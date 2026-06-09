Now we move from architecture into implementation.

Before writing `fn_spawnPackage.sqf`, we need a small but important subsystem:

# ID Generation System

Do **not** create separate generators for groups, operations, vehicles, commanders, etc.

Instead create a single centralized ID service.

This avoids collisions and simplifies save/load.

---

# File Structure

```text
systems/core/
├── fn_generateID.sqf
├── fn_initIDSystem.sqf
└── fn_resetIDSystem.sqf
```

---

# Global State

Stored in:

```sqf
missionNamespace setVariable [
    "IDS_IDCounters",
    createHashMap
];
```

Example:

```sqf
[
    ["GRP", 15],
    ["OP", 4],
    ["CMD", 2],
    ["VEH", 8]
]
```

---

# fn_initIDSystem.sqf

**Purpose**

Initialize counters during framework startup.

**Authority**

Server only.

```sqf
/*
    File: fn_initIDSystem.sqf

    Description:
    Initializes global ID counters.

    Authority:
    Server Only
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
```

---

# fn_generateID.sqf

**Purpose**

Generate unique framework IDs.

**Input**

```sqf
"GRP"
"OP"
"CMD"
"VEH"
```

**Output**

```sqf
"GRP_000001"
```

---

### Implementation

```sqf
/*
    File: fn_generateID.sqf

    Description:
    Generates framework-wide unique IDs.

    Parameters:
    0: STRING - Prefix

    Returns:
    STRING

    Authority:
    Server Only
*/

params ["_prefix"];

if (!isServer) exitWith {""};

private _counters = missionNamespace getVariable [
    "IDS_IDCounters",
    createHashMap
];

private _current = _counters getOrDefault [
    _prefix,
    0
];

_current = _current + 1;

_counters set [
    _prefix,
    _current
];

missionNamespace setVariable [
    "IDS_IDCounters",
    _counters
];

format [
    "%1_%2",
    _prefix,
    [_current, 6] call CBA_fnc_formatNumber
]
```

---

# Problem With CBA_fnc_formatNumber

Do **not** actually use that implementation.

`CBA_fnc_formatNumber` is intended for display formatting and may introduce separators depending on configuration.

Instead create a dedicated padding helper.

---

# fn_padNumber.sqf

```sqf
/*
    File: fn_padNumber.sqf

    Description:
    Left-pads integer values.

    Example:
    [15,6] call IDS_fnc_padNumber

    Returns:
    "000015"
*/

params [
    "_number",
    "_digits"
];

private _str = str _number;

while {(count _str) < _digits} do {
    _str = "0" + _str;
};

_str
```

---

# Revised fn_generateID.sqf

```sqf
params ["_prefix"];

if (!isServer) exitWith {""};

private _counters = missionNamespace getVariable [
    "IDS_IDCounters",
    createHashMap
];

private _current = (_counters getOrDefault [_prefix,0]) + 1;

_counters set [_prefix,_current];

missionNamespace setVariable [
    "IDS_IDCounters",
    _counters
];

format [
    "%1_%2",
    _prefix,
    [_current,6] call IDS_fnc_padNumber
]
```

---

# Next Function: fn_registerGroup.sqf

This is the first truly important registry function because every spawned force package must pass through it.

Contract:

```sqf
[
    _group,
    _commanderID,
    _forcePackage
] call IDS_fnc_registerGroup;
```

Returns:

```sqf
"GRP_000001"
```

and creates:

```sqf
IDS_GroupRegistry[
    "GRP_000001"
]
```

---

## Proposed Registry Object

For v0.1:

```sqf
private _groupData = createHashMapFromArray [

    ["ID", _groupID],

    ["Group", _group],

    ["CommanderID", _commanderID],

    ["OperationID", ""],

    ["Faction", side _group],

    ["ForcePackage", _forcePackage],

    ["Status", "AVAILABLE"],

    ["CombatPower", 100],

    ["PersonnelCount", count units _group],

    ["VehicleCount", 0],

    ["SpawnTime", serverTime],

    ["LastUpdate", serverTime]
];
```

Stored as:

```sqf
private _registry = missionNamespace getVariable [
    "IDS_GroupRegistry",
    createHashMap
];

_registry set [
    _groupID,
    _groupData
];
```

---

# Important Correction to Earlier Design

I would revise one earlier recommendation:

Do **not** remove engine objects from the runtime registry.

Store them.

Example:

```sqf
["Group", _group]
```

is perfectly acceptable **in runtime memory**.

The restriction only applies to:

```text
Save files
Persistence exports
Network serialization
```

Runtime systems should absolutely store direct references because:

* faster lookups
* less resolution overhead
* simpler debugging

For save/load:

```sqf
IDS_fnc_serializeGroupRegistry
```

can strip engine references before writing to disk.

---

# After fn_registerGroup

The next implementation sequence should be:

```text
fn_registerGroup.sqf
↓
fn_getGroupData.sqf
↓
fn_getAvailableGroups.sqf
↓
fn_spawnPackage.sqf
↓
fn_createOperation.sqf
```

At that point you'll have the first complete path:

```text
Commander
    ↓
Create CAPTURE Operation
    ↓
Request FORCE_RIFLE_SQUAD
    ↓
Spawn Squad
    ↓
Register Squad
    ↓
Assign To Operation
```

which is the first executable slice of the IDS Commander AI war loop.
