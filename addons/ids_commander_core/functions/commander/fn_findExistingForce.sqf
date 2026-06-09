/*
    IDS Commander AI - Find Existing Force (Version 2) (chat27.sqf)

    Simplified category-based lookup for groups.

    Params:
        0: _categoryOrType (String) e.g. "RECON" or "INFANTRY" or package category.

    Returns:
        grpNull or a matching group.

    Notes:
        This is intentionally lightweight for v0: it searches current mission groups.
*/

params [
    ["_categoryOrType",""],
    ["_side", east]
];

if !(call IDS_fnc_isAuthority) exitWith {grpNull};

if (_categoryOrType isEqualTo "") exitWith {grpNull};

private _allGroups = allGroups select { (side _x) isEqualTo _side };

// Prefer groups that were tagged by IDS when spawned.
{
    private _pkgKey = _x getVariable ["IDS_PackageKey",""];
    if (_pkgKey isEqualTo "") then
    {
        // Fallback: category tagging.
        private _cat = _x getVariable ["IDS_Category",""];
        if (_cat isEqualTo _categoryOrType) exitWith {_x};
    }
    else
    {
        private _pkg = IDS_ForcePackages getOrDefault [_pkgKey, createHashMap];
        private _cat = _pkg getOrDefault ["Category",""];
        if (_cat isEqualTo _categoryOrType) exitWith {_x};
    };
} forEach _allGroups;

grpNull

