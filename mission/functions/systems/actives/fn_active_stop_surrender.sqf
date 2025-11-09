/*
	File: fn_active_stop_surrender.sqf
	Author: Legend
	Public: No

	Description:
		Allows DAC player to stop surrendering via wheel menu.

	Parameter(s): None

	Returns: None

	Example(s):
		call vn_mf_fnc_active_stop_surrender;
*/

if (([player, 'DacCong'] call vn_mf_fnc_player_on_team)) then
{
	[player] spawn
	{
		params ["_player"];

		// Ensure this executes on the client where the player is local
		if (!local _player) exitWith {};

		// Clear surrender state (sync this globally)
		_player setVariable ["isSurrendered", false, true];

		// --- THE FIX ---
		// 1. First, tell the engine to release the current forced animation.
		//    This will cause a quick snap to a default idle for a split second.
		[_player, ""] remoteExec ["switchMove", _player];
        //sleep 0.05; // A tiny pause to allow the engine to process the switch. Sometimes necessary.

		// 2. Then, play the smooth transition animation.
		//    It will now play from the player's natural idle state.
		[_player, "AmovPercMstpSsurWnonDnon_AmovPercMstpSnonWnonDnon"] remoteExec ["playMoveNow", _player];

		// Optional: You might want a small delay after the transition too if other scripts
		// are trying to re-assert control or check the animation state very rapidly.
		// sleep 0.5; // Example
	};
};