/*import funkin.backend.system.Flags;

	function postCreate() {
	if (PlayState.SONG.meta.customValues?.flipHealth == 'true')
		healthBar.flipX = iconP1.flipX = iconP2.flipX = true;
	}

	function postUpdate(elapsed:Float) {
	if (PlayState.SONG.meta.customValues?.flipHealth == 'true') {
		var iconOffset = Flags.ICON_OFFSET;
		var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBar.percent, 100, 0, 1, 0);

		iconP1.x = center - (iconP1.width - 26);
		iconP2.x = center - 26;
	}
	}
 */

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
