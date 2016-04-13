waitUntil {!isNil "serverInit"};
waitUntil {serverInit};

//Starting position marker
_mark = createMarkerLocal ["start", getMarkerPos "redStart"];
_mark setMarkerShapeLocal "ICON";
_mark setMarkerTypeLocal "mil_start";
_mark setMarkerColorLocal "colorBlue";

//Mark boxes and add actions
{
	_markerName = format["%1_marker", _x];
	_marker = createMarkerLocal [_markerName, getPos _x];
	_marker setMarkerShapeLocal "ICON";
	_marker setMarkerTypeLocal "mil_dot";
	_marker setMarkerColorLocal "colorRed";
	
	_id = _x addAction ["<t color='#AADDAA'>Place tracker</t>", "_this execVM 'logic\trackerAction.sqf';", "", 6, false, true, "", "_this distance _target < 5"];
	
	_x setVariable ["marker", _marker, false];
	_x setVariable ["tracker_action", _id, false];
} forEach boxes;

//Exfil action
player addAction ["<t color='#05DD05'>Extract</t>", { missionNamespace setVariable ["redfor_exfil", true, true]; }, "", 0.5, false, true, "", "( { !(_x in insertion) && side _x == east } count playableUnits == 0 ) || ( !canMove insertion && { side _x == east && [trigger_area, getPos vehicle _x] call BIS_fnc_inTrigger } count playableUnits == 0 )" ];

//create camera
execVM "logic\camCreate.sqf";

//add UAV camera action
_cam_action = player addAction ["<t color='#AAAAEE'>View UAV camera</t>", "logic\camView.sqf", "", 0, false, true];

_uavHUD = [] spawn {
	["display", "onEachFrame", "CARAN_fnc_UAVDisplay"] call BIS_fnc_addStackedEventHandler;
};

//create redfor briefing
_brief = [] execVM "briefing\briefingRed.sqf";

//addd gear
_gear = [] execVM "player\gear.sqf";