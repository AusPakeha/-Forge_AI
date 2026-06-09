/*
    File: fn_ShareContact.sqf
    Description:
        Shares known enemy contacts between nearby friendly leaders.

        Behavior:
        - Runs continuously every ~40–50 seconds.
        - Only triggers if VCM_SHARE_Distance >= 1.
        - Leaders with knowsAbout > 2 share that knowledge
          with other friendly leaders within the given distance.
*/

[] spawn {

    while {true} do {
        sleep (40 + random 10);

        private _shareDist = missionNamespace getVariable ["VCM_SHARE_Distance", 50];

        // --- Disable sharing when distance < 1 ---
        if (_shareDist < 1) exitWith {};

        private _leaders = allUnits select {
            leader group _x == _x && {alive _x}
        };

        {
            private _ldr = _x;

            private _enemies = allUnits select {
                side _x getFriend side _ldr < 0.6 && {alive _x}
            };

            {
                private _enemy = _x;
                private _kv = _ldr knowsAbout _enemy;

                if (_kv > 2) then {
                    private _nearLeaders = _leaders select {
                        _x != _ldr && {_ldr distance _x < _shareDist}
                    };

                    {
                        private _receiver = _x;
                        if (local _receiver) then {
                            _receiver reveal [_enemy, _kv];
                        };
                    } forEach _nearLeaders;
                };
            } forEach _enemies;
        } forEach _leaders;
    };
};
