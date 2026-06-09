/*
    IDS Commander AI - Request Force Package (Force Package Framework contract) (v0.1)

    Maps operation type + commander/personality → force package type string.

    Contract (spawn boundary later):
        Operation requests Force Package type.

    Params:
        0: _operationType (String) e.g. "CAPTURE"
        1: _commander (HashMap or objNull)

    Returns:
        packageType (String) or ""

    Notes:
    - Authority: server only.
    - This is a minimal mapping for v0.1.
*/

params [
    ["_operationType",""],
    ["_commander", objNull]
];

if (!call IDS_fnc_isAuthority) exitWith {""};

call IDS_fnc_initForcePackages;

private _doctrine = "";
if (isEqualType _commander) then {
    _doctrine = _commander getOrDefault ["Doctrine", _commander getOrDefault ["Personality", ""]];
};

private _base = switch (_operationType) do {
    case "CAPTURE": {"FORCE_RIFLE_SQUAD"};
    case "DEFEND":  {"FORCE_GARRISON"};
    case "RECON":   {"FORCE_RECON_TEAM"};
    default {""};
};

if (_base isEqualTo "") exitWith {""};

// Doctrine influence (minimal for v0.1)
if (_doctrine isEqualTo "AGGRESSIVE") then {
    if (_operationType isEqualTo "CAPTURE") exitWith {"FORCE_MOTORIZED_SQUAD"};
};

_base

