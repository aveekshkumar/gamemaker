/// --- oRunner Step Event ---

// ✅ RESET COINS WHEN ENTERING GAME
if (!variable_instance_exists(self, "coins_initialized")) {
    coins = 0;
    coins_initialized = true;
}

if (!variable_global_exists("scroll_speed")) global.scroll_speed = 4.5; // adjust for balance

// Skip updates when paused
if (global.game_paused) exit;

// Keep best score saved so Mission Menu updates next time
if (!variable_global_exists("best_score")) global.best_score = 0;
if (global.score > global.best_score) {
    global.best_score = global.score;
    ini_open("save.ini");
    ini_write_real("PlayerData", "BestScore", global.best_score);
    ini_close();
}

// Animate score bounce
if (score_display != global.score) {
    score_display = global.score;
    score_bounce = 1.3;  // Bounce size
}

if (score_bounce > 1) {
    score_bounce = lerp(score_bounce, 1, 0.15);  // Smoothly return to normal
}

 // Example base tick:
global.score += 1 * global.score_mult;

// Night mode toggle
if keyboard_check_pressed(ord("N")) {
    night_mode = !night_mode;
}

// Use actual scroll speed for distance
var ds = variable_global_exists("scroll_speed") ? global.scroll_speed : move_speed;
distance += ds / room_speed; // adds 1 per second if ds == 1

/// Celebration fireworks
if (global.score > 0 && global.score mod 500 == 0 && !instance_exists(oFirework)) {
    for (var i = 0; i < irandom_range(2, 3); i++) {
        instance_create_depth(irandom(room_width), irandom_range(80, 200), -50, oFirework);
    }
}

// Aura updates
aura_pulse_t += 0.08;
var target = (global.score >= aura_min_score) ? 1 : 0;
if (global.score >= aura_min_score) {
    var extra = clamp((global.score - aura_min_score) / 4000, 0, 0.5);
    target = clamp(1.0 + extra, 0, 1.5);
}
if (aura_strength < target) aura_strength = min(target, aura_strength + aura_rise);
else aura_strength = max(0, aura_strength - aura_fall);

// Color Burst update
if (!burst_active && burst_strength <= 0 && global.score >= burst_next_at) {
    burst_active = true;
    burst_timer = 0;
    burst_next_at += burst_interval;
}
if (burst_active) {
    burst_strength = min(1, burst_strength + burst_rise);
    burst_timer++;
    if (burst_timer >= burst_length) burst_active = false;
} else burst_strength = max(0, burst_strength - burst_fall);

// --- LANE SWITCHING ---
if keyboard_check_pressed(vk_left) && lane > 0 { lane--; lane_flash_t = 20; }
if keyboard_check_pressed(vk_right) && lane < 2 { lane++; lane_flash_t = 20; }
x = lane_x[lane];

// --- JUMP + LAND ---
if keyboard_check_pressed(vk_space) && !is_jumping && y >= 700 {
    is_jumping = true;
    jump_height = -jump_speed;
    was_airborne = true;
    repeat(5) instance_create_layer(x + random_range(-10, 10), y + 25, "Instances", oParticle);
}
if (is_jumping) {
    y += jump_height;
    jump_height += grav;
    if (y >= 700) {
        y = 700;
        is_jumping = false;
        jump_height = 0;
        if (was_airborne && !shockwave_active) {
            shockwave_active = true;
            shockwave_timer = 0;
            shockwave_radius = 0;
            was_airborne = false;
        }
        shadow_scale = 1.4;
    }
} else was_airborne = false;
shadow_scale = max(1, shadow_scale - 0.02);

// --- SHOCKWAVE ---
if (shockwave_active) {
    shockwave_timer++;
    shockwave_radius = lerp(shockwave_radius, shockwave_max, 0.25);
    if (shockwave_timer > room_speed * 0.4) shockwave_active = false;
}

// --- DASH ---
dash_cooldown = max(0, dash_cooldown - 1);
if keyboard_check_pressed(ord("D")) && dash_cooldown <= 0 && !dash_active {
    dash_active = true;
    dash_start_y = y;
    y -= 64;
    dash_duration = 240;
    dash_cooldown = 1200;
}
if dash_active {
    dash_duration--;
    if (dash_duration <= 0) { y = dash_start_y; dash_active = false; }
}

