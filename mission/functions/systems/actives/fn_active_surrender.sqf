/*
File: fn_active_surrender.sqf
Author: Legend
Public: No

Description:  
	DAC player triggers surrender via wheel menu.  
	Plays animation, removes weapons, and flags unit as surrendered for MP actions.

Parameter(s):  
	None

Returns:  
	None

Example(s):  
	call vn_mf_fnc_active_surrender;
*/

if (([player, 'DacCong'] call vn_mf_fnc_player_on_team)) then
{
	[player] spawn
	{
		params ["_player"];

		// Flag as surrendered (globally syncs)
		_player setVariable ["isSurrendered", true, true];

		// Play surrender animation
		_player playMoveNow "AmovPercMstpSsurWnonDnon";

		// Optional: disarm
		//removeAllWeapons _player;
		//_player disableAI "AUTOTARGET";
		//_player disableAI "TARGET";
	};
};