/*
    IDS Commander AI - Select Best Force Package (chat27.sqf)

    First-release scoring placeholder.

    Params:
        0: _operation (HashMap)
        1: _availablePackages (ARRAY of package keys or HASHMAP entries)
        2: _commander (optional HashMap)

    Returns:
        Selected package key (String) or "".
*/

params [
    ["_operation", createHashMap],
    ["_availablePackages", []],
    ["_commander", objNull]
];

if !(call IDS_fnc_isAuthority) exitWith {""};

if (typeName _availablePackages != "ARRAY") exitWith {""};

if (_availablePackages isEqualTo []) exitWith {""};

// Minimal stable heuristic for first integration:
// - Prefer highest CombatPower, ignore costs for now.

private _bestKey = "";
private _bestScore = -1;

call IDS_fnc_initForcePackages;

{
    private _key = _x;
    if (_key isEqualType "") then
    {
        private _pkg = IDS_ForcePackages getOrDefault [_key, createHashMap];
        private _cp = _pkg getOrDefault ["CombatPower", 0];

        if (_cp > _bestScore) then
        {
            _bestScore = _cp;
            _bestKey = _key;
        };
    };
} forEach _availablePackages;

_bestKey

