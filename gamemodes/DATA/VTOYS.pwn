/*stock GetPlayerVehicle(playerid, vehicleid)
{
	if(!IsPlayerConnected(playerid)) return -1;
	if(!GetVehicleModel(vehicleid)) return -1;
    for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
    {
        if(PlayerVehicleInfo[playerid][v][pvId] == vehicleid)
        {
            return v;
        }
    }
    return -1;
}*/

// Vehicle attach update types
const FloatX =  1;
const FloatY =  2;
const FloatZ =  3;
const FloatRX = 4;
const FloatRY = 5;
const FloatRZ = 6;

new Float:NudgeVal[MAX_PLAYERS];

MySQL_LoadVehicleToys(vehicleid)
{
	new tstr[512];
	mysql_format(g_SQL, tstr, sizeof(tstr), "SELECT * FROM vtoys WHERE Owner='%d' LIMIT 1", pvData[vehicleid][cID]);
	mysql_tquery(g_SQL, tstr, "LoadVehicleToys", "i", vehicleid);
}

function LoadVehicleToys(vehicleid)
{
	new rows = cache_num_rows(), vehid = pvData[vehicleid][cVeh];
 	if(rows)
  	{
		pvData[vehid][PurchasedvToy] = true;
		cache_get_value_name_int(0, "Slot0_Modelid", vtData[vehid][0][vtoy_modelid]);
  		cache_get_value_name_float(0, "Slot0_XPos", vtData[vehid][0][vtoy_x]);
  		cache_get_value_name_float(0, "Slot0_YPos", vtData[vehid][0][vtoy_y]);
  		cache_get_value_name_float(0, "Slot0_ZPos", vtData[vehid][0][vtoy_z]);
  		cache_get_value_name_float(0, "Slot0_XRot", vtData[vehid][0][vtoy_rx]);
  		cache_get_value_name_float(0, "Slot0_YRot", vtData[vehid][0][vtoy_ry]);
  		cache_get_value_name_float(0, "Slot0_ZRot", vtData[vehid][0][vtoy_rz]);

		cache_get_value_name_int(0, "Slot1_Modelid", vtData[vehid][1][vtoy_modelid]);
  		cache_get_value_name_float(0, "Slot1_XPos", vtData[vehid][1][vtoy_x]);
  		cache_get_value_name_float(0, "Slot1_YPos", vtData[vehid][1][vtoy_y]);
  		cache_get_value_name_float(0, "Slot1_ZPos", vtData[vehid][1][vtoy_z]);
  		cache_get_value_name_float(0, "Slot1_XRot", vtData[vehid][1][vtoy_rx]);
  		cache_get_value_name_float(0, "Slot1_YRot", vtData[vehid][1][vtoy_ry]);
  		cache_get_value_name_float(0, "Slot1_ZRot", vtData[vehid][1][vtoy_rz]);
		
		cache_get_value_name_int(0, "Slot2_Modelid", vtData[vehid][2][vtoy_modelid]);
  		cache_get_value_name_float(0, "Slot2_XPos", vtData[vehid][2][vtoy_x]);
  		cache_get_value_name_float(0, "Slot2_YPos", vtData[vehid][2][vtoy_y]);
  		cache_get_value_name_float(0, "Slot2_ZPos", vtData[vehid][2][vtoy_z]);
  		cache_get_value_name_float(0, "Slot2_XRot", vtData[vehid][2][vtoy_rx]);
  		cache_get_value_name_float(0, "Slot2_YRot", vtData[vehid][2][vtoy_ry]);
  		cache_get_value_name_float(0, "Slot2_ZRot", vtData[vehid][2][vtoy_rz]);
		
		cache_get_value_name_int(0, "Slot3_Modelid", vtData[vehid][3][vtoy_modelid]);
  		cache_get_value_name_float(0, "Slot3_XPos", vtData[vehid][3][vtoy_x]);
  		cache_get_value_name_float(0, "Slot3_YPos", vtData[vehid][3][vtoy_y]);
  		cache_get_value_name_float(0, "Slot3_ZPos", vtData[vehid][3][vtoy_z]);
  		cache_get_value_name_float(0, "Slot3_XRot", vtData[vehid][3][vtoy_rx]);
  		cache_get_value_name_float(0, "Slot3_YRot", vtData[vehid][3][vtoy_ry]);
  		cache_get_value_name_float(0, "Slot3_ZRot", vtData[vehid][3][vtoy_rz]);

		AttachVehicleToys(vehid);
	}
}

