/// oMissionMenu → Step Event
if (mouse_check_button_pressed(mb_left)) {
    for (var i = 0; i < array_length(global.missions); i++) {
        var m = global.missions[i];
        var y_pos = 150 + i * 60;

        // If mouse clicks inside the mission text area
        if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0),
            100, y_pos - 20, 540, y_pos + 20)) {

            if (m.completed && !m.claimed) {
                global.gems += m.reward;
                global.missions[i].claimed = true;
                show_debug_message("Mission Collected! +" + string(m.reward) + " Gems");
            } else if (!m.completed) {
                show_debug_message("Mission not done! Cannot collect yet.");
            } else if (m.claimed) {
                show_debug_message("Reward already claimed.");
            }
        }
    }
}

// Back button to return to start menu
if (keyboard_check_pressed(vk_escape)) {
    room_goto(rm_start);
}