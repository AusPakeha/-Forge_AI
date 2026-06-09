# IDS Commander AI - Data Model Specification

Version: 0.1

This document defines the core data structures used throughout IDS Commander AI.

All systems must use these structures.

Do not create alternate versions of these objects.

---

# Commander Object

Represents the active AI commander.

Type:

HashMap

Example:

```sqf
IDS_Commander = createHashMapFromArray
[
    ["ID","CMD_001"],
    ["Name","Enemy Commander"],
    ["Personality","Aggressive"],
    ["Resources",1000],
    ["Money",0],
    ["Manpower",500],
    ["ControlledLocations",[]],
    ["KnownIntel",[]],
    ["Operations",[]],
    ["ThreatLevel",0],
    ["Created",serverTime]
];
```

Fields:

| Field               | Type   | Description                   |
| ------------------- | ------ | ----------------------------- |
| ID                  | String | Unique commander ID           |
| Name                | String | Commander display name        |
| Personality         | String | Active doctrine               |
| Resources           | Number | General resources             |
| Money               | Number | Currency used by PMC doctrine |
| Manpower            | Number | Available manpower pool       |
| ControlledLocations | Array  | Owned location IDs            |
| KnownIntel          | Array  | Intel IDs                     |
| Operations          | Array  | Operation IDs                 |
| ThreatLevel         | Number | Current threat estimate       |
| Created             | Number | Creation timestamp            |

---

# Commander Personality

Personality definitions must be stored separately.

Type:

HashMap

Example:

```sqf
IDS_CommanderProfiles set
[
    "Aggressive",
    createHashMapFromArray
    [
        ["AttackWeight",1.0],
        ["DefenseWeight",0.2],
        ["ExpansionWeight",1.0],
        ["SupportWeight",0.4],
        ["AmbushWeight",0.1]
    ]
];
```

---

# Location Object

Represents a strategic location.

Type:

HashMap

Example:

```sqf
private _location =
createHashMapFromArray
[
    ["ID","LOC_001"],
    ["Name","Kavala"],
    ["Position",[0,0,0]],
    ["Owner",east],
    ["ResourceValue",100],
    ["StrategicValue",80],
    ["Population",500],
    ["Infrastructure",70],
    ["SpawnPoints",[]],
    ["ConnectedLocations",[]],
    ["LastCaptured",0]
];
```

Fields:

| Field              | Type        |
| ------------------ | ----------- |
| ID                 | String      |
| Name               | String      |
| Position           | PositionATL |
| Owner              | Side        |
| ResourceValue      | Number      |
| StrategicValue     | Number      |
| Population         | Number      |
| Infrastructure     | Number      |
| SpawnPoints        | Array       |
| ConnectedLocations | Array       |
| LastCaptured       | Number      |

---

# Resource Node Object

Represents an economy source.

Type:

HashMap

Example:

```sqf
private _resourceNode =
createHashMapFromArray
[
    ["ID","RES_001"],
    ["Type","Oil"],
    ["LocationID","LOC_001"],
    ["Income",25],
    ["Owner",east]
];
```

Resource Types:

* Town
* Industry
* Military
* Port
* Airfield
* Oil
* Communications

---

# Intel Object

Represents enemy information.

Type:

HashMap

Example:

```sqf
private _intel =
createHashMapFromArray
[
    ["ID","INTEL_001"],
    ["Type","EnemyContact"],
    ["Position",[0,0,0]],
    ["Observer",objNull],
    ["Confidence",1.0],
    ["Timestamp",serverTime],
    ["Expires",serverTime + 600]
];
```

Fields:

| Field      | Type        |
| ---------- | ----------- |
| ID         | String      |
| Type       | String      |
| Position   | PositionATL |
| Observer   | Object      |
| Confidence | Number      |
| Timestamp  | Number      |
| Expires    | Number      |

Confidence Range:

0.0 - 1.0

---

# Operation Object

Represents a strategic mission.

Type:

HashMap

Example:

```sqf
private _operation =
createHashMapFromArray
[
    ["ID","OP_001"],
    ["Type","Capture"],
    ["Status","Pending"],
    ["Priority",100],
    ["TargetLocation","LOC_001"],
    ["AssignedGroups",[]],
    ["Created",serverTime],
    ["LastUpdate",serverTime]
];
```

Operation Types:

* Capture
* Defend
* Patrol
* Raid
* Ambush
* Reinforce
* ArtilleryStrike
* Sabotage
* Recon

Operation Status:

* Pending
* Active
* Completed
* Failed
* Cancelled

---

# Group Object

Represents a military force available to the commander.

Type:

HashMap

Example:

```sqf
private _groupData =
createHashMapFromArray
[
    ["Group",_group],
    ["Type","Infantry"],
    ["Strength",8],
    ["CombatPower",100],
    ["CurrentOperation",""],
    ["Available",true]
];
```

Group Types:

* Infantry
* Mechanized
* Armor
* Recon
* Artillery
* Air
* Guerilla

---

# World Database

Global world storage.

Type:

HashMap

Example:

```sqf
IDS_WorldDB = createHashMapFromArray
[
    ["Locations",createHashMap],
    ["Resources",createHashMap],
    ["Intel",createHashMap],
    ["Operations",createHashMap],
    ["Groups",createHashMap]
];
```

This database acts as the master world state.

---

# Save Object

Represents persistent data.

Type:

HashMap

Example:

```sqf
private _saveData =
createHashMapFromArray
[
    ["Commander",IDS_Commander],
    ["WorldDB",IDS_WorldDB],
    ["Version","0.1"]
];
```

Persistent Fields:

* Commander
* Locations
* Resources
* Operations
* Intel
* Territory Ownership

Do Not Persist:

* Dead AI units
* Temporary combat events
* Active bullets
* Temporary tactical state

---

# Network Rules

Authority Machine:

```sqf
isServer
```

Only the authority machine may:

* Create operations
* Create intel
* Update economy
* Change ownership
* Execute commander decisions

Clients receive synchronized state.

Clients never execute strategic AI.

---

# Third-Party AI Rules

VCOM AI and ODKAI remain untouched.

Use adapters.

Example:

```sqf
[group] call IDS_fnc_VCOMAdapter;
```

or

```sqf
[group] call IDS_fnc_ODKAdapter;
```

Commander code must never directly depend on third-party implementation details.
