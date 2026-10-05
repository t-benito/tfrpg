#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

int g_iCredits[MAXPLAYERS + 1];

public void Player_ClientPutInServer(int client)
{
	Player_Reset(client);
}

public void Player_Reset(int client)
{
	g_iCredits[client] = 0;
}

public int Player_GetCredits(int client)
{
	return g_iCredits[client];
}

public int Player_AddCredits(int client, int amount)
{
	g_iCredits[client] += amount;
	return g_iCredits[client];
}