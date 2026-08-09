var duration:Float = 0;
var game:PlayState;
var jumpOffs:Float = 20;

function create() {
	game = PlayState.instance;
}

function postCreate() {
	duration = Conductor.stepCrochet * 2 / 1100;
}

function beatHit(curBeat) {
	FlxTween.tween(game.iconP1, {y: game.iconP1.y - jumpOffs}, duration, {
		ease: FlxEase.cubeOut,
		onComplete: function(twn:FlxTween) {
			FlxTween.tween(game.iconP1, {y: game.iconP1.y + jumpOffs}, duration, {ease: FlxEase.cubeIn});
		}
	});
}

function update(e) {
	var angleOfs = FlxG.random.float(-15, 15);
	if (game.healthBar.percent < 20)
		game.iconP1.angle = angleOfs;
	else
		game.iconP1.angle = 0;
}
