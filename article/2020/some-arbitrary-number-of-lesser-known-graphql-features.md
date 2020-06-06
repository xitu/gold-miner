> * 原文地址：[Some Arbitrary Number of Lesser-Known GraphQL Features](https://medium.com/front-end-weekly/some-arbitrary-number-of-lesser-known-graphql-features-7fe3feeda72)
> * 原文作者：[dave.js](https://medium.com/@_davejs)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/some-arbitrary-number-of-lesser-known-graphql-features.md](https://github.com/xitu/gold-miner/blob/master/article/2020/some-arbitrary-number-of-lesser-known-graphql-features.md)
> * 译者：[hansonfang](https://github.com/hansonfang)
> * 校对者：[rachelcdev](https://github.com/rachelcdev), [lhd951220](https://github.com/lhd951220)

# 鲜为人知的 GraphQL 特性

![](https://cdn-images-1.medium.com/max/7256/1*fcV8mO_Z0iAO3iXmGNlMwA.png)

新的 Web 技术每次都会在你不经意的扭头的一瞬间就出现了。好像就是昨天，GrapQL 还是其中之一。但事实上，GraphQL 出世已经差不多五年了。不禁让人感叹时光的流逝。

尽管 GraphQL 已经是个相对比较旧的事物，但对于大多数软件工程师来说，它仍然是个新鲜玩意。如果你就是这大多数软件工程师之一，不妨去试试水 ——— **快跑吧，这玩意就是个陷阱** 当然我是开玩笑的。GraphQL 实际上是很棒的，希望你不要被我吓跑。

以下列表内容仅仅是 GraphQL 客户端的特性，这样你可以在任意 GraphQL 发送端使用，服务端不需要特别的修改(可能下次我会写篇鲜为人知的 GraphQL 服务端特性)

闲话少说，下面就是我列举的一些鲜为人知的 GraphQL 功能，这些功能点都是非常简洁的。

对于文中的示例 API，我用的是 [SpaceX GraphQL API](https://api.spacex.land/graphql/).

## 1. 字段别名

别名允许你在一段查询中重命名一个字段。这里有一个把字段 `ceo` 改为 `bossMan` 的查询样例:

```
query CEO {
  company {
    bossMan: ceo
  }
}
```

解析返回的数据是：

```
{
  "data": {
    "company": {
      "bossMan": "Elon Musk"
    }
  }
}
```

这就是一个小例子，我们现在来看点更有用的。

别名也能用于在相同的 GraphQL 字段中拿到不同名称的数据集合。比如，我想获取两个火箭信息并根据他们的 `id` 重命名:

```
query Ships {
  falcon1: rocket(id: "falcon1") {
    id
    active
    height {
      meters
    }
  }
  falconheavy: rocket(id: "falconheavy") {
    id
    active
    height {
      meters
    }
  }
}
```

解析返回的数据是：

```
{
  "data": {
    "falcon1": {
      "id": "falcon1",
      "active": false,
      "height": {
        "meters": 22.25
      }
    },
    "falconheavy": {
      "id": "falconheavy",
      "active": true,
      "height": {
        "meters": 70
      }
    }
  }
}
```

## 2. 片段

片段可以复用一段查询或变更中多次使用的公共语句，下面演示一下，可以重构上一个例子为获取飞船信息。

```
fragment shipDetails on Rocket {
  id
  active
  height {
    meters
  }
}

query Ships {
  falcon1: rocket(id: "falcon1") {
    ...shipDetails
  }
  falconheavy: rocket(id: "falconheavy") {
    ...shipDetails
  }
}
```

注意在片段中，需要使用 `on [Type]` 来指定片段上哪些字段是可用的。这将对自动补全非常有用，还有一件重要的事，在使用片段时要捕捉错误防止出现类型不匹配的情况。

## 3. 默认变量

当在一个应用中写查询时，通常会传递给查询一些变量以便在运行时改变查询。就像 JavaScript 中的函数默认参数，GraphQL 也可以利用默认值。

让我们查询一个火箭信息并将默认火箭信息设置为 `"falconheavy"`( SpaceX 的重型猎鹰)，简直帅呆了。 🚀

```
query Ship($rocketId: ID! = "falconheavy") {
  rocket(id: $rocketId)  {
    id
    active
    height {
      meters
    }
  }
}
```

## 额外一条：带变量的片段

是的！变量甚至可以用在片段中。这在我看来有点奇怪，因为变量的使用似乎超出了它定义的范围，但它的确能工作。

```
fragment ship on Query {
  rocket(id: $rocketId)  {
    id
    active
    height {
      meters
    }
  }
}
query Ship($rocketId: ID = "falconheavy") {
  ...ship
}
```

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
