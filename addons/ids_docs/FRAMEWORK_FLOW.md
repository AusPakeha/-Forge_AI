# IDS Commander AI - Framework Flow Specification

Version: 0.1

This document defines the lifecycle and execution flow of IDS Commander AI.

All systems must follow this flow.

---

# High-Level Design

IDS Commander AI consists of three layers:

Strategic Layer
↓
Operational Layer
↓
Tactical Layer

Strategic Layer determines objectives.

Operational Layer creates missions.

Tactical Layer executes missions using VCOM AI and ODKAI.

---

# Execution Authority

Strategic AI only runs on the authority machine.

Authority Machine:

```sqf
isServer
```

Examples:

Single Player:

* Player machine acts as authority.

Hosted Multiplayer:

* Host machine acts as authority.

Dedicated Server:

* Dedicated server acts as authority.

Clients never execute strategic AI.

---

# Mission Initialization

Mission Start
↓
IDS Initialization
↓
World Scan
↓
Database Creation
↓
Commander Selection
↓
Economy Initialization
↓
Intel Initialization
↓
Operations Initialization
↓
Commander Loop Starts

---

# Initialization Phase

Function:

```sqf
[] call IDS_fnc_init;
```

Responsibilities:

* Verify authority machine
* Load saved state
* Create databases
* Create commander registry
* Register personalities
* Register AI adapters
* Start system loops

---

# World Generation Phase

Function:

```sqf
[] call IDS_fnc_buildWorld;
```

Responsibilities:

* Scan strategic locations
* Scan military installations
* Scan airfields
* Scan ports
* Scan road networks
* Generate spawn points
* Generate resource nodes

Output:

```sqf
IDS_WorldDB
```

---

# Commander Selection Phase

Function:

```sqf
[] call IDS_fnc_selectCommander;
```

Only occurs:

* New Campaign
* New Save

Does NOT occur:

* During gameplay
* During normal loading

Personality Pool:

* Aggressive
* Defensive
* PMC
* Support
* Guerilla

Selected personality remains persistent.

---

# Commander Creation Phase

Function:

```sqf
[] call IDS_fnc_createCommander;
```

Responsibilities:

* Create commander object
* Apply personality profile
* Initialize resources
* Initialize manpower
* Initialize operation list
* Initialize intel list

Output:

```sqf
IDS_Commanders
```

---

# Main System Loops

The framework contains several independent loops.

Economy Loop

Default Interval:

300 seconds

Responsibilities:

* Generate income
* Update manpower
* Process upkeep
* Purchase reinforcements

---

Intel Loop

Default Interval:

30 seconds

Responsibilities:

* Process reports
* Remove expired intel
* Update confidence values

---

Operations Loop

Default Interval:

60 seconds

Responsibilities:

* Update active missions
* Check completion status
* Reassign groups
* Handle failures

---

Commander Loop

Default Interval:

300 seconds

Responsibilities:

* Evaluate threats
* Analyze economy
* Select objectives
* Create operations
* Allocate resources

---

# Strategic Decision Flow

Commander Loop Begins
↓
Evaluate Economy
↓
Evaluate Territory
↓
Evaluate Threats
↓
Evaluate Available Forces
↓
Determine Strategic Priority
↓
Create Operations
↓
Assign Resources
↓
End Loop

Repeat

---

# Economy Flow

Economy Tick
↓
Get Controlled Locations
↓
Calculate Resource Income
↓
Calculate Money Income
↓
Calculate Manpower Gain
↓
Apply Upkeep Costs
↓
Update Commander Resources
↓
End Tick

---

# Intel Flow

Enemy Observed
↓
Intel Report Created
↓
Intel Added To Database
↓
Intel Confidence Updated
↓
Intel Expires
↓
Intel Removed

Rules:

No omniscient information.

All intelligence must originate from friendly units.

---

# Territory Flow

Location Captured
↓
Ownership Changed
↓
Resource Ownership Updated
↓
Spawn Permissions Updated
↓
Commander Territory Updated

Ownership drives:

* Economy
* Reinforcements
* Strategic priorities

---

# Operation Creation Flow

Commander Selects Objective
↓
Operation Created
↓
Priority Assigned
↓
Resources Allocated
↓
Groups Assigned
↓
Operation Activated

---

# Operation Resolution Flow

Operation Active
↓
Monitor Progress
↓
Success?
├── Yes
│   ↓
│   Update Territory
│   ↓
│   Reward Commander
│
└── No
↓
Determine Failure Reason
↓
Reallocate Resources

---

# Tactical AI Flow

Commander Creates Operation
↓
Group Assigned
↓
AI Adapter Invoked
↓
VCOM or ODKAI Controls Combat
↓
Commander Monitors Outcome

Commander never controls combat directly.

---

# Personality Influence System

Personalities modify priorities.

Example:

Aggressive:

* Attack Priority +50%
* Expansion Priority +50%
* Defense Priority -50%

Defensive:

* Defense Priority +50%
* Patrol Priority +50%
* Expansion Priority -50%

PMC:

* Money Priority +100%
* Mercenary Priority +100%

Support:

* Artillery Priority +100%
* Recon Priority +75%

Guerilla:

* Ambush Priority +100%
* Sabotage Priority +100%

The same strategic framework is used for all personalities.

Only weighting changes.

---

# Save Flow

Save Triggered
↓
Serialize Commander Registry
↓
Serialize World Database
↓
Serialize Operations
↓
Serialize Intel
↓
Serialize Resources
↓
Write Save Data

---

# Load Flow

Load Triggered
↓
Read Save Data
↓
Restore Commander Registry
↓
Restore World Database
↓
Restore Operations
↓
Restore Intel
↓
Resume Loops

Commander personality must remain unchanged after loading.

---

# Failure Recovery

If a subsystem fails:

* Log error
* Disable failed subsystem
* Continue framework execution

The commander framework should never crash the mission due to one failed subsystem.

---

# Future Expansion Support

The framework must support future additions:

* Multiple commanders
* Regional commanders
* Rebel commanders
* Campaign systems
* Dynamic diplomacy
* Logistics systems
* Supply systems
* Strategic air warfare
* Naval operations

Current implementation should avoid hardcoded limitations that would prevent future expansion.
