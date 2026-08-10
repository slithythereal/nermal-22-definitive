public var camOther:FlxCamera;

function create() {
	camOther = new FlxCamera();
	camOther.bgColor = FlxColor.TRANSPARENT;
	FlxG.cameras.add(camOther, false);
}

function postCreate() {
	if (FlxG.save.data.middlescroll) {
		for (playerStrum in playerStrums)
			playerStrum.x = ((FlxG.width / 2) - (Note.swagWidth * 2)) + (Note.swagWidth * playerStrums.members.indexOf(playerStrum));
		for (i in 2...4)
			cpuStrums.members[i].x = 756 + i * 110;
		for (i in 0...2)
			cpuStrums.members[i].x = 80 + i * 110;
	}
}

function postUpdate() {
	if (FlxG.save.data.middlescroll) {
		for (i in strumLines.members[0])
			i.alpha = 0.5;
		for (i in strumLines.members[0].notes)
			i.alpha = 0.5;
	}
}
