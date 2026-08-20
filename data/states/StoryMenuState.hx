var variation:String = null;

var diffData:Map<String, {variation:String, hasRecharts:Bool}> = [
	'gay' => {variation: 'gay', hasRecharts: false},
	'easy' => {variation: null, hasRecharts: true}
];

importScript('data/scripts/HandyDandy');

function onWeekSelect(event) {
	event.cancel();
	canSelect = false;

	CoolUtil.playMenuSFX(1);
	if (characterSprites != null)
		characterSprites.forEachAlive(function(spr) {
			spr.playAnim('confirm', true, "LOCK");
		});

	var difficultyCuh:String = weeks[curWeek].difficulties[curDifficulty].toLowerCase();
	variation = (diffData[difficultyCuh].variation != null ? diffData[difficultyCuh].variation : null);

	new FlxTimer().start(1, function(tmr:FlxTimer) {
		var songsLol:Array<String> = [];
		for (song in weeks[curWeek].songs)
			songsLol.push(song.name.toLowerCase());
		HandyDandy.loadWeek(songsLol, weeks[curWeek].name.toLowerCase, weeks[curWeek].id.toLowerCase(), weeks[curWeek].difficulties[curDifficulty], variation);
	});
	weekSprites.members[event.weekID].startFlashing();
}
/**
 * todo: add rechart box
 */
