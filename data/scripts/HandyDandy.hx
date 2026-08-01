import funkin.game.PlayState;

public var HandyDandy:T = {
	// can use whenever
	loadWeek: function(weekSongs:Array<String>, name:String, id:String) {
		var songArray:Array<WeekSong> = [];
		PlayState.deathCounter = 0;

		for (song in weekSongs)
			songArray.push({name: song, hide: false});
		PlayState.loadWeek({
			name: name,
			id: id,
			sprite: null,
			chars: [null, null, null],
			songs: songArray,
			difficulties: ["hard"]
		}, "hard");

		FlxG.switchState(new PlayState());
	},
	insert_camera: function(newCamera:FlxCamera, position:Int, defaultDrawTarget = true):T {
		if (position < 0)
			position += FlxG.cameras.list.length;

		if (position >= FlxG.cameras.list.length)
			return FlxG.cameras.add(newCamera);

		final childIndex = FlxG.game.getChildIndex(FlxG.cameras.list[position].flashSprite);
		FlxG.game.addChildAt(newCamera.flashSprite, childIndex);

		FlxG.cameras.list.insert(position, newCamera);
		if (defaultDrawTarget)
			FlxG.cameras.defaults.push(newCamera);

		for (i in position...(FlxG.cameras.list.length))
			FlxG.cameras.list[i].ID = i;

		FlxG.cameras.cameraAdded.dispatch(newCamera);
		return newCamera;
	},
	loadSong: function(song:String) {
		PlayState.loadSong(song.toLowerCase(), "hard", false, false);
		FlxG.switchState(new PlayState());
	},
	watch: function(obj:FlxObject) {
		FlxG.watch.add(obj, "x");
		FlxG.watch.add(obj, "y");
	},
	tweenHudElements: function(alpha:Float, time:Float) {
		var game = PlayState.instance;
		for (i in [
			game.iconP1,
			game.iconP2,
			game.healthBarBG,
			game.healthBar,
			game.scoreTxt,
			game.accuracyTxt,
			game.missesTxt
		]) {
			FlxTween.tween(i, {alpha: alpha}, time, {ease: FlxEase.linear});
		}

		for (strum in PlayState.instance.strumLines) {
			for (i => strumLine in strumLines.members) {
				for (strumNote in strumLine.members)
					FlxTween.tween(strumNote, {alpha: alpha}, time, {ease: FlxEase.linear});
			}
		}
	}
}

