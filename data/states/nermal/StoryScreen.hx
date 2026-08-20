import funkin.backend.utils.FunkinParentDisabler;
import flixel.math.FlxPoint;
import flixel.util.typeLimit.OneOfTwo;
import funkin.backend.FunkinText;
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
		weekTexture: 'nermal',
		weekBackground: 'nermal'
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
var trackList:FlxText;
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
var charSprites:FlxTypedGroup<FunkinSprite>;

importScript('data/scripts/HandyDandy');
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

	// weekSprites = new FlxTypedGroup<MenuItem>();

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

	// add(weekSprites);
	for (e in [blackBar, scoreText, blackBox, weekTitle, weekBG, tracklist]) {
		e.scrollFactor.set();
		add(e);
	}

	add(characterSprites = new FlxTypedGroup<FunkinSprite>());

	for (week in weekArray) {
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
	/*for (i => week in weeks) {
		//var spr:MenuItem = new MenuItem(0, (i * 120) + 480, 'menus/storymenu/weeks/${week.sprite}');
		//weekSprites.add(spr);
	}*/

	interpColor = new FlxInterpolateColor(weekBG.color);
	var wdl = weekDataMINE[weekArray[curWeek]].difficulties.length;
	curDifficulty = Math.floor(wdl * 0.5);
	// changeWeek(0, true);
}

function loadXMLS() {
	for (week in weekArray)
		for (char in weekDataMINE[week].weekChars)
			addCharacter(char);

	/*
		var weekList = StoryWeeklist.get(true, false);
		trace('Weeklist: ${weekList.weeks}');
		var weeks = weekList.weeks;
		trace(weeks); */

	// addCharacter(char.name);
}

function addCharacter(char:OneOfTwo<String, Dynamic>) {
	var ourChar:Dynamic = null;
	var charName:String;
	charName = char is String ? cast char : (ourChar = cast char).name;
	if (characters[charName] != null)
		return;
	characters[charName] = ourChar == null ? Week.loadWeekCharacter(charName) : ourChar;
}

function postUpdate(elapsed:Float) {
	if (controls.BACK) {
		remove(pD);
		close();
	}
	// interpColor.fpsLerpTo()
}

function beatHit(curBeat) {
	if (characterSprites != null)
		characterSprites.forEachAlive(function(spr) spr.beatHit(curBeat));
}

function changeWeek(change:Int, force:Bool = false) {
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
	if (characterSprites != null)
		characterSprites.forEachAlive(function(spr) spr.playAnim('confirm', true, "LOCK"));
}
