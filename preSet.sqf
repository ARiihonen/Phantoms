/*
This script is defined as a pre-init function in description.ext, meaning it runs before the map initialises.
*/
#include "logic\preInit.sqf"
#include "logic\activeMods.sqf"

if (isServer) then {
	//Randomizing unit presence variables using caran_randInt and caran_presenceArray
	//_players_blue = playersNumber west;
	_players_blue = 6;

	_max_box = 0;
	switch ( ceil(_players_blue / 2)) do {
		case 1: { _max_box = 6; };
		case 2: { _max_box = 10; };
		case 3: { _max_box = 14; };
		case 4: { _max_box = 18; };
	};
	
	box_positions = [_max_box, _players_blue/2] call caran_presenceArray;
	boxes = [];
	
	_trucks_start = 10*60 + (_players_blue * 10 * 60);
	missionNamespace setVariable ["trucks_start", _trucks_start, true];
	
	//Define strings to search for in active addons
	_check_list = [
		"ace_common",
		"asr_ai3_main",
		"task_force_radio",
		"acre_"
	];
	
	//Check mod checklist against active addons
	_check_list call caran_initModList;
	
	if ( "asr_ai3_main" call caran_checkMod ) then {
		call compile preprocessfile "mods\asr.sqf";
	};
};