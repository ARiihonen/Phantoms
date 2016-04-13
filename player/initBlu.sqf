//Mark all boxes
{
	_markerName = format["%1_marker", _x];
	_marker = createMarkerLocal [_markerName, getPos _x];
	_marker setMarkerShapeLocal "ICON";
	_marker setMarkerTypeLocal "mil_dot";
	_marker setMarkerColorLocal "colorRed";
	
	_x setVariable ["Marker", _marker, false];
} forEach boxes;

player addEventHandler ["Hit", "_this execVM 'logic\bluforHit.sqf';"];
player addEventHandler ["Killed", "_this execVM 'logic\bluforKilled.sqf';"];

//Briefing
_brief = [] execVM "briefing\briefingBlu.sqf";

//Gear
_gear = [] execVM "player\gear.sqf";