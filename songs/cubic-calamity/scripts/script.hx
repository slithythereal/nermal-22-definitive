var game:PlayState;
var songStarted:Bool = false;

function create() {
	game = PlayState.instance;
}

function postCreate() {
	bf.visible = gf.visible = false;
	game.camGame.alpha = scoreTxt.alpha = missesTxt.alpha = accuracyTxt.alpha = 0;
}

function onSongStart() {
	FlxTween.tween(game.camGame, {alpha: 1}, 1.8, {
		ease: FlxEase.linear,
		onComplete: function() {
			songStarted = true;
		}
	});
}

function onNoteHit(_) {
	if (_.note.strumLine.ID == 0) {
		if (FlxG.save.data.cubicCameraShake) {
			for (i in [game.camGame, game.camHUD])
				i.shake(0.08, 0.15);
		}
		health -= 0.01;
	}
}

function beatHit(curBeat) {
	if (curBeat == 36) {
		for (i => strumLine in strumLines.members)
			for (strumNote in strumLine.members)
				FlxTween.tween(strumNote, {alpha: 0.8}, 0.5, {ease: FlxEase.linear});

		for (i in [scoreTxt, accuracyTxt, missesTxt])
			FlxTween.tween(i, {alpha: 1}, 0.5, {ease: FlxEase.linear});
	} else if (curBeat == 76) {
		game.camGame.shake(0.3, 0.15);
		game.camHUD.shake(0.3, 0.15);
	}
}

function postUpdate(e) {
	if (!songStarted)
		for (i => strumLine in strumLines.members)
			for (strumNote in strumLine.members)
				strumNote.alpha = 0;
}

function onSongEnd() {
	if (FlxG.save.data.cubicCloseGame)
		Sys.exit(1);
}
