/*
    IDS Commander AI - Tick Operations (server auth)

    This loops forever and updates all operations in IDS_Operations.
    Not used by default because fn_startloops runs separate loops.
    Kept for compatibility / future decoupling.
*/

if !(call IDS_fnc_isAuthority) exitWith {};

while {true} do
{
    private _ops = missionNamespace getVariable ["IDS_Operations", createHashMap];

    {
        private _op = _y;
        [_op] call IDS_fnc_updateOperation;
    } forEach _ops;

    sleep 10;
};

