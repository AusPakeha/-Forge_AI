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

private _worldDB = missionNamespace getVariable ["IDS_WorldDB", createHashMap];
private _intelDB = _worldDB getOrDefault ["Intel", createHashMap];

_intelDB set
[
    _intelID,
    _intel
];

_worldDB set ["Intel", _intelDB];
missionNamespace setVariable ["IDS_WorldDB", _worldDB, true];
IDS_WorldDB = _worldDB;

_intelID