MySQL_SaveVehicleToys(vehicleid)
{
	new line4[1600], lstr[1024], x = pvData[vehicleid][cVeh];

	//if(pvData[x][PurchasedvToy] == false) return true;

	mysql_format(g_SQL, lstr, sizeof(lstr),
	"UPDATE `vtoys` SET \
	`Slot0_Modelid` = %d, `Slot0_XPos` = %.3f, `Slot0_YPos` = %.3f, `Slot0_ZPos` = %.3f, `Slot0_XRot` = %.3f, `Slot0_YRot` = %.3f, `Slot0_ZRot` = %.3f,",
		vtData[x][0][vtoy_modelid],
        vtData[x][0][vtoy_x],
        vtData[x][0][vtoy_y],
        vtData[x][0][vtoy_z],
        vtData[x][0][vtoy_rx],
        vtData[x][0][vtoy_ry],
        vtData[x][0][vtoy_rz]);
	strcat(line4, lstr);

	mysql_format(g_SQL, lstr, sizeof(lstr),
	" `Slot1_Modelid` = %d, `Slot1_XPos` = %.3f, `Slot1_YPos` = %.3f, `Slot1_ZPos` = %.3f, `Slot1_XRot` = %.3f, `Slot1_YRot` = %.3f, `Slot1_ZRot` = %.3f,",
		vtData[x][1][vtoy_modelid],
        vtData[x][1][vtoy_x],
        vtData[x][1][vtoy_y],
        vtData[x][1][vtoy_z],
        vtData[x][1][vtoy_rx],
        vtData[x][1][vtoy_ry],
        vtData[x][1][vtoy_rz]);
  	strcat(line4, lstr);

    mysql_format(g_SQL, lstr, sizeof(lstr),
	" `Slot2_Modelid` = %d, `Slot2_XPos` = %.3f, `Slot2_YPos` = %.3f, `Slot2_ZPos` = %.3f, `Slot2_XRot` = %.3f, `Slot2_YRot` = %.3f, `Slot2_ZRot` = %.3f,",
		vtData[x][2][vtoy_modelid],
	    vtData[x][2][vtoy_x],
	    vtData[x][2][vtoy_y],
	    vtData[x][2][vtoy_z],
	    vtData[x][2][vtoy_rx],
	    vtData[x][2][vtoy_ry],
	    vtData[x][2][vtoy_rz]);
  	strcat(line4, lstr);

    mysql_format(g_SQL, lstr, sizeof(lstr),
	" `Slot3_Modelid` = %d, `Slot3_XPos` = %.3f, `Slot3_YPos` = %.3f, `Slot3_ZPos` = %.3f, `Slot3_XRot` = %.3f, `Slot3_YRot` = %.3f, `Slot3_ZRot` = %.3f WHERE `Owner` = '%d'",
		vtData[x][3][vtoy_modelid],
	    vtData[x][3][vtoy_x],
	    vtData[x][3][vtoy_y],
	    vtData[x][3][vtoy_z],
	    vtData[x][3][vtoy_rx],
	    vtData[x][3][vtoy_ry],
	    vtData[x][3][vtoy_rz],
	    pvData[vehicleid][cID]);
  	strcat(line4, lstr);

    mysql_tquery(g_SQL, line4);
    return 1;
}

