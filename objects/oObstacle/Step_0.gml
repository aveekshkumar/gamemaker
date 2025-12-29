/// --- oObstacle Step Event (falling vertically) ---
if (global.game_paused) exit;

// --- Safety: ensure required globals exist ---
if (!variable_global_exists("scroll_speed")) global.scroll_speed = 0.24;
if (!variable_global_exists("dodge_count")) global.dodge_count = 0;
if (!variable_global_exists("dodges_needed")) global.dodges_needed = 5;
if (!variable_global_exists("combo")) global.combo = 0;
if (!variable_global_exists("obstacles_dodged")) global.obstacles_dodged = 0;

// --- Move obstacle downward based on scroll speed ---
y += global.scroll_speed;

// --- Destroy when off-screen ---
if (y > room_height + sprite_height) instance_destroy();

// --- Collision safety check ---
if (place_meeting(x, y, oObstacle)) {
    instance_destroy();
}

/// --- DODGE CHECK ---
if (!variable_instance_exists(self, "dodged")) dodged = false;

// if obstacle moved below player and wasn’t counted as dodged
if (!dodged && y > oRunner.y && !place_meeting(x, y, oRunner)) {
    dodged = true;
    global.dodge_count += 1;
    global.obstacles_dodged += 1; // ✅ counts toward missions

    // --- Combo logic ---
    if (global.dodge_count >= global.dodges_needed) {
        global.dodge_count = 0;
        global.combo += 1;

        // Combo popup
        if (object_exists(oPopupText)) {
            with (instance_create_layer(oRunner.x, oRunner.y - 40, "Instances", oPopupText)) {
                text = "COMBO x" + string(global.combo);
                color = c_yellow;
            }
        }
    } else {
        // Small "DODGE!" popup
        if (object_exists(oPopupText)) {
            with (instance_create_layer(oRunner.x, oRunner.y - 30, "Instances", oPopupText)) {
                text = "DODGE!";
                color = c_lime;
            }
        }
    }
}