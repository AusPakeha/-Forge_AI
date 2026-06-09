/*
    IDS Commander AI - Init Doctrine Registry

    Creates the IDS_Doctrines registry map.

    Authority only; safe to call multiple times.
*/

if !(call IDS_fnc_isAuthority) exitWith {};

if !(isNil "IDS_Doctrines") exitWith {};

IDS_Doctrines = createHashMap;

// First implementation: only AGGRESSIVE and DEFENSIVE
IDS_Doctrines set [
    "AGGRESSIVE",
    createHashMapFromArray
    [
        ["MinReserveMoney",0],
        ["MinReserveManpower",0],

        ["AttackBias",2.0],
        ["DefenseBias",0.5],

        ["MaxSimultaneousOperations",5],

        ["PreferredOperations", ["CAPTURE"]]
    ]
];

IDS_Doctrines set [
    "DEFENSIVE",
    createHashMapFromArray
    [
        ["MinReserveMoney",500],
        ["MinReserveManpower",100],

        ["AttackBias",0.6],
        ["DefenseBias",2.0],

        ["MaxSimultaneousOperations",2],

        ["PreferredOperations", ["DEFEND","PATROL","COUNTERATTACK"]]
    ]
];

true

