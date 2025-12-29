// oRewardDisplay Draw GUI Event

// Title
draw_set_color(c_lime);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(-1);
draw_text(x, y - 100, "REWARD POOLS");

// GREEN POOL (Daily) - touching LEFT EDGE
draw_set_color(c_lime);
draw_rectangle(0, y - 60, x - 50, y + 100, false);
draw_set_color(c_black);
draw_rectangle(0, y - 60, x - 50, y + 100, true);
draw_set_color(c_black);
draw_text(x - 110, y - 50, "GREEN");
draw_text(x - 110, y - 30, "DAILY");
draw_text(x - 110, y - 10, "300 COINS");
draw_text(x - 110, y + 10, "150 COINS");
draw_text(x - 110, y + 30, "450 COINS");
draw_text(x - 110, y + 50, "600 COINS");

// RED POOL (Weekly) - touching GREEN
draw_set_color(c_orange);
draw_rectangle(x - 50, y - 60, x + 50, y + 100, false);
draw_set_color(c_black);
draw_rectangle(x - 50, y - 60, x + 50, y + 100, true);
draw_set_color(c_black);
draw_text(x, y - 50, "RED");
draw_text(x, y - 30, "WEEKLY");
draw_text(x, y - 10, "900 COINS");
draw_text(x, y + 10, "10 GEMS");
draw_text(x, y + 30, "1000 COINS");
draw_text(x, y + 50, "5 GEMS");
draw_text(x, y + 70, "20 GEMS");

// PURPLE POOL (Monthly) - touching RED & RIGHT EDGE
draw_set_color(c_purple);
draw_rectangle(x + 50, y - 60, room_width, y + 100, false);
draw_set_color(c_black);
draw_rectangle(x + 50, y - 60, room_width, y + 100, true);
draw_set_color(c_black);
draw_text(x + 110, y - 50, "PURPLE");
draw_text(x + 110, y - 30, "MONTHLY");
draw_text(x + 110, y - 10, "6000 COINS");
draw_text(x + 110, y + 10, "70 GEMS");
draw_text(x + 110, y + 30, "50 GEMS");
draw_text(x + 110, y + 50, "7000 COINS");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);