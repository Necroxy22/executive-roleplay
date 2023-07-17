enum eNotify
{
	NotifyIcon,
	NotifyMessage[320],
	NotifySize
}
new InfoNotify[MAX_PLAYERS][7][eNotify];
new MaxPlayerNotify[MAX_PLAYERS];
new PlayerText:TextDrawNotifikasi[MAX_PLAYERS][7*10];
new PlayerText:TextDrawNotifikasiLoding[MAX_PLAYERS][7*10];
new IndexNotify[MAX_PLAYERS];
new LoadingNotif[MAX_PLAYERS];

function HideNotify(playerid)
{
	if(!IndexNotify[playerid]) return 1;
	--IndexNotify[playerid];
	MaxPlayerNotify[playerid]--;
	for(new i=-1;++i<10;) PlayerTextDrawDestroy(playerid, TextDrawNotifikasi[playerid][(IndexNotify[playerid]*10)+i]);
	for(new i=-1;++i<10;) PlayerTextDrawDestroy(playerid, TextDrawNotifikasiLoding[playerid][(IndexNotify[playerid]*10)+i]);
	return 1;
}
function NotifyLoadingUpdet(playerid)
{
	if(!IndexNotify[playerid]) return 1;
	for(new x=-1; ++x <IndexNotify[playerid];)
	{
		new Float:Value = LoadingNotif[playerid] * 109/110;
		for(new i=-1;++i<9;) PlayerTextDrawTextSize(playerid, TextDrawNotifikasiLoding[playerid][(x*10)+i], Value, -3.0);
		for(new i=-1;++i<9;) PlayerTextDrawShow(playerid, TextDrawNotifikasiLoding[playerid][(x*10)+i]);
	}
	return 1;
}
function NotifyLoading(playerid)
{
    for(new x=-1; ++x <IndexNotify[playerid];)
	{
	    LoadingNotif[x] -= 10;
		NotifyLoadingUpdet(x);
		if(LoadingNotif[x] <= 5)
		{
			LoadingNotif[x] = 109;
		}
	}
	return 1;
}
stock InfoMsg(playerid, pesan[])
{
  	if(IsPlayerAndroid(playerid))
	{
		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	}
	else
	{
		PlayerPlaySound(playerid, 5201, 0.0, 0.0, 0.0);
  	}
  	ShowNotify(playerid, pesan, 1);
  	return 1;
}
stock ErrorMsg(playerid, pesan[])
{
  	if(IsPlayerAndroid(playerid))
	{
		PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
	}
	else
	{
		PlayerPlaySound(playerid, 5206, 0.0, 0.0, 0.0);
	}
 	ShowNotify(playerid, pesan, 2);
 	return 1;
}
stock SuccesMsg(playerid, pesan[])
{
	if(IsPlayerAndroid(playerid))
	{
		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	}
	else
	{
		PlayerPlaySound(playerid, 5203, 0.0, 0.0, 0.0);
	}
  	ShowNotify(playerid, pesan, 3);
  	LoadingNotif[playerid] = 109;
  	return 1;
}
stock SyntaxMsg(playerid, pesan[])
{
  	if(IsPlayerAndroid(playerid))
	{
		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	}
	else
	{
		PlayerPlaySound(playerid, 5202, 0.0, 0.0, 0.0);
	}
  	ShowNotify(playerid, pesan, 4);
  	return 1;
}

stock WarningMsg(playerid, pesan[])
{
  	if(IsPlayerAndroid(playerid))
	{
		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	}
	else
	{
		PlayerPlaySound(playerid, 5202, 0.0, 0.0, 0.0);
	}
  	ShowNotify(playerid, pesan, 5);
  	return 1;
}

stock ShowNotify(const playerid, const string:message[], const icon)
{
	if(MaxPlayerNotify[playerid] == 5) return 1;
	MaxPlayerNotify[playerid]++;
	for(new x=-1; ++x <IndexNotify[playerid];)
	{
		for(new i=-1;++i<9;) PlayerTextDrawDestroy(playerid, TextDrawNotifikasi[playerid][(x*10) + i]);
		for(new i=-1;++i<9;) PlayerTextDrawDestroy(playerid, TextDrawNotifikasiLoding[playerid][(x*10) + i]);
		InfoNotify[playerid][IndexNotify[playerid]-x] = InfoNotify[playerid][(IndexNotify[playerid]-x)-1];
	}
	format(InfoNotify[playerid][0][NotifyMessage], 320, "%s", message);
	InfoNotify[playerid][0][NotifyIcon] = icon;
	InfoNotify[playerid][0][NotifySize] = 3;
	++IndexNotify[playerid];
	new Float:new_x=0.0;
	for(new x=-1;++x<IndexNotify[playerid];)
	{
		CreateNotify(playerid, x, x * 10, new_x);
		new_x += (InfoNotify[playerid][x][NotifySize]*7.25)+15.0;
	}
	SetTimerEx("HideNotify", 10000, false, "d", playerid);
	return 1;
}

