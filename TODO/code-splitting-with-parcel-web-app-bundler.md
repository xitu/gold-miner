> * 原文地址：[Code Splitting with Parcel Web App Bundler](https://hackernoon.com/code-splitting-with-parcel-web-app-bundler-fe06cc3a20da)
> * 原文作者：[Ankush Chatterjee](https://hackernoon.com/@ankushc?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/code-splitting-with-parcel-web-app-bundler.md](https://github.com/xitu/gold-miner/blob/master/TODO/code-splitting-with-parcel-web-app-bundler.md)
> * 译者：
> * 校对者：

# Code Splitting with Parcel Web App Bundler

![](https://cdn-images-1.medium.com/max/800/1*3Tp8OGHuIlun20JS84i7DA.gif)

Code Splitting!! Quite a buzzword in web development nowadays. Today, we will explore code splitting and see how can we do it super easily with parcel.

#### What is Code Splitting?

If you are already familiar with it… you may skip this part, others, ride along…

If you have done frontend web development with any JavaScript framework, you have surely packed all of your modules into one big bundle JavaScript file, which you attach to your webpage and do amazing stuff. But hey, those bundles are quite big! You have written your awesome(and complicated) web app, with so many parts… they ought to produce big bundles; and bigger the things, longer it takes to download them on slow networks. Ask yourself the question, does the user need _all of it_ at once?

Imagine it’s an e-commerce single page app. The user logs in to see the product listing, he may have come just to check out the products, but he has already spent a lot of time and data not just to download the JavaScript to render the product listing, but also the JavaScript to render about, filters, product detail, offers… and so on and so forth.

By doing this we are doing the users injustice!! Wont it be awesome, if we could _give the users what they need,only when they need it?._

So, this idea of splitting your large bundle into multiple smaller bundles is called code splitting. These smaller bundles are loaded on demand and asynchronously. It surely sounds tough to do, but modern bundlers like Webpack make it quite easy, and parcel takes this easiness to whole another level.

![](https://cdn-images-1.medium.com/max/800/1*WKxqnQQJjn03TXiBM4TYfw.png)

The parent is divided into these cute babies. Courtesy [Shreya](https://medium.com/@shreyawriteshere) [[Instagram](https://www.instagram.com/shreyadoodles/)]

#### So, what is this new Parcel thing??

[Parcel](https://parceljs.org/) is the

> Blazing fast, zero configuration web application bundler

It makes module bundling really very easy!! If you haven’t heard about it, I recommend [this article](https://medium.freecodecamp.org/all-you-need-to-know-about-parcel-dbe151b70082) by [Indrek Lasn](https://medium.com/@wesharehoodies).

#### Let’s get Splitting!

To the coding part… I wont use any framework here(which you normally would), but framework or no framework, the process would remain the same. This example would have really really simple code to demonstrate the process.

Create a new empty directory, and `init` a project, by

```
npm init
```

Or,

```
yarn init
```

Start it with whatever your favorite is(yarn in my case 😉) and create the files like show below.

![](https://cdn-images-1.medium.com/max/800/1*oZy87TFDpGZYXf05uunBxA.png)

World’s simplest file structure

The idea is, we will only include the contents of `index.js` in our `index.html` and on an event(it will be a button click in this case) we will load `someModule.js` and render some content with it.

Open `index.html` and add the following code.

```
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Code Splitting like Humans</title>
  </head>
  <body>
    <button id="bt">Click</button>
    <div class="holder"></div>
    <script src="./index.js"></script>
  </body>
</html>
```

Nothing special, just basic HTML boiler plate, with a button and a `div` where we will render the content from `someModule.js`

So, lets write the code for the module `someModule`

```
console.log("someModule.js loaded");
module.exports = {
  render : function(element){
      element.innerHTML = "You clicked a button";
  }
}
```

We are exporting an object, which has a function `render` which takes in an element and sets its inner HTML to “You clicked a button”.

Now, comes the magic. In our `index.js` file we have to handle the button click event and dynamically load `someModule`

For the dynamic asynchronous loading we will use the `import()` function syntax. This function loads a module on demand and asynchronously.

Look at the usage,

```
import('./path/to/module').then(function(page){
//Do Something
});
```

As `import` is asynchronous it returns a promise which we handle with `then`. In `then` we pass a function which accepts the object loaded from the module. It is similar to `const page = require('./path/to/module');`, only done dynamically and asynchronously.

In our case,

```
import('./someModule').then(function (page) {
   page.render(document.querySelector(".holder"));
});
```

We load `someModule` and call its render function.

Lets add it up inside a button’s click event listener.

```
console.log("index.js loaded");
window.onload = function(){
       document.querySelector("#bt").addEventListener('click',function(evt){
     console.log("Button Clicked");
     import('./someModule').then(function (page) {
         page.render(document.querySelector(".holder"));
     });
});
}
```

Now that the code is all written, let’s run parcel. Parcel will automatically handle all the configuration work!

```
parcel index.html
```

It produces, the following files.

![](https://cdn-images-1.medium.com/max/800/1*NEtHUZA1zchHSsWuOqB6mQ.png)

Run it in your browser and observe.

![](https://cdn-images-1.medium.com/max/800/1*RIhun_YTgvmtvHgeqKWNkw.png)

Console output

![](https://cdn-images-1.medium.com/max/800/1*kS4YO7jH-6sA49LuWs-lsA.png)

Network tab

Notice in the console output, `someModule` is loaded only after the button click. In the network tab see how the module is loaded by `codesplit-parcel.js` after `import` function call.

Code Splitting is something awesome, and if it can be done so easily, there is no reason we should step back from it. 💞💞


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
