> * 原文地址：[How to conditionally build an object in JavaScript with ES6](https://medium.freecodecamp.org/how-to-conditionally-build-an-object-in-javascript-with-es6-e2c49022c448)
> * 原文作者：[Knut Melvær](https://medium.freecodecamp.org/@kmelve?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-conditionally-build-an-object-in-javascript-with-es6.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-conditionally-build-an-object-in-javascript-with-es6.md)
> * 译者：[ssshooter](https://github.com/ssshooter)
> * 校对者：[kezhenxu94](https://github.com/kezhenxu94), [Park-ma](https://github.com/Park-ma)

# 如何使用 JavaScript ES6 有条件地构造对象

![](https://cdn-images-1.medium.com/max/800/1*_CMG7dT4YMldUiVPueOmXw.png)

在不同来源之间移动用户生成的数据，通常需要检查特定字段是否具有值，基于这些数据构建输出。这篇文章将会教你如何使用 JavaScript ES6 特性更简洁地完成这件事。

自 [Sanity.io](https://sanity.io)（我工作的地方）赞助 [Syntax](https://syntax.fm/show/068/design-tips-for-developers) 以来，我一直在 [CLIs](https://github.com/sanity-io/podcast-to-sanity) 和 [Express, and Serverless functions](https://github.com/sanity-io/Syntax) 处理播客 RSS-feeds。这包含处理和构建包含大量字段和信息的复杂对象。因为处理的数据来源各不相同，所以很难保证所有字段都被填充。还有一些字段是选填的，但你不希望在 RSS XML 或 [JSON FEED](https://jsonfeed.org) 输出没有值的标签。

之前我会通过在对象上添加新的键来解决这个问题：

```
function episodeParser(data) {
  const { id, 
   title,
   description,
   optionalField,
   anotherOptionalField
  } = data
  const parsedEpisode = { guid: id, title, summary: description }
  if (optionalField) {
    parsedEpisode.optionalField = optionalField
  } else if (anotherOptionalField) {
    parsedEpisode.anotherOptionalField = anotherOptionalField
  }
  // and so on
  return parsedEpisode
}
```

这不够优雅（但它确实有效），如果有大量可选字段，你就必须写很多 `if-` 语句。我也曾通过循环对象 key 处理这个问题，但这么做代码会更复杂，并且让人难以直观地看懂这个对象。

这时候，ES6 新语法又来救场啦。我发现可以将代码重写为以下模式：

```
function episodeParser({
  id, 
  title, 
  description = 'No summary', 
  optionalField, 
  anotherOptionalField
}) {
  return {
    guid: id,
    title,
    summary: description,
    ...(optionalField && {optionalField}),
    ...(anotherOptionalField && {anotherOptionalField})
  }
}
```

这个函数使用了两个 ES6 新特性。第一个是[**参数对象解构**](https://www.youtube.com/watch?v=-vR3a11Wzt0)，如果你需要在函数中处理大量的参数，这是一个很好的模式。可以取代这种写法：

```
function episodeParser(data) {
  const id = data.id
  const title = data.title
  // and so on...
}
```

改写为：

```
function({id, title}) {
  // and so on...
}
```

这也是避免函数参数过多的好方法。还要注意对象解构的 `description = 'No summary'` 部分，这就是所谓的默认参数。如果 `description` 未定义，它将被默认定义为字符串 `No summary`。

第二个 `...` 是[**展开语法**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax)。如果条件为真（`&&` 的作用），它将会 “unwrap（解包）”对象：

```
{
  id: 'some-id',
  ...(true && { optionalField: 'something'})
}

// is the same as

{
  id: 'some-id',
  optionalField: 'someting'
}
```

你最终得到的是一个简洁又易于测试的函数。关于使用 `&&` 运算符有一点需要注意：数字 0 将被视为 `false`，因此对于某些数据类型需要小心处理。

实际使用此函数，会像这样：

```
const data = { 
  id: 1, 
  title: 'An episode', 
  description: 'An episode summary', 
  anotherOptionalField: 'some data' 
}
episodeParser(data)
//> { guid: 1, title: 'An episode', summary: 'An episode summary', anotherOptionalField: 'some data' }
```

你可以在我们为 [express.js](https://github.com/sanity-io/Syntax/blob/master/routeHandlers/rss.js) 和 [netlify lambdas](https://github.com/sanity-io/Syntax/blob/master/functions/rss.js) 实现的播客订阅中看到实际效果。如果你想亲自尝试 Sanity.io，你可以在 [sanity.io/freecodecamp](https://sanity.io/freecodecamp?utm_source=freecodecamp&utm_medium=blog&utm_campaign=jq) 获得一个免费的开发者计划。 ✨

* * *

**首发于 [_www.sanity.io_](https://www.sanity.io/blog/how-to-conditionally-build-an-object-in-es6)。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

