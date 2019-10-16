> * 原文地址：[CSS Quickies: CSS Variables - Or how you create a 🌞white/🌑dark theme easily](https://dev.to/lampewebdev/css-quickies-css-variables-or-how-you-create-a-white-dark-theme-easily-1i0i)
> * 原文作者：[lampewebdev](https://dev.to/lampewebdev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/css-quickies-css-variables-or-how-you-create-a-white-dark-theme-easily.md](https://github.com/xitu/gold-miner/blob/master/TODO1/css-quickies-css-variables-or-how-you-create-a-white-dark-theme-easily.md)
> * 译者：[cyz980908](https://github.com/cyz980908)
> * 校对者：[Reaper622](https://github.com/Reaper622),[sleepingxixi](https://github.com/sleepingxixi)

# CSS 小妙招：CSS 变量 —— 如何轻松创建一个🌞白色/🌑暗色主题 

![lampewebdev profile image](https://res.cloudinary.com/practicaldev/image/fetch/s--4OXdDnPC--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://res.cloudinary.com/practicaldev/image/fetch/s--2-YUNNqu--/c_imagga_scale%2Cf_auto%2Cfl_progressive%2Ch_420%2Cq_auto%2Cw_1000/https://thepracticaldev.s3.amazonaws.com/i/vhv9dhjxosxtrvezecuy.png)

## 什么是 CSS 小妙招?

我在 Instagram 上询问我可爱的网友们：“哪些 CSS 属性会让您感到困惑？”

在“CSS 小妙招”这个话题中，我将深入讲解一个 CSS 属性。这些都是网友们提问的属性。所以，如果您也有感到困惑的 CSS 属性，请在 [Instagram](https://www.instagram.com/lampewebdev/) 或者 [Twitter](https://twitter.com/lampewebdev) 下方留言给我！我有问必回。

如果您还想找点乐子或者想问我些其他问题，可以来 [twitch.tv](https://www.twitch.tv/lampewebdev/) 看我直播敲代码。  

## 让我们来聊聊 `自定义属性` 即 `CSS 变量`.

废话不多说，我们进入主题。如果您曾经写过 CSS，并且想完美还原设计稿？或者还想在某些页面上，让你的网站有不同的填充、边距或颜色？

又或许你想实现一个黑夜模式？这些都是可以实现的，但现在变得容易了。

当然，如果您曾经使用过 LESS 或者 SASS，那么您就应该了解过 CSS 变量，现在它们终于得到了本地支持。😁

让我们先睹为快！

### 定义 CSS 变量

你定义一个 CSS 变量，并在 CSS 属性前添加 `--`。让我们看些例子。

```css
:root{
  --example-color: #ccc;
  --example-align: left;
  --example-shadow: 10px 10px 5px 0px rgba(0,0,0,0.75);
}
```

您的第一个疑惑可能是：“这个 ':root' 伪类是什么？”。
好问题！伪类 `:root` 与您使用 `html` 选择器时相同，不同之处在于 ':root' 伪类的权重更高。这意味着如果您在 `:root` 伪类中设置属性，它的优先级将大于 html 选择器。

好啦，那剩下的就很简单了。自定义属性 `--example-color` 的值为 `#ccc`。当我们在例如 `background-color` 的属性上使用自定义属性，元素的背景将是浅灰色。酷吧？

你可以给自定义属性，也就是 CSS 变量赋予任何你能赋予给其他 CSS 属性的值。例如，可以赋值 `left` 或者 `10px` 等等。

### [](#using-css-variables)使用 CSS 变量

我们已经知道如何设置 CSS 变量，现在我们需要学习如何使用它们！

首先，我们需要学习 `var()` 函数。
 `var()` 可以传入两个参数。第一个参数需要是一个自定义属性。如果自定义属性是无效的，则希望有回退值。为了实现这个，您只需设置 `var()` 函数的第二个参数。让我们来看个例子。

```css
:root{
  --example-color: #ccc;
}

.someElement {
  background-color: var(--example-color, #d1d1d1);
}
```

现在你们应该很容易理解了。我们将 `--example-color` 设置为 `#ccc`，然后在 `.someElement` 中使用它来作为背景颜色。 如果出了一些问题，使我们的 `--example-color` 失效了，那么我们的回退值为 `#d1d1d1`。

如果您没有设置回退值，并且自定义变量无效，会发生什么情况？浏览器将像没有指定该属性一样运行，并执行其常规工作。 

### 技巧与提示

#### 多个回退值

如果希望有多个回退值，该怎么办?你以为可以这样做：

```css
.someElement {
  background-color: var(--first-color, --second-color, white);
}
```

但是这是行不通的。因为 `var()` 函数会把第一个逗号后面的所有内容视为一个值。浏览器会将其认为是 `background-color: --second-color, white;`。这并不是我们想要的。

想要有多个回退值，我们可以简单地在 `var()` 中调用 `var()`。例子如下：  

```css
.someElement {
  background-color: var(--first-color, var(--second-color, white));
}
```

现在这就得到了我们想要的结果。当 `--first-color` 和 `--second-color` 都失效时，浏览器会将背景设置为 `white`。

#### [](#what-if-my-fallback-value-needs-a-comma)如果我的回退值需要逗号怎么办？

例如，如果您想设置一个 `font-family`，并且需要指定一个以上的字体，该怎么办？ 回顾之前的提示，直接用就是了。我们只需要用逗号来写。所以代码应该是这样：

```css
.someElement {
    font-family: var(--main-font, "lucida grande" , tahoma, Arial);
}

```

在这里，我们可以看到 `var()` 函数把第一个逗号后面的所有内容视为一个值。

#### [](#setting-and-getting-custom-properties-in-javascript)在 Javascript 中设置和获取自定义属性

在更复杂的应用程序和网站，Javascript 将用于状态管理和渲染. 您还可以使用 Javascript 获取和设置自定义属性。你可以这样做：

```js
    const element = document.querySelector('.someElement');
   // 获得元素的自定义属性
    element.style.getPropertyValue("--first-color");
   // 设置元素的自定义属性
   element.style.setProperty("--my-color", "#ccc");
```

我们可以像任何其他属性一样获取和设置自定义属性。这还不酷吗？

### 使用自定义变量实现一个主题切换器

先来看看我们即将做出的成品：[预览地址](https://codepen.io/lampewebdev/pen/zYORBwe)

#### HTML 代码 

```html
<div class="grid theme-container">
  <div class="content">
    <div class="demo">
      <label class="switch">
        <input type="checkbox" class="theme-switcher">
        <span class="slider round"></span>
      </label>
    </div>
  </div>
</div>
```

没什么特别的。
我们将使用 CSS 的 `grid` 特性来使内容居中，这就是为什么在第一个元素上具有 `.grid` 类的原因。`.content` 和 `.demo` 类就仅仅是命名。这里的两个关键类是 `.theme-container` 和 `.theme.switcher`。

#### Javascript 代码

```js
const checkbox = document.querySelector(".theme-switcher");

checkbox.addEventListener("change", function() {
  const themeContainer = document.querySelector(".theme-container");
  if (themeContainer && this.checked) {
    themeContainer.classList.add("light");
  } else {
    themeContainer.classList.remove("light");
  }
});
```

首先，我们选择 `.theme-switcher` 输入框 和`.theme-container` 元素。  
然后，我们将添加一个事件侦听器，它将侦听输入框内容是否发生了变化。这意味着每次单击输入时，都将运行该事件监听器的回调函数。
在 `if` 分支当中，我们将检查是否存在 themeContainer 这个对象，以及复选框是否被选中。  
当这个 if 为真时，我们将 `.light` 类加到 `.themeContainer` 元素上，如果它为假，我们将删除它。

为什么我们要删除和添加 `.light` 类? 我们马上就会知晓。

#### CSS 代码

因为这段代码很长，所以我将一步一步地分解!  

```css
.grid {
  display: grid;
  justify-items: center;
  align-content: center;
  height: 100vh;
  width: 100vw;
}
```

首先让我们集中内容布局。我们用 CSS 的 `grid` 特性实现。我们将在另一个 CSS 小妙招中介绍 `grid` 特性！  

```css
:root {
  /* 亮的 */
  --c-light-background: linear-gradient(-225deg, #E3FDF5 0%, #FFE6FA 100%);
  --c-light-checkbox: #fce100;
  /* 暗的 */
  --c-dark-background:linear-gradient(to bottom, rgba(255,255,255,0.15) 0%, rgba(0,0,0,0.15) 100%), radial-gradient(at top center, rgba(255,255,255,0.40) 0%, rgba(0,0,0,0.40) 120%) #989898; 
  --c-dark-checkbox: #757575;
}
```

这里看起来有很多代码和数字，但实际上我们做的不多，我们正在准备将自定义属性用于我们的主题。`--c-dark-` 和 `--c-light-` 是我选择的自定义属性前缀。我们在此之前定义了明暗主题。对于我们的示例，我们只需要`复选框`的颜色和 `background` 属性（在我们的演示中为渐变）。  

```css
.theme-container {
  --c-background: var(--c-dark-background);
  --c-checkbox: var(--c-dark-checkbox);
  background: var(--c-background);
  background-blend-mode: multiply,multiply;
  transition: 0.4s;
}
.theme-container.light {
  --c-background: var(--c-light-background);
  --c-checkbox: var(--c-light-checkbox);
  background: var(--c-background);
}
```

这是整个代码里很重要的一部分。如果你知道我们在做什么，你就会明白为什么我们要定义 `.theme-container` 这个类。我们做了什么呢？这我们使用全局自定义变量的开始。我们不想使用特定的自定义变量。我们想要的是使用全局自定义变量。这就是我们设置 `--c-background` 的原因。从现在开始，我们将只使用全局自定义变量。然后我们设置 `background`。  

```css
.demo {
  font-size: 32px;
}

/* 开关 —— 滑块外的框 */
.switch {
  position: relative;
  display: inline-block;
  width: 60px;
  height: 34px;
}

/* 隐藏默认的 HTML 复选框 */
.switch .theme-switcher {
  opacity: 0;
  width: 0;
  height: 0;
}
```

这只是一些样例代码来设置我们的样式。在 `.demo` 选择器中，我们设置 `font-size` 给切换符号的大小。在 `.switch` 选择器中，`height` 和 `width` 是切换符号后面的元素的长度和宽度。

```css
/* 滑块 */
.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: var(--c-checkbox);
  transition: 0.4s;
}

.slider:before {
  position: absolute;
  content: "🌑";
  height: 0px;
  width: 0px;
  left: -10px;
  top: 16px;
  line-height: 0px;
  transition: 0.4s;
}

.theme-switcher:checked + .slider:before {
  left: 4px;
  content: "🌞";
  transform: translateX(26px);
}
```

到这里，除非你直接在 `.theme.container` 中设定了自定义属性，或者写了其他的代码，那么现在我们终于可以看到自定义属性的效果了。正如你所看到的，切换符号是简单的 Unicode 字符。这就是为什么切换开关在不同的操作系统和手机系统上看起来会不同的原因，这一点你需要注意。还需要注意的是，在 `.slider:before` 选择器中，我们使用 `left` 和 `top` 属性来移动符号。我们在 `.theme-switcher:checked + .slider:before` 中也这样做了，但只使用了 `left` 属性。  

```css
/* 圆形滑块 */
.slider.round {
  border-radius: 34px;
}
```

这里的代码只是为了修改样式。为了将我们的切换开关的拐角变圆。

完成了！现在，我们有了一个可扩展的主题切换器。 ✌😀

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
