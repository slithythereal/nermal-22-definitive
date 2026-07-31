importScript('data/scripts/HandyDandy.hx');

function create(){

}

function onPlayerHit(event){
    if(event.noteType == 'nermalNote'){
        //make nermal block hud\
        health -= 0.18;
    }
}

function onPlayerMiss(event){
    if(event.noteType == 'nermalNote'){
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
    if(event.noteType == 'nermalNote' && PlayState.SONG.meta.customValues?.nermalNoteType == 'garfield')
        event.noteSprite = 'game/notes/GARFNOTES';
}