/*
 * Author: PabstMirror
 * Handlese firing the 40mm pike grenade/rocket
 *
 * Arguments:
 * FiredEH
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [] call ace_pike_fnc_handleFired
 *
 * Public: No
 */
#include "script_component.hpp"

//IGNORE_PRIVATE_WARNING ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
TRACE_7("firedEH:",_unit, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile);
if (_ammo != QGVAR(ammo_gl)) exitWith {};

[{
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
    TRACE_7("rocket stage",_unit, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile);

    //If null (deleted or hit water) exit:
    if (isNull _projectile) exitWith {TRACE_};

    private _posASL = getPosASL _projectile;
    private _vel = velocity _projectile;
    
    systemChat format ["gl %1 %2",_vel, round vectorMagnitude _vel];
    
    deleteVehicle _projectile;

    private _rocket = QGVAR(ammo_rocket) createVehicle (getPosATL _projectile);
    _rocket setPosASL _posASL;

    // Set correct velocity and direction
    [_rocket, _vel] call EFUNC(missileguidance,changeMissileDirection);

    // Start missile guidance
    [_unit, _weapon, _muzzle, _mode, QGVAR(ammo_rocket), _magazine, _rocket] call EFUNC(missileguidance,onFired);
    
    #ifdef DEBUG_MODE_FULL
    [{
        params ["_args", "_pfID"];
        _args params [["_rocket", objNull]];
        if (!alive _rocket) exitWith {[_pfID] call CBA_fnc_removePerFrameHandler;};
        drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\Cursors\selectover_ca.paa", [1,0,1,1], ASLtoAGL getPosASL _rocket, 0.75, 0.75, 0, "", 1, 0.025, "TahomaB"];
        hintSilent format ["%1\n%2",velocity _rocket, round vectorMagnitude velocity _rocket];
    }, 0, [_rocket]] call CBA_fnc_addPerFrameHandler;
    #endif
    
}, _this, 0.1] call CBA_fnc_waitAndExecute;
