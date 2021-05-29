DROP PROCEDURE IF EXISTS add_migration;
delimiter ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20210529220751');
IF v=0 THEN
INSERT INTO `migrations` VALUES ('20210529220751');
-- Add your query below.


-- Correct inhabit type and flags for Belfry Bat.
UPDATE `creature_template` SET `inhabit_type`=4, `unit_flags`=33555200, `flags_extra`=33555202 WHERE `entry`=10716;

-- Add bats that spawn every hour in Brill.
INSERT INTO `creature` (`guid`, `id`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecsmin`, `spawntimesecsmax`, `movement_type`, `wander_distance`) VALUES 
(8493, 10716, 0, 2291.84, 292.171, 81.5713, 2.86234, 60, 60, 2, 0), -- 1385
(8494, 10716, 0, 2290.52, 287.5, 81.4823, 2.72271, 60, 60, 2, 0), -- 1386
(8495, 10716, 0, 2293.2, 296.473, 81.7742, 2.75762, 60, 60, 2, 0), -- 1387
(8496, 10716, 0, 2295.22, 281.972, 81.7218, 3.97935, 60, 60, 2, 0), -- 1388
(8497, 10716, 0, 2299.58, 280.706, 81.6103, 4.29351, 60, 60, 2, 0), -- 1389
(8498, 10716, 0, 2303.57, 279.754, 81.6749, 4.74729, 60, 60, 2, 0), -- 1390
(8499, 10716, 0, 2309.1, 282.281, 81.0983, 6.05629, 60, 60, 2, 0), -- 1391
(8500, 10716, 0, 2309.64, 287.967, 81.852, 5.91667, 60, 60, 2, 0), -- 1392
(8501, 10716, 0, 2311.46, 292.325, 81.2885, 0.383972, 60, 60, 2, 0), -- 1393
(8502, 10716, 0, 2308.97, 297.232, 81.7615, 1.22173, 60, 60, 2, 0), -- 1394
(8503, 10716, 0, 2303.29, 298.127, 82.2253, 1.22173, 60, 60, 2, 0), -- 1395
(8504, 10716, 0, 2298.5, 299.817, 81.8604, 0.977384, 60, 60, 2, 0); -- 1396
-- Add Belfry Bat spawns to Hourly Bells event.
INSERT INTO `game_event_creature` (`guid`, `event`) VALUES
(8493, 78),
(8494, 78),
(8495, 78),
(8496, 78),
(8497, 78),
(8498, 78),
(8499, 78),
(8500, 78),
(8501, 78),
(8502, 78),
(8503, 78),
(8504, 78);

-- Add waypoints for Belfry Bat (Guid: 8493).
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `waittime`, `wander_distance`, `script_id`) VALUES
(8493, 1, 2264.929932, 300.329987, 76.030296, 100.000000, 0, 0.000000, 849301), -- spline 0/11
(8493, 2, 2245.699951, 321.632996, 59.558102, 100.000000, 0, 0.000000, 0), -- spline 1/11
(8493, 3, 2227.820068, 320.307007, 60.324600, 100.000000, 0, 0.000000, 0), -- spline 2/11
(8493, 4, 2208.379883, 340.748993, 60.324600, 100.000000, 0, 0.000000, 0), -- spline 3/11
(8493, 5, 2184.139893, 372.239990, 60.324600, 100.000000, 0, 0.000000, 0), -- spline 4/11
(8493, 6, 2180.270020, 386.799988, 60.324600, 100.000000, 0, 0.000000, 0), -- spline 5/11
(8493, 7, 2163.419922, 392.268005, 60.324600, 100.000000, 0, 0.000000, 0), -- spline 6/11
(8493, 8, 2119.560059, 369.352997, 60.324600, 100.000000, 0, 0.000000, 0), -- spline 7/11
(8493, 9, 2096.479980, 331.221985, 69.324600, 100.000000, 0, 0.000000, 0), -- spline 8/11
(8493, 10, 2081.800049, 305.434998, 80.074600, 100.000000, 0, 0.000000, 0), -- spline 9/11
(8493, 11, 2062.149902, 278.320007, 75.241302, 100.000000, 0, 0.000000, 0), -- spline 10/11
(8493, 12, 2058.270020, 272.925995, 68.741302, 100.000000, 60000, 0.000000, 0); -- spline 11/11
DELETE FROM `creature_movement_scripts` WHERE `id`=849301;
INSERT INTO `creature_movement_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `target_param1`, `target_param2`, `target_type`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `condition_id`, `comments`) VALUES (849301, 0, 16, 6596, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Belfry Bat - Play Sound');

-- Add waypoints for Belfry Bat (Guid: 8494).
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `waittime`, `wander_distance`, `script_id`) VALUES
(8494, 1, 2266.399902, 299.696014, 76.504501, 100.000000, 0, 0.000000, 0), -- spline 0/10
(8494, 2, 2249.469971, 319.334991, 66.504501, 100.000000, 0, 0.000000, 0), -- spline 1/10
(8494, 3, 2225.669922, 327.811005, 58.365601, 100.000000, 0, 0.000000, 0), -- spline 2/10
(8494, 4, 2212.790039, 354.635986, 58.365601, 100.000000, 0, 0.000000, 0), -- spline 3/10
(8494, 5, 2188.070068, 387.682007, 58.365601, 100.000000, 0, 0.000000, 0), -- spline 4/10
(8494, 6, 2152.820068, 398.834991, 58.365601, 100.000000, 0, 0.000000, 0), -- spline 5/10
(8494, 7, 2108.860107, 381.304993, 58.365601, 100.000000, 0, 0.000000, 0), -- spline 6/10
(8494, 8, 2094.750000, 337.619995, 67.171204, 100.000000, 0, 0.000000, 0), -- spline 7/10
(8494, 9, 2085.129883, 303.131989, 80.587898, 100.000000, 0, 0.000000, 0), -- spline 8/10
(8494, 10, 2064.189941, 284.048004, 78.858200, 100.000000, 0, 0.000000, 0), -- spline 9/10
(8494, 11, 2058.659912, 276.401001, 68.552597, 100.000000, 60000, 0.000000, 0); -- spline 10/10

