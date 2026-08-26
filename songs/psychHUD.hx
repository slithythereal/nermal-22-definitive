import flixel.ui.FlxBar;
import flixel.util.FlxStringUtil;
import flixel.text.FlxTextBorderStyle;
import funkin.backend.scripting.events.note.NoteHitEvent;

importScript('data/scripts/HandyDandy');
public var timeBarBG:FlxSprite;
public var timeText:FlxText;
public var timeBar:FlxBar;
public var psychScore:FlxText;
var songPercent:Float = 0;
var psychScoreTwn:FlxTween;

function create() {
	// sprites
	if (FlxG.save.data.psychHUD) {
		timeText = new FlxText(0, 19, 400, "", 32);
		timeText.setFormat(Paths.font("vcr.ttf"), 32, 0xFFffffff, "CENTER");
		timeText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeText.borderSize = 2;

		timeBarBG = new FlxSprite(-216, timeText.y + (timeText.height / 4));
		timeBarBG.loadGraphic(Paths.image('game/psychlol/timeBar'));

		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, Type.resolveEnum('flixel.ui.FlxBarFillDirection').LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8),
			Std.int(timeBarBG.height - 8), null, "", 0, 1);
		timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		timeBar.updateBar();
		timeBar.unbounded = true;
		timeBar.numDivisions = 800;
		timeBar.value = 0;

		add(timeBarBG);
		add(timeBar);
		add(timeText);

		psychScore = new FlxText(0, 0, FlxG.width, "", 20);
		psychScore.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, "center");
		psychScore.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		psychScore.borderSize = 1.25;
		HandyDandy.watch(psychScore);
		for (spr in [timeBar, timeBarBG, timeText, psychScore]) {
			spr.screenCenter(FlxAxes.X);
			spr.cameras = [camHUD];
			spr.alpha = 0;
		}
		timeText.x += (timeBarBG.width / 2) * 0.825;
	}
}

function postCreate() {
	if (FlxG.save.data.psychHUD) {
		scoreTxt.visible = accuracyTxt.visible = missesTxt.visible = false;
		add(psychScore);
		psychScore.y = healthBar.y + 30;
	}
}

function onStartCountdown(event) {
	if (FlxG.save.data.psychHUD) {
		for (spr in [timeBar, timeBarBG, timeText, psychScore])
			FlxTween.tween(spr, {alpha: 1}, Conductor.crochet / 1000, {ease: FlxEase.cubeInOut});
	}
}

function update(elapsed:Float) {
	if (FlxG.sound.music != null && FlxG.save.data.psychHUD) {
		psychScore.text = 'Score: ' + songScore + ' | Misses: ' + misses + ' | Rating: ' + curRating.rating;
		var songLength:Float = FlxG.sound.music.length;
		var curTimeText:Float = Conductor.songPosition;
		var curTimeBar:Float = Math.max(0, Conductor.songPosition);
		timeBar.value = (curTimeBar / songLength);
		timeBar.updateBar();
		if (curTimeText < 0)
			curTimeText = 0;
		songPercent = (curTimeText / songLength);
		var songCalc:Float = (songLength - curTimeText);
		var secondsTotal:Int = Math.floor(songCalc / 1000);
		if (secondsTotal < 0)
			secondsTotal = 0;
		timeText.text = FlxStringUtil.formatTime(secondsTotal, false);
	}
}

function onPlayerHit(event:NoteHitEvent) {
	if (psychScoreTwn != null)
		psychScoreTwn.cancel();
	psychScore.scale.set(1.075, 1.075);
	psychScoreTwn = FlxTween.tween(psychScore.scale, {x: 1, y: 1}, 0.2, {
		onComplete: function(twn:FlxTween) {
			psychScoreTwn = null;
		}
	});
}
