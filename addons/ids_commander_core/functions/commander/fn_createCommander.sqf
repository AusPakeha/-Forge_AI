/*
    IDS Commander AI - Create Commander (Version 0.1)
*/

params [
    ["_personality","Aggressive"]
];

if !(call IDS_fnc_isAuthority) exitWith {objNull};

if (isNil "IDS_Commanders") then {
    missionNamespace setVariable ["IDS_Commanders", createHashMap];
};

private _commanderId = ["CMD"] call IDS_fnc_generateUID;

private _commander = createHashMapFromArray
[
    ["ID",_commanderId],
    ["Name","Enemy Commander"],
    ["Personality",_personality],
    ["Doctrine",_personality],
    ["DoctrineData",createHashMap],

    ["Resources",1000],
    ["Money",0],
    ["Manpower",500],

    ["ControlledLocations",[]],
    ["KnownIntel",[]],
    ["Operations",[]],

    ["ThreatLevel",0],
    ["Created",serverTime]
];

// Store
IDS_Commanders set [_commanderId, _commander];

_commander
