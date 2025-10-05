// Pause check
if instance_exists(oRunner) && oRunner.game_paused { exit; }

warning_duration--;

// Flash effect
alpha -= flash_speed;
if alpha <= 0.3 || alpha >= 1 {
    flash_speed *= -1; // Reverse direction
}

// Position at linked obstacle's lane
if instance_exists(linked_obstacle) {
    x = linked_obstacle.x;
}

// Destroy when warning time is up
if warning_duration <= 0 {
    instance_destroy();
}