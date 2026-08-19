var topBar:FlxSprite;
var bottomBar:FlxSprite;

function create() {
	topBar = new FlxSprite(0, -120);
	bottomBar = new FlxSprite(0, 720);

	for (i in [topBar, bottomBar]) {
		i.makeGraphic(1280, 120, 0xFF000000);
		i.cameras = [camOther];
	}
	add(topBar);
	add(bottomBar);
}

function onEvent(_) {
	if (_.event.name == 'Cinematic Bars' && FlxG.save.data.cinematicBar) {
		var topTwn:Float = (_.event.params[0] ? 0 : -120);
		var bottomTwn:Float = (_.event.params[0] ? 600 : 720);
		var hudAlpha:Float = (_.event.params[0] ? 0 : 1);
		var upScrollY:Float = (_.event.params[0] ? 120 : 50);
		var downScrollY:Float = (_.event.params[0] ? 480 : 570);
		FlxTween.tween(topBar, {y: topTwn}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(bottomBar, {y: bottomTwn}, 0.5, {ease: FlxEase.circOut});
		for (i in [healthBarBG, healthBar, scoreTxt, accuracyTxt, missesTxt, iconP1, iconP2])
			FlxTween.tween(i, {alpha: hudAlpha}, 0.25, {ease: FlxEase.circOut});
		for (strum in playerStrums)
			FlxTween.tween(strum, {y: (FlxG.save.data.downscroll ? downScrollY : upScrollY)}, 0.5, {ease: FlxEase.circOut});
		for (strum in cpuStrums)
			FlxTween.tween(strum, {y: (FlxG.save.data.downscroll ? downScrollY : upScrollY)}, 0.5, {ease: FlxEase.circOut});
	}
}
