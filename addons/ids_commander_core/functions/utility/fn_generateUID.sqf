/*
["LOC"] call IDS_fnc_generateUID;
*/

params
[
    ["_prefix","OBJ"]
];

private _counterName = format
[
    "IDS_UID_%1",
    _prefix
];

private _current =
missionNamespace getVariable
[
    _counterName,
    0
];

_current = _current + 1;

missionNamespace setVariable
[
    _counterName,
    _current
];

format
[
    "%1_%2",
    _prefix,
    str _current
];