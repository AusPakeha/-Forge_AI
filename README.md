## 1) Project Goal

Create a **standalone Arma 3 mod** that provides an **AI Commander** system capable of controlling **OPFOR/EAST forces strategically** across any terrain.

The mod must also function as an **addon for mission frameworks such as Forge** without requiring modification of the core commander code.

### Operating level
- **Strategic + operational** decisions
- Tactical combat is handled by external AI systems (e.g., **VCOM AI** and **ODKAI**)

### Hard boundaries
- Never directly control individual soldiers unless absolutely necessary.
- Never micromanage tactical combat.
- Build as a **commander framework with modular subsystems**; not a monolithic “one big AI script”.

---

## 2) Core Layering (enforced)

Use three conceptual layers:

1. **Strategic Layer** (decides what to do)
2. **Operational Layer** (converts decisions into missions/operations; assigns groups)
3. **Tactical Layer** (VCOM/ODKAI executes combat; commander monitors results)

Commander should never execute tactical movement/engagement logic.

---

## 3) Data contracts first (non-negotiable)

Before writing SQF functions, treat the following docs as contracts:
- `docs/DATA_MODEL.md`
- `docs/FRAMEWORK_FLOW.md`
- `docs/FUNCTION_REGISTRY.md`

Do not invent alternate data structures.

### Commander Registry (future-proof)
Even if v0.1 only has one commander, design for `IDS_Commanders` (map/hash) instead of a single `IDS_Commander` object.

---

## 4) Multiplayer / Authority rules (enforced in code)

Strategic execution must run on the **authority machine**.

### Default authority rule
Use this rule everywhere (strategic systems):
```sqf
if (!isServer) exitWith {};
```

### Clients
Clients must not execute strategic decision-making. They may receive synchronized state (e.g., markers/UI notifications) but never run loops that allocate resources, select objectives, or change ownership.

### Store global state in missionNamespace
Commander framework state should live in `missionNamespace`, for example:
- `IDS_Commanders`
- `IDS_WorldDB` / `IDS_Locations`
- `IDS_Operations`
- `IDS_Intel`

---

## 5) Third-party AI integration rule

- **Never modify VCOMAI or ODKAI source code.**
- Implement **adapter layers**.

Example pattern:
```sqf
[group] call IDS_fnc_VCOMAdapter;
[group] call IDS_fnc_ODKAdapter;
```

Commander interacts with adapters only.

---

## 6) Personality system (weight-based; same commander code)

Personalities modify decision weights; they do not require separate commander implementations.

### Personalities in v0.1
- **AGGRESSIVE**
- **DEFENSIVE**

Suggested decision weights:
- Aggressive:
  - AttackWeight = 1.0
  - DefenseWeight = 0.2
  - ExpansionWeight = 1.0
- Defensive:
  - AttackWeight = 0.3
  - DefenseWeight = 1.0
  - ExpansionWeight = 0.3

---

## 7) Intel / Fog-of-war realism constraint

Commander must not “cheat”.

Intel must be derived from friendly AI reports:
- Enemy AI observes detected threats
- Reports are added to the intel database
- Intel decays / expires over time

Result: commander decisions are based only on **reported, decaying intel**, not global omniscience.

---

## 8) Vertical Slice v0.1 (chat-driven: implementation-first milestone)

### v0.1 Objective
Two AI commanders fight over territory on Altis with:
- fog-of-war
- economy
- basic operations

Strict exclusions for v0.1:
- No artillery
- No sabotage
- No PMC
- No guerilla
- No Forge integration
- No ODKAI integration
- No VCOM integration

**Success for v0.1 = core loop proof**.

---

## 9) Repo / Implementation roadmap (what to build)

Since the repo already contains:
- `ODKAI/`
- `VCOMAI/`

Create implementation focus under:

```text
IDS_CommanderAI/
  addons/
    ids_commander/
  ODKAI/
  VCOMAI/
  docs/
  test_missions/
```

Inside the addon skeleton:

```text
ids_commander/
├── config.cpp
├── functions/
└── systems/
    ├── worldgen/
    ├── economy/
    ├── intel/
    ├── commander/
    ├── operations/
    ├── forcepackages/
    ├── territory/
    ├── frontline/
    ├── save/
    └── debug/
    
└── init/
```

---

## 10) v0.1: Systems to code in order (each must verify independently)

### 1) World Generation
- Output: `IDS_Locations` (or equivalent locations database)
Verify:
- detects towns
- assigns strategic values
- assigns resources

No other systems yet.

### 2) Territory Ownership
- Output: `OwnerFaction` (ownership per location)
Verify:
- locations can change ownership
- markers update (if debug)

### 3) Economy Tick
- Output: `Money`, `Manpower` (or configured economy outputs)
Verify:
- capturing towns changes income

### 4) Commander Selection + persistence contract
- doctrine selection: `AGGRESSIVE` or `DEFENSIVE`
Verify:
- save/load works
- doctrine doesn’t change during normal gameplay (only on new save/campaign)

### 5) Intel System
Verify:
- commander knows only reported contacts (via intel network)
- intel expires/decays

### 6) Operation Framework (minimal)
Only implement:
- `CAPTURE`
Verify:
- commander can create a capture operation

### 7) Force Packages (minimal)
Only implement:
- `FORCE_RIFLE_SQUAD`
Verify:
- operation requests package
- package spawns

### 8) Operation Execution
Verify:
- squad attacks target location
- location changes ownership

Success point:
- at this moment you have a functioning war loop.

---

## 11) Debug layer (build early; don’t wait)

Enable:
```sqf
IDS_Debug = true;
```

Visualize (if debug):
- Territory
  - Green = OPFOR
  - Blue = BLUFOR
- Frontlines
  - Orange markers
- Intel
  - Red circles
- Operations
  - Lines from origin to target
- Commander Goal
  - Marker text: "Capture Region North"

---

## 12) Framework flow (system lifecycle; follow it)

Implement according to the lifecycle:

Mission Start
↓
`IDS` Initialization
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
Commander Loop starts

And loops:
- Economy loop (interval ~300s)
- Intel loop (interval ~30s)
- Operations loop (interval ~60s)
- Commander loop (interval ~300s)

Strategic decision flow inside commander loop:
- evaluate economy
- evaluate territory
- evaluate threats
- evaluate available forces
- determine strategic priority
- create operations
- allocate resources

---

## 13) Function/API guidance (function registry contract)

When you add new functions:
- use naming convention `IDS_fnc_functionName`
- register them in `docs/FUNCTION_REGISTRY.md`
- clearly state authority requirements (server-only for strategic logic)
- ensure single responsibility

---

## 14) Concrete repo integration targets (required entrypoints)

For this repo, “Vertical Slice v0.1” maps to concrete server-authority entrypoints:

1. `IDS_Locations` world generation (territory graph + location evaluation)
2. Territory ownership updates via `fn_changeOwner` / `OwnerFaction`
3. Economy tick via `fn_tickEconomy` / `fn_updateEconomy` (money + manpower)
4. Commander strategic loop via `fn_updateCommander.sqf`
5. Capture operation creation and execution via operations layer
6. Force package selection via `fn_requestForcePackage.sqf`
   - must map `CAPTURE` → `FORCE_RIFLE_SQUAD`
7. Force package spawning via `fn_spawnPackage.sqf`
