#pragma semicolon 1
#pragma newdecls required

#define RPG
#define MAXENTITIES 2048

#include "rpg/database.sp"
#include "rpg/player.sp"
#include "rpg/rpg_core.sp"

public void OnPluginStart(){
    RPG_PluginStart();
}

public void OnClientPutInServer(int client) {
    RPG_ClientPutInServer(client);
}

public void OnClientDisconnect(int client) {
    RPG_ClientDisconnect(client);
}