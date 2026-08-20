var variation:String = null;

importScript('data/scripts/HandyDandy');
function onWeekSelect(event) {
	event.cancel();
	canSelect = false;

	CoolUtil.playMenuSFX(1);
	if (characterSprites != null)
		characterSprites.forEachAlive(function(spr) {
			spr.playAnim('confirm', true, "LOCK");
		});

	if (weeks[curWeek].difficulties[curDifficulty].toLowerCase() == 'gay')
		variation = 'gay';
	else
		variation = null;
	new FlxTimer().start(1, function(tmr:FlxTimer) {
		trace(weeks[curWeek].songs);
		var songsLol:Array<String> = [];
		for (song in weeks[curWeek].songs)
			songsLol.push(song.name.toLowerCase());
		HandyDandy.loadWeek(songsLol, weeks[curWeek].name.toLowerCase, weeks[curWeek].id.toLowerCase(), weeks[curWeek].difficulties[curDifficulty], variation);
	});
	weekSprites.members[event.weekID].startFlashing();
}
