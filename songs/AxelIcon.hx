function postCreate() {
	if (FlxG.save.data.axelIcons) {
		if (dad.xml.exists("axelIcon"))
			iconP2.setIcon('new-icons/' + dad.xml.get('axelIcon'));
		if (bf.xml.exists("axelIcon"))
			iconP1.setIcon('new-icons/' + bf.xml.get('axelIcon'));
	}
}
