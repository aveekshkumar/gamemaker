// Pause toggle
if keyboard_check_pressed(ord("P")) {
    game_paused = !game_paused;
    
    if game_paused {
        audio_pause_all();
    } else {
        audio_resume_all();
    }
}

// If paused, skip all other code
if game_paused {
    exit;
}

// Night mode toggle
if keyboard_check_pressed(ord("N")) {
    night_mode = !night_mode;
}

// Increment score
global.score += 1;

/// --- Color Burst Trigger ---
if (!burst_active && global.score >= burst_next_at) {
    burst_active  = true;
    burst_timer   = 0;
    burst_next_at += burst_interval; // next trigger at +1000
}

if (burst_active) {
    burst_timer++;
    if (burst_timer >= burst_length) {
        burst_active = false;
        burst_timer  = 0;
    }
}

distance += move_speed / room_speed; // adds per second

// Lane switcher
if keyboard_check_pressed(vk_left) && lane > 0 {
    lane--;
	lane_flash_t = 20; // frames of flash
}
if keyboard_check_pressed(vk_right) && lane < 2 {
    lane++;
	lane_flash_t = 20; // frames of flash
}

x = lane_x[lane];

/// --- HOT LANE logic ---
if (hot_timer > 0) {
    hot_timer--;

    // if you're in the hot lane, drip bonus once per second
    if (lane == hot_lane) {
        hot_tick += 1;
        if (hot_tick >= room_speed) {
            hot_tick = 0;
            coins += 1;        // free coin per second in hot lane
            score += 10;       // small score bonus too
            // optional: tiny popup bounce if you already use popup_text
            // popup_text = "+1 (HOT LANE)";
            // popup_timer = 20;
        }
    } else {
        hot_tick = 0; // left the hot lane → stop ticking
    }
}
else {
    // waiting for the next hot lane
    if (hot_cooldown > 0) {
        hot_cooldown--;
    } else {
        // start a new hot lane
        hot_lane  = irandom(2);               // pick 0/1/2
        hot_timer = round(room_speed * 10);   // 10 seconds hot
        hot_cooldown = hot_gap;               // set gap for next cycle
        hot_tick = 0;

        // optional: announce it
        if (is_undefined(popup_timer)) { /* ignore if you don't use popups */ } else {
            popup_text = "HOT LANE!";
            popup_timer = 45;
        }
    }
}

// Jumping
if keyboard_check_pressed(vk_space) && !is_jumping {
    is_jumping = true;
    jump_height = -jump_speed;
    
    repeat(5) {
        instance_create_layer(x + random_range(-10, 10), y + 25, "Instances", oParticle);
    }
}

if is_jumping {
    y += jump_height;
    jump_height += grav;
    
    if y >= 700 {
        y = 700;
        is_jumping = false;
        jump_height = 0;
    }
}

// On landing
if (is_jumping && y >= 700) {
    y = 700; is_jumping = false; jump_height = 0;
    shadow_scale = 1.4;   // squash
    shake_magnitude = 3; shake_length = 6;
}
shadow_scale = max(1, shadow_scale - 0.02);

// Dash ability
dash_cooldown--;
if dash_cooldown < 0 { dash_cooldown = 0; }

// Activate dash with D key
if keyboard_check_pressed(ord("D")) && dash_cooldown <= 0 && !dash_active {
    dash_active = true;
    dash_start_y = y;
    y -= 64; // Move up 64 pixels
    dash_duration = 240; // 4 seconds at 60fps
    dash_cooldown = 1200; // 20 seconds cooldown (20 * 60)
}

// Dash duration countdown
if dash_active {
    dash_duration--;
    if dash_duration <= 0 {
        y = dash_start_y; // Return to original height
        dash_active = false;
    }
}

// === COIN MAGNET ===
// Press 'E' to toggle when off cooldown (change key if you like)
if (keyboard_check_pressed(ord("E"))) {
    if (!magnet_active && magnet_cd <= 0) {
        magnet_active = true;
        magnet_time   = magnet_time_max;
        // tiny popup if you use popups
        popup_text  = "Magnet ON";
        popup_timer = 45;
    } else if (magnet_active) {
        // allow early cancel
        magnet_active = false;
        popup_text  = "Magnet OFF";
        popup_timer = 30;
    }
}

// tick timers
if (magnet_active) {
    magnet_time--;
    if (magnet_time <= 0) {
        magnet_active = false;
        magnet_cd = magnet_cd_max;  // start cooldown
    }
} else if (magnet_cd > 0) {
    magnet_cd--;
}

