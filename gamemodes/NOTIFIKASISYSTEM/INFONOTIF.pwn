
// Notification system 1.0
// Creator: HPQ123#8114

//Tambahan dari hengker wolmo tiziyi, kalo mau digunakan includenya/ diaktifin  jadi notif pake yg dibawah ini
/*
notification.Show(playerid, "Judulnya", "Pesan Yang Mau Ditampilin", "Logo Disamping pesan");
*/
//Contoh penggunaan begini cuyyy
/*

CMD:ngocok
{
	notification.Show(playerid, "Info", "Kamu sedang ngocok");
}

*/

#define 	BOXCOLOR_GREEN		9109759
#define 	BOXCOLOR_BLUE       548580095
#define 	BOXCOLOR_RED		-1962934017

// * Settings * //
#define 	MAX_NOTIFY 		(6) // max show notofication
#define 	MAX_NT_STRING 	(320)
#define 	MAX_NT_TITLE 	(64)
#define 	SECONDS_NT 		(5)

enum ntInfo { ntIcon[32], ntTitle[MAX_NT_TITLE], ntMessage[MAX_NT_STRING], ntLines, ntColor }
static notifyInfo[MAX_PLAYERS][MAX_NOTIFY][ntInfo],
Text:notifyPTD[MAX_NOTIFY * 11],
notifyIndex[MAX_PLAYERS];

#define notify::%0(%1) forward %0(%1); public %0(%1)
#define InternalNotification_show InternalNotification_Show
#define notification.	InternalNotification_

static const TDTextCaracterWidth[] = {
	0,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
	12,12,12,12,12,12,12,13,13,28,28,28,28,8,17,17,30,28,28,12,9,21,28,14,28,28,
	28,28,28,28,28,28,13,13,30,30,30,30,10,25,23,21,24,22,20,24,24,17,20,22,20,
	30,27,27,26,26,24,23,24,31,23,31,24,23,21,28,33,33,14,28,10,11,12,9,11,10,
	10,12,12,7,7,13,5,18,12,10,12,11,10,12,8,13,13,18,17,13,12,30,30,37,35,37,
	25,25,25,25,33,21,24,24,24,24,17,17,17,17,27,27,27,27,31,31,31,31,11,11,11,
	11,11,20,9,10,10,10,10,7,7,7,7,10,10,10,10,13,13,13,13,27,12,30
};


// Get width for char //
stock getSizeMessage(const string:message[], maxWidth=500) {
	new size = 0, lines=1, i=-1, lastPoint = 0;

	while(message[++i]) {
		size += TDTextCaracterWidth[message[i]];

		switch(message[i]) {
			case ' ':
				lastPoint = i;

			default:
				if(size >= maxWidth)
					++lines,
					size -= maxWidth,
					size += i - lastPoint;
		}
	}
	return lines;
}

