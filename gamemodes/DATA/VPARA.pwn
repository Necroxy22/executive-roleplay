//VEH PARACHUTE BY HAN

new vpara[MAX_PLAYERS]; 
new para[MAX_VEHICLES];

CMD:vpara(playerid)
{ 
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "Ошибка: Чтобы использовать команду ты должен быть в транспорте."); 
    new vid = GetPlayerVehicleID(playerid); 
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) 
    { 
        if(vpara[playerid]==0) 
        { 
            para[vid] = CreateDynamicObject(18849,0.0,0.0,-6000.0,0.0,0.0,0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)); 
            SendClientMessage(playerid, -1, "~Parachute Attached."); 
            switch(random(5)) 
            { 
                case 0: { 

               SetDynamicObjectMaterial(para[vid],0,18841,"MickyTextures", "Smileyface2",0x00000000); 
               SetDynamicObjectMaterial(para[vid],2,10412,"hotel1", "carpet_red_256",0x00FFFFFF); 

                } 
                case 1: { 

               SetDynamicObjectMaterial(para[vid],0,18841,"MickyTextures", "red032",0x00000000); 
               SetDynamicObjectMaterial(para[vid],2,10412,"hotel1", "carpet_red_256", 0x00FFFFFF); 

                } 
                case 2: { 

                SetDynamicObjectMaterial(para[vid],0,18841,"MickyTextures", "ws_gayflag1", 0x00000000); 
                SetDynamicObjectMaterial(para[vid],2,10412,"hotel1", "carpet_red_256", 0x00FFFFFF); 

                } 
                case 3: { 

                SetDynamicObjectMaterial(para[vid],0,18841,"MickyTextures", "waterclear256",0x00000000); 
                SetDynamicObjectMaterial(para[vid],2,10412,"hotel1", "carpet_red_256",0x00FFFFFF); 

                } 
                case 4: { 

                SetDynamicObjectMaterial(para[vid],2,10412,"hotel1", "carpet_red_256",0x00FFFFFF); 

                } 
            } 
            new Float:x,Float:y,Float:z; 
            GetVehicleModelInfo(GetVehicleModel(vid),VEHICLE_MODEL_INFO_SIZE,x,y,z); 
            z /= 2.0; 
            AttachDynamicObjectToVehicle(para[vid],vid,0.0,0.0,z+6.0,0.0,0.0,90.0); 
            vpara[playerid] = 1; 
            return 1; 
        } 
        if(vpara[playerid]==1) 
        { 
            SendClientMessage(playerid, -1, "~Парашют удален."); 
            DestroyDynamicObject(para[vid]); 
            vpara[playerid]=0; 
            return 1; 
        } 
    } 
    return 1; 
}  