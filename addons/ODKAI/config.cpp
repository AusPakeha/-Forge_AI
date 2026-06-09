class CfgPatches {
	class ODKAI
	{
		units[]=
		{
			"ODKAI"
		};
		requiredVersion=1;
		requiredAddons[]=
		{
			"cba_main"
		};
		authors[]=
		{
			"RedCharlie & IlSigSmoke"
		};
	};
};

class Extended_PreInit_EventHandlers {
	class ODKAI
	{
		init="call compile preprocessFileLineNumbers 'z\ODKAI\addons\ODKAI\XEH_preInit.sqf'";
		disableModuload=1;
	};
};

class CfgFunctions {
	class ODKAI
	{
		class ODKAI_Initialization
		{
			class Init
			{
				file="z\ODKAI\addons\ODKAI\init.sqf";
				preInit=1;
			};
		};
	};
	class DEBUG
	{
		class DEBUG
		{
			class postInit
			{
				file="z\ODKAI\addons\ODKAI\post_init.sqf";
				postInit=1;
			};
		};
	};
};

class CfgVehicles {
	class CAManBase;
	class Civilian;
	class SoldierWB: CAManBase
	{
		fsmDanger="z\ODKAI\addons\ODKAI\ODKAI\AIUnits\danger.fsm";
	};
	class SoldierEB: CAManBase
	{
		fsmDanger="z\ODKAI\addons\ODKAI\ODKAI\AIUnits\danger.fsm";
	};
	class SoldierGB: CAManBase
	{
		fsmDanger="z\ODKAI\addons\ODKAI\ODKAI\AIUnits\danger.fsm";
	};

};

class CfgFSMs {
	class Formation
	{
		class States
		{
			class Hide_or_Out
			{
				class Init
				{
					function = "formationInit";
					parameters[] = {};
					/*
					set slot 1 to random value
					the offset of the values from 0..1
					determines the ratio between hiden and out
					(The higher, the less are we out)
					*/
					thresholds[] = {{1, 0.2, 1.2}};
				};	
			}
			class Drop_to_ground
			{
				class Init
				{
					function="nothing";
					parameters[]={};
					thresholds[]={};
				};
			};
			class Drop_to_ground_1
			{
				class Init
				{
					function="nothing";
					parameters[]={};
					thresholds[]={};
				};
			};
			class Hide_in_cover__Hidden
			{
				class Init
				{
					function="searchPath";
					parameters[]={26,8};
					thresholds[]={};
				};
			};
			class Search_path__Covering
			{
				class Init
				{
					function="searchPath";
					parameters[]={26,8};
					thresholds[]={};
				};
			};
		};
	};
};

class Cfg3DEN {
	/*
	class Group
	{
		class AttributeCategories
		{
			class Odkai_attributes
			{
				collapsed=1;
				displayName="ODKAI Options";
				class Attributes
				{
					class ODKAI_disableHQ
					{
						property="odkai_disableHQ";
						control="Checkbox";
						displayName="Disable HQ Controls";
						tooltip="This Group won't be controlled by HQ";
						expression="if (_value) then {_this setVariable ['odkai_HQDisabled', _value, true]}";
						typeName="BOOL";
						condition="1";
						defaultValue="(false)";
					};
				};
			};
		};
	};
	*/
	class Object
	{
		class AttributeCategories
		{
			class Odkai_attributes
			{
				collapsed=1;
				displayName="ODKAI Options";
				class Attributes
				{
					class ODKAI_disableUAV
					{
						property="odkai_disableUAV";
						control="Checkbox";
						displayName="ODKAI UAV Disabled";
						tooltip="Disable ODKAI FSM for UAV";
						expression="if (_value) then {_this setVariable ['odkai_UAVDisabled', _value, true]}";
						typeName="BOOL";
						condition="objectVehicle";
						defaultValue="(false)";
					};
					class ODKAI_disableAI
					{
						property="odkai_disableAI";
						control="Checkbox";
						displayName="ODKAI Disabled";
						tooltip="Disable ODKAI FSM for this Unit";
						expression="if (_value) then {_this setVariable ['odkai_Disabled', _value, true]}";
						typeName="BOOL";
						condition="objectControllable";
						defaultValue="(false)";
					};
					class ODKAI_disableVehicle
					{
						property="odkai_disableVehicle";
						control="Checkbox";
						displayName="VEHICLE Unused by AI";
						tooltip="VEHICLE Unused by AI odkai";
						expression="if (_value) then {_this setVariable ['odkai_VEhDisabled', _value, true]}";
						typeName="BOOL";
						condition="objectVehicle";
						defaultValue="(false)";
					};
				};
			};
		};
	};
};







