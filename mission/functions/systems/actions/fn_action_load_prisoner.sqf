/*
	File: fn_action_load_prisoner.sqf
	Author: Legend
	Public: No

	Description:


	Parameter(s):
		none.

	Returns: nothing

	Example(s):
		call fn_action_load_prisoner;
*/

[
	player,
	format ["<t color='#ffe600ff'>%1</t>", localize 'STR_vn_mf_load_player'],
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa",	// Progress icon shown on screen
	"(player getVariable ['vn_mf_db_player_group',''] in ['MilitaryPolice']) && (cursorTarget getVariable ['vn_mf_db_player_group',''] in ['DacCong']) && player distance cursorTarget <= 3 && vehicle player isEqualTo player && cursorTarget isKindOf 'Man' && alive cursorTarget && !(cursorTarget getVariable ['isArrested',false]) && !(cursorTarget getVariable ['isUnconscious', false])",								  // Condition for the action to be shown
	"player distance cursorTarget < 5",							// Condition for the action to progress
	{},															// Code executed when action starts
	{},															// Code executed on every progress tick
	{
		[cursorTarget, player] remoteExec ["vn_mf_fnc_load_prisoner", 2];
	},															// Code executed on completion I need to make this function
	{},															// Code executed on interrupted
	[],															// Arguments passed to the scripts as _this select 3
	2,															// Action duration [s]
	100,														// Priority
	false,														// Remove on completion
	false														// Show in unconscious state
] call BIS_fnc_holdActionAdd;
