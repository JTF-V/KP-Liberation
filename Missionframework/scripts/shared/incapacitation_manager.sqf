params ["_unit", "_anim"];

// if (isServer) exitWith {};

[10, [(name _unit)]] remoteExec ["KPLIB_fnc_crGlobalMsg"];

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
hintSilent "";