function olah1(playerid)
{
	ShowItemBox(playerid, "Marijuana", "ADD_1x", 1578, 4);
	pData[playerid][pMarijuana] ++;
	pData[playerid][pKanabis] --;
	return 1;
}

function ambil1(playerid)
{
	ShowItemBox(playerid, "Kanabis", "ADD_1x", 800, 4);
	pData[playerid][pKanabis] ++;
	return 1;
}
CMD:olahkanabis(playerid, params[])
{
	if(pData[playerid][pKanabis] < 1) return ErrorMsg(playerid, "Anda Tidak memiliki kanabis");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda Tidak masih memiliki activity");
	ShowProgressbar(playerid, "Mengolah kanabis..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	SetTimerEx("olah1", 10000, false, "d", playerid);
	return 1;
}


CMD:ambilkanabis(playerid, params[])
{
	if(pData[playerid][pKanabis] > 7) return ErrorMsg(playerid, "Anda Tidak bisa membawa lebih dari 8 kanabis");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda Tidak masih memiliki activity");
	ShowProgressbar(playerid, "Mengambil kanabis..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	SetTimerEx("ambil1", 10000, false, "d", playerid);
	return 1;
}
