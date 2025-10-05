/// oBackground Draw

var night = night_mode;

// --- smooth flat sky (no gradient blocks) ---
if (night)
    draw_clear_alpha(make_color_rgb(10, 15, 30), 1); // dark blue night
else
    draw_clear_alpha(make_color_rgb(130, 190, 250), 1); // light blue day

// --- stars (night) ---
if (night) {
    draw_set_colour(c_white);
    for (var i = 0; i < star_count; i++) {
        draw_rectangle(star_x[i], star_y[i], star_x[i] + 2, star_y[i] + 2, false);
    }
}

// --- clouds (day) ---
if (!night) {
    draw_set_alpha(0.4);
    draw_set_colour(c_white);
    for (var c = 0; c < cloud_count; c++) {
        var cl = cloud[c];
        draw_circle(cl.x, cl.y, cl.s, false);
        draw_circle(cl.x - cl.s * 0.6, cl.y + 4, cl.s * 0.8, false);
        draw_circle(cl.x + cl.s * 0.6, cl.y + 6, cl.s * 0.7, false);
    }
    draw_set_alpha(1);
}

// --- meteors ---
draw_set_colour(make_color_rgb(255, 200, 120));
for (var m = 0; m < ds_list_size(meteor_list); m++) {
    var met = meteor_list[| m];
    for (var t = 0; t < 10; t++) {
        var tx = met.x - lengthdir_x(t * 3, met.ang);
        var ty = met.y - lengthdir_y(t * 3, met.ang);
        draw_circle(tx, ty, max(1, 5 - t * 0.4), false);
    }
}