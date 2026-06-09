/*
    FINAL VCOM ITN + Vanilla Light Detection (Updated with Robust ITN Variables)
    PLAYER-ONLY DETECTION VERSION
*/

if !(missionNamespace getVariable ["VCM_LIGHTDETECT_INFANTRY", true]) exitWith {};

private _interval = 10;
private _maxDist  = 501;

private _itnLoaded =
    isClass (configFile >> "CfgPatches" >> "gjb_itn_core")
 || isClass (configFile >> "CfgPatches" >> "gjb_itn");

// --- Distance-based reveal cap ---
private _getRevealCap = {
    params ["_distance"];
    switch (true) do {
        case (_distance < 200): { 2.5 };
        case (_distance < 300): { 2.0 };
        case (_distance < 400): { 1.6 };
        case (_distance < 500): { 1.4 };
        default { 1.0 };
    };
};

while {Vcm_ActivateAI} do
{
    sleep _interval;

    // Night only
    if (sunOrMoon > 0.2) then { continue };

    private _players = allPlayers;
    if (_players isEqualTo []) then { continue };

    private _emitters = [];

    // ============================================================
    // PLAYER-ONLY EMITTER SCAN
    // ============================================================
    {
        private _u = _x;
        if (!alive _u) then { continue };  // sanity

        // NEARBY PLAYER CHECK
        private _near = false;
        {
            if (_u distance2D _x <= _maxDist) exitWith { _near = true };
        } forEach _players;

        if (!_near) then { continue };

        private _vis = false;
        private _ir  = false;

        // ---------- Vanilla attachments ----------
        private _w = currentWeapon _u;
        if (_w != "") then {
            if (_u isFlashlightOn _w) then { _vis = true };
            if (_u isIRLaserOn _w) then  { _ir  = true };
        };

        // ---------- ITN ----------
        if (_itnLoaded) then {

            // IR illuminator object
            private _illumObject = _u getVariable ["gjb_itn_illumobject", objNull];
            if (!isNull _illumObject) then { _ir = true };

            private _ds = _u getVariable ["gjb_itn_devicestate", []];
            if (typeName _ds == "ARRAY" && {count _ds >= 5 && {(_ds select 0) == 1}}) then {

                private _irIllumState = _ds select 4;

                if (_irIllumState == 5 || _irIllumState == 4) then { _ir = true };
                if ((_ds select 1) == 1) then { _ir = true };

                if ((_ds select 3) == 1) then { _vis = true };
                if ((_ds select 4) == 8) then { _vis = true };
            };
        };

        // ---------- WBK headlamps ----------
        if (isClass (configFile >> "CfgPatches" >> "WBK_Headlamps")) then {
            private _wbkLights = _u getVariable ["WBK_AttachedFlaslights", []];
            if (count _wbkLights > 0) then { _vis = true };
        };

        if (!(_vis || _ir)) then { continue };

        _emitters pushBack [_u, _vis, _ir];

    } forEach _players;   // <-- ONLY PLAYERS scanned now

    if (_emitters isEqualTo []) then { continue };


    // ============================================================
    // REVEAL LOGIC (AI team leaders only)
    // ============================================================
    {
        private _grp = _x;
        private _lead = leader _grp;

        if (!local _lead) then { continue };
        if (!(alive _lead && {simulationEnabled _lead})) then { continue };

        {
            private _tgt  = _x select 0;
            private _vis2 = _x select 1;
            private _ir2  = _x select 2;

            if (!(_vis2 || _ir2)) then { continue };

            // Must be enemy
            if !([side _lead, side _tgt] call BIS_fnc_sideIsEnemy) then { continue };

            private _dist = _lead distance _tgt;

            // IR requires NVG
            if (_ir2 && {currentVisionMode _lead != 1}) then { continue };

            // LOS
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

            private _found = _los isEqualTo [];

            // Cascade LOS under 150m
            if (!_found && {_dist < 150}) then {
                {
                    private _u2 = _x;
                    if (_u2 isEqualTo _lead) then { continue };
                    if (!alive _u2 || !(_u2 isKindOf "Man")) then { continue };

                    sleep (0.1 + random 0.1);

                    private _gFrom = eyePos _u2;

                    private _gLos = lineIntersectsSurfaces
                    [
                        _gFrom,
                        _to,
                        _u2,
                        _tgt,
                        true,
                        1,
                        "GEOM"
                    ];

                    if (_gLos isEqualTo []) exitWith { _found = true };

                } forEach units _grp;
            };

            if (!_found) then { continue };

            // Knowledge gain
            private _maxKnowledge = [_dist] call _getRevealCap;
            private _old = _lead knowsAbout _tgt;
            private _add = 0.6 + random 0.9;
            private _new = (_old + _add) min _maxKnowledge;

            _lead reveal [_tgt, _new];

        } forEach _emitters;

    } forEach VcmAI_ActiveList;

};
