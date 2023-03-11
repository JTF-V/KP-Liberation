private ['_noObjectParent','_cursorDistance','_QS_player''_QS_helmetCam_helperType','_cursorTarget','_false','_true',];
disableSerialization;
_cursorTarget = cursorTarget;
_QS_player = player;
_QS_helmetCam_helperType = 'sign_sphere10cm_f';
_QS_interaction_drag = FALSE;
_QS_action_drag = nil;
_QS_action_drag_text = localize 'STR_QS_Interact_001';
_QS_action_drag_array = [_QS_action_drag_text,{_this spawn (missionNamespace getVariable 'QS_fnc_clientInteractDrag')},[],-9,TRUE,TRUE,'','TRUE',-1,FALSE,''];
_QS_interaction_carry = FALSE;
_QS_action_carry = nil;
_QS_action_carry_text = localize 'STR_QS_Interact_002';
_QS_action_carry_array = [_QS_action_carry_text,{_this spawn (missionNamespace getVariable 'QS_fnc_clientInteractCarry')},[],-10,TRUE,TRUE,'','TRUE',-1,FALSE,''];
_QS_interaction_release = FALSE;
_QS_action_release = nil;
_QS_action_release_text = localize 'STR_QS_Interact_010';
_QS_action_release_array = [_QS_action_release_text,{_this spawn (missionNamespace getVariable 'QS_fnc_clientInteractRelease')},[],88,FALSE,TRUE,'','TRUE',-1,FALSE,''];
_false = FALSE;
_true = TRUE;
_objNull = objNull;
_noObjectParent = TRUE;
/*/=========================== Action manager module/*/
{
	player setVariable _x;
} forEach [
	['QS_RD_interacting',FALSE,TRUE]
];

