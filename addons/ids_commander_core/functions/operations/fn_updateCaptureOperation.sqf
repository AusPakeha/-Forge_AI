/*
    IDS Commander AI - Update CAPTURE operation (type-specific update)

    Converts legacy capture logic into a simple operation lifecycle.
*/

params ["_op"];

if (!isServer) exitWith {};
if (isNil "_op") exitWith {};

private _operationID = _op getOrDefault ["ID", ""];
if (_operationID isEqualTo "") exitWith {};

private _state = _op getOrDefault ["State", "CREATED"];

switch (_state) do
{
    case "CREATED":
    {
        [_operationID] call IDS_fnc_planOperation;
    };
    case "ALLOCATING_FORCES":
    {
        [_operationID] call IDS_fnc_allocateOperationForces;
    };
    case "STAGING":
    {
        [_operationID] call IDS_fnc_stageOperation;
    };
    case "EXECUTING":
    {
        private _operation = [_operationID] call IDS_fnc_getOperationData;
        if (typeName _operation != "HASHMAP") exitWith {};

        private _targetLocation = [_operation get "TargetLocation"] call IDS_fnc_getLocationData;
        private _targetPos = _targetLocation getOrDefault ["Position", []];
        if (_targetPos isEqualTo []) exitWith {};
        private _capturingGroups = 0;
        private _aliveGroups = 0;
        private _timeout = _operation getOrDefault ["Timeout", 1800];

        {
            private _group = [_x] call IDS_fnc_getGroupObject;
            if !(isNull _group) then {
                if (({alive _x} count units _group) > 0) then {
                    _aliveGroups = _aliveGroups + 1;
                };

                private _leader = leader _group;
                if (
                    alive _leader &&
                    (_leader distance2D _targetPos) < 100
                ) then {
                    _capturingGroups = _capturingGroups + 1;
                };
            };
        } forEach (_operation getOrDefault ["AssignedGroups", []]);

        if (_aliveGroups == 0) then {
            [_operationID] call IDS_fnc_failOperation;
            exitWith {};
        };

        if (_capturingGroups > 0) then {
            [_operationID] call IDS_fnc_completeCaptureOperation;
            exitWith {};
        };

        if (serverTime > ((_operation get "StartTime") + _timeout)) then {
            [_operationID] call IDS_fnc_failOperation;
            exitWith {};
        };
    };
    case "SUCCEEDED":
    case "FAILED":
    {
        // Terminal states; nothing to do.
    };
    default
    {
        // Legacy compatibility fallback.
        private _status = _op getOrDefault ["Status", "DEPLOY"];
        switch (_status) do
        {
            case "DEPLOY":   { [_op] call IDS_fnc_operationDeploy; };
            case "MARCH":    { [_op] call IDS_fnc_operationMarch; };
            case "ENGAGE":   { [_op] call IDS_fnc_operationEngage; };
            case "RESOLVE":  { [_op] call IDS_fnc_operationResolve; };
            default { _op set ["Status","COMPLETED"]; };
        };
    };
};

true

