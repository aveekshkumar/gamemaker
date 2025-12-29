/// --- oGameOver Draw GUI Event ---
var gw = display_get_gui_width();
var gh = display_get_gui_height();

draw_set_halign(fa_center);
draw_text(gw/2, gh/4, "💀 GAME OVER 💀");

for (var i = 0; i < array_length(menu_items); i++) {
    var yy = gh/2 + i * 50;
    draw_set_color(i == menu_index ? c_red : c_white);
    draw_text(gw/2, yy, menu_items[i]);
}

draw_set_color(c_gray);
draw_text(gw/2, gh - 40, "↑↓ Move  |  Enter Select");