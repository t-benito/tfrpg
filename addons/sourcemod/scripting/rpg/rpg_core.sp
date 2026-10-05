#include <sourcemod>

#include "player.sp"
#include "database.sp" // must be after player

#pragma semicolon 1
#pragma newdecls required

public void RPG_PluginStart()
{
	PrintToServer("rpg time");
	DB_PluginStart();
}

public void RPG_ClientPutInServer(int client)
{
	Player_ClientPutInServer(client);
	DB_ClientPutInServer(client);
}

public void RPG_ClientDisconnect(int client)
{
	DB_ClientDisconnect(client);
}