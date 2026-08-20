import funkin.backend.utils.FunkinParentDisabler;
import flixel.math.FlxPoint;
import flixel.util.typeLimit.OneOfTwo;
import funkin.backend.scripting.events.CancellableEvent;
import funkin.backend.scripting.events.menu.MenuChangeEvent;
import funkin.backend.system.Flags;
import funkin.backend.utils.FlxInterpolateColor;
import funkin.backend.week.Week;
import funkin.savedata.FunkinSave;
import haxe.io.Path;
import haxe.xml.Access;
import funkin.menus.StoryWeeklist;
import funkin.backend.utils.XMLUtil;
import funkin.backend.utils.MemoryUtil;
import funkin.backend.FunkinText;

importScript('data/scripts/HandyDandy');

/**
 * TODO: 
 * add weeksprites menuitem
 * write functionality
 * tween in the menus on load
 */
var pD:FunkinParentDisabler;

var characters:Map<String, Dynamic> = []; // using dynamics because I can't get typedefs for the life of me
// im not figuring allat out 😭
var weekArray:Array<String> = ['nermal'];

var weekDataMINE = [
	'nermal' => {
		songs: ['nermal', 'xd', 'abuse'],
		difficulties: ['easy', 'gay'],
		weekName: "THE NERMAL MOD",
		weekChars: ['nermal', 'gf', 'bf'],
		weekTexture: 'weekn',
		weekBackground: 'nermal',
		weekID: 'nermal'
	}
];

var diffArray:Map<String, {variant:String, hasRechart:Bool}> = [
	'easy' => {variant: null, hasRechart: true},
	'normal' => {variant: null, hasRechart: false},
	'hard' => {variant: null, hasRechart: false},
	'gay' => {variant: 'gay', hasRechart: false}
];

var weekList:StoryWeekList;
var curDiff:Int = 0;
var curWeek:Int = 0;
var scoreMessage:String = 'WEEK SCROE:{0}';
var scoreText:FlxText;
var trackList:FunkinText;
var weekTitle:FlxText;
var difficultySprites:Map<String, FlxSprite> = [];
var leftArrow:FlxSprite;
var rightArrow:FlxSprite;
var blackBar:FlxSprite;
var blackBox:FlxSprite;
var interpColor:FlxInterpolateColor;
var lerpScore:Float = 0;
var intendedScore:Int = 0;
var weekBG:FlxSprite;
var canSelect:Bool = false;
var weekSprites:FlxTypedGroup<MenuItem>;
var weekTextureData:Map<FunkinSprite, {isFlashing:Bool, targetY:Float, time:Float}> = [];
var charSprites:FlxTypedGroup<FunkinSprite>;

