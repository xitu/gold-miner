> * 原文地址：[clamp() for Responsive Design](https://calebhearth.com/clamp-for-responsive-design)
> * 原文作者：[Caleb Hearth](https://calebhearth.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/clamp-for-responsive-design.md](https://github.com/xitu/gold-miner/blob/master/article/2020/clamp-for-responsive-design.md)
> * 译者：[Alfxjx](https://github.com/Alfxjx)
> * 校对者：[z0gSh1u](https://github.com/z0gSh1u)、[HurryOwen](https://github.com/HurryOwen)

# 使用 clamp() 进行响应式设计

新的 CSS 函数 `clamp()` 提供了一种通过给目标值设置最大最小值的范围来计算实际值方法。它的语法是 `clamp([min], [calculated], [max])`。当你基于屏幕尺寸，使用长度单位 `vw` 来缩放一些值时，这个函数很有用。

该项技术很适用于跨多种屏幕尺寸的设计。常规的方法是根据屏幕的宽度使用媒体查询的方法来对样式做不同的调整，但是这么做导致我们在开发的时候要么以“移动端优先”为原则，开发小屏幕的应用，再按比例增加；要么是以“桌面端优先”为原则，开发适用于大屏幕的应用，再按比例缩小。通过使用 `clamp()` 函数，用一个已知的最大最小值来约束变化的范围，我们开发人员可以减少对于样式响应式断点的依赖，这样就无需为了一致性检查很多种不同的宽度了。
 
![image](https://user-images.githubusercontent.com/5164225/95879008-7562ad00-0da8-11eb-9b5a-01dd31d575d8.png)
运河闸可以使船通过不同水位的水域

为了理解 `clamp()` 是如何工作的，我喜欢用运河闸的比喻。运河闸使用两个可以升高和降低的船闸，以使船只可以越过它们。一旦船在闸板之间，则从高水位侧添加水或将水排到低水位侧，以分别升高或降低闸板之间的水位。这使船可以随水位轻轻浮动并在最小和最大水位之间移动。

更具体地说，`clamp(100%, calc(1em + 1vw), 200%)` 的效果与 `max(100%, min(calc(1em + 1vw), 200%))` 相同。最神奇的就是中间的这个参数 `calc(1em + 1vw)`，将浏览器的宽度（或者说，视口的宽度）代入了计算之中。`1vw` 相当于视口宽度的 1%，因此 1em 加上视口宽度的 1% 的计算结果会随着浏览器的大小调整而变动。

让我们来看看我们是怎样通过此方法来调整字号大小的。下面的这个例子和我在我的个人网站上使用的方式非常相近：

```css
body {
  font-size: clamp(100%, calc(1rem + 2vw), 1.375rem);
}
```

拆分下来看，`100%` 通常表示着“当前页面的基本尺寸”，对于字号而言就是 16px。`calc(1rem + 2vw)` 使用 `rem`（同样是 16px ）加上视口宽度的 2% 来进行计算。`1.375rem` 则是我理想情况下的最大字号，为 22px。

`clamp()` 以及相关的 `min()` 和 `max()` 函数在本文写作之时都有了很好的浏览器支持：

![来自 caniuse.com 的跨主要浏览器的 css-math-functions 功能支持数据](https://caniuse.bitsofco.de/image/css-math-functions.jpg) 

[在 MDN 中](https://developer.mozilla.org/en-US/docs/Web/CSS/clamp)，`clamp()` 适用于任何使用了数字、百分数以及其他长度单位的样式中。但奇怪的是，当我尝试将其应用到[ `line-height` ](https://blog.typekit.com/2016/08/17/flexible-typography-with-css-locks/)时，我发现 Safari 14 应该是支持 `line-height: clamp(...)` 这样的写法的（我尝试了 `@supports`），但是实际情况却是回退到了基准的 `line-height` ，非常令人费解。最终我使用 `line-height: min(calc(1.1em + 1vw), 32px)` 从而实现了 `line-height` 响应式地根据我的内容高度来确定。这里不需要设置一个最小值，因为我测试的宽度都不是很小，但是如果有最小值的需求的话，可以在最外层包裹一个 `max()`：`line-height: max(100%, min(calc(1.1em + 1vw), 32px))`。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
