if (keyboard_check_pressed(vk_escape) || 
    (mouse_check_button_pressed(mb_left) && 
     mouse_x > 40 && mouse_x < 40 + back_button_width &&
     mouse_y > back_button_y && mouse_y < back_button_y + back_button_height)) {
    
    show_debug_message("📍 Returning to start menu from leaderboard");
    room_goto(rm_start);
}