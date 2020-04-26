> * 原文地址：[CSS Pseudo-Classes You Might Have Missed](https://blog.bitsrc.io/css-pseudo-selectors-you-never-knew-existed-b5c0ddaa8116)
> * 原文作者：[Chidume Nnamdi 🔥💻🎵🎮](https://medium.com/@kurtwanger40)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/css-pseudo-selectors-you-never-knew-existed.md](https://github.com/xitu/gold-miner/blob/master/TODO1/css-pseudo-selectors-you-never-knew-existed.md)
> * 译者：
> * 校对者：

# 你可能会错过的 CSS 伪类

![](https://cdn-images-1.medium.com/max/2560/1*jrpPfGEYlAZlB5aRNMt2dA.jpeg)

> **（伪）选择器让你 selectors let you assign styles to what are, in effect, 幻影类phantom classes that are inferred by the state of certain elements, or markup patterns within the document, or even by the state of the document itself.**
> **— CSS 权威指南: Eric Meyer, Estelle Weyl**

这篇文章鼓励构造 UI 时使用更多普通的 CSS 和更少的 JS。熟悉所有的 CSS 是实现这个目标的一种方法 —— 另一种是使用最佳的做法来尽可能地减少代码。

## ::first-line | 选中首行文本

这个伪选择器在换行之前影响文本的首行。

```css
p:first-line {
    color: lightcoral;
}
```

## ::first-letter | 选中首个单词

这个伪选择器应用于元素中文本的首个单词。

```css
.innerDiv p:first-letter {
    color: lightcoral;
    font-size: 40px
}
```

## ::selection | 选中高亮（被选中）的区域

应用于任何被用户选中的高亮区域。

通过 `::selection` 伪选择器，我们可以将样式应用于高亮区域。

```css
div::selection {
    background: yellow;
}
```

## :root | 根元素

`:root` 伪类选中文档的根元素。在 HTML 中，为 HTML 元素。在 RSS 中，则为 RSS 元素.

这个伪选择器多用于使用 CSS 变量存储全局自定义属性，因为它应用于根元素。

## :empty | 仅当元素为空时触发

这个伪选择器将选中没有任何子项的元素。该元素必须为空。如果一个元素没有空格、可见的内容、后代元素，则为空元素。

```
div:empty {
    border: 2px solid orange;
}

<div></div>
<div></div>
<div>
</div>
```

这个规则将应用于空的 `div` 元素。这个规则将应用于第一个和第二个 `div`，因为他们是真为空，而第三个 div 包含空格。

## :only-child | 选中仅有的子元素

应用于父元素仅有的子元素。

```css
.innerDiv p:only-child {
    color: orangered;
}
```

## :first-of-type | 选中第一个指定类型的子元素

```css
.innerDiv p:first-of-type {
    color: orangered;
}
```

这将应用到 `.innerDiv` 下的第一个 `p` 段落元素。

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

这个 `p`（"These are the necessary step"）将被选中。

## :last-of-type | 选中最后一个指定类型的子元素

像 `:first-of-type` 一样，但是会选中最后一个同类型的子元素。

```css
.innerDiv p:last-of-type {
    color: orangered;
}
```

这将应用到 `innerDiv` 下的最后一个 `p` 段落元素。

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

因此，这个 `p` 元素（"Do the same"）将被选中。

## :nth-of-type() | 选中特定类型的子元素

这个选择器将从指定的父元素列表中选中某种类型的元素。

```css
.innerDiv p:nth-of-type(1) {
    color: orangered;
}
```

## :nth-last-of-type() | Selects the child element of a type by the end of a list

This will select the last child element of a certain type.

```css
.innerDiv p:nth-last-of-type() {
    color: orangered;
}
```

This will select the last child element in the list contained in the `innerDiv` element and of type, paragraph element.

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

The p `Do the same` is the last paragraph child element inside the `innerDiv` so it will be selected and affected by the CSS rule.

## :link | 选中一个为访问过的超链接

这个选择器应用于为被访问过的链接。常用于带有 href 属性的 `a` 锚元素。

```
a:link {
    color: orangered;
}

<a href="/login">Login<a>
```

This will make all `a` anchor elements with a href attribute that has not been clicked to visit the page in its href attribute to have an orangered color text.

## :checked | 选择一个选中的复选框

这个应用于已经被选中的复选框。

```css
input:checked {
    border: 2px solid lightcoral;
}
```

This rule applies to all checkboxes that have been clicked on to check it.

## :valid | 选中一个有效的元素

This is mostly used in forms to visualize form elements that pass validation set by the user. When a validation passes, the defaulting element is set with the `valid` attribute.

```css
input:valid {
    boder-color: lightsalmon;
}
```

## :invalid | 选中一个无效的元素

像 `:valid` 一样，但是会应用到未通过验证测试的元素。

```css
input[type="text"]:invalid {
    border-color: red;
}
```

## :lang() | 选中指定语言的元素

应用于指定了语言的元素。

可以通过以下两种方式使用：

```css
p:lang(fr) {
    background: yellow;
}
```

or

```css
p[lang|="fr"] {
    background: yellow;
}

<p lang="fr">Paragraph 1</p>
```

## :not() | 对于选择取反（这是一个操作）

否定伪选择器选中相反的。

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

That’s it. We exhausted the list. There are more pseudoselectors, but they are not standard so I left them out.

感谢！！

## 引用

* [CSS 权威指南 —— Eric A. Meyer, Estelle Weyl](https://www.amazon.com/CSS-Definitive-Guide-Eric-Meyer/dp/0596527330)

## 了解更多

[Theming React Components with CSS Variables](https://blog.bitsrc.io/theming-react-components-with-css-variables-ee52d1bb3d90)
[11 Chrome APIs That Will Give Your Web App a Native Feel](https://blog.bitsrc.io/11-chrome-apis-that-give-your-web-app-a-native-feel-ad35ad648f09)
[10 Useful Web APIs for 2020](https://blog.bitsrc.io/10-useful-web-apis-for-2020-8e43905cbdc5)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
