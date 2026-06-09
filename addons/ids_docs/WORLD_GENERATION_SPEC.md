# IDS Commander AI - World Generation Specification

Version: 0.1

This document defines how IDS Commander AI discovers, evaluates, and stores strategic information about any terrain.

The world generation system must operate automatically without requiring mission makers to place markers, modules, or custom objects.

---

# Goals

World Generation must:

* Work on any terrain
* Require zero mission setup
* Create strategic locations
* Create resource nodes
* Create spawn networks
* Create transportation networks
* Support persistence

Output:

```sqf
IDS_WorldDB
```

---

# World Generation Flow

Mission Start
↓
Scan Terrain
↓
Identify Strategic Locations
↓
Generate Resource Nodes
↓
Generate Spawn Points
↓
Generate Road Network
↓
Calculate Strategic Values
↓
Store In Database

---

# Strategic Location Types

IDS Commander AI classifies locations into categories.

Location Types:

* Capital
* City
* Town
* Village
* Military Base
* Airfield
* Port
* Industrial Site
* Communication Site
* Resource Site

Each category receives different strategic weighting.

---

# Terrain Scan

Function:

```sqf
IDS_fnc_scanLocations
```

Uses:

```sqf
nearestLocations
```

Categories:

```sqf
[
    "NameCityCapital",
    "NameCity",
    "NameVillage",
    "NameLocal"
]
```

Example:

```sqf
private _locations =
nearestLocations
[
    [worldSize/2, worldSize/2],
    [
        "NameCityCapital",
        "NameCity",
        "NameVillage",
        "NameLocal"
    ],
    worldSize
];
```

Output:

Location Objects

---

# Capital Detection

Priority:

Highest

Detection:

```sqf
"NameCityCapital"
```

Strategic Value Multiplier:

```text
x3.0
```

Resource Multiplier:

```text
x2.0
```

---

# City Detection

Detection:

```sqf
"NameCity"
```

Strategic Value Multiplier:

```text
x2.0
```

Resource Multiplier:

```text
x1.5
```

---

# Village Detection

Detection:

```sqf
"NameVillage"
```

Strategic Value Multiplier:

```text
x1.0
```

Resource Multiplier:

```text
x1.0
```

---

# Military Site Detection

Function:

```sqf
IDS_fnc_scanMilitaryLocations
```

Sources:

* Airport areas
* Military map markers
* Military buildings
* Military compositions

Detection Classes:

Examples:

```text
Land_Cargo_HQ
Land_MilOffices
Land_i_Barracks
Land_u_Barracks
```

Military sites generate:

* Reinforcement capacity
* Vehicle spawning capability
* Strategic importance

---

# Airfield Detection

Methods:

Primary:

```sqf
nearestLocations
```

Secondary:

Terrain object scan

Output:

Location Type:

```text
Airfield
```

Benefits:

* Air support
* Air reinforcement
* Recon capability

---

# Port Detection

Detection:

Coastal location analysis.

Criteria:

* Near coastline
* Significant structures
* Pier objects

Benefits:

* Logistics
* Future naval systems

---

# Industrial Detection

Detection:

Industrial structures.

Examples:

```text
Factory
Power Plant
Processing Facility
Warehouse District
```

Benefits:

Increased resource generation.

---

# Communication Site Detection

Detection:

```text
Radar
Radio Tower
Communication Facility
```

Benefits:

Improved intel gathering.

Future:

Intel network expansion.

---

# Resource Generation

Every strategic location receives resources.

Base Resource Formula:

```text
Population
+
Infrastructure
+
Location Type Modifier
```

Output:

```sqf
ResourceValue
```

Range:

```text
10 - 500
```

---

# Resource Types

Each location receives one primary resource.

Possible Types:

* Population
* Industry
* Oil
* Communications
* Military
* Logistics

Example:

```sqf
["ResourceType","Industry"]
```

---

# Infrastructure Score

Range:

```text
0 - 100
```

Calculated Using:

* Building density
* Road density
* Location type

Purpose:

Determines:

* Resource output
* Spawn quality
* Defensive capability

---

# Population Score

Range:

```text
0 - 1000
```

Estimated from:

* Building count
* Settlement type

Purpose:

Determines:

* Resource generation
* Recruitment potential

---

# Strategic Value Calculation

Formula:

Strategic Value =
Location Importance
+
Infrastructure
+
Connectivity
+
Military Significance

Output:

```text
0 - 100
```

Examples:

Small Village:

```text
20
```

Large City:

```text
70
```

Capital:

```text
100
```

---

# Spawn Point Generation

Function:

```sqf
IDS_fnc_generateSpawnPoints
```

Purpose:

Create reinforcement positions.

Rules:

Must:

* Be on terrain
* Be accessible
* Avoid water
* Avoid steep slopes

Preferred:

* Near roads
* Near military sites

Output:

```sqf
SpawnPoints[]
```

---

# Road Network Generation

Function:

```sqf
IDS_fnc_buildRoadNetwork
```

Purpose:

Determine connectivity.

Data:

```sqf
ConnectedLocations[]
```

Used For:

* Reinforcement routes
* Logistics
* Expansion planning

---

# Location Connectivity

Every location stores:

```sqf
ConnectedLocations
```

Example:

```sqf
[
    "LOC_001",
    "LOC_004",
    "LOC_012"
]
```

Connections determined by:

* Road access
* Distance
* Terrain

---

# Region Generation

Future Feature

World divided into regions.

Example:

```text
North
South
East
West
Central
```

Supports:

* Regional commanders
* Frontline systems

Not required in Version 0.1.

---

# Ownership Initialization

At mission start:

Default:

```sqf
east
```

or

Mission Configuration Override

Future:

Framework integration may define ownership.

---

# World Database Structure

Output:

```sqf
IDS_WorldDB
```

Contains:

Locations

Resources

Road Network

Spawn Network

Strategic Values

Ownership

---

# Persistence Requirements

Persist:

* Ownership
* Resource Values
* Strategic Values
* Spawn Points
* Infrastructure

Do Not Recalculate After Load

Load directly from save.

---

# Performance Requirements

World Generation executes:

Once

During Initialization

Never continuously.

After initialization:

All systems use cached data.

No repeated terrain scanning.

---

# Debug Requirements

Future Debug Modes:

Display:

* Strategic Locations
* Resource Values
* Spawn Points
* Connectivity
* Ownership

Used for balancing and validation.

# CRITICAL DESIGN IMPROVMENT

After laying this out, I would add one more field to every location object:

["LocationType","Town"]

Examples:

Capital
City
Village
Military
Airfield
Port
Industrial
Communications

This will make personality logic much easier later.

For example:

Aggressive Commander Prioritizes:

Capital
City
Military

---
PMC Commander Prioritizes:

Industry
Oil
Communications

---
Support Commander Prioritizes:

Airfield
Military
Communications

without needing special-case code.