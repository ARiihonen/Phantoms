_box = _this select 0;

_box setVariable ["tracked", true, true];
["TrackerPlaced",[]] call BIS_fnc_showNotification;

[_box, "logic\boxTracked.sqf"] remoteExec ["BIS_fnc_execVM", east];