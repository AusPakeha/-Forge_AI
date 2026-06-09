/*
    IDS Commander AI - Init Force Packages (chat27.sqf)

    Creates the global IDS_ForcePackages registry.

    Authority only; safe to call multiple times.
*/

if !(call IDS_fnc_isAuthority) exitWith {};

if !(isNil "IDS_ForcePackages") exitWith {true};

IDS_ForcePackages = createHashMap;

// NOTE: This first release keeps it intentionally small.

IDS_ForcePackages set
[
    "FORCE_RECON_TEAM",
    createHashMapFromArray
    [
        ["Category","RECON"],

        ["MoneyCost",80],
        ["ManpowerCost",4],

        ["Composition",
            [
                "O_recon_TL_F",
                "O_recon_F",
                "O_recon_M_F",
                "O_recon_medic_F"
            ]
        ],

        ["CombatPower",40]
    ]
];

IDS_ForcePackages set
[
    "FORCE_GARRISON",
    createHashMapFromArray
    [
        ["Category","GARRISON"],

        ["MoneyCost",60],
        ["ManpowerCost",6],

        // First release: keep composition empty until a stable garrison template is decided.
        ["Composition",[]],

        ["CombatPower",70]
    ]
];

IDS_ForcePackages set
[
    "FORCE_RIFLE_SQUAD",
    createHashMapFromArray
    [
        ["Category","INFANTRY"],

        ["MoneyCost",100],
        ["ManpowerCost",8],

        ["Composition",
            [
                "O_Soldier_SL_F",
                "O_Soldier_F",
                "O_Soldier_F",
                "O_Soldier_AR_F",
                "O_medic_F",
                "O_Soldier_LAT_F",
                "O_Soldier_F",
                "O_Soldier_F"
            ]
        ],

        ["CombatPower",100]
    ]
];

IDS_ForcePackages set
[
    "FORCE_MOTORIZED_SQUAD",
    createHashMapFromArray
    [
        ["Category","MOTORIZED"],

        ["MoneyCost",160],
        ["ManpowerCost",10],

        ["Composition",
            [
                "O_Soldier_SL_F",
                "O_Soldier_F",
                "O_Soldier_F",
                "O_Soldier_AR_F",
                "O_medic_F",
                "O_Soldier_LAT_F",
                "O_Soldier_F",
                "O_Soldier_F"
            ]
        ],

        ["CombatPower",150],

        ["RequiresVehicle",true]
    ]
];

true

