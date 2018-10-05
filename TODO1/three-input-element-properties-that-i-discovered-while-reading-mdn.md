> * 原文地址：[Three Input element properties that I discovered while reading MDN](https://dev.to/stefanjudis/three-input-element-properties-that-i-discovered-while-reading-mdn-30fg)
> * 原文作者：[Stefan Judis](https://dev.to/stefanjudis)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/three-input-element-properties-that-i-discovered-while-reading-mdn.md](https://github.com/xitu/gold-miner/blob/master/TODO1/three-input-element-properties-that-i-discovered-while-reading-mdn.md)
> * 译者：
> * 校对者：

# Three Input element properties that I discovered while reading MDN

Recently I was reading Twitter and stumbled across [a tweet by Dan Abramov](https://twitter.com/dan_abramov/status/1035190868876177409). He shared a short code snippet that caught my eye. It included some JavaScript which accessed an input element from the DOM ([Document Object Model](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model)) and read or changed some of its properties. What was exciting and surprising to me was the property `defaultValue`.

I immediately opened MDN to read more about this property of `HTTMLInputElements` and stumbled upon a few more properties that I wasn't aware of, which lead me to write this quick article.

So here we go!

## `defaultValue`

This is Dan's Tweet example – let's have a quick look and assume you have some HTML and query an input element which has a `value` attribute (attributes are defined in the HTML whereas properties belong to JavaScript objects) defined.

```
<input type="text" value="Hello world">
```

You can now grab this element and start tinkering around with it.

```
const input = document.querySelector('input');

console.log(input.value);        // 'Hello world'

input.value = 'New value';

console.log(input.value);        // 'New value'
console.log(input.defaultValue); // 'Hello world'
```

As you see that the value defined in the attribute `value` is initially reflected in the element property `value`. That makes total sense to me. When you now change `value`, you can still access the "initial value" using `defaultValue` (for checkboxes `defaultChecked` is also available). Pretty cool!

[The MDN definition](https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement#Properties) for `defaultValue` is a follows:

> [It] returns / sets the default value as initially specified in the HTML that created this object.

If you like you can play around with the code in [a CodePen](https://codepen.io/stefanjudis/pen/eLvMMx).

## `indeterminate`

The `indeterminate` property is a fascinating one. Did you know that checkboxes can have an additional visual state other than checked and not checked? `indeterminate` is a property (there is no attribute for it) that you can use to put this little dash into a checkbox that you may have seen every now and then.

```
const input = document.querySelector('input');
input.indeterminate = true;
```

[![Checkbox in indeterminate state including a dash instead of being empty or including a checkmark](//images.ctfassets.net/f20lfrunubsq/3DG7ExLKLCEQyWw4ysC4Ag/53ad885c80761ea3aa8f3f5d253b7db2/checkbox.png)](//images.ctfassets.net/f20lfrunubsq/3DG7ExLKLCEQyWw4ysC4Ag/53ad885c80761ea3aa8f3f5d253b7db2/checkbox.png)

Setting `indeterminate` to `true` doesn't have any effect on the value of the checkbox, and the only reasonable use case I can think of are nested checkbox like [Chris Coyier describes on CSSTricks](https://css-tricks.com/indeterminate-checkboxes/).

`indeterminate` doesn't work only for checkboxes though. It also can be used for radio buttons and progress elements. Let's take a group of radio buttons in which no radio button is selected. When you're not preselecting one element in a group of radio buttons none of them is selected and also none of them is not selected – thus all of them are in `indeterminate` state.

What's cool is, that you can also use the CSS pseudo class `:indeterminate` pseudo-class to selected elements which could come in handy to show particular UI components when no radio button in a group is selected yet.

[![Radio buttons followed by a message showcasing the :indeterminate pseudo-class](//images.ctfassets.net/f20lfrunubsq/gR6DWzopxemgaKa4eUika/d71705c5621232e54fa902eda0e87267/radios.png)](//images.ctfassets.net/f20lfrunubsq/gR6DWzopxemgaKa4eUika/d71705c5621232e54fa902eda0e87267/radios.png)

```
.msg {
  display: none;
}

input:indeterminate ~ .msg {
  display: block;
}
```

What is interesting about the property `indeterminate` is that you can set it to `true` or `false` and this will affect the pseudo-class for checkboxes but not for radios. **Dealing with radio buttons the actual selection state of a group is always right**.

And only to mention it for the sake of completion [progress elements](https://developer.mozilla.org/de/docs/Web/HTML/Element/progress) will also match a selector including `:indeterminate` when they don't have a `value` attribute defined.

[The MDN definition](https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement#Properties) for `indeterminate` is a follows:

> [It] indicates that a checkbox or radio buttons have no value and are in indeterminate state. Checkboxes change the appearance to resemble a third state. Does not affect the value of the checked attribute, and clicking the checkbox will set the value to false.

If you like you can play around with the code in [a CodePen](https://codepen.io/stefanjudis/pen/WgpzYy).

## `selectionStart`, `selectionEnd` and `selectionDirection`

These three properties can be used to figure out what a user selected and they are very straightforward to use. If the user selects text in an input field, you can use these to evaluate what was selected.

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

What I did to test this is that I defined an interval which logs the selection values every second. `selectionStart` and `selectionEnd` return numbers describing the position of my selection but `selectionDirection` surprisingly returns `none` when you select things with your mouse or trackpad but `forward` or `backward` when you select text using SHIFT and the arrow or control keys.

If you like you can play around with the code in [a CodePen](https://codepen.io/stefanjudis/pen/yxMjWe).

And that's it. :)

### Quick (and short) conclusion

MDN is a fantastical resource. Even after using `input` elements for eight years now there are always new things to discover, and this is what I love about web development. Personally, I try to read random MDN articles regularly (I have a daily Slack-bot that reminds me to open [bit.ly/randommdn](http://bit.ly/randommdn)) because there are always things to discover and I can only highly recommend it!

Thanks for reading! ❤️

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
