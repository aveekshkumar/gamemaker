var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);

// Title - CENTERED
draw_text_transformed(gui_width/2, 50, "⭐ BATTLE PASS ⭐", 2, 2, 0);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Current Tier
draw_text(100, 150, "Current Tier: " + string(global.bp_tier) + "/15");

// XP Bar
var xp_needed = 50 + (global.bp_tier - 1) * 10;
var xp_progress = global.bp_xp / xp_needed;
draw_text(100, 180, "XP: " + string(floor(global.bp_xp)) + "/" + string(xp_needed));

// Progress bar background
draw_set_color(c_black);
draw_rectangle(100, 210, 500, 230, false);

// Progress bar fill
draw_set_color(c_lime);
draw_rectangle(100, 210, 100 + 400 * xp_progress, 230, false);

draw_set_color(c_white);

// Current Tier Reward
if (global.bp_tier <= 15) {
    var current_reward = global.bp_rewards[global.bp_tier - 1];
    draw_text(100, 270, "Tier " + string(global.bp_tier) + " Reward:");
    draw_text(120, 295, "Coins: " + string(current_reward.coins));
    draw_text(120, 320, "Gems: " + string(current_reward.gems));
}

// Claim Reward Button
draw_set_color(c_lime);
draw_rectangle(claim_button_x, claim_button_y, claim_button_x + claim_button_width, claim_button_y + claim_button_height, false);
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(claim_button_x + claim_button_width/2, claim_button_y + claim_button_height/2, "CLAIM REWARD", 1.2, 1.2, 0);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Back button
draw_set_color(c_white);
draw_rectangle(back_button_x, back_button_y, back_button_x + back_button_width, back_button_y + back_button_height, false);
draw_set_color(c_black);
draw_text(back_button_x + 10, back_button_y + 10, "BACK");
draw_set_color(c_white);