/*

	JOB PEMERAS SUSU CEWE

*/

#include <YSI_Coding\y_hooks>

new cow1,
	cow2,
	cow3,
	cow4,
	cow5,
	cow6,
	cow7,
	cow8,
	cow9,
	cow10,
	cow11,
	cow12,
	cow13,
	cow14;

enum E_PEMERASUSU
{
	STREAMER_TAG_AREA:Dutyarea,
	STREAMER_TAG_CP:Dutycp,
	STREAMER_TAG_MAP_ICON:Iconsapi,
	STREAMER_TAG_AREA:Olahsusu,
	STREAMER_TAG_CP:Olahcp
}
new PemerasArea[MAX_PLAYERS][E_PEMERASUSU];

DeleteJobPemerahMap(playerid)
{
	if(IsValidDynamicArea(PemerasArea[playerid][Dutyarea]))
	{
		DestroyDynamicArea(PemerasArea[playerid][Dutyarea]);
		PemerasArea[playerid][Dutyarea] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicArea(PemerasArea[playerid][Olahsusu]))
	{
		DestroyDynamicArea(PemerasArea[playerid][Olahsusu]);
		PemerasArea[playerid][Olahsusu] = STREAMER_TAG_AREA: -1;
	}

	if(IsValidDynamicCP(PemerasArea[playerid][Dutycp]))
	{
		DestroyDynamicCP(PemerasArea[playerid][Dutycp]);
		PemerasArea[playerid][Dutycp] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicCP(PemerasArea[playerid][Olahcp]))
	{
		DestroyDynamicCP(PemerasArea[playerid][Olahcp]);
		PemerasArea[playerid][Olahcp] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicCP(PemerasArea[playerid][Olahcp]))
	{
		DestroyDynamicCP(PemerasArea[playerid][Olahcp]);
		PemerasArea[playerid][Olahcp] = STREAMER_TAG_CP: -1;
	}

	if(IsValidDynamicMapIcon(PemerasArea[playerid][Iconsapi]))
	{
		DestroyDynamicMapIcon(PemerasArea[playerid][Iconsapi]);
		PemerasArea[playerid][Iconsapi] = STREAMER_TAG_MAP_ICON: -1;
	}
}

RefreshMapJobSapi(playerid)
{
	DeleteJobPemerahMap(playerid);

	if(pData[playerid][pJob] == 5)
	{
		if(!pData[playerid][pJobmilkduty])
		{
			PemerasArea[playerid][Dutyarea] = CreateDynamicCircle(300.12, 1141.13, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Dutycp] = CreateDynamicCP(300.12, 1141.13, 9.13, 2.0, -1, -1, playerid, 30.0);

			destroyladangsapi();
		}
		else
		{
			PemerasArea[playerid][Dutyarea] = CreateDynamicCircle(300.12, 1141.13, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Dutycp] = CreateDynamicCP(300.12, 1141.13, 9.13, 2.0, -1, -1, playerid, 30.0);

			PemerasArea[playerid][Olahsusu] = CreateDynamicCircle(315.27, 1154.77, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Olahcp] = CreateDynamicCP(315.27, 1154.77, 8.58, 2.0, -1, -1, playerid, 30.0);

			PemerasArea[playerid][Iconsapi] = CreateDynamicMapIcon(300.12, 1141.13, 9.13, 19238, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);

			createladangsapi();
		}
		return 1;
	}
	if(pData[playerid][pJob2] == 5)
	{
		if(!pData[playerid][pJobmilkduty])
		{
			PemerasArea[playerid][Dutyarea] = CreateDynamicCircle(300.12, 1141.13, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Dutycp] = CreateDynamicCP(300.12, 1141.13, 9.13, 2.0, -1, -1, playerid, 30.0);

			destroyladangsapi();
		}
		else
		{
			PemerasArea[playerid][Dutyarea] = CreateDynamicCircle(300.12, 1141.13, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Dutycp] = CreateDynamicCP(300.12, 1141.13, 9.13, 2.0, -1, -1, playerid, 30.0);

			PemerasArea[playerid][Olahsusu] = CreateDynamicCircle(315.27, 1154.77, 1.0, -1, -1, playerid);
			PemerasArea[playerid][Olahcp] = CreateDynamicCP(315.27, 1154.77, 8.58, 2.0, -1, -1, playerid, 30.0);

			PemerasArea[playerid][Iconsapi] = CreateDynamicMapIcon(300.12, 1141.13, 9.13, 19238, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);

			createladangsapi();
		}
	}

	return 1;
}

