enum eNotifyChat
{
	NotifyIcon,
	NotifyMessage[320],
	NotifySize
}
new InfoNotifyChat[MAX_PLAYERS][7][eNotifyChat];
new MaxPlayerNotifyChat[MAX_PLAYERS];
new Text:TextDrawChat[7*10];
new IndexNotifyChat[MAX_PLAYERS];

function HideNotifyChat(playerid)
{
	if(!IndexNotifyChat[playerid]) return 1;
	--IndexNotifyChat[playerid];
	MaxPlayerNotifyChat[playerid]--;
	for(new i=-1;++i<10;) TextDrawHideForAll(TextDrawChat[(IndexNotifyChat[playerid]*10)+i]);
	return 1;
}

stock ShowNotifyChat(const playerid, const string:message[])
{
	if(MaxPlayerNotifyChat[playerid] == 4) return 1;
	MaxPlayerNotifyChat[playerid]++;
	for(new x=-1; ++x <IndexNotifyChat[playerid];)
	{
		for(new i=-1;++i<9;) TextDrawHideForAll(TextDrawChat[(x*10) + i]);
		InfoNotifyChat[playerid][IndexNotifyChat[playerid]-x] = InfoNotifyChat[playerid][(IndexNotifyChat[playerid]-x)-1];
	}
    PlayerPlaySound(playerid, 1056, 0.0, 0.0, 0.0);
	format(InfoNotifyChat[playerid][0][NotifyMessage], 320, "%s", message);

	++IndexNotifyChat[playerid];
	new Float:new_x=0.0;
	for(new x=-1;++x<IndexNotifyChat[playerid];)
	{
		CreateNotifyChat(playerid, x, x * 10, new_x);
		new_x += (InfoNotifyChat[playerid][x][NotifySize]*7.25)+25.0;
	}
	SetTimerEx("HideNotifyChat", 10000, false, "i", playerid);
	return 1;
}

stock CreateNotifyChat(const playerid, index, i, const Float:new_x)
{
		new lines = InfoNotifyChat[playerid][index][NotifySize];
		new Float:x = (lines * 10) + new_x;
		new Float:posisibaru = x-1.0;
		
		TextDrawChat[++i] = TextDrawCreate(10.000, 2.000+posisibaru, "LD_BUM:blkdot");
		TextDrawTextSize(TextDrawChat[i], 191.000, 25.000);
		TextDrawAlignment(TextDrawChat[i], 1);
		TextDrawColor(TextDrawChat[i], 512819199);
		TextDrawSetShadow(TextDrawChat[i], 0);
		TextDrawSetOutline(TextDrawChat[i], 0);
		TextDrawBackgroundColor(TextDrawChat[i], 255);
		TextDrawFont(TextDrawChat[i], 4);
		TextDrawSetProportional(TextDrawChat[i], 1);
		TextDrawShowForAll(TextDrawChat[i]);
		
		TextDrawChat[++i] = TextDrawCreate(28.000, 6.000+posisibaru, "Kepolisian Executive");
		TextDrawLetterSize(TextDrawChat[i], 0.200, 0.899);
		TextDrawAlignment(TextDrawChat[i], 1);
		TextDrawColor(TextDrawChat[i], -1);
		TextDrawSetShadow(TextDrawChat[i], 0);
		TextDrawSetOutline(TextDrawChat[i], 0);
		TextDrawBackgroundColor(TextDrawChat[i], 150);
		TextDrawFont(TextDrawChat[i], 1);
		TextDrawSetProportional(TextDrawChat[i], 1);
		TextDrawShowForAll(TextDrawChat[i]);

		TextDrawChat[++i] = TextDrawCreate(15.000, 2.000+posisibaru, "LD_BEAT:chit");
		TextDrawTextSize(TextDrawChat[i], 14.000, 16.000);
		TextDrawAlignment(TextDrawChat[i], 1);
		TextDrawColor(TextDrawChat[i], -1);
		TextDrawSetShadow(TextDrawChat[i], 0);
		TextDrawSetOutline(TextDrawChat[i], 0);
		TextDrawBackgroundColor(TextDrawChat[i], 255);
		TextDrawFont(TextDrawChat[i], 4);
		TextDrawSetProportional(TextDrawChat[i], 1);
		TextDrawShowForAll(TextDrawChat[i]);

		TextDrawChat[++i] = TextDrawCreate(15.000, 15.000+posisibaru, InfoNotifyChat[playerid][index][NotifyMessage]);
		TextDrawLetterSize(TextDrawChat[i], 0.200, 0.899);
		TextDrawAlignment(TextDrawChat[i], 1);
		TextDrawColor(TextDrawChat[i], -1);
		TextDrawSetShadow(TextDrawChat[i], 0);
		TextDrawSetOutline(TextDrawChat[i], 0);
		TextDrawBackgroundColor(TextDrawChat[i], 150);
		TextDrawFont(TextDrawChat[i], 1);
		TextDrawSetProportional(TextDrawChat[i], 1);
		TextDrawShowForAll(TextDrawChat[i]);

		TextDrawChat[++i] = TextDrawCreate(18.000, 6.000+posisibaru, "HUD:radar_gangB");
		TextDrawTextSize(TextDrawChat[i], 8.000, 8.000);
		TextDrawAlignment(TextDrawChat[i], 1);
		TextDrawColor(TextDrawChat[i], -1);
		TextDrawSetShadow(TextDrawChat[i], 0);
		TextDrawSetOutline(TextDrawChat[i], 0);
		TextDrawBackgroundColor(TextDrawChat[i], 255);
		TextDrawFont(TextDrawChat[i], 4);
		TextDrawSetProportional(TextDrawChat[i], 1);
		TextDrawShowForAll(TextDrawChat[i]);

		TextDrawChat[++i] = TextDrawCreate(186.000, 5.000+posisibaru, "02:01");
		TextDrawLetterSize(TextDrawChat[i], 0.140, 0.899);
		TextDrawTextSize(TextDrawChat[i], -4.000, -3.000);
		TextDrawAlignment(TextDrawChat[i], 1);
		TextDrawColor(TextDrawChat[i], -1);
		TextDrawSetShadow(TextDrawChat[i], 0);
		TextDrawSetOutline(TextDrawChat[i], 0);
		TextDrawBackgroundColor(TextDrawChat[i], 150);
		TextDrawFont(TextDrawChat[i], 1);
		TextDrawSetProportional(TextDrawChat[i], 1);
		TextDrawShowForAll(TextDrawChat[i]);
		return true;
}
