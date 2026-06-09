/*
    IDS Commander AI - Spawn Reinforcement Squad

    Rear area logic stub.
    This implementation spawns a group at a rear-area position determined by
    IDS_fnc_getFactionRearArea (adapter/placeholder).
*/

if !(call IDS_fnc_isAuthority) exitWith {};

params ["_commander"];

if (isNull _commander) exitWith {};

// Rear area helper (placeholder).
// Must be implemented elsewhere; for now we provide a safe fallback.
private _rearAreaFn = "IDS_fnc_getFactionRearArea";
private _spawnPos = [0,0,0];

if (!isNil _rearAreaFn) then
{
    _spawnPos = [] call (missionNamespace getVariable [_rearAreaFn, { [0,0,0] }]);
}
else
{
    // Fallback to first spawn point or world center.
    private _worldSize = worldSize;
    _spawnPos = [_worldSize/2,_worldSize/2,0];
};

private _side = _commander getOrDefault ["Side", east];

private _grp = createGroup [_side, true];

// Infantry only for stability.
private _unitType = _commander getOrDefault ["ReinforcementUnitType", "O_Soldier_F"];

for "_i" from 1 to 8 do
{
    _grp createUnit [
        _unitType,
        _spawnPos,
        [],
        5,
        "FORM"
    ];
};

_grp setVariable ["Faction", _commander getOrDefault ["Faction", "FAC_OPFOR"]];

true