MySQL_CreateVehicleToy(vehicleid)
{
	new query[1000];

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO `vtoys` (`Owner`) VALUES ('%d')", pvData[vehicleid][cID]);
	mysql_tquery(g_SQL, query);
	pvData[vehicleid][PurchasedvToy] = true;

	for(new i = 0; i < 4; i++)
	{
		vtData[vehicleid][i][vtoy_modelid] = 0;
		vtData[vehicleid][i][vtoy_x] = 0.0;
		vtData[vehicleid][i][vtoy_y] = 0.0;
		vtData[vehicleid][i][vtoy_z] = 0.0;
		vtData[vehicleid][i][vtoy_rx] = 0.0;
		vtData[vehicleid][i][vtoy_ry] = 0.0;
		vtData[vehicleid][i][vtoy_rz] = 0.0;
	}
}

AttachVehicleToys(vehicleid)
{
	if(pvData[vehicleid][PurchasedvToy] == false) return 1;

	if(vtData[vehicleid][0][vtoy_model] == 0)
	{
		vtData[vehicleid][0][vtoy_model] = CreateObject(vtData[vehicleid][0][vtoy_modelid],
 	 	vtData[vehicleid][0][vtoy_x],
		vtData[vehicleid][0][vtoy_y],
		vtData[vehicleid][0][vtoy_z],
		vtData[vehicleid][0][vtoy_rx],
		vtData[vehicleid][0][vtoy_ry],
		vtData[vehicleid][0][vtoy_rz]);

		AttachObjectToVehicle(vtData[vehicleid][0][vtoy_model],
		vehicleid,
		vtData[vehicleid][0][vtoy_x],
		vtData[vehicleid][0][vtoy_y],
		vtData[vehicleid][0][vtoy_z],
		vtData[vehicleid][0][vtoy_rx],
		vtData[vehicleid][0][vtoy_ry],
		vtData[vehicleid][0][vtoy_rz]);
	}
	if(vtData[vehicleid][1][vtoy_model] == 0)
	{
		vtData[vehicleid][1][vtoy_model] = CreateObject(vtData[vehicleid][1][vtoy_modelid],
 	 	vtData[vehicleid][1][vtoy_x],
		vtData[vehicleid][1][vtoy_y],
		vtData[vehicleid][1][vtoy_z],
		vtData[vehicleid][1][vtoy_rx],
		vtData[vehicleid][1][vtoy_ry],
		vtData[vehicleid][1][vtoy_rz]);

		AttachObjectToVehicle(vtData[vehicleid][1][vtoy_model],
		vehicleid,
		vtData[vehicleid][1][vtoy_x],
		vtData[vehicleid][1][vtoy_y],
		vtData[vehicleid][1][vtoy_z],
		vtData[vehicleid][1][vtoy_rx],
		vtData[vehicleid][1][vtoy_ry],
		vtData[vehicleid][1][vtoy_rz]);
	}
	if(vtData[vehicleid][2][vtoy_model] == 0)
	{
		vtData[vehicleid][2][vtoy_model] = CreateObject(vtData[vehicleid][2][vtoy_modelid],
 	 	vtData[vehicleid][2][vtoy_x],
		vtData[vehicleid][2][vtoy_y],
		vtData[vehicleid][2][vtoy_z],
		vtData[vehicleid][2][vtoy_rx],
		vtData[vehicleid][2][vtoy_ry],
		vtData[vehicleid][2][vtoy_rz]);

		AttachObjectToVehicle(vtData[vehicleid][2][vtoy_model],
		vehicleid,
		vtData[vehicleid][2][vtoy_x],
		vtData[vehicleid][2][vtoy_y],
		vtData[vehicleid][2][vtoy_z],
		vtData[vehicleid][2][vtoy_rx],
		vtData[vehicleid][2][vtoy_ry],
		vtData[vehicleid][2][vtoy_rz]);
	}
	if(vtData[vehicleid][3][vtoy_model] == 0)
	{
		vtData[vehicleid][3][vtoy_model] = CreateObject(vtData[vehicleid][3][vtoy_modelid],
 	 	vtData[vehicleid][3][vtoy_x],
		vtData[vehicleid][3][vtoy_y],
		vtData[vehicleid][3][vtoy_z],
		vtData[vehicleid][3][vtoy_rx],
		vtData[vehicleid][3][vtoy_ry],
		vtData[vehicleid][3][vtoy_rz]);

		AttachObjectToVehicle(vtData[vehicleid][3][vtoy_model],
		vehicleid,
		vtData[vehicleid][3][vtoy_x],
		vtData[vehicleid][3][vtoy_y],
		vtData[vehicleid][3][vtoy_z],
		vtData[vehicleid][3][vtoy_rx],
		vtData[vehicleid][3][vtoy_ry],
		vtData[vehicleid][3][vtoy_rz]);
	}
	return 1;
}

