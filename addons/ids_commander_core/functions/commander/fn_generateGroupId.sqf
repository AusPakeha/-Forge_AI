/*
    IDS Commander AI - Generate Group ID (GRP_XXXX)

    Params:
        0: _prefix (String, optional) defaults to "GRP"

    Returns:
        String group id (e.g. "GRP_0001")

    Authority: Any machine. Uses missionNamespace counters.
*/

params [
    ["_prefix","GRP"]
];

private _counterName = format ["IDS_UID_%1", _prefix];

private _current = missionNamespace getVariable [_counterName, 0];
_current = _current + 1;
missionNamespace setVariable [_counterName, _current];

private _suffix = str _current;
if (_current < 10) then {
    _suffix = format ["000%1", _current];
} else {
    if (_current < 100) then {
        _suffix = format ["00%1", _current];
    } else {
        if (_current < 1000) then {
            _suffix = format ["0%1", _current];
        };
    };
};

format ["%1_%2", _prefix, _suffix]

