/*
    IDS Commander AI - Get Commander Data

    Returns the commander hashmap for a given commander ID.
*/

params ["_commanderID"];

if (_commanderID isEqualTo "") exitWith {createHashMap};

private _cmds = missionNamespace getVariable ["IDS_Commanders", createHashMap];
if (typeName _cmds != "HASHMAP") exitWith {createHashMap};
if !(_cmds hasKey _commanderID) exitWith {createHashMap};

_cmds get _commanderID