function AddVObjPos(playerid)
{
	new vehid = GetPlayerVehicleID(playerid), gametext[36];
	new idxs = pvData[vehid][vtoySelected];
	if(pData[playerid][EditStatus] == FloatX)
	{
		vtData[vehid][idxs][vtoy_x] += NudgeVal[playerid];
		format(gametext, 36, "Float X: ~w~%f", vtData[vehid][idxs][vtoy_x]);
	} 
	else if(pData[playerid][EditStatus] == FloatY)
	{
		vtData[vehid][idxs][vtoy_y] += NudgeVal[playerid];
		format(gametext, 36, "Float Y: ~w~%f", vtData[vehid][idxs][vtoy_y]);
	}
	else if(pData[playerid][EditStatus] == FloatZ)
	{
		vtData[vehid][idxs][vtoy_z] += NudgeVal[playerid];
		format(gametext, 36, "Float Z: ~w~%f", vtData[vehid][idxs][vtoy_z]);
	}
	else if(pData[playerid][EditStatus] == FloatRX)
	{
		vtData[vehid][idxs][vtoy_rx] += NudgeVal[playerid];
		format(gametext, 36, "Float RX: ~w~%f", vtData[vehid][idxs][vtoy_rx]);
	}
	else if(pData[playerid][EditStatus] == FloatRY)
	{
		vtData[vehid][idxs][vtoy_ry] += NudgeVal[playerid];
		format(gametext, 36, "Float RY: ~w~%f", vtData[vehid][idxs][vtoy_ry]);
	}
	else if(pData[playerid][EditStatus] == FloatRZ)
	{
		vtData[vehid][idxs][vtoy_rz] += NudgeVal[playerid];
		format(gametext, 36, "Float RZ: ~w~%f", vtData[vehid][idxs][vtoy_rz]);
	}
	PlayerTextDrawSetString(playerid, EditVObjTD[playerid][5], gametext);
	AttachObjectToVehicle(vtData[vehid][idxs][vtoy_model], vehid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z], vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
}
function SubVObjPos(playerid)
{
	new vehid = GetPlayerVehicleID(playerid), gametext[36];
	new idxs = pvData[vehid][vtoySelected];
	if(pData[playerid][EditStatus] == FloatX)
	{
		vtData[vehid][idxs][vtoy_x] -= NudgeVal[playerid];
		format(gametext, 36, "Float X: ~w~%f", vtData[vehid][idxs][vtoy_x]);
	} 
	else if(pData[playerid][EditStatus] == FloatY)
	{
		vtData[vehid][idxs][vtoy_y] -= NudgeVal[playerid];
		format(gametext, 36, "Float Y: ~w~%f", vtData[vehid][idxs][vtoy_y]);
	}
	else if(pData[playerid][EditStatus] == FloatZ)
	{
		vtData[vehid][idxs][vtoy_z] -= NudgeVal[playerid];
		format(gametext, 36, "Float Z: ~w~%f", vtData[vehid][idxs][vtoy_z]);
	}
	else if(pData[playerid][EditStatus] == FloatRX)
	{
		vtData[vehid][idxs][vtoy_rx] -= NudgeVal[playerid];
		format(gametext, 36, "Float RX: ~w~%f", vtData[vehid][idxs][vtoy_rx]);
	}
	else if(pData[playerid][EditStatus] == FloatRY)
	{
		vtData[vehid][idxs][vtoy_ry] -= NudgeVal[playerid];
		format(gametext, 36, "Float RY: ~w~%f", vtData[vehid][idxs][vtoy_ry]);
	}
	else if(pData[playerid][EditStatus] == FloatRZ)
	{
		vtData[vehid][idxs][vtoy_rz] -= NudgeVal[playerid];
		format(gametext, 36, "Float RZ: ~w~%f", vtData[vehid][idxs][vtoy_rz]);
	}
	PlayerTextDrawSetString(playerid, EditVObjTD[playerid][5], gametext);
	AttachObjectToVehicle(vtData[vehid][idxs][vtoy_model], vehid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z], vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
}

