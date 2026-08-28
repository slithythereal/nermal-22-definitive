importScript('data/scripts/HandyDandy');
var variation:String = null;
var rechartCheckbox:FunkinSprite;
var rechartISCHECKED:Bool = false;
var rechartUncheckedAlpha:Float = 0.5;
var rechartText:FlxText;

function postCreate() {
	FlxG.mouse.visible = true;
	rechartCheckbox = new FunkinSprite(1150, 600);
	rechartCheckbox.frames = Paths.getSparrowAtlas('menus/options/checkboxThingie');
	rechartCheckbox.addAnim('selected', 'Check Box Selected Static0', 1);
	rechartCheckbox.addAnim('selecting', 'Check Box selecting animation0', 24, false);
	rechartCheckbox.addAnim('unselecting', 'Check Box deselect animation0', 24, false);
	rechartCheckbox.addAnim('unselected', 'Check Box unselected0', 1);
	rechartCheckbox.addOffset('selected', 23, 38);
	rechartCheckbox.addOffset('selecting', 35, 99);
	rechartCheckbox.addOffset('unselecting', 25, 58);
	rechartCheckbox.playAnim('unselected');
	rechartCheckbox.scale.set(0.55, 0.5);
	rechartCheckbox.updateHitbox();
	rechartCheckbox.scale.set(1, 1);
	rechartCheckbox.offset.set(7.5, 7.5);
	add(rechartCheckbox);

	rechartText = new FlxText(735, 620, 0, "PLAY RECHARTS: ");
	rechartText.setFormat(Paths.font('vcr.ttf'), 50, FlxColor.WHITE, "RIGHT");
	add(rechartText);
}

function postUpdate(elapsed:Float) {
	if (FlxG.mouse.overlaps(rechartCheckbox) && FlxG.mouse.justPressed && canSelect && rechartCheckbox.visible) {
		rechartISCHECKED = !rechartISCHECKED;
		rechartCheckbox.playAnim((rechartISCHECKED ? 'selecting' : 'unselecting'));
		rechartCheckbox.animation.finishCallback = function() {
			rechartCheckbox.playAnim((rechartISCHECKED ? 'selected' : 'unselected'));
		}
		FlxG.sound.play(Paths.sound('editors/checkbox' + (rechartISCHECKED ? 'Checked' : 'Unchecked')));
	}
}

function onChangeDifficulty(event) {
	var eventdiff = event.value;
	var difficultyCuh:String = weeks[curWeek].difficulties[eventdiff].toLowerCase();
	var localHasRecharts:Bool = diffData[difficultyCuh].hasRecharts;
	rechartCheckbox.visible = rechartText.visible = localHasRecharts;
	if (rechartISCHECKED && !localHasRecharts) {
		rechartCheckbox.playAnim('unselecting');
		rechartISCHECKED = false;
		rechartCheckbox.animation.finishCallback = function() {
			rechartCheckbox.playAnim('unselected');
		}
	}
}

function onWeekSelect(event) {
	var eventdiff:String = event.difficulty; // fix for week select
	event.cancel();
	canSelect = false;

	CoolUtil.playMenuSFX(1);
	if (characterSprites != null)
		characterSprites.forEachAlive(function(spr) {
			spr.playAnim('confirm', true, "LOCK");
		});

	var difficultyCuh:String = eventdiff.toLowerCase();
	variation = (diffData[difficultyCuh].variation != null ? diffData[difficultyCuh].variation : null);

	var rechart:String = (rechartISCHECKED ? "-rechart" : "");
	if (!diffData[difficultyCuh].hasRecharts)
		rechart = '';

	new FlxTimer().start(1, function(tmr:FlxTimer) {
		var songsLol:Array<String> = [];
		for (song in weeks[curWeek].songs)
			songsLol.push(song.name.toLowerCase());
		HandyDandy.loadWeek(songsLol, weeks[curWeek].name.toLowerCase, weeks[curWeek].id.toLowerCase(), difficultyCuh + rechart, variation);
	});
	weekSprites.members[event.weekID].startFlashing();
}
