#pragma semicolon 1
#pragma newdecls required

int g_iCredits[MAXPLAYERS + 1];

methodmap Player {
	public Player(int client) {
		return view_as<Player>(client);
	}
	
	property int Credits {
		public get() {
			return g_iCredits[view_as<int>(this)];
		}
		public set(int val) {
			g_iCredits[view_as<int>(this)] = val;
		}
	}
}

//public void Player_ClientPutInServer(int client) {
//	g_Players[client] = Player(client);
//	// database handles stats
//}

public Player Player_Get(int client) {
	return view_as<Player>(client);
}