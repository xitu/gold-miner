> * 原文地址：[Do You Know About the Keyboard Tag in HTML?](https://medium.com/better-programming/do-you-know-about-the-keyboard-tag-in-html-55bb3986f186)
> * 原文作者：[Ashay Mandwarya 🖋️💻🍕](https://medium.com/@ashaymurceilago)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/do-you-know-about-the-keyboard-tag-in-html.md](https://github.com/xitu/gold-miner/blob/master/TODO1/do-you-know-about-the-keyboard-tag-in-html.md)
> * 译者：[IAMSHENSH](https://github.com/IAMSHENSH)
> * 校对者：[QinRoc](https://github.com/QinRoc)

# 您知道 HTML 的键盘标签吗？

> 使键盘指令有更好的文本格式

![图片来源于 [Florian Krumm](https://unsplash.com/@floriankrumm?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*f7nqmMC9F1xGB3im)

HTML5 的 `\<kbd>` 标签用于展示键盘输入。使用此标签包装键盘指令文本，将会在语义上提供更准确的结果，也能让您定位，以便能对其应用一些很棒的样式。而且 `\<kbd>` 标签特别适合用在文档中。

让我们来看看它的实际效果。

## HTML

#### 使用 \<kbd> 标签

```html
<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Del</kbd>
```

![使用 \<kbd> 标签](https://cdn-images-1.medium.com/max/2000/1*cOX2zkr7t8lqhi1cAs-y-w.png)

#### 不使用 \<kbd> 标签

对比一下，没有使用 `\<kbd>` 标签是这样的：

```html
<p>Ctrl+Alt+Del</p>
```

![不使用 \<kbd> 标签](https://cdn-images-1.medium.com/max/2000/1*78xmgPdM1W93VAPMxWUegg.png)

## CSS

只使用 \<kbd> 标签，看起来差别不大。但通过加上一些样式，可以让它看起来像实际的键盘按钮，具有更逼真的效果。

```css
kbd {
border-radius: 5px;
padding: 5px;
border: 1px solid teal;
}
```

![加上样式](https://cdn-images-1.medium.com/max/2000/1*YeOd2I5BjpmHf1gqvy8SOA.png)

如果您在控制台中查看该元素，您会发现它除了更改为等宽字体外，没有其他特别之处。

![](https://cdn-images-1.medium.com/max/2000/1*m6FqgEvoA0T5zuIxkUAfGQ.png)

## 结论

使用 `\<code>` 标签也可以产生同样的效果。那为什么要创建 `\<kbd>` 呢？

答案在于语义上的区别。`\<code>` 用于显示简短的代码片段，而 `\<kbd>` 用于表示键盘输入。

感谢您花时间读完本文！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
