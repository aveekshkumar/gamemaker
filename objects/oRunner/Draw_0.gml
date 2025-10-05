/// --- TRAIL DRAW (normal + color burst) ---

// Base color from your customizer
var base_col = trail_colors[trail_color_index];

// If burst active → rainbow colors
var rainbow_speed = 8; // faster color flow
for (var i = 0; i < trail_length; i++) {
    var p = trail_points[i];
    if (is_array(p) && p[0] != -1) {
        var t = i / trail_length;
        var alpha = (1 - t) * 0.6;
        var size  = 10 - (i / 2);

        var col;

        if (burst_active) {
            // Hue shift by trail index & time
            var hue = (current_time / (rainbow_speed * 1000) + t) mod 1;
            col = make_color_hsv(hue * 255, 240, 255); // rainbow color
            alpha *= 0.8;
        } else {
            col = base_col;
        }

        draw_set_alpha(alpha);
        draw_set_colour(col);
        draw_circle(p[0], p[1], size, false);
    }
}
draw_set_alpha(1);
draw_set_colour(c_white);

//runner - sprite
draw_self();