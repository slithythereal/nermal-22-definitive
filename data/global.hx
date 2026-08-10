import funkin.backend.utils.WindowUtils;
import lime.graphics.Image;
import funkin.backend.system.framerate.Framerate;
import openfl.text.TextFormat;
import openfl.text.TextField;
import funkin.backend.MusicBeatTransition;
import funkin.backend.utils.DiscordUtil;
import funkin.game.GameOverSubstate;
import openfl.Lib;
import openfl.display.Sprite;
import Sys;
import funkin.backend.MusicBeatState;
import openfl.Lib;
import funkin.backend.utils.NativeAPI;
import flixel.util.FlxColor;
import flixel.group.FlxTypedSpriteGroup;

function new() {
	FlxG.save.data.customNermalNotes ??= true;
	FlxG.save.data.customJumpscareNotes ??= true;
	FlxG.save.data.noteSwing ??= true;
	FlxG.save.data.pussyMode ??= false;
	FlxG.save.data.axelIcons ??= false;
	FlxG.save.data.disableNermalNotes ??= false;
	FlxG.save.data.disableJumpscareNotes ??= false;
	FlxG.save.data.cubicCloseGame ??= true;
	FlxG.save.data.cubicCameraShake ??= true;
	FlxG.save.data.middlescroll ??= false;
	FlxG.save.data.psychHUD ??= false;
	FlxG.save.data.v2Ratings ??= false;
	FlxG.save.data.gsrfieldNoteVisible ??= true;
	FlxG.save.data.warningScreenNN22 ??= true;
}
