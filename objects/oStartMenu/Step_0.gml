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
        case 0: room_goto(rm_game); break;
        case 1: var t = instance_create_layer(0, 0, "Instances", oTransition); t.next_room = rm_shop; break;
        case 2: var t = instance_create_layer(0, 0, "Instances", oTransition); t.next_room = rm_gemshop; break;
        case 3: var t = instance_create_layer(0, 0, "Instances", oTransition); t.next_room = rm_inventory; break;
		case 4: var t = instance_create_layer(0, 0, "Instances", oTransition); t.next_room = rm_daily_login; break;
        case 5: game_end(); break;
    }
}

// --- DEBUG SHORTCUT: Add 1000 Gems ---
if (keyboard_check_pressed(ord("G"))) {
    global.total_gems += 1000;
    show_debug_message("💎 Added 1000 Gems! Total: " + string(global.total_gems));
    
    ini_open(global.save_path);
    ini_write_real("PlayerData", "TotalCoins", global.total_coins);
    ini_write_real("PlayerData", "Gems", global.total_gems);
    ini_close();
    
    show_debug_message("💾 Gems saved successfully!");
}

// --- DEBUG SHORTCUT: Add 500 Coins ---
if (keyboard_check_pressed(ord("C"))) {
    global.total_coins += 500;
    show_debug_message("💰 Added 500 Coins! Total: " + string(global.total_coins));
    
    ini_open(global.save_path);
    ini_write_real("PlayerData", "TotalCoins", global.total_coins);
    ini_write_real("PlayerData", "Gems", global.total_gems);
    ini_close();
}

// --- Open Preview Room ---
if (keyboard_check_pressed(ord("P"))) {
    room_goto(rm_preview);
}