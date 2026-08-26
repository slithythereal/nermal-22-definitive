var defaultY:Float = 0;
var game:PlayState;

function create() {
	game = PlayState.instance;
}

function onStartCountdown(_){
	//couldn't put this in `create` or `postCreate` for some reason
	var dadScl:Array<Float> = [game.dad.scale.x, game.dad.scale.y];
	game.dad.scale.set(dadScl[0] / 2, dadScl[1]);
	game.dad.updateHitbox();
	game.dad.scale.set(dadScl[0], dadScl[1]);
	game.dad.playAnim('idle');
}

function beatHit(curBeat) {
	if (game.healthBar.percent < 80)
		game.iconP2.flipX = !game.iconP2.flipX;

	if (curBeat % 1 == 0 && game.dad.animation.curAnim.name == 'idle') {
		game.dad.flipX = !game.dad.flipX;
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
	if (game.healthBar.percent > 80 && curStep % 2 == 0)
		game.iconP2.flipX = !game.iconP2.flipX;
}

function update(e) {
	var angleOfs = FlxG.random.float(-5, 5);
	game.iconP2.angle = (game.healthBar.percent > 80 ? angleOfs : 0);
}
