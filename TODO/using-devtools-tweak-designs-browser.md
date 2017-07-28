> * 原文地址：[Using DevTools to Tweak Designs in the Browser](https://css-tricks.com/using-devtools-tweak-designs-browser/)
> * 原文作者：[AHMAD SHADEED](https://css-tricks.com/author/shadeed9/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[bambooom](https://github.com/bambooom)
> * 校对者：[gy134340](https://github.com/gy134340) / [avocadowang](https://github.com/avocadowang)

# 使用开发者工具在浏览器中调整设计

让我们来看看使用浏览器的开发者工具做设计工作的几种方式。你会发现一些很方便的隐藏技巧。

### 使用复选框切换类名

当你在从不同的选择中挑选一个设计时，或者在不手动添加类名的时候切换元素的状态时，这个技巧很有用。

为了达到这一点，我们可以使用不同的类名和范围样式。那么如果想看看不同的横幅设计的样式的时候，我们可以这么做： 


```css
.banner-1 {
  /* Style variation */
}

.banner-2 {
  /* Style variation */
}
```

Google Chrome 可以让我们添加所有类，并在其中使用复选框切换来快速比较不同的样式。

[![](https://i.vimeocdn.com/video/623010079.webp?mw=700&mh=525)](https://player.vimeo.com/video/207830826)

[可以看看 codepen demo](http://codepen.io/shadeed/pen/e2a8f51691cad05bdfd5b14fb9365214?editors=0100).

### 开启 designMode 来编辑内容

web 内容是动态的，所以设计应该是灵活的，我们应该测试不同类型不同长度的内容。比方说，输入一个非常长的单词可能会破坏现有的设计。为了检查这个，我们可以在浏览器控制台里输入 `document.designMode = 'on'` 后编辑我们的设计。

[![](https://i.vimeocdn.com/video/623015649.webp?mw=700&mh=525)](https://player.vimeo.com/video/207835383)

这个可以很方便的测试设计而不需要手动在源代码中进行修改。

### 隐藏元素

有时我们需要隐藏某些元素试试看如果没有它的时候是什么样子。Chrome DevTools 可以让我们检查一个元素然后键盘输入 `h` 来隐藏它，也就是切换元素 CSS 的 visibility 属性。

[![](https://i.vimeocdn.com/video/623017144.webp?mw=700&mh=439)](https://player.vimeo.com/video/207836443)

当你需要隐藏某些元素并截图，再和你的同事、设计师或者经理讨论的时候，这个功能非常有用。有时我会利用这个技巧去隐藏元素并截图后，在 PhotoShop 中快速模拟简单的想法。

### 截图设计元素

FireFox 的开发者工具中有一个很有用的功能，它可以给 DOM 中特定元素截图。这样的话，我们可以将几种不同的方案放在一起对比挑选最好的方案。

按照如下步骤：

1. 打开 FireFox 开发者工具
2. 对一个元素右键，选择**节点截图**（**Screenshot Node**）
3. 截图会存在默认的下载路径文件夹中

![](https://cdn.css-tricks.com/wp-content/uploads/2017/03/firefox-screenshot.jpg)

你也可以在 Chrome 中使用这个功能，有一个插件叫 [Element Screenshot](https://chrome.google.com/webstore/detail/element-screenshot/mhbapdljigafafoimcnnhagdclejnkcf) 可以达到相同的效果。

### 更改设计颜色

在设计项目的初期阶段，你可能需要探索多种不同的调色板。CSS 的 `hue-rotate` 函数是一共功能强大的过滤器，它可以让我们在浏览器中更改设计颜色。它可以旋转图像或元素中每个像素的色相。其中的值可以通过 `deg` 或者 `rad` 设定。 

在下面的视频中，我给组件添加了 `filter: hue-rotate(value)` 属性，注意看所有的颜色是如何变化的。

[![](https://i.vimeocdn.com/video/623210796.webp?mw=700&mh=577)](https://player.vimeo.com/video/207995530)

注意**每个**设计元素都会被使用 `hue-rotate` 所影响。比如，用户头像的颜色好像不太对，我们可以通过应用 `hue-rotate` 的负值使之恢复正常。


```css
.bio__avatar {
  filter: hue-rotate(-100deg);
}
```


See the [demo Pen](http://codepen.io/shadeed/pen/2d611749947ac7688c2710248c473e50?editors=0010).

### 使用 CSS 变量（自定义 CSS 属性）

虽然自定义属性的[浏览器支持](http://caniuse.com/#feat=css-variables)并不是很友好（现在 Microsoft Edge 现在[正在开发](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/csscustompropertiesakacssvariables/?q=css%20v)）。我们现在也仍然可以从 CSS 变量中获益。使用自定义变量定义间距和颜色单位可以通过更改很小的值轻松实现巨大的变化。

我在我们网页上定义了下面一些变量：

```css
:root {
  --spacing-unit: 1em;
  --spacing-unit-half: calc(var(--spacing-unit) / 2); /* = 0.5em */
  --brand-color-primary: #7ebdc2;
  --brand-color-secondary: #468e94;
}
```

这些变量可以在网站所有的元素上使用，就像链接、导航、边距和背景颜色。当在开发工具中更改一个变量的值，所有相关联的元素都会受到影响。

![](https://cdn.css-tricks.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-12-at-4.34.47-PM.jpg)

### 使用 CSS 属性 `filter: invert()` 翻转元素 

当你在黑底白字或者白底黑字的情况下，这个属性是很有用的。例如，在标题中，我们在黑色背景上将页面标题设为白色，然后在元素上添加了 `filter: invert()`属性，所有的颜色就会被反转。 

![](https://cdn.css-tricks.com/wp-content/uploads/2017/03/invert-filter.gif)

### CSS 视觉编辑器

这个功能每天都在变得越来越好。Safari 具有非常好的用于编辑值的 UI 工具，Chrome 也正在向 DevTools 中缓慢添加类似的东西。

[![](https://i.vimeocdn.com/video/623229127.webp?mw=700&mh=525)](https://player.vimeo.com/video/208011466)

Chrome 有些很实用的工具用来编辑 `box-shadow`、`background-color`、`text-shadow` 和 `color`.

![](https://cdn.css-tricks.com/wp-content/uploads/2017/03/chrome-visual-css.gif)

我想上面这些技巧对于并不是特别熟悉 CSS 的设计师会很有帮助。直接视觉上的进行编辑会给设计师更多对设计细节的把控，他们可以在浏览器中调整并将结果显示给开发人员来实现。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
