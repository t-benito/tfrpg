#pragma semicolon 1
#pragma newdecls required

#define SKILLCOUNT 6

enum SkillType {
    Strength,
    Precision,
    Wisdom,
    Resistance,
    Constitution,
    Intelligence,
}

char g_SkillNames[SKILLCOUNT][] = {
    "Strength",
    "Precision",
    "Wisdom",
    "Resistance",
    "Constitution",
    "Intelligence",
};

char g_SkillHelp[SKILLCOUNT][] = {
    "Increases melee DMG", // Strength
    "Increases ranged DMG", // Prescision
    "Increases magic DMG", // wisdom
    "Reduces damage taken", // Resistance
    "Increases max HP", // constituition
    "Used for crafting, spells, and bonuses", // intelligence
};