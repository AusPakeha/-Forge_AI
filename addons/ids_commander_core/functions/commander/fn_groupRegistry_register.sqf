/*
    IDS Commander AI - Group Registry Register (v0.1)

    Purpose:
        Register a spawned group in IDS_GroupRegistry.

    Params:
        0: _groupId (String)
        1: _group (Group)
        2: _commanderId (String)
        3: _operationId (String, optional)

    Returns:
        Boolean

    Authority: Server only.
*/

params [
    ["_groupId",""],
    ["_group", grpNull],
    ["_commanderId",""],
    ["_operationId",""]
];

if (!isServer) exitWith {false};
if (_groupId isEqualTo "") exitWith {false};
if (isNull _group) exitWith {false};
if (_commanderId isEqualTo "") exitWith {false};

private _reg = missionNamespace getVariable ["IDS_GroupRegistry", createHashMap];
if (typeName _reg != "HASHMAP") then {
    _reg = createHashMap;
};

private _forcePackage = _group getVariable ["IDS_PackageKey", ""];
private _faction = side _group;
private _personnelCount = count units _group;
private _vehicleCount = 0;
private _status = "AVAILABLE";
private _combatPower = 100;
private _currentTime = serverTime;

// If it exists, overwrite (safe for v0.1 since only authority spawns).
private _entry = createHashMapFromArray [
    ["ID", _groupId],
    ["Group", _group],
    ["CommanderID", _commanderId],
    ["OperationID", _operationId],
    ["Faction", _faction],
    ["ForcePackage", _forcePackage],
    ["Status", _status],
    ["CombatPower", _combatPower],
    ["PersonnelCount", _personnelCount],
    ["VehicleCount", _vehicleCount],
    ["SpawnTime", _currentTime],
    ["LastUpdate", _currentTime],
    ["Alive", true]
];

_reg set [_groupId, _entry];
missionNamespace setVariable ["IDS_GroupRegistry", _reg];

true

