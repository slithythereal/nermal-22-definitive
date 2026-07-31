importScript('data/scripts/HandyDandy.hx');
var nermB:FlxSprite;
var nermT:FlxSprite;
var customScare:String = null;

var customScareMap = [
	'garfield' => {sound: "fard", noteSkin: 'GARFNOTES', jumpScare: 'garfield jumpscare'}
];

function create() {
	if (PlayState.SONG.meta.customValues?.nermalNoteType != null)
		customScare = PlayState.SONG.meta.customValues?.nermalNoteType;

	nermB = new FlxSprite(-400, 500);
	add(nermB);
	nermT = new FlxSprite(-400, -570);
	add(nermT);
	for (nermal in [nermB, nermT]) {
		nermal.loadGraphic(Paths.image('game/mech/nermal jumpscare'));
		if (customScare != null && customScareMap.exists(customScare))
			if (customScareMap[customScare].jumpScare != null)
				nermal.loadGraphic(Paths.image('game/mech/' + customScareMap[customScare].jumpScare));
		nermal.scale.set(2, 0.5);
		nermal.updateHitbox();
		nermal.cameras = [camHUD];
		nermal.alpha = 0.001;
	}
	nermT.flipY = true;
}

function onPlayerHit(event) {
	if (event.noteType == 'nermalNote') {
		health -= 0.18;

		var soundID:String = 'wow';
		if (customScare != null)
			if (customScareMap[customScare].sound != null)
				soundID = customScareMap[customScare].sound;
		FlxG.sound.play(Paths.sound(soundID), 1);

		camGame.shake(0.10, 0.5);
		camHUD.shake(0.10, 0.5);

		for (i in [nermB, nermT]) {
			FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.bounceOut});
			new FlxTimer().start(7, function(tmr:FlxTimer) {
				FlxTween.tween(i, {alpha: 0.001}, 1, {ease: FlxEase.bounceOut});
			});
		}
	}
}

function onPlayerMiss(event) {
	if (event.noteType == 'nermalNote') {
		event.animCancelled = true;
		event.cancel(true);
		event.cancelResetCombo();
		var note:Note = event.note;
		remove(note);
		note.destroy();
	}
}

function onNoteCreation(event) {
	if (event.noteType == 'nermalNote' && customScare != null) {
		if (customScareMap.exists(customScare)) {
			event.noteSprite = 'game/notes/' + customScareMap[customScare].noteSkin;
		}
	}
}
