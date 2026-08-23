importScript('data/scripts/HandyDandy');
import funkin.backend.utils.FunkinParentDisabler;

var parentDisabler:FunkinParentDisabler;
var song:String;
var sprGrp:FlxTypedGroup<FlxSprite>;

var warnMap = [
	'nermal' => function() {
		var notePic:FlxSprite = makeImage(850, 200, 2, 'nermnoteWarningImage');
		sprGrp.add(notePic);
		var text:FlxSprite = makeImage(0, 0, 1.3, 'nermnoteWarningText');
		sprGrp.add(text);
		if (PlayState.difficulty == 'gay') {
			var gayWarn:FlxSprite = makeImage(150, 600, 0.7, 'gayModeWarning');
			sprGrp.add(gayWarn);
		}
	},
	'abuse' => function() {
		var notePic1:FlxSprite = makeImage(550, 400, 2, 'nermnoteWarningImage');
		notePic1.scale.set(1.2, 1.2);
		sprGrp.add(notePic1);
		var notePic:FlxSprite = makeImage(1000, 400, 2, 'garfnoteWarningImage');
		notePic.scale.set(1.2, 1.2);
		sprGrp.add(notePic);
		var text:FlxSprite = makeImage(0, 0, 1.3, 'abuseWarningText');
		sprGrp.add(text);
		var arrow:FlxSprite = makeImage(825, 475, 0.5, 'clickbaitarrow');
		sprGrp.add(arrow);
		var scary:FlxSprite = makeImage(850, 100, 2, 'jumpscareNoteWarning');
		sprGrp.add(scary);
	}
];

function postCreate() {
	if (this.data.song != null)
		song = this.data.song.toLowerCase();
	sprGrp = new FlxTypedGroup<FlxSprite>();
	add(sprGrp);

	if(!FlxG.save.data.warningScreenNN22)
		endWarn();

	var black:FlxSprite = new FlxSprite(-100, 0);
	black.makeGraphic(1500, 1500, FlxColor.BLACK);
	sprGrp.add(black);
	black.alpha = 0.8;

	warnMap[song]();
}

function postUpdate(elapsed:Float) {
	if (controls.ACCEPT) {
		endWarn();
	}
}

function endWarn() {
	this.data.onClose != null ? this.data.onClose() : null;
	close();
}

function makeImage(x:Float, y:Float, scl:Float, graphic:String) {
	var spr:FlxSprite = new FlxSprite(x, y);
	spr.loadGraphic(Paths.image('warning/' + graphic));
	spr.scale.set(scl, scl);
	spr.updateHitbox();
	return spr;
}
