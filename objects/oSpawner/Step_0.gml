/// oSpawner → Step

// stop everything if already won (lets your HUD show the banner)
if (global.game_won) exit;

if (keyboard_check_pressed(ord("M"))) {
    audio_play_sound(sndBackgroundMusic, 1, true);
}

// ---------- timers ----------
survival_time++;
run_time_frames++;

// ---------- speed bumps every 10s ----------
if (survival_time >= next_bump_at && speed_index < array_length(speed_schedule) - 1) {
    speed_index++;
    global.scroll_speed = speed_schedule[speed_index];
    next_bump_at += bump_interval;

    // optional toast on the runner
    if (instance_exists(oRunner)) {
        with (oRunner) { popup_text = "Speed Up!"; popup_timer = 45; }
    }
}

// ---------- SPAWN LOGIC ----------
// difficulty scale: later stages spawn a bit faster (index 0..3)
var diff_k = 1.0 - 0.15 * speed_index; // 1.00, 0.85, 0.70, 0.55

// --- obstacles ---
obs_timer++;
var obs_interval = max(obs_min, round(obs_base * diff_k));
if (obs_timer >= obs_interval) {
    obs_timer = 0;

    // pick lane, avoid repeating same lane twice
    var lane = irandom(2);
    if (lane == last_obs_lane) lane = (lane + choose(1,2)) mod 3;
    last_obs_lane = lane;

    // choose type
    var use_moving = (random(1) < chance_moving_obstacle);
    var obj = use_moving ? oMovingObstacle : oObstacle;

    var inst = instance_create_layer(lane_x[lane], spawn_y, layer, obj);

    // give moving obstacle a side target (glide to neighbor lane)
    if (use_moving) {
        var t_lane = clamp(lane + choose(-1, 1), 0, 2);
        if (t_lane == lane) t_lane = clamp(lane + (lane == 0 ? 1 : -1), 0, 2);
        if (!variable_instance_exists(inst, "target_x")) inst.target_x = lane_x[t_lane];
        if (!variable_instance_exists(inst, "move_rate")) inst.move_rate = 0.08; // lerp power
    }

    // chance to spawn second obstacle in a different lane
    if (random(1) < chance_double_spawn) {
        var lane2 = irandom(2);
        if (lane2 == lane) lane2 = (lane2 + choose(1,2)) mod 3;
        var obj2 = (random(1) < chance_moving_obstacle) ? oMovingObstacle : oObstacle;
        instance_create_layer(lane_x[lane2], spawn_y - 18, layer, obj2);
    }
}

// -------- COINS (calmer) --------
coin_timer++;

// coin interval scales a little with difficulty, but not too much
var coin_diff = clamp(1.0 - 0.08 * speed_index, 0.7, 1.0); // 1.0 → 0.76 across stages
var coin_interval = round(coin_base * coin_diff);

// only try to spawn if timer passed AND under the coin cap
if (coin_timer >= coin_interval && instance_number(oCoin) < coin_cap) {
    coin_timer = 0;

    // extra probability gate so not every window spawns
    if (random(1) < coin_spawn_chance) {

        // pick lane (avoid repeating previous)
        var clane = irandom(2);
        if (clane == last_coin_lane) clane = (clane + choose(1,2)) mod 3;
        last_coin_lane = clane;

        var cx = lane_x[clane];
        var run_len = irandom_range(coin_run_len_min, coin_run_len_max);

        // spawn a small vertical "train" of coins
        for (var i = 0; i < run_len; i++) {
            // small jitter so trains don't perfectly overlap every time
            var jx = 0; // keep centered on lane; set to irandom_range(-2,2) if you want tiny horizontal wobble
            var jy = i * coin_run_gap_y;
            instance_create_layer(cx + jx, spawn_y - jy, layer, oCoin);
        }
    }
}

// --- COINS (calmer) ---
coin_timer++;

var coin_diff = clamp(1.0 - 0.08 * speed_index, 0.7, 1.0);
var coin_interval = round(coin_base * coin_diff);

// include gem coins in the cap check
if (coin_timer >= coin_interval && (instance_number(oCoin) + instance_number(oGemCoin)) < coin_cap) {
    coin_timer = 0;

    if (random(1) < coin_spawn_chance) {
        var clane = irandom(2);
        if (clane == last_coin_lane) clane = (clane + choose(1,2)) mod 3;
        last_coin_lane = clane;

        var cx = lane_x[clane];
        var run_len = irandom_range(coin_run_len_min, coin_run_len_max);

        // choose ONE gem position in the run (rare)
        var gem_chance = 0.20; // 20% chance this run has a gem
        var gem_i = -1;
        if (random(1) < gem_chance) gem_i = irandom(run_len - 1);

        for (var i = 0; i < run_len; i++) {
            var yy = spawn_y - i * coin_run_gap_y;
            var objc = (i == gem_i) ? oGemCoin : oCoin;
            instance_create_layer(cx, yy, layer, objc);
        }
    }
}

// ---------- hard room restart at 40s ----------
if (run_time_frames >= restart_after) {
    global.restart_count += 1;
    global.track_index   += 1;
    global.bg_shift       = (global.bg_shift + 1) mod 6;

    // show "won" after target_restarts (if > 0)
    if (global.target_restarts > 0 && global.restart_count >= global.target_restarts) {
        global.game_won     = true;
        global.scroll_speed = 0; // freeze movers so banner shows
        exit; // stay in room
    }

    room_restart(); // restart THIS room
}