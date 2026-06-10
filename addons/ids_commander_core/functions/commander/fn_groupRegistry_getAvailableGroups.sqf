/*
    IDS Commander AI - Group Registry Get Available Groups (v0.1)

    Params:
        0: _status (String, optional) defaults to "AVAILABLE"

    Returns:
        ARRAY of group IDs
*/

params [
    ["_status", "AVAILABLE"]
];

private _registry = missionNamespace getVariable ["IDS_GroupRegistry", createHashMap];
if (typeName _registry != "HASHMAP") exitWith {[]};

private _availableGroups = [];
{
    private _entry = _registry get _x;
    if (typeName _entry == "HASHMAP") then {
        private _alive = _entry getOrDefault ["Alive", false];
        private _entryStatus = _entry getOrDefault ["Status", ""];
        if (_alive && _entryStatus isEqualTo _status) then {
            _availableGroups pushBack _x;
        };
    };
} forEach _registry;

_availableGroups
