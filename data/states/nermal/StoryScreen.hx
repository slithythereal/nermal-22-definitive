import funkin.backend.utils.FunkinParentDisabler;
import flixel.math.FlxPoint;
import flixel.util.typeLimit.OneOfTwo;
import funkin.backend.FunkinText;
import funkin.backend.scripting.events.CancellableEvent;
import funkin.backend.scripting.events.menu.MenuChangeEvent;
// import funkin.backend.scripting.events.menu.storymenu.*;
// import funkin.backend.week.*;
import funkin.backend.system.Flags;
import funkin.backend.utils.FlxInterpolateColor;
// import funkin.backend.week.WeekData;
import funkin.savedata.FunkinSave;
import haxe.io.Path;
import haxe.xml.Access;
//import funkin.menus.StoryMenuState;
import funkin.menus.StoryWeeklist;
var pD:FunkinParentDisabler;

// var characters:Map<String, WeekData.WeekCharacter> = [];

var diffArray:Array<{diff:String, variant:String, hasRechart:Bool}> = [
	{diff: 'easy', variant: null, hasRechart: true},
	{diff: 'gay', variant: 'gay', hasRechart: false}
];

// var weeks:Array<WeekData>;
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

	leftArrow = new FlxSprite((FlxG.width + 400) / 2, weekBG.y + weekBG.height-150);
	rightArrow = new FlxSprite(FlxG.width - 10, weekBG.y + weekBG.height-150);
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

	/*for (i => week in weeks) {
		//var spr:MenuItem = new MenuItem(0, (i * 120) + 480, 'menus/storymenu/weeks/${week.sprite}');
		//weekSprites.add(spr);

		for (e in week.difficulties) {
			var le = e.toLowerCase();
			if (difficultySprites[le] == null) {
				var diffSprite = new FlxSprite(leftArrow.x + leftArrow.width, leftArrow.y);
				diffSprite.loadAnimatedGraphic(Paths.image('menus/storymenu/difficulties/${le}'));
				diffSprite.setUnstretchedGraphicSize(Std.int(rightArrow.x - leftArrow.x - leftArrow.width), Std.int(leftArrow.height), false, 1);
				diffSprite.antialiasing = true;
				diffSprite.scrollFactor.set();
				add(diffSprite);

				difficultySprites[le] = diffSprite;
			}
		}
	}*/

	interpColor = new FlxInterpolateColor(weekBG.color);
	// curDifficulty = Math.floor(weeks[0].difficulties.length * 0.5);
	// changeWeek(0, true);
}

function loadXMLS() {/*
	weekList = StoryWeekList.get(true, false);
	weeks = weekList.weeks;
	for (week in weeks)
		for (char in week.chars)
			if (char != null)
				trace('balls');
	// addCharacter(char.name);*/
}
