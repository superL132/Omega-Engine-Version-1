# Omega Engine (WIP)


>NB : This is based off the final engine, which currently isn't available... For now it will help you modify the current mod. Most      things aren't very 'player friendly' and quite frankly, I can't figure out wtf I typed out either! Feel free to play around and break everything! There are many copies to go around!

**Edit: Wtf? Why is it taking so long... Idk if this thing will realese at this point...**



Looking for a great Friday Night Funkin' Engine for Godot? Well this is the one for you!!
But before you start modding, there are somethings you might want to check out first

Otherwise skip and go to [Modifying the Omega Engine](#modifying-the-omega-engine)

## Setting up the Omega Engine

Follow these steps to change it to a mod [IMPORTANT!!!]:

- So what you'd want to do is enter the file [Project File](project.godot)
- next you'd want to find the **is_mod** property under the section [Omega]
- After you find it, change it to *false* if it isn't already

Congrats! You just let the engine know you are trying to make a mod!
Time to change a few more things

### Custom update checker
This next part is optional
Follow these steps to change the version checker

#### Part 1
- You'd want go enter the same file, [Project File](project.godot)
- then you'd want to find the **has_custom_update_link** property below the **is_mod** property
- After that, change it to *true* if it isn't already

#### Part 2

(For this part I personally recommend using [Gist](https://gist.github.com))

- After you set the property **has_custom_update_link** to *true* put your Update's API url into the blank string place

There we go!
### Custom Main Menu Music
Follow these steps to change the **Main Menu Music**
Note that although this won't effect anything, it will work in future

- Enter the [Project File](project.godot)
- Change the blank value to to the file path
## Modifying the Omega Engine

Now that you ahve the engine ready for modding, you could go do anything you want!

### These are the table of contents:
 - [Modifying The Main Menu](#modifying-the-main-menu)


## Modifying The Main Menu

The first this you'd want to do is go to the [Main Menu Scene]()