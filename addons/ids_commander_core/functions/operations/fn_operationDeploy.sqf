/*
    IDS Commander AI - Operation Deploy

    Spawns a simple squad for Version 1.
*/

params ["_op"];

private _targetPos = _op getOrDefault ["TargetPos",[]];
if (_targetPos isEqualTo []) exitWith {};

// Spawn group at target offset for now.
private _grp = createGroup [east, true];

for "_i" from 1 to 8 do
{
    _grp createUnit
    [
        "O_Soldier_F",
        _targetPos getPos [random 20, random 360],
        [],
        0,
        "FORM"
    ];
};

_op set ["Group", _grp];
_op set ["OriginPos", getPos (leader _grp)];
_op set ["Status", "MARCH"];

true

