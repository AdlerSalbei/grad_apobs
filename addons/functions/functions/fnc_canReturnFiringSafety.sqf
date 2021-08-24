#include "script_component.hpp"
/*
 * Author: Salbei
 * Check if the safety pin can be returned.
 *
 * Arguments:
 * 0: Target <OBJECT>
 *
 * Return Value:
 * Can return <BOOLEAN>
 *
 * Example:
 * [obj] call grad_apobs_functions_fnc_canReturnFiringSafety
 *
 * Public: No
 */

params ["_target"];

if (_target getVariable [QGVAR(isClosed), true]) exitWith { false };
if (isNull (_target getVariable [QGVAR(rocket), objNull])) exitWith { false };
if !(_target getVariable [QGVAR(firingSaftyPulled), false]) exitWith { false };
if (_target getVariable [QGVAR(firingPinPulled), false]) exitWith { false };

true
