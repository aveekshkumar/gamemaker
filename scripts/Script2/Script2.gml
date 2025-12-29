function SaveCoins(){
/// SaveCoins()
ini_open("save.ini");
ini_write_real("PlayerData", "TotalCoins", global.total_coins);
ini_close();
}