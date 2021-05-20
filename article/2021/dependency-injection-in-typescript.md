> * 原文地址：[Dependency Injection in TypeScript](https://levelup.gitconnected.com/dependency-injection-in-typescript-2f66912d143c)
> * 原文作者：[Mert Türkmenoğlu](https://medium.com/@mertturkmenoglu)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/dependency-injection-in-typescript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/dependency-injection-in-typescript.md)
> * 译者：
> * 校对者：

# Dependency Injection in TypeScript

![Photo by [Anthony DELANOIX](https://unsplash.com/@anthonydelanoix?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11174/0*EjOezZWFJ92qj8bt)

## Introduction

Every software program has fundamental building blocks. In Object-Oriented Programming, we use classes to build complex architectures. Like building a structure, we set up relations that are called **dependencies** between our blocks. Other classes support our class by offering to do complex operations on our behalf of us.

A class may have fields that refer to other ones. Then, we have to ask these questions: How are these references constructed? Should **we** assemble these objects, or should **others** be responsible for instantiating them? What if instantiating a class is **too complex**, and we want to avoid spaghetti code? All these questions compose the problem set the **Dependency Injection Principle** tries to solve.

Before we proceed to the examples, we have to understand a few concepts about dependency injection. The dependency injection principle tells us that a class should **receive** its dependencies rather than instantiating them. Delegating object initializations can reduce the stress of designing classes by taking care of complex operations. You carry away the complicated part from the code, and you re-introduce dependencies through other ways. How you do this **“carrying away”** and **“re-introducing them”** is the problem of managing dependencies. You can manually handle all of the initializations and injections, but this leads to intricate systems, which we try to avoid. Instead of this, you can transfer your construction responsibilities to an **IoC container**.

**Inversion of Control** is inverting the whole program flow so that a container manages all program dependencies. You create a container, and this container becomes responsible for constructing every object. When a class needs an object to instantiate, the IoC container serves required dependencies.

IoC **only** expresses a methodology, not a concrete implementation. For applying the dependency injection principle, you need a **DI framework**. A couple of examples are:

* **Spring** and **Dagger** for **Java**
* **Hilt** for **Kotlin**
* **Unity** for **C#**
* **Inversify**, **Nest.js**, and **TypeDI** for **TypeScript**

## Overview & Roles

![Dependency Injection Overview](https://cdn-images-1.medium.com/max/2000/1*Wk4iA2XNAOl4pAF5cYbU3w.png)

In the dependency injection principle, we need to understand **four** different types of **roles**:

* **Client**
* **Service**
* **Interface**
* **Injector**

**Services** are what we expose to out. These classes are instantiated and used by the IoC container. A **client** uses these services through the IoC container. A client shouldn’t be bothered with details, so **interfaces** ensure that the client and services live in harmony. A client asks dependencies, and an **injector** provides instantiated services.

## Types of Dependency Injection

When we talk about how we can manage to inject dependencies into a class, we can achieve this in **three different ways**:

* We can supply dependencies through **properties**(fields). Defining a property on the class and then injecting a concrete object into the property is called property injection. By exposing a property to the outside, you **violate** the **encapsulation** principle of OOP; because of this, you may want to avoid this type of injection.
* We can supply dependencies through **methods**. A **state** of the object **should be private**, and when an outsider wants to change that state, it should use the **getter/setter methods** of the class. So when you use a setter method to initialize a private field in the class, you use the **method injection**.
* We can supply dependencies through a **constructor**. Constructor methods are highly intertwined with object constructions because of their basic nature. We usually **favor** doing injections **through constructors** because of the similarity of our purpose and the constructor methods.

## Using TypeDI

Once we understand the underlying principles, what framework or library we use makes no difference. For this article, I chose TypeScript language and TypeDI library to demonstrate the fundamental concepts.

Initializing Yarn and adding TypeScript takes a little bit of effort. Because I don’t want to bore you with well-known project configs with no additional information, I will give you the starting code and go through it briefly. You can view and download the codes from [this GitHub repository](https://github.com/mertturkmenoglu/typescript-dependency-injection).

Any TypeScript project would be an example to demonstrate DI, but I chose a Node/Express app for this article. I assume people who work with TypeScript either directly work with Node/Express servers, or have an idea about them.

When you inspect `package.json` , you can see a couple of dependencies. Let me go through them briefly:

* **express**: Express is a popular framework for writing Node.js RESTful servers.
* **reflect-metadata**: A Polyfill library for Metadata Reflection API. This library allows other libraries to use metadata through decorators.
* **ts-node:** Node.js can’t run TypeScript files. Before you can run your code, you need to compile TypeScript into JavaScript. ts-node handles this process for you.
* **typedi:** TypeDI is a dependency injection library for TypeScript. We’ll see the use cases in a short time.
* **typescript:** We are using TypeScript for this project, so we need to add it as a dependency.
* **@types/express:** Type definitions for Express library.
* **@types/node**: Type definitions for Node.js.
* **ts-node-dev:** This library allows you to run TypeScript files and watch changes on certain files.

There are a few important compiler options you need to pay attention to. If you take a look at **tsconfig.json**, you can see the options for the compilation process:

* We specify types for **reflect-metadata** and **node**.
* We have to set **emitDecoratorMetadata** and **experimentalDecorators** flags to true.

All of our source code is inside the **src** folder. **src/index.ts** is our entry point. This file contains all the bootstrap steps of the server:

```TypeScript
import 'reflect-metadata';

import express from 'express';
import Container from 'typedi';
import UserController from './controllers/UserController';

const main = async () => {
  const app = express();

  const userController = Container.get(UserController);

  app.get('/users', (req, res) => userController.getAllUsers(req, res));

  app.listen(3000, () => {
    console.log('Server started');
  });
}

main().catch(err => {
  console.error(err);
});
```

This code is a minimal Express server that has only one endpoint. When you send a **GET** request to **/users** route, it will return a list of users. The crucial part of the **main** function is the “**Container.ge**t” method. Please pay attention that we didn’t use the new keyword or instantiate an object. We just asked for the IoC container to return us a UserController instance. Then we bind the route and the controller method.

Our application is a dummy RESTful server, but I didn’t want it to be completely meaningless. I add four different folders to represent foundational sections of a complete backend. These are **controllers**, **models**, **repositories**, and **services**. Now let’s go through each of them:

* **Controllers** folder contains our **REST controllers**. They are responsible for mediating communication between the user and the services. They receive requests and return responses.
* **Models** folder contains our **database entities**. We don’t have a database connection, nor we need them but establishing a proper project structure has a major impact on learning. Let’s assume they are real database entities and continue on our journey.
* **Services** folder contains our **services**. They are responsible for serving what REST controllers need by accessing different repositories.
* **Repositories** folder contains our **database access classes**. We are using the Data Mapper pattern to perform database operations. In this pattern, we use repository classes to access the database and make operations.

We don’t do everything in a single class. There are many layers between request and response. This is called **layered architecture**. By doing a work-sharing between classes we make it easier to do dependency injection.

```TypeScript
import { Request, Response } from "express";
import { Service } from "typedi";
import UserService from "../services/UserService";

@Service()
class UserController {
  constructor(private readonly userService: UserService) { }
  async getAllUsers(_req: Request, res: Response) {
    const result = await this.userService.getAllUsers();
    return res.json(result);
  }
}

export default UserController;
```

UserController has only one method. “getAllUsers” method is responsible for getting a result from user service and transmitting. We added a **Service** decorator to UserController class because we want this class to be managed by the IoC container. Inside the constructor method, we can see that this class needs a UserService instance. Again, we don’t have to control this dependency because the TypeDI container will create an instance for UserService, and when it generates the UserController instance, it will inject UserService.

```TypeScript
import { Service } from "typedi";
import User from "../models/User";
import UserRepository from "../repositories/UserRepository";

@Service()
class UserService {
  constructor(private readonly userRepository: UserRepository) { }
  async getAllUsers(): Promise<User[]> {
    const result = await this.userRepository.getAllUsers();
    return result;
  }
}

export default UserService;
```

UserService is very similar to UserController. We add a Service decorator to the class and we specify the dependencies we want inside the constructor method.

```TypeScript
import { Service } from "typedi";
import User from "../models/User";

@Service()
class UserRepository {
  private readonly users: User[] = [
    { name: 'Emily' },
    { name: 'John' },
    { name: 'Jane' },
  ];

  async getAllUsers(): Promise<User[]> {
    return this.users;
  }
}

export default UserRepository;
```

UserRepository is our final stop. We annotate this class with Service, but we don’t have any dependencies. Because we don’t have a database connection, I just added a hardcoded user list to class as private property.

## Conclusion

Dependency injection is a handy tool for managing complex object initializations. Doing manual dependency injection is better than nothing, but using TypeDI is much easier and more concise. When you start a new project, you should definitely check out the DI principle and give it a try.

You can find the codes in this article at [this GitHub repository](https://github.com/mertturkmenoglu/typescript-dependency-injection).

You can find me on [GitHub](https://github.com/mertturkmenoglu), [LinkedIn](https://www.linkedin.com/in/mert-turkmenoglu/), and [Twitter](https://twitter.com/capreaee).

Thank you for your time. Have a great day.

## References

* [1] [](https://www.tutorialsteacher.com/ioc/dependency-injection)[https://www.tutorialsteacher.com/ioc/dependency-injection](https://www.tutorialsteacher.com/ioc/dependency-injection)
* [2] [https://en.wikipedia.org/wiki/Dependency_injection](https://en.wikipedia.org/wiki/Dependency_injection)
* [3] [https://developer.android.com/training/dependency-injection](https://developer.android.com/training/dependency-injection)
* [4] [https://stackoverflow.com/questions/21288/which-net-dependency-injection-frameworks-are-worth-looking-into](https://stackoverflow.com/questions/21288/which-net-dependency-injection-frameworks-are-worth-looking-into)
* [5] [https://docs.typestack.community/typedi/v/develop/01-getting-started](https://docs.typestack.community/typedi/v/develop/01-getting-started)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
