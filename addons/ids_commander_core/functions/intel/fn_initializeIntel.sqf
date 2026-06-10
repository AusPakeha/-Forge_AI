/*
    IDS Commander AI - Initialize Intel (Version 0.1)
*/

if !(call IDS_fnc_isAuthority) exitWith {};

params ["_commander"];

private _worldDB = missionNamespace getVariable ["IDS_WorldDB", createHashMap];
private _intelDB = _worldDB getOrDefault ["Intel", createHashMap];
_worldDB set ["Intel", _intelDB];
missionNamespace setVariable ["IDS_WorldDB", _worldDB, true];
IDS_WorldDB = _worldDB;

_commander set ["KnownIntel", _commander getOrDefault ["KnownIntel", []]];

true
