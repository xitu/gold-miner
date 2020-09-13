> * 原文地址：[Using JSON.stringify to Work with JavaScript Object](https://levelup.gitconnected.com/using-json-stringify-to-work-with-javascript-object-9416c1e2c7c4)
> * 原文作者：[TRAN SON HOANG](https://medium.com/@transonhoang)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/using-json-stringify-to-work-with-javascript-object.md](https://github.com/xitu/gold-miner/blob/master/article/2020/using-json-stringify-to-work-with-javascript-object.md)
> * 译者：[Inchill](https://github.com/Inchill)
> * 校对者：[Chorer](https://github.com/Chorer)、[z0gSh1u](https://github.com/z0gSh1u)

# 使用 JSON.stringify 处理 JavaScript 对象

![Photo by [Hanny Naibaho](https://unsplash.com/@hannynaibaho?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/coffee?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/9282/1*Kiz9V-noKpoSaIAdYyzWNA.jpeg)

在这篇文章，我将会分享如何使用 JSON.stringify() 的第二个参数 replacer。

## 语法复习

我相信大多数人都知道 **`JSON.stringify()`** 的第一个参数。但是，只有一些人知道这里还有第二个参数叫做 **replacer**。所以我想重新介绍这个方法的语法。

**`JSON.stringify()`** 方法将会做 2 件事：

1. 将值转换成一个 JSON 字符串。
2. 如果有指定的 replacer 转换函数则继续转换该值。

```
JSON.stringify(value[, replacer[, space]])
```

这里有 3 个参数：

1. **value**
将要被转换成 JSON 字符串的值。
2. **replacer**
更改字符串序列化过程的自定义处理函数。
3. **space**
添加输出时缩进用的空白字符串。


value 支持多种数据类型，比如对象、数组和基本数据类型。

![JSON stringify with some basic data types](https://cdn-images-1.medium.com/max/2000/1*5E21LFldSmAu59S8nuxEjQ.png)

有些 value 值会返回 `undefined`，比如函数、Symbol 类型和 `undefined`。

![JSON stringify return undefined for some specific input](https://cdn-images-1.medium.com/max/2000/1*rouzCb86i62XKCX4Ucy_9g.png)

那么 `Object` 实例，例如 Map、Set、WeakMap 和 WeakSet 会返回什么呢？

![JSON stringify with Object instance](https://cdn-images-1.medium.com/max/2000/1*zmsGDy7_pc_4bs2YSBfofw.png)

注意：

* `Infinity`、`NaN` 和 `null`, 都将被视作 `null`。
* 编码后，对象属性名以及字符串都将被双引号引起来。

## 使用 Replacer 参数

对象被递归地序列化成 `JSON` 字符串，同时在每个属性上调用 `replacer` 函数。在 JavaScript 中使用对象时，这将有很大帮助。

**replacer** 有 2 种类型：

* 数组
* 函数

#### replacer 作为一个数组

当需要过滤对象属性时，可以将 replacer 作为数组应用。

只有传递给数组的这些属性才会被编码。

![excluding object properties by array replacer](https://cdn-images-1.medium.com/max/2000/1*9z346wFbRjwhSoKyjKkJHA.png)

#### replacer 作为一个函数

如果我们不知道确切的属性名称，或者因为有太多属性而无法一一列出时，则可以将 replacer 用作函数。

因此，我们编写了一个函数，来过滤那些遵循某种数据类型或者特定模式的属性值。

![excluding object properties by function replacer](https://cdn-images-1.medium.com/max/2000/1*u3xjA0lr8z8doKYIz9JxwQ.png)

对于某些我们想从一个对象中获取部分属性的简单情况，使用 replacer 很有用。

我们有时在维护老项目时，是没有任何好的工具可以支持我们从大型 JSON 对象中过滤属性的。

我希望这篇文章对你有所帮助！您可以随时在下面的评论中留下您的任何问题。我很乐意提供帮助！

## 参考

[1] Json Stringify: [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
