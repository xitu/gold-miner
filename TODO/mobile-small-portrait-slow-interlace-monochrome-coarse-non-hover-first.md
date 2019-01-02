> * 原文地址：[Mobile, Small, Portrait, Slow, Interlace, Monochrome, Coarse, Non-Hover, First](https://css-tricks.com/mobile-small-portrait-slow-interlace-monochrome-coarse-non-hover-first/)
> * 原文作者：本文已获原作者 [ANDRÉS GALANTE](https://css-tricks.com/author/agalante/) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Mobile, Small, Portrait, Slow, Interlace, Monochrome, Coarse, Non-Hover, First #

A month ago I [explored the importance of relying on Interaction Media Features](https://css-tricks.com/touch-devices-not-judged-size/) to identify the user's ability to hover over elements or to detect the accuracy of their pointing device, meaning a fine pointer like a mouse or a coarse one like a finger.

But it goes beyond the input devices or the ability to hover; the screen refresh rate, the color of the screen, or the orientation. Making assumptions about these factors based on the width of the viewport is not reliable and can lead to a broken interface.

I'll take you on a journey through the land of [Media Query Level 4](https://www.w3.org/TR/mediaqueries-4/#color-gamut) and explore the opportunities that the [W3C CSS WG](https://www.w3.org/Style/CSS/members.en.php3) has drafted to help us deal with all the device fruit salad madness.

### Media queries ###

Media queries, in a nutshell, inform us about the context in which our content is being displayed, allowing us to scope and optimize our styles. Meaning, we can display the same content in different ways depending on the context.

The [Media Queries Level 4 spec](https://www.w3.org/TR/mediaqueries-4/) answers two questions:

- What is the device viewport size and resolution?
- What is the device capable of doing?

We can detect the device type where the document is being displayed using the media type keywords `all`, `print`, `screen` or `speech` or you can get more granular using Media Features.

### Media Features ###

Each Media Feature tests a single, specific feature of the device. There are five types:

- [Screen Dimensions Media Features](https://www.w3.org/TR/mediaqueries-4/#mf-dimensions) detect the viewport size and orientation.
- [Display Quality Media Features](https://www.w3.org/TR/mediaqueries-4/#mf-display-quality) identify the resolution and update speed.
- [Color Media Features](https://www.w3.org/TR/mediaqueries-4/#mf-colors) spot the amount of colors a device is capable to displaying.
- [Interaction Media Features](https://www.w3.org/TR/mediaqueries-4/#mf-interaction) find if a device is able to hover and the quality of its input device.
- [Scripting Media Features](https://www.w3.org/TR/mediaqueries-4/#mf-scripting) recognize if scripting languages, for example javascript, are supported.

We can use these features on their own or combine them using the keyword `and` or a comma to mean "or". It's also possible to negate them with the keyword `not`. 

For example:

```
@media screen and ((min-width: 50em) and (orientation: landscape)), print and (not(color)){
	...
	}
```

Scopes the styles to landscape orientated screens that are less than or equal to `50em` wide, or monochrome print outputs.

The best way to understand something is by actually doing it. Let's delve into the corner cases of a navigation bar to test these concepts.

### The Unnecessarily Complicated Navbar ###

One of the best pieces of advice that Brad Frost gave us on "[7 Habits of Highly Effective Media Queries](http://bradfrost.com/blog/post/7-habits-of-highly-effective-media-queries/)" is not to go overboard.

> The more complex we make our interfaces the more we have to think in order to properly maintain them. - [Brad Frost](http://bradfrost.com/)

And that's exactly what I'm about to do. Let's go overboard!

Be aware that the following demo was designed as an example to understand what each Media Feature does: if you want to use it (and maintain it), do it at your own risk (and [let me know](https://twitter.com/andresgalante)!).

With that in mind, let's start with the less capable smaller experience, also know as "The mobile, small, portrait, slow, interlace, monochrome, coarse, non-hover first" approach.

### The HTML structure ###

To test the media query features, I started with a very simple structure. On one side: a `header` with an `h1` for a brand name and a `nav` with an unordered list. On the other side: a `main` area with a placeholder title and text.

```
HTML

<div class="container">
  <header role="banner">
    <h1>Brand Name</h1>
    <nav>
      <ul>
        <li><a href="#main">Home</a></li>
        <li><a href="/about">About</a></li>
        <li><a href="/products">Products</a></li> 
        <li><a href="/login">Login</a></li>
      </ul> 
    </nav> 
  </header>
  <main id="main">
    <h2>Content goes here</h2>
    
    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Consectetur deserunt, suscipit velit itaque vitae necessitatibus, impedit pariatur eos. Pariatur beatae sed repellendus iusto doloribus quidem asperiores quia exercitationem sint dicta!</p>
    
  </main>
</div>
```

```
Result

Brand Name

Home
About
Products
Login
Content goes here

Lorem ipsum dolor sit amet, consectetur adipisicing elit. Consectetur deserunt, suscipit velit itaque vitae necessitatibus, impedit pariatur eos. Pariatur beatae sed repellendus iusto doloribus quidem asperiores quia exercitationem sint dicta!
```

### Default your CSS for less capable devices and smaller viewport ###

As I mentioned before, we are thinking of the less capable smaller devices first. Even though we are not scoping styles yet, I am considering an experience that is:

- `max-width: 45em` small viewport, less than or equal to 45em wide
- `orientation: portrait` portrait viewport, height is larger than width
- `update: slow`  the output device is not able to render or display changes quickly enough for them to be perceived as a smooth animation.
- `monochrome` all monochrome devices
- `pointer: coarse` the primary input mechanism has limited accuracy, like a finger
- `hover: none` indicates that the primary pointing system can't hover

Let's take care of positioning. For portrait, small, touchscreen devices, I want to pin the menu at the bottom of the viewport so users have comfortable access to the menu with their thumbs.

```
nav {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
}
```

Since we are targeting touchscreen devices, it is important to increase the touch target. On [Inclusive Design Patterns](https://www.smashingmagazine.com/inclusive-design-patterns/), [Heydon Pickering](https://twitter.com/heydonworks) mentions that it's still unclear what the magical size of a touch area is, different vendors recommend different sizes. 

Pickering mentions Anthony Thomas's [article about finger-friendly experiences](http://uxmovement.com/mobile/finger-friendly-design-ideal-mobile-touch-target-sizes/) and Patrick H Lauke research for [The W3C Mobile Accessibility Taskforce into touch / pointer target size](https://www.w3.org/WAI/GL/mobile-a11y-tf/wiki/Summary_of_Research_on_Touch/Pointer_Target_Size), and the main takeaway is, "...to make each link larger than the diameter of an adult finger pad".

That's why I've increased the height of the menu items to `4em`. Since this is not scoped, it'll be applied to any viewport size, so both large touchscreen devices like an iPad Pro and tiny smartphones alike will have comfortable touch targets.

```
li a {
  min-height: 4em;
}
```

To help readability on monochromatic or slow devices, like a Kindle, I haven't removed the underlines from links or added animations. I'll do that later on.

```
 HTML
 
 <div class="container">
  <header role="banner">
    <h1>Brand Name</h1>
    <nav>
      <ul>
        <li><a href="#main">Home</a></li>
        <li><a href="/about">About</a></li>
        <li><a href="/products">Products</a></li> 
        <li><a href="/login">Login</a></li>
      </ul> 
    </nav> 
  </header>
  <main id="main">
    <h2>Content goes here</h2>
    
    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Consectetur deserunt, suscipit velit itaque vitae necessitatibus, impedit pariatur eos. Pariatur beatae sed repellendus iusto doloribus quidem asperiores quia exercitationem sint dicta!</p>
    
  </main>
</div>

CSS

/* Defuault styles:
width: narrow,
orientation: portrait, 
update: slow,
scan: interlace,
monochrome: 1,
pointer: coarse, 
hover: none
*/

/* Positions the navbar at the bottom for easy thumb access on small devices with portrait orientation */ 
h1, nav{
  position: fixed;
  left: 0;
  right: 0; 
}

/* Creates large touch areas for finguers (coarse) */
li a {
  min-height: 4em;
}

/* Moves the main area to accomodate fixed header and navbar */
main {
  padding: 1em;
  padding-bottom: 5em;
  padding-top: 5em;
}

/* Mobile first: Accomodates the brand name on the left and the navigation on the right and it wraps without the need of width media queries */
header {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
}

/* Center aligns the brand name */
h1 {
  display: flex;
  min-height: 2.5em;
  align-items: center;
  flex: 1 0 auto;
  padding-left: 1em;
  padding-right: 1em;
}

/* Flex items to make them streach */
nav {
  bottom: 0;
  display: flex;
  flex: 1 0 auto;
}

ul, li, li a {
 display: flex;
 flex: 1;
}

li a {
  flex: 1;
  align-items: center;
  justify-content: center;
  padding-left: 1em;
  padding-right: 1em;
  border-left: 1px solid black;
}

li:first-child a {
  border: none;
}


/* General make up: colors, fonts, etc */
html, body, .container { box-size: border-box; height: 100vh; }
body { font-family: sans-serif; line-height: 1.5; }
header { background: #393f44; border-top: 4px solid #00a8e1; color: white; }
nav { background: #292e34; }
h1 { background: #030303; font-weight: bold; }
li a { color: #ccc; }
li a:hover { background: #393f44; color: white }
h2, p { margin-bottom: 1em; }
h2 {font-weight: 700; }

Result

Brand Name

Content goes here

Lorem ipsum dolor sit amet, consectetur adipisicing elit. Consectetur deserunt, suscipit velit itaque vitae necessitatibus, impedit pariatur eos. Pariatur beatae sed repellendus iusto doloribus quidem asperiores quia exercitationem sint dicta!

Home  About  Products  Login
```

![](https://cdn.css-tricks.com/wp-content/uploads/2017/04/portrait-phones.jpg)

### Small landscape viewports, vertical large displays, or mouse pointers ###

For landscape viewports `orientation: landscape`, large portrait viewports like vertical monitors or tablets `min-width: 45em`, or small portrait devices with fine pointers like a stylus `pointer: fine`, users will no longer be using their thumbs on a handheld device; that's why I unpinned the menu and put it at the top right of the header.

```
@media (orientation: landscape), (pointer: fine), (min-width: 45em) {
  main {
    padding-bottom: 1em;
    padding-top: 1em;
  }
  h1, nav {
    position: static;
  }
}
```

Since the menu and the brand name are already flexed and stretched, then they'll accommodate themselves nicely.

For users that have a fine pointer like a mouse or a stylus, we want to decrease the hit target to gain the real estate on the main area:

```
@media (pointer: fine) {
  h1, li a {
    min-height: 2.5em;
  }
}
```

```
HTML

 <h1>Brand Name</h1>
    <nav>
      <ul>
        <li><a href="#main">Home</a></li>
        <li><a href="/about">About</a></li>
        <li><a href="/products">Products</a></li> 
        <li><a href="/login">Login</a></li>
      </ul> 
    </nav> 
  </header>
  <main id="main">
    <h2>Content goes here</h2>
    
    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Consectetur deserunt, suscipit velit itaque vitae necessitatibus, impedit pariatur eos. Pariatur beatae sed repellendus iusto doloribus quidem asperiores quia exercitationem sint dicta!</p>
    
  </main>
</div>

CSS
/* Detaches the fixed header and navbar for landscape viewports, fine pointers like a mouse and large screens */
@media (orientation: landscape), (pointer: fine), (min-width: 45em) {
  main {
    padding-bottom: 1em;
    padding-top: 1em;
  }
  h1, nav {
    position: static;
  }
}

/* Makes hit areas smaller for fine pointers like a mouse to gain viewport realestate */
@media (pointer: fine) {
  li a {
    min-height: 2.5em;
  }
}


/* General make up: colors, fonts, etc */
html, body, .container { box-size: border-box; height: 100vh; }
body { font-family: sans-serif; line-height: 1.5; }
header { background: #393f44; border-top: 4px solid #00a8e1; color: white; }
nav { background: #292e34; }
h1 { background: #030303; font-weight: bold; }
li a { color: #ccc; }
li a:hover { background: #393f44; color: white }
h2, p { margin-bottom: 1em; }
h2 {font-weight: 700; }

Result

Brand Name   Home  About   Products   Login

Content goes here

Lorem ipsum dolor sit amet, consectetur adipisicing elit. Consectetur deserunt, suscipit velit itaque vitae necessitatibus, impedit pariatur eos. Pariatur beatae sed repellendus iusto doloribus quidem asperiores quia exercitationem sint dicta!
```


![](https://cdn.css-tricks.com/wp-content/uploads/2017/04/IMG_5446.jpg) 

### Vertical nav for large landscape viewports ###

Vertical navigations are great for large landscape viewports `(orientation: landscape) and (min-width: 45em)`, like a tablet or a computer display. To do that I'll flex the container:

```
@media (orientation: landscape) and (min-width: 45em) {
  .container {
    display: flex;
  }
  ...
}
```

Notice that hit targets have nothing to do with the size of the viewport or style of navigation. If the user is on a large touchscreen device with a vertical tab, they'll see larger targets regardless of the size of the width of the screen.

```
HTML

<div class="container">
  <header role="banner">
    <h1>Brand Name</h1>
    <nav>
      <ul>
        <li><a href="#main">Home</a></li>
        <li><a href="/about">About</a></li>
        <li><a href="/products">Products</a></li> 
        <li><a href="/login">Login</a></li>
      </ul> 
    </nav> 
  </header>
  <main id="main">
    <h2>Content goes here</h2>
    
    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Consectetur deserunt, suscipit velit itaque vitae necessitatibus, impedit pariatur eos. Pariatur beatae sed repellendus iusto doloribus quidem asperiores quia exercitationem sint dicta!</p>
    
  </main>
</div>

CSS

HTML  CSS  Result
EDIT ON
 /* Defuault styles:
width: narrow,
orientation: portrait, 
update: slow,
scan: interlace,
monochrome: 1,
pointer: coarse, 
hover: none
*/

/* Creates large touch areas for finguers (coarse) */
li a {
  min-height: 4em;
}

/* Positions the navbar at the bottom for easy thumb access on small devices with portrait orientation */ 
h1, nav{
  position: fixed;
  left: 0;
  right: 0; 
}

/* Moves the main area to accomodate fixed header and navbar */
main {
  padding: 1em;
  padding-bottom: 5em;
  padding-top: 5em;
}

/* Mobile first: Accomodates the brand name on the left and the navigation on the right and it wraps without the need of width media queries */
header {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
}

/* Center aligns the brand name */
h1 {
  display: flex;
  min-height: 2.5em;
  align-items: center;
  flex: 1 0 auto;
  padding-left: 1em;
  padding-right: 1em;
}

/* Flex items to make them streach */
nav {
  bottom: 0;
  display: flex;
  flex: 1 0 auto;
}

ul, li, li a {
 display: flex;
 flex: 1;
}

li a {
  flex: 1;
  align-items: center;
  justify-content: center;
  padding-left: 1em;
  padding-right: 1em;
  border-left: 1px solid black;
}

li:first-child a {
  border: none;
}

/* Detaches the fixed header and navbar for landscape viewports, fine pointers like a mouse and large screens */
@media (orientation: landscape), (pointer: fine), (min-width: 45em) {
  main {
    padding-bottom: 1em;
    padding-top: 1em;
  }
  h1, nav {
    position: static;
  }
}

/* Makes hit areas smaller for fine pointers like a mouse to gain viewport realestate */
@media (pointer: fine) {
  li a {
    min-height: 2.5em;
  }
}


/* Creates a vertical navigation on large landscape viewports */
  @media (orientation: landscape) and (min-width: 45em) {
  .container {
    display: flex;
  }

  header {
    display: block;
    flex: 0 0 20%;
  }
    
  header h1{
    min-height: 6em;
  }
    
  ul, li {
    display: block;
  }

  li a, li:first-child a {
    justify-content: start;
    border-left: 0;
    border-bottom: 1px solid black;
  } 
}

/* General make up: colors, fonts, etc */
html, body, .container { box-size: border-box; height: 100vh; }
body { font-family: sans-serif; line-height: 1.5; }
header { background: #393f44; border-top: 4px solid #00a8e1; color: white; }
nav { background: #292e34; }
h1 { background: #030303; font-weight: bold; }
li a { color: #ccc; }
li a:hover { background: #393f44; color: white }
h2, p { margin-bottom: 1em; }
h2 {font-weight: 700; }

Result

Brand Name  Home   About  Products   Login

Content goes here

Lorem ipsum dolor sit amet, consectetur adipisicing elit. Consectetur deserunt, suscipit velit itaque vitae necessitatibus, impedit pariatur eos. Pariatur beatae sed repellendus iusto doloribus quidem asperiores quia exercitationem sint dicta!
```

![](https://cdn.css-tricks.com/wp-content/uploads/2017/04/IMG_5479.jpg) 

### Animations, decorations and edge cases ###

Animations are a great way to [enhance interactions](https://material.io/guidelines/motion/material-motion.html#) and help users achieve their goals quickly and easily. But some devices are incapable of producing smooth animations - like e-readers. That's why I am limiting animations to devices that are capable of generating a good experience `(update: fast), (scan: progressive), (hover: hover)`.

```
@media (update: fast), (scan: progressive), (hover: hover) {
  li a {
    transition: all 0.3s ease-in-out;
  }
}
```

I am also removing the text decoration on color devices:

```
@media (color) {
  li a { text-decoration: none; }
}
```

Removing underlines (via `text-decoration`) is tricky territory. Our accessibility consultant Marcy Sutton put it well:

> Some users really benefit from link underlines, especially in body copy. But since these particular links are part of the navigation with a distinct design treatment, the link color just needs [adequate contrast](https://www.w3.org/TR/WCAG20-TECHS/F73.html) from the background color for users with low vision or color blindness.

![](https://cdn.css-tricks.com/wp-content/uploads/2017/05/contrast.png) 

We made sure the colors had enough [color contrast](http://webaim.org/resources/contrastchecker/) to pass WCAG AAA.

I'm also increasing the border width to 2px to avoid "[twitter](https://en.wikipedia.org/wiki/Interlaced_video#Interline_twitter)" (real term!) on interlace devices like plasma TVs:

```
@media (scan: interlace) {
  li a, li:first-child a {
    border-width: 2px;
  }
}
```

And here is the final result:

```
HTML

<div class="container">
  <header role="banner">
    <h1>Brand Name</h1>
    <nav>
      <ul>
        <li><a href="#main">Home</a></li>
        <li><a href="/about">About</a></li>
        <li><a href="/products">Products</a></li> 
        <li><a href="/login">Login</a></li>
      </ul> 
    </nav> 
  </header>
  <main id="main">
    <h2>Content goes here</h2>
    
    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Consectetur deserunt, suscipit velit itaque vitae necessitatibus, impedit pariatur eos. Pariatur beatae sed repellendus iusto doloribus quidem asperiores quia exercitationem sint dicta!</p>
    
  </main>
</div>

CSS

/* Defuault styles:
width: narrow,
orientation: portrait, 
update: slow,
scan: interlace,
monochrome: 1,
pointer: coarse, 
hover: none
*/

/* Creates large touch areas for finguers (coarse) */
li a {
  min-height: 4em;
}

/* Positions the navbar at the bottom for easy thumb access on small devices with portrait orientation */ 
h1, nav{
  position: fixed;
  left: 0;
  right: 0; 
}

/* Moves the main area to accomodate fixed header and navbar */
main {
  padding: 1em;
  padding-bottom: 5em;
  padding-top: 5em;
}

/* Mobile first: Accomodates the brand name on the left and the navigation on the right and it wraps without the need of width media queries */
header {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
}

/* Center aligns the brand name */
h1 {
  display: flex;
  min-height: 2.5em;
  align-items: center;
  flex: 1 0 auto;
  padding-left: 1em;
  padding-right: 1em;
}

/* Flex items to make them streach */
nav {
  bottom: 0;
  display: flex;
  flex: 1 0 auto;
}

ul, li, li a {
 display: flex;
 flex: 1;
}

li a {
  flex: 1;
  align-items: center;
  justify-content: center;
  padding-left: 1em;
  padding-right: 1em;
  border-left: 1px solid black;
}

li:first-child a {
  border: none;
}

/* Detaches the fixed header and navbar for landscape viewports, fine pointers like a mouse and large screens */
@media (orientation: landscape), (pointer: fine), (min-width: 45em) {
  main {
    padding-bottom: 1em;
    padding-top: 1em;
  }
  h1, nav {
    position: static;
  }
}

/* Makes hit areas smaller for fine pointers like a mouse to gain viewport realestate */
@media (pointer: fine) {
  li a {
    min-height: 2.5em;
  }
}


/* Creates a vertical navigation on large landscape viewports */
  @media (orientation: landscape) and (min-width: 45em) {
  .container {
    display: flex;
  }

  header {
    display: block;
    flex: 0 0 20%;
  }
    
  header h1{
    min-height: 6em;
  }
    
  ul, li {
    display: block;
  }

  li a, li:first-child a {
    justify-content: start;
    border-left: 0;
    border-bottom: 1px solid black;
  } 
}

/* Adds an animation on devices that are capable to render animations smoothly. Filters devices like Kindles, TVs, touch devices */
@media (update: fast), (scan: progressive), (hover: hover) {
  li a {
    transition: all 0.3s ease-in-out;
  }
}

/* Removes underlines on links for color screens */
@media (color) {
  li a { text-decoration: none; }
}

/* Increases borders to 2px on interlace screens like plasma TVs */
@media (scan: interlace) {
    li a, li:first-child a {
    border-width: 2px;
  }
}

/* General make up: colors, fonts, etc */
html, body, .container { box-size: border-box; height: 100vh; }
body { font-family: sans-serif; line-height: 1.5; }
header { background: #393f44; border-top: 4px solid #00a8e1; color: white; }
nav { background: #292e34; }
h1 { background: #030303; font-weight: bold; }
li a { color: #ccc; }
li a:hover { background: #393f44; color: white }
h2, p { margin-bottom: 1em; }
h2 {font-weight: 700; }

Result

Brand Name   Home  About  Products   Login

Content goes here

Lorem ipsum dolor sit amet, consectetur adipisicing elit. Consectetur deserunt, suscipit velit itaque vitae necessitatibus, impedit pariatur eos. Pariatur beatae sed repellendus iusto doloribus quidem asperiores quia exercitationem sint dicta!

```

### Test it out ###

Testing all this may not be that easy!. This example relies on flexbox, and some browsers have limited support for other modern CSS features. A Kindle, for example, won't read `@media`, `@support`, or flexbox properties.

I've added float fallbacks here:

```
HTML

<div class="container">
  <header role="banner">
    <h1>Brand Name</h1>
    <nav>
      <ul>
        <li><a href="#main">Home</a></li>
        <li><a href="/about">About</a></li>
        <li><a href="/products">Products</a></li> 
        <li><a href="/login">Login</a></li>
      </ul> 
    </nav> 
  </header>
  <main id="main">
    <h2>Content goes here</h2>
    
    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Consectetur deserunt, suscipit velit itaque vitae necessitatibus, impedit pariatur eos. Pariatur beatae sed repellendus iusto doloribus quidem asperiores quia exercitationem sint dicta!</p>
    
  </main>
</div>

CSS

/* Float fallback for browsers that don't support flex. This is not a full fallback for all cases. */

  h1, li a {
    min-height: 0;
    padding: .8em;
    display: block;
  }
  h1, nav {
    position: static;
  }
  main {
    display: block;
    padding: .8em;
  }

  /* floats instead of flex the navbar */
  li {
    float: left;
    width: 25%;
  }

  /* Clearfixes the nav unorder list */
  ul:after {
    content: "";
    display: table;
    clear: both;
  }

  /* Defuault styles:
  width: narrow,
  orientation: portrait,
  update: slow,
  scan: interlace,
  monochrome: 1,
  pointer: coarse,
  hover: none
  */

  /* Creates large touch areas for finguers (coarse) */
  @supports (display: flex) {
    li a {
      min-height: 4em;
    }

    /* Positions the navbar at the bottom for easy thumb access on small devices with portrait orientation */
    h1, nav{
      position: fixed;
      left: 0;
      right: 0;
    }

    /* Moves the main area to accomodate fixed header and navbar */
    main {
      display: block;
      padding: 1em;
      padding-bottom: 5em;
      padding-top: 5em;
    }
  }

  /* Mobile first: Accomodates the brand name on the left and the navigation on the right and it wraps without the need of width media queries */

  header {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
  }

  /* Center aligns the brand name */

  @supports (display: flex) {
    h1 {
      min-height: 2.5em;
      padding: 0 1em;
      display: flex;
      align-items: center;
      flex: 1 0 auto;
    }
  }

  /* Flex items to make them streach */
  nav {
    bottom: 0;
    display: flex;
    flex: 1 0 auto;
  }

  ul, li, li a {
    display: flex;
    flex: 1;
    text-align: center;
  }
  li a {
    border-left: 1px solid black;
  }

  @supports (display: flex) {
    li a {
      flex: 1;
      align-items: center;
      justify-content: center;
      padding: 0 1em;
      border-left: 1px solid black;
    }
  }
  li:first-child a {
    border: none;
  }

  /* Detaches the fixed header and navbar for landscape viewports, fine pointers like a mouse and large screens */
  @media (orientation: landscape), (pointer: fine), (min-width: 45em) {
    main {
      padding-bottom: 1em;
      padding-top: 1em;
    }
    h1, nav {
      position: static;
    }
  }

  /* Makes hit areas smaller for fine pointers like a mouse to gain viewport realestate */
  @media (pointer: fine) {
    li a {
      min-height: 2.5em;
    }
  }


  /* Creates a vertical navigation on large landscape viewports */
  @media (orientation: landscape) and (min-width: 45em) {
    .container {
      display: flex;
    }

    header {
      display: block;
      flex: 0 0 20%;
    }

    h1{
      min-height: 6em;
    }

    @supports (display: flex) {
      ul, li {
        display: block;
        float: none;
        width: auto;
      }
    }

    li a, li:first-child a {
      justify-content: start;
      border-left: 0;
      border-bottom: 1px solid black;
    }
  }

  /* Adds an animation on devices that are capable to render animations smoothly. Filters devices like Kindles, TVs, touch devices */
  @media (update: fast), (scan: progressive), (hover: hover) {
    li a {
      transition: all 0.3s ease-in-out;
    }
  }

  /* Removes underlines on links for color screens */
  @media (color) {
    li a { text-decoration: none; }
  }

  /* Increases borders to 2px on interlace screens like plasma TVs */
  @media (scan: interlace) {
    li a, li:first-child a {
      border-width: 2px;
    }
  }

  /* General make up: colors, fonts, etc */
  html, body, .container { box-size: border-box; height: 100vh; }
  body { font-family: sans-serif; line-height: 1.5; }
  header { background: #393f44; border-top: 4px solid #00a8e1; color: white; }
  nav { background: #292e34; }
  h1 { background: #030303; font-weight: bold; }
  li a { color: #ccc; }
  li a:hover { background: #393f44; color: white }
  h2, p { margin-bottom: 1em; }
  h2 {font-weight: 700; }
  
Result

Brand Name   Home   About   Products   Login

Content goes here

Lorem ipsum dolor sit amet, consectetur adipisicing elit. Consectetur deserunt, suscipit velit itaque vitae necessitatibus, impedit pariatur eos. Pariatur beatae sed repellendus iusto doloribus quidem asperiores quia exercitationem sint dicta!

```

![](https://cdn.css-tricks.com/wp-content/uploads/2017/04/IMG_5476.jpg)

You can open the [full page example](https://rawgit.com/andresgalante/test/master/test.html) in different devices, landscape, or portrait and test it out!

### How soon will we realistically be able to use all these features? ###

Now! That is, if you are ok offering different experiences on different browsers.

Today, Firefox doesn't support Interaction Media Queries. A Firefox user with a fine pointer mechanism, like a mouse, will see large hit areas reducing the main area real estate.

Browser support for [most of these features](http://caniuse.com/#feat=css-mediaqueries) is already available and support for [Interaction Media Features, support isn't bad](https://css-tricks.com/touch-devices-not-judged-size/#article-header-id-5)! I am sure that we will see it [supported across the board](http://caniuse.com/#feat=css-media-interaction) soon.

Remember to test as much as you can and don't assume that any of this will just work, especially in less capable or older devices.

### There is more! ###

I've covered some of the Media Features along the example, but I left others behind. For example the [Resolution Media Feature](https://www.w3.org/TR/mediaqueries-4/#resolution) that describes the resolution of the output device.

My goal is to make you think beyond your almighty MacBook or iPhone with a retina display. The web is so much more and it's everywhere. We have the tools to create the most amazing, flexible, inclusive, and adaptable experiences; let's use them.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
