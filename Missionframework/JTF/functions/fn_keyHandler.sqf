/*
	JTF's Key Handler
	
    Author: Highlander - https// github.com/JTF-V/KP-Liberation
	Date: 12/03/2023 (dd/mm/yyyy)
	Last Update: 12/03/2023 (dd/mm/yyyy)
*/

params [
	"_ctrl",
	"_code",
	"_shift",
	"_ctrlKey",
	"_alt"
];

private _handled = false;
private _interruptionKeys = [17, 30, 31, 32]; //A,S,W,D

if (_code in _interruptionKeys) exitWith {};

private _allowedMoves = [
        "MoveForward",
        "MoveBack",
        "TurnLeft",
        "TurnRight",
        "MoveFastForward",
        "MoveSlowForward",
        "turbo",
        "TurboToggle",
        "MoveLeft",
        "MoveRight",
        "WalkRunTemp",
        "WalkRunToggle",
        "AdjustUp",
        "AdjustDown",
        "AdjustLeft",
        "AdjustRight",
        "Stand",
        "Crouch",
        "Prone",
        "MoveUp",
        "MoveDown",
        "LeanLeft",
        "LeanLeftToggle",
        "LeanRight",
        "LeanRightToggle"
    ];
    if (({_code in (actionKeys _x)} count _allowedMoves) > 0) exitwith {
        false;
    };

switch (_code) do {
	// Keycodes found here: https// community.bistudio.com/wiki/DIK_KeyCodes

	// 0 key
    // All credit goes to Bryan "Tonic" Boardwine for this script
    // Source: https://github.com/AsYetUntitled/Framework/blob/v5.X.X/Altis_Life.Altis/core/functions/fn_keyHandler.sqf
    // License: https://github.com/AsYetUntitled/Framework/blob/v5.X.X/LICENSE.md
	case 11: {
		if (_shift && !_ctrlKey && !(currentWeapon player isEqualTo "")) then {
			curWep_h = currentWeapon player;
			player action ["SwitchWeapon", player, player, 100];
			player switchCamera cameraView;
		};

		if (!_shift && _ctrlKey && !isNil "curWep_h" && {
			!(curWep_h isEqualTo "")
		}) then {
			if (curWep_h in [primaryWeapon player, secondaryWeapon player, handgunWeapon player]) then {
				player selectWeapon curWep_h;
			};
		};
	};

	// End Key
	case 207: {
		// Out
	    if (player getVariable ['JTF_state_earplugs_full',FALSE]) then {
		    player setVariable ['JTF_state_earplugs_full',FALSE,FALSE];
		    1 fadeSound 1;
			systemChat format [localize "STR_MISC_earplugsOut", 100];
	    }
		// In
        else {
			// Check if already half. If so, set full. Otherwise, set half
			if(player getVariable ['JTF_state_earplugs_half',FALSE]) then {
				player setVariable ['JTF_state_earplugs_half',FALSE,FALSE];
				player setVariable ['JTF_state_earplugs_full',TRUE,FALSE];

				1 fadeSound round jtf_desired_earplug_volume / 100;
            	systemChat format [localize "STR_MISC_earplugsIn", (round jtf_desired_earplug_volume)];
			}
			else {
				player setVariable ['JTF_state_earplugs_half',TRUE,FALSE];
		    	1 fadeSound round jtf_desired_earplug_volume / 50;
				systemChat format [localize "STR_MISC_earplugsInHalf", (round jtf_desired_earplug_volume * 2)];
			};
	    };
		_handled = true;
	};
};

_handled;