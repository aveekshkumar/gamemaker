/// --- oGameOver Step Event ---
if (keyboard_check_pressed(vk_up)) menu_index = max(0, menu_index - 1);
if (keyboard_check_pressed(vk_down)) menu_index = min(array_length(menu_items) - 1, menu_index + 1);

if (keyboard_check_pressed(vk_enter)) {
    switch (menu_index) {
        case 0: room_goto(rm_game); break;
        case 1: room_goto(rm_start); break;
        case 2: game_end(); break;
    }
}