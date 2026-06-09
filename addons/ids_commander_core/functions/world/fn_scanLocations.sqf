/*
    Scan all major settlements on map

    Returns:
    Array<LocationObject>
*/

private _results = [];

private _center =
[
    worldSize / 2,
    worldSize / 2,
    0
];

private _terrainLocations =
nearestLocations
[
    _center,
    [
        "NameCityCapital",
        "NameCity",
        "NameVillage"
    ],
    worldSize
];

{
    private _location = _x;

    private _id =
    [
        "LOC"
    ] call IDS_fnc_generateUID;

    private _type =
    switch (type _location) do
    {
        case "NameCityCapital":
        {
            "Capital"
        };

        case "NameCity":
        {
            "City"
        };

        case "NameVillage":
        {
            "Village"
        };

        default
        {
            "Unknown"
        };
    };

    private _locationData =
    createHashMapFromArray
    [
        ["ID",_id],

        ["Name",text _location],

        ["Position",
            locationPosition _location
        ],

        ["LocationType",_type],

        ["Owner",sideUnknown],

        ["ResourceValue",0],

        ["StrategicValue",0],

        ["Population",0],

        ["Infrastructure",0],

        ["SpawnPoints",[]],

        ["ConnectedLocations",[]],

        ["LastCaptured",-1]
    ];

    _results pushBack _locationData;

} forEach _terrainLocations;

_results