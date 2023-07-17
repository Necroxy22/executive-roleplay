// COLOR DEFINE
#define 	WARNA_MERAH		"{FF0000}"
#define 	WARNA_KUNING	"{FFFF00}"
#define 	WARNA_BIRU		"{0099FF}"
#define 	WARNA_PUTIH		"{FFFFFF}"

// RADIO DEFINE
#define 	MAX_FREQUENSI	9999

// MESSAGE DEFINE
#define 	Info(%1,%2)		SendClientMessage(%1, -1, ""WARNA_BIRU"[INFO]: "WARNA_PUTIH""%2)
#define 	Error(%1,%2)	SendClientMessage(%1, -1, ""WARNA_MERAH"[ERROR]: "WARNA_PUTIH""%2)
#define 	Usage(%1,%2)	SendClientMessage(%1, -1, ""WARNA_KUNING"[USAGE]: "WARNA_PUTIH""%2)

// OTHER DEFINE
#define function%0(%1) forward %0(%1); public %0(%1)
#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

new SV_LSTREAM:localStream[MAX_PLAYERS] = SV_NULL;
new SV_GSTREAM:radioStream[MAX_FREQUENSI] = SV_NULL;

// SAVE SYSTEM (MYSQL)
#define     MYSQL_HOST      "localhost"
#define     MYSQL_USER      "root"
#define     MYSQL_PASS      ""
#define     MYSQL_DATA      "dewata"

new MySQL:voiceData;
