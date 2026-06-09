/*
    IDS Commander AI
    PreInit
*/

missionNamespace setVariable
[
    "IDS_Commanders",
    createHashMap
];

missionNamespace setVariable
[
    "IDS_WorldDB",
    createHashMap
];

missionNamespace setVariable
[
    "IDS_Settings",
    createHashMapFromArray
    [
        ["CommanderTick",300],
        ["EconomyTick",300],
        ["IntelTick",30],
        ["OperationTick",60]
    ]
];

missionNamespace setVariable ["IDS_WorldDB", createHashMap];
missionNamespace setVariable ["IDS_Factions", createHashMap];
missionNamespace setVariable ["IDS_Commanders", createHashMap];
missionNamespace setVariable ["IDS_Operations", createHashMap];
missionNamespace setVariable ["IDS_Intel", createHashMap];