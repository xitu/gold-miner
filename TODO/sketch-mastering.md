> * 原文链接 : [Mastering Sketch 3 - Design+Code](https://designcode.io/sketch-mastering)
* 原文作者 : [Mastering Sketch ](https://designcode.io/sketch-mastering)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态 :  待定

## A Comprehensive Guide to Designing in Sketch

Over the last 3 years working with Sketch, I’ve learned a number of key techniques that helped me tremendously in my workflow. Using that experience, I released [3 UI Kits(https://designcode.io/ios9), which were downloaded over 300,000 times collectively. Because I enjoy prototyping and coding as well, I need a tool that can execute designs fast and that delivers assets effortlessly. I barely use Photoshop or Illustrator anymore. 99% of my job is focused on designing, animating and building user interfaces for Web and Mobile. Sketch, its plugins and other prototyping tools fulfill that role.

## New Features and Techniques

Sketch has grown tremendously since 3.0, [releasing updates(http://bohemiancoding.com/sketch/whats-new/) faster than its competitors to improve performance, stability and to introduce new features such as Local Sharing, Scissors and new iOS / Material Design templates. There are new Plugins that make Sketch more powerful than ever for working with adaptive layouts, style guides and prototyping: [Fluid(https://github.com/matt-curtis/Fluid-for-Sketch), [Magic Mirro(http://magicmirror.design/), [Content Generator(https://github.com/timuric/Content-generator-sketch-plugin), [Zeplin(https://zeplin.io/) and [Flinto(https://www.flinto.com/mac) just to name a few.

### Local Sharing

_With Local Sharing, you can export all your Artboards in a Web interface and share it to anyone on the same Wi-Fi as you. To remove the local restriction, use this [trick(https://medium.com/@thomasdegry/how-sketch-took-over-200gb-of-our-macbooks-cb7dd10c8163)._


![](https://designcode.io/cloud/sketch/Learn-LocalSharing.jpeg)


_As soon as you enable this feature, Sketch will start generating a Web page that shows all the Artboards and Pages of your document. Like this, whether the recipient is on their iPhone, iPad or Windows machine, they can open the link and view the entire design._

### Scissors

_Scissors is a powerful new tool that lets you quickly cut parts of a vector. For instance, a circle can be cut in half, then close its paths to reform a new shape. It requires far less steps than using Subtract or editing the vector points manually._ _Combined with Border Options, Vectorize Stroke and Flatten, you can create interesting new shapes, especially when it comes to using outlines. A lot of familiar icons out there may benefit this technique._

### New Templates

_The new iOS and Material Design templates are particularly comprehensive since **version 3.4**. Android also gets a new App Icon template. They’re a great starting point for any designer, beginners and experts alike. You don’t need to download anything since they’re preloaded in Sketch._


![](https://designcode.io/cloud/sketch/Sketch-iOSGUI.jpg)


_⬆︎ Sketch iOS UI Kit._


![](https://designcode.io/cloud/sketch/Sketch-MaterialDesign.jpg)


_⬆︎ Material Design UI Kit._


![](https://designcode.io/cloud/sketch/Sketch-AndroidIcon.jpeg)


_⬆︎ Android Icon Design_ _Templates make it easy to have a solid starting point and to respect strict design guidelines. For elements like the Status Bar, Tab Bar and icons, it is recommended to use them as a guide. To use them, go to **File** ➤ **New From Template**._


![](https://designcode.io/cloud/sketch/Screenshot%202015-10-03%2023.21.10.png)


_You can also store custom templates by downloading your own. [Facebook Design(http://facebook.github.io/design/), [Sketch App Sources](http://www.sketchappsources.com/) and [Sketch Repo](http://sketchrepo.com/) are some of favorite places for finding them. Once you download these templates, you can go to File > **Save as Template**._

## Border Options

_One of the most under-utilized features of Sketch is the border options, which is hidden in a small gear icon next to border styles. But you can do really cool things with it, like replicating the Apple Watch rings._ _Learn how to create the Apple Watch rings in the [Techniques](http://designcode.io/sketch-techniques) section._

### Background Blur

_iOS uses blur everywhere, from the Lock screen to the Notifications center. **Background Blur** is a feature unique to Sketch, and it’s extremely convenient. The blur is a dynamic sheet placed on top of multiple layers in the background. It updates in real-time as everything changes._ _Creating the exact same effect only requires you to create a Shape, set the Fill opacity to less than 100%, and change the blur to Background Blur. From there, you can customize the Blur strength. As you move the Blur layer, the layers underneath blur automatically. You can use Soft Light or Overlay to add interesting effects that replicate the Vibrancy in iOS._ _In addition to Background Blur, you have the usual **Gaussian**, **Motion** and **Zoom** blurs. Background Blur can be an expensive feature to the performance of Sketch, so don’t overuse it. Flatten to Bitmap whenever possible._

## Working with Vectors

_Vector is traditionally something that’s very hard to learn because you had to master the Bezier Curve and recreate complex shapes from scratch. Sketch makes this a little easier by combining simple shapes, rounding vector points and vectorizing borders. You can replicate 90% of all the icons found in iOS 9 by applying these basic techniques. Watch the [full video tutorial](http://designcode.io/sketch-vector)._


![](https://designcode.io/cloud/sketch/Vector-Points.jpg)


### Straight Point

_The Straight Point is as easy as drawing a straight line. If we stopped here, we’d only be able to draw perfect geometric shapes. Use **Shift** to draw perfectly straight lines._


![](https://designcode.io/cloud/sketch/Vector-Straight.jpg)


### Mirrored

_**Mirrored** is a symmetric bezier curve. As you change the **angle** or **distance** of one side, it’ll update the other side as well._


![](https://designcode.io/cloud/sketch/Vector-Mirrored.jpeg)


### Asymmetric

_Similar to Mirrored, Asymmetric will keep the same **angle**, but allows for a different **distance**._


![](https://designcode.io/cloud/sketch/Vector-Asymmetric.jpeg)


### Disconnected

_When the two handles are completely different, use **Disconnected**. You can even delete one handle and keep the other. This is especially useful when you have a sharp turn, followed by a curve._


![](https://designcode.io/cloud/sketch/Vector-Disconnected.jpeg)


### Open / Close Path

_When you begin a new Vector, it’ll be open. In other words, you can draw as many points as you want before it completes itself. When you’re ready to close the path, click on **Close Path**._ _If you wish to re-open the paths again, click on **Open Path**. Notice that it’ll open at the **last** point. Press **Alt** to show the first, which gives you an idea where the last point will be._

### Polygon Points

_You can quickly create a **Polygon** with as many points as you want. This only works with the Polygon shape._


![](https://designcode.io/cloud/sketch/Sketch-PolygonPoints.gif)


### Star Points and Radius

_The **Star** shape has not only Points, but Radius as well, which lets you design the perfect angle for your points._

## Duplicate and Transform

_A design tool is often measured by how easy it is to manipulate layers. It should be able to handle key tasks like duplicate, scale and transform in few steps. Luckily, Sketch has all those tools and more._

### Make Grid

_When I discovered this method, it really affected the way I worked. Make Grid makes it easy to duplicate anything, for any amount of copies in a grid style. You can set the spacing between the elements or have them enclosed in boxes before duplicating. This is specifically useful for handling List (Table View) and Grid (Collection View) interfaces, or simply rearrange layers in an orderly fashion. Make Grid also works on Artboards._

### Perspective Transform

_The Transform tool may be harder to use than in your typical vector tool such as Illustrator, but it works if done right. Plus, you don’t have to switch between two applications._ _First, make sure to **Convert to Outlines** every text layer. Also, ungroup everything since Transform won’t work on Groups. Finally, select all the layers together and do Transform (**Cmd Shift T**). The beautiful thing about this is everything will be kept in vector._

### Scale Tool

_One of my favorite tools in Sketch is the Scale tool (**Cmd K**). Note that this isn’t the same as resizing, since it actually scales every property: Size, Radius, Border, Shadow and Inner Shadow. For instance, a 1 px border scaled at 200% will be 2 px. By only resizing, it’ll remain 1 px. This will be indispensable for converting **@1x** UI Kits to **@2x** or **@3x**, as it even works with Artboards._

## Alignment, Distances and Guides

_There are many tools in Sketch that will help you design with incredible precision. You can never have too much precision. Designers would have a hard time working without rulers and grids, because they’re essential to keeping the composition organized and clean._


![](https://designcode.io/cloud/sketch/Sketch-Alignment.jpeg)


### Smart Guides

_Smart Guides are intrinsic to the experience of using Sketch. In fact, it’s an essential feature in most apps where drawing is involved. As soon as you start dragging in a layer, red lines will appear to indicate if it's well-aligned or centered properly. Unique to Sketch, you’ll see Smart Guides appearing even before you start drawing, enabling incredible precision._


![](https://designcode.io/cloud/sketch/Keyboard-Insert.gif)


### Distances

_Holding the **Alt** key will show the distances between the selected layer against other ones in the same Group or Artboard. It also measures the distances to the Artboard itself. It’s important to mouse over different elements to see the distances._


![](https://designcode.io/cloud/sketch/Keyboard-Distances.gif)


_**Tip**: Distances can work against Rulers as well._


![](https://designcode.io/cloud/sketch/Learn-DistancesRuler.gif)


### Align and Distribute Objects

_As you create new shapes, you can instantly align them horizontally or vertically within the Artboard. When two layers are selected, they can also align with each other._ _Distribute Objects allows you to normalize the distances between multiple layers._

### Rulers

_Rulers can be enabled by pressing **Ctrl R**. They’re good for setting persistent guides that can be snapped or measured against your layers. To create a guide, simply click within the Ruler regions. **Hold Shift** to jump by 10 px._


![](https://designcode.io/cloud/sketch/Keyboard-Rulers.gif)


_In the Editor, You can even get the distances between a layer and a Ruler guide by holding the **Alt** key and hovering the guide._

### Layout


![](https://designcode.io/cloud/sketch/Sketch-LayoutSettings.jpeg)


_If you open Layout Settings, you’ll find a way to set up your own Layout Grid system, such as the famous [960grid](http://960.gs/). With this, setting up 2, 3 or 4 columns proportionally is as easy as snapping the layers to the grids. Layout Grids are particularly useful for bigger screens that occupy multiple columns and call for clean divisions. Examples are Web, iPad and tvOS interfaces._

### Grids


![](https://designcode.io/cloud/sketch/Sketch-Material-Design%202.jpeg)


_Enable Grids (**Ctrl G**) to divide your canvas perfectly. For instance, Material Design encourages a 8 dp grid system in order for shapes, text and baselines to fall perfectly into those lines. This promotes better spacing and cleanly divided layouts._


![](https://designcode.io/cloud/sketch/Design-SpacingAlign.jpg)


_For iOS, the guidelines are not as strict. Mostly, you are encouraged to have a minimum padding and margin of 8 pt._

### Pixels Grid

_Use **Show Pixels** (**Ctrl P**) to make sure that your design is pixel perfect. Pixels will only be visible at more than 100% zoom if enabled. If you zoom at 1000% or more, you can see the Pixels Grid automatically._


![](https://designcode.io/cloud/sketch/Vector-BezierCurve%202.jpeg)


## Preferences

_You may want to customize some preferences. Here are the key options that will likely affect your workflow later on._

### Auto-Save

_I highly recommend Auto-Save. It will automatically save all your changes as you design, preventing you from losing precious work in case of crashes, power outage or accidental quitting. Please note that Auto-Save may be dangerous if fonts are missing or team mates open your files and make changes to them. That may lead to unintended modifications. Also, be wary of the [disk space cost](https://medium.com/@thomasdegry/how-sketch-took-over-200gb-of-our-macbooks-cb7dd10c8163), especially if you happen to work with large bitmaps._


![](https://designcode.io/cloud/sketch/Sketch-Auto-Save.jpeg)


### Reverting To Old Versions

_With Auto-Save enabled, Sketch will create a version history of your documents. In case mistakes happen (and they will happen), you can revert back to an older version of your Sketch file. Since Sketch 3.4, you can disable this feature._

### Pixel Fitting

_As a result of working with vectors, new shapes may not always land on the pixel grid as you create them, making them not as sharp as they should be (to enable Show Pixels, press **Ctrl + p**). As you align or resize, this option will make sure that your pixels stay sharp._


![](https://designcode.io/cloud/sketch/Sketch-PixelFitting.gif)


### Sub-Pixel Anti-Alias Fonts

_Sub-pixel Antialias makes your typefaces unnaturally thicker in exchange for increased readability. That was useful at a time when monitors were small and didn’t have a Retina resolution. Today, as screens are infinitely better and texts are bigger, this option will only make your fonts inaccurate to the true rendering, especially for mobile devices. In Sketch’s Preferences (**⌘,**), you can disable it by going to **Canvas**._


![](https://designcode.io/cloud/sketch/Sketch-Preferences.jpeg)


### Artboards within Artboard

_When you work with dozens of screens, you can have a great overview of the whole experience. You may also have Artboards within an Artboard, allowing you to quickly export the entire flow._


![](https://designcode.io/cloud/sketch/Sketch-Arboards-All.jpeg)


### Artboard Background

_To select the Artboard, you must select the title above it. An Artboard may have a background color, otherwise the resulting screen will show a transparent background instead of what seems to be white._


![](https://designcode.io/cloud/sketch/Sketch-Artboard-Options%202.jpeg)


## Color Picker

_Colors are easy to work with in Sketch. As explained in the [Colors](http://designcode.io/colors) section, you can switch from **RGB** to **HSB**, a more intuitive way to manipulate colors. Like this, you are in control of how much Hue, Saturation and Brightness you need._


![](https://designcode.io/cloud/sketch/Sketch-HSBA.gif)


### Quick Eyedropper

_The **Eyedropper** tool (shortcut: **Ctrl + C**) allows you to quickly pick colors within the document, or even outside the bounds of the application. The magnifying glass will increase the precision._


![](https://designcode.io/cloud/sketch/Sketch-EyeDropper.gif)


### Frequently Used Colors

_Sketch will automatically detect the colors used inside your document. To access it, click on the color itself. Colors will be ordered by how many times they were used._


![](https://designcode.io/cloud/sketch/Sketch-FrequentColors.gif)


### Color Palettes

_**Global Colors** are shared across all your Sketch documents. On the other hand, **Document Colors** are document-specific. There’s a [good plugin](https://github.com/andrewfiorillo/sketch-palettes "Sketch Palettes") for saving your own palettes, or download from other designers. I made one using iOS, Material Design and FlatUI. You can download it [here](http://cl.ly/2k1g3h1w1c1y)._


![](https://designcode.io/cloud/sketch/Sketch-ColorPalettes.jpeg)


### Gradients

_In the same window as the Color Picker, you can switch to the **Gradients** Tab. In iOS, gradients are often used for app icons, backgrounds and buttons (combined with blur and vibrancy) to add a sense of depth. On the Mac, they’re even more [prevalent](http://www.sketchappsources.com/free-source/1387-yosemite-icons-pack-sketch-freebie-resource.html)._


![](https://designcode.io/cloud/sketch/Sketch-Gradients-Examples.jpg)


_You can edit your gradient by dragging the ends of the sliders. You can also rotate, or add new gradient points by double-clicking in the slider._ _**Radial Gradients** are typically used for large backgrounds to give a more realistic spotlight. You can achieve interesting results by dragging the points outside the bounds of the canvas._ _**Angular Gradients** are especially handy for circular shapes’s backgrounds like those on the Apple Watch._

### Patterns

_Patterns can be used to repeat a **Tile** design and create interesting backgrounds by using a tiny image. I often use this feature in combination with the [Content Generator Plugin](https://github.com/timuric/Content-generator-sketch-plugin) to quickly set up avatars and image backgrounds by using the **Fill** option._ _There's this [great site](http://thepatternlibrary.com/) lets you use their library of gorgeous patterns._

### Noise

_If you want to replicate dust, paper or aluminium textures for presentations or to serve as an image background, then use the Noise fill at a very low opacity. Additionally, you can use Overlay or Soft Light to blend the colors even better._

## Exporting Assets

_Perhaps my favorite feature is the ability to easily export at multiple screen resolutions, at **1x**, **2x**, **3x**, or any custom resolution. If you have troubles understanding pixel densities, filenames and formats, read the [full tutorial](http://designcode.io/sketch-exporting)._

### Designing in 1x


![](https://designcode.io/cloud/sketch/Assets-Designing1x.jpg)


_When you're designing in Sketch, you need to be aware of the pixel density that you're designing in. Ever since the introduction of **@3x** screens (iPhone 6 Plus), most designers are going back to designing in **1x**. That way, exporting assets for all 3 pixel densities is easier and far more accurate. For each asset, you need to create @1x, @2x and @3x files, so that they work on all iPhones and iPad devices._ _If you’re unsure with what Artboard to start with, go with the **iPhone 6 at 375 x 667**. That will effectively target most iPhone users today._

### Export Tricks

_If you drag out any Layer or Group out of the Sketch window, it’ll automatically create a **1x** PNG asset without the need to slice anything. If you want the slice to be in **2x** or **3x**, or another file format, just use Make Exportable before._

![](https://designcode.io/cloud/sketch/Assets-ExportFolder.gif

_If you name your Layer or Group **folder/asset**, it’ll automatically export to the folder name before the forward slash._


![](https://designcode.io/cloud/sketch/Assets-800w.jpg)


_When you use Make Exportable, you can set a **Max number** for width or height. For example, **800w** will export the asset to a maximum of 800 px wide._

## Keyboard Shortcuts and Tricks

Keyboard shortcuts play a major part in Sketch to boost your productivity while designing. You can save a few seconds per action, which really adds up as you perform them hundreds of times per day.

Here are all the 80+ Keyboard Shortcuts, excluding the contextual shortcuts such as those in the Inspector and Layers List. Download the [Apple Keyboard](http://cl.ly/0f32133Y1l2g).


![](https://designcode.io/cloud/sketch/Keyboard-Shortcuts.jpg)


### Select Any Layer Quickly

_When layers are grouped, you lose the ability to select specific layers. But there are 2 solutions:_

Select one level deeper inside a Group

Double-Click

Select any layer regardless of groups

⌘ Click

### Focus Layers

_Artboards and Layers can be quickly focused on. This is extremely useful for finding your layers._

Focus on all the elements in the screen

⌘ 1

Focus on the element selected

⌘ 2

### Layers and Groups

_It is recommended to always name your layers, and group (**⌘ G**) similar layers together. When you do, it is much easier to manage and organize your document._ _You can drag outside to export 1x PNG asset based on Layer, Group or Artboard. You may override that setting by using Make Exportable._


![](https://designcode.io/cloud/sketch/Keyboard-DragOut.gif)


### Expand and Collapse


![](https://designcode.io/cloud/sketch/Keyboard-LayersList.jpeg)


_As you work with hundreds of layers and nested groups, you’ll want to be able to find your layers quickly._ _**Alt Click Expand Arrow** to expand and collapse all Artboards and groups._

### Copy and Paste

_One of the convenient things about Sketch is that it plays really well with other Mac apps like Finder, Keynote, Pages and Mail. Copy any image or text to the **Clipboard** will allow you to paste them to Sketch._

Paste image or text

⌘ V

Paste in Place at position 0, 0 of selected layer

⌘ Shift V


Paste at the mouse cursor from center position

Right-Click > Paste Here

_Vice versa, you can copy any image or text Sketch to other apps. For apps like Keynote or Pages, it’ll copy the **vector** format, which makes it infinitely scalable._

### Emoji & Symbols

_Emojis are increasingly popular thanks to iOS and messaging apps. It is not uncommon to use them in demos and presentation screens. “Emojis & Symbols” (**Ctrl Cmd Space**) not only allows you to insert emojis but also all the other useful symbols. Note that this feature works across all Mac apps._


![](https://designcode.io/cloud/sketch/Sketch-Emojis.jpeg)


### Open Recent files

_If you long press the Sketch app icon on your Mac's dock, you get a list of the recent files you've opened._


![](https://designcode.io/cloud/sketch/Sketch-Recent.jpeg)


### Flatten to Bitmap

_The more Layers, Symbols, Blurred backgrounds you have, the slower Sketch may get. Transforming them to Bitmap can help performance greatly. With Bitmaps, you have the flexibility to use as a Fill background._

## Designing From Scratch

_If you wish to learn how to use Sketch from a blank canvas to a functional prototype, you can watch this [hour-long video tutorial](http://designcode.io/sketch-design)._


![](https://designcode.io/cloud/sketch/Scratch-Cover.jpeg)


## Quick Prototyping

_[Prototyping](http://designcode.io/sketch-flinto) animations can be a labour-intensive process, especially with tools that have a steep learning curve. For those who just don’t want to learn code, I think that [Flinto](http://flinto.com/mac) or [Principle](http://principleformac.com/) are perfect. They yield maximum results for little investment in time and efforts. Using their Sketch plugin, Flinto lets you import all your screens and do powerful animations in a matter of minutes._


![](https://designcode.io/cloud/sketch/Quick-Cover.jpeg)


## Plugins

_There are hundreds of Sketch plugins out there, and more released each week. These [plugins](http://designcode.io/sketch-plugins) are my absolute favorites for boosting my productivity in Sketch._

### Perspective Mockups

_I used to rely on Photoshop a lot to create design presentations like the ones found on Apple’s website. I found that having an attractive hero image sells your product better as long as it explains well how it functions._


![](https://designcode.io/cloud/sketch/Screenshot%202015-10-03%2020.32.59.jpg)


_With [Magic Mirror](http://magicmirror.design/), you have the ability to transform screens and place them on a beautiful photo or digital composition._


![](https://designcode.io/cloud/sketch/2015-10-03%2021_04_11.gif)


### Generating Content

_One thing that can take up a lot of time is to collect avatars and photos of people and places, and try to come up with meaningful names to make our designs more realistic. With [Content Generator](https://github.com/timuric/Content-generator-sketch-plugin), you can save a lot of hassle by quickly populating shape and text layers with a large content library._


![](https://designcode.io/cloud/sketch/2015-10-03%2020_28_43.gif)


### Working with Adaptive Layouts

_Ever since the iPhone 6 and Multi-tasking on the iPad became available, creating a layout that’s adaptive to multiple devices has never been this important. Up until now, we had to do all that work inside Xcode or in a Web editor._ _However, thanks to the [Fluid(https://github.com/matt-curtis/Fluid-for-Sketch) plugin, you can now edit the position and size of your UI elements and the layout will automatically update. Download the [Sketch file](http://cl.ly/0I213k3a360N)._

### Creating a Style Guide with Zeplin

_Documentations are time-consuming and often don’t pay back quite as well. You have to spend days or weeks on them, then keep them updated manually. With each update, you have to inform your whole team about them. It’s like a major project on its own, and the rewards aren’t that great. That’s time that you could be spending on perfecting the project and getting real feedback from users._


![](https://designcode.io/cloud/sketch/Sketch-Zeplin.jpeg)


_That’s what [Zeplin](https://zeplin.io/) had set to solve. With their Sketch plugin, you can just export all your Artboards and the Mac app will automatically pick up alling specifications. When your team opens your designs in Zeplin, they get the latest updates, find all the sizes, distances and font properties right there. Additionally, developers will find the assets embedded and can even make comments on specific parts of your designs. Totally recommend this one!_
