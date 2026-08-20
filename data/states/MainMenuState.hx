import funkin.options.OptionsMenu;

importScript("data/scripts/HandyDandy");
function update(e) {
	if (FlxG.keys.justPressed.Q) { // loading gay week (TEMP) 
		PlayState.storyVariations = ['gay'];
		HandyDandy.loadWeek(['nermal', 'xd', 'abuse'], 'nermal', 'nermal', 'gay', 'gay');
	}
}


function onSelectItem(event){
	event.cancel();

	switch(event.name){
		case 'story mode':
			openSubState(new ModSubState('nermal/StoryScreen'));
		case 'freeplay':
			FlxG.switchState(new FreeplayState());
		case 'options':
			FlxG.switchState(new OptionsMenu());
	}
}