> * 原文地址：[Performant JavaScript Best Practices](https://levelup.gitconnected.com/performant-javascript-best-practices-c5a49a357e46)
> * 原文作者：[John Au-Yeung](https://medium.com/@hohanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/performant-javascript-best-practices.md](https://github.com/xitu/gold-miner/blob/master/TODO1/performant-javascript-best-practices.md)
> * 译者：
> * 校对者：

# Performant JavaScript Best Practices

![Photo by [Jason Chen](https://unsplash.com/@ja5on?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/5760/0*UyQ42ciE79LF-bK4)

Like any program, JavaScript programs can get slow fast if we aren’t careful with writing our code.

In this article, we’ll look at some best practices for writing fast JavaScript programs.

## Reduce DOM Manipulation With Host Object and User’s Browser

DOM manipulation is slow. The more we do, the slower it’ll be. Since DOM manipulation is synchronous, each action is done one at a time, holding the rest of our program.

Therefore, we should minimize the number of DOM manipulation actions that we're doing.

The DOM can be blocked by loading CSS and JavaScript. However, images aren’t blocking render so that they don’t hold up our page from finishing loading.

However, we still want to minimize the size of our images.

Render blocking JavaScript code can be detected with Google PageSpeed Insights, which tells us how many pieces of render-blocking JavaScript code we have.

Any inline CSS would block the rendering of the whole page. They are the styles that are scattered within our page with `style` attributes.

We should move them all to their own style sheets, inside the `style` tag, and below the body element.

CSS should be concatenated and minified to reduce the number of the stylesheet to load and their size.

We can also mark `link` tags as non-render blocking by using media queries. For instance, we can write the following to do that:

```html
<link href="portrait.css" rel="stylesheet" media="orientation:portrait">
```

so that it only loads when the page is displayed in portrait orientation.

We should move style manipulation outside of our JavaScript and put styles inside our CSS by putting styles within their own class in a stylesheet file.

For instance, we can write the following code to add a class in our CSS file:

```css
.highlight {
  background-color: red;
}
```

and then we can add a class with the `classList` object as follows:

```js
const p = document.querySelector('p');
p.classList.add('highlight');
```

We set the p element DOM object to its own constant so we can cache it and reuse it anywhere and then we call `classList.add` to add the `hightlight` class to it.

We can also remove it if we no longer want it. This way, we don’t have to do a lot of unnecessary DOM manipulation operations in our JavaScript code.

If we have scripts that no other script depends on, we can load then asynchronously so that they don’t block the loading of other scripts.

We just put `async` in our script tag so that we can load our script asynchronously as follows:

```html
<script async src="script.js"></script>
```

Now `script.js` will load in the background instead of in the foreground.

We can also defer the loading of scripts by using the `defer` directive. However, it guarantees that the script in the order they were specified on the page.

This is a better choice if we want our scripts to load one after another without blocking the loading of other things.

Minifying scripts is also a must-do task before putting our code into production. To do that, we use module bundlers like Webpack and Parcel, which so create a project and then build them for us automatically.

Also, command-line tools for frameworks like Vue and Angular also do code minification automatically.

## Minimize the Number of Dependencies Our App Uses

We should minimize the number of scripts and libraries that we use. Unused dependencies should also be removed.

For instance, if we’re using Lodash methods for array manipulation, then we can replace them with native JavaScript array methods, which are just as good.

Once we remove our dependency, we should remove them from `package.json` and the run `npm prune` to remove the dependency from our system.

![Photo by [Tim Carey](https://unsplash.com/@baudy?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6154/0*9Qx9V9XpyjsjvSME)

## Poor Event Handling

Event handling code is always slow if they’re complex. We can improve performance by reducing the depth of our call stack.

That means we call as few functions as possible. Put everything in CSS style sheets if possible if we’re manipulating styles in our event handlers.

And do everything to reduce calling functions like using the `**` operator instead of calling `Math.pow` .

## Conclusion

We should reduce the number of dependencies and loading them in an async manner if possible.

Also, we should reduce the CSS in our code and move them to their own stylesheets.

We can also add media queries so that stylesheets don’t load everywhere.

Finally, we should reduce the number of functions that are called in our code.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
