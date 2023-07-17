RGBAToARGB(rgba)
    return rgba >>> 8 | rgba << 24;

#define GetVehicleBoot(%0,%1,%2,%3)				GetVehicleOffset((%0),VEHICLE_OFFSET_BOOT,(%1),(%2),(%3))

enum OffsetTypes {
	VEHICLE_OFFSET_BOOT,
	VEHICLE_OFFSET_HOOD,
	VEHICLE_OFFSET_ROOF
};

enum VehicleProperties {
	e_VEHICLE_PAINTJOB,
	e_VEHICLE_INTERIOR,
	e_VEHICLE_COLOR_1,
	e_VEHICLE_COLOR_2,
	e_VEHICLE_HORN,
	e_VEHICLE_SPAWN_X,
	e_VEHICLE_SPAWN_Y,
	e_VEHICLE_SPAWN_Z,
	e_VEHICLE_SPAWN_A,
	e_VEHICLE_SPAWN_VW,
	e_VEHICLE_SPAWN_INT,
	e_VEHICLE_SPEED_CAP,
	e_VEHICLE_FUEL_USE,
	e_VEHICLE_FUEL,
	e_VEHICLE_STICKY,
	e_VEHICLE_UNO_DAMAGE,
	e_VEHICLE_CAP_DAMAGE,
	e_VEHICLE_EDITOR,
	e_VEHICLE_DAMAGE_PANELS,
	e_VEHICLE_DAMAGE_DOORS,
	e_VEHICLE_DAMAGE_LIGHTS,
	e_VEHICLE_DAMAGE_TIRES,
	e_VEHICLE_BOMB,
	e_VEHICLE_BOMB_TIMER
};

GetVehicleOffset(vehicleid, OffsetTypes:type,&Float:x,&Float:y,&Float:z)
{
	new Float:fPos[4],Float:fSize[3];

	if(!IsValidVehicle(vehicleid)){
		x = y =	z = 0.0;
		return 0;
	} else {
		GetVehiclePos(vehicleid,fPos[0],fPos[1],fPos[2]);
		GetVehicleZAngle(vehicleid,fPos[3]);
		GetVehicleModelInfo(GetVehicleModel(vehicleid),VEHICLE_MODEL_INFO_SIZE,fSize[0],fSize[1],fSize[2]);

		switch(type){
			case VEHICLE_OFFSET_BOOT: {
				x = fPos[0] - (floatsqroot(fSize[1] + fSize[1]) * floatsin(-fPos[3],degrees));
				y = fPos[1] - (floatsqroot(fSize[1] + fSize[1]) * floatcos(-fPos[3],degrees));
 				z = fPos[2];
			}
			case VEHICLE_OFFSET_HOOD: {
				x = fPos[0] + (floatsqroot(fSize[1] + fSize[1]) * floatsin(-fPos[3],degrees));
				y = fPos[1] + (floatsqroot(fSize[1] + fSize[1]) * floatcos(-fPos[3],degrees));
	 			z = fPos[2];
			}
			case VEHICLE_OFFSET_ROOF: {
				x = fPos[0];
				y = fPos[1];
				z = fPos[2] + floatsqroot(fSize[2]);
			}
		}
	}
	return 1;
}
