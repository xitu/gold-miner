> * 原文地址：[How to start with backend TypeScript and use it’s full potential.](https://medium.com/@igorandreev/how-to-start-with-backend-typescript-and-use-its-full-potential-5114e52012b)
> * 原文作者：[idchlife](https://medium.com/@igorandreev?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-start-with-backend-typescript-and-use-its-full-potential.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-start-with-backend-typescript-and-use-its-full-potential.md)
> * 译者：
> * 校对者：

# How to start with backend TypeScript and use it’s full potential.

I will describe several dealbreaker libraries from one developer. They can give you most of the features you will want from your backend application. Power of decorators and metadata is shining through these libraries, making them very powerful and easy to use.

I hope this article will help people like me, who like TypeScript and want to write backend code in it with such ease like I’m doing it after discovering all of these libraries.

**TL;DR - stack making your backend app as powerful as many enterprise static typed solutions in other languages:**

* library for routing and controllers with decorators, parameters, body injection
* library for dependency injection and your services with decorators
* ORM with decorators for convenient work with entities like it’s Doctrine/Hibernate
* Small tip for writing backend TypeScript for those who are not yet familiar with it

**Routing-controllers: controllers, actions, requests, etc**

[**pleerock/routing-controllers**
_routing-controllers - Create structured, declarative and beautifully organized class-based controllers with heavy…_github.com](https://github.com/pleerock/routing-controllers)

Despite this library was built as TypeScript helper for Express/Koa, this it will help you write your controllers like you are using some kind of enterprise framework in Java/PHP/C#

Here is small example of controller:

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

Many useful features in decorators, like @Controller for your basic controllers, where in actions you will define what type of content it serves etc and @JsonController for serving and accepting json.

I’m using it with Express, and since we have async/await (I don’t stop praising it even after several months of development TS nodejs) we might not need to use Koa (routing-controllers support for express is slightly better now). And Express has bigger set of types at @types

Here is example from my project, using routing-controllers and other @pleerock libraries (VSCode, if someone interested, references are from TypeLens plugin):

![](https://cdn-images-1.medium.com/max/800/1*DdYJb1pIl3JYBfoCQPvSRw.png)

As you can see, routing-controllers provide even undefined result code (there are also decorators for empty and null) and many other features. About this.playerService — it’s another fascinating library, which I will describe next.

Overall, library has powerful documentation, it will help you understand and build your application with custom middlewares that apply to action or even whole controller (that was whoa cool moment for me). Url inheritance as you can see also there. Very convenient.

Of course, you can pump your app with many express/koa middlewares out there, also configuration for views (library also has special decorator for view), authentication (which can be applied via middleware to the whole controller!), error handling etc.

Usually I store them in /controllers folder

**TypeDI: dependency injection, services**

[https://github.com/pleerock/typedi](https://github.com/pleerock/typedi)

This one gave my project structure and easement to code and not think “well where to store service, is this even service? hmm maybe another, but… how it will depend on to another? how one service will be using another hm..”

Returning to my PlayerService, here part of it for you to observer what it has as dependencies (which are another services):

![](https://cdn-images-1.medium.com/max/800/1*lpTGJEYWTCr18jjm8uAnbg.png)

@Inject is one of the most useful decorators I discovered for myself in terms of working with services and serious logic-full backend application.

(if you are wondering about @OrmEntityManager — it’s from another @pleerock library, which will be described later)

Yes, you can have many services that depend on another services. And even if you have circular service dependency, you can overcome this issue by defining type explicitly (library documentation covers most of issues and cases)

For those who is not familiar with services, service container, dependency injection in services etc. Short info:

You have functionality of some sort, and you want it to be stored in class, and you want one instance of this class and also you want this class to be dependent on another, another etc. Dependency Injection with service container got you covered. You will get services from Container and it will handle all the dependencies of services by itself, giving you your working instance with all other instances injected automatically.

My description of this library doesn’t cover its full potential (you can check it’s documentation and see for yourself — there is much more to work with): you can define services with names, you can define constructor injection etc.

Usually I store my services under /services folder.

**TypeORM: very easy to use ORM for defining entities with relations, different column types and different data storing solutions (relation, non-relation)**

[**typeorm/typeorm**
_typeorm - Data-Mapper ORM for TypeScript and JavaScript (ES7, ES6, ES5). Supports MySQL, PostgreSQL, MariaDB, SQLite…_github.com](https://github.com/typeorm/typeorm)

This one here is what gave me feeling that TypeScript with nodejs can finally compete with other languages and ORMs out there.

Powerful ORM, which can be used to write your entities very easy and in understandable way. I’m not fan of many other nodejs ORMs out there like:

```
module.exports = { id: SomeORM.Integer, name: SomeOrm.String({ …})}
```

I always wanted entity to be class. And class with typed properties, which will be discovered by ORM with simple decorator. Even without type.

TypeORM gives you this. Another example from my project:

![](https://cdn-images-1.medium.com/max/800/1*VJEWGi8ycPxqaLNzjev7nA.png)

As you can see, I’m not even writing what type of property is in decorator (you can do this, don’t worry, for explicitly defining type, default, nullable etc)! TypeORM doing all the work for me here, learning what type (thanks to TypeScript reflect:metadata extended functionality) and applying it to my database.

It is very powerful, you will have all the neat stuff which you had/saw in another ORMs like this one (doctrine, hibernate).

When used with routing-controllers and typedi it provides useful decorators to inject EntityManager (as you saw in screenshot of my PlayerService) or even Connection into your controllers, services (it’s **very** handy)

There is official documentation that covers huge functionality of this ORM, you can read it and learn all the things you need to start using it.

I usually store my db config in /config folder and entities in /entities folder

* **Why one article for all of these libraries?**

That’s the interesting part.

Routing-controllers is like your application foundation. It gives you possibility to attach those 2 libraries with ease (covered in library documentation). You may not if you don’t want to, of course. It can work with any ORM out there.

But, when using all three of these libraries you are getting framework which is way too powerful (at least it is for me) when comparing to other solutions out there. You have controllers, parameters injection, body injection, parameter validation, dependency injection with which you can forget about manually providing dependencies and defining their type) entities with decorated properties, query builder. And it is all with TypeScript! So yay, compile-time backend types check!

* **Yeah thank you for covering those libraries but say again, how to write TypeScript for node?…**

Well it’s simple as it can get. You write typescript like usually, making target es2015 (node has many features now, no need to transpile it to something more than es2015), module commonjs.

And you use pm2 or something to start your index/server/app.js after compilation. Basically production code is ready. No need for ts-node or something.

**Don’t forget to show some love if you liked those libraries!**

As you can see, not many people know about routing-controllers and typedi and these are one of the most useful and powerful libraries I used for TypeScript nodejs projects. If you like them, please spend a second to star them and spread the word. They helped me a lot and I hope they will help you and other fellow TypeScript-ers out there!

There are also gitter channels for libraries, you can find them easily by googling “gitter library-name”.

Thank you for reading and happy TypeScript-ing. Feel free to comment and ask questions!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
