/*
    IDS Commander AI - Save State (Version 0.1)
*/

if !(call IDS_fnc_isAuthority) exitWith {createHashMap};

private _version = "0.1";
private _cmds = missionNamespace getVariable ["IDS_Commanders", createHashMap];
private _worldDB = missionNamespace getVariable ["IDS_WorldDB", createHashMap];

private _saveData = createHashMapFromArray
[
    ["Version",_version],
    ["Commander",_cmds],
    ["WorldDB",_worldDB]
];

_saveData
