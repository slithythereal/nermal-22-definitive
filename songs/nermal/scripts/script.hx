function onStartCountdown(event) {
	if (PlayState.isStoryMode) {
		event.cancel();
		focusOn(PlayState.instance.dad);
		PlayState.instance.inCutscene = true;
		var sub:ModSubState = new ModSubState('nermal/substate/WarningScreen', {
			song: 'nermal',
			onClose: function() {
				PlayState.instance.inCutscene = false;
				startCountdown();
			}
		});
		sub.cameras = [camHUD];
		openSubState(sub);
	}
}

function focusOn(char, snap:Bool = false) {
	var camPos = char.getCameraPosition();
	PlayState.instance.camFollow.setPosition(camPos.x, camPos.y);
	FlxG.camera.snapToTarget();
	camPos.put();
}
