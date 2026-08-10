importScript("data/scripts/HandyDandy");
function update(e) {
	if (FlxG.keys.justPressed.Q) { // loading gay week (TEMP) 
		PlayState.storyVariations = ['gay'];
		HandyDandy.loadWeek(['nermal', 'xd', 'abuse'], 'nermal', 'nermal', 'gay', 'gay');
	}
}
