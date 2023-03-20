params ["_unit", "_anim"];

if (isServer) exitWith {};

[10, [(name _unit)]] remoteExec ["KPLIB_fnc_crGlobalMsg"];

// We should add the bleedout timer here