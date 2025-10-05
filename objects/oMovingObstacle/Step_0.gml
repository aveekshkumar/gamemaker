// Pause check
if instance_exists(oRunner) && oRunner.game_paused { exit; }

if (variable_global_exists("game_won") && global.game_won) exit;

// vertical scroll
if (variable_global_exists("scroll_speed")) y += global.scroll_speed;

// if this is a moving obstacle with target_x/move_rate, glide sideways
if (variable_instance_exists(id, "target_x") && variable_instance_exists(id, "move_rate")) {
    x = lerp(x, target_x, move_rate);
}

// destroy when below screen
if (y > room_height + 40) instance_destroy();

// Lane switching logic - every 3 seconds
lane_switch_timer--;
if lane_switch_timer <= 0 {
    // Pick a new adjacent lane
    if lane == 0 { 
        target_lane = 1; // Can only go right
    } else if lane == 2 { 
        target_lane = 1; // Can only go left
    } else { 
        target_lane = choose(0, 2); // Middle can go left or right
    }
    
    lane_switch_timer = 180; // Reset to 3 seconds
}

// Move smoothly toward target lane
if x < lane_x[target_lane] {
    x += move_speed;
    if x >= lane_x[target_lane] {
        x = lane_x[target_lane];
        lane = target_lane;
    }
}
if x > lane_x[target_lane] {
    x -= move_speed;
    if x <= lane_x[target_lane] {
        x = lane_x[target_lane];
        lane = target_lane;
    }
}

// Destroy when off-screen
if y > room_height + 64 {
    instance_destroy();
}

// Destroy when hitting regular obstacles
if place_meeting(x, y, oObstacle) {
    instance_destroy();
}

// Collision with player
if place_meeting(x, y, oRunner) {
    if !oRunner.is_jumping {
        if oRunner.dodge_count > 0 {
            show_debug_message("Combo streak lost!");
        }
        oRunner.dodge_count = 0;
        oRunner.dodge_counter = 1;
        oRunner.dodges_needed = 5;
        
        oRunner.shake_magnitude = 8;
        oRunner.shake_length = 30;
        oRunner.death_timer = 30;
        audio_stop_all();
    }
}