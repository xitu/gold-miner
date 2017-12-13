> * 原文地址：[How to start with backend TypeScript and use it’s full potential.](https://medium.com/@igorandreev/how-to-start-with-backend-typescript-and-use-its-full-potential-5114e52012b)
> * 原文作者：[idchlife](https://medium.com/@igorandreev?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-start-with-backend-typescript-and-use-its-full-potential.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-start-with-backend-typescript-and-use-its-full-potential.md)
> * 译者：xilihuasi[https://github.com/xilihuasi]
> * 校对者：

# How to start with backend TypeScript and use it’s full potential.
# 如何用 TypeScript 玩转后端？

I will describe several dealbreaker libraries from one developer. They can give you most of the features you will want from your backend application. Power of decorators and metadata is shining through these libraries, making them very powerful and easy to use.

我将从一个开发者的角度介绍几个优秀的库。它们可以满足你后端应用的绝大部分特性。装饰器和元数据的能力在这些库中得到的充分的应用，使其非常强大并且简单易用。

I hope this article will help people like me, who like TypeScript and want to write backend code in it with such ease like I’m doing it after discovering all of these libraries.

我希望这篇文章可以帮到像我这样，喜欢 TypeScript 而且想用它编写后端代码的人，让他们像我一样发现这些库之后乐在其中。

**TL;DR - stack making your backend app as powerful as many enterprise static typed solutions in other languages:**

**TL;DR —— 堆栈使你的后端应用像许多使用其他语言的企业静态解决方案一样强大：**

* library for routing and controllers with decorators, parameters, body injection
* library for dependency injection and your services with decorators
* ORM with decorators for convenient work with entities like it’s Doctrine/Hibernate
* Small tip for writing backend TypeScript for those who are not yet familiar with it

* 使用装饰器，参数，body 注入的路由和控制器的库
* 依赖注入和使用装饰器的 services 的库
* 使用装饰器的 ORM 就像 Doctrine/Hibernate 那样方便操作实体
* 对那些还不熟悉使用 TyepScript 写后端的朋友的小建议

**Routing-controllers: controllers, actions, requests, etc**

**Routing-controllers：控制器，行为，请求等**

[**pleerock/routing-controllers**
_routing-controllers - Create structured, declarative and beautifully organized class-based controllers with heavy…_github.com](https://github.com/pleerock/routing-controllers)

Despite this library was built as TypeScript helper for Express/Koa, this it will help you write your controllers like you are using some kind of enterprise framework in Java/PHP/C#

尽管这个库是作为 Express/Koa 的 TypeScript helper 编写的，它也会对你编写控制器有所帮助，就像你在使用 Java/PHP/C# 的企业级框架里用到的那样。

Here is small example of controller:

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

For some people it will be like waking up from a nightmare: no more modules with routes, filled with middleware on middleware on middleware and also middleware for injecting, validating and required parameters (yes, you can even define that parameter can be validated for type and required! like @Body({ required: true, validate: true }) and you’re good to go, it will drop badrequest bomb if something is missing/not right in request)

对于一些人来说这简直摆脱了噩梦：再也没有带路由的组件，充满中间件中的中间件中的中间件以及注入，验证和请求参数的中间层（是的，你甚至可以定义参数类型和是否必传！如 @Body({ required: true, validate: true }) 这种写法就可以实现，这样以来缺少参数或者不正确的异常请求就会被抛弃）

Many useful features in decorators, like @Controller for your basic controllers, where in actions you will define what type of content it serves etc and @JsonController for serving and accepting json.

装饰器有很多有用的特性，如基础控制器的 @Controller，定义 actions 用于什么类型的内容等以及使用 @JsonController 服务和接收 json。

I’m using it with Express, and since we have async/await (I don’t stop praising it even after several months of development TS nodejs) we might not need to use Koa (routing-controllers support for express is slightly better now). And Express has bigger set of types at @types

我正在 Express 中使用它，既然我们有了 async/await （即使 TS nodejs 开发已经过了好几个月我还是忍不住赞美）我们似乎不再需要 Koa 了（现在 routing-controllers 可以更好的支持 express ）。而且 Express 有更大的类型集 @types。

Here is example from my project, using routing-controllers and other @pleerock libraries (VSCode, if someone interested, references are from TypeLens plugin):

下面是我项目中使用 routing-controllers 和其他 @pleerock 库（VSCode, 如果有兴趣的话，引用来自 TypeLens 插件）的例子：

![](https://cdn-images-1.medium.com/max/800/1*DdYJb1pIl3JYBfoCQPvSRw.png)

As you can see, routing-controllers provide even undefined result code (there are also decorators for empty and null) and many other features. About this.playerService — it’s another fascinating library, which I will describe next.

如你所见，routing-controllers 甚至提供了 undefined 返回码（也有 empty 和 null 的装饰器）以及许多其他特性。关于 this.playerService —— 这是另一个迷人的库，稍后我将介绍它。

Overall, library has powerful documentation, it will help you understand and build your application with custom middlewares that apply to action or even whole controller (that was whoa cool moment for me). Url inheritance as you can see also there. Very convenient.

总体来看，库有强大的文档，可以帮助你理解和使用自定义应用在 action 或者整个控制器的中间件构建你的应用（这对我来说是个绝妙的时刻）。链接地址如你所见就在那，非常方便。

Of course, you can pump your app with many express/koa middlewares out there, also configuration for views (library also has special decorator for view), authentication (which can be applied via middleware to the whole controller!), error handling etc.

当然，你也可以使用很多 express/koa 中间件把你的应用抽离出来，以及视图配置（库也有针对试图的装饰器），认证（可以通过中间件应用到整个控制层），错误处理等。

Usually I store them in /controllers folder

通常我把他们存在 /controllers 文件夹。

**TypeDI: dependency injection, services**

**TypeDI：依赖注入，services**

[https://github.com/pleerock/typedi](https://github.com/pleerock/typedi)

This one gave my project structure and easement to code and not think “well where to store service, is this even service? hmm maybe another, but… how it will depend on to another? how one service will be using another hm..”

这个库帮我定好了项目结构，方便编码并且不用去想“好吧 service 存在哪里，这个是 service ？唔或许是另一个，但是。。。它怎么依赖另一个 service ？怎么引用其他 service 唔。。。”

Returning to my PlayerService, here part of it for you to observer what it has as dependencies (which are another services):

回到我的 PlayerService，下面这部分你可以看到它依赖了什么（其他 services）：

![](https://cdn-images-1.medium.com/max/800/1*lpTGJEYWTCr18jjm8uAnbg.png)

@Inject is one of the most useful decorators I discovered for myself in terms of working with services and serious logic-full backend application.

@Inject 对我来说是在处理 services 和逻辑完整的后端应用方面最好用的装饰器。

(if you are wondering about @OrmEntityManager — it’s from another @pleerock library, which will be described later)

（如果你想了解 @OrmEntityManager —— 另一个来自 @pleerock 的库，稍后我将讲解）

Yes, you can have many services that depend on another services. And even if you have circular service dependency, you can overcome this issue by defining type explicitly (library documentation covers most of issues and cases)

是的，你可以有很多依赖其他 services 的 services。并且如果你有 service 循环依赖，你可以通过明确地定义类型来解决这个问题（库的文档涵盖了大部分的问题和情景）

For those who is not familiar with services, service container, dependency injection in services etc. Short info:

对那些不熟悉 services，service 容器，services 依赖注入等的朋友。简要说明：

You have functionality of some sort, and you want it to be stored in class, and you want one instance of this class and also you want this class to be dependent on another, another etc. Dependency Injection with service container got you covered. You will get services from Container and it will handle all the dependencies of services by itself, giving you your working instance with all other instances injected automatically.

你有某种功能，想把它存在类中，然后你想要类的实例并且想让这个类依赖另一个，另一个等。service 容器的依赖注入可以为你保驾护航。你可以从容器中获取 services 并且他会自己处理 services 的所有依赖，给你带有其他实例的工作实例自动注入。

My description of this library doesn’t cover its full potential (you can check it’s documentation and see for yourself — there is much more to work with): you can define services with names, you can define constructor injection etc.

我关于这个库的描述并不涵盖所有潜能（你可以自己查看它的文档——有更多的特性可以使用）：你可以在定义 services 时给它命名，还可以定义构造器注入等。

Usually I store my services under /services folder.

通常我把我的 services 存在 /services 文件夹。

**TypeORM: very easy to use ORM for defining entities with relations, different column types and different data storing solutions (relation, non-relation)**

**TypeORM：使用 ORM 定义关系型实体,不同列类型和不同数据存储方案非常方便（关系型，非关系型）**

[**typeorm/typeorm**
_typeorm - Data-Mapper ORM for TypeScript and JavaScript (ES7, ES6, ES5). Supports MySQL, PostgreSQL, MariaDB, SQLite…_github.com](https://github.com/typeorm/typeorm)

This one here is what gave me feeling that TypeScript with nodejs can finally compete with other languages and ORMs out there.

这给我的感觉就是，用 TypeScript 写 nodejs 最终有能力跟其他语言和 ORMS 竞争。

Powerful ORM, which can be used to write your entities very easy and in understandable way. I’m not fan of many other nodejs ORMs out there like:

强大的 ORM 可以让你很方便地用一种可理解的方式编写实体。我不是其他许多类似这种 nodejs ORMS 的粉丝：

```
module.exports = { id: SomeORM.Integer, name: SomeOrm.String({ …})}
```

I always wanted entity to be class. And class with typed properties, which will be discovered by ORM with simple decorator. Even without type.

我总是想让实体写成类。被赋予类型的属性的类，会被带有简单装饰器的 ORM 发现。甚至是没有类型的。

TypeORM gives you this. Another example from my project:

TypeORM 给你这种能力。我项目中的另一个例子：

![](https://cdn-images-1.medium.com/max/800/1*VJEWGi8ycPxqaLNzjev7nA.png)

As you can see, I’m not even writing what type of property is in decorator (you can do this, don’t worry, for explicitly defining type, default, nullable etc)! TypeORM doing all the work for me here, learning what type (thanks to TypeScript reflect:metadata extended functionality) and applying it to my database.

如你所见，我甚至没在装饰器中写属性的类型（你可以这样做，不要担心，明确地定义类型，默认的，可空的等）！TypeORM 为我做了所有这些工作，了解什么类型（感谢 TypeScript 反射：元数据扩展功能）以及把它应用在我的数据库。

It is very powerful, you will have all the neat stuff which you had/saw in another ORMs like this one (doctrine, hibernate).

它非常强大，你将拥有所有你在其他 ORMs 中拥有/看到的东西，比如（doctrine, hibernate）。

When used with routing-controllers and typedi it provides useful decorators to inject EntityManager (as you saw in screenshot of my PlayerService) or even Connection into your controllers, services (it’s **very** handy)

当使用 routing-controllers 和 typedi，它会为你注入实体管理器（就像你在我的 PlayerService 截图中看到的一样）提供非常有用的装饰器或者连接你的控制器和 services（这**非常**方便）。

There is official documentation that covers huge functionality of this ORM, you can read it and learn all the things you need to start using it.

这个 ORM 有一个涵盖了大量功能的官方文档，你可以看看并且从中了解所有你开始使用它需要了解的东西。

I usually store my db config in /config folder and entities in /entities folder

我通常把我的数据库配置放在 /config 文件夹，实体放在 /entities 文件夹。

* **Why one article for all of these libraries?**

* **为什么一篇文章涵盖了所有这些库？**

That’s the interesting part.

这正是有趣的部分。

Routing-controllers is like your application foundation. It gives you possibility to attach those 2 libraries with ease (covered in library documentation). You may not if you don’t want to, of course. It can work with any ORM out there.

Routing-controllers 就像是你应用的地基。它给你轻松连接那两个库的可能（涵盖在库文档中）。当然，如果你不想的话可以不用。它可以和任何 ORM 一同使用。

But, when using all three of these libraries you are getting framework which is way too powerful (at least it is for me) when comparing to other solutions out there. You have controllers, parameters injection, body injection, parameter validation, dependency injection with which you can forget about manually providing dependencies and defining their type) entities with decorated properties, query builder. And it is all with TypeScript! So yay, compile-time backend types check!

但是，当你使用全部这三个库时，你会让框架对比其他解决方案时显得太过强大（至少对我来说是这样）。你有控制器，参数注入，body 注入，参数验证，依赖注入，有了这些你可以忘掉手动提供依赖和定义类型，装饰属性的实体，查询 builder。这全都是靠 TypeScript。所以，编译时后端类型检查同理！

* **Yeah thank you for covering those libraries but say again, how to write TypeScript for node?…**

* **是的感谢涵盖了那些库但是再说一次，如何在 node 中使用 TypeScript？。。。**

Well it’s simple as it can get. You write typescript like usually, making target es2015 (node has many features now, no need to transpile it to something more than es2015), module commonjs.

好吧，这再简单不过了。你可以像平时一样写 typescript ，使用 es2015 （node 现在有很多特性，不用把它编译成高于 es2015 版本），commonjs 实现模块。『麻烦校对者对这段翻译提下建议』

And you use pm2 or something to start your index/server/app.js after compilation. Basically production code is ready. No need for ts-node or something.

并且使用 pm2 或其他东西在编译后启动 index/server/app.js 。基本上生产代码已经就绪。不用 ts-node 或者其他什么。

**Don’t forget to show some love if you liked those libraries!**

**如果你喜欢这些库，不要忘了表达你的喜爱**

As you can see, not many people know about routing-controllers and typedi and these are one of the most useful and powerful libraries I used for TypeScript nodejs projects. If you like them, please spend a second to star them and spread the word. They helped me a lot and I hope they will help you and other fellow TypeScript-ers out there!

如你所见，没有很多人知道 routing-controllers 和 typedi，这些是我 TypeScript nodejs 项目用到的最强大并且好用的库了。如果你喜欢它们，请花一秒钟 star 它们并且宣传一下。它们帮了我很多，所以我希望它们可以帮到你和其他同样的 TypeScript 使用者！

There are also gitter channels for libraries, you can find them easily by googling “gitter library-name”.

这些库也有 gitter 栏目，你可以通过谷歌搜索“gitter 库名”很方便地找到它们。

Thank you for reading and happy TypeScript-ing. Feel free to comment and ask questions!

感谢阅读并且快乐使用 TypeScript。快来评论或提问吧！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
