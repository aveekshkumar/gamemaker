/// --- oLogo Step Event ---
/// Handles fade timing and transitions

switch (phase) {
    case 0: // fade in
        alpha += fade_in_speed;
        if (alpha >= 1) { alpha = 1; phase = 1; timer = 120; } // hold 2 seconds
        break;

    case 1: // hold
        timer--;
        if (timer <= 0) phase = 2;
        break;

    case 2: // fade out
        alpha -= fade_out_speed;
        if (alpha <= 0) {
            alpha = 0;
            room_goto(next_room);
        }
        break;
}