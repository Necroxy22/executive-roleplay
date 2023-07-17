
#include <a_samp>
#pragma warning disable 217, 203, 204, 211, 202, 215, 219, 213
#undef MAX_PLAYERS
#define MAX_PLAYERS 500
#include <crashdetect>
#include <gvar>
#include <a_mysql>
#include <a_actor>
#include <a_zones>
#include <progress2>
#include <Pawn.CMD>
#include <mSelection.inc>
#include <FiTimestamp>
#define ENABLE_3D_TRYG_YSI_SUPPORT
#include <3DTryg>
#include <streamer>
#include <EVF2>
#include <YSI\y_timers>
#include <YSI\y_ini>
#include <sscanf2>
#include <yom_buttons>
#include <geoiplite>
#include <garageblock>
#include <tp>
#include <compat>
#define DCMD_PREFIX '!'
#include <discord-connector>
#include <discord-cmd>
#include <fixobject>
#include <timerfix.inc>
#include <VehiclePartPosition>
//#include <GPS>
#define MAX_AUCTIONS    10
//-----[ Modular ]-----
#include "DATA\DEFINE.pwn"
//#include "DATA\GPS.pwn"
#include "DATA\VPARA.pwn"
//BAJU SYSTEM
new delaykargo;
new cskin[MAX_PLAYERS];
new rusa;
//id atas pala
new Text:txt;
new PlayerText:ID[MAX_PLAYERS];
new Text3D:playerID[MAX_PLAYERS];

static const PedMan[] =
{
    1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33,
	34, 35, 36, 37, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 68, 72, 73,
	78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
	110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133,
	134, 135, 136, 137, 142, 143, 144, 146, 153, 154, 156, 158, 159, 160, 161, 162, 167, 168, 170,
	171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 188, 189, 190, 200, 202, 203,
	204, 206, 208, 209, 210, 212, 213, 217, 220, 221, 222, 223, 228, 229, 230, 234, 235, 236, 239, 240, 241,
	242, 247, 248, 249, 250, 253, 254, 255, 258, 259, 260, 261, 262, 268, 272, 273, 289, 290, 291, 292, 293,
	294, 296, 297, 299
};
static const PedMale[] =
{
    9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69, 75, 76, 77, 85, 88, 89, 90, 91, 92,
	93, 129, 130, 131, 138, 140, 141, 145, 148, 150, 151, 152, 157, 169, 178, 190, 191, 192, 193, 194, 195, 196,
	197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245,
	246, 251, 256, 257, 263, 298
};
//=================================================
new bool:explosive[MAX_PLAYERS char] = {false,...};
new Text:gspeedo[4];
new Text:speedo_dot[21];
new Text: nopixel[1];
new Text:speedo_number[12];
new WaktuMolotov[MAX_PLAYERS];
new PakaiSenjata[MAX_PLAYERS];
new carvid_0;
#include <sampvoice>
#define MAX_RADIOS 999
new SV_LSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... };
new SV_GSTREAM:gstream = SV_NULL;
new SV_GSTREAM:StreamTelpon[MAX_PLAYERS] = { SV_NULL, ... };
new SV_GSTREAM:StreamFreq[MAX_RADIOS] = SV_NULL;
new IDStream[MAX_PLAYERS];
//=========[ JAM FIVEM ]==========
new JamFivEm;
new DetikFivEm;
new rentalbike;
new rentalterminal;
new asuransi;
new sellpv;
new garasisamd;
new garasisags;
new garasigojek;
new kanabis1;
new kanabis2;
new kanabis3;
new kanabis4;
new kanabis5;
new kanabis6;
new kanabis7;
new garasipedagang;
new rentalpelabuhan;
new kendaraansapd;
new gudangkota;
new menumasak;
new menuminum;
new menupedagang;
new sppelabuhan;
//aufa rob
new createlockpick;
//=======[ ATM FIVEM]=======
new atm1;
new atm2;
new atm3;
new atm4;
new atm5;
new atm6;
new atm7;
//========[ MANCING CP ]========
new mancing1;
new mancing2;
new mancing3;
new mancing4;
new mancing5;
new mancing6;
new mancing7;
new mancing8;
new mancing9;
new mancing10;
//======[ JOB BY Aufa ]========
new Sopirbus;
new tukangayam;
new petani;
new tukangtebang;
new penambangminyak;
new penjahit;
new pemerah;
new penambang;
//=======[ JOB PEMERAH Aufa ]=========
new PemerahCP;
new Trucker;
new Disnaker;
new Healing;
//jualbotol
new JualIkan;
new JualNambang;
new JualPetani;
new JualKayu;
new JualBotol;
//pernikahan
new pernikahan;
//creategun
new Creategunn;
//================================
new
    JOB[MAX_PLAYERS], inJOB[MAX_PLAYERS], Car_Job[MAX_PLAYERS], timer_Car[MAX_PLAYERS], stresstimer[MAX_PLAYERS], KeluarKerja[MAX_PLAYERS],
    Seconds_timer[MAX_PLAYERS], Hunter_Deer[MAX_PLAYERS], Meeters_BTWDeer[MAX_PLAYERS], TimerKeluar[MAX_PLAYERS],
    Meeters[MAX_PLAYERS], Deer[MAX_PLAYERS], Deep_Deer[MAX_PLAYERS], Meeter_Kill[MAX_PLAYERS],
    Shoot_Deer[MAX_PLAYERS];

//han
new STATUS_BOT2;

static warnings[MAX_PLAYERS char] = {0,...};
new Text3D:TagKeluar[MAX_PLAYERS];
//new DCC_Channel:g_Discord_CHENH4X;

//-----[ Quiz ]-----
new quiz,
	answers[256],
	answermade,
	qprs;

//-----[ Twitter ]-----
new tweet[60];

//-----[ New HamZyy ]----
//rob
//new DCC_Channel:chLogsRobbank;
//New GMX
new CurGMX;
//Enum GMX
forward DoGMX();
//


//-----[ Rob ]-----
new RobMember = 0;

//-----[ Event ]-----
new EventCreated = 0, 
	EventStarted = 0, 
	EventPrize = 500;
new Float: RedX, 
	Float: RedY, 
	Float: RedZ, 
	EventInt, 
	EventWorld;
new Float: BlueX, 
	Float: BlueY, 
	Float: BlueZ;
new EventHP = 100,
	EventArmour = 0,
	EventLocked = 0;
new EventWeapon1, 
	EventWeapon2, 
	EventWeapon3, 
	EventWeapon4, 
	EventWeapon5;
new BlueTeam = 0, 
	RedTeam = 0;
new MaxRedTeam = 5, 
	MaxBlueTeam = 5;
new IsAtEvent[MAX_PLAYERS];


new AntiBHOP[MAX_PLAYERS];

new InRob[MAX_PLAYERS];
//-----[ Discord Connector ]-----
new pemainic;
new upt = 0;

//-----[ Selfie System ]-----
new takingselfie[MAX_PLAYERS];
new Float:Degree[MAX_PLAYERS];
const Float: Radius = 1.4; //do not edit this
const Float: Speed  = 1.25; //do not edit this
const Float: Height = 1.0; // do not edit this
new Float:lX[MAX_PLAYERS];
new Float:lY[MAX_PLAYERS];
new Float:lZ[MAX_PLAYERS];
//=========[ TIMER ]============//
new olahh[MAX_PLAYERS];
new ayamjob[MAX_PLAYERS];
//=========[ DISCORD ]============//
new DCC_Channel:g_Discord_Serverstatus;

enum
{
	//JOBBALKOTi
	DIALOG_GPS_PETANI,
	DIALOG_DISNAKER,
	DIALOG_GARASIPD,
	DIALOG_GUDANGBARU,
	DIALOG_GARASIMD,
	DIALOG_GARASIPEDAGANG,
	DIALOG_GARASIGOJEK,
	DIALOG_GARASISAGS,
	DIALOG_INPUTFUEL,
	DIALOG_WITHDEPO,
	DIALOG_KARGO,
	DIALOG_LOCKERAYAM,
	DIALOG_WALLPAPER,
	DIALOG_NANAMBIBIT,
	DIALOG_ASURANSI,
	DIALOG_BELIBIBIT,
	DIALOG_PROSESTANI,
	DIALOG_ONDUTY,
	DIALOG_LOCKERPEMERAH,
	DIALOG_DOKUMEN,
	DIALOG_LOCKERPENJAHIT,
	DIALOG_LOCKERTUKANGKAYU,
	DIALOG_GOJEK,
	DIALOG_GOPAY,
	DIALOG_VOICE,
	DIALOG_LOCKERMINYAK,
	DIALOG_GOTOPUP,
	DIALOG_GOFOOD,
	DIALOG_GOCAR,
	DIALOG_GPS_BUS,
	DIALOG_GPSPENJAHIT,
	DIALOG_VRM,
	DIALOG_LOCKERPENAMBANG,
	DIALOG_TINGGI,
	DIALOG_BERAT,
	DIALOG_AYAMFILL,
	DIALOG_REPORTS,
	//dialog radial menu dewata
	DIALOG_RADIAL,
	DIALOG_WT,
	DIALOG_HOLIMARKET,

	DIALOG_JUALIKAN,
	DIALOG_TAMBANG,
	DIALOG_JUALPETANI,
	DIALOG_JUALKAYU,

	DIALOG_RADIO,
	DIALOG_GPSSPAREPART,
	DIALOG_LOCKERGOJEK,
	//modshop
	DIALOG_GIVE,
	DIALOG_AMOUNT,
	DIALOG_MODSHOP,
	DIALOG_MAKE_CHAR,
	DIALOG_CHARLIST,
	DIALOG_VERIFYCODE,
	DIALOG_UNUSED,
    DIALOG_LOGIN,
    DIALOG_REGISTER,
    DIALOG_AGE,
	DIALOG_GENDER,
	DIALOG_EMAIL,
	DIALOG_PASSWORD,
	DIALOG_STATS,
	DIALOG_SETTINGS,
	DIALOG_HBEMODE,
	DIALOG_CHANGEAGE,
	DIALOG_GOLDSHOP,
	// MODSHOP
	DIALOG_MODMENU,
	DIALOG_MODTOY,
	DIALOG_MODTBUY,
	DIALOG_MODTEDIT,
	DIALOG_MODTPOSX,
	DIALOG_MODTPOSY,
	DIALOG_MODTPOSZ,
	DIALOG_MODTPOSRX,
	DIALOG_MODTPOSRY,
	DIALOG_MODTPOSRZ,
	DIALOG_MODTSELECTPOS,
	DIALOG_MODTSETVALUE,
	DIALOG_MODTSETCOLOUR,
	DIALOG_MODTSETPOS,
	DIALOG_MODTACCEPT,
	DIALOG_GOLDNAME,
	DIALOG_SELL_BISNISS,
	DIALOG_SELL_BISNIS,
	DIALOG_MY_BISNIS,
	DIALOG_MENU,
	DIALOG_MENUMASAK,
	DIALOG_LOCKERPEDAGANG,
	DIALOG_LOCKFAMS,
	DIALOG_GPS_KARGO,
	DIALOG_GPS_TUKANGKAYU,
	DIALOG_MENUMINUM,
	DIALOG_GUDANGPEDAGANG,
	DIALOG_SIMPAN,
	DIALOG_SIMPANUANG,
	DIALOG_TAKEMONEY,
	DIALOG_TAKE,
	DIALOG_WEAPONPEDAGANG,
	DIALOG_MMENU,
	BISNIS_MENU,
	BISNIS_INFO,
	BISNIS_NAME,
	BISNIS_VAULT,
	BISNIS_WITHDRAW,
	BISNIS_DEPOSIT,
	BISNIS_BUYPROD,
	BISNIS_EDITPROD,
	BISNIS_PRICESET,
	DIALOG_SELL_HOUSES,
	DIALOG_SELL_HOUSE,
	DIALOG_MY_HOUSES,
	DIALOG_MY_SG,
	DIALOG_SG_MENU,
	DIALOG_SETNAME,
	DIALOG_MAT,
	DIALOG_COM,
	DIALOG_UANG,
	DIALOG_COM2,
	DIALOG_MAT2,
	DIALOG_AMBILUANG,
	DIALOG_DEPOUANG,
	HOUSE_INFO,
	HOUSE_STORAGE,
	HOUSE_WEAPONS,
	HOUSE_MONEY,
	HOUSE_REALMONEY,
	HOUSE_WITHDRAW_REALMONEY,
	HOUSE_DEPOSIT_REALMONEY,
	HOUSE_REDMONEY,
	HOUSE_WITHDRAW_REDMONEY,
	HOUSE_DEPOSIT_REDMONEY,
	HOUSE_FOODDRINK,
	HOUSE_FOOD,
	HOUSE_FOOD_DEPOSIT,
	HOUSE_FOOD_WITHDRAW,
	HOUSE_DRINK,
	HOUSE_DRINK_DEPOSIT,
	HOUSE_DRINK_WITHDRAW,
	HOUSE_DRUGS,
	HOUSE_MEDICINE,
	HOUSE_MEDICINE_DEPOSIT,
	HOUSE_MEDICINE_WITHDRAW,
	HOUSE_MEDKIT,
	HOUSE_MEDKIT_DEPOSIT,
	HOUSE_MEDKIT_WITHDRAW,
	HOUSE_BANDAGE,
	HOUSE_BANDAGE_DEPOSIT,
	HOUSE_BANDAGE_WITHDRAW,
	HOUSE_OTHER,
	HOUSE_SEED,
	HOUSE_SEED_DEPOSIT,
	HOUSE_SEED_WITHDRAW,
	HOUSE_MATERIAL,
	HOUSE_MATERIAL_DEPOSIT,
	HOUSE_MATERIAL_WITHDRAW,
	HOUSE_COMPONENT,
	HOUSE_COMPONENT_DEPOSIT,
	HOUSE_COMPONENT_WITHDRAW,
	HOUSE_MARIJUANA,
	HOUSE_MARIJUANA_DEPOSIT,
	HOUSE_MARIJUANA_WITHDRAW,
	DIALOG_TRACK,
	DIALOG_TRACK_PH,
	DIALOG_INFO_BIS,
	DIALOG_INFO_HOUSE,
	DIALOG_FINDVEH,
	DIALOG_TRACKVEH,
	DIALOG_TRACKVEH2,
	DIALOG_TRACKPARKEDVEH,
	DIALOG_GOTOVEH,
	DIALOG_GETVEH,
	DIALOG_DELETEVEH,
	DIALOG_BUYPV,
	DIALOG_BUYVIPPV,
	DIALOG_BUYPLATE,
	DIALOG_LOCKVEH,
	DIALOG_BUYPVCP,
	DIALOG_BUYPVCP_BIKES,
	DIALOG_BUYPVCP_CARS,
	DIALOG_BUYPVCP_UCARS,
	DIALOG_BUYPVCP_JOBCARS,
	DIALOG_BUYPVCP_VIPCARS,
	DIALOG_BUYPVCP_CONFIRM,
	DIALOG_BUYPVCP_VIPCONFIRM,
	DIALOG_RENT_JOBCARS,
	DIALOG_RENT_JOBCARSCONFIRM,
	DIALOG_SKINFAM,
	DIALOG_RENT_BOAT,
	DIALOG_RENT_BOATCONFIRM,
	DIALOG_RENT_BIKE,
	DIALOG_RENT_BIKECONFIRM,
	DIALOG_GARKOT,
	DIALOG_GUDANG,
	DIALOG_MY_VEHICLE,
	DIALOG_TOY,
	DIALOG_TOYEDIT,
	DIALOG_TOYEDIT_ANDROID,
	DIALOG_TOYPOSISI,
	DIALOG_TOYPOSISIBUY,
	DIALOG_TOYBUY,
	DIALOG_TOYVIP,
	DIALOG_TOYPOSX,
	DIALOG_TOYPOSY,
	DIALOG_TOYPOSZ,
	DIALOG_TOYPOSRX,
	DIALOG_TOYPOSRY,
	DIALOG_TOYPOSRZ,
	DIALOG_TOYPOSSX,
	DIALOG_TOYPOSSY,
	DIALOG_TOYPOSSZ,
	//ingame map
	DIALOG_MTEDIT,
	DIALOG_EDIT,
	DIALOG_X,
	DIALOG_Y,
	DIALOG_Z,
	DIALOG_RX,
	DIALOG_RY,
	DIALOG_RZ,
	DIALOG_MTC,
	DIALOG_COORD,
	DIALOG_MTX,
	DIALOG_MTY,
	DIALOG_MTZ,
	DIALOG_MTRX,
	DIALOG_MTRY,
	DIALOG_MTRZ,
	DIALOG_HELP,
	DIALOG_GPS,
	DIALOG_JOB,
	DIALOG_GPS_MINYAK,
	DIALOG_GPS_PEMERASSUSU,
	DIALOG_GPS_PENAMBANG,
	DIALOG_GPS_JOB,
	DIALOG_GPS_PUBLIC,
	DIALOG_GPS_PROPERTIES,
	DIALOG_GPS_GENERAL,
	DIALOG_GPS_MISSION,
	DIALOG_GPS_AYAM,
	DIALOG_TRACKBUSINESS,
	DIALOG_ELECTRONIC_TRACK,
	DIALOG_PAYBILL,
	DIALOG_PAY,
	DIALOG_EDITBONE,
	FAMILY_SAFE,
	FAMILY_STORAGE,
	FAMILY_WEAPONS,
	FAMILY_MARIJUANA,
	FAMILY_WITHDRAWMARIJUANA,
	FAMILY_DEPOSITMARIJUANA,
	FAMILY_COMPONENT,
	FAMILY_WITHDRAWCOMPONENT,
	FAMILY_DEPOSITCOMPONENT,
	FAMILY_MATERIAL,
	FAMILY_WITHDRAWMATERIAL,
	FAMILY_DEPOSITMATERIAL,
	FAMILY_MONEY,
	FAMILY_WITHDRAWMONEY,
	FAMILY_DEPOSITMONEY,
	FAMILY_INFO,
	DIALOG_SERVERMONEY,
	DIALOG_SERVERMONEY_STORAGE,
	DIALOG_SERVERMONEY_WITHDRAW,
	DIALOG_SERVERMONEY_DEPOSIT,
	DIALOG_SERVERMONEY_REASON,
	DIALOG_LOCKERSAPD,
	DIALOG_WEAPONSAPD,
	DIALOG_LOCKERSAGS,
	DIALOG_WEAPONSAGS,
	DIALOG_LOCKERSAMD,
	DIALOG_WEAPONSAMD,
	DIALOG_DRUGSSAMD,
	DIALOG_LOCKERSANEW,
	DIALOG_WEAPONSANEW,
	DIALOG_LOCKERVIP,
	DIALOG_SERVICE,
	DIALOG_SERVICE_COLOR,
	DIALOG_SERVICE_COLOR2,
	DIALOG_SERVICE_PAINTJOB,
	DIALOG_SERVICE_WHEELS,
	DIALOG_SERVICE_SPOILER,
	DIALOG_SERVICE_HOODS,
	DIALOG_SERVICE_VENTS,
	DIALOG_SERVICE_LIGHTS,
	DIALOG_SERVICE_EXHAUSTS,
	DIALOG_SERVICE_FRONT_BUMPERS,
	DIALOG_SERVICE_REAR_BUMPERS,
	DIALOG_SERVICE_ROOFS,
	DIALOG_SERVICE_SIDE_SKIRTS,
	DIALOG_SERVICE_BULLBARS,
	DIALOG_SERVICE_NEON,
	DIALOG_MENU_TRUCKER,
	DIALOG_SHIPMENTS,
	DIALOG_SHIPMENTS_VENDING,
	DIALOG_HAULING,
	DIALOG_RESTOCK,
	DIALOG_RESTOCK_VENDING,
	DIALOG_ARMS_GUN,
	DIALOG_PLANT,
	DIALOG_EDIT_PRICE,
	DIALOG_EDIT_PRICE1,
	DIALOG_EDIT_PRICE2,
	DIALOG_EDIT_PRICE3,
	DIALOG_EDIT_PRICE4,
	DIALOG_OFFER,
	DIALOG_MATERIAL,
	DIALOG_COMPONENT,
	DIALOG_DRUGS,
	DIALOG_FOOD,
	DIALOG_FOOD_BUY,
	DIALOG_SEED_BUY,
	DIALOG_PRODUCT,
	DIALOG_GASOIL,
	DIALOG_APOTEK,
	DIALOG_ATM,
	DIALOG_TRACKATM,
	DIALOG_ATMDEPOSIT,
	DIALOG_ATMWITHDRAW,
	DIALOG_BSHOP,
	DIALOG_BANK,
	DIALOG_BANKDEPOSIT,
	DIALOG_BANKWITHDRAW,
	DIALOG_BANKREKENING,
	DIALOG_BANKTRANSFER,
	DIALOG_BANKCONFIRM,
	DIALOG_BANKSUKSES,
	DIALOG_PHONE,
	DIALOG_TWITTER,
	DIALOG_TWITTERPOST,
	DIALOG_TWITTERNAME,
	DIALOG_PHONE_ADDCONTACT,
	DIALOG_PHONE_CONTACT,
	DIALOG_PHONE_NEWCONTACT,
	DIALOG_PHONE_INFOCONTACT,
	DIALOG_PHONE_SENDSMS,
	DIALOG_PHONE_TEXTSMS,
	DIALOG_PHONE_DIALUMBER,
	DIALOG_TOGGLEPHONE,
	DIALOG_IBANK,
	DIALOG_AYAM,
	DIALOG_ASKS,
	DIALOG_SALARY,
	DIALOG_PAYCHECK,
	DIALOG_BUS,
	DIALOG_RUTE_BUS,
	DIALOG_HEALTH,
	DIALOG_OBAT,
	DIALOG_ISIKUOTA,
	DIALOG_DOWNLOAD,
	DIALOG_KUOTA,
	DIALOG_STUCK,
	DIALOG_TDM,
	DIALOG_PICKUPVEH,
	DIALOG_TRACKPARK,
	DIALOG_MY_WS,
	DIALOG_TRACKWS,
	WS_MENU,
	WS_SETNAME,
	WS_SETOWNER,
	WS_SETEMPLOYE,
	WS_SETEMPLOYEE,
	WS_SETOWNERCONFIRM,
	WS_SETMEMBER,
	WS_SETMEMBERE,
	WS_MONEY,
	WS_WITHDRAWMONEY,
	WS_DEPOSITMONEY,
	WS_COMPONENT,
	WS_COMPONENT2,
	WS_MATERIAL,
	WS_MATERIAL2,
	DIALOG_ACTORANIM,
	DIALOG_MY_VENDING,
	DIALOG_VENDING_INFO,
	DIALOG_VENDING_BUYPROD,
	DIALOG_VENDING_MANAGE,
	DIALOG_VENDING_NAME,
	DIALOG_VENDING_VAULT,
	DIALOG_VENDING_WITHDRAW,
	DIALOG_VENDING_DEPOSIT,
	DIALOG_VENDING_EDITPROD,
	DIALOG_VENDING_PRICESET,
	DIALOG_VENDING_RESTOCK,
	DIALOG_SPAWN_1,
	DIALOG_MYVEH,
	DIALOG_MYVEH_INFO,
	DIALOG_FAMILY_INTERIOR,
	DIALOG_SPAREPART,
	DIALOG_BUYPARTS,
	DIALOG_BUYPARTS_DONE,
	VEHICLE_STORAGE,
	VEHICLE_WEAPON,
	VEHICLE_MONEY,
	VEHICLE_REALMONEY,
	VEHICLE_REALMONEY_WITHDRAW,
	VEHICLE_REALMONEY_DEPOSIT,
	VEHICLE_REDMONEY,
	VEHICLE_REDMONEY_WITHDRAW,
	VEHICLE_REDMONEY_DEPOSIT,
	VEHICLE_DRUGS,
	VEHICLE_MEDICINE,
	VEHICLE_MEDICINE_WITHDRAW,
	VEHICLE_MEDICINE_DEPOSIT,
	VEHICLE_MEDKIT,
	VEHICLE_MEDKIT_WITHDRAW,
	VEHICLE_MEDKIT_DEPOSIT,
	VEHICLE_BANDAGE,
	VEHICLE_BANDAGE_WITHDRAW,
	VEHICLE_BANDAGE_DEPOSIT,
	VEHICLE_OTHER,
	VEHICLE_SEED,
	VEHICLE_SEED_WITHDRAW,
	VEHICLE_SEED_DEPOSIT,
	VEHICLE_MATERIAL,
	VEHICLE_MATERIAL_WITHDRAW,
	VEHICLE_MATERIAL_DEPOSIT,
	VEHICLE_COMPONENT,
	VEHICLE_COMPONENT_WITHDRAW,
	VEHICLE_COMPONENT_DEPOSIT,
	VEHICLE_MARIJUANA,
	VEHICLE_MARIJUANA_WITHDRAW,
	VEHICLE_MARIJUANA_DEPOSIT,
	DIALOG_NONRPNAME,
	//CONTAINER
	DIALOG_CONTAINER,
	//bb
	DIALOG_BOOMBOX,
	DIALOG_BOOMBOX1,
	//dealership
	DIALOG_FIND_DEALER,
	DIALOG_BUYDEALERCARS_CONFIRM_M,
	DIALOG_BUYJOBCARSVEHICLE,
	DIALOG_ACLAIM,
	DIALOG_BUYDEALERCARS_CONFIRM,
	DIALOG_BUYTRUCKVEHICLE,
	DIALOG_BUYMOTORCYCLEVEHICLE,
	DIALOG_BUYUCARSVEHICLE,
	DIALOG_BUYCARSVEHICLE,
	DIALOG_DEALER_MANAGE,
	DIALOG_DEALER_VAULT,
	DIALOG_DEALER_WITHDRAW,
	DIALOG_PRISONMENU,
	DIALOG_DEALER_DEPOSIT,
	DIALOG_DEALER_NAME,
	DIALOG_DEALER_RESTOCK,
	DIALOG_TAKEFOOD,
	DIALOG_TDC,
	DIALOG_TDC_PLACE,
	//PEDAGANG
	PEDAGANG_MENU,
	PDG_KENTANG,
	PDG_MINERAL,
	PDG_SNACK,
	PDG_CHICKEN,
	PDG_COCACOLA,
	PDG_JERUK,
	PDG_BURGER,
	PDG_PIZZA,
	PDG_AYAM_FILET,
	//
	PDG_KENTANG1,
	PDG_MINERAL1,
	PDG_SNACK1,
	PDG_CHICKEN1,
	PDG_COCACOLA1,
	PDG_JERUK1,
	PDG_BURGER1,
	PDG_PIZZA1,
	PDG_AYAM_FILET1,
	//---[ DIALOG OWN FARM ]---
	FARM_STORAGE,
	FARM_INFO,
	FARM_POTATO,
	FARM_WHEAT,
	FARM_ORANGE,
	FARM_MONEY,
	FARM_DEPOSITPOTATO,
	FARM_WITHDRAWPOTATO,
	FARM_DEPOSITWHEAT,
	FARM_WITHDRAWWHEAT,
	FARM_DEPOSITORANGE,
	FARM_WITHDRAWORANGE,
	FARM_DEPOSITMONEY,
	FARM_WITHDRAWMONEY,

	DIALOG_BENSIN,
	DIALOG_ISIBENSIN,
}

//-----[ Download System ]-----
new download[MAX_PLAYERS];

//-----[ Count System ]-----
new Count = -1;
new countTimer;
new showCD[MAX_PLAYERS];
new CountText[5][5] =
{
	"~r~1",
	"~g~2",
	"~y~3",
	"~g~4",
	"~b~5"
};

//-----[ Rob System ]-----
new robmoney;

//-----[ Server Uptime ]-----
new up_days,
	up_hours,
	up_minutes,
	up_seconds,
	WorldTime = 10,
	WorldWeather = 24;

//idskin
new SpawnMale = mS_INVALID_LISTID,
	SpawnFemale = mS_INVALID_LISTID,
	MaleSkins = mS_INVALID_LISTID,
	FemaleSkins = mS_INVALID_LISTID,
	VIPMaleSkins = mS_INVALID_LISTID,
	VIPFemaleSkins = mS_INVALID_LISTID,
	SAPDMale = mS_INVALID_LISTID,
	SAPDFemale = mS_INVALID_LISTID,
	SAPDWar = mS_INVALID_LISTID,
	SAGSMale = mS_INVALID_LISTID,
	SAGSFemale = mS_INVALID_LISTID,
	SAMDMale = mS_INVALID_LISTID,
	SAMDFemale = mS_INVALID_LISTID,
	SANEWMale = mS_INVALID_LISTID,
	SANEWFemale = mS_INVALID_LISTID,
	toyslist = mS_INVALID_LISTID,
	viptoyslist = mS_INVALID_LISTID,
	vtoylist = mS_INVALID_LISTID,
	PDGSkinMale = mS_INVALID_LISTID,
	PDGSkinFemale = mS_INVALID_LISTID,
	TransFender = mS_INVALID_LISTID,
	Waa = mS_INVALID_LISTID,
	LoCo = mS_INVALID_LISTID;

//AFK SYSTEM Aufa
new afk_check[MAX_PLAYERS];
new afk_tick[MAX_PLAYERS];
new afk_time[MAX_PLAYERS];
//-----[ Faction Vehicle ]-----	
#define VEHICLE_RESPAWN 7200

new SAPDVehicles[75],
	SAGSVehicles[30],
	SAMDVehicles[30],
	SANAVehicles[30];

IsSAPDCar(carid)
{
	for(new v = 0; v < sizeof(SAPDVehicles); v++)
	{
	    if(carid == SAPDVehicles[v]) return 1;
	}
	return 0;
}

IsGovCar(carid)
{
	for(new v = 0; v < sizeof(SAGSVehicles); v++)
	{
	    if(carid == SAGSVehicles[v]) return 1;
	}
	return 0;
}

IsSAMDCar(carid)
{
	for(new v = 0; v < sizeof(SAMDVehicles); v++)
	{
	    if(carid == SAMDVehicles[v]) return 1;
	}
	return 0;
}

IsSANACar(carid)
{
	for(new v = 0; v < sizeof(SANAVehicles); v++)
	{
	    if(carid == SANAVehicles[v]) return 1;
	}
	return 0;
}

//-----[ Showroom Checkpoint ]-----	
new ShowRoomCP,
	ShowRoomCPRent;
new Kompensasi;
new spterminal;
new DutyTimer;
new MalingKendaraan;

//-----[ Button ]-----	
new SAGSLobbyBtn[8],
	SAGSLobbyDoor[4],
	SAMCLobbyBtn[6],
	SAMCLobbyDoor[3];

//-----[ MySQL Connect ]-----	
new MySQL: g_SQL;

new TogOOC = 1;

new bool:DialogHauling[7];
new bool:DialogSaya[MAX_PLAYERS][7];
new TrailerContainer[MAX_VEHICLES];

//NAMASERVERGERAK
#define MAX_ANIM_DATA 100
#define MAX_ANIM_STRING 512
#define function%0(%1)  	forward %0(%1); public %0(%1)

//new PlayerText:NamaServer[MAX_PLAYERS][1];
//new ServerName[MAX_PLAYERS];

enum E_ANIM_DATA
{
	data_string[MAX_ANIM_STRING],
	data_frame,
	data_chars,
	data_color[4],
	data_color_1[15],
	data_color_2[15]
}
new AnimData[MAX_ANIM_DATA][E_ANIM_DATA];

static FindFreeAnimDataID()
{
	for (new i = 0; i < MAX_ANIM_DATA; i++) {
		if (strlen(AnimData[i][data_string]) <= 0) {
			return i;
		}
	}
	return -1;
}

stock CreateTextdrawAnimation(playerid, PlayerText:textdraw, frame, color[], string[])
{
	new id = FindFreeAnimDataID();
	if (id == -1) return 1;

	for (new i = 0; i < strlen(string); i++) {
		if (string[i] == ' ') {
			string[i] = '_';
		}
	}

	AnimData[id][data_chars] = 0;
	AnimData[id][data_frame] = frame;
	format (AnimData[id][data_string], MAX_ANIM_STRING, "%s", string);
	format (AnimData[id][data_color], 4, "%s", color);
	format (AnimData[id][data_color_1], 15, "%s~h~~h~~h~", color);
	format (AnimData[id][data_color_2], 15, "%s~h~~h~", color);
	PlayerTextDrawSetString(playerid, textdraw, "");

	SetTimerEx("UpdateTextdrawAnimation", frame, false, "iii", playerid, _:textdraw, id);
	return 1;
}

function UpdateTextdrawAnimation(playerid, PlayerText:textdraw, id)
{
	new tmp[MAX_ANIM_STRING];
	new len = strlen(AnimData[id][data_string]);
	new idx = AnimData[id][data_chars]++;

	if (AnimData[id][data_string][idx] == '~') {
		AnimData[id][data_chars] += 3;
		idx += 3;
	}

	strmid(tmp, AnimData[id][data_string], 0, idx);

	if (idx < len) {
		if (idx > 2 && (tmp[idx - 2] != '~' && tmp[idx - 1] != '~' && tmp[idx] != '~') ) {
			strins(tmp, AnimData[id][data_color_2], idx - 2);
			strins(tmp, AnimData[id][data_color_1], idx + strlen(AnimData[id][data_color_2]) - 1);
		}

		SetTimerEx("UpdateTextdrawAnimation", AnimData[id][data_frame], false, "iii", playerid, _:textdraw, id);
	} else {
		format (AnimData[id][data_string], MAX_ANIM_STRING, "");
		CallRemoteFunction("OnTextdrawAnimationFinish", "ii", playerid, _:textdraw);
	}

	strins(tmp, AnimData[id][data_color], 0);
	PlayerTextDrawSetString(playerid, textdraw, tmp);
	return 1;
}

/*function TDWEBACCOUNT(playerid)
{
	PlayerTextDrawHide(playerid, NamaServer[playerid][0]);
	PlayerTextDrawShow(playerid, NamaServer[playerid][0]);
	CreateTextdrawAnimation(playerid, NamaServer[playerid][0], 150, "", "Executive RolePlay");
	ServerName[playerid] = 0;
	return 1;
}

function TDNAMASERVER(playerid)
{
	PlayerTextDrawHide(playerid, NamaServer[playerid][0]);
	PlayerTextDrawShow(playerid, NamaServer[playerid][0]);
	CreateTextdrawAnimation(playerid, NamaServer[playerid][0], 150, "", "Executive RolePlay");
	ServerName[playerid] = 1;
	return 1;
}*/

/*function OnTextdrawAnimationFinish(playerid, PlayerText:textdraw)
{
	if(ServerName[playerid] == 0)
	{
		SetTimerEx("TDNAMASERVER", 15000, false, "i", playerid);
	}
	if(ServerName[playerid] == 1)
	{
		SetTimerEx("TDWEBACCOUNT", 15000, false, "i", playerid);
	}
	return 1;
}*/

/*stock CreateTextDrawNamaServer(playerid)
{
	NamaServer[playerid][0] = CreatePlayerTextDraw(playerid, 320.000000, 14.000000, "Executive RolePlay");
	PlayerTextDrawFont(playerid, NamaServer[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, NamaServer[playerid][0], 0.300000, 1.500000);
	PlayerTextDrawTextSize(playerid, NamaServer[playerid][0], 400.000000, 500.000000);
	PlayerTextDrawSetOutline(playerid, NamaServer[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, NamaServer[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, NamaServer[playerid][0], 2);
	PlayerTextDrawColor(playerid, NamaServer[playerid][0], 1173618687);
	PlayerTextDrawBackgroundColor(playerid, NamaServer[playerid][0], 690563583);
	PlayerTextDrawBoxColor(playerid, NamaServer[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, NamaServer[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, NamaServer[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, NamaServer[playerid][0], 0);
	PlayerTextDrawShow(playerid, NamaServer[playerid][0]);
	CreateTextdrawAnimation(playerid, NamaServer[playerid][0], 150, "", "Executive RolePlay");
	ServerName[playerid] = 1;
}*/

//-----[ Player Data ]-----	
enum E_PLAYERS
{
	pID,
	pUCP[22],
	pExtraChar,
	pChar,
	pName[MAX_PLAYER_NAME],
	pAdminname[MAX_PLAYER_NAME],
	bool:pAhide,
	pIP[16],
	pTrackDealer,
	pVerifyCode,
	pPassword[65],
	pSalt[17],
	pEmail[40],
	pBotol,
	pAdmin,
	pHelper,
	pClikmap,
	pLevel,
	pLevelUp,
	pVip,
	pVipTime,
	pGold,
	pSteak,
	pRegDate[50],
	pLastLogin[50],
	UangGudang,
	pMoney,
	pRedMoney,
	Text3D:pMaskLabel,
	pBankMoney,
	pInputMoney,
	pInputFuel,
	pToggleBank,
	pBankRek,
	pPhone,
	pPhoneCredit,
	pContact,
	pPhoneBook,
	pSMS,
	pCall,
	pCallTime,
	pWT,
	pHours,
	pMinutes,
	pSeconds,
	pPaycheck,
	pSkin,
	pFacSkin,
	pJobSkin,
	pGender,
	pDelaypernikahan,
	pAge[50],
	pDutyJob,
	pGetPARKID,
	pInDoor,
	pInHouse,
	pInBiz,
	pInVending,
	pInFamily,
	Float: pPosX,
	Float: pPosY,
	Float: pPosZ,
	Float: pPosA,
	Float:pPos[4],
	pInt,
	pWorld,
	Float:pHealth,
    Float:pArmour,
    pVest,
	pHunger,
	pEnergy,
	pBladder,
	pBladderTime,
	pKencing,
	pKencingTime,
	pHungerTime,
	pEnergyTime,
	pSick,
	pSickTime,
	pHospital,
	Text3D:pBensinLabel,
	pHospitalTime,
	pInjured,
	Text3D: pInjuredLabel,
	pOnDuty,
	pOnDutyTime,
	pFaction,
	pFactionRank,
	pObatStress,
	pPerban,
	pFactionLead,
	pTazer,
	pBroadcast,
	pNewsGuest,
	pFamily,
	pFamilyRank,
	pJail,
	pJailTime,
	pArrest,
	pArrestTime,
	pWarn,
	pJob,
	pJob2,
	pJobTime,
	pExitJob,
	pMedicine,
	pMedkit,
	pMask,
	pHelmet,
	pCig,
	pMineral,
	pPizza,
	pBurger,
	pChiken,
	pCola,
	//makanan di market
	pSnack,
	pKebab,
	pCappucino,
	pRoti,
	pWallpaper,
	pStarling,
	pSprunk,
	pMilxMax,
	//-----------------
	pGas,
	pBandage,
	pGopay,
	pGPS,
	pGpsActive,
	pMaterial,
	pComponent,
	pFood,
	pSeed,
	//MANCING
	pPenyu,
	pMakarel,
	pNemo,
 	pBlueFish,
	//PETANI
	pPadi,
	pCabai,
	pJagung,
	pTebu,
	pPadiOlahan,
	pCabaiOlahan,
	pJagungOlahan,
	pTebuOlahan,
	pBeras,
	pSambal,
	pGula,
	pTepung,
	//
	pPotato,
	pWheat,
	pOrange,
	pPrice1,
	pPrice2,
	pPrice3,
	pPrice4,
	pMarijuana,
	pKanabis,
	pPlant,
	pPlantTime,
	pInSt,
	pFishTool,
	pInstallDweb,
	pMenuTypeStorage,
	pIns,
	pWorm,
	pFish,
	//bus
	Kontol,
	Memek,
	pInFish,
	pIDCard,
	pIDCardTime,
	pDriveLic,
	pDriveLicTime,
	pDriveLicApp,
	pBoatLic,
	pBoatLicTime,
	pWeaponLic,
	pWeaponLicTime,
	pBizLic,
	pBizLicTime,
	pBpjs,
	pBpjsTime,
	pFlyLic,
	pFlyLicTime,
	pGuns[13],
    pAmmo[13],
	pWeapon,
	//Not Save
	Cache:Cache_ID,
	bool: IsLoggedIn,
	LoginAttempts,
	LoginTimer,
	pSpawned,
	pSpawnList,
	pAdminDuty,
	pFreezeTimer,
	pFreeze,
	pMaskID,
	pMaskOn,
	pSPY,
	pTogPM,
	pTogLog,
	pTogAds,
	pTogWT,
	pBuluAyam,
	Text3D:pAdoTag,
	Text3D:pBTag,
	bool:pBActive,
	bool:pAdoActive,
	pFlare,
	bool:pFlareActive,
	sampahsaya,
	//=======[ PEMERAS SUSU ]======
	pSusu,
	bool:pJobmilkduty,
	pMilkJob,
	bool:pLoading,
	pSusuOlahan,
	//========[ Duty Job ]========
	bool:DutyPenambang,
	bool:DutyMinyak,
	bool:DutyPemotong,
	bool:DutyPenebang,
	//=============================
	pPeluru[2],
	pDe,
	pKatana,
	pMolotov,
	p9mm,
	pSg,
	pSpas,
	pMp5,
	pM4,
	pClip,
	//================
	pTrackCar,
	pBuyPvModel,
	pTrackHouse,
	pTrackBisnis,
	pTrackVending,
	pFacInvite,
	pFacOffer,
	pFamInvite,
	pFamOffer,
	pFindEms,
	pCuffed,
	toySelected,
	bool:PurchasedToy,
	pEditingItem,
	pProductModify,
	pEditingVendingItem,
	pVendingProductModify,
	pCurrSeconds,
	pCurrMinutes,
	pCurrHours,
	pSpec,
	playerSpectated,
	pFriskOffer,
	pDragged,
	pDraggedBy,
	pDragTimer,
	pHBEMode,
	pHelmetOn,
	pReportTime,
	pAskTime,
	//Player Progress Bar
	PlayerBar:spfuelbar,
	PlayerBar:spdamagebar,
	PlayerBar:sphungrybar,
	PlayerBar:spenergybar,
	PlayerBar:activitybar,
	pPart,
	pPartStatus,
	pProducting,
	pProductingStatus,
	pPemotong,
	pPemotongStatus,
	pCooking,
	pCookingStatus,
	pArmsDealer,
	pArmsDealerStatus,
	// Roleplay Booster
 	pBooster,
 	pBoostTime,
	pMechanic,
	pMechanicStatus,
	pActivity,
	pActivityStatus,
	pActivityTime,
	pCs,
	//Penambang
	pTimeTambang1,
	pTimeTambang2,
	pTimeTambang3,
	pTimeTambang4,
	pTimeTambang5,
	pTimeTambang6,
	//Jobs
	pSideJob,
	pSideJobTime,
	pBustime,
	pBusRute,
	pBusTime,
	bool:pBuswaiting,
	bool:TempatHealing,
	pSparepartTime,
	pGetJob,
	pGetJob2,
	pMechDuty,
	pAmbilCar,
	pKendaraanKerja,
	pMechVeh,
	pKendaraanFraksi,
	pMechColor1,
	pMechColor2,
	EditingTrash,
	EditingGarkot,
	//ATM
	EditingATMID,
	//lumber job
	pKamera,
	EditingTreeID,
	CuttingTreeID,
	bool:CarryingLumber,
	//Storage
	ST_MENU,
	ST_MONEY,
	ST_WITHDRAWMONEY,
	ST_DEPOSITMONEY,
	ST_COMPONENT,
	ST_COMPONENT2,
	ST_MATERIAL,
	ST_MATERIAL2,
	//Container
	pSedangContainer,
	//ROB
	pLockPick,
	BankDelay,
	pRobStatus,
	RobbankTime,
	RobatmTime,
	RobbizTime,
	//Vending
	EditingVending,
	//production
	CarryProduct,
	//part job
	CarryPart,
	//trucker
	pMission,
	pHauling,
	pVendingRestock,
	bool: CarryingBox,
	//kejar
	pCheckpointTarget,
	//Farmer
	pHarvest,
	pHarvestID,
	pOffer,
	//Bank
	pTransfer,
	pTransferRek,
	pTransferName[128],
	//Gas Station
	pFill,
	bool:pFillCp,
	pFillStatus,
	pFillTime,
	pFillPrice,
	pFillVeh,
	pFillCapOpen,
	bool:pGrabFuel,
	Float:pCapX,
	Float:pCapY,
	Float:pCapZ,
	//boombox
	pBoombox,
	//Gate
	gEditID,
	gEdit,
	// WBR
	pHead,
 	pPerut,
 	pLHand,
 	pRHand,
 	pLFoot,
 	pRFoot,
 	// Inspect Offer
 	pInsOffer,
 	// Obat System
 	pObat,
 	// Suspect
 	pSuspectTimer,
 	pSuspect,
 	// Phone On Off
 	pPhoneStatus,
 	// Kurir
 	pKurirEnd,
 	// Shareloc Offer
 	pLocOffer,
 	// Register tinggi dan berat badan
 	pTinggi[50],
 	pBerat[50],
 	//download app handphone
 	pInstallTweet,
 	pInstallGojek,
 	pInstallMap,
 	pInstallBank,
 	// Twitter
 	pTwitter,
	pTwitterStatus, 
	pTwittername[MAX_PLAYER_NAME],
	pTwitterPostCooldown,
	pTwitterNameCooldown,
 	pRegTwitter,
 	// Kuota
 	pKuota,
 	// DUTY SYSTEM
 	pDutyHour,
 	//pemotong ayam
	timerambilayamhidup,
    timerpotongayam,
    timerpackagingayam,
    timerjualayam,
    AmbilAyam,
    DutyAmbilAyam,
    AyamHidup,
	AyamPotong,
	AyamFillet,
	bool:sedangambilayam,
    sedangpotongayam,
    sedangfilletayam,
    sedangjualayam,
 	// CHECKPOINT
 	pCP,
 	// ROBBERY
 	pRobTime,
 	pRobOffer,
 	pRobLeader,
 	pRobMember,
 	pMemberRob,
 	pKargo,
	pTrailer,
	// Smuggler
	bool:pTakePacket,
	pTrackPacket,
	// Garkot
	pPark,
	pLoc,
	//robbank
	pPanelHacking,
	pBomb,
	// WS
	pMenuType,
	pInWs,
	pTransferWS,
	//PENJAHIT
	pKain,
	pWool,
	pPakaian,
	//tukang kayu
	pKayu,
	pPapan,
	//Anticheat
	pACWarns,
	pACTime,
	pRadioVoice,
	pTombolVoice,
	pTombolVoiceRadio,
	pTombolVoiceAdmin,
	pCallStage,
	pCallLine,
	pCalling,
	pJetpack,
	pArmorTime,
	pLastUpdate,
	//Checkpoint
	pCheckPoint,
	pBus,
	//SpeedCam
	pSpeedTime,
	//Starterpack
	pStarterpack,
	//inventkry
	PilihSpawn,
	pProgress,
	Float:pWeight,
	pilihbensin,
	WaktuWarung,
	pMasukinNama,
	pilihkarakter,
	pSelectItem,
	pTarget,
	pGiveAmount,
	//Anim
	pLoopAnim,
	//Rob Car
	pLastChop,
	pLastChopTime,
	pIsStealing,
	//Sparepart
	pSparepart,
	//
	pUangKorup,
	//Senter
	pFlashlight,
	pUsedFlashlight,
	//Moderator
	pServerModerator,
	pEventModerator,
	pFactionModerator,
	pFamilyModerator,
	//
	pPaintball,
	pPaintball2,
	//
	pDelayIklan,
	pTukar,
	//PENAMBANG
	pBatu,
	pBatuCucian,
	pBorax,
	pKecubung,
	pPaketborax,
	pPaketkecubung,
	pTujuan[100],
	pOngkos[50],
	pEmas,
	pBesi,
	pAluminium,
	//PENAMBANGMINYAK
	pMinyak,
	pEssence,
	//Pedagang
	pdgMenuType,
	pInPdg,
	//-----[ FARM PRIVATE]
	pFarm,
	pFarmRank,
	pFarmInvite,
	pFarmOffer,
	//GPS TAG HAN
	pWaypoint,
	pLocation[32],
	Float:pWaypointPos[3],
	PlayerText:pTextdraws[83],
	//SEATBLET
	pSeatbelt,
	// Vehicle Toys
	EditStatus,
	VehicleID,
	pInDealer,
	BlacklistBill
};
new pData[MAX_PLAYERS][E_PLAYERS];
new g_MysqlRaceCheck[MAX_PLAYERS];
#define PlayerData pData
#define PlayerInfo PlayerData

//-----[ Smuggler ]-----	

new Text3D:packetLabel,
	packetObj,
	Float:paX, 
	Float:paY, 
	Float:paZ;

//-----[ Forklifter Object ]-----	
new 
	VehicleObject[MAX_VEHICLES] = {-1, ...};

//-----[ Lumber Object Vehicle ]-----	
#define MAX_BOX 50
#define BOX_LIFETIME 100
#define BOX_LIMIT 5

enum    E_BOX
{
	boxDroppedBy[MAX_PLAYER_NAME],
	boxSeconds,
	boxObjID,
	boxTimer,
	boxType,
	Text3D: boxLabel
}
new BoxData[MAX_BOX][E_BOX],
	Iterator:Boxs<MAX_BOX>;

new
	BoxStorage[MAX_VEHICLES][BOX_LIMIT];

//-----[ Trucker ]-----	
new VehProduct[MAX_VEHICLES];
new VehGasOil[MAX_VEHICLES];
new VehParts[MAX_VEHICLES];


//-----[ Type Checkpoint ]-----	
enum
{
	CHECKPOINT_NONE = 0,
	CHECKPOINT_DRIVELIC,
	CHECKPOINT_MISC,
	CHECKPOINT_BUS
}

//-----[ Storage Limit ]-----	
enum
{
	LIMIT_SNACK,
	LIMIT_SPRUNK,
	LIMIT_MEDICINE,
	LIMIT_MEDKIT,
 	LIMIT_BANDAGE,
 	LIMIT_SEED,
	LIMIT_MATERIAL,
	LIMIT_COMPONENT,
	LIMIT_MARIJUANA
};

//-----[ eSelection Define ]-----	
#define 	SPAWN_SKIN_MALE 		1
#define 	SPAWN_SKIN_FEMALE 		2
#define 	SHOP_SKIN_MALE 			3
#define 	SHOP_SKIN_FEMALE 		4
#define 	VIP_SKIN_MALE 			5
#define 	VIP_SKIN_FEMALE 		6
#define 	SAPD_SKIN_MALE 			7
#define 	SAPD_SKIN_FEMALE 		8
#define 	SAPD_SKIN_WAR 			9
#define 	SAGS_SKIN_MALE 			10
#define 	SAGS_SKIN_FEMALE 		11
#define 	SAMD_SKIN_MALE 			12
#define 	SAMD_SKIN_FEMALE 		13
#define 	SANA_SKIN_MALE 			14
#define 	SANA_SKIN_FEMALE 		15
#define 	TOYS_MODEL 				16
#define 	VIPTOYS_MODEL 			17
#define 	PDG_SKIN_MALE 			18
#define 	PDG_SKIN_FEMALE 		19
#define 	vtoyslist 		20




//-----[ Modular ]-----	
main() 
{
	SetTimer("onlineTimer", 1000, true);
	SetTimer("TDUpdates", 8000, true);
}
new bool:Warung;
new bool:Nikahan;
#include <textdraw-streamer>
//========= DATA =====================
#include "DATA\COLOR.pwn"
#include "DATA\SERVER.pwn"
#include "DATA\LOADINGPROG.pwn"
#include "NOTIFIKASISYSTEM\INFONOTIF.pwn"
#include "NOTIFIKASISYSTEM\NOTIFIKASI.pwn"
#include "NOTIFIKASISYSTEM\SHOWITEMBOX.pwn"
#include "DATA\AUFAINV.pwn"
#include "DATA\UCP.pwn"
#include "DATA\TEXTDRAW.pwn"
#include "DATA\ANIMS.pwn"
#include "DATA\RENTAL.pwn"
#include "DATA\KANABIS.pwn"
#include "DATA\PRIVATE_VEHICLE.pwn"
#include "DYNAMIC\HOUSE.pwn"
#include "DYNAMIC\BISNIS.pwn"
#include "DYNAMIC\GARKOT.pwn"
#include "DYNAMIC\DOOR.pwn"
#include "DYNAMIC\GAS_STATION.pwn"
#include "DYNAMIC\LOCKER.pwn"
#include "DYNAMIC\DEALERSHIP.pwn"
#include "DYNAMIC\GATE.pwn"
#include "DYNAMIC\WORKSHOP.pwn"
#include "DYNAMIC\SPEEDCAM.pwn"
#include "DYNAMIC\ACTOR.pwn"
#include "DYNAMIC\TRASH.pwn"
#include "DYNAMIC\ROBWARUNG.pwn"
#include "DATA\VSTORAGE.pwn"
#include "DATA\REPORT.pwn"
#include "DATA\ASK.pwn"
#include "DATA\WEAPON_ATTH.pwn"
#include "DATA\TOYS.pwn"
#include "DATA\HELMET.pwn"
#include "DATA\BILLS.pwn"
#include "DATA\FAMILY.pwn"
#include "DATA\AUCTION.pwn"
#include "DATA\NATIVE.pwn"
#include "DATA\VOUCHER.pwn"
#include "DATA\SALARY.pwn"
#include "DATA\ATM.pwn"
#include "DATA\ARMS_DEALER.pwn"
#include "DATA\INGAMEMAP.pwn"
#include "DATA\ROB.pwn"
#include "DATA\ROBBANK.pwn"
#include "DATA\MDC.pwn"
#include "DATA\TEXTCLICK.pwn"
#include "DATA\PRIVATE_FARM.pwn"
#include "DATA\ROBBERY.pwn"
#include "DATA\DMV.pwn"
#include "DATA\ANTICHEAT.pwn"
#include "DATA\VENDING.pwn"
#include "DATA\CONTACT.pwn"
#include "DATA\TOLL.pwn"
#include "DATA\MOD.pwn"
#include "DATA\LADANG.pwn"
#include "DATA\SIREN.pwn"
#include "DATA\STORAGE.pwn"
#include "DATA\GUDANG_PEDAGANG.pwn"
#include "DATA\MODIF.pwn"
//======[ PEKERJAAN KOTA NOPIXEL ]==========
#include "JOB\TUKANGAYAM.pwn"
#include "JOB\PENAMBANGMINYAK.pwn"
#include "JOB\KARGO.pwn"
#include "JOB\PENAMBANG.pwn"
#include "JOB\PEMERAHSUSU.pwn"
#include "JOB\SMUGGLER.pwn"
#include "JOB\TRUCKER.pwn"
#include "JOB\MANCING.pwn"
#include "JOB\PENJAHIT.pwn"
#include "JOB\BUS.pwn"
#include "JOB\PETANI.pwn"
#include "JOB\PEMBURU.pwn"
#include "JOB\TUKANGKAYU.pwn"
// MODSHOP
#include "DATA\VTOYS.pwn"
#include "DATA\MODSHOP.pwn"
#include "MODSHOP\ANAXY.pwn"

#include "CMD\FACTION.pwn"
#include "CMD\PLAYER.pwn"
#include "CMD\ADMIN.pwn"


#include "DATA\SAPD_TASER.pwn"
#include "DATA\SAPD_SPIKE.pwn"

#include "DATA\DIALOG.pwn"
#include "DATA\MAPPING.pwn"

#include "CMD\ALIAS\ALIAS_PRIVATE_VEHICLE.pwn"
#include "CMD\ALIAS\ALIAS_PLAYER.pwn"
#include "CMD\ALIAS\ALIAS_BISNIS.pwn"
#include "CMD\ALIAS\ALIAS_ADMIN.pwn"
#include "CMD\ALIAS\ALIAS_HOUSE.pwn"

#include "DATA\EVENT.pwn"

#include "DATA\FUNCTION.pwn"

#include "DATA\TASK.pwn"

#include "CMD\DISCORD.pwn"

//aufa scrip
#include "AUFASCRIP\LOGIN.pwn"

native SendClientCheck(playerid, type, arg, offset, size);

//-----[ Discord Status ]-----	
/*forward BotStatus();
public BotStatus()
{
    new h = 0, m = 0, secs = 0, statuz[256];
	h = floatround(upt / 3600);
	m = floatround((upt / 60) - (h * 60));
	secs = floatround(upt - ((h * 3600) + (m * 60)));
	upt++;
	//format(statuz,sizeof(statuz),"! [nama ucp]");
	format(statuz,sizeof(statuz),"%d/%d Warga | %02dj %02dm %02ds Uptime | Executive Roleplay", pemainic, GetMaxPlayers(), h, m, secs);
	DCC_SetBotActivity(statuz);
}*/

forward splits(const strsrc[], strdest[][], delimiter);
public splits(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
		if(strsrc[i]==delimiter || i==strlen(strsrc)){
			len = strmid(strdest[aNum], strsrc, li, i, 128);
			strdest[aNum][len] = 0;
			li = i+1;
			aNum++;
		}
		i++;
	}
	return 1;
}

stock FIXES_valstr(dest[], value, bool:pack = false)
{
    // format can't handle cellmin properly
    static const cellmin_value[] = !"-2147483648";

    if (value == cellmin)
        pack && strpack(dest, cellmin_value, 12) || strunpack(dest, cellmin_value, 12);
    else
        format(dest, 12, "%d", value) && pack && strpack(dest, dest, 12);
}

stock number_format(number)
{
	new i, string[15];
	FIXES_valstr(string, number);
	if(strfind(string, "-") != -1) i = strlen(string) - 4;
	else i = strlen(string) - 3;
	while (i >= 1)
 	{
		if(strfind(string, "-") != -1) strins(string, ",", i + 1);
		else strins(string, ",", i);
		i -= 3;
	}
	return string;
}

public DCC_OnMessageCreate(DCC_Message:message)
{
	new realMsg[100];
    DCC_GetMessageContent(message, realMsg, 100);
    new bool:IsBot;
    new DCC_Channel:g_Discord_Chat;
    g_Discord_Chat = DCC_FindChannelById("981567510006624266");
    new DCC_Channel:channel;
 	DCC_GetMessageChannel(message, channel);
    new DCC_User:author;
	DCC_GetMessageAuthor(message, author);
    DCC_IsUserBot(author, IsBot);
    if(channel == g_Discord_Chat && !IsBot) //!IsBot will block BOT's message in game
    {
        new user_name[32 + 1], str[152];
       	DCC_GetUserName(author, user_name, 32);
        format(str,sizeof(str), "{8a6cd1}[DISCORD] {aa1bb5}%s: {ffffff}%s", user_name, realMsg);
        SendClientMessageToAll(-1, str);
    }

    return 1;
}

stock GetCS(playerid)
{
 	new astring[48];
 	if(pData[playerid][pCs] == 0)format(astring, sizeof(astring), ""RED_E"None");
	else if(pData[playerid][pCs] == 1)format(astring, sizeof(astring), ""LG_E"Approved");
	return astring;
}

function WaktuKeluar(playerid)
{
 	if(IsValidDynamic3DTextLabel(TagKeluar[playerid]))
  		DestroyDynamic3DTextLabel(TagKeluar[playerid]);
}

function RobWarung(playerid)
{
	new value = 500 + random(500), str[500];
	for(new i = 0; i < MAX_ROBBERY; i++)
	{
  		if(IsPlayerInRangeOfPoint(playerid, 2.3, RobberyData[i][robberyX], RobberyData[i][robberyY], RobberyData[i][robberyZ]))
		{
			GivePlayerMoneyEx(playerid, value);
			format(str,sizeof(str),"Anda mendapatkan uang ~g~%s", FormatMoney(value));
			SuccesMsg(playerid, str);
			new duet[500];
			format(duet, sizeof(duet), "Received_%sx", FormatMoney(value));
			ShowItemBox(playerid, "Uang", duet, 1212, 2);
		 	ApplyActorAnimation(RobberyData[i][robberyID], "ped", "cower",4.0,0,0,0,1,0);
		 	DeletePVar(playerid, "RobArea");
		 	PlayerPlaySound(playerid, 3401, RobberyData[i][robberyX], RobberyData[i][robberyY], RobberyData[i][robberyZ]);
		 	if(IsValidDynamic3DTextLabel(RobberyData[i][robberyText]))
		  	DestroyDynamic3DTextLabel(RobberyData[i][robberyText]);
		}
	}
}
function SambutanHilang(playerid)
{
	PlayerTextDrawHide(playerid, SambutanTD[playerid][0]);
	PlayerTextDrawHide(playerid, SambutanTD[playerid][1]);
}
function SambutanMuncul(playerid)
{
    PlayerTextDrawShow(playerid, SambutanTD[playerid][0]);
    new AtmInfo[560];
   	format(AtmInfo,1000,"%s", GetName(playerid));
	PlayerTextDrawSetString(playerid, SambutanTD[playerid][1], AtmInfo);
    PlayerTextDrawShow(playerid, SambutanTD[playerid][1]);
}
function SimpanHp(playerid)
{
    	for(new i = 0; i < 21; i++)
		{
			TextDrawHideForPlayer(playerid, PhoneTD[i]);
		}
		for(new i = 0; i < 13; i++)
		{
			TextDrawHideForPlayer(playerid, APKNAME[i]);
		}
		for(new u = 0; u < 13; u++)
	    {
			PlayerTextDrawHide(playerid, APKLOGO[playerid][u]);
     	}
        TextDrawHideForPlayer(playerid, GPS);
	    TextDrawHideForPlayer(playerid, KONTAK);
		TextDrawHideForPlayer(playerid, AIRDROP);
		TextDrawHideForPlayer(playerid, GOJEK);
		TextDrawHideForPlayer(playerid, MBANKING);
		TextDrawHideForPlayer(playerid, TWITTER);
		TextDrawHideForPlayer(playerid, DARKWEB);
		TextDrawHideForPlayer(playerid, PLAYSTORE);
		TextDrawHideForPlayer(playerid, WHATSAPP);
		TextDrawHideForPlayer(playerid, CALL);
		TextDrawHideForPlayer(playerid, MUSIC);
		TextDrawHideForPlayer(playerid, SETTINGS);
		TextDrawHideForPlayer(playerid, KAMERA);
		TextDrawHideForPlayer(playerid, TUTUPHP);
		TextDrawHideForPlayer(playerid, TANGGAL);
		TextDrawHideForPlayer(playerid, FINGERPRINT);
		TextDrawHideForPlayer(playerid, JAMTD);
		for(new u = 0; u < 3; u++)
        {
			PlayerTextDrawHide(playerid, KONTAKAPP[playerid][u]);
	    }
	    for(new i = 0; i < 21; i++)
		{
			TextDrawHideForPlayer(playerid, PhoneTD[i]);
		}
	    PlayerTextDrawHide(playerid, KONTAKBARU[playerid]);
	    PlayerTextDrawHide(playerid, DAFTARKONTAK[playerid]);
	    for(new u = 0; u < 11; u++)
        {
			PlayerTextDrawHide(playerid, MBANKINGAPP[playerid][u]);
	    }
		PlayerTextDrawHide(playerid, TRANSFER[playerid]);
		PlayerTextDrawHide(playerid, NoRekening[playerid]);
		PlayerTextDrawHide(playerid, BNama[playerid]);
		PlayerTextDrawHide(playerid, BSaldo[playerid]);
		for(new u = 0; u < 12; u++)
        {
			PlayerTextDrawHide(playerid, MUSICAPP[playerid][u]);
	    }
		PlayerTextDrawHide(playerid, EARPHONE[playerid]);
		PlayerTextDrawHide(playerid, BOOMBOX[playerid]);
		for(new u = 0; u < 17; u++)
        {
			PlayerTextDrawHide(playerid, GOJEKAPP[playerid][u]);
	    }
		PlayerTextDrawHide(playerid, GPAY[playerid]);
		PlayerTextDrawHide(playerid, GSALDO[playerid]);
		PlayerTextDrawHide(playerid, GTOPUP[playerid]);
		PlayerTextDrawHide(playerid, GRIDE[playerid]);
		PlayerTextDrawHide(playerid, GSEND[playerid]);
		PlayerTextDrawHide(playerid, GCAR[playerid]);
		PlayerTextDrawHide(playerid, GFOOD[playerid]);
		for(new u = 0; u < 31; u++)
        {
			PlayerTextDrawHide(playerid, PLAYSTOREAPP[playerid][u]);
	    }
		PlayerTextDrawHide(playerid, TWELCOME[playerid]);
		PlayerTextDrawHide(playerid, TLOGIN[playerid]);
		PlayerTextDrawHide(playerid, TLOGOUT[playerid]);
		PlayerTextDrawHide(playerid, TWEET[playerid]);
		PlayerTextDrawHide(playerid, TDAFTAR[playerid]);
		for(new u = 0; u < 4; u++)
        {
			PlayerTextDrawHide(playerid, TWEETAPP[playerid][u]);
	    }
		CancelSelectTextDraw(playerid);
}
public OnGameModeInit()
{
    SetGameModeText("Projek Kota Fiksi");

	JamFivEm = 7;

	SetTimer("TambahDetikFivEM", 4000, true);
	CreateTextDraw();
	
    gstream = SvCreateGStream(0xC2A2DAFF, "DEWA");

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    warnings{i} = 0;
	}
	SetTimer("YANGTIM", 10000, true);
	////////////////////////////////
	//mysql_log(ALL);
	SetTimer("BackupDB", 60000, true);
	new MySQLOpt: option_id = mysql_init_options();

    DCC_FindChannelById("973240252162506822"); //
    g_Discord_Serverstatus = DCC_FindChannelById("101010");

    //g_Discord_CHENH4X = DCC_FindChannelById("992113672942002187");
    
	mysql_set_option(option_id, AUTO_RECONNECT, true);

	g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE, option_id);
	if (g_SQL == MYSQL_INVALID_HANDLE || mysql_errno(g_SQL) != 0)
	{
		print("MySQL connection failed. Server is shutting down.");
		SendRconCommand("exit");
		return 1;
	}
	print("MySQL connection is successful.");

	mysql_tquery(g_SQL, "SELECT * FROM `server`", "LoadServer");
	mysql_tquery(g_SQL, "SELECT * FROM `doors`", "LoadDoors");
	mysql_tquery(g_SQL, "SELECT * FROM `familys`", "LoadFamilys");
	mysql_tquery(g_SQL, "SELECT * FROM `houses`", "LoadHouses");
	mysql_tquery(g_SQL, "SELECT * FROM `bisnis`", "LoadBisnis");
	mysql_tquery(g_SQL, "SELECT * FROM `lockers`", "LoadLockers");
	mysql_tquery(g_SQL, "SELECT * FROM `gstations`", "LoadGStations");
	mysql_tquery(g_SQL, "SELECT * FROM `atms`", "LoadATM");
	mysql_tquery(g_SQL, "SELECT * FROM `gates`", "LoadGates");
	mysql_tquery(g_SQL, "SELECT * FROM `vouchers`", "LoadVouchers");
	mysql_tquery(g_SQL, "SELECT * FROM `object`", "Object_Load", "");
    mysql_tquery(g_SQL, "SELECT * FROM `matext`", "Matext_Load", "");
	mysql_tquery(g_SQL, "SELECT * FROM `workshop`", "LoadWorkshop");
	mysql_tquery(g_SQL, "SELECT * FROM `dealership`", "LoadDealership");
	mysql_tquery(g_SQL, "SELECT * FROM `parks`", "LoadGarkot");
	mysql_tquery(g_SQL, "SELECT * FROM `trash`", "LoadTrash");
	mysql_tquery(g_SQL, "SELECT * FROM `speedcameras`", "LoadSpeedCam");
	mysql_tquery(g_SQL, "SELECT * FROM `actor`", "LoadActor");
	mysql_tquery(g_SQL, "SELECT * FROM `vending`", "LoadVending");
	mysql_tquery(g_SQL, "SELECT * FROM `pedagang`", "LoadPedagang");
	mysql_tquery(g_SQL, "SELECT * FROM `farm`", "LoadFarm");
	mysql_tquery(g_SQL, "SELECT * FROM `robbery`", "Loadrobbery");

	ShowNameTags(0);
	EnableTirePopping(0);
	CreateServerPoint();
	CreateArmsPoint();
	LoadTazerSAPD();
	CreateJoinSmugglerPoint();
	
	new garasi;
	garasi = CreateDynamicObject(1316, 1303.972045,-1338.869506,13.722788 -0.5, 0.0, 0.0, 0.0, 0, 0, -1, 50.00, 50.00);
	SetDynamicObjectMaterial(garasi, 0, 18646, "matcolours", "white", 0xFFCCCC00);
	garasi = CreateDynamicObject(1316, 1493.067138,-666.322204,94.769989 -0.5, 0.0, 0.0, 0.0, 0, 0, -1, 50.00, 50.00);
	SetDynamicObjectMaterial(garasi, 0, 18646, "matcolours", "white", 0xFFCCCC00);
	garasi = CreateDynamicObject(1316, 717.724060,-1418.360717,13.785820 -0.5, 0.0, 0.0, 0.0, 0, 0, -1, 50.00, 50.00);
	SetDynamicObjectMaterial(garasi, 0, 18646, "matcolours", "white", 0xFFCCCC00);
	
	//CreateDynamicPickup(19134, 23, 1164.004394,-1201.940551,19.837736, -1, -1, -1, 50);
	//CreateDynamic3DTextLabel("| Gudang Kota |\n| Gunakan "LG_E"ALT {FFFFFF}Untuk Akses Gudang |", COLOR_WHITE, 1164.004394,-1201.940551,19.837736, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

   	rusa = CreateObject(19315, -1911.798583,-2382.167480,30.197269,   0.00000, 0.00000, 0.00000);
	    	
	CreateCarStealingPoint();
	LoadMap();

	nopixel[0] = TextDrawCreate(284.000, -20.000, "NOPIXEL:NL");
	TextDrawTextSize(nopixel[0], 75.000, 90.000);
	TextDrawAlignment(nopixel[0], 1);
	TextDrawColor(nopixel[0], -1);
	TextDrawSetShadow(nopixel[0], 0);
	TextDrawSetOutline(nopixel[0], 0);
	TextDrawBackgroundColor(nopixel[0], 255);
	TextDrawFont(nopixel[0], 4);
	TextDrawSetProportional(nopixel[0], 1);
	
	for (new i; i < sizeof(ColorList); i++) {
    format(color_string, sizeof(color_string), "%s{%06x}%03d %s", color_string, ColorList[i] >>> 8, i, ((i+1) % 16 == 0) ? ("\n") : (""));
    }

    for (new i; i < sizeof(FontNames); i++) {
        format(object_font, sizeof(object_font), "%s%s\n", object_font, FontNames[i]);
    }
	
	SpawnMale = LoadModelSelectionMenu("spawnmale.txt");
	SpawnFemale = LoadModelSelectionMenu("spawnfemale.txt");
	MaleSkins = LoadModelSelectionMenu("maleskin.txt");
	FemaleSkins = LoadModelSelectionMenu("femaleskin.txt");
	VIPMaleSkins = LoadModelSelectionMenu("maleskin.txt");
	VIPFemaleSkins = LoadModelSelectionMenu("femaleskin.txt");
	SAPDMale = LoadModelSelectionMenu("sapdmale.txt");
	SAPDFemale = LoadModelSelectionMenu("sapdfemale.txt");
	SAPDWar = LoadModelSelectionMenu("sapdwar.txt");
	SAGSMale = LoadModelSelectionMenu("sagsmale.txt");
	SAGSFemale = LoadModelSelectionMenu("sagsfemale.txt");
	SAMDMale = LoadModelSelectionMenu("samdmale.txt");
	SAMDFemale = LoadModelSelectionMenu("samdfemale.txt");
	SANEWMale = LoadModelSelectionMenu("sanewmale.txt");
	SANEWFemale = LoadModelSelectionMenu("sanewfemale.txt");
	toyslist = LoadModelSelectionMenu("toys.txt");
	viptoyslist = LoadModelSelectionMenu("viptoys.txt");
	vtoylist = LoadModelSelectionMenu("vtoylist.txt");
	PDGSkinMale = LoadModelSelectionMenu("pmale.txt");
	PDGSkinFemale = LoadModelSelectionMenu("pfemale.txt");
	TransFender = LoadModelSelectionMenu("transfender.txt");
	Waa = LoadModelSelectionMenu("waa.txt");
	LoCo = LoadModelSelectionMenu("loco.txt");
	
	ResetCarStealing();
	LoadModsPoint();
	
	Healing = CreateDynamicSphere(119.636665,-1773.970703,8.591071, 30.0, 0, 0);
	JualIkan = CreateDynamicSphere(2798.4680,-1578.8145,10.9858, 2.0, 0, 0);
	JualNambang = CreateDynamicSphere(2798.1953,-1571.1901,11.0391, 2.0, 0, 0);
	JualPetani = CreateDynamicSphere(2799.2314,-1556.5638,11.0114, 2.0, 0, 0);
	JualKayu = CreateDynamicSphere(2799.0505,-1544.9191,11.0521, 2.0, 0, 0);

	new gm[32];
	format(gm, sizeof(gm), "%s", TEXT_GAMEMODE);
	SetGameModeText(gm);
	format(gm, sizeof(gm), "weburl %s", TEXT_WEBURL);
	SendRconCommand(gm);
	format(gm, sizeof(gm), "language %s", TEXT_LANGUAGE);
	SendRconCommand(gm);
	//SendRconCommand("hostname Xero Gaming Roleplay");
	SendRconCommand("mapname Executive");
	ManualVehicleEngineAndLights();
	EnableStuntBonusForAll(0);
	AllowInteriorWeapons(1);
	DisableInteriorEnterExits();
	LimitPlayerMarkerRadius(1.0);
	SetNameTagDrawDistance(1.0);
	//DisableNameTagLOS();
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	SetWorldTime(WorldTime);
	SetWeather(WorldWeather);
	BlockGarages(.text="NO ENTER");
	//Audio_SetPack("default_pack");	
	CreateDynamicObject(800, 1754.928588,-187.140090,80.490097, 0.000000, 0.000000, 133.731521, -1, -1, -1, 300.00, 300.00);//Kanabis
	CreateDynamicObject(800, 1754.928588,-187.140090,80.490097, 0.000000, 0.000000, 137.313674, -1, -1, -1, 300.00, 300.00);//Kanabis
	CreateDynamicMapIcon(2817.4790,-1577.3334,10.9289, 52, 0, -1, -1, -1, 700.0, -1);//Executive market
	CreateDynamicMapIcon(1316.866088,-872.307128,39.626033, 10, 0, -1, -1, -1, 700.0, -1);//pedagang
	CreateDynamicMapIcon(1335.1455,-1369.5229,13.7228, 30, 0, -1, -1, -1, 700.0, -1);//polisi
	//------[ PENJAHIT ]-----------
	new str[1500];
	format(str, sizeof(str), "Tekan ALT {ffffff}Untuk Potong Ayam");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, -2075.82, -2440.67, 30.6839, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	format(str, sizeof(str), "Tekan ALT {ffffff}Untuk Potong Ayam");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, -2074.63, -2439.26, 30.6739, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	format(str, sizeof(str), "Tekan ALT {ffffff}Untuk Potong Ayam");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, -2076.86, -2441.9, 30.6839, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 

	format(str, sizeof(str), "Tekan ALT {ffffff}Untuk Packing Ayam");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, -2058.77, -2437.32, 30.6939, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 

	format(str, sizeof(str), "Tekan ALT {ffffff}Untuk Packing Ayam");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, -2060.71, -2439.79, 30.6939, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 

	format(str, sizeof(str), "Ketik /masukkandangayam {ffffff}Untuk Masuk kandang ayam");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, -1435.59, -1463.27, 101.711, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 

	format(str, sizeof(str), "Ketik /keluarkandangayam {ffffff}Untuk keluar kandang ayam\n/mulaitangkapayam untuk mulai tangkap ayam\n/stoptangkapayam untuk stop tangkap ayam");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, -1433.84, -1461.69, 101.711, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 

    CreateDynamicPickup(1275, 23, 1302.190673,-1876.173828,13.763982, -1, -1, -1, 50);
    format(str, sizeof(str), "Tekan "LG_E"ALT {ffffff}Untuk Membuat Pakaian");

	CreateDynamic3DTextLabel(str, COLOR_WHITE, 2313.817382,-2075.185546,17.644004, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
    format(str, sizeof(str), "Tekan "LG_E"ALT {ffffff}Untuk Menjual Pakaian");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, 1276.9907,-1424.0293,13.7541, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	format(str, sizeof(str), "Tekan "LG_E"ALT {ffffff}Untuk Mengambil Wool");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, 1925.521972,170.046707,37.281250, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	format(str, sizeof(str), "Tekan "LG_E"ALT {ffffff}Untuk Akses Locker");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, 2318.562744,-2070.840576,17.644752, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	format(str, sizeof(str), "Tekan "LG_E"ALT {ffffff}Untuk Membuat Kain");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, 2319.573730,-2080.727783,17.692657, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
    format(str, sizeof(str), "Tekan "LG_E"ALT {ffffff}Untuk Membuat Kain");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, 2321.482421,-2082.888671,17.652400, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	format(str, sizeof(str), "Tekan "LG_E"ALT {ffffff}Untuk Membuat Kain");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, 2317.667236,-2082.262939,17.694538, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	format(str, sizeof(str), "Tekan "LG_E"ALT {ffffff}Untuk Membuat Kain");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, 2319.653320,-2084.508544,17.652679, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

    format(str, sizeof(str), "Tekan "LG_E"ALT {ffffff}Untuk Membuat new rek");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, 1448.5902,-1134.6410,23.9580, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	format(str, sizeof(str), "Tekan "LG_E"ALT {ffffff}Untuk Mengakses bank");
	CreateDynamic3DTextLabel(str, COLOR_WHITE, 1456.1683,-1128.3212,23.9580, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	//-----[ Toll System ]-----	
	for(new i;i < sizeof(BarrierInfo);i ++)
	{
		new
		Float:X = BarrierInfo[i][brPos_X],
		Float:Y = BarrierInfo[i][brPos_Y];

		ShiftCords(0, X, Y, BarrierInfo[i][brPos_A]+90.0, 3.5);
		CreateDynamicObject(966,BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z],0.00000000,0.00000000,BarrierInfo[i][brPos_A]);
		if(!BarrierInfo[i][brOpen])
		{
			gBarrier[i] = CreateDynamicObject(968,BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.8,0.00000000,90.00000000,BarrierInfo[i][brPos_A]+180);
			MoveObject(gBarrier[i],BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.7,BARRIER_SPEED,0.0,0.0,BarrierInfo[i][brPos_A]+180);
			MoveObject(gBarrier[i],BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.75,BARRIER_SPEED,0.0,90.0,BarrierInfo[i][brPos_A]+180);
		}
		else gBarrier[i] = CreateDynamicObject(968,BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.8,0.00000000,20.00000000,BarrierInfo[i][brPos_A]+180);
	}
	new strings[500];
	CreateDynamicPickup(1239, 23, 1444.531616,-23.858947,-55.601955, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Kantor Pemerintah]\n{FFFFFF}/buatktp - untuk mendapatkan ktp\n/sellhouse - untuk menjual rumah anda\n/sellbusiness - untuk menjual bisnis anda");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1444.531616,-23.858947,-55.601955, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); //

	CreateDynamicPickup(1239, 23, 801.12, -613.77, 16.33, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Sparepart]\n{FFFFFF}/sellpart\n");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 801.12, -613.77, 16.33, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Veh insurance
	
	CreateDynamicPickup(1239, 23, 1294.1837, -1267.9083, 20.6199, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Sparepart Shop]\n{FFFFFF}/buysparepart\n");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 1294.1837, -1267.9083, 20.6199, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Veh insurance

	CreateDynamicPickup(1239, 23, 1330.39, 1566.83, 3010.90, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[BPJS]\n{FFFFFF}/newbpjs\n");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 1330.39, 1566.83, 3010.90, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Veh insurance

	CreateDynamicPickup(1239, 23, 1381.769653,1532.049682,1510.901123, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[License]\n{FFFFFF}/newdrivelic - membeli lisensi kendaraan");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 1381.769653,1532.049682,1510.901123, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Driving Lic
	
	format(strings, sizeof(strings), "{7fffd4}[Rumah Sakit Executive]\n{BABABA}Tekan "LG_E" ALT {BABABA}untuk membeli perban");
	CreateDynamic3DTextLabel(strings, COLOR_PINK2, 739.011047,-1431.948242,13.825812, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	format(strings, sizeof(strings), "[Rumah Sakit Executive]\n{BABABA}Tekan "LG_E" ALT {BABABA}untuk membeli obat stress");
	CreateDynamic3DTextLabel(strings, COLOR_PINK2, 737.314941,-1431.849365,13.825812, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	
	CreateDynamicPickup(1239, 23, 1295.64, -1367.56, 15.47, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Kepolisian Executive]\n{BABABA}/buyplate - membuat plate kendaraan\n/newdrivelic - membuat surat izin mengemudi\n/payticket untuk membayar biaya pelangaran");
	CreateDynamic3DTextLabel(strings, COLOR_ARWIN, 1295.64, -1367.56, 15.47, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Plate Kota LS
	
	CreateDynamicPickup(1239, 23, 85.0160, 1070.5106, -48.9141, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Ticket]\n{FFFFFF}/payticket - untuk membayar denda");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 85.0160, 1070.5106, -48.9141, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Ticket Kota Dilimore

	CreateDynamicPickup(1239, 23, 1331.1376,-1352.8523,13.7228, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Arrest Point]\n{FFFFFF}/arrest - untuk mengirimkan pelaku ke penjara");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 1331.1376,-1352.8523,13.7228, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // arrest

	CreateDynamicPickup(1239, 23, 1326.1808,-1354.0112,13.7228, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[release Area]\n{FFFFFF}/release - Untuk mengeluarkan pelaku dari penjara");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 1326.1808,-1354.0112,13.7228, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // arrest
	
	CreateDynamicPickup(1239, 23, 708.316162,-1427.967773,13.592469, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Hospital]\n{FFFFFF}/dropinjured");
	CreateDynamic3DTextLabel(strings, COLOR_PINK, 708.316162,-1427.967773,13.592469, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // hospital
	
	CreateDynamicPickup(1239, 23, 1672.12, -1347.85, 18.21, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[BANK]\n{FFFFFF}/bank - access rekening\n/newrek - new rekening");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 1672.12, -1347.85, 18.21, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // bank
	
	CreateDynamicPickup(1239, 23, 792.0918,-1315.1270,710.3754, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[IKLAN]\n{FFFFFF}/ads - public ads");
	CreateDynamic3DTextLabel(strings, COLOR_ORANGE2, 792.0918,-1315.1270,710.3754, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // iklan

	CreateDynamicPickup(1241, 23, 1341.95, 1575.97, 3010.90, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[MYRICOUS PRODUCTION]\n{FFFFFF}/mix");
	CreateDynamic3DTextLabel(strings, COLOR_ORANGE2, 1341.95, 1575.97, 3010.90, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // racik obat

	CreateDynamicPickup(1239, 23, -427.3773, -392.3799, 16.5802, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Exchange Money]\n{FFFFFF}/washmoney");
	CreateDynamic3DTextLabel(strings, COLOR_ORANGE2, -427.3773, -392.3799, 16.5802, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // pencucian uang haram
	
	//-----[ Dynamic Checkpoint ]-----	
	ShowRoomCP = CreateDynamicCP(1080.413208,-1666.189453,13.611383, 1.0, -1, -1, -1, 5.0);
	Disnaker = CreateDynamicCP(1447.612548,-24.116228,-55.601955, 1.0, -1, -1, -1, 20.0);
	Kompensasi = CreateDynamicCP(1738.4631,-2524.5730,13.5969, 1.0, -1, -1, -1, 20.0);
	spterminal = CreateDynamicCP(-607.7561,-488.6573,25.6234, 1.0, -1, -1, -1, 20.0);
	Creategunn = CreateDynamicCP(-1066.2753,-2322.0605,55.8431, 1.0, -1, -1, -1, 20.0);
	//pernikahan
	pernikahan = CreateDynamicCP(830.3033,-2066.9246,13.2240, 1.0, -1, -1, -1, 20.0);
	//--------[ ATM CP ]--------------
	atm1 = CreateDynamicCP(1920.387207,-1786.922729,13.546875, 1.0, -1, -1, -1, 5.0);
	atm4 = CreateDynamicCP(1291.651489,-1874.457031,13.783984, 1.0, -1, -1, -1, 5.0);
	atm2 = CreateDynamicCP(1550.266601,-2176.392578,13.546875, 1.0, -1, -1, -1, 5.0);
	atm3 = CreateDynamicCP(1545.033935,-2177.635498,13.582808, 1.0, -1, -1, -1, 5.0);
	atm5 = CreateDynamicCP(1374.6693,-1887.5564,13.5901, 1.0, -1, -1, -1, 5.0);
	atm6 = CreateDynamicCP(1275.9919,-1558.3986,13.5869, 1.0, -1, -1, -1, 5.0);
	atm7 = CreateDynamicCP(1977.7656,-2058.9355,13.5938, 1.0, -1, -1, -1, 5.0);
	asuransi = CreateDynamicCP(1510.5328,-2178.1340,13.6257, 1.0, -1, -1, -1, 5.0);//aufa
	sellpv = CreateDynamicCP(1516.3483,-2177.7971,13.6174, 1.0, -1, -1, -1, 5.0);//aufa
	rentalbike = CreateDynamicCP(1687.043090,-2265.090087,13.481613, 1.0, -1, -1, -1, 5.0);
	rentalterminal = CreateDynamicCP(-613.6473,-488.6987,25.6234, 1.0, -1, -1, -1, 5.0);
	menumasak = CreateDynamicCP(1318.067016,-861.774475,39.726036, 1.0, -1, -1, -1, 5.0);
	menuminum = CreateDynamicCP(1311.526611,-865.060852,39.726036, 1.0, -1, -1, -1, 5.0);
	menupedagang = CreateDynamicCP(1316.866088,-872.307128,39.626033, 1.0, -1, -1, -1, 5.0);
	rentalpelabuhan = CreateDynamicCP(2766.651367,-2395.744384,13.632812, 1.0, -1, -1, -1, 5.0);
	sppelabuhan = CreateDynamicCP(2772.931640,-2429.260742,13.637291, 1.0, -1, -1, -1, 5.0);
	createlockpick = CreateDynamicCP(-1069.9493,-2322.5383,55.7935, 1.0, -1, -1, -1, 5.0);//aufa

	//kendaraan fraksi dan gudang
	kendaraansapd = CreateDynamicCP(865.371276,-1753.296508,13.686874, 2.0, -1, -1, -1, 5.0);
	garasisags = CreateDynamicCP(1239.4237,-2054.5679,59.9075, 2.0, -1, -1, -1, 5.0);
	garasisamd = CreateDynamicCP(717.724060,-1418.360717,13.785820, 2.0, -1, -1, -1, 5.0);
	garasigojek = CreateDynamicCP(1375.9167,-1767.8365,13.5781, 2.0, -1, -1, -1, 5.0);
	garasipedagang = CreateDynamicCP(1493.067138,-666.322204,94.769989, 2.0, -1, -1, -1, 5.0);
	gudangkota = CreateDynamicCP(1164.004394,-1201.940551,19.837736, 2.0, -1, -1, -1, 5.0);

	kanabis1 = CreateDynamicCP(874.795104,-13.976298,63.195312, 2.0, -1, -1, -1, 5.0);
	kanabis2 = CreateDynamicCP(1775.1582,-167.0989,77.5520, 2.0, -1, -1, -1, 5.0);
	kanabis3 = CreateDynamicCP(1770.9899,-166.8354,78.0667, 2.0, -1, -1, -1, 5.0);
	kanabis4 = CreateDynamicCP(1767.3459,-170.8528,78.9311, 2.0, -1, -1, -1, 5.0);
	kanabis5 = CreateDynamicCP(1769.2379,-174.3668,79.8527, 2.0, -1, -1, -1, 5.0);
	kanabis6 = CreateDynamicCP(1765.0322,-175.5911,79.8391, 2.0, -1, -1, -1, 5.0);
	kanabis7 = CreateDynamicCP(1755.6796,-180.9095,79.8963, 2.0, -1, -1, -1, 5.0);
	//MANCINGCP
	mancing1 = CreateDynamicCP(202.3336,-1918.2603,1.2257, 1.0, -1, -1, -1, 5.0);
	mancing2 = CreateDynamicCP(197.5030,-1918.0684,1.2261, 1.0, -1, -1, -1, 5.0);
	mancing3 = CreateDynamicCP(194.7841,-1937.1458,1.2014, 1.0, -1, -1, -1, 5.0);
	mancing4 = CreateDynamicCP(175.2086,-1933.6747,1.2014, 1.0, -1, -1, -1, 5.0);
	mancing5 = CreateDynamicCP(204.8122,-1914.7838,1.1988, 1.0, -1, -1, -1, 5.0);
	mancing6 = CreateDynamicCP(227.4286,-1918.3226,1.2014, 1.0, -1, -1, -1, 5.0);
	mancing7 = CreateDynamicCP(223.3978,-1946.2858,1.1914, 1.0, -1, -1, -1, 5.0);
	mancing8 = CreateDynamicCP(239.2198,-1934.7523,1.1914, 1.0, -1, -1, -1, 5.0);
	//mancing9 = CreateDynamicCP(361.865936,-2088.551513,7.835937, 1.0, -1, -1, -1, 5.0);
	//mancing10 = CreateDynamicCP(354.502258,-2088.541748,7.835937, 1.0, -1, -1, -1, 5.0);
	

	//chLogsRobbank = DCC_FindChannelById("955040124348010536");

	new DCC_Channel:hidupp, DCC_Embed:logss;
	new yy, m, d, timestamp[200];
	getdate(yy, m , d);
	hidupp = DCC_FindChannelById("1102276177491664907");

	format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d);
	logss = DCC_CreateEmbed("Executive Roleplay");
	DCC_SetEmbedTitle(logss, "Executive Roleplay | HappyBarengExecutive");
	DCC_SetEmbedTimestamp(logss, timestamp);
	DCC_SetEmbedColor(logss, 0x00ff00);
	DCC_SetEmbedUrl(logss, "https://media.discordapp.net/attachments/1101454563908800553/1113354457460256778/Tak_berjudul21_20230513005034.png");
	DCC_SetEmbedThumbnail(logss, "https://media.discordapp.net/attachments/1101454563908800553/1113354457460256778/Tak_berjudul21_20230513005034.png");
	DCC_SetEmbedFooter(logss, "Executive Roleplay | HappyBarengExecutive", "");
	new stroi[5000];
	format(stroi, sizeof(stroi), "> Pintu Executive #1 telah dibuka, para penonton yang telah memiliki karcis dipersilakan memasuki ruangan Executive\n> Server update <#1096287335672446997>\n\n> IP server <#1095732521267896472>\nDihimbau semua warga untuk membaca:\n<#1095732507749666848>\n\n> Punya saran & kritik? <#1100318896717824020>\n> Mengalami kesulitan? <#1095732667481325599>\n> Mendapatkan bug? <#1099311571341168640>");
	DCC_AddEmbedField(logss, "Pintu Executive #1 Terbuka", stroi, true);
	DCC_SendChannelEmbedMessage(hidupp, logss);

	printf("[Objects]: %d Loaded.", CountDynamicObjects());
	

	return 1;
}
public OnGameModeExit()
{
   	print("-------------- [ Auto Gmx ] --------------");
	new count = 0, user = 0;
	foreach(new gsid : GStation)
	{
		if(Iter_Contains(GStation, gsid))
		{
			count++;
			GStation_Save(gsid);
		}
	}
	printf("[Gas Station]: %d Saved.", count);
	
	for (new i = 0, j = GetPlayerPoolSize(); i <= j; i++) 
	{
		if (IsPlayerConnected(i))
		{
			OnPlayerDisconnect(i, 1);
		}
	}
	printf("[Database] User Saved: %d", user);
	print("-------------- [ Auto Gmx ] --------------");
	SendClientMessageToAll(COLOR_RED, "[!]"YELLOW_E" Maaf server dalam pemeliharaan/Restart.{00FFFF} ~Executive BOTS");

	UnloadTazerSAPD();
	DestroyDynaimcRobBank();
	//Audio_DestroyTCPServer();
	mysql_close(g_SQL);
		new DCC_Channel:hidupp, DCC_Embed:logss;
	new yy, m, d, timestamp[200];
	getdate(yy, m , d);
	hidupp = DCC_FindChannelById("1102276177491664907");

	format(timestamp, sizeof(timestamp), "%02i%02i%02i", yy, m, d);
	logss = DCC_CreateEmbed("Executive Roleplay");
	DCC_SetEmbedTitle(logss, "Executive Roleplay | HappyBarengExecutive");
	DCC_SetEmbedTimestamp(logss, timestamp);
	DCC_SetEmbedColor(logss, 0x00ff00);
	DCC_SetEmbedUrl(logss, "https://media.discordapp.net/attachments/1101454563908800553/1113354457460256778/Tak_berjudul21_20230513005034.png");
	DCC_SetEmbedThumbnail(logss, "https://media.discordapp.net/attachments/1101454563908800553/1113354457460256778/Tak_berjudul21_20230513005034.png");
	DCC_SetEmbedFooter(logss, "Executive Roleplay | HappyBarengExecutive", "");
	new stroi[5000];
	format(stroi, sizeof(stroi), "> Pintu Theater #1 telah tertutup.");
	DCC_AddEmbedField(logss, "Pintu Executive #1 Tertutup", stroi, true);
	DCC_SendChannelEmbedMessage(hidupp, logss);

	return 1;
}

stock RefreshDGHbec(playerid)
{
	PlayerTextDrawSetPreviewModel(playerid, DGHBEC[playerid], GetVehicleModel(GetPlayerVehicleID(playerid)));
	PlayerTextDrawShow(playerid, DGHBEC[playerid]);
    return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if(vehicleid == Car_Job[playerid])
	{
        KillTimer(timer_Car[playerid]);
        Seconds_timer[playerid] = 0;
    }
    if(vehicleid == pData[playerid][pKendaraanKerja])
	{
        KillTimer(KeluarKerja[playerid]);
        TimerKeluar[playerid] = 0;
    }
	if(!ispassenger)
	{
		if(IsSAPDCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 1)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Anda bukan SAPD!");
			}
		}
		if(IsGovCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 2)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Anda bukan SAGS!");
			}
		}
		if(IsSAMDCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 3)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Anda bukan SAMD!");
			}
		}
		if(IsSANACar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 4)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Anda bukan SANEWS!");
			}
		}
	}
	return 1;
}

stock SGetName(playerid)
{
    new name[ 64 ];
    GetPlayerName(playerid, name, sizeof( name ));
    return name;
}

public OnPlayerText(playerid, text[])
{
	if(isnull(text)) return 0;
	new str[150];
	format(str,sizeof(str),"[CHAT] %s: %s", GetRPName(playerid), text);
	LogServer("Chat", str);
	printf(str);

	if(pData[playerid][pSpawned] == 0 && pData[playerid][IsLoggedIn] == false)
	{
	    Error(playerid, "You must be spawned or logged in to use chat.");
	    return 0;
	}
	//-----[ Auto RP ]-----	
	if(!strcmp(text, "rpgun", true) || !strcmp(text, "gunrp", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s lepaskan senjatanya dari sabuk dan siap untuk menembak kapan saja.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcrash", true) || !strcmp(text, "crashrp", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s kaget setelah kecelakaan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfish", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memancing dengan kedua tangannya.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfall", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s jatuh dan merasakan sakit.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpmad", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s merasa kesal dan ingin mengeluarkan amarah.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rprob", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s menggeledah sesuatu dan siap untuk merampok.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcj", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mencuri kendaraan seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpwar", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s berperang dengan sesorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpdie", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s pingsan dan tidak sadarkan diri.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfixmeka", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memperbaiki mesin kendaraan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcheckmeka", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memeriksa kondisi kendaraan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfight", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ribut dan memukul seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcry", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sedang bersedih dan menangis.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rprun", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s berlari dan kabur.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfear", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s merasa ketakutan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpdropgun", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s meletakkan senjata kebawah.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rptakegun", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mengamnbil senjata.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpgivegun", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memberikan kendaraan kepada seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpshy", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s merasa malu.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpnusuk", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s menusuk dan membunuh seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpharvest", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memanen tanaman.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rplockhouse", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sedang mengunci rumah.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rplockcar", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sedang mengunci kendaraan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpnodong", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memulai menodong seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpeat", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s makan makanan yang ia beli.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpdrink", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s meminum minuman yang ia beli.", ReturnName(playerid));
		return 0;
	}
	if(text[0] == '@')
	{
		if(pData[playerid][pSMS] != 0)
		{
			if(pData[playerid][pPhoneCredit] < 1)
			{
				Error(playerid, "Anda tidak memiliki Credit!");
				return 0;
			}
			if(pData[playerid][pInjured] != 0)
			{
				Error(playerid, "Tidak dapat melakukan saat ini.");
				return 0;
			}
			new tmp[512];
			foreach(new ii : Player)
			{
				if(text[1] == ' ')
				{
			 		format(tmp, sizeof(tmp), "%s", text[2]);
				}
				else
				{
				    format(tmp, sizeof(tmp), "%s", text[1]);
				}
				if(pData[ii][pPhone] == pData[playerid][pSMS])
				{
					if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii))
					{
						Error(playerid, "Nomor ini tidak aktif!");
						return 0;
					}
					SendClientMessageEx(playerid, COLOR_YELLOW, "[SMS to %d]"WHITE_E" %s", pData[playerid][pSMS], tmp);
					SendClientMessageEx(ii, COLOR_YELLOW, "[SMS from %d]"WHITE_E" %s", pData[playerid][pPhone], tmp);
					PlayerPlaySound(ii, 6003, 0,0,0);
					pData[ii][pSMS] = pData[playerid][pPhone];
					
					pData[playerid][pPhoneCredit] -= 1;
					return 0;
				}
			}
		}
	}
	if(pData[playerid][pCall] != INVALID_PLAYER_ID)
	{
		// Anti-Caps
		if(GetPVarType(playerid, "Caps"))
			UpperToLower(text);
		new lstr[1024];
		format(lstr, sizeof(lstr), "[CellPhone] %s says: %s", ReturnName(playerid), text);
		ProxDetector(10, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
		SetPlayerChatBubble(playerid, text, COLOR_WHITE, 10.0, 3000);
		SendClientMessageEx(pData[playerid][pCall], COLOR_YELLOW, "[CELLPHONE] "WHITE_E"%s.", text);
		return 0;
	}
	else
	{
		// Anti-Caps
		if(GetPVarType(playerid, "Caps"))
			UpperToLower(text);
		new lstr[1024];
		if(!IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		{
			if(pData[playerid][pAdminDuty] == 1)
			{
				if(strlen(text) > 64)
				{
					SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %.64s ..", ReturnName(playerid), text);
					SendNearbyMessage(playerid, 20.0, COLOR_WHITE, ".. %s ))", text[64]);
					return 0;
				}
				else
				{
					SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %s ))", ReturnName(playerid), text);
					return 0;
				}
			}
			new dc[128];
			format(dc, sizeof(dc),  "```\n[CHAT] %s: %s```", ReturnName(playerid), text);
			SendDiscordMessage(2, dc);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		{
			if(pData[playerid][pAdmin] < 1)
			{
				format(lstr, sizeof(lstr), "[OOC ZONE] %s: (( %s ))", ReturnName(playerid), text);
				ProxDetector(40, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
			}
			else if(pData[playerid][pAdmin] > 1 || pData[playerid][pHelper] > 1)
			{
				format(lstr, sizeof(lstr), "[OOC ZONE] %s: %s", pData[playerid][pAdminname], text);
				ProxDetector(40, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
			}
		}
		return 0;
	}
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    new str[1500];
    if (result == -1)
    {
	    format(str,sizeof(str),"Perintah ~y~/%s ~w~Tidak Ditemukan Gunakan ~y~/help", cmd);
		ErrorMsg(playerid, str);
        return 0;
    }
	
	format(str,sizeof(str),"[CMD] %s: [%s] [%s]", GetRPName(playerid), cmd, params);
	LogServer("Command", str);
	printf(str);
	new dc[128];
	format(dc, sizeof(dc),  "```\n[CMD] %s: [%s] [%s]", GetRPName(playerid), cmd);
	SendDiscordMessage(1, dc);
    return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	return 1;
}

//TD DEATH
stock ShowTdDeath(playerid)
{
	PlayerTextDrawShow(playerid, Text_Player[playerid][0]);
    PlayerTextDrawShow(playerid, Text_Player[playerid][1]);
    PlayerTextDrawShow(playerid, Text_Player[playerid][2]);
    PlayerTextDrawShow(playerid, Text_Player[playerid][3]);
	PlayerTextDrawShow(playerid, Text_Player[playerid][4]);
    PlayerTextDrawShow(playerid, Text_Player[playerid][5]);
    PlayerTextDrawShow(playerid, Text_Player[playerid][6]);
    PlayerTextDrawShow(playerid, Text_Player[playerid][7]);
    PlayerTextDrawShow(playerid, Text_Player[playerid][8]);
    return 1;
}
stock HideTdDeath(playerid)
{
	PlayerTextDrawHide(playerid, Text_Player[playerid][0]);
    PlayerTextDrawHide(playerid, Text_Player[playerid][1]);
    PlayerTextDrawHide(playerid, Text_Player[playerid][2]);
    PlayerTextDrawHide(playerid, Text_Player[playerid][3]);
	PlayerTextDrawHide(playerid, Text_Player[playerid][4]);
    PlayerTextDrawHide(playerid, Text_Player[playerid][5]);
    PlayerTextDrawHide(playerid, Text_Player[playerid][6]);
    PlayerTextDrawHide(playerid, Text_Player[playerid][7]);
    PlayerTextDrawHide(playerid, Text_Player[playerid][8]);
    return 1;
}

public OnPlayerConnect(playerid)
{
	//id atas pala
    new str[1000];
    format(str, sizeof(str), "ID:[%d]", playerid);
    playerID[playerid] = Create3DTextLabel(str, 0x1E90FFFF, 0, 0, 0, 10, 0);
    Attach3DTextLabelToPlayer(playerID[playerid], playerid, 0.0, 0.0, 0.1);

	for(new i; i < 5; i++)
	{
		TextDrawShowForPlayer(playerid, ExecutiveLogo[i]);
	}

 	if (SvGetVersion(playerid) == SV_NULL)
    {
		KickEx(playerid);
    }
	//PlayAudioStreamForPlayer(playerid, "http://k.top4top.io/m_2685nhtv30.mp3");
   // SendClientMessage(playerid, -1, "{56A4E4}[Server] -> {FFFFFF}Aufa Dev");
              
    if(IsValidDynamic3DTextLabel(TagKeluar[playerid]))
  		DestroyDynamic3DTextLabel(TagKeluar[playerid]);
  		
    PakaiSenjata[playerid] = 0;
    CreateProgress(playerid);
    CreatePlayerInv(playerid);
    PlayerInfo[playerid][pSelectItem] = 0;
    for (new i = 0; i != MAX_INVENTORY; i ++)
	{
	    InventoryData[playerid][i][invExists] = false;
	    InventoryData[playerid][i][invModel] = 0;
	}
	TextDrawShowForPlayer(playerid, nopixel[0]);
	PlayerTextDrawShow(playerid, TdNopix[playerid][0]);
	Player_EditVehicleObject[playerid] = -1;
    Player_EditVehicleObjectSlot[playerid] = -1;
    Player_EditingObject[playerid] = 0;

    JOB[playerid] = 0;
    inJOB[playerid] = 0;
	warnings{playerid} = 0;
	SendClientCheck(playerid, 0x48, 0, 0, 2);
	new PlayerIP[16], country[MAX_COUNTRY_LENGTH], city[MAX_CITY_LENGTH];
	g_MysqlRaceCheck[playerid]++;
	pemainic++;
	AntiBHOP[playerid] = 0;
	IsAtEvent[playerid] = 0;
	takingselfie[playerid] = 0;
	pData[playerid][pDriveLicApp] = 0;
	//AntiCheat
	pData[playerid][pJetpack] = 0;
	pData[playerid][pLastUpdate] = 0;
	pData[playerid][pArmorTime] = 0;
	pData[playerid][pACTime] = 0;
	pData[playerid][pToggleBank] = 0;
	//Anim
	pData[playerid][pLoopAnim] = 0;
	//Rob
	pData[playerid][pLastChop] = 0;
	//seatblet
	PlayerInfo[playerid][pSeatbelt] = 0;
	//Pengganti IsValidTimer
	pData[playerid][pProductingStatus] = 0;
	pData[playerid][pPartStatus] = 0;
	pData[playerid][pPemotongStatus] = 0;
	pData[playerid][pCookingStatus] = 0;
	pData[playerid][pMechanicStatus] = 0;
	pData[playerid][pActivityStatus] = 0;
	pData[playerid][pArmsDealerStatus] = 0;
	pData[playerid][pFillStatus] = 0;
	pData[playerid][pPemotongStatus] = 0;
	pData[playerid][pActivityTime] = 0;
	//

	ClearAnimations(playerid);

	ResetVariables(playerid);
	RemoveMappingGreenland(playerid);
	CreatePlayerTextDraws(playerid);

	GetPlayerName(playerid, pData[playerid][pUCP], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
	pData[playerid][pIP] = PlayerIP;
	pData[playerid][pID] = playerid;
	InterpolateCameraPos(playerid, 698.826049, -1404.027099, 16.206615, 2045.292480, -1425.237182, 128.337753, 60000);
	InterpolateCameraLookAt(playerid, 703.825317, -1404.041990, 500000681, 2050.291992, -1425.306762, 128.361190, 50000);

	GetPlayerCountry(playerid, country, MAX_COUNTRY_LENGTH);
	GetPlayerCity(playerid, city, MAX_CITY_LENGTH);
	
	SetTimerEx("SafeLogin", 1000, 0, "i", playerid);
	//Prose Load Data
	new query[103];
	mysql_format(g_SQL, query, sizeof query, "SELECT * FROM `playerucp` WHERE `ucp` = '%e' LIMIT 1", pData[playerid][pUCP]);
	mysql_pquery(g_SQL, query, "OnPlayerDataLoaded", "dd", playerid, g_MysqlRaceCheck[playerid]);
	SetPlayerColor(playerid, COLOR_WHITE);

	pData[playerid][activitybar] = CreatePlayerProgressBar(playerid, 273.500000, 157.333541, 88.000000, 8.000000, 5930683, 100, 0);
	
	//HBE textdraw Simple
	pData[playerid][pInjuredLabel] = CreateDynamic3DTextLabel("", COLOR_ORANGE, 0.0, 0.0, -0.3, 10, .attachedplayer = playerid, .testlos = 1);

    if(pData[playerid][pHead] < 0) return pData[playerid][pHead] = 20;

    if(pData[playerid][pPerut] < 0) return pData[playerid][pPerut] = 20;

    if(pData[playerid][pRFoot] < 0) return pData[playerid][pRFoot] = 20;

    if(pData[playerid][pLFoot] < 0) return pData[playerid][pLFoot] = 20;

    if(pData[playerid][pLHand] < 0) return pData[playerid][pLHand] = 20;
   
    if(pData[playerid][pRHand] < 0) return pData[playerid][pRHand] = 20;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	//id atas pala
	Delete3DTextLabel(playerID[playerid]);
    DelHunter(playerid);
	if (lstream[playerid])
    {
        SvDeleteStream(lstream[playerid]);
        lstream[playerid] = SV_NULL;
    }
    if(pData[playerid][pJob] == 1)
	{
	    DeleteBusCP(playerid);
	    Sopirbus--;
	}
	else if(pData[playerid][pJob] == 2)
	{
    	tukangayam--;
    	DeletePemotongCP(playerid);
	}
	else if(pData[playerid][pJob] == 3)
	{
    	tukangtebang--;
		DeletePenebangCP(playerid);
	}
	else if(pData[playerid][pJob] == 4)
	{
	    DeleteMinyakCP(playerid);
    	penambangminyak--;
	}
	else if(pData[playerid][pJob] == 5)
	{
	    DeleteJobPemerahMap(playerid);
    	pemerah--;
	}
	else if(pData[playerid][pJob] == 6)
	{
    	penambang--;
    	DeletePenambangCP(playerid);
	}
	else if(pData[playerid][pJob] == 7)
	{
	    DeletePetaniCP(playerid);
    	petani--;
	}
	else if(pData[playerid][pJob] == 8)
	{
    	Trucker--;
    	DeleteKargoCP(playerid);
	}
	else if(pData[playerid][pJob] == 10)
	{
    	penjahit--;
	}

	explosive{playerid} = false;
	//////////
	warnings{playerid} = 0;

	pemainic--;

	SetPlayerName(playerid, pData[playerid][pUCP]);
	//Pengganti IsValidTimer
	pData[playerid][pProductingStatus] = 0;
	pData[playerid][pPartStatus] = 0;
	pData[playerid][pCookingStatus] = 0;
	pData[playerid][pMechanicStatus] = 0;
	pData[playerid][pActivityStatus] = 0;
	pData[playerid][pArmsDealerStatus] = 0;
	pData[playerid][pFillStatus] = 0;
	pData[playerid][pPemotongStatus] = 0;
	pData[playerid][pActivityTime] = 0;

	DestroyDynamic3DTextLabel(pData[playerid][pInjuredLabel]);

	pData[playerid][pDriveLicApp] = 0;
	pData[playerid][pSpawnList] = 0;
	takingselfie[playerid] = 0;
	//KillTimer(Unload_Timer[playerid]);
	
	if(IsPlayerInAnyVehicle(playerid))
	{
        RemovePlayerFromVehicle(playerid);
    }
	if(IsValidVehicle(pData[playerid][pKendaraanFraksi]))
   		DestroyVehicle(pData[playerid][pKendaraanFraksi]);
   	
    if(IsValidVehicle(pData[playerid][pKendaraanKerja]))
   		DestroyVehicle(pData[playerid][pKendaraanKerja]);
   		
    if(IsValidVehicle(pData[playerid][pTrailer]))
   		DestroyVehicle(pData[playerid][pTrailer]);

	g_MysqlRaceCheck[playerid]++;
	
	if(pData[playerid][IsLoggedIn] == true)
	{

		UpdatePlayerData(playerid);
		RemovePlayerVehicle(playerid);
		Report_Clear(playerid);
		Ask_Clear(playerid);

		KillTazerTimer(playerid);
		if(IsValidVehicle(pData[playerid][pTrailer]))
			DestroyVehicle(pData[playerid][pTrailer]);

		pData[playerid][pTrailer] = INVALID_VEHICLE_ID;
		if(IsAtEvent[playerid] == 1)
		{
			if(GetPlayerTeam(playerid) == 1)
			{
				if(EventStarted == 1)
				{
					RedTeam -= 1;
					foreach(new ii : Player)
					{
						if(GetPlayerTeam(ii) == 2)
						{
							GivePlayerMoneyEx(ii, EventPrize);
							Servers(ii, "Selamat, Tim Anda berhasil memenangkan Event dan Mendapatkan Hadiah $%d per orang", EventPrize);
							SetPlayerPos(ii, pData[ii][pPosX], pData[ii][pPosY], pData[ii][pPosZ]);
							pData[playerid][pHospital] = 0;
							ClearAnimations(ii);
							BlueTeam = 0;
						}
						else if(GetPlayerTeam(ii) == 1)
						{
							Servers(ii, "Maaf, Tim anda sudah terkalahkan, Harap Coba Lagi lain waktu");
							SetPlayerPos(ii, pData[ii][pPosX], pData[ii][pPosY], pData[ii][pPosZ]);
							pData[playerid][pHospital] = 0;
							ClearAnimations(ii);
							RedTeam = 0;
						}
					}
				}
			}
			if(GetPlayerTeam(playerid) == 2)
			{
				if(EventStarted == 1)
				{
					BlueTeam -= 1;
					foreach(new ii : Player)
					{
						if(GetPlayerTeam(ii) == 1)
						{
							GivePlayerMoneyEx(ii, EventPrize);
							Servers(ii, "Selamat, Tim Anda berhasil memenangkan Event dan Mendapatkan Hadiah $%d per orang", EventPrize);
							SetPlayerPos(ii, pData[ii][pPosX], pData[ii][pPosY], pData[ii][pPosZ]);
							pData[playerid][pHospital] = 0;
							ClearAnimations(ii);
							BlueTeam = 0;
						}
						else if(GetPlayerTeam(ii) == 2)
						{
							Servers(ii, "Maaf, Tim anda sudah terkalahkan, Harap Coba Lagi lain waktu");
							SetPlayerPos(ii, pData[ii][pPosX], pData[ii][pPosY], pData[ii][pPosZ]);
							pData[playerid][pHospital] = 0;
							ClearAnimations(ii);
							BlueTeam = 0;
						}
					}
				}
			}
			SetPlayerTeam(playerid, 0);
			IsAtEvent[playerid] = 0;
			pData[playerid][pInjured] = 0;
			pData[playerid][pSpawned] = 1;
			UpdateDynamic3DTextLabelText(pData[playerid][pInjuredLabel], COLOR_ORANGE, "");
	    }
		if(pData[playerid][pRobLeader] == 1)
		{
			foreach(new ii : Player) 
			{
				if(pData[ii][pMemberRob] > 1)
				{
					Servers(ii, "* Pemimpin Perampokan anda telah keluar! [ MISI GAGAL ]");
					pData[ii][pMemberRob] = 0;
					RobMember = 0;
					pData[ii][pRobLeader] = 0;
					ServerMoney += robmoney;
				}
			}
		}
		if(pData[playerid][pMemberRob] == 1)
		{
			pData[playerid][pMemberRob] = 0;
			foreach(new ii : Player) 
			{
				if(pData[ii][pRobLeader] > 1)
				{
					Servers(ii, "* Member berkurang 1");
					pData[ii][pMemberRob] -= 1;
					RobMember -= 1;
				}
			}
		}
	}
	
	if(IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
            DestroyDynamic3DTextLabel(pData[playerid][pAdoTag]);

    if(IsValidDynamic3DTextLabel(pData[playerid][pBTag]))
            DestroyDynamic3DTextLabel(pData[playerid][pBTag]);
			
	if(IsValidDynamicObject(pData[playerid][pFlare]))
            DestroyDynamicObject(pData[playerid][pFlare]);
    

    pData[playerid][pAdoActive] = false;
	

	if (pData[playerid][LoginTimer])
	{
		KillTimer(pData[playerid][LoginTimer]);
		pData[playerid][LoginTimer] = 0;
	}

	pData[playerid][IsLoggedIn] = false;
	
	new Float:x, Float:y, Float:z, strings[500];
	GetPlayerPos(playerid, x, y, z);

	new reasontext[526];
	switch(reason)
	{
	    case 0: reasontext = "Timeout/ Crash";
	    case 1: reasontext = "Quit";
	    case 2: reasontext = "Kicked/ Banned";
	}
	format(strings, sizeof(strings), "[%s | %s (%d) Telah Keluar Dari Kota\nAlasan: [%s]", pData[playerid][pName], pData[playerid][pUCP], playerid, reasontext);
	TagKeluar[playerid] = CreateDynamic3DTextLabel(strings, 0xC6E2FFFF, x, y, z, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Text Jika Player Disconnect
 	SetTimerEx("WaktuKeluar", 10000, false, "d", playerid);
	new dc[100];
	format(dc, sizeof(dc),  "```\nNama: %s Telah keluar dari kota Executive\nUcp: %s\nReason: %s.```", pData[playerid][pName], pData[playerid][pUCP], reasontext);
	SendDiscordMessage(0, dc);
	return 1;
}
function Register(playerid)
{
    for(new i = 0; i < 32; i++)
	{
		PlayerTextDrawShow(playerid, BuatKarakter[playerid][i]);
	}
	for(new idx; idx < 35; idx++) PlayerTextDrawHide(playerid, RegisterTD[playerid][idx]);
	SelectTextDraw(playerid, COLOR_BLUE);
	return 1;
}
function pilihanspawn(playerid)
{
    for(new i = 0; i < 22; i++)
	{
		TextDrawShowForPlayer(playerid, SpawnTD[i]);
	}
	TextDrawHideForPlayer(playerid, SpawnTD[14]);
	TextDrawHideForPlayer(playerid, SpawnTD[5]);
	SelectTextDraw(playerid, COLOR_BLUE);
	return 1;
}
public OnPlayerSpawn(playerid)
{
    //CreateTextDrawNamaServer(playerid);
	StopAudioStreamForPlayer(playerid);
	SetPlayerInterior(playerid, pData[playerid][pInt]);
	SetPlayerVirtualWorld(playerid, pData[playerid][pWorld]);
	SetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
	SetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 0);
	SetPlayerSpawn(playerid);
	LoadAnims(playerid);
	ClearChat(playerid);
 	
	vpara[playerid]=0;
	
	SetPlayerSkillLevel(playerid, WEAPON_COLT45, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SILENCED, 1);
	SetPlayerSkillLevel(playerid, WEAPON_DEAGLE, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SHOTGUN, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SAWEDOFF, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SHOTGSPA, 1);
	SetPlayerSkillLevel(playerid, WEAPON_UZI, 1);
	SetPlayerSkillLevel(playerid, WEAPON_MP5, 1);
	SetPlayerSkillLevel(playerid, WEAPON_AK47, 1);
	SetPlayerSkillLevel(playerid, WEAPON_M4, 1);
	SetPlayerSkillLevel(playerid, WEAPON_TEC9, 1);
	SetPlayerSkillLevel(playerid, WEAPON_RIFLE, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SNIPER, 1);
 	new dc[100];
	format(dc, sizeof(dc),  "```\nNama: %s Telah memasuki kota Executive\nUcp: %s\nNegara: Indonesian.```", pData[playerid][pName], pData[playerid][pUCP]);
	SendDiscordMessage(0, dc);
	return 1;
}

SetPlayerSpawn(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(pData[playerid][pGender] == 0)
		{
			TogglePlayerControllable(playerid,0);
			SetPlayerHealth(playerid, 100.0);
			SetPlayerArmour(playerid, 0.0);
			SetPlayerPos(playerid, 2823.21,-2440.34,12.08);
			SetPlayerCameraPos(playerid,1058.544433, -1086.021362, 41);
			SetPlayerCameraLookAt(playerid,1055.534057, -1082.029296, 39.802570);
			SetPlayerVirtualWorld(playerid, 0);
		}
		else
		{
			SetPlayerColor(playerid, COLOR_WHITE);
			CheckPlayerSpawn3Titik(playerid);
			if(pData[playerid][pHBEMode] == 1) //simple
			{
				PlayerTextDrawHide(playerid, PlayerTD[playerid][8]);
				PlayerTextDrawSetString(playerid, PlayerTD[playerid][8], "Normal");
				PlayerTextDrawShow(playerid, PlayerTD[playerid][8]);
			}
			CheckPlayerSpawn3Titik(playerid);
			SetPlayerSkin(playerid, pData[playerid][pSkin]);
			if(pData[playerid][pOnDuty] >= 1)
			{
				SetPlayerSkin(playerid, pData[playerid][pFacSkin]);
				SetFactionColor(playerid);
			}
			if(pData[playerid][pAdminDuty] > 0)
			{
				SetPlayerColor(playerid, COLOR_RED);
			}
			SetTimerEx("SpawnTimer", 6000, false, "i", playerid);
		}
	}
}

function SpawnTimer(playerid)
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, pData[playerid][pMoney]);
	SetPlayerScore(playerid, pData[playerid][pLevel]);
	SetPlayerHealth(playerid, pData[playerid][pHealth]);
	SetPlayerArmour(playerid, pData[playerid][pArmour]);
	pData[playerid][pSpawned] = 1;
	TogglePlayerControllable(playerid, 1);
	SetCameraBehindPlayer(playerid);
	AttachPlayerToys(playerid);
	SetWeapons(playerid);
	if(pData[playerid][pJail] > 0)
	{
		JailPlayer(playerid); 
	}
	if(pData[playerid][pArrestTime] > 0)
	{
		SetPlayerArrest(playerid, pData[playerid][pArrest]);
	}
	return 1;
}
static const Float:cam_start_pos [4] [3] [6] =
{
	{
    	{2225.367919, -1341.228515, 26.527132, 1864.286499, -1511.908691, 160.707336},
    	{2220.424560, -1341.353149, 25.787668, 1860.622192, -1508.632812, 159.789916},
    	{2206.6897,-1344.4692,23.9844, 0.0, 0.0, 0.0}
	},
	{
    	{1705.268432, -576.238891, 39.012908, 1732.554321, -934.871826, 161.531326},
    	{1705.068969, -581.234924, 39.009002, 1729.563598, -938.804077, 160.761276},
    	{1673.0056,-712.7117,68.5703, 0.0, 0.0, 0.0}
	},
	{
    	{85.656761, -1339.051513, 89.242439, 24.335859, -1566.349487, 8.120280},
    	{87.708625, -1343.310302, 87.613655, 28.958576, -1564.447021, 8.224605},
    	{2.0860,-1355.8615,1.0736, 0.0, 0.0, 0.0}
	},
	{
    	{1705.268432, -576.238891, 39.012908, 1732.554321, -934.871826, 161.531326},
    	{1705.068969, -581.234924, 39.009002, 1729.563598, -938.804077, 160.761276},
    	{1673.0056,-712.7117,68.5703, 0.0, 0.0, 0.0}
	}
};
public OnPlayerRequestClass(playerid, classid)
{
    new rand = random(4);
	InterpolateCameraPos(playerid, cam_start_pos[rand][0][0], cam_start_pos[rand][0][1], cam_start_pos[rand][0][2], cam_start_pos[rand][0][3], cam_start_pos[rand][0][4], cam_start_pos[rand][0][5], 20000);
	InterpolateCameraLookAt(playerid, cam_start_pos[rand][1][0], cam_start_pos[rand][1][1], cam_start_pos[rand][1][2], cam_start_pos[rand][1][3], cam_start_pos[rand][1][4], cam_start_pos[rand][1][5], 20000);
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		Info(playerid, "{ff0000}Jangan di pencet spawn adik adik!!!");
		KickEx(playerid);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID)
	{
		new reasontext[526];
		switch(reason)
		{
	        case 0: reasontext = "Fist";
	        case 1: reasontext = "Brass Knuckles";
	        case 2: reasontext = "Golf Club";
	        case 3: reasontext = "Nite Stick";
	        case 4: reasontext = "Knife";
	        case 5: reasontext = "Basebal Bat";
	        case 6: reasontext = "Shovel";
	        case 7: reasontext = "Pool Cue";
	        case 8: reasontext = "Katana";
	        case 9: reasontext = "Chain Shaw";
	        case 14: reasontext = "Cane";
	        case 18: reasontext = "Molotov";
	        case 22..24: reasontext = "Pistol";
	        case 25..27: reasontext = "Shotgan";
	        case 28..34: reasontext = "Laras long";
		    case 49: reasontext = "Rammed by Car";
		    case 50: reasontext = "Helicopter blades";
		    case 51: reasontext = "Explosion";
		    case 53: reasontext = "Drowned";
		    case 54: reasontext = "Splat";
		    case 255: reasontext = "Suicide";
		}
		new h, m, s;
		new day, month, year;
	    gettime(h, m, s);
	    getdate(year,month,day);

        new dc[128];
        format(dc, sizeof dc, "```%02d.%02d.%d - %02d:%02d:%02d```\n```\n%s [ID: %d] killed %s [ID: %d] (%s)\n```",day, month, year, h, m, s, pData[killerid][pName], killerid, pData[playerid][pName], playerid, reasontext);
        SendDiscordMessage(9, dc);
	}
    else
	{
		new reasontext[526];
		switch(reason)
		{
	        case 0: reasontext = "Fist";
	        case 1: reasontext = "Brass Knuckles";
	        case 2: reasontext = "Golf Club";
	        case 3: reasontext = "Nite Stick";
	        case 4: reasontext = "Knife";
	        case 5: reasontext = "Basebal Bat";
	        case 6: reasontext = "Shovel";
	        case 7: reasontext = "Pool Cue";
	        case 8: reasontext = "Katana";
	        case 9: reasontext = "Chain Shaw";
	        case 14: reasontext = "Cane";
	        case 18: reasontext = "Molotov";
	        case 22..24: reasontext = "Pistol";
	        case 25..27: reasontext = "Shotgan";
	        case 28..34: reasontext = "Laras long";
		    case 49: reasontext = "Rammed by Car";
		    case 50: reasontext = "Helicopter blades";
		    case 51: reasontext = "Explosion";
		    case 53: reasontext = "Drowned";
		    case 54: reasontext = "Splat";
		    case 255: reasontext = "Suicide";
		}
	    new h, m, s;
	    new day, month, year;
	    gettime(h, m, s);
	    getdate(year,month,day);
	    new name[MAX_PLAYER_NAME + 1];
	    GetPlayerName(playerid, name, sizeof name);

	    new dc[128];
	    format(dc, sizeof dc, "```%02d.%02d.%d - %02d:%02d:%02d```\n```\n%s [ID: %d] death(%s)\n```",day, month, year, h, m, s, name, playerid, reasontext);
	    SendDiscordMessage(9, dc);
	}

	DeletePVar(playerid, "UsingSprunk");
	SetPVarInt(playerid, "GiveUptime", -1);
	pData[playerid][pSpawned] = 0;

	pData[playerid][CarryProduct] = 0;
	pData[playerid][CarryPart] = 0;
	pData[playerid][pProductingStatus] = 0;
	pData[playerid][pPemotongStatus] = 0;
	pData[playerid][pPartStatus] = 0;
	pData[playerid][pCookingStatus] = 0;
	pData[playerid][pMechanicStatus] = 0;
	pData[playerid][pActivityStatus] = 0;
	pData[playerid][pArmsDealerStatus] = 0;
	pData[playerid][pFillStatus] = 0;
	
	KillTimer(pData[playerid][pActivity]);
	KillTimer(pData[playerid][pMechanic]);
	KillTimer(pData[playerid][pProducting]);
	KillTimer(pData[playerid][pCooking]);
	KillTimer(pData[playerid][pPemotong]);
	KillTimer(pData[playerid][pCheckpointTarget]);
	KillTimer(pData[playerid][pPart]);
	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
	PlayerTextDrawHide(playerid, ActiveTD[playerid]);
	pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
	pData[playerid][pActivityTime] = 0;
	
	pData[playerid][pMechDuty] = 0;
	pData[playerid][pMission] = -1;
	
	pData[playerid][pSideJob] = 0;
	DisablePlayerCheckpoint(playerid);
	DisablePlayerRaceCheckpoint(playerid);
	SetPlayerColor(playerid, COLOR_WHITE);
	RemovePlayerAttachedObject(playerid, 9);
	GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
	UpdatePlayerData(playerid);
    if(IsAtEvent[playerid] == 1)
    {
    	SetPlayerPos(playerid, 1474.65, -1736.36, 13.38);
    	SetPlayerVirtualWorld(playerid, 0);
    	SetPlayerInterior(playerid, 0);
    	ClearAnimations(playerid);
    	ResetPlayerWeaponsEx(playerid);
       	SetPlayerColor(playerid, COLOR_WHITE);
    	if(GetPlayerTeam(playerid) == 1)
    	{
    		Servers(playerid, "Anda sudah terkalahkan");
    		RedTeam -= 1;
    	}
    	else if(GetPlayerTeam(playerid) == 2)
    	{
    		Servers(playerid, "Anda sudah terkalahkan");
    		BlueTeam -= 1;
    	}
    	if(BlueTeam == 0)
    	{
    		foreach(new ii : Player)
    		{
    			if(GetPlayerTeam(ii) == 1)
    			{
    				GivePlayerMoneyEx(ii, EventPrize);
    				Servers(ii, "Selamat, Tim Anda berhasil memenangkan Event dan Mendapatkan Hadiah $%d per orang", EventPrize);
    				pData[playerid][pHospital] = 0;
    				ClearAnimations(ii);
    				BlueTeam = 0;
    			}
    			else if(GetPlayerTeam(ii) == 2)
    			{
    				Servers(ii, "Maaf, Tim anda sudah terkalahkan, Harap Coba Lagi lain waktu");
    				pData[playerid][pHospital] = 0;
    				ClearAnimations(ii);
    				BlueTeam = 0;
    			}
    		}
    	}
    	if(RedTeam == 0)
    	{
    		foreach(new ii : Player)
    		{
    			if(GetPlayerTeam(ii) == 2)
    			{
    				GivePlayerMoneyEx(ii, EventPrize);
    				Servers(ii, "Selamat, Tim Anda berhasil memenangkan Event dan Mendapatkan Hadiah $%d per orang", EventPrize);
    				pData[playerid][pHospital] = 0;
    				ClearAnimations(ii);
    				BlueTeam = 0;
    			}
    			else if(GetPlayerTeam(ii) == 1)
    			{
    				Servers(ii, "Maaf, Tim anda sudah terkalahkan, Harap Coba Lagi lain waktu");
    				pData[playerid][pHospital] = 0;
    				ClearAnimations(ii);
    				RedTeam = 0;
    			}
    		}
    	}
    	SetPlayerTeam(playerid, 0);
    	IsAtEvent[playerid] = 0;
    	pData[playerid][pInjured] = 0;
    	pData[playerid][pSpawned] = 1;
		UpdateDynamic3DTextLabelText(pData[playerid][pInjuredLabel], COLOR_ORANGE, "");
    }
    if(IsAtEvent[playerid] == 0)
    {
    	new asakit = RandomEx(0, 5);
    	new bsakit = RandomEx(0, 9);
    	new csakit = RandomEx(0, 7);
    	new dsakit = RandomEx(0, 6);
    	pData[playerid][pLFoot] -= dsakit;
    	pData[playerid][pLHand] -= bsakit;
    	pData[playerid][pRFoot] -= csakit;
    	pData[playerid][pRHand] -= dsakit;
    	pData[playerid][pHead] -= asakit;
    }
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ,Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	new weaponid = EditingWeapon[playerid];
    if(weaponid)
    {
        if(response == 1)
        {
            new enum_index = weaponid - 22, weaponname[18], string[340];
 
            GetWeaponName(weaponid, weaponname, sizeof(weaponname));
           
            WeaponSettings[playerid][enum_index][Position][0] = fOffsetX;
            WeaponSettings[playerid][enum_index][Position][1] = fOffsetY;
            WeaponSettings[playerid][enum_index][Position][2] = fOffsetZ;
            WeaponSettings[playerid][enum_index][Position][3] = fRotX;
            WeaponSettings[playerid][enum_index][Position][4] = fRotY;
            WeaponSettings[playerid][enum_index][Position][5] = fRotZ;
 
            RemovePlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid));
            SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][enum_index][Bone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, 1.0, 1.0, 1.0);
 
            Servers(playerid, "You have successfully adjusted the position of your %s.", weaponname);
           
            mysql_format(g_SQL, string, sizeof(string), "INSERT INTO weaponsettings (Owner, WeaponID, PosX, PosY, PosZ, RotX, RotY, RotZ) VALUES ('%d', %d, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f) ON DUPLICATE KEY UPDATE PosX = VALUES(PosX), PosY = VALUES(PosY), PosZ = VALUES(PosZ), RotX = VALUES(RotX), RotY = VALUES(RotY), RotZ = VALUES(RotZ)", pData[playerid][pID], weaponid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ);
            mysql_tquery(g_SQL, string);
        }
		else if(response == 0)
		{
			new enum_index = weaponid - 22;
			SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][enum_index][Bone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, 1.0, 1.0, 1.0);
		}
        EditingWeapon[playerid] = 0;
		return 1;
    }
	else
	{
		if(response == 1)
		{
			InfoTD_MSG(playerid, 4000, "~g~~h~Toy Position Updated~y~!");

			pToys[playerid][index][toy_x] = fOffsetX;
			pToys[playerid][index][toy_y] = fOffsetY;
			pToys[playerid][index][toy_z] = fOffsetZ;
			pToys[playerid][index][toy_rx] = fRotX;
			pToys[playerid][index][toy_ry] = fRotY;
			pToys[playerid][index][toy_rz] = fRotZ;
			pToys[playerid][index][toy_sx] = fScaleX;
			pToys[playerid][index][toy_sy] = fScaleY;
			pToys[playerid][index][toy_sz] = fScaleZ;
			
			MySQL_SavePlayerToys(playerid);
		}
		else if(response == 0)
		{
			InfoTD_MSG(playerid, 4000, "~r~~h~Selection Cancelled~y~!");

			SetPlayerAttachedObject(playerid,
				index,
				modelid,
				boneid,
				pToys[playerid][index][toy_x],
				pToys[playerid][index][toy_y],
				pToys[playerid][index][toy_z],
				pToys[playerid][index][toy_rx],
				pToys[playerid][index][toy_ry],
				pToys[playerid][index][toy_rz],
				pToys[playerid][index][toy_sx],
				pToys[playerid][index][toy_sy],
				pToys[playerid][index][toy_sz]);
		}
		SetPVarInt(playerid, "UpdatedToy", 1);
		TogglePlayerControllable(playerid, true);
	}
	return 1;
}

public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT: objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(Player_EditingObject[playerid])
	{
		if (response == EDIT_RESPONSE_FINAL)
		{
			new
                vehicleid = Player_EditVehicleObject[playerid],
                vehid = GetPlayerVehicleID(playerid),
                slot = Player_EditVehicleObjectSlot[playerid],
                Float:vx,
                Float:vy,
                Float:vz,
                Float:va,
                Float:real_x,
                Float:real_y,
                Float:real_z,
                Float:real_a
            ;

            GetVehiclePos(vehid, vx, vy, vz);
            GetVehicleZAngle(vehid, va); // Coba lagi

            real_x = x - vx;
            real_y = y - vy;
            real_z = z - vz;
            real_a = rz - va;

            new Float:v_size[3];
            GetVehicleModelInfo(pvData[vehicleid][cModel], VEHICLE_MODEL_INFO_SIZE, v_size[0], v_size[1], v_size[2]);
            if(	(real_x >= v_size[0] || -v_size[0] >= real_x) ||
                (real_y >= v_size[1] || -v_size[1] >= real_y) ||
                (real_z >= v_size[2] || -v_size[2] >= real_z))
            {
                SendClientMessageEx(playerid, COLOR_ARWIN,"MODSHOP: "WHITE_E"Posisi object terlal jauh dari body kendaraan.");
                ResetEditing(playerid);
                return 1;
            }

            VehicleObjects[vehicleid][slot][vehObjectPosX] = real_x;
            VehicleObjects[vehicleid][slot][vehObjectPosY] = real_y;
            VehicleObjects[vehicleid][slot][vehObjectPosZ] = real_z;
            VehicleObjects[vehicleid][slot][vehObjectPosRX] = rx;
            VehicleObjects[vehicleid][slot][vehObjectPosRY] = ry;
            VehicleObjects[vehicleid][slot][vehObjectPosRZ] = real_a;
		
			Streamer_UpdateEx(playerid, VehicleObjects[vehicleid][slot][vehObjectPosX], VehicleObjects[vehicleid][slot][vehObjectPosY], VehicleObjects[vehicleid][slot][vehObjectPosZ]);
			if(VehicleObjects[vehicleid][slot][vehObjectType] == OBJECT_TYPE_BODY)
			{
				SetDynamicObjectMaterial(VehicleObjects[vehicleid][slot][vehObject], 0, VehicleObjects[vehicleid][slot][vehObjectModel], "none", "none", RGBAToARGB(ColorList[VehicleObjects[vehicleid][slot][vehObjectColor]]));
			}
			else if(VehicleObjects[vehicleid][slot][vehObjectType] == OBJECT_TYPE_TEXT)
			{
				SetDynamicObjectMaterialText(VehicleObjects[vehicleid][slot][vehObject], 0, VehicleObjects[vehicleid][slot][vehObjectText], 130, VehicleObjects[vehicleid][slot][vehObjectFont], VehicleObjects[vehicleid][slot][vehObjectFontSize], 1, RGBAToARGB(ColorList[VehicleObjects[vehicleid][slot][vehObjectFontColor]]), 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
			}
			AttachDynamicObjectToVehicle(VehicleObjects[vehicleid][slot][vehObject], pvData[vehicleid][cVeh], real_x, real_y, real_z, rx, ry, real_a);
        	Vehicle_ObjectUpdate(vehicleid, slot);
			//Vehicle_AttachObject(vehicleid, slot);
            Vehicle_ObjectSave(vehicleid, slot);
			
            if(VehicleObjects[vehicleid][slot][vehObjectType] == OBJECT_TYPE_BODY)
            {
                Dialog_Show(playerid, VACCSE, DIALOG_STYLE_LIST, "Edit Component", "Position\nPosition (Manual)\nChange Color\nRemove Modification\nSave", "Pilih", "Kembali");
            }
            else if(VehicleObjects[vehicleid][slot][vehObjectType] == OBJECT_TYPE_TEXT)
            {
                Dialog_Show(playerid, VACCSE1, DIALOG_STYLE_LIST, "Edit Component", "Position\nPosition (Manual)\nText Name\nText Size\nText Font\nText Color\nRemove Modification\nSave", "Pilih", "Kembali");
            }
            else if(VehicleObjects[vehicleid][slot][vehObjectType] == OBJECT_TYPE_LIGHT)
            {
                Dialog_Show(playerid, VACCSE2, DIALOG_STYLE_LIST, "Edit Component", "Position\nPosition (Manual)\nRemove Modification\nSave", "Pilih", "Kembali");
            }
			return 1;
		}

		if(response == EDIT_RESPONSE_CANCEL)
		{
			ResetEditing(playerid);
			return 1;
		}
	}
    if (response == EDIT_RESPONSE_FINAL)
	{
		if (EditingObject[playerid] != -1 && ObjectData[EditingObject[playerid]][objExists])
	    {
			ObjectData[EditingObject[playerid]][objPos][0] = x;
			ObjectData[EditingObject[playerid]][objPos][1] = y;
			ObjectData[EditingObject[playerid]][objPos][2] = z;
			ObjectData[EditingObject[playerid]][objPos][3] = rx;
			ObjectData[EditingObject[playerid]][objPos][4] = ry;
			ObjectData[EditingObject[playerid]][objPos][5] = rz;

			Object_Refresh(EditingObject[playerid]);
			Object_Save(EditingObject[playerid]);

			SendClientMessageEx(playerid, COLOR_WHITE, "OBJECT: {FFFFFF}You've edited the position of Object ID: %d.", EditingObject[playerid]);
	    }
		else if (EditingMatext[playerid] != -1 && MatextData[EditingMatext[playerid]][mtExists])
	    {
			MatextData[EditingMatext[playerid]][mtPos][0] = x;
			MatextData[EditingMatext[playerid]][mtPos][1] = y;
			MatextData[EditingMatext[playerid]][mtPos][2] = z;
			MatextData[EditingMatext[playerid]][mtPos][3] = rx;
			MatextData[EditingMatext[playerid]][mtPos][4] = ry;
			MatextData[EditingMatext[playerid]][mtPos][5] = rz;

			Matext_Refresh(EditingMatext[playerid]);
			Matext_Save(EditingMatext[playerid]);

			SendClientMessageEx(playerid, COLOR_WHITE, "MATEXT: {FFFFFF}You've edited the position of Material Text ID: %d.", EditingMatext[playerid]);
	    }

	    
	}
	if(pData[playerid][EditingATMID] != -1 && Iter_Contains(ATMS, pData[playerid][EditingATMID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingATMID];
	        AtmData[etid][atmX] = x;
	        AtmData[etid][atmY] = y;
	        AtmData[etid][atmZ] = z;
	        AtmData[etid][atmRX] = rx;
	        AtmData[etid][atmRY] = ry;
	        AtmData[etid][atmRZ] = rz;

	        SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
	        SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_X, AtmData[etid][atmX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_Y, AtmData[etid][atmY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_Z, AtmData[etid][atmZ] + 0.3);

		    Atm_Save(etid);
	        pData[playerid][EditingATMID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingATMID];
	        SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
	        SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);
	        pData[playerid][EditingATMID] = -1;
	    }
	}
	if(pData[playerid][gEditID] != -1 && Iter_Contains(Gates, pData[playerid][gEditID]))
	{
		new id = pData[playerid][gEditID];
		if(response == EDIT_RESPONSE_UPDATE)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
		}
		else if(response == EDIT_RESPONSE_CANCEL)
		{
			SetDynamicObjectPos(objectid, gPosX[playerid], gPosY[playerid], gPosZ[playerid]);
			SetDynamicObjectRot(objectid, gRotX[playerid], gRotY[playerid], gRotZ[playerid]);
			gPosX[playerid] = 0; gPosY[playerid] = 0; gPosZ[playerid] = 0;
			gRotX[playerid] = 0; gRotY[playerid] = 0; gRotZ[playerid] = 0;
			Servers(playerid, " You have canceled editing gate ID %d.", id);
			Gate_Save(id);
		}
		else if(response == EDIT_RESPONSE_FINAL)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
			if(pData[playerid][gEdit] == 1)
			{
				gData[id][gCX] = x;
				gData[id][gCY] = y;
				gData[id][gCZ] = z;
				gData[id][gCRX] = rx;
				gData[id][gCRY] = ry;
				gData[id][gCRZ] = rz;
				if(IsValidDynamic3DTextLabel(gData[id][gText])) DestroyDynamic3DTextLabel(gData[id][gText]);
				new str[64];
				format(str, sizeof(str), "Gate ID: %d", id);
				gData[id][gText] = CreateDynamic3DTextLabel(str, COLOR_WHITE, gData[id][gCX], gData[id][gCY], gData[id][gCZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
				
				pData[playerid][gEditID] = -1;
				pData[playerid][gEdit] = 0;
				Servers(playerid, " You have finished editing gate ID %d's closing position.", id);
				gData[id][gStatus] = 0;
				Gate_Save(id);
			}
			else if(pData[playerid][gEdit] == 2)
			{
				gData[id][gOX] = x;
				gData[id][gOY] = y;
				gData[id][gOZ] = z;
				gData[id][gORX] = rx;
				gData[id][gORY] = ry;
				gData[id][gORZ] = rz;
				
				pData[playerid][gEditID] = -1;
				pData[playerid][gEdit] = 0;
				Servers(playerid, " You have finished editing gate ID %d's opening position.", id);

				gData[id][gStatus] = 1;
				Gate_Save(id);
			}
		}
	}
	return 1;
}

public DoGMX()
{
	SendRconCommand("gmx");
	return 1;
}
function StressBerkurang(playerid)
{
	pData[playerid][pBladder] --;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(areaid == Healing)
	{
	    InfoMsg(playerid, "Anda telah meninggalkan Healing Peace Executive");
	    pData[playerid][TempatHealing] = false;
	    KillTimer(stresstimer[playerid]);
	}
}

forward OnPlayerEnterDynamicArea(playerid, areaid);
public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(areaid == Healing)
	{
	    InfoMsg(playerid, "Anda memasukin healing peace Executive");
        pData[playerid][TempatHealing] = true;
	}
	if(areaid == JualIkan)
	{
	    Jembut(playerid, "Untuk menjual ikan", 5);
	}
	if(areaid == JualNambang)
	{
	    Jembut(playerid, "Untuk menjual hasil nambang", 5);
	}
	if(areaid == JualPetani)
	{
	    Jembut(playerid, "Untuk menjual hasil tani/ternak", 5);
	}
	if(areaid == JualKayu)
	{
	    Jembut(playerid, "Untuk menjual hasil nebang kayu", 5);
	}
	
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
	if(checkpointid == atm2)
	{
	    HideSemua(playerid);
	}
	if(checkpointid == rentalbike)
	{
	    HideSemua(playerid);
	}
	if(checkpointid == rentalterminal)
	{
		HideSemua(playerid);
	}
	if(checkpointid == atm3)
	{
		HideSemua(playerid);
	}
	if(checkpointid == Disnaker)
	{
        HideSemua(playerid);
	}
	if(checkpointid == Creategunn)
	{
        HideSemua(playerid);
	}
	if(checkpointid == pernikahan)
	{
        HideSemua(playerid);
	}
	if(checkpointid == Kompensasi)
	{
		HideSemua(playerid);
	}
	if(checkpointid == spterminal)
	{
		HideSemua(playerid);
	}	
	if(checkpointid == BusArea[playerid][BusCp])
	{
		HideSemua(playerid);
	}
	if(checkpointid == BusArea[playerid][BusCpBaru])
	{
		HideSemua(playerid);
	}
	if(checkpointid == PemotongArea[playerid][LockerPemotong])
	{
		HideSemua(playerid);
	}
	if(checkpointid == PemotongArea[playerid][AmbilAyam])
	{
		HideSemua(playerid);
	}
	if(checkpointid == PemotongArea[playerid][PotongAyam])
	{
		HideSemua(playerid);
	}
	if(checkpointid == PemotongArea[playerid][PotongAyam2])
	{
		HideSemua(playerid);
	}
	if(checkpointid == PemotongArea[playerid][PotongAyam3])
	{
		HideSemua(playerid);
	}
	if(checkpointid == PemotongArea[playerid][PackingAyam2])
	{
		HideSemua(playerid);
	}
	if(checkpointid == PemotongArea[playerid][PackingAyam])
	{
		HideSemua(playerid);
	}
	if(checkpointid == PenambangArea[playerid][LockerTambang])
	{
		HideSemua(playerid);
	}
	if(checkpointid == PenambangArea[playerid][Nambang])
	{
		HideSemua(playerid);
	}
	if(checkpointid == PenambangArea[playerid][CuciBatu])
	{
		HideSemua(playerid);
	}
	if(checkpointid == PenambangArea[playerid][Peleburan])
	{
        HideSemua(playerid);
	}
	if(checkpointid == PenebangArea[playerid][LockerNebang])
	{
		HideSemua(playerid);
	}
	if(checkpointid == PenebangArea[playerid][Nebang])
	{
		HideSemua(playerid);
	}
	if(checkpointid == PenebangArea[playerid][ProsesKayu])
	{
		HideSemua(playerid);
	}
	if(checkpointid == MinyakArea[playerid][OlahMinyak])
	{
	    HideSemua(playerid);
	}
	if(checkpointid == MinyakArea[playerid][LockerTambang])
	{
	    HideSemua(playerid);
	}
	if(checkpointid == PemerahCP)
	{
		HideSemua(playerid);
	}
	if(checkpointid == MinyakArea[playerid][Nambangg])
	{
	    HideSemua(playerid);
	}
	if(checkpointid == MinyakArea[playerid][Nambang])
	{
	    HideSemua(playerid);
	}
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if(checkpointid == KargoArea[playerid][Kargo])
	{
		Jembut(playerid, "Mulai Tugas Kargo", 5);
	}
	if(checkpointid == atm2)
	{
		Jembut(playerid, "Menggunakan Atm", 5);
	}
	/*if(checkpointid == gudangkota)
	{
		Jembut(playerid, "Mengakses Gudang Kota", 5);
	}*/
	//kanabis
	if(checkpointid == kanabis1)
	{
		Jembut(playerid, "Untuk Mengambil kanabis", 5);
	}
	if(checkpointid == kanabis2)
	{
		Jembut(playerid, "Untuk Mengambil kanabis", 5);
	}
	if(checkpointid == kanabis3)
	{
		Jembut(playerid, "Untuk Mengambil kanabis", 5);
	}
	if(checkpointid == kanabis1)
	{
		Jembut(playerid, "Untuk Mengambil kanabis", 5);
	}
	if(checkpointid == kanabis1)
	{
		Jembut(playerid, "Untuk Mengambil kanabis", 5);
	}
	if(checkpointid == kanabis1)
	{
		Jembut(playerid, "Untuk Mengambil kanabis", 5);
	}
	if(checkpointid == kanabis1)
	{
		Jembut(playerid, "Untuk Mengambil kanabis", 5);
	}
	//garasi pemerintah
	if(checkpointid == garasisags)
	{
		Jembut(playerid, "Mengakses Garasi Pemerintah", 5);
	}
	if(checkpointid == garasigojek)
	{
		Jembut(playerid, "Mengakses Garasi Gojek", 5);
	}
	if(checkpointid == kendaraansapd)
	{
		Jembut(playerid, "Mengakses Garasi Kepolisian", 5);
	}
	if(checkpointid == garasisamd)
	{
		Jembut(playerid, "Mengakses Garasi Tenaga Medis", 5);
	}
	if(checkpointid == garasipedagang)
	{
		Jembut(playerid, "Mengakses Garasi Pedagang", 5);
	}
	if(checkpointid == rentalbike)
	{
		Jembut(playerid, "Merental sepeda", 5);
	}
	//aufa five em
	if(checkpointid == createlockpick)
	{
		Jembut(playerid, "Untuk membuat lock pick", 5);
	}
	if(checkpointid == rentalterminal)
	{
		Jembut(playerid, "Merental sepeda", 5);
	}
	if(checkpointid == menumasak)
	{
		Jembut(playerid, "Melihat Menu Masakan", 5);
	}
	if(checkpointid == menuminum)
	{
		Jembut(playerid, "Mengambil minuman", 5);
	}
	if(checkpointid == menupedagang)
	{
		Jembut(playerid, "Melihat menu pedagang", 5);
	}
	if(checkpointid == rentalpelabuhan)
	{
		Jembut(playerid, "Merental sepeda", 5);
	}
	if(checkpointid == mancing1)
	{
		Jembut(playerid, "Untuk Memancing Ikan", 5);
	}
	if(checkpointid == mancing2)
	{
		Jembut(playerid, "Untuk Memancing Ikan", 5);
	}
	if(checkpointid == mancing3)
	{
		Jembut(playerid, "Untuk Memancing Ikan", 5);
	}
	if(checkpointid == mancing4)
	{
		Jembut(playerid, "Untuk Memancing Ikan", 5);
	}
	if(checkpointid == mancing5)
	{
		Jembut(playerid, "Untuk Memancing Ikan", 5);
	}
	if(checkpointid == mancing6)
	{
		Jembut(playerid, "Untuk Memancing Ikan", 5);
	}
	if(checkpointid == mancing7)
	{
		Jembut(playerid, "Untuk Memancing Ikan", 5);
	}
	if(checkpointid == mancing8)
	{
		Jembut(playerid, "Untuk Memancing Ikan", 5);
	}
	/*if(checkpointid == mancing9)
	{
		Jembut(playerid, "Untuk Memancing Ikan", 5);
	}
	if(checkpointid == mancing10)
	{
		Jembut(playerid, "Untuk Memancing Ikan", 5);
	}*/
	if(checkpointid == sppelabuhan)
	{
		Jembut(playerid, "Untuk mengambil starterpack", 5);
	}
	if(checkpointid == atm3)
	{
		Jembut(playerid, "Menggunakan Atm", 5);
	}
	if(checkpointid == atm4)
	{
		Jembut(playerid, "Menggunakan Atm", 5);
	}
	if(checkpointid == atm1)
	{
		Jembut(playerid, "Menggunakan Atm", 5);
	}
	if(checkpointid == atm5)
	{
		Jembut(playerid, "Menggunakan Atm", 5);
	}
	if(checkpointid == atm7)
	{
		Jembut(playerid, "Menggunakan Atm", 5);
	}
	if(checkpointid == atm6)
	{
		Jembut(playerid, "Menggunakan Atm", 5);
	}
	if(checkpointid == asuransi)
	{
		Jembut(playerid, "Mengakses Asuransi", 5);
	}
	if(checkpointid == sellpv)
	{
		Jembut(playerid, "untuk menjual kendaraan", 5);
	}
	if(checkpointid == Disnaker)
	{
		Jembut(playerid, "Untuk Ambil Job", 5);
	}
	if(checkpointid == pernikahan)
	{
		Jembut(playerid, "Untuk mengambil makanan", 5);
	}
	if(checkpointid == Creategunn)
	{
		Jembut(playerid, "Untuk membuat Gun", 5);
	}
	if(checkpointid == Kompensasi)
	{
		Jembut(playerid, "Untuk Mengambil Starterpack", 5);
	}
	if(checkpointid == spterminal)
	{
		Jembut(playerid, "Untuk Mengambil Starterpack", 5);
	}
	if(checkpointid == ShowRoomCP)
	{
		ShowPlayerDialog(playerid, DIALOG_BUYPVCP, DIALOG_STYLE_LIST, "Executive - Showroom", "Sepeda Motor\nMobil\nMobil Sport", "Pilih", "Batal");
	}
	if(checkpointid == BusArea[playerid][BusCp])
	{
		Jembut(playerid, "Untuk memulai pekerjaan bus", 5);
	}
	if(checkpointid == BusArea[playerid][BusCpBaru])
	{
		Jembut(playerid, "Untuk memulai pekerjaan bus", 5);
	}
	if(checkpointid == PemotongArea[playerid][AmbilAyam])
	{
		Jembut(playerid, "Untuk Memulai Mengambil Ayam", 5);
	}
	if(checkpointid == PetaniArea[playerid][LockerTani])
	{
		Jembut(playerid, "Untuk Membeli Bibit", 5);
	}
	if(checkpointid == PetaniArea[playerid][PembuatanJadiApa])
	{
		Jembut(playerid, "Untuk Memproses Bahan Tani", 5);
	}
	if(checkpointid == PetaniArea[playerid][NanamTani])
	{
		Jembut(playerid, "Untuk Menanam Bibit", 5);
	}
	if(checkpointid == PetaniArea[playerid][NanamLagi])
	{
		Jembut(playerid, "Untuk Menanam Bibit", 5);
	}
	if(checkpointid == PetaniArea[playerid][NanamJuga])
	{
		Jembut(playerid, "Untuk Menanam Bibit", 5);
	}
	if(checkpointid == PetaniArea[playerid][NanamAja])
	{
		Jembut(playerid, "Untuk Menanam Bibit", 5);
	}
	if(checkpointid == PemotongArea[playerid][AmbilAyamHidup])
	{
		Jembut(playerid, "Untuk Mengambil Ayam", 5);
	}
	if(checkpointid == PemotongArea[playerid][PotongAyam])
	{
		Jembut(playerid, "Untuk Memotong Ayam", 5);
	}
	if(checkpointid == PemotongArea[playerid][PotongAyam2])
	{
		Jembut(playerid, "Untuk Memotong Ayam", 5);
	}
	if(checkpointid == PemotongArea[playerid][PotongAyam3])
	{
		Jembut(playerid, "Untuk Memotong Ayam", 5);
	}
	if(checkpointid == PemotongArea[playerid][PackingAyam2])
	{
		Jembut(playerid, "Untuk Packing Ayam", 5);
	}
	if(checkpointid == PemotongArea[playerid][PackingAyam])
	{
		Jembut(playerid, "Untuk Packing Ayam", 5);
	}
	if(checkpointid == PenambangArea[playerid][Nambang])
	{
		Jembut(playerid, "Untuk Memulai Menambang", 5);
	}
	if(checkpointid == PenambangArea[playerid][Nambang2])
	{
		Jembut(playerid, "Untuk Memulai Menambang", 5);
	}
	if(checkpointid == PenambangArea[playerid][Nambang3])
	{
		Jembut(playerid, "Untuk Memulai Menambang", 5);
	}
	if(checkpointid == PenambangArea[playerid][Nambang4])
	{
		Jembut(playerid, "Untuk Memulai Menambang", 5);
	}
	if(checkpointid == PenambangArea[playerid][Nambang5])
	{
		Jembut(playerid, "Untuk Memulai Menambang", 5);
	}
	if(checkpointid == PenambangArea[playerid][Nambang6])
	{
		Jembut(playerid, "Untuk Memulai Menambang", 5);
	}
	if(checkpointid == PenambangArea[playerid][CuciBatu])
	{
		Jembut(playerid, "Untuk Mencuci Batu", 5);
	}
	if(checkpointid == PenambangArea[playerid][Peleburan])
	{
		Jembut(playerid, "Untuk Meleburkan Batu", 5);
	}
	if(checkpointid == PenebangArea[playerid][Nebang])
	{
		Jembut(playerid, "Untuk Menggergaji Pohon", 5);
	}
	if(checkpointid == PenebangArea[playerid][Nebang1])
	{
		Jembut(playerid, "Untuk Menggergaji Pohon", 5);
	}
	if(checkpointid == PenebangArea[playerid][Nebang2])
	{
		Jembut(playerid, "Untuk Menggergaji Pohon", 5);
	}
	if(checkpointid == PenebangArea[playerid][Nebang3])
	{
		Jembut(playerid, "Untuk Menggergaji Pohon", 5);
	}
	if(checkpointid == PenebangArea[playerid][Nebang4])
	{
		Jembut(playerid, "Untuk Menggergaji Pohon", 5);
	}
	if(checkpointid == PenebangArea[playerid][ProsesKayu])
	{
		Jembut(playerid, "Untuk Memproses Pohon", 5);
	}
	if(checkpointid == PenebangArea[playerid][ProsesKayu1])
	{
		Jembut(playerid, "Untuk Memproses Pohon", 5);
	}
	if(checkpointid == MinyakArea[playerid][OlahMinyak])
	{
	    Jembut(playerid, "Untuk Olah Minyak", 5);
	}
	if(checkpointid == PemerahCP)
	{
		Jembut(playerid, "Untuk Akses ~p~Locker", 5);
	}
	if(checkpointid == MinyakArea[playerid][Nambangg])
	{
	    Jembut(playerid, "Untuk Ambil Minyak", 5);
	}
	if(checkpointid == MinyakArea[playerid][Nambang])
	{
	    Jembut(playerid, "Untuk Ambil Minyak", 5);
	}
	return 1;
}
public OnPlayerLeaveCheckpoint(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
	if(pData[playerid][pBus] && GetVehicleModel(vehicleid) == 431)
	{
		pData[playerid][pBuswaiting] = false;
		HideSemua(playerid);
	}
	return 1;
}
public OnPlayerEnterRaceCheckpoint(playerid)
{
	switch(pData[playerid][pCheckPoint])
	{
		case CHECKPOINT_BUS:
		{
			if(pData[playerid][pJob] == 1)
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				if(GetVehicleModel(vehicleid) == 431)
				{
					if(pData[playerid][pBus] == 1)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 2;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint2, buspoint2, 5.0);
					}
					else if(pData[playerid][pBus] == 2)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 3;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint3, buspoint3, 5.0);
					}
					else if(pData[playerid][pBus] == 3)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 4;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint4, buspoint4, 5.0);
					}
					else if(pData[playerid][pBus] == 4)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 5;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint5, buspoint5, 5.0);
					}
					else if(pData[playerid][pBus] == 5)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 6;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint6, buspoint6, 5.0);
					}
					else if(pData[playerid][pBus] == 6)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 7;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint7, buspoint7, 5.0);
					}
					else if(pData[playerid][pBus] == 7)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 8;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint8, buspoint8, 5.0);
					}
					else if(pData[playerid][pBus] == 8)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 9;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint9, buspoint9, 5.0);
					}
					else if(pData[playerid][pBus] == 9)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 10;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint10, buspoint10, 5.0);
					}
					else if(pData[playerid][pBus] == 10)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 11;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint11, buspoint11, 5.0);
					}
					else if(pData[playerid][pBus] == 11)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 12;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint12, buspoint12, 5.0);
					}
					else if(pData[playerid][pBus] == 12)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 13;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint13, buspoint13, 5.0);
					}
					else if(pData[playerid][pBus] == 13)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 14;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint14, buspoint14, 5.0);
					}
					else if(pData[playerid][pBus] == 14)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 15;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint15, buspoint15, 5.0);
					}
					else if(pData[playerid][pBus] == 15)
					{
						pData[playerid][pBuswaiting] = true;
						pData[playerid][pBustime] = 10;
						PlayerPlaySound(playerid, 43000, 1965.075073,-1779.868530,13.479113);
					}
					else if(pData[playerid][pBus] == 16)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 17;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint17, buspoint17, 5.0);
					}
					else if(pData[playerid][pBus] == 17)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 18;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint18, buspoint18, 5.0);
					}
					else if(pData[playerid][pBus] == 18)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 19;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint19, buspoint19, 5.0);
					}
					else if(pData[playerid][pBus] == 19)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 20;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint20, buspoint20, 5.0);
					}
					else if(pData[playerid][pBus] == 20)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 21;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint21, buspoint21, 5.0);
					}
					else if(pData[playerid][pBus] == 21)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 22;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint22, buspoint22, 5.0);
					}
					else if(pData[playerid][pBus] == 22)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 23;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint23, buspoint23, 5.0);
					}
					else if(pData[playerid][pBus] == 23)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 24;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint24, buspoint24, 5.0);
					}
					else if(pData[playerid][pBus] == 24)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 25;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint25, buspoint25, 5.0);
					}
					else if(pData[playerid][pBus] == 25)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 26;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint26, buspoint26, 5.0);
					}
					else if(pData[playerid][pBus] == 26)
					{
						pData[playerid][pBuswaiting] = true;
						pData[playerid][pBustime] = 10;
						PlayerPlaySound(playerid, 43000, 2763.975097,-2479.834228,13.575368);
					}
					else if(pData[playerid][pBus] == 27)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 28;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint28, buspoint28, 5.0);
					}
					else if(pData[playerid][pBus] == 28)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 29;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint29, buspoint29, 5.0);
					}
					else if(pData[playerid][pBus] == 29)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 30;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint30, buspoint30, 5.0);
					}
					else if(pData[playerid][pBus] == 30)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 31;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint31, buspoint31, 5.0);
					}
					else if(pData[playerid][pBus] == 31)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 32;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint32, buspoint32, 5.0);
					}
					else if(pData[playerid][pBus] == 32)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 33;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint33, buspoint33, 5.0);
					}
					else if(pData[playerid][pBus] == 33)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 34;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint34, buspoint34, 5.0);
					}
					else if(pData[playerid][pBus] == 34)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 35;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint35, buspoint35, 5.0);
					}
					else if(pData[playerid][pBus] == 35)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 36;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint36, buspoint36, 5.0);
					}
					else if(pData[playerid][pBus] == 36)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 37;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint37, buspoint37, 5.0);
					}
					else if(pData[playerid][pBus] == 37)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 38;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint38, buspoint38, 5.0);
					}
					else if(pData[playerid][pBus] == 38)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 39;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint39, buspoint39, 5.0);
					}
					else if(pData[playerid][pBus] == 39)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 40;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint40, buspoint40, 5.0);
					}
					else if(pData[playerid][pBus] == 40)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 41;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint41, buspoint41, 5.0);
					}
					else if(pData[playerid][pBus] == 41)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 42;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint42, buspoint42, 5.0);
					}
					else if(pData[playerid][pBus] == 42)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 43;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint43, buspoint43, 5.0);
					}
					else if(pData[playerid][pBus] == 43)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 44;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint44, buspoint44, 5.0);
					}
					else if(pData[playerid][pBus] == 44)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 45;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint45, buspoint45, 5.0);
					}
					else if(pData[playerid][pBus] == 45)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 46;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint46, buspoint46, 5.0);
					}
					else if(pData[playerid][pBus] == 46)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 47;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint47, buspoint47, 5.0);
					}
					else if(pData[playerid][pBus] == 47)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 48;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint48, buspoint48, 5.0);
					}
					else if(pData[playerid][pBus] == 48)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 49;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint49, buspoint49, 5.0);
					}
					else if(pData[playerid][pBus] == 49)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 50;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint50, buspoint50, 5.0);
					}
					else if(pData[playerid][pBus] == 50)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 51;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint51, buspoint51, 5.0);
					}
					else if(pData[playerid][pBus] == 51)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 52;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint52, buspoint52, 5.0);
					}
					else if(pData[playerid][pBus] == 52)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 53;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint53, buspoint53, 5.0);
					}
					else if(pData[playerid][pBus] == 53)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 54;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint54, buspoint54, 5.0);
					}
					else if(pData[playerid][pBus] == 54)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 55;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint55, buspoint55, 5.0);
					}
					else if(pData[playerid][pBus] == 55)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 56;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint56, buspoint56, 5.0);
					}
					else if(pData[playerid][pBus] == 56)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 57;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint57, buspoint57, 5.0);
					}
					else if(pData[playerid][pBus] == 57)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 58;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint58, buspoint58, 5.0);
					}
					else if(pData[playerid][pBus] == 58)
					{
						pData[playerid][pBuswaiting] = true;
						pData[playerid][pBustime] = 10;
						PlayerPlaySound(playerid, 43000, 1235.685913,-1855.510986,13.481544);
					}
					else if(pData[playerid][pBus] == 59)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 60;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint60, buspoint60, 5.0);
					}
					else if(pData[playerid][pBus] == 60)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 61;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint61, buspoint61, 5.0);
					}
					else if(pData[playerid][pBus] == 61)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 62;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint62, buspoint62, 5.0);
					}
					else if(pData[playerid][pBus] == 62)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 63;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint63, buspoint63, 5.0);
					}
					else if(pData[playerid][pBus] == 63)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 64;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint64, buspoint64, 5.0);
					}
					else if(pData[playerid][pBus] == 64)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 65;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint65, buspoint65, 5.0);
					}
					else if(pData[playerid][pBus] == 65)
					{
						pData[playerid][pBus] = 0;
						pData[playerid][pSideJob] = 0;
						pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
						DisablePlayerRaceCheckpoint(playerid);
					    GivePlayerMoneyEx(playerid, 250);
					    ShowItemBox(playerid, "Uang", "Received_$250", 1212, 4);
						RemovePlayerFromVehicle(playerid);
						if(IsValidVehicle(pData[playerid][pKendaraanKerja]))
   						DestroyVehicle(pData[playerid][pKendaraanKerja]);  //jika player disconnect maka kendaraan akan ilang
					}
					//bus rute baru
					else if(pData[playerid][pBus] == 66)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 67;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus2, cpbus2, 5.0);
					}
					else if(pData[playerid][pBus] == 67)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 68;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus3, cpbus3, 5.0);
					}
					else if(pData[playerid][pBus] == 68)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 70;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus4, cpbus4, 5.0);
					}
					else if(pData[playerid][pBus] == 69)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 70;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus5, cpbus5, 5.0);
					}
					else if(pData[playerid][pBus] == 70)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 71;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus6, cpbus6, 5.0);
					}
					else if(pData[playerid][pBus] == 71)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 72;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus7, cpbus7, 5.0);
					}
					else if(pData[playerid][pBus] == 72)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 73;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus8, cpbus8, 5.0);
					}
					else if(pData[playerid][pBus] == 73)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 74;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus9, cpbus9, 5.0);
					}
					else if(pData[playerid][pBus] == 74)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 75;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus10, cpbus10, 5.0);
					}
					else if(pData[playerid][pBus] == 75)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 76;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus11, cpbus11, 5.0);
					}
					else if(pData[playerid][pBus] == 76)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 77;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus12, cpbus12, 5.0);
					}
					else if(pData[playerid][pBus] == 77)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 78;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus13, cpbus13, 5.0);
					}
					else if(pData[playerid][pBus] == 78)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 79;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus14, cpbus14, 5.0);
					}
					else if(pData[playerid][pBus] == 79)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 80;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus15, cpbus15, 5.0);
					}
					else if(pData[playerid][pBus] == 80)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 81;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus16, cpbus16, 5.0);
					}
					else if(pData[playerid][pBus] == 81)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 82;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus17, cpbus17, 5.0);
					}
					else if(pData[playerid][pBus] == 82)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 83;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus18, cpbus18, 5.0);
					}
					else if(pData[playerid][pBus] == 83)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 84;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus19, cpbus19, 5.0);
					}
					else if(pData[playerid][pBus] == 84)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 85;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus20, cpbus20, 5.0);
					}
					else if(pData[playerid][pBus] == 85)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 86;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus21, cpbus21, 5.0);
					}
					else if(pData[playerid][pBus] == 86)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 87;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus22, cpbus22, 5.0);
					}
					else if(pData[playerid][pBus] == 87)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 88;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus23, cpbus23, 5.0);
					}
					else if(pData[playerid][pBus] == 88)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 89;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus24, cpbus24, 5.0);
					}
					else if(pData[playerid][pBus] == 89)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 90;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus25, cpbus25, 5.0);
					}
					else if(pData[playerid][pBus] == 90)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 91;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus26, cpbus26, 5.0);
					}
					else if(pData[playerid][pBus] == 91)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 92;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus27, cpbus27, 5.0);
					}
					else if(pData[playerid][pBus] == 92)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 93;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus28, cpbus28, 5.0);
					}
					else if(pData[playerid][pBus] == 93)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 94;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus29, cpbus29, 5.0);
					}
					else if(pData[playerid][pBus] == 94)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 95;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus30, cpbus30, 5.0);
					}
					else if(pData[playerid][pBus] == 95)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 96;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus31, cpbus31, 5.0);
					}
					else if(pData[playerid][pBus] == 96)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 97;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus32, cpbus32, 5.0);
					}
					else if(pData[playerid][pBus] == 97)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 98;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus33, cpbus33, 5.0);
					}
					else if(pData[playerid][pBus] == 98)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 99;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus34, cpbus34, 5.0);
					}
					else if(pData[playerid][pBus] == 99)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 100;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus35, cpbus35, 5.0);
					}
					else if(pData[playerid][pBus] == 100)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 101;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus36, cpbus36, 5.0);
					}
					else if(pData[playerid][pBus] == 101)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 102;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus37, cpbus37, 5.0);
					}
					else if(pData[playerid][pBus] == 102)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 103;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus38, cpbus38, 5.0);
					}
					else if(pData[playerid][pBus] == 103)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 104;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus39, cpbus39, 5.0);
					}
					else if(pData[playerid][pBus] == 104)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 105;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus40, cpbus40, 5.0);
					}
					else if(pData[playerid][pBus] == 105)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 106;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus41, cpbus41, 5.0);
					}
					else if(pData[playerid][pBus] == 106)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 107;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus42, cpbus42, 5.0);
					}
					else if(pData[playerid][pBus] == 107)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 108;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus43, cpbus43, 5.0);
					}
					else if(pData[playerid][pBus] == 108)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 109;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus44, cpbus44, 5.0);
					}
					else if(pData[playerid][pBus] == 109)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 110;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus45, cpbus45, 5.0);
					}
					else if(pData[playerid][pBus] == 110)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 111;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus46, cpbus46, 5.0);
					}
					else if(pData[playerid][pBus] == 111)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 112;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus47, cpbus47, 5.0);
					}
					else if(pData[playerid][pBus] == 112)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 113;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus48, cpbus48, 5.0);
					}
					else if(pData[playerid][pBus] == 113)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 114;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus49, cpbus49, 5.0);
					}
					else if(pData[playerid][pBus] == 114)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 115;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus50, cpbus50, 5.0);
					}
					else if(pData[playerid][pBus] == 115)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 116;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus51, cpbus51, 5.0);
					}
					else if(pData[playerid][pBus] == 116)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 117;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus52, cpbus52, 5.0);
					}
					else if(pData[playerid][pBus] == 117)
					{
						pData[playerid][pBus] = 0;
						pData[playerid][pSideJob] = 0;
						pData[playerid][pBusTime] = 0;
						pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
						DisablePlayerRaceCheckpoint(playerid);
						GivePlayerMoneyEx(playerid, 350);
					    ShowItemBox(playerid, "Uang", "Received_$350", 1212, 4);
						RemovePlayerFromVehicle(playerid);
						if(IsValidVehicle(pData[playerid][pKendaraanKerja]))
   						DestroyVehicle(pData[playerid][pKendaraanKerja]);  //jika player disconnect maka kendaraan akan ilang
					}
				}
			}
		}
		case CHECKPOINT_MISC:
		{
			pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
			DisablePlayerRaceCheckpoint(playerid);
		}
	}
	if(pData[playerid][pGpsActive] == 1)
	{
		pData[playerid][pGpsActive] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackCar] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan kendaraan anda!");
		pData[playerid][pTrackCar] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackHouse] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan rumah anda!");
		pData[playerid][pTrackHouse] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackBisnis] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan bisnis!");
		pData[playerid][pTrackBisnis] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pMission] > -1)
	{
		DisablePlayerRaceCheckpoint(playerid);
		Info(playerid, "/buy , /gps(My Mission) , /storeproduct.");
	}
	if(pData[playerid][pJob] == 8)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 515)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.5, 290.330383,2542.228027,16.820337))
			{
				ShowProgressbar(playerid, "Memuat Kargo..", 20);
				SetTimerEx("MuatBarang", 20000, false, "d", playerid);
				DisablePlayerRaceCheckpoint(playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, 2814.943847,964.729858,10.750000))
			{
				ShowProgressbar(playerid, "Memuat Kargo..", 20);
				SetTimerEx("MuatBarangRock", 20000, false, "d", playerid);
				DisablePlayerRaceCheckpoint(playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, 1633.136718,971.050537,10.820312))
			{
				ShowProgressbar(playerid, "Memuat Kargo..", 20);
				SetTimerEx("MuatBarangLva", 20000, false, "d", playerid);
				DisablePlayerRaceCheckpoint(playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, -1326.462036,2688.859619,50.062500))
			{
				ShowProgressbar(playerid, "Memuat Kargo..", 20);
				SetTimerEx("BahanBakar", 20000, false, "d", playerid);
                DisablePlayerRaceCheckpoint(playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, 249.263397,1443.614746,10.585937))
			{
				ShowProgressbar(playerid, "Memuat Kargo..", 20);
				SetTimerEx("BahanBakarLv", 20000, false, "d", playerid);
                DisablePlayerRaceCheckpoint(playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, -1676.272094,412.909149,7.179687))
			{
				ShowProgressbar(playerid, "Memuat Kargo..", 20);
				SetTimerEx("BahanBakarSf", 20000, false, "d", playerid);
                DisablePlayerRaceCheckpoint(playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 3.5, -1040.951782,-656.037048,32.007812))
			{
			    if(pData[playerid][pKargo] == 1)
			    {
			        if(IsValidVehicle(pData[playerid][pKendaraanKerja]))
			   		DestroyVehicle(pData[playerid][pKendaraanKerja]);

				    if(IsValidVehicle(pData[playerid][pTrailer]))
				   		DestroyVehicle(pData[playerid][pTrailer]);
					GivePlayerMoneyEx(playerid, 1150);
					ShowItemBox(playerid, "Uang", "Received_$1,150", 1212, 2);
					DisablePlayerRaceCheckpoint(playerid);
					SuccesMsg(playerid, "Anda berhasil ekspor ~y~Puing Pesawat ~w~seharga ~p~$1,150.");
			    }
			    if(pData[playerid][pKargo] == 2)
			    {
			        if(IsValidVehicle(pData[playerid][pKendaraanKerja]))
			   		DestroyVehicle(pData[playerid][pKendaraanKerja]);

				    if(IsValidVehicle(pData[playerid][pTrailer]))
				   		DestroyVehicle(pData[playerid][pTrailer]);
					GivePlayerMoneyEx(playerid, 1250);
					ShowItemBox(playerid, "Uang", "Received_$1,250", 1212, 2);
					DisablePlayerRaceCheckpoint(playerid);
					SuccesMsg(playerid, "Anda berhasil ekspor ~y~Bahan Bakar ~w~seharga ~p~$1,250.");
			    }
			    if(pData[playerid][pKargo] == 3)
			    {
			        if(IsValidVehicle(pData[playerid][pKendaraanKerja]))
			   		DestroyVehicle(pData[playerid][pKendaraanKerja]);

				    if(IsValidVehicle(pData[playerid][pTrailer]))
				   		DestroyVehicle(pData[playerid][pTrailer]);
					GivePlayerMoneyEx(playerid, 1300);
					ShowItemBox(playerid, "Uang", "Received_$1,300", 1212, 2);
					DisablePlayerRaceCheckpoint(playerid);
					SuccesMsg(playerid, "Anda berhasil ekspor ~y~Barang ~w~seharga ~p~$1,300.");
			    }
			    if(pData[playerid][pKargo] == 4)
			    {
			        if(IsValidVehicle(pData[playerid][pKendaraanKerja]))
			   		DestroyVehicle(pData[playerid][pKendaraanKerja]);

				    if(IsValidVehicle(pData[playerid][pTrailer]))
				   		DestroyVehicle(pData[playerid][pTrailer]);
					GivePlayerMoneyEx(playerid, 750);
					ShowItemBox(playerid, "Uang", "Received_$750", 1212, 2);
					DisablePlayerRaceCheckpoint(playerid);
					SuccesMsg(playerid, "Anda berhasil ekspor ~y~Bahan Bakar ~w~seharga ~p~$750.");
			    }
			    if(pData[playerid][pKargo] == 5)
			    {
			        if(IsValidVehicle(pData[playerid][pKendaraanKerja]))
			   		DestroyVehicle(pData[playerid][pKendaraanKerja]);

				    if(IsValidVehicle(pData[playerid][pTrailer]))
				   		DestroyVehicle(pData[playerid][pTrailer]);
					GivePlayerMoneyEx(playerid, 850);
					ShowItemBox(playerid, "Uang", "Received_$850", 1212, 2);
					DisablePlayerRaceCheckpoint(playerid);
					SuccesMsg(playerid, "Anda berhasil ekspor ~y~Barang ~w~seharga ~p~$850.");
			    }
			    if(pData[playerid][pKargo] == 6)
			    {
			        if(IsValidVehicle(pData[playerid][pKendaraanKerja]))
			   		DestroyVehicle(pData[playerid][pKendaraanKerja]);

				    if(IsValidVehicle(pData[playerid][pTrailer]))
				   		DestroyVehicle(pData[playerid][pTrailer]);
					GivePlayerMoneyEx(playerid, 550);
					ShowItemBox(playerid, "Uang", "Received_$550", 1212, 2);
					DisablePlayerRaceCheckpoint(playerid);
					SuccesMsg(playerid, "Anda berhasil ekspor ~y~Bahan Bakar ~w~seharga ~p~$550.");
			    }
			}
		}
	}
	if(pData[playerid][pHauling] > -1)
	{
		if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
		{
			DisablePlayerRaceCheckpoint(playerid);
			Info(playerid, "'/storegas' untuk menyetor GasOilnya!");
		}
		else
		{
			if(IsPlayerInRangeOfPoint(playerid, 10.0, 335.66, 861.02, 21.01))
			{
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, 336.70, 895.54, 20.40, 5.5);
				Info(playerid, "Silahkan ambil trailer dan menuju ke checkpoint untuk membeli GasOil!");
			}
			else
			{
				Error(playerid, "Anda tidak membawa Trailer Gasnya, Silahkan ambil kembali trailernnya!");
			}
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    CPHunter(playerid);
	if (PlayerInfo[playerid][pWaypoint])
	{
		PlayerInfo[playerid][pWaypoint] = 0;

		DisablePlayerCheckpoint(playerid);
		PlayerTextDrawHide(playerid, PlayerInfo[playerid][pTextdraws][69]);
		SuccesMsg(playerid, "Anda telah sampai ditujuan :)");
	}
	if(pData[playerid][pFillCp] == true)
	{
		if(pData[playerid][pGrabFuel] == true)
		{
			InfoMsg(playerid, "Silahkan /isibensin untuk mengisi");
		}
		else
		{
			InfoMsg(playerid, "Anda belum mengambil nozzle di SPBU");
		}
	}
	if(pData[playerid][sedangambilayam] == true)
	{
		DisablePlayerCheckpoint(playerid);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant",	4.1, 1, 0, 0, 0, 0, 1);
		ShowProgressbar(playerid, "Mengambil Ayam", 5);
		SetTimerEx("ngambilayam", 5000, false, "i", playerid);
	}
	if(pData[playerid][pHauling] > -1)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.5, 336.70, 895.54, 20.40))
		{
			DisablePlayerCheckpoint(playerid);
			Info(playerid, "/buy, /gps(My Hauling), /storegas.");
		}
	}
	if(pData[playerid][pFindEms] != INVALID_PLAYER_ID)
	{
		pData[playerid][pFindEms] = INVALID_PLAYER_ID;
		DisablePlayerCheckpoint(playerid);
	}
	if(pData[playerid][pSideJob] == 2)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 431)
		{
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint1))
			{
				SetPlayerCheckpoint(playerid, buspoint2, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint2))
			{
				SetPlayerCheckpoint(playerid, buspoint3, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint3))
			{
				SetPlayerCheckpoint(playerid, buspoint4, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint4))
			{
				SetPlayerCheckpoint(playerid, buspoint5, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint5))
			{
				SetPlayerCheckpoint(playerid, buspoint6, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint6))
			{
				SetPlayerCheckpoint(playerid, buspoint7, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint7))
			{
				SetPlayerCheckpoint(playerid, buspoint8, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint8))
			{
				SetPlayerCheckpoint(playerid, buspoint9, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint9))
			{
				SetPlayerCheckpoint(playerid, buspoint10, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint10))
			{
				SetPlayerCheckpoint(playerid, buspoint11, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint11))
			{
				SetPlayerCheckpoint(playerid, buspoint12, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint12))
			{
				SetPlayerCheckpoint(playerid, buspoint13, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint13))
			{
				SetPlayerCheckpoint(playerid, buspoint14, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint14))
			{
				SetPlayerCheckpoint(playerid, buspoint15, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint15))
			{
				SetPlayerCheckpoint(playerid, buspoint16, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint16))
			{
				SetPlayerCheckpoint(playerid, buspoint17, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint17))
			{
				SetPlayerCheckpoint(playerid, buspoint18, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint18))
			{
				SetPlayerCheckpoint(playerid, buspoint19, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint19))
			{
				SetPlayerCheckpoint(playerid, buspoint20, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint20))
			{
				SetPlayerCheckpoint(playerid, buspoint21, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint21))
			{
				SetPlayerCheckpoint(playerid, buspoint22, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint22))
			{
				SetPlayerCheckpoint(playerid, buspoint23, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint23))
			{
				SetPlayerCheckpoint(playerid, buspoint24, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint24))
			{
				SetPlayerCheckpoint(playerid, buspoint25, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint25))
			{
				SetPlayerCheckpoint(playerid, buspoint26, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint26))
			{
				SetPlayerCheckpoint(playerid, buspoint27, 7.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 7.0,buspoint27))
			{
				pData[playerid][pSideJob] = 0;
				pData[playerid][pBusTime] = 280;
				DisablePlayerCheckpoint(playerid);
				AddPlayerSalary(playerid, "Sidejob(Bus)", 300);
				Info(playerid, "Sidejob(Bus) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    DEN_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_NO))
	{
		if(pData[playerid][CarryingBox])
		{
			Player_DropBox(playerid);
		}
	}
	if((newkeys & KEY_SECONDARY_ATTACK))
    {
		foreach(new did : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
			{
				if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
					return ErrorMsg(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

				if(dData[did][dLocked])
					return ErrorMsg(playerid, "This entrance is locked at the moment.");
					
				if(dData[did][dFaction] > 0)
				{
					if(dData[did][dFaction] != pData[playerid][pFaction])
						return ErrorMsg(playerid, "This door only for faction.");
				}
				if(dData[did][dFamily] > 0)
				{
					if(dData[did][dFamily] != pData[playerid][pFamily])
						return ErrorMsg(playerid, "This door only for family.");
				}
				
				if(dData[did][dVip] > pData[playerid][pVip])
					return ErrorMsg(playerid, "Your VIP level not enough to enter this door.");
				
				if(dData[did][dAdmin] > pData[playerid][pAdmin])
					return ErrorMsg(playerid, "Your admin level not enough to enter this door.");
					
				if(strlen(dData[did][dPass]))
				{
					new params[256];
					if(sscanf(params, "s[256]", params)) return SyntaxMsg(playerid, "/enter [password]");
					if(strcmp(params, dData[did][dPass])) return Error(playerid, "Invalid door password.");
					
					if(dData[did][dCustom])
					{
						SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					else
					{
						SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
					pData[playerid][pInDoor] = did;
					ShowProgressbar(playerid, "Loading Rendering..", 3);
					SetPlayerInterior(playerid, dData[did][dIntint]);
					SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, 0);
				}
				else
				{
					if(dData[did][dCustom])
					{
						SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					else
					{
						SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
					pData[playerid][pInDoor] = did;
					ShowProgressbar(playerid, "Loading Rendering..", 3);
					SetPlayerInterior(playerid, dData[did][dIntint]);
					SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, 0);
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]))
			{
				if(dData[did][dFaction] > 0)
				{
					if(dData[did][dFaction] != pData[playerid][pFaction])
						return Error(playerid, "This door only for faction.");
				}
				
				if(dData[did][dCustom])
				{
					SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
				}
				else
				{
					SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
				}
				pData[playerid][pInDoor] = -1;
				if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
				ShowProgressbar(playerid, "Loading Rendering..", 3);
				SetPlayerInterior(playerid, dData[did][dExtint]);
				SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
			}
        }
		//Houses
		foreach(new hid : Houses)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
			{
				if(hData[hid][hIntposX] == 0.0 && hData[hid][hIntposY] == 0.0 && hData[hid][hIntposZ] == 0.0)
					return Error(playerid, "Interior house masih kosong, atau tidak memiliki interior.");

				if(hData[hid][hLocked])
					return Error(playerid, "This house is locked!");
				
				pData[playerid][pInHouse] = hid;
				SetPlayerPositionEx(playerid, hData[hid][hIntposX], hData[hid][hIntposY], hData[hid][hIntposZ], hData[hid][hIntposA]);

				SetPlayerInterior(playerid, hData[hid][hInt]);
				SetPlayerVirtualWorld(playerid, hid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inhouseid = pData[playerid][pInHouse];
		if(pData[playerid][pInHouse] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, hData[inhouseid][hIntposX], hData[inhouseid][hIntposY], hData[inhouseid][hIntposZ]))
		{
			pData[playerid][pInHouse] = -1;
			SetPlayerPositionEx(playerid, hData[inhouseid][hExtposX], hData[inhouseid][hExtposY], hData[inhouseid][hExtposZ], hData[inhouseid][hExtposA]);
			
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Family
		foreach(new fid : FAMILYS)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ]))
			{
				if(fData[fid][fIntposX] == 0.0 && fData[fid][fIntposY] == 0.0 && fData[fid][fIntposZ] == 0.0)
					return Error(playerid, "Interior masih kosong, atau tidak memiliki interior.");

				if(pData[playerid][pFaction] == 0)
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have registered for this door!");
					
				pData[playerid][pInFamily] = fid;	
				SetPlayerPositionEx(playerid, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ], fData[fid][fIntposA]);

				SetPlayerInterior(playerid, fData[fid][fInt]);
				SetPlayerVirtualWorld(playerid, fid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
			new difamily = pData[playerid][pInFamily];
			if(pData[playerid][pInFamily] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, fData[difamily][fIntposX], fData[difamily][fIntposY], fData[difamily][fIntposZ]))
			{
				pData[playerid][pInFamily] = -1;	
				SetPlayerPositionEx(playerid, fData[difamily][fExtposX], fData[difamily][fExtposY], fData[difamily][fExtposZ], fData[difamily][fExtposA]);

				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
			}
        }
	}
	//SAPD Taser/Tazer
	if(newkeys & KEY_FIRE && TaserData[playerid][TaserEnabled] && GetPlayerWeapon(playerid) == 0 && !IsPlayerInAnyVehicle(playerid) && TaserData[playerid][TaserCharged])
	{
  		TaserData[playerid][TaserCharged] = false;

	    new Float: x, Float: y, Float: z, Float: health;
     	GetPlayerPos(playerid, x, y, z);
	    PlayerPlaySound(playerid, 6003, 0.0, 0.0, 0.0);
	    ApplyAnimation(playerid, "KNIFE", "KNIFE_3", 4.1, 0, 1, 1, 0, 0, 1);
		pData[playerid][pActivityTime] = 0;
	    TaserData[playerid][ChargeTimer] = SetTimerEx("ChargeUp", 1000, true, "i", playerid);
		PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Recharge...");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);

	    for(new i, maxp = GetPlayerPoolSize(); i <= maxp; ++i)
		{
	        if(!IsPlayerConnected(i)) continue;
          	if(playerid == i) continue;
          	if(TaserData[i][TaserCountdown] != 0) continue;
          	if(IsPlayerInAnyVehicle(i)) continue;
			if(GetPlayerDistanceFromPoint(i, x, y, z) > 2.0) continue;
			ClearAnimations(i, 1);
			TogglePlayerControllable(i, false);
   			ApplyAnimation(i, "CRACK", "crckdeth2", 4.1, 0, 0, 0, 1, 0, 1);
			PlayerPlaySound(i, 6003, 0.0, 0.0, 0.0);

			GetPlayerHealth(i, health);
			TaserData[i][TaserCountdown] = TASER_BASETIME + floatround((100 - health) / 12);
   			Info(i, "Anda bisa memakai Taser setelah %d detik!", TaserData[i][TaserCountdown]);
			TaserData[i][GetupTimer] = SetTimerEx("TaserGetUp", 1000, true, "i", i);
			break;
	    }
	}
	if((newkeys & KEY_CTRL_BACK))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return 1;
	    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		ShowPlayerDialog(playerid, DIALOG_RADIAL, DIALOG_STYLE_TABLIST_HEADERS, "Radial Menu - {7fffd4}Kota Executive", "Kategori\tPenjelasan\n{BABABA}Dokumen Pribadi\t{BABABA}-> Untuk melihat dokumen pribadi\n{ffffff}Phone\t-> Untuk membuka smartphone\n{BABABA}Inventory\t{BABABA}-> Untuk membuka tas\n{ffffff}Walkie Talkie\t-> Untuk membuka walkie talkie\n{BABABA}Faction Menu\t{BABABA}-> Untuk membuka menu faction\n{ffffff}Voice Mode\t-> Untuk mengganti jarak suara\n{BABABA}Kendaraan\t{BABABA}-> Untuk membuka menu kendaraan\n{ffffff}Aksesoris\t-> Untuk mengatur aksesoris\n{BABABA}Radio Mode\t{BABABA}-> Untuk toggle berbicara di radio\n{FFFFFF}Geledah Menu\t{FFFFFf}-> Untuk melihat item orang\n{FFFFFF}Invoice\t{ffffff}-> Untuk melihat daftar tagihan mu", "Pilih", "Tutup");
	}
	if(newkeys & KEY_HANDBRAKE && GetPlayerWeapon(playerid) == 24 && GetNearbyRobbery(playerid) >= 0)
	{
	    for(new i = 0; i < MAX_ROBBERY; i++)
		{
		    if(IsPlayerInRangeOfPoint(playerid, 2.3, RobberyData[i][robberyX], RobberyData[i][robberyY], RobberyData[i][robberyZ]))
			{
				if(Warung == true) return 1;
				SetTimerEx("RobWarung", 10000, false, "d", playerid);
				ApplyActorAnimation(RobberyData[i][robberyID], "ROB_BANK","SHP_HandsUp_Scr",4.0,0,0,0,1,0);
				Warung = true;
				new label[100];
				format(label, sizeof label, "Penjaga : Jangan sakiti aku tuan, aku akan memberikanmu uangnya");
				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				new lstr[1024];
				format(lstr, sizeof(lstr), "PERAMPOKAN | WARUNG: {ffffff}Telah terjadi perampokan warung di daerah %s", GetLocation(x, y, z));
				SendClientMessageToAll(COLOR_ORANGE2, lstr);
				RobberyData[i][robberyText] = CreateDynamic3DTextLabel(label, COLOR_WHITE, RobberyData[i][robberyX], RobberyData[i][robberyY], RobberyData[i][robberyZ]+1.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1, 10.0);
			}
		}
	}
	if(newkeys & KEY_NO)
	{
		callcmd::death(playerid, "");
	}
	//-----[ Vehicle ]-----	
	if((newkeys & KEY_NO ))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			return callcmd::engine(playerid, "");
		}
	}
	if((newkeys & KEY_WALK ))
	{
		foreach(new lid : Lockers)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ]))
			{
				if(pData[playerid][pVip] > 0 && lData[lid][lType] == 7)
				{
					ShowPlayerDialog(playerid, DIALOG_LOCKERVIP, DIALOG_STYLE_LIST, "Executive - VIP Locker", "Health\nWeapons\nClothing\nVip Toys", "Okay", "Batal");
				}
				else if(pData[playerid][pFaction] == 1 && pData[playerid][pFaction] == lData[lid][lType])
				{
					ShowPlayerDialog(playerid, DIALOG_LOCKERSAPD, DIALOG_STYLE_LIST, "Executive - Locker Kepolisian", "Baju Kerja\nArmour\nSenjata", "Pilih", "Batal");
				}
				else if(pData[playerid][pFaction] == 2 && pData[playerid][pFaction] == lData[lid][lType])
				{
					ShowPlayerDialog(playerid, DIALOG_LOCKERSAGS, DIALOG_STYLE_LIST, "Executive - Locker Pemerintah", "Baju Kerja\nArmour\nSenjata", "Pilih", "Batal");
				}
				else if(pData[playerid][pFaction] == 3 && pData[playerid][pFaction] == lData[lid][lType])
				{
					ShowPlayerDialog(playerid, DIALOG_LOCKERSAMD, DIALOG_STYLE_LIST, "Executive - Locker Medis", "Baju Kerja\nObat", "Pilih", "Batal");
				}
				else if(pData[playerid][pFaction] == 4 && pData[playerid][pFaction] == lData[lid][lType])
				{
					ShowPlayerDialog(playerid, DIALOG_LOCKERSANEW, DIALOG_STYLE_LIST, "Executive - Locker Pembawa Berita", "Baju Kerja", "Proceed", "Batal");
				}
				else if(pData[playerid][pFaction] == 5 && pData[playerid][pFaction] == lData[lid][lType])
				{
					ShowPlayerDialog(playerid, DIALOG_LOCKERPEDAGANG, DIALOG_STYLE_LIST, "Executive - Locker Pedagang", "Baju Kerja", "Pilih", "Batal");
				}
				else if(pData[playerid][pFaction] == 6 && pData[playerid][pFaction] == lData[lid][lType])
				{
					ShowPlayerDialog(playerid, DIALOG_LOCKERGOJEK, DIALOG_STYLE_LIST, "Executive - Locker Gojek", "Seragam Driver Gojek\nSeragam biasa", "Pilih", "Batal");
				}
				else if(pData[playerid][pFamily] > -1)
				{
					ShowPlayerDialog(playerid, DIALOG_SKINFAM, DIALOG_STYLE_LIST, "Executive - Family Lockers", "Baju Fam", "Pilih", "Batal");
				}
				else return ErrorMsg(playerid, "Anda tidak mengakses locker ini!");
			}
		}
	}
	if((newkeys & KEY_WALK ))
	{
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 1510.5328,-2178.1340,13.6257))
	{
	    if(!GetOwnedVeh(playerid)) return ErrorMsg(playerid, "Anda tidak memiliki kendaraan apapun.");
		new vid, _tmpstring[128], count = GetOwnedVeh(playerid), CMDSString[512], status[30], status1[30];
		CMDSString = "";
		strcat(CMDSString,"VID\tModel [Database ID]\tPlate\t\tBiaya Asuransi\n",sizeof(CMDSString));
		Loop(itt, (count + 1), 1)
		{
			vid = ReturnPlayerVehID(playerid, itt);
			if(pvData[vid][cPark] != -1)
			{
				status = ""LG_E"Garkot";
			}
			else if(pvData[vid][cClaim] != 0)
			{
				status = "Asuransi";
			}
			else if(pvData[vid][cStolen] != 0)
			{
				status = ""RED_E"Rusak";
			}
			else
			{
				status = "Spawned";
			}

			if(itt == count)
			{
				format(_tmpstring, sizeof(_tmpstring), "{ffffff}[%s]\t%s [%d]{ffffff}\t%s\t\t"LG_E"$500\n", status, GetVehicleModelName(pvData[vid][cModel]), pvData[vid][cID], pvData[vid][cPlate]);
			}
			else format(_tmpstring, sizeof(_tmpstring), "{ffffff}[%s]\t%s [%d]{ffffff}\t%s\t\t"LG_E"$500\n", status, GetVehicleModelName(pvData[vid][cModel]), pvData[vid][cID], pvData[vid][cPlate]);
			strcat(CMDSString, _tmpstring);
		}
		ShowPlayerDialog(playerid, DIALOG_ASURANSI, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Ansuransi Kendaraan", CMDSString, "Pilih", "Batal");
	}
}
	//sell pv
	if(newkeys & KEY_WALK)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3, 1516.3483,-2177.7971,13.6174))
        {
        	callcmd::sellpv(playerid, "");
        }
	}
	if((newkeys & KEY_WALK))
	{
	   	foreach(new gsid : GStation)
		{
			if(IsPlayerInRangeOfPoint(playerid, 1.0, gsData[gsid][gsPosX], gsData[gsid][gsPosY], gsData[gsid][gsPosZ]))
			{
				new veh = pData[playerid][pFillVeh];
				if(pData[playerid][pFillStatus] == 1)
					return ErrorMsg(playerid, "Anda sedang mengisi bahan bakar, mohon ditunggu!");

				if(GetVehicleFuel(veh) == 100)
					return ErrorMsg(playerid, "Bensin di kendaraan anda sudah penuh");
					
				if(gsData[gsid][gsStock] < 1)
					return ErrorMsg(playerid, "Pom bensin tidak mempunyai stok!");

				ShowPlayerDialog(playerid, DIALOG_BENSIN, DIALOG_STYLE_LIST, "SPBU", "Ambil Nozzle untuk mengisi Bensin\nBeli Jerigen", "Pilih", "Batal");
			}
		}
	}
	//-----[ Bisnis ]-----
	if((newkeys & KEY_WALK))
	{
	    foreach(new bid : Bisnis)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
			{
				if(bData[bid][bLocked])
					return ErrorMsg(playerid, "Bisnis Ini Sedang Tutup!");

					pData[playerid][pInBiz] = bid;
					Bisnis_BuyMenu(playerid, pData[playerid][pInBiz]);
				}
			}
	}
	if((newkeys & KEY_NO ))
	{
		foreach(new id : Bisnis)
		{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]))
		{
			if(bData[id][bPrice] > GetPlayerMoney(playerid)) return ErrorMsg(playerid, "Uang anda tidak cukup, anda tidak dapat membeli bisnis ini!.");
			if(strcmp(bData[id][bOwner], "-")) return ErrorMsg(playerid, "Someone already owns this bisnis.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 2) return ErrorMsg(playerid, "You can't buy any more bisnis.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 3) return ErrorMsg(playerid, "You can't buy any more bisnis.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 4) return Error(playerid, "You can't buy any more bisnis.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 1) return ErrorMsg(playerid, "You can't buy any more bisnis.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -bData[id][bPrice]);
			GetPlayerName(playerid, bData[id][bOwner], MAX_PLAYER_NAME);
			bData[id][bOwnerID] = pData[playerid][pID];
			bData[id][bVisit] = gettime();
			new str[522], query[500];
			format(str,sizeof(str),"[BIZ]: %s membeli bisnis id %d seharga %s!", GetRPName(playerid), id, FormatMoney(bData[id][bPrice]));
			SuccesMsg(playerid, str);
			LogServer("Property", str);
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET owner='%s', ownerid='%d', visit='%d' WHERE ID='%d'", bData[id][bOwner], bData[id][bOwnerID], bData[id][bVisit], id);
			mysql_tquery(g_SQL, query);
			Bisnis_Refresh(id);
			Bisnis_Save(id);
		}
	}
}
	if(newkeys & KEY_WALK)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3, 435.119323,1264.405517,9.370626))
        {
        	callcmd::kerjaminyak1(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, 490.874359,1294.272338,9.020936))
        {
        	callcmd::kerjaminyak2(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, 570.088989,1219.789794,11.711267))
        {
        	callcmd::saringminyak(playerid, "");
        }
	}
	if(newkeys & KEY_WALK)
	{
		if(IsPlayerInRangeOfPoint(playerid, 1, 202.3336,-1918.2603,1.2257))
        {
        	callcmd::mancingAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, 197.5030,-1918.0684,1.2261))
        {
        	callcmd::mancingAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, 194.7841,-1937.1458,1.2014))
        {
        	callcmd::mancingAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, 175.2086,-1933.6747,1.2014))
        {
        	callcmd::mancingAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, 204.8122,-1914.7838,1.1988))
        {
        	callcmd::mancingAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, 227.4286,-1918.3226,1.2014))
        {
        	callcmd::mancingAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, 223.3978,-1946.2858,1.1914))
        {
        	callcmd::mancingAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, 239.2198,-1934.7523,1.1914))
        {
        	callcmd::mancingAufa(playerid, "");
        }
	}
	//tukang kayu
	if(newkeys & KEY_WALK)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2, -1992.7512,-2387.5115,30.6250))//tukang kayu
		{
		    if(pData[playerid][pJob] == 3)
			ShowPlayerDialog(playerid, DIALOG_LOCKERTUKANGKAYU, DIALOG_STYLE_LIST, "Executive - Locker Tukang Kayu", "Baju Kerja\nBaju Warga", "Pilih", "Batal");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2, -1997.1274,-2420.9097,30.6250))
        {
        	callcmd::potongkayu1(playerid, "");
        }
		else if(IsPlayerInRangeOfPoint(playerid, 2, -2001.2432,-2416.8083,30.6250))
        {
        	callcmd::potongkayu2(playerid, "");
        }
		else if(IsPlayerInRangeOfPoint(playerid, 2, -2011.3643,-2404.0962,30.6250))
        {
        	callcmd::potongkayu3(playerid, "");
        }
		else if(IsPlayerInRangeOfPoint(playerid, 2, -2021.2697,-2402.0901,30.6250))
        {
        	callcmd::potongkayu4(playerid, "");
        }
		else if(IsPlayerInRangeOfPoint(playerid, 2, -2030.3298,-2391.3167,30.6250))
        {
        	callcmd::potongkayu5(playerid, "");
        }
		else if(IsPlayerInRangeOfPoint(playerid, 2, -1986.3417,-2425.8486,30.6250))
        {
        	callcmd::proseskayu1(playerid, "");
        }
		else if(IsPlayerInRangeOfPoint(playerid, 2, -1986.3417,-2425.8486,30.6250))
        {
        	callcmd::proseskayu2(playerid, "");
        }
	}







	if(newkeys & KEY_WALK)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2, 2318.562744,-2070.840576,17.644752))//penjahit
		{
		    if(pData[playerid][pJob] == 10)
			ShowPlayerDialog(playerid, DIALOG_LOCKERPENJAHIT, DIALOG_STYLE_LIST, "Executive - Locker Penjahit", "Baju Kerja\nBaju Warga", "Pilih", "Batal");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2, 2319.573730,-2080.727783,17.692657))
        {
        	callcmd::buatkain(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 2321.482421,-2082.888671,17.652400))
        {
        	callcmd::buatkain(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 2317.667236,-2082.262939,17.694538))
        {
        	callcmd::buatkain(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 2319.653320,-2084.508544,17.652679))
        {
        	callcmd::buatkain(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 1925.521972,170.046707,37.281250))
        {
        	callcmd::ambilwool(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 2313.817382,-2075.185546,17.644004))
        {
        	callcmd::buatbaju(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 1276.9907,-1424.0293,13.7541))
		{
            callcmd::jualpakaian(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2,1448.5902,-1134.6410,23.9580))
		{
            callcmd::newrek(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2,1456.1683,-1128.3212,23.9580))
		{
            callcmd::bank(playerid, "");
        }
	}
	if(newkeys & KEY_WALK)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 1, 1690.892456,-2237.770751,13.539621))
		{
			callcmd::atmAufa(playerid, "");
        }
		else if(IsPlayerInRangeOfPoint(playerid, 1, 1550.266601,-2176.392578,13.546875))
        {
			callcmd::atmAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, 1125.240966,-2033.215698,69.883659))
        {
			callcmd::atmAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, 1291.651489,-1874.457031,13.783984))
        {
			callcmd::atmAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, 1920.387207,-1786.922729,13.546875))
        {
			callcmd::atmAufa(playerid, "");
        }
		else if(IsPlayerInRangeOfPoint(playerid, 1, 1374.6693,-1887.5564,13.5901))
        {
			callcmd::atmAufa(playerid, "");
        }
		else if(IsPlayerInRangeOfPoint(playerid, 1, 1275.9919,-1558.3986,13.5869))
        {
			callcmd::atmAufa(playerid, "");
        }
		else if(IsPlayerInRangeOfPoint(playerid, 1, 1977.7656,-2058.9355,13.5938))
        {
			callcmd::atmAufa(playerid, "");
        }
	}
	if((newkeys & KEY_WALK))
	{
		if(GetNearbyTrash(playerid) >= 0)
		{
		    for(new i = 0; i < MAX_Trash; i++)
			{
			    if(IsPlayerInRangeOfPoint(playerid, 2.3, TrashData[i][TrashX], TrashData[i][TrashY], TrashData[i][TrashZ]))
			{
				if(pData[playerid][sampahsaya] < 1) return ErrorMsg(playerid, "Anda tidak mempunyai sampah");
				new total = pData[playerid][sampahsaya];
				pData[playerid][sampahsaya] -= total;
				new str[500];
				format(str, sizeof(str), "Removed_%dx", total);
				ShowItemBox(playerid, "Sampah", str, 1265, total);
			    Inventory_Update(playerid);
			    TrashData[i][Sampah] += total;
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE trash SET sampah='%d' WHERE ID='%d'", TrashData[i][Sampah], i);
				mysql_tquery(g_SQL, query);
				ShowProgressbar(playerid, "Membuang sampah..", 1);
				ApplyAnimation(playerid,"GRENADE","WEAPON_throwu",4.0, 1, 0, 0, 0, 0, 1);
				Trash_Save(i);
			}
		}
	}
}
	if((newkeys & KEY_WALK))
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, 1687.043090,-2265.090087,13.481613))
		{
			new str[1024];
			format(str, sizeof(str), "Jenis Sepeda & Series\tHarga Rental\n"WHITE_E"TDR-3000\t"LG_E"$75\n{ffffff}Sepeda Gunung Aviator 2690 XT Steel\t"LG_E"$150\n> Pilih ini untuk mengembalikan kendaraan yang disewa dari negara");			
			ShowPlayerDialog(playerid, DIALOG_RENT_BIKE, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Rental Sepeda", str, "Rent", "Close");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3, 2766.651367,-2395.744384,13.632812))
        {
        	new str[1024];
			format(str, sizeof(str), "Jenis Sepeda & Series\tHarga Rental\n"WHITE_E"TDR-3000\t"LG_E"$75\n{ffffff}Sepeda Gunung Aviator 2690 XT Steel\t"LG_E"$150\n> Pilih ini untuk mengembalikan kendaraan yang disewa dari negara");
			ShowPlayerDialog(playerid, DIALOG_RENT_BIKE, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Rental Sepeda", str, "Rent", "Close");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3, -613.6473,-488.6987,25.6234))
        {
        	new str[1024];
			format(str, sizeof(str), "Jenis Sepeda & Series\tHarga Rental\n"WHITE_E"TDR-3000\t"LG_E"$75\n{ffffff}Sepeda Gunung Aviator 2690 XT Steel\t"LG_E"$150\n> Pilih ini untuk mengembalikan kendaraan yang disewa dari negara");
			ShowPlayerDialog(playerid, DIALOG_RENT_BIKE, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Rental Sepeda", str, "Rent", "Close");
		}
	}
	if(newkeys & KEY_CROUCH)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 1303.972045,-1338.869506,13.722788))
		{
		    if(pData[playerid][pFaction] != 1)
        	return ErrorMsg(playerid, "Anda bukan seorang kepolisian!");
			if(IsValidVehicle(pData[playerid][pKendaraanFraksi]))
   			DestroyVehicle(pData[playerid][pKendaraanFraksi]);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 717.724060,-1418.360717,13.785820))
		{
		    if(pData[playerid][pFaction] != 3)
        	return ErrorMsg(playerid, "Anda bukan seorang tenaga medis!");
			if(IsValidVehicle(pData[playerid][pKendaraanFraksi]))
   			DestroyVehicle(pData[playerid][pKendaraanFraksi]);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1493.067138,-666.322204,94.769989))
		{
		    if(pData[playerid][pFaction] != 5)
        	return ErrorMsg(playerid, "Anda bukan seorang pedagang!");
			if(IsValidVehicle(pData[playerid][pKendaraanFraksi]))
   			DestroyVehicle(pData[playerid][pKendaraanFraksi]);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1239.4237,-2054.5679,59.9075))
		{
		    if(pData[playerid][pFaction] != 2)
        	return ErrorMsg(playerid, "Anda bukan anggota pemerintah!");
			if(IsValidVehicle(pData[playerid][pKendaraanFraksi]))
   			DestroyVehicle(pData[playerid][pKendaraanFraksi]);
		}
	}
	if((newkeys & KEY_WALK))
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, 1303.972045,-1338.869506,13.722788))
		{
		    if(pData[playerid][pFaction] != 1)
        	return ErrorMsg(playerid, "Anda bukan seorang kepolisian!");
			new str[1024];
			format(str, sizeof(str), "Nama Kendaraan\nBullet\nSultan\nKendaraan Patroli\nSanchez\nMotor Patroli");
			ShowPlayerDialog(playerid, DIALOG_GARASIPD, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Garasi Kepolisian", str, "Pilih", "Close");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 717.724060,-1418.360717,13.785820))
		{
		    if(pData[playerid][pFaction] != 3)
        	return ErrorMsg(playerid, "Anda bukan seorang tenaga medis!");
			new str[1024];
			format(str, sizeof(str), "Nama Kendaraan\nAmbulance\nSanchez");
			ShowPlayerDialog(playerid, DIALOG_GARASIMD, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Garasi Tenaga Medis", str, "Pilih", "Close");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1493.067138,-666.322204,94.769989))
		{
		    if(pData[playerid][pFaction] != 5)
        	return ErrorMsg(playerid, "Anda bukan seorang pedagang!");
			new str[1024];
			format(str, sizeof(str), "Nama Kendaraan\nMobil Pedagang\nPizza Boy");
			ShowPlayerDialog(playerid, DIALOG_GARASIPEDAGANG, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Garasi Pedagang", str, "Pilih", "Close");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1239.4237,-2054.5679,59.9075))
		{
		    if(pData[playerid][pFaction] != 2)
        	return ErrorMsg(playerid, "Anda bukan anggota pemerintah!");
			new str[1024];
			format(str, sizeof(str), "Nama Kendaraan\nMobil Pemerintah\nSentinel\nFCR");
			ShowPlayerDialog(playerid, DIALOG_GARASISAGS, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Garasi Pemerintah", str, "Pilih", "Close");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1375.9167,-1767.8365,13.5781))
		{
		    if(pData[playerid][pFaction] != 6)
        	return ErrorMsg(playerid, "Anda bukan anggota gojek!");
			new str[1024];
			format(str, sizeof(str), "Nama Kendaraan\nMotor Gojek\nMobil Gojek\nMotor makanan gojek");
			ShowPlayerDialog(playerid, DIALOG_GARASIGOJEK, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Garasi Gojek", str, "Pilih", "Close");
		}
		/*else if(IsPlayerInRangeOfPoint(playerid, 3, 2766.651367,-2395.744384,13.632812))
        {
        	new str[1024];
			format(str, sizeof(str), "Ambil Barang\nSimpan Barang");
			ShowPlayerDialog(playerid, DIALOG_GUDANGBARU, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Gudang Kota", str, "Pilih", "Close");
		}*/
	}
	if(newkeys & KEY_WALK)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2, 874.795104,-13.976298,63.195312))//Olah kanabis
		{
  			callcmd::olahkanabis(playerid, "");
		}
	    else if(IsPlayerInRangeOfPoint(playerid, 2, 1775.1582,-167.0989,77.5520))//ambilkanabis
        {
        	callcmd::ambilkanabis(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 1770.9899,-166.8354,78.0667))//ambilkanabis
        {
        	callcmd::ambilkanabis(playerid, "");
        }
       	else if(IsPlayerInRangeOfPoint(playerid, 2, 1767.3459,-170.8528,78.9311))//ambilkanabis
        {
        	callcmd::ambilkanabis(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 1769.2379,-174.3668,79.8527))//ambilkanabis
        {
        	callcmd::ambilkanabis(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 1765.0322,-175.5911,79.8391))//ambilkanabis
        {
        	callcmd::ambilkanabis(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 1755.6796,-180.9095,79.8963))//ambilkanabis
        {
        	callcmd::ambilkanabis(playerid, "");
        }
	}
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 1447.600830,-23.859462,-55.601955))
		{
		    if(pData[playerid][pIDCard] == 0) return ErrorMsg(playerid, "Anda tidak memiliki ID Card!");
			PlayerPlaySound(playerid, 5202, 0,0,0);
			new string[1000];
		    format(string, sizeof(string), "Pekerjaan\t\tSedang Bekerja\n{ffffff}Supir Bus\t\t{FFFF00}%d Orang\n{BABABA}Tukang Ayam\t\t{FFFF00}%d Orang\n{ffffff}Penebang Kayu\t\t{FFFF00}%d Orang\n{BABABA}Petani\t\t{FFFF00}%d Orang\n{ffffff}Penambang Minyak\t\t{FFFF00}%d Orang\n{BABABA}Pemerah Susu\t\t{FFFF00}%d Orang\n{ffffff}Penambang\t\t{FFFF00}%d Orang\n{BABABA}Kargo\t\t{FFFF00}%d Orang\n{ffffff}Penjahit\t\t{FFFF00}%d Orang\n"RED_E"Keluar dari pekerjaan",
			Sopirbus,
			tukangayam,
			tukangtebang,
			petani,
			penambangminyak,
		 	pemerah,
		 	penambang,
		 	Trucker,
			penjahit
		    );
	    	ShowPlayerDialog(playerid, DIALOG_DISNAKER, DIALOG_STYLE_TABLIST_HEADERS, "{7fffd4}Dinas Tenaga Kerja Executive", string, "Pilih", "Batal");
		}
	}
	//-----[ Toll System ]-----	
	if(newkeys & KEY_CROUCH)
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
		{
			new forcount = MuchNumber(sizeof(BarrierInfo));
			for(new i;i < forcount;i ++)
			{
				if(i < sizeof(BarrierInfo))
				{
					if(IsPlayerInRangeOfPoint(playerid,8,BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]))
					{
						if(BarrierInfo[i][brOrg] == TEAM_NONE)
						{
							if(!BarrierInfo[i][brOpen])
							{
								if(pData[playerid][pMoney] < 5)
								{
									ErrorMsg(playerid, "Uangmu tidak cukup untuk membayar toll");
								}
								else
								{
									MoveDynamicObject(gBarrier[i],BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.7,BARRIER_SPEED,0.0,0.0,BarrierInfo[i][brPos_A]+180);
									SetTimerEx("BarrierClose",5000,0,"i",i);
									BarrierInfo[i][brOpen] = true;
									GivePlayerMoneyEx(playerid, -5);
									ShowItemBox(playerid, "Uang", "Removed_$5", 1212, 2);
									if(BarrierInfo[i][brForBarrierID] != -1)
									{
										new barrierid = BarrierInfo[i][brForBarrierID];
										MoveDynamicObject(gBarrier[barrierid],BarrierInfo[barrierid][brPos_X],BarrierInfo[barrierid][brPos_Y],BarrierInfo[barrierid][brPos_Z]+0.7,BARRIER_SPEED,0.0,0.0,BarrierInfo[barrierid][brPos_A]+180);
										BarrierInfo[barrierid][brOpen] = true;

									}
								}
							}
						}
						else Toll(playerid, "Anda tidak bisa membuka pintu Toll ini!");
						break;
					}
				}
			}
		}
		return true;		
	}
	if(GetPVarInt(playerid, "UsingSprunk"))
	{
		if(pData[playerid][pEnergy] >= 100 )
		{
  			Info(playerid, " Anda terlalu banyak minum.");
	   	}
	   	else
	   	{
		    pData[playerid][pEnergy] += 5;
		}
	}
	if(takingselfie[playerid] == 1)
	{
		if(PRESSED(KEY_ANALOG_RIGHT))
		{
			GetPlayerPos(playerid,lX[playerid],lY[playerid],lZ[playerid]);
			static Float: n1X, Float: n1Y;
		    if(Degree[playerid] >= 360) Degree[playerid] = 0;
		    Degree[playerid] += Speed;
		    n1X = lX[playerid] + Radius * floatcos(Degree[playerid], degrees);
		    n1Y = lY[playerid] + Radius * floatsin(Degree[playerid], degrees);
		    SetPlayerCameraPos(playerid, n1X, n1Y, lZ[playerid] + Height);
		    SetPlayerCameraLookAt(playerid, lX[playerid], lY[playerid], lZ[playerid]+1);
		    SetPlayerFacingAngle(playerid, Degree[playerid] - 90.0);
		}
		if(PRESSED(KEY_ANALOG_LEFT))
		{
		    GetPlayerPos(playerid,lX[playerid],lY[playerid],lZ[playerid]);
			static Float: n1X, Float: n1Y;
		    if(Degree[playerid] >= 360) Degree[playerid] = 0;
		    Degree[playerid] -= Speed;
		    n1X = lX[playerid] + Radius * floatcos(Degree[playerid], degrees);
		    n1Y = lY[playerid] + Radius * floatsin(Degree[playerid], degrees);
		    SetPlayerCameraPos(playerid, n1X, n1Y, lZ[playerid] + Height);
		    SetPlayerCameraLookAt(playerid, lX[playerid], lY[playerid], lZ[playerid]+1);
		    SetPlayerFacingAngle(playerid, Degree[playerid] - 90.0);
		}
	}

    if(PRESSED( KEY_WALK ) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
    	foreach(new pid : Pedagang)
		{
    		if(IsPlayerInRangeOfPoint(playerid, 4.0, pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ]))
			{
				if(pData[playerid][pFaction] != 5)
    				return Error(playerid, "You must be part of a Pedagang faction.");
				ShowPedagangMenu(playerid, pid);
			}
		}
    }
   /* if(PRESSED( KEY_WALK ))
    {
    		if(IsPlayerInRangeOfPoint(playerid, 2.0, 2506.981933,-2637.118896,13.646511))
			{
			    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
				PlayerPlaySound(playerid, 5202, 0,0,0);
				new string[10000];
			    format(string, sizeof(string), "Barang\t\tHarga\nAyam Fillet\t\t"LG_E"$40/{ffffff}1 Paket\nSusu Olahan\t\t"LG_E"$30/{ffffff}1 Botol\nEssence\t\t"LG_E"$25/{ffffff}1 Kotak\nEmas\t\t"LG_E"$45/{ffffff}1 emas\nBeras\t\t"LG_E"$14/{ffffff}1 Paket\nSambal\t\t"LG_E"$8/{ffffff}1 Paket\nTepung\t\t"LG_E"$10/{ffffff}1 Paket\nGula\t\t"LG_E"$12/{ffffff}1 Paket\nPenyu\t\t"LG_E"$9/{ffffff}1 Penyu\nIkan Marakel\t\t"LG_E"$3/{ffffff}1 Ikan\nIkan Nemo\t\t"LG_E"$5/{ffffff}1 Ikan\nBlue Fish\t\t"LG_E"$6/{ffffff}1 Ikan\nBesi\t\t"LG_E"$16/{ffffff}1 Besi\nAluminium\t\t"LG_E"$22/{ffffff}1 Tembaga\nPapan\t\t"LG_E"$80/{ffffff}1 Papan");
		    	ShowPlayerDialog(playerid, DIALOG_HOLIMARKET, DIALOG_STYLE_TABLIST_HEADERS, "Executive Market - Penjualan", string, "Jual", "Batal");
			}
    	}*/

	// SELL FISH AUFA
    if(PRESSED( KEY_WALK ))
    {
    		if(IsPlayerInRangeOfPoint(playerid, 2.0, 2798.4680,-1578.8145,10.9858))
			{
			    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
				PlayerPlaySound(playerid, 5202, 0,0,0);
				new string[10000];
			    format(string, sizeof(string), "Mancing Ikan\t\tHarga\nPenyu\t\t"LG_E"$9/{ffffff}1 Penyu\nIkan Marakel\t\t"LG_E"$3/{ffffff}1 Ikan\nIkan Nemo\t\t"LG_E"$5/{ffffff}1 Ikan\nBlue Fish\t\t"LG_E"$6/{ffffff}1 Ikan");
		    	ShowPlayerDialog(playerid, DIALOG_JUALIKAN, DIALOG_STYLE_TABLIST_HEADERS, "Executive Market - Jual Ikan", string, "Jual", "Batal");
			}
    	}
	//sell hasil tambang & minyak Aufa
	if(PRESSED( KEY_WALK ))
    {
    		if(IsPlayerInRangeOfPoint(playerid, 2.0, 2798.1953,-1571.1901,11.0391))
			{
			    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
				PlayerPlaySound(playerid, 5202, 0,0,0);
				new string[10000];
			    format(string, sizeof(string), "nambang\t\tHarga\nEssence\t\t"LG_E"$50/{ffffff}1 Kotak\nEmas\t\t"LG_E"$50/{ffffff}1 emas\nBesi\t\t"LG_E"$40/{ffffff}1 Besi\nAluminium\t\t"LG_E"$45/{ffffff}1 Tembaga");
		    	ShowPlayerDialog(playerid, DIALOG_TAMBANG, DIALOG_STYLE_TABLIST_HEADERS, "Executive Market -Hasil Nambang", string, "Jual", "Batal");
			}
    	}
	//sell hasil petani & peternak ayam
	if(PRESSED( KEY_WALK ))
    {
    		if(IsPlayerInRangeOfPoint(playerid, 2.0, 2799.2314,-1556.5638,11.0114))
			{
			    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
				PlayerPlaySound(playerid, 5202, 0,0,0);
				new string[10000];
			    format(string, sizeof(string), "Petani/Peternak\t\tHarga\nAyam Fillet\t\t"LG_E"$45/{ffffff}1 Paket\nSusu Olahan\t\t"LG_E"$30/{ffffff}1 botol\nBeras\t\t"LG_E"$14/{ffffff}1 Paket\nSambal\t\t"LG_E"$8/{ffffff}1 Paket\nTepung\t\t"LG_E"$10/{ffffff}1 Paket\nGula");
		    	ShowPlayerDialog(playerid, DIALOG_JUALPETANI, DIALOG_STYLE_TABLIST_HEADERS, "Executive Market - Peternak & Petani", string, "Jual", "Batal");
			}
    	}

	//hasil tukang kayu
	if(PRESSED( KEY_WALK ))
    {
    		if(IsPlayerInRangeOfPoint(playerid, 2.0, 2799.0505,-1544.9191,11.0521))
			{
			    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
				PlayerPlaySound(playerid, 5202, 0,0,0);
				new string[10000];
			    format(string, sizeof(string), "Kayu\t\tHarga\nPapan\t\t"LG_E"$60/{ffffff}1 Papan");
		    	ShowPlayerDialog(playerid, DIALOG_JUALKAYU, DIALOG_STYLE_TABLIST_HEADERS, "Executive Market - Tukang Kayu", string, "Jual", "Batal");
			}
    	}


   if(PRESSED(KEY_WALK) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
        if(IsPlayerInRangeOfPoint(playerid, 3, 1318.067016,-861.774475,39.726036))
        {
        	return callcmd::menumasak(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 1316.866088,-872.307128,39.626033))
        {
        	return callcmd::menu(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 1311.526611,-865.060852,39.726036))
        {
        	return callcmd::menuminum(playerid, "");
        }
	}
    if(PRESSED(KEY_WALK) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
        if(IsPlayerInRangeOfPoint(playerid, 2, -1428.316528,-950.212158,201.093750))
        {
        	return callcmd::ambilayam(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -2075.82, -2440.67, 30.6839))
        {
        	return callcmd::potongayamAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -999.998291,-683.041320,32.007812))
        {
        	return callcmd::kargoaufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -1422.421142,-967.581909,200.775970))
        {
            return callcmd::izinayam(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -2074.63, -2439.26, 30.6739))
        {
        	return callcmd::potongayamAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -2076.86, -2441.9, 30.6839))
        {
        	return callcmd::potongayamAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -2058.77, -2437.32, 30.6939))
        {
        	return callcmd::packingayamAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -2060.71, -2439.79, 30.6939))
        {
        	return callcmd::packingayamAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, 2395.137695,-1495.538696,23.834865))
        {
        	return callcmd::jualayam(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 5, 1458.828491,-674.108825,94.979980))
        {
        	return callcmd::menumasak(playerid, "");
        }
    }
    if(PRESSED(KEY_WALK) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
        if(IsPlayerInRangeOfPoint(playerid, 2, ORusa1))
        {
        	return callcmd::ambilrusa(playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, ORusa2))
        {
        	return callcmd::ambilrusa(playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, ORusa2))
        {
        	return callcmd::ambilrusa(playerid);
        }
    }
    if(PRESSED(KEY_WALK) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
        if(IsPlayerInRangeOfPoint(playerid, 2, -1060.852172,-1195.437011,129.664138))
        {
        	return callcmd::belibibitAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -1141.685791,-1095.497192,129.218750))
        {
        	return callcmd::plantAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -1129.279663,-1095.668579,129.218750))
        {
        	return callcmd::plantAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -1125.371826,-1084.356811,129.218750))
        {
        	return callcmd::plantAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -1138.143554,-1084.205688,129.218750))
        {
        	return callcmd::plantAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 2, -1431.233398,-1460.474975,101.693000))
        {
        	return callcmd::prosesAufa(playerid, "");
        }
    }
    if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3, 1244.857910,-2020.113891,59.894012))
		{
            if(pData[playerid][pJob] != 1) return 1;
		    if(pData[playerid][pBusTime] > 0)
		    	return	ErrorMsg(playerid, "Anda harus menunggu.");
		    	
	    	pData[playerid][pKendaraanKerja] = CreateVehicle(431, 1244.857910,-2020.113891,59.894012,180.118698,0,0,120000,0);
			PutPlayerInVehicle(playerid, pData[playerid][pKendaraanKerja], 0);
	    	SetVehicleNumberPlate(pData[playerid][pKendaraanKerja], "JOB VEHICLE");
	    	new tmpobjid;
	    	tmpobjid = CreateDynamicObject(7313,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10837, "airroadsigns_sfse", "ws_airbigsign1", 0);
		    SetDynamicObjectMaterial(tmpobjid, 1, 16646, "a51_alpha", "des_rails1", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "PELABUHAN - BANDARA", 80, "Arial", 30, 0, 0xFF555999, 0xFF000000, 1);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.274, 0.464, -0.120, 0.000, 0.000, 89.899);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.330, -2.455, 0.490, 0.000, 0.000, 90.099);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.349, -4.018, 0.490, 0.000, 0.000, 90.999);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "u", 90, "Webdings", 100, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.411, -3.781, 0.550, 0.000, 0.000, 90.799);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Executive Transit", 90, "Times New Roman", 45, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.427, -3.071, 0.480, 0.000, 0.000, 91.600);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "BUS", 90, "Times New Roman", 65, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.342, -2.997, 0.210, 0.000, 0.000, 91.299);
		    tmpobjid = CreateDynamicObject(7313,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10837, "airroadsigns_sfse", "ws_airbigsign1", 0);
		    SetDynamicObjectMaterial(tmpobjid, 1, 16646, "a51_alpha", "des_rails1", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "PELABUHAN - BANDARA", 80, "Arial", 30, 0, 0xFF555999, 0xFF000000, 1);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.322, 0.442, -0.090, 0.000, 0.000, -90.900);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.345, -1.662, 0.490, 0.000, 0.000, -90.000);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.342, -3.243, 0.490, 0.000, 0.000, -90.299);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "u", 90, "Webdings", 100, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.400, -4.109, 0.550, 0.000, 0.000, -91.899);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Executive Transit", 90, "Times New Roman", 48, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.448, -2.595, 0.440, 0.000, 0.000, -84.799);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "BUS", 90, "Times New Roman", 65, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.397, -3.351, 0.150, 0.000, 0.000, -89.399);
			pData[playerid][pBusTime] = 360;
			pData[playerid][pBus] = 1;
			SetPlayerRaceCheckpoint(playerid, 2, buspoint1, buspoint1, 4.0);
			pData[playerid][pCheckPoint] = CHECKPOINT_BUS;
			InfoMsg(playerid, "Ikuti Checkpoint!");
			SwitchVehicleEngine(pData[playerid][pKendaraanKerja], true);
		}
	}
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3, -609.8121,-507.1617,25.7228))
		{
            if(pData[playerid][pJob] != 1) return 1;
		    if(pData[playerid][pBusTime] > 0)
		    	return	ErrorMsg(playerid, "Anda harus menunggu.");

	    	pData[playerid][pKendaraanKerja] = CreateVehicle(431, -609.8121,-507.1617,25.7228,272.3994,0,0,120000,0);
			PutPlayerInVehicle(playerid, pData[playerid][pKendaraanKerja], 0);
	    	SetVehicleNumberPlate(pData[playerid][pKendaraanKerja], "JOB VEHICLE");
	    	SwitchVehicleEngine(pData[playerid][pKendaraanKerja], true);
	    	pData[playerid][pBusRute] = 2;
	    	new tmpobjid;
	    	tmpobjid = CreateDynamicObject(7313,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10837, "airroadsigns_sfse", "ws_airbigsign1", 0);
		    SetDynamicObjectMaterial(tmpobjid, 1, 16646, "a51_alpha", "des_rails1", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Terminal Bus", 80, "Arial", 30, 0, 0xFF555999, 0xFF000000, 1);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.274, 0.464, -0.120, 0.000, 0.000, 89.899);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.330, -2.455, 0.490, 0.000, 0.000, 90.099);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.349, -4.018, 0.490, 0.000, 0.000, 90.999);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "u", 90, "Webdings", 100, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.411, -3.781, 0.550, 0.000, 0.000, 90.799);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Executive Transit", 90, "Times New Roman", 45, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.427, -3.071, 0.480, 0.000, 0.000, 91.600);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "BUS", 90, "Times New Roman", 65, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], 1.342, -2.997, 0.210, 0.000, 0.000, 91.299);
		    tmpobjid = CreateDynamicObject(7313,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10837, "airroadsigns_sfse", "ws_airbigsign1", 0);
		    SetDynamicObjectMaterial(tmpobjid, 1, 16646, "a51_alpha", "des_rails1", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Terminal Bus", 80, "Arial", 30, 0, 0xFF555999, 0xFF000000, 1);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.322, 0.442, -0.090, 0.000, 0.000, -90.900);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.345, -1.662, 0.490, 0.000, 0.000, -90.000);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.342, -3.243, 0.490, 0.000, 0.000, -90.299);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "u", 90, "Webdings", 100, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.400, -4.109, 0.550, 0.000, 0.000, -91.899);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "Executive Transit", 90, "Times New Roman", 48, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.448, -2.595, 0.440, 0.000, 0.000, -84.799);
		    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
		    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
		    SetDynamicObjectMaterialText(tmpobjid, 0, "BUS", 90, "Times New Roman", 65, 0, -16777216, 0, 0);
		    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanKerja], -1.397, -3.351, 0.150, 0.000, 0.000, -89.399);
			pData[playerid][pBusTime] = 360;
			pData[playerid][pBus] = 66;
			SetPlayerRaceCheckpoint(playerid, 2, cpbus1, cpbus1, 4.0);
			pData[playerid][pCheckPoint] = CHECKPOINT_BUS;
			InfoMsg(playerid, "Ikuti Checkpoint!");
		}
	}
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.0, 737.314941,-1431.849365,13.825812))
		{
            if(pData[playerid][pMoney] < 750)
				return ErrorMsg(playerid, "Anda tidak memiliki uang sebanyak $750!");

			pData[playerid][pObatStress] += 1;
			GivePlayerMoneyEx(playerid, -750);
			ShowItemBox(playerid, "Obat_Stress", "Received_1x", 1241, 4);
			ShowItemBox(playerid, "Uang", "Removed_$750", 1212, 4);
		}
	}
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.0, 739.011047,-1431.948242,13.825812))
		{
            if(pData[playerid][pMoney] < 500)
				return ErrorMsg(playerid, "Anda tidak memiliki uang sebanyak $500!");

			pData[playerid][pPerban] += 1;
			GivePlayerMoneyEx(playerid, -500);
			ShowItemBox(playerid, "Perban", "Received_1x", 11736, 4);
			ShowItemBox(playerid, "Uang", "Removed_$500", 1212, 4);
		}
	}
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 1738.4631,-2524.5730,13.5969))
		{
            if(pData[playerid][pStarterpack] != 0)
				return ErrorMsg(playerid, "Kamu sudah mengambil Sebelumnya!");

			pData[playerid][pStarterpack] = 1;
			pData[playerid][pPhone] = 1;
			ShowItemBox(playerid, "Ponsel", "Received_1x", 18871, 4);
			pData[playerid][pSnack] += 10;
			pData[playerid][pSprunk] += 10;
			GivePlayerMoneyEx(playerid, 500);
			SuccesMsg(playerid, "Anda Diberi Kompensasi 10 Snack, 10 Water Dan $500");
			ShowItemBox(playerid, "Snack", "Received_10x", 2821, 4);
			ShowItemBox(playerid, "Water", "Received_10x", 2958, 4);
			ShowItemBox(playerid, "Uang", "Received_$500", 1212, 4);
		}
	}
	//terminal
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.5, -607.7561,-488.6573,25.6234))
		{
            if(pData[playerid][pStarterpack] != 0)
				return ErrorMsg(playerid, "Kamu sudah mengambil Sebelumnya!");

			pData[playerid][pStarterpack] = 1;
			pData[playerid][pPhone] = 1;
			ShowItemBox(playerid, "Ponsel", "Received_1x", 18871, 4);
			pData[playerid][pSnack] += 10;
			pData[playerid][pSprunk] += 10;
			GivePlayerMoneyEx(playerid, 500);
			SuccesMsg(playerid, "Anda Diberi Kompensasi 10 Snack, 10 Water Dan $500");
			ShowItemBox(playerid, "Snack", "Received_10x", 2821, 4);
			ShowItemBox(playerid, "Water", "Received_10x", 2958, 4);
			ShowItemBox(playerid, "Uang", "Received_$500", 1212, 4);
		}
	}
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 2772.931640,-2429.260742,13.637291))
		{
            if(pData[playerid][pStarterpack] != 0)
				return ErrorMsg(playerid, "Kamu sudah mengambil Sebelumnya!");

			pData[playerid][pStarterpack] = 1;
			pData[playerid][pSnack] += 10;
			pData[playerid][pPhone] = 1;
			ShowItemBox(playerid, "Ponsel", "Received_1x", 18871, 4);
			pData[playerid][pSprunk] += 10;
			GivePlayerMoneyEx(playerid, 500);
			SuccesMsg(playerid, "Anda Diberi Kompensasi 10 Snack, 10 Water Dan $500");
			ShowItemBox(playerid, "Snack", "Received_10x", 2821, 4);
			ShowItemBox(playerid, "Water", "Received_10x", 2958, 4);
			ShowItemBox(playerid, "Uang", "Received_$500", 1212, 4);
		}
	}
	if(newkeys & KEY_WALK)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3, -1066.2753,-2322.0605,55.8431))
		{
		   callcmd::creategun(playerid, "");
		}
	}
	if(newkeys & KEY_WALK)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3, -1069.9493,-2322.5383,55.7935))
		{
		   callcmd::lockpick(playerid, "");
		}
	}
	
	if(newkeys & KEY_WALK)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3, 830.3033,-2066.9246,13.2240))
		{
		   callcmd::pernikahan(playerid, "");
		}
	}


	if(newkeys & KEY_WALK)
	{
		if(IsPlayerInRangeOfPoint(playerid, 1, -396.575592,1249.352050,6.749223))
        {
            if(pData[playerid][pTimeTambang1] > 0) return 1;
        	callcmd::nambangAufa1(playerid, "");
        	pData[playerid][pTimeTambang1] = 1;
        	SetTimerEx("TungguNambang1", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, -393.591278,1249.288940,6.789647))
        {
        	if(pData[playerid][pTimeTambang2] > 0) return 1;
        	callcmd::nambangAufa1(playerid, "");
        	pData[playerid][pTimeTambang2] = 1;
        	SetTimerEx("TungguNambang2", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, -393.588256,1253.867553,6.928194))
        {
        	if(pData[playerid][pTimeTambang3] > 0) return 1;
        	callcmd::nambangAufa1(playerid, "");
        	pData[playerid][pTimeTambang3] = 1;
        	SetTimerEx("TungguNambang3", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, -396.943634,1254.083374,6.890728))
        {
        	if(pData[playerid][pTimeTambang4] > 0) return 1;
        	callcmd::nambangAufa1(playerid, "");
        	pData[playerid][pTimeTambang4] = 1;
        	SetTimerEx("TungguNambang4", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, -393.617950,1259.353393,7.093970))
        {
        	if(pData[playerid][pTimeTambang5] > 0) return 1;
        	callcmd::nambangAufa1(playerid, "");
        	pData[playerid][pTimeTambang5] = 1;
        	SetTimerEx("TungguNambang5", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 1, -396.967498,1260.187988,7.082924))
        {
        	if(pData[playerid][pTimeTambang6] > 0) return 1;
        	callcmd::nambangAufa1(playerid, "");
        	pData[playerid][pTimeTambang6] = 1;
        	SetTimerEx("TungguNambang6", 50000, false, "d", playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, -795.673522,-1928.231567,5.612922))
        {
        	callcmd::cucibatuAufa(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3, 2152.539062,-2263.646972,13.300081))
        {
        	callcmd::peleburanbatuAufa(playerid, "");
        }
	}
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3, 300.121429,1141.311645,9.137485))
		{
		    if(pData[playerid][pJob] == 5)
			ShowPlayerDialog(playerid, DIALOG_LOCKERPEMERAH, DIALOG_STYLE_LIST, "Executive {ffffff}- Locker Pemerah", "Baju Kerja\nBaju Warga", "Pilih", "Kembali");
		}
	}
	//penambang batu bara
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3, 110.3333,1105.5592,13.6094))
		{
		    if(pData[playerid][pJob] == 6)
			ShowPlayerDialog(playerid, DIALOG_LOCKERPENAMBANG, DIALOG_STYLE_LIST, "Executive {ffffff}- Locker Penambang batu", "Baju Kerja\nBaju Warga", "Pilih", "Kembali");
		}
	}

	//nambang minyak
	if((newkeys & KEY_WALK))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3, 117.4530,1108.9342,13.6094))
		{
		    if(pData[playerid][pJob] == 4)
			ShowPlayerDialog(playerid, DIALOG_LOCKERMINYAK, DIALOG_STYLE_LIST, "Executive {ffffff}- Locker Penambang Minyak", "Baju Kerja\nBaju Warga", "Pilih", "Kembali");
		}
	}

	if(PRESSED( KEY_CTRL_BACK ))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || pData[playerid][pInjured] == 1 || pData[playerid][pCuffed] == 1) return Error(playerid, "You can't do at this moment.");
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pCuffed] == 0)
		{
			if(pData[playerid][pLoopAnim])
	    	{	
	        	pData[playerid][pLoopAnim] = 0;

				ClearAnimations(playerid);
				StopLoopingAnim(playerid);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				TogglePlayerControllable(playerid, 1);
		    	TextDrawHideForPlayer(playerid, AnimationTD);
			}
		}
    }
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_WASTED && pData[playerid][pJail] < 1)
    {	
		if(pData[playerid][pInjured] == 0)
        {
            pData[playerid][pInjured] = 1;
            SetPlayerHealthEx(playerid, 99999);

            pData[playerid][pInt] = GetPlayerInterior(playerid);
            pData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);

            GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
            GetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
        }
        else
        {
            pData[playerid][pHospital] = 1;
        }
	}
	//Spec Player
	new vehicleid = GetPlayerVehicleID(playerid);
	if(newstate == PLAYER_STATE_ONFOOT)
	{
		if(pData[playerid][playerSpectated] != 0)
		{
			foreach(new ii : Player)
			{
				if(pData[ii][pSpec] == playerid)
				{
					PlayerSpectatePlayer(ii, playerid);
					Servers(ii, ,"%s(%i) is now on foot.", pData[playerid][pName], playerid);
				}
			}
		}
		PlayerTextDrawHide(playerid, TD_KMH[playerid]);
		PlayerTextDrawHide(playerid, TD_Fuel[playerid]);
	}
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
		if(pData[playerid][pInjured] == 1)
        {
            //RemoveFromVehicle(playerid);
			RemovePlayerFromVehicle(playerid);
            SetPlayerHealthEx(playerid, 99999);
        }
		foreach (new ii : Player) if(pData[ii][pSpec] == playerid) 
		{
            PlayerSpectateVehicle(ii, GetPlayerVehicleID(playerid));
        }
	}
	if(oldstate == PLAYER_STATE_DRIVER)
    {	
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED)
            return RemovePlayerFromVehicle(playerid);/*RemoveFromVehicle(playerid);*/
		
			
		if(pData[playerid][pIsStealing] == 1)
		{
			pData[playerid][pIsStealing] = 0;
			pData[playerid][pLastChopTime] = 0;
			Info(playerid, "Anda gagal mencuri kendaraan ini, di karenakan Anda keluar kendaraan saat proses pencurian!");
			KillTimer(MalingKendaraan);

		}
        
		HidePlayerProgressBar(playerid, pData[playerid][spfuelbar]);
        HidePlayerProgressBar(playerid, pData[playerid][spdamagebar]);
	}
	else if(newstate == PLAYER_STATE_DRIVER)
    {
		foreach(new pv : PVehicles)
		{
			if(vehicleid == pvData[pv][cVeh])
			{
				if(IsABike(vehicleid) || GetVehicleModel(vehicleid) == 424)
				{
					if(pvData[pv][cLocked] == 1)
					{
						RemovePlayerFromVehicle(playerid);
						//new Float:slx, Float:sly, Float:slz;
						//GetPlayerPos(playerid, slx, sly, slz);
						//SetPlayerPos(playerid, slx, sly, slz);
						ShowInfo(playerid, "Kendaraan ini Dikunci", BOXCOLOR_RED);
						return 1;
					}
				}
			}
		}
		if(IsSAPDCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 1)
			{
			    RemovePlayerFromVehicle(playerid);
			    ErrorMsg(playerid, "Anda bukan SAPD!");
			}
		}
		if(IsGovCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 2)
			{
			    RemovePlayerFromVehicle(playerid);
			    ErrorMsg(playerid, "Anda bukan SAGS!");
			}
		}
		if(IsSAMDCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 3)
			{
			    RemovePlayerFromVehicle(playerid);
			    ErrorMsg(playerid, "Anda bukan SAMD!");
			}
		}
		if(IsSANACar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 4)
			{
			    RemovePlayerFromVehicle(playerid);
			    ErrorMsg(playerid, "Anda bukan SANEWS!");
			}
		}
		if(!IsEngineVehicle(vehicleid))
        {
            SwitchVehicleEngine(vehicleid, true);
        }
		if(IsEngineVehicle(vehicleid) && pData[playerid][pDriveLic] <= 0)
        {
            WarningMsg(playerid, "Anda tidak memiliki sim.");
        }
		new Float:health;
        GetVehicleHealth(GetPlayerVehicleID(playerid), health);
        VehicleHealthSecurityData[GetPlayerVehicleID(playerid)] = health;
        VehicleHealthSecurity[GetPlayerVehicleID(playerid)] = true;
		
		if(pData[playerid][playerSpectated] != 0)
  		{
			foreach(new ii : Player)
			{
    			if(pData[ii][pSpec] == playerid)
			    {
        			PlayerSpectateVehicle(ii, vehicleid);
				    Servers(ii, "%s(%i) is now driving a %s(%d).", pData[playerid][pName], playerid, GetVehicleModelName(GetVehicleModel(vehicleid)), vehicleid);
				}
			}
		}
		SetPVarInt(playerid, "LastVehicleID", vehicleid);
	}
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if(Deer[playerid] == 1) {
        if(weaponid == 33) {
            if(hittype == BULLET_HIT_TYPE_OBJECT) {
                if(IsPlayerInRangeOfPoint(playerid, 100.0, 2046.76978, -799.45319, 127.07957) && Shoot_Deer[playerid] == 0) {
                    KillTimer(Meeters_BTWDeer[playerid]);
                    Meeter_Kill[playerid] = Meeters[playerid];
                    Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);

                    if(Meeter_Kill[playerid] >= 5) {
                        Shoot_Deer[playerid] = 1;
                        new mesaj[256];
                        MoveObject(Hunter_Deer[playerid], 2046.7698, -799.4532, 126.7188, 3.5, -90.0000, 0.0000, 0.0000);
                        format(mesaj, sizeof(mesaj), "{1e90ff}(JOB): {FFFFFF}You killed a deer from a distance {1e90ff}%d{FFFFFF}Go and peel the skin off it by pressing F. ", Meeter_Kill[playerid]);
                        SendClientMessage(playerid, -1, mesaj);
                        Deep_Deer[playerid] = 1;
                    }else {
                        new mesaj[256];
                        DestroyObject(Hunter_Deer[playerid]);
                        format(mesaj, sizeof(mesaj), "{1e90ff}(JOB): {FFFFFF}Because you fired from a distance {1e90ff}%d{FFFFFF}the deer got scared and ran away. ", Meeter_Kill[playerid]);
                        SendClientMessage(playerid, -1, mesaj);
                        DisablePlayerCheckpoint(playerid);
                        SetTimerEx("Next_Deer", 1000, false, "i", playerid);
                    }
                }
            }
        }
    }else if(Deer[playerid] == 2) {
        if(weaponid == 33) {
            if(hittype == BULLET_HIT_TYPE_OBJECT) {
                if(IsPlayerInRangeOfPoint(playerid, 100.0, 2021.1818, -494.0207, 76.1904) && Shoot_Deer[playerid] == 0) {
                    KillTimer(Meeters_BTWDeer[playerid]);
                    Meeter_Kill[playerid] = Meeters[playerid];
                    Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);

                    if(Meeter_Kill[playerid] >= 5) {
                        Shoot_Deer[playerid] = 1;
                        new mesaj[256];
                        MoveObject(Hunter_Deer[playerid], 2021.18176, -494.02069, 76.19040, 3.5, -90.0000, 0.0000, 0.0000);
                        format(mesaj, sizeof(mesaj), "{1e90ff}(JOB): {FFFFFF}You killed a deer from a distance {1e90ff}%d{FFFFFF}m. Du-te si jupoaiei pielea de pe ea apasat CTRL. ", Meeter_Kill[playerid]);
                        SendClientMessage(playerid, -1, mesaj);
                        Deep_Deer[playerid] = 1;
                    }else {
                        new mesaj[256];
                        DestroyObject(Hunter_Deer[playerid]);
                        format(mesaj, sizeof(mesaj), "{1e90ff}(JOB): {FFFFFF}Because you fired from a distance {1e90ff}%d{FFFFFF}the deer got scared and ran away. ", Meeter_Kill[playerid]);
                        SendClientMessage(playerid, -1, mesaj);
                        DisablePlayerCheckpoint(playerid);
                        SetTimerEx("Next_Deer", 1000, false, "i", playerid);
                    }
                }
            }
        }
    }else if(Deer[playerid] == 3) {
        if(weaponid == 33) {
            if(hittype == BULLET_HIT_TYPE_OBJECT) {
                if(IsPlayerInRangeOfPoint(playerid, 100.0, 1632.5769, -599.7444, 62.0889) && Shoot_Deer[playerid] == 0) {
                    KillTimer(Meeters_BTWDeer[playerid]);
                    Meeter_Kill[playerid] = Meeters[playerid];
                    Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);

                    if(Meeter_Kill[playerid] >= 5) {
                        Shoot_Deer[playerid] = 1;
                        new mesaj[256];
                        MoveObject(Hunter_Deer[playerid], 1632.57690, -599.74438, 61.82332, 3.5, 90.00000, 0.00000, -54.66002);
                        format(mesaj, sizeof(mesaj), "{1e90ff}(JOB): {FFFFFF}You killed a deer from a distance {1e90ff}%d{FFFFFF}Go and peel the skin off it by pressing CTRL. ", Meeter_Kill[playerid]);
                        SendClientMessage(playerid, -1, mesaj);
                        Deep_Deer[playerid] = 1;
                    }else {
                        new mesaj[256];
                        DestroyObject(Hunter_Deer[playerid]);
                        format(mesaj, sizeof(mesaj), "{1e90ff}(JOB): {FFFFFF}Because you fired from a distance {1e90ff}%d{FFFFFF}the deer got scared and ran away. ", Meeter_Kill[playerid]);
                        SendClientMessage(playerid, -1, mesaj);
                        DisablePlayerCheckpoint(playerid);
                        SetTimerEx("Next_Deer", 1000, false, "i", playerid);
                    }

                }
            }
        }
    }else if(Deer[playerid] == 4) {
        if(weaponid == 33) {
            if(hittype == BULLET_HIT_TYPE_OBJECT) {
                if(IsPlayerInRangeOfPoint(playerid, 100.0, 1741.4386, -979.5817, 36.9209) && Shoot_Deer[playerid] == 0) {
                    KillTimer(Meeters_BTWDeer[playerid]);
                    Meeter_Kill[playerid] = Meeters[playerid];
                    Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);

                    if(Meeter_Kill[playerid] >= 5) {
                        Shoot_Deer[playerid] = 1;
                        new mesaj[256];
                        MoveObject(Hunter_Deer[playerid], 1741.43860, -979.58173, 36.61147, 3.5, 90.00000, 0.00000, -7.38000);
                        format(mesaj, sizeof(mesaj), "{1e90ff}(JOB): {FFFFFF}You killed a deer from a distance {1e90ff}%d{FFFFFF}Go and peel the skin off it by pressing CTRL. ", Meeter_Kill[playerid]);
                        SendClientMessage(playerid, -1, mesaj);
                        Deep_Deer[playerid] = 1;
                    }else {
                        new mesaj[256];
                        DestroyObject(Hunter_Deer[playerid]);
                        format(mesaj, sizeof(mesaj), "{1e90ff}(JOB): {FFFFFF}Because you fired from a distance {1e90ff}%d{FFFFFF}the deer got scared and ran away. ", Meeter_Kill[playerid]);
                        SendClientMessage(playerid, -1, mesaj);
                        DisablePlayerCheckpoint(playerid);
                        SetTimerEx("Next_Deer", 1000, false, "i", playerid);
                    }
                }
            }
        }
    }else if(Deer[playerid] == 5) {
        if(weaponid == 33) {
            if(hittype == BULLET_HIT_TYPE_OBJECT) {
                if(IsPlayerInRangeOfPoint(playerid, 100.0, 2553.6780, -963.4338, 82.0169) && Shoot_Deer[playerid] == 0) {
                    KillTimer(Meeters_BTWDeer[playerid]);
                    Meeter_Kill[playerid] = Meeters[playerid];
                    Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);

                    if(Meeter_Kill[playerid] >= 5) {
                        Shoot_Deer[playerid] = 1;
                        new mesaj[256];
                        MoveObject(Hunter_Deer[playerid], 2553.67798, -963.43378, 81.66848, 3.5, 90.00000, 0.00000, 0.00000);
                        format(mesaj, sizeof(mesaj), "{1e90ff}(JOB): {FFFFFF}You killed a deer from a distance {1e90ff}%d{FFFFFF}Go and peel the skin off it by pressing CTRL. ", Meeter_Kill[playerid]);
                        SendClientMessage(playerid, -1, mesaj);
                        Deep_Deer[playerid] = 1;
                    }else {
                        new mesaj[256];
                        DestroyObject(Hunter_Deer[playerid]);
                        format(mesaj, sizeof(mesaj), "{1e90ff}(JOB): {FFFFFF}Because you fired from a distance {1e90ff}%d{FFFFFF}the deer got scared and ran away. ", Meeter_Kill[playerid]);
                        SendClientMessage(playerid, -1, mesaj);
                        DisablePlayerCheckpoint(playerid);
                        SetTimerEx("Next_Deer", 1000, false, "i", playerid);
                    }
                }
            }
        }
    }else if(Deer[playerid] == 6) {
        if(weaponid == 33) {
            if(hittype == BULLET_HIT_TYPE_OBJECT) {
                if(IsPlayerInRangeOfPoint(playerid, 100.0, 2637.4963, -380.2195, 58.2060) && Shoot_Deer[playerid] == 0) {
                    KillTimer(Meeters_BTWDeer[playerid]);
                    Meeter_Kill[playerid] = Meeters[playerid];
                    Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);

                    if(Meeter_Kill[playerid] >= 5) {
                        Shoot_Deer[playerid] = 1;
                        new mesaj[256];
                        MoveObject(Hunter_Deer[playerid], 2637.49634, -380.21951, 57.92605, 3.5, 90.00000, 0.00000, -49.26000);
                        format(mesaj, sizeof(mesaj), "{1e90ff}(JOB): {FFFFFF}You killed a deer from a distance {1e90ff}%d{FFFFFF}Go and peel the skin off it by pressing CTRL. ", Meeter_Kill[playerid]);
                        SendClientMessage(playerid, -1, mesaj);
                        Deep_Deer[playerid] = 1;
                    }else {
                        new mesaj[256];
                        DestroyObject(Hunter_Deer[playerid]);
                        format(mesaj, sizeof(mesaj), "{1e90ff}(JOB): {FFFFFF}Because you fired from a distance {1e90ff}%d{FFFFFF}the deer got scared and ran away. ", Meeter_Kill[playerid]);
                        SendClientMessage(playerid, -1, mesaj);
                        DisablePlayerCheckpoint(playerid);
                        SetTimerEx("Next_Deer", 1000, false, "i", playerid);
                    }
                }
            }
        }
    }else if(Deer[playerid] == 7) {
        if(weaponid == 33) {
            if(hittype == BULLET_HIT_TYPE_OBJECT) {
                if(IsPlayerInRangeOfPoint(playerid, 100.0, 2406.9773, -403.4681, 72.4926) && Shoot_Deer[playerid] == 0) {
                    KillTimer(Meeters_BTWDeer[playerid]);
                    Meeter_Kill[playerid] = Meeters[playerid];
                    Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);

                    if(Meeter_Kill[playerid] >= 5) {
                        Shoot_Deer[playerid] = 1;
                        new mesaj[256];
                        MoveObject(Hunter_Deer[playerid],  2406.97729, -403.46811, 72.17617, 3.5, 90.00000, 0.00000, 0.00000);
                        format(mesaj, sizeof(mesaj), "{1e90ff}(JOB): {FFFFFF}You killed a deer from a distance {1e90ff}%d{FFFFFF}Go and peel the skin off it by pressing CTRL. ", Meeter_Kill[playerid]);
                        SendClientMessage(playerid, -1, mesaj);
                        Deep_Deer[playerid] = 1;
                    }else {
                        new mesaj[256];
                        DestroyObject(Hunter_Deer[playerid]);
                        format(mesaj, sizeof(mesaj), "{1e90ff}(JOB): {FFFFFF}Because you fired from a distance {1e90ff}%d{FFFFFF}the deer got scared and ran away. ", Meeter_Kill[playerid]);
                        SendClientMessage(playerid, -1, mesaj);
                        DisablePlayerCheckpoint(playerid);
                        SetTimerEx("Next_Deer", 1000, false, "i", playerid);
                    }
                }
            }
        }
    }
	if(explosive{playerid})
	{
	    CreateExplosion(fX, fY, fZ, 12, 5.0);
	}
	switch(weaponid){ case 0..18, 39..54: return 1;} //invalid weapons
	if(1 <= weaponid <= 46 && pData[playerid][pGuns][g_aWeaponSlots[weaponid]] == weaponid)
	{
		pData[playerid][pAmmo][g_aWeaponSlots[weaponid]]--;
		if(pData[playerid][pGuns][g_aWeaponSlots[weaponid]] != 0 && !pData[playerid][pAmmo][g_aWeaponSlots[weaponid]])
		{
			pData[playerid][pGuns][g_aWeaponSlots[weaponid]] = 0;
		}
	}
	return 1;
}

stock GivePlayerHealth(playerid,Float:Health)
{
	new Float:health; GetPlayerHealth(playerid,health);
	SetPlayerHealth(playerid,health+Health);
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
   	new Float: p_HP;
    GetPlayerHealth(playerid, p_HP);
	if(!pData[playerid][pSeatbelt])
	{
		SetPlayerHealth(playerid, p_HP-3);
		PlayerPlaySoundEx(playerid, 1130);
		SetTimerEx("HidePlayerBox", 500, false, "dd", playerid, _:ShowPlayerBox(playerid, 0xFF000066));
	}

	new
        Float: vehicleHealth,
        playerVehicleId = GetPlayerVehicleID(playerid);

    new Float: health;
	health = GetPlayerHealth(playerid, health);
    GetVehicleHealth(playerVehicleId, vehicleHealth);
    if(pData[playerid][pSeatbelt] == 0 || pData[playerid][pHelmetOn] == 0)
    {
    	if(GetVehicleSpeed(vehicleid) <= 20)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -1);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 50)
    	{
    		new asakit = RandomEx(0, 2);
    		new bsakit = RandomEx(0, 2);
    		new csakit = RandomEx(0, 2);
    		new dsakit = RandomEx(0, 2);
    		pData[playerid][pLFoot] -= dsakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= dsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -2);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 100)
    	{
    		new asakit = RandomEx(0, 3);
    		new bsakit = RandomEx(0, 3);
    		new csakit = RandomEx(0, 3);
    		new dsakit = RandomEx(0, 3);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= csakit;
    		pData[playerid][pRFoot] -= dsakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -5);
    		return 1;
    	}
    	return 1;
    }
    if(pData[playerid][pSeatbelt] == 1 || pData[playerid][pHelmetOn] == 1)
    {
    	if(GetVehicleSpeed(vehicleid) <= 20)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -1);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 50)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		new dsakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= dsakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= dsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -1);
    		return 1;
    	}
    	if(GetVehicleSpeed(vehicleid) <= 90)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		new dsakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= csakit;
    		pData[playerid][pRFoot] -= dsakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -3);
    		return 1;
    	}
    }
    return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	new str[60];
	new Float:hp;
	GetPlayerHealth(playerid, hp);
	if(IsPlayerNPC(issuerid) || !IsPlayerInAnyVehicle(issuerid)) return 0;
	if(weaponid > 21 && weaponid < 34 || weaponid == 38)
	{
	    SetPlayerHealth(playerid, hp);
		TogglePlayerControllable(issuerid, 0);
		warnings{issuerid} ++;
		if(warnings{issuerid} < MAX_WARININGS)
		{
		    format(str, sizeof(str), "{FFFFFF}Jangan lakukan drive-by {FF0000}%d{FFFFFF}/{FF0000}%d", warnings{issuerid}, MAX_WARININGS);
		    ShowPlayerDialog(issuerid, 12221, DIALOG_STYLE_MSGBOX, "{FF0000}Drive-By", str, "Ok", "");
		    TogglePlayerControllable(issuerid, 1);
		}
		if(warnings{issuerid} >= MAX_WARININGS)
		{
		    ShowPlayerDialog(issuerid, 12221, DIALOG_STYLE_MSGBOX, "{FF0000}Drive-By", "{FF0000}Anda telah di tendang karna drive-by", "Ok", "");
		    KickEx(issuerid);
		}
	}
	if(IsAtEvent[playerid] == 0)
	{
		new sakit = RandomEx(1, 4);
		new asakit = RandomEx(1, 5);
		new bsakit = RandomEx(1, 7);
		new csakit = RandomEx(1, 4);
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 9)
		{
			pData[playerid][pHead] -= 20;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 3)
		{
			pData[playerid][pPerut] -= sakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 6)
		{
			pData[playerid][pRHand] -= bsakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 5)
		{
			pData[playerid][pLHand] -= asakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 8)
		{
			pData[playerid][pRFoot] -= csakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 7)
		{
			pData[playerid][pLFoot] -= bsakit;
		}
	}
	else if(IsAtEvent[playerid] == 1)
	{
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 9)
		{
			GivePlayerHealth(playerid, -90);
			SendClientMessage(issuerid, -1,"{7fffd4}[ TDM ]{ffffff} Headshot!");
		}
	}
    return 1;
}

stock SavePeluru(playerid)
{
    new queryBuffer[103];
	if(GetPlayerWeapon(playerid) == WEAPON_DEAGLE)
	{
		pData[playerid][pPeluru][0] = GetPlayerAmmo(playerid);
		mysql_format(g_SQL, queryBuffer, sizeof(queryBuffer), "UPDATE players SET peluru_0 = %i WHERE uid = %i", pData[playerid][pPeluru][0], pData[playerid][pID]);
		mysql_tquery(g_SQL, queryBuffer);
	}
	else if(GetPlayerWeapon(playerid) == WEAPON_SILENCED)
	{
		pData[playerid][pPeluru][1] = GetPlayerAmmo(playerid);
		mysql_format(g_SQL, queryBuffer, sizeof(queryBuffer), "UPDATE players SET peluru_1 = %i WHERE uid = %i", pData[playerid][pPeluru][1], pData[playerid][pID]);
		mysql_tquery(g_SQL, queryBuffer);
	}
}

public OnPlayerUpdate(playerid)
{
    afk_tick[playerid]++;
    new string[256];
	format(string, sizeof string, "%02d:%02d", JamFivEm, DetikFivEm);
   	TextDrawSetString(JAMLOCKSCREEN, string);
    //SavePeluru(playerid);
	if(vpara[playerid] == 1) 
    { 
        if(IsPlayerInAnyVehicle(playerid)) 
        { 
            if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) 
            { 
                static vid, Float:x, Float:y, Float:z; 
               	vid = GetPlayerVehicleID(playerid); 
                GetVehicleVelocity(vid,x,y,z); 
                SetVehicleVelocity(vid,x,y,-0.2); 
            } 
        } 
    } 
	static str[500];
	if (PlayerInfo[playerid][pWaypoint])
	{
		format(str, sizeof(str), "~b~GPS:~w~ %s (%.2f meters)", PlayerInfo[playerid][pLocation], GetPlayerDistanceFromPoint(playerid, PlayerInfo[playerid][pWaypointPos][0], PlayerInfo[playerid][pWaypointPos][1], PlayerInfo[playerid][pWaypointPos][2]));
		PlayerTextDrawSetString(playerid, PlayerInfo[playerid][pTextdraws][69], str);
	}
	//SAPD Tazer/Taser
	UpdateTazer(playerid);
	
	//SAPD Road Spike
	CheckPlayerInSpike(playerid);

	//Report ask
	//GetPlayerName(playerid, g_player_name[playerid], MAX_PLAYER_NAME);

	//AntiCheat
	pData[playerid][pLastUpdate] = gettime();

	//SpeedCam
	static id;
	new vehicled = Vehicle_Nearest2(playerid), query[326];
	if ((id = SpeedCam_Nearest(playerid)) != -1 && GetPlayerSpeedCam(playerid) > CamData[id][CamLimit] && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && pvData[vehicled][cOwner] == pData[playerid][pID] && GetEngineStatus(vehicled) && !pData[playerid][pSpeedTime])
	{
	    if (!IsACruiser(vehicled) && !IsABoat(vehicled) && !IsAPlane(vehicled) && !IsAHelicopter(vehicled))
	    {
	 		new price = 30 + floatround(GetPlayerSpeedCam(playerid) - CamData[id][CamLimit]);
	   		format(str, sizeof(str), "Kecepatan (%.0f/%.0f mph)", GetPlayerSpeedCam(playerid), CamData[id][CamLimit]);
	        SetTimerEx("HidePlayerBox", 500, false, "dd", playerid, _:ShowPlayerBox(playerid, 0xFFFFFF66));
    		format(str, sizeof(str), "Anda telah melebihi kecepatan dan mendapatkan denda sebesar ~y~%s", FormatMoney(price));
     		InfoMsg(playerid, str);
			pvData[vehicled][cTicket] += price;

			mysql_format(g_SQL, query, sizeof(query), "UPDATE vehicle SET ticket = '%d' WHERE id = '%d'", pvData[vehicled][cTicket], pvData[vehicled][cID]);
			mysql_tquery(g_SQL, query);
			pData[playerid][pSpeedTime] = 5;
		}
	}
	return 1;
}

task VehicleUpdate[40000]()
{
	for (new i = 1; i != MAX_VEHICLES; i ++) if(IsEngineVehicle(i) && GetEngineStatus(i))
    {
        if(GetVehicleFuel(i) > 0)
        {
			new fuel = GetVehicleFuel(i);
            SetVehicleFuel(i, fuel - 1);

            if(GetVehicleFuel(i) >= 1 && GetVehicleFuel(i) <= 20)
            {
               Info(GetVehicleDriver(i), "Kendaraan ingin habis bensin, Harap pergi ke SPBU ( Gas Station )");
            }
        }
        if(GetVehicleFuel(i) <= 0)
        {
            SetVehicleFuel(i, 0);
            SwitchVehicleEngine(i, false);
        }
    }
	foreach(new ii : PVehicles)
	{
		if(IsValidVehicle(pvData[ii][cVeh]))
		{
			if(pvData[ii][cPlateTime] != 0 && pvData[ii][cPlateTime] <= gettime())
			{
				format(pvData[ii][cPlate], 32, "NoHave");
				SetVehicleNumberPlate(pvData[ii][cVeh], pvData[ii][cPlate]);
				pvData[ii][cPlateTime] = 0;
			}
			if(pvData[ii][cRent] != 0 && pvData[ii][cRent] <= gettime())
			{
				pvData[ii][cRent] = 0;
				new query[128], xuery[128];
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[ii][cID]);
				mysql_tquery(g_SQL, query);

				mysql_format(g_SQL, xuery, sizeof(xuery), "DELETE FROM vstorage WHERE owner = '%d'", pvData[ii][cID]);
				mysql_tquery(g_SQL, xuery);
				if(IsValidVehicle(pvData[ii][cVeh])) DestroyVehicle(pvData[ii][cVeh]);
				pvData[ii][cVeh] = INVALID_VEHICLE_ID;
				Iter_SafeRemove(PVehicles, ii, ii);
			}
		}
		if(pvData[ii][cClaimTime] != 0 && pvData[ii][cClaimTime] <= gettime())
		{
			pvData[ii][cClaimTime] = 0;
		}
	}
}
public OnVehicleDeath(vehicleid, killerid)
{
    foreach(new i : PVehicles)
    {
        if(pvData[i][cVeh] == vehicleid)
        {
            pvData[i][cStolen] = gettime() + 15;
        }
    }
    return 1;
}

public OnVehicleSpawn(vehicleid)
{
    //LoadedTrash[vehicleid] = 0;
    foreach(new ii : PVehicles)
    {
        if(vehicleid == pvData[ii][cVeh] && pvData[ii][cRent] == 0 && pvData[ii][cStolen] > gettime())
        {
            if(pvData[ii][cInsu] > 0)
            {
                pvData[ii][cStolen] = 0;

                pvData[ii][cClaim] = 1;
                pvData[ii][cClaimTime] = gettime() + (1 * 1200);
                foreach(new pid : Player) if (pvData[ii][cOwner] == pData[pid][pID])
                {
                    Info(pid, "Kendaraan anda hancur, silahkan ambil di kantor insurance.");
                }
                if(IsValidVehicle(pvData[ii][cVeh]))
                    DestroyVehicle(pvData[ii][cVeh]);

                pvData[ii][cVeh] = INVALID_VEHICLE_ID;
            }
        }
    }
    return 1;
}
ptask PlayerVehicleUpdate[200](playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsValidVehicle(vehicleid))
	{
		if(!GetEngineStatus(vehicleid) && IsEngineVehicle(vehicleid))
		{	
			SwitchVehicleEngine(vehicleid, false);
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new Float:fHealth;
			GetVehicleHealth(vehicleid, fHealth);
			if(IsValidVehicle(vehicleid) && fHealth <= 250.0)
			{
				SetValidVehicleHealth(vehicleid, 300.0);
				SwitchVehicleEngine(vehicleid, false);
				ErrorMsg(playerid, "Mesin kendaraan anda rusak, segera perbaiki");
			}
		}
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if(pData[playerid][pHBEMode] == 1)
			{
                new Float:fDamage, fFuel, color1, color2;
			    new Float: SPEEDVEHBAR, Float: FUELVEHBAR, str[500];
			    static Float:bengsin;
			    static Float:kecepatan;

				GetVehicleColor(vehicleid, color1, color2);

				GetVehicleHealth(vehicleid, fDamage);
				if(fDamage <= 350) fDamage = 0;
				else if(fDamage > 1000) fDamage = 1000;

				fFuel = GetVehicleFuel(vehicleid);

 				if(fFuel < 0) fFuel = 0;
				else if(fFuel > 100) fFuel = 100;

				new strspeed[128], strfuel[128];
				format(strspeed, sizeof(strspeed), "%.0f", GetVehicleSpeed(vehicleid));
				PlayerTextDrawSetString(playerid, TD_KMH[playerid], strspeed);
				PlayerTextDrawShow(playerid, TD_KMH[playerid]);
				format(strfuel, sizeof(strfuel), "%d", fFuel);
				PlayerTextDrawSetString(playerid, TD_Fuel[playerid], strfuel);
				PlayerTextDrawShow(playerid, TD_Fuel[playerid]);
			}
		}
	}
}
ptask PlayerUpdate[999](playerid)
{
    // AFK
		new StringF[50];
	 	if(afk_tick[playerid] > 10000) afk_tick[playerid] = 1, afk_check[playerid] = 0;
	 	if(afk_check[playerid] < afk_tick[playerid] && GetPlayerState(playerid)) afk_check[playerid] = afk_tick[playerid], afk_time[playerid] = 0;
	 	if(afk_check[playerid] == afk_tick[playerid] && GetPlayerState(playerid))
	  	{
	   		afk_time[playerid]++;
	     	if(afk_time[playerid] > 2)
	      	{
	       		format(StringF,sizeof(StringF), "[ATIP]");
				SetPlayerChatBubble(playerid, StringF, COLOR_RED, 15.0, 1200);
	    	}
	    }
    if(pData[playerid][TempatHealing])
    {
        stresstimer[playerid] = SetTimerEx("StressBerkurang", 5000, true, "d", playerid);
    }
    if(pData[playerid][pBladder] <= 15)
    {
        pData[playerid][TempatHealing] = false;
        KillTimer(stresstimer[playerid]);
    }
    if(pData[playerid][AmbilAyam] == 8)
    {
        pData[playerid][AmbilAyam] = 0;
        pData[playerid][DutyAmbilAyam] = 0;
        SetPlayerPos(playerid, -1415.173583,-958.280090,201.093750);
		SetPlayerFacingAngle(playerid, 175.453338);
    }
    //JOB BUS
    new vehicleid = GetPlayerVehicleID(playerid);
	if(pData[playerid][pBus] && GetVehicleModel(vehicleid) == 431 && pData[playerid][pBuswaiting])
	{
		if(pData[playerid][pBustime] > 0)
		{
			pData[playerid][pBustime]--;
			new str[512];
			format(str, sizeof(str), "Tunggu %d Detik", pData[playerid][pBustime]);
			Jembut(playerid, str, 1);
			PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
		}
		else
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, 1965.075073,-1779.868530,13.479113))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				pData[playerid][pBus] = 16;
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 2, buspoint16, buspoint16, 5.0);
				PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, 2763.975097,-2479.834228,13.575368))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				pData[playerid][pBus] = 27;
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 1, buspoint27, buspoint27, 5.0);
				PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, 1235.685913,-1855.510986,13.481544))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				pData[playerid][pBus] = 59;
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 1, buspoint59, buspoint59, 5.0);
				PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
			}
			//rute bus 2
			/*else if(IsPlayerInRangeOfPoint(playerid, 2.0, 1909.409545,-1929.344238,12.945344))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				pData[playerid][pBus] = 69;
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 1, cpbus4, cpbus4, 5.0);
				PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, 1825.054931,-1665.261474,12.955155))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				pData[playerid][pBus] = 73;
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 1, cpbus7, cpbus7, 5.0);
				PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, 2082.242187,-1777.502929,12.955197))
			{
				pData[playerid][pBuswaiting] = false;
				pData[playerid][pBustime] = 0;
				pData[playerid][pBus] = 77;
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 1, cpbus11, cpbus11, 5.0);
				PlayerPlaySound(playerid, 43000, 0.0,0.0,0.0);
			}*/
	}
	return 1;
}
	if(GetPlayerScore(playerid) < 3)//artinya kalau level dibawah 2 bakalan ke kick terkena anti cheat weapon hack
 	{
		if(GetPlayerWeapon(playerid) == 10)//id 25 sama dengan senjata shotgun
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 11)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 12)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 13)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 14)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 15)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 16)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
        if(GetPlayerWeapon(playerid) == 17)//id 38 sama dengan senjata minigun
		{	
			ResetPlayerWeaponsEx(playerid); 
		   	Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 18)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 19)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 20)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 21)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 22)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 23)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 24)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 25)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 26)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 27)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 28)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 29)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 30)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 32)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 32)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 33)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 34)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 35)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 36)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 37)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 38)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 39)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
		if(GetPlayerWeapon(playerid) == 40)
		{
			ResetPlayerWeaponsEx(playerid);   
		    Kick(playerid);
		}
	}
	//Anti-Cheat Vehicle health hack
	if(pData[playerid][pAdmin] < 2)
	{
		for(new v, j = GetVehiclePoolSize(); v <= j; v++) if(GetVehicleModel(v))
		{
			new Float:health;
			GetVehicleHealth(v, health);
			if( (health > VehicleHealthSecurityData[v]) && VehicleHealthSecurity[v] == false)
			{
				if(GetPlayerVehicleID(playerid) == v)
				{
					new playerState = GetPlayerState(playerid);
					if(playerState == PLAYER_STATE_DRIVER)
					{
						SetValidVehicleHealth(v, VehicleHealthSecurityData[v]);
						SendClientMessageToAllEx(COLOR_RED, "[ExecutiveBOT]: telah menendang %s dari kota, Alasan: Vehicle Health!", pData[playerid][pName]);
						KickEx(playerid);
					}
				}
			}
			if(VehicleHealthSecurity[v] == true)
			{
				VehicleHealthSecurity[v] = false;
			}
			VehicleHealthSecurityData[v] = health;
		}
	}	
	//Anti-Money Hack
	if(GetPlayerMoney(playerid) > pData[playerid][pMoney])
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, pData[playerid][pMoney]);
		//SendAdminMessage(COLOR_RED, "Possible money hacks detected on %s(%i). Check on this player. "LG_E"($%d).", pData[playerid][pName], playerid, GetPlayerMoney(playerid) - pData[playerid][pMoney]);
	}
	if(pData[playerid][pJail] <= 0)
	{
		if(pData[playerid][pHunger] > 100)
		{
			pData[playerid][pHunger] = 100;
		}
		if(pData[playerid][pHunger] < 0)
		{
			pData[playerid][pHunger] = 0;
		}
		if(pData[playerid][pBladder] > 100)
		{
			pData[playerid][pBladder] = 100;
		}
		if(pData[playerid][pBladder] < 0)
		{
			pData[playerid][pBladder] = 0;
		}
		if(pData[playerid][pEnergy] > 100)
		{
			pData[playerid][pEnergy] = 100;
		}
		if(pData[playerid][pEnergy] < 0)
		{
			pData[playerid][pEnergy] = 0;
		}
        if(pData[playerid][pKencing] > 100)
		{
			pData[playerid][pKencing] = 100;
		}
		if(pData[playerid][pKencing] < 0)
		{
			pData[playerid][pKencing] = 0;
		}
	}
	
	if(pData[playerid][pHBEMode] == 1 && pData[playerid][IsLoggedIn] == true)
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);

		PlayerTextDrawShow(playerid, PlayerTD[playerid][0]);
		PlayerTextDrawShow(playerid, PlayerTD[playerid][1]);
		PlayerTextDrawShow(playerid, PlayerTD[playerid][2]);
		new lokasi[20];
		format(lokasi, sizeof(lokasi), "%s", GetLocation(x, y, z));
		PlayerTextDrawSetString(playerid, PlayerTD[playerid][5], lokasi);
		PlayerTextDrawShow(playerid, PlayerTD[playerid][5]);
		PlayerTextDrawShow(playerid, PlayerTD[playerid][6]);
		PlayerTextDrawShow(playerid, PlayerTD[playerid][7]);

		PlayerTextDrawShow(playerid, BG_Makanan[playerid]);
		PlayerTextDrawShow(playerid, BG_Minuman[playerid]);
		PlayerTextDrawShow(playerid, BG_Stress[playerid]);
		PlayerTextDrawShow(playerid, BG_Kencing[playerid]);
		new makan[20];
		format(makan, sizeof(makan), "%d", pData[playerid][pHunger]);
		PlayerTextDrawSetString(playerid, TD_Makanan[playerid], makan);
		PlayerTextDrawShow(playerid, TD_Makanan[playerid]);
		new minum[20];
		format(minum, sizeof(minum), "%d", pData[playerid][pEnergy]);
		PlayerTextDrawSetString(playerid, TD_Minum[playerid], minum);
		PlayerTextDrawShow(playerid, TD_Minum[playerid]);
		new stress[20];
		format(stress, sizeof(stress), "%d", pData[playerid][pBladder]);
		PlayerTextDrawSetString(playerid, TD_Stress[playerid], stress);
		PlayerTextDrawShow(playerid, TD_Stress[playerid]);
		new kencing[20];
		format(kencing, sizeof(kencing), "%d", pData[playerid][pKencing]);
		PlayerTextDrawSetString(playerid, TD_Kencing[playerid], kencing);
		PlayerTextDrawShow(playerid, TD_Kencing[playerid]);

		PlayerTextDrawShow(playerid, TD_Jam[playerid]);
	}
	if(pData[playerid][pHospital] == 1)
    {
		if(pData[playerid][pInjured] == 1)
		{
			SetPlayerPosition(playerid, -2028.32, -92.87, 1067.43, 275.78, 1);
		
			SetPlayerInterior(playerid, 1);
			SetPlayerVirtualWorld(playerid, playerid + 100);

			SetPlayerCameraPos(playerid, -2024.67, -93.13, 1066.78);
			SetPlayerCameraLookAt(playerid, -2028.32, -92.87, 1067.43);
			TogglePlayerControllable(playerid, 0);
			pData[playerid][pInjured] = 0;
			UpdateDynamic3DTextLabelText(pData[playerid][pInjuredLabel], COLOR_ORANGE, "");
			ResetPlayerWeaponsEx(playerid);
		}
		pData[playerid][pHospitalTime]++;
		new mstr[64];
		format(mstr, sizeof(mstr), "~n~~n~~n~~w~Recovering... %d", 15 - pData[playerid][pHospitalTime]);
		InfoTD_MSG(playerid, 1000, mstr);

		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
        if(pData[playerid][pHospitalTime] >= 15)
        {
            pData[playerid][pHospitalTime] = 0;
            pData[playerid][pHospital] = 0;
			pData[playerid][pHunger] = 100;
			pData[playerid][pEnergy] = 100;
			SetPlayerHealthEx(playerid, 100);
			pData[playerid][pBladder] = 0;
			pData[playerid][pKencing] = 0;
			pData[playerid][pSick] = 0;
			GivePlayerMoneyEx(playerid, -150);
			SetPlayerHealthEx(playerid, 100);
			HideTdDeath(playerid);

            for (new i; i < 20; i++)
            {
                SendClientMessage(playerid, -1, "");
            }

            InfoMsg(playerid, "Anda membayar $150 kerumah sakit.");
 
			SetPlayerPosition(playerid, 759.10,-1411.21,13.53,48.52);

            TogglePlayerControllable(playerid, 1);
            SetCameraBehindPlayer(playerid);

            SetPlayerVirtualWorld(playerid, 0);
            SetPlayerInterior(playerid, 0);
			ClearAnimations(playerid);
			pData[playerid][pSpawned] = 1;
			SetPVarInt(playerid, "GiveUptime", -1);
		}
    }
	if(pData[playerid][pInjured] == 1 && pData[playerid][pHospital] != 1)
    {
		new string[30];
		format(string, sizeof(string), "(( THIS PLAYER IS INJURED ))");
		UpdateDynamic3DTextLabelText(pData[playerid][pInjuredLabel], COLOR_ORANGE, string);

		ShowTdDeath(playerid);
		
		if(GetPVarInt(playerid, "GiveUptime") == -1)
		{
			SetPVarInt(playerid, "GiveUptime", gettime());
		}
		
		if(GetPVarInt(playerid,"GiveUptime"))
        {
            if((gettime()-GetPVarInt(playerid, "GiveUptime")) > 100)
            {
                Info(playerid, "Now you can spawn, type '/death' for spawn to hospital.");
                SetPVarInt(playerid, "GiveUptime", 0);
            }
        }
		
        ApplyAnimation(playerid, "CRACK", "null", 4.0, 0, 0, 0, 1, 0, 1);
        ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);
        SetPlayerHealthEx(playerid, 99999);
    }
	if(pData[playerid][pInjured] == 0 && pData[playerid][pGender] != 0) //Pengurangan Data
	{
		if(++ pData[playerid][pHungerTime] >= 150)
        {
            if(pData[playerid][pHunger] > 0)
            {
                pData[playerid][pHunger]--;
            }
            else if(pData[playerid][pHunger] <= 0)
            {
          		pData[playerid][pSick] = 1;
            }
            pData[playerid][pHungerTime] = 0;
        }
        if(++ pData[playerid][pEnergyTime] >= 120)
        {
            if(pData[playerid][pEnergy] > 0)
            {
                pData[playerid][pEnergy]--;
            }
            else if(pData[playerid][pEnergy] <= 0)
            {
          		pData[playerid][pSick] = 1;
            }
            pData[playerid][pEnergyTime] = 0;
        }
        if(++ pData[playerid][pBladderTime] >= 150)
        {
            if(pData[playerid][pBladder] < 97)
            {
                pData[playerid][pBladder]++;
            }
            else if(pData[playerid][pBladder] >= 90)
            {
          		Info(playerid, "Sepertinya anda stress, segeralah pergi ke pantai atau konsumsi pil untuk menghilangkan stress.");
          		SetPlayerDrunkLevel(playerid, 2200);
            }
            pData[playerid][pBladderTime] = 0;
        }
        if(++ pData[playerid][pKencingTime] >= 30)
        {
            if(pData[playerid][pKencing] < 97)
            {
                pData[playerid][pKencing]++;
            }
            else if(pData[playerid][pKencing] >= 90)
            {
          		Info(playerid, "Karakter anda merasa ingin kencing, segeralah pergi ke toilet.");
            }
            pData[playerid][pKencingTime] = 0;
        }
		if(pData[playerid][pSick] == 1)
		{
			if(++ pData[playerid][pSickTime] >= 200)
			{
				if(pData[playerid][pSick] >= 1)
				{
					new Float:hp;
					GetPlayerHealth(playerid, hp);
					Info(playerid, "Sepertinya anda sakit, segeralah pergi ke dokter.");
					pData[playerid][pSickTime] = 0;
				}
			}
		}
	}
	if (pData[playerid][pSpeedTime] > 0)
	{
	    pData[playerid][pSpeedTime]--;
	}
	if(pData[playerid][pLastChopTime] > 0)
    {
		pData[playerid][pLastChopTime]--;
		new mstr[64];
        format(mstr, sizeof(mstr), "Waktu Pencurian ~r~%d ~w~detik", pData[playerid][pLastChopTime]);
        InfoTD_MSG(playerid, 1000, mstr);
	}
	//Jail Player
	if(pData[playerid][pJail] > 0)
	{
		if(pData[playerid][pJailTime] > 0)
		{
			pData[playerid][pJailTime]--;
			new mstr[128];
			format(mstr, sizeof(mstr), "~b~~h~Anda akan dibebaskan dalam ~w~%d ~b~~h~detik.", pData[playerid][pJailTime]);
			InfoTD_MSG(playerid, 1000, mstr);
		}
		else
		{
			pData[playerid][pJail] = 0;
			pData[playerid][pJailTime] = 0;
			//SpawnPlayer(playerid);
			SetPlayerPositionEx(playerid, 1316.1792,-1366.5283,15.4769, 2000);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			InfoMsg(playerid, "Anda Telah dibebaskan dari penjara");
		}
	}
	//Arreset Player
	if(pData[playerid][pArrest] > 0)
	{
		if(pData[playerid][pArrestTime] > 0)
		{
			pData[playerid][pArrestTime]--;
			new mstr[128];
			format(mstr, sizeof(mstr), "~b~~h~Anda dipenjara selama ~w~%d ~b~~h~detik.", pData[playerid][pArrestTime]);
			InfoTD_MSG(playerid, 1000, mstr);
		}
		else
		{
			pData[playerid][pArrest] = 0;
			pData[playerid][pArrestTime] = 0;
			//SpawnPlayer(playerid);
			SetPlayerPositionEx(playerid, 1316.1792,-1366.5283,15.4769, 2000);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			InfoMsg(playerid, "Anda telah dibebaskan dari penjara");
		}
	}
	return 1;
}
public OnPlayerExitVehicle(playerid, vehicleid)
{
    if(vehicleid == Car_Job[playerid])
    {
        timer_Car[playerid] = SetTimerEx("Detectare_Intrare", 1000, true, "i", playerid);
        Seconds_timer[playerid] = 0;
        SendClientMessage(playerid, ATENTIE, "Silahkan kembali ke kendaraan selama 120 detik.");
    }
	if(vehicleid == pData[playerid][pKendaraanKerja])
    {
        KeluarKerja[playerid] = SetTimerEx("KeluarKendaraanKerja", 1000, true, "i", playerid);
        TimerKeluar[playerid] = 0;
        InfoMsg(playerid, "Segera masuk kedalam kendaraan dalam 15 detik!");
    }
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) 
    { 
        vpara[playerid]=0; 
        DestroyDynamicObject(para[vehicleid]); 
    } 
    if(pData[playerid][pDriveLicApp] > 0)
	{
		//new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 602)
		{
		    DisablePlayerCheckpoint(playerid);
			DisablePlayerRaceCheckpoint(playerid);
		    Info(playerid, "Anda Dengan Sengaja Keluar Dari Mobil Latihan, Anda Telah "RED_E"DIDISKUALIFIKASI.");
		    RemovePlayerFromVehicle(playerid);
		    pData[playerid][pDriveLicApp] = 0;
		    SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(PlayerData[playerid][pAdmin] > 0)
	{
		DisplayStats(clickedplayerid, playerid);
	}
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	Waypoint_Set(playerid, GetLocation(fX, fY, fZ), fX, fY, fZ);
    if (pData[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pAdminDuty] == 1)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid > 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
                SetVehiclePos(vehicleid, fX, fY, fZ+10);
        }
        else
        {
                SetPlayerPosFindZ(playerid, fX, fY, 999.0);
                SetPlayerVirtualWorld(playerid, 0);
                SetPlayerInterior(playerid, 0);
        }
    }
    foreach (new i : Player)
	{
		if(pData[i][pClikmap] == pData[playerid][pClikmap] && pData[playerid][pClikmap] != 0 && pData[i][pClikmap] != 0)
		{
			SetPlayerCheckpoint(i, fX, fY, fZ, 3.0);
			Info(i, "Waypoint Sharing, Lihat pada map.");
		}
    }
    return 1;
}

stock SenjataHilang(playerid)
{
	new cQuery[4028];
	pData[playerid][pPeluru][0] = 0;
	pData[playerid][pPeluru][1] = 0;
	pData[playerid][pDe] = 0;
	pData[playerid][pKatana] = 0;
	pData[playerid][pMolotov] = 0;
	pData[playerid][p9mm] = 0;
	pData[playerid][pSg] = 0;
	pData[playerid][pSpas] = 0;
	pData[playerid][pMp5] = 0;
	pData[playerid][pM4] = 0;
	pData[playerid][pClip] = 0;
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE players SET peluru_0 = 0, peluru_1 = 0 WHERE reg_id = %i", pData[playerid][pPeluru][0], pData[playerid][pPeluru][1], pData[playerid][pID]);
	mysql_tquery(g_SQL, cQuery);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE players SET de = 0 WHERE reg_id = %i", pData[playerid][pDe], pData[playerid][pID]);
	mysql_tquery(g_SQL, cQuery);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE players SET katana = 0 WHERE reg_id = %i", pData[playerid][pKatana], pData[playerid][pID]);
	mysql_tquery(g_SQL, cQuery);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE players SET molotov = 0 WHERE reg_id = %i", pData[playerid][pMolotov], pData[playerid][pID]);
	mysql_tquery(g_SQL, cQuery);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE players SET 9mm = 0 WHERE reg_id = %i", pData[playerid][p9mm], pData[playerid][pID]);
	mysql_tquery(g_SQL, cQuery);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE players SET sg = 0 WHERE reg_id = %i", pData[playerid][pSg], pData[playerid][pID]);
	mysql_tquery(g_SQL, cQuery);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE players SET spas = 0 WHERE reg_id = %i", pData[playerid][pSpas], pData[playerid][pID]);
	mysql_tquery(g_SQL, cQuery);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE players SET mp5 = 0 WHERE reg_id = %i", pData[playerid][pMp5], pData[playerid][pID]);
	mysql_tquery(g_SQL, cQuery);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE players SET m4 = 0 WHERE reg_id = %i", pData[playerid][pM4], pData[playerid][pID]);
	mysql_tquery(g_SQL, cQuery);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE players SET clip = 0 WHERE reg_id = %i", pData[playerid][pClip], pData[playerid][pID]);
	mysql_tquery(g_SQL, cQuery);
	return 1;
}

stock SendDiscordMessage(channel, message[])
{
	new DCC_Channel:ChannelId;
	switch(channel)
	{
		//==[ Log Join & Leave ]
		case 0:
		{
			ChannelId = DCC_FindChannelById("1095732573004648499");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Log Command ]
		case 1:
		{
			ChannelId = DCC_FindChannelById("985459425739423814");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Log Chat IC ]
		case 2:
		{
			ChannelId = DCC_FindChannelById("1095732561793253447");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Warning & Banned ]
		case 3:
		{
			ChannelId = DCC_FindChannelById("1102965085384744970");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Log Death ]
		case 4:
		{
			ChannelId = DCC_FindChannelById("1095732571511459941");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Ucp ]
		case 5:
		{
			ChannelId = DCC_FindChannelById("1099135730044907681");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 6://Korup
		{
			ChannelId = DCC_FindChannelById("985459255127732244");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 7://Register
		{
			ChannelId = DCC_FindChannelById("1099135730044907681");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 8://Bot Admin
		{
			ChannelId = DCC_FindChannelById("981567510006624266");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Log Death ]
		case 9:
		{
			ChannelId = DCC_FindChannelById("985459325562650645");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Log CMD Admin ]
		case 10:
		{
			ChannelId = DCC_FindChannelById("987326112227016786");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ LOG STATUS SERVER ]==
		case 11:
		{
			ChannelId = DCC_FindChannelById("987326112227016786");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
	}
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == TUTUPHP)
	{
		SimpanHp(playerid);
	}
	if(clickedid == FINGERPRINT)
	{
	    TextDrawHideForPlayer(playerid, FINGERPRINT);
		TextDrawHideForPlayer(playerid, TANGGAL);
		TextDrawHideForPlayer(playerid, JAMLOCKSCREEN);

		for(new i = 0; i < 13; i++)
        {
			TextDrawShowForPlayer(playerid, APKNAME[i]);
	    }
		for(new u = 0; u < 13; u++)
        {
			PlayerTextDrawShow(playerid, APKLOGO[playerid][u]);
	    }

		TextDrawShowForPlayer(playerid, GPS);
	    TextDrawShowForPlayer(playerid, KONTAK);
		TextDrawShowForPlayer(playerid, AIRDROP);
		TextDrawShowForPlayer(playerid, GOJEK);
		TextDrawShowForPlayer(playerid, MBANKING);
		TextDrawShowForPlayer(playerid, TWITTER);
		TextDrawShowForPlayer(playerid, DARKWEB);
		TextDrawShowForPlayer(playerid, PLAYSTORE);
		TextDrawShowForPlayer(playerid, WHATSAPP);
		TextDrawShowForPlayer(playerid, CALL);
		TextDrawShowForPlayer(playerid, MUSIC);
		TextDrawShowForPlayer(playerid, SETTINGS);
		TextDrawShowForPlayer(playerid, KAMERA);
		TextDrawShowForPlayer(playerid, TUTUPHP);
		PunyaSpotify(playerid);
		PunyaDarkWeb(playerid);
  		PunyaMbanking(playerid);
		PunyaTwitter(playerid);
		PunyaGojek(playerid);
	}
	if(clickedid == GPS)
	{
		ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "{7fffd4}Executive {ffffff}- GPS", "Lokasi Pekerjaan\nLokasi Umum\nToko Di Kota\nGarasi Kota\n"RED_E"(Hapus Checkpoint GPS)", "Pilih", "Batal");
	}
	if(clickedid == MBANKING)
	{
		SimpanHp(playerid);
		for(new u = 0; u < 11; u++)
        {
			PlayerTextDrawShow(playerid, MBANKINGAPP[playerid][u]);
	    }
	    for(new i = 0; i < 21; i++)
		{
			TextDrawShowForPlayer(playerid, PhoneTD[i]);
		}
		PlayerTextDrawShow(playerid, TRANSFER[playerid]);
		PlayerTextDrawShow(playerid, NoRekening[playerid]);
		PlayerTextDrawShow(playerid, BNama[playerid]);
		PlayerTextDrawShow(playerid, BSaldo[playerid]);
		TextDrawShowForPlayer(playerid, TUTUPHP);
		new AtmInfo[560];
	   	format(AtmInfo,1000,"%s", GetName(playerid));
	   	PlayerTextDrawSetString(playerid, BNama[playerid], AtmInfo);
	   	format(AtmInfo,1000,"%s", FormatMoney(pData[playerid][pBankMoney]));
	   	PlayerTextDrawSetString(playerid, BSaldo[playerid], AtmInfo);
	   	format(AtmInfo,1000,"%d", pData[playerid][pBankRek]);
	   	PlayerTextDrawSetString(playerid, NoRekening[playerid], AtmInfo);
		SelectTextDraw(playerid, COLOR_BLUE);
	}
	if(clickedid == PLAYSTORE)
	{
	    SimpanHp(playerid);
	    for(new i = 0; i < 21; i++)
		{
			TextDrawShowForPlayer(playerid, PhoneTD[i]);
		}
		for(new u = 0; u < 31; u++)
        {
			PlayerTextDrawShow(playerid, PLAYSTOREAPP[playerid][u]);
	    }
	    TextDrawShowForPlayer(playerid, TUTUPHP);
	    SelectTextDraw(playerid, COLOR_BLUE);
	}
	if(clickedid == SETTINGS)
	{
		ShowPlayerDialog(playerid, DIALOG_TOGGLEPHONE, DIALOG_STYLE_LIST, "Executive - Pengaturan", "Tentang Ponsel", "Pilih", "Kembali");
	}
	if(clickedid == KAMERA)
	{
		callcmd::selfie(playerid, "");
	}
	if(clickedid == MUSIC)
	{
		SimpanHp(playerid);
	    for(new u = 0; u < 12; u++)
        {
			PlayerTextDrawShow(playerid, MUSICAPP[playerid][u]);
	    }
	    for(new i = 0; i < 21; i++)
		{
			TextDrawShowForPlayer(playerid, PhoneTD[i]);
		}
	    PlayerTextDrawShow(playerid, EARPHONE[playerid]);
	    PlayerTextDrawShow(playerid, BOOMBOX[playerid]);
	    TextDrawShowForPlayer(playerid, TUTUPHP);
	    SelectTextDraw(playerid, COLOR_BLUE);
	}
	if(clickedid == GOJEK)
	{
		SimpanHp(playerid);
	    for(new u = 0; u < 17; u++)
        {
			PlayerTextDrawShow(playerid, GOJEKAPP[playerid][u]);
	    }
	    for(new i = 0; i < 21; i++)
		{
			TextDrawShowForPlayer(playerid, PhoneTD[i]);
		}
		new Gopay[560];
	   	format(Gopay,1000,"%s", FormatMoney(pData[playerid][pGopay]));
	   	PlayerTextDrawSetString(playerid, GSALDO[playerid], Gopay);
	    PlayerTextDrawShow(playerid, GPAY[playerid]);
	    PlayerTextDrawShow(playerid, GTOPUP[playerid]);
	    PlayerTextDrawShow(playerid, GSALDO[playerid]);
	    PlayerTextDrawShow(playerid, GRIDE[playerid]);
	    PlayerTextDrawShow(playerid, GCAR[playerid]);
	    PlayerTextDrawShow(playerid, GFOOD[playerid]);
	    PlayerTextDrawShow(playerid, GSEND[playerid]);
	    TextDrawShowForPlayer(playerid, TUTUPHP);
	    SelectTextDraw(playerid, COLOR_BLUE);
	}
	if(clickedid == DARKWEB)
	{
        //ShowPlayerDialog(playerid, DIALOG_IBANK, DIALOG_STYLE_LIST, "{6688FF}HoliBank", "Cek Saldo\nTransfer Uang", "Pilih", "Batal");
	}
	if(clickedid == TWITTER)
	{
		SimpanHp(playerid);
	    for(new u = 0; u < 4; u++)
        {
			PlayerTextDrawShow(playerid, TWEETAPP[playerid][u]);
	    }
	    for(new i = 0; i < 21; i++)
		{
			TextDrawShowForPlayer(playerid, PhoneTD[i]);
		}
	    PlayerTextDrawShow(playerid, TWEET[playerid]);
	    PlayerTextDrawShow(playerid, TDAFTAR[playerid]);
	    PlayerTextDrawShow(playerid, TLOGOUT[playerid]);
	    PlayerTextDrawShow(playerid, TLOGIN[playerid]);
	    PlayerTextDrawShow(playerid, TWELCOME[playerid]);
	    TextDrawShowForPlayer(playerid, TUTUPHP);
	    SelectTextDraw(playerid, COLOR_BLUE);
	}
	if(clickedid == KONTAK)
	{
		SimpanHp(playerid);
	    for(new u = 0; u < 3; u++)
        {
			PlayerTextDrawShow(playerid, KONTAKAPP[playerid][u]);
	    }
	    for(new i = 0; i < 21; i++)
		{
			TextDrawShowForPlayer(playerid, PhoneTD[i]);
		}
	    PlayerTextDrawShow(playerid, KONTAKBARU[playerid]);
	    PlayerTextDrawShow(playerid, DAFTARKONTAK[playerid]);
	    TextDrawShowForPlayer(playerid, TUTUPHP);
	    SelectTextDraw(playerid, COLOR_BLUE);
	}
	if(clickedid == WHATSAPP)
	{
		ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "Executive - Sms", "Masukan nomor yang akan anda kirimkan:", "Kirim", "Kembali");
	}
	if(clickedid == CALL)
	{
		InfoMsg(playerid, "Fitur telepon dalam perbaikan");
	}
    //BAJU SYSTEM Aufa
	if(clickedid == BajuTD[1])//exit
	{
	    SetPlayerSkin(playerid, pData[playerid][pSkin]);
        for(new i = 0; i < 17; i++)
		{
			TextDrawHideForPlayer(playerid, BajuTD[i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(clickedid == BajuTD[2])//baju
	{
	    TextDrawShowForPlayer(playerid, BajuTD[4]);
		TextDrawShowForPlayer(playerid, BajuTD[5]);
		TextDrawShowForPlayer(playerid, BajuTD[6]);
		TextDrawShowForPlayer(playerid, BajuTD[7]);
		TextDrawShowForPlayer(playerid, BajuTD[13]);
		TextDrawShowForPlayer(playerid, BajuTD[14]);
		TextDrawShowForPlayer(playerid, BajuTD[15]);
		TextDrawShowForPlayer(playerid, BajuTD[16]);
	}
	if(clickedid == BajuTD[3])//aksesoris
	{
	    for(new i = 0; i < 17; i++)
		{
			TextDrawHideForPlayer(playerid, BajuTD[i]);
		}
		CancelSelectTextDraw(playerid);
	    new string[248];
		if(pToys[playerid][0][toy_model] == 0)
		{
			strcat(string, ""dot"Slot 1\n");
		}
		else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

		if(pToys[playerid][1][toy_model] == 0)
		{
			strcat(string, ""dot"Slot 2\n");
		}
		else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

		if(pToys[playerid][2][toy_model] == 0)
		{
			strcat(string, ""dot"Slot 3\n");
		}
		else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

		if(pToys[playerid][3][toy_model] == 0)
		{
			strcat(string, ""dot"Slot 4\n");
		}
		else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");
		ShowPlayerDialog(playerid, DIALOG_TOYBUY, DIALOG_STYLE_LIST, "Executive - Aksesoris", string, "Pilih", "Batal");
	}
	if(clickedid == BajuTD[4])//kiri
	{
	    cskin[playerid]--;
 		if(pData[playerid][pGender] == 1)
  		{
   			if(cskin[playerid] < 0) cskin[playerid] = sizeof PedMan - 1;
    		SetPlayerSkin(playerid, PedMan[cskin[playerid]]);
		}
		else
		{
			if(cskin[playerid] < 0) cskin[playerid] = sizeof PedMale - 1;
			SetPlayerSkin(playerid, PedMale[cskin[playerid]]);
		}
		return 1;
	}
	if(clickedid == BajuTD[5])//kanan
	{
	    cskin[playerid]++;
   		if(pData[playerid][pGender] == 1)
    	{
   			if(cskin[playerid] >= sizeof PedMan) cskin[playerid] = 0;
			SetPlayerSkin(playerid, PedMan[cskin[playerid]]);
		}
		else
		{
			if(cskin[playerid] >= sizeof PedMale) cskin[playerid] = 0;
			SetPlayerSkin(playerid, PedMale[cskin[playerid]]);
		}
		return 1;
	}
	if(clickedid == BajuTD[6])//beli
	{
	    pData[playerid][pSkin] = GetPlayerSkin(playerid);
        GivePlayerMoneyEx(playerid, -100);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s telah membeli baju seharga $100 <", ReturnName(playerid));
        ShowItemBox(playerid, "Uang", "Removed_$100", 1212, 3);
    	TextDrawHideForPlayer(playerid, BajuTD[4]);
		TextDrawHideForPlayer(playerid, BajuTD[5]);
		TextDrawHideForPlayer(playerid, BajuTD[6]);
		TextDrawHideForPlayer(playerid, BajuTD[7]);
		TextDrawHideForPlayer(playerid, BajuTD[13]);
		TextDrawHideForPlayer(playerid, BajuTD[14]);
		TextDrawHideForPlayer(playerid, BajuTD[15]);
		TextDrawHideForPlayer(playerid, BajuTD[16]);
		return 1;
	}
	if(clickedid == BajuTD[7])//exit
	{
	    SetPlayerSkin(playerid, pData[playerid][pSkin]);
	    TextDrawHideForPlayer(playerid, BajuTD[4]);
		TextDrawHideForPlayer(playerid, BajuTD[5]);
		TextDrawHideForPlayer(playerid, BajuTD[6]);
		TextDrawHideForPlayer(playerid, BajuTD[7]);
		TextDrawHideForPlayer(playerid, BajuTD[13]);
		TextDrawHideForPlayer(playerid, BajuTD[14]);
		TextDrawHideForPlayer(playerid, BajuTD[15]);
		TextDrawHideForPlayer(playerid, BajuTD[16]);
	}
	if(clickedid == NoMarket[8]) 
	{
	    for(new i = 0; i < 32; i++)
		{
			TextDrawHideForPlayer(playerid, NoMarket[i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(clickedid == NoMarket[1])
	{
	    static bizid = -1, price;
	    
	    if((bizid = pData[playerid][pInBiz]) != -1)
		{
			price = bData[bizid][bP][0];
			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Anda tidak memiliki uang!");

            if(price == 0)
				return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

			if(bData[bizid][bProd] < 1)
				return ErrorMsg(playerid, "Produk ini habis!");

			if(pData[playerid][pSprunk] > 15) return ErrorMsg(playerid, "Anda tidak bisa membeli lebih dari 15");

			GivePlayerMoneyEx(playerid, -price);
			pData[playerid][pSprunk]++;
			ShowItemBox(playerid, "Water", "Received_1x", 2958, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s membeli water seharga %s.", ReturnName(playerid), FormatMoney(price));
			bData[bizid][bProd]--;
			bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
			mysql_tquery(g_SQL, query);
		}
	}
	if(clickedid == NoMarket[2])
	{
	    static bizid = -1, price;

	    if((bizid = pData[playerid][pInBiz]) != -1)
		{
			price = bData[bizid][bP][4];
			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Anda tidak memiliki uang!");

            if(price == 0)
				return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

			if(bData[bizid][bProd] < 1)
				return ErrorMsg(playerid, "Produk ini habis!");

            if(pData[playerid][pSnack] > 15) return ErrorMsg(playerid, "Anda tidak bisa membeli lebih dari 15");

			GivePlayerMoneyEx(playerid, -price);
			pData[playerid][pSnack]++;
			ShowItemBox(playerid, "Snack", "Received_1x", 2821, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s membeli Snack seharga %s.", ReturnName(playerid), FormatMoney(price));
			bData[bizid][bProd]--;
			bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
			mysql_tquery(g_SQL, query);
		}
	}
	if(clickedid == NoMarket[4])
	{
	    static bizid = -1, price;

	    if((bizid = pData[playerid][pInBiz]) != -1)
		{
			price = bData[bizid][bP][6];
			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Anda tidak memiliki uang!");

            if(price == 0)
				return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

			if(bData[bizid][bProd] < 1)
				return ErrorMsg(playerid, "Produk ini habis!");

            if(pData[playerid][pCappucino] > 15) return ErrorMsg(playerid, "Anda tidak bisa membeli lebih dari 15");

			GivePlayerMoneyEx(playerid, -price);
			pData[playerid][pCappucino]++;
			ShowItemBox(playerid, "Cappucino", "Received_1x", 19835, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s membeli Cappucino seharga %s.", ReturnName(playerid), FormatMoney(price));
			bData[bizid][bProd]--;
			bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
			mysql_tquery(g_SQL, query);
		}
	}
	/*if(clickedid == MarketIndoSans[6])
	{
	    static bizid = -1, price;

	    if((bizid = pData[playerid][pInBiz]) != -1)
		{
			price = bData[bizid][bP][2];
			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Anda tidak memiliki uang!");

            if(price == 0)
				return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

			if(bData[bizid][bProd] < 1)
				return ErrorMsg(playerid, "Produk ini habis!");

            if(pData[playerid][pKebab] > 15) return ErrorMsg(playerid, "Anda tidak bisa membeli lebih dari 15");

			GivePlayerMoneyEx(playerid, -price);
			pData[playerid][pKebab]++;
			ShowItemBox(playerid, "Kebab", "Received_1x", 2769, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s membeli Kebab seharga %s.", ReturnName(playerid), FormatMoney(price));
			bData[bizid][bProd]--;
			bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
			mysql_tquery(g_SQL, query);
		}
	}*/
	if(clickedid == NoMarket[5])
	{
	    static bizid = -1, price;

	    if((bizid = pData[playerid][pInBiz]) != -1)
		{
			price = bData[bizid][bP][1];
			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Anda tidak memiliki uang!");

            if(price == 0)
				return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

			if(bData[bizid][bProd] < 1)
				return ErrorMsg(playerid, "Produk ini habis!");

            if(pData[playerid][pMilxMax] > 15) return ErrorMsg(playerid, "Anda tidak bisa membeli lebih dari 15");

			GivePlayerMoneyEx(playerid, -price);
			pData[playerid][pMilxMax]++;
			ShowItemBox(playerid, "Milx_Max", "Received_1x", 19570, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s membeli MilxMax seharga %s.", ReturnName(playerid), FormatMoney(price));
			bData[bizid][bProd]--;
			bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
			mysql_tquery(g_SQL, query);
		}
	}
	if(clickedid ==  NoMarket[3])
	{
	    static bizid = -1, price;

	    if((bizid = pData[playerid][pInBiz]) != -1)
		{
			price = bData[bizid][bP][5];
			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Anda tidak memiliki uang!");

            if(price == 0)
				return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

			if(bData[bizid][bProd] < 1)
				return ErrorMsg(playerid, "Produk ini habis!");

            if(pData[playerid][pStarling] > 15) return ErrorMsg(playerid, "Anda tidak bisa membeli lebih dari 15");

			GivePlayerMoneyEx(playerid, -price);
			pData[playerid][pStarling]++;
			ShowItemBox(playerid, "Starling", "Received_1x", 1455, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s membeli minuman Starling seharga %s.", ReturnName(playerid), FormatMoney(price));
			bData[bizid][bProd]--;
			bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
			mysql_tquery(g_SQL, query);
		}
	}
	if(clickedid == NoMarket[7])
	{
	    static bizid = -1, price;

	    if((bizid = pData[playerid][pInBiz]) != -1)
		{
	 		price = bData[bizid][bP][3];
			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Anda tidak memiliki uang!");
				
            if(price == 0)
				return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

			if(bData[bizid][bProd] < 1)
				return ErrorMsg(playerid, "Produk ini habis!");

            if(pData[playerid][pRoti] > 15) return ErrorMsg(playerid, "Anda tidak bisa membeli lebih dari 15");

			GivePlayerMoneyEx(playerid, -price);
			pData[playerid][pRoti]++;
			ShowItemBox(playerid, "Roti", "Received_1x", 19883, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s telah membeli Roti seharga %s.", ReturnName(playerid), FormatMoney(price));
			bData[bizid][bProd]--;
			bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
			mysql_tquery(g_SQL, query);
		}
	}
	if(clickedid == SpawnTD[1]) // Terminal
	{
		pData[playerid][PilihSpawn] = 2;
        InterpolateCameraPos(playerid, -644.3238,-484.9586,51.7151, -553.3467,-525.7678,44.5802, 3000);
		InterpolateCameraLookAt(playerid, -644.3238,-484.9586,51.7151, -553.3467,-525.7678,44.5802, 3000);
		TextDrawShowForPlayer(playerid, SpawnTD[14]);
		TextDrawShowForPlayer(playerid, SpawnTD[5]);
	}
	if(clickedid == SpawnTD[2]) // BANDARA
	{
		pData[playerid][PilihSpawn] = 1;
        InterpolateCameraPos(playerid, 1717.2083,-2250.4700,13.3828, 1676.7021,-2260.7058,13.5363, 3000);
		InterpolateCameraLookAt(playerid, 1717.2083,-2250.4700,13.3828, 1676.7021,-2260.7058,13.5363, 3000);
        TextDrawShowForPlayer(playerid, SpawnTD[14]);
		TextDrawShowForPlayer(playerid, SpawnTD[5]);
	}
	if(clickedid == SpawnTD[3]) // PELABUHAN
	{
		pData[playerid][PilihSpawn] = 5;
        InterpolateCameraPos(playerid, 2740.1541,-2440.6343,13.6432, 2771.3376,-2437.4644,13.6377, 3000);
		InterpolateCameraLookAt(playerid, 2740.1541,-2440.6343,13.6432, 2771.3376,-2437.4644,13.6377, 3000);
		TextDrawShowForPlayer(playerid, SpawnTD[14]);
		TextDrawShowForPlayer(playerid, SpawnTD[5]);
	}
	if(clickedid == SpawnTD[4]) // ORGANISASI
	{
	    if(pData[playerid][pFaction] == 0) return ErrorMsg(playerid, "Anda belum bergabung di organisasi manapun");
		pData[playerid][PilihSpawn] = 4;
        InterpolateCameraPos(playerid, 698.826049, -1404.027099, 16.206615, 2045.292480, -1425.237182, 128.337753, 60000);
		InterpolateCameraLookAt(playerid, 703.825317, -1404.041992, 16.120681, 2050.291992, -1425.306762, 128.361190, 50000);
		TextDrawShowForPlayer(playerid, SpawnTD[14]);
		TextDrawShowForPlayer(playerid, SpawnTD[5]);
	}
	if(clickedid == SpawnTD[16]) // LOKASI TERAKHIR
	{
		pData[playerid][PilihSpawn] = 3;
		InterpolateCameraPos(playerid, 1058.544433, -1086.021362, 83.586357, 595.605712, -1334.382934, 89.737655, 10000);
		InterpolateCameraLookAt(playerid, 1055.534057, -1082.029296, 83.555107, 590.985107, -1332.492675, 89.460456, 10000);
		TextDrawShowForPlayer(playerid, SpawnTD[14]);
		TextDrawShowForPlayer(playerid, SpawnTD[5]);
	}
	if(clickedid == SpawnTD[5]) // MENDARAT BANDARA
	{
	    if(pData[playerid][PilihSpawn] == 0) // GAK MILIH
	    return ErrorMsg(playerid, "Anda belum memilih tempat mendarat");
	    
	    if(pData[playerid][PilihSpawn] == 1)
	    {
			pData[playerid][PilihSpawn] = 0;
			SetPlayerPos(playerid, 1750.5931,-2515.8118,13.5969);
			SetPlayerFacingAngle(playerid, 178.455139);
			SetCameraBehindPlayer(playerid);
			SetPlayerVirtualWorld(playerid, 0);
   			SetPlayerInterior(playerid, 0);
			SuccesMsg(playerid, "Anda Spawn Di Bandara Executive");
			TogglePlayerControllable(playerid, 1);
            PlayerData[playerid][pPos][0] = 1750.5931,
			PlayerData[playerid][pPos][1] =-2515.8118,
			PlayerData[playerid][pPos][2] = 13.5969;
			PlayerData[playerid][pPos][3] = 178.455139;
			InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
		}
		else if(pData[playerid][PilihSpawn] == 2)
	    {
	        pData[playerid][PilihSpawn] = 0;
		    SetPlayerPos(playerid, -603.9959,-471.3341,25.6234);
		    SetPlayerFacingAngle(playerid, 85.07);
		    SuccesMsg(playerid, "Anda Spawn Di Terminal Bus Executive");
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 1);
			SetPlayerVirtualWorld(playerid, 0);
   			SetPlayerInterior(playerid, 0);
   			PlayerData[playerid][pPos][0] = -603.9959,
			PlayerData[playerid][pPos][1] = -471.3341,
			PlayerData[playerid][pPos][2] = 25.6234;
			PlayerData[playerid][pPos][3] = 85.07;
			InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
		}
		else if(pData[playerid][PilihSpawn] == 5)
	    {
	        pData[playerid][PilihSpawn] = 0;
		    SetPlayerPos(playerid, 2823.21,-2440.34,12.08);
		    SetPlayerFacingAngle(playerid, 85.07);
		    SuccesMsg(playerid, "Anda Spawn Di Pelabuhan Executive");
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 1);
			SetPlayerVirtualWorld(playerid, 0);
   			SetPlayerInterior(playerid, 0);
   			PlayerData[playerid][pPos][0] = 2823.21,
			PlayerData[playerid][pPos][1] = -2440.34,
			PlayerData[playerid][pPos][2] = 12.08;
			PlayerData[playerid][pPos][3] = 85.07;
			InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
		}
		else if(pData[playerid][PilihSpawn] == 4)
	    {
	        if(pData[playerid][pFaction] == 1)
	        {
		        pData[playerid][PilihSpawn] = 0;
			    SetPlayerPos(playerid, 1300.503417,-1358.428710,15.476866);
			    SetPlayerFacingAngle(playerid, 355.460937);
			    SuccesMsg(playerid, "Anda Spawn Di Kepolisian Executive");
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
				SetPlayerVirtualWorld(playerid, 0);
	   			SetPlayerInterior(playerid, 0);
	   			PlayerData[playerid][pPos][0] = 1300.503417,
				PlayerData[playerid][pPos][1] = -1358.428710,
				PlayerData[playerid][pPos][2] = 15.476866;
				PlayerData[playerid][pPos][3] = 355.460937;
				InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
			}
			if(pData[playerid][pFaction] == 2)
	        {
		        pData[playerid][PilihSpawn] = 0;
		        InfoMsg(playerid, "Dalam pengembangan..");
			}
			if(pData[playerid][pFaction] == 3)
	        {
		        pData[playerid][PilihSpawn] = 0;
			    SetPlayerPos(playerid, 731.039245,-1437.234619,13.823826);
			    SetPlayerFacingAngle(playerid, 270.832824);
			    SuccesMsg(playerid, "Anda Spawn Di Rumah Sakit Executive");
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
				SetPlayerVirtualWorld(playerid, 0);
	   			SetPlayerInterior(playerid, 0);
	   			PlayerData[playerid][pPos][0] = 731.039245,
				PlayerData[playerid][pPos][1] = -1437.234619,
				PlayerData[playerid][pPos][2] = 13.823826;
				PlayerData[playerid][pPos][3] = 270.832824;
				InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
			}
			if(pData[playerid][pFaction] == 4)
	        {
		        pData[playerid][PilihSpawn] = 0;
		        InfoMsg(playerid, "Dalam pengembangan..");
			}
			if(pData[playerid][pFaction] == 5)
	        {
		        pData[playerid][PilihSpawn] = 0;
			    SetPlayerPos(playerid, 1325.951171,-862.046752,39.726036);
			    SetPlayerFacingAngle(playerid, 85.081848);
			    SuccesMsg(playerid, "Anda Spawn Di Pedagang Executive");
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, 1);
				SetPlayerVirtualWorld(playerid, 0);
	   			SetPlayerInterior(playerid, 0);
	   			PlayerData[playerid][pPos][0] = 1325.951171,
				PlayerData[playerid][pPos][1] = -862.046752,
				PlayerData[playerid][pPos][2] = 39.726036;
				PlayerData[playerid][pPos][3] = 85.081848;
				InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
			}
		}

		else if(pData[playerid][PilihSpawn] == 3)
	    {
	        pData[playerid][PilihSpawn] = 0;
		    SetPlayerInterior(playerid, pData[playerid][pInt]);
			SetPlayerVirtualWorld(playerid, pData[playerid][pWorld]);
			SetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
			SetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 0);
			SetPlayerSpawn(playerid);
			LoadAnims(playerid);
			PlayerData[playerid][pPos][0] = pData[playerid][pPosX],
			PlayerData[playerid][pPos][1] = pData[playerid][pPosY],
			PlayerData[playerid][pPos][2] = pData[playerid][pPosZ];
			PlayerData[playerid][pPos][3] = pData[playerid][pPosA];
			InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
		}
			for(new i = 0; i < 22; i++)
			{
				TextDrawHideForPlayer(playerid, SpawnTD[i]);
				CancelSelectTextDraw(playerid);
			}
			SetTimerEx("SetPlayerCameraBehind", 2500, false, "i", playerid);
	}
	return 1;
}
function SetPlayerCameraBehind(playerid)
{
	SetCameraBehindPlayer(playerid);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{7fffd4}Login Sukses - Kota Executive", "{ffffff}Ingat ini adalah server Roleplay.\nMohon selalu beroleplay\n\nSilahkan Klik "YELLOW_E"SPAWN {ffffff} untuk mulai beroleplay\n\n\n"RED_E"Tambahan: {ffffff}server ini menggunakan "YELLOW_E"sistem voice only {ffffff} dilarang keras bisu atau tuli", "Spawn", "Tidak");
}
function SetPlayerCameraBehindAyam(playerid)
{
	SetCameraBehindPlayer(playerid);
}
stock RefreshVModel(playerid)
{

    return 1;
}

stock RefreshPSkin(playerid)
{

    return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == SpawnMale)
	{
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 2823.21,-2440.34,12.08,85.07, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
		}
	}
	
	if(listid == SpawnFemale)
	{
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 2823.21,-2440.34,12.08,85.07, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
		}
   }

   //Locker Faction Skin
	if(listid == SAPDMale)
	{
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
	}
	
	if(listid == SAPDFemale)
	{
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
	}

	if(listid == SAPDWar)
	{
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
	}

	if(listid == SAGSMale)
	{
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
	}

	if(listid == SAGSFemale)
	{
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
	}

	if(listid == SAMDMale)
	{
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
	}

	if(listid == SAMDFemale)
	{
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
	}

	if(listid == SANEWMale)
	{
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
	}

	if(listid == SANEWFemale)
	{
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
	}
	if(listid == MaleSkins)
	{
		if(response)
		{
			new bizid = pData[playerid][pInBiz], price;
			price = bData[bizid][bP][0];
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			GivePlayerMoneyEx(playerid, -price);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli pakaian ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
			bData[bizid][bProd]--;
			bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);
			Bisnis_Save(bizid);
			SuccesMsg(playerid, "Anda telah membeli pakaian baru");
		}
		else return Info(playerid, "Anda tidak jadi membeli pakaian");
	}

	if(listid == FemaleSkins)
	{
		if(response)
		{
			new bizid = pData[playerid][pInBiz], price;
			price = bData[bizid][bP][0];
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			GivePlayerMoneyEx(playerid, -price);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
			bData[bizid][bProd]--;
			bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);
			Bisnis_Save(bizid);
			SuccesMsg(playerid, "Anda telah membeli pakaian baru");
		}
		else return Info(playerid, "Anda tidak jadi membeli pakaian");
	}
	if(listid == VIPMaleSkins)
	{
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengganti skin ID %d.", ReturnName(playerid), modelid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
	}

	if(listid == VIPFemaleSkins)
	{
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d.", ReturnName(playerid), modelid);
			SuccesMsg(playerid, "Anda telah membeli pakaian baru");
		}
		else return Servers(playerid, "Canceled buy skin");
	}
	if(listid == VIPMaleSkins)
	{
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengganti skin ID %d.", ReturnName(playerid), modelid);
			SuccesMsg(playerid, "Anda telah membeli pakaian baru");
		}
		else return Servers(playerid, "Canceled buy skin");
	}

	if(listid == VIPFemaleSkins)
	{
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d.", ReturnName(playerid), modelid);
			SuccesMsg(playerid, "Anda telah membeli pakaian baru");
		}
		else return Servers(playerid, "Canceled buy skin");
	}
	if(listid == toyslist)
	{
		if(response)
		{
			new bizid = pData[playerid][pInBiz], price;
			price = bData[bizid][bP][1];
			
			GivePlayerMoneyEx(playerid, -price);
			if(pData[playerid][PurchasedToy] == false) MySQL_CreatePlayerToy(playerid);
			pToys[playerid][pData[playerid][toySelected]][toy_model] = modelid;
			pToys[playerid][pData[playerid][toySelected]][toy_status] = 1;
			new finstring[750];
			strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
			strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");
			ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""WHITE_E"Select Bone", finstring, "Pilih", "Batal");
			
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s telah membeli aksesoris seharga %s <", ReturnName(playerid), FormatMoney(price));
			bData[bizid][bProd]--;
			bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);
			new str[500];
			format(str, sizeof(str), "Removed_%s", FormatMoney(price));
			ShowItemBox(playerid, "Uang", str, 1212, 2);
            SuccesMsg(playerid, "Anda telah membeli aksesoris baru");
			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
			mysql_tquery(g_SQL, query);
		}
		else return ErrorMsg(playerid, "Batal membeli aksesoris");
	}

	//modshop
	if(listid == TransFender)
	{
		if(response)
        {
            new
            price = 5000,
            vehicleid
            ;

            if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
                return Error(playerid, "You need to be inside vehicle as driver");

            vehicleid = Vehicle_Nearest(playerid);

            if(vehicleid == -1)
                return 0;

            Vehicle_ObjectAddObjects(playerid, vehicleid, modelid, OBJECT_TYPE_BODY);

            SendClientMessageEx(playerid, COLOR_ARWIN,"MODSHOP: "WHITE_E"You have purchased a {00FFFF}%s "WHITE_E"for "GREEN_E"$%s.", GetVehObjectNameByModel(modelid), FormatMoney(price));
        }
	}

	if(listid == Waa)
	{
		if(response)
        {
            new
            price = 5000,
            vehicleid
            ;

            if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
                return Error(playerid, "You need to be inside vehicle as driver");

            vehicleid = Vehicle_Nearest(playerid);

            if(vehicleid == -1)
                return 0;

            Vehicle_ObjectAddObjects(playerid, vehicleid, modelid, OBJECT_TYPE_BODY);

            SendClientMessageEx(playerid, COLOR_ARWIN,"MODSHOP: "WHITE_E"You have purchased a {00FFFF}%s "WHITE_E"for "GREEN_E"$%s.", GetVehObjectNameByModel(modelid), FormatMoney(price));
        }
	}

	if(listid == LoCo)
	{
		if(response)
        {
            new
            price = 5000,
            vehicleid
            ;

            if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
                return Error(playerid, "You need to be inside vehicle as driver");

            vehicleid = Vehicle_Nearest(playerid);

            if(vehicleid == -1)
                return 0;

            Vehicle_ObjectAddObjects(playerid, vehicleid, modelid, OBJECT_TYPE_BODY);

            SendClientMessageEx(playerid, COLOR_ARWIN,"MODSHOP: "WHITE_E"You have purchased a {00FFFF}%s "WHITE_E"for "GREEN_E"$%s.", GetVehObjectNameByModel(modelid), FormatMoney(price));
        }
	}

	if(listid == viptoyslist)
	{
		if(response)
		{
			if(pData[playerid][PurchasedToy] == false) MySQL_CreatePlayerToy(playerid);
			pToys[playerid][pData[playerid][toySelected]][toy_model] = modelid;
			pToys[playerid][pData[playerid][toySelected]][toy_status] = 1;
			new finstring[750];
			strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
			strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");
			ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""WHITE_E"Select Bone", finstring, "Pilih", "Batal");
			
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil object ID %d dilocker.", ReturnName(playerid), modelid);
		}
		else return Servers(playerid, "Canceled toys");
	}
	if(listid == PDGSkinMale)
	{
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
			RefreshPSkin(playerid);
		}
	}

	if(listid == PDGSkinFemale)
	{
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
			RefreshPSkin(playerid);
		}
	}

	if(listid == vtoylist)
	{
		if(response)
		{
			new x = pData[playerid][VehicleID], Float:vPosx, Float:vPosy, Float:vPosz;
			GetVehiclePos(x, vPosx, vPosy, vPosz);
			foreach(new i: PVehicles)
			if(x == pvData[i][cVeh])
			{
				new vehid = pvData[i][cVeh];
				new toyslotid = pvData[vehid][vtoySelected];
				vtData[vehid][toyslotid][vtoy_modelid] = modelid;

				if(pvData[vehid][PurchasedvToy] == false) 			// Cek kalo gada database di mysql auto di buat
				{
					MySQL_CreateVehicleToy(i);
				}

				printf("VehicleID: %d, Object: %d, Pos: (%f ,%f, %f), ToySlotID: %d", vehid, vtData[vehid][toyslotid][vtoy_modelid], vPosx, vPosy, vPosz, toyslotid);

				vtData[vehid][toyslotid][vtoy_model] = CreateObject(modelid, vPosx, vPosy, vPosz, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(vtData[vehid][toyslotid][vtoy_model], vehid, vtData[vehid][toyslotid][vtoy_x], vtData[vehid][toyslotid][vtoy_y], vtData[vehid][toyslotid][vtoy_z], vtData[vehid][toyslotid][vtoy_rx], vtData[vehid][toyslotid][vtoy_ry], vtData[vehid][toyslotid][vtoy_rz]);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memasang toys untuk vehicleid(%d) object ID %d", ReturnName(playerid), vehid, modelid);
				ShowPlayerDialog(playerid, DIALOG_MODTACCEPT, DIALOG_STYLE_MSGBOX, "Vehicle Toys", "Do You Want To Save it?", "Yes", "Batal");
			}
		}
		else return Servers(playerid, "Canceled buy toys");
	}
	return 1;
}
stock DisplayDokumen(playerid)
{
    new ktpstatus[36];
	if(pData[playerid][pIDCard] == 1)
	{
		format(ktpstatus, 36, ""LG_E"Ada");
	}
	else
	{
		format(ktpstatus, 36, ""RED_E"Tidak");
	}

	new simstatus[36];
	if(pData[playerid][pDriveLic] == 1)
	{
		format(simstatus, 36, ""LG_E"Ada");
	}
	else
	{
		format(simstatus, 36, ""RED_E"Tidak");
	}
	
	new weaponstatus[36];
	if(pData[playerid][pWeaponLic] == 1)
	{
		format(weaponstatus, 36, ""LG_E"Ada");
	}
	else
	{
		format(weaponstatus, 36, ""RED_E"Tidak");
	}
	new string[2048];
	format(string, sizeof(string),"Kartu Tanda Penduduk\t[%s]\nSurat Izin Mengemudi\t[%s]\nLisensi Senjata\t[%s]",
    ktpstatus,
	simstatus,
	weaponstatus);
	ShowPlayerDialog(playerid, DIALOG_DOKUMEN, DIALOG_STYLE_LIST, "Executive - Dokumen", string, "Tutup","");
}

forward TambahDetikFivEM();
public TambahDetikFivEM()
{
	DetikFivEm ++;

	if(DetikFivEm == 60)
	{
		DetikFivEm = 0;
		TambahJamFivEm();
	}

	SetWorldTime(JamFivEm);
}

forward TambahJamFivEm();
public TambahJamFivEm()
{
	JamFivEm ++;

	if(JamFivEm == 24)
	{
		JamFivEm = 0;
	}

	SetWorldTime(JamFivEm);
}

stock GetMonthName(months)
{
    new monthname_str[10];

	switch(months)
	{
		case 1: monthname_str = "Januari";
		case 2: monthname_str = "Februari";
		case 3: monthname_str = "Maret";
		case 4: monthname_str = "April";
		case 5: monthname_str = "Mei";
		case 6: monthname_str = "Juni";
		case 7: monthname_str = "Juli";
		case 8: monthname_str = "Augustus";
		case 9: monthname_str = "September";
		case 10: monthname_str = "Oktober";
		case 11: monthname_str = "November";
		case 12: monthname_str = "Desember";
	}

	return monthname_str;
}

function PunyaSpotify(playerid)
{
	if(pData[playerid][pInstallMap])
	{
	    TextDrawShowForPlayer(playerid, MUSIC);
	    PlayerTextDrawShow(playerid, APKLOGO[playerid][8]);
	    TextDrawShowForPlayer(playerid, APKNAME[8]);
	}
	else
	{
 		TextDrawHideForPlayer(playerid, MUSIC);
	    PlayerTextDrawHide(playerid, APKLOGO[playerid][8]);
	    TextDrawHideForPlayer(playerid, APKNAME[8]);
	}
}
function PunyaDarkWeb(playerid)
{
	if(pData[playerid][pInstallDweb])
	{
	    TextDrawShowForPlayer(playerid, DARKWEB);
	    PlayerTextDrawShow(playerid, APKLOGO[playerid][6]);
	    TextDrawShowForPlayer(playerid, APKNAME[6]);
	}
	else
	{
 		TextDrawHideForPlayer(playerid, DARKWEB);
	    PlayerTextDrawHide(playerid, APKLOGO[playerid][6]);
	    TextDrawHideForPlayer(playerid, APKNAME[6]);
	}
}
function PunyaMbanking(playerid)
{
	if(pData[playerid][pInstallBank])
	{
	    TextDrawShowForPlayer(playerid, MBANKING);
	    PlayerTextDrawShow(playerid, APKLOGO[playerid][4]);
	    TextDrawShowForPlayer(playerid, APKNAME[4]);
	}
	else
	{
 		TextDrawHideForPlayer(playerid, MBANKING);
	    PlayerTextDrawHide(playerid, APKLOGO[playerid][4]);
	    TextDrawHideForPlayer(playerid, APKNAME[4]);
	}
}
function PunyaTwitter(playerid)
{
	if(pData[playerid][pInstallTweet])
	{
	    TextDrawShowForPlayer(playerid, TWITTER);
	    PlayerTextDrawShow(playerid, APKLOGO[playerid][5]);
	    TextDrawShowForPlayer(playerid, APKNAME[5]);
	}
	else
	{
 		TextDrawHideForPlayer(playerid, TWITTER);
	    PlayerTextDrawHide(playerid, APKLOGO[playerid][5]);
	    TextDrawHideForPlayer(playerid, APKNAME[5]);
	}
}
function PunyaGojek(playerid)
{
	if(pData[playerid][pInstallGojek])
	{
	    TextDrawShowForPlayer(playerid, GOJEK);
	    PlayerTextDrawShow(playerid, APKLOGO[playerid][3]);
	    TextDrawShowForPlayer(playerid, APKNAME[3]);
	}
	else
	{
 		TextDrawHideForPlayer(playerid, GOJEK);
	    PlayerTextDrawHide(playerid, APKLOGO[playerid][3]);
	    TextDrawHideForPlayer(playerid, APKNAME[3]);
	}
}
function DownloadTweet(playerid)
{
	pData[playerid][pInstallTweet] = 1;
	SuccesMsg(playerid, "AppStore telah selesai menginstall Twitter");
	return 1;
}
function DownloadSpotify(playerid)
{
	pData[playerid][pInstallMap] = 1;
	SuccesMsg(playerid, "AppStore telah selesai menginstall Spotify");
	return 1;
}
function DownloadDarkWeb(playerid)
{
	pData[playerid][pInstallDweb] = 1;
	SuccesMsg(playerid, "AppStore telah selesai menginstall DarkWeb");
	return 1;
}
function DownloadBank(playerid)
{
	pData[playerid][pInstallBank] = 1;
	SuccesMsg(playerid, "AppStore telah selesai menginstall Mbanking");
	return 1;
}
function DownloadGojek(playerid)
{
	pData[playerid][pInstallGojek] = 1;
	SuccesMsg(playerid, "AppStore telah selesai menginstall Gojek");
	return 1;
}
function SedangKencing(playerid)
{
	pData[playerid][pKencing] = 0;
	InfoMsg(playerid, "Anda merasa lega.");
	ClearAnimations(playerid);
	StopLoopingAnim(playerid);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	return 1;
}
epublic: WaktuBerburu(playerid)
{
	ClearAnimations(playerid);
	InfoMsg(playerid, "Silahkan Melanjutkan Berburu");
	return 1;
}

epublic: WaktuBerburu1(playerid)
{
	ClearAnimations(playerid);
	PutRusa[playerid] = 1;
	SetPlayerCheckpoint(playerid, -280.6513, -2175.8017, 28.6393, 5);
	SetPlayerAttachedObject(playerid, 6, 19315, 3, 0.1, 0.1, -0.1, 0.0, 270.0, 0.0, 1, 1, 1);
	InfoMsg(playerid, "Kembali Ke Om Badak Untuk Menjual Rusa");
	return 1;
}

CMD:starthunter(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 5, -280.6513, -2175.8017, 28.6393))
	{
		if(JobHunter[playerid] != 0) return ErrorMsg(playerid, "Kamu Sudah Mulai Berburu");
		JobHunter[playerid] = 1;
		GivePlayerWeapon(playerid, 25, 5);
		SetPlayerCheckpoint(playerid, -515.0798, -2276.4099, 33.4140, 1);
	    SendClientMessage(playerid, COLOR_YELLOW, "Pergi Ke Tanda Merah Untuk Berburu");
	}
	return 1;
}

CMD:sellrusa(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 5, -280.6513, -2175.8017, 28.6393))
	{
		if(PutRusa[playerid] != 1) return ErrorMsg(playerid, "Kamu Tidak Membawa Rusa");
		RemovePlayerAttachedObject(playerid, 6);
		JobHunter[playerid] = 0;
		PutRusa[playerid] = 0;
		pData[playerid][pMoney] += 100;
	}
	return 1;
}
CMD:rusagerak(playerid, params[])
{
    MoveObject(rusa, -1934.440795,-2371.890136,30.826015, 3.5, -90.0000, 0.0000, 0.0000);
	return 1;
}
