var camOther:FlxCamera;

function create() {
	camOther = new FlxCamera();
	camOther.bgColor = FlxColor.TRANSPARENT;
	FlxG.cameras.add(camOther, false);
}

function postCreate() {
	sl.scale.set(FlxG.width / 883, FlxG.height / 600);
	sl.updateHitbox();
	sl.cameras = [camOther];
	gf.visible = false;
	for (strum in strumLines) {
		for (i => strumLine in strumLines.members) {
			if (i == 2) {
				strumLine.visible = false;
			}
		}
	}
}

function onNoteCreation(event) {
	event.noteSprite = 'game/notes/ourplenotes';
}

function onStrumCreation(event) {
	event.sprite = 'game/notes/ourplenotes';
}

function garfieldFall() {
	gf.visible = true;
	gf.playAnim('intro');
	for (strum in strumLines) {
		for (i => strumLine in strumLines.members) {
			if (i == 2) {
				strumLine.visible = true;

				for (strumNote in strumLine.members) {
					strumNote.alpha = 0;
					FlxTween.tween(strumNote, {alpha: 1}, 0.75, {ease: FlxEase.cubeOut});
				}
			}
		}
	}
}
