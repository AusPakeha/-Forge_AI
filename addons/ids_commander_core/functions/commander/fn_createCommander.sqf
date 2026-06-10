/*
    IDS Commander AI - Create Commander (Version 0.2)

    Creates a commander entry in `missionNamespace` under `IDS_Commanders`.
*/

params [
    ["_personality","AGGRESSIVE"],
    ["_faction","FAC_OPFOR"]
];

if !(call IDS_fnc_isAuthority) exitWith {objNull};

if (isNil "IDS_Commanders") then {
    missionNamespace setVariable ["IDS_Commanders", createHashMap];
};

private _commanderId = ["CMD"] call IDS_fnc_generateUID;

private _commander = createHashMapFromArray [
    ["ID", _commanderId],
    ["Name", "Enemy Commander"],
    ["Faction", _faction],
    ["Personality", _personality],
    ["Doctrine", _personality],
    ["DoctrineData", createHashMap],

    ["Money", 10000],
    ["Manpower", 100],

    // Combat power accounting
    ["AvailableCombatPower", 0],
    ["CommittedCombatPower", 0],

    // Group tracking
    ["ReserveGroups", []],
    ["AssignedGroups", []],
    ["ActiveGroups", []],
    ["ActiveOperations", []],

    ["ControlledLocations", []],
    ["KnownIntel", []],
    ["Operations", []],

    ["ThreatLevel", 0],
    ["Created", serverTime]
];

// Store authoritative registry
IDS_Commanders set [_commanderId, _commander];

_commander
