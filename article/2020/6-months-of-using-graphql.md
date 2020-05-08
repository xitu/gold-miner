> - 原文地址：[6 Months Of Using GraphQL](https://levelup.gitconnected.com/6-months-of-using-graphql-faa0fb68b4af)
> - 原文作者：[Manish Jain](https://medium.com/@jaiin.maniish)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/6-months-of-using-graphql.md](https://github.com/xitu/gold-miner/blob/master/article/2020/6-months-of-using-graphql.md)
> - 译者：[YueYongDEV](https://github.com/YueYongDev)
> - 校对者：[JohnieXu](https://github.com/JohnieXu)、[cyril](https://github.com/shixi-li)

# 使用 GraphQL 的 6 个月

在使用 GraphQL 进行了 6 个月的后端项目开发后，我开始考量该技术是否适合在开发工作中使用。

![The output from my terminal](https://cdn-images-1.medium.com/max/2526/1*SYo5JVMz3D79G_OEfs8q_g.png)

## 首先

GraphQL 是一种实现 API 的查询语言，也是使用现有数据完成这些查询的运行时。GraphQL 为你的 API 中的数据提供了完整且易于理解的描述，并且让用户有权决定他们所需要的东西，仅此而已。

它由 Facebook 开发，作为其移动应用程序的内部解决方案，后来向社区开放了源代码。

## 优点

#### 务实的数据交换

使用 GraphQL，可以为客户需要的字段指定一个查询，不多也不少。真的就是这么简单。如果**前端**只需要一个人的**`名字`**和**`年龄`**字段，直接请求相应的字段就可以了。这个人的**`姓氏`**和**`地址`**等其他字段不会返回在请求结果中。

#### 使用数据加载器（Dataloaders）减少网络调用

虽然 Dataloaders 不是 GraphQL 库本身的一部分，但是它的确是一个很有用的第三方库，可以用来解耦应用程序中不相关的部分，同时不会牺牲批量数据加载的性能。虽然加载器提供了一个加载各个独立值的 API，但是所有并发请求都将被合并起来才分送给你的批处理加载函数。这使你的应用程序可以安全地在整个应用程序进行数据的分发与获取。

这方面的一个例子是，从另一个称为**事务服务**的服务中获取人的银行信息，后端可以从**事务服务**中获取银行信息，然后将结果与人的**`姓名`**和**`年龄`**结合起来后作为结果返回。

#### 公开数据和数据库模型之间的解耦

GraphQL 的一大优点是可以将数据库建模数据和给用户公开的数据解耦。这样，在设计持久层时，我们可以专注于该层的需求，然后分别考虑如何采取最好的方式将数据暴露给使用者。这与 dataloader 的使用密切相关，因为你可以在将数据发送给用户之前将它们组合在一起，从而使得公开数据的设计模型变得非常容易。

#### 忘记 API 的版本控制

API 的版本控制是一个常见问题，通常一个简单的解决方案是，在相同的 API 前面添加一个**v2**标识。但一旦有了 GraphQL，情况就不同了。虽然你仍然可以使用相同的解决方案，但这与 GraphQL 的理念不合。官方文档明确指出你应该改进你的 API，这意味着向已有端点添加更多的字段并不会破坏原有的 API。前端仍然可以使用相同的 API 进行查询，并且可以根据需要查询新字段。这种处理方式真的很巧妙。

在与前端团队协作时，这个特性非常有用。他们可以发出请求，并添加由于设计更改而需要的新字段，而后端可以轻松地添加该字段，同时不会破坏现有的 API。

#### 独立团队

使用 GraphQL，前端和后端可以独立工作。因为 GraphQL 具有严格的类型化架构，因此两个团队可以并行工作互不影响。首先，**前端**无需查看后端代码即可轻松地生成数据模型，且生成的数据模型可以直接用于创建数据查询。其次，**前端**可以使用模拟（mock）出来的 API 来测试代码。这样便不会阻碍前后端的开发工作，大大的提升了程序员的开发体验。

![Photo by [Perry Grone](https://unsplash.com/@perrygrone?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10944/0*ClSi_KEJVSWlHwUL)

## 缺点

#### 并非所有的 API 都能改进

有时，会因业务或设计而产生一些变化，这需要对 API 的实现进行彻底更改。在这种情况下，你将不得不依靠旧的方式进行版本控制。

#### 不可读的代码

由于经历了多次迭代，所以有时在使用 Dataloader 读取数据时代码会分散到多个位置，这可能很难维护。

#### 响应时间更长

由于查询会不断发展并变得臃肿，因此有可能会延长响应时间。为避免这种情况，请确保简明扼要的响应资源。有关指导原则，请查看[Github GraphQL API。](https://developer.github.com/v4/)

#### 缓存

缓存 API 响应的目的主要是为了更快地从将来的请求中获取响应。与 GraphQL 不同，RESTful API 可以利用 HTTP 规范中内置的缓存。正如前面提到的，GraphQL 查询可以请求资源的任何字段，因此本质上是很难实现缓存的。

## 结论

我强烈建议使用 GraphQL 替代 REST API。GraphQL 所提供的灵活性绝对可以取代它的痛点。这里提到的优缺点可能并不总适用，但是探索如何借助 GraphQL 来帮助你完成项目是很值得思考的。

如果你有任何意见，请在下面回复。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
