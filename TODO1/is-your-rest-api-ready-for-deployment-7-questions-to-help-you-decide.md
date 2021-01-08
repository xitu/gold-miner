> * 原文地址：[Is Your REST API Ready for Deployment? 7 Questions to Help You Decide](https://codeburst.io/is-your-rest-api-ready-for-deployment-7-questions-to-help-you-decide-a371de9faa76)
> * 原文作者：[Zac Johnson](https://medium.com/@zacjohnson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/is-your-rest-api-ready-for-deployment-7-questions-to-help-you-decide.md](https://github.com/xitu/gold-miner/blob/master/TODO1/is-your-rest-api-ready-for-deployment-7-questions-to-help-you-decide.md)
> * 译者：[Renzi Meng](https://github.com/mengrenzi)
> * 校对者：[Roc](https://github.com/QinRoc)

# 你的 REST API 准备好部署了吗？7 个问题帮助你做出决定

[构建一个 API](https://codeburst.io/this-is-how-easy-it-is-to-create-a-rest-api-8a25122ab1f3) 似乎令人生畏，这是有充分理由的。很多地方[经常会](https://medium.com/better-programming/tips-on-rest-api-error-response-structure-aebe726e7f94)出错。与其在你的 REST API 已经部署好之后再从头开始，不如从一开始就谨慎构建一个优秀的 API。

你怎么知道何时说「等等…… 暂时不要部署此 API」？

以下问题可以帮助你确定答案。

![](https://cdn-images-1.medium.com/max/2560/1*ol3WYuuPV0nhrE0tMNiiZg.jpeg) 

**你是否有效记录了 REST API？**

坦率地说，如果你的 API 提供了糟糕的（或没有）文档，开发人员就不会想要使用它。设计你的文档来引导开发人员了解 API 的重要方面，使其易于使用。你的文档还应该使开发人员易于维护和更新 API。

创建教程:

* 可公开访问
* 提供定义术语的词汇表
* 指定和定义资源
* 解释你的 API 方法

如果你不知道从哪里开始，[Raml](https://raml.org/) 或 [Swagger](https://swagger.io/) 之类的工具都可以为你提供帮助。

**你的 REST API 是否使用正确的数据格式？**

设计 API 时，你可以选择数据格式，而你选择的格式可以决定成败。由于 API 是客户端和服务器之间的连接点，因此它的数据格式需要对双方都是用户友好的。

流行的格式包括:

* **直接格式 (如 JSON、XML、YAML)。** 这些格式用于管理直接与其他系统一起使用的数据。它们非常适合与其他 APIs 交互.
* **Feed 格式（如 RSS、SUP、Atom）。** 这些格式主要用于序列化社交媒体和博客的更新。
* **数据库格式（如 SQL、CSV）。** 它们非常适合数据库到数据库以及数据库到用户的通信。

** 你是否有效地命名了 REST API 的路径？
 
** 路径标识资源的位置，并指定如何访问这些资源。

你应该遵循良好的 REST 实践来命名你的路径，包括:

* **简单的资源名。** 不要让开发人员猜测资源名称，也不要迫使他们仔细检查文档以发现如何查找资源。确保名称从一开始就是直观的。
* **在 URI 中使用名词。** RESTful URI 应该包括一个名词（比如 "/photos"），而不包括动词。例如，不要使用 "/createPhotos" 这样的名字。这里不要使用任何 CRUD（增、删、改、查）约定。
* **保持资源名称为复数。** 为了一致性，建议使用 "/photos" 或 "/settings"（而不是 "/photo"）。
* **使用连字符，而不是下划线。** 一些浏览器隐藏了下划线（_）。连字符（-）更容易被看到。
* **小写字母。** URI 元素区分大小写（模式（`scheme`）和主机组件除外）。为了一致性，坚持使用小写字母。

**你是否对 REST API 进行了正确的版本设置？**

你的 API 将随时间而变化，因此你需要管理这些变化。保持你的旧 API 版本处于活动状态，并为仍在使用它们的用户维护它们。

适当的版本控制有助于将发送到新更新的路径的无效请求数减到最少。

版本控制的方法包括:

* 在自定义请求头中添加版本号作为属性
* 使用请求参数进行版本控制，即添加版本号作为查询参数
* 在 URI 中包含当前版本号
* 媒体类型版本控制，或更改 accept 标头以反映当前版本

**你是否测试了 REST API？**

传统上，测试是在用户界面侧进行的，侧重于网站用户体验等方面。

但是由于 API 连接数据层和 UI，因此 API 测试现在被认为是一项至关重要的任务。通过[测试你的 REST API](https://www.sisense.com/blog/rest-api-testing-strategy-what-exactly-should-you-test/)，你可以确保其性能和功能。

API 测试的类型包括：

* **性能测试。** 顾名思义，这使你可以清楚地了解 API 的性能。性能测试包括功能测试和负载测试。
* **单元测试。** 单元可以是路径，HTTP 方法（GET, POST, PUT, DELETE），请求头或请求主体。
* **集成测试。** 这可能是最常用的 API 测试类型。你的 API 是集成数据、应用程序和用户设备的核心。因此，测试这种集成至关重要。
* **端到端测试。** 这种类型的测试使你能够确认 API 连接之间数据流的顺畅性。

**你是否为你的 REST API 建立了安全措施？**

2020 年代，黑客变得越来越聪明和强大。你必须保持警惕。

良好的安全实践包括：

* **仅使用 HTTPS。** 仅使用 HTTPS 可保护凭据，例如密码，JSON Web 令牌，API 密钥等。此外，还应包括 HTTP 请求的时间戳。这使服务器只能在指定的时间范围内接受请求，以防止黑客尝试重放攻击。
* **限制允许的 HTTP 方法。** 拒绝所有不在你的允许方法列表中的请求。
* **不要让敏感信息显示在 URL 中。** 信不信由你，这有时会发生。确保任何 URL 中均未出现密码、用户名、API 密钥等。
* **安全检查。** 要彻底，不要冒险。保护你的 HTTP cookie 和数据库。隐藏可能聚合到日志的所有敏感数据。采用有效的安全密码检查，并使用 CSRF 令牌。

**你是否设计了具有可伸缩性的 REST API？**

随着时间的推移，你需要使用 API 来处理越来越多的请求。把 API 设计成可伸缩的以保持其性能并根据需要添加新功能非常重要。

甚至在设计之前就估计系统的负载。评估大致的每秒请求数和请求大小。然后，在 API 正常运行期间，请经常检查其负载分配，响应时间和其他重要指标。

考虑使用能够自动扩展系统的云服务。这样，你就无需购买昂贵的设备来处理越来越多的数据。

**准备好运行了吗？**

花时间并注意细节将使你免于日后的挫折。在这个过程的每个环节，问自己：“如果我是使用此 API 的开发人员，我会对它感到满意吗？”

如果有错误或粗糙之处，则有理由暂停部署以确保一切正常。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
