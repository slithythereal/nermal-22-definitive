# Adding Your Songs or Difficulties to Nermal 22 Recode
So you're obviously going to need your songs or difficulties charted and imported into CNE. [You can use the wiki for more info.](https://codename-engine.com/wiki/modding/songs/)
Next you're going to navigate to `data/config` and open up two files. `freeplaySongList.txt` and `freeplaySongDifficulties.txt`
<img width="197" height="64" alt="image" src="https://github.com/user-attachments/assets/72f10f44-8b41-497f-b941-fda4173051bb" />

If you're adding a song, you're going to first add your song into `freeplaySongList.txt`. If you're only adding a difficulty you can skip this step.
<img width="290" height="179" alt="image" src="https://github.com/user-attachments/assets/2bf84c7d-44c9-4845-8491-910921771223" />

Next: you're going to open `freeplaySongDifficulties.txt`
<img width="403" height="183" alt="image" src="https://github.com/user-attachments/assets/d0346b27-d4e3-4560-bf17-59370386b8a4" />

You may immediately notice the songs are formatted in a specific way. 

So first, you have your song name followed by a colon `:`. 

Then you have your difficulties split by a comma `,`.
If you have a `-rechart`, the mod will automatically detect the `-rechart` in the difficulties variable, so no need to add that here, as doing so will break the game.

## This part is subject to change as I might rework this system.
If you want to add your songs to Story Mode as a week.

First, create your own week. [Use the CNE wiki as a short guide.](https://codename-engine.com/wiki/modding/weeks/)

Next. You open up your week file and add your difficulties.
<img width="610" height="207" alt="image" src="https://github.com/user-attachments/assets/768c70e3-4730-4064-a40c-52a6786c6f28" />

The middle one is first, so technically, for this specific file, "easy" will be first to show up when you open the story menu.

Now you need to add some variables to your difficulty. Navigate to `data/scripts/HandyDandy.hx` and add them in the `diffData` variable. 

<img width="617" height="94" alt="image" src="https://github.com/user-attachments/assets/9107a63d-9317-4032-907f-803b89066f3c" />


Now open up your game, and everything should work!!!