function postCreate() {
	pD = new FunkinParentDisabler();
	add(pD);
	loadXMLS();

	blackBar = new FlxSprite(0, 0).makeSolid(FlxG.width, 56, 0xFFFFFFFF);
	blackBar.color = 0xFF000000;
	blackBar.updateHitbox();

	blackBox = new FlxSprite(0, 400).makeSolid(FlxG.width + 100, 400, 0xFF000000);
	blackBox.color = 0xFF000000;
	add(blackBox);

	scoreText = new FunkinText(10, 10, 0, 'WEEK SCORE: ', 36);
	scoreText.setFormat(Paths.font("vcr.ttf"), 32);

	weekTitle = new FlxText(10, 10, FlxG.width - 20, "", 32);
	weekTitle.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, "right");
	weekTitle.alpha = 0.7;

	weekBG = new FlxSprite(0, 56).makeSolid(FlxG.width, 400, 0xFFFFFFFF);
	weekBG.color = Flags.DEFAULT_WEEK_COLOR;
	weekBG.updateHitbox();

	weekSprites = new FlxTypedGroup<FunkinSprite>();

	// DUMBASS ARROWS
	var assets = Paths.getFrames('menus/storymenu/assets');
	var directions = ["left", "right"];

	leftArrow = new FlxSprite((FlxG.width + 400) / 2, weekBG.y + weekBG.height - 150);
	rightArrow = new FlxSprite(FlxG.width - 10, weekBG.y + weekBG.height - 150);
	for (k => arrow in [leftArrow, rightArrow]) {
		var dir = directions[k];

		arrow.frames = assets;
		arrow.animation.addByPrefix('idle', 'arrow $dir');
		arrow.animation.addByPrefix('press', 'arrow push $dir', 24, false);
		arrow.animation.play('idle');
		arrow.antialiasing = true;
		add(arrow);
	}
	rightArrow.x -= rightArrow.width;

	tracklist = new FunkinText(16, weekBG.y + weekBG.height + 44, Std.int(((FlxG.width - 400) / 2) - 80), "TRACKS: ", 32);
	tracklist.alignment = "center";
	tracklist.color = 0xFFE55777;

	add(weekSprites);
	for (e in [blackBar, scoreText, blackBox, weekTitle, weekBG, tracklist]) {
		e.scrollFactor.set();
		add(e);
	}

	add(characterSprites = new FlxTypedGroup<FunkinSprite>());

	for (i => week in weekArray) {
		var spr:FunkinSprite = new FunkinSprite(0, (i * 120) + 480);
		CoolUtil.loadAnimatedGraphic(spr, Paths.image('menus/storymenu/weeks/' + weekDataMINE[week].weekTexture));
		spr.screenCenter(FlxAxes.X);
		spr.antialiasing = true;
		weekTextureData.set(spr, {isFlashing: false, time: 0, targetY: 0});
		weekSprites.add(spr);
		for (diff in weekDataMINE[week].difficulties) {
			var le = diff.toLowerCase();
			if (difficultySprites[le] == null) {
				var diffSprite = new FlxSprite(leftArrow.x + leftArrow.width, leftArrow.y);
				CoolUtil.loadAnimatedGraphic(diffSprite, Paths.image('menus/storymenu/difficulties/' + le));
				CoolUtil.setUnstretchedGraphicSize(diffSprite, Std.int(rightArrow.x - leftArrow.x - leftArrow.width), Std.int(leftArrow.height), false, 1);
				diffSprite.antialiasing = true;
				diffSprite.scrollFactor.set();
				add(diffSprite);
				difficultySprites[le] = diffSprite;
			}
		}
	}

	interpColor = new FlxInterpolateColor(weekBG.color);
	var wdl = weekDataMINE[weekArray[curWeek]].difficulties.length;
	curDiff = Math.floor(wdl * 0.5);
	changeWeek(0, true);
	canSelect = true;

}

function loadXMLS() {
	for (week in weekArray)
		for (char in weekDataMINE[week].weekChars)
			addCharacter(char);
}

function addCharacter(char:OneOfTwo<String, Dynamic>) {
	var ourChar:Dynamic = null;
	var charName:String;
	charName = char is String ? cast char : (ourChar = cast char).name;
	if (characters[charName] != null)
		return;
	characters[charName] = ourChar == null ? Week.loadWeekCharacter(charName) : ourChar;
}

var __lastDifficultyTween:FlxTween;

function postUpdate(elapsed:Float) {
	updateWeekSprites(elapsed);

	lerpScore = lerp(lerpScore, intendedScore, 0.5);
	scoreText.text = "WEEK SCORE: " + Math.round(lerpScore);

	if (canSelect) {
		if (leftArrow != null && leftArrow.exists)
			leftArrow.animation.play(controls.LEFT ? 'press' : 'idle');
		if (rightArrow != null && rightArrow.exists)
			rightArrow.animation.play(controls.LEFT ? 'press' : 'idle');
		if (controls.BACK) {
			remove(pD);
			close();
		}
		changeDifficulty((controls.LEFT_P ? -1 : 0) + (controls.RIGHT_P ? 1 : 0));
		changeWeek((controls.UP_P ? -1 : 0) - FlxG.mouse.wheel);
		if (controls.ACCEPT)
			selectWeek();
	} else {
		for (e in [leftArrow, rightArrow]) {
			if (e != null && e.exists) {
				e.animation.play('idle');
			}
		}
	}
	// interpColor.fpsLerpTo()
}

function beatHit(curBeat) {
	if (characterSprites != null)
		characterSprites.forEachAlive(function(spr) spr.beatHit(curBeat));
}

