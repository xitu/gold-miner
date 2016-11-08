* 原文地址：[Avoiding Accidental Complexity When Structuring Your App State](https://hackernoon.com/avoiding-accidental-complexity-when-structuring-your-app-state-6e6d22ad5e2a#.hgm96hth7)
* 原文作者：[Tal Kol](https://hackernoon.com/@talkol)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：chemzqm@gmail.com
* 校对者：[yifili09](https://github.com/yifili09) [DeadLion](https://github.com/DeadLion)

# 构建应用状态时，你应该避免不必要的复杂性


__Redux 做为一个 Flux 模型的实现需要我们明确思考应用程序内部的整体状态，然后花费时间建模。事实证明，这未必是一项简单的任务。它是混沌理论的一个典型例子，一个看似无害的蝴蝶翅膀振动在错误的方向可能导致飓风等一系列复杂的连锁效应（译注：蝴蝶效应）。下面提供了一个如何对应用程序状态建模的实用提示列表，它们在保证可用性的同时，也能让你的业务逻辑更加合理。__

---

#### 什么是应用程序状态?

根据[维基百科](https://en.wikipedia.org/wiki/State_%28computer_science%29) - 计算机程序在变量中存储数据，其表示计算机存储器中的存储位置。在程序执行的任何给定时间点，这些存储器位置中的内容被称为程序的状态。


就我们当前所讨论的状态而言，重要的是在这个定义中添加__最小化__。当对我们的应用程序建模为了更精确的控制的时候，，我们将尽最大努力来用最少的数据表达应用可能处于的不同状态，从而忽略程序中可以由这个核心所派生的其它动态变量。在 [Flux](https://facebook.github.io/flux/) 应用中，状态保存在 `store` 对象内。通过调用不同的 `action` 对状态进行修改，之后__视图组件__监听到状态变化后自动在内部进行相应的重渲染处理。

![](https://cdn-images-1.medium.com/max/800/1*pgxTL69KXTYjupzGO015Ew.png)

[Redux](http://redux.js.org/), 做为一个 Flux 的实现，额外添加了一些更严格的要求 -  例如将整个应用的状态保存在一个单一的 `store` 对象，同时它是__不可变的__，通常（译注：指状态）也是__可序列化的__。

如果你不使用 Redux，下面给出的提示也应该是有益的。 即使你不使用 Flux，它们也很有可能是有用的。

#### 1. 避免根据服务端响应建模

本地应用程序状态通常来自服务器。 当应用程序用于显示从远程服务器到达的数据时，它常常会被照着以服务器下发的数据格式进行保存。

考虑一个电子商务网店管理应用的示例，商家使用此应用来管理商店库存，因此显示产品列表是一个关键功能。产品列表源自服务器，但需要将应用程序做为状态保存在本地，以便在视图内展现。让我们假设从服务器获取产品列表的主 API 返回以下 JSON 结果：

``` javascript
{
  "total": 117,
  "offset": 0,
  "products": [
    {
      "id": "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0",
      "title": "Blue Shirt",
      "price": 9.99
    },
    {
      "id": "aec17a8e-4793-4687-9be4-02a6cf305590",
      "title": "Red Hat",
      "price": 7.99
    }
  ]
}
```

产品列表作为对象数组到达，为什么不将它们作为对象数组保存在应用程序状态中？

服务器 API 的设计遵循不同的原则，不一定与你想要实现的应用程序状态结构一致。在这种情况下，服务器的数组结构选择可能与响应分页相关，将完整列表拆分为更小的块，因此客户端可以根据需要下载数据，并避免多次发送相同的数据以节省带宽。它们主要考虑的是网络问题，但是总而言之，与我们的应用状态关注点无关。

#### 2. 首选映射而非数组

一般来说，数组不便于状态的维护。考虑当特定产品需要更新或检索时会发生什么。例如，如果应用程序提供编辑价格功能，或者如果来自服务器的数据需要刷新，则可能面临的就是这种情况。遍历一个大的数组来查找特定的产品比根据它的 ID 查询这个产品要麻烦得多。

那么推荐的方法是什么？ 使用主键为键值的映射类型做为查询的对象。

这意味着来自上面示例的数据可以按以下结构存储应用程序的状态：

``` js
{
  "productsById": {
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
      "title": "Blue Shirt",
      "price": 9.99
    },
    "aec17a8e-4793-4687-9be4-02a6cf305590": {
      "title": "Red Hat",
      "price": 7.99
    }
  }
}
```

如果排序顺序很重要，会发生什么？ 例如，如果从服务器返回的订单顺序同时也是我们要给用户呈现的顺序。 对于这种情况，我们可以存储一个额外的 ID 数组：

``` js
{
  "productsById": {
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
      "title": "Blue Shirt",
      "price": 9.99
    },
    "aec17a8e-4793-4687-9be4-02a6cf305590": {
      "title": "Red Hat",
      "price": 7.99
    }
  },
  "productIds": [
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0",
    "aec17a8e-4793-4687-9be4-02a6cf305590"
  ]
}
```

还有一点很有意思：如果我们需要在 React Native 的 `ListView` 组件中显示数据，这个结构实际上效果很好。支持稳定行 ID 的推荐版 `cloneWithRows` 方法所需要的就是这种格式。

#### 3. 避免根据视图的需要进行建模

应用程序状态的最终目的是展现到视图中，并让用户觉得是一种享受。把状态保存为视图需要的形式看上去很有诱惑力，因为这能避免对数据进行额外的转换操作。

让我们回到我们的电子商务商店管理示例。 假设每个产品都可以是库存或缺货两种状态之一。我们可以将此数据存储在产品对象的一个布尔属性中。

``` js
{
  "id": "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0",
  "title": "Blue Shirt",
  "price": 9.99,
  "outOfStock": false
}
```

我们的应用程序需要显示所有缺货产品的列表。之前提到过，React Native ListView 组件期望使用调用它的 `cloneWithRows` 方法时传递两个参数：行的映射和行 ID 的数组。我们倾向于提前准备好这个状态，并且明确地保持这个列表。这将允许我们向 ListView 提供两个参数，而不需要额外的转换。我们最终得到的状态对象结构如下：

``` js
{
  "productsById": {
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
      "title": "Blue Shirt",
      "price": 9.99,
      "outOfStock": false
    },
    "aec17a8e-4793-4687-9be4-02a6cf305590": {
      "title": "Red Hat",
      "price": 7.99,
      "outOfStock": true
    }
  },
  "outOfStockProductIds": ["aec17a8e-4793-4687-9be4-02a6cf305590"]
}
```

听起来像个好主意，对吧？ 好吧，事实证明，并不是。

像以前一样，原因是，视图有自己不同的关注点。视图不关心保持状态最小。具体来说，他们的倾向完全相反，因为数据必须为用户布局服务。不同的视图可以以不同的方式呈现相同的状态数据，并且通常不可能在不复制数据的情况下满足它们。

这把我们引入到下一个要点。

#### 4. 避免在应用程式状态中保存重复的数据

测试你的状态是否持有重复数据有一种好办法，就是检查是否需要同时更新两处数据来保证数据一致性。在上述缺货产品示例中，假设第一个产品突然变为缺货。 为了处理这个更新，我们必须将其在映射中的 `outOfStock` 字段更改为 true，并将其 ID 添加到数组 `outOfStockProductIds` 之中 - 两个更新。

处理重复数据很简单。所有你需要做的是删除其中一个实例。这背后的推理源于一个[单一信息源](https://en.wikipedia.org/wiki/Single_source_of_truth)：如果数据仅保存一次，则不再可能达到不一致的状态。

如果我们删除 `outOfStockProductIds` 数组，我们仍然需要找到一种方法来准备这些数据以供视图使用。这种转换必须在数据被提供给视图之前在运行时进行。Redux 应用中的推荐做法是在[选择器](https://egghead.io/lessons/javascript-redux-colocating-selectors-with-reducers)中实现此操作：

``` js
{
  "productsById": {
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
      "title": "Blue Shirt",
      "price": 9.99,
      "outOfStock": false
    },
    "aec17a8e-4793-4687-9be4-02a6cf305590": {
      "title": "Red Hat",
      "price": 7.99,
      "outOfStock": true
    }
  }
}

// selector
function outOfStockProductIds(state) {
  return _.keys(_.pickBy(state.productsById, (product) => product.outOfStock));  
}
```

选择器是一个纯函数，它将状态作为输入，并返回我们想要消费的转换后状态。 [Dan Abramov](https://twitter.com/dan_abramov) 建议我们将选择器放在 `reducers` 旁边，因为它们通常是紧耦合的。 我们将在视图的 `mapStateToProps` 函数中执行选择器。

删除数组的另一个可行的替代方法是从映射中的每个产品里删除库存属性。使用这种替代方法，我们可以将数组作为单一信息源。实际上，根据提示＃2 它可能会更好，将此数组更改为映射：

```
{
  "productsById": {
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
      "title": "Blue Shirt",
      "price": 9.99
    },
    "aec17a8e-4793-4687-9be4-02a6cf305590": {
      "title": "Red Hat",
      "price": 7.99
    }
  },
  "outOfStockProductMap": {
    "aec17a8e-4793-4687-9be4-02a6cf305590": true
  }
}

// selector
function outOfStockProductIds(state) {
  return _.keys(state.outOfStockProductMap);  
}
```

#### 5. 不要将衍生数据存储在状态中

单一信息源原则不仅对于重复数据适用。在商店中出现的任何衍生数据都违反了这条原则，因为必须对多个位置进行更新以保持状态一致性。

让我们在我们的商店管理示例中添加另一个要求 - 将产品放在销售中并对其价格添加折扣的能力。该应用程序需要向用户显示过滤后的商品列表，所有产品列表，以及仅显示没有折扣的产品或仅显示有折扣的产品。

一个常见的错误是在商店中保存 3 个数组，每个数组包含每个过滤器的相关产品的 ID 列表。由于 3 个数组可以从当前过滤器和产品映射中导出，更好的方法是使用类似于前面的选择器来生成它们：

``` js
{
  "productsById": {
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
      "title": "Blue Shirt",
      "price": 9.99,
      "discount": 1.99
    },
    "aec17a8e-4793-4687-9be4-02a6cf305590": {
      "title": "Red Hat",
      "price": 7.99,
      "discount": 0
    }
  }
}

// selector
function filteredProductIds(state, filter) {
  return _.keys(_.pickBy(state.productsById, (product) => {
    if (filter == "ALL_PRODUCTS") return true;
    if (filter == "NO_DISCOUNTS" && product.discount == 0) return true;
    if (filter == "ONLY_DISCOUNTS" && product.discount > 0) return true;
    return false;
  }));
}
```

在重新呈现视图之前，对每个状态更改执行选择器。 如果您的选择器是计算密集型，并且您关注性能，请使用 [Memoization](https://en.wikipedia.org/wiki/Memoization) 技术来计算结果并在运行一次后缓存它们。 你可以去看看实现此优化能力的 [Reselect](https://github.com/reactjs/reselect) 组件。

#### 6. 规范化嵌套对象

总的来说，到目前为止，这些提示的基本动机是简单性。状态时刻都需要被管理，并且我们想要的是尽可能让这个管理的过程变得简单。当数据对象是独立的，简单性更容易维护，但是当有相互关联时会发生什么？

考虑我们的商店管理应用程序中的以下示例。我们想添加一个订单管理系统，客户在此可以单个订单购买多个产品。让我们假设我们有一个服务器 API，它返回以下 JSON 订单列表：

``` js
{
  "total": 1,
  "offset": 0,
  "orders": [
    {
      "id": "14e743f8-8fa5-4520-be62-4339551383b5",
      "customer": "John Smith",
      "products": [
        {
          "id": "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0",
          "title": "Blue Shirt",
          "price": 9.99,
          "giftWrap": true,
          "notes": "It's a gift, please remove price tag"
        }
      ],
      "totalPrice": 9.99
    }
  ]
}
```

一个订单包含几个产品，因此我们需要对两者之间的关系进行建模。我们已经从提示＃1知道，我们不应该使用 API 的响应结构，这确实看起来有问题，因为它会导致产品数据的重复。

在这种情况下，一种好的方法是使数据标准化，并保持两个单独的映射 - 一个用于产品，一个用于订单。由于这两种类型的对象都基于唯一的 ID，因此我们可以使用 ID 属性来指定关联。生成后的应用程序状态结构为：

``` js
{
  "productsById": {
    "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
      "title": "Blue Shirt",
      "price": 9.99
    },
    "aec17a8e-4793-4687-9be4-02a6cf305590": {
      "title": "Red Hat",
      "price": 7.99
    }
  },
  "ordersById": {
    "14e743f8-8fa5-4520-be62-4339551383b5": {
      "customer": "John Smith",
      "products": {
        "88cd7621-d3e1-42b7-b2b8-8ca82cdac2f0": {
          "giftWrap": true,
          "notes": "It's a gift, please remove price tag"
        }
      },
      "totalPrice": 9.99
    }
  }
}
```

如果我们想查找属于某个订单的所有产品，我们将遍历 `products` 属性的键。 每个键值是一个产品 ID。 使用此 ID 访问 `productsById` 映射将为我们提供产品详细信息。 此订单特定的其他产品详细信息（如 giftWrap）位于订单下的 `products` 所映射的值中。

如果标准化 API 响应的过程变得乏味，可使用相应的辅助程序库，如 [normalizr](https://github.com/paularmstrong/normalizr)，它接受一个模式做为参数并为你执行标准化数据的过程操作。

#### 7. 应用程序状态可以被视为内存数据库

到目前为止，各种建模技巧我们都已经介绍了，大家应该比较熟悉了。

当建模传统的数据库结构时，我们避免重复和派生，使用主键（ID）用于映射相似的表中索引数据，并规范化多个表之间的关系。这几乎就是我们之前所谈论的全部东西。

像处理内存数据库一样处理应用程序状态可以有助于你处于正确的思考方向，从而做出更好的结构化决策。

---

#### 将应用状态视为一等公民

如果说你从这篇文章的获得了什么东西，那就应该是它。

在命令式编程期间，我们倾向于视代码为王，并且花费更少的时间担心内部隐式数据结构（如状态）的 “正确” 模型。我们的应用程序状态通常被发现分散在各种管理器或控制器作为私有属性，肆无忌惮的有机增长。

然而在声明性的范式下情况是不同的。在像 React 这样的环境中，我们的系统表现为对状态的反应。状态变身为一等公民，与我们编写的代码一样重要。这是 Flux 里面 `actions` 对象存在的目的，同时也是 Flux 视图的真理之源。

Redux 这类工具库基于 Flux 构建，并且提供了一系列工具，例如引入不可变性让我们拥有更好的应用状态可预见性。

我们应该多花点时间思考我们的应用程序状态。 我们应该清楚的认识到它的复杂度，以及相应的我们所需在代码中维护它所需做出的努力。就像我们在写代码时一样，我们应该重构它，而且是在它显现出腐烂的迹象就开始。
