/*
    IDS Commander AI - Plan Operation (v0.1)

    Params:
        0: STRING - OperationID

    Authority: Server only.
*/

params ["_operationID"];

if (!isServer) exitWith {};

private _operation = [_operationID] call IDS_fnc_getOperationData;
if (typeName _operation != "HASHMAP") exitWith {};

private _requiredPackages = [];

private _type = _operation getOrDefault ["Type", "CAPTURE"];

switch (_type) do {
    case "CAPTURE": {
        _requiredPackages pushBack "FORCE_RIFLE_SQUAD";
    };
    default {
        // Default: no packages
    };
};

_operation set ["RequiredForcePackages", _requiredPackages];

[_operationID, "ALLOCATING_FORCES"] call IDS_fnc_setOperationState;

true
