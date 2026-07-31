importScript('data/scripts/HandyDandy.hx');

function onPlayerHit(event){
    if(event.noteType == 'jumpScareNote'){
        health -= 1;
        var garf:FlxSprite = new FlxSprite(50, 0);
        garf.loadGraphic(Paths.image('game/mech/scarygarfield'));
        garf.scale.set(1.8, 1);
        garf.updateHitbox();
        garf.cameras = [camHUD];
        garf.alpha = 1;
        add(garf);
        new FlxTimer().start(0.5, function(tmr:FlxTimer){
            FlxTween.tween(garf, {alpha: 0}, 0.5, {ease:FlxEase.linear});
        });
        FlxG.sound.play(Paths.sound('sonic.exe laugh'), 0.5);
    }
}

function onPlayerMiss(event){
    if(event.noteType == 'jumpScareNote'){
        event.animCancelled = true;
        event.cancel(true);
        event.cancelResetCombo();
        var note:Note = event.note;
        remove(note);
        note.destroy();
    }
}

function onNoteCreation(event)
{
    if(event.noteType == 'jumpScareNote'){
        switch(PlayState.SONG.meta.customValues?.jumpscareNoteType){
            case 'scary':
            event.noteSprite = 'game/notes/jumpscareNoteAsset2';
            default:
            event.noteSprite = 'game/notes/jumpscareNoteAsset1';
        }
    }
}