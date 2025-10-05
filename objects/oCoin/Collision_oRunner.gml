with (other) {
    coins += 1;
    global.score += 50;   // ← make sure this line exists
    score = global.score;
    popup_text  = "+1";
    popup_timer = 30;
}
instance_destroy();