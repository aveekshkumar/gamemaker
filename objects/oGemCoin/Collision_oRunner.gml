with (other) {
    coins += 5;
    global.score += 10;  // ← gem points
    score = global.score;
    popup_text  = "+GEM!";
    popup_timer = 45;
}
instance_destroy();