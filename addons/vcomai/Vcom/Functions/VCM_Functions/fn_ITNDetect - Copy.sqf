/*
    VCOM - ITN + Vanilla Light Detection
    FINAL PATCHED VERSION
    ------------------------------------
    Fixes:
      ✔ IR illuminator not detected
      ✔ Vanilla IR laser working
      ✔ Reveal runs ONLY while emitting
      ✔ No looping reveal after light OFF
      ✔ ITN slot 0/1 logic correct
      ✔ Clean and safe full file
*/

if !(missionNamespace getVariable ["VCM_LIGHTDETECT_INFANTRY", true]) exitWith {};

private _interval = 10;
private _maxDist  = 800;

// Detect ITN mod
private _itnLoaded =
    isClass (configFile >> "CfgPatches" >> "gjb_itn_core")
 || isClass (configFile >> "CfgPatches" >> "gjb_itn");

if (!_itnLoaded) exitWith {
    systemChat "VCOM-ITN: ITN not loaded.";
};

// MAIN LOOP
//---------------------------------------------------------------
while {Vcm_ActivateAI} do
{
    sleep _interval;

    // night only
    if (sunOrMoon > 0.2) then { continue };

    private _players = allPlayers;
    if (_players isEqualTo []) then { continue };

    private _emitters = [];

    //-----------------------------------------------------------
    // FIND EMITTERS (players or team leaders)
    //-----------------------------------------------------------
    {
        private _u = _x;

        if (!alive _u) then { continue };
        if (!(isPlayer _u || {_u isEqualTo leader (group _u)})) then { continue };

        // must be near ANY player
        private _near = false;
        {
            if (_u distance2D _x <= _maxDist) exitWith { _near = true };
        } forEach _players;

        if (!_near) then { continue };

        // ------------------------------
        // Vanilla IR Laser detection
        // ------------------------------
        private _weap = currentWeapon _u;
        private _vanillaIR = false;

        if (_weap != "") then {
            _vanillaIR = _u isIRLaserOn _weap;
        };

        // ------------------------------
        // ITN light object detection
        // ------------------------------
        private _objs = _u getVariable ["gjb_itn_lightobjects", ["",""]];

        private _emitVis = toLower (_objs select 1);    // VIS in slot 1
        private _emitIR  = toLower (_objs select 0);    // IR illuminator in slot 0

        // ITN VIS
        private _hasVis = (_emitVis find "_vis") > -1;

        // ITN IR illuminator pattern: gjb_itn_illum_dbal_*_Hi / Lo
        private _hasITN_IR =
                (_emitIR find "illum") > -1
            && ((_emitIR find "_hi") > -1 || (_emitIR find "_lo") > -1);

        // Final IR = ITN IR OR vanilla IR laser
        private _hasIR = false;
        if (_hasITN_IR) then { _hasIR = true };
        if (_vanillaIR) then { _hasIR = true };

        // If neither, skip target
        if (!(_hasVis || _hasIR)) then { continue };

        // Add emitter
        _emitters pushBack [_u, _hasVis, _hasIR];

        systemChat format [
            "EMITTER: %1 | VIS=%2 IR=%3 | data=%4",
            name _u,
            _hasVis,
            _hasIR,
            _objs
        ];

    } forEach allUnits;

    if (_emitters isEqualTo []) then { continue };

    //-----------------------------------------------------------
    // PROCESS AI LEADERS
    //-----------------------------------------------------------
    {
        private _grp  = _x;
        private _lead = leader _grp;

        if (!local _lead) then { continue };
        if (!(alive _lead && {simulationEnabled _lead})) then { continue };

        {
            private _tgt    = _x select 0;
            private _hasVis = _x select 1;
            private _hasIR  = _x select 2;

            // Fresh emission check: do NOT reveal unless emitting NOW
            if (!(_hasVis || _hasIR)) then { continue };

            // IR requires NVGs
            if (_hasIR && {currentVisionMode _lead != 1}) then { continue };

            // LOS check
            private _from = eyePos _lead;
            private _to   = eyePos _tgt;

            private _los = lineIntersectsSurfaces
            [
                _from,
                _to,
                _lead,
                _tgt,
                true,
                1,
                "GEOM"
            ];

            if !(_los isEqualTo []) then { continue };

            // REVEAL
            private _old = _lead knowsAbout _tgt;
            private _add = 0.8 + random 0.7;
            private _new = (_old + _add) min 2.5;

            _lead reveal [_tgt, _new];

            systemChat format [
                "VCOM-ITN: REVEAL %1 → %2 | %3 → %4 (VIS=%5 IR=%6)",
                name _lead,
                name _tgt,
                _old,
                _new,
                _hasVis,
                _hasIR
            ];

        } forEach _emitters;

    } forEach VcmAI_ActiveList;

};
