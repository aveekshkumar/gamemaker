/// --- oStartMenu Step Event ---
// --- Menu Navigation ---
if (keyboard_check_pressed(vk_down)) {
    menu_index = (menu_index + 1) mod array_length(menu_items);
}
if (keyboard_check_pressed(vk_up)) {
    menu_index = (menu_index - 1 + array_length(menu_items)) mod array_length(menu_items);
}

if (keyboard_check_pressed(vk_enter)) {
    // Burst sparks upward!
    for (var i = 0; i < 25; i++) {
        var s = {
            x: display_get_gui_width() / 2 + irandom_range(-50, 50),
            y: display_get_gui_height() / 2 + irandom_range(-20, 20),
            alpha: 1,
            speed: random_range(1, 3),
            size: irandom_range(2, 4),
            dir: irandom_range(-80, 80)
        };
        array_push(sparkles, s);
    }
}

// --- Handle selection ---
if (keyboard_check_pressed(vk_enter)) {
    switch (menu_index) {
		case 0: var t = instance_create_layer(0, 0, "Instances", oTransition); t.next_room = rm_stats; break;
		case 1: var t = instance_create_layer(0, 0, "Instances", oTransition); t.next_room = rm_leaderboard; break;
        case 2: room_goto(rm_game); break;
        case 3: var t = instance_create_layer(0, 0, "Instances", oTransition); t.next_room = rm_shop; break;
        case 4: var t = instance_create_layer(0, 0, "Instances", oTransition); t.next_room = rm_gemshop; break;
        case 5: var t = instance_create_layer(0, 0, "Instances", oTransition); t.next_room = rm_inventory; break;
		case 6: var t = instance_create_layer(0, 0, "Instances", oTransition); t.next_room = rm_daily_login; break;
		case 7: var t = instance_create_layer(0, 0, "Instances", oTransition); t.next_room = rm_character_pick; break;
		case 8: game_end(); break;
    }
}

// --- Menu Item Animation ---
menu_scale = lerp(menu_scale, 1, 0.15);
menu_glow = max(0, menu_glow - 0.05);

// When menu changes, reset animation
if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(vk_up)) {
    menu_scale = 1.15;  // Scale up when selected
    menu_glow = 1;      // Glow bright
}

// --- DEBUG SHORTCUT: Add 50000 Gems ---
if (keyboard_check_pressed(ord("G"))) {
    global.total_gems += 50000;
    show_debug_message("💎 Added 50000 Gems! Total: " + string(global.total_gems));
    
    ini_open(global.save_path);
    ini_write_real("PlayerData", "TotalCoins", global.total_coins);
    ini_write_real("PlayerData", "Gems", global.total_gems);
    ini_close();
    
    show_debug_message("💾 Gems saved successfully!");
}

// --- DEBUG SHORTCUT: Add 50000 Coins ---
if (keyboard_check_pressed(ord("C"))) {
    global.total_coins += 50000;
    show_debug_message("💰 Added 50000 coins! Total: " + string(global.total_coins));
    
    ini_open(global.save_path);
    ini_write_real("PlayerData", "TotalCoins", global.total_coins);
    ini_write_real("PlayerData", "Gems", global.total_gems);
    ini_close();
}