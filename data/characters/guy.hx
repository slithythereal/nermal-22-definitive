var flipped:Bool = true;
var flippedIdle:Bool = false;
var defaultY:Float = 0;
var game:PlayState;

function create() {
	game = PlayState.instance;
}

function beatHit(curBeat) {
	if (game.healthBar.percent < 80) {
		flipped = !flipped;
		game.iconP2.flipX = flipped;
	}
	if (curBeat % 1 == 0 && game.dad.animation.curAnim.name == 'idle') {
		flippedIdle = !flippedIdle;
		game.dad.flipX = flippedIdle;
		if (defaultY == 0)
			defaultY = game.dad.y;
		game.dad.y = game.dad.y + 20;
		FlxTween.tween(game.dad, {y: game.dad.y - 20}, 0.15, {ease: FlxEase.cubeOut});
	}
}

function onNoteHit(_) {
	if (_.note.strumLine.ID == 0) {
		FlxTween.cancelTweensOf(game.dad);
		game.dad.y = defaultY;
		game.dad.flipX = false;
	}
}

function stepHit(curStep) {
	if (game.healthBar.percent > 80 && curStep % 2 == 0) {
		flipped = !flipped;
		game.iconP2.flipX = flipped;
	}
}

function update(e) {
	var angleOfs = FlxG.random.float(-5, 5);
	if (game.healthBar.percent > 80)
		game.iconP2.angle = angleOfs;
	else
		game.iconP2.angle = 0;
}
