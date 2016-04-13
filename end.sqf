_ending = _this;

//Separate ending conditions:

/*Different endings are set up in Description.ext in the cfgDebriefing class, 
syntax for BIS_fnc_endMission is ["endingName", isVictory, fancyVisuals], 
where endingName is the ending's class name, 
isVictory a boolean value denoting if the ending was a victory or not, 
and fancyVisuals a boolean that says whether to go straight to the 
debriefing or to use the cool new ingame ending graphic*/

if (alive player) then {

	switch (side player) do {
		case west: { [_ending select 0, true, true] call BIS_fnc_endMission; };
		case east: { [_ending select 1, true, true] call BIS_fnc_endMission; };
	};

} else {
	["Dead", false, true] call BIS_fnc_endMission;
};