importScript('data/scripts/HandyDandy');
import funkin.backend.chart.Chart;
import funkin.menus.FreeplayState.FreeplaySonglist;
import funkin.game.HealthIcon;
import funkin.backend.system.Conductor;
import funkin.menus.FreeplayState.FreeplaySonglist;
import openfl.Assets;
import sys.io.File;
import sys.FileSystem;
import funkin.savedata.FunkinSave;
import funkin.menus.ui.Alphabet;

using StringTools;

var curSelection:Int = 0;
var selections:Array<String> = ['songs', 'difficulties'];
var canPress:Bool = false;
var songs:Array<String> = [];
var curSong:Int = 0;
var curDifficulty:Int = 0;
var chartDataMap:Map<String, ChartMetaData> = [];
var songDifficultyMap:Map<String, Array<String>> = [];
var oppIcon:HealthIcon;
var songText:Alphabet;
var songScore:FlxText;
var songsHaveRechart:Array<{songName:String, difficulty:String}> = [];
var coolBG:FunkinSprite;
var coolDiffSprite:FunkinSprite;
var arrows:FlxTypedGroup<FunkinSprite>;

function postCreate() {
	var freeplaysonglist = FreeplaySonglist.get();
	var rawDifficultyArray:Array<String> = [];
	rawDifficultyArray = CoolUtil.coolTextFile(Paths.txt('config/freeplaySongDifficulties'));
	for (song in rawDifficultyArray) {
		var colonPos:Int = song.indexOf(':'); // position of this thingy
		var difficulties:String = song.substr(colonPos + 1); // difficulties
		var songName:String = song.substr(0, colonPos); // song name
		var diffArray:Array<String> = difficulties.split(','); // splitting the string into an array
		songs.push(songName);
		songDifficultyMap.set(songName, diffArray);
	}
	for (i => song in freeplaysonglist.songs)
		if (song.name.toLowerCase() == songs[i])
			chartDataMap.set(songs[i], song);
	for (i => chart in chartDataMap) {
		for (difficulty in chart.difficulties) {
			if (difficulty.contains('-rechart')) {
				var dashPos:Int = difficulty.indexOf('-');
				var difficultyName:String = difficulty.substr(0, dashPos);
				songsHaveRechart.push({songName: i, difficulty: difficultyName});
			}
		}
	}

	var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height * 0.75, 0xFFF9CF51);
	add(bg);
	bg.screenCenter(FlxAxes.Y);

	coolBG = new FunkinSprite(bg.x, bg.y).loadGraphic(Paths.image('menus/storymenu/menubgs/menu_nermal'));
	coolBG.setGraphicSize(bg.width, bg.height + (bg.height * 0.3));
	add(coolBG);

	oppIcon = new HealthIcon(chartDataMap[songs[curSong]].icon, true);
	oppIcon.flipX = true;
	var iconScl:Float = 2;
	oppIcon.scale.set(iconScl, iconScl);
	oppIcon.updateHitbox();
	oppIcon.defaultScale = iconScl;
	add(oppIcon);
	oppIcon.screenCenter();

	songText = new Alphabet(0, 520, chartDataMap[songs[curSong]].displayName, "bold");
	add(songText);
	songText.screenCenter(FlxAxes.X);

	var topBar:FlxSprite = new FlxSprite();
	var bottomBar:FlxSprite = new FlxSprite();
	for (bar in [topBar, bottomBar]) {
		bar.makeGraphic(FlxG.width, FlxG.height * 0.125, 0xFF000000);
		add(bar);
	}
	bottomBar.y += 630;

	songScore = new FlxText(925, 25, 0, 'HIGH SCORE: ');
	songScore.setFormat(Paths.font('vcr.ttf'), 50, FlxColor.WHITE, "center");
	add(songScore);

	coolDiffSprite = new FunkinSprite(0, 645);
	coolDiffSprite.loadGraphic(Paths.image('menus/storymenu/difficulties/' + songDifficultyMap[songs[curSong]][curDifficulty].toLowerCase()));
	add(coolDiffSprite);
	coolDiffSprite.screenCenter(FlxAxes.X);

	arrows = new FlxTypedGroup<FunkinSprite>();
	add(arrows);
	for (i => dir in ['left', 'right']) {
		var arrow:FunkinSprite = new FunkinSprite(0, 0);
		arrow.frames = Paths.getSparrowAtlas('menus/storymenu/assets');
		arrow.addAnim('idle', 'arrow ' + dir);
		arrow.addAnim('press', 'arrow push ' + dir, 24, false);
		arrow.playAnim('idle');
		arrow.ID = i;
		arrow.y = coolDiffSprite.y;
		arrow.antialiasing = false;
		arrows.add(arrow);
	}
	for (arrow in arrows) {
		arrow.x = coolDiffSprite.x - 50 + (arrow.ID * (196 / 0.8));
	}

	changeSong(0);
	tweenObjs();
}

