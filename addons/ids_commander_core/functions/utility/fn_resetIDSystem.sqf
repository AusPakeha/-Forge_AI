/*
    IDS Commander AI - Reset ID System (v0.1)

    Purpose:
        Reset global ID counters back to the initial state.

    Authority:
        Server only.
*/

if (!isServer) exitWith {false};

private _counters = createHashMapFromArray [
    ["GRP", 0],
    ["OP", 0],
    ["CMD", 0],
    ["VEH", 0]
];

missionNamespace setVariable [
    "IDS_IDCounters",
    _counters,
    true
];

true
