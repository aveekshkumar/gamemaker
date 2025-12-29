// oLoginSystem Create Event

// Create the pools with rewards
green_pool = ds_list_create();
ds_list_add(green_pool, 300, 150, 450, 600);

red_pool = ds_list_create();
ds_list_add(red_pool, 900, 10, 1000, 5, 20);

purple_pool = ds_list_create();
ds_list_add(purple_pool, 6000, 70, 50, 7000);

// Variables for tracking login
last_login_date = "";
days_since_login = 0;

// Function to claim daily reward
function claim_daily_reward() {
    var reward_type = irandom(2);
    var reward = 0;
    
    if (reward_type == 0) {
        reward = ds_list_find_value(green_pool, irandom(ds_list_size(green_pool) - 1));
        if (reward > 100) {
            global.total_coins += reward;
        } else {
            global.total_gems += reward;
        }
        show_debug_message("🟢 Daily reward: " + string(reward));
    }
    else if (reward_type == 1) {
        reward = ds_list_find_value(red_pool, irandom(ds_list_size(red_pool) - 1));
        if (reward > 100) {
            global.total_coins += reward;
        } else {
            global.total_gems += reward;
        }
        show_debug_message("🔴 Weekly reward: " + string(reward));
    }
    else {
        reward = ds_list_find_value(purple_pool, irandom(ds_list_size(purple_pool) - 1));
        if (reward > 100) {
            global.total_coins += reward;
        } else {
            global.total_gems += reward;
        }
        show_debug_message("🟣 Monthly reward: " + string(reward));
    }
    
    ini_open(global.save_path);
    ini_write_real("PlayerData", "TotalCoins", global.total_coins);
    ini_write_real("PlayerData", "Gems", global.total_gems);
    ini_close();
}