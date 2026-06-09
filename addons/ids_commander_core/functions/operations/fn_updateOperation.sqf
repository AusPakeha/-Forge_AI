/*
    IDS Commander AI - Update Operation (type router + phase router)

    chat26.sqf integration:
    - Operations are routed by Type (CAPTURE/DEFEND/PATROL/RECON)
    - Each operation type has a dedicated update function
    - The existing DEPLOY/MARCH/ENGAGE/RESOLVE statuses remain as a temporary
      generic phase model for CAPTURE until full per-type lifecycles exist.
*/

params ["_op"];

if (isNil "_op") exitWith {};

// ------------------------------
// Operation State Machine Router
// ------------------------------

private _type = _op getOrDefault ["Type","CAPTURE"];

// New contract field (preferred)
private _state = _op getOrDefault ["State", ""];

// Legacy field (temporary compatibility)
private _legacyStatus = _op getOrDefault ["Status", ""];

// If legacy operation has no State yet, map legacy Status to State.
if (_state isEqualTo "") then
{
    private _mapped = switch (_legacyStatus) do
    {
        case "DEPLOY":   { "STAGING" };
        case "MARCH":    { "EXECUTING" };
        case "ENGAGE":   { "EXECUTING" };
        case "RESOLVE":  { "EXECUTING" }; // CAPTURE resolution happens inside resolve/update
        default           { "CREATED" };
    };

    _op set ["State", _mapped];
};

// One unified completion marker used by existing code.
// When State becomes terminal, we keep calling type routers in a minimal way.

switch (_type) do
{
    case "CAPTURE":
    {
        // Type-specific phase execution
        [_op] call IDS_fnc_updateCaptureOperation;
    };

    case "DEFEND":
    {
        // v0: fall back to capture lifecycle to keep system working.
        [_op] call IDS_fnc_updateDefendOperation;
    };

    case "PATROL":
    {
        [_op] call IDS_fnc_updatePatrolOperation;
    };

    case "RECON":
    {
        [_op] call IDS_fnc_updateReconOperation;
    };

    default
    {
        // Unknown operation type: avoid hard failure.
        _op set ["Status","COMPLETED"];
        _op set ["State","FAILED"];
    };
};

true








