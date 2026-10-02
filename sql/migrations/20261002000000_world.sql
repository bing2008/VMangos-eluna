DROP PROCEDURE IF EXISTS add_migration;
DELIMITER ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20261002000000');
IF v = 0 THEN
INSERT INTO `migrations` VALUES ('20261002000000');
-- Add your query below.


-- AuctionHouseBot: per-item target stock for stock-based replenishment.
-- 1 means "keep one listing of this item in the auction house"; 0 falls back to AHBot.DefaultItemCount.
ALTER TABLE `auctionhousebot`
	ADD COLUMN `count` TINYINT(3) UNSIGNED NOT NULL DEFAULT '1' COMMENT 'Target number of listings to keep in the auction house (0 = use AHBot.DefaultItemCount)' AFTER `item`;


-- End of migration.
END IF;
END??
DELIMITER ;
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
