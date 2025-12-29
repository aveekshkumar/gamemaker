/// --- oShop Step Event ---
// Navigate items
if (keyboard_check_pressed(vk_up))   shop_index = max(0, shop_index - 1);
if (keyboard_check_pressed(vk_down)) shop_index = min(array_length(shop_items) - 1, shop_index + 1);

// --- Purchase ---
if (keyboard_check_pressed(vk_enter)) {
    var item = shop_items[shop_index];
    var name = item[0];
    var cost = item[1];
    
    if (global.total_coins >= cost) {
        global.total_coins -= cost;
        
        switch (name) {
            case "Shield": global.owned_shield = 1; break;
            case "Aura":   global.owned_aura = 1; break;
            case "Speed":  global.owned_speed = 1; break;
        }
        
        // ✅ SAVE using "save.ini"
        ini_open("save.ini");
        ini_write_real("PlayerData", "TotalCoins", global.total_coins);
        ini_write_real("ShopData", "ShieldOwned", global.owned_shield);
        ini_write_real("ShopData", "AuraOwned", global.owned_aura);
        ini_write_real("ShopData", "SpeedOwned", global.owned_speed);
        ini_close();
        
        show_debug_message("🛍️ Purchased: " + name + " | Coins left: " + string(global.total_coins));
    } else {
        show_debug_message("❌ Not enough coins for " + name);
    }
}

// --- Exit back to main menu ---
if (keyboard_check_pressed(vk_escape)) {
    room_goto(rm_start);
}