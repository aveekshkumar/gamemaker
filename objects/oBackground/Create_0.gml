/// oBackground — Create (original color cycle + clouds + stars)

// --- Color themes (same as before) ---
bg_colors = [
    make_color_rgb(80, 180, 255),   // Day
    make_color_rgb(255, 170, 100),  // Sunset
    make_color_rgb(40, 50, 90),     // Night
    make_color_rgb(120, 220, 180)   // Mint Morning
];

// Cycle on room restart (unchanged)
if (!variable_global_exists("restart_theme")) global.restart_theme = 0;
global.restart_theme = (global.restart_theme + 1) mod array_length(bg_colors);

// Start from the restart theme (unchanged)
theme_index   = global.restart_theme;
current_color = bg_colors[theme_index];
target_color  = current_color;
lerp_speed    = 0.20; // unchanged quick fade

// Clouds (unchanged)
clouds = [];
for (var i = 0; i < 6; i++) {
    var cx = irandom_range(0, room_width);
    var cy = irandom_range(40, 200);
    var sp = random_range(0.3, 0.8);
    array_push(clouds, [cx, cy, sp]);
}

// ⭐ Twinkling stars (slightly bigger and brighter)
stars = [];
var star_count = 25;
for (var s = 0; s < star_count; s++) {
    var sx     = irandom_range(0, room_width);
    var sy     = irandom_range(room_height * 0.18, room_height * 0.42);
    var phase  = irandom(360);
    var spd  = random_range(0.6, 1.2);
    var radius = random_range(1.5, 2.5); // 🌟 bigger than before
    array_push(stars, [sx, sy, phase, speed, radius, 1]);
}