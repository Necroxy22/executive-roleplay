#define MAX_RENTVEH 20

new Float:rentVehicle[][3] =
{
    {2772.847900,-2398.968750,13.632812},
    {1688.049560,-2259.662353,13.530823},
    {1693.9724, -2312.2305, 13.5469555}
};

new Float:unrentVehicle[][3] =
{
    {1689.7552, -2311.7261, 13.546955},
    {804.9299, -1362.8210, 13.546955},
    {1757.7032, -1864.0552, 13.574355}
};

new Float:rentBoat[][3] =
{
    {213.6747, -1986.3925, 1.4154}
};

CMD:rentbike(playerid)
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 2772.847900,-2398.968750,13.632812) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1688.049560,-2259.662353,13.530823) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1693.9724, -2312.2305, 13.5469))
        return ErrorMsg(playerid, "Kamu tidak berada di dekat penyewaan sepeda!");
        
    new str[1024];
    format(str, sizeof(str), "Jenis Sepeda & Series\tHarga Rental\n"WHITE_E"TDR-3000\t"LG_E"$75\n{ffffff}Sepeda Gunung Aviator 2690 XT Steel\t"LG_E"$150\n{FFB6C1}> Pilih ini untuk mengembalikan kendaraan yang disewa dari negara");
                
    ShowPlayerDialog(playerid, DIALOG_RENT_BIKE, DIALOG_STYLE_TABLIST_HEADERS, "HoliDays - Rental Sepeda", str, "Rent", "Close");
    return 1;
}    

CMD:rentboat(playerid, params)
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 213.6747, -1986.3925, 1.4154)) return Error(playerid, "Kamu tidak berada di dekat penyewaan Kapal!");

    new str[1024];
    format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t"LG_E"$750 / one days\n%s\t"LG_E"$1.250 / one days\n%s\t"LG_E"$1.500 / one days",
    GetVehicleModelName(473), 
    GetVehicleModelName(453),
    GetVehicleModelName(452));
           
    ShowPlayerDialog(playerid, DIALOG_RENT_BOAT, DIALOG_STYLE_TABLIST_HEADERS, "Rent Boat", str, "Rent", "Close");
    return 1;
}
