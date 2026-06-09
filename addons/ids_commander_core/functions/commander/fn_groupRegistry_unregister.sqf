/*
    IDS Commander AI - Group Registry Unregister (v0.1)

    Purpose:
        Mark a group as dead/unregistered in IDS_GroupRegistry.

    Params:
        0: _groupId (String)

    Returns:
        Boolean

    Authority: Server only.
*/

params [
    ["_groupId","" ]
];

if (!isServer) exitWith {false};
if (_groupId isEqualTo "") exitWith {false};

private _reg = missionNamespace getVariable ["IDS_GroupRegistry", createHashMap];
if (typeName _reg != "HASHMAP") exitWith {false};

if (_reg hasKey _groupId) then {
    private _entry = _reg get _groupId;

    if (typeName _entry == "HASHMAP") then {
        _entry set ["Alive", false];
        _entry set ["DestroyTime", serverTime];
        _reg set [_groupId, _entry];
    };

    missionNamespace setVariable ["IDS_GroupRegistry", _reg];
    true
} else {
    false
}

