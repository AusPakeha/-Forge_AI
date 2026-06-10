/*
    IDS Commander AI
    PreInit
*/

IDS_Commanders = createHashMap;
IDS_WorldDB = createHashMap;
IDS_Settings = createHashMapFromArray
[
    ["CommanderTick",300],
    ["EconomyTick",300],
    ["IntelTick",30],
    ["OperationTick",60]
];
IDS_Factions = createHashMap;
IDS_Operations = createHashMap;
IDS_Intel = createHashMap;
IDS_Locations = createHashMap;

missionNamespace setVariable
[
    "IDS_Commanders",
    IDS_Commanders,
    true
];

missionNamespace setVariable
[
    "IDS_WorldDB",
    IDS_WorldDB,
    true
];

missionNamespace setVariable
[
    "IDS_Locations",
    IDS_Locations,
    true
];

missionNamespace setVariable
[
    "IDS_Settings",
    IDS_Settings,
    true
];

missionNamespace setVariable ["IDS_Factions", IDS_Factions, true];
missionNamespace setVariable ["IDS_Operations", IDS_Operations, true];
missionNamespace setVariable ["IDS_Intel", IDS_Intel, true];