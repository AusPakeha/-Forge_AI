/*
    IDS Commander AI - Get Faction Template (v0.1)

    Description:
    Returns faction template data.

    Parameters:
        0: STRING - Faction ID

    Returns:
        HASHMAP
*/

params ["_factionID"];

switch (_factionID) do {
    case "OPFOR_CSAT": {
        createHashMapFromArray [
            ["Side", east],
            ["Leader", "O_Soldier_SL_F"],
            ["Grenadier", "O_Soldier_GL_F"],
            ["Autorifleman", "O_Soldier_AR_F"],
            ["Rifleman", "O_Soldier_F"]
        ];
    };
    default {
        createHashMap;
    };
};
