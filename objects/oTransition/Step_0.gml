/// --- oTransition Step Event ---
/// Handles fade in/out animation

if (fading_out) {
    alpha -= fade_speed;
    if (alpha <= 0) {
        alpha = 0;
        fading_out = false;
    }
} else if (next_room != noone) {
    alpha += fade_speed;
    if (alpha >= 1) {
        room_goto(next_room);
    }
}