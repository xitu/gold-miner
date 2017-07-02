
> * 原文地址：[What Archive Format Should You Use, WAR or JAR?](https://dzone.com/articles/what-archive-format-should-you-use-war-or-jar)
> * 原文作者：[Nicolas Frankel](https://dzone.com/users/293758/nfrankel.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/what-archive-format-should-you-use-war-or-jar.md](https://github.com/xitu/gold-miner/blob/master/TODO/what-archive-format-should-you-use-war-or-jar.md)
> * 译者：
> * 校对者：

# What Archive Format Should You Use, WAR or JAR?
# WAR 还是 JAR，你应该用哪种格式打包？

Some time ago, RAM and disk space were scarce resources. At that time, the widespread strategy was to host different applications onto the same platform. That was the golden age of the application server. I wrote in an earlier post on how the current tendency toward cheaper resources will make the application server obsolete, in the short or long term. However, a technology trend might bring it back in favor.
以前，内存和磁盘都是稀有资源。在那时，比较常见的方案是把不用的应用程序部署在同一个平台上。那是应用服务器的黄金时代。我早期写过一批文章，说的是当前存储资源趋于廉价会使应用服务器在一段时间内过时。然而，有一种技术趋势让应用服务器重新回到舞台。

Having an application server is good when infrastructure resources are expensive, and sharing them across apps brings a significant cost decrease. On the downside, it requires a deep insight into the load of each application sharing the same resources, as well as skilled sysadmins that can deploy applications that are compatible on the same app server. For old-timers, does requiring an application to be run alone because it mismanages resources ring a bell? When infrastructure costs decrease, laziness and aversion to risk take precedence and hosting a single app on an application server becomes the norm. At that point, the next logical step is to consider why application servers as dedicated components are still required. It seems the Spring guys came to the same conclusion, for Spring Boot applications' default mode is to package executable JARs - also known as Fat JARs. Those apps can be run as java -jar fat.jar. Hence the famous:
在基础设施昂贵的情况下，拥有一台应用服务器是不错的，而且通过应用程序共享，可以大大降低成本。但缺点是，需要有能力深入地了解每个应用程序的共享是如何负载的，也需要资深的系统管理员来部署应用程序，他们需要保证程序在服务器的兼容性。对于老一辈人来说，难道因为不善于管理服务器，就只能给需要独立部署的应用程序按个铃？当基础设施成本降低时，每个服务器只部署一个应用程序变得很普遍。那时，人们下一步考虑的是为什么仍然需要将应用程序服务器作为专用组件。看上去Spring团队也有相同的结论，因为Spring Boot 应用的默认模式是打包成一些可执行的jar包，我们知道这叫Fat JARs。那些应用程序可以通过“java -jar fat.jar”的命令运行。因此有句名言：

'Make JAR, not WAR.' — Josh Long
“用JAR包，而不是WAR包” - Josh Long

I’m still not completely sold on that, as I believe it too easily discards the expertise of most Ops teams regarding an application servers' management. However, one compelling argument about Fat JARs is that since the booting technology is in charge of app management from the start, it can handle load classes in any way it wants. For example, with Dev Tools, Spring Boot provides a mechanism based on two classloaders, one for libraries and one for classes, so that classes can be changed and reloaded without restarting the whole JVM - a neat trick that gives a very fast feedback loop at each code change.
我仍然不是完成同意这个观点，我认为这个观点会让大多数团队失去应用服务器管理方面的专业知识。然而，关于Fat JARs的一个有力证据表明，自从booting技术负责应用程序管理开始，加载java类变得非常容易。例如，使用开发工具，Spring Boot 为两种类加载器提供了同一种处理机制，一种类加载器对应类库，另一种对应java类，所以重新加载一个修改过的类是不需要重启整个jvm的-这是一个非常简洁的技巧，因为每次代码变化服务器都很快就能生效。

It wrongly thought that application server providers were still stuck in the legacy way of doing things - thanks to Ivar Grimstad for making me aware of this option (a good reason to visit talks that do not necessarily target your interest at conferences). Wildlfy, TomEE, and other app server implementers can be configured to package Fat JARs as well, albeit with one huge difference: there’s nothing like Spring Dev Tools, so the restart of the whole app server is still required when code changes. The only alternative for faster feedback regarding those changes is to work at a lower level, e.g. JRebel licenses for the whole team. However, there’s still one reason to use WAR archives, and that reason is Docker. By providing a common app server, and Docker image as a base image, one just needs to add one’s WAR on top of it, thus making the WAR image quite lightweight. And this cannot be achieved (yet?) with the JAR approach.
如果我们还认为应用服务器提供商在用传统方式处理事务仍然会很卡，那就错了-辛亏Ivar Grimstad让我想到这个问题（一个访谈的好理由，虽然你不一定对会议感兴趣）。Wildlfy, TomEE,以及其他应用服务器实施者都使用Fat JARs打包，但一个大的差别：他们不用类似Sping的开发工具，所以当代码修改时，还是需要重启整个服务器的。对于低层次工作来说要修改代码快速生效，这个唯一的选择，就想这个团队的JRebel许可证一样。然而，还有一个理由让我们用WAR包，这个理由就是使用Docker。通过提供一个普通应用服务器，Docker镜像作为一个基础镜像，只需要在上面加一个WAR包就行了，这样制作WAR包的镜像是非常简单的。这种方式JAR包是无法实现的。（现在还不行吧？）

Note that it’s not Spring Boot vs JavaEE, but mostly JAR vs WAR, as Spring Boot is perfectly able to package either format. As I pointed out above, the only missing piece is for the later to reload classes instead of restarting the whole JVM when a change occurs - but I believe it will happen at some point.
请注意这里并不是比较Spring Boot和JavaEE，而是比较JAR和WAR,因为用Spring Boot两种包都可以完美地打出来。正如我上面指出的，现在还有一个问题，那就是当代码修改了，还是要重启整个JVM，而不是仅仅重载java类-但我相信这个问题迟早会解决的。

Choosing between the WAR and the JAR approaches is highly dependent on whether the company values more fast feedback cycles during development or more optimized and manageable Docker images.
选择用WAR包还是JAR包的方式还是取决于公司的实际情况，看公司是更看中代码的快速生效还是Docker镜像的优化管理。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
