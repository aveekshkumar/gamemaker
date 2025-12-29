/// --- oLogo Create Event ---
/// Aviki.Co logo intro setup

alpha = 0;             // transparency for fade
fade_in_speed  = 0.02; // how fast the logo appears
fade_out_speed = 0.015;
timer = 0;
phase = 0;             // 0 = fade in, 1 = hold, 2 = fade out
next_room = rm_loader; // what comes after