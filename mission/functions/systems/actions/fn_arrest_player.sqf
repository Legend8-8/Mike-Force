/*
    File: fn_arrest_player.sqf
    Original Author: Duke Lawrence
    Modified by: Legend
    Public: No

    Description:
	    Flags DAC player as arrested, cancels surrender, applies visible animation.

    Parameter(s): 
        _target - [PLAYER]
        _player - [PLAYER] (MP performing the arrest)

    Returns: nothing

    Example(s):
	    [_target, _player] call vn_mf_fnc_arrest_player;
*/

params ["_target", "_player"];

if !(isPlayer _target) exitWith {};

// Run logic on the DAC player's machine
[_target] remoteExec [
	{
		params ["_unit"];

		_unit setVariable ["isArrested", true, true];
		_unit setVariable ["isSurrendered", false, true];

		// Restrained but walkable animation
		_unit playMoveNow "AmovPercMwlkSnonWnonDf";
		_unit playActionNow "gestureSurrender";

		// Loop the gesture every few seconds
		[_unit] spawn {
			while { _unit getVariable ["isArrested", false] } do {
				_unit playActionNow "gestureSurrender";
				sleep 5;
			};
		};
	},
	_target
];
