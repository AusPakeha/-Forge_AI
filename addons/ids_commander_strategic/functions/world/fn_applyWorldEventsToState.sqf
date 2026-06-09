/*
    IDS Commander AI - Apply World Events to Commander State (placeholder)

    First implementation hook inspired by chat31.sqf.

    Responsibilities:
    - Read missionNamespace world event state
    - For each active event, apply minimal effects to commander-side fields
    - Keep logic safe to call repeatedly

    Notes:
    - This repo does not yet have a fully modeled economy/territory adapter
      for events.
    - This function only writes commander-visible state fields that
      strategic planning and later systems can read.

    Event support (first vertical slice):
    - Resource Boom: sets a per-location ResourceMultiplier entry (if a target exists)
    - Intel Leak: appends KnownLocations to commander KnownLocations (best-effort)
*/

params [
    ["_commander", objNull],
    ["_worldEvents", createHashMap],
    ["_activeEvents", []]
];

if (isNull _commander) exitWith {false};
if !(call IDS_fnc_isAuthority) exitWith {false};

private _cmdWorld = _worldEvents; // alias
private _cmdActive = _activeEvents;

// Init commander state holders
private _recent = _commander getOrDefault ["RecentEvents", []];
private _knownLocations = _commander getOrDefault ["KnownLocations", []];

{
    private _type = _x getOrDefault ["Type", ""];
    private _name = _x getOrDefault ["Name", ""];
    private _target = _x getOrDefault ["Target", ""];
    private _data = _x getOrDefault ["Data", createHashMap];

    // Keep RecentEvents on commander for UI/debug
    if !(_name isEqualTo "") then {
        _recent pushBack _name;
        if ((count _recent) > 8) then { _recent deleteAt 0; };
    };

    switch (_type) do {
        // ECONOMIC
        case "ECONOMIC": {
            // This placeholder expects event name to differentiate effects.
            // Resource Boom
            if ((_name toUpper) isEqualTo "RESOURCE BOOM") then {
                // Data may contain ResourceMultiplier
                private _mult = _data getOrDefault ["ResourceMultiplier", 2.0];

                // Best effort: if world DB exists, try to update target location.
                private _worldDB = missionNamespace getVariable ["IDS_WorldDB", objNull];
                if !(isNull _worldDB) then {
                    private _locs = _worldDB getOrDefault ["Locations", []];
                    {
                        if ((_x getOrDefault ["ID", ""]) isEqualTo _target) exitWith {
                            _x set ["ResourceMultiplier", _mult];
                        };
                    } forEach _locs;
                };
            };
        };

        // INTEL
        case "INTEL": {
            if ((_name toUpper) isEqualTo "INTEL LEAK") then {
                private _kl = _data getOrDefault ["KnownLocations", []];
                if (typeName _kl == "ARRAY") then {
                    {
                        if !(_x in _knownLocations) then { _knownLocations pushBack _x; };
                    } forEach _kl;
                };
            };
        };

        // Default: no-op
        default { };
    };

} forEach _cmdActive;

_commander set ["KnownLocations", _knownLocations];
_commander set ["RecentEvents", _recent];

true

