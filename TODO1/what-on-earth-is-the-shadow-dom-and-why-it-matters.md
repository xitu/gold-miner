> * 原文地址：[What on Earth is the Shadow DOM and Why Does it Matter?](https://medium.com/better-programming/what-on-earth-is-the-shadow-dom-and-why-it-matters-eff0884bd33d)
> * 原文作者：[Aphinya Dechalert](https://medium.com/@PurpleGreenLemon)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-on-earth-is-the-shadow-dom-and-why-it-matters.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-on-earth-is-the-shadow-dom-and-why-it-matters.md)
> * 译者：
> * 校对者：

# What on Earth is the Shadow DOM and Why Does it Matter?

![Photo by [Tom Barrett](https://unsplash.com/@wistomsin?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/shadow?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/6538/1*wDb9Aw5YXEM_O8DqrsG0vQ.jpeg)

> Isn’t one DOM enough?

We’ve all heard of the DOM at some point. It’s a topic that is quickly brushed over, and there’s not enough discussion of it. The name **shadow DOM** sounds somewhat sinister — but trust me, it’s not.

The concept of DOMs is one of the foundations of the web and interfaces, and it’s deeply intertwined with JavaScript.

Many know what a DOM is. For starters, it stands for Document Object Model. But what does that mean? Why is it important? And how is understanding how it works relevant to your next coding project?

---

Read on to find out.

## What Exactly Is a DOM?

There’s a misconception that HTML elements and DOM are one and the same. However, they are separate and different in terms of functionality and how they are created.

HTML is a markup language. Its sole purpose is to dress up content for rendering. It uses tags to define elements and uses words that are human-readable. It is a standardized markup language with a set of predefined tags.

Markup languages are different from typical programming syntaxes because they don’t do anything other than create demarcations for content.

The DOM, however, is a constructed tree of objects that are created by the browser or rendering interface. In essence, it acts sort of like an API for things to hook into the markup structure.

So what does this tree look like?

Let’s take a quick look at the HTML below:

```HTML
<!doctype html>
   <html>
   <head>
     <title>DottedSquirrel.com</title>
   </head>
   <body>
      <h1>Welcome to the site!</h1>
      <p>How, now, brown, cow</p>
   </body>
   </html>
```

This will result in the following DOM tree.

![](https://cdn-images-1.medium.com/max/2000/1*J8n54a_p1jI6bPPJIKufbg.jpeg)

Since all elements and any styling in an HTML document exist on the global scope, it also means that the DOM is one big globally scoped object.

`document` in JavaScript refers to the global space of a document. The `querySelector()` method lets you find and access a particular element type, regardless of how deeply nested it sits in the DOM tree, provided that you have the pathway to it correct.

For example:

```js
document.querySelector(".heading");
```

This will select the first element in the document with `class="heading"`.

Suppose you do something like the following:

```js
document.querySelector("p");
```

This will target the first `\<p>` element that exists in a document.

To be more specific, you can also do something like this:

```js
document.querySelector("h1.heading");
```

This will target the first instance of `\<h1 class="heading">`.

Using `.innerHTML = ""` will give you the ability to modify whatever sits in between the tags. For example, you can do something like this:

```js
document.querySelector("h1").innerHTML = "Moooo!"
```

This will change the content inside the first `\<h1>` tags to `Moooo!`.

---

Now that we have the basics of DOMs sorted, let’s talk about when a DOM starts to exist within a DOM.

## DOM Within DOMs (aka Shadow DOMs)

There are times when a straight single-object DOM will suffice for all the requirements of your web app or web page. Sometimes, though, you need third-party scripts to display things without it messing with your pre-existing elements.

This is where shadow DOMs come into play.

Shadow DOMs are DOMs that sit in isolation, have their own set of scopes, and aren’t part of the original DOM.

Shadow DOMs are essentially self-contained web components, making it possible to build modular interfaces without them clashing with one another.

Browsers automatically attach shadow DOMs to some elements, such as `\<input>` , `\<textarea>` and, `\<video>`.

But sometimes you need to manually create the shadow DOM to extract the parts you need. To do this, you need to first create a shadow host, followed by a shadow root.

#### Setting up the shadow host

To split out a shadow DOM, you need to figure out which set of wrappers you want to extract.

For example, you want the `host` class to be the set of wrappers that defines the boundaries of your shadow DOM.

```HTML
<!doctype html>
   <html>
   <head>
     <title>DottedSquirrel.com</title>
   </head>
   <body>
      <h1>Welcome to the site!</h1>
      <p>How, now, brown, cow</p> 
      <span class="host"> 
           ... 
      <span class="host">
   </body>
   </html>
```

Under normal circumstances, `span` isn’t automatically converted into a shadow DOM by the browser. To do this via JavaScript, you need to use `querySelector()` and `attachShadow()` methods.

```js
const shadowHost = document.querySelector(".host");
const shadow = shadowHost.attachShadow({mode: 'open'});
```

`shadow` is set up to be the shadow root of our shadow DOM. The elements then become a child of an extracted and separate DOM with `.host` as the root class element.

While you can still see the HTML in your inspector, the `host` portion of the code is no longer visible to the root code.

To access this new shadow DOM, you just need to use a reference to the shadow root, i.e., `shadow` in the example above.

For example, you want to add some content. You can do so with something like this:

```js
const paragraph = document.createElement("p");
paragraph.text = shadow.querySelector("p");
paragraph.innerHTML = "helloooo!";
```

This will create a new `p` element with the text `helloooo!` inside your shadow root.

#### Parts of a shadow DOM

A shadow DOM consists of four parts: the shadow host, the shadow tree, the shadow boundary, and the shadow root.

The shadow host is the regular DOM node that the shadow DOM is attached to. In the examples previously, this is through the class `host`.

The shadow tree looks and acts like a normal DOM tree, except its scope is limited to the edges of the shadow host.

The shadow boundary is the place where the shadow DOM starts and ends.

And finally, the shadow root is the root node of the shadow tree. This is different from the shadow host (i.e., `host` class, based on the examples above).

Let’s look at this code again:

```js
const shadowHost = document.querySelector(".host");
const shadow = shadowHost.attachShadow({mode: 'open'});
```

The `shadowHost` constant is our shadow host, while `shadow` is actually the shadow root. The difference between these two is that `shadow` returns a `DocumentFragment` while the `shadowHost` returns a `document` element.

---

Think of the host as a placeholder for the location of your actual shadow DOM.

## Why Do Shadow DOMs Matter?

Now comes the big question — why do shadow DOMs matter?

Shadow DOM is a browser technology that’s used to scope variables and CSS in web components.

For starters, a DOM is an object, and you can’t possibly do all you need to do with a single object without it stepping over boundaries you want to certainly keep separate.

This means that shadow DOMs allow for encapsulation, that is, the ability to keep markup structure, style, and behavior separated and hidden from other code so they don’t clash.

And those are the basics of shadow DOMs.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
