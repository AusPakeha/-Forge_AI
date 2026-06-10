/*
    IDS Commander AI - Group Registry Assign Operation (v0.1)

    Params:
        0: _groupId (String)
        1: _operationId (String)

    Returns:
        Boolean

    Authority: Server only.
*/

params [
    ["_groupId", ""],
    ["_operationId", ""]
];

if (!isServer) exitWith {false};
if (_groupId isEqualTo "") exitWith {false};
if (_operationId isEqualTo "") exitWith {false};

private _registry = missionNamespace getVariable ["IDS_GroupRegistry", createHashMap];
if (typeName _registry != "HASHMAP") exitWith {false};
if !(_registry hasKey _groupId) exitWith {false};

private _entry = _registry get _groupId;
if (typeName _entry != "HASHMAP") exitWith {false};

_entry set ["OperationID", _operationId];
_entry set ["Status", "ASSIGNED"];
_entry set ["LastUpdate", serverTime];
_registry set [_groupId, _entry];
missionNamespace setVariable ["IDS_GroupRegistry", _registry];

true
