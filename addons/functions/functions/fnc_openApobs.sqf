#include "script_component.hpp"

params ["_target"];

private _targetClass = typeOf _target;
private _pos = getPos _target;
private _dir = getDir _target;
private _vectorDir = vectorDir _target;
private _vectorUp = vectorUp _target;

private _str = _targetClass splitString "_";
private _newClass = ("Grad_APOBS_" + (_str select 2)) + "_Open";

deleteVehicle _target;
private _newPack = _newClass createVehicle _pos;
_newPack setDir _dir;
_newPack setPos _pos;
_newPack setVectorDirAndUp [_vectorDir,_vectorUp];

_newPack animate ["open", 1];
[{_this animationPhase "open" == 1},{_this setVariable [QGVAR(isOpen), true, true];},_newPack] call CBA_fnc_waitUntilAndExecute;
