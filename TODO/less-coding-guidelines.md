>* 原文链接 : [LESS Coding Guidelines](https://gist.github.com/fat/a47b882eb5f84293c4ed)
* 原文作者 : [fat](https://gist.github.com/fat)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Gran](https://github.com/Graning)
* 校对者: [hpf](https://github.com/hpoenixf) ,[MAYDAY1993](https://github.com/MAYDAY1993)


# Medium 内部使用 css/less 的代码风格指南

Medium 对代码风格使用了  [LESS](http://lesscss.org/)  的一种严格子集。这个子集包含变量和混合指令，但是没有别的（嵌套等等）。

Medium 的常规命名改编自正在进行适配工作的 CSS 框架。这就是说，它依赖于 _结构化类名_ 和 _有意义的连字符_ （即不使用连字符只为了把单词分开）。这是为了帮助 CSS 应用到 DOM 围绕当前的限制（即缺乏风格封装）更好的进行类关系之间的通讯。


**目录**

* [JavaScript](#javascript)
* [Utilities（工具）](#utilities)
  * [u-utilityName](#u-utilityName)
* [Components（组件）](#components)
  * [componentName](#componentName)
  * [componentName--modifierName](#componentName--modifierName)
  * [componentName-descendantName](#componentName-descendantName)
  * [componentName.is-stateOfComponent](#is-stateOfComponent)
* [Variables（变量）](#variables)
  * [colors](#colors)
  * [z-index](#zindex)
  * [font-weight](#fontweight)
  * [line-height](#lineheight)
  * [letter-spacing](#letterspacing)
* [Polyfills](#polyfills)
* [Formatting（格式）](#formatting)
  * [Spacing](#spacing)
  * [Quotes](#quotes)
* [Performance（性能）](#performance)
  * [Specificity](#specificity)


<a name="javascript"></a>
## JavaScript

语法: `js-<targetName>`

JavaScript 具体类减少了更改构件的结构或主题不经意间影响到任何需要 JavaScript 特性以及复杂功能的风险。没必要在所有情况下使用它们，只是把它们当做你工具带的工具。如果你要创建一个类，而不打算使用样式，而只是在 JavaScript 中选择，你可能应该加上 `js-` 前缀。在具体的实践中它看起来这样：

```html
<a href="/login" class="btn btn-primary js-login"></a>
```

**同样，JavaScript 的特定的类不应该在任何情况下设置样式。**

<a name="utilities"></a>
## Utilities 工具

Medium 的工具类采用低层次的结构和位置特征。工具们可直接应用于任何元素；可多工具同时应用；跟组件类一起被使用。

Utilities 存在是因为某些 CSS 属性和模式经常使用。例如： floats, containing floats, vertical alignment, text truncation .依靠实用程序可以帮助减少重复和提供一致的实现，它们同时还充当了功能性混合指令的替代功能（即非填充工具）。


```html
<div class="u-clearfix">
  <p class="u-textTruncate">{$text}</p>
  <img class="u-pullLeft" src="{$src}" alt="">
  <img class="u-pullLeft" src="{$src}" alt="">
  <img class="u-pullLeft" src="{$src}" alt="">
</div>
```

<a name="u-utilityName"></a>
### u-utilityName

语法: `u-<utilityName>`

Utilities 必须使用驼峰命名, 前缀带有 `u` 的命名空间。 以下是对如何不同的实用程序可用于组件内建立一个简单的结构的例子。

```html
<div class="u-clearfix">
  <a class="u-pullLeft" href="{$url}">
    <img class="u-block" src="{$src}" alt="">
  </a>
  <p class="u-sizeFill u-textBreak">
    …
  </p>
</div>
```

<a name="components"></a>
## components 组件

语法: `<componentName>[--modifierName|-descendantName]`

读取和写入 HTML 和 CSS 当组件驱动的开发有几个好处：

* 它有助于在不同的类之间区分根组件，子元素和修改。
* 它保持低选择器的特异性。
* 它有助于从文档语义去耦呈现语义。

你可以将组件当做该封装的特定语义，样式和行为的自定义元素。


<a name="componentName"></a>
### componentName

组件名必须使用驼峰命名法。

```css
.myComponent { /* … */ }
```

```html
<article class="myComponent">
  …
</article>
```

<a name="componentName--modifierName"></a>
### componentName--modifierName

组件修饰器是一种可以在某种形式改变基础组件的样式的类。修饰器的名字必须为驼峰式并通过两个连字符与组件的名字分开。类应该包括在 _除了_ 基础构件类的 HTML 。

```css
/* Core button */
.btn { /* … */ }
/* Default button style */
.btn--default { /* … */ }
```

```html
<button class="btn btn--primary">…</button>
```
<a name="componentName-descendantName"></a>
### componentName-descendantName

子组件是附加到一个组件的子节点的类。它负责代表特定组件直接应用呈现给子代。子代命名也要使用驼峰式命名。 

```html
<article class="tweet">
  <header class="tweet-header">
    <img class="tweet-avatar" src="{$src}" alt="{$alt}">
    …
  </header>
  <div class="tweet-body">
    …
  </div>
</article>
```

<a name="is-stateOfComponent"></a>
### componentName.is-stateOfComponent

使用 `is-stateName` 对部件进行基于状态的修改。状态名命名也要使用驼峰式。 **不要把这些样式当做类；它们应该被常用作相邻的类。**

JS 可以添加或删除这些类。这意味着相同的状态名称可以在上下文中多次使用，但每一组件必须定义它自己的样式的状态（因为它们被限定在组件）。

```css
.tweet { /* … */ }
.tweet.is-expanded { /* … */ }
```

```html
<article class="tweet is-expanded">
  …
</article>
```


<a name="variables"></a>
## Variables 变量

语法: `<property>-<value>[--componentName]`

在我们的 CSS 中变量名也有严格的结构。此语法提供属性，使用和组件之间的强关联。

以下变量为指标确定颜色属性，其值为grayLight，与highlightMenu组件一起使用2。

```CSS
@color-grayLight--highlightMenu: rgb(51, 51, 50);
```

<a name="colors"></a>
### Colors

在实现特性的样式时，你只应使用由 colors.less 提供的颜色变量。

当添加一个颜色变量 colors.less ，使用 RGB 和 RGBA 颜色单位优先于十六进制，命名， HSL 和 HSLA 值。

**正确的做法:**
```css
rgb(50, 50, 50);
rgba(50, 50, 50, 0.2);
```

**错误的做法:**
```css
#FFF;
#FFFFFF;
white;
hsl(120, 100%, 50%);
hsla(120, 100%, 50%, 1);
```

<a name="zindex"></a>
### z-index scale

请使用 Z-index.less 定义 z-index 的范围。

`@zIndex-1 - @zIndex-9` 提供了。 没什么应该比 `@zIndex-9` 高。


<a name="fontweight"></a>
### Font Weight

随着网页字体的额外支持 `font-weight` 起着比从前重要的作用。不同的字体粗细将专门渲染重建。不像曾经的 `bold` 只是通过一个算法来增粗字体。明显的使用 `font-weight` 的值，以使字体的最佳展示。下面是一个指导：

原始定义字体粗细应尽量避免。相反，使用合适的字体混合指令: `.font-sansI7, .font-sansN7, 等等.`

后缀定义粗细和样式：

```CSS
N = normal
I = italic
4 = normal font-weight
7 = bold font-weight
```

请参考 type.less 类型的大小，字母间距和行高。原尺寸，空格和线的高度应避免在 type.less 之外。


```CSS
ex:

@fontSize-micro
@fontSize-smallest
@fontSize-smaller
@fontSize-small
@fontSize-base
@fontSize-large
@fontSize-larger
@fontSize-largest
@fontSize-jumbo
```

参见 [Mozilla Developer Network — font-weight](https://developer.mozilla.org/en/CSS/font-weight) 进一步阅读。


<a name="lineheight"></a>
### Line Height

Type.less 还提供了一个行高比例。这本应该用于文本块。


```CSS
ex:

@lineHeight-tightest
@lineHeight-tighter
@lineHeight-tight
@lineHeight-baseSans
@lineHeight-base
@lineHeight-loose
@lineHeight-looser
```

另外，使用行高垂直居中单行文本的时候，一定要将行高设置为容器的高度 -1 。

```CSS
.btn {
  height: 50px;
  line-height: 49px;
}
```

<a name="letterspacing"></a>
### Letter spacing

字母间隔同样也应该跟随 var 进行比例控制。

```CSS
@letterSpacing-tightest
@letterSpacing-tighter
@letterSpacing-tight
@letterSpacing-normal
@letterSpacing-loose
@letterSpacing-looser
````

<a name="polyfills"></a>
## Polyfills

混合指令语法: `m-<propertyName>`

在 Medium 我们只用混合指令生成浏览前缀属性 polyfills 。


边框半径混合指令的例子：

```css
.m-borderRadius(@radius) {
  -webkit-border-radius: @radius;
     -moz-border-radius: @radius;
          border-radius: @radius;
}
```


<a name="formatting"></a>
## Formatting

以下是一些高水平的网页格式样式规则。

<a name="spacing"></a>
### Spacing

CSS 规则在新的一行应该用逗号分开：

**正确的写法:**
```css
.content,
.content-edit {
  …
}
```

**错误的写法:**
```css
.content, .content-edit {
  …
}
```

CSS 块应由一个新行分开，而不是两个并且不为 0 。

**正确的写法:**
```css
.content {
  …
}
.content-edit {
  …
}
```

**错误的写法:**
```css
.content {
  …
}

.content-edit {
  …
}
```


<a name="quotes"></a>
### Quotes

引号在 CSS 和 LESS 可选。我们使用双引号，因为它视觉上更加简洁，而且该字符串不是选择或样式属性。

**正确的写法:**
```css
background-image: url("/img/you.jpg");
font-family: "Helvetica Neue Light", "Helvetica Neue", Helvetica, Arial;
```

**错误的写法:**
```css
background-image: url(/img/you.jpg);
font-family: Helvetica Neue Light, Helvetica Neue, Helvetica, Arial;
```

<a name="performance"></a>
## Performance 性能

<a name="specificity"></a>
### Specificity

虽然在名称（层叠样式表）层叠会增加不必要的性能支出在应用样式上。看看下面的例子：

```css
ul.user-list li span a:hover { color: red; }
```

样式渲染在布局处理过程中解决。该选择器从右到左进行，当它不匹配时退出。因此，本例中的每个标记有待检查，看它是否驻留在 span 和 list 内。你可以想象，这需要大量的 DOM 操作，大型文档的话可能导致布局时间增多。进一步阅读： https://developers.google.com/speed/docs/best-practices/rendering#UseEfficientCSSSelectors

如果我们知道给所有 `a` 元素在 `.user-list` 悬停时变红，我们可以简化这种样式：

```css
.user-list > a:hover {
  color: red;
}
```

如果我们仅仅想给 `.user-list` 中的 a 元素设置特别的样式，我们可以给他们设定一个特定的类。

```css
.user-list > .link-primary:hover {
  color: red;
}
```
