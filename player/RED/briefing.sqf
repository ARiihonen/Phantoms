player createDiarySubject ["Diary", "Diary"];

player createDiaryRecord ["Diary", ["Avoiding the search", format [LoadFile "player\RED\BRIEF\Mechanics.txt", suspShot*100, suspKill*100, suspDestroy*100]]];

_uavText = "";
if (paramsArray select 0 != 0) then {
	_uavText = "<br /> <br />You have a surveillance UAV on station above the site. You will be able to access the UAV feed via your action menu, and close it by pressing space bar."
};

player createDiaryRecord ["Diary", ["Intel", format [LoadFile "BRIEF\Intel.txt", trucksStart/60, _uavText]]];
player createDiaryRecord ["Diary", ["Mission", format [LoadFile "BRIEF\Mission.txt", (count boxes)/2]]];
player createDiaryRecord ["Diary", ["Situation", LoadFile "BRIEF\Situation.txt"]];