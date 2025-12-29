/// --- oShop Draw GUI Event ---
var gw = display_get_gui_width();
var gh = display_get_gui_height();

/// Draw shop UI and options
var gw = display_get_gui_width();
var gh = display_get_gui_height();

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Background
draw_set_color(shop_color);
draw_rectangle(0, 0, gw, gh, false);

// Title
draw_set_color(c_white);
draw_text(gw/2, gh/6, "🛒 SHOP");

// Coin Display
draw_set_color(c_yellow);
draw_text(gw/2, gh/6 + 60, "Coins: " + string(global.total_coins));

// Shop Items
for (var i = 0; i < array_length(shop_items); i++) {
    var yy = gh/3 + i * 60;

    if (i == shop_index) draw_set_color(c_lime);
    else draw_set_color(c_white);

    var item = shop_items[i];
    var name = item[0];
    var cost = item[1];
    var desc = item[2];

    draw_text(gw/2, yy, name + " - " + string(cost) + " coins");
    draw_set_color(c_ltgray);
    draw_text(gw/2, yy + 24, desc);
}

// Footer
draw_set_color(c_gray);
draw_text(gw/2, gh - 40, "↑↓ Move  |  Enter Buy  |  Esc Back");