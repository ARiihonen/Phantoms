/*
This runs on the server machine after objects have initialised in the map. Anything the server needs to set up before the mission is started is set up here.
*/

//broadcast boxes for everyone
publicvariable "boxes";

//Task setting: ["TaskName", locality, ["Description", "Title", "Marker"], target, "STATE", priority, showNotification, true] call BIS_fnc_setTask;
["ProtectTask", west, ["Protect the supply stashes in the area until relief comes in", "Guard Duty", ""], nil, "ASSIGNED", 2, false, true] call BIS_fnc_setTask;
["InfiltrateTask", east, ["Infiltrate the area and tag as many supply crates as you can without being noticed", "Infiltration", ""], nil, "ASSIGNED", 1, false, true] call BIS_fnc_setTask;
["ExfilTask", east, ["Escape the area without being captured or killed", "Exfiltration", ""], nil, "CREATED", 1, false, true] call BIS_fnc_setTask;

//add event handlers to detect killed defenders
{
	if (side _x == west && !isPlayer _x) then {
		_x addEventHandler ["Hit", "_this execVM 'logic\bluforHit.sqf';"];
		_x addEventHandler ["Killed", "_this execVM 'logic\bluforKilled.sqf';"];
	};
} forEach allUnits;

//end mission after calculating result
missionEnding = {
	/*
	_boxes_tagged = { alive _x && _x getVariable ["tracked", false] } count boxes;
	_boxes_destroyed = { !alive _x } count boxes;
	_boxes_compromised = _boxes_tagged + _boxes_destroyed;
	
	_dead_infiltrators = missionNamespace getVariable ["killed_infiltrators", 0];
	_dead_defenders = missionNamespace getVariable ["murdered_defenders", 0];
	
	_search = if (_boxes_destroyed < _dead_defenders) then { true; } else { false; };
	
	_score_blu = (_dead_infiltrators*50) - ( _boxes_compromised/(count boxes)*100 ) - ( _dead_defenders/( _dead_defenders + { side _x == west } count playableUnits ) * 100 );
	
	_score_red = ( _boxes_tagged/(count boxes)*100 ) - (_dead_infiltrators*50) - ( _dead_defenders/( _dead_defenders + { side _x == west } count playableUnits ) * 100 );
	if (!canMove insertion) then { _score_red = _score_red - 50; };
	
	{
		_points = rating _x;
		_x addRating (_points*-1);
	} forEach playableUnits;
	
	{
		switch (side group _x) do {
			case west: { _x addRating _score_red; };
			case east: { _x addRating _score_blu; };
		};
	} forEach allUnits;
	
	_end_blu = if (_boxes_compromised < (boxes/2)) then { "BlueVictory"; } else { "BlueLoss"; };
	if (_boxes_compromised == 0) then { _end_blu = "BlueVictoryAll"; };
	
	_end_red = if (!_search && _boxes_tagged > (boxes/2)) then { "RedVictory"; } else { if (_search) then { "RedLossSearch"; } else { "RedLossAmount" }; };
	if (_boxes_tagged == count boxes) then { _end_red = "RedVictoryTotal"; };
	
	if ( ["Victory", _end_blu] call BIS_fnc_inString ) then {
		["ProtectTask", "SUCCEEDED", false] call BIS_fnc_taskSetState;
	} else {
		["ProtectTask", "FAILED", false] call BIS_fnc_taskSetState;
	};
	
	if ( ["Victory", _end_red] call BIS_fnc_inString ) then {
		["InfiltrateTask", "SUCCEEDED", false] call BIS_fnc_taskSetState;
	} else {
		["InfiltrateTask", "FAILED", false] call BIS_fnc_taskSetState;
	};
	
	{
		if (alive _x) then {
			["ExfilTask", "SUCCEEDED", false] call BIS_fnc_taskSetState;
		} else {
			["ExfilTask", "FAILED", false] call BIS_fnc_taskSetState;
		};
	} forEach (allUnits select { side _x == east } );
	
	hint format ["Mission ending blu: %1, red: %2", _end_blu, _end_red];
	//[[_end_blu, _end_red],"end.sqf"] remoteExec ["BIS_fnc_execVM",0,false];
	*/
};

//End mission triggers

//End mission if either side is dead
trigger_dead = createTrigger ["EmptyDetector", [0,0,0], false];
trigger_dead setTriggerActivation ["NONE", "PRESENT", false];
trigger_dead setTriggerStatements [
	"{ side _x == west } count playableUnits == 0 || { side _x == east } count playableUnits == 0",
	"call missionEnding;",
	""
];

//End mission if redfor exfiltrate
trigger_exfil = createTrigger ["EmptyDetector", [0,0,0], false];
trigger_exfil setTriggerActivation ["NONE", "PRESENT", false];
trigger_exfil setTriggerStatements [
	"missionNamespace getVariable ['redfor_exfil', false]",
	"call missionEnding;",
	""
];
		
//client inits wait for serverInit to be true before starting, to make sure all variables the server sets up are set up before clients try to refer to them (which would cause errors)
serverInit = true;
publicVariable "serverInit";