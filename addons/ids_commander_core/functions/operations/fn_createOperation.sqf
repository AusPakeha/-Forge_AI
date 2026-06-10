/*
    IDS Commander AI - Create Operation (v0.1)

    Params:
        0: STRING - CommanderID
        1: STRING - Type
        2: STRING - OriginLocation
        3: STRING - TargetLocation

    Returns:
        STRING - Operation ID or empty string on failure

    Authority: Server only.
*/

params [
    ["_commanderID", ""],
    ["_type", ""],
    ["_originLocation", ""],
    ["_targetLocation", ""]
];

if (!isServer) exitWith {""};
if (_commanderID isEqualTo "") exitWith {""};
if (_type isEqualTo "") exitWith {""};

private _operationID = ["OP"] call IDS_fnc_generateID;

private _operation = createHashMapFromArray [
    ["ID", _operationID],
    ["Type", _type],
    ["State", "CREATED"],
    ["CommanderID", _commanderID],
    ["OriginLocation", _originLocation],
    ["TargetLocation", _targetLocation],
    ["RequiredForcePackages", []],
    ["AssignedGroups", []],
    ["Progress", 0],
    ["Timeout", 1800],
    ["CreatedTime", serverTime],
    ["StartTime", -1],
    ["EndTime", -1]
];

private _operations = missionNamespace getVariable ["IDS_Operations", createHashMap];

_operations set [_operationID, _operation];

missionNamespace setVariable ["IDS_Operations", _operations, true];

_operationID