class Mode_SemiAuto;
class CfgWeapons {
    class LauncherCore;
    class Launcher;
    class Launcher_Base_F: Launcher {
        class WeaponSlotsInfo;
    };
    //class Launcher_Base_F;
    class Launch_RPG7_F : Launcher_Base_F {
        class Single : Mode_SemiAuto {
            dispersion = 0.015;
            aiDispersionCoefX = 1.7;
            aiDispersionCoefY = 2.3;
            aiRateOfFire = 5;
            aiRateOfFireDispersion = 5;
            aiRateOfFireDistance = 450;
            maxRange = 450;
            maxRangeProbab = 0.3;
            midRange = 100;
            midRangeProbab = 0.6;
            minRange = 20;
            minRangeProbab = 0.3;
            recoil = "recoil_single_law";
            sounds[] = {"StandardSound"};
        };
    };


    class launch_RPG32_F : Launcher_Base_F {
        class Single : Mode_SemiAuto {
            aiDispersionCoefX = 1.7;
            aiDispersionCoefY = 2.2;
            aiRateOfFire = 5;
            aiRateOfFireDispersion = 5;
            aiRateOfFireDistance = 600;
            maxRange = 600;
            maxRangeProbab = 0.6;
            midRange = 100;
            midRangeProbab = 0.6;
            minRange = 20;
            minRangeProbab = 0.6;
            recoil = "recoil_single_law";
            sounds[] = {"StandardSound"};
        };
    };

    class CUP_launch_RPG7V : Launcher_Base_F {
        class Single : Mode_SemiAuto {
            dispersion = 0.018;
            aiDispersionCoefX = 1.8;
            aiDispersionCoefY = 2.3;
            aiRateOfFire = 5;
            aiRateOfFireDispersion = 5;
            aiRateOfFireDistance = 300;
            maxRange = 450;
            maxRangeProbab = 0.3;
            midRange = 100;
            midRangeProbab = 0.6;
            minRange = 20;
            minRangeProbab = 0.3;
            //sounds[] = {"StandardSound"};
        };
    };




   class launch_MRAWS_base_F: Launcher_Base_F { 
        class Single : Mode_SemiAuto {
            aiDispersionCoefX = 1.7;
            aiDispersionCoefY = 2.2;
            aiRateOfFire = 2;
            aiRateOfFireDispersion = 1;
            aiRateOfFireDistance = 600;
            maxRange = 600;
            midRange = 100;
            minRange = 20;
        };
    };


   class launch_NLAW_F: Launcher_Base_F {
        class Single : Mode_SemiAuto {
            aiRateOfFire = 2;
            aiRateOfFireDispersion = 1;
            midRange = 100;
            minRange = 20;
        };
    };


   class launch_Vorona_base_F: Launcher_Base_F { 
        class Single : Mode_SemiAuto {
            aiRateOfFire = 2;
            aiRateOfFireDispersion = 1;
            midRange = 100;
            minRange = 20;
        };
    };

};

class CfgAmmo {
    class RocketCore;
    class RocketBase;
    class R_PG7_F : RocketBase {
        aiAmmoUsageFlags = "64 + 128 + 512";
        airLock = 1;
        allowAgainstInfantry = 1;
        cost = 0.1;

        //thrust = 470;
        effectsMissile = "missile3";
        whistleDist = 30;
    };
    class M_SPG9_HEAT : RocketBase {
        aiAmmoUsageFlags = "64 + 128 + 512";
        allowAgainstInfantry = 1;
        airLock = 1;
        cost = 0.1;
    };
    class R_PG32V_F : RocketBase {
        aiAmmoUsageFlags = "64 + 128 + 512";
        airLock = 1;
        allowAgainstInfantry = 1;
        cost = 0.1;
    };
    class R_MRAAWS_HEAT_F : RocketBase {
        aiAmmoUsageFlags = "64 + 128 + 512";
        airLock = 1;
        allowAgainstInfantry = 1;
        cost = 0.1;
    };

    class CUP_R_PG7V_AT : RocketBase {
        aiAmmoUsageFlags = "64 + 128 + 512";
        airLock = 1;
        airFriction = 0.5;
        allowAgainstInfantry = 1;
        cost = 0.1;
        effectsMissile = "missile3";
        whistleDist = 30;

    };

