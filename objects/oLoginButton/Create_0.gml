// oLoginButton Create Event
x = room_width / 2;
y = room_height / 2 - 100;
width = 220;
height = 80;

// Make sure save path exists
if (!variable_instance_exists(global, "save_path")) {
    global.save_path = working_directory + "save.ini";
}

// Check if already claimed today
current_date = date_date_string(date_current_datetime());
can_claim = true;

if (file_exists(global.save_path)) {
    ini_open(global.save_path);
    var last_claim_date = ini_read_string("LoginData", "LastClaimDate", "");
    ini_close();
    
    can_claim = (last_claim_date != current_date);
}

// Button colors
color_available = c_lime;
color_claimed = c_gray;

// Animation
button_scale = 1;
hover = false;

show_debug_message("🔘 oLoginButton created at X: " + string(x) + " Y: " + string(y));
show_debug_message("🔘 Can claim: " + string(can_claim));