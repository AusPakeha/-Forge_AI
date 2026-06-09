/*
    IDS Commander AI - Check Reinforcements (Auto-replacement)

    Consumes ReinforcementPool and spawns replacement squads.
    Server authority only.
*/

if !(call IDS_fnc_isAuthority) exitWith {};

params ["_commander"];

if (isNil "_commander") exitWith {};

private _pool = _commander getOrDefault ["ReinforcementPool", createHashMap];
private _inf = _pool getOrDefault ["Infantry", 0];

if (_inf <= 0) exitWith {false};

// Consume exactly one infantry element per tick to keep load stable.
_pool set ["Infantry", _inf - 1];
_commander set ["ReinforcementPool", _pool];

[_commander] call IDS_fnc_spawnReinforcementSquad;

true

