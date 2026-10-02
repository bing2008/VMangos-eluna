# PlayerBot 「同账号个人队伍」更新说明

日期：2026-10-02
模块：PlayerBots（PartyBot / BattleBot）
是否需要数据库迁移：否
是否需要重新编译：是（game + mangosd）

---

## 一、更新概述

新增「个人队伍」模式：一个玩家可以在主号在线的情况下，把自己同一账号下的
小号当作 PartyBot 拉进队伍，组队一起打怪、升级。

更新后可以一条命令召唤整队：

```
.partybot load 小号1 小号2 小号3 小号4
```

机器人会自动加入队伍、跟随队长、按职业自动分配定位（坦克 / 治疗 / 输出）并传送到
队长身边。下线或移除后，小号的角色数据正常保存在原账号下，之后可以照常登录。

---

## 二、更新前的问题

原版 PlayerBots 的设计前提是「被加载成机器人的角色，其账号当前必须离线」：

- `.partybot load` / `.bot add` 会取角色的**真实账号**；
- 若该账号已有会话（也就是主号正登录着），直接拒绝并报
  `[PlayerBotMgr] Account %u is already online!`；
- 因此同账号小号无法作为机器人加载，唯一变通办法是给小号单独开一个账号。

此外，机器人会话使用的是「合成账号」，而角色存档会把会话账号写回
`characters.account`，会导致小号脱离原账号（选人界面看不到）。

---

## 三、本次改动内容

### 1. 支持同账号小号作为机器人

- 目标账号已在线时，机器人会话改用**合成账号**，与主号会话共存；
- 同时在机器人条目上记录角色**真实账号**；
- 存档与玩家缓存统一写入真实账号，小号不会被重新绑定。

### 2. 一条命令召唤整队

- `.partybot load` 支持一次传入多个角色名；
- 按「队伍人数 + 正在加载中的机器人」累计判断容量，避免异步入队时超出 5 人上限；
- 重复名字、已在线或已加载的角色会被跳过并提示，不会重复加载。

### 3. 开放给普通玩家（可配置）

- `PartyBot.OwnAccountTeam = 1` 时，普通玩家可加载**自己账号**的角色；
- 管理员不受限制，仍可加载任意离线角色；
- `.partybot remove` 对普通玩家开放，但只能移除自己队伍中的机器人；
- `.partybot add` / `.partybot clone` 权限与行为保持不变（仍为管理员命令）。

---

## 四、配置项

| 配置 | 默认值 | 说明 |
| --- | --- | --- |
| `PlayerBot.AllowSaving` | `0` | 必须设为 `1`，否则机器人角色的经验 / 等级 / 物品不会保存 |
| `PartyBot.OwnAccountTeam` | `0` | 设为 `1` 开启个人队伍模式（普通玩家可加载自己账号的角色） |
| `PartyBot.MaxBots` | `0` | 每个玩家可带的机器人上限，`0` 表示不额外限制（仍受 5 人队伍上限约束） |
| `PartyBot.SkipChecks` | `0` | 设为 `1` 可放开「副本内 / 战斗中 / 死亡时不能加载」等限制 |

本次已在运行配置 `_avperf/mangosd.conf` 中启用：

```ini
PlayerBot.AllowSaving = 1
PartyBot.OwnAccountTeam = 1
```

> 使用其他配置文件部署时，请把上面两行加入对应的 `mangosd.conf`。

---

## 五、使用说明

1. 用小号所在的账号登录主号；
2. 确认小号当前未登录；
3. 输入命令（最多 4 个，队伍总人数上限 5）：

   ```
   .partybot load 小号1 小号2 小号3 小号4
   ```

4. 机器人会自动入队并跟随；
5. 解散时选中对应机器人执行：

   ```
   .partybot remove
   ```

6. 需要自己操控小号时，先移除对应机器人，再正常登录该角色。

注意事项：

- 小号作为机器人期间处于在线状态，不能同时从选人界面登录；
- 主号下线时，机器人检测不到队长会自动退出，不会残留在线；
- 每次上线需要重新执行一次召唤命令（不保存队伍组合）。

---

## 六、技术实现要点

| 文件 | 改动 |
| --- | --- |
| `src/game/PlayerBots/PlayerBotMgr.h` | `PlayerBotEntry` 新增 `realAccountId`；`AddBot` 新增 `allowAccountOnline`；新增 `GetPendingPartyBotCount`、`IsBotActive` |
| `src/game/PlayerBots/PlayerBotMgr.cpp` | 账号在线时改用合成会话账号；`.partybot load` 支持多名角色并做组队容量校验；`.partybot remove` 增加权限校验 |
| `src/game/Server/WorldSession.h/.cpp` | 新增 `GetCharacterAccountId()`：机器人返回角色真实账号，普通会话返回自身账号 |
| `src/game/Objects/Player.cpp` | `SaveToDB` 写回真实账号，避免小号被重新绑定 |
| `src/game/ObjectMgr.cpp` | 玩家缓存同步使用真实账号 |
| `src/game/World.h/.cpp` | 新增配置 `PartyBot.OwnAccountTeam` |
| `src/game/Chat/Chat.cpp` | `.partybot load` / `.partybot remove` 调整为 `SEC_PLAYER` |
| `src/mangosd/mangosd.conf.dist.in` | 新增配置项说明与默认值 |

关键链路：`AddBot` 判定账号冲突 → 分配合成账号并记录真实账号 →
`LoginPlayer` 加载角色（`Player::LoadFromDB` 对机器人跳过账号校验）→
`PartyBotAI` 入队 / 跟随 / 自动定位 → 存档时 `SaveToDB` 写回真实账号。

---

## 七、验证情况

- 使用 Visual Studio 2022 (BuildTools/Community) 重新编译 `game` 与 `mangosd` 均通过；
- 无新增编译错误，仅存在仓库原有的编码 / 枚举相关警告；
- 构建产物：`Eluna-VMaNGOS/bin/Release/mangosd.exe`。

---

## 八、兼容性说明

- 不需要数据库迁移，`playerbot` 表结构不变；
- 老存档不需要处理，角色账号字段在保存时会写回原账号；
- `.partybot add` / `.partybot clone` 生成的临时机器人与原来一致（仍为临时角色，不落库）；
- 关闭 `PartyBot.OwnAccountTeam` 即恢复原有的管理员专用行为。
