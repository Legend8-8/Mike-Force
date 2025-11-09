/*
    File: fn_eject_and_parachute.sqf
    Author: Legend + ChatGPT (adapted for MF actions system)
    Public: No

    Description:
        Server-side: equips a parachute from the aircraft backpack cargo, consumes it,
        ejects the player, then restores their original backpack after landing or death.

    Parameter(s):
        0: _ply (Object)    - requesting player
        1: _veh (Object)    - aircraft the player is currently in

    Example(s):
        [_ply, _veh] remoteExec ["vn_mf_fnc_eject_and_parachute", 2];
*/

if (!isServer) exitWith {};

params ["_ply","_veh"];
if (isNull _ply || {isNull _veh}) exitWith {};
if (!isPlayer _ply) exitWith {};
if (vehicle _ply != _veh) exitWith { ["You're no longer in that aircraft."] remoteExec ["hint", _ply]; };
if (!(_veh isKindOf "Air")) exitWith { ["Not an aircraft."] remoteExec ["hint", _ply]; };

// Optional: block pilot seat (index 0 on most airframes)
private _idx = _veh crewIndex _ply;
if (_idx isEqualTo 0) exitWith { ["Pilot ejection is disabled."] remoteExec ["hint", _ply]; };

// Parachute backpack classes used on your server (extend as needed)
private _parachuteClasses = [
    "B_Parachute",
    "vn_i_pack_parachute_01",
    "vn_o_pack_parachute_01",
    "vn_b_pack_parachute_01"
];

// Find a chute in backpack cargo
private _cargo = getBackpackCargo _veh; // [[classes],[counts]]
private _classes = _cargo param [0, []];
private _counts  = _cargo param [1, []];

private _foundIndex = -1;
private _foundClass = "";

{
    private _i = _classes find _x;
    if (_i > -1 && {_counts select _i > 0}) exitWith { _foundIndex = _i; _foundClass = _x; };
} forEach _parachuteClasses;

if (_foundIndex < 0) exitWith {
    ["No parachutes left in this aircraft."] remoteExec ["hint", _ply];
};

// Consume one chute in the vehicle cargo (server authoritative)
_counts set [_foundIndex, (_counts select _foundIndex) - 1];
clearBackpackCargoGlobal _veh;
{ _veh addBackpackCargoGlobal [_x, _counts select _forEachIndex]; } forEach _classes;

// Stash old backpack + items
private _oldClass = backpack _ply;
private _oldItems = [];
if (!isNull unitBackpack _ply) then {
    _oldItems = backpackItems _ply;
};

// Equip chute + eject
removeBackpackGlobal _ply;
// also do a local add on owner so it appears immediately
[_ply, _foundClass] remoteExecCall ["addBackpack", _ply];
_ply action ["EJECT", _veh];

// Restore backpack after landing or death
[_ply, _oldClass, _oldItems, _foundClass] spawn {
    params ["_p","_oldC","_oldItems","_chuteC"];

    // wait until on-foot and chute is gone (or dead)
    waitUntil {
        sleep 0.25;
        isNull objectParent _p && (!alive _p || {backpack _p != _chuteC})
    };

    uiSleep 0.5; // let engine tidy up chute

    if (!alive _p) exitWith {};

    if (!isNil "_oldC" && {_oldC != ""}) then {
        removeBackpackGlobal _p;
        _p addBackpack _oldC;
        { _p addItemToBackpack _x; } forEach _oldItems;
    } else {
        if (backpack _p == _chuteC) then { removeBackpackGlobal _p; };
    };
};

// (Optional) audit log
diag_log format ["[ParachuteEject] %1 used %2 from %3", name _ply, _foundClass, typeOf _veh];
