/*
    IDS Commander AI - Get Group Object (v0.1)

    Description:
    Returns the group object for a given group ID.

    Parameters:
        0: STRING - Group ID

    Returns:
        GROUP | grpNull
*/

params ["_groupID"];

if (_groupID isEqualTo "") exitWith {grpNull};

private _data = [_groupID] call IDS_fnc_getGroupData;
_data getOrDefault ["Group", grpNull]
