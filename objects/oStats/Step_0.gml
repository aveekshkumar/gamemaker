// === CONTINUOUS PLAYTIME TRACKING - SAVE EVERY SECOND ===
var elapsed = (current_time - global.session_start_time) / 1000;  // Convert to seconds
global.total_playtime += elapsed;
global.session_start_time = current_time;

// Save to INI every second (not every frame)
if (global.total_playtime mod 1 < 0.016) {  // Roughly once per second at 60fps
    ini_open(global.save_path);
    ini_write_real("Statistics", "TotalPlaytime", global.total_playtime);
    ini_close();
}

// Back button
if (keyboard_check_pressed(vk_escape)) {
    room_goto(rm_start);
}

if (mouse_check_button_pressed(mb_left)) {
    if (mouse_x >= 40 && mouse_x <= 160 && 
        mouse_y >= 500 && mouse_y <= 550) {
        room_goto(rm_start);
    }
if (keyboard_check_pressed(vk_escape) || 
    (mouse_check_button_pressed(mb_left) && 
     mouse_x > 40 && mouse_x < 40 + back_button_width &&
     mouse_y > back_button_y && mouse_y < back_button_y + back_button_height)) {
    
    show_debug_message("📍 Returning to start menu from stats");
    room_goto(rm_start);
}
}