/// oDrone Step (fixed)

// Smooth follow
if (instance_exists(follow_target)) {
    var tx = follow_target.x;
    var ty = follow_target.y + hover_height + sin(hover_t) * hover_range;
    x += (tx - x) * follow_speed;
    y += (ty - y) * follow_speed;
}

// Hover animation
hover_t += hover_speed * room_speed;

// Make sure the drone knows who to give points to
var runner = instance_exists(follow_target) ? follow_target : noone;

// animate the tether a tiny bit
beam_pulse += 0.15;
beam_col = merge_color(make_color_rgb(120, 255, 120), make_color_rgb(180, 255, 200), 0.5 + 0.5 * sin(beam_pulse * 0.5));

// --- Auto collect normal coins ---
with (oCoin) {
    var dx = other.x - x;
    var dy = other.y - y;
    if (dx*dx + dy*dy <= sqr(other.pull_radius)) {
        var d = max(1, point_distance(x, y, other.x, other.y));
        x += (dx / d) * other.pull_power * 10;
        y += (dy / d) * other.pull_power * 10;

        if (point_distance(x, y, other.x, other.y) < 6) {
            if (instance_exists(other.follow_target)) {
                with (other.follow_target) {
                    coins += 1;
                    if (variable_global_exists("score")) global.score += 50;
                    popup_text = "+1 (Drone)";
                    popup_timer = 30;
                }
            }
            instance_destroy();
        }
    }
}

// --- Auto collect gem coins ---
with (oGemCoin) {
    var dx = other.x - x;
    var dy = other.y - y;
    if (dx*dx + dy*dy <= sqr(other.pull_radius)) {
        var d = max(1, point_distance(x, y, other.x, other.y));
        x += (dx / d) * other.pull_power * 10;
        y += (dy / d) * other.pull_power * 10;

        if (point_distance(x, y, other.x, other.y) < 6) {
            if (instance_exists(other.follow_target)) {
                with (other.follow_target) {
                    coins += 5;
                    if (variable_global_exists("score")) global.score += 500;
                    popup_text = "+GEM (Drone)";
                    popup_timer = 45;
                }
            }
            instance_destroy();
        }
    }
}