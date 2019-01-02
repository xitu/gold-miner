
> * 原文地址：[REST APIs are REST-in-Peace APIs. Long Live GraphQL](https://medium.freecodecamp.org/rest-apis-are-rest-in-peace-apis-long-live-graphql-d412e559d8e4)
> * 原文作者：[Samer Buna](https://medium.freecodecamp.org/@samerbuna)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/rest-apis-are-rest-in-peace-apis-long-live-graphql.md](https://github.com/xitu/gold-miner/blob/master/TODO/rest-apis-are-rest-in-peace-apis-long-live-graphql.md)
> * 译者：[sigoden](https://github.com/sigoden)
> * 校对者：[jasonxia23](https://github.com/jasonxia23)、[shawnchenxmu](https://github.com/shawnchenxmu)

# REST API 已死，GraphQL 长存

在使用多年的 REST API 后，当我第一次接触到 GraphQL 并了解到它试图解决的问题时，我无法抗拒给本文取了这样一个标题。

![![](https://ws2.sinaimg.cn/large/006tNc79gy1fi3ephib0oj312g0aqq45.jpg)](https://twitter.com/samerbuna/status/644548922979954688)

当然，过去，这可能只是本人有趣的尝试，但是现在，我相信这有趣的预测正在慢慢发生。

请不要理解错了，我并没有说 GraphQL 会干掉 REST 或其它类似的话语，REST 大概永远不会真正消亡，就像 XML 并不会真正消亡一样。我只是认为 GraphQL 与 REST 的关系将会变得像 JSON 与 XML 一样。

本文并不是百分百支持 GraphQL。需要注意 GraphQL 灵活性所带来的开销。好的灵活性常常伴随着大的开销。

我信仰"一切[从提问开始](https://startwithwhy.com/)"，让我们开始吧。

### 总而言之：为什么需要 GraphQL？

GraphQL 漂亮地解决了如下三个重要问题：

- **填充一个视图需要的数据进行多次往返拉取**: 使用 GraphQL，我们总能够通过**一次**往返就能从服务器获取到用来填充视图的所有初始化数据。如果使用 REST API，要到达相同的效果，我们需要引入非结构化的参数和条件，使管理和维护变得困难。
- **客户端对服务端产生依赖**: 使用 GraphQL，客户端就有了自己的语言：1) 无需服务端对数据的结构和规格进行硬编码 2) 客户端与服务端解耦。这意味着我们能让客户端与服务器分离并单独对它进行维护和升级。
- **糟糕的前端开发体验**: 使用 GraphQL，前端开发人员使用声明式语言表达其对填充用户界面所需要的数据的需求。他们表达他们需要什么，而不是如何使其可用。这样就在 UI 需要的数据和开发人员在 GraphQL 中表述的数据之间构建一种紧密的联系。

本文将就 GraphQL 如何解决这些问题进行详细阐述。

在我们正式开始之前，考虑到你目前可能还不熟悉 GraphQL ，我们先从简单定义开始。

### GraphQL 是什么？

GraphQL 是一门**语言**。 如果我们传授 GraphQL 语言给一款应用，这款应用就能够向支持 GraphQL 的后端数据服务**声明式**传达数据需求。

> 就像小孩子很快就能学会一种新语言，而成年人却很难学会一样，使用 GraphQL 从头开始编写应用比将 GraphQL 添加到一款成熟的应用要容易很多。

为了让数据服务支持 GraphQL，我们需要实现一个**运行时**层并将它暴露给想要与服务通信的客户端。可以将这个添加到服务端的层简单地看作是一位 GraphQL 语言翻译员，或代表数据服务并会说 GraphQL 语言的代理。GraphQL 并不是一个存储引擎，所以它不能作为一个独立的解决方案。这就是我们不能有一个纯粹的 GraphQL 服务，而需要实现一个翻译运行时的原因。

这个层可以用任何语言编写，它定义了一个通用的基于图的模板来发布它所代表的数据服务的**功能**。支持 GraphQL 的客户端可以在功能允许的范围内使用这种模版进行查询。这一策略可以将客户端与服务端分离，允许两者独立开发和扩展。

一个 GraphQL 请求既可以是**查询**（读操作），也可以是**修改**（写操作）。不管是何种情形，请求均只是一个带有特定格式的简单字符串，GraphQL 服务器可以对其进行解析、执行、处理。在移动和 Web 应用中最常见的响应格式是 *JSON* 。

### 什么是 GraphQL ？（把我当五岁小孩后再向我解释版）

GraphQL 一切为了数据通信。你有一个需要需要彼此通信的客户端和服务器，客户端需要告诉服务器它需要什么数据，服务器需要根据客户端的需求返回具体的数据，GraphQL 作为这种通信的中间人。
![](https://cdn-images-1.medium.com/max/1600/1*fSaxvhFkiXvr8FoFZZjF0g.png)

屏幕截图中是我的 Pluralsight 课程 —— 使用 GraphQL 构建可扩展 API
你问，客户端难道不能直接与服务器通信吗？答案是能。

这儿有几个原因导致我们需要在客户端和服务器间添加一个 GraphQL 层。原因之一，可能也是最主要的原因，这样做更**高效**。客户端通常需要从服务器获取**多个**资源，而服务器通常只能理解如何对单个资源进行回复。这就造成客户端最后需要多次往返服务器才能集齐需要的数据。

通过 GraphQL，我们基本上可以将这种复杂的多次请求转移到服务端，让 GraphQL 层来处理。客户端向 GraphQL 层发起单个请求，并得到一个完全符合客户端需求的响应。

使用 GraphQL 层还有很多其它好处。例如，另一个大的好处是与多个服务进行通信。当您有多个客户端向多个服务请求数据时，中间的 GraphQL 可以让通信简化、标准化。尽管与 REST API 比起来这不算是卖点 —— 因为 REST API 也可以很容易地完成同样的工作 —— 但 GraphQL 运行时提供了一种结构化和标准化的方法。

![](https://cdn-images-1.medium.com/max/1600/1*2mTYU2RCJHagQrqQokYpww.png)

屏幕截图中是我的 Pluralsight 课程 —— 使用 GraphQL 构建可扩展 API
不是让客户端直接请求两个不同的数据服务（如幻灯片所示），而是让客户端先与 GraphQL 层通信。GraphQL 层再分别与两个不同的数据服务通信。通过这种方式，GraphQL 解决了客户端必须与多个不同语言的后端进行通信的问题，并将单个请求转换为使用不同语言的多个服务的多个请求。

> 想象一下，你认识三个人，他们说不同的语言，掌握着不同领域的知识。然后再想象一下，你遇到一个只有结合三个人的知识才能回答的问题。如果你有一个会说这三种语言的翻译人员，那么任务就变成将你的问题的答案放在一起，这就很容易了。这就是 GraphQL 运行时要做的。

计算机还没有聪明到能回答任何问题（至少目前是这样），所以它们必须遵守某种算法。这就是为什么我们需要在 GraphQL 运行时中定义一个模板让客户端来使用的原因。

这个模板基本上是一个功能文档，它列出了客户端能向 GraphQL 层查询的全部问题。因为模板采用了图形节点所以在使用上具有一定的灵活性。模板也表明了 GraphQL 层能解答哪些问题，不能解答哪些问题。

还是不理解？让我用最确切最简短的话语来描述 GraphQL ：**一种 REST API 的替代**。接下来让我回答一下你很可能会问的问题。

### REST API 有什么错？

REST API 最大的问题是其天然倾向多端点。这造成客户端需要多次往返获取数据。

REST API 通常由多个端点组成，每个端点代表一种资源。因此，当客户端需要多个资源时，它需要向 REST API 发起多个请求，才能获取到所需要的数据。

在 REST API 中，是没有描述客户端请求的语言的。客户端无法控制服务器返回哪些数据。没有让客户端对返回数据进行控制的语言。更确切的说，客户端能使用的语言是很有限的。

例如，有如下进行**读取**操作的 REST API：

- GET `/ResouceName` - 从该资源获取包含所有记录的列表
- GET `/ResourceName/ResourceID` - 通过 ID 获取某条特定记录

例如，客户端是不能够指定从该资源的记录中选择哪些**字段**的。信息仅存在于提供 REST API  的服务中，该服务将始终返回所有字段，而不管客户端需要什么。借用 GraphQL 术语描述这个问题：**超额获取**(over-fetching) 没用的信息。这浪费了服务器和客户端的网络内存资源
*
REST API 的另一个大问题就是版本控制了。如果你需要支持多版本，那你就需要为此创建多个新的端点。这会导致这些端点很难使用和维护，此外，还造成服务端出现很多冗余代码。

上面列出的一些 REST API 带来的问题都是 GraphQL 试图解决的。这并不是 REST API 带来的全部问题，我也不打算说明 REST API 是什么不是什么。我只是在谈论一种最流行的基于资源的 HTTP 终点 API。这些 API 最终都会变成一种具有常规 REST 特性的端点和出于性能原因定制的特殊端点的组合。

### GraphQL 如何实现其魔力？

在 GraphQL 背后有很多的概念和设计策略，这儿列举了一些最重要的：

- GraphQL 模板是强类型的。要创建一套 GraphQL 模板，我们需要定义了一些带有**类型**的**字段**。这些类型可以是原始数据类型也可以是自定义的，在模板中一切均需要类型。丰富的类型系统带来了丰富的特性，如 API 自证，这让我们能够为客户端和服务端创建强大的工具。
- GraphQL 以图的形式组织数据，数据自然形成图。如果你需要一个结构描述数据，图是一种不错的选择。GraphQL 运行时让我们能够使用与该数据的自然图结构匹配的图 API 来表示我们的数据。
－GraphQL 具有表达数据需求声明性质。GraphQL 让客户端能够以一种声明性的语言描述其对数据的需求。这种声明性带来了一种围绕着 GraphQL 语言使用的心智模型，该模型与我们用自然语言思考数据需求的方式接近，让我们使用 GraphQL 时比使用其它方式更容易。

最后一个概念是我为什么认为 GraphQL 是游戏规则改变者的原因。

这些全是抽象概念。让我们深入到细节中。

为了解决多次往返请求的问题，GraphQL 让响应服务器变成一个端点。本质上，GraphQL 把自定义端点这一思想发挥到了极致，它让这个端点能够回复所有数据问题。

伴随着单个端点这一概念的另一个重要概念是需要一种强大的客户端请求描述语言与自定义的单个端点进行通信。缺少客户端请求描述语言，单个端点是没有意义的。它需要一种语言解析自定义请求以及根据自定义请求返回数据。

拥有一门客户端请求描述语言意味这客户端能够对请求进行控制。客户端能够精确表达它们需要什么，服务端也能精准回复客户端需要的。这就解决了超额获取的问题。

当涉及到版本时，GraphQL 提供了一种有趣的解决方式。版本能够被完全避免。基本上，我们只需要在保留老的字段的基础上添加新**字段**即可，因为我们用的是图，我们能很灵活的在图上添加更多节点。因此，我们可以在图上留下旧的 API，并引入新的 API，而不会将其标记为新版本。API 只是多了更多节点。

这点对于移动端尤为重用，因为我们无法充值这些移动端使用的版本。一经安装，移动端应用可能数年都使用老版本 API 。对于 Web，我们可以通过发布新代码简单的控制 API　版本，对于移动端应用，这点很难做到。

**还没有完全相信？** 结合实例一对一对比 GraphQL 和 REST 怎么样？

### REST 风格 API vs GraphQL API —— 案例

我们假设我们是开发者，负责构建闪亮全新的用户界面，用来展示星球大战影片和角色。

我们要构建的第一份 UI 很简单：一个显示单个星球大战角色的信息视图。例如，达斯·维德以及电影中出场的其他角色。这个视图需要显示角色的姓名、出生年份、母星名、以及出场的所有影片中出现的头衔。

听起来很简单，我们实际上已经需要处理三种不同的资源：人物、星球和电影。资源之间的关系很简单，任何人都很容易就猜出这里的数据组成。

此 UI 的 JSON 数据可能类似于：

    {
      "data": {
        "person": {
          "name": "Darth Vader",
          "birthYear": "41.9BBY",
          "planet": {
            "name": "Tatooine"
          },
          "films": [
            { "title": "A New Hope" },
            { "title": "The Empire Strikes Back" },
            { "title": "Return of the Jedi" },
            { "title": "Revenge of the Sith" }
          ]
        }
      }
    }

假设数据服务按照上面的结构返回数据给我们。我们有一种可行的方式即使用 React.js 来展现视图：

    // The Container Component:
    <PersonProfile person={data.person} ></PersonProfile>

    // The PersonProfile Component:
    Name: {person.name}
    Birth Year: {person.birthYear}
    Planet: {person.planet.name}
    Films: {person.films.map(film => film.title)}

这是一个简单例子，此外我们关于星球大战的经验也能帮我们一点忙，我们可以很清楚的明白 UI 和数据之间的关系。与我们想象一致，UI 是使用了 JSON 数据对象中的全部的键。

让我们来看看如何通过 REST 风格 API 获取这些数据。

我们需要单个角色的信息，假设我们知道这个角色的 ID，REST 风格的 API 倾向于这样输出这些信息：

    GET - /people/{id}

这个请求将会返回角色的姓名、出生年份以及一些其它信息给我们。一个规范的 REST 风格 API 将会返回给我们角色星球的 ID 以及该角色出现过的所有影片的 ID 组成的数组。

这个请求以 JSON 格式返回的响应类似于：

    {
      "name": "Darth Vader",
      "birthYear": "41.9BBY",
      "planetId": 1
      "filmIds": [1, 2, 3, 6],
      *** 其它信息我们不需要 ***
    }

然后为了获取星球名称，我们发起请求：

    GET - /planets/1

接着为了获取影片中的头衔，我们发起请求：

    GET - /films/1
    GET - /films/2
    GET - /films/3
    GET - /films/6

当从服务器接受到所有的六个数据后，我们才能将其组合并生成满足视图需要的数据。

除了有需要六次往返才能获取到满足一个简单 UI 需求的数据这一事实外，这种方式并无不可。我们阐明了如何获取数据，以及如何处理数据使其满足视图需要。

如果你想确认我说的你可以自己动手尝试。有一个部署在 [http://swapi.co/](http://swapi.co/) 上的 REST API 服务提供了星球大战的数据，点进去，在里面尝试构造角色数据。数据的键名可能不同，但 API 端点是一致的。你同样需要进行六次 API 调用。同样，你不得不超额获取视图不需要的信息。

当然，这只是 REST API 的一个实现方式，可能有更好的实现让生成视图更简单。例如，如果 API 服务支持资源嵌套并能理解角色和影片之间的关系，我们能够通过这种方式获取影片数据：

    GET - /people/{id}/films

然而，一个纯粹的 REST API 服务很难实现这点。我们需要让后端工程师为我们创建自定义端点。这造成 REST API 规模不断增长这一事实 —— 为了满足不断增长的客户端的需要，我们不断添加自定义端点。管理这些自定义端点很难。

让我们来看一看 GraphQL 策略。GraphQL 在服务端拥抱自定义端点思想并把它发展到极致。服务将只是一个端点，通道变得没有意义。如果我们使用 HTTP 实现，HTTP 方法将失去意义。假设我们有一个单一的 GraphQL 端点，它的 HTTP 地址是 `/graphql`

因为我们希望一次往返获取需要的数据，所以我们需要明明白白告诉服务器我们需要哪些数据。我们通过 GraphQL 进行查询：

    GET or POST - /graphql?query={...}

GraphQL 查询只是字符串，但它将包含我们需要的全部数据。这就是声明的强大之处。

英语中，我们这样阐述数据需求：**我们需要角色名、出生年份、星球名和在所有出现过的影片中的头衔**。通过 GraphQL，我们进行如下转换：

    {
      person(ID: ...) {
        name,
        birthYear,
        planet {
          name
        },
        films {
          title
        }
      }
    }

再细读一次英语表述的需求并与 GraphQL 查询进行对比。它们不能再更接近了。现在，将 GraphQL 查询与我们最开始用到的原始 JSON 数据进行对比。GraphQL 查询完全与 JSON 数据结构相对应，不过排除所有是值的部分。如果我们仿照问题与答案关系来考虑这中情况，那问题就是没有具体答案的答案原语。

如果答案是：

> **离太阳最近的星球是水星。**

一种好的提问方式是保留原话只去掉提问部分：

> **哪个星球里太阳最近？**

这种关系同样适用于 GraphQL 查询。拿着 JSON 格式的响应数据，移除所有是答案的部分（作为值的对象），最后你得到了一个非常适合代表关于 JSON 响应问题的 GraphQL 查询。

现在，将 GraphQL 查询和与我们展示数据的声明性 React UI 对比。所有出现在 GraphQL 查询中的数据都出现在了 UI 中。所有出现在 UI 中的数据都出现在了 GraphQL 查询中。

这就是 GraphQL 强大的心智模型。UI 知晓它所需要的确切数据，提取需要的数据也很容易。编写 GraphQL 查询变成一个从 UI 中提取作为变量这一简单的工作。


将模型进行反转，它仍然很强大。如果我们知道了 GraphQL 查询，我们同样知道如何在 UI 中使用相应数据。我们不需要分析响应数据就能使用它，也不需要的这些 API 的文档。这一切都是内建的。

获取星球大战数据的 GraphQL 托管在 [https://github.com/graphql/swapi-graphql](https://github.com/graphql/swapi-graphql)。点击进去并尝试构造角色数据。只有一点点不同，我们之后会谈论，以下是可以从这个 API 中获取视图所需要数据的正式查询（使用达斯·维德举例）

    {
      person(personID: 4) {
        name,
        birthYear,
        homeworld {
          name
        },
        filmConnection {
          films {
            title
          }
        }
      }
    }

这个请求返回的我们的响应数据结构十分接近视图用到的，记住，这些数据是我们通过一次往返获得的。

### GraphQL 灵活性带来的开销

完美的解决方案是不存在的。GraphQL 带来了灵活性，也带来了一些明确的问题和考量。

GraphQL更容易的造成一个安全隐患是资源耗尽型攻击（拒绝服务攻击）。GraphQL 服务器可能会受到伴随着极其复杂的查询的攻击，造成服务器资源耗尽。很容易就能构造一个深度嵌套关系链（用户 -> 好友 -> 好友的好友。) 或者多次通过字段别名请求同一字段的查询。资源耗尽型攻击并没有限定 GraphQL，但是在使用 GraphQL 时，我们要特别小心。

这儿有一些缓解措施我们可以用上。我们可以进行一些高级查询的开销分析，对单个用户请求的数据量做某种限制。我们也可以实现一种机制对需要很长时间处理的请求进行超时处理。此外，考虑到 GraphQL 就只是一个处理层，我们能在 GraphQL 之下的更底层进行速率限制。

如果我们尝试保护的 GraphQL API 端点并不是公开的，仅供我们私有的客户端（web、移动）内部访问，我们能够使用白名单策略并预先审核服务器能够处理的查询。客户端仅能通过唯一查询标识码向服务器发起审核过的查询。Facebook 似乎就采用了这种策略。

当使用 GraphQL 时，我们还需要考虑到认证和授权。我们是在 GraphQL 解析请求之前，之后还是之间处理它们呢？

为了回答这个问题，需要将 GraphQL 想象成你一种位于你的后端数据请求逻辑顶层的 DSL（领域限定语言）。它只是一个能够被我们放在客户端与实际数据服务（多个）之间的处理层。

将认证和授权当成另一个处理层。GraphQL 与认证和授权逻辑的具体实现关系不大。它的意义不在这儿。但是如果我们把这些层放在 GraphQL 之后，我们就可以在 GraphQL 层使用访问令牌连通客户端与执行逻辑。这和我们在 REST 风格 API 处理认证和授权类似。

另一件因为 GraphQL 而变得更具挑战性的任务是客户端数据缓存。REST 风格的 API 因其类似目录更容易进行缓存处理。REST API 通过访问路径获取数据，我们能够使用访问路径作缓存键。

对于 GraphQL，我们能够采用类似的策略使用查询字段作为响应数据的缓存键。但是这种方式有限制，效率低下，还容易造成数据一致性方面的问题。原因是多个 GraphQL 查询的结果很容易重叠，而这种缓存策略并没有考虑到这种重叠。

这个问题有一个很好的解决方案。一个图的查询意味这一个**图的缓存**。如果我们将一个 GraphQL 查询的响应数据正则化为一个平铺的记录集合，为每个记录设置一个全局唯一 ID，我们就能够只缓存这些记录而不用缓存整个响应了。

这种处理并不容易。这样导致一些记录指向另一些记录，导致我们可能得管理一个环形图，导致在写入和读取缓存时我们需要进行遍历，导致我们需要编写一个层来处理缓存逻辑。但是，这种方法总体上比基于响应的缓存更高效。[Relay.js](https://facebook.github.io/relay/) 就是一个采用这种缓存策略并在内部进行自动管理的框架。

对于 GraphQL 我们最需要关心的问题可能是被普遍称作 N+1 SQL 查询的问题了。GraphQL 的字段查询被设计成独立的函数，从数据库获取这些字段可能造成每个字段都需要一个数据库查询。

简单 REST 风格 API 端点的逻辑，易分析，易检测，可以优化 SQL 查询语句来解决 N+1 问题。而 GraphQL 需要动态处理字段，这点不容易做到。幸运的是 Facebook 正在研发一个处理类似问题的可能的解决方案：DataLoader。

如名字暗示，DataLoader 是一款能让我们从数据库读取数据并让数据能被 GraphQL 处理函数使用的工具。我们使用 DataLoader，而不是直接通过 SQL 查询从数据库获取数据，将 DataLoader 作为代理以减少我们实际需要发送给数据库的 SQL 查询。

DataLoader 使用批处理和缓存的组合来实现。如果同一个客户端请求会造成多次请求数据库，DataLoader 会整合这些问题并从数据库批量拉取请求数据。DataLoader 会同时缓存这些数据，当有后续请求需要同样资源时可以直接从缓存获取到。

---

谢谢你阅读本文。如果你觉得本文有用，点击下面的连接。关注我以获取更多的关于 Node.js 和 JavaScript 的文章。

我在 [Pluralsight](https://app.pluralsight.com/profile/author/samer-buna) and [Lynda](https://www.lynda.com/Samer-Buna/7060467-1.html) 上创建了**在线课程**。我最近的课程包含 Advanced React.js](https://www.pluralsight.com/courses/reactjs-advanced), [Advanced Node.js](https://www.pluralsight.com/courses/nodejs-advanced), and [Learning Full-stack JavaScript](https://www.lynda.com/Express-js-tutorials/Learning-Full-Stack-JavaScript-Development-MongoDB-Node-React/533304-2.html)。

我还在做让 JavaScript、Node.js、React.js 和 GraphQL 初学者进阶到更高级别的线上线下培训。如果您正在寻找教练，[请与我联系](mailto:samer@jscomplete.com)。如果你您对本文以及我写的其它文章有疑问，可以在 『这个**slack**账户』() 找到我并在 #questions 频道提问。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
