/*
    IDS Commander AI - Save State (Version 0.1)
*/

if !(call IDS_fnc_isAuthority) exitWith {createHashMap};

private _version = "0.1";

private _saveData = createHashMapFromArray
[
    ["Version",_version],
    ["Commander",IDS_Commanders],
    ["WorldDB",IDS_WorldDB]
];

_saveData
