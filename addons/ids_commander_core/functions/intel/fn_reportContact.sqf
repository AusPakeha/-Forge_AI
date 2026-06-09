params
[
    "_observer",
    "_target"
];

private _intelID =
[
    "INTEL"
]
call IDS_fnc_generateUID;

private _intel =
createHashMapFromArray
[
    ["ID",_intelID],

    ["Reporter",_observer],

    ["Target",_target],

    ["Position",
        getPosWorld _target
    ],

    ["TimeStamp",
        serverTime
    ],

    ["Confidence",100],

    ["Type","EnemyContact"]
];

private _intelDB =
IDS_WorldDB get "Intel";

_intelDB set
[
    _intelID,
    _intel
];

_intelID