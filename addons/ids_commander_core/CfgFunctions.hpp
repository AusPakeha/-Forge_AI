class IDS
{
    class Init
    {
        file = "\ids_commander_core\functions\init";

        class init {};
        class initIDSystem {};
        class startLoops {};
        class isAuthority {};
    };

    class World
    {
        file = "\ids_commander_core\functions\world";

        class buildWorld {};
        class scanLocations {};
        class scanMilitaryLocations {};
        class generateSpawnPoints {};
        class getLocationData {};
        class buildRoadNetwork {};
    };

    // World Events integration (chat31) - lives in ids_commander_strategic addon
    class WorldEvents
    {
        file = "\ids_commander_strategic\functions\world";

        class updateEvents {};
        class applyWorldEventsToState {};
    };

    class Commander
    {
        file = "\ids_commander_core\functions\commander";

        class createCommander {};
        class selectCommander {};
        class updateCommander {};

        class initCommanders {};
        class getCommanderData {};
        class registerCommanderGroup {};
        class commitForce {};
        class releaseForce {};

        // Force Allocation System (chat29)
        class fn_forceAllocationPass {};
        class fn_generateStrategicOperations {};

        // Force Package System (chat27.sqf)
        class initForcePackages {};
        class requestForcePackage {};
        class spawnPackage {};
        class findExistingForce {};
        class selectBestForcePackage {};

        // Force Package Framework contracts (v0.1)
        // Spawn contract wrapper returns [_groupIDs, _vehicleIDs]
        class spawnForcePackage {};

        // Internal v0.1 implementation (used by spawnForcePackage)
        class spawnForcePackage_v1 {};
        class requestForcePackage_v1 {};

        // Force package and faction helpers (v0.1)
        class fn_getFactionTemplate {};
        class fn_registerGroup {};
        class fn_getGroupData {};
        class fn_getGroupObject {};
        class fn_addReserveGroup {};
        class fn_assignGroupToCommanderOperation {};
        class fn_releaseGroupFromOperation {};
        class fn_getCommanderReserveGroups {};
        class fn_calculateCommanderCombatPower {};

        // Group registry helpers (v0.1)
        class fn_groupRegistry_get {};
        class fn_groupRegistry_getObject {};
        class fn_groupRegistry_getAvailableGroups {};
        class fn_groupRegistry_setStatus {};
        class fn_groupRegistry_assignOperation {};
        class fn_groupRegistry_register {};
        class fn_groupRegistry_unregister {};
    };

    class Economy
    {
        file = "\ids_commander_core\functions\economy";

        class updateEconomy {};
        class tickEconomy {};
        class checkReinforcements {};
        class spawnReinforcementSquad {};
        class applyCasualties {};
    };

    class Intel
    {
        file = "\ids_commander_core\functions\intel";

        class initializeIntel {};
        class updateIntel {};
    };

    class Operations
    {
        file = "\ids_commander_core\functions\operations";

        class initializeOperations {};
        class updateOperations {};

        class createOperation {};
        class getOperationData {};
        class setOperationState {};
        class planOperation {};
        class allocateOperationForces {};
        class stageOperation {};
        class completeCaptureOperation {};
        class failOperation {};

        class tickOperations {};
        class updateOperation {};
        class updateCaptureOperation {};
        class updateDefendOperation {};
        class updatePatrolOperation {};
        class updateReconOperation {};
        class operationDeploy {};
        class operationMarch {};
        class operationEngage {};
        class operationResolve {};
        class getLocationByPosition {};
    };

    class Territory
    {
        file = "\ids_commander_core\functions\territory";

        class fn_buildLocationGraph {};
        class fn_updateFrontlines {};
        class fn_updateFrontlineRegions {};
        class fn_selectFrontlineFocus {};
        class fn_scoreStrategicTargets {};
        class fn_getFrontlineTargetPos {};
        class fn_getLocationByID {};
    };

    class Persistence
    {
        file = "\ids_commander_core\functions\persistence";

        class saveState {};
        class loadState {};
    };

    class Utility
    {
        file = "\ids_commander_core\functions\utility";

        class log {};
        class generateUID {};
        class generateID {};
        class padNumber {};
        class resetIDSystem {};
    };
};

