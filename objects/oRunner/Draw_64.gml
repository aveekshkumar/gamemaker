draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Draw coin icon and score
draw_sprite(sIconCoin, 0, 10, 10);
draw_text(35, 10, "Score: " + string(global.score));

// Draw clock icon and time
var seconds = floor(oSpawner.survival_time / 60);
var minutes = floor(seconds / 60);
var display_seconds = seconds - (minutes * 60);
draw_sprite(sIconClock, 0, 10, 30);
draw_text(35, 30, "Time: " + string(minutes) + ":" + string(display_seconds));

// Flash combo counter when close
if dodge_count >= dodges_needed - 1 {
    var flash_alpha = (sin(current_time / 100) + 1) / 2;
    draw_set_alpha(flash_alpha);
    draw_set_color(c_yellow);
}
draw_text(10, 50, "Combo: " + string(dodge_count) + "/" + string(dodges_needed));
draw_set_alpha(1);
draw_set_color(c_white);

draw_text(0, 100, "Distance: " + string_format(distance, 0, 0) + "m");

draw_text(0, 150, "Dash: " + (dash_cooldown > 0 ? string(ceil(dash_cooldown / 60)) + "s" : "READY"));

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

//lane flash
if (lane_flash_t > 0) {
    var cx = gui_w/2 + (lane-1)*60; // adjust spacing if needed
    var cy = gui_h - 40;
    var alpha = lane_flash_t / 20.0;

    draw_set_alpha(alpha);
    draw_set_colour(c_yellow);
    draw_circle(cx, cy, 12, false);
    draw_set_alpha(1);

    lane_flash_t--;
}

// === Lane markers (bottom HUD) ===
var gw = display_get_gui_width();
var gh = display_get_gui_height();

var baseY   = gh - 28;   // vertical position of the markers
var spacing = 48;        // distance between dots
var centerX = gw * 0.5;

// draw 3 base dots
for (var i = 0; i < 3; i++) {
    var dotX  = centerX + (i - 1) * spacing;
    var rad   = (i == lane) ? 7 : 5;
    var color = (i == lane) ? c_white : c_dkgray;

    draw_set_colour(color);
    draw_circle(dotX, baseY, rad, false);
}

// (improved) lane flash ring on current lane
if (lane_flash_t > 0) {
    var flashX   = centerX + (lane - 1) * spacing;
    var alpha    = lane_flash_t / 20.0;
    var ringR0   = 10;                       // starting radius
    var ringR    = ringR0 + (20 - lane_flash_t) * 0.6;  // expand a bit

    draw_set_alpha(alpha);
    draw_set_colour(c_yellow);
    draw_circle(flashX, baseY, ringR, false);
    draw_set_alpha(1);

    lane_flash_t--;
}

// ===== HOT LANE HUD =====
var gw = display_get_gui_width();
var gh = display_get_gui_height();

// Position must match your lane dots; tweak spacing/baseY if needed
var baseY   = gh - 28;
var spacing = 48;
var centerX = gw * 0.5;

// Gold ring & timer on the hot lane
if (hot_timer > 0 && hot_lane >= 0) {
    var hx = centerX + (hot_lane - 1) * spacing;

    // outer gold ring
    draw_set_colour(make_colour_rgb(255, 215, 0)); // gold
    draw_set_alpha(0.9);
    draw_circle(hx, baseY, 14, false);
    draw_set_alpha(1);

    // small timer bar under the dots
    var seconds_left = ceil(hot_timer / room_speed);
    var w = 60; var h = 6;
    var bx1 = hx - w/2, by1 = baseY + 12, bx2 = hx + w/2, by2 = by1 + h;

    // background
    draw_set_colour(c_black);
    draw_set_alpha(0.5);
    draw_rectangle(bx1, by1, bx2, by2, false);
    draw_set_alpha(1);

    // fill based on remaining time (0..1)
    var fill_ratio = hot_timer / (room_speed * 10);
    fill_ratio = clamp(fill_ratio, 0, 1); // safety
    draw_set_colour(make_colour_rgb(255, 215, 0));
    draw_rectangle(bx1, by1, bx1 + w * fill_ratio, by2, false);

    // label
    draw_set_colour(c_white);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_text(hx, by1 - 8, "HOT");
}

//one variable setup
var gui_w = display_get_gui_width();

// ===== Compact Coin HUD (top-right, safe & auto-size) =====
var gui_w = display_get_gui_width();

// 1) Detect change & pulse (do this right here; Draw GUI is fine)
if (coin_hud_last != coins) {
    coin_hud_last  = coins;
    coin_hud_pulse = 1;               // trigger a small pulse
}
// decay pulse (no 'static' used)
if (coin_hud_pulse > 0) coin_hud_pulse = max(0, coin_hud_pulse - 0.08);

// 2) Text & optional icon
var pad   = 6;                        // inner padding
var gap   = 4;                        // space between icon and text
var txt   = "Coins: " + string(coins);
var tw    = string_width(txt);
var th    = string_height(txt);

