/*
    IDS Commander AI - Generate ID (v0.1)

    Purpose:
        Generate framework-wide unique IDs.

    Params:
        0: _prefix (String)

    Returns:
        String

    Authority:
        Server only.
*/

params ["_prefix"];

if (!isServer) exitWith {""};

private _counters = missionNamespace getVariable [
    "IDS_IDCounters",
    createHashMap
];

private _current = (_counters getOrDefault [_prefix, 0]) + 1;

_counters set [_prefix, _current];

missionNamespace setVariable [
    "IDS_IDCounters",
    _counters,
    true
];

format [
    "%1_%2",
    _prefix,
    [_current, 6] call IDS_fnc_padNumber
]
