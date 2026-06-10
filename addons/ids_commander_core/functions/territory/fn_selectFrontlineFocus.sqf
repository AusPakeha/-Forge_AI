/*
    IDS Commander AI - Select Frontline Focus (chat28.sqf)

    Chooses Primary/Secondary/Reserve frontline regions based on doctrine.

    Params:
      0: _commander (HashMap)

    Returns:
      HashMap [
        ["Primary", regionId],
        ["Secondary", regionIdOr""],
        ["Reserve", regionIdOr""],
        ["Regions", array]
      ]

    Authoritative only.

    v0.1 scoring model (simple):
      Score = StrategicValue + ThreatScore + FrontlineScore

    doctrine influence:
      AGGRESSIVE => primary gets highest fraction, fewer reserve
      DEFENSIVE => distribute more evenly
      (other doctrines reserved for future)
*/

if !(call IDS_fnc_isAuthority) exitWith {createHashMap};

params ["_commander"];

private _regions = IDS_WorldDB getOrDefault ["FrontlineRegions", []];
if (_regions isEqualTo []) exitWith {createHashMap};

private _doctrine = _commander getOrDefault ["Doctrine", _commander getOrDefault ["Personality", ""]];

// Build region score list
private _scored = [];
{
    private _regionId = _x select 0;
    private _locIds = _x select 1;

    private _threat = 0;
    private _strategic = 0;
    private _frontlineCount = count _locIds;

    {
      private _loc = [_x] call IDS_fnc_getLocationData;
      if (isNull _loc) exitWith {};

      _threat = _threat + (_loc getOrDefault ["ThreatScore",0]);
      _strategic = _strategic + (_loc getOrDefault ["StrategicValue",0]);
    } forEach _locIds;

    // Normalize a little to keep consistent magnitude.
    private _frontlineScore = _frontlineCount * 10;

    private _score = _strategic + _threat + _frontlineScore;

    // Doctrine tweak
    switch (_doctrine) do
    {
        case "AGGRESSIVE": { _score = _score * 1.10; };
        case "DEFENSIVE": { _score = _score * 0.95; };
        default {};
    };

    _scored pushBack [_regionId, _score];

} forEach _regions;

// Sort descending by score
_scored sort false; // sorts ascending by default? ensure proper by using custom
_scored = _scored sortBy {_x select 1};
_scored reverse;

private _primary = "";
private _secondary = "";
private _reserve = "";

if (count _scored > 0) then { _primary = (_scored select 0) select 0; };
if (count _scored > 1) then { _secondary = (_scored select 1) select 0; };
if (count _scored > 2) then { _reserve = (_scored select 2) select 0; };

private _result = createHashMapFromArray
[
    ["Primary", _primary],
    ["Secondary", _secondary],
    ["Reserve", _reserve],
    ["Regions", (_scored apply { _x select 0 })]
];

_result

