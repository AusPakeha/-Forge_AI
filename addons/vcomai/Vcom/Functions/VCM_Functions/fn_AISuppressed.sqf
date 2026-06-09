/*
    File: fn_AISuppressed.sqf
    Description: Gradual awareness gain when a unit is repeatedly suppressed.
*/

params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];

if (VCM_DebugSuppression) then {
    systemChat format ["Suppression _distance: %1 (%2 → %3)", _distance, _unit, _shooter];
};

if (_distance > 5) exitWith {};  // ignore distant rounds

[_unit, "SUPPRESSED", 10] call VCM_fnc_DebugText;

private _lastSup = _unit getVariable ["VCM_Suptime", -100];
if (_lastSup + 1 > time) exitWith {};  // small spam limiter
_unit setVariable ["VCM_Suptime", time];
// Temporarily lock hearing for this unit to prevent double reveal
_unit setVariable ["VCM_HearingLock", time + 5]; // 5 seconds lock
//_unit setSuppression 1;
_unit suppressFor (0.5 + random 0.5);

// --- Suppression counter logic ---
private _key = format ["VCM_Suppressed_%1", _shooter];
private _data = _unit getVariable [_key, [0, time]];  // [count, lastTime]
private _count = _data#0;
private _lastTime = _data#1;

// reset if last event >60s ago
if (time - _lastTime > 60) then { _count = 0; };

_count = _count + 1;
_unit setVariable [_key, [_count, time]];

// --- Threshold reached? ---
private _threshold = 3 + floor (random 3 + random 1); // 3–5 suppression events
if (_count >= _threshold) then {

    private _kv = _unit knowsAbout _shooter;
    private _add = 0.5 + random (0.7 + (diag_tickTime % 0.3));
    private _newKv = _kv + _add;
    if (_newKv > 4) then { _newKv = 4; };

    _unit reveal [_shooter, _newKv];

    // reset counter after reveal
    _unit setVariable [_key, [0, time]];

    if (VCM_DebugSuppression) then {
        systemChat format [
            "[VCOM SUPPRESSION] %1 suppressed by %2 (%3 shots) → reveal +%.2f (%.2f→%.2f)",
            _unit, _shooter, _count, _add, _kv, _newKv
        ];
    };
};
