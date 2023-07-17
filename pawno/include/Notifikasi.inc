enum eNotify
{
	NotifyIcon,
	NotifyMessage[320],
	NotifySize
}
new InfoNotify[MAX_PLAYERS][7][eNotify];
new MaxPlayerNotify[MAX_PLAYERS];
new PlayerText:TextDrawNotifikasi[MAX_PLAYERS][7*10];
new IndexNotify[MAX_PLAYERS];

function HideNotify(playerid)
{
	if(!IndexNotify[playerid]) return 1;
	--IndexNotify[playerid];
	MaxPlayerNotify[playerid]--;
	for(new i=-1;++i<10;) PlayerTextDrawDestroy(playerid, TextDrawNotifikasi[playerid][(IndexNotify[playerid]*10)+i]);
	return 1;
}

stock InfoMsg(playerid, pesan[])
{
  ShowNotify(playerid, pesan, 1);
  return 1;
}
stock ErrorMsg(playerid, pesan[])
{
  ShowNotify(playerid, pesan, 2);
  return 1;
}
stock SuccesMsg(playerid, pesan[])
{
  ShowNotify(playerid, pesan, 3);
  return 1;
}
stock SyntaxMsg(playerid, pesan[])
{
  ShowNotify(playerid, pesan, 4);
  return 1;
}

stock WarningMsg(playerid, pesan[])
{
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
		InfoNotify[playerid][IndexNotify[playerid]-x] = InfoNotify[playerid][(IndexNotify[playerid]-x)-1];
	}
	format(InfoNotify[playerid][0][NotifyMessage], 320, "%s", message);
	InfoNotify[playerid][0][NotifyIcon] = icon;
	InfoNotify[playerid][0][NotifySize] = 3;
	++IndexNotify[playerid];
	new Float:new_x=0.0;
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	for(new x=-1;++x<IndexNotify[playerid];)
	{
		CreateNotify(playerid, x, x * 10, new_x);
		new_x += (InfoNotify[playerid][x][NotifySize]*7.25)+5.0;
	}
	SetTimerEx("HideNotify", 10000, false, "i", playerid);
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

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 498.000, 113.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.000, 38.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 12582911);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 621.000, 113.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.000, 38.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 119.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 123.000, 26.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 506.000, 121.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 16.000, 20.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 12582911);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 523.000, 120.000+posisibaru, "INFORMATION");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.219, 0.998);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 12582911);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 523.000, 129.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
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

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 513.299, 125.000+posisibaru, "i");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.230, 1.199);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
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

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 498.000, 113.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.000, 38.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1962934017);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 621.000, 113.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.000, 38.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 119.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 123.000, 26.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 506.000, 121.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 16.000, 20.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1962934017);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 523.000, 120.000+posisibaru, "KESALAHAN");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.219, 0.998);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], -1962934017);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 523.000, 129.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
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

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 511.299, 125.000+posisibaru, "X");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.230, 1.199);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
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

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 498.000, 113.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.000, 38.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 16711935);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 621.000, 113.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.000, 38.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 119.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 123.000, 26.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 506.000, 121.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 16.000, 20.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 16711935);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 523.000, 120.000+posisibaru, "SUKSES");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.219, 0.998);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 16711935);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 523.000, 129.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
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

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 513.299, 125.000+posisibaru, "/");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.230, 1.199);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 514.299, 130.000+posisibaru, "/");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], -0.230, 0.598);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
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

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 498.000, 113.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.000, 38.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 12582911);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 621.000, 113.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.000, 38.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 119.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 123.000, 26.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 506.000, 121.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 16.000, 20.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 12582911);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 523.000, 120.000+posisibaru, "INFORMATION");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.219, 0.998);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 12582911);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 523.000, 129.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
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

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 513.299, 125.000+posisibaru, "i");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.230, 1.199);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
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

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 498.000, 113.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.000, 38.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 12582911);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 621.000, 113.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 12.000, 38.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 504.000, 119.000+posisibaru, "LD_BUM:blkdot");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 123.000, 26.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 506.000, 121.000+posisibaru, "LD_BEAT:chit");
		PlayerTextDrawTextSize(playerid, TextDrawNotifikasi[playerid][i], 16.000, 20.000);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 12582911);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 523.000, 120.000+posisibaru, "INFORMATION");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.219, 0.998);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 12582911);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 523.000, 129.000+posisibaru, InfoNotify[playerid][index][NotifyMessage]);
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

		TextDrawNotifikasi[playerid][++i] = CreatePlayerTextDraw(playerid, 513.299, 125.000+posisibaru, "i");
		PlayerTextDrawLetterSize(playerid, TextDrawNotifikasi[playerid][i], 0.230, 1.199);
		PlayerTextDrawAlignment(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawColor(playerid, TextDrawNotifikasi[playerid][i], 255);
		PlayerTextDrawSetShadow(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, TextDrawNotifikasi[playerid][i], 0);
		PlayerTextDrawBackgroundColor(playerid, TextDrawNotifikasi[playerid][i], 150);
		PlayerTextDrawFont(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, TextDrawNotifikasi[playerid][i], 1);
		PlayerTextDrawShow(playerid, TextDrawNotifikasi[playerid][i]);
	}
	return true;
}