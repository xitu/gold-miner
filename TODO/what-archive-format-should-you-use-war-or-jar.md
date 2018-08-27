
> * 原文地址：[What Archive Format Should You Use, WAR or JAR?](https://dzone.com/articles/what-archive-format-should-you-use-war-or-jar)
> * 原文作者：[Nicolas Frankel](https://dzone.com/users/293758/nfrankel.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/what-archive-format-should-you-use-war-or-jar.md](https://github.com/xitu/gold-miner/blob/master/TODO/what-archive-format-should-you-use-war-or-jar.md)
> * 译者：[windmxf](https://github.com/windmxf)
> * 校对者：[lsvih](https://github.com/lsvih), [LeviDing](https://github.com/leviding)

# WAR 还是 JAR，你应该用哪种格式打包？

以前，内存和磁盘都是稀缺资源。在那时，比较常见的方案是把不用的应用程序部署在同一个平台上。那是应用服务器的黄金时代。我早期写过一篇文章，说的是当前存储资源趋于廉价会使应用服务器在一段时间内过时。然而，有一种技术趋势让应用服务器重新回归主流。

在基础设施昂贵的情况下，拥有一台应用服务器是一件很棒的事情，通过应用程序共享可以大大降低成本。但缺点是，这种方法需要深入地了解每个共享相同资源的应用程序的负载情况，还需要资深的系统管理员来部署应用程序，他们需要保证程序在服务器的兼容性。然而对于老一辈人来说，难道仅仅因为某个应用程序的资源管理没做好，就只能让它单独运行吗？当基础设施成本降低时，每个服务器只部署一个应用程序的做法变得很普遍。那时，人们下一步考虑的是为什么仍然需要将应用程序服务器作为专用组件。看上去 Spring 团队也得到了相同的结论，因为 Spring Boot 应用的默认模式就是打包成一些可执行的 jar 包，我们称其为 Fat JARs。这些应用程序可以通过“java -jar fat.jar”的命令运行。因此有句名言：

“用 JAR 包，而不是 WAR 包” - Josh Long

我并不完全同意这个观点，我认为这个观点会让大多数团队失去应用服务器管理方面的专业知识。不过，一个支持 Fat JARs 的有力证据表明，自从使用 booting 技术管理应用程序，加载 java 类变得非常容易。例如，使用开发工具，Spring Boot 为两种类加载器（classloader）提供了同一种处理机制，一种类加载器对应类库，另一种对应 java 类，所以重新加载一个修改过的类是不需要重启整个 jvm — 这个简洁的技巧让代码的更新迭代变得快捷方便。

如果我们认为，应用服务器提供商仍在使用传统方式来处理任务的话，那就错了——多谢 Ivar Grimstad 让我想到
了这个问题（这是一个访谈的好理由，虽然你不一定对会议感兴趣）。Wildlfy、TomEE，以及其他应用服务器提供商都使用 Fat JARs 打包，但他们和我们有个很大的区别：他们不使用 Spring 之类的开发工具，所以每当修改代码都需要重启整个服务器。让代码快速生效的唯一方法就是在底层进行开发工作，例如为团队购买正版的 JRebel。然而，现在还有一个理由让我们选用 WAR 包，那就是使用 Docker。通过提供一个普通的应用服务器以及 Docker 映象作为基础映象，在上面加一个 WAR 包就能轻松得到 WAR 包镜像。目前 JAR 包（暂时）还不能通过这种方式实现。

请注意这里并不是在比较 Spring Boot 和 JavaEE，而是在比较 JAR 和 WAR，因为用 Spring Boot 可以完美地打出这两种类型的包。我前面提到现在还有一个问题，那就是当代码修改之后还是需要重启整个 JVM，而不能仅仅重载 java 类 — 但我相信这个问题迟早会解决。

选择用 WAR 包还是 JAR 包最终取决于公司的实际情况，看公司是更看中开发的快速反馈迭代，还是更看重 Docker 映像的优化与管理。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