// --- Pull regular coins ---
if (magnet_active) {
    with (oCoin) {
        var dx = other.x - x;
        var dy = other.y - y;
        var ex = dx*dx / (other.magnet_rx*other.magnet_rx);
        var ey = dy*dy / (other.magnet_ry*other.magnet_ry);
        if (ex + ey <= 1) {
            var d = max(1, point_distance(x, y, other.x, other.y));
            var t = clamp((ex + ey), 0, 1);
            var boost = 1.0 + 0.75 * (1.0 - t);
            x += (dx / d) * other.magnet_power * 12 * boost;
            y += (dy / d) * other.magnet_power * 12 * boost;
            if (point_distance(x, y, other.x, other.y) < 8) { x = other.x; y = other.y; }
        }
    }
}

// --- Pull gem coins too (same logic) ---
if (magnet_active) {
    with (oGemCoin) {
        var dx = other.x - x;
        var dy = other.y - y;
        var ex = dx*dx / (other.magnet_rx*other.magnet_rx);
        var ey = dy*dy / (other.magnet_ry*other.magnet_ry);
        if (ex + ey <= 1) {
            var d = max(1, point_distance(x, y, other.x, other.y));
            var t = clamp((ex + ey), 0, 1);
            var boost = 1.0 + 0.85 * (1.0 - t); // tiny bit stronger for gems (optional)
            x += (dx / d) * other.magnet_power * 12 * boost;
            y += (dy / d) * other.magnet_power * 12 * boost;
            if (point_distance(x, y, other.x, other.y) < 8) { x = other.x; y = other.y; }
        }
    }
}

//death timer
if death_timer > 0 {
    death_timer--;
    if death_timer <= 0 {
        // Create game over and pass data
        var game_over = instance_create_layer(0, 0, "Instances", oGameOver);
        game_over.final_score = score;
        game_over.final_time_seconds = floor(oSpawner.survival_time / 60);
        game_over.final_minutes = floor(game_over.final_time_seconds / 60);
        game_over.final_seconds = game_over.final_time_seconds - (game_over.final_minutes * 60);
        
        // Destroy all game objects
        with(oObstacle) instance_destroy();
        with(oMovingObstacle) instance_destroy();
        with(oSpawner) instance_destroy();
        with(oParticle) instance_destroy();
        with(oCoin) instance_destroy();
		with(oGemCoin) instance_destroy();
		with(oWarning) instance_destroy();
		with(oDrone) instance_destroy();
        
        instance_destroy();
    }
}

// Dodge detection for combo
with(oObstacle) {
    if bbox_top > other.y + 32 && !variable_instance_exists(id, "counted") {
        other.dodge_count++;
        counted = true;
        
        if other.dodge_count >= other.dodges_needed {
            if variable_instance_exists(other, "score") {
                var bonus = 10 * other.dodge_counter;
                other.score += bonus;
            }
            
            other.dodge_counter++;
            other.dodges_needed = 5 + (other.dodge_counter * 2);
            other.dodge_count = 0;
        }
    }
}

with(oMovingObstacle) {
    if bbox_top > other.y + 32 && !variable_instance_exists(id, "counted") {
        other.dodge_count++;
        counted = true;
        
        if other.dodge_count >= other.dodges_needed {
            if variable_instance_exists(other, "score") {
                var bonus = 10 * other.dodge_counter;
                other.score += bonus;
            }
            
            other.dodge_counter++;
            other.dodges_needed = 5 + (other.dodge_counter * 2);
            other.dodge_count = 0;
        }
    }
}

// --- Perfect Run Glow update ---
if (hit_obstacle) {
    glow_timer  = 0;
    glow_factor = 0;
    hit_obstacle = false; // clear flag for next run
} else {
    glow_timer++;
}

// ramp up only after the 25s threshold, otherwise decay
if (glow_timer >= glow_threshold) {
    glow_factor = clamp(glow_factor + glow_rise, 0, 1);
} else {
    glow_factor = max(0, glow_factor - glow_fall);
}

/// --- TRAIL UPDATE ---
trail_timer++;
if (trail_timer >= trail_gap) {
    trail_timer = 0;
    // shift points down
    for (var i = trail_length - 1; i > 0; i--) {
        trail_points[i] = trail_points[i - 1];
    }
    trail_points[0] = [x, y];
}

// Change color when pressing P
if (keyboard_check_pressed(ord("V"))) {
    trail_color_index = (trail_color_index + 1) mod array_length(trail_colors);
}