// Safe icon lookup (won’t crash if sprite doesn’t exist)
var icon_idx = asset_get_index("spr_coin");   // use your sprite name here if you have one
var has_icon = (icon_idx != -1);
var icon_w   = 0;
if (has_icon) icon_w = max(16, sprite_get_width(icon_idx));

// 3) Auto-size box
var box_w = pad + (has_icon ? icon_w + gap : 0) + tw + pad;
var box_h = max(th + pad*2, 24);

// Position (top-right, 8px margin)
var bx2 = gui_w - 8;
var bx1 = bx2 - box_w;
var by1 = 8;
var by2 = by1 + box_h;

// 4) Background rectangle (simple for max compatibility)
draw_set_alpha(0.6);
draw_set_colour(c_black);
draw_rectangle(bx1, by1, bx2, by2, false);
draw_set_alpha(1);

// Center Y inside the box
var cy = (by1 + by2) * 0.5;

// 5) Draw icon (if present) with a little pulse scale
if (has_icon) {
    var s  = 1 + 0.12 * coin_hud_pulse;
    var ix = bx1 + pad + icon_w * 0.5;
    draw_sprite_ext(icon_idx, 0, ix, cy, s, s, 0, c_white, 1);
}

// 6) Draw text with tiny pulse
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
var tx    = bx1 + pad + (has_icon ? icon_w + gap : 0);
var s_txt = 1 + 0.10 * coin_hud_pulse;

// If your GameMaker supports it, this gives a nice scale effect:
draw_text_transformed(tx, cy, txt, s_txt, s_txt, 0);

// If draw_text_transformed isn’t available in your version, comment the line above
// and uncomment the simple fallback below:
// draw_text(tx, cy, txt);
// ===== /Coin HUD =====

// draw text "Coins: N"
draw_set_colour(c_white);
draw_set_halign(fa_right);
draw_set_valign(fa_middle);
draw_text(gui_w - 16, 24, "Coins: " + string(coins));

if (popup_timer > 0) {
    draw_set_colour(c_yellow);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var alpha = popup_timer / 30.0;        // fade out
    draw_set_alpha(alpha);

    // convert runner position to GUI coordinates
    var vx = camera_get_view_x(view_camera[0]);
    var vy = camera_get_view_y(view_camera[0]);
    var px = x - vx;
    var py = y - vy;

    // rise up a bit while fading (moves ~15px up)
    var rise = (30 - popup_timer) * 0.5;

    draw_text(px, py - 40 - rise, popup_text);

    draw_set_alpha(1);
    popup_timer -= 1;
}

if (night_mode) {
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();

    draw_set_alpha(0.35);                 // semi-dark overlay
    draw_set_colour(c_black);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    draw_set_colour(c_lime);
    draw_set_halign(fa_right); draw_set_valign(fa_top);
    draw_text(gw - 8, 40, "🌙 NIGHT MODE");
}

// --- Magnet UI (top-left) ---
var gx = 90, gy = 300;
var w = 100, h = 10;

// state vars (avoid using 'frac' as a name)
var mag_label;
var mag_color;
var mag_fill = 0; // 0..1

if (magnet_active) {
    mag_label = "Magnet ON";
    mag_color = c_lime;
    mag_fill  = magnet_time / max(1, magnet_time_max);
} else if (magnet_cd > 0) {
    mag_label = "Recharging";
    mag_color = make_color_rgb(200,200,200);
    mag_fill  = 1 - (magnet_cd / max(1, magnet_cd_max));
} else {
    mag_label = "Ready (E)";
    mag_color = make_color_rgb(150,220,255);
    mag_fill  = 1;
}

// frame
draw_set_colour(c_white);
draw_rectangle(gx-1, gy-1, gx+w+1, gy+h+1, false);

// fill
draw_set_colour(mag_color);
draw_rectangle(gx, gy, gx + w * clamp(mag_fill, 0, 1), gy + h, false);

// label
draw_set_colour(c_white);
draw_text(gx, gy - 12, mag_label);

// Countdown until restart (top-center)
if (instance_exists(oSpawner)) {
    var sp = oSpawner;
    var secs_left = max(0, ceil((sp.restart_after - sp.run_time_frames) / room_speed));
    draw_set_halign(fa_center); draw_set_valign(fa_top);
    draw_set_colour(secs_left <= 5 ? c_red : c_white);
    draw_text(display_get_gui_width()/2, 65, "Restart in: " + string(secs_left) + "s");
}

// Optional win banner if you enabled target_restarts
if (variable_global_exists("game_won") && global.game_won) {
    var gw = display_get_gui_width(), gh = display_get_gui_height();
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_set_colour(c_yellow); draw_set_alpha(0.9);
    draw_text(gw/2, gh/2 - 20, "GAME WON!");
    draw_set_alpha(1);
}

var gw = display_get_gui_width();
var gh = display_get_gui_height();

if (game_paused) {
    draw_set_alpha(0.6); draw_set_colour(c_black);
    draw_rectangle(0,0,gw,gh,false); draw_set_alpha(1);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text(gw/2, gh/2, "PAUSED — Press P");
}