createladangsapi()
{
	new object_world = -1, object_int = -1;
	cow1 = CreateDynamicObject(19833, 253.927902, 1140.457641, 10.066599, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
	cow2 = CreateDynamicObject(19833, 253.927902, 1130.417602, 9.526599, 0.000000, 0.000000, 95.800003, object_world, object_int, -1, 300.00, 300.00); 
	cow3 = CreateDynamicObject(19833, 245.680389, 1129.579833, 9.946600, 0.000000, 0.000000, -29.899995, object_world, object_int, -1, 300.00, 300.00); 
	cow4 = CreateDynamicObject(19833, 237.748306, 1134.141479, 10.526604, 0.000000, 0.000000, 85.899993, object_world, object_int, -1, 300.00, 300.00); 
	cow5 = CreateDynamicObject(19833, 238.098693, 1139.028808, 10.746607, 0.000000, 0.000000, 128.600006, object_world, object_int, -1, 300.00, 300.00); 
	cow6 = CreateDynamicObject(19833, 233.163864, 1145.209228, 11.486613, 0.000000, 0.000000, -154.399993, object_world, object_int, -1, 300.00, 300.00); 
	cow7 = CreateDynamicObject(19833, 231.071533, 1133.838745, 10.976607, 0.000000, 0.000000, -101.399978, object_world, object_int, -1, 300.00, 300.00); 
	cow8 = CreateDynamicObject(19833, 233.103103, 1129.363769, 10.686608, 0.000000, 0.000000, 97.500015, object_world, object_int, -1, 300.00, 300.00); 
	cow9 = CreateDynamicObject(19833, 237.083068, 1125.641357, 10.506606, 0.000000, 0.000000, 97.500015, object_world, object_int, -1, 300.00, 300.00); 
	cow10 = CreateDynamicObject(19833, 247.684814, 1152.292846, 10.876612, 0.000000, 0.000000, 137.499984, object_world, object_int, -1, 300.00, 300.00); 
	cow11 = CreateDynamicObject(19833, 244.711456, 1142.905395, 10.536610, 0.000000, 0.000000, 69.499938, object_world, object_int, -1, 300.00, 300.00); 
	cow12 = CreateDynamicObject(19833, 261.201599, 1146.604125, 9.896611, 0.000000, 0.000000, -27.000057, object_world, object_int, -1, 300.00, 300.00); 
	cow13 = CreateDynamicObject(19833, 260.699554, 1137.599853, 9.486606, 0.000000, 0.000000, -79.700073, object_world, object_int, -1, 300.00, 300.00); 
	cow14 = CreateDynamicObject(19833, 262.818328, 1125.940917, 9.226603, 0.000000, 0.000000, -141.400070, object_world, object_int, -1, 300.00, 300.00); 

	return 1;
}

destroyladangsapi()
{
	DestroyDynamicObject(cow1);
	DestroyDynamicObject(cow2);
	DestroyDynamicObject(cow3);
	DestroyDynamicObject(cow4);
	DestroyDynamicObject(cow5);
	DestroyDynamicObject(cow6);
	DestroyDynamicObject(cow7);
	DestroyDynamicObject(cow8);
	DestroyDynamicObject(cow9);
	DestroyDynamicObject(cow10);
	DestroyDynamicObject(cow11);
	DestroyDynamicObject(cow12);
	DestroyDynamicObject(cow13);
	DestroyDynamicObject(cow14);


	return 1;
}

function spawncow1(playerid)
{
	new object_world = -1, object_int = -1;
    cow1 = CreateDynamicObject(19833, 253.927902, 1140.457641, 10.066599, 0.000000, 0.000000, 0.000000, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow2(playerid)
{
	new object_world = -1, object_int = -1;
    cow2 = CreateDynamicObject(19833, 253.927902, 1130.417602, 9.526599, 0.000000, 0.000000, 95.800003, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow3(playerid)
{
	new object_world = -1, object_int = -1;
    cow3 = CreateDynamicObject(19833, 245.680389, 1129.579833, 9.946600, 0.000000, 0.000000, -29.899995, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow4(playerid)
{
	new object_world = -1, object_int = -1;
    cow4 = CreateDynamicObject(19833, 237.748306, 1134.141479, 10.526604, 0.000000, 0.000000, 85.899993, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow5(playerid)
{
	new object_world = -1, object_int = -1;
    cow5 = CreateDynamicObject(19833, 238.098693, 1139.028808, 10.746607, 0.000000, 0.000000, 128.600006, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow6(playerid)
{
	new object_world = -1, object_int = -1;
    cow6 = CreateDynamicObject(19833, 233.163864, 1145.209228, 11.486613, 0.000000, 0.000000, -154.399993, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow7(playerid)
{
	new object_world = -1, object_int = -1;
    cow7 = CreateDynamicObject(19833, 231.071533, 1133.838745, 10.976607, 0.000000, 0.000000, -101.399978, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow8(playerid)
{
	new object_world = -1, object_int = -1;
    cow8 = CreateDynamicObject(19833, 233.103103, 1129.363769, 10.686608, 0.000000, 0.000000, 97.500015, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow9(playerid)
{
	new object_world = -1, object_int = -1;
    cow9 = CreateDynamicObject(19833, 237.083068, 1125.641357, 10.506606, 0.000000, 0.000000, 97.500015, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow10(playerid)
{
	new object_world = -1, object_int = -1;
    cow10 = CreateDynamicObject(19833, 247.684814, 1152.292846, 10.876612, 0.000000, 0.000000, 137.499984, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow11(playerid)
{
	new object_world = -1, object_int = -1;
    cow11 = CreateDynamicObject(19833, 244.711456, 1142.905395, 10.536610, 0.000000, 0.000000, 69.499938, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow12(playerid)
{
	new object_world = -1, object_int = -1;
    cow12 = CreateDynamicObject(19833, 261.201599, 1146.604125, 9.896611, 0.000000, 0.000000, -27.000057, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow13(playerid)
{
	new object_world = -1, object_int = -1;
    cow13 = CreateDynamicObject(19833, 260.699554, 1137.599853, 9.486606, 0.000000, 0.000000, -79.700073, object_world, object_int, -1, 300.00, 300.00); 
}

function spawncow14(playerid)
{
	new object_world = -1, object_int = -1;
    cow14 = CreateDynamicObject(19833, 262.818328, 1125.940917, 9.226603, 0.000000, 0.000000, -141.400070, object_world, object_int, -1, 300.00, 300.00); 
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5 && pData[playerid][pJobmilkduty] == true)
	{
		if(IsPlayerInDynamicArea(playerid, PemerasArea[playerid][Olahsusu]))
		{
			if(areaid == PemerasArea[playerid][Olahsusu])
			{
				Jembut(playerid, "Mengolah Susu", 4);
			}
		}
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_WALK && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pJob] == 5 && pData[playerid][pJobmilkduty] == true)
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 253.927902, 1140.457641, 10.066599))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk1", 10000, true, "i", playerid);
            ShowProgressbar(playerid, "Mengambil Susu..", 10);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 253.927902, 1130.417602, 9.526599))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk2", 10000, true, "i", playerid);
            ShowProgressbar(playerid, "Mengambil Susu..", 10);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 245.680389, 1129.579833, 9.946600))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk3", 10000, true, "i", playerid);
            ShowProgressbar(playerid, "Mengambil Susu..", 10);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 237.748306, 1134.141479, 10.526604))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk4", 10000, true, "i", playerid);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
            ShowProgressbar(playerid, "Mengambil Susu..", 10);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 238.098693, 1139.028808, 10.746607))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk5", 10000, true, "i", playerid);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
            ShowProgressbar(playerid, "Mengambil Susu..", 10);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 233.163864, 1145.209228, 11.486613))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk6", 10000, true, "i", playerid);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
            ShowProgressbar(playerid, "Mengambil Susu..", 10);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 231.071533, 1133.838745, 10.976607))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk7", 10000, true, "i", playerid);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
            ShowProgressbar(playerid, "Mengambil Susu..", 10);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 233.103103, 1129.363769, 10.686608))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk8", 10000, true, "i", playerid);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
            ShowProgressbar(playerid, "Mengambil Susu..", 10);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 237.083068, 1125.641357, 10.506606))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk9", 10000, true, "i", playerid);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
            ShowProgressbar(playerid, "Mengambil Susu..", 10);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 247.684814, 1152.292846, 10.876612))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk10", 10000, true, "i", playerid);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
            ShowProgressbar(playerid, "Mengambil Susu..", 10);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 244.711456, 1142.905395, 10.536610))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk11", 10000, true, "i", playerid);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
            ShowProgressbar(playerid, "Mengambil Susu..", 10);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 261.201599, 1146.604125, 9.896611))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk12", 10000, true, "i", playerid);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
            ShowProgressbar(playerid, "Mengambil Susu..", 10);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 260.699554, 1137.599853, 9.486606))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk13", 10000, true, "i", playerid);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
            ShowProgressbar(playerid, "Mengambil Susu..", 10);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
        }
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 262.818328, 1125.940917, 9.226603))
        {
        	if(pData[playerid][pSusu] == 20) return ErrorMsg(playerid, "Inventory susu Anda Sudah Penuh MAX: 20 susu");
        	if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            TogglePlayerControllable(playerid, 0);
            SetPVarInt(playerid, "delay", gettime() + 30);
            pData[playerid][pMilkJob] = SetTimerEx("takemilk14", 10000, true, "i", playerid);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
            ShowProgressbar(playerid, "Mengambil Susu..", 10);
            ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
        }
        if(IsPlayerInRangeOfPoint(playerid, 4.0,315.5888, 1154.6294, 8.5859, 8.58))
        {
        	return callcmd::olahsusu(playerid, "");
        }
    }
    else if(newkeys & KEY_YES && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pJob2] == 5)
	{
		if(IsPlayerInDynamicArea(playerid, PemerasArea[playerid][Dutyarea]))
		{
			if(!pData[playerid][pJobmilkduty])
			{
				pData[playerid][pJobmilkduty] = true;
				SuccesMsg(playerid, "Anda sekarang menggunakan baju kerja");

				RefreshMapJobSapi(playerid);

				Info(playerid, "Silakan Dekatkan Sapi di ladang sapi Lalu KLIK Y");
			}
			else
			{
				pData[playerid][pJobmilkduty] = false;
				SuccesMsg(playerid, "Anda Sekarang menggunakan baju warga");
				RefreshMapJobSapi(playerid);
			}
		}
	}
	return 1;
}

