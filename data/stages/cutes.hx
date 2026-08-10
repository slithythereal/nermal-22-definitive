function postCreate() {
	sl.scale.set(FlxG.width / 883, FlxG.height / 600);
	sl.updateHitbox();
	sl.cameras = [camOther];
	gf.visible = false;
	for (strum in strumLines) {
		for (i => strumLine in strumLines.members) {
			if (i == 2) {
				strumLine.visible = false;
				if (FlxG.save.data.middlescroll) {
					for (i in 2...4)
						strumLine.members[i].x = 750 + i * (110 / 2);
					for (i in 0...2)
						strumLine.members[i].x = 310 + i * (110 / 2);
				}
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

function onPostNoteCreation(event) {
	event.note.splash = 'ourplenoteSplashes';
}

function onCountdown(event) {
	if (event.soundPath != null)
		event.soundPath = 'ourpleUI/' + event.soundPath;
	event.antialiasing = false;
	event.spritePath = switch(event.swagCounter){
		case 0: 'game/ourpleUI/onyourmarks';
		case 1: 'game/ourpleUI/ready';
		case 2: 'game/ourpleUI/set';
		case 3: 'game/ourpleUI/go';
	}
}

function onNoteHit(event){
	event.ratingPrefix = 'game/ourpleUI/'; //changes the numbers too so i had to add all the numbers in here to fix it (bounty)
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
					FlxTween.tween(strumNote, {alpha: (FlxG.save.data.middlescroll ? 0.5 : 1)}, 0.75, {ease: FlxEase.cubeOut});
				}
			}
		}
	}
}
