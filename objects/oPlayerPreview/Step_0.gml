/// --- oPlayerPreview Step Event ---
/// Auto and manual color cycling

cycle_timer++;

if (cycle_timer >= cycle_speed) {
    cycle_timer = 0;
    cycle_index = (cycle_index + 1) mod array_length(global.unlocked_colors);
}

// Manual color control
if (keyboard_check_pressed(vk_right)) {
    cycle_index = (cycle_index + 1) mod array_length(global.unlocked_colors);
}

if (keyboard_check_pressed(vk_left)) {
    cycle_index = (cycle_index - 1 + array_length(global.unlocked_colors)) mod array_length(global.unlocked_colors);
}

// Return to main menu
if (keyboard_check_pressed(vk_escape)) {
    room_goto(rm_start);
}