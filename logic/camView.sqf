// Apply post-process effects
private ["_ppColor"];
_ppColor = ppEffectCreate ["colorCorrections", 1999];
_ppColor ppEffectEnable true;
_ppColor ppEffectAdjust [1, 1, 0, [1, 1, 1, 0], [0.8, 0.8, 0.8, 0.65], [1, 1, 1, 1.0]];
_ppColor ppEffectCommit 0;

//set view effects
showCinemaBorder false;
true setCamUseTI 0;

fakeUAV cameraEffect ["internal", "BACK"];
cameraEffectEnableHud true;

//set player variable
player setVariable ["uav", true, false];

//disable serialization and add keydown event handler for exiting from the camera
disableSerialization;
private ["_skipEH"];
_skipEH = (findDisplay 46) displayAddEventHandler [
	"KeyDown",
	format [
		"
			if (_this select 1 == 57) then {
				([] call BIS_fnc_displayMission) displayRemoveEventHandler ['KeyDown', uiNamespace getVariable 'skipEH'];

				playSound ['click', true];

				activateKey '%1';
				player setVariable ['uav', false, false];
			};
		"
	]
];
uiNamespace setVariable ["skipEH", _skipEH];

//create HUD markers
[
	"uav_display", 
	"onEachFrame", 
	"
		{
			if (_x getVariable ['tracked', false]) then {
				_icon = '\A3\ui_f\data\map\markers\military\objective_CA.paa';
				_pos = visiblePosition _x;
				_colour = [0, 1, 0, 0.5];
				_text = 'ONLINE';
				
				if (!alive _x) then {
					_colour = [1, 0, 0, 0.5];
					_text = 'CONTACT LOST';
				};

				drawIcon3D [_icon, _colour , _pos , 0.5, 0.5, 0, _text, 0, 0.025, 'TahomaB'];
			};
		} forEach boxes;
	"
] call BIS_fnc_addStackedEventHandler;

// Display instructions
disableSerialization;

private ["_layerTitlecard"];
_layerTitlecard = "BIS_layerTitlecard" call BIS_fnc_rscLayer;
_layerTitlecard cutRsc ["RscDynamicText", "PLAIN"];

private ["_dispText", "_ctrlText"];
_dispText = uiNamespace getVariable "BIS_dynamicText";
_ctrlText = _dispText displayCtrl 9999;

_ctrlText ctrlSetPosition [
	0 * safeZoneW + safeZoneX,
	0.8 * safeZoneH + safeZoneY,
	safeZoneW,
	safeZoneH
];

// Determine appropriate key highlight colour
private ["_keyColor"];
_keyColor = format [
	"<t color = '%1'>",
	(["GUI", "BCG_RGB"] call BIS_fnc_displayColorGet) call BIS_fnc_colorRGBtoHTML
];

private ["_skipText"];
_skipText = format ["<t size = '0.75'> Press %1 [SPACE] </t> to close</t>", _keyColor];

_ctrlText ctrlSetStructuredText parseText _skipText;
_ctrlText ctrlSetFade 1;
_ctrlText ctrlCommit 0;

_ctrlText ctrlSetFade 0;
_ctrlText ctrlCommit 1;

// Wait for player to skip out
waitUntil{!(player getVariable "uav") || !alive player};

// remove HUD, postprocess effects, terminate camera
_ctrlText ctrlSetFade 1;
_ctrlText ctrlCommit 0;

["uav_display", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
ppEffectDestroy _ppColor;
fakeUAV cameraEffect ["TERMINATE", "BACK"];