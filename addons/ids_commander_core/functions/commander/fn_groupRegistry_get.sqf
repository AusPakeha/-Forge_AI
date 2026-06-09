/*
    IDS Commander AI - Group Registry Get (v0.1)

    Params:
        0: _groupId (String)
        1: _default (Any, optional)

    Returns:
        HashMap group entry or _default

    Authority: Server only (safe to call on any machine but returns null if not authority).
*/

params [
    ["_groupId",""],
    ["_default", createHashMap]
];

if (!call IDS_fnc_isAuthority) exitWith {_default};
if (_groupId isEqualTo "") exitWith {_default};

private _reg = missionNamespace getVariable ["IDS_GroupRegistry", createHashMap];

private _entry = _reg getOrDefault [_groupId, _default];
_entry

