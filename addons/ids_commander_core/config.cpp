class CfgPatches
{
    class IDS_Commander_Core
    {
        name = "IDS Commander AI Core";

        units[] = {};
        weapons[] = {};

        requiredVersion = 2.14;

        requiredAddons[] =
        {
            "cba_main",
            "A3_Data_F",
            "A3_Functions_F"
        };

        author = "Innovative Dev Solutions";
        version = "0.1.0";
    };
};

class CfgFunctions
{
    #include "CfgFunctions.hpp"
};

class Extended_PreInit_EventHandlers
{
    class IDS_Commander_Core
    {
        init = "call compile preprocessFileLineNumbers '\ids_commander_core\XEH_preInit.sqf'";
    };
};

class Extended_PostInit_EventHandlers
{
    class IDS_Commander_Core
    {
        init = "call compile preprocessFileLineNumbers '\ids_commander_core\XEH_postInit.sqf'";
    };
};