enum BlinkingLights
{
	V_BLINK,
	V_BLINKING
};
new g_vehicle_params[MAX_VEHICLES][BlinkingLights];

forward BlinkingLight(playerid);
public BlinkingLight(playerid)
{
	new vehicleid = GetPVarInt(playerid,"BlinkVehID"), panels, doors, lights, tires;
	if(g_vehicle_params[vehicleid][V_BLINK] == 1)
{
GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

if(g_vehicle_params[vehicleid][V_BLINKING] == 1)
{
	UpdateVehicleDamageStatus(vehicleid, 0, doors, 1, tires);
	g_vehicle_params[vehicleid][V_BLINKING] = 69;
	}
		else if(g_vehicle_params[vehicleid][V_BLINKING] == 69)
		{
			UpdateVehicleDamageStatus(vehicleid, 0, doors, 69, tires);
			g_vehicle_params[vehicleid][V_BLINKING] = 0;
		}
		else if(g_vehicle_params[vehicleid][V_BLINKING] == 0)
		{
			UpdateVehicleDamageStatus(vehicleid, 0, doors, 1, tires);
			g_vehicle_params[vehicleid][V_BLINKING] = 4;
		}
		else
		{
			UpdateVehicleDamageStatus(vehicleid, 0, doors, 4, tires);
			g_vehicle_params[vehicleid][V_BLINKING] = 1;
		}
	}
}

CMD:siren(playerid, params[])
{

	if(pData[playerid][pFaction] == 1 || pData[playerid][pFaction] == 3)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		SetPVarInt(playerid, "BlinkVehID", vehicleid);
		if(g_vehicle_params[vehicleid][V_BLINK] == 1)
		{
			g_vehicle_params[vehicleid][V_BLINK] = 0;
			Info(playerid, "Siren {FF0000}OFF");
		}
		else
		{
			g_vehicle_params[vehicleid][V_BLINK] = 1;
			Info(playerid, "Siren {00FF00}ON");
		}
	}
	else
	{
		return Error(playerid, "You not police/medical.");
	}
    return 1;
}
