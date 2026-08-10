function focusOn(char, snap:Bool = false) {
	var camPos = char.getCameraPosition();
	PlayState.instance.camFollow.setPosition(camPos.x, camPos.y);
	FlxG.camera.snapToTarget();
	camPos.put();
}

function postCreate() {
	if (PlayState.isStoryMode && !PlayState.seenCutscene) {
		focusOn(dad);
		inCutscene = persistentDraw = true;
		persistentUpdate = false;
		var modState:ModSubState = new ModSubState('nermal/substate/WarningScreen', {song: curSong.toLowerCase(), onClose: function(){
			inCutscene = false;
			PlayState.seenCutscene = persistentUpdate = persistentDraw = true;
			startCountdown();
		}});
		modState.cameras = [camOther];
		openSubState(modState);
	}
}

function onStartCountdown(event) {
	if (PlayState.isStoryMode && !PlayState.seenCutscene) 
		event.cancel();
}