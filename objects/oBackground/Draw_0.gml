/// oBackground — Draw (unchanged sky + NEW stars under clouds)

// Sky (unchanged)
draw_set_colour(current_color);
draw_rectangle(0, 0, room_width, room_height, false);

// ⭐ Stars UNDER clouds
for (var i = 0; i < array_length(stars); i++) {
    var sx = stars[i][0];
    var sy = stars[i][1];
    var r  = stars[i][4];
    var a  = stars[i][5];

    draw_set_alpha(a * 0.9); // brighter fade
    draw_set_colour(make_color_rgb(255, 230, 120));
    draw_circle(sx, sy, r, false);
}

// ☁️ Clouds ON TOP (unchanged)
draw_set_alpha(0.6);
draw_set_colour(c_white);
for (var j = 0; j < array_length(clouds); j++) {
    var cx = clouds[j][0];
    var cy = clouds[j][1];
    draw_ellipse(cx - 30, cy - 10, cx + 30, cy + 10, false);
}

draw_set_alpha(1);
draw_set_colour(c_white);