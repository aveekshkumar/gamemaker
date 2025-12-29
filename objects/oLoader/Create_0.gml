/// --- oLoader Create Event ---
/// Initializes loading animation and studio branding

progress      = 0;
loading_speed = 0.005;  // smooth & cinematic speed
next_room     = rm_start;

// Circle visuals
radius     = 100;
thickness  = 120;
start_ang  = -90;
bg_col     = make_color_rgb(20,22,28);
ring_bg    = make_color_rgb(60,65,75);
// Replace ring_fg with this dynamic color each frame:
var col_shift = progress * 360 + current_time / 30;
ring_fg = make_color_hsv(frac(col_shift / 360) * 255, 240, 255);

// Glow animation setup
glow_alpha = 0;
glow_dir   = 1; // 1 = fade in, -1 = fade out

// Fade transition setup
fade_alpha = 1;
fade_dir   = -1; // fade in from black

// Studio name glow
studio_glow = 0;
studio_dir  = 1;