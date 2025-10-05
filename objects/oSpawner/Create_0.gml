/// oSpawner → Create  (FULL)

// --- Background Music (robust, no master-gain calls) ---
if (!variable_global_exists("bgm_handle")) global.bgm_handle = -1;

// Replace snd_music with your actual BGM asset name
var bgm = sndBackgroundMusic;

// Only start if not already playing (survives room_restart)
if (global.bgm_handle == -1 || !audio_is_playing(global.bgm_handle)) {
    global.bgm_handle = audio_play_sound(bgm, 1, true); // loop = true
    // Optional: fade in nicely over 0.5s
    audio_sound_gain(global.bgm_handle, 1, 500);
}

// ---------- Globals that persist across restarts ----------
if (!variable_global_exists("restart_count"))    global.restart_count    = 0;
if (!variable_global_exists("track_index"))      global.track_index      = 0;
if (!variable_global_exists("bg_shift"))         global.bg_shift         = 0;
if (!variable_global_exists("game_won"))         global.game_won         = false;
// Show "You Won!" after this many restarts (set 0 to disable win)
if (!variable_global_exists("target_restarts"))  global.target_restarts  = 4;

// ---------- Speed schedule (fits inside 40s) ----------
speed_schedule = [5, 6.5, 7, 7.5];  // speeds at 0s, 10s, 20s, 30s
speed_index    = 0;
bump_interval  = room_speed * 10; // 10 seconds per bump
next_bump_at   = bump_interval;
survival_time  = 0;

global.scroll_speed = speed_schedule[0];

// ---------- Hard room restart after 40 seconds ----------
run_time_frames = 0;
restart_after   = room_speed * 40;

// ---------- (Optional) music per run ----------
// Replace snd_track1..4 with your real assets or delete this block.
/*
var track_list = [ snd_track1, snd_track2, snd_track3, snd_track4 ];
if (array_length(track_list) > 0) {
    var t_idx = global.track_index mod array_length(track_list);
    audio_stop_all();
    audio_play_sound(track_list[t_idx], 1, true);
}
*/

// ---------- Spawner setup ----------

// lanes (match your runner)
lane_x  = [80, 160, 240];
spawn_y = -32;

// remember last lanes to avoid immediate repeats
last_obs_lane  = -1;
last_coin_lane = -1;

// ---- OBSTACLE spawn timing (frames)
obs_base  = round(room_speed * 0.85); // ~0.85s base at stage 0
obs_min   = round(room_speed * 0.35); // never faster than ~0.35s
obs_timer = 0;

// chance knobs
chance_moving_obstacle = 0.30; // 30% moving vs normal
chance_double_spawn     = 0.10; // 10% chance to spawn two obstacles

// ---- COIN spawn timing (CALMER) ----
coin_base  = round(room_speed * 1.90); // slower than before (was 0.55)
coin_timer = 0;

// shorter trains
coin_run_len_min = 2;
coin_run_len_max = 3;
coin_run_gap_y   = 26;

// probability gate so not every window spawns coins
coin_spawn_chance = 0.65;

// hard cap on simultaneous coins on screen
coin_cap = 14;