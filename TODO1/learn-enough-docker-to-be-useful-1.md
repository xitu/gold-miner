> * 原文地址：[Learn Enough Docker to be Useful](https://towardsdatascience.com/learn-enough-docker-to-be-useful-b7ba70caeb4b)
> * 原文作者：[Jeff Hale](https://medium.com/@jeffhale)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learn-enough-docker-to-be-useful-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-enough-docker-to-be-useful-1.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[MarchYuanx](https://github.com/MarchYuanx)，[TokenJan](https://github.com/TokenJan)

# Docker 的学习和应用

### 第一部分：基本概念

![](https://cdn-images-1.medium.com/max/3840/1*4eXBePb2oLVPxHyocCNmlw.jpeg)

容器（Container）对于提高软件研发和数据存储的安全性、再生性，以及可扩展性都大有用途。它们的兴起是当今科技潮流中最重要的部分之一。

Docker 就是一个在容器中研发、部署以及运行程序的平台。实际上，Docker 就是集装箱的同义词。如果你是或是立志想要成为一名软件开发工程师或者数据科学家，Docker 就是你必须要学习的内容。

![](https://cdn-images-1.medium.com/max/2000/1*EJx9QN4ENSPKZuz51rC39w.png)

不用担心你的进度比别人落后了 —— 本文将会帮助你了解 Docker 的基本概念 —— 然后你就可以在此基础上应用它了。

在这个系列的后五篇文章中，我将会专注讲解 Docker 术语、Dockerfile、Docker 镜像，Docker 命令以及数据存储。第二部分现在已经上线：

* [**Docker 的学习和应用（2）：你需要知道的那些 Docker 术语**](https://towardsdatascience.com/learn-enough-docker-to-be-useful-1c40ea269fa8)

在这个系列的最后（还会有一些练习内容），你应该能基本学会 Docker 并可以加以应用了 😃！

## 关于 Docker 的比喻

首先，我们从一个对 Docker 的比喻开始讲起。

![[They’re everywhere! Just check out this book.](https://www.goodreads.com/book/show/34459.Metaphors_We_Live_By)](https://cdn-images-1.medium.com/max/2000/1*poqn_j2R9xTk940n9wE9Lw.jpeg)

[Google 对比喻的定义](https://www.google.com/search?q=metaphor+definition&oq=metaphor+defini&aqs=chrome.0.0j69i57j0l4.2999j1j4&sourceid=chrome&ie=UTF-8)正是我们需要了解的：

> 代表或者象征另外一些事物，特别是很抽象的事物。

比喻能帮助我们了解新事物。比如说，将其比喻为一个容器实体可以帮助我们快速的了解虚拟容器的本质。

![一个容器实体](https://cdn-images-1.medium.com/max/2000/1*ndncU4a3uNsQ_oy2YrNLBA.jpeg)

### 容器（Container）

正如一个塑料盒子实体，一个 Docker 容器的特性包括：

1. **容纳事物** —— 毕竟事物不是在容器内就是在容器外。

2. **便携式** —— 它可以用于本地设备、共享设备，或者云服务（例如 AWS）上。有点像你小时候搬家的时候用来装小玩意儿们的盒子。

3. **提供清晰的接口** —— 实体盒子会有一个开口，让我们能打开它并放入或者取出东西。类似的，Docker 容器也有和外界沟通的机制。它有可以开放的端口，通过浏览器即可与外界交互。你可以通过命令行对它进行数据交互的相关配置。

4. **支持远程获取** —— 当你有需要的时候，你可以从亚马逊上买到另一个空的塑料盒子。亚马逊从制造商那里获取塑料盒子，而制造商从一个模具中可以制造出成千上万这样的盒子。而对于 Docker 容器，异地登陆会保留一张镜像，它就像是一个盒子模具。如果你需要另一个容器，你可以从这个镜像中制作出一份。。

和虚拟的 Docker 容器不同，你必须付费才能从亚马逊买新的塑料盒子，而且也不能得到放进去的货物的备份。抱歉喽 💸。

### 活的实例

第二种你可以用来思考 Docker 容器的方法是将它看作一个**活物的实例**。实例是指以某种形态存在的事物。它不仅仅是代码。它让事物有了生命。就像其他的活物一样，这个实例最终会消亡 —— 意味着容器会被关闭。

![An instance of a monster](https://cdn-images-1.medium.com/max/2000/1*t-uVUfbywQsDnwQoYAEbgA.jpeg)

Docker 容器就是 Docker 镜像的活体形态。

### 软件

除了盒子的比喻和活的实例的比喻，你还可以将 Docker 容器看作是**一个软件程序**。毕竟，它在本质上还是一个软件。从根本上来说，容器是一系列能计算比特的指令。

![Containers are code](https://cdn-images-1.medium.com/max/2000/1*0D45gdLlWgvMBu9Xwr0RrA.jpeg)

当 Docker 容器在运行的时候，通常情况下会有程序在它内部运行。程序在容器内执行操作，所以应用程序才能完成某些功能。

例如，你现在正在阅读的网页也许就是 Docker 容器内的代码发送给你的。或者它也许读取了你的声音指令并发送给 Amazon Alexa，你的声音被解码为其他指令，然后其他容器中的程序将会使用它。

使用 Docker，你就可以在一台主机上同时运行多个容器。和其他软件程序一样，Docker 容器可以被运行、检测、停止和删除。

## 概念

### 虚拟机

虚拟机是 Docker 容器的前身。虚拟机也会分离应用和它的依赖。但是，Docker 容器需要的资源更少，更轻也更快，因此它要比虚拟机更加先进。你可以阅读[这篇文章](https://medium.freecodecamp.org/a-beginner-friendly-introduction-to-containers-vms-and-docker-79a9e3e119b)来了解更多它们之间的相似点与不同点。

### Docker 镜像

我在前文中提到了镜像。那么什么是镜像呢？我很高兴你积极的提问了！在 Docker 的语境中，**镜像**这个术语的含义和真正的照片的含义完全不同。

![Images](https://cdn-images-1.medium.com/max/2000/1*Wv9nvbm0XRLSGQ9nqTzpdA.jpeg)

Docker 镜像更像是一个蓝图，饼干模具，或者说是模子。镜像是不会变化的主模版，它用于产生完全一样的多个容器。

![Cookie cutters](https://cdn-images-1.medium.com/max/2000/1*n53WlDyD9mxVcOu17Rj86Q.jpeg)

镜像包含 Dockerfile，库，以及需要运行的应用代码，所有这些绑定在一起组成镜像。

### Dockerfile

[Dockerfile](https://docs.docker.com/engine/reference/builder/) 是一个包含了 Docker 如何构建镜像的指令的文件。

Dockerfile 会指向一个可用于构建初始镜像层的基础镜像。使用广泛的官方基础镜像包括 [python](https://hub.docker.com/_/python/)、[ubuntu](https://hub.docker.com/_/ubuntu) 和 [alpine](https://hub.docker.com/_/alpine)。

其他附加层将会根据 Dockerfile 中的指令，添加在基础镜像层的上面。例如，机器学习应用的 Dockerfile 将会通知 Docker 在中间层中添加 NumPy、Pandas 和 Scikit-learn。

最后，一个很薄并且可写的层将会根据 Dockerfile 的代码添加在所有层的上方。（薄的意思其实就是指这一层的体积很小，这一点你明白了对吧 😃？因为你已经很直观的理解了**薄**这个比喻）

我将会在这一系列的其他文章中更加深入的探讨 Dockerfile。

### Docker Container

Docker 镜像加上命令 `docker run image_name` 将会从这个镜像中创建一个容器，并启动它。

### Container 注册处

如果你想让其他人也可以使用你的镜像生成容器，你需要将镜像发送给容器注册处。[Docker Hub](https://hub.docker.com/) 是最大的、也是人们默认的注册处。

唉！太多零碎的内容了。我们把这些都集中在一起，进行一次实践，这就好像做一款披萨一样哦。

## Docker 实践

![Landscape Metaphor](https://cdn-images-1.medium.com/max/2000/1*v6WWacmOsrPYtkGXUu-cbA.jpeg)

* 配方就是 **Dockerfile**。它告诉我们如何操作才能做好这款披萨。

* 材料就是 Docker 的**层**。现在你已经有了披萨的面坯，酱料以及芝士了。

将配方和原料的组合想象为一个一体化的披萨制作工具包。这就是 **Docker 镜像**。

配方（Dockerfile）告诉了我们操作步骤。如下：

* 披萨面坯是不能改的，就好比是基础的 ubuntu 父级镜像。它是**底层**，并且会最先被构建。

* 然后还需要添加一些芝士。披萨的第二层就好比**安装外部库** —— 例如 NumPy。

* 然后你还可以撒上一些罗勒。罗勒就好比你写在**文件里的代码**，用来运行你的应用。。

好了，现在我们开始烹饪吧。

![Oven](https://cdn-images-1.medium.com/max/2000/1*rihuhM7hCvWaJhuw7Hjvzg.jpeg)

* 用来烤披萨的烤箱就好比是 Docker 平台。你将烤箱搬到你的家里，这样就可以用它来烹饪了。相似的，你把 Docker 安装到你的电脑里，这样就可以操作容器。

* 你通过旋转旋钮来让烤箱开始工作。`docker run image_name` 指令就像是你的旋钮 —— 它可以创建并让容器开始工作。

* 做好的披萨就好比是一个 Docker 容器。

* 享用披萨就好比是使用你的应用。

正如做披萨一样，在 Docker 里创建应用也要你付出劳动，但是最终你能得到很棒的成果。享用它吧！

## 尾声

本文的主要内容是概念框架。在[这个系列的第二部分](https://towardsdatascience.com/learn-enough-docker-to-be-useful-1c40ea269fa8)，我将会解释一些在 Docker 生态圈中你可能会见到的术语。记得关注我，这样你就不会错过了。

希望这篇概述能帮助你更好的理解 Docker。我也希望它能够让你知道，比喻这种方式在理解新技术的时候的价值。

如果觉得本文对你有帮助，请转发到你喜欢的社交媒体上，这样其他人也就可以阅读学习了。👏

我也写关于 Python、Docker、数据科学等等很多方面的文章。如果你感兴趣，可以在[这里](https://medium.com/@jeffhale)阅读更多内容，也可以在 Medium 上关注我。😄

![](https://cdn-images-1.medium.com/max/NaN/1*oPkqiu1rrt-hC_lDMK-jQg.png)

感谢你花时间阅读本文！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
