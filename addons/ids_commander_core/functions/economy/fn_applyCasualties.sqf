/*
    IDS Commander AI - Apply Casualties -> Economy Loss

    After an operation resolves, apply manpower losses based on dead units.
*/

if !(call IDS_fnc_isAuthority) exitWith {};

params ["_operation"];

if (isNil "_operation") exitWith {};

private _grp = _operation getOrDefault ["Group", grpNull];
private _factionId = _operation getOrDefault ["Faction", "FAC_BLUFOR"];

if (isNull _grp) exitWith {};

private _deadCount = { !alive _x } count units _grp;
private _manpowerLoss = _deadCount * 6;

// Apply to all commanders that match faction.
private _cmds = missionNamespace getVariable ["IDS_Commanders", createHashMap];

{
    private _cmd = _y;
    private _cmdFaction = _cmd getOrDefault ["Faction", "FAC_BLUFOR"];
    if (_cmdFaction isEqualTo _factionId) then
    {
        private _mp = _cmd getOrDefault ["Manpower", 0];
        _cmd set ["Manpower", _mp - _manpowerLoss];
    };
} forEach _cmds;

true

