/*
    IDS Commander AI - Operations Tick (Version 0.1 placeholder)
*/

if !(call IDS_fnc_isAuthority) exitWith {};

params ["_commander"];

// Operation Execution Layer entry point (vertical slice).
// Iterate all operations in IDS_Operations and update by phase.

private _ops = missionNamespace getVariable ["IDS_Operations", createHashMap];

{
    private _op = _y;

    if (isNil {_op getOrDefault ["Type", nil]}) then
    {
        // Legacy operations default to CAPTURE.
        _op set ["Type","CAPTURE"];
    };

    // Server-authoritative frontline refresh.
    // v0.1: done per operation update; can be optimized by moving to separate tick later.
    [] call IDS_fnc_updateFrontlines;
    [] call IDS_fnc_updateFrontlineRegions;

    // Frontline/region focus selection currently happens when generating new targets
    // (operation generation not yet rewritten to use fronts).

    [_op] call IDS_fnc_updateOperation;
} forEach _ops;

true
