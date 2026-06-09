# IDS Commander AI - Mod Structure Specification

Version: 0.1

This document defines the physical addon structure, loading order, initialization sequence, and packaging requirements.

---

# Project Goals

The addon must support:

* Single Player
* Hosted Multiplayer
* Dedicated Server

The addon must function as:

* Standalone strategic AI mod
* Addon for mission frameworks
* Addon for custom missions

The addon must not require mission makers to edit core files.

---

# Top Level Layout

```text
IDS_CommanderAI/
│
├── addons/
│
│   └── ids_commander_core/
│       │
│       ├── config.cpp
│       ├── XEH_preInit.sqf
│       ├── XEH_postInit.sqf
│       │
│       ├── functions/
│       │
│       ├── data/
│       │
│       ├── integrations/
│       │
│       ├── personalities/
│       │
│       └── persistence/
│
├── docs/
│
├── tools/
│
├── thirdparty/
│   │
│   ├── VCOMAI/
│   │
│   └── ODKAI/
│
└── build/
```

---

# Addon Philosophy

The commander framework owns:

* Strategic AI
* Economy
* Territory
* Intelligence
* Operations

Third-party AI owns:

* Tactical combat
* Group combat decisions
* Cover
* Flanking
* Suppression

Never merge tactical logic into strategic logic.

---

# Addon Packaging

Initial release:

```text
ids_commander_core.pbo
```

Future releases may split into:

```text
ids_commander_core.pbo

ids_commander_economy.pbo

ids_commander_persistence.pbo

ids_commander_integrations.pbo
```

Version 0.1 should remain a single addon.

---

# Required Dependencies

Initial dependency list:

```cpp
requiredAddons[] =
{
    "A3_Data_F",
    "A3_Functions_F"
};
```

Avoid requiring VCOM AI.

Avoid requiring ODKAI.

Detect them dynamically.

---

# Dynamic AI Detection

Framework startup should detect:

* VCOM AI
* ODKAI

Example:

```sqf
IDS_AIProviders = [];

if !(isNil "VCM_Settings") then
{
    IDS_AIProviders pushBack "VCOM";
};

if !(isNil "ODK_Main") then
{
    IDS_AIProviders pushBack "ODKAI";
};
```

The framework should continue functioning if neither is present.

---

# CfgPatches

Example:

```cpp
class CfgPatches
{
    class IDS_Commander_Core
    {
        units[] = {};
        weapons[] = {};

        requiredVersion = 2.14;

        requiredAddons[] =
        {
            "A3_Data_F",
            "A3_Functions_F"
        };
    };
};
```

---

# CfgFunctions

Root namespace:

```cpp
IDS
```

Example:

```cpp
class CfgFunctions
{
    class IDS
    {
        class Init
        {
            file = "\ids_commander_core\functions\init";

            class init {};
            class startLoops {};
            class isAuthority {};
        };

        class World
        {
            file = "\ids_commander_core\functions\world";

            class buildWorld {};
            class scanLocations {};
            class scanMilitaryLocations {};
        };

        class Commander
        {
            file = "\ids_commander_core\functions\commander";

            class createCommander {};
            class updateCommander {};
        };
    };
};
```

---

# Extended Event Handlers

Use CBA XEH.

Required dependency:

```cpp
"CBA_Main"
```

Recommended dependency list:

```cpp
requiredAddons[] =
{
    "cba_main",
    "A3_Data_F",
    "A3_Functions_F"
};
```

---

# PreInit

Purpose:

Register framework globals.

Do not:

* Scan world
* Create commander
* Start loops

Only:

* Create namespaces
* Load settings
* Register personalities

Example:

```sqf
IDS_Commanders = createHashMap;

IDS_WorldDB = createHashMap;
```

---

# PostInit

Purpose:

Start framework.

Example:

```sqf
if (isServer) then
{
    [] call IDS_fnc_init;
};
```

---

# Initialization Sequence

PostInit
↓
IDS_fnc_init
↓
Load Save
↓
Build World
↓
Create Commander
↓
Start Loops
↓
Begin Strategic AI

---

# Server Authority Rules

Only server authority machine executes:

* Commander Loop
* Economy Loop
* Intel Loop
* Operation Loop

Clients execute:

* UI
* Debug
* Visualization

No strategic calculations on clients.

---

# Future UI Support

Reserve:

```text
functions/ui/
```

Planned Features:

* Commander Debug Panel
* Territory Map
* Resource Viewer
* Intel Viewer
* Active Operations Viewer

UI must remain optional.

---

# Logging System

All framework messages use:

```sqf
[IDS COMMANDER]
```

Example:

```sqf
diag_log
"[IDS COMMANDER] Commander Created";
```

---

# Debug Mode

Global variable:

```sqf
IDS_DebugMode = false;
```

Future:

```sqf
IDS_DebugLevel = 0;
```

Levels:

0 = Disabled

1 = Errors

2 = Warnings

3 = Info

4 = Verbose

---

# Configuration Layer

Future settings:

```sqf
IDS_Settings
```

Example:

```sqf
IDS_Settings = createHashMapFromArray
[
    ["EconomyTick",300],
    ["CommanderTick",300],
    ["IntelTick",30],
    ["OperationTick",60]
];
```

Never hardcode tick rates.

Always read settings.

---

# Save Compatibility

Every save must include:

```sqf
Version
```

Example:

```sqf
["Version","0.1"]
```

Future migration scripts may be required.

---

# Third Party Integration Rules

Never modify:

* VCOM AI source
* ODKAI source

Create adapters.

Location:

```text
integrations/
```

Example:

```text
fn_vcomAdapter.sqf

fn_odkaiAdapter.sqf
```

The commander framework communicates only with adapters.

---

# Build Pipeline

Source
↓
PBO Build
↓
Testing
↓
Release

Recommended tools:

* PBO Project
* HEMTT
* Mikero Tools

Preferred long-term:

HEMTT

---

# Version Roadmap

Version 0.1

Framework Only

* Initialization
* World Scan
* Commander Registry
* Resource System

Version 0.2

Strategic Systems

* Intel
* Operations
* Economy

Version 0.3

AI Integration

* VCOM Adapter
* ODKAI Adapter

Version 0.4

Personalities

* Aggressive
* Defensive

Version 0.5

Advanced Doctrines

* PMC
* Support
* Guerilla

Version 1.0

Full Strategic Commander
Persistent Campaign Support
Framework Integration Support
