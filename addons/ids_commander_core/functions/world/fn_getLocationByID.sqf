/*
    IDS Commander AI - Get Location By ID

    Params:
        0: STRING - Location ID

    Returns:
        HASHMAP - Location data or nil when not found
*/

params ["_locationID"];

private _result = nil;

private _locations = missionNamespace getVariable ["IDS_Locations", createHashMap];

if ((typeName _locations == "HASHMAP") && (_locations hasKey _locationID)) then {
    _result = _locations get _locationID;
} else {
    private _worldLocations = IDS_WorldDB getOrDefault ["Locations", []];
    if (typeName _worldLocations == "HASHMAP") then {
        if (_worldLocations hasKey _locationID) then {
            _result = _worldLocations get _locationID;
        };
    } else {
        {
            if ((_x getOrDefault ["ID", ""]) isEqualTo _locationID) then {
                _result = _x;
                exitWith {};
            };
        } forEach _worldLocations;
    };
};

_result
