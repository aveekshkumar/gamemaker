function scr_save_game() {
    /// Saves all persistent player data to global.save_path
    
    if (!variable_global_exists("save_path")) {
        show_debug_message("⚠️ Save path not initialized — run oGlobal first!");
        return;
    }
    
    ini_open(global.save_path);
    
    // --- Basic Stats ---
    ini_write_real("PlayerData", "TotalCoins", global.total_coins);  // ✅ FIXED: "TotalCoins" not "Coins"
    ini_write_real("PlayerData", "Gems", global.total_gems);
    ini_write_real("PlayerData", "PlayerColor", global.player_color);
    
    // --- Shop Upgrades ---
    ini_write_real("ShopData", "ShieldOwned", global.owned_shield);
    ini_write_real("ShopData", "AuraOwned", global.owned_aura);
    ini_write_real("ShopData", "SpeedOwned", global.owned_speed);
    
    // --- Unlocked Colors ---
    var s = "";
    for (var i = 0; i < array_length(global.unlocked_colors); i++) {
        s += string(global.unlocked_colors[i]);
        if (i < array_length(global.unlocked_colors) - 1) s += ",";
    }
    ini_write_string("PlayerData", "UnlockedColors", s);
    
    ini_close();
    show_debug_message("💾 Game saved successfully at " + string(global.save_path));
}