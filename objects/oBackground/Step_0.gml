/// oBackground — Step (original logic + star twinkle)

// Press L to change background color (unchanged behavior)
if (keyboard_check_pressed(ord("L"))) {
    theme_index  = (theme_index + 1) mod array_length(bg_colors);
    target_color = bg_colors[theme_index];

    // keep the “snap then lerp” feel like before
    current_color = target_color;
}

// Smooth fade toward target (unchanged)
current_color = merge_color(current_color, target_color, lerp_speed);

// Move clouds & wrap (unchanged)
for (var i = 0; i < array_length(clouds); i++) {
    clouds[i][0] -= clouds[i][2];
    if (clouds[i][0] < -64) {
        clouds[i][0] = room_width + irandom_range(0, 100);
        clouds[i][1] = irandom_range(40, 180);
    }
}

// ⭐ Update star twinkle
for (var i = 0; i < array_length(stars); i++) {
    stars[i][2] += stars[i][3];
    var a = 0.5 + 0.5 * sin(degtorad(stars[i][2])); // slightly stronger pulse
    stars[i][5] = clamp(a, 0.4, 1.0);
}