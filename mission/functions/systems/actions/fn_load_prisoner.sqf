/*
	File: fn_load_prisoner.sqf
	Author: Legend
	Public: No

	Description:
		Moves arrested DAC player into nearby vehicle.

	Parameter(s):
		0: _unit (Object) – The DAC player
		1: _mp (Object) – The MP attempting to load

	Returns: nothing

	Example(s):
		[_unit, _mp] remoteExec ["vn_mf_fnc_load_prisoner", 2];
*/

params ["_unit", "_mp"];

if (!alive _unit || !(isPlayer _unit)) exitWith {};
if (!alive _mp || !(isPlayer _mp)) exitWith {};

private _vehicle = nearestObjects [_mp, ["Car", "Truck"], 10] select {
	(isNull driver _x) &&
	(count (_x emptyPositions "cargo") > 0)
} param [0, objNull];


if (isNull _vehicle) exitWith {
	[_mp, "No valid vehicle nearby to load prisoner."] remoteExec ["hint", _mp];
};

[_unit] remoteExec ["", _unit]; // Optional: add any prep or animations here

// Move the DAC player in as cargo (must run on DAC player's machine!)
_unit moveInCargo _vehicle; // then the function itself?
