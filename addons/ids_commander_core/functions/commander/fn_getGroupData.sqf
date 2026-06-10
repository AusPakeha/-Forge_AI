/*
    IDS Commander AI - Get Group Data (v0.1)

    Description:
    Returns group registry data for a given group ID.

    Parameters:
        0: STRING - Group ID

    Returns:
        HASHMAP
*/

params ["_groupID"];

if (_groupID isEqualTo "") exitWith {createHashMap};

[_groupID] call IDS_fnc_groupRegistry_get
