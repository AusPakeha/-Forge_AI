/*
    IDS Commander AI - Initialize ID System (v0.1)

    Purpose:
        Initialize global ID counters used by the commander AI.

    Authority:
        Server only.
*/

if (!isServer) exitWith {};

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
