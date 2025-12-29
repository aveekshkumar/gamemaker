/// --- oObstacle Collision with oRunner ---
/// Handles shield, jumping immunity, and death logic

// 1️⃣ Ignore collision if runner is jumping
if (other.is_jumping) {
    exit; // no hit while in air
}

// 2️⃣ If runner has shield active
if (global.owned_shield == 1 && other.shield_active)
{
    // Shield absorbs the impact
    other.shield_active = false;
    global.owned_shield = 0; // consumed once

    // Save updated shield state
    ini_open("save.ini");
    ini_write_real("ShopData", "ShieldOwned", 0);
    ini_close();

    // Visual feedback
    instance_create_layer(other.x, other.y - 32, "Instances", oFirework);

    // Optional sound effect
    //if (sound_exists(snd_shield_break)) audio_play_sound(snd_shield_break, 1, false);

    show_debug_message("🛡️ Shield absorbed the obstacle!");
    instance_destroy(); // destroy obstacle only
    exit;
}

// 3️⃣ If no shield → trigger death
if (other.death_timer <= 0)
{
    // Optional small screen flash or particles
    instance_create_layer(other.x, other.y - 16, "Instances", oFirework);

    // Stop all active sounds
    audio_stop_all();

    // Save coins before reset
    ini_open("save.ini");
    ini_write_real("PlayerData", "TotalCoins", global.total_coins);
    ini_close();

    // Start death timer for fade-out or restart
    other.death_timer = 15; // shorter than before (0.25s)
    
    // Small camera shake setup (if used)
    other.shake_mag = 5;
    other.shake_length = 10;

    // Show debug
    show_debug_message("💀 Runner hit obstacle! Death triggered.");

    // Optional: destroy this obstacle so it doesn’t double-trigger
    instance_destroy();
}