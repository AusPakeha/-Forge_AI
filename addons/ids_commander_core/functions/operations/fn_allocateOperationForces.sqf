/*
    IDS Commander AI - Allocate Operation Forces (v0.1)

    Params:
        0: STRING - OperationID

    Authority: Server only.
*/

params ["_operationID"];

if (!isServer) exitWith {};

private _operation = [_operationID] call IDS_fnc_getOperationData;
if (typeName _operation != "HASHMAP") exitWith {};

private _commanderID = _operation getOrDefault ["CommanderID", ""];
private _commander = [_commanderID] call IDS_fnc_getCommanderData;
private _factionID = _commander getOrDefault ["Faction", "OPFOR_CSAT"];
private _reserveGroups = [_commanderID] call IDS_fnc_getCommanderReserveGroups;
private _assignedGroups = [];

private _originLocation = [_operation get "OriginLocation"] call IDS_fnc_getLocationData;
private _spawnPos = _originLocation getOrDefault ["Position", []];
if (_spawnPos isEqualTo []) then { _spawnPos = position player; };

{
    private _package = _x;
    private _groupID = "";

    if (_reserveGroups != []) then {
        {
            private _groupData = [_x] call IDS_fnc_getGroupData;
            if ((_groupData getOrDefault ["ForcePackage", ""]) isEqualTo _package) then {
                _groupID = _x;
                exitWith {};
            };
        } forEach _reserveGroups;
    };

    if (_groupID isEqualTo "") then {
        private _result = [
            _package,
            _factionID,
            _spawnPos,
            _commanderID
        ] call IDS_fnc_spawnPackage;

        private _groupIDs = _result select 0;
        if (_groupIDs != []) then {
            _groupID = _groupIDs select 0;
        };
    } else {
        [_commanderID, _groupID] call IDS_fnc_commitForce;
    };

    if !(_groupID isEqualTo "") then {
        [_groupID, _operationID] call IDS_fnc_groupRegistry_assignOperation;
        [_commanderID, _groupID, _operationID] call IDS_fnc_assignGroupToCommanderOperation;
        _assignedGroups pushBack _groupID;
    };

} forEach (_operation getOrDefault ["RequiredForcePackages", []]);

_operation set ["AssignedGroups", _assignedGroups];

// persist
private _ops = missionNamespace getVariable ["IDS_Operations", createHashMap];
_ops set [_operationID, _operation];
missionNamespace setVariable ["IDS_Operations", _ops, true];

[_operationID, "STAGING"] call IDS_fnc_setOperationState;

true
