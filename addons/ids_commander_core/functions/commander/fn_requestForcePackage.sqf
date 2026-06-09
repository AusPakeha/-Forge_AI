/*
    IDS Commander AI - Request Force Package (chat27.sqf)

    Maps operation type + commander doctrine/personality → a force package key.

    Params:
        0: _operationType (String)
        1: _commander (HashMap)

    Returns:
        String package key (e.g. "FORCE_RECON_TEAM") or "" on failure.
*/

params [
    ["_operationType",""],
    ["_commander", objNull]
];

if !(call IDS_fnc_isAuthority) exitWith {""};

call IDS_fnc_initForcePackages;

private _doctrine = "";
if (isEqualType _commander) then
{
    _doctrine = _commander getOrDefault ["Doctrine", _commander getOrDefault ["Personality",""]];
};

// Base mapping from spec.
private _base = switch (_operationType) do
{
    case "CAPTURE": {"FORCE_RIFLE_SQUAD"};
    case "DEFEND":  {"FORCE_GARRISON"};
    case "RECON":   {"FORCE_RECON_TEAM"};
    default {""};
};

if (_base isEqualTo "") exitWith {""};

// Doctrine influence (minimal for first release).
// Aggressive: CAPTURE → motorized.
// Defensive/PMC are spec'd for future extensions; keep safe fallbacks.

switch (_doctrine) do
{
    case "AGGRESSIVE":
    {
        if (_operationType isEqualTo "CAPTURE") exitWith {"FORCE_MOTORIZED_SQUAD"};
    };

    case "DEFENSIVE":
    {
        // Spec mentions additional patrol behavior; package stays garrison for now.
    };

    case "PMC":
    {
        // Reserved for future: FORCE_MERCENARY_SQUAD.
    };

    case "SUPPORT":
    {
        // Reserved for future.
    };

    case "GUERILLA":
    {
        // Reserved for future.
    };
};

_base

