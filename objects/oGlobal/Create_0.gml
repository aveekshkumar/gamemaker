/// --- oGlobal Create Event ---
if (instance_number(oGlobal) > 1) {
    instance_destroy();
    exit;
}
persistent = true;

// ✅ SET SAVE PATH FIRST
global.save_path = game_save_id + "_leaderboard.ini";

// ✅ Initialize ALL globals to 0 FIRST
if (!variable_global_exists("total_coins")) global.total_coins = 0;
if (!variable_global_exists("total_gems")) global.total_gems = 0;
if (!variable_global_exists("owned_shield")) global.owned_shield = 0;
if (!variable_global_exists("owned_aura")) global.owned_aura = 0;
if (!variable_global_exists("owned_speed")) global.owned_speed = 0;

// ✅ THEN load from file
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

// === STATISTICS TRACKING ===
global.best_score = 0;
global.games_played = 0;
global.total_playtime = 0;  // in seconds
global.session_start_time = 0;

// Load stats from INI (NOW global.save_path exists!)
ini_open(global.save_path);
global.best_score = ini_read_real("Statistics", "BestScore", 0);
global.games_played = ini_read_real("Statistics", "GamesPlayed", 0);
global.total_playtime = ini_read_real("Statistics", "TotalPlaytime", 0);
global.session_start_time = ini_read_real("Statistics", "SessionStartTime", current_time);
ini_close();

show_debug_message("📊 Stats loaded: Best=" + string(global.best_score) + " Games=" + string(global.games_played));