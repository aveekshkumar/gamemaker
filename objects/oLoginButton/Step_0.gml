// oLoginButton Step Event

var button_left = x - width/2;
var button_right = x + width/2;
var button_top = y - height/2;
var button_bottom = y + height/2;

var mouse_over = (mouse_x > button_left && mouse_x < button_right && 
                  mouse_y > button_top && mouse_y < button_bottom);

hover = mouse_over;

// Animation
if (hover) {
    button_scale = lerp(button_scale, 1.1, 0.1);
} else {
    button_scale = lerp(button_scale, 1, 0.1);
}

// If clicked
if (mouse_over && mouse_check_button_pressed(mb_left)) {
    if (can_claim) {
        claim_daily_reward();
        
        ini_open(global.save_path);
        ini_write_string("LoginData", "LastClaimDate", current_date);
        ini_close();
        
        can_claim = false;
        show_debug_message("✅ You have claimed your daily reward!");
    } else {
        show_debug_message("⚠️ You have already claimed your reward today");
    }
}
