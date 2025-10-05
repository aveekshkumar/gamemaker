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

if place_meeting(x,y, oObstacle)
{
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