stock CreateNotify(const playerid, index, i, const Float:new_x)
{
	new lines = InfoNotify[playerid][index][NotifySize];
	new Float:x = (lines * 10) + new_x;
	new Float:posisibaru = x-1.0;
	if(InfoNotify[playerid][index][NotifyIcon] == 1)
	{
		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 1000.000000, 108.500000+posisibaru, "");
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.425000, 1.400000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 520.000, 116.000+posisibaru, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 109.000, 35.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 893010175);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 520.000, 116.000+posisibaru, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 109.000, -3.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 1687547391);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 518.000, 116.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 16.000, 16.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 525.000, 119.000+posisibaru, "i");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.220, 1.099);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 1687547391);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 533.000, 119.000+posisibaru, "INFORMATION");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.158, 1.098);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 129.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.150, 0.699);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 633.500, 494.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);
	}
	if(InfoNotify[playerid][index][NotifyIcon] == 2)
	{
		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 1000.000000, 108.500000+posisibaru, "");
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.425000, 1.400000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 520.000, 116.000+posisibaru, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 109.000, 35.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 893010175);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 520.000, 116.000+posisibaru, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 109.000, -3.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1962934017);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 518.000, 116.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 16.000, 16.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 523.400, 119.000+posisibaru, "X");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.220, 1.099);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1962934017);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 533.000, 119.000+posisibaru, "KESALAHAN");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.158, 1.098);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 129.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.150, 0.699);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 633.500, 494.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);
	}
	if(InfoNotify[playerid][index][NotifyIcon] == 3)
	{
		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 1000.000000, 108.500000+posisibaru, "");
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.425000, 1.400000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 520.000, 116.000+posisibaru, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 109.000, 35.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 893010175);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasiLoding[playerid][++i] = CreatePlayerTextDraw(playerid, 520.000, 116.000+posisibaru, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasiLoding[playerid][i], 109.000, -3.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasiLoding[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasiLoding[playerid][i], 1689621759);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasiLoding[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasiLoding[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasiLoding[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasiLoding[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasiLoding[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasiLoding[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 518.000, 116.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 16.000, 16.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 525.000, 120.000+posisibaru, "/");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.200, 0.799);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 16711935);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 526.000, 123.000+posisibaru, "/");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], -0.136, 0.398);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 16711935);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 533.000, 119.000+posisibaru, "SUCCES");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.158, 1.098);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 129.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.150, 0.699);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 633.500, 494.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

	}
	if(InfoNotify[playerid][index][NotifyIcon] == 4)
	{
		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 1000.000000, 108.500000+posisibaru, "");
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.425000, 1.400000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 520.000, 116.000+posisibaru, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 109.000, 35.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 893010175);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 520.000, 116.000+posisibaru, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 109.000, -3.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 1687547391);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 518.000, 116.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 16.000, 16.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 525.000, 119.000+posisibaru, "i");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.220, 1.099);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 1687547391);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 533.000, 119.000+posisibaru, "INFORMATION");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.158, 1.098);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 129.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.150, 0.699);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 633.500, 494.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);
	}
	if(InfoNotify[playerid][index][NotifyIcon] == 5)
	{
		TextDrawNotifikasi[playerid][i] = CreatePlayerTextDraw(playerid, 1000.000000, 108.500000+posisibaru, "");
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.425000, 1.400000);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 400.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, TextDrawNotifikasi[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 520.000, 116.000+posisibaru, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 109.000, 35.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 893010175);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 520.000, 116.000+posisibaru, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 109.000, -3.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 1687547391);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 518.000, 116.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 16.000, 16.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 525.000, 119.000+posisibaru, "i");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.220, 1.099);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 1687547391);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 533.000, 119.000+posisibaru, "INFORMATION");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.158, 1.098);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 521.000, 129.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.150, 0.699);
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 633.500, 494.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);
	}
	return true;
}
