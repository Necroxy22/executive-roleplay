//GALEH KAYA KONTOL SUKA MAKELAR
// Server Define
#define TEXT_GAMEMODE	"EXE v0.2"
#define TEXT_WEBURL		"Executive.xyz"
#define TEXT_LANGUAGE	"Bahasa Indonesia"
#define SERVER_BOT      "Executive Roleplay"
#define SERVER_NAME     "Executive Roleplay"

#define		MYSQL_HOST 			"localhost"
#define		MYSQL_USER 			"root"
#define		MYSQL_PASSWORD 		""
#define		MYSQL_DATABASE 		"rapsody715"

// how many seconds until it kicks the player for taking too long to login
#define		SECONDS_TO_LOGIN 	200

// default spawn point: Las Venturas (The High Roller)
#define 	DEFAULT_POS_X       1053.953613
#define 	DEFAULT_POS_Y 		1001.667663
#define 	DEFAULT_POS_Z 		1001.085937
#define 	DEFAULT_POS_A 		178.048751


#define ATENTIE 0xAFAFAFAA

#define IJAL  "Aufa"


//Android Client Check
#define IsPlayerAndroid(%0)                 GetPVarInt(%0, "NotAndroid") == 0

#define Loop(%0,%1,%2) for(new %0 = %2; %0 < %1; %0++)

// Message
#define function%0(%1) forward %0(%1); public %0(%1)
#define Servers(%1,%2) SendClientMessageEx(%1, COLOR_WHITE, "[i]: {ffffff}"%2)
#define Info(%1,%2) SendClientMessageEx(%1, COLOR_WHITE, "[i]: {ffffff}"%2)
#define Vehicle(%1,%2) SendClientMessageEx(%1, ARWIN, "[V]: "WHITE_E""%2)
#define Usage(%1,%2) SendClientMessage(%1, ARWIN , "[USAGE]: "WHITEP_E""%2)
#define Error(%1,%2) SendClientMessageEx(%1, COLOR_GREY3, ""RED_E"[ERROR]: "WHITE_E""%2)
#define AdminCMD(%1,%2) SendClientMessageEx(%1, COLOR_YELLOW , "AdmCmd: "%2)
#define Gps(%1,%2) SendClientMessageEx(%1, COLOR_GREY3, ""COLOR_GPS"[GPS]: "WHITE_E""%2)
#define PermissionError(%0) SendClientMessage(%0, COLOR_RED, "[KESALAHAN]: "WHITE_E"Kamu tidak memiliki akses untuk melakukan command ini!")
#define SCM SendClientMessage
#define SM(%0,%1) \
    SendClientMessageEx(%0, COLOR_YELLOW, "»"WHITE_E" "%1)

#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

//Converter
#define minplus(%1) \
        (((%1) < 0) ? (-(%1)) : ((%1)))

// AntiCaps
#define UpperToLower(%1) for( new ToLowerChar; ToLowerChar < strlen( %1 ); ToLowerChar ++ ) if ( %1[ ToLowerChar ]> 64 && %1[ ToLowerChar ] < 91 ) %1[ ToLowerChar ] += 32

// Banneds
const BAN_MASK = (-1 << (32 - (/*this is the CIDR ip detection range [def: 26]*/26)));

//---------[ Define Faction ]-----
#define SAPD	1		//locker 1573.26, -1652.93, -40.59
#define	SAGS	2		// 1464.10, -1790.31, 2349.68
#define SAMD	3		// -1100.25, 1980.02, -58.91
#define SANEW	4		// 256.14, 1776.99, 701.08
//---------[ JOB ]---------//
#define BOX_INDEX            9 // Index Box Barang

#define NT_DISTANCE 25.0
//anti db
#define OBJECT_TYPE_BODY 1
#define MAX_WARININGS (3)
#define MAX_VEHICLE_OBJECT 10

#define MODEL_SELECTION_Loco    14
#define MODEL_SELECTION_Transfender     16
#define MODEL_SELECTION_Waa     15

new g_player_listitem[MAX_PLAYERS][96];
#define GetPlayerListitemValue(%0,%1) 		g_player_listitem[%0][%1]
#define SetPlayerListitemValue(%0,%1,%2) 	g_player_listitem[%0][%1] = %2
