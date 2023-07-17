//Rob bank system
//robbank bank besar
CMD:lockpick(playerid, params[])
{
	if(pData[playerid][pFamily] >= -1)
	{
		Info(playerid, "Kamu Sedang membuat lockpick mohon di tunggu..");
		ShowProgressbar(playerid, "Membuat Lock Pick..", 10);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		SetTimerEx("LockPick", 5000, false, "d", playerid);
		InRob[playerid] = 1;
	}
	else
	{
		Error(playerid, "Anda Bukan Anggota Family!");
  	}
	return 1;
}

function Lockpick(playerid)
{
	if((pData[playerid][pActivity])) return 0;
	{
	    if(pData[playerid][pActivityTime] >= 100)
	    {
	    	InfoTD_MSG(playerid, 8000, "Lockpick Berhasil Di buat!");
			pData[playerid][pEnergy] -= 4;
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
	    	InRob[playerid] = 0;
	        GivePlayerMoneyEx(playerid, -700);
	    	pData[playerid][pLockPick] += 1;
	    	SendClientMessageEx(playerid, COLOR_WHITE, "INFO: {FFFFFF}Anda telah berhasil membuat lockpick dan uang Anda -$700");
		}
	}
	return 1;
}


IsSAPDEnformance(playerid)
{
	return pData[playerid][pFaction] == 1;
}
IsSAMDEnformance(playerid)
{
	return pData[playerid][pFaction] == 3;
}


CMD:robbank(playerid, params[])
{
	new count;
	if(pData[playerid][RobbankTime] >= gettime()) return Error(playerid, "Anda harus menunggu %d detik untuk merampok bank", pData[playerid][RobbankTime] - gettime());
	if(pData[playerid][pInjured] >= 1) return Error(playerid, "Anda tidak dapat menggunakan ini saat ini!");
	if(pData[playerid][pLockPick] == -1) return Error(playerid, "Kamu Tidak mempunyai lockpick");

	/*foreach(new i : Player)
	{
		if(IsSAPDEnformance(i) && pData[i][pOnDuty] == 0)
		{
			count++;
		}
	}
	if(count < 4)
	{
		return Info(playerid, "Anggota SAPD harus minimal 4++ untuk melakukan perampokan.");
	}

	foreach(new i : Player)
	{
		if(IsSAMDEnformance(i) && pData[i][pOnDuty] == 0)
		{
			count++;
		}
	}
	if(count < 2)
	{
		return Info(playerid, "Anggota SAMD harus minimal 2++ untuk melakukan perampokan.");
	}*/

	SetTimerEx("SedangRob", 10000, false, "d", playerid);

	ShowProgressbar(playerid, "Robbank..", 10);
	ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 1, 1, 1, 1, 1);

	return 1;
}

//Bank
function RobBank(playerid)
{
	new rand = RandomEx(1,4);
    if((pData[playerid][pActivity])) return 0;
	{
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 1)
		    {
		    	InfoTD_MSG(playerid, 10000, "Perampokan ~r~Gagal!");
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
		    	Info(playerid, "Anda gagal membobol Bank, Lakukan lagi sebelum Polisi datang");
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 2)
		    {
		    	InfoTD_MSG(playerid, 8000, "Perampokan ~r~Gagal!");
		    	TogglePlayerControllable(playerid, 1);
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
		    	Info(playerid, "Anda gagal membobol Bank, Lakukan lagi sebelum Polisi datang");
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 3)
		    {
		    	InfoTD_MSG(playerid, 8000, "Perampokan ~r~Gagal!");
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pLockPick] -= 1;
				Info(playerid, "Locpick patah silakan coba kembali");
		    	Info(playerid, "Anda gagal membobol Bank, Lakukan lagi sebelum Polisi datang");
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 4)
		    {
		    	InfoTD_MSG(playerid, 8000, "Perampokan ~g~ Berhasil!");
				pData[playerid][pHunger] -= 5;
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pLockPick] -= 1;
				ClearAnimations(playerid);
				pData[playerid][RobbankTime] = gettime() + 172800;
		    	new RandRobBank = Random(5764, 4214);
		    	pData[playerid][pRedMoney] += RandRobBank;
		    	Info(playerid, "Anda berhasil merampok BANK, cepat pergi dari lokasi sebelum polisi datang");
		    	new string[1280];
				format(string, sizeof(string), "Anda mengambil Uang Merah Bank Perampokan "LG_E"$%d", RandRobBank);
                SendClientMessage(playerid, ARWIN, string);
                if(pData[playerid][pFaction] == 1)
				{
					SendFactionMessage(1, COLOR_BLUE, "ALARM: "WHITE_E"saat ini sedang terjadi perampokan BANK di "YELLOW_E"Lokasi: Downton Los santos");
				}
			}
		}
	 	else if(pData[playerid][pActivityTime] < 100)
		{
		   	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		   	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

CMD:robatm(playerid, params[])
{
	new count;
	//if(pData[playerid][pFamily] != -1) return Error(playerid, "Kamu bukan family");
	if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "You must logged in!");
	if(pData[playerid][pInjured] >= 1) return Error(playerid, "You can't use this at this moment!");
	if(pData[playerid][RobbankTime] >= gettime()) return Error(playerid, "You've must wait %d seconds to robbery Atm", pData[playerid][RobbankTime] - gettime());
	if(pData[playerid][pLockPick] == 1) return Error(playerid, "Kamu tidak ada lockpick");

	foreach(new i : Player)
	{
		if(IsSAPDEnformance(i) && pData[i][pOnDuty] == 0)
		{
			count++;
		}
	}

	if(count < 0)
	{
		return Info(playerid, "Anggota SAPD harus minimal 3++ untuk melakukan perampokan.");
	}

	foreach(new i : Player)
	{
		if(IsSAMDEnformance(i) && pData[i][pOnDuty] == 0)
		{
			count++;
		}
	}

	if(count < 0)
	{
		return Info(playerid, "Anggota SAMD harus minimal 2++ untuk melakukan perampokan.");
	}

	new id = -1;
	id = GetClosestATM(playerid);

	if(id > -1)
	{
		pData[playerid][pActivity] = ("RobAtm", 5000, true, "idd", playerid);

		PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Rob ATM...");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
		TogglePlayerControllable(playerid, 0);
		ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 1, 1, 1, 1, 1);
	}

	return 1;
}

