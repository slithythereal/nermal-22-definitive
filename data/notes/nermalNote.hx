import funkin.backend.system.Conductor;
import Math;

var nermB:FlxSprite;
var nermT:FlxSprite;
var customScare:String = null;

var customScareMap = [
	'garfield' => {sound: "fard", noteSkin: 'GARFNOTES', jumpScare: 'garfield jumpscare'}
];

function create() {
	if (PlayState.SONG.meta.customValues?.nermalNoteType != null && FlxG.save.data.customNermalNotes)
		customScare = PlayState.SONG.meta.customValues?.nermalNoteType;

	nermB = new FlxSprite(-400, 500);
	add(nermB);
	nermT = new FlxSprite(-400, -570);
	add(nermT);
	for (nermal in [nermB, nermT]) {
		nermal.loadGraphic(Paths.image('game/mech/nermal jumpscare'));
		if (customScare != null && customScareMap.exists(customScare) && FlxG.save.data.customNermalNotes)
			if (customScareMap[customScare].jumpScare != null)
				nermal.loadGraphic(Paths.image('game/mech/' + customScareMap[customScare].jumpScare));
		nermal.scale.set(2, 0.5);
		nermal.updateHitbox();
		nermal.cameras = [camHUD];
		nermal.alpha = 0.001;
	}
	nermT.flipY = true;

	if (FlxG.save.data.noteSwing && !FlxG.save.data.pussyMode) {
		strumLines.members[0].onNoteUpdate.add(onNoteUpdate);
		strumLines.members[1].onNoteUpdate.add(onNoteUpdate);
	}
}

var timers:Array<FlxTimer> = [];

function onPlayerHit(event) {
	if (event.noteType == 'nermalNote' && !FlxG.save.data.pussyMode) {
		health -= 0.18;

		var soundID:String = 'wow';
		if (customScare != null && FlxG.save.data.customNermalNotes)
			if (customScareMap[customScare].sound != null)
				soundID = customScareMap[customScare].sound;
		FlxG.sound.play(Paths.sound(soundID), 1);

		camGame.shake(0.10, 0.5);
		camHUD.shake(0.10, 0.5);

		if (timers.length > 1) {
			for (timer in timers) {
				timer.cancel();
				timers.remove(timer);
			}
		}
		for (i in [nermB, nermT]) {
			var timer:FlxTimer;
			FlxTween.cancelTweensOf(i);
			FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.bounceOut});
			timer = new FlxTimer().start(7, function(tmr:FlxTimer) {
				timers.remove(tmr);
				FlxTween.tween(i, {alpha: 0.001}, 1, {ease: FlxEase.linear});
			});
			timers.push(timer);
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
	if (event.noteType == 'nermalNote') {
		if (customScare != null && FlxG.save.data.customNermalNotes)
			if (customScareMap.exists(customScare))
				event.noteSprite = 'game/notes/' + customScareMap[customScare].noteSkin;

		if (FlxG.save.data.pussyMode || FlxG.save.data.disableNermalNotes) {
			event.note.strumTime -= 999999;
			event.note.exists = event.note.active = event.note.visible = false;
		}
	}
}

/*function postUpdate(elapsed:Float) {
	for (note in strumLines.notes) {
		if (note.noteType == 'nermalNote') {
			note.updateNotesPosY = true;
			note.updateNotesPosX = true;
			note.offset.y = note.y / -1 * Math.abs(Math.sin(Conductor.songPosition / 100 * 1));
			note.offset.x = note.y * Math.sin(Conductor.songPosition / 100) * 0.3;
		}
	}
}*/
function onNoteUpdate(e:NoteUpdateEvent) {
	var note:Note = e.note;

	if (note.noteType == 'nermalNote' && PlayState.SONG.meta.customValues?.noteSwing == 'true') {
		note.updateNotesPosY = true;
		note.updateNotesPosX = true;
		note.y = note.y / -1 * Math.abs(Math.sin(Conductor.songPosition / 100 * 1));
		note.x = note.y * Math.sin(Conductor.songPosition / 100) * 0.3;
	}
}
/*
	function onNoteUpdate(e:NoteUpdateEvent) {
	if (FlxG.save.data.noteSwing && !FlxG.save.data.pussyMode) {
		var note:Note = e.note;
		trace("works");

		if (note.noteType != "nermalNote")
			return;

		
			if(PlayState.SONG.meta.customValues?.noteSwing == 'true'){

				//note.y = note.y / -1.1;

				note.x = note.y * Math.sin(Conductor.songPosition / 100) * 3;
					//	setPropertyFromGroup('notes', i, 'offsetX', getPropertyFromGroup('notes', i, 'y') * math.sin(getPropertyFromClass('Conductor', 'songPosition') / 100) * 0.3)

		}
	}
}*/
/*
	* function onUpdate(elapsed)
		--note stuff
		for i = 0, getProperty('notes.length')-1 do
			if getPropertyFromGroup('notes', i, 'noteType') == 'nermalNote' then
				if getPropertyFromGroup('notes', i, 'strumTime') - 1500 > (curStep * stepCrochet) then
					setPropertyFromGroup('notes', i, 'visible', false)
				else
					setPropertyFromGroup('notes', i, 'visible', true)
				end
				
				--does note tweens on the gay difficulty
				if getProperty('storyDifficultyText') == 'Gay' then
					if dadName == 'garfield' then
						setPropertyFromGroup('notes', i, 'offsetY', getPropertyFromGroup('notes', i, 'y') / -1 * math.abs(math.sin(getPropertyFromClass('Conductor', 'songPosition') / 100) * 1))
					else
						setPropertyFromGroup('notes', i, 'offsetY', getPropertyFromGroup('notes', i, 'y') / -1.1)
					end
					
					setPropertyFromGroup('notes', i, 'offsetX', getPropertyFromGroup('notes', i, 'y') * math.sin(getPropertyFromClass('Conductor', 'songPosition') / 100) * 0.3)
				end
			end
		end
	end
 */
