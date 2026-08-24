import funkin.backend.utils.NativeAPI;
import funkin.backend.MusicBeatState;
import funkin.options.OptionsMenu;

function onSelectItem(event) {
	event.cancel();

	switch (event.name) {
		case 'story mode':
			FlxG.switchState(new StoryMenuState());
		case 'freeplay':
			MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
			if (FlxG.save.data.freeplayUnlockedNN22)
				// FlxG.switchState(new FreeplayState());
				 FlxG.switchState(new ModState('nermal/Freeplay'));
				/*openSubState(new ModSubState('nermal/substate/Freeplay', {
					onClose: function() {
						FlxG.switchState(new MainMenuState());
					}
				}));*/
			else {
				NativeAPI.showMessageBox("NERMAL WANTS TO TELL YOU", "You need to beat my week before accessing the really cool freeplay songs!", 0x00000000);
				FlxG.switchState(new MainMenuState());
			}
		case 'options':
			FlxG.switchState(new OptionsMenu());
	}
}