//main function for show notification
stock ShowInfo(const playerid, const string:message[], boxcolor)
{
	for(new x=-1;++x<notifyIndex[playerid];) {
		for(new i=-1;++i<11;) TextDrawHideForPlayer(playerid, notifyPTD[(x*11) + i]);
		notifyInfo[playerid][notifyIndex[playerid]-x] = notifyInfo[playerid][(notifyIndex[playerid]-x)-1];
	}

	strmid(notifyInfo[playerid][0][ntMessage], message, 0, MAX_NT_STRING);
	notifyInfo[playerid][0][ntColor] = boxcolor;
	notifyInfo[playerid][0][ntLines] = getSizeMessage(message);

	++notifyIndex[playerid];

	new Float:static_x=0.0;
	for(new x=-1;++x<notifyIndex[playerid];) {
		createNotifyTD(playerid, x, x * 11, static_x);
		static_x+=(notifyInfo[playerid][x][ntLines] * 19.5) + 1.0;
	}

	SetTimerEx(#destroy_notify, SECONDS_NT * 1000, false, #i, playerid);
	return 1;
}

// when the notification stops //
notify::destroy_notify(playerid) {
	if(!notifyIndex[playerid]) return 1;
	--notifyIndex[playerid];
	for(new i=-1;++i<11;) TextDrawHideForPlayer(playerid, notifyPTD[(notifyIndex[playerid]*11) + i]);
	return 1;
}

// display notification //
stock createNotifyTD(const playerid, index, i, const Float:static_x) {
	new lines = notifyInfo[playerid][index][ntLines],Float:x = (lines * 19.5) + static_x;
    new Float:posisibaru = x-1.0;
    
	notifyPTD[++i] = TextDrawCreate(406.000, 5.300+posisibaru, "LD_BEAT:chit");
	TextDrawTextSize(notifyPTD[i], 19.000, 22.000);
	TextDrawAlignment(notifyPTD[i], 1);
	TextDrawColor(notifyPTD[i], notifyInfo[playerid][index][ntColor]);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 255);
	TextDrawFont(notifyPTD[i], 4);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	notifyPTD[++i] = TextDrawCreate(522.000, 5.300+posisibaru, "LD_BEAT:chit");
	TextDrawTextSize(notifyPTD[i], 19.000, 22.000);
	TextDrawAlignment(notifyPTD[i], 1);
	TextDrawColor(notifyPTD[i], notifyInfo[playerid][index][ntColor]);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 255);
	TextDrawFont(notifyPTD[i], 4);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	notifyPTD[++i] = TextDrawCreate(415.000, 8.000+posisibaru, "LD_BUM:blkdot");
	TextDrawTextSize(notifyPTD[i], 117.000, 15.000);
	TextDrawAlignment(notifyPTD[i], 1);
	TextDrawColor(notifyPTD[i], notifyInfo[playerid][index][ntColor]);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 255);
	TextDrawFont(notifyPTD[i], 4);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	notifyPTD[++i] = TextDrawCreate(415.000, 12.000+posisibaru, "LD_BUM:blkdot");
	TextDrawTextSize(notifyPTD[i], 116.000, 12.000);
	TextDrawAlignment(notifyPTD[i], 1);
	TextDrawColor(notifyPTD[i], notifyInfo[playerid][index][ntColor]);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 255);
	TextDrawFont(notifyPTD[i], 4);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	notifyPTD[++i] = TextDrawCreate(479.000, 11.000+posisibaru, notifyInfo[playerid][index][ntMessage]);
	TextDrawLetterSize(notifyPTD[i], 0.200, 0.999);
	TextDrawAlignment(notifyPTD[i], 2);
	TextDrawColor(notifyPTD[i], -1);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 150);
	TextDrawFont(notifyPTD[i], 1);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	notifyPTD[++i] = TextDrawCreate(406.000, 4.300+posisibaru, "LD_BEAT:chit");
	TextDrawTextSize(notifyPTD[i], 19.000, 22.000);
	TextDrawAlignment(notifyPTD[i], 1);
	TextDrawColor(notifyPTD[i], notifyInfo[playerid][index][ntColor]);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 255);
	TextDrawFont(notifyPTD[i], 4);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	notifyPTD[++i] = TextDrawCreate(522.000, 4.300+posisibaru, "LD_BEAT:chit");
	TextDrawTextSize(notifyPTD[i], 19.000, 22.000);
	TextDrawAlignment(notifyPTD[i], 1);
	TextDrawColor(notifyPTD[i], notifyInfo[playerid][index][ntColor]);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 255);
	TextDrawFont(notifyPTD[i], 4);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	notifyPTD[++i] = TextDrawCreate(417.000, 11.000+posisibaru, "i");
	TextDrawLetterSize(notifyPTD[i], 0.200, 1.199);
	TextDrawAlignment(notifyPTD[i], 1);
	TextDrawColor(notifyPTD[i], -1);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 150);
	TextDrawFont(notifyPTD[i], 1);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	notifyPTD[++i] = TextDrawCreate(420.000, 10.000+posisibaru, "]");
	TextDrawLetterSize(notifyPTD[i], 0.200, 1.199);
	TextDrawAlignment(notifyPTD[i], 1);
	TextDrawColor(notifyPTD[i], -1);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 150);
	TextDrawFont(notifyPTD[i], 1);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);

	notifyPTD[++i] = TextDrawCreate(413.000, 10.000+posisibaru, "[");
	TextDrawLetterSize(notifyPTD[i], 0.200, 1.199);
	TextDrawAlignment(notifyPTD[i], 1);
	TextDrawColor(notifyPTD[i], -1);
	TextDrawSetShadow(notifyPTD[i], 0);
	TextDrawSetOutline(notifyPTD[i], 0);
	TextDrawBackgroundColor(notifyPTD[i], 150);
	TextDrawFont(notifyPTD[i], 1);
	TextDrawSetProportional(notifyPTD[i], 1);
	TextDrawShowForPlayer(playerid, notifyPTD[i]);
	return true;
}

public OnPlayerConnect(playerid)
{

	notifyIndex[playerid] = 0;

	#if defined NT_OnPlayerConnect
		return NT_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect NT_OnPlayerConnect
#if defined NT_OnPlayerConnect
	forward NT_OnPlayerConnect(playerid);
#endif
