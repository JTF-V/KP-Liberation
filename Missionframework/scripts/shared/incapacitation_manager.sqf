/*
    Incapacitation Manager

    Author: Highlander - https://github.com/JTF-V/KP-Liberation
    Date: 23/03/2023 (dd/mm/yyyy)
    Last Update: 23/03/2023 (dd/mm/yyyy)
*/

params ["_unit", "_anim"];

if (isDedicated) exitWith {};

[10, [(name _unit)]] remoteExec ["KPLIB_fnc_crGlobalMsg"];

// Disables voice and chat for: Global, Side, Command, Group
for "_i" from 0 to 3 do { _i enableChannel false };

// All but the last line use the 'local' version, this is to reduce the number of messages sent over the network to each client
// See: https://community.bistudio.com/wiki/createMarker#:~:text=Multiplayer%20optimisation
_incapacitatedMarkerName = format ["_USER_DEFINED#%1", getPlayerUid _unit]; 
_incapacitatedMarker = createMarkerLocal [_incapacitatedMarkerName, getPos _unit];  
_incapacitatedMarker setMarkerColorLocal "ColorRed";  
_incapacitatedMarker setMarkerTypeLocal "loc_heal"; 
_incapacitatedMarker setMarkerText format["%1 (Incapacitated)", (name _unit)];

private _time = diag_tickTime -3;
while {lifeState _unit == "incapacitated"} do {
	// *** Set colours for bleedout ***
	_color = "#45f442"; //green
	if (diag_tickTime >= (_time + 480)) then {_color = "#eef441";}; //yellow
	if (diag_tickTime >= (_time + 540)) then {_color = "#ff0000";}; //red
	if (diag_tickTime >= (_time + 600)) exitWith { hintSilent parseText format ["<t color='%1'>--- Time is up! ---</t>",_color]; };

	private _timer = format ["Time Left:<br/><t color='%1'>--- %2 ---</t>", _color, [(bis_revive_bleedOutDuration - (diag_tickTime - _time))/60,"HH:MM:SS"] call BIS_fnc_timetostring];
	private _hint = parseText _timer;

	// *** Nearest allied player ***
	_friendlyPlayers = allPlayers select { !( _x isEqualTo player ) && { side group _x isEqualTo playerSide } && {alive _x} && {lifeState _x != "INCAPACITATED"} } apply {[_x distance player,_x]};
	_friendlyPlayers sort true;
	if !( _friendlyPlayers isEqualTo [] ) then {
		_friendlyPlayers select 0 params[ "_nearestFriendlyPlayerDistance", "_nearestFriendlyPlayer" ];
		_hint = parseText format["%1<br/><br/>The nearest friendly is <t color='#004D99'>%2</t> who is %3m away at a heading of %4°",
							_timer,
							name _nearestFriendlyPlayer,
							round _nearestFriendlyPlayerDistance,
							round (player getDir _nearestFriendlyPlayer)				
						];
	};

	hintSilent _hint;
};
uisleep 1;

// Enables voice and chat for: Global, Side, Command, Group
for "_i" from 0 to 3 do { _i enableChannel true };
hintSilent "";
deleteMarker _incapacitatedMarkerName;