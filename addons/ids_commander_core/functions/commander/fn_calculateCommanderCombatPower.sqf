/*
    IDS Commander AI - Calculate Commander Combat Power

    Params:
        0: STRING - CommanderID

    Returns:
        NUMBER - Derived combat power from the commander's reserve groups
*/

params ["_commanderID"];

if (_commanderID isEqualTo "") exitWith {0};

private _groups = [_commanderID] call IDS_fnc_getCommanderReserveGroups;
private _power = 0;
{
    private _groupData = [_x] call IDS_fnc_getGroupData;
    _power = _power + (_groupData getOrDefault ["CombatPower", 0]);
} forEach _groups;

_power