//Atm
function RobAtm(playerid)
{
    new id = -1;
	id = GetClosestATM(playerid);
	new rand = RandomEx(1,12);
    if((pData[playerid][pActivity])) return 0;
	{
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 1)
		    {
		    	InfoTD_MSG(playerid, 8000, "Robbery ~r~Failed!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
		    	Info(playerid, "Anda gagal meretas ATM, Lakukan lagi sebelum Polisi datang");
		        TogglePlayerControllable(playerid, 1);
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 2)
		    {
		    	InfoTD_MSG(playerid, 8000, "Robbery ~r~Failed!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
		    	Info(playerid, "Anda gagal meretas ATM, Lakukan lagi sebelum Polisi datang");
		        TogglePlayerControllable(playerid, 1);
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 3)
		    {
		    	InfoTD_MSG(playerid, 8000, "Robbery ~r~Failed!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
		    	Info(playerid, "Anda gagal meretas ATM, alat perampokan anda hancur");
		        TogglePlayerControllable(playerid, 1);
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 4)
		    {
		    	InfoTD_MSG(playerid, 8000, "Robbery ~r~Failed!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
		    	Info(playerid, "Anda gagal meretas ATM, alat perampokan anda hancur");
		        TogglePlayerControllable(playerid, 1);
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 5)
		    {
		    	InfoTD_MSG(playerid, 8000, "Robbery ~r~Failed!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pLockPick] -= 1;
				Info(playerid, "Lockipick pecah");
		    	Info(playerid, "Anda gagal meretas ATM, Lakukan lagi sebelum Polisi datang");
		        TogglePlayerControllable(playerid, 1);
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 6)
		    {
		    	InfoTD_MSG(playerid, 8000, "Robbery ~r~Failed!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
		    	Info(playerid, "Anda gagal meretas ATM, alat perampokan anda hancur");
		        TogglePlayerControllable(playerid, 1);
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 7)
		    {
		    	InfoTD_MSG(playerid, 8000, "Robbery ~r~Failed!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
		    	Info(playerid, "Anda gagal meretas ATM, alat perampokan anda hancur");
		        TogglePlayerControllable(playerid, 1);
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 8)
		    {
		    	InfoTD_MSG(playerid, 8000, "Robbery ~r~Failed!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
		    	Info(playerid, "Anda gagal meretas ATM, Lakukan lagi sebelum Polisi datang");
		        TogglePlayerControllable(playerid, 1);
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 9)
		    {
		    	InfoTD_MSG(playerid, 8000, "Robbery ~r~Failed!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
		    	Info(playerid, "Anda gagal meretas ATM, alat perampokan anda hancur");
		        TogglePlayerControllable(playerid, 1);
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 10)
		    {
		    	InfoTD_MSG(playerid, 8000, "Robbery ~r~Failed!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
		    	Info(playerid, "Anda gagal meretas ATM, alat perampokan anda hancur");
		        TogglePlayerControllable(playerid, 1);
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 11)
		    {
		    	InfoTD_MSG(playerid, 8000, "Robbery ~g~Succesfully!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pHunger] -= 5;
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
				ClearAnimations(playerid);
		    	new RandRobAtm = Random(1821, 2851);
		    	pData[playerid][pRedMoney] += RandRobAtm;
		    	Info(playerid, "Anda berhasil merampok ATM, cepat pergi dari lokasi sebelum polisi datang");
		    	new string[1280];
				format(string, sizeof(string), "You takes Robbery ATM Money "LG_E"$%d", RandRobAtm);
                SendClientMessage(playerid, ARWIN, string);
                pData[playerid][RobbankTime] = gettime() + 172800;
                if(pData[playerid][pFaction] == 1)
				{
					SendFactionMessage(1, COLOR_BLUE, "ALARM: "WHITE_E"saat ini sedang terjadi perampokan ATM di "YELLOW_E"Lokasi: %s",GetLocation(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]));
				}
			}
		}
	 	else if(pData[playerid][pActivityTime] < 100)
		{
		   	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		   	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

CMD:Robbiz(playerid, params[])
{
	new count;
	if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "You must logged in!");
	if(pData[playerid][pInjured] >= 1) return Error(playerid, "You can't use this at this moment!");
	if(pData[playerid][RobbankTime] >= gettime()) return Error(playerid, "You've must wait %d seconds to robbery Atm", pData[playerid][RobbankTime] - gettime());
	//     if(pData[playerid][pFamily] != -1) return Error(playerid, "Kamu tidak masuk family");
	if(pData[playerid][pLockPick] == 1) return Error(playerid, "Kamu tidak ada lockpick"); 
	if(pData[playerid][pInBiz] >= 0 && IsPlayerInRangeOfPoint(playerid, 3.0, bData[pData[playerid][pInBiz]][bPointX], bData[pData[playerid][pInBiz]][bPointY], bData[pData[playerid][pInBiz]][bPointZ]))
	{
		foreach(new i : Player)
		{
			if(IsSAPDEnformance(i) && pData[i][pOnDuty] == 0)
			{
				count++;
			}
		}

		if(count < 3)
		{
			return Info(playerid, "Anggota SAMD harus minimal 3++ untuk melakukan perampokan.");
		}

		foreach(new i : Player)
		{
			if(IsSAMDEnformance(i) && pData[i][pOnDuty] == 0)
			{
				count++;
			}
		}

		if(count < 2)
		{
			return Info(playerid, "Anggota SAMD harus minimal 2++ untuk melakukan perampokan.");
		}

		Info(playerid, "You're in robbery please wait...");
				
		pData[playerid][pActivity] = ("RobBizz", 6000, true, "i", playerid);
    			
		PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Robbing...");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
		TogglePlayerControllable(playerid, 0);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant",	4.0, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

function RobBizz(playerid)
{
	new rand = RandomEx(1,4);
    if((pData[playerid][pActivity])) return 0;
	{
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 1)
		    {
		    	InfoTD_MSG(playerid, 8000, "Robbery ~r~Failed!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
		    	Info(playerid, "Anda gagal membobol Bank, Lakukan lagi sebelum Polisi datang");
		        TogglePlayerControllable(playerid, 1);
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 2)
		    {
		    	InfoTD_MSG(playerid, 8000, "Robbery ~r~Failed!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pLockPick] -= 1;
				Info(playerid, "Lockpick patah rob bizz gagal");
		    	Info(playerid, "Anda gagal membobol Bank, Lakukan lagi sebelum Polisi datang");
		        TogglePlayerControllable(playerid, 1);
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 3)
		    {
		    	InfoTD_MSG(playerid, 8000, "Robbery ~r~Failed!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
		    	Info(playerid, "Anda gagal membobol Bank, Lakukan lagi sebelum Polisi datang");
		        TogglePlayerControllable(playerid, 1);
				return 1;
			}
		}
 		else if(pData[playerid][pActivityTime] < 100)
 		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    if(rand == 4)
		    {
		    	InfoTD_MSG(playerid, 8000, "Robbery ~g~Succesfully!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pHunger] -= 5;
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
				pData[playerid][pLockPick] -= 1;
				ClearAnimations(playerid);
				InRob[playerid] = 0;
				pData[playerid][RobbankTime] = gettime() + 172800;
		    	new RandRobBizz = Random(2764, 3214);
		    	pData[playerid][pRedMoney] += RandRobBizz;
		    	Info(playerid, "Anda berhasil merampok BIZZ, cepat pergi dari lokasi sebelum polisi datang");
		    	new string[1280];
				format(string, sizeof(string), "You takes Robbery Bizz Red Money "LG_E"$%d", RandRobBizz);
                SendClientMessage(playerid, ARWIN, string);
                if(pData[playerid][pFaction] == 1)
				{
					SendFactionMessage(1, COLOR_RED, "**[Warning]{FFFFFF} Alarm Berbunyi Di bisnis ID: %d", GetPlayerVirtualWorld(playerid));
				}
			}
		}
	 	else if(pData[playerid][pActivityTime] < 100)
		{
		   	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		   	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}