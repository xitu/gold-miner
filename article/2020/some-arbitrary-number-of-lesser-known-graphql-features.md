> * 原文地址：[Some Arbitrary Number of Lesser-Known GraphQL Features](https://medium.com/front-end-weekly/some-arbitrary-number-of-lesser-known-graphql-features-7fe3feeda72)
> * 原文作者：[dave.js](https://medium.com/@_davejs)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/some-arbitrary-number-of-lesser-known-graphql-features.md](https://github.com/xitu/gold-miner/blob/master/article/2020/some-arbitrary-number-of-lesser-known-graphql-features.md)
> * 译者：
> * 校对者：

# Some Arbitrary Number of Lesser-Known GraphQL Features

![](https://cdn-images-1.medium.com/max/7256/1*fcV8mO_Z0iAO3iXmGNlMwA.png)

Every time you turn your head some new web technology spontaneously spawns into existence. It seemed like just yesterday, GraphQL was one of them. In reality, GraphQL has been out in the wild for about five years. Oh how the precious years escape us…

Despite it being relatively old news, it’s still quite new to the vast majority of software developers. If you’re one of those developers, just dipping your toes into the pond of GraphQL — **RUN! IT’S A TRAP!** Nah, just kidding. GraphQL is great! Hope I didn’t scare you away.

This list includes only client-side features so they’re usable with any GraphQL endpoint. No special changes need to be made to the server for these to work. (Perhaps lesser-known GraphQL server features will be my next blog post.)

Anyway, enough rambling. Here’s a list of neat lesser-known GraphQL features that I think are pretty neat!

For the examples in this post, we’ll be using the [SpaceX GraphQL API](https://api.spacex.land/graphql/).

## 1. Field Aliases

Aliases allow you to rename a field in your query. Here’s a simple query that renames the `ceo` field to `bossMan`:

```
query CEO {
  company {
    bossMan: ceo
  }
}
```

which resolves the following result:

```
{
  "data": {
    "company": {
      "bossMan": "Elon Musk"
    }
  }
}
```

This is a trivial example, so let’s do something more useful with it now.

Aliasing can also be used to get different sets of data from the same GraphQL field. For example, let’s get two rockets and rename them based on their `id`:

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

which resolves to the following result:

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

## 2. Fragments

Fragments let you reuse common pieces of a query or mutation. To demonstrate this, we can refactor our last example to reuse the ship details.

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

Notice that for fragments, we need to use `on [Type]` to specify which fields are available on the fragment. This helps GraphQL autocomplete your fragment, and more importantly, catch errors when you try to use a fragment in a type that doesn’t match.

## 3. Default Variables

When writing your queries for use in an app, you’ll typically want to pass variables into it so you can change the query at runtime. Just like default function parameters in JavaScript, GraphQL can also take advantage of default values.

Let’s query a given rocket and set the default rocket to `"falconheavy"` because it’s dope AF. 🚀

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

## Bonus: Variables Within Fragments

Yes! Variables can even be used within fragments. This seems a bit odd to me because the usage of the variable looks like it’s out of scope of where it’s defined, but that’s just how it works.

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