function takemilk1(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if((pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
			SetTimerEx("spawncow1", 100000, false, "i", playerid);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pProgress] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow1);
		}
	return 1;
}

function takemilk2(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if((pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
			SetTimerEx("spawncow2", 100000, false, "i", playerid);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pProgress] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow2);
		}
	return 1;
}

function takemilk3(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if((pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
			SetTimerEx("spawncow3", 100000, false, "i", playerid);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pProgress] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow3);
		}
	return 1;
}

function takemilk4(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if((pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
			SetTimerEx("spawncow4", 100000, false, "i", playerid);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pProgress] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow4);
	}

	return 1;
}

function takemilk5(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if((pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
			SetTimerEx("spawncow5", 100000, false, "i", playerid);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pProgress] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow5);
		}
	return 1;
}

function takemilk6(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if((pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
			SetTimerEx("spawncow6", 100000, false, "i", playerid);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pProgress] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow6);
		}
		return 1;
}

function takemilk7(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if((pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
			SetTimerEx("spawncow7", 100000, false, "i", playerid);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pProgress] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow7);
		}
	return 1;
}

function takemilk8(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if((pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
			SetTimerEx("spawncow8", 100000, false, "i", playerid);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pProgress] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow8);
		}
	return 1;
}

