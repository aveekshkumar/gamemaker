// oBackgroundPixels Draw GUI Event
for (var i = 0; i < array_length(pixels); i++) {
    var px = pixels[i];
    draw_set_alpha(px.alpha);
    
    // DUOTONE - Green to Yellow
    var green_col = make_color_rgb(0, 255, 0);
    var yellow_col = make_color_rgb(255, 255, 0);
    var blend = (px.y / room_height);  // Blend based on Y position
    var pixel_col = merge_color(green_col, yellow_col, blend);
    
    draw_set_color(pixel_col);
    var size = px.size * 10;
    draw_rectangle(px.x, px.y, px.x + size, px.y + size, false);
}
draw_set_alpha(1);
draw_set_color(c_white);