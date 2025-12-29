// Pause check
if (global.game_paused) exit;

if (variable_global_exists("game_won") && global.game_won) exit;

if (variable_global_exists("scroll_speed")) y += global.scroll_speed;

if (y > room_height + 40) instance_destroy();

/// oCoin Step
pulse_t += pulse_speed;