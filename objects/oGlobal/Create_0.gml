if (instance_number(oGlobal) > 1) {
    instance_destroy();
    exit;
}
persistent = true;

// ✅ SET SAVE PATH FIRST - BEFORE ANYTHING ELSE
global.save_path = game_save_id + "_leaderboard.ini";

// === STATISTICS TRACKING ===
global.best_score = 0;
global.games_played = 0;
global.total_playtime = 0;

// Load stats from INI
ini_open(global.save_path);
global.best_score = ini_read_real("Statistics", "BestScore", 0);
global.games_played = ini_read_real("Statistics", "GamesPlayed", 0);
global.total_playtime = ini_read_real("Statistics", "TotalPlaytime", 0);
ini_close();

// Set session start time AFTER loading
global.session_start_time = current_time;

show_debug_message("📊 Stats loaded: Best=" + string(global.best_score) + " Games=" + string(global.games_played) + " Playtime=" + string(global.total_playtime));

// Initialize coins/gems
if (!variable_global_exists("total_coins")) global.total_coins = 0;
if (!variable_global_exists("total_gems")) global.total_gems = 0;
if (!variable_global_exists("owned_shield")) global.owned_shield = 0;
if (!variable_global_exists("owned_aura")) global.owned_aura = 0;
if (!variable_global_exists("owned_speed")) global.owned_speed = 0;

if (file_exists("save.ini")) {
    ini_open("save.ini");
    global.total_coins = ini_read_real("PlayerData", "TotalCoins", 0);
    global.total_gems = ini_read_real("PlayerData", "Gems", 0);
    global.owned_shield = ini_read_real("ShopData", "ShieldOwned", 0);
    global.owned_aura = ini_read_real("ShopData", "AuraOwned", 0);
    global.owned_speed = ini_read_real("ShopData", "SpeedOwned", 0);
    ini_close();
}

show_debug_message("✅ oGlobal loaded: Coins=" + string(global.total_coins) + " Gems=" + string(global.total_gems));

// === COLOR SYSTEM ===
global.unlocked_colors = [
    16711680,   // Red
    16744448,   // Orange  
    16776960,   // Yellow
    65280,      // Lime
    65535,      // Aqua
    255,        // Blue
    8388608,    // Purple
    16711935    // Fuchsia
];

if (!variable_global_exists("inv_index")) {
    global.inv_index = 0;
}

if (!variable_global_exists("player_color")) {
    global.player_color = global.unlocked_colors[0];
}

ini_open(global.save_path);
global.inv_index = ini_read_real("PlayerData", "ColorIndex", 0);
ini_close();

if (global.inv_index >= 0 && global.inv_index < array_length(global.unlocked_colors)) {
    global.player_color = global.unlocked_colors[global.inv_index];
} else {
    global.inv_index = 0;
    global.player_color = global.unlocked_colors[0];
}

show_debug_message("🎨 Color loaded: Index=" + string(global.inv_index) + " RGB=" + string(global.player_color));

// === BATTLE PASS ===
global.bp_tier = 1;
global.bp_xp = 0;
global.bp_purchased = 0;
global.bp_season = 1;
global.bp_claimed_tiers = ds_list_create();

// Battle Pass rewards array (Tiers 1-15)
global.bp_rewards = [
    { coins: 50, gems: 0 },    // Tier 1
    { coins: 75, gems: 0 },    // Tier 2
    { coins: 100, gems: 0 },   // Tier 3
    { coins: 125, gems: 0 },   // Tier 4
    { coins: 0, gems: 20 },    // Tier 5
    { coins: 75, gems: 0 },    // Tier 6
    { coins: 100, gems: 0 },   // Tier 7
    { coins: 125, gems: 0 },   // Tier 8
    { coins: 150, gems: 0 },   // Tier 9
    { coins: 0, gems: 30 },    // Tier 10
    { coins: 100, gems: 0 },   // Tier 11
    { coins: 125, gems: 0 },   // Tier 12
    { coins: 150, gems: 0 },   // Tier 13
    { coins: 175, gems: 0 },   // Tier 14
    { coins: 0, gems: 40 }     // Tier 15
];

// Load BP data from INI
ini_open(global.save_path);
global.bp_tier = ini_read_real("BattlePass", "Tier", 1);
global.bp_xp = ini_read_real("BattlePass", "XP", 0);
global.bp_purchased = ini_read_real("BattlePass", "Purchased", 0);
global.bp_season = ini_read_real("BattlePass", "Season", 1);
var claimed_tiers_str = ini_read_string("BattlePass", "ClaimedTiers", "");
ini_close();

// Load claimed tiers from string
if (claimed_tiers_str != "") {
    var tier_array = string_split(claimed_tiers_str, ",");
    for (var i = 0; i < array_length(tier_array); i++) {
        ds_list_add(global.bp_claimed_tiers, real(tier_array[i]));
    }
}

show_debug_message("⭐ Battle Pass loaded: Tier=" + string(global.bp_tier) + " XP=" + string(global.bp_xp));