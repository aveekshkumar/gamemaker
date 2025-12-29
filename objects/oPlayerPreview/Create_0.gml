/// --- oPlayerPreview Create Event ---
/// Setup color cycling

cycle_index = 0;
cycle_timer = 0;
cycle_speed = 90; // 1.5 seconds at 60fps

if (!variable_global_exists("unlocked_colors")) {
    global.unlocked_colors = [c_white, c_red, c_blue, c_yellow];
}

image_speed = 0.2;