function postUpdate(elapsed:Float) {
	if (controls.BACK)
		FlxG.switchState(new MainMenuState());
	if (canPress) {
		if (controls.LEFT_P)
			change(-1, selections[curSelection]);
		else if (controls.RIGHT_P)
			change(1, selections[curSelection]);
		if (controls.UP_P)
			changeSelection(-1);
		else if (controls.DOWN_P)
			changeSelection(1);
	}
}

function tweenObjs() {
	var posMap:Map<FlxObject, Float> = [];
	var topObjs:Array<FlxObject> = [songScore, coolBG];
	var bottomObjs:Array<FlxObject> = [songText, oppIcon, coolDiffSprite];
	for (obj in topObjs) {
		posMap.set(obj, obj.y);
		obj.y -= 720;
	}
	for (obj in bottomObjs) {
		posMap.set(obj, obj.y);
		obj.y += 720;
	}
	var allObjs:Array<FlxObject> = topObjs;
	for (obj in bottomObjs)
		allObjs.push(obj);
	for (obj in allObjs) {
		FlxTween.tween(obj, {y: posMap[obj]}, 0.75, {
			ease: FlxEase.quintOut,
			onComplete: function(twn:FlxTween) {
				canPress = true;
			}
		});
	}
}

function changeSong(change:Int) {
	var pre:Int = curSong;
	curSong += change;
	curSong = FlxMath.wrap(curSong, 0, songs.length - 1);
	changeAssets();
	changeDifficulty(0);
}

function changeDifficulty(change:Int) {
	var pre:Int = curDifficulty;
	curDifficulty += change;
	curDifficulty = FlxMath.wrap(curDifficulty, 0, songDifficultyMap[songs[curSong]].length - 1);
}

function changeAssets() {
	oppIcon.setIcon(chartDataMap[songs[curSong]].icon);
	var iconScl:Float = 2;
	oppIcon.scale.set(iconScl, iconScl);
	oppIcon.updateHitbox();
	oppIcon.defaultScale = iconScl;
	songText.text = '< ' + chartDataMap[songs[curSong]].displayName + ' >';
	songText.screenCenter(FlxAxes.X);

	oppIcon.scale.set(iconScl + 0.2, iconScl + 0.2);
	FlxTween.cancelTweensOf(oppIcon);
	FlxTween.tween(oppIcon, {"scale.x": iconScl, "scale.y": iconScl}, 0.1, {ease: FlxEase.linear});
	var high = FunkinSave.getSongHighscore(chartDataMap[songs[curSong]].displayName.toLowerCase(), songDifficultyMap[songs[curSong]][curDifficulty]);
	songScore.text = 'HIGH SCORE: ' + high.score;
	songScore.screenCenter(FlxAxes.X);
}

function change(change:Int, selection:String) {
	switch (selection) {
		case 'songs':
			changeSong(change);
		case 'difficulties':
			changeDifficulty(change);
		default:
			trace('functionality not coded in yet');
	}
}

function changeSelection(change:Int) {
	curSelection += change;
	curSelection = FlxMath.wrap(curSelection, 0, selections.length - 1);

	var sTxt:String = chartDataMap[songs[curSong]].displayName;
	var songsSelected:Bool = selections[curSelection] == 'songs';
	songText.text = (songsSelected ? '< ' : '') + sTxt + (songsSelected ? ' >' : '');
	songText.screenCenter(FlxAxes.X);
}
