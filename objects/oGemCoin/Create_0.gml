scroll_speed = 6;

// Use lane system
lane_x[0] = 80;
lane_x[1] = 160; 
lane_x[2] = 240;

lane = irandom(2);
x = lane_x[lane];
y = -32;

// breathing animation settings
base_scale  = 1.0;     // 1.0 = draw at true sprite size
pulse_amp   = 0.28;    // how much it grows/shrinks (0.22 ≈ 16px → ~19.5px)
pulse_speed = 0.18;    // how fast it “breathes”
pulse_t     = irandom_range(0, 360); // randomize phase so coins don't sync

// soft glow
glow_alpha  = 0.28;    // transparency of glow
glow_rings  = 5;       // how many soft rings to draw
glow_spread = 3.0;     // how far the glow extends

depth = -15; // In front of everything