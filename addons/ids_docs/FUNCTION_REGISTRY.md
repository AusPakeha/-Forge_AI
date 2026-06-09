# IDS Commander AI - Function Registry

Version: 0.1

This document defines the official function API for IDS Commander AI.

All new functions must be registered here.

Function naming convention:

```sqf
IDS_fnc_functionName
```

Function categories:

* Init
* World
* Commander
* Economy
* Intel
* Operations
* Territory
* Persistence
* Integration
* Utilities

---

# INIT SUBSYSTEM

## IDS_fnc_init

Purpose:

Primary framework bootstrap.

Authority:

Server Only

Parameters:

None

Returns:

Boolean

Responsibilities:

* Create databases
* Load configuration
* Register personalities
* Register integrations
* Build world
* Create commander
* Start loops

Dependencies:

* IDS_fnc_buildWorld
* IDS_fnc_createCommander
* IDS_fnc_startLoops

---

## IDS_fnc_startLoops

Purpose:

Starts all framework loops.

Authority:

Server Only

Parameters:

None

Returns:

Nothing

Starts:

* Commander Loop
* Economy Loop
* Intel Loop
* Operations Loop

---

## IDS_fnc_isAuthority

Purpose:

Determine if current machine owns strategic execution.

Authority:

Any

Parameters:

None

Returns:

Boolean

Implementation:

```sqf
isServer
```

---

# WORLD SUBSYSTEM

## IDS_fnc_buildWorld

Purpose:

Generate strategic world database.

Authority:

Server Only

Parameters:

None

Returns:

HashMap

Creates:

* Locations
* Resource Nodes
* Spawn Nodes
* Strategic Values

---

## IDS_fnc_scanLocations

Purpose:

Locate towns and strategic positions.

Authority:

Server Only

Parameters:

None

Returns:

Array

Output:

Array of Location Objects

---

## IDS_fnc_scanMilitaryLocations

Purpose:

Find military bases and installations.

Authority:

Server Only

Parameters:

None

Returns:

Array

---

## IDS_fnc_generateSpawnPoints

Purpose:

Generate spawn positions for locations.

Authority:

Server Only

Parameters:

Location Object

Returns:

Array

---

## IDS_fnc_generateResourceNodes

Purpose:

Create resource nodes.

Authority:

Server Only

Parameters:

Location Object

Returns:

Array

---

# COMMANDER SUBSYSTEM

## IDS_fnc_createCommander

Purpose:

Create commander object.

Authority:

Server Only

Parameters:

String Personality

Returns:

Commander Object

---

## IDS_fnc_selectCommander

Purpose:

Choose personality for new campaign.

Authority:

Server Only

Parameters:

None

Returns:

String

Possible Values:

* Aggressive
* Defensive
* PMC
* Support
* Guerilla

---

## IDS_fnc_updateCommander

Purpose:

Main strategic AI tick.

Authority:

Server Only

Parameters:

Commander Object

Returns:

Nothing

Responsibilities:

* Threat evaluation
* Resource allocation
* Operation creation

---

## IDS_fnc_evaluateThreats

Purpose:

Determine current threat environment.

Authority:

Server Only

Parameters:

Commander Object

Returns:

Threat Score

---

## IDS_fnc_chooseObjective

Purpose:

Determine strategic objective.

Authority:

Server Only

Parameters:

Commander Object

Returns:

Objective Data

---

# ECONOMY SUBSYSTEM

## IDS_fnc_updateEconomy

Purpose:

Process economy tick.

Authority:

Server Only

Parameters:

Commander Object

Returns:

Nothing

---

## IDS_fnc_calculateIncome

Purpose:

Calculate commander income.

Authority:

Server Only

Parameters:

Commander Object

Returns:

Number

---

## IDS_fnc_spendResources

Purpose:

Spend resources.

Authority:

Server Only

Parameters:

Commander Object
Amount

Returns:

Boolean

---

## IDS_fnc_purchaseForces

Purpose:

Purchase new units.

Authority:

Server Only

Parameters:

Commander Object

Returns:

