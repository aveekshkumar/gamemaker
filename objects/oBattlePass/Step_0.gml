// ✅ ENSURE BP LIST EXISTS
if (global.bp_claimed_tiers == undefined || global.bp_claimed_tiers < 0) {
    global.bp_claimed_tiers = ds_list_create();
    show_debug_message("⚠️ Battle Pass list recreated!");
}

if (keyboard_check_pressed(vk_escape)) {
    room_goto(rm_start);
}

// Back button
if (mouse_check_button_pressed(mb_left)) {
    if (mouse_x >= back_button_x && mouse_x <= back_button_x + back_button_width && 
        mouse_y >= back_button_y && mouse_y <= back_button_y + back_button_height) {
        room_goto(rm_start);
    }
    
    // Claim reward button
    if (mouse_x >= claim_button_x && mouse_x <= claim_button_x + claim_button_width && 
        mouse_y >= claim_button_y && mouse_y <= claim_button_y + claim_button_height) {
        
        // Find the first unclaimed tier up to current tier
        var tier_to_claim = -1;
        for (var i = 1; i < global.bp_tier; i++) {
            if (ds_list_find_index(global.bp_claimed_tiers, i) == -1) {
                tier_to_claim = i;
                break;
            }
        }
        
        if (tier_to_claim != -1) {
            var reward = global.bp_rewards[tier_to_claim - 1];
            global.total_coins += reward.coins;
            global.total_gems += reward.gems;
            ds_list_add(global.bp_claimed_tiers, tier_to_claim);
            
            // ✅ SAVE EVERYTHING TO INI
            ini_open(global.save_path);
            ini_write_real("PlayerData", "TotalCoins", global.total_coins);
            ini_write_real("PlayerData", "Gems", global.total_gems);
            ini_write_real("BattlePass", "Tier", global.bp_tier);
            ini_write_real("BattlePass", "XP", global.bp_xp);
            
            // ⭐ SAVE CLAIMED TIERS LIST
            var claimed_str = "";
            for (var i = 0; i < ds_list_size(global.bp_claimed_tiers); i++) {
                claimed_str += string(global.bp_claimed_tiers[| i]);
                if (i < ds_list_size(global.bp_claimed_tiers) - 1) claimed_str += ",";
            }
            ini_write_string("BattlePass", "ClaimedTiers", claimed_str);
            ini_close();
            
            show_debug_message("⭐ REWARD CLAIMED! Tier " + string(tier_to_claim) + " | Coins: " + string(reward.coins) + " Gems: " + string(reward.gems));
        } else {
            show_debug_message("❌ THERE ARE NO REWARDS FOR YOU TO CLAIM!");
        }
    }
}