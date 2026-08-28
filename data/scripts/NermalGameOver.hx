import Float;
import funkin.menus.StoryMenuState;
import funkin.editors.charter.Charter;
import funkin.backend.MusicBeatState;
import funkin.menus.ui.Alphabet;

var lossSound:FlxSound;
var isEnding:Bool = false;
var isLooping:Bool = false;
var retryText:Alphabet;

function create(event) {
	if (!PlayState.instance.camGame.visible)
		PlayState.instance.camGame.visible = true;
	PlayState.instance.camHUD.zoom = 1;
	PlayState.instance.camHUD.alpha = 1;
	PlayState.instance.camGame.zoom = 1;
	FlxG.camera.zoom = 1;
	FlxG.camera.angle = 0;
	event.cancel();

	var pic:FlxSprite = new FlxSprite().loadGraphic(Paths.image('riodejaneiro'));
	pic.setGraphicSize(FlxG.width, FlxG.height);
	pic.updateHitbox();
	pic.scrollFactor.set();
	add(pic);

	retryText = new Alphabet(126, 210, "Retry?\n\nCONTINUE (SPACE)\nGIVE UP LOSER (ESCAPE)", "bold");
	add(retryText);
	retryText.textWidth = retryText.textHeight = 1;
	retryText.screenCenter();
	retryText.scrollFactor.set();
	retryText.alignment = 1;
    retryText.y-=2000;

	lossSound = FlxG.sound.load(Paths.sound('utter failure'));
	lossSound.play();
	lossSound.onComplete = function() {
        FlxTween.tween(retryText,{y:210},0.5,{ease:FlxEase.linear});
		isLooping = true;
		CoolUtil.playMusic(Paths.music(gameOverSong));
	}
}

function update(elapsed:Float) {
	if (controls.ACCEPT) {
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		MusicBeatState.skipTransOut = true;
		FlxG.switchState(new PlayState());
	}
	if (controls.BACK)
		exitGameOver();
}

function exitGameOver() {
	if (PlayState.chartingMode && Charter.undos.unsaved)
		PlayState.instance.saveWarn(false);
	else {
		if (Charter.instance != null)
			Charter.instance.__clearStatics();

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.sound.music = null;

		FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState());
	}
}