// --- MAGNET ---
if keyboard_check_pressed(ord("E")) {
    if (!magnet_active && magnet_cd <= 0) {
        magnet_active = true;
        magnet_time = magnet_time_max;
        popup_text = "Magnet ON";
        popup_timer = 45;
    } else if (magnet_active) {
        magnet_active = false;
        popup_text = "Magnet OFF";
        popup_timer = 30;
    }
}
if (magnet_active) {
    magnet_time--;
    if (magnet_time <= 0) {
        magnet_active = false;
        magnet_cd = magnet_cd_max;
    }
} else if (magnet_cd > 0) magnet_cd--;

// --- Death Logic ---
if (death_timer > 0) {
    death_timer--;
    if (death_timer <= 0) {
        show_debug_message("💀 Game Over! Final coins this run: " + string(coins));
        
        // ✅ SAVE EVERYTHING IN ONE INI BLOCK
        var run_score = global.score;
        var save_file = game_save_id + "_leaderboard.ini";
        
        ini_open(save_file);
        
        // Save coins & gems
        ini_write_real("PlayerData", "TotalCoins", global.total_coins);
        ini_write_real("PlayerData", "Gems", global.total_gems);
        
        // Read existing top 5 scores
        var scores = [];
        for (var i = 1; i <= 5; i++) {
            var score_val = ini_read_real("Leaderboard", "Score" + string(i), 0);
            if (score_val > 0) {
                array_push(scores, score_val);
            }
        }
        
        // Add new score
        array_push(scores, run_score);
        
        // Sort descending (highest first)
        array_sort(scores, false);
        
        // Keep only top 5
        if (array_length(scores) > 5) {
            array_resize(scores, 5);
        }
        
        // Save leaderboard scores
        for (var i = 0; i < array_length(scores); i++) {
            ini_write_real("Leaderboard", "Score" + string(i + 1), scores[i]);
        }
        
        ini_close();
        
        // Debug messages
        show_debug_message("💾 SAVED on death: Coins=" + string(global.total_coins) + " Gems=" + string(global.total_gems));
        show_debug_message("💾 Score saved: " + string(run_score));
        show_debug_message("💾 Saved to: " + save_file);
        
		// ✅ UPDATE BEST SCORE
        if (run_score > global.best_score) {
            global.best_score = run_score;
        }

        // ✅ UPDATE STATS
        global.games_played += 1;
        var session_duration = (current_time - global.session_start_time) / 1000;  // convert to seconds
        global.total_playtime += session_duration;
		
        // Save stats
        ini_open(save_file);
        ini_write_real("Statistics", "BestScore", global.best_score);
        ini_write_real("Statistics", "GamesPlayed", global.games_played);
        ini_write_real("Statistics", "TotalPlaytime", global.total_playtime);
        ini_close();

        show_debug_message("📊 Stats updated: Best=" + string(global.best_score) + " Games=" + string(global.games_played));
		
        // Destroy objects
        with (oGemCoin) instance_destroy();
        with (oCoin) instance_destroy();
        with (oObstacle) instance_destroy();
        with (oDrone) goodbye = true;
        
        room_goto(rm_start);
    }
}

// --- Energy Trail Update ---
trail_timer++;
if (trail_timer >= trail_gap) {
    trail_timer = 0;
    // shift points down
    for (var i = trail_max_points - 1; i > 0; i--) {
        trail_points[i] = trail_points[i - 1];
    }
    // add current position at start
    trail_points[0] = [x, y];
}

// --- Speed boost trail (visual only) ---
if (global.owned_speed == 1) {
    if (irandom(3) == 0) {
        var px = x + irandom_range(-5, 5);
        var py = y + 20 + irandom_range(-5, 5);

        // create a yellow dust puff
        part_particles_create(part_system, px, py, part_dust, 1);
        part_type_color1(part_dust, c_yellow);   // sets color safely
    }
}

/// --- oRunner Step Event (color sync) ---
self.color = global.player_color;