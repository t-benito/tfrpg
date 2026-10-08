#include <sourcemod>

#include "player.sp"
#include "database.sp"

#include "data/item.sp"
#include "data/entity.sp"

#pragma semicolon 1
#pragma newdecls required

public void RPG_PluginStart() {
	LogMessage("rpg time");

	DB_PluginStart();
	Items_PluginStart();
	Entities_PluginStart();
}

public void RPG_ClientPutInServer(int client) {
	//Player_ClientPutInServer(client);
	DB_ClientPutInServer(client);
}

public void RPG_ClientDisconnect(int client) {
	DB_ClientDisconnect(client);
}