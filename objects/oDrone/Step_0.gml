/// --- oDrone Step Event ---
if (global.game_paused) exit;

/// Smooth hover + auto-collects coins and gem coins + saves progress

// === SMOOTH FOLLOW ===
if (instance_exists(follow_target))
{
    var tx = follow_target.x;
    var ty = follow_target.y + hover_height + sin(hover_t) * hover_range;
    x += (tx - x) * follow_speed;
    y += (ty - y) * follow_speed;
}

// === HOVER ANIMATION ===
hover_t += hover_speed * room_speed;

// === BEAM EFFECT COLOR ANIMATION ===
beam_pulse += 0.15;
beam_col = merge_color(make_color_rgb(120, 255, 120), make_color_rgb(180, 255, 200), 0.5 + 0.5 * sin(beam_pulse * 0.5));

// === COIN COLLECTION ===
var range = 60; // pickup radius

/// --- Drone Coin Collection Step ---

// ✅ Only collect coins after oRunner is fully initialized
if (instance_exists(oRunner) && variable_instance_exists(oRunner, "runner_init_complete")) {
    with (oCoin)
{
    if (point_distance(x, y, other.x, other.y) < other.range)
    {
        var runner = instance_find(oRunner, 0);
        if (instance_exists(runner))
        {
            // ✅ SAFETY RELOAD
            if (!file_exists(global.save_path)) {
                global.save_path = working_directory + "save.ini";
            }
            ini_open(global.save_path);
            var loaded_total = ini_read_real("PlayerData", "TotalCoins", 0);
            ini_close();
            
            if (loaded_total > global.total_coins) {
                global.total_coins = loaded_total;
            }
            
            runner.coins += 1;
            global.total_coins += 1;
            
            // ✅ SAVE GLOBAL TOTAL (like gems!)
            ini_open(global.save_path);
            ini_write_real("PlayerData", "TotalCoins", global.total_coins);  // Save GLOBAL total
            ini_close();
            
            show_debug_message("💾 Coins saved: " + string(global.total_coins));
        }
        instance_destroy();
    }
}
    
    with (oGemCoin)
    {
        if (point_distance(x, y, other.x, other.y) < other.range)
        {
            var runner2 = instance_find(oRunner, 0);
            if (instance_exists(runner2))
            {
                runner2.gems += 1;
                global.total_gems += 1;
                
                ini_open(global.save_path);
                ini_write_real("PlayerData", "Gems", global.total_gems);
                ini_close();
                
                show_debug_message("💎 Gems saved: " + string(global.total_gems));
            }
            instance_destroy();
        }
    }
}