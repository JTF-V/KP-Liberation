params ["_unit", "_killer", "_instigator"];

if (isPlayer _killer || (("uav" in toLowerAnsi typeOf _killer || "ugv" in toLowerAnsi typeOf _killer) && isPlayer _instigator)) then {
	true
} 
else {
	false;
};