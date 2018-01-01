> * 原文地址：[How to start with backend TypeScript and use it’s full potential.](https://medium.com/@igorandreev/how-to-start-with-backend-typescript-and-use-its-full-potential-5114e52012b)
> * 原文作者：[idchlife](https://medium.com/@igorandreev?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-start-with-backend-typescript-and-use-its-full-potential.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-start-with-backend-typescript-and-use-its-full-potential.md)
> * 译者：[xilihuasi](https://github.com/xilihuasi)
> * 校对者：[tvChan](https://github.com/tvChan), [noahziheng](https://github.com/noahziheng)

# 如何用 TypeScript 玩转后端？

我将从一个开发者的角度介绍几个优秀的库。它们可以满足你后端应用的绝大部分特性。装饰器和元数据的能力在这些库中得到的充分的应用，使其非常强大并且简单易用。

我希望这篇文章可以帮到像我这样，喜欢 TypeScript 而且想用它编写后端代码的人，让他们像我一样发现这些库之后乐在其中。

**TL;DR —— 堆栈使你的后端应用像许多使用其他语言的企业静态解决方案一样强大：**

* 使用装饰器，参数，body 注入的路由和控制器的库

* 依赖注入和使用装饰器的 services 的库

* 使用装饰器的 ORM 就像 Doctrine/Hibernate 那样方便操作实体

* 给那些还不熟悉使用 TypeScript 写后端的朋友的小建议

**Routing-controllers：控制器，行为，请求等**

[**pleerock/routing-controllers** routing-controllers —— 创建结构化，声明性和组织良好的基于类的控制器](https://github.com/pleerock/routing-controllers)

尽管这个库是作为 Express/Koa 的 TypeScript helper 编写的，它也会对你编写控制器有所帮助，就像你在 Java/PHP/C# 的企业级框架里用到的那样。

下面是一个控制器的小例子：

```
import {JsonController, Param, Body, Get, Post, Put, Delete} from "routing-controllers";

@JsonController()
export class UserController {

    @Get("/users")
    getAll() {
       return userRepository.findAll();
    }

    @Get("/users/:id")
    getOne(@Param("id") id: number) {
       return userRepository.findById(id);
    }

    @Post("/users")
    post(@Body() user: User) {
       return userRepository.insert(user);
    }

}
```

这对一些人来说就像是摆脱了噩梦：不再有带路由的组件，充满嵌套的中间件以及具有注入，验证和请求参数的中间件的实现（是的，你甚至可以定义参数类型和是否必传！如 @Body({ required: true, validate: true }) 这种写法将能很好地工作，如果缺少参数或者不正确的请求就会抛出异常）

装饰器有很多有用的特性，如基础控制器的 @Controller，可在 actions 中定义内容的类型以及使用 @JsonController 服务和接收 JSON。

我正在 Express 中使用它，既然我们有了 async/await （即使 TS Node.js 开发已经过了好几个月我还是忍不住赞美）我们似乎不再需要 Koa 了（现在 routing-controllers 可以更好的支持 Express ）。而且 Express 有更大的类型集 @types。

下面是我项目中使用 routing-controllers 和其他 @pleerock 库（VSCode, 如果有兴趣的话，引用来自 TypeLens 插件）的例子：

![](https://cdn-images-1.medium.com/max/800/1*DdYJb1pIl3JYBfoCQPvSRw.png)

如你所见，routing-controllers 甚至提供了 undefined 返回码（也有 empty 和 null 的装饰器）以及许多其他特性。关于 this.playerService —— 这是另一个迷人的库，稍后我将介绍它。

总体来看，库有强大的文档，它可以帮助你理解和构建适用于操作甚至整个控制器的自定义中间件的应用程序（这对我来说是个绝妙的时刻）。链接地址如你所见就在那，非常方便。

当然，你也可以使用很多 Express/Koa 中间件把你的应用抽离出来，以及视图配置（库也有针对视图的装饰器），认证（可以通过中间件应用到整个控制层），错误处理等方面的配置。

通常我把他们存放在 /controllers 文件夹。

**TypeDI：依赖注入，services**

[https://github.com/pleerock/typedi](https://github.com/pleerock/typedi)

这个库帮我定好了项目结构，方便编码并且不用去想「好吧 service 存在哪里，这个是 service？唔或许是另一个，但是，它怎么依赖另一个 service？怎么引用其他 service 唔。」

回到我的 PlayerService，下面这部分你可以看到它依赖了什么（其他 services）：

![](https://cdn-images-1.medium.com/max/800/1*lpTGJEYWTCr18jjm8uAnbg.png)

@Inject 对我来说是在处理 services 和逻辑完整的后端应用方面最好用的装饰器。

（如果你想了解 @OrmEntityManager —— 另一个来自 @pleerock 的库，稍后我将讲解）

是的，你可以有很多 services 依赖其他的 services。并且如果你有 service 循环依赖，你可以通过明确地定义类型来解决这个问题（库的文档涵盖了大部分的问题和情景）

对那些不熟悉 services，service 容器，services 依赖注入等的朋友。简要说明：

你有某种功能，想把它存在类中，然后你想要类的实例并且想让这个类依赖另一个，另一个等。service 容器的依赖注入可以为你保驾护航。你可以从容器中获取 services 并且它会自己处理 services 的所有依赖，给你带有其他实例的工作实例自动注入。

我关于这个库的描述并不涵盖它的所有潜能（你可以自己查看它的文档——有更多的特性可以使用）：你可以在定义 services 时给它命名，还可以定义构造器注入等。

通常我把我的 services 存放在 /services 文件夹。

**TypeORM：使用 ORM 定义关系型实体，不同列类型和不同数据存储方案非常方便（关系型，非关系型）**

[**typeorm/typeorm**_typeorm —— 可在 TypeScript and JavaScript (ES7, ES6, ES5)环境中使用的 Data-Mapper ORM。支持 MySQL, PostgreSQL, MariaDB, SQLite](https://github.com/typeorm/typeorm)

这给我的感觉就是，用 TypeScript 写 Node.js 最终有能力跟其他语言和 ORMS 竞争。

强大的 ORM 可以让你很方便地用一种可理解的方式编写实体。我不是其他许多类似这种 Node.js ORMS 的粉丝：

```
module.exports = { id: SomeORM.Integer, name: SomeOrm.String({ …})}
```

我总是想让实体写成类。被赋予类型的属性的类，会被带有简单装饰器的 ORM 发现。甚至是没有类型的。

TypeORM 给你这种能力。我项目中的另一个例子：

![](https://cdn-images-1.medium.com/max/800/1*VJEWGi8ycPxqaLNzjev7nA.png)

如你所见，我甚至没在装饰器中写属性的类型（你可以这样做，不要担心，明确地定义类型，默认的，可空的等）！TypeORM 为我做了所有这些工作，了解什么类型（感谢 TypeScript 反射：元数据扩展功能）以及把它应用在我的数据库。

它非常强大，你将拥有所有你在其他 ORMs 中拥有/看到的东西，比如（Doctrine, Hibernate）。

当使用 routing-controllers 和 TypeDI，它会为你注入实体管理器（就像你在我的 PlayerService 截图中看到的一样）提供非常有用的装饰器或者连接你的控制器和 services（这**非常**方便）。

这个 ORM 有一个涵盖了大量功能的官方文档，你可以看看并且从中了解所有你开始使用它需要了解的东西。

我通常把我的数据库配置放在 /config 文件夹，实体放在 /entities 文件夹。

* **为什么一篇文章涵盖了所有这些库？**

这正是有趣的部分。

Routing-controllers 就像是你应用的地基。它给你轻松连接那两个库的可能（涵盖在库文档中）。当然，如果你不想的话可以不用。它可以和任何 ORM 一同使用。

但是，当你使用全部这三个库时，你会让框架对比其他解决方案时显得太过强大（至少对我来说是这样）。你有控制器，参数注入，body 注入，参数验证，依赖注入，有了这些你可以忘掉手动提供依赖和定义类型，装饰属性的实体，查询 builder。这全都是靠 TypeScript！所以，后端也将有编译时类型检查！

* **是的，感谢涵盖了那些功能的库。但是再说一次，如何在 node 中使用 TypeScript？**

好吧，这再简单不过了。你可以像平时一样写 typescript，配置它编译到 ES2015（node 现在有很多特性，不用把它编译成 ES2015 之前的版本了），使用 CommonJS 标准来实现模块即可。

并且使用 pm2 或其他东西在编译后启动 index/server/app.js 。基本上生产代码已经就绪。不用 ts-node 或者其他什么了。

**如果你喜欢这些库，不要忘了表达你的喜爱**

如你所见，没有很多人知道 routing-controllers 和 TypeDI，这些是我 TypeScript Node.js 项目用到的最强大并且好用的库了。如果你喜欢它们，请花一秒钟 star 它们并且宣传一下。它们帮了我很多，所以我希望它们可以帮到你和其他同样的 TypeScript 使用者！

这些库也有 gitter 社区，你可以通过谷歌搜索“gitter 库名”很方便地找到它们。

感谢阅读并且快乐地使用 TypeScript。欢迎评论或提问吧~

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
