# Window management

This hammerspoon configuration is based on [Miro's windows management](https://github.com/miromannino/miro-windows-management)
With this configuration you will be able to move the windows in halves and in corners using only arrows. You would also be able to resize them by thirds, quarters, or halves.

## Shortcuts

### Hyper key

The hyper key is defined as `ctrl` + `cmd`. This means that each shortcut will start by pressing these keys. If you consider this too verbose for your personal keyboard interactions, you can also change this key by editing the file `init.lua`.

### Move in halves

 - `hyper` + `up`: move to the top half of the screen
 - `hyper` + `right`: move to the right half of the screen
 - `hyper` + `down`: move to the bottom half of the screen
 - `hyper` + `left`: move to the left half of the screen

By repeating these shortcuts the window is resized to be one third or two thirds and again in one half.

### Move to corners

 - `hyper` + `up` + `right`: move the window to the top-right corner
 - `hyper` + `down` + `right`: move the window to the bottom-right corner
 - `hyper` + `up` + `left`: move the window to the top-left corner
 - `hyper` + `down` + `left`: move the window to the bottom-left corner

 When the window is in the corner, it will have one half of screen height and one half of screen width.
 The arrows can be used to expand the height/width to be one third, two thirds or again one half.
 For example if the window is in the top-right corner, pressing `hyper` + `up` the window height will be resized to be one third, while pressing `hyper` + `right` the window width will be resized to be one third; in this case `hyper` + `left` and `hyper` + `down` will move the window to the top-left and bottom-right corners, respectively.

### Expand to fit the entire height or width

These are useful in case the window is in one of the corners.

 - `hyper` + `up` + `down`: expand the height to fit the entire screen height
 - `hyper` + `right` + `left`: expand the width to fit the entire screen width

### Expand to fullscreen

 - `hyper` + `f`: expand to be full screen

Note that in case the window is resized to be a half of the screen, you can also use `hyper` + `up` + `down` (or `hyper` + `right` + `left`) to resize the window full screen.

As the other shortcuts, `hyper` + `f` can be pressed multiple times to obtain a centered window of three fourth and one half of height and width. This behaviour can be customized.

### Change focus

 - `hyper` + `ctrl` + `up`: Focus wintow to the north
 - `hyper` + `ctrl` + `down`: Focus wintow to the south
 - `hyper` + `ctrl` + `right`: Focus wintow to the east
 - `hyper` + `ctrl` + `left`: Focus wintow to the west

### Applications

 - `hyper` + `return`: Open or focus terminal
 - `hyper` + `b`: Open or focus browser
