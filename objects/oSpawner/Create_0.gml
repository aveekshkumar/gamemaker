/// --- oSpawner Create Event (FINAL) ---\
/// --- oSpawner Create Event (safe globals) ---
if (!variable_global_exists("global.coins_collected")) global.coins_collected = 0;
if (!variable_global_exists("global.total_coins")) global.total_coins = 0;
if (!variable_global_exists("global.obstacles_dodged")) global.obstacles_dodged = 0;
if (!variable_global_exists("global.score")) global.score = 0;
if (!variable_global_exists("global.missions")) global.missions = [];

// --- Safety init for level progression ---
if (!variable_global_exists("level_timer")) global.level_timer = 0;
if (!variable_global_exists("level_duration")) global.level_duration = room_speed * 90; // 90 seconds default

// Stage / Level setup (from coder menu or defaults)
if (!variable_global_exists("stage_index")) global.stage_index = 0;
if (!variable_global_exists("level_index")) global.level_index = 0;

global.total_stages = 5;
global.levels_per_stage = 5;
global.stage_total = 5;

// Duration (per level = 90 seconds)
level_duration = room_speed * 90;

// Difficulty scaling
var base_speed   = 4.5;
var stage_boost  = 0.05 * global.stage_index;
var level_boost  = 0.02 * global.level_index;
global.scroll_speed = base_speed + stage_boost + level_boost;

// Music (safe start)
if (!variable_global_exists("bgm_handle")) global.bgm_handle = -1;
var bgm = sndBackgroundMusic1;
if (global.bgm_handle == -1 || !audio_is_playing(global.bgm_handle)) {
    global.bgm_handle = audio_play_sound(bgm, 1, true);
    audio_sound_gain(global.bgm_handle, 1, 500);
}

// Persistent globals
if (!variable_global_exists("restart_count")) global.restart_count = 0;
if (!variable_global_exists("bg_shift"))      global.bg_shift = 0;
if (!variable_global_exists("game_won"))      global.game_won = false;

// Timers
survival_time   = 0;
run_time_frames = 0;
global.level_timer = 0;

// Banner system
global.level_banner  = "";
global.banner_visible = false;
global.banner_timer  = 0;

// Background color
var hue = (global.stage_index * 60 + global.level_index * 15) mod 255;
global.bg_color = make_color_hsv(hue, 200, 255);

// Lane system (match oRunner)
lane_x  = [80, 160, 240];
spawn_y = -32;

// Obstacle spawn settings
obs_base  = round(room_speed * 0.85);
obs_min   = round(room_speed * 0.35);
obs_timer = 0;

chance_moving_obstacle = 0.30;
chance_double_spawn    = 0.10;

last_obs_lane  = -1;
last_coin_lane = -1;

// Coin spawn settings
coin_base  = round(room_speed * 0.45);
coin_timer = 0;
coin_run_len_min = 2;
coin_run_len_max = 3;
coin_run_gap_y   = 26;
coin_spawn_chance = 0.65;
coin_cap = 14;

// Level tracking
global.current_stage = global.stage_index + 1;
global.current_level = global.level_index + 1;