function takemilk9(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if((pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
			SetTimerEx("spawncow9", 100000, false, "i", playerid);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pProgress] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow9);
		}
	return 1;
}

function takemilk10(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if((pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
			SetTimerEx("spawncow10", 100000, false, "i", playerid);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pProgress] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow10);
	}

	return 1;
}

function takemilk11(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if((pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
			SetTimerEx("spawncow11", 100000, false, "i", playerid);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pProgress] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow11);
		}
	return 1;
}

function takemilk12(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if((pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
			SetTimerEx("spawncow12", 100000, false, "i", playerid);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pProgress] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow12);
	}
	return 1;
}

function takemilk13(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if((pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
			SetTimerEx("spawncow13", 100000, false, "i", playerid);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pProgress] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow13);
	}
	return 1;
}

function takemilk14(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if((pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
			SetTimerEx("spawncow14", 100000, false, "i", playerid);
			ShowItemBox(playerid, "Susu", "Received_1x", 19570, 3);
			SuccesMsg(playerid, "Taking Succes!");
			pData[playerid][pSusu] ++;
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pProgress] = 0;
			ClearAnimations(playerid);
			DestroyDynamicObject(cow14);
		}
	return 1;
}

CMD:olahsusu(playerid, params[])
{
	if(pData[playerid][pJobTime] > 0) return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0, 315.27, 1154.77, 8.58))
		{
			//if(pData[playerid][pLoading] == true) return ErrorMsg(playerid, "Anda masih olah susu!");
			if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
			if(pData[playerid][pSusu] < 1) return ErrorMsg(playerid, "Kamu harus mengambil susu terlebih dahulu!");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			TogglePlayerControllable(playerid, 0);
			//pData[playerid][pLoading] = true;
			pData[playerid][pMilkJob] = SetTimerEx("olahsusu", 4000, true, "i", playerid);
			ShowProgressbar(playerid, "Mengolah Susu..", 4);
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 0, 1);
			SuccesMsg(playerid, "Anda telah berhasil mengolah susu");
			ShowItemBox(playerid, "Susu_Olahan", "Received_1x", 19569, 3);
			ShowItemBox(playerid, "Susu", "Removed_1x", 19570, 3);
			pData[playerid][pSusu] --;
			pData[playerid][pSusuOlahan]++;
		}
		else return ErrorMsg(playerid, "Kamu tidak berada ditempat pemeras susu");
	}
	else return ErrorMsg(playerid, "Kamu bukan pekerja pemeras susu!");

	return 1;
}

function olahsusu(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if((pData[playerid][pMilkJob])) return 0;
	if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
	{
			SuccesMsg(playerid, "Anda telah berhasil mengolah susu");
			ShowItemBox(playerid, "Susu_Olahan", "Received_1x", 19569, 3);
			ShowItemBox(playerid, "Susu", "Removed_1x", 19570, 3);
			TogglePlayerControllable(playerid, 1);
			KillTimer(pData[playerid][pMilkJob]);
			pData[playerid][pProgress] = 0;
			//pData[playerid][pLoading] = false;
			pData[playerid][pSusu] --;
			ClearAnimations(playerid);
			pData[playerid][pSusuOlahan]++;
	}
	return 1;
}
CMD:jualsusuaufa(playerid, params[])
{
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    new total = pData[playerid][pSusuOlahan];
    if(pData[playerid][pSusuOlahan] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Susu Olahan");
    ShowProgressbar(playerid, "Menjual Susu..", total);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pSusuOlahan] * 30;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pSusuOlahan] -= total;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, total);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Susu_Olahan", str, 19569, total);
    Inventory_Update(playerid);
	return 1;
}
