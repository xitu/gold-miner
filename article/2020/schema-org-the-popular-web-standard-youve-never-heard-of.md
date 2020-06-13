> - 原文地址：[Schema.org: The Popular Web Standard You’ve Never Heard Of 🤫](https://levelup.gitconnected.com/schema-org-the-popular-web-standard-youve-never-heard-of-d9b7ff28a22d)
> - 原文作者：[dave.js](https://medium.com/@_davejs)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：https://github.com/xitu/gold-miner/blob/master/article/2020/schema-org-the-popular-web-standard-youve-never-heard-of.md
> - 译者：[lhd951220](https://github.com/lhd951220)
> - 校对者：[rachelcdev](https://github.com/rachelcdev), [noirlyrik](https://github.com/noirlyrik)

# Schema.org: 你未曾耳闻的流行网页标准 🤫

![](https://cdn-images-1.medium.com/max/5868/1*zjJka96wmgZpOMTw5CnCIg.png)

## Schema.org 是什么？

Schema.org 是由 Google，Microsoft，Yahoo 和 Yandex 一起建立的一个开放标准，在 2013 年 4 月 发布了 v1 版本。是的，它已经存在了相当长的时间。但是，它不断的发展以支持人们以新的和未知的方式使用网络。

那它到底是什么呢？根据 [Schema.org 主页](https://schema.org/)：

> **Schema.org 是一个由社区驱动的议案，它负责创建、维护和促进，那些在互联网、网页、邮件等平台上的结构化数据的模式。**

总结而言：Schema.org 为网络内容赋予含义。它建立在 [语义化 HTML 元素](https://developer.mozilla.org/en-US/docs/Glossary/Semantics#Semantics_in_HTML) 之上，并且为网络内容赋予丰富的含义。

和语义化 HTML 一样，Schema.org 也用来帮助搜索引擎优化（SEO）。通过给你的内容添加更多的上下文信息，搜索引擎可以更好的解析你的内容，并且为你的内容做更好的分类，使之可以被人们更容易的查找得到。搜索引擎还可以使用这些结构化数据创建丰富的预览信息。

![](https://cdn-images-1.medium.com/max/2000/0*WuvNN7OKDhL59cPN.png)

通过 IMDb 上有关 **Avengers: Endgame** 的预览信息，我们可以在搜索结果中看到评分数据。这是因为 IMDb 应用 Schema.org 恰当地标记它们的内容。

从另一个角度来看 Schema.org，它类似于 [ARIA](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA)，但它是为了 SEO 而不是可访问性。这使得你无需修改网站的功能，但却可以增强指定的用户（在这里，用户就是搜索引擎）。

## 为 HTML 内容添加 Schema.org

Schema.org 支持几种编码方式，但是，最常用的一种是 **Microdata**，它允许我们直接通过 HTML 属性使用模式数据标记。

API 非常简单。只有三个属性：

- `itemtype`：定义一个项的模式。
- `itemscope`：定义一个项的容器。
- `itemprop`：在项上定义属性。

## 基本使用

这是一个使用 [Person 类型](https://schema.org/Person) 的简单例子:

```html
<div itemscope itemtype="https://schema.org/Person">
  <img
    src="/david-leger.png"
    alt="mid-twenties male with brown hair and blue eyes"
    itemprop="image"
  />
  <h1 itemprop="name">David Leger</h1>
  <p itemprop="description">
    Hey! I'm dave.js and I'm from <span itemprop="nationality">Canada</span>. I
    love writing <span itemprop="knowsAbout">JavaScript</span>,
    <span itemprop="knowsAbout">HTML</span>, and
    <span itemprop="knowsAbout">CSS</span>!
  </p>
</div>
```

`itemscope` 和 `itemtype` 设置在顶层的 `<div>` 元素，所以每一个在顶层元素下的 `itemprop` 都是属于 Person 类型的。

`itemtype` 的值是你想要使用的类型的文档的 URL。为了了解哪一个 `itemtype` 和 `itemprop` 的值最适合你的内容，你可以查阅 Schema.org 的文档，里面有详细的描述和如何使用每种模式类型的示例。

注意 `description` 是如何包裹两个额外的 `itemprop`。不论标签的层次如何，`itemprops` 将会被关联在最近的祖先 `itemscope`。我们还可以定义多个相同的 `itemprop` 实例，就像 `knowsAbout` 一样。

## 嵌套项

如果我们想要将一个项嵌套在另一个项中该怎么办？为了达到这个目的，我们可以定义一个新的 `itemscope`。 扩展我们的 Person 项，并添加一个 [PostalAddress](https://schema.org/PostalAddress)。

```html
<div itemscope itemtype="https://schema.org/Person">
  <img
    src="/david-leger.png"
    alt="mid-twenties male with brown hair and blue eyes"
    itemprop="image"
  />
  <h1 itemprop="name">David Leger</h1>
  <p itemprop="description">...</p>
  <address
    itemprop="address"
    itemscope
    itemtype="https://schema.org/PostalAddress"
  >
    <span itemprop="streetAddress">1505 Barrington Street</span><br />
    <span itemprop="addressLocality">Halifax</span><br />
    <span itemprop="addressRegion">Nova Scotia</span>
  </address>
</div>
```

通过为 `<address>` 元素添加 `itemscope`，我们限定了在这个标记中的所有 `itemprop` 的作用范围为 PostalAddress 项。通过使用 `itemprop="address"`，PostalAddress 链接到 Person 项，否则，它们将会被解释为单独的、未关联的项。

## 隐藏数据

有时，我们想要为搜索引擎提供上下文信息，但是我们并不想在页面上展示。这可以通过使用 `<meta>` 标记来实现。这看起来也许有一点奇怪， 因为 `<meta>` 标记通常在网页的 `<head>` 中使用的，但是 [Schema.org 建议为隐藏内容使用 meta 标记](https://schema.org/docs/gs.html#advanced_missing)。

对于 Person 项，让我们使用 `<meta>` 标记来添加我的昵称（dave.js）。

```html
<div itemscope itemtype="https://schema.org/Person">
  <img
    src="/david-leger.png"
    alt="mid-twenties male with brown hair and blue eyes"
    itemprop="image"
  />
  <h1 itemprop="name">David Leger</h1>
  <p itemprop="description">...</p>
  <address
    itemprop="address"
    itemscope
    itemtype="https://schema.org/PostalAddress"
  >
    ...
  </address>
  <meta itemprop="alternateName" content="dave.js" />
</div>
```

## 测试 Schema.org 项目

测试你的项目是很简单的。Google 提供了一个 [结构化数据测试工具](https://search.google.com/structured-data/testing-tool) 来测试你的项目。它解析你的 HTML，并且会显示一个如何解析项中属性的树。如果 `itemtype` 中必需或建议的属性缺失，那么就会显示这些缺失属性导致的错误和警告。

这是我们使用结构化测试工具进行解析的示例：

![](https://cdn-images-1.medium.com/max/2000/0*aXWVolaitY_AbKtL.png)

## 活跃的标准

Schema.org 是一个开源的社区项目。尽管它得到了 Google、Microsoft、Mozilla 等主要公司的支持，但仍然鼓励公众做出贡献。尽管 Schema.org 在 2013 年就已经存在了，但它是一个适应网络需求的活跃的标准。比如，最近的发行版包括了诸如 [CovidTestingFacility](https://schema.org/CovidTestingFacility) 之类的项类型，以帮助新冠疫情救灾工作。

查看 [文档](https://schema.org/docs/documents.html) 来学习更多的 Schema.org 的知识和它的用法。这里有大量不同类型的项的模式，以及有关如何使用它们的详细文档。

如果你想为 Schema.org 做出贡献，访问 [社区页面](https://www.w3.org/community/schemaorg/) 以了解如果提供帮助。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
