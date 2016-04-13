_killer = _this select 1;

if (_killer == player && !isNull (player getVariable "last_hit") then {
	_killer = player getVariable "last_hit";
};

if (side (group _killer) == east) then {
	_murders = missionNamespace getVariable ["murdered_defenders", 0];
	_murders = _murders + 1;
	missionNamespace setVariable ["murdered_defenders", _murders, true];
};