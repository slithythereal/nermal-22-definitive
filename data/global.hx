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

function new(){
    if(FlxG.save.data.customNermalNotes == null)
        FlxG.save.data.customNermalNotes = true;
    if(FlxG.save.data.customJumpscareNotes == null)
        FlxG.save.data.customJumpscareNotes = true;
    if(FlxG.save.data.noteSwing == null)
        FlxG.save.data.noteSwing = true;
    if(FlxG.save.data.pussyMode == null)
        FlxG.save.data.pussyMode = false;
        
}