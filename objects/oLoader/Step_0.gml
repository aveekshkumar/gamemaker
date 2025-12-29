/// --- oLoader Step Event ---
/// Handles progress, glow animations, and transitions

// Progress logic
progress = clamp(progress + loading_speed, 0, 1);

// --- Glow for the green ring ---
glow_alpha += glow_dir * 0.03;
if (glow_alpha > 1) { 
    glow_alpha = 1; 
    glow_dir = -1; 
}
if (glow_alpha < 0.2) { 
    glow_alpha = 0.2; 
    glow_dir = 1; 
}

// --- Studio text glow (slower pulse) ---
studio_glow += studio_dir * 0.015;
if (studio_glow > 1) { 
    studio_glow = 1; 
    studio_dir = -1; 
}
if (studio_glow < 0.3) { 
    studio_glow = 0.3; 
    studio_dir = 1; 
}

// --- Fade in/out logic ---
fade_alpha = clamp(fade_alpha + fade_dir * 0.03, 0, 1);

// --- When loading completes, begin fade out ---
if (progress >= 1) {
    fade_dir = 1;
    if (fade_alpha >= 1) {
    draw_clear(c_white);
    room_goto(next_room);
    }
}