> * 原文地址：[Dependency Injection in TypeScript](https://levelup.gitconnected.com/dependency-injection-in-typescript-2f66912d143c)
> * 原文作者：[Mert Türkmenoğlu](https://medium.com/@mertturkmenoglu)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/dependency-injection-in-typescript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/dependency-injection-in-typescript.md)
> * 译者：[Usualminds](https://github.com/Usualminds)
> * 校对者：[Kim Yang](https://github.com/KimYangOfCat)、[PassionPenguin](https://github.com/PassionPenguin)

# TypeScript 中的依赖注入

![图源 [Anthony DELANOIX](https://unsplash.com/@anthonydelanoix?utm_source=medium&utm_medium=referral)，出自 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11174/0*EjOezZWFJ92qj8bt)

## 简介

每一个软件程序都有其最基础的构建模块。在面向对象的编程语言中， 我们使用类去构建复杂的体系架构。像建一幢大楼，我们把模块之间建立的联系称之为**依赖**。其他的类为了支持我们类的需求，提供复杂的封装操作。

一个类可能有引用其他类的字段。因此，我们不得不问及这些问题：这些引用是怎么被创建的？是**我们**去组合这些对象，还是**其他类**负责实例化它们？如果要实例化的类**太复杂**，并且我们想避免出现垃圾代码？所有这些问题都可以试图通过**依赖注入原则**来解决。

在开始示例之前，我们必须要去理解关于依赖注入的一些相关概念。依赖注入原则告诉我们，一个类应该去**接收**而非实例化它的依赖。通过委托方式来进行对象初始化，这可以处理较为复杂的操作，从而减少在类设计上的压力。你可以移除代码中复杂的模块，并通过其他方式重新引入依赖。如何处理**移除**和**重新引入依赖**，这是依赖管理的问题。你可以手动处理所有对象的初始化和注入，但是这将会使整个系统变得复杂，我们要尽量避免这种情况的发生。相反，你可以将构造的职责转移到 **IoC 容器**。

**控制反转**是通过反转整个程序的流程，以便容器对所有程序中涉及的依赖进行管理。你可以创建一个容器，整个容器负责构造对象。当一个类需要实例化对象时，IoC 容器可以提供它所需要的依赖。

IoC **只**提供了一种方法而非具体的实现。为了使用依赖注入原则，你需要一个**依赖注入框架**。举例如下：

* **Spring** 和 **Dagger**是 **Java** 的依赖注入框架
* **Hilt** 是 **Kotlin** 的依赖注入框架
* **Unity** 是 **C#** 的依赖注入框架
* **Inversify**、**Nest.js** 和 **TypeDI** 是 **TypeScript** 的依赖注入框架

## 概览和角色划分

![依赖注入概览](https://cdn-images-1.medium.com/max/2000/1*Wk4iA2XNAOl4pAF5cYbU3w.png)

在依赖注入原则中，我们需要理解**四**种不同的**角色**:

* **客户端**
* **服务端**
* **接口**
* **注入器**

**服务端**是我们对外暴露服务使用的。这些类由 IoC 容器实例化和使用。一个**客户端**通过 IoC 容器来使用这些服务。客户端不应该被具体细节所困扰，因此**接口**需要确保客户端和服务端保持协调。客户端请求所需的依赖，**注入器**提供实例化服务。

## 依赖注入的类型

当我们讨论如何在类中注入依赖时，可以通过**三种不同方式**来实现：

* 我们可以通过**属性**(字段)提供依赖关系。在类上定义属性，然后将具体的对象注入到该属性中，这就是属性注入。通过对外暴露这个属性，但这样做**违背**了面向对象程序设计的**封装**原则；因此，要尽量避免这种注入。
* 我们可以通过**方法**提供依赖关系。对象的**状态应该是私有的**，当外部想要改变该状态时，它应该调用类的 **getter/setter 方法**。所以当你使用 setter 方法初始化类中的私有字段时，你可以使用**方法注入**。
* 我们可以通过**构造函数**提供依赖关系。构造函数方法因为其基本属性和对象构造高度融合在一起。我们通常**支持通过构造函数**进行注入，因为我们的目标和构造函数的方法很类似。

## 使用 TypeDI 库

一旦我们理解了依赖注入的基本原理，使用什么框架或者库差别并不大。这篇文章里，我选择了 TypeScript 语言和 TypeDI 库来展示这些基本概念。

初始化 Yarn 和添加 TypeScript 会花点时间。我不想使用有名气但没有足够注释的项目配置，因为这会让你感到无趣。所以我将给出初步的代码并做简要介绍。你可以从[这个 Github 仓库](https://github.com/mertturkmenoglu/typescript-dependency-injection)查看和下载代码。

任何 TypeScript 项目都可以作为依赖注入演示的例子。但这篇文章里我选择了一个 Node/Express 应用作为示例。我假设使用 TypeScript 的开发者要么直接使用 Node/Express 服务器，要么对它们有所了解。

当你查看 `package.json` 文件时，你可以看到这些依赖项配置，让我简要介绍下它们：

* **express**：Express 是编写 Node.js RESTful 服务的流行框架。
* **reflect-metadata**：一个用于元数据反射 API 的库。它允许其他库通过装饰器使用元数据。
* **ts-node**：Node.js 无法运行 TypeScript 文件。在代码运行前，需要将 TypeScript 编译为 JavaScript。ts-node 帮你处理了这个过程。
* **typedi**：TypeDI 是一个 TypeScript 依赖注入库。我们很快会看到它的示例。
* **typescript**：我们在这个项目中使用了 TypeScript，因此需要将它也作为一个依赖。
* **@types/express**：Express 库的类型定义。
* **@types/node**：Node.js 的类型定义。
* **ts-node-dev**：这个库允许你运行 TypeScript，并观察某些文件的变化情况。

你需要留意一些重要的编译器选项配置。如果你看下 **tsconfig.json**，你可以看到编译过程的配置选项：

* 我们为 **reflect-metadata** 和 **node** 指定了类型。
* 我们必须将 **mitDecoratorMetadata** 和 **experimentalDecorators** 设置为 true。

所有的源码都在 **src** 文件夹下。**src/index.ts** 是我们项目的入口文件。这个文件包含了服务器的所有引导步骤：

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

这段代码是一个只有一个端口的小型 Express 服务器。当你向 **/users** 路由发送一个 **GET** 请求时，它会返回一个用户列表。**main** 函数的核心是 **Container.get** 方法。注意我们并没有使用 new 关键字或者实例化对象。我们只是调用 IoC 容器返回的一个 UserController 实例方法。然后绑定了路由和控制器方法。

我们的应用程序是一个虚拟的 RESTful 服务器，但我不想让它没有一点意义。我添加了四个不同的文件夹代表一个完备后端服务的基本部分。它们是 **controllers**、**models**、**repositories** 和 **services**。现在让我一个个介绍下它们：

* **Controllers** 文件夹包含我们的 **REST 控制器**。它们负责协调客户端和服务器之间的通信。它们接收请求并返回响应。
* **Models** 文件夹包含我们的**数据库实体类**。我们没有数据库连接，也不需要，但建立一个合适的项目结构对于学习该项目有很大的帮助。我们假设它是真是的数据库实体并继续我们的项目。
* **Services** 文件夹包含我们的**服务**。它们通过访问不同的存储库，负责为 REST 控制器提供所需服务。
* **Repositories** 文件夹包含我们**数据库连接类**。我们使用 Data Mapper 模式来执行数据库操作。该模式中我们使用实体类来访问数据库并进行相关操作。

我们不会把所有的东西都放到一个类中。请求和响应之间还有很多层级。这就是所谓的**分层架构**。通过类之间的依赖共享，我们可以更容易地进行依赖注入。

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

UserController 只有一个方法。`getAllUsers` 方法负责从用户服务中获取结果并进行传输。我们给 UserController 添加类一个 **Service** 装饰器，因为我们希望这个类由 IoC 容器进行管理。在构造函数方法内部，我们可以看到这个类需要一个 UserService 实例。同样，我们不需要控制这个依赖关系。因为 TypeDI 容器为 UserService 创建了一个实例，当它生成 UserController 实例时，它将注入到  UserService 中。

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

UserService 和 UserController 很类似。我们向类添加一个 Service 装饰器，并在构造函数方法中指定它们想要的依赖项。

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

UserRepository 是我们的最后一步。我们用 Service 来注解这个类，但是我们没有任何依赖关系。因为没有数据库连接，所以我只是将已硬编码过的用户列表作为私有属性添加到类中。

## 结论

依赖注入是管理复杂对象初始化的有力工具。手动进行依赖注入总比什么都不做要好，但是使用 TypeDI 更简单可行。当你要开始做一个新项目时，你应该明确地考虑下依赖注入原则并给予适当尝试。

你可以在[这个 GitHub 分支](https://github.com/mertturkmenoglu/typescript-dependency-injection)找到本文的代码。

你可以在 [GitHub](https://github.com/mertturkmenoglu)、[LinkedIn](https://www.linkedin.com/in/mert-turkmenoglu/) 和 [Twitter](https://twitter.com/capreaee) 找到我。

感谢阅读，祝你快乐。

## 引用

* [1] [https://www.tutorialsteacher.com/ioc/dependency-injection](https://www.tutorialsteacher.com/ioc/dependency-injection)
* [2] [https://en.wikipedia.org/wiki/Dependency_injection](https://en.wikipedia.org/wiki/Dependency_injection)
* [3] [https://developer.android.com/training/dependency-injection](https://developer.android.com/training/dependency-injection)
* [4] [https://stackoverflow.com/questions/21288/which-net-dependency-injection-frameworks-are-worth-looking-into](https://stackoverflow.com/questions/21288/which-net-dependency-injection-frameworks-are-worth-looking-into)
* [5] [https://docs.typestack.community/typedi/v/develop/01-getting-started](https://docs.typestack.community/typedi/v/develop/01-getting-started)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
