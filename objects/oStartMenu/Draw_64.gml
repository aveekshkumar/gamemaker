//draw gui
/// --- Energy Sparks (Magical Glow) ---
for (var i = 0; i < array_length(sparkles); i++) {
    var s = sparkles[i];
    s.alpha += choose(-1, 1) * 0.04;
    s.alpha = clamp(s.alpha, 0.3, 1);
    // 🌪 gentle swirl
    s.dir += sin(current_time / 600 + i) * 0.5;
    // movement
    s.y -= s.speed * cos(degtorad(s.dir));
    s.x += s.speed * sin(degtorad(s.dir));
    // wrap edges
    if (s.y < 0) s.y = display_get_gui_height();
    if (s.x < 0) s.x = display_get_gui_width();
    if (s.x > display_get_gui_width()) s.x = 0;
    var col = merge_color(c_aqua, c_white, 0.5 + 0.5 * sin(current_time / 300 + s.x));
    gpu_set_blendmode(bm_add);
    draw_set_alpha(s.alpha);
    draw_set_color(col);
    draw_circle(s.x, s.y, s.size * 1.5, false);
    gpu_set_blendmode(bm_normal);
}
draw_set_alpha(1);

/// --- Draw GUI Event ---
var gw = display_get_gui_width();
var gh = display_get_gui_height();
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

function draw_glow_text(x, y, txt, col) {
    draw_set_color(merge_color(col, c_black, 0.6));
    draw_text_transformed(x + 2, y + 2, txt, 1.05, 1.05, 0);
    draw_set_color(col);
    draw_text(x, y, txt);
}

/// Modernized UI layout
fade_alpha = clamp(fade_alpha + 0.05, 0, 1);
draw_set_alpha(fade_alpha);

var gw = display_get_gui_width();
var gh = display_get_gui_height();

// Title - ENHANCED VERSION
var title_y = gh/4;
var title_scale = 2.5 + 0.3 * sin(current_time / 400);  // 4. PULSE ANIMATION
var title_x = gw/2;

// 3. GLOW EFFECT (multiple layers)
gpu_set_blendmode(bm_add);
draw_set_alpha(0.3);
draw_set_color(c_lime);
draw_text_transformed(title_x, title_y, "BOX DODGE", title_scale * 1.1, title_scale * 1.1, 0);
draw_set_alpha(0.2);
draw_set_color(c_aqua);
draw_text_transformed(title_x, title_y, "BOX DODGE", title_scale * 1.2, title_scale * 1.2, 0);
gpu_set_blendmode(bm_normal);

// 1. BIGGER TEXT SIZE + 2. DIFFERENT COLOR (bright cyan)
draw_set_alpha(1);
draw_set_color(c_aqua);
draw_text_transformed(title_x, title_y, "BOX DODGE", title_scale, title_scale, 0);

// Coins & Gems
draw_glow_text(gw/2, gh/4 + 120, "Coins: " + string(global.total_coins), c_aqua);
draw_glow_text(gw/2, gh/4 + 145, "Gems: " + string(global.total_gems), c_aqua);

// Menu Items
for (var i = 0; i < array_length(menu_items); i++) {
    var yy = gh/2 + i * 40;
    var col = (menu_index == i) ? c_lime : c_white;
    draw_glow_text(gw/2, yy, menu_items[i], col);
}

// Footer Hint
draw_set_color(merge_color(c_gray, c_white, 0.3));
draw_text(gw / 2, gh - 60, "↑↓ Move  |  Enter Select");
draw_set_alpha(1);