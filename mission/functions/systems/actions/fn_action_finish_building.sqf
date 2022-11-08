[
	player,											// Object the action is attached to
	localize "STR_vn_mf_build",										// Title of the action
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",				// Idle icon shown on screen
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",				// Progress icon shown on screen
	"(cursorObject getVariable 'para_g_building') getVariable 'para_g_build_progress' < 1",						// Condition for the action to be shown
	"(cursorObject getVariable 'para_g_building') getVariable 'para_g_build_progress' < 1",						// Condition for the action to progress
	{},											// Code executed when action starts
	{},											// Code executed on every progress tick
	{
		private _building = cursorObject getVariable 'para_g_building';

		[_building, 1] remoteExec ["para_s_fnc_building_add_build_progress", 2];
	},											// Code executed on completion
	{},												// Code executed on interrupted
	[],											// Arguments passed to the scripts as _this select 3
	3,												// Action duration [s]
	100,												// Priority
	false,												// Remove on completion
	false												// Show in unconscious state
] call BIS_fnc_holdActionAdd;