/*
    IDS Commander AI - Pad Number (v0.1)

    Purpose:
        Left-pad integer values for stable ID formatting.

    Example:
        [15, 6] call IDS_fnc_padNumber

    Returns:
        "000015"
*/

params [
    "_number",
    "_digits"
];

private _str = str _number;

while {(count _str) < _digits} do {
    _str = "0" + _str;
};

_str
