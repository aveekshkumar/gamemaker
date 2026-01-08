/// --- oRunner Create Event ---
/// Reset coins for this run
coins = 0;
gems = 0;

// ✅ LOAD total coins from file for HUD display
if (file_exists("save.ini")) {
    ini_open("save.ini");
    global.total_coins = ini_read_real("PlayerData", "TotalCoins", 0);
    global.total_gems = ini_read_real("PlayerData", "Gems", 0);
    ini_close();
    show_debug_message("✅ oRunner loaded from file: total_coins=" + string(global.total_coins));
    show_debug_message("🔍 FILE CHECK: File exists? YES | Loaded value: " + string(global.total_coins));  // ← ADD THIS
} else {
    global.total_coins = 0;
    global.total_gems = 0;
    show_debug_message("🔍 FILE CHECK: File exists? NO");  // ← ADD THIS
}

show_debug_message("🔍 oRunner Created! coins reset to: " + string(coins) + " | total_coins: " + string(global.total_coins));

/// --- Ensure global pause flag exists ---
if (!variable_global_exists("game_paused")) {
    global.game_paused = false;
}

/// --- Set runner color based on saved player color ---
if (!variable_global_exists("player_color")) {
    global.player_color = c_white;
}

self.color = global.player_color;

// Ensure globals
if (!variable_global_exists("score"))        global.score        = 0;
if (!variable_global_exists("scroll_speed")) global.scroll_speed = 0.24;

// Load multiplier
ini_open(global.save_path);
global.score_mult = ini_read_real("PlayerData", "ScoreMult", 1);
ini_close();

// Distance
distance = 0;

// --- Aura setup ---
aura_min_score = 2000;
aura_strength  = 0;
aura_rise      = 0.05;
aura_fall      = 0.08;
aura_pulse_t   = 0;
aura_radius    = 0;
aura_active    = false;
aura_color     = make_color_rgb(80, 200, 255);

// --- Core stats ---
global.score = 0;
score        = global.score;
move_speed   = 10;
depth        = -10;

// Simple lane setup
lane_x[0] = 80;
lane_x[1] = 160;
lane_x[2] = 240;
lane = 1;
x = lane_x[lane];
y = 700;

// Jumping
is_jumping   = false;
jump_height  = 0;
jump_speed   = 6.25;
grav         = 0.4;
was_airborne = false;

// Shockwave
shockwave_active = false;
shockwave_timer  = 0;
shockwave_radius = 0;
shockwave_max    = 28;

// Hot lane system
hot_lane     = -1;
hot_timer    = 0;
hot_gap      = round(room_speed * 5);
hot_cooldown = 0;
hot_tick     = 0;

// Trail system
trail_length = 25;
trail_timer  = 0;
trail_gap    = 2;
trail_points = array_create(trail_length, [-1,-1]);
trail_color_index = 0;
trail_colors = [
    make_color_rgb(50, 100, 255),
    make_color_rgb(255, 60, 60),
    make_color_rgb(255, 160, 60),
    make_color_rgb(255, 255, 80),
    make_color_rgb(60, 255, 120)
];

// Perfect Run Glow
glow_timer     = 0;
glow_threshold = room_speed * 25;
glow_factor    = 0;
glow_rise      = 0.012;
glow_fall      = 0.035;
hit_obstacle   = false;

// Color Burst Trail
burst_active   = false;
burst_timer    = 0;
burst_length   = room_speed * 3;
burst_next_at  = 1000;
burst_interval = 1000;
burst_strength = 0;
burst_rise     = 0.06;
burst_fall     = 0.08;

// Coins + Popup
popup_timer  = 0;
popup_text   = "";
popup_scale  = 1;

// Magnet
magnet_active   = false;
magnet_power    = 0.30;
magnet_time_max = round(room_speed * 5);
magnet_time     = 0;
magnet_cd_max   = round(room_speed * 15);
magnet_cd       = 0;
magnet_rx       = 180;
magnet_ry       = 260;

/// --- APPLY SHOP UPGRADES ---
if (!variable_global_exists("owned_speed"))  global.owned_speed  = 0;
if (!variable_global_exists("owned_shield")) global.owned_shield = 0;
if (!variable_global_exists("owned_aura"))   global.owned_aura   = 0;

if (global.owned_speed == 1) {
    move_speed *= 1.5;
    global.scroll_speed *= 1.5;
}

// Shield state
shield_active = (global.owned_shield == 1);

// Drone spawn
if (!instance_exists(oDrone)) instance_create_layer(x, y - 60, layer, oDrone);

// Night + Game control
night_mode   = false;
game_paused  = false;
global.scroll_speed = 0.24;

// game-over handoff flag
waiting_gameover = false;

// Shake
shake_time  = 0;
shake_mag   = 0;
shake_decay = 0.9;
shake_ox    = 0;
shake_oy    = 0;

// Particles
part_system = part_system_create();
part_dust = part_type_create();
part_type_shape(part_dust, pt_shape_circle);
part_type_size(part_dust, 0.5, 1.5, 0, 0);
part_type_color1(part_dust, c_white);
part_type_alpha2(part_dust, 1, 0);
part_type_speed(part_dust, 2, 5, 0, 0);
part_type_direction(part_dust, 80, 100, 0, 0);
part_type_gravity(part_dust, 0.1, 270);
part_type_life(part_dust, 20, 40);

// Combo system
dodge_count   = 0;
dodge_counter = 1;
dodges_needed = 5;

// Dash
dash_cooldown = 0;
dash_active   = false;
dash_duration = 0;
dash_start_y  = 0;

// Death / misc
death_timer  = 0;
shadow_scale = 1;
lane_flash_t = 0;

// Score HUD bounce
score_display = global.score;
score_bounce = 1;  // Scale factor

// Coin HUD pulse
coin_hud_last  = coins;
coin_hud_pulse = 0;

// --- Energy Trail Setup ---
trail_max_points = 45;
trail_gap        = 4;
trail_timer      = 0;
trail_points     = array_create(trail_max_points, [x, y]);

// ✅ Mark initialization complete
runner_init_complete = true;