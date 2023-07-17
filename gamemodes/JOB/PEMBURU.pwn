new Text3D: TRusa[MAX_PLAYERS][3];
new JobHunter[MAX_PLAYERS];
new PutRusa[MAX_PLAYERS];
new ORusa[MAX_PLAYERS];
#define ORusa1 -533.976440, -2303.278808, 29.644664
#define ORusa2 -552.976440, -2322.278808, 27.944664
#define ORusa3 -560.676513, -2331.678222, 27.344661
#define YCM SendClientMessage
#define YPRES(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define COLOR_REDZ       0xFF0000FF
#define COLOR_YELLOWZ 	0xFFFF00AA

stock DelHunter(playerid)
{
	JobHunter[playerid] = 0;
	PutRusa[playerid] = 0;
	DestroyDynamicObject(ORusa[playerid]);
	DestroyDynamic3DTextLabel(TRusa[playerid][0]);
	DestroyDynamic3DTextLabel(TRusa[playerid][1]);
	DestroyDynamic3DTextLabel(TRusa[playerid][2]);
}

stock CPHunter(playerid)
{
	if(JobHunter[playerid] == 1)
	{
		printf("============================");
		printf("=====[ JOB PEMBURU AUFA ]====");
		printf("============================");
		if(JobHunter[playerid] == 1)
		{
			DisablePlayerCheckpoint(playerid);
			SendClientMessage(playerid, -1, "Cari rusa disekitar");
			ORusa[playerid] = CreateDynamicObject(19315, -533.976440, -2303.278808, 29.644664, 0.000000, 0.000000, -35.000000);
		}
	}
}
stock DEN_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(JobHunter[playerid] == 1)
	{
		if(YPRES(KEY_FIRE))
		{
			if(IsPlayerInRangeOfPoint(playerid, 5, ORusa1))
			{
				if(GetPlayerWeapon(playerid) == 25)
				{
					DestroyDynamicObject(ORusa[playerid]);
                    ORusa[playerid] = CreateDynamicObject(19315, -533.976440, -2303.278808, 29.144664, 90.000000, 0.000000, -35.000000);
					TRusa[playerid][0] = CreateDynamic3DTextLabel("{BABABA}Rusa\n"YELLOW_E"Tertembak\nTekan "LG_E"ALT {FFFFFF}untuk memotong daging", COLOR_YELLOWZ, ORusa1, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
                }
            }
        }
    }
	if(JobHunter[playerid] == 2)
	{
	if(YPRES(KEY_FIRE))
	{
		if(IsPlayerInRangeOfPoint(playerid, 5, ORusa2))
		{
			if(GetPlayerWeapon(playerid) == 25)
			{
					DestroyDynamicObject(ORusa[playerid]);
					ORusa[playerid] = CreateDynamicObject(19315, -552.976440, -2322.278808, 27.544664, 90.000000, 0.000000, -35.000000);
					TRusa[playerid][0] = CreateDynamic3DTextLabel("{BABABA}Rusa\n"YELLOW_E"Tertembak\nTekan "LG_E"ALT {FFFFFF}untuk memotong daging", COLOR_YELLOWZ, ORusa1, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
                }
            }
        }
    }
	if(JobHunter[playerid] == 3)
	{
		if(PutRusa[playerid] == 0)
		{
			if(YPRES(KEY_FIRE))
			{
				if(IsPlayerInRangeOfPoint(playerid, 5, ORusa3))
				{
					if(GetPlayerWeapon(playerid) == 25)
					{
						DestroyDynamicObject(ORusa[playerid]);
						ORusa[playerid] = CreateDynamicObject(19315, -560.676513, -2331.678222, 26.944662, 90.000000, 0.000000, -25.000000);
						TRusa[playerid][2] = CreateDynamic3DTextLabel("{BABABA}Rusa\n"YELLOW_E"Tertembak\nTekan "LG_E"ALT {FFFFFF}untuk memotong daging", COLOR_YELLOWZ, ORusa1, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
					}
				}
            }
        }
    }
	return 1;
}
CMD:ambilrusa(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 5, ORusa1))
	{
		if(JobHunter[playerid] != 1) return ErrorMsg(playerid, "Belum Mengambil Rusa Sebelumnya");
		{
			JobHunter[playerid] = 2;
			DestroyDynamicObject(ORusa[playerid]);
			DisablePlayerCheckpoint(playerid);
			DestroyDynamicObject(ORusa[playerid]);
			DestroyDynamic3DTextLabel(TRusa[playerid][0]);
			DestroyDynamic3DTextLabel(TRusa[playerid][1]);
			DestroyDynamic3DTextLabel(TRusa[playerid][2]);
			SetPlayerCheckpoint(playerid, ORusa2, 1);
			ORusa[playerid] = CreateDynamicObject(19315, -552.976440, -2322.278808, 27.944664, 0.000000, 0.000000, -35.000000);
		    SetTimerEx("WaktuBerburu", 5000, false, "d", playerid);
		    ShowProgressbar(playerid, "Mengambil Rusa..", 5);
		    ApplyAnimation(playerid, "COP_AMBIENT", "Copbrowse_loop", 4.0, 1, 0, 0, 0, 0, 1);
		}
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5, ORusa2))
	{
		if(JobHunter[playerid] != 2) return ErrorMsg(playerid, "Belum Mengambil Rusa Sebelumnya");
		{
			JobHunter[playerid] = 3;
			DestroyDynamicObject(ORusa[playerid]);
			DisablePlayerCheckpoint(playerid);
			DestroyDynamicObject(ORusa[playerid]);
			DestroyDynamic3DTextLabel(TRusa[playerid][0]);
			DestroyDynamic3DTextLabel(TRusa[playerid][1]);
			DestroyDynamic3DTextLabel(TRusa[playerid][2]);
			SetPlayerCheckpoint(playerid, ORusa3, 1);
			ORusa[playerid] = CreateDynamicObject(19315, -560.676513, -2331.678222, 27.344661, 0.000000, 0.000000, -25.000000);
		    SetTimerEx("WaktuBerburu", 5000, false, "d", playerid);
		    ShowProgressbar(playerid, "Mengambil Rusa..", 5);
		    ApplyAnimation(playerid, "COP_AMBIENT", "Copbrowse_loop", 4.0, 1, 0, 0, 0, 0, 1);
		}
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5, ORusa3))
	{
		if(JobHunter[playerid] != 3) return ErrorMsg(playerid, "Belum Mengambil Rusa Sebelumnya");
		if(PutRusa[playerid] == 1) return ErrorMsg(playerid, "Kamu Sudah Mengambil Rusa");
		{
			DisablePlayerCheckpoint(playerid);
			DestroyDynamicObject(ORusa[playerid]);
			DestroyDynamic3DTextLabel(TRusa[playerid][0]);
			DestroyDynamic3DTextLabel(TRusa[playerid][1]);
			DestroyDynamic3DTextLabel(TRusa[playerid][2]);
		    SetTimerEx("WaktuBerburu1", 5000, false, "d", playerid);
		    ShowProgressbar(playerid, "Mengambil Rusa..", 5);
		    ApplyAnimation(playerid, "COP_AMBIENT", "Copbrowse_loop", 4.0, 1, 0, 0, 0, 0, 1);
	  	}
	}
	return 1;
}
