/// --- oGemShop Draw GUI ---
var gw = display_get_gui_width();
var gh = display_get_gui_height();

/// Glowing centered color shop interface

var gw = display_get_gui_width();
var gh = display_get_gui_height();

draw_set_alpha(fade_alpha);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Title
draw_set_color(merge_color(c_white, c_aqua, 0.3 + 0.2 * sin(current_time / 400)));
draw_text(gw / 2, gh * 0.15, "💎 COLOR SHOP");

// Gems display
draw_set_halign(fa_right);
draw_set_color(c_aqua);
draw_text(gw - 40, 40, "💎 Gems: " + string(global.total_gems));

// Color list
draw_set_halign(fa_center);
for (var i = 0; i < array_length(gem_colors); i++) {
    var yy = gh * 0.35 + i * 55;
    var name = gem_names[i];
    var price = gem_prices[i];
    var col = gem_colors[i];
    var owned = false;

    for (var j = 0; j < array_length(global.unlocked_colors); j++) {
        if (global.unlocked_colors[j] == col) owned = true;
    }

    // Color of text
    var draw_col = (gem_index == i) ? c_lime : c_white;
    draw_set_color(draw_col);

    // Display name and price
    var label = name + " - " + string(price) + " Gems";
    draw_text(gw / 2, yy, label);

    // Draw color swatch
    draw_set_color(col);
    draw_rectangle(gw / 2 - 160, yy - 10, gw / 2 - 120, yy + 10, false);

    // Owned marker
    if (owned) {
        draw_set_color(c_lime);
        draw_text(gw / 2 + 200, yy, "✓ Owned");
    }
}

// Footer
draw_set_color(merge_color(c_gray, c_white, 0.3));
draw_text(gw / 2, gh - 60, "↑↓ Move  |  Enter Buy  |  Esc Back");

draw_set_alpha(1);