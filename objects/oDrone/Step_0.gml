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
hover_t += hover_speed;

// === BEAM EFFECT COLOR ANIMATION ===
beam_pulse += 0.15;
beam_col = merge_color(make_color_rgb(120, 255, 120), make_color_rgb(180, 255, 200), 0.5 + 0.5 * sin(beam_pulse * 0.5));

// === COIN COLLECTION ===
var range = 60; // pickup radius

/// --- Drone Coin Collection Step ---
// ✅ Only collect coins after oRunner is fully initialized
if (instance_exists(oRunner)) {
    with (oCoin)
{
    if (point_distance(x, y, other.x, other.y) < other.range)
    {
        if (instance_exists(oRunner))
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
            
            oRunner.coins += 1;
            global.total_coins += 1;
            
            // ⭐ BATTLE PASS XP GAIN (1 coin = 2 XP)
            global.bp_xp += 2;
            
            // ⭐ CHECK TIER UP (NO AUTO REWARD)
            var xp_needed = 50 + (global.bp_tier - 1) * 10;  // 50, 60, 70, 80...
            if (global.bp_xp >= xp_needed && global.bp_tier < 15) {
                global.bp_xp -= xp_needed;
                global.bp_tier += 1;
                show_debug_message("⭐ TIER UP! Tier=" + string(global.bp_tier));
            }
            
            // ✅ SAVE GLOBAL TOTAL & BATTLE PASS DATA
            ini_open(global.save_path);
            ini_write_real("PlayerData", "TotalCoins", global.total_coins);
            ini_write_real("BattlePass", "Tier", global.bp_tier);
            ini_write_real("BattlePass", "XP", global.bp_xp);
            
            // ⭐ SAVE CLAIMED TIERS
            var claimed_str = "";
            for (var i = 0; i < ds_list_size(global.bp_claimed_tiers); i++) {
                claimed_str += string(global.bp_claimed_tiers[| i]);
                if (i < ds_list_size(global.bp_claimed_tiers) - 1) claimed_str += ",";
            }
            ini_write_string("BattlePass", "ClaimedTiers", claimed_str);
            ini_close();
            
            show_debug_message("💾 Coins saved: " + string(global.total_coins));
        }
        
        // ✅ PARTICLE EXPLOSION!
        var num_particles = 180;
        var angle_step = 360 / num_particles;
    
        for (var i = 0; i < num_particles; i++) {
            var angle = i * angle_step;
            var particle_x = x + lengthdir_x(5, angle);
            var particle_y = y + lengthdir_y(5, angle);
        
            with (instance_create_layer(particle_x, particle_y, "Instances", oParticle2)) {
                direction = angle;
                speed = 3 + random(2);
                image_alpha = 0.8;
                lifetime = 30;
            }
        }
    
        instance_destroy();
        }
    }
    
    with (oGemCoin)
{
    if (point_distance(x, y, other.x, other.y) < other.range)
    {
        if (instance_exists(oRunner))
        {
            oRunner.gems += 1;
            global.total_gems += 1;
            
            ini_open(global.save_path);
            ini_write_real("PlayerData", "Gems", global.total_gems);
            ini_close();
            
            show_debug_message("💎 Gems saved: " + string(global.total_gems));
        }
        
        // ✅ PARTICLE EXPLOSION (CYAN)!
        var num_particles = 180;
        var angle_step = 360 / num_particles;

        for (var i = 0; i < num_particles; i++) {
            var angle = i * angle_step;
            var particle_x = x + lengthdir_x(5, angle);
            var particle_y = y + lengthdir_y(5, angle);
    
            with (instance_create_layer(particle_x, particle_y, "Instances", oParticle2)) {
                direction = angle;
                speed = 3 + random(2);
                image_alpha = 0.8;
                lifetime = 30;
                particle_color = c_aqua;  // aqua for gems
            }
        }
    
        instance_destroy();
        }
    }
}