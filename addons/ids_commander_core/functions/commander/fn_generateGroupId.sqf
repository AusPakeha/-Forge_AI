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

format ["%1_%2", _prefix, str _current]

