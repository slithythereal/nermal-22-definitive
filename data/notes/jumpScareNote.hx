importScript('data/scripts/HandyDandy.hx');

function create(){

}

function onPlayerHit(event){
    if(event.noteType == 'jumpScareNote'){
        //show scary garfield\
        health -= 0.18;
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