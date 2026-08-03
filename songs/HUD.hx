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