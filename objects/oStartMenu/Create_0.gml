/// --- oStartMenu Create Event ---
global.save_path = working_directory + "save.ini";
show_debug_message("💾 Save path: " + global.save_path);

// Load coins & gems from save
if (file_exists(global.save_path)) {
    ini_open(global.save_path);
    global.total_coins = ini_read_real("PlayerData", "TotalCoins", 0);
    global.total_gems  = ini_read_real("PlayerData", "Gems", 0);
    ini_close();
    show_debug_message("✅ oStartMenu loaded: Coins = " + string(global.total_coins));
} else {
    show_debug_message("❌ No save file found!");
}

// Define menu items
menu_items = [
    "Leaderboard",
    "Play",
    "Shop",
    "Gem Shop",
    "Inventory",
	"Daily login",
    "Quit"
];

menu_scale = 1;
menu_glow = 0;

/// --- Sparkle Setup ---
sparkle_max = 40;
sparkles = [];

for (var i = 0; i < 50; i++) {
    var s = {
        x: irandom_range(0, display_get_gui_width()),
        y: irandom_range(0, display_get_gui_height()),
        alpha: random_range(0.4, 1),
        speed: random_range(0.5, 1.2),
        size: irandom_range(1, 3),
        dir: irandom_range(-20, 20)
    };
    array_push(sparkles, s);
}

menu_index = 0;
fade_alpha = 0;