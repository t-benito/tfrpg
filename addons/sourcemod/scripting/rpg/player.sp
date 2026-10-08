#pragma semicolon 1
#pragma newdecls required

#include "skill.sp"

int g_iCredits[MAXPLAYERS + 1];
int g_iXP[MAXPLAYERS + 1];
int g_iLevel[MAXPLAYERS + 1];
int g_iSkills[SKILLCOUNT][MAXPLAYERS + 1];

methodmap Player {
	public Player(int client) {
		return view_as<Player>(client);
	}

	public void Zero() {
		this.Credits = 0;
		this.XP = 0;
		this.Level = 0;
		for (int i = 0; i < SKILLCOUNT; i++) {
			g_iSkills[view_as<int>(this)][i] = 10;
		}
	}
	
	property int Credits {
		public get() {
			return g_iCredits[view_as<int>(this)];
		}
		public set(int val) {
			g_iCredits[view_as<int>(this)] = val;
		}
	}
	property int XP {
		public get() {
			return g_iXP[view_as<int>(this)];
		}
		public set(int val) {
			g_iXP[view_as<int>(this)] = val;
		}
	}
	property int Level {
		public get() {
			return g_iLevel[view_as<int>(this)];
		}
		public set(int val) {
			g_iLevel[view_as<int>(this)] = val;
		}
	}
	
	// because you cant have arrays as properties..
	// thisll do
	public int[] GetSkills() {
		return g_iSkills[view_as<int>(this)];
	}
	public int GetSkillLvl(SkillType skill) {
		return g_iSkills[view_as<int>(this)][view_as<int>(skill)];
	}
	public void AddSkillLvl(SkillType skill, int add) {
		g_iSkills[view_as<int>(this)][view_as<int>(skill)] += add;
	}
}

public Player Player_Get(int client) {
	return view_as<Player>(client);
}