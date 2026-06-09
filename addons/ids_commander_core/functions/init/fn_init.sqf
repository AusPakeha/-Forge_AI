/*
    Main bootstrap
*/

if !(call IDS_fnc_isAuthority) exitWith {};

["Initializing IDS Commander AI"] call IDS_fnc_log;

[] call IDS_fnc_buildWorld;

["World generation complete"] call IDS_fnc_log;

// Version 0.1: select/create commander and start loops.
private _personality = [] call IDS_fnc_selectCommander;

[_personality] call IDS_fnc_createCommander;

["Commander created"] call IDS_fnc_log;

[] call IDS_fnc_startLoops;

["Loops started"] call IDS_fnc_log;
