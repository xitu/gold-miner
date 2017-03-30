> * 原文地址：[Using DevTools to Tweak Designs in the Browser](https://css-tricks.com/using-devtools-tweak-designs-browser/)
> * 原文作者：[AHMAD SHADEED](https://css-tricks.com/author/shadeed9/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Using DevTools to Tweak Designs in the Browser #

Let's look at some ways we can use the browsers DevTools to do design work. There are a few somewhat hidden tricks you mind find handy!

### Toggling Classes With Checkboxes

This is useful when trying to pick a design from different options or to toggle the active state of an element without adding the class manually in DevTools. 

To achieve this, we could use different classes and scope styles inside them. So if we want to see different options for a banner design, we could so something like: 


```
.banner-1 {
  /* Style variation */
}

.banner-2 {
  /* Style variation */
}
```
  
Google Chrome gives us the ability to add all of these classes and toggle (show/hide) them with a checkbox to make a quick comparison between them.

[![](https://i.vimeocdn.com/video/623010079.webp?mw=700&mh=525)](https://player.vimeo.com/video/207830826)

See the [demo Pen](http://codepen.io/shadeed/pen/e2a8f51691cad05bdfd5b14fb9365214?editors=0100).

### Editing Content with designMode

Web content is dynamic, so our design should be flexible and we should test for various types and lengths of content. For example, entering a very long word might break a design. To check that, we can edit our design right in the browser with `document.designMode`.

[![](https://i.vimeocdn.com/video/623015649.webp?mw=700&mh=525)](https://player.vimeo.com/video/207835383)

This can help us test our design without editing the content manually in the source code. 

### Hiding Elements

Sometimes we need to hide elements in our design to check how it will look without them. Chrome DevTools give us the ability to inspect an element and type `h` from the keyboard to hide it by toggling CSS visibility property.

[![](https://i.vimeocdn.com/video/623017144.webp?mw=700&mh=439)](https://player.vimeo.com/video/207836443)

This is very useful in case you want to hide some elements to take a screenshot and then discuss it with your team/designer/manager. Sometimes I use this feature to hide elements and then take a screenshot to mock a quick idea in Photoshop.

### Screenshotting design elements

There is a useful feature in Firefox DevTools to take a screenshot of a specific element in the DOM. By doing that, we can compare our variations side by side to see which one is the best of our case.

Follow the below steps:

1. Open Firefox DevTools
2. Right-click on an element and pick **Screenshot Node**
3. The screenshots are saved in the default downloads folder

![](https://cdn.css-tricks.com/wp-content/uploads/2017/03/firefox-screenshot.jpg)

If you want to use Chrome for screenshotting, you can. There is a [plugin](https://chrome.google.com/webstore/detail/element-screenshot/mhbapdljigafafoimcnnhagdclejnkcf) called "Element Screenshot" that does almost the same job.

### Changing Design Colors

In the early stages of every design projects, you might be exploring different color palettes. CSS' `hue-rotate` function is a powerful filter that provides us with the ability to change design colors right in the browser. It causes hue rotation for each pixel in an image or element. The value can be specified in `deg` or `rad`. 

In the below video, I added `filter: hue-rotate(value)` to the component, notice how all the colors change.

[![](https://i.vimeocdn.com/video/623210796.webp?mw=700&mh=577)](https://player.vimeo.com/video/207995530)

Notice that *every* design element got affected from applying `hue-rotate`. For example, the user avatar colors looks wrong. We can revert the normal look by applying the negative value of `hue-rotate`.


```
.bio__avatar {
  filter: hue-rotate(-100deg);
}
```


See the [demo Pen](http://codepen.io/shadeed/pen/2d611749947ac7688c2710248c473e50?editors=0010).

### Using CSS Variables (Custom CSS Properties)

Even if the support is still not [perfectly cross-browser](http://caniuse.com/#feat=css-variables) friendly (it's [currently](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/csscustompropertiesakacssvariables/?q=css%20v) in development in Microsoft Edge), we can get the benefit of CSS variables today. Using them to define the spacing and color units will make it easy to make huge changes by changing tiny values on the fly.

I defined the following for our web page:

```
:root {
  --spacing-unit: 1em;
  --spacing-unit-half: calc(var(--spacing-unit) / 2); /* = 0.5em */
  --brand-color-primary: #7ebdc2;
  --brand-color-secondary: #468e94;
}
```

These variables will be used throughout the website elements like links, nav items, borders and background colors. When changing a single variable from the dev tools, all the associated elements will be affected!

![](https://cdn.css-tricks.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-12-at-4.34.47-PM.jpg)

### Invert elements with CSS `filter: invert()`

This is useful when you have a white text on black background or vice versa. For instance, in the header, we have the page title in white on a black background, and by adding `filter: invert` to the element, all the colors will be inverted. 

![](https://cdn.css-tricks.com/wp-content/uploads/2017/03/invert-filter.gif)

### CSS Visual Editor

This feature is becoming better every day. Safari has really nice UI tools for editing values. Chrome is adding similar things slowly to DevTools.

[![](https://i.vimeocdn.com/video/623229127.webp?mw=700&mh=525)](https://player.vimeo.com/video/208011466)

Chrome has some cool stuff for things like `box-shadow`, `background-color`, `text-shadow` and `color`.

![](https://cdn.css-tricks.com/wp-content/uploads/2017/03/chrome-visual-css.gif)

I think this will be very useful for designers who doesn't know much about CSS. Editing things visually like that will give them more control over some design details, they can tweak things in the browser and show the result to the developer to be implemented.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
