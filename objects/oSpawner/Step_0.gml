/// --- oSpawner Step Event (FINAL) ---

if (global.game_paused) exit;
if (global.game_won) exit;

// Timers
survival_time++;
run_time_frames++;
global.level_timer++;

// --- OBSTACLES ---
obs_timer++;
var diff_scale = 1.0 + 0.05 * (global.stage_index + global.level_index);
var obs_interval = max(obs_min, round(obs_base / diff_scale));

if (obs_timer >= obs_interval) {
    obs_timer = 0;

    var lane = irandom(2);
    if (lane == last_obs_lane) lane = (lane + choose(1,2)) mod 3;
    last_obs_lane = lane;

    var use_moving = (random(1) < chance_moving_obstacle);
    var obj = use_moving ? oMovingObstacle : oObstacle;
    var inst = instance_create_layer(lane_x[lane], spawn_y, layer, obj);

    if (use_moving) {
        var t_lane = clamp(lane + choose(-1,1), 0, 2);
        if (t_lane == lane) t_lane = clamp(lane + (lane == 0 ? 1 : -1), 0, 2);
        inst.target_x = lane_x[t_lane];
        inst.move_rate = 0.08;
    }

    // Optional double obstacle
    if (random(1) < chance_double_spawn) {
        var lane2 = (lane + choose(1,2)) mod 3;
        var obj2 = (random(1) < chance_moving_obstacle) ? oMovingObstacle : oObstacle;
        instance_create_layer(lane_x[lane2], spawn_y - 18, layer, obj2);
    }
}

// --- COINS ---
coin_timer++;
var coins_on_screen = instance_number(oCoin) + instance_number(oGemCoin);
show_debug_message("🪙 Coin timer: " + string(coin_timer) + " | Need: " + string(round(coin_base / diff_scale)) + " | Coins on screen: " + string(coins_on_screen));
if (coin_timer >= round(coin_base / diff_scale) && (instance_number(oCoin) + instance_number(oGemCoin)) < coin_cap) {
    show_debug_message("✅ SPAWNING COINS!");
	coin_timer = 0;

    if (random(1) < coin_spawn_chance) {
        var clane = irandom(2);
        if (clane == last_coin_lane) clane = (clane + choose(1,2)) mod 3;
        last_coin_lane = clane;

        var cx = lane_x[clane];
        var run_len = irandom_range(coin_run_len_min, coin_run_len_max);

        // 20% gem chance
        var gem_i = -1;
        if (random(1) < 0.20) gem_i = irandom(run_len - 1);

        for (var i = 0; i < run_len; i++) {
            var yy = spawn_y - i * coin_run_gap_y;
            var objc = (i == gem_i) ? oGemCoin : oCoin;
            instance_create_layer(cx, yy, layer, objc);
        }
    }
}

// --- LEVEL COMPLETION ---
if (global.level_timer >= level_duration) {
    global.level_timer = 0;
    global.level_index++;

    // Level complete banner
    global.level_banner = "LEVEL " + string(global.level_index) + " COMPLETE!";
    global.banner_visible = true;
    global.banner_timer = room_speed * 2;

    // Advance logic
    if (global.level_index >= global.levels_per_stage) {
        global.level_index = 0;
        global.stage_index++;

        global.level_banner = "STAGE " + string(global.stage_index) + " COMPLETE!";
        global.banner_visible = true;
        global.banner_timer = room_speed * 3;
    }

    // All stages done → finale
    if (global.stage_index >= global.total_stages) {
        global.level_banner = "🎉 ALL STAGES COMPLETED! 🎉";
        global.banner_visible = true;
        global.banner_timer = room_speed * 5;
        global.scroll_speed = 0;
        global.game_won = true;
        alarm[0] = room_speed * 5;
    }

    // Restart the level or next stage
    room_goto(room);
}

// --- Banner fade timer ---
if (global.banner_visible) {
    global.banner_timer--;
    if (global.banner_timer <= 0) global.banner_visible = false;
}

// --- Debug Skip Shortcut (for testing, smooth version) ---
if (keyboard_check_pressed(ord("K"))) {
    // Trigger instant level completion (no restart)
    global.level_timer = level_duration;

    // Immediately advance logic like it naturally reached the end
    global.level_banner = "LEVEL " + string(global.current_level) + " COMPLETED!";
    global.banner_visible = true;
    global.banner_timer = room_speed * 2;

    global.current_level++;
    global.scroll_speed = min(global.scroll_speed + 0.5, 15);

    // Change background color slightly
    var hue = (global.current_stage * 50 + global.current_level * 15) mod 255;
    global.bg_color = make_color_hsv(hue, 200, 255);

    // Handle stage completion
    if (global.current_level > global.levels_per_stage) {
        global.current_stage++;
        global.current_level = 1;
        global.level_banner = "STAGE " + string(global.current_stage - 1) + " COMPLETED!";
        global.banner_visible = true;
        global.banner_timer = room_speed * 3;
    }

    // Handle all stages done
    if (global.current_stage > global.stage_total) {
        global.level_banner = "🎉 ALL STAGES COMPLETED! 🎉";
        global.banner_visible = true;
        global.banner_timer = room_speed * 5;
        global.scroll_speed = 0;
        alarm[0] = room_speed * 5;
    }

    global.level_timer = 0;
}

// === BACKGROUND PULSE EFFECT ===
// creates a subtle breathing glow effect behind gameplay
var pulse_speed = 0.03;          // how fast it pulses (lower = slower)
var pulse_intensity = 30;        // color shift amount
var base_hue = (global.current_stage * 50 + global.current_level * 15) mod 255;

// make the hue oscillate smoothly
var pulse = sin(current_time * pulse_speed) * pulse_intensity;
var hue = (base_hue + pulse) mod 255;

// apply background color
global.bg_color = make_color_hsv(hue, 200, 255);