// oFirework Draw

if (life < explode_time) {
    // rocket glow
    draw_set_colour(color_main);
    draw_set_alpha(1 - (life / explode_time));
    draw_circle(x, y, 3, true);
    draw_set_alpha(1);
} else {
    var t = (life - explode_time) / 60;
    var fade = 1 - t;
    for (var i = 0; i < array_length(particles); i++) {
        var p = particles[i];
        draw_set_colour(color_main);
        draw_set_alpha(fade);
        draw_circle(x + p[0], y + p[1], 2, true);
    }
    draw_set_alpha(1);
}