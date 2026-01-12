/// --- oGlobal Step Event ---
// Quick save (press F5)
if (keyboard_check_pressed(vk_f5)) {
    ini_open(global.save_path);
    ini_write_real("PlayerData", "TotalCoins", global.total_coins);
    ini_write_real("PlayerData", "Gems", global.total_gems);
    ini_write_real("PlayerData", "PlayerColor", global.player_color);
    ini_write_string("PlayerData", "UnlockedColors", string_join(global.unlocked_colors, ","));
    ini_close();
    show_debug_message("💾 Manual save (F5) complete!");
}

// Quick reset (press F9)
if (keyboard_check_pressed(vk_f9)) {
    file_delete(global.save_path);
    show_debug_message("🧹 Save file reset!");
}

/// --- oGlobal Step Event ---
// Update playtime every frame
var elapsed = (current_time - global.session_start_time) / 1000;  // convert to seconds
global.total_playtime = elapsed;