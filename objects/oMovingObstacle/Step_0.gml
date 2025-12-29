/// --- oMovingObstacle Step Event (fixed) ---
if (global.game_paused) exit;

// Safety: ensure scroll speed
if (!variable_global_exists("scroll_speed")) global.scroll_speed = 0.24;

// === FALLING DOWN ===
y += global.scroll_speed;

// Destroy if off-screen
if (y > room_height + sprite_height) instance_destroy();

//if touching obstacle destroy
if place_meeting(x, y, oObstacle){
	instance_destroy();
}

// === INITIALIZE VARIABLES (first-time setup) ===
if (!variable_instance_exists(id, "move_timer")) move_timer = 0;
if (!variable_instance_exists(id, "move_dir")) move_dir = choose(-1, 1); // random start
if (!variable_instance_exists(id, "side_speed")) side_speed = 2;         // horizontal speed
if (!variable_instance_exists(id, "lane_limit_left")) lane_limit_left = x - 40;  // lane bounds
if (!variable_instance_exists(id, "lane_limit_right")) lane_limit_right = x + 40;

// === SIDE MOVEMENT ===
move_timer++;

// Start moving sideways after 1 second
if (move_timer > room_speed) {
    x += move_dir * side_speed;

    // Bounce back within lane limits
    if (x <= lane_limit_left || x >= lane_limit_right) {
        move_dir *= -1;
    }
}

/// --- DODGE CHECK ---
if (!variable_instance_exists(self, "dodged")) dodged = false;

// if obstacle moved below player and wasn’t counted
if (!dodged && y > oRunner.y && !place_meeting(x, y, oRunner)) {
    dodged = true;
    global.dodge_count += 1;

    // Combo achieved!
    if (global.dodge_count >= global.dodges_needed) {
        global.dodge_count = 0;
        global.combo += 1;

        // optional popup
        with (instance_create_layer(oRunner.x, oRunner.y - 40, "Instances", oPopupText)) {
            text = "COMBO x" + string(global.combo);
            color = c_yellow;
        }
    } else {
        // small “DODGE!” popup for normal ones
        with (instance_create_layer(oRunner.x, oRunner.y - 30, "Instances", oPopupText)) {
            text = "DODGE!";
            color = c_lime;
        }
    }
}