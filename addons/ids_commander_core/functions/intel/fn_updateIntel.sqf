/*
    IDS Commander AI - Intel Tick (Version 0.1)
*/

if !(call IDS_fnc_isAuthority) exitWith {};

params ["_commander"];

[_commander] call IDS_fnc_decayIntel;

private _worldDB = missionNamespace getVariable ["IDS_WorldDB", createHashMap];
private _intelDB = _worldDB getOrDefault ["Intel", createHashMap];
private _knownIntel = [];

{
    if ((_x getOrDefault ["Type", ""] ) isEqualTo "EnemyContact") then {
        private _confidence = _x getOrDefault ["Confidence", 0];
        if (_confidence > 20) then {
            _knownIntel pushBack _x;
        };
    };
} forEach values _intelDB;

_commander set ["KnownIntel", _knownIntel];
private _threat = [_commander, _knownIntel] call IDS_fnc_calculateThreats;
_commander set ["ThreatLevel", _threat];

private _enemyPositions = [_knownIntel, 30] call IDS_fnc_getKnownEnemyPositions;
_commander set ["KnownEnemyPositions", _enemyPositions];

true
