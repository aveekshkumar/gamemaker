/// --- oGlobal Create Event ---
if (instance_number(oGlobal) > 1) {
    instance_destroy();
    exit;
}
persistent = true;

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