    class MissileCore;
    class MissileBase;
    class M_Vorona_HEAT : MissileBase {
        aiAmmoUsageFlags = "64 + 128 + 512";
        airLock = 1;
        allowAgainstInfantry = 1;
        cost = 0.1;
    };

    class M_NLAW_AT_F : MissileBase {
        aiAmmoUsageFlags = "64 + 128 + 512";
        airLock = 1;
        allowAgainstInfantry = 1;
        cost = 0.1;
    };

    class M_Titan_AT : MissileBase {
        aiAmmoUsageFlags = "64 + 128 + 512";
        airLock = 1;
        allowAgainstInfantry = 1;
        cost = 0.1;
    };

    class GrenadeCore;
    class GrenadeBase;

    class G_40mm_HE : GrenadeBase {
        aiAmmoUsageFlags = "64 + 128";
        allowAgainstInfantry = 1;
        cost = 0.1;
    };

	class BulletBase;
	class SmokeLauncherAmmo: BulletBase
	{
		muzzleEffect = "BIS_fnc_effectFiredSmokeLauncher";
		effectsSmoke = "EmptyEffect";
		weaponLockSystem = "1 + 2 + 4";
		hit = 1;
		indirectHit = 0;
		indirectHitRange = 0;
		timeToLive = 10.0;
		thrustTime = 10.0;
		airFriction = -0.1;
		simulation = "shotCM";
		model = "\A3\weapons_f\empty";
		maxControlRange = 50;
		initTime = 2;
		aiAmmoUsageFlags = "4 + 8 + 64";
	};
	class SmokeLauncherAmmo_boat: SmokeLauncherAmmo
	{
		muzzleEffect = "BIS_fnc_effectFiredSmokeLauncher_boat";
	};

};

class CfgCloudlets
{
	class Default;
	class SmokeShellWhite: Default
	{

		animationSpeedCoef = 0.00001;
		colorCoef[] = {"colorR","colorG","colorB",1.8};
		sizeCoef = 1;

		moveVelocity[]={0.1,0.5,0.5};
		size[]={0.46000001,4.5,9,15};
		MoveVelocityVar[]={1.25,0.1,0.60000002};
		weight=1.27767;
		circleRadius=0.1;
		blockAIVisibility=1;
		lifeTime=8;

	};
	class SmokeShellWhiteSmall: Default
	{

		animationSpeedCoef = 0.00001;
		colorCoef[] = {"colorR","colorG","colorB",1.8};
		sizeCoef = 1;

		moveVelocity[]={0.1,0.5,0.5};
		size[]={0.46000001,4.5,9,15};
		MoveVelocityVar[]={1.25,0.1,0.60000002};
		weight=1.27767;
		circleRadius=0.1;
		blockAIVisibility=1;
		lifeTime=8;

	};
	class LauncherSmoke: Default
	{
		animationSpeedCoef = 0.00001;
		colorCoef[] = {"colorR","colorG","colorB",1.8};
		sizeCoef = 1;

		moveVelocity[]={0.1,0.5,0.5};
		size[]={0.46000001,4.5,9,15};
		MoveVelocityVar[]={1.25,0.1,0.60000002};
		weight=1.27767;
		circleRadius=0.1;
		blockAIVisibility=1;
		lifeTime=10;
	};
};

class CfgBrains
{
	class DefaultSoldierBrain
	{
		class Components
		{
			class AIBrainSuppressionComponent
			{
				maxSuppression=1.3;
				worstDecreaseTime=3;
				bestDecreaseTime=1;
				SuppressionRange=20;
				CauseFireWeight=0.89999998;
				CauseHitWeight=0.80000001;
				CauseExplosionWeight=0.69999999;
				CauseBulletCloseWeight=0.69999999;
				SuppressionThreshold=0.89999998;
			};

		};
	};


	class CfgVehicles
	{
		class AICarSteeringComponent
		{
			allowOvertaking=1;
			allowCollisionAvoidance=1;
			allowDrifting=1;
			ejectDamageLimit=0.75;
		};
		class AITankSteeringComponent
		{
			allowOvertaking=1;
			allowCollisionAvoidance=1;
			allowDrifting=1;
			allowTurnAroundInPoint=1;
			ejectDamageLimit=0.89999998;
		};
	};


};