var garfJumpIn:FlxSprite;
var angryNerm:Character;
var boyf:Character;
var game:PlayState;

function create() {
	game = PlayState.instance;
	if (PlayState.isStoryMode && !PlayState.seenCutscene) {
		garfJumpIn = new FlxSprite(141, -808);
		garfJumpIn.frames = Paths.getSparrowAtlas('cutscenes/garfieldjumpin');
		garfJumpIn.animation.addByPrefix('jumpIn', 'garf jumpscare fr fr', 24, false);
		garfJumpIn.scale.set(2, 2);
		garfJumpIn.updateHitbox();
		add(garfJumpIn);
		bf.visible = dad.visible = garfJumpIn.visible = false;

		boyf = new Character(game.bf.x+42.5, game.bf.y + 20, "bfShot", true);
		game.insert(game.members.indexOf(game.bf) - 1, boyf);

		angryNerm = new Character(game.dad.x, game.dad.y + game.dad.globalOffset.y, "angrynermal");
		game.insert(game.members.indexOf(game.dad) - 1, angryNerm);
	}
}

function postCreate() {
	if (PlayState.isStoryMode && !PlayState.seenCutscene) {
		game.camHUD.visible = persistentUpdate = false;
		focusOn(dad);
		inCutscene = persistentDraw = true;

		new FlxTimer().start(1, function(_:FlxTimer) {
			garfJumpIn.visible = true;
			boyf.visible = angryNerm.visible = false;
			garfJumpIn.animation.play('jumpIn');
			new FlxTimer().start(2, function(__:FlxTimer) {
				garfJumpIn.visible = false;
				dad.visible = bf.visible = true;
				var modState:ModSubState = new ModSubState('nermal/substate/WarningScreen', {
					song: curSong.toLowerCase(),
					onClose: function() {
						inCutscene = false;
						PlayState.seenCutscene = persistentUpdate = persistentDraw = game.camHUD.visible = true;
						startCountdown();
					}
				});
				modState.cameras = [camOther];
				openSubState(modState);
			});
		});
	}
}

function onStartCountdown(event) {
	if (PlayState.isStoryMode && !PlayState.seenCutscene)
		event.cancel();
}

function focusOn(char, snap:Bool = false) {
	var camPos = char.getCameraPosition();
	PlayState.instance.camFollow.setPosition(camPos.x, camPos.y);
	FlxG.camera.snapToTarget();
	camPos.put();
}
