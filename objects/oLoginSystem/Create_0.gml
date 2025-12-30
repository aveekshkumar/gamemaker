function claim_daily_reward() {
    // Get last login date
    ini_open(global.save_path);
    var last_date = ini_read_string("LoginData", "LastClaimDate", "");
    ini_close();
    
    var current_date = date_date_string(date_current_datetime());
    var reward = 0;
    var reward_type = 0;  // 0 = green, 1 = red, 2 = purple
    
    // Calculate days since last login
    var days_diff = 0;
    if (last_date != "") {
        days_diff = date_get_day(date_create_from_datetime(
            date_year_span(current_date, last_date),
            date_month_span(current_date, last_date),
            real(string_digits(current_date)), 0, 0, 0
        ));
    }
    
    // Determine which pool based on days
    if (days_diff >= 30) {
        reward_type = 2;  // Purple (monthly)
        reward = ds_list_find_value(purple_pool, irandom(ds_list_size(purple_pool) - 1));
        show_debug_message("🟣 Monthly reward: " + string(reward));
    }
    else if (days_diff >= 7) {
        reward_type = 1;  // Red (weekly)
        reward = ds_list_find_value(red_pool, irandom(ds_list_size(red_pool) - 1));
        show_debug_message("🔴 Weekly reward: " + string(reward));
    }
    else {
        reward_type = 0;  // Green (daily)
        reward = ds_list_find_value(green_pool, irandom(ds_list_size(green_pool) - 1));
        show_debug_message("🟢 Daily reward: " + string(reward));
    }
    
    // Give reward
    if (reward > 100) {
        global.total_coins += reward;
    } else {
        global.total_gems += reward;
    }
    
    // Save
    ini_open(global.save_path);
    ini_write_real("PlayerData", "TotalCoins", global.total_coins);
    ini_write_real("PlayerData", "Gems", global.total_gems);
    ini_close();
}