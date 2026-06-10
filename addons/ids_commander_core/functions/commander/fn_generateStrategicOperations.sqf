/*
    IDS Commander AI - Generate Strategic Operations

    Params:
      0: _commander (HashMap)

    Creates a simple CAPTURE operation for a scored target (frontline-preferred)
*/

params ["_commander"];

if !(call IDS_fnc_isAuthority) exitWith {};

// Update frontlines first
[_commander] call IDS_fnc_updateFrontlines;

// Score targets
private _targets = [_commander] call IDS_fnc_scoreStrategicTargets;
if (_targets isEqualTo []) exitWith {};

// Select best target (first entry)
private _best = _targets select 0;
private _targetLoc = _best select 0;

// Determine origin (prefer owned locations)
private _myFaction = _commander getOrDefault ["Faction","FAC_BLUFOR"];
private _worldDB = missionNamespace getVariable ["IDS_WorldDB", createHashMap];
private _locations = _worldDB getOrDefault ["Locations", createHashMap];

private _origin = objNull;
{
    private _owner = _x getOrDefault ["OwnerFaction", ""];
    if (_owner isEqualTo _myFaction) exitWith {_origin = _x};
} forEach values _locations;

if (isNull _origin) then { _origin = _targetLoc; };

// Create operation
private _operationID = [_commander get "ID", "CAPTURE", (_origin get "ID"), (_targetLoc get "ID")] call IDS_fnc_createOperation;
if (!(_operationID isEqualTo "")) then {
    private _ops = _commander getOrDefault ["Operations", []];
    _ops pushBack _operationID;
    _commander set ["Operations", _ops];

    private _activeOps = _commander getOrDefault ["ActiveOperations", []];
    _activeOps pushBack _operationID;
    _commander set ["ActiveOperations", _activeOps];

    // Allocate forces
    [_operationID] call IDS_fnc_allocateOperationForces;
};


