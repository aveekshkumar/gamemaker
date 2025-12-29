// oBackgroundPixels Draw GUI Event
draw_set_color(c_lime);
for (var i = 0; i < array_length(pixels); i++) {
    var px = pixels[i];
    draw_set_alpha(px.alpha);
    var size = px.size * 10;
    draw_rectangle(px.x, px.y, px.x + size, px.y + size, false);
}
draw_set_alpha(1);
draw_set_color(c_white);