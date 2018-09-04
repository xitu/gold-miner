> * 原文地址：[How to Build a Simple Chrome Extension in Vanilla JavaScript](https://medium.com/javascript-in-plain-english/https-medium-com-javascript-in-plain-english-how-to-build-a-simple-chrome-extension-in-vanilla-javascript-e52b2994aeeb)
> * 原文作者：[Sara Wegman](https://medium.com/@sarawegman?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-simple-chrome-extension-in-vanilla-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-simple-chrome-extension-in-vanilla-javascript.md)
> * 译者：
> * 校对者：

# How to Build a Simple Chrome Extension in Vanilla JavaScript

Today, I’m going to show you how to make Chrome extension in vanilla JavaScript — that is, plain JavaScript without any additional frameworks like React, Angular, or Vue.

Building a Chrome extension is very easy — in my first year of programming, I released two extensions, and I made both using just HTML, CSS, and plain JavaScript. In this article, I’ll walk you through how to the same in just a few minutes.

I’ll be showing you how to make a simple Chrome extension dashboard from scratch. If you have your own idea for an extension, however, and just want to know what to add to your existing project files to get it working in Chrome, you can skip down to the section on customizing your own `manifest.json` file and icon.

![](https://cdn-images-1.medium.com/max/2000/1*BOYvlX903vKaY8TI2JJFQA.png)

### About Chrome Extensions

A Chrome extension is essentially just a group of files that customizes your experience in the Google Chrome browser. There are a few different kinds of Chrome extensions; some activate when a certain condition is met, like when you’re on a store checkout page; some only pop up when you click on an icon; and some appear each time you open a new tab. Both of the extensions that I published this year are ‘new tab’ extensions; the first is [Compliment Dash](http://bit.ly/complimentdash), a dashboard that keeps a to-do list and compliments the user, and the second is a tool for pastors called [Liturgical.li](http://liturgical.li/). If you know how to code a basic website, then you can code this kind of extension without too much difficulty.

### Prerequisites

We’re going to keep things simple, so in this tutorial, we’ll just be using HTML, CSS, and some basic JavaScript, as well as customizing a `manifest.json` file that I’ll include below. Chrome extensions vary in complexity, so building a Chrome extension can be as simple or complicated as you want it to be. After you learn the basics here, you’ll be able to create something much more complicated using your own skillset.

### Setting Up Your Files

For this tutorial, we’re going to create a simple dashboard that greets the user by name. Let’s call our extension Simple Greeting Dashboard.

To get started, you’ll want to create three files: `index.html`, `main.css`, and `main.js`. Put these in their own folder. Next, fill the HTML file with basic HTML document setup, and connect it to the CSS and JS files:

```
<!-- =================================
Simple Greeting Dashboard
================================= //-->

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>Simple Greeting Dashboard</title>
  <link rel="stylesheet" type="text/css" media="screen" href="main.css" />
</head>
<body>
   <!-- My code will go here -->
   <script src="main.js"></script>
</body>
</html>
```

### Customizing Your manifest.json file

These files won’t be enough to get your project working as a Chrome extension. For that, we need a `manifest.json` file that we’ll customize with some basic information about our extension. You can download that file on [Google’s developer portal,](https://developer.chrome.com/extensions/getstarted) or just copy/paste the following lines into a new file and save it as `manifest.json` in your folder:

```
{
  "name": "Getting Started Example",
  "version": "1.0",
  "description": "Build an Extension!",
  "manifest_version": 2
}
```

Now, let’s update the sample file with a little more information about our extension. We’ll want to change only the first three values of this code: `name`, `version`, and `description`. Let’s fill in our name and a one-line description, and since this is our first version, let’s keep that value at 1.0. The `manifest_version` number should be kept the same.

Next, we’re going to add a few lines to tell Chrome what to do with this extension.

```
{
  "name": "Simple Greeting Dashboard",
  
  "version": "1.0",
  
  "description": "This Chrome extension greets the user each time they open a new tab",
  
  "manifest_version": 2
  "incognito": "split",
  
  "chrome_url_overrides": {
    "newtab": "index.html"
  },
  
  "permissions": [
     "activeTab"
   ],
"icons": {
    "128": "icon.png"
    }
}
```

The value `"incognito": "split"` tells Chrome what to do with this extension when it’s in incognito mode. `"split"` will allow the extension to run in its own process when the browser is incognito; for other options, see the [Chrome developer documentation](https://developer.chrome.com/extensions/manifest/incognito).

As you can probably see, `"chrome_url_overrides"` tells Chrome to open `index.html` whenever a new tab is opened. The value of `"permissions"` will give the user a pop-up letting them know that this extension will override their new tab when they try to install it.

Finally, we’re telling Chrome what to display as our favicon: a file called `icon.png`, which will be 128 x 128 pixels.

### Creating an Icon

Since we don’t have the icon file yet, next, we’ll create an icon for Simple Greeting Dash. Feel free to use the one I made below. If you’d like to make your own, you can easily do so using Photoshop or a free service like [Canva](http://canva.com). Just be sure the dimensions are 128 x 128 pixels, and that you save it as `icon.png` in the same folder as your HTML, CSS, JS, and JSON files.

![](https://cdn-images-1.medium.com/max/800/1*-dBIaX8IyG0PfHK-2vZ2dA.png)

My 128x128 icon for Simple Greeting Dash

### Uploading Your Files (If You’re Coding Your Own Page)

The information above is all you really need to know to create your own new tab Chrome extension. After you customize your `manifest.json` file, you can design whatever kind of new tab page you want in HTML, CSS, and JavaScript and upload it as shown below. But if you’d like to see how I’m going to make this simple dashboard, skip down to “Creating a Settings Menu.”

Once you’re done styling your new tab page, your Chrome extension is done and ready to upload to Chrome. To upload it yourself, head to [**chrome://extensions/**](about:invalid#zSoyz)  in your browser and toggle on Developer Mode in the upper right.

![](https://cdn-images-1.medium.com/max/800/1*O2j2WS2RAPYE_NiOWqyWCw.png)

Refresh the page and click on “Load unpacked.”

![](https://cdn-images-1.medium.com/max/800/1*gb0c8qmG_MtinG9tOmjxuA.png)

Next, select the folder where you’re storing your HTML, CSS, JS, and `manifest.json` files, as well as your `icon.png`, and upload. The extension should work each time you open a new tab!

Once you’re done with your extension and have tested it out yourself, you can get a developer account and it to the Chrome extension store. [This guide on publishing your extension](https://developer.chrome.com/webstore/publish) should help.

If you aren’t creating your own extension right now and just want to see what’s possible with Chrome extensions, read on to see how to make a very simple greeting dashboard.

### Creating a Settings Menu

For my extension, the first thing I’ll want to do is create an input where my user can add their name. Since I don’t want this input to be visible all the time, I’m going to put it in a div called `settings`, which I’ll make visible only when the Settings button is clicked.

```
<button id="settings-button">Settings</button>
<div class="settings" id="settings">
   <form class="name-form" id="name-form" action="#">
      <input class="name-input" type="text"
        id="name-input" placeholder="Type your name here...">
      <button type="submit" class="name-button">Add</button>
   </form>
</div>
```

Right now, our settings look like this:

![](https://cdn-images-1.medium.com/max/800/1*YXSHj-nYAotrbMCAulpJ0Q.png)

So beautiful!

… so I’m going to give them some basic styles in CSS. I’ll give the button and input both some padding and an outline, and then put a little space between the settings and the form.

```
.settings {
   display: flex;
   flex-direction: row;
   align-content: center;
}

input {
   padding: 5px;
   font-size: 12px;
   width: 150px;
   height: 20px;
}

button {
   height: 30px;
   width: 70px;
   background: none; /* This removes the default background */
   color: #313131;
   border: 1px solid #313131;
   border-radius: 50px; /* This gives our button rounded edges */
   font-size: 12px;
   cursor: pointer;
}

form {
   padding-top: 20px;
}
```

Now our settings look a bit better:

![](https://cdn-images-1.medium.com/max/800/1*xk-CcvLMpxklx1MIvsD7xQ.png)

But let’s make them hidden when the user hasn’t clicked on Settings. I’ll do this by adding the following to `.settings`, which will cause the name input to disappear off the side of the screen:

```
transform: translateX(-100%);

transition: transform 1s;
```

Now let’s create a class called `settings-open` that we’ll toggle on and off in JavaScript when the user clicks the Settings button. When `settings-open` is added to `settings`, it will not have any transformations applied to it; it’ll just be visible in its normal position.

```
.settings-open.settings {
   transform: none;
}
```

Let’s get the class toggle working in JavaScript. I’m going to make a function called `openSettings()` that will toggle the class `settings-open` on or off. To do this, I’ll first get the element by its ID of `"settings"`, then use `classList.toggle` to add the class of `settings-open`.

```
function openSettings() {
   document.getElementById("settings").classList.toggle("settings-open");
}
```

Now I’ll add an event listener that will trigger the function whenever the Settings button is clicked.

```
document.getElementById("settings-button").addEventListener('click', openSettings)
```

This will make your settings appear or disappear whenever you click the Settings button.

### Creating a Personalized Greeting

Next, let’s create the greeting message. We’ll make an empty `h2` in HTML, and then fill it using innerHTML in JavaScript. I’m going to give the `h2` an ID so I can access it later, and put it inside a `div` called `greeting-container` to center it.

```
<div class="greeting-container">
   <h2 class="greeting" id="greeting"></h2>
</div>
```

Now, in JavaScript, I’m going to create a basic greeting using the user’s name. First I’ll make variable to hold the name, which I’ll keep empty for now, and add to later.

```
var userName;
```

Even if `userName` wasn’t empty, if I just put `userName` into a greeting in my HTML, Chrome wouldn’t use the same name if I open it in another session. To make sure Chrome remembers who I am, I’m going to have to work with local storage. So I’ll make a function called `saveName()`.

```
function saveName() {
    localStorage.setItem('receivedName', userName);
}
```

The function `localStorage.setItem()` takes two arguments: the first is a keyword I’ll use to access the information later, and the second is the information it needs to remember; in this case, the `userName`. I’m going to get this saved information through `localStorage.getItem`, which I’m going to use to update the `userName` variable.

```
var userName = localStorage.getItem('receivedName');
```

Before we link this to an event listener in the form, I want to tell Chrome what to call me if I haven’t told it my name yet. I’ll do this using an if statement.

```
if (userName == null) {
   userName = "friend";
}
```

And now, let’s finally hook up our userName variable to our form. I want to do this inside of a function, so that I can call that function whenever the name is updated. Let’s call the function `changeName()`.

```
function changeName() {
   userName = document.getElementById("name-input").value;
   saveName();
}
```

I want to call this function each time someone submits a name using the form. I’ll do this with an event listener, in which I’ll call the function `changeName()` and also prevent the page’s default of refreshing when a form is submitted.

```
document.getElementById("name-form").addEventListener('submit', function(e) {
   e.preventDefault()
   changeName();
});
```

Finally, let’s create our greeting. I’ll put this in a function as well, so that I can call it both when the page is refreshed, and whenever `changeName()` occurs. Here’s the function:

```
function getGreeting() {
   document.getElementById("greeting").innerHTML  = `Hello, ${userName}. Enjoy your day!`;
}

getGreeting()
```

Now I’ll call `getGreeting()` in my `changeName()` function and call it a day!

### Finally, Style Your Page

Now it’s time to add the finishing touches. I’m going to center my header using flexbox, make it bigger, and add a gradient background to the body in CSS. And to make the button and `h2` pop against the gradient, I’ll make them white.

```
.greeting-container {
   display: flex;
   justify-content: center;
   align-content: center;
}

.greeting {
   font-family: sans-serif;
   font-size: 60px;
   color: #fff;
}

body {
   background-color: #c670ca;
   background-image: linear-gradient(45deg, #c670ca 0%, #25a5c8 52%, #20e275 90%);
}

html {
   height: 100%;
}
```

And that’s it! Your page will look like this:

![](https://cdn-images-1.medium.com/max/2000/1*QMqFDrey8Ylut2XLen8JRA.png)

Your very own Chrome extension!

It may not be much, but it’s a great foundation for you to create and style your own Chrome dashboards. Please let us know if you have any questions, and feel free to reach out to me on Twitter at [@saralaughed](https://twitter.com/SaraLaughed).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
