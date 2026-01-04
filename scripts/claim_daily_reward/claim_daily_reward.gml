/// @function claim_daily_reward()
function claim_daily_reward() {
    // Get last login date
    ini_open(global.save_path);
    var last_date = ini_read_string("LoginData", "LastClaimDate", "");
    ini_close();
    
    var current_date = date_date_string(date_current_datetime());
    var reward = 0;
    var pool_choice = 0;
    
    // Create pools
    var green_pool = ds_list_create();
    ds_list_add(green_pool, 300, 150, 450, 600);
    
    var red_pool = ds_list_create();
    ds_list_add(red_pool, 900, 10, 1000, 5, 20);
    
    var purple_pool = ds_list_create();
    ds_list_add(purple_pool, 6000, 70, 50, 7000);
    
    // Calculate days difference
    var days_diff = 0;
    
    if (last_date != "") {
        // Parse day/month/year format (DD/MM/YY)
        var last_day = real(string_copy(last_date, 1, 2));
        var last_month = real(string_copy(last_date, 4, 2));
        var last_year_str = string_copy(last_date, 7, 2);
        var last_year = real(last_year_str);
        if (last_year < 50) {
            last_year += 2000;
        } else {
            last_year += 1900;
        }
        
        var curr_day = real(string_copy(current_date, 1, 2));
        var curr_month = real(string_copy(current_date, 4, 2));
        var curr_year_str = string_copy(current_date, 7, 2);
        var curr_year = real(curr_year_str);
        if (curr_year < 50) {
            curr_year += 2000;
        } else {
            curr_year += 1900;
        }
        
        // Simple calculation
        if (curr_year == last_year && curr_month == last_month) {
            days_diff = curr_day - last_day;
        } else if (curr_year == last_year) {
            days_diff = 30 + curr_day - last_day;
        } else {
            days_diff = 365;
        }
    } else {
        days_diff = 1;
    }
    
    // Determine pool based on days
    if (days_diff >= 30) {
        pool_choice = 2;  // PURPLE
    }
    else if (days_diff >= 7) {
        pool_choice = 1;  // RED
    }
    else if (days_diff >= 1) {
        pool_choice = 0;  // GREEN
    }
	
	show_debug_message("Last date: " + last_date + " | Current date: " + current_date);
    show_debug_message("Days diff: " + string(days_diff));
    
    // Get reward from chosen pool
    if (pool_choice == 0) {
        reward = ds_list_find_value(green_pool, irandom(ds_list_size(green_pool) - 1));
        show_debug_message("🟢 Daily reward: " + string(reward));
    }
    else if (pool_choice == 1) {
        reward = ds_list_find_value(red_pool, irandom(ds_list_size(red_pool) - 1));
        show_debug_message("🔴 Weekly reward: " + string(reward));
    }
    else {
        reward = ds_list_find_value(purple_pool, irandom(ds_list_size(purple_pool) - 1));
        show_debug_message("🟣 Monthly reward: " + string(reward));
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
    
    ds_list_destroy(green_pool);
    ds_list_destroy(red_pool);
    ds_list_destroy(purple_pool);
}