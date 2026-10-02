#include "Database/DatabaseEnv.h"
#include "Log.h"
#include "Policies/SingletonImp.h"
#include "Item.h"
#include "AuctionHouseMgr.h"
#include "ObjectMgr.h"
#include "AuctionHouseBotMgr.h"
#include "Config/Config.h"
#include "Chat.h"
#include "Utilities/Random.h"

#include <algorithm>
#include <unordered_map>

INSTANTIATE_SINGLETON_1(AuctionHouseBotMgr);

AuctionHouseBotMgr::~AuctionHouseBotMgr()
{
    m_items.clear();

    if (m_config)
        m_config.reset();
}

void AuctionHouseBotMgr::Load()
{
    /* 1 - DELETE */
    m_items.clear();
    m_loaded = false;

    if (m_config)
        m_config.reset();

    /*2 - LOAD */
    std::unique_ptr<QueryResult> result(WorldDatabase.Query("SELECT `item`, `stack`, `bid`, `buyout`, `count` FROM `auctionhousebot`"));

    if (!result)
    {
        BarGoLink bar(1);
        bar.step();

        sLog.Out(LOG_BASIC, LOG_LVL_MINIMAL, "");
        sLog.Out(LOG_BASIC, LOG_LVL_MINIMAL, ">> Loaded 0 AuctionHouseBot items");
        return;
    }

    uint32 count = 0;
    BarGoLink bar(result->GetRowCount());

    Field* fields;
    do
    {
        bar.step();
        AuctionHouseBotEntry e;
        fields    = result->Fetch();
        e.item    = fields[0].GetUInt32();
        e.stack   = fields[1].GetUInt32();
        e.bid     = fields[2].GetUInt32();
        e.buyout  = fields[3].GetUInt32();
        e.count   = fields[4].GetUInt32();

        m_items.push_back(e);

        ++count;
    }
    while (result->NextRow());

    sLog.Out(LOG_BASIC, LOG_LVL_MINIMAL, "");
    sLog.Out(LOG_BASIC, LOG_LVL_MINIMAL, ">> Loaded %u AuctionHouseBot items", count);

    /* CONFIG */
    m_config                 = std::make_unique<AuctionHouseBotConfig>();
    m_config->enable         = sConfig.GetBoolDefault("AHBot.Enable", false);
    m_config->ahfid          = sConfig.GetIntDefault("AHBot.ah.fid", 120);
    m_config->itemcount      = sConfig.GetIntDefault("AHBot.itemcount", 0);
    m_config->defaultItemCount = sConfig.GetIntDefault("AHBot.DefaultItemCount", 1);
    m_config->maxAddsPerTick = sConfig.GetIntDefault("AHBot.MaxAddsPerTick", 50);

    m_auctionHouseEntry = sAuctionMgr.GetAuctionHouseEntry(m_config->ahfid);
    if (!m_auctionHouseEntry)
    {
        sLog.Out(LOG_BASIC, LOG_LVL_MINIMAL, "AHBot::Load() : No auction house for faction %u.", m_config->ahfid);
        return;
    }
    m_loaded = true;
}

