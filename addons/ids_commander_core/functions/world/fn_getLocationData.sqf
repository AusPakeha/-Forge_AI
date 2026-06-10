/*
    IDS Commander AI - Get Location Data (v0.1)

    Params:
        0: STRING - Location ID

    Returns:
        HASHMAP - Location data or empty hash map
*/

params ["_locationID"];

private _locations = missionNamespace getVariable ["IDS_Locations", createHashMap];
private _location = createHashMap;

if ((typeName _locations == "HASHMAP") && (_locations hasKey _locationID)) then {
    _location = _locations get _locationID;
} else {
    private _worldLocs = IDS_WorldDB getOrDefault ["Locations", []];
    {
        if ((_x getOrDefault ["ID", ""]) isEqualTo _locationID) then {
            _location = _x;
        };
    } forEach _worldLocs;
};

_location
