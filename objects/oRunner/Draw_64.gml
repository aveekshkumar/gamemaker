/// --- oRunner Draw GUI ---
// basic setup
draw_set_colour(c_green);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Score (top-left)
draw_sprite(sIconCoin, 0, 10, 10);
draw_text_transformed(35, 10, "Score: " + string(global.score), score_bounce, score_bounce, 0);

// --- Speed display (moved left) ---
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_lime);

// Slight offset below the time counter
draw_text(35, 50 + 40, "Speed: " + string_format(global.scroll_speed, 1, 2));

// Time
var seconds = floor(oSpawner.survival_time / 60);;
var minutes = floor(seconds / 60);
var display_seconds = seconds - (minutes * 60);
draw_sprite(sIconClock, 0, 10, 30);
draw_text(35, 30, "Time: " + string(minutes) + ":" + string(display_seconds));

// Distance (now drawn, not updated)
draw_text(35, 50, "Distance: " + string(floor(distance)));

// Combo counter
var flash_alpha = (global.dodge_count >= global.dodges_needed - 1) ? (0.5 + 0.5 * sin(current_time / 100)) : 1;
draw_set_alpha(flash_alpha);
draw_set_color(c_yellow);
draw_text(10, 70, "Combo: " + string(global.dodge_count) + "/" + string(global.dodges_needed) + "  (x" + string(global.combo) + ")");
draw_set_alpha(1);
draw_set_color(c_green);

// Dash status
draw_text(10, 150, "Dash: " + (dash_cooldown > 0 ? string(ceil(dash_cooldown / 60)) + "s" : "READY"));

// Lane flash ring at bottom
var gw = display_get_gui_width();
var gh = display_get_gui_height();
var baseY   = gh - 28;
var spacing = 48;
var centerX = gw * 0.5;

// lane dots
for (var i = 0; i < 3; i++) {
    var dotX  = centerX + (i - 1) * spacing;
    var rad   = (i == lane) ? 7 : 5;
    var color = (i == lane) ? c_white : c_dkgray;
    draw_set_colour(color);
    draw_circle(dotX, baseY, rad, false);
}

// flash ring
if (lane_flash_t > 0) {
    var flashX   = centerX + (lane - 1) * spacing;
    var alpha    = lane_flash_t / 20.0;
    var ringR    = 10 + (20 - lane_flash_t) * 0.6;
    draw_set_alpha(alpha);
    draw_set_colour(c_yellow);
    draw_circle(flashX, baseY, ringR, false);
    draw_set_alpha(1);
    lane_flash_t--;
}

// HOT LANE HUD
if (hot_timer > 0 && hot_lane >= 0) {
    var hx = centerX + (hot_lane - 1) * spacing;
    draw_set_colour(make_colour_rgb(255, 215, 0));
    draw_set_alpha(0.9);
    draw_circle(hx, baseY, 14, false);
    draw_set_alpha(1);

    var w = 60, h = 6;
    var bx1 = hx - w/2, by1 = baseY + 12, bx2 = hx + w/2, by2 = by1 + h;

    draw_set_colour(c_black); draw_set_alpha(0.5);
    draw_rectangle(bx1, by1, bx2, by2, false);
    draw_set_alpha(1);

    var fill_ratio = hot_timer / (room_speed * 10);
    fill_ratio = clamp(fill_ratio, 0, 1);
    draw_set_colour(make_colour_rgb(255, 215, 0));
    draw_rectangle(bx1, by1, bx1 + w * fill_ratio, by2, false);

    draw_set_colour(c_white);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_text(hx, by1 - 8, "HOT");
}

// ===== Compact Coin HUD (top-right) =====
var gui_w = display_get_gui_width();
var pad   = 6;
var gap   = 4;
var txt   = "Coins: " + string(coins);
var tw    = string_width(txt);
var th    = string_height(txt);

var icon_idx = sCoin;
var has_icon = (icon_idx != -1);
var icon_w   = has_icon ? max(16, sprite_get_width(icon_idx)) : 0;

// pulse on change
if (coin_hud_last != coins) { coin_hud_last = coins; coin_hud_pulse = 1; }
if (coin_hud_pulse > 0) coin_hud_pulse = max(0, coin_hud_pulse - 0.08);

var box_w = pad + (has_icon ? icon_w + gap : 0) + tw + pad;
var box_h = max(th + pad*2, 24);
var bx2 = gui_w - 8;
var bx1 = bx2 - box_w;
var by1 = 8;
var by2 = by1 + box_h;
var cy  = (by1 + by2) * 0.5;

// bg
draw_set_alpha(0.6);
draw_set_colour(c_black);
draw_rectangle(bx1, by1, bx2, by2, false);
draw_set_alpha(1);

// icon
if (has_icon) {
    var s  = 1 + 0.12 * coin_hud_pulse;
    var ix = bx1 + pad + icon_w * 0.5;
    draw_sprite_ext(icon_idx, 0, ix, cy, s, s, 0, c_red, 1);
}

// text
draw_set_colour(c_red);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
var tx = bx1 + pad + (has_icon ? icon_w + gap : 0);
var s_txt = 1 + 0.10 * coin_hud_pulse;
draw_text_transformed(tx, cy, txt, s_txt, s_txt, 0);

//next level in
if (instance_exists(oSpawner)) {
    var sp = oSpawner;
    var secs_passed = sp.run_time_frames / room_speed;
    var secs_left   = max(0, ceil((sp.level_duration / room_speed) - secs_passed));

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_lime);

    var gw = display_get_gui_width();
    draw_text(gw / 1.35, 65, "Next Level in: " + string(secs_left) + "s");
}

// === LEVEL PROGRESS BAR ===
if (instance_exists(oSpawner)) {
    var sp = oSpawner;

    // Progress fraction 0 → 1
    var progress = clamp(global.level_timer / global.level_duration, 0, 1);

    var gw = display_get_gui_width();
    var gh = display_get_gui_height();

    // Bar position & size
    var bar_w = gw * 0.6;   // 60% of screen width
    var bar_h = 10;
    var bar_x = (gw - bar_w) * 0.5;
    var bar_y = gh - 50;

    // Bar background
    draw_set_colour(make_colour_rgb(30, 30, 40));
    draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);

    // Bar fill
    draw_set_colour(c_lime);
    draw_rectangle(bar_x, bar_y, bar_x + bar_w * progress, bar_y + bar_h, false);

    // Text overlay
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text(gw / 2, bar_y - 12, "Level Progress: " + string_format(progress * 100, 2, 0) + "%");
}

// --- Developer Skip Hint ---
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(c_gray);
draw_text(display_get_gui_width() / 2, display_get_gui_height() - 10, "Press K to skip level (dev)");

// Night overlay label
if (night_mode) {
    var gw2 = display_get_gui_width();
    var gh2 = display_get_gui_height();
    draw_set_alpha(0.0); // overlay disabled here; just label
    draw_set_colour(c_black);
    draw_rectangle(0,0,gw2,gh2,false);
    draw_set_alpha(1);
    draw_set_colour(c_lime);
    draw_set_halign(fa_right); draw_set_valign(fa_top);
    draw_text(gw2 - 8, 40, "🌙 NIGHT MODE");
}