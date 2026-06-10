This is where I would make a significant architectural adjustment before writing more code.

## Do NOT use Combat Power as the primary force-accounting mechanism

Combat Power is useful for **evaluation**, but it is a poor primary resource for **allocation**.

A commander doesn't actually own "300 Combat Power".

A commander owns:

```text
Groups
Money
Manpower
Territory
```

Combat Power is a derived metric.

---

# Revised Commander Architecture

Instead of:

```sqf
["AvailableCombatPower",300]
["CommittedCombatPower",100]
```

use:

```sqf
["ReserveGroups",[]]
["AssignedGroups",[]]
["ActiveOperations",[]]
```

Then calculate combat power when needed.

This avoids synchronization issues.

---

# Commander Registry Framework

Create:

```text
systems/commander/
├── fn_initCommanders.sqf
├── fn_createCommander.sqf
├── fn_getCommanderData.sqf
├── fn_addReserveGroup.sqf
├── fn_assignGroupToCommanderOperation.sqf
├── fn_releaseGroupFromOperation.sqf
├── fn_getCommanderReserveGroups.sqf
└── fn_calculateCommanderCombatPower.sqf
```

---

# Commander Object Schema

For v0.1:

```sqf
private _commander = createHashMapFromArray [

    ["ID", "CMD_OPFOR"],

    ["Faction", "OPFOR_CSAT"],

    ["Side", east],

    ["Doctrine", "AGGRESSIVE"],

    ["Money", 10000],

    ["Manpower", 100],

    ["ReserveGroups", []],

    ["AssignedGroups", []],

    ["ActiveOperations", []],

    ["CreatedTime", serverTime]
];
```

Stored in:

```sqf
missionNamespace setVariable [
    "IDS_Commanders",
    createHashMap,
    true
];
```

---

# fn_initCommanders.sqf

```sqf
/*
    File: fn_initCommanders.sqf
*/

if (!isServer) exitWith {};

missionNamespace setVariable [
    "IDS_Commanders",
    createHashMap,
    true
];
```

---

# fn_createCommander.sqf

```sqf
/*
    Parameters:
    0: Commander ID
    1: Faction ID
    2: Doctrine
*/

params [
    "_commanderID",
    "_factionID",
    "_doctrine"
];

if (!isServer) exitWith {false};

private _template =
[
    _factionID
]
call IDS_fnc_getFactionTemplate;

private _commander = createHashMapFromArray [

    ["ID", _commanderID],

    ["Faction", _factionID],

    ["Side", _template get "Side"],

    ["Doctrine", _doctrine],

    ["Money", 10000],

    ["Manpower", 100],

    ["ReserveGroups", []],

    ["AssignedGroups", []],

    ["ActiveOperations", []],

    ["CreatedTime", serverTime]
];

private _commanders =
    missionNamespace getVariable [
        "IDS_Commanders",
        createHashMap
    ];

_commanders set [
    _commanderID,
    _commander
];

missionNamespace setVariable [
    "IDS_Commanders",
    _commanders
];

true
```

---

# fn_getCommanderData.sqf

```sqf
params ["_commanderID"];

private _commanders =
    missionNamespace getVariable [
        "IDS_Commanders",
        createHashMap
    ];

_commanders getOrDefault [
    _commanderID,
    createHashMap
]
```

---

# Reserve Force Registration

When a package spawns:

Current flow:

```text
Spawn Package
    ↓
Register Group
```

New flow:

```text
Spawn Package
    ↓
Register Group
    ↓
Add To Commander Reserve Pool
```

---

# fn_addReserveGroup.sqf

```sqf
params [
    "_commanderID",
    "_groupID"
];

if (!isServer) exitWith {};

private _commander =
[
    _commanderID
]
call IDS_fnc_getCommanderData;

private _reserve =
    _commander get "ReserveGroups";

if !(_groupID in _reserve) then {

    _reserve pushBack _groupID;
};

_commander set [
    "ReserveGroups",
    _reserve
];
```

---

# Important Improvement To Allocation

Current operation allocation:

```text
Need Rifle Squad
        ↓
Spawn Rifle Squad
```

This should change.

---

# New Allocation Algorithm

```text
Need Rifle Squad
        ↓
Reserve Group Exists?
        ↓
YES
        ↓
Assign Existing Group

NO
        ↓
Spawn New Group
        ↓
Assign New Group
```

This gives us:

* force reuse
* operational reserves
* future reinforcement capability
* realistic force management

---

# fn_getCommanderReserveGroups.sqf

```sqf
params ["_commanderID"];

private _commander =
[
    _commanderID
]
call IDS_fnc_getCommanderData;

+(_commander get "ReserveGroups")
```

Return a copy, not the original array.

---

# Dynamic Combat Power

Now combat power becomes derived.

---

# fn_calculateCommanderCombatPower.sqf

```sqf
params ["_commanderID"];

private _groups =
[
    _commanderID
]
call IDS_fnc_getCommanderReserveGroups;

private _power = 0;

{
    private _groupData =
    [
        _x
    ]
    call IDS_fnc_getGroupData;

    _power =
        _power +
        (_groupData getOrDefault [
            "CombatPower",
            0
        ]);

} forEach _groups;

_power
```

---

# Why This Matters

Later commander decisions become:

```sqf
private _availablePower =
[
    _commanderID
]
call IDS_fnc_calculateCommanderCombatPower;
```

Then:

```sqf
if (_availablePower > 200) then {

    createAttackOperation;
};
```

instead of maintaining duplicated accounting fields.

---

# Required Refactor To fn_allocateOperationForces

Current:

```text
Operation
    ↓
Spawn Package
```

Target:

```text
Operation
    ↓
Check Reserve Pool
    ↓
Use Existing Force
    ↓
Otherwise Spawn Force
```

That function becomes the heart of operational force management.

---

# After This Sprint

The framework will have:

```text
✓ ID System
✓ Group Registry
✓ Faction Templates
✓ Force Packages
✓ Operations
✓ Operation Execution
✓ Commander Registry
✓ Reserve Forces
```

At that point the next major system should finally be:

```text
World Generation
        ↓
Location Graph
        ↓
Adjacency Network
        ↓
Frontline Detection
```

because then the commander can start making geographically valid strategic decisions rather than selecting arbitrary map locations.

That territory graph is the foundation for the actual strategic AI layer described in the original IDS Commander AI design.
