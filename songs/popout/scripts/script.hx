var playerStrumPos:Array<Float> = [300, 428, 732, 860];

function postCreate() {
    //garf.visible = true;
	stage.stageSprites['garf'].visible = true;
    dad.visible = false; // WHY DOES THIS WORK
	for (i => strumLine in strumLines.members) // ...ig...
		if (i == 0)
			for (i in 0...4)
				strumLine.members[i].x = playerStrumPos[i];
}

function update(elapsed:Float) {
	health = 2; // this was what was in the og script so yea u cant die in popout :man_shrugging:
}
