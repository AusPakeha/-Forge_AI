/*
    IDS Commander AI - Group Registry Get Object (v0.1)

    Params:
        0: _groupId (String)

    Returns:
        GROUP | grpNull
*/

params ["_groupId"];

if (_groupId isEqualTo "") exitWith {grpNull};

private _data = [_groupId] call IDS_fnc_groupRegistry_get;
_data getOrDefault ["Group", grpNull]
