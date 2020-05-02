> * 原文地址：[CSS Pseudo-Classes You Might Have Missed](https://blog.bitsrc.io/css-pseudo-selectors-you-never-knew-existed-b5c0ddaa8116)
> * 原文作者：[Chidume Nnamdi 🔥💻🎵🎮](https://medium.com/@kurtwanger40)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/css-pseudo-selectors-you-never-knew-existed.md](https://github.com/xitu/gold-miner/blob/master/TODO1/css-pseudo-selectors-you-never-knew-existed.md)
> * 译者：[niayyy](https://github.com/niayyy-S)
> * 校对者：[Long Xiong](https://github.com/xionglong58)、[CoolRice](https://github.com/CoolRice)

# 你可能会错过的 CSS 伪选择器

![](https://cdn-images-1.medium.com/max/2560/1*jrpPfGEYlAZlB5aRNMt2dA.jpeg)

> **（伪）选择器可以为文档中不一定具体存在的结构指定样式，或者为某些元素、文档的标记模式、甚至是文档本身的状态所指示的幻像类指定样式。**
> **— CSS 权威指南：Eric Meyer、Estelle Weyl**

这篇文章鼓励构造 UI 时使用更多纯 CSS 和更少的 JS。熟悉所有的 CSS 是实现这个目标的一种方法 —— 另一种是实施最佳实践和尽可能的减少代码。

## ::first-line | 选择首行文本

这个伪元素选择器选择换行之前文本的首行。

```css
p:first-line {
    color: lightcoral;
}
```

## ::first-letter | 选择首字母

这个伪元素选择器应用于元素中文本的首字母。

```css
.innerDiv p:first-letter {
    color: lightcoral;
    font-size: 40px
}
```

## ::selection | 选择高亮（被选中）的区域

应用于任何被用户选中的高亮区域。

通过 `::selection` 伪元素选择器，我们可以将样式应用于高亮区域。

```css
div::selection {
    background: yellow;
}
```

## :root | 根元素

`:root` 伪类选中文档的根元素。在 HTML 中，为 HTML 元素。在 RSS 中，则为 RSS 元素.

这个伪类选择器应用于根元素，多用于存储全局 CSS 自定义属性。

## :empty | 仅当元素为空时触发

这个伪类选择器将选中没有任何子项的元素。该元素必须为空。如果一个元素没有空格、可见的内容、后代元素，则为空元素。

```
div:empty {
    border: 2px solid orange;
}

<div></div>
<div></div>
<div>
</div>
```

这个规则将应用于空的 `div` 元素。这个规则将应用于第一个和第二个 `div`，因为他们是真为空，而第三个 `div` 包含空格。

## :only-child | 选择仅有的子元素

匹配父元素中没有任何兄弟元素的子元素。

```css
.innerDiv p:only-child {
    color: orangered;
}
```

## :first-of-type | 选择第一个指定类型的子元素

```css
.innerDiv p:first-of-type {
    color: orangered;
}
```

这将应用于 `.innerDiv` 下的第一个 `p` 元素。

```html
<div class="innerDiv">
    <div>Div1</div>
    <p>These are the necessary steps</p>
    <p>hiya</p>
    
    <p>
        Do <em>not</em> push the brake at the same time as the accelerator.
    </p>
    <div>Div2</div>
</div>
```

这个 `p`（“These are the necessary step”）将被选中。

## :last-of-type | 选择最后一个指定类型的子元素

像 `:first-of-type` 一样，但是会应用于最后一个同类型的子元素。

```css
.innerDiv p:last-of-type {
    color: orangered;
}
```

这将应用于 `innerDiv` 下的最后一个 `p` 段落元素。

```html
<div class="innerDiv">
    <p>These are the necessary steps</p>
    <p>hiya</p>
    <div>Div1</div>
    <p>
        Do the same.
    </p>
    <div>Div2</div>
</div>
```

因此，这个 `p` 元素（“Do the same”）将被选中。

## :nth-of-type() | 选择特定类型的子元素

这个选择器将从指定的父元素的孩子列表中选择某种类型的子元素。

```css
.innerDiv p:nth-of-type(1) {
    color: orangered;
}
```

## :nth-last-of-type() | 选择列表末尾中指定类型的子元素

这将选择最后一个指定类型的子元素。

```css
.innerDiv p:nth-last-of-type() {
    color: orangered;
}
```

这将选择 `innerDiv` 列表元素中包含的最后一个段落类型子元素。

```html
<div class="innerDiv">
    <p>These are the necessary steps</p>
    <p>hiya</p>
    <div>Div1</div>
    <p>
        Do the same.
    </p>
    <div>Div2</div>
</div>
```

`innerDiv` 中最后一个段落子元素 `p`（“Do the same”）将会被选中。

## :link | 选择一个未访问过的超链接

这个选择器应用于未被访问过的链接。常用于带有 href 属性的 `a` 锚元素。

```
a:link {
    color: orangered;
}

<a href="/login">Login<a>
```

这将选中未被点击过带有 `href` 的指定界面的 `a` 锚点元素，选中的元素中的文字将会显示为橙色。

## :checked | 选择一个选中的复选框

这个应用于已经被选中的复选框。

```css
input:checked {
    border: 2px solid lightcoral;
}
```

这个规则应用到所有被选中的复选框。

## :valid | 选择一个通过验证的元素

这主要用于可视化表单元素，以让用户判断是否验证通过。验证通过时，默认元素带有 `valid` 属性。

```css
input:valid {
    boder-color: lightsalmon;
}
```

## :invalid | 选择一个未通过验证的元素

像 `:valid` 一样，但是会应用到未通过验证的元素。

```css
input[type="text"]:invalid {
    border-color: red;
}
```

## :lang() | 选择指定语言的元素

应用于指定了语言的元素。

可以通过以下两种方式使用：

```css
p:lang(fr) {
    background: yellow;
}
```

或者

```css
p[lang|="fr"] {
    background: yellow;
}

<p lang="fr">Paragraph 1</p>
```

## :not() | 对于选择取反（这是一个运算符）

否定伪类选择器选中相反的。

让我们看一个示例：

```
.innerDiv :not(p) {
    color: lightcoral;
}

<div class="innerDiv">
    <p>Paragraph 1</p>
    <p>Paragraph 2</p>
    <div>Div 1</div>
    <p>Paragraph 3</p>
    <div>Div 2</div>
</div>
```

`Div 1` 和 `Div 2` 会被选中，因为他们不是 `p` 元素。

## 结论

就这些了。这是全部内容。还有更多的伪选择器，但是为非标准的，因此我省略了它们。

感谢！！

## 引用

* [CSS 权威指南 —— Eric A. Meyer、Estelle Weyl](https://www.amazon.com/CSS-Definitive-Guide-Eric-Meyer/dp/0596527330)

## 了解更多

[Theming React Components with CSS Variables](https://blog.bitsrc.io/theming-react-components-with-css-variables-ee52d1bb3d90)
[11 Chrome APIs That Will Give Your Web App a Native Feel](https://blog.bitsrc.io/11-chrome-apis-that-give-your-web-app-a-native-feel-ad35ad648f09)
[10 Useful Web APIs for 2020](https://blog.bitsrc.io/10-useful-web-apis-for-2020-8e43905cbdc5)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
