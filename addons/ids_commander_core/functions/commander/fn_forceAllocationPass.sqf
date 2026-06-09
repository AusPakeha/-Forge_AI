/*
    IDS Commander AI - Force Allocation Pass (chat29 implementation)

    Implements the commander-side “force allocation pass” from chat29.sqf.

    Current repo status:
    - The full data-model functions from the prompt (IDS_fnc_getAvailableForces, IDS_fnc_calculateLocationStrength, IDS_fnc_getCombatPower, IDS_fnc_assignForces, IDS_fnc_generateOperations)
      are not implemented yet.
    - This file provides a first integration layer that:
        1) Computes per-location RequiredStrength from StrategicValue/ThreatScore if present
        2) Approximates CurrentStrength using a best-effort combat-power estimate derived from available force packages / group counts
        3) Creates an “available pool budget” to prevent over-commitment
        4) Applies reserve rule based on doctrine data
        5) Does not yet move groups between states (that requires IDS_fnc_getAvailableForces / IDS_fnc_assignForces)

    The function is safe to call repeatedly and is authority-only.
*/

params [
    ["_commander", objNull],
    ["_factionId", ""],
    ["_operations", []]
];

if !(call IDS_fnc_isAuthority) exitWith {false};
if (isNull _commander) exitWith {false};

// ----------------------------
// Helpers (local)
// ----------------------------

private _safeGet = {
    params ["_hash", "_key", "_default"];
    if (isNil "_hash") exitWith {_default};
    if (typeName _hash != "HASHMAP") exitWith {_default};
    if (isNil {_hash get _key}) exitWith {_default};
    _hash getOrDefault [_key, _default]
};

private _getDoctrine = {
    params ["_cmd"];
    private _key = _cmd getOrDefault ["Doctrine", _cmd getOrDefault ["Personality", "AGGRESSIVE"]];
    call {
        private _d = IDS_Doctrines getOrDefault [_key, createHashMap];
        _d
    }
};

// Reserve logic (combat-power budget units are currently “generic combat power” points)
// We use existing doctrine biases from IDS_Doctrines when available.
private _computeReserveFraction = {
    params ["_doctrine", "_personalityKey"];

    // If doctrine has no explicit fractions, derive from AttackBias/DefenseBias.
    private _attackBias = _doctrine getOrDefault ["AttackBias", 1];
    private _defBias    = _doctrine getOrDefault ["DefenseBias", 1];

    // Map bias ratio into reserve fraction (simple, stable):
    // Higher defense bias => higher reserve.
    private _ratio = _defBias max 0.01 / (_attackBias max 0.01);
    // Normalize: ratio around 1 => ~0.3 reserve, ratio 2 => ~0.4, ratio 0.5 => ~0.2
    private _reserve = 0.2 + (0.2 * (_ratio min 3));
    _reserve min 0.5 max 0.1
};

// Compute required strength from location strategic values.
private _computeRequiredStrength = {
    params ["_location"];

    private _sv = _location getOrDefault ["StrategicValue", 0];
    private _th = _location getOrDefault ["ThreatScore", 0];

    // chat29 base formula example
    private _required =
        4
        + (_sv / 20)
        + (_th / 25);

    // Keep minimum viable requirement.
    _required max 1
};

// Best-effort combat power approximation.
// Until IDS_fnc_getCombatPower exists, we compute a generic estimate based on:
// - number of groups currently existing for the faction (side east only for now)
// - and per-operation force package CombatPower when composition exists.
private _estimateCurrentStrength = {
    params ["_commander", "_factionId", "_location"];

    // World data may store groups; fallback to available force package budget.
    // This is deliberately conservative so we don't over-allocate.

    private _worldDB = missionNamespace getVariable ["IDS_WorldDB", objNull];
    private _locations = if (isNull _worldDB) then {[]} else {_worldDB getOrDefault ["Locations", []]};

    // Count groups for side (current repo spawns east groups)
    private _groups = allGroups select {side _x == east};
    private _groupCount = count _groups;

    // Convert groups to pseudo combat power.
    // Roughly assume each group equals ~10 points.
    private _cp = _groupCount * 10;

    // Slightly bias by strategic location value and threat.
    private _sv = _location getOrDefault ["StrategicValue", 0];
    private _th = _location getOrDefault ["ThreatScore", 0];
    _cp + (_sv / 20) + (_th / 25)
};

// ----------------------------
// Main logic
// ----------------------------

call IDS_fnc_initDoctrineRegistry;

private _doctrine = [_commander] call _getDoctrine;
private _reserveFrac = [_doctrine, (_commander getOrDefault ["Doctrine", ""]) ] call _computeReserveFraction;

private _worldDB = missionNamespace getVariable ["IDS_WorldDB", objNull];
if (isNull _worldDB) exitWith {false};

private _locations = _worldDB getOrDefault ["Locations", []];
if (_locations isEqualTo []) exitWith {false};

// Determine operation list if not provided: use existing operations tick structures.
private _ops = _operations;
if (typeName _ops != "ARRAY") then { _ops = []; };

// Compute total current combat power budget for this pass.
private _totalCurrent = 0;
{
    private _req = [_x] call _computeRequiredStrength;
    private _cur = [_commander, _factionId, _x] call _estimateCurrentStrength;
    _totalCurrent = _totalCurrent + _cur;

    // Store per-location strengths to location hash if possible.
    _x set ["RequiredStrength", _req];
    _x set ["CurrentStrength", _cur];
    _x set ["ExcessStrength", (_cur - _req) max 0];
} forEach _locations;

// Reserve budget (points to keep unassigned)
private _reserveBudget = _totalCurrent * _reserveFrac;
private _availableBudget = _totalCurrent - _reserveBudget;

// Allocation placeholder:
// - The full “assignForces” needs IDs_fnc_getAvailableForces + IDs_fnc_assignForces.
// - For now, we only gate how many operations can be “considered” based on RequiredStrength sum.

// Compute a desired “op cost” from operations if they look like operations with a RequiredStrength/Location data.
private _opCosts = [];
{
    private _cost = _x getOrDefault ["RequiredStrength", 5];
    _opCosts pushBack _cost;
} forEach _ops;

private _sortedIdx = [];
for "_i" from 0 to ((count _ops) - 1) do { _sortedIdx pushBack _i; };
// Keep stable order for now.

private _acc = 0;
private _allowedOps = [];
for "_i" from 0 to ((count _sortedIdx) - 1) do
{
    private _idx = _sortedIdx select _i;
    private _cost = _opCosts select _idx;
    if ((_acc + _cost) <= _availableBudget) then
    {
        _allowedOps pushBack (_ops select _idx);
        _acc = _acc + _cost;
    };
};

// Apply operation gating by tagging operations.
{
    _x set ["ForceBudgetApproved", true];
} forEach _allowedOps;

private _result = [
    "ForceAllocation",
    [
        "ReserveFraction", _reserveFrac,
        "TotalCurrentStrength", _totalCurrent,
        "ReserveBudget", _reserveBudget,
        "AvailableBudget", _availableBudget,
        "ApprovedOperations", count _allowedOps
    ]
];

// Store on commander for debugging / telemetry
_commander set ["LastForceAllocation", _result];

true

