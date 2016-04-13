_source = _this select 1;

if (_source != player) then {
	player setVariable ["last_hit", _source];
};