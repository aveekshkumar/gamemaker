/// @function claim_daily_reward()
function claim_daily_reward() {
    // Get last login date
    ini_open(global.save_path);
    var last_date = ini_read_string("LoginData", "LastClaimDate", "");
    ini_close();
    
    var current_date = date_date_string(date_current_datetime());
    var reward = 0;
    var pool_choice = 0;
    var days_diff = 0;
    
    // Create pools
    var green_pool = ds_list_create();
    ds_list_add(green_pool, 300, 150, 450, 600);
    
    var red_pool = ds_list_create();
    ds_list_add(red_pool, 900, 10, 1000, 5, 20);
    
    var purple_pool = ds_list_create();
    ds_list_add(purple_pool, 6000, 70, 50, 7000);
    
    // Calculate days difference
    if (last_date != "") {
        // Parse month/day/year format (MM/DD/YY) - GameMaker format!
        var last_month = real(string_copy(last_date, 1, 2));
        var last_day = real(string_copy(last_date, 4, 2));
        var last_year_str = string_copy(last_date, 7, 2);
        var last_year = real(last_year_str);
        if (last_year < 50) {
            last_year += 2000;
        } else {
            last_year += 1900;
        }
        
        var curr_month = real(string_copy(current_date, 1, 2));
        var curr_day = real(string_copy(current_date, 4, 2));
        var curr_year_str = string_copy(current_date, 7, 2);
        var curr_year = real(curr_year_str);
        if (curr_year < 50) {
            curr_year += 2000;
        } else {
            curr_year += 1900;
        }
        
        show_debug_message("📅 Parsed - Last: Day=" + string(last_day) + " Month=" + string(last_month) + " Year=" + string(last_year));
        show_debug_message("📅 Parsed - Curr: Day=" + string(curr_day) + " Month=" + string(curr_month) + " Year=" + string(curr_year));
        
        // Calculate days difference - account for month/year changes
        var days_diff_simple = curr_day - last_day;
        
        if (curr_month > last_month || curr_year > last_year) {
            // Different month or year - calculate properly
            // Get days in the last month
            var days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
            var days_in_last_month = days_in_month[last_month - 1];  // -1 because arrays start at 0
            
            // Handle leap year for February
            if (last_month == 2 && ((last_year mod 4 == 0 && last_year mod 100 != 0) || last_year mod 400 == 0)) {
                days_in_last_month = 29;
            }
            
            days_diff = (days_in_last_month - last_day) + curr_day;
            show_debug_message("📅 Different month - Days in last month: " + string(days_in_last_month) + " | Calc: (" + string(days_in_last_month) + " - " + string(last_day) + ") + " + string(curr_day) + " = " + string(days_diff));
        } else {
            days_diff = days_diff_simple;
            show_debug_message("📅 Same month - Simple diff: " + string(days_diff));
        }
    } else {
        days_diff = 1;
    }
    
    show_debug_message("Last date: " + last_date + " | Current date: " + current_date);
    show_debug_message("Days diff: " + string(days_diff));
    
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
    ini_write_string("LoginData", "LastClaimDate", current_date);  // ✅ SAVE THE CURRENT DATE!
    ini_close();
    
    ds_list_destroy(green_pool);
    ds_list_destroy(red_pool);
    ds_list_destroy(purple_pool);
}