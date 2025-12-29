/// --- oGemShop Step Event ---
/// Handles color purchase logic, navigation, and save updates

// Fade in animation
fade_alpha = clamp(fade_alpha + 0.05, 0, 1);

// Navigation
if (keyboard_check_pressed(vk_up))   gem_index = max(0, gem_index - 1);
if (keyboard_check_pressed(vk_down)) gem_index = min(array_length(gem_colors) - 1, gem_index + 1);

// --- Purchase selected color ---
if (keyboard_check_pressed(vk_enter)) {
    var name  = gem_names[gem_index];
    var price = gem_prices[gem_index];
    var col   = gem_colors[gem_index];

    // Check if player already owns this color
    var owned = false;
    for (var i = 0; i < array_length(global.unlocked_colors); i++) {
        if (global.unlocked_colors[i] == col) {
            owned = true;
            break;
        }
    }

    if (owned) {
        show_debug_message("⚠️ You already own " + name + " color!");
    } else if (global.total_gems >= price) {
        // Deduct gems and unlock color
        global.total_gems -= price;
        array_push(global.unlocked_colors, col);

        // Save progress
        ini_open("save.ini");
        ini_write_real("PlayerData", "Gems", global.total_gems);

        var save_str = "";
        for (var j = 0; j < array_length(global.unlocked_colors); j++) {
            save_str += string(global.unlocked_colors[j]);
            if (j < array_length(global.unlocked_colors) - 1) save_str += ",";
        }
        ini_write_string("PlayerData", "UnlockedColors", save_str);
        ini_close();

        show_debug_message("✅ Purchased color: " + name + " for " + string(price) + " gems!");
    } else {
        show_debug_message("❌ Not enough gems for " + name + "!");
    }
}

// --- Exit back to Start Menu ---
if (keyboard_check_pressed(vk_escape)) {
    room_goto(rm_start);
}