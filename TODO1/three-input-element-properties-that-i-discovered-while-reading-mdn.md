> * 原文地址：[Three Input element properties that I discovered while reading MDN](https://dev.to/stefanjudis/three-input-element-properties-that-i-discovered-while-reading-mdn-30fg)
> * 原文作者：[Stefan Judis](https://dev.to/stefanjudis)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/three-input-element-properties-that-i-discovered-while-reading-mdn.md](https://github.com/xitu/gold-miner/blob/master/TODO1/three-input-element-properties-that-i-discovered-while-reading-mdn.md)
> * 译者：[ssshooter](https://github.com/ssshooter)
> * 校对者：[GpingFeng](https://github.com/GpingFeng) [Park-ma](https://github.com/Park-ma)

# 我在阅读 MDN 时发现的 3 个 Input 元素属性

我最近在 Twitter 偶然发现了 [Dan Abramov 的推文](https://twitter.com/dan_abramov/status/1035190868876177409)。他分享的一段简短的代码引起了我注意的。这段代码使用 JavaScript 访问 DOM（([Document Object Model](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model))）中的 input 元素，并读取或更改了它的一些属性，其中令我惊叹的是 `defaultValue` 属性。

我立即打开 MDN 阅读更多关于 `HTTMLInputElement` 的 `defaultValue` 属性，并偶然发现了一些我不知道的属性，这便是我写这篇短文的原因。

那么我们开始吧！

## `defaultValue`

这是 Dan 推文中的示例 — HTML 代码中有一个 input 元素，该元素具有 `value` 属性（attribute）（attribute 在 HTML 代码中定义，而 property 属于 JavaScript 对象）。

```
<input type="text" value="Hello world">
```

现在可以查找到这个元素并做一些处理。

```
const input = document.querySelector('input');

console.log(input.value);        // 'Hello world'

input.value = 'New value';

console.log(input.value);        // 'New value'
console.log(input.defaultValue); // 'Hello world'
```

如你所见，属性 `value` 中定义的值最初反映在元素属性 `value` 中，这没什么特别，但当你改变 `value` 时，仍然可以使用 `defaultValue` 访问“初始值”（`defaultChecked` 在复选框也可用），这就很酷了！

`defaultValue` 在 [MDN 的定义](https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement#Properties)如下：

> [它]返回 / 设置在创建此对象的 HTML 中最初指定的默认值。

你可以在 [CodePen](https://codepen.io/stefanjudis/pen/eLvMMx) 测试这段代码。

## `indeterminate`

`indeterminate` 属性是一个迷人的属性。你可曾知道复选框具有已选和未选之外的其他可视状态？`indeterminate` 是一个 property（没有对应的 attribute），你有时候可能会看到带着一个小破折号的复选框，使用这个属性便能做到。

```
const input = document.querySelector('input');
input.indeterminate = true;
```

[![Checkbox in indeterminate state including a dash instead of being empty or including a checkmark](//images.ctfassets.net/f20lfrunubsq/3DG7ExLKLCEQyWw4ysC4Ag/53ad885c80761ea3aa8f3f5d253b7db2/checkbox.png)](//images.ctfassets.net/f20lfrunubsq/3DG7ExLKLCEQyWw4ysC4Ag/53ad885c80761ea3aa8f3f5d253b7db2/checkbox.png)

将 `indeterminate` 设置为 `true` 对复选框的值没有任何影响，我想到的唯一应用场景是 [Chris Coyier 在 CSSTricks 提到的](https://css-tricks.com/indeterminate-checkboxes/) 嵌套复选框。

`indeterminate` 不仅适用于复选框，还可以用于单选按钮和进度元素。假设有一组单选按钮，没有一个按钮被选择。在你未作出选择前，它们都没有被选中同时也都没有不被选中，这时它们就处于 `indeterminate` 状态。

还有一种玩法，你可以对被选定元素使用 CSS 伪类 `:indeterminate`，这样可以在单选按钮组未被选择时方便展示一些特殊的 UI 组件。

[![Radio buttons followed by a message showcasing the :indeterminate pseudo-class](//images.ctfassets.net/f20lfrunubsq/gR6DWzopxemgaKa4eUika/d71705c5621232e54fa902eda0e87267/radios.png)](//images.ctfassets.net/f20lfrunubsq/gR6DWzopxemgaKa4eUika/d71705c5621232e54fa902eda0e87267/radios.png)

```
.msg {
  display: none;
}

input:indeterminate ~ .msg {
  display: block;
}
```

有关 `indeterminate` 属性的有趣之处在于你可以将它设置为 `true` 或 `false`，这将影响复选框的伪类，但不会影响单选按钮。**对于单选按钮，按钮组的实际选择状态始终是正确的**。

顺道提一下，[progress 元素](https://developer.mozilla.org/de/docs/Web/HTML/Element/progress) 在未定义 `value` 属性时也将匹配 `:indeterminate` 选择器。

`indeterminate` 在 [MDN 的定义](https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement#Properties)如下：

> [它]表示复选框或单选按钮没有值且处于不确定的状态。复选框的外观会变成第三个状态，但这不影响 checked 属性的值，单击复选框会将值设置为 false。

你可以在 [CodePen](https://codepen.io/stefanjudis/pen/WgpzYy) 测试这段代码。

## `selectionStart`、`selectionEnd` 和 `selectionDirection`

这三个属性可以确定用户选择的内容，并且使用起来非常简单。如果用户在输入字段中选择文本，则可以使用这三个属性计算所选内容。

[![Input with selected characters](//images.ctfassets.net/f20lfrunubsq/pTKyzmAjwkSuMqi6wO2iA/e966e1a23477226bf9046a36645300b1/selection.png)](//images.ctfassets.net/f20lfrunubsq/pTKyzmAjwkSuMqi6wO2iA/e966e1a23477226bf9046a36645300b1/selection.png)

```
const input = document.querySelector('input');

setInterval( _ => {
  console.log(
    input.selectionStart,
    input.selectionEnd,
    input.selectionDirection;
  ); // e.g. 2, 5, "forward"
}, 1000)
```

这段测试代码的作用是每秒记录一次选择值。`selectionStart` 和 `selectionEnd` 返回描述我选择位置的索引，但是当你使用鼠标或触控板选择时 `selectionDirection` 返回的是 `none`，而使用 SHIFT 和箭头选择文本时会返回 `forward` 或 `backward`。

你可以在 [CodePen](https://codepen.io/stefanjudis/pen/yxMjWe) 测试这段代码。

以上是这次分享的全部内容。 :)

### 快速简单的总结

MDN 是一种奇妙的网站。即使在我使用了 `input` 元素的八年之后，仍能发现新玩法，这就是我喜欢的 Web 开发的原因。我以后会定期随机阅读 MDN 的文章（我有一个日常 Slack-bot，提醒我打开 [bit.ly/randommdn](http://bit.ly/randommdn)），因为学无止境！我强烈推荐 MDN！

感谢阅读！ ❤️

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

