params
[
    "_location"
];

private _population =
[
    _location
] call IDS_fnc_calculatePopulation;

private _infrastructure =
[
    _location
] call IDS_fnc_calculateInfrastructure;

private _military =
[
    _location
] call IDS_fnc_calculateMilitaryValue;

private _strategic =
[
    _population,
    _infrastructure,
    _military
]
call IDS_fnc_calculateStrategicValue;

_location set
[
    "Population",
    _population
];

_location set
[
    "Infrastructure",
    _infrastructure
];

_location set
[
    "MilitaryValue",
    _military
];

_location set
[
    "StrategicValue",
    _strategic
];

_location