void AuctionHouseBotMgr::Update(bool force /* = false */)
{
    if (!m_loaded)
        return;

    ASSERT(m_config);
    ASSERT(m_auctionHouseEntry);

    if (!(m_config->enable || force))
        return;

    if (m_items.empty())
    {
        sLog.Out(LOG_BASIC, LOG_LVL_ERROR, "AHBot::Update() : Bad config or empty table.");
        return;
    }

    AuctionHouseObject* auctionHouse = sAuctionMgr.GetAuctionsMap(m_auctionHouseEntry);
    if (!auctionHouse)
    {
        sLog.Out(LOG_BASIC, LOG_LVL_ERROR, "AHBot::Update() : No auction house for faction %u.", m_config->ahfid);
        return;
    }

    // Current stock per item template. Player listings are counted on purpose:
    // the bot only fills the gap up to the configured target, it never overstocks.
    std::unordered_map<uint32, uint32> stock;
    for (auto const& itr : *auctionHouse->GetAuctions())
        ++stock[itr.second->itemTemplate];

    uint32 total     = auctionHouse->GetCount();
    uint32 globalCap = m_config->itemcount;                     // 0 = no cap
    uint32 addLimit  = force ? 0 : m_config->maxAddsPerTick;    // 0 = no cap
    uint32 added     = 0;
    bool   stop      = false;
    bool   capped    = false;

    for (AuctionHouseBotEntry const& e : m_items)
    {
        if (stop)
            break;

        uint32 target = e.count ? e.count : m_config->defaultItemCount;
        if (!target)
            continue;

        for (uint32 have = stock[e.item]; have < target; ++have)
        {
            if (globalCap && total >= globalCap)
            {
                stop = true;
                capped = true;
                break;
            }

            if (addLimit && added >= addLimit)
            {
                stop = true;
                break;
            }

            // Do not retry a bad entry `target` times, just skip it for this pass.
            if (!AddItem(e, auctionHouse))
                break;

            ++stock[e.item];
            ++total;
            ++added;
        }
    }

    if (added)
        sLog.Out(LOG_BASIC, LOG_LVL_DEBUG, "AHBot::Update() : Added %u listing(s), auction house now holds %u.", added, total);

    if (capped)
        sLog.Out(LOG_BASIC, LOG_LVL_MINIMAL, "AHBot::Update() : Global cap AHBot.itemcount=%u reached, some items are below their target stock.", globalCap);
}

bool AuctionHouseBotMgr::AddItem(AuctionHouseBotEntry e, AuctionHouseObject *auctionHouse)
{
    ASSERT(m_auctionHouseEntry);

    ItemPrototype const* prototype = sObjectMgr.GetItemPrototype(e.item);
    if (prototype == nullptr)
    {
        sLog.Out(LOG_BASIC, LOG_LVL_MINIMAL, "AHBot::AddItem() : Item %u does not exist.", e.item);
        return false;
    }

    Item* item = Item::CreateItem(e.item, 1);
    if (!item)
    {
        sLog.Out(LOG_BASIC, LOG_LVL_MINIMAL, "AHBot::AddItem() : Cannot create item %u.", e.item);
        return false;
    }

    // Never exceed the item's own stack limit, otherwise the listing is invalid.
    uint32 stack = std::min<uint32>(e.stack, prototype->GetMaxStackSize());
    if (stack == 0)
        stack = 1;

    sLog.Out(LOG_BASIC, LOG_LVL_DEBUG, "AHBot::AddItem() : Adding item %u x%u.", e.item, stack);

    uint32 randomPropertyId = Item::GenerateItemRandomPropertyId(e.item);
    if (randomPropertyId != 0)
        item->SetItemRandomProperties(randomPropertyId);

    uint32 etime = urand(1, 3);
    switch (etime)
    {
        case 1:
            etime = 43200;
            break;
        case 2:
            etime = 86400;
            break;
        case 3:
            etime = 172800;
            break;
        default:
            etime = 86400;
            break;
    }
    item->SetCount(stack);

    uint32 dep = sAuctionMgr.GetAuctionDeposit(m_auctionHouseEntry, etime, item);

    AuctionEntry* auctionEntry       = new AuctionEntry;
    auctionEntry->Id                 = sObjectMgr.GenerateAuctionID();
    auctionEntry->auctionHouseEntry  = m_auctionHouseEntry;
    auctionEntry->itemGuidLow        = item->GetGUIDLow();
    auctionEntry->itemTemplate       = item->GetEntry();
    auctionEntry->owner              = 0;
    auctionEntry->startbid           = e.bid;
    auctionEntry->buyout             = e.buyout;
    auctionEntry->bidder             = 0;
    auctionEntry->bid                = 0;
    auctionEntry->deposit            = dep;
    auctionEntry->depositTime        = time(nullptr);
    auctionEntry->expireTime         = (time_t) etime + time(nullptr);

    item->SaveToDB();

    sAuctionMgr.AddAItem(item);
    auctionHouse->AddAuction(auctionEntry);
    auctionEntry->SaveToDB();
    return true;
}

bool ChatHandler::HandleAHBotUpdateCommand(char *args)
{
    sAuctionHouseBotMgr.Update(true);
    SendSysMessage("[AHBot] Update finished.");
    return true;
}

bool ChatHandler::HandleAHBotReloadCommand(char *args)
{
    sAuctionHouseBotMgr.Load();
    SendSysMessage("[AHBot] Reload finished.");
    return true;
}
