importScript('data/scripts/HandyDandy');
import funkin.backend.utils.FunkinParentDisabler;
var parentDisabler:FunkinParentDisabler;

var song:String;
var sprGrp:FlxTypedGroup<FlxSprite>;

var warnMap = [
    'nermal' => function(){
        var notePic:FlxSprite = new FlxSprite(850, 200);
        notePic.loadGraphic(Paths.image('warning/nermnoteWarningImage'));
        notePic.scale.set(2,2);
        notePic.updateHitbox();
        sprGrp.add(notePic);

        var text:FlxSprite = new FlxSprite(850, 200);
        text.loadGraphic(Paths.image('warning/nermnoteWarningText'));
        text.scale.set(2,2);
        text.updateHitbox();
        sprGrp.add(text);
        //add gay warn
    }
];

function postCreate(){
    //add(parentDisabler = new FunkinParentDisabler());
    if(this.data.song != null)
        song = this.data.song.toLowerCase();
    sprGrp = new FlxTypedGroup<FlxSprite>();
    add(sprGrp);

    var black:FlxSprite = new FlxSprite(-100, 0);
    black.makeGraphic(1500, 1500, FlxColor.BLACK);
    sprGrp.add(black);
    black.alpha = 0.8;

    warnMap[song]();
}

function postUpdate(elapsed:Float){
    if(controls.ACCEPT){
        this.data.onClose != null ? this.data.onClose() : null;
        close();
    }
}