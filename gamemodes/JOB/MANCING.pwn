function FishTime(playerid)
{
	if(IsPlayerConnected(playerid) && pData[playerid][pInFish] == 1)
	{
	    new rand = RandomEx(1,12);
	    if(rand == 1)
	    {
	        Info(playerid, "Anda mendapatkan sebuah kondom dan langsung membuangannya.");
	        pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
			return 1;
		}
		else if(rand == 2)
		{
		    InfoMsg(playerid, "Anda mendapatkan ikan makarel!");
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
	        pData[playerid][pMakarel]++;
	        ShowItemBox(playerid, "Ikan_Makarel", "Received_1x", 19630, 2);
			return 1;
		}
		else if(rand == 3)
		{
		    InfoMsg(playerid, "Anda mendapatkan ikan nemo!");
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
	        pData[playerid][pNemo]++;
	        ShowItemBox(playerid, "Nemo", "Received_1x", 1599, 2);
			return 1;
		}
		else if(rand == 4)
		{
		    InfoMsg(playerid, "Anda mendapatkan penyu");
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
	        pData[playerid][pPenyu]++;
	        ShowItemBox(playerid, "Penyu", "Received_1x", 1609, 2);
			return 1;
		}
		else if(rand == 5)
		{
		    Info(playerid, "Anda mendapatkan blue fish!");
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
	        pData[playerid][pBlueFish]++;
	        ShowItemBox(playerid, "Blue_Fish", "Received_1x", 1604, 2);
			return 1;
		}
		else if(rand == 6)
		{
		    InfoMsg(playerid, "Anda mendapatkan ikan makarel!");
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
	        pData[playerid][pMakarel]++;
	        ShowItemBox(playerid, "Ikan_Makarel", "Received_1x", 19630, 2);
			return 1;
		}
		else if(rand == 7)
		{
		    InfoMsg(playerid, "Anda mendapatkan ikan makarel!");
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
	        pData[playerid][pMakarel]++;
	        ShowItemBox(playerid, "Ikan_Makarel", "Received_1x", 19630, 2);
			return 1;
		}
		else if(rand == 8)
		{
		    InfoMsg(playerid, "Anda mendapatkan ikan makarel!");
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
	        pData[playerid][pMakarel]++;
	        ShowItemBox(playerid, "Ikan_Makarel", "Received_1x", 19630, 2);
			return 1;
		}
		else if(rand == 9)
		{
		    InfoMsg(playerid, "Anda mendapatkan ikan makarel!");
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
	        pData[playerid][pMakarel]++;
	        ShowItemBox(playerid, "Ikan_Makarel", "Received_1x", 19630, 2);
			return 1;
		}
		else if(rand == 10)
		{
		    Info(playerid, "Anda mendapatkan kaos kaki dan langsung membuangnya.");
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
		    return 1;
		}
		else if(rand == 11)
		{
		    Info(playerid, "Ikan yang sangat besar! tetapi pancingan anda terputus dan rusak.");
		    pData[playerid][pWorm] -= 1;
	        pData[playerid][pInFish] = 0;
			pData[playerid][pFishTool]--;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
		    return 1;
		}
		else
		{
		    Info(playerid, "Anda mendapatkan kondom bau dan langsung membuangnya.");
	        pData[playerid][pInFish] = 0;
	        TogglePlayerControllable(playerid, 1);
	        RemovePlayerAttachedObject(playerid, 9);
		    return 1;
		}
	}
	return 0;
}

CMD:mancingAufa(playerid,params[])
{
	new random2 = RandomEx(10000, 20000);
	pData[playerid][pInFish] = 1;
	SetTimerEx("FishTime", random2, 0, "i",playerid);
	SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "** %s mengayunkan pancing dan mulai menunggu ikan", ReturnName(playerid));
	TogglePlayerControllable(playerid, 0);
	ApplyAnimation(playerid,"SWORD","sword_block",50.0 ,0,1,0,1,1);
	SetPlayerAttachedObject(playerid, 9,18632,6,0.079376,0.037070,0.007706,181.482910,0.000000,0.000000,1.000000,1.000000,1.000000);
	InfoMsg(playerid, "Memancing Ikan..");
	return 1;
}

CMD:jualpenyuAufa(playerid, params[])
{
    new total = pData[playerid][pPenyu];
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if(pData[playerid][pPenyu] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki 1 Penyu");
    ShowProgressbar(playerid, "Menjual Penyu..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pPenyu] * 9;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pPenyu] -= total;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, 2);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Penyu", str, 1609, 2);
    Inventory_Update(playerid);
	return 1;
}
CMD:jualmarakelAufa(playerid, params[])
{
    new total = pData[playerid][pMakarel];
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if(pData[playerid][pMakarel] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki 1 Makarel");
    ShowProgressbar(playerid, "Menjual Makarel..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pMakarel] * 3;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pMakarel] -= total;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, 2);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Ikan_Makarel", str, 19630, 2);
    Inventory_Update(playerid);
	return 1;
}
CMD:jualnemoAufa(playerid, params[])
{
    new total = pData[playerid][pNemo];
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if(pData[playerid][pNemo] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki 1 Nemo");
    ShowProgressbar(playerid, "Menjual Nemo..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pNemo] * 5;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pNemo] -= total;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, 2);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Nemo", str, 1599, 2);
    Inventory_Update(playerid);
	return 1;
}
CMD:jualbluefishAufa(playerid, params[])
{
    new total = pData[playerid][pBlueFish];
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if(pData[playerid][pBlueFish] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki 1 Blue Fish");
    ShowProgressbar(playerid, "Menjual BlueFish..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pBlueFish] * 6;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pBlueFish] -= total;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, 2);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Blue_Fish", str, 1604, 2);
    Inventory_Update(playerid);
	return 1;
}
