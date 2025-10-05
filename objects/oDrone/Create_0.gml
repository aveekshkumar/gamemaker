/// oDrone Create
follow_target = oRunner;    // follow this object
hover_height  = -60;        // offset above the runner
hover_range   = 12;         // small side wiggle
hover_speed   = 0.05;       // speed of that wiggle
pull_radius   = 70;         // how far it collects
pull_power    = 0.28;       // how strong the attraction is
follow_speed  = 0.15;       // smooth follow strength
effect_create_above(ef_ring, x, y, 1, c_aqua);

// --- Tether visuals ---
beam_col = make_color_rgb(150, 255, 150); // light green
beam_width = 5;                              // base thickness
beam_alpha = 0.45;                           // overall opacity
beam_pulse = 0;                              // animation phase

hover_t = irandom(360);