stock ShowEditVehicleTD(pid)
{
	for(new x; x < 8; x++)
	{
		SelectTextDraw(pid, 0xFF0000FF);
		PlayerTextDrawShow(pid, EditVObjTD[pid][x]);
	}
}
stock HideEditVehicleTD(pid)
{
	for(new x; x < 8; x++)
	{
		PlayerTextDrawHide(pid, EditVObjTD[pid][x]);
		CancelSelectTextDraw(pid);
	}
}

CMD:vehtoys(playerid)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{	
		new string[350];
		new x = GetPlayerVehicleID(playerid);
		foreach(new i: PVehicles)
		{
			if(x == pvData[i][cVeh])
			{
				pData[playerid][VehicleID] = pvData[i][cVeh];
				if(vtData[pvData[i][cVeh]][0][vtoy_modelid] == 0)
				{
				    strcat(string, ""dot"Slot 1\n");
				}
				else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

				if(vtData[pvData[i][cVeh]][1][vtoy_modelid] == 0)
				{
				    strcat(string, ""dot"Slot 2\n");
				}
				else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

				if(vtData[pvData[i][cVeh]][2][vtoy_modelid] == 0)
				{
				    strcat(string, ""dot"Slot 3\n");
				}
				else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

				if(vtData[pvData[i][cVeh]][3][vtoy_modelid] == 0)
				{
				    strcat(string, ""dot"Slot 4\n");
				}
				else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");
				
				ShowPlayerDialog(playerid, DIALOG_MODTBUY, DIALOG_STYLE_LIST, "Kota Executive - Vehicle Toys", string, "Pilih", "Batal");
			}
		}
	}
	else return Error(playerid, "Anda harus mengendarai kendaraan!");
	
	return 1;
}

CMD:vtoys(playerid)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{	
		new string[350];
		new x = GetPlayerVehicleID(playerid);
		foreach(new i: PVehicles)
		if(x == pvData[i][cVeh])
		{
			pData[playerid][VehicleID] = pvData[i][cVeh];
			if(vtData[pvData[i][cVeh]][0][vtoy_modelid] == 0)
			{
			    strcat(string, ""dot"Slot 1\n");
			}
			else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

			if(vtData[pvData[i][cVeh]][1][vtoy_modelid] == 0)
			{
			    strcat(string, ""dot"Slot 2\n");
			}
			else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

			if(vtData[pvData[i][cVeh]][2][vtoy_modelid] == 0)
			{
			    strcat(string, ""dot"Slot 3\n");
			}
			else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

			if(vtData[pvData[i][cVeh]][3][vtoy_modelid] == 0)
			{
			    strcat(string, ""dot"Slot 4\n");
			}
			else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");
			
			strcat(string, ""dot""RED_E"Reset All Object\n");
			strcat(string, ""dot""RED_E"Refresh All Object");
			ShowPlayerDialog(playerid, DIALOG_MODTOY, DIALOG_STYLE_LIST, "Kota Executive - Vehicle Toys", string, "Pilih", "Batal");
		}
	}
	else return ErrorMsg(playerid, "Anda harus mengendarai kendaraan!");
	
	return 1;
}
