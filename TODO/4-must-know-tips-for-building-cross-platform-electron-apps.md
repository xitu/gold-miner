> * 原文地址：[4 must-know tips for building cross platform Electron apps](https://blog.avocode.com/blog/4-must-know-tips-for-building-cross-platform-electron-apps)
* 原文作者：[Kilian Valkhof](https://blog.avocode.com/authors/kilian-valkhof)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：





[Electron](https://electron.atom.io), the technology that powers Avocode among many other apps, allows you to get a cross-platform desktop application up and running very quickly. If you don't pay attention you will quickly end up in the uncanny valley of apps, though. Apps that don't feel _quite_ in place among your other apps.

This is a transcript of presentation I gave in May 2016 at the Electron Meetup in Amsterdam, updated to take into account API changes. Mind you, this goes into great detail and assumes some familiarity with Electron.

## **First off, who am I?**

I'm Kilian Valkhof, a front-end developer/UX designer/app developer, depending on who you ask. I have over 10 years of experience creating things for the internet, and built a number of desktop apps in various environments such as GTK and Qt, and of course, in Electron.

The most recent application I built is [Fromscratch](https://fromscratch), a free cross-platform auto-saving note taking application you should try.

During the development of Fromscratch, I spent a lot of time making sure the app feels great on all three platforms, and finding out how to make that happen in Electron. These are the gotcha's I encountered and how-to's I've come up with.

Getting an app to feel nice and consistent in Electron is not difficult, you just have to make sure you pay attention to the details.

## **1\. Copy and paste on macOS**

Imagine, for a moment, you release an app. Say, a note taking app. That you tested and used heavily on your Linux machine. And then you get this friendly message on ProductHunt:



![cp.png](https://lh6.googleusercontent.com/TlfwI6UWMb7sFhVU-KIE3C25bBcl0EIPm50HGgHnXDhY0NBGRjzgiNGfM3u3pzGgXvctkKaqBIp6BTIfo2bQuaA7oY1_pNmlYclk44qW-afSILxCIALGu2-KJYBlaZL0FM_DgkM4)



     if (process.platform === 'darwin') {

           var template = [{

             label: 'FromScratch',

             submenu: [{

               label: 'Quit',

               accelerator: 'CmdOrCtrl+Q',

               click: function() { app.quit(); }

             }]

           }, {

             label: 'Edit',

             submenu: [{

               label: 'Undo',

               accelerator: 'CmdOrCtrl+Z',

               selector: 'undo:'

             }, {

               label: 'Redo',

               accelerator: 'Shift+CmdOrCtrl+Z',

               selector: 'redo:'

             }, {

               type: 'separator'

             }, {

               label: 'Cut',

               accelerator: 'CmdOrCtrl+X',

               selector: 'cut:'

             }, {

               label: 'Copy',

               accelerator: 'CmdOrCtrl+C',

               selector: 'copy:'

             }, {

               label: 'Paste',

               accelerator: 'CmdOrCtrl+V',

               selector: 'paste:'

             }, {

               label: 'Select All',

               accelerator: 'CmdOrCtrl+A',

               selector: 'selectAll:'

             }]

           }];

           var osxMenu = menu.buildFromTemplate(template);

           menu.setApplicationMenu(osxMenu);

       }

If you already have a menu, you need to augment it to inlude the above cut/copy/paste commands.

### 1.1 Specify an icon

...or your app will look like this on Ubuntu:



![icon.png](https://lh3.googleusercontent.com/hgM2iMDPsJDn-QbmIwi6TlaBygW7twHNplrfrUrGk8lp-ilSDg81t42hT7jgYjrS58PA9undzhXds-NdXxmoE5HQ6dfVie-k2WqLJL6xN8o0UIkgH3RSTY3byGzlMOx5uv5dySvF)



Many, _many_ applications get this wrong unfortunately, because on Windows and on macOS, the icon shown in the task bar or dock is the _application icon_ (an .ico or .icns) and on Ubuntu, it's your _window icon_ that is shown. Adding it is super simple. in your `BrowserWindow` options, just specify an icon:

    mainWindow = new BrowserWindow({

         title: 'ElectronApp',

         *icon: __dirname + '/app/assets/img/icon.png',*

       };

This will also give you a small icon in the top left of your Windows app.

### 1.2 UI Text is not selectable

When you use your browser, word processing software, or any other native application, you will notice that you can't select the text in your menus and other applications like Chrome. One of the ways an Electron app quickly jumps into the uncanny valley is by accidentally triggering a text selection or highlight on what are supposed to be UI elements.

CSS has our back here, though; for any button, menu, or other item of UI text, just add the following:

     .my-ui-text {

           *-webkit-user-select:none;*

       }

And the text will simply not be selectable anymore. It will feel much more like a native application. A little tip to check this: simply press ctrl/cmd + A to select all selectable text in your app. Then you can quickly spot the items you still need to disallow selection on.

### 1.3 You need three icons for three platforms

Really, this is just super inconvenient. On Windows, you need an .ico file, on macOS you need a .icns file and on Linux you need a .png file.



![facepalm.jpg](https://lh6.googleusercontent.com/_f669yBlzhJADMhMhrZtR3pwIRg5GhSmIHd_CvDWg_hL6UnpwfoxXHZ37Wl6XW4uBMzw8df2PNJeQsIQnkVO6LTrXyYduBljhCbel0SkU05DAlrR8rD1jRnrtRl_XDFtsKJEC6hl)



Luckily, the same, normal png can be used to generate the other two icons. Here's the most convenient way:

1\.  Start with a 1024x1024 pixel PNG. That means we're already 1/3rd of the way done. (Linux, check!)

2\.  For Windows, run it through [icotools](http://www.nongnu.org/icoutils/) to get an .ico:

   `icontool -c icon.png > icon.ico`

3\.  For macOS, run it through png2icns to get an icns:

   `png2icns icon.icns icon.png`

4\. You're done!

There are GUI tools available such as [img2icns](http://www.img2icnsapp.com/) on macOS and [iconverticons](https://iconverticons.com/online/) on Web, Windows and macOS but I have not used them.

### 1.4 Bonus!

electron-packager doesn't need the extension of the icon to pick the correct one for a given platform:

    $ electron-packager . MyApp *--icon=img/icon* --platform=all --arch=all --version=0.36.0 --out=../dist/ --asar

Of course, I only figured that one out after writing my own build script that selected the correct version of the icon. Oh well.

## **2\. White loading screens belong in browsers**

Nothing gives away the inherent __browseriness__ of an Electron app more than a white loading screen. Luckily there are two things we can do to combat that:

### 2.1 Specify a BrowserWindow background color

If your application has a non-white background color, make sure to specify it in your BrowserWindow options. This won't prevent the square-of-solid-color while your application loads, but at least it doesn't also change color halfway through:

     mainWindow = new BrowserWindow({

         title: 'ElectronApp',

         *backgroundColor: '#002b36',*

       };

### 2.2 Hide your application until your page has loaded:

Because we're actually in the browser, we can choose to hide the windows until we know all our resources have been loaded in. Upon starting, make sure to hide your browser window:

     var mainWindow = new BrowserWindow({

           title: 'ElectronApp',

           *show: false,*

       };

Then, when everything is loaded, show the window and focus it so it pops up for the user. You can do this with the "ready-to-show" event on your `BrowserWindow`, which is recommended, or the 'did-finish-load' event on your webContents.

     mainWindow.on('ready-to-show', function() {

           mainWindow.show();

           mainWindow.focus();

       });

You want to focus it to make the user aware that your application has loaded.

## **3\. Preserve your window dimensions and position**

Now, this is one that a lot of "native" apps get wrong as well, and I find it one of the most annoying things ever. It drives me up the wall when a carefully positioned app, upon a next launch, simply resets it position and dimensions back to whatever default the app developer thought would be reasonable. Don't do that.

Instead, save the window’s position and dimensions and restore them on each launch. Your users will thank you.

### 3.1 Prebuilt solutions

There are two prebuilt solutions that solve this for you, called [electron-window-state](https://www.npmjs.com/package/electron-window-state) and [electron-window-state-manager](https://www.npmjs.com/package/electron-window-state-manager). Both of them work, have good documentation and take care of edge cases such as maximised applications. If you're in a hurry, use these.

### 3.2 Roll your own

You can also roll your own, and that's what I did, based on code I had already made for [Trimage](https://trimage.org) a few years ago. It's not a lot of work and it gives you a lot of control. I'll show you:

#### 3.2.1 Get something to save your state to

First off, we need to be able to store the position and dimensions of our application somewhere. You can use [Electron-settings](https://github.com/nathanbuchar/electron-settings) which does it very well, but I chose to use [node-localstorage](https://www.npmjs.com/package/node-localstorage) because of its simplicity.

    var JSONStorage = require('node-localstorage').JSONStorage;

       var storageLocation = app.getPath('userData');

       global.nodeStorage = new JSONStorage(storageLocation);

If you save your data to _`getPath('userData');`_ electron will store it alongside it's own application settings, in _`~/.config/YOURAPPNAME`_, or on Windows, in the appdata folder under your user.

#### 3.2.2 When opening your app, try to load in your state

    var windowState = {};

         try {

           windowState = global.nodeStorage.getItem('windowstate');

         } catch (err) {

           // the file is there, but corrupt. Handle appropriately.

         }

Of course this will not work on first launch so you need to deal with that. Probably by providing sensible defaults. Once you have your previous state in a javascript object, just use that information to set your BrowserWindow dimensions:

    var mainWindow = new BrowserWindow({

         title: 'ElectronApp',

         x: windowState.bounds && windowState.bounds.x || undefined,

         y: windowState.bounds && windowState.bounds.y || undefined,

         width: windowState.bounds && windowState.bounds.width || 550,

         height: windowState.bounds && windowState.bounds.height || 450,

       });

As you can see, I add the sensible default in here by providing a fallback value.

Now in Electron, it's not possible to start a window in its maximised state, so we need to do that straight after creating our BrowserWindow.

    // Restore maximised state if it is set.

       // not possible via options so we do it here

       if (windowState.isMaximized) {

         mainWindow.maximize();

       }

#### 3.2.3 Save your current state on move, resize and close:

In a perfect world you will only have to save your window state when closing the application, but that will miss all the times the application is terminated for some unknown reason (such as when the power cuts out).

Getting and saving the state on every move or resize event makes sure we always restore the last known position and dimensions.

     ['resize', 'move', 'close'].forEach(function(e) {

         mainWindow.on(e, function() {

           storeWindowState();

         });

       });

    And the storeWindowState function:

    var storeWindowState = function() {

         windowState.isMaximized = mainWindow.isMaximized();

         if (!windowState.isMaximized) {

           // only update bounds if the window isn't currently maximized

           windowState.bounds = mainWindow.getBounds();

         }

         global.nodeStorage.setItem('windowstate', windowState);

       };

The storeWindowState function has a little gotcha: If you minimise a native maximised window, it will revert to its _previous_ position. This means that when the window state is maximised we want to save that fact, but we don't then want to overwrite the previous (unmaximised) window dimensions so that if you maximise, close, re-open, and unmaximise, you will end up with the position your window had before maximising.

## **4\. Some quick fire tips**

Below are a couple of small, quick tips and tricks.

### 4.1 Shortcuts

In general, Windows and Linux users use Ctrl, while macOS users use Cmd for shortcuts. Instead of adding each shortcut (called an _Accelerator_ in Electron) twice, use "CmdOrCtrl" to target all platforms at once.

### 4.2 Use the ~~system font~~ San Francisco

Using the default system font means that your application can blend in with the rest of the OS. Instead of hardcoding it for each system separately, you can use the following CSS to automatically pick whatever font is the UI font on a system:

     body {

         font: caption;

       }

"caption" is a keyword in CSS that links to a platform-specified font.

### 4.3 System colors

Just like the system font, you can also choose to let the platform determine the colors of your application by using [System colors](http://www.sitepoint.com/css-system-styles/). These are actually deprecated in favor of not-yet-implemented Appearance value type in CSS3, but they're not going anywhere for the foreseeable future.

### 4.4 Layouting

CSS is an immensely powerful way to lay out applications, especially when you combine flexbox with `calc()`, but don't discount the work done in older GUI frameworks such as GTK, Qt or Apple Autolayout. You can create your app GUI in a similar way by using [Grid Stylesheets](https://gridstylesheets.org/) which is a constraint-based layout system.

## **Thanks!**

Building applications in Electron is a lot of fun and very rewarding: you can get something up and running on multiple platforms in a matter of minutes. If you've never looked into Electron I hope this article intrigued you enough to take a look. Their [website](http://electron.atom.io) has excellent documentation as well as a very cool demo app that lets you try out all the API’s on offer.

If you're already writing Electron applications, I hope the above encourages you to think about how your app runs on all platforms.

Lastly, If you have any additional tips, please share them in the comments!



