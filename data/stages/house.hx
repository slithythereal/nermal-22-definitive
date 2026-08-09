function postCreate() {
	// precache
	var garf:FlxSprite = new FlxSprite(50, 0);
	garf.loadGraphic(Paths.image('game/mech/scarygarfield'));
}

public var bfD:FlxSprite;

function create() {
	bfD = new FlxSprite(660, 420);
	bfD.frames = Paths.getSparrowAtlas('cutscenes/killbf');
	bfD.animation.addByPrefix('shot', 'BF hit', 24, false);
	add(bfD);
	bfD.visible = false;
}

public function bfDies() {
	bf.visible = false;
	bfD.visible = true;
	bfD.animation.play('shot');
}
