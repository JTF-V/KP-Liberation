params ["_unit", "_killer", "_instigator"];

if(isPlayer _killer) then { name _killer } else { if(isPlayer _instigator) then { format ["%1 (UAV)", (name _instigator)] } else { name _killer } };