-- Add waypoints for Belfry Bat (Guid: 8495).
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `waittime`, `wander_distance`, `script_id`) VALUES
(8495, 1, 2266.489990, 305.485992, 75.808197, 100.000000, 0, 0.000000, 0), -- spline 0/10
(8495, 2, 2255.949951, 330.838989, 63.058201, 100.000000, 0, 0.000000, 0), -- spline 1/10
(8495, 3, 2226.149902, 362.273987, 47.752602, 100.000000, 0, 0.000000, 0), -- spline 2/10
(8495, 4, 2196.439941, 396.825989, 55.349800, 100.000000, 0, 0.000000, 0), -- spline 3/10
(8495, 5, 2166.129883, 402.358002, 72.002403, 100.000000, 0, 0.000000, 0), -- spline 4/10
(8495, 6, 2135.909912, 391.731995, 72.002403, 100.000000, 0, 0.000000, 0), -- spline 5/10
(8495, 7, 2111.649902, 352.752014, 76.335800, 100.000000, 0, 0.000000, 0), -- spline 6/10
(8495, 8, 2094.030029, 313.950989, 82.502403, 100.000000, 0, 0.000000, 0), -- spline 7/10
(8495, 9, 2086.229980, 297.226990, 79.280197, 100.000000, 0, 0.000000, 0), -- spline 8/10
(8495, 10, 2061.229980, 304.009003, 79.280197, 100.000000, 0, 0.000000, 0), -- spline 9/10
(8495, 11, 2059.000000, 280.492004, 68.085800, 100.000000, 60000, 0.000000, 0); -- spline 10/10

