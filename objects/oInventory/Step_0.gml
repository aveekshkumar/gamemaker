/// --- oInventory Step Event ---
/// Handles navigation, color equipping, and exit

// Fade in effect
fade_alpha = clamp(fade_alpha + 0.05, 0, 1);

// Navigation
if (keyboard_check_pressed(vk_down)) inv_index = min(array_length(global.unlocked_colors) - 1, inv_index + 1);
if (keyboard_check_pressed(vk_up))   inv_index = max(0, inv_index - 1);

// Equip selected color
if (keyboard_check_pressed(vk_enter)) {
    if (array_length(global.unlocked_colors) > 0) {
        global.player_color = global.unlocked_colors[inv_index];

        ini_open("save.ini");
        ini_write_real("PlayerData", "PlayerColor", global.player_color);
        ini_close();

        show_debug_message("🎨 Equipped new color: " + string(global.player_color));
    }
}

// Exit to start
if (keyboard_check_pressed(vk_escape)) {
    room_goto(rm_start);
}