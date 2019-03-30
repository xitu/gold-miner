> * 原文地址：[Crafting Reusable HTML Templates](https://css-tricks.com/crafting-reusable-html-templates/)
> * 原文作者：[Caleb Williams](https://css-tricks.com/author/calebdwilliams/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
> * 译者：
> * 校对者：

# Crafting Reusable HTML Templates

In our [last article](https://juejin.im/post/5c9a3cce5188252d9b3771ad), we discussed the Web Components specifications (custom elements, shadow DOM, and HTML templates) at a high-level. In this article, and the three to follow, we will put these technologies to the test and examine them in greater detail and see how we can use them in production today. To do this, we will be building a custom modal dialog from the ground up to see how the various technologies fit together.

#### Article Series:

1.  [Web Components 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [Crafting Reusable HTML Templates (_This post_)](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
3.  [Creating a Custom Element from Scratch](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [Encapsulating Style and Structure with Shadow DOM](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Advanced Tooling for Web Components](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

* * *

### HTML templates

One of the least recognized, but most powerful features of the [Web Components specification](https://www.w3.org/standards/techs/components#w3c_all) is the `<template>` element. In the [first article](https://css-tricks.com/an-introduction-to-web-components) of this series, we defined the template element as, “user-defined templates in HTML that aren’t rendered until called upon.” In other words, a template is HTML that the browser ignores until told to do otherwise.

These templates then can be passed around and reused in a lot of interesting ways. For the purposes of this article, we will look at creating a template for a dialog that will eventually be used in a custom element.

### Defining our template

As simple as it might sound, a `<template>` is an HTML element, so the most basic form of a template with content would be:

```
<template>
  <h1>Hello world</h1>
</template>
```

Running this in a browser would result in an empty screen as the browser doesn’t render the template element’s contents. This becomes incredibly powerful because it allows us to define content (or a content structure) and save it for later — instead of writing HTML in JavaScript.

In order to use the template, we _will_ need JavaScript

```
const template = document.querySelector('template');
const node = document.importNode(template.content, true);
document.body.appendChild(node);
```

The real magic happens in the `document.importNode` method. This function will create a copy of the template’s `content` and prepare it to be inserted into another document (or document fragment). The first argument to the function grabs the template’s content and the second argument tells the browser to do a deep copy of the element’s DOM subtree (i.e. all of its children).

We could have used the `template.content` directly, but in so doing we would have removed the content from the element and appended to the document's body later. Any DOM node can only be connected in one location, so subsequent uses of the template's content would result in an empty document fragment (essentially a null value) because the content had previously been moved. Using `document.importNode` allows us to reuse instances of the same template content in multiple locations.

That node is then appended into the `document.body` and rendered for the user. This ultimately allows us to do interesting things, like providing our users (or consumers of our programs) templates for creating content, similar to the following demo, which we covered in the [first article](https://css-tricks.com/an-introduction-to-web-components):

See the Pen [Template example](https://codepen.io/calebdwilliams/pen/LqQmXN/) by Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) on [CodePen](https://codepen.io).

In this example, we have provided two templates to render the same content — authors and books they’ve written. As the form changes, we choose to render the template associated with that value. Using that same technique will allow us eventually create a custom element that will consume a template to be defined at a later time.

### The versatility of template

One of the interesting things about templates is that they can contain _any_ HTML. That includes script and style elements. A very simple example would be a template that appends a button that alerts us when it is clicked.

```
<button id="click-me">Log click event</button>
```

Let’s style it up:

```
button {
  all: unset;
  background: tomato;
  border: 0;
  border-radius: 4px;
  color: white;
  font-family: Helvetica;
  font-size: 1.5rem;
  padding: .5rem 1rem;
}
```

...and call it with a really simple script:

```
const button = document.getElementById('click-me');
button.addEventListener('click', event => alert(event));
```

Of course, we can put all of this together using HTML’s `<style>` and `<script>` tags directly in the template rather than in separate files:

```
<template id="template">
  <script>
    const button = document.getElementById('click-me');
    button.addEventListener('click', event => alert(event));
  </script>
  <style>
    #click-me {
      all: unset;
      background: tomato;
      border: 0;
      border-radius: 4px;
      color: white;
      font-family: Helvetica;
      font-size: 1.5rem;
      padding: .5rem 1rem;
    }
  </style>
  <button id="click-me">Log click event</button>
</template>
```

Once this element is appended to the DOM, we will have a new button with ID `#click-me`, a global CSS selector targeted to the button’s ID, and a simple event listener that will alert the element’s click event.

For our script, we simply append the content using `document.importNode` and we have a mostly-contained template of HTML that can be moved around from page to page.

See the Pen [Template with script and styles demo](https://codepen.io/calebdwilliams/pen/modxXr/) by Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) on [CodePen](https://codepen.io).

### Creating the template for our dialog

Getting back to our task of making a dialog element, we want to define our template’s content and styles.

```
<template id="one-dialog">
  <script>
    document.getElementById('launch-dialog').addEventListener('click', () => {
      const wrapper = document.querySelector('.wrapper');
      const closeButton = document.querySelector('button.close');
      const wasFocused = document.activeElement;
      wrapper.classList.add('open');
      closeButton.focus();
      closeButton.addEventListener('click', () => {
        wrapper.classList.remove('open');
        wasFocused.focus();
      });
    });
  </script>
  <style>
    .wrapper {
      opacity: 0;
      transition: visibility 0s, opacity 0.25s ease-in;
    }
    .wrapper:not(.open) {
      visibility: hidden;
    }
    .wrapper.open {
      align-items: center;
      display: flex;
      justify-content: center;
      height: 100vh;
      position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
      opacity: 1;
      visibility: visible;
    }
    .overlay {
      background: rgba(0, 0, 0, 0.8);
      height: 100%;
      position: fixed;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
      width: 100%;
    }
    .dialog {
      background: #ffffff;
      max-width: 600px;
      padding: 1rem;
      position: fixed;
    }
    button {
      all: unset;
      cursor: pointer;
      font-size: 1.25rem;
      position: absolute;
        top: 1rem;
        right: 1rem;
    }
    button:focus {
      border: 2px solid blue;
    }
  </style>
  <div class="wrapper">
  <div class="overlay"></div>
    <div class="dialog" role="dialog" aria-labelledby="title" aria-describedby="content">
      <button class="close" aria-label="Close">&#x2716;&#xfe0f;</button>
      <h1 id="title">Hello world</h1>
      <div id="content" class="content">
        <p>This is content in the body of our modal</p>
      </div>
    </div>
  </div>
</template>
```

This code will serve as the foundation for our dialog. Breaking it down briefly, we have a global close button, a heading and some content. We have also added in a bit of behavior to visually toggle our dialog (although it isn't yet accessible). Unfortunately the styles and script content aren't scoped to our template and are applied to the entire document, resulting in less-than-ideal behaviors when more than one instance of our template is added to the DOM. In our next article, we will put custom elements to use and create one of our own that consumes this template in real-time and encapsulates the element's behavior.

See the Pen [Dialog with template with script](https://codepen.io/calebdwilliams/pen/JzjLyQ/) by Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) on [CodePen](https://codepen.io).

#### Article Series:

1.  [Web Components 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [Crafting Reusable HTML Templates (_This post_)](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
3.  [Creating a Custom Element from Scratch](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [Encapsulating Style and Structure with Shadow DOM](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Advanced Tooling for Web Components](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