function changeWeek(change:Int, force:Bool = false) {
	var before:Int = curWeek;
	curWeek += change;
	if (before != curWeek) { // not porting that event stuff lmfao
		if (curWeek >= weekArray.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekArray.length - 1;
	}

	if (!force)
		CoolUtil.playMenuSFX();
	for (k => e in weekSprites.members) {
		weekTextureData[e].targetY = k - curWeek;
		e.alpha = k == curWeek ? 1.0 : 0.6;
	}

	var weekSongs:String = '';
	for (song in weekDataMINE[weekArray[curWeek]].songs)
		weekSongs += '\n' + song.toUpperCase();
	//trackList.text = 'TRACKS:' + weekSongs;
	weekTitle.text = weekDataMINE[weekArray[curWeek]].weekName;
	if (characterSprites != null) {
		for (i in 0...3) {
			var char = weekDataMINE[weekArray[curWeek]].weekChars[i];
			var curChar:FunkinSprite = null;
			var newChar = null;
			if (char == null || (newChar = characters[char.name]) == null)
				modifyCharacterAt(i, null);
			else if ((curChar = cast characterSprites.members[i]) == null || newchar.name != curChar.name)
				modifyCharacterAt(i, newChar);
		}
	}
	changeDifficulty(0, true);
	MemoryUtil.clearMinor();
}

var __oldDiffName = null;

function changeDifficulty(change:Int, force:Bool = false) {
	if (change == 0 && !force)
		return;
	var before:Int = curDiff;
	curDiff += change;
	var diffArr:Array<String> = weekDataMINE[weekArray[curWeek]].difficulties;
	if (before != curDiff) { // hope
		if (curDiff >= diffArr.length)
			curDiff = 0;
		if (curDiff < 0)
			curDiff = diffArr.length - 1;
	}
	if (__oldDiffName != (__oldDiffName = weekDataMINE[weekArray[curWeek]].difficulties[curDiff].toLowerCase())) {
		for (e in difficultySprites)
			e.visible = false;
		var diffSprite = difficultySprites[__oldDiffName];
		if (diffSprite != null) {
			diffSprite.visible = true;
			if (__lastDifficultyTween != null) {
				__lastDifficultyTween.cancel();
				diffSprite.alpha = 0;
				diffSprite.y = leftArrow.y - 15;
				__lastDifficultyTween = FlxTween.tween(diffSprite, {y: leftArrow.y, alpha: 1}, 0.07);
			}
		}
	}
	//intendedScore = FunkinSave.getWeekHighScore(weekDataMINE[weekArray[curWeek]].difficulties[curDiff]).score;
}

function modifyCharacterAt(i:Int, ?data:Dynamic) {
	var curChar:FunkinSprite = null;

	if (characterSprites != null) {
		var old = characterSprites.members[i];
		if (old != null) {
			characterSprites.remove(old);
			old.destroy();
		}
		if (data != null) {
			curChar = XMLUtil.createSpriteFromXMLI(data.xml, "", "BEAT");
			curChar.offset.x += curChar.x;
			curChar.offset.y += curChar.y;
			curChar.setPosition((FlxG.width * 0.25) * (1 + i) - 150, 70);
			curChar.playAnim('idle', true, "DANCE");
		} else {
			characterSprites.insert(i, new FunkinSprite()).visible = false;
		}
	}
	return curChar;
}

function selectWeek() {
	canSelect = false;

	if (characterSprites != null)
		characterSprites.forEachAlive(function(spr) spr.playAnim('confirm', true, "LOCK"));

	var variation:String = null;
	if (diffArray[weekDataMINE[curWeek].difficulties[curDiff]].variant != null)
		variation = diffArray[weekDataMINE[curWeek].difficulties[curDiff]].variant;

	new FlxTimer().start(1, function(tmr:FlxTimer) {
		HandyDandy.loadWeek(weekDataMINE[curWeek].songs, weekDataMINE[curWeek].weekID, weekDataMINE[curWeek].weekID,
			weekDataMINE[curWeek].difficulties[curDiff], variation);
	});

	weekTextureData[weekSprites.members[curWeek]].isFlashing = true;
}

function updateWeekSprites(elapsed:Float) {
	weekSprites.forEachAlive(function(weekSpr:FunkinSprite) {
		weekTextureData[weekSpr].time += elapsed;
		weekSpr.y = CoolUtil.fpsLerp(weekSpr.y, (weekTextureData[weekSpr].targetY * 120) + 480, 0.17);
		if (weekTextureData[weekSpr].isFlashing)
			weekSpr.color = (weekTextureData[weekSpr].time % 0.1 > 0.05) ? 0xFFffffff : 0xFF33ffff;
	});
}
