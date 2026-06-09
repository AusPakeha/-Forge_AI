# IDS Commander AI - Operation Framework

## Purpose

The Operation Framework is the bridge between the Strategic Layer and the Tactical Layer.

Strategic systems decide what objectives should be achieved.

Operations convert those objectives into executable military actions.

Tactical AI systems execute combat actions independently.

The Commander must never directly control individual soldiers.

---

# Authority

All operation creation, planning, execution, and completion logic runs on the server.

Required guard:

```sqf
if (!isServer) exitWith {};
```

Clients may display operation state but must never modify operation data.

---

# Registry

Operations are stored in:

```sqf
missionNamespace getVariable [
    "IDS_Operations",
    createHashMap
];
```

Structure:

```sqf
IDS_Operations = HashMap<
    OperationID,
    OperationObject
>
```

---

# Operation Types

## v0.1

Supported:

```text
CAPTURE
```

Future:

```text
DEFEND
REINFORCE
PATROL
RAID
SABOTAGE
COUNTERATTACK
RECON
```

---

# Operation States

```text
CREATED
PLANNING
ALLOCATING_FORCES
STAGING
EXECUTING
SUCCEEDED
FAILED
CANCELLED
```

---

# State Definitions

## CREATED

Operation exists.

No resources allocated.

Waiting for planning.

### Entry

Operation created.

### Exit

PLANNING

---

## PLANNING

Determine force requirements.

Example:

CAPTURE

requires:

```text
FORCE_RIFLE_SQUAD
```

### Entry

CREATED

### Exit

ALLOCATING_FORCES

---

## ALLOCATING_FORCES

Requests resources from Economy System.

Required:

```text
Money
Manpower
```

### Success

STAGING

### Failure

FAILED

---

## STAGING

Spawn force packages.

Assign groups.

Move toward assembly area.

No attack order issued yet.

### Exit

EXECUTING

---

## EXECUTING

Operation active.

Tactical systems perform combat.

Commander only monitors progress.

### Success

SUCCEEDED

### Failure

FAILED

---

## SUCCEEDED

Operation objective achieved.

Example:

Target location ownership changed.

Actions:

* update territory ownership
* update economy
* archive operation

Terminal state.

---

## FAILED

Operation unsuccessful.

Examples:

* all assigned groups destroyed
* timeout reached

Actions:

* archive operation

Terminal state.

---

## CANCELLED

Operation manually terminated.

Actions:

* release resources
* archive operation

Terminal state.

---

# Operation Object Schema

Every operation must implement this schema.

```sqf
private _operation = createHashMapFromArray [

    ["ID", ""],

    ["Type", ""],

    ["State", "CREATED"],

    ["CommanderID", ""],

    ["OriginLocation", ""],
    ["TargetLocation", ""],

    ["Priority", 0],

    ["RequiredForcePackages", []],

    ["AssignedGroups", []],

    ["Progress", 0],

    ["CreatedTime", serverTime],
    ["StartTime", -1],
    ["EndTime", -1],

    ["Timeout", 3600]
];
```

---

# State Transitions

Allowed transitions:

```text
CREATED
→ PLANNING

PLANNING
→ ALLOCATING_FORCES

ALLOCATING_FORCES
→ STAGING
→ FAILED

STAGING
→ EXECUTING

EXECUTING
→ SUCCEEDED
→ FAILED

ANY
→ CANCELLED
```

No other transitions are valid.

---

# Commander Interaction

Commander may:

* create operations
* cancel operations
* monitor operation results

Commander may not:

* control units
* issue combat micro-orders
* manage individual engagements

---

# Tactical Layer Interaction

Operation Execution Layer hands control to adapters.

Example:

```sqf
[_group] call IDS_fnc_VCOMAdapter;
```

Commander framework only tracks outcomes.

---

# Monitoring Metrics

Operations may monitor:

```text
Objective Ownership
Group Survival
Combat Power
Distance To Objective
Operation Duration
```

These metrics inform success/failure decisions.

---

# Operation Tick

Operation manager updates all active operations.

Default interval:

```text
60 seconds
```

Single manager only.

No per-operation infinite loops.

---

# Persistence

Operations must be save-compatible.

Operation objects must not store:

```text
Group objects
Unit objects
Vehicle objects
```

Store IDs only.

Example:

```sqf
AssignedGroups = [
    "GRP_001",
    "GRP_002"
];
```

Runtime systems resolve IDs into actual engine objects.

---

# Debug

When:

```sqf
IDS_Debug = true;
```

Display:

* operation markers
* operation state
* origin location
* target location
* progress

Example:

```text
CAPTURE KAVALA
EXECUTING
65%
```

---

# v0.1 Completion Criteria

A CAPTURE operation must:

1. Be created by commander
2. Request FORCE_RIFLE_SQUAD
3. Consume economy resources
4. Spawn a squad
5. Move squad toward objective
6. Transfer ownership when objective secured
7. Complete successfully
8. Feed results back to commander

```
```
