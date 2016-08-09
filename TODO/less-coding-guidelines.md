>* 原文链接 : [LESS Coding Guidelines](https://gist.github.com/fat/a47b882eb5f84293c4ed)
* 原文作者 : [fat](https://gist.github.com/fat)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Gran](https://github.com/Graning)
* 校对者: 


# Medium 内部使用 css/less 的代码风格指南

Medium 对代码风格使用严格的子集 [LESS](http://lesscss.org/) 。这个子集包含变量和混合类型，但是没有别的（没有嵌套等等）。

Medium 的常规命名改编自正在进行适配工作的 CSS 框架。这就是说，它依赖于_结构化类名_和_有意义的连字符_（即不使用连字符只为了把单词分开）。这是为了帮助 CSS 应用到 DOM 围绕当前的限制（即缺乏风格封装）更好的进行类关系之间的通讯。


**目录**

* [JavaScript](#javascript)
* [Utilities](#utilities)
  * [u-utilityName](#u-utilityName)
* [Components](#components)
  * [componentName](#componentName)
  * [componentName--modifierName](#componentName--modifierName)
  * [componentName-descendantName](#componentName-descendantName)
  * [componentName.is-stateOfComponent](#is-stateOfComponent)
* [Variables](#variables)
  * [colors](#colors)
  * [z-index](#zindex)
  * [font-weight](#fontweight)
  * [line-height](#lineheight)
  * [letter-spacing](#letterspacing)
* [Polyfills](#polyfills)
* [Formatting](#formatting)
  * [Spacing](#spacing)
  * [Quotes](#quotes)
* [Performance](#performance)
  * [Specificity](#specificity)


<a name="javascript"></a>
## JavaScript

语法: `js-<targetName>`

JavaScript 具体类减少了更改构件的结构或主题不经意间影响到任何需要 JavaScript 特性以及复杂功能的风险。没必要在所有情况下使用它们，只是把它们当做你工具带的工具。如果你要创建一个类，而不打算使用样式，而只是在 JavaScript 中选择，你可能应该加上 `js-` 前缀。在具体的实践中它看起来这样：

```html
<a href="/login" class="btn btn-primary js-login"></a>
```

**Again, JavaScript-specific classes should not, under any circumstances, be styled.**

<a name="utilities"></a>
## 工具（感觉好别扭，校对者看看有没有其他译法）

Medium 的工具类采用低层次的结构和位置特征。实用程序可直接应用于任何元件；可多工具同时应用；同时可以横靠在组件类中使用。

Utilities 存在是因为某些 CSS 属性和模式经常使用。例如： floats, containing floats, vertical alignment, text truncation.依靠实用程序可以帮助减少重复和提供一致的实现，它们同时还充当哲学的替代功能（即非填充工具）的混入。



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

Syntax: `u-<utilityName>`

Utilities must use a camel case name, prefixed with a `u` namespace. What follows is an example of how various utilities can be used to create a simple structure within a component.

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
## Components

Syntax: `<componentName>[--modifierName|-descendantName]`

Component driven development offers several benefits when reading and writing HTML and CSS:

* It helps to distinguish between the classes for the root of the component, descendant elements, and modifications.
* It keeps the specificity of selectors low.
* It helps to decouple presentation semantics from document semantics.

You can think of components as custom elements that enclose specific semantics, styling, and behaviour.


<a name="componentName"></a>
### ComponentName

The component's name must be written in camel case.

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

A component modifier is a class that modifies the presentation of the base component in some form. Modifier names must be written in camel case and be separated from the component name by two hyphens. The class should be included in the HTML _in addition_ to the base component class.

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

A component descendant is a class that is attached to a descendant node of a component. It's responsible for applying presentation directly to the descendant on behalf of a particular component. Descendant names must be written in camel case.

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

Use `is-stateName` for state-based modifications of components. The state name must be Camel case. **Never style these classes directly; they should always be used as an adjoining class.**

JS can add/remove these classes. This means that the same state names can be used in multiple contexts, but every component must define its own styles for the state (as they are scoped to the component).

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
## Variables

Syntax: `<property>-<value>[--componentName]`

Variable names in our CSS are also strictly structured. This syntax provides strong associations between property, use, and component.

The following variable defintion is a color property, with the value grayLight, for use with the highlightMenu component.

```CSS
@color-grayLight--highlightMenu: rgb(51, 51, 50);
```

<a name="colors"></a>
### Colors

When implementing feature styles, you should only be using color variables provided by colors.less.

When adding a color variable to colors.less, using RGB and RGBA color units are preferred over hex, named, HSL, or HSLA values.

**Right:**
```css
rgb(50, 50, 50);
rgba(50, 50, 50, 0.2);
```

**Wrong:**
```css
#FFF;
#FFFFFF;
white;
hsl(120, 100%, 50%);
hsla(120, 100%, 50%, 1);
```

<a name="zindex"></a>
### z-index scale

Please use the z-index scale defined in z-index.less.

`@zIndex-1 - @zIndex-9` are provided. Nothing should be higher then `@zIndex-9`.


<a name="fontweight"></a>
### Font Weight

With the additional support of web fonts `font-weight` plays a more important role than it once did. Different font weights will render typefaces specifically created for that weight, unlike the old days where `bold` could be just an algorithm to fatten a typeface. Obvious uses the numerical value of `font-weight` to enable the best representation of a typeface. The following table is a guide:

Raw font weights should be avoided. Instead, use the appropriate font mixin: `.font-sansI7, .font-sansN7, etc.`

The suffix defines the weight and style:

```CSS
N = normal
I = italic
4 = normal font-weight
7 = bold font-weight
```

Refer to type.less for type size, letter-spacing, and line height. Raw sizes, spaces, and line heights should be avoided outside of type.less.


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

See [Mozilla Developer Network — font-weight](https://developer.mozilla.org/en/CSS/font-weight) for further reading.


<a name="lineheight"></a>
### Line Height

Type.less also provides a line height scale. This should be used for blocks of text.


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

Alternatively, when using line height to vertically center a single line of text, be sure to set the line height to the height of the container - 1.

```CSS
.btn {
  height: 50px;
  line-height: 49px;
}
```

<a name="letterspacing"></a>
### Letter spacing

Letter spacing should also be controlled with the following var scale.

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

mixin syntax: `m-<propertyName>`

At Medium we only use mixins to generate polyfills for browser prefixed properties.


An example of a border radius mixin:

```css
.m-borderRadius(@radius) {
  -webkit-border-radius: @radius;
     -moz-border-radius: @radius;
          border-radius: @radius;
}
```


<a name="formatting"></a>
## Formatting

The following are some high level page formatting style rules.

<a name="spacing"></a>
### Spacing

CSS rules should be comma seperated but live on new lines:

**Right:**
```css
.content,
.content-edit {
  …
}
```

**Wrong:**
```css
.content, .content-edit {
  …
}
```

CSS blocks should be seperated by a single new line. not two. not 0.

**Right:**
```css
.content {
  …
}
.content-edit {
  …
}
```

**Wrong:**
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

Quotes are optional in CSS and LESS. We use double quotes as it is visually clearer that the string is not a selector or a style property.

**Right:**
```css
background-image: url("/img/you.jpg");
font-family: "Helvetica Neue Light", "Helvetica Neue", Helvetica, Arial;
```

**Wrong:**
```css
background-image: url(/img/you.jpg);
font-family: Helvetica Neue Light, Helvetica Neue, Helvetica, Arial;
```

<a name="performance"></a>
## Performance

<a name="specificity"></a>
### Specificity

Although in the name (cascading style sheets) cascading can introduce unnecessary performance overhead for applying styles. Take the following example:

```css
ul.user-list li span a:hover { color: red; }
```

Styles are resolved during the renderer's layout pass. The selectors are resolved right to left, exiting when it has been detected the selector does not match. Therefore, in this example every a tag has to be inspected to see if it resides inside a span and a list. As you can imagine this requires a lot of DOM walking and and for large documents can cause a significant increase in the layout time. For further reading checkout: https://developers.google.com/speed/docs/best-practices/rendering#UseEfficientCSSSelectors

If we know we want to give all `a` elements inside the `.user-list` red on hover we can simplify this style to:

```css
.user-list > a:hover {
  color: red;
}
```

If we want to only style specific `a` elements inside `.user-list` we can give them a specific class:

```css
.user-list > .link-primary:hover {
  color: red;
}
```
