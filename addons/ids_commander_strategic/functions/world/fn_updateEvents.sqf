/*
    IDS Commander AI - World Events Manager (placeholder)

    This is the first integration point for chat31’s “World Event System”.

    Current repo note:
    - A full world-event model does not yet exist.
    - This placeholder provides a safe entrypoint and state plumbing
      so commander code can react once the rest of the model is implemented.

    Responsibilities (for now):
    - Ensure the save-state/event arrays exist
    - Generate at most one event per tick (server authority)
    - Expire events after duration
    - Keep RecentEvents bounded
*/

if !(call IDS_fnc_isAuthority) exitWith {false};

// Event state is stored in missionNamespace so it can be persistence-friendly.
private _worldEvents = missionNamespace getVariable ["IDS_WorldEvents", createHashMap];

// Init fields
if (isNil {_worldEvents getOrDefault ["ActiveEvents", nil]}) then {
    _worldEvents set ["ActiveEvents", []];
};
if (isNil {_worldEvents getOrDefault ["RecentEvents", nil]}) then {
    _worldEvents set ["RecentEvents", []];
};

private _active = _worldEvents getOrDefault ["ActiveEvents", []];
private _recent = _worldEvents getOrDefault ["RecentEvents", []];

// Expire
private _now = serverTime;
private _stillActive = [];
{
    private _st = _x getOrDefault ["StartTime", _now];
    private _dur = _x getOrDefault ["Duration", 0];
    private _exp = _st + _dur;

    if (_now <= _exp) then {
        _stillActive pushBack _x;
    };
} forEach _active;

_worldEvents set ["ActiveEvents", _stillActive];

// Generate one new event if none exist or occasionally.
// Weighted generation is not implemented yet; we create a Resource Boom template when possible.
private _shouldGenerate = (count _stillActive) isEqualTo 0;
if (_shouldGenerate) then {
    private _event = createHashMapFromArray [
        ["ID", format ["EVENT_%1", _now]],
        ["Type","ECONOMIC"],
        ["Name","Resource Boom"],
        ["StartTime", _now],
        ["Duration", 3600],
        ["Target",""],
        ["Data", createHashMap]
    ];

    _active pushBack _event;
    _stillActive = _active;
    _worldEvents set ["ActiveEvents", _stillActive];

    _recent pushBack (_event getOrDefault ["Name","EVENT"]);
    if ((count _recent) > 8) then { _recent deleteAt 0; };

    _worldEvents set ["RecentEvents", _recent];
};

missionNamespace setVariable ["IDS_WorldEvents", _worldEvents, true];

true

