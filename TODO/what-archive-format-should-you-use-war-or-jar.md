
> * 原文地址：[What Archive Format Should You Use, WAR or JAR?](https://dzone.com/articles/what-archive-format-should-you-use-war-or-jar)
> * 原文作者：[Nicolas Frankel](https://dzone.com/users/293758/nfrankel.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/what-archive-format-should-you-use-war-or-jar.md](https://github.com/xitu/gold-miner/blob/master/TODO/what-archive-format-should-you-use-war-or-jar.md)
> * 译者：
> * 校对者：

# What Archive Format Should You Use, WAR or JAR?

Some time ago, RAM and disk space were scarce resources. At that time, the widespread strategy was to host different applications onto the same platform. That was the golden age of the application server. I wrote in an earlier post on how the current tendency toward cheaper resources will make the application server obsolete, in the short or long term. However, a technology trend might bring it back in favor.

Having an application server is good when infrastructure resources are expensive, and sharing them across apps brings a significant cost decrease. On the downside, it requires a deep insight into the load of each application sharing the same resources, as well as skilled sysadmins that can deploy applications that are compatible on the same app server. For old-timers, does requiring an application to be run alone because it mismanages resources ring a bell? When infrastructure costs decrease, laziness and aversion to risk take precedence and hosting a single app on an application server becomes the norm. At that point, the next logical step is to consider why application servers as dedicated components are still required. It seems the Spring guys came to the same conclusion, for Spring Boot applications' default mode is to package executable JARs - also known as Fat JARs. Those apps can be run as java -jar fat.jar. Hence the famous:

'Make JAR, not WAR.' — Josh Long

I’m still not completely sold on that, as I believe it too easily discards the expertise of most Ops teams regarding an application servers' management. However, one compelling argument about Fat JARs is that since the booting technology is in charge of app management from the start, it can handle load classes in any way it wants. For example, with Dev Tools, Spring Boot provides a mechanism based on two classloaders, one for libraries and one for classes, so that classes can be changed and reloaded without restarting the whole JVM - a neat trick that gives a very fast feedback loop at each code change.

It wrongly thought that application server providers were still stuck in the legacy way of doing things - thanks to Ivar Grimstad for making me aware of this option (a good reason to visit talks that do not necessarily target your interest at conferences). Wildlfy, TomEE, and other app server implementers can be configured to package Fat JARs as well, albeit with one huge difference: there’s nothing like Spring Dev Tools, so the restart of the whole app server is still required when code changes. The only alternative for faster feedback regarding those changes is to work at a lower level, e.g. JRebel licenses for the whole team. However, there’s still one reason to use WAR archives, and that reason is Docker. By providing a common app server, and Docker image as a base image, one just needs to add one’s WAR on top of it, thus making the WAR image quite lightweight. And this cannot be achieved (yet?) with the JAR approach.

Note that it’s not Spring Boot vs JavaEE, but mostly JAR vs WAR, as Spring Boot is perfectly able to package either format. As I pointed out above, the only missing piece is for the later to reload classes instead of restarting the whole JVM when a change occurs - but I believe it will happen at some point.

Choosing between the WAR and the JAR approaches is highly dependent on whether the company values more fast feedback cycles during development or more optimized and manageable Docker images.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