-- Add waypoints for Belfry Bat (Guid: 8496).
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `waittime`, `wander_distance`, `script_id`) VALUES
(8496, 1, 2271.699951, 260.510010, 79.634598, 100.000000, 0, 0.000000, 0), -- spline 0/9
(8496, 2, 2245.729980, 241.697006, 71.995697, 100.000000, 0, 0.000000, 0), -- spline 1/9
(8496, 3, 2199.070068, 250.287003, 61.079102, 100.000000, 0, 0.000000, 0), -- spline 2/9
(8496, 4, 2165.340088, 277.854004, 85.106796, 100.000000, 0, 0.000000, 0), -- spline 3/9
(8496, 5, 2157.689941, 323.028015, 71.995697, 100.000000, 0, 0.000000, 0), -- spline 4/9
(8496, 6, 2129.300049, 359.356995, 71.995697, 100.000000, 0, 0.000000, 0), -- spline 5/9
(8496, 7, 2112.340088, 354.092987, 71.995697, 100.000000, 0, 0.000000, 0), -- spline 6/9
(8496, 8, 2099.340088, 318.188995, 77.384598, 100.000000, 0, 0.000000, 0), -- spline 7/9
(8496, 9, 2055.800049, 296.967010, 79.276100, 100.000000, 0, 0.000000, 0), -- spline 8/9
(8496, 10, 2060.520020, 284.787994, 68.498299, 100.000000, 60000, 0.000000, 0); -- spline 9/9

-- Add waypoints for Belfry Bat (Guid: 8497).
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `waittime`, `wander_distance`, `script_id`) VALUES
(8497, 1, 2285.689941, 255.447006, 78.652901, 100.000000, 0, 0.000000, 0), -- spline 0/12
(8497, 2, 2263.810059, 220.705002, 50.069500, 100.000000, 0, 0.000000, 0), -- spline 1/12
(8497, 3, 2240.590088, 205.897995, 41.402802, 100.000000, 0, 0.000000, 0), -- spline 2/12
(8497, 4, 2203.679932, 208.694000, 50.315102, 100.000000, 0, 0.000000, 0), -- spline 3/12
(8497, 5, 2184.360107, 226.690994, 43.870602, 100.000000, 0, 0.000000, 0), -- spline 4/12
(8497, 6, 2176.790039, 270.209991, 49.703999, 100.000000, 0, 0.000000, 0), -- spline 5/12
(8497, 7, 2163.310059, 304.420990, 69.681000, 100.000000, 0, 0.000000, 0), -- spline 6/12
(8497, 8, 2148.449951, 319.838989, 69.681000, 100.000000, 0, 0.000000, 0), -- spline 7/12
(8497, 9, 2125.100098, 328.727997, 69.681000, 100.000000, 0, 0.000000, 0), -- spline 8/12
(8497, 10, 2114.310059, 318.783997, 74.264397, 100.000000, 0, 0.000000, 0), -- spline 9/12
(8497, 11, 2092.639893, 301.253998, 78.403297, 100.000000, 0, 0.000000, 0), -- spline 10/12
(8497, 12, 2059.010010, 299.459991, 79.209198, 100.000000, 0, 0.000000, 0), -- spline 11/12
(8497, 13, 2061.620117, 288.808990, 68.431396, 100.000000, 60000, 0.000000, 0); -- spline 12/12

-- Add waypoints for Belfry Bat (Guid: 8498).
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `waittime`, `wander_distance`, `script_id`) VALUES
(8498, 1, 2311.110107, 239.684006, 76.978600, 100.000000, 0, 0.000000, 0), -- spline 0/13
(8498, 2, 2292.060059, 209.531998, 51.839699, 100.000000, 0, 0.000000, 0), -- spline 1/13
(8498, 3, 2257.199951, 197.623993, 39.311901, 100.000000, 0, 0.000000, 0), -- spline 2/13
(8498, 4, 2216.389893, 194.893997, 48.751301, 100.000000, 0, 0.000000, 0), -- spline 3/13
(8498, 5, 2199.179932, 184.031998, 54.005199, 100.000000, 0, 0.000000, 0), -- spline 4/13
(8498, 6, 2191.929932, 184.959000, 54.005199, 100.000000, 0, 0.000000, 0), -- spline 5/13
(8498, 7, 2184.520020, 193.207001, 54.005199, 100.000000, 0, 0.000000, 0), -- spline 6/13
(8498, 8, 2162.159912, 233.373993, 54.005199, 100.000000, 0, 0.000000, 0), -- spline 7/13
(8498, 9, 2159.820068, 282.661987, 63.810699, 100.000000, 0, 0.000000, 0), -- spline 8/13
(8498, 10, 2134.770020, 300.579987, 79.866302, 100.000000, 0, 0.000000, 0), -- spline 9/13
(8498, 11, 2110.280029, 296.656006, 79.755302, 100.000000, 0, 0.000000, 0), -- spline 10/13
(8498, 12, 2083.850098, 304.947998, 79.560799, 100.000000, 0, 0.000000, 0), -- spline 11/13
(8498, 13, 2063.929932, 307.476013, 79.560799, 100.000000, 0, 0.000000, 0), -- spline 12/13
(8498, 14, 2063.409912, 290.584991, 70.671799, 100.000000, 60000, 0.000000, 0); -- spline 13/13

