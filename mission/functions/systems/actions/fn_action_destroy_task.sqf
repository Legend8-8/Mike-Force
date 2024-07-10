/*
	File: fn_action_destroy_task.sqf
	Author: Cerebral
	Public: No
	
	Description:
		Pops a task
	
	Parameter(s): none
	
	Returns:
	
	Example(s):
		call vn_mf_fnc_action_destroy_task;
*/

// stuff players can destroy
private _classNames = [
        'Land_vn_o_platform_04',
	'vn_o_nva_navy_static_zpu4',
	'Land_vn_pavn_launchers',
	'Land_vn_o_shelter_06',
	'vn_b_ammobox_01',
	'Land_vn_pavn_weapons_wide',
	'Land_vn_pavn_weapons_cache',
	'Land_vn_pavn_ammo',
	'Land_vn_pavn_weapons_stack1',
	'Land_vn_pavn_weapons_stack2',
	'Land_vn_pavn_weapons_stack3',
	'vn_b_ammobox_full_02',
	'vn_o_ammobox_wpn_04',
	'vn_o_ammobox_full_03',
	'vn_o_ammobox_full_07',
	'vn_o_ammobox_full_06',
	'vn_o_nva_65_static_zpu4',
	'vn_o_nva_navy_static_mortar_type63',
	'vn_o_nva_65_static_mortar_type53',
	'vn_o_nva_static_d44_01',
	'Land_vn_wf_vehicle_service_point_east',
	'vn_sa2',
	'vn_o_static_rsna75',
	'Land_vn_o_trapdoor_01',
	'vn_o_ammobox_02',
	'Land_CratesWooden_F',
	'vn_o_nva_navy_static_mortar_type63',
	'vn_o_nva_65_static_mortar_type53',
	'vn_o_nva_static_d44_01'
];

// stuff players can destory formatted as a list
private _objString = format ["['%1']", _classNames joinString "', '"];

// all the checks formatted as a single string
private _conditionToShowString = format ["(%1)",
	[
		format ["typeOf cursorObject in %1", _objString],
		"player distance cursorObject < 10",
		"side player != east",
		// the vn_tunnel module sets this variable globally,
		// meaning we should be able to inspect it locally as
		// a player (holdAction is player local)
		"(isNull (cursorObject getVariable ['vn_tunnel_tunnel_object', objNull]))"
	] joinString " && "
];

[
	player,											// Object the action is attached to
	localize "STR_vn_mf_destroy_task",							// Title of the action
	"custom\holdactions\holdAction_destroy_ca.paa",	// Idle icon shown on screen
	"custom\holdactions\holdAction_destroy_ca.paa",	// Progress icon shown on screen
	_conditionToShowString, // Condition for the action to be shown
	"player distance cursorObject < 10",						// Condition for the action to progress
	{},	// Code executed when action starts
	{},	// Code executed on every progress tick
	{
		[cursorObject, player] remoteExec ["vn_mf_fnc_sites_remoteactions_destroy_task", 2];
	},// Code executed on completion
	{},	// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	5,													// Action duration [s]
	100,													// Priority
	false,											// Remove on completion
	false												// Show in unconscious state
] call BIS_fnc_holdActionAdd;
