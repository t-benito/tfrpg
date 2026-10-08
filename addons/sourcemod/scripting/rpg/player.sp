#pragma semicolon 1
#pragma newdecls required

#include "skill.sp"

int g_iCredits[MAXPLAYERS + 1];
int g_iXP[MAXPLAYERS + 1];
int g_iLevel[MAXPLAYERS + 1];
int g_iLvlProgress[MAXPLAYERS + 1];
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
	public int GetRequiredXP() {
		return 10 + RoundToCeil(Pow(float(this.Level) * 1.5, 1.32));
	}

	property int LevelProgress {
		public get() {
			return g_iLvlProgress[view_as<int>(this)];
		}
		public set(int val) {
			g_iLvlProgress[view_as<int>(this)] = val;
		}
	}
	// Get Required Level Progress
	// (good looking version)
	public int GetRequiredLvlPrgrs() {
		int req = RoundToFloor(10.0 + float(this.Level) * 0.1);
		if (req > 30) 
			req = 30;
		return req;
	}

	property int Level {
		public get() {
			return g_iLevel[view_as<int>(this)];
		}
		public set(int val) {
			g_iLevel[view_as<int>(this)] = val;
		}
	}

	public void Update() {
		int consti = this.GetSkillLvl(Constitution);

		SetEntProp(view_as<int>(this), Prop_Data, "m_iMaxHealth", consti * 30);
	}
	
	// because you cant have arrays as properties..
	// thisll do
	public int[] GetSkills() {
		return g_iSkills[view_as<int>(this)];
	}
	public int GetSkillLvl(SkillType skill) {
		return g_iSkills[view_as<int>(this)][view_as<int>(skill)];
	} // maybe turn this to a porperty?... 
	public void SetSkill(SkillType skill, int val) {
		g_iSkills[view_as<int>(this)][view_as<int>(skill)] = val;
	}
	public void SetSkillI(int skill, int val) {
		//assert(skill >= 0 && skill < SKILLCOUNT);
		g_iSkills[view_as<int>(this)][skill] = val;
	}


	public void UpgradeSkill(SkillType skill, int plus = 1) {
		int req = this.GetRequiredXP();
		int client = view_as<int>(this);

		if (this.XP >= req) {
			g_iSkills[client][view_as<int>(skill)] += plus;
			this.XP -= req;
			this.LevelProgress++;

			this.Update();

			int reqProgress = this.GetRequiredLvlPrgrs();
			if (this.LevelProgress >= reqProgress) {
				this.LevelProgress = 0;
				this.Level++;

				PrintCenterText(client, "LVL UP! You are now level %d", this.Level);
			}
		}
	}
}

public Player Player_Get(int client) {
	return view_as<Player>(client);
}