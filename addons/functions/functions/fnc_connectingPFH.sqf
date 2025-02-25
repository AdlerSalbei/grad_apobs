#include "script_component.hpp"
/*
 * Author: Dystopian, Salbei
 * PFH while connector is in hands.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Connector <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, connector] call grad_apobs_functions_fnc_connectingPFH
 *
 * Public: No
 */

params ["_unit", "_connector"];

[{
    params ["_args", "_idPFH"];
    _args params ["_unit", "_connector"];

    if !(
        alive _unit
        && {"" isEqualTo currentWeapon _unit || {_unit call ace_common_fnc_isSwimming}}
        && {[_unit, objNull, ["notOnMap"]] call ace_common_fnc_canInteractWith}
        && {!("unconscious" isEqualTo toLower animationState _unit)}
        && {!(_unit getVariable ["ACE_isUnconscious", false])}
    ) exitWith {
        [_unit, _connector] call FUNC(dropConnector);
        _unit setVariable [QGVAR(selectedWeaponOnRefuel), nil];
        _unit setVariable [QGVAR(hint), nil];
        call ace_interaction_fnc_hideMouseHint;
        [_unit, "forceWalk", "Grad_APOBS_connecting", false] call ace_common_fnc_statusEffect_set;
        [_unit, "blockThrow", "Grad_APOBS_connecting", false] call ace_common_fnc_statusEffect_set;
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    // check drop from external events
    if (isNull (_unit getVariable [QGVAR(connector), objNull])) exitWith {
        _unit selectWeapon (_unit getVariable QGVAR(selectedWeaponOnConnecting));
        _unit setVariable [QGVAR(selectedWeaponOnConnecting), nil];
        _unit setVariable [QGVAR(hint), nil];
        call ace_interaction_fnc_hideMouseHint;
        [_unit, "forceWalk", "Grad_APOBS_connecting", false] call ace_common_fnc_statusEffect_set;
        [_unit, "blockThrow", "Grad_APOBS_connecting", false] call ace_common_fnc_statusEffect_set;
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _source = _connector getVariable [QGVAR(source), objNull];
    if !(alive _source) exitWith {
        [_unit, _connector] call FUNC(dropConnector);
        private _rope = _connector getVariable [QGVAR(rope), objNull];
        if !(isNull _rope) then {
            ropeDestroy _rope;
        };
        deleteVehicle _connector;
        _unit selectWeapon (_unit getVariable QGVAR(selectedWeaponOnConnecting));
        _unit setVariable [QGVAR(selectedWeaponOnConnecting), nil];
        _unit setVariable [QGVAR(hint), nil];
        call ace_interaction_fnc_hideMouseHint;
        [_unit, "forceWalk", "Grad_APOBS_connecting", false] call ace_common_fnc_statusEffect_set;
        [_unit, "blockThrow", "Grad_APOBS_connecting", false] call ace_common_fnc_statusEffect_set;
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if !(_unit == vehicle _unit && {_unit isEqualTo ACE_player}) exitWith {
        [_unit, _connector] call FUNC(dropConnector);
        _unit selectWeapon (_unit getVariable QGVAR(selectedWeaponOnConnecting));
        _unit setVariable [QGVAR(selectedWeaponOnConnecting), nil];
        _unit setVariable [QGVAR(hint), nil];
        call ace_interaction_fnc_hideMouseHint;
        [_unit, "forceWalk", "Grad_APOBS_connecting", false] call ace_common_fnc_statusEffect_set;
        [_unit, "blockThrow", "Grad_APOBS_connecting", false] call ace_common_fnc_statusEffect_set;
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    // check hoseLength < distance
    if (((_source getVariable [QGVAR(hoseLength), GVAR(hoseLength)]) - 2) < _unit distance (_source modelToWorld (_connector getVariable QGVAR(attachPos)))) exitWith {
        [_unit, _connector] call FUNC(dropConnector);
        _unit selectWeapon (_unit getVariable QGVAR(selectedWeaponOnConnecting));
        _unit setVariable [QGVAR(selectedWeaponOnConnecting), nil];
        _unit setVariable [QGVAR(hint), nil];
        call ace_interaction_fnc_hideMouseHint;
        [_unit, "forceWalk", "Grad_APOBS_connecting", false] call ace_common_fnc_statusEffect_set;
        [_unit, "blockThrow", "Grad_APOBS_connecting", false] call ace_common_fnc_statusEffect_set;
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        [LSTRING(Hint_TooFar), 2, _unit] call ace_common_fnc_displayTextStructured;
    };

    private _hintLMB = "";
    private _hintRMB = localize LSTRING(drop);

    getCursorObjectParams params ["_cursorObject", "", "_distance"];
    if (!isNull _cursorObject && {_distance < 2}) then {
        if (
            (isNumber (configFile >> "CfgVehicles" >> (typeOf _cursorObject) >> QGVAR(canReceive)))
            && {isNull (_cursorObject getVariable [QGVAR(connector), objNull])}
        ) then {
            _hintLMB = localize LSTRING(Connect);
        };
        if ([_unit, _cursorObject] call FUNC(canReturnConnector)) then {
            _hintRMB = localize LSTRING(Return);
        };
    };

    private _hint = [_hintLMB, _hintRMB];
    if !(_hint isEqualTo (_unit getVariable [QGVAR(hint), []])) then {
        _unit setVariable [QGVAR(hint), _hint];
        _hint call ace_interaction_fnc_showMouseHint;
    };
}, 0, [_unit, _connector]] call cba_fnc_addPerFrameHandler;