/*/===== Action Manager/*/
	
	if (alive _QS_player) then {
		if (_lifeState in ['HEALTHY','INJURED']) then {
			_cursorTarget = cursorTarget;
			_cursorDistance = _QS_player distance _cursorTarget;
			getCursorObjectParams params ['_cursorObject','_cursorObjectNamedSel','_cursorObjectDistance'];
			if (isNull _cursorObject) then {
				_cursorObject = cursorObject;
			};
			if (
				(!isNull _cursorObject) &&
				{(_cursorObject isKindOf 'CAManBase')} &&
				{(_cursorObjectDistance < 15)} &&
				{((_QS_player knowsAbout _cursorObject) < 1)}
			) then {
				_QS_player reveal [_cursorObject,4];
			};
			_noObjectParent = isNull _objectParent;
			if (_timeNow > _QS_nearEntities_revealCheckDelay) then {
				if (_noObjectParent) then {
					{
						if ((simulationEnabled _x) && {((_QS_player knowsAbout _x) < 1)}) then {
							_QS_player reveal [_x,3.9];
						};
					} count (((_posATLPlayer select [0,2]) nearEntities [_QS_entityTypes,_QS_entityRange]) + (_posATLPlayer nearObjects [_QS_objectTypes,_QS_objectRange]));
					{
						if (
							(!isNull (_x # 0)) &&
							{((_x # 1) < 5)} &&
							{(simulationEnabled (_x # 0))} &&
							{((_QS_player knowsAbout (_x # 0)) < 1)}
						) then {
							_QS_player reveal [(_x # 0),3.9];
						};
					} count [
						[_cursorTarget,_cursorDistance],
						[_cursorObject,_cursorObjectDistance]
					];
				};
				_QS_nearEntities_revealCheckDelay = _timeNow + _QS_nearEntities_revealDelay;
			};
			

			/*/===== Action Drag/*/
			
			if (
				(_noObjectParent) &&
				{(_cursorDistance < 1.9)} &&
				{(((attachedObjects _QS_player) findIf {((!isNull _x) && (!(_x isKindOf 'Sign_Sphere10cm_F')))}) isEqualTo -1)} &&
				{(alive _cursorTarget)} &&
				{(isNull (attachedTo _cursorTarget))} &&
				{(isNull (ropeAttachedTo _cursorTarget))}
			) then {
				if (_cursorTarget isKindOf 'Man') then {
					if (((lifeState _cursorTarget) isEqualTo 'INCAPACITATED') && {((isNull (attachedTo _cursorTarget)) && (isNull (objectParent _cursorTarget)))}) then {
						if (!(_QS_interaction_drag)) then {
							_QS_interaction_drag = _true;
							_QS_action_drag = player addAction _QS_action_drag_array;
							player setUserActionText [_QS_action_drag,((player actionParams _QS_action_drag) # 0),(format ["<t size='3'>%1</t>",((player actionParams _QS_action_drag) # 0)])];
						};
					} else {
						if (_QS_interaction_drag) then {
							_QS_interaction_drag = _false;
							player removeAction _QS_action_drag;
						};
					};
				} else {
					if (([0,_cursorTarget,_objNull] call _fn_getCustomCargoParams) || {(_cursorTarget getVariable ['QS_RD_draggable',_false])}) then {
						if (!(_QS_interaction_drag)) then {
							_QS_interaction_drag = _true;
							_QS_action_drag = player addAction _QS_action_drag_array;
							player setUserActionText [_QS_action_drag,((player actionParams _QS_action_drag) # 0),(format ["<t size='3'>%1</t>",((player actionParams _QS_action_drag) # 0)])];
						};
					} else {
						if (_QS_interaction_drag) then {
							_QS_interaction_drag = _false;
							player removeAction _QS_action_drag;
						};
					};
				};
			} else {
				if (_QS_interaction_drag) then {
					_QS_interaction_drag = _false;
					player removeAction _QS_action_drag;
				};
			};

			/*/===== Action Carry/*/
			
			if (
				(_noObjectParent) &&
				{(_cursorDistance < 1.9)} &&
				{(((attachedObjects _QS_player) findIf {((!isNull _x) && (!(_x isKindOf 'Sign_Sphere10cm_F')))}) isEqualTo -1)} &&
				{(isNull (attachedTo _cursorTarget))} &&
				{(isNull (objectParent _cursorTarget))}
			) then {
				if (_cursorTarget isKindOf 'CAManBase') then {
					if ((alive _cursorTarget) && {((lifeState _cursorTarget) isEqualTo 'INCAPACITATED')}) then {
						if (!(_QS_interaction_carry)) then {
							_QS_interaction_carry = _true;
							_QS_action_carry = player addAction _QS_action_carry_array;
							player setUserActionText [_QS_action_carry,((player actionParams _QS_action_carry) # 0),(format ["<t size='3'>%1</t>",((player actionParams _QS_action_carry) # 0)])];
						};
					} else {
						if (_QS_interaction_carry) then {
							_QS_interaction_carry = _false;
							player removeAction _QS_action_carry;
						};
					};
				} else {
					if (([0,_cursorTarget,_objNull] call _fn_getCustomCargoParams) && {([4,_cursorTarget,_QS_v2] call _fn_getCustomCargoParams)}) then {
						if (!(_QS_interaction_carry)) then {
							_QS_interaction_carry = _true;
							_QS_action_carry = player addAction _QS_action_carry_array;
							player setUserActionText [_QS_action_carry,((player actionParams _QS_action_carry) # 0),(format ["<t size='3'>%1</t>",((player actionParams _QS_action_carry) # 0)])];
						};
					} else {
						if (_QS_interaction_carry) then {
							_QS_interaction_carry = _false;
							player removeAction _QS_action_carry;
						};							
					};
				};
			} else {
				if (_QS_interaction_carry) then {
					_QS_interaction_carry = _false;
					player removeAction _QS_action_carry;
				};
			};
		};
			
			/*/===== Action Release/*/

			if (((attachedObjects _QS_player) findIf {((!isNull _x) && ((_x isKindOf 'Man') || {([0,_x,_objNull] call _fn_getCustomCargoParams)} || {(_x isKindOf 'StaticWeapon')}))}) isNotEqualTo -1) then {
				{
					if ((_x isKindOf 'Man') || {([0,_x,_objNull] call _fn_getCustomCargoParams)} || {(_x isKindOf 'StaticWeapon')}) then {
						if (!(_QS_interaction_release)) then {
							_QS_interaction_release = _true;
							_QS_action_release = player addAction _QS_action_release_array;
							player setUserActionText [_QS_action_release,((player actionParams _QS_action_release) # 0),(format ["<t size='3'>%1</t>",((player actionParams _QS_action_release) # 0)])];
						};
						if (_x getVariable ['QS_RD_escorted',_false]) then {
							if (!(_QS_interaction_release)) then {
								_QS_interaction_release = _true;
								_QS_action_release = player addAction _QS_action_release_array;
								player setUserActionText [_QS_action_release,((player actionParams _QS_action_release) # 0),(format ["<t size='3'>%1</t>",((player actionParams _QS_action_release) # 0)])];
							};
						};
					};
				} count (attachedObjects _QS_player);
			} else {
				if (_QS_interaction_release) then {
					_QS_interaction_release = _false;
					player removeAction _QS_action_release;
					if (!isNil {_QS_player getVariable 'QS_RD_interacting'}) then {
						if (_QS_player getVariable 'QS_RD_interacting') then {
							_QS_player setVariable ['QS_RD_interacting',_false,_true];
						};
					};
					if (!isNil {_QS_player getVariable 'QS_RD_dragging'}) then {
						if (_QS_player getVariable 'QS_RD_dragging') then {
							_QS_player setVariable ['QS_RD_dragging',_false,_true];
							_QS_player playAction 'released';
						};
					};
					if (!isNil {_QS_player getVariable 'QS_RD_carrying'}) then {
						if (_QS_player getVariable 'QS_RD_carrying') then {
							_QS_player setVariable ['QS_RD_carrying',_false,_true];
							_QS_player playMoveNow 'AidlPknlMstpSrasWrflDnon_AI';
						};
					};
				};
			};
	} else {
		if (!isNil {_QS_player getVariable 'QS_RD_interacting'}) then {
			if (_QS_player getVariable 'QS_RD_interacting') then {
				_QS_player setVariable ['QS_RD_interacting',_false,_true];
			};
		};
		if (!isNil {_QS_player getVariable 'QS_RD_carrying'}) then {
			if (_QS_player getVariable 'QS_RD_carrying') then {
				_QS_player setVariable ['QS_RD_carrying',_false,_true];
			};
		};
		if (!isNil {_QS_player getVariable 'QS_RD_dragging'}) then {
			if (_QS_player getVariable 'QS_RD_dragging') then {
				_QS_player setVariable ['QS_RD_dragging',_false,_true];
			};
		};
	};

/*/===== Functions Preload/*/
_fn_getCustomCargoParams = missionNamespace getVariable 'QS_fnc_getCustomCargoParams';