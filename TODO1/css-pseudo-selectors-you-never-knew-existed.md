> * 原文地址：[CSS Pseudo-Classes You Might Have Missed](https://blog.bitsrc.io/css-pseudo-selectors-you-never-knew-existed-b5c0ddaa8116)
> * 原文作者：[Chidume Nnamdi 🔥💻🎵🎮](https://medium.com/@kurtwanger40)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/css-pseudo-selectors-you-never-knew-existed.md](https://github.com/xitu/gold-miner/blob/master/TODO1/css-pseudo-selectors-you-never-knew-existed.md)
> * 译者：
> * 校对者：

# CSS Pseudo-Classes You Might Have Missed

#### Useful CSS pseudo-classes that are often overlooked.

![](https://cdn-images-1.medium.com/max/2560/1*jrpPfGEYlAZlB5aRNMt2dA.jpeg)

> # **(Pseudo) selectors let you assign styles to what are, in effect, phantom classes that are inferred by the state of certain elements, or markup patterns within the document, or even by the state of the document itself.**

> # **— CSS: The Definitive Guide: Eric Meyer, Estelle Weyl**

This post is a sort-of encouragement to use more plain CSS and less JS when building your UI. Getting familiar with everything CSS has to offer is one way to achieving that — another one is implementing best practices and reusing that code, as much as possible.

To reuse your UI components try using cloud component hubs like [**Bit.dev**](https://bit.dev). Use it to publish, document and organize all your team’s reusable UI components. It’s not only a way to build faster but also a way to build better as it encourages you to standardize and modularize your code.

![Exploring shared UI components on [bit.dev](https://bit.dev)](https://cdn-images-1.medium.com/max/2000/1*Nj2EzGOskF51B5AKuR-szw.gif)

## ::first-line | Selects the first line of text

This pseudo selector affects the first line of text before a line breaks.

```
p:first-line {
    color: lightcoral;
}
```

## ::first-letter | Selects the first letter

This pseudo selector applies to the first letter of the text in an element.

```
.innerDiv p:first-letter {
    color: lightcoral;
    font-size: 40px
}
```

## ::selection | Selects the highlighted (selected) area

This applies to any area that has been highlighted by the user.

With the `::selection` pseudo-selector, we can apply our styling to the area that we highlight.

```
div::selection {
    background: yellow;
}
```

## :root | Basic element

The `:root` pseudo-class selects the root element of the document. In HTML, it is always the HTML element. In RSS, it is the RSS element.

This pseudo selector is most used to store global rule values using CSS variable as it applies to the root element.

## :empty | Applies only if the item is empty

This pseudo selector will select any element that has no children of any kind. The element must be empty. An element is empty if it has no whitespace, visible content, or descendant elements.

```
div:empty {
    border: 2px solid orange;
}

<div></div>
<div></div>
<div>
</div>
```

The rule will apply to empty div elements. The rule will be applied to the first and second div because they are truly empty, not the third div because it has whitespace.

## :only-child | Selects an only child

This applies to an element that is the only child of its parent element.

```
.innerDiv p:only-child {
    color: orangered;
}
```

## :first-of-type | Selects the first child element of a specified type

```
.innerDiv p:first-of-type {
    color: orangered;
}
```

This would apply to the first child of `.innerDiv` of `p` paragraph element.

```
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

The p ("These are the necessary step") would be selected.

## :last-of-type | Selects the last child element of a specified type

Same as `:first-of-type`, but this will affect the last child element of the same type.

```
.innerDiv p:last-of-type {
    color: orangered;
}
```

This would apply to the last child of `innerDiv` of type `p` paragraph element.

```
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

So, the `p` element `("Do the same")` would be selected.

## :nth-of-type() | Selects the child element of a specified type

This selector would select an element of a certain type from the list of the specified parent element.

```
.innerDiv p:nth-of-type(1) {
    color: orangered;
}
```

## :nth-last-of-type() | Selects the child element of a type by the end of a list

This will select the last child element of a certain type.

```
.innerDiv p:nth-last-of-type() {
    color: orangered;
}
```

This will select the last child element in the list contained in the `innerDiv` element and of type, paragraph element.

```
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

## :link | Selects an unvisited hyperlink

This selector applies to links that have not been visited. This is mostly used with the `a` anchor element with href attribute.

```
a:link {
    color: orangered;
}

<a href="/login">Login<a>
```

This will make all `a` anchor elements with a href attribute that has not been clicked to visit the page in its href attribute to have an orangered color text.

## :checked | Selects a checked checkbox

This applies to checkbox that has been checked.

```
input:checked {
    border: 2px solid lightcoral;
}
```

This rule applies to all checkboxes that have been clicked on to check it.

## :valid | Selects an element that is valid

This is mostly used in forms to visualize form elements that pass validation set by the user. When a validation passes, the defaulting element is set with the `valid` attribute.

```
input:valid {
    boder-color: lightsalmon;
}
```

## :invalid | Selects an element that is invalid

Same as `:valid` but this will apply to elements that have failed the validation test.

```
input[type="text"]:invalid {
    border-color: red;
}
```

## :lang() | Selects an element by a specified lang value

This applies to elements that have their language specified.

It can be set in two ways either by this:

```
p:lang(fr) {
    background: yellow;
}
```

or

```
p[lang|="fr"] {
    background: yellow;
}

<p lang="fr">Paragraph 1</p>
```

## :not() | Negates the following selections (this is an operator)

A negation pseudo-selector selects what is not.

Let’s see an example:

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

`Div 1` and `Div 2` will be selected because they are not `p` elements.

## Conclusion

That’s it. We exhausted the list. There are more pseudoselectors, but they are not standard so I left them out.

Thanks!!

## References

* [CSS: The Definitive guide — Eric A. Meyer, Estelle Weyl](https://www.amazon.com/CSS-Definitive-Guide-Eric-Meyer/dp/0596527330)

## Learn More
[**Theming React Components with CSS Variables**
**Two ways to theme React components using CSS custom properties.**blog.bitsrc.io](https://blog.bitsrc.io/theming-react-components-with-css-variables-ee52d1bb3d90)
[**11 Chrome APIs That Will Give Your Web App a Native Feel**
**11 Chrome APIs that will give your web app a native-like user experience.**blog.bitsrc.io](https://blog.bitsrc.io/11-chrome-apis-that-give-your-web-app-a-native-feel-ad35ad648f09)
[**10 Useful Web APIs for 2020**
**Awesome Web APIs for your next web app — with examples.**blog.bitsrc.io](https://blog.bitsrc.io/10-useful-web-apis-for-2020-8e43905cbdc5)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
