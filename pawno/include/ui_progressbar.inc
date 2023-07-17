/*
	Textdraw Builder : HAN
	Script Development : HAN
	Disocrd : Ecclesia#8555
/*
/////////////////////////////
/* Include */
#include <YSI\y_hooks>
/* var */
new PlayerText:PROGRESSBAR[MAX_PLAYERS][7];
new LoadingPlayerBar[MAX_PLAYERS];
new TimerLoading[MAX_PLAYERS];
new ProgressTimer[MAX_PLAYERS][128];
/* Hide TD */
HideProgressBar(playerid)
{
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][0]);
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][1]);
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][2]);
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][3]);
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][4]);
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][5]);
	PlayerTextDrawHide(playerid, PROGRESSBAR[playerid][6]);
	return 1;
}
/* Create TD */
CreateProgress(playerid)
{
	PROGRESSBAR[playerid][0] = CreatePlayerTextDraw(playerid, 273.000000, 364.000000, "ld_bum:blkdot");
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][0], 101.000000, 23.500000);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][0], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][0], 144);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, PROGRESSBAR[playerid][0], 0);

	PROGRESSBAR[playerid][1] = CreatePlayerTextDraw(playerid, 273.000000, 364.000000, "ld_bum:blkdot");
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][1], 101.000000, 23.500000);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][1], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][1], 566060031);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, PROGRESSBAR[playerid][1], 0);

	PROGRESSBAR[playerid][2] = CreatePlayerTextDraw(playerid, 323.000000, 370.000000, "MINUM");
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][2], 0.216664, 1.200000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][2], 406.500000, 98.000000);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][2], 1);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][2], 2);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][2], 0);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, PROGRESSBAR[playerid][2], 0);

	PROGRESSBAR[playerid][3] = CreatePlayerTextDraw(playerid, 273.000000, 363.000000, "ld_bum:blkdot");
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][3], 101.000000, 1.000000);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][3], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, PROGRESSBAR[playerid][3], 0);

	PROGRESSBAR[playerid][4] = CreatePlayerTextDraw(playerid, 272.000000, 363.000000, "ld_bum:blkdot");
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][4], 1.000000, 24.500000);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][4], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, PROGRESSBAR[playerid][4], 0);

	PROGRESSBAR[playerid][5] = CreatePlayerTextDraw(playerid, 272.000000, 387.000000, "ld_bum:blkdot");
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][5], 4);
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][5], 102.000000, 1.000000);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][5], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, PROGRESSBAR[playerid][5], 0);

	PROGRESSBAR[playerid][6] = CreatePlayerTextDraw(playerid, 374.000000, 363.000000, "ld_bum:blkdot");
	PlayerTextDrawFont(playerid, PROGRESSBAR[playerid][6], 4);
	PlayerTextDrawLetterSize(playerid, PROGRESSBAR[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][6], 1.000000, 24.500000);
	PlayerTextDrawSetOutline(playerid, PROGRESSBAR[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, PROGRESSBAR[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, PROGRESSBAR[playerid][6], 1);
	PlayerTextDrawColor(playerid, PROGRESSBAR[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, PROGRESSBAR[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, PROGRESSBAR[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, PROGRESSBAR[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, PROGRESSBAR[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, PROGRESSBAR[playerid][6], 0);
	return 1;
}
/* Hook OnPlayerConnect */
hook OnPlayerConnect(playerid)
{
	CreateProgress(playerid);
	return 1;
}
/* Func */
ShowProgressbar(playerid, text[] = "", Times)
{
	LoadingPlayerBar[playerid] = 0;
	pData[playerid][pProgress] = 1;
	new Float:Value = LoadingPlayerBar[playerid]*101/100;
	new Timer = Times*1000/100;
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][1], Value, 23.5);
	PlayerTextDrawSetString(playerid, PROGRESSBAR[playerid][2], text);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][0]);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][1]);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][2]);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][3]);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][4]);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][5]);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][6]);
	TogglePlayerControllable(playerid, 0);
	TimerLoading[playerid] = SetTimerEx("UpdtLoading", Timer, true, "d", playerid);
	return 1;
}

stock UpdateLoading(playerid)
{
	new Float:Value = LoadingPlayerBar[playerid]*101.0/100;
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][1], Value, 23.4);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][1]);
	return 1;
}

forward UpdtLoading(playerid);
public UpdtLoading(playerid)
{
	LoadingPlayerBar[playerid] += 1;
	UpdateLoading(playerid);
	if(LoadingPlayerBar[playerid] >= 100)
	{
		KillTimer(TimerLoading[playerid]);
		LoadingPlayerBar[playerid] = 0;
		pData[playerid][pProgress] = 0;
		HideProgressBar(playerid);
		SetTimerEx(ProgressTimer[playerid], 3000, false, "d", playerid);
		TogglePlayerControllable(playerid, 1);
	}
	return 1;
}
CMD:testprog(playerid, params[])
{
	ShowProgressbar(playerid, "Test aja", 3);
	return 1;
}