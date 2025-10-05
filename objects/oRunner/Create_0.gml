// Ensure global score exists once
if (!variable_global_exists("score")) global.score = 0;

// local mirror used by your HUD (optional)
score = global.score;

// Simple lane system - hardcode the positions
lane_x[0] = 80;  // Left lane
lane_x[1] = 160; // Middle lane  
lane_x[2] = 240; // Right lane

lane = 1; // Start in middle lane
x = lane_x[lane];
y = 700;

// HOT LANE system
hot_lane     = -1;                          // 0/1/2 when active
hot_timer    = 0;                           // frames left while hot
hot_gap      = round(room_speed * 5);       // 5s gap before the next hot lane
hot_cooldown = 0;                           // frames left before next hot lane
hot_tick     = 0;  // accumulates time for +1 coin/second

// --- TRAIL SYSTEM ---
trail_length = 25;           // how many trail points are stored
trail_timer  = 0;
trail_gap    = 2;            // delay between points
trail_points = array_create(trail_length, [-1,-1]); // x,y pairs
trail_color_index = 0; // start color (dark blue)
trail_colors = [
    make_color_rgb(50, 100, 255),   // dark blue
    make_color_rgb(255, 60, 60),    // red
    make_color_rgb(255, 160, 60),   // orange
    make_color_rgb(255, 255, 80),   // yellow
    make_color_rgb(60, 255, 120)    // green
];

// --- Perfect Run Glow ---
glow_timer     = 0;                        // counts frames survived without a hit
glow_threshold = room_speed * 25;          // 25 seconds
glow_factor    = 0;                        // 0..1 visual intensity
glow_rise      = 0.012;                    // how fast it ramps up after threshold
glow_fall      = 0.035;                    // how fast it fades when broken
hit_obstacle   = false;                    // set true on obstacle collision

// --- Color Burst Trail ---
burst_active   = false;           // is the burst happening?
burst_timer    = 0;               // counts how long it's been active
burst_length   = room_speed * 3;  // lasts 3 seconds
burst_next_at  = 1000;            // first trigger at 1000 score
burst_interval = 1000;            // triggers every 1000 points after that

//box upgrading
// Coin HUD helpers (no 'static' needed)
coin_hud_last  = -1;
coin_hud_pulse = 0;

night_mode = false;   // start in day mode

global.scroll_speed = 0.24;   // starting speed

//distance
distance = 0; //needed for distance counter

//coins
coins = 0;           // start with zero coins
popup_timer = 0;
popup_text = "";
popup_scale = 1;     

move_speed = 10;
is_jumping = false;
jump_height = 0;
jump_speed = 6.25;
grav = 0.4;
depth = -10;
score = 0;

shadow_scale = 1;

lane_flash_t = 0;

//dash
dash_cooldown = 0; // Cooldown timer
dash_active = false; // Is dash currently active
dash_duration = 0; // How long dash has been active
dash_start_y = 0; // Y position before dash

// --- Coin Magnet (update for all lanes) ---
magnet_active   = false;
magnet_power    = 0.30;
magnet_time_max = round(room_speed * 5);
magnet_time     = 0;
magnet_cd_max   = round(room_speed * 15);
magnet_cd       = 0;

// --- Spawn helper drone ---
if (!instance_exists(oDrone)) {
    instance_create_layer(x, y - 60, layer, oDrone);
}

// BIGGER, OVAL-SHAPED REACH: covers all lanes & a tall vertical window
magnet_rx = 180;   // horizontal reach (lanes are at 80 / 160 / 240 → 160px span)
magnet_ry = 260;   // vertical reach (pull coins well above/below)

image_speed = 0.5;

//death shake
shake_magnitude = 0;
shake_length = 0;
death_timer = 0;

part_system = part_system_create();
part_dust = part_type_create();

// Set up more visible dust particle
part_type_shape(part_dust, pt_shape_circle);
part_type_size(part_dust, 0.5, 1.5, 0, 0);
part_type_color1(part_dust, c_white);
part_type_alpha2(part_dust, 1, 0);
part_type_speed(part_dust, 2, 5, 0, 0);
part_type_direction(part_dust, 80, 100, 0, 0);
part_type_gravity(part_dust, 0.1, 270);
part_type_life(part_dust, 20, 40);

game_paused = false;

dodge_count = 0;
dodge_counter = 1; // Tracks how many combos you've completed
dodges_needed = 5; // How many dodges needed for next combo