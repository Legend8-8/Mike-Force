/*
    File: fn_action_parachute_eject.sqf
    Author: Legend + ChatGPT
    Public: No

    Description:
        Adds a gated player addAction that requests a server-side parachute + eject.
        The action only shows when:
          - player is alive,
          - in an aircraft,
          - not in pilot seat (seat index 0),
          - altitude >= ~60m ASL,
          - aircraft speed <= ~120 km/h (UX guard only; server re-validates).

    Example(s):
        call vn_mf_fnc_action_parachute_eject;
*/

if (!hasInterface) exitWith {};

if (!isNil "vn_mf_parachute_eject_action") then {
    player removeAction vn_mf_parachute_eject_action;
    vn_mf_parachute_eject_action = nil;
};

// Condition string executes locally every frame; keep it cheap.
private _conditionToShow =
"
    call {
        private _p = player;
        if (isNull _p || {!alive _p}) exitWith {false};

        private _v = vehicle _p;
        if (_v isEqualTo _p) exitWith {false};
        if (!(_v isKindOf 'Air')) exitWith {false};

        // block pilot seat (index 0 on most airframes)
        private _idx = _v crewIndex _p;
        if (_idx isEqualTo 0) exitWith {false};

        // lightweight safety guards (UX only; server re-checks)
        private _altASL = (getPosASL _p) select 2;
        private _speedMS = speed _v;                  // m/s
        private _speedOk = _speedMS <= (120 / 3.6);   // <=120 km/h
        (_altASL >= 60) && _speedOk
    }
";

vn_mf_parachute_eject_action = player addAction
[
    "<t color='#ffe600ff'>Eject with Parachute</t>",
    {
        // on activation (client)
        private _p = player;
        private _v = vehicle _p;

        if (isNull _v || {_v isEqualTo _p} || {!(_v isKindOf 'Air')}) exitWith {
            hint "Not in an aircraft.";
        };

        // Ask server to perform the authoritative operation.
        // Server function lives in the same actions system.
        [_p, _v] remoteExec ["vn_mf_fnc_eject_and_parachute", 2];
    },
    nil,
    1,      // priority
    true,   // showWindow
    true,   // hideOnUse
    "",     // shortcut
    _conditionToShow,
    3       // radius
];

// Re-create on respawn to survive player lifecycle
player addEventHandler ["Respawn", {
    if (!isNil "vn_mf_parachute_eject_action") then {
        player removeAction vn_mf_parachute_eject_action;
        vn_mf_parachute_eject_action = nil;
    };
    [] spawn {
        uiSleep 0.25;
        call vn_mf_fnc_action_parachute_eject;
    };
}];