Array

---

# TERRITORY SUBSYSTEM

## IDS_fnc_captureLocation

Purpose:

Transfer ownership.

Authority:

Server Only

Parameters:

Location ID
New Owner

Returns:

Boolean

---

## IDS_fnc_changeOwner

Purpose:

Internal ownership update.

Authority:

Server Only

Parameters:

Location Object
Side

Returns:

Nothing

---

## IDS_fnc_getControlledLocations

Purpose:

Get commander territory.

Authority:

Any

Parameters:

Commander Object

Returns:

Array

---

# INTEL SUBSYSTEM

## IDS_fnc_reportContact

Purpose:

Create intel report.

Authority:

Server Only

Parameters:

Observer
Target

Returns:

Intel Object

---

## IDS_fnc_addIntel

Purpose:

Add intel to database.

Authority:

Server Only

Parameters:

Intel Object

Returns:

Intel ID

---

## IDS_fnc_decayIntel

Purpose:

Remove stale intel.

Authority:

Server Only

Parameters:

None

Returns:

Nothing

---

## IDS_fnc_getKnownEnemyPositions

Purpose:

Retrieve valid enemy positions.

Authority:

Any

Parameters:

Commander Object

Returns:

Array

---

# OPERATIONS SUBSYSTEM

## IDS_fnc_createOperation

Purpose:

Create mission.

Authority:

Server Only

Parameters:

Operation Type
Target

Returns:

Operation Object

---

## IDS_fnc_assignOperation

Purpose:

Assign operation to group.

Authority:

Server Only

Parameters:

Group
Operation

Returns:

Boolean

---

## IDS_fnc_updateOperations

Purpose:

Monitor mission progress.

Authority:

Server Only

Parameters:

None

Returns:

Nothing

---

## IDS_fnc_completeOperation

Purpose:

Mark operation successful.

Authority:

Server Only

Parameters:

Operation ID

Returns:

Nothing

---

## IDS_fnc_failOperation

Purpose:

Mark operation failed.

Authority:

Server Only

Parameters:

Operation ID

Returns:

Nothing

---

# INTEGRATION SUBSYSTEM

## IDS_fnc_VCOMAdapter

Purpose:

Bridge commander operations to VCOM.

Authority:

Server Only

Parameters:

Group
Operation

Returns:

Boolean

Notes:

Must not modify VCOM source.

---

## IDS_fnc_ODKAdapter

Purpose:

Bridge commander operations to ODKAI.

Authority:

Server Only

Parameters:

Group
Operation

Returns:

Boolean

Notes:

Must not modify ODKAI source.

---

# PERSISTENCE SUBSYSTEM

## IDS_fnc_saveState

Purpose:

Serialize framework state.

Authority:

Server Only

Parameters:

None

Returns:

Save Object

---

## IDS_fnc_loadState

Purpose:

Restore framework state.

Authority:

Server Only

Parameters:

Save Object

Returns:

Boolean

---

# UTILITY SUBSYSTEM

## IDS_fnc_generateUID

Purpose:

Generate framework IDs.

Authority:

Any

Parameters:

Prefix

Returns:

String

Examples:

LOC_001
INTEL_005
OP_023

---

## IDS_fnc_log

Purpose:

Framework logging.

Authority:

Any

Parameters:

Message

Returns:

Nothing

Log Format:

[IDS COMMANDER] Message

---

# RESERVED FUTURE FUNCTIONS

These names are reserved.

Do not implement alternate versions.

Commander:

* IDS_fnc_evaluateDoctrine
* IDS_fnc_requestSupport
* IDS_fnc_allocateReserves

Intel:

* IDS_fnc_createIntelNetwork
* IDS_fnc_processReconData

Economy:

* IDS_fnc_processLogistics
* IDS_fnc_updateSupplyLines

Operations:

* IDS_fnc_createAmbushOperation
* IDS_fnc_createRaidOperation
* IDS_fnc_createArtilleryOperation

Strategic:

* IDS_fnc_createRegionalCommander
* IDS_fnc_updateCampaignState
