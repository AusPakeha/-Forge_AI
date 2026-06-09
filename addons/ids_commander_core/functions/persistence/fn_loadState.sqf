/*
    IDS Commander AI - Load State (Version 0.1)
*/

params [
    ["_saveData", createHashMap]
];

if !(call IDS_fnc_isAuthority) exitWith {false};

if (_saveData isEqualTo createHashMap) exitWith {false};

private _loadedVersion = _saveData getOrDefault ["Version","0.0"];

IDS_Commanders = _saveData getOrDefault ["Commander", createHashMap];
IDS_WorldDB = _saveData getOrDefault ["WorldDB", createHashMap];

// Ensure doctrine registry exists after load.
call IDS_fnc_initDoctrineRegistry;

// Doctrine persistence rule: keep stored doctrine unless this is a New Save.
// Backfill missing doctrine fields for older saves.
{
    private _commander = _x;

    private _doctrineKey = _commander getOrDefault ["Doctrine", objNull];
    if (isNull _doctrineKey) then {
        _doctrineKey = _commander getOrDefault ["Personality","AGGRESSIVE"];
        _commander set ["Doctrine", _doctrineKey];
    };

    _commander set ["DoctrineData", (IDS_Doctrines getOrDefault [_doctrineKey, createHashMap])];

} forEach values IDS_Commanders;

// Resume loops after load.
[] call IDS_fnc_startLoops;

true