-- Add waypoints for Belfry Bat (Guid: 8499).
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `waittime`, `wander_distance`, `script_id`) VALUES
(8499, 1, 2338.199951, 263.053986, 76.536903, 100.000000, 0, 0.000000, 0), -- spline 0/8
(8499, 2, 2344.889893, 261.101013, 66.342400, 100.000000, 0, 0.000000, 0), -- spline 1/8
(8499, 3, 2361.709961, 242.326004, 52.675701, 100.000000, 0, 0.000000, 0), -- spline 2/8
(8499, 4, 2349.909912, 220.966995, 47.870201, 100.000000, 0, 0.000000, 0), -- spline 3/8
(8499, 5, 2323.969971, 238.057007, 45.064602, 100.000000, 0, 0.000000, 0), -- spline 4/8
(8499, 6, 2290.469971, 258.101990, 43.092400, 100.000000, 0, 0.000000, 0), -- spline 5/8
(8499, 7, 2247.540039, 281.933014, 43.092400, 100.000000, 0, 0.000000, 0), -- spline 6/8
(8499, 8, 2212.919922, 296.894989, 45.647999, 100.000000, 0, 0.000000, 0), -- spline 7/8
(8499, 9, 2181.479980, 318.591003, 46.897999, 100.000000, 0, 0.000000, 0), -- spline 8/8
(8499, 10, 2144.870117, 327.882996, 71.922401, 100.000000, 0, 0.000000, 849910), -- spline 0/3
(8499, 11, 2110.179932, 313.437988, 88.172501, 100.000000, 0, 0.000000, 0), -- spline 1/3
(8499, 12, 2101.520020, 321.703003, 79.090698, 100.000000, 0, 0.000000, 0), -- spline 2/3
(8499, 13, 2071.030029, 289.042999, 70.729599, 100.000000, 60000, 0.000000, 0); -- spline 3/3
DELETE FROM `creature_movement_scripts` WHERE `id`=849910;
INSERT INTO `creature_movement_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `target_param1`, `target_param2`, `target_type`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `condition_id`, `comments`) VALUES (849910, 0, 16, 6596, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Belfry Bat - Play Sound');

-- Add waypoints for Belfry Bat (Guid: 8500).
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `waittime`, `wander_distance`, `script_id`) VALUES
(8500, 1, 2335.419922, 270.260986, 79.447502, 100.000000, 0, 0.000000, 0), -- spline 0/13
(8500, 2, 2342.520020, 265.394989, 79.447502, 100.000000, 0, 0.000000, 0), -- spline 1/13
(8500, 3, 2341.580078, 253.927002, 79.447502, 100.000000, 0, 0.000000, 0), -- spline 2/13
(8500, 4, 2324.810059, 240.490997, 79.447502, 100.000000, 0, 0.000000, 0), -- spline 3/13
(8500, 5, 2297.620117, 255.063995, 79.447502, 100.000000, 0, 0.000000, 0), -- spline 4/13
(8500, 6, 2268.709961, 283.138000, 62.280800, 100.000000, 0, 0.000000, 0), -- spline 5/13
(8500, 7, 2252.810059, 312.338989, 49.864101, 100.000000, 0, 0.000000, 0), -- spline 6/13
(8500, 8, 2242.409912, 346.750000, 43.141899, 100.000000, 0, 0.000000, 0), -- spline 7/13
(8500, 9, 2206.449951, 368.545990, 45.614101, 100.000000, 0, 0.000000, 0), -- spline 8/13
(8500, 10, 2166.879883, 368.070007, 71.656403, 100.000000, 0, 0.000000, 0), -- spline 9/13
(8500, 11, 2125.270020, 340.610992, 76.989700, 100.000000, 0, 0.000000, 0), -- spline 10/13
(8500, 12, 2103.600098, 308.622009, 80.017502, 100.000000, 0, 0.000000, 0), -- spline 11/13
(8500, 13, 2085.139893, 299.303986, 79.350800, 100.000000, 0, 0.000000, 0), -- spline 12/13
(8500, 14, 2073.129883, 286.395996, 68.628601, 100.000000, 60000, 0.000000, 0); -- spline 13/13

-- Add waypoints for Belfry Bat (Guid: 8501).
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `waittime`, `wander_distance`, `script_id`) VALUES
(8501, 1, 2341.199951, 315.338989, 92.903099, 100.000000, 0, 0.000000, 0), -- spline 0/13
(8501, 2, 2346.010010, 334.989014, 92.903099, 100.000000, 0, 0.000000, 0), -- spline 1/13
(8501, 3, 2332.449951, 368.037994, 64.153000, 100.000000, 0, 0.000000, 0), -- spline 2/13
(8501, 4, 2295.639893, 383.843994, 48.264000, 100.000000, 0, 0.000000, 0), -- spline 3/13
(8501, 5, 2263.879883, 364.484985, 44.791801, 100.000000, 0, 0.000000, 0), -- spline 4/13
(8501, 6, 2244.020020, 354.554993, 41.930599, 100.000000, 0, 0.000000, 0), -- spline 5/13
(8501, 7, 2227.370117, 352.993988, 41.930599, 100.000000, 0, 0.000000, 0), -- spline 6/13
(8501, 8, 2219.439941, 372.144012, 49.652802, 100.000000, 0, 0.000000, 0), -- spline 7/13
(8501, 9, 2178.169922, 360.458008, 63.541698, 100.000000, 0, 0.000000, 0), -- spline 8/13
(8501, 10, 2142.389893, 329.195007, 78.597298, 100.000000, 0, 0.000000, 0), -- spline 9/13
(8501, 11, 2103.120117, 304.903992, 80.958397, 100.000000, 0, 0.000000, 0), -- spline 10/13
(8501, 12, 2102.169922, 281.625000, 79.625099, 100.000000, 0, 0.000000, 0), -- spline 11/13
(8501, 13, 2087.820068, 280.266998, 72.486198, 100.000000, 0, 0.000000, 0), -- spline 12/13
(8501, 14, 2073.350098, 281.459015, 68.402802, 100.000000, 60000, 0.000000, 0); -- spline 13/13

-- Add waypoints for Belfry Bat (Guid: 8502).
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `waittime`, `wander_distance`, `script_id`) VALUES
(8502, 1, 2317.389893, 324.369995, 87.687500, 100.000000, 0, 0.000000, 0), -- spline 0/10
(8502, 2, 2319.510010, 352.401001, 98.159698, 100.000000, 0, 0.000000, 0), -- spline 1/10
(8502, 3, 2314.949951, 369.937988, 89.298599, 100.000000, 0, 0.000000, 0), -- spline 2/10
(8502, 4, 2298.729980, 382.324005, 78.242996, 100.000000, 0, 0.000000, 0), -- spline 3/10
(8502, 5, 2255.229980, 406.108002, 74.326302, 100.000000, 0, 0.000000, 0), -- spline 4/10
(8502, 6, 2213.989990, 403.273987, 68.409698, 100.000000, 0, 0.000000, 0), -- spline 5/10
(8502, 7, 2180.020020, 376.944000, 72.020798, 100.000000, 0, 0.000000, 0), -- spline 6/10
(8502, 8, 2145.969971, 346.626007, 91.992996, 100.000000, 0, 0.000000, 0), -- spline 7/10
(8502, 9, 2106.560059, 315.518005, 93.631897, 100.000000, 0, 0.000000, 0), -- spline 8/10
(8502, 10, 2088.439941, 276.399994, 79.492996, 100.000000, 0, 0.000000, 0), -- spline 9/10
(8502, 11, 2070.790039, 277.661011, 68.381897, 100.000000, 60000, 0.000000, 0); -- spline 10/10

-- Add waypoints for Belfry Bat (Guid: 8503).
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `waittime`, `wander_distance`, `script_id`) VALUES
(8503, 1, 2320.830078, 333.566986, 84.623398, 100.000000, 0, 0.000000, 0), -- spline 0/16
(8503, 2, 2337.030029, 353.589996, 84.623398, 100.000000, 0, 0.000000, 0), -- spline 1/16
(8503, 3, 2342.090088, 369.609985, 70.484497, 100.000000, 0, 0.000000, 0), -- spline 2/16
(8503, 4, 2318.000000, 392.368011, 60.067799, 100.000000, 0, 0.000000, 0), -- spline 3/16
(8503, 5, 2288.770020, 379.468994, 44.845600, 100.000000, 0, 0.000000, 0), -- spline 4/16
(8503, 6, 2275.840088, 340.661011, 41.706699, 100.000000, 0, 0.000000, 0), -- spline 5/16
(8503, 7, 2259.179932, 303.696014, 40.373402, 100.000000, 0, 0.000000, 0), -- spline 6/16
(8503, 8, 2235.239990, 273.893005, 47.317799, 100.000000, 0, 0.000000, 0), -- spline 7/16
(8503, 9, 2202.870117, 260.562012, 59.873299, 100.000000, 0, 0.000000, 0), -- spline 8/16
(8503, 10, 2160.820068, 255.893005, 84.623398, 100.000000, 0, 0.000000, 0), -- spline 9/16
(8503, 11, 2128.030029, 276.407990, 78.512299, 100.000000, 0, 0.000000, 0), -- spline 10/16
(8503, 12, 2138.469971, 298.958008, 84.623398, 100.000000, 0, 0.000000, 0), -- spline 11/16
(8503, 13, 2128.320068, 327.652008, 101.651001, 100.000000, 0, 0.000000, 0), -- spline 12/16
(8503, 14, 2114.159912, 327.721008, 98.567902, 100.000000, 0, 0.000000, 0), -- spline 13/16
(8503, 15, 2101.719971, 303.272003, 90.040100, 100.000000, 0, 0.000000, 0), -- spline 14/16
(8503, 16, 2079.030029, 302.569000, 79.456703, 100.000000, 0, 0.000000, 0), -- spline 15/16
(8503, 17, 2070.139893, 274.324005, 68.484497, 100.000000, 60000, 0.000000, 0); -- spline 16/16

-- Add waypoints for Belfry Bat (Guid: 8504).
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `waittime`, `wander_distance`, `script_id`) VALUES
(8504, 1, 2318.800049, 334.148987, 78.170601, 100.000000, 0, 0.000000, 0), -- spline 0/14
(8504, 2, 2342.189941, 358.182007, 78.170601, 100.000000, 0, 0.000000, 0), -- spline 1/14
(8504, 3, 2343.439941, 401.080994, 87.615097, 100.000000, 0, 0.000000, 0), -- spline 2/14
(8504, 4, 2322.850098, 445.485992, 78.170601, 100.000000, 0, 0.000000, 0), -- spline 3/14
(8504, 5, 2296.310059, 453.006989, 72.281700, 100.000000, 0, 0.000000, 0), -- spline 4/14
(8504, 6, 2266.729980, 428.024994, 60.309502, 100.000000, 0, 0.000000, 0), -- spline 5/14
(8504, 7, 2232.300049, 413.587006, 73.726196, 100.000000, 0, 0.000000, 0), -- spline 6/14
(8504, 8, 2188.090088, 402.131989, 86.976196, 100.000000, 0, 0.000000, 0), -- spline 7/14
(8504, 9, 2141.080078, 394.648987, 71.726097, 100.000000, 0, 0.000000, 0), -- spline 8/14
(8504, 10, 2118.989990, 353.406006, 78.170601, 100.000000, 0, 0.000000, 0), -- spline 9/14
(8504, 11, 2107.399902, 322.726990, 87.392799, 100.000000, 0, 0.000000, 0), -- spline 10/14
(8504, 12, 2083.290039, 311.605011, 81.753899, 100.000000, 0, 0.000000, 0), -- spline 11/14
(8504, 13, 2065.270020, 304.687988, 75.281700, 100.000000, 0, 0.000000, 0), -- spline 12/14
(8504, 14, 2062.120117, 283.634003, 75.281700, 100.000000, 0, 0.000000, 0), -- spline 13/14
(8504, 15, 2069.189941, 269.863007, 68.976097, 100.000000, 60000, 0.000000, 0); -- spline 14/14


-- End of migration.
END IF;
END??
delimiter ; 
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
