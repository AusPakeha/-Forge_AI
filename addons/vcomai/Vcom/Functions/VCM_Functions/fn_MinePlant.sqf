/*
    Author: Genesis
    Description:
        Plants a mine
    Parameter(s):
        0: OBJECT - Unit to plant a mine
        1: ARRAY - ???
    Returns:
        NOTHING
*/
// --- Exit early if disabled
if (VCM_MINECHANCE <= 0) exitWith {
    diag_log "[VCOM] Mine laying skipped (VCM_MINECHANCE = 0)";
};

{
    // Skip players
    if (isPlayer _x) exitWith {};

    // Chance check (0..100 roll must be below VCM_MINECHANCE)
    if ((random 100) > VCM_MINECHANCE) exitWith {};

    private _Unit = _x;
    private _nearestEnemy = _Unit call VCM_fnc_ClstEmy;
    if (_nearestEnemy isEqualTo [] || {isNil "_nearestEnemy"}) exitWith {};
	
private _mine = "";

    if (_nearestEnemy distance2D _Unit < 100) then {
        // place near enemy
        private _magsAmmo = magazinesAmmo _Unit;
        {
            private _mag = _x select 0;
            private _Index = (VCM_MineList findIf {_mag isEqualTo _x#1});
            if (_Index > -1) exitWith {
                private _Mine = VCM_MineList#_Index;
                _Unit fire [(_Mine#3), (_Mine#3), (_Mine#1)];
                [_Unit, (_Mine#2)] spawn {
                    params ["_Unit", "_Mine"];
                    private _Pos = getPos _Unit;
                    sleep 3;
                    {
                        if (_Mine isEqualTo typeOf _x) then {
                            VCOM_mineArray pushBack [_x, side _Unit];
                        };
                    } forEach nearestObjects [_Pos, [], 1];
                };
            };
        } forEach _magsAmmo;
    } else {

            private _nearRoads = _Unit nearRoads 50;
            if (count _nearRoads > 0) then
            {
                private _closestRoad = [_nearRoads, _Unit, true] call VCM_fnc_ClstObj;
                private _magsAmmo = magazinesAmmo _Unit;
                {
                    private _mag = _x select 0;
                    private _Index = (VCM_MineList findif {_mag isEqualTo _x#1});
                    if (_Index > -1) exitWith
                    {
                        private _Mine = VCM_MineList#_Index;
                        _Unit fire [(_Mine#3), (_Mine#3), (_Mine#1)];
                        [_Unit, "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon"] remoteExec ["Vcm_PMN", 0];
                        [_Unit, (_Mine#2), _closestRoad] spawn
                        {
                            params ["_Unit", "_Mine", "_closestRoad"];
                            private _Pos = getpos _Unit;
                            sleep 3;
                            private _NrstMine = nearestObjects [_Pos, [], 1];
                            {
                                if (_Mine isEqualTo (typeof _x)) then
                                {
                                    _x setposATL (getposATL _closestRoad);
                                    _unitSide = (side _Unit);
                                    VCOM_mineArray pushBack [_x, _unitSide];
                                };
                            } foreach _NrstMine;
                        };
                    };
                } foreach _magsAmmo;
            }
            else
            {
                private _magsAmmo = magazinesAmmo _Unit;
                {
                    private _mag = _x select 0;
                    private _Index = (VCM_MineList findif {_mag isEqualTo _x#1});
                    if (_Index > -1) exitWith
                    {
                        private _Mine = VCM_MineList#_Index;
                        _Unit fire [(_Mine#3), (_Mine#3), (_Mine#1)];
                        [_Unit, "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon"] remoteExec ["Vcm_PMN", 0];
                        [_Unit, (_Mine#2)] spawn
                        {
                            params ["_Unit", "_Mine"];
                            private _Pos = getpos _Unit;
                            sleep 3;
                            private _NrstMine = nearestObjects [_Pos, [], 1];
                            {
                                if (_Mine isEqualTo (typeof _x)) then
                                {
                                    _unitSide = (side _Unit);
                                    VCOM_mineArray pushBack [_x, _unitSide];
                                };
                            } foreach _NrstMine;
                        };
                    };
                } foreach _magsAmmo;
            };
        };
    } foreach (units _this);
