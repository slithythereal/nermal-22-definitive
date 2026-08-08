importScript('data/scripts/HandyDandy');
import funkin.backend.utils.FunkinParentDisabler;

var parentDisabler:FunkinParentDisabler;
var song:String;
var sprGrp:FlxTypedGroup<FlxSprite>;

var warnMap = [
	'nermal' => function() {
		var notePic:FlxSprite = new FlxSprite(850, 200);
		notePic.loadGraphic(Paths.image('warning/nermnoteWarningImage'));
		notePic.scale.set(2, 2);
		notePic.updateHitbox();
		sprGrp.add(notePic);

		var text:FlxSprite = new FlxSprite(0, 0);
		text.loadGraphic(Paths.image('warning/nermnoteWarningText'));
		text.scale.set(1.3, 1.3);
		text.updateHitbox();
		sprGrp.add(text);
		// add gay warn
	},
	'abuse' => function() {
		var notePic1:FlxSprite = new FlxSprite(550, 400);
		notePic1.loadGraphic(Paths.image('warning/nermnoteWarningImage'));
		notePic1.scale.set(2, 2);
		notePic1.updateHitbox();
		notePic1.scale.set(1.2, 1.2);

		sprGrp.add(notePic1);

		var notePic:FlxSprite = new FlxSprite(1000, 400);
		notePic.loadGraphic(Paths.image('warning/garfnoteWarningImage'));
		notePic.scale.set(2, 2);
		notePic.updateHitbox();
		notePic.scale.set(1.2, 1.2);

		sprGrp.add(notePic);

		var text:FlxSprite = new FlxSprite(0, 0);
		text.loadGraphic(Paths.image('warning/abuseWarningText'));
		text.scale.set(1.3, 1.3);
		text.updateHitbox();
		sprGrp.add(text);

		var arrow:FlxSprite = new FlxSprite(825, 475);
		arrow.loadGraphic(Paths.image('warning/clickbaitarrow'));
		arrow.scale.set(0.5, 0.5);
		arrow.updateHitbox();
		sprGrp.add(arrow);

		var scary:FlxSprite = new FlxSprite(850, 100);
		scary.loadGraphic(Paths.image('warning/jumpscareNoteWarning'));
		scary.scale.set(2, 2);
		scary.updateHitbox();
		sprGrp.add(scary);
	}
];

function postCreate() {
	// add(parentDisabler = new FunkinParentDisabler());
	trace("open");
	if (this.data.song != null)
		song = this.data.song.toLowerCase();
	sprGrp = new FlxTypedGroup<FlxSprite>();
	add(sprGrp);

	var black:FlxSprite = new FlxSprite(-100, 0);
	black.makeGraphic(1500, 1500, FlxColor.BLACK);
	sprGrp.add(black);
	black.alpha = 0.8;

	warnMap[song]();
}

function postUpdate(elapsed:Float) {
	if (controls.ACCEPT) {
		this.data.onClose != null ? this.data.onClose() : null;
		close();
	}
}
