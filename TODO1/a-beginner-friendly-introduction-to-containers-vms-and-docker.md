> * 原文地址：[A Beginner-Friendly Introduction to Containers, VMs and Docker](https://medium.freecodecamp.org/a-beginner-friendly-introduction-to-containers-vms-and-docker-79a9e3e119b)
> * 原文作者：[Preethi Kasireddy](https://medium.freecodecamp.org/@preethikasireddy?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-beginner-friendly-introduction-to-containers-vms-and-docker.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-beginner-friendly-introduction-to-containers-vms-and-docker.md)
> * 译者：[steinliber](https://github.com/steinliber)
> * 校对者：[7Ethan](https://github.com/7Ethan)，[jianboy](https://github.com/jianboy)

# 容器，虚拟机以及 Docker 的初学者入门介绍

![](https://cdn-images-1.medium.com/max/2000/1*k8n7Jx9UaLRAxum9HMp8nQ.png)

来自： [https://flipboard.com/topic/container](https://flipboard.com/topic/container)

如果你是一个开发者或者技术人员，那你肯定或多或少听说过 Docker：它是一个用于打包，传输并且在“容器”中运行应用的工具。它是如此不容忽视，以至于现在无论开发还是运维相关人员都在关注这个工具。甚至像谷歌，VMware 和亚马逊这样的大型公司也正在构建支持它的服务。

无论对你来说 Docker 是否能马上用得到，我都认为理解 “容器”的一些基础概念以及它和虚拟机（VM）之间的差异是很重要的。虽然互联网上已经有了大量优秀的 Docker 使用指南，但我没看到很多适合初学者的概念指南，特别是和容器的构成相关的。所以希望这篇文章可以帮助解决这个问题：）

让我们先来理解虚拟机和容器到底是什么。

### 什么是“容器”和“虚拟机”

容器和虚拟机它们的目的很相似：即将应用程序和它的依赖放到一个可以在任何环境运行的自足单元中。

此外，容器和虚拟机消除了对物理硬件的需求，从而在能源消耗和成本效益方面能让我们更有效地使用计算资源，

容器和虚拟机的主要区别在于它们的架构方式。让我们继续深入了解。

### 虚拟机

虚拟机在本质上是对现实中计算机的仿真，它会像真实的计算机一样执行程序。使用 __“hypervisor”__  可以将虚拟机运行于物理机上。hypervisor 可以在主机运行，也可以在“裸机”上运行。

让我们来揭开这些术语的面纱：

**hypervisor**（之后都以虚拟机管理程序称呼） 是能让虚拟机在其上运行的软件，固件或者硬件。虚拟机管理程序本身会在物理计算机上运行，称为 __“主机”__。主机为虚拟机提供资源，包括 RAM 和 CPU。这些资源在虚拟机之间被划分并且可以根据需要进行分配。所以如果一个虚拟机上运行了资源占用更大的应用程序，相较于其它运行在同一个主机的虚拟机你可以给其分配更多的资源。

运行在主机上的虚拟机（再次说明，通过使用虚拟机管理程序）通常也被叫做“访客机”。访客机包含了应用以及运行这个应用所需要的全部依赖（比如：系统二进制文件和库）。它还带有一个自己的完整虚拟化硬件栈，包括虚拟化的网络适配器，储存和 CPU-这意味着它还拥有自己成熟的整个访客操作系统。从虚拟机内部来看，访客机的操作都认为其使用的都是自己的专用资源。从外部来看，我们知道它是一个虚拟机-和其它虚拟机一起共享主机提供的资源。

就像前面所提到的，访客机既可以运行在**托管的虚拟机管理程序**上，也可以运行在**裸机虚拟机管理程序**上。它们之间存在一些重要的差别。

首先，托管的虚拟化管理程序是在主机的操作系统上运行。比如说，可以在一台运行 OSX 操作系统的计算机的系统上安装虚拟机（例如：VirtualBox 或者 VMware Workstation 8）。虚拟机无法直接访问硬件，因此必须通过主机上运行的操作系统访问（在我们的例子中，也就是 Mac 的 OSX 操作系统）。

托管虚拟机管理程序的好处是底层硬件并不那么重要。主机的操作系统会负责硬件的驱动而不需要管理程序参与。因此这种方式被认为具备更好的“硬件兼容性”。在另一方面，在硬件和管理程序之间这个额外的附加层会产生更多的资源开销，这会降低虚拟机的性能。

裸机虚拟机管理程序通过直接在主机硬件上安装和运行来解决这个性能问题。因为它直接面对底层的硬件，所以并不需要运行在主机的操作系统之上。在这种情况下，安装在主机上第一个作为操作系统运行的就是这个裸机虚拟机管理程序。与托管虚拟机管理程序不同，它有自己的设备驱动直接与每个组件交互，以执行任何 I/O，处理或特定于操作系统的任务。这样可以获得更好的性能，可伸缩性和稳定性。这里的权衡在于其对硬件的兼容性有限，因为裸机虚拟机管理程序内置的设备驱动只有那么多。

在讨论了虚拟机管理程序之后，你可能想知道为什么我们需要在虚拟机和主机之间这个额外的“虚拟机管理程序”层。

好吧，虚拟机管理程序在其中确实发挥了重要的作用，由于虚拟机拥有自己的虚拟操作系统，管理程序为虚拟机管理和执行访客操作系统提供了一个平台。它允许主机与作为客户端运行的虚拟机之间共享其资源。

![](https://cdn-images-1.medium.com/max/800/1*RKPXdVaqHRzmQ5RPBH_d-g.png)

虚拟机图示

正如你可以在图示中所看到的，VMS 会为每个新的虚拟机打包虚拟硬件，一个内核（即操作系统）和用户空间。

### 容器

与提供硬件虚拟化的虚拟机不同，容器通过抽象“用户空间”来提供操作系统级别的虚拟化。当我们详解容器这个术语的时候你就会明白我的意思。

从所有的意图和目的来看，容器看起来就像一个虚拟机。比如说，它们有执行进程的私有空间，可以使用 root 权限执行命令，具有专有的网络接口和 IP 地址，允许自定义路由和 iptable 规则，可以挂载文件系统等。

容器和虚拟机之间的一个重要区别在于容器和其它容器共享主机系统的内核。

![](https://cdn-images-1.medium.com/max/800/1*V5N9gJdnToIrgAgVJTtl_w.png)

容器图示

这图表明容器只会打包用户空间，而不是像虚拟机那样打包内核或虚拟硬件。每个容器都有自己独立的用户空间从而可以让多个容器在单个主机上运行。我们可以看到所有操作系统级别的体系架构是所有容器共享的。要从头开始创建的部分只有 bins 和 libs 目录。这就是容器如此轻巧的原因。

### Docker 是从哪来的？

Docker 是基于 Linux 容器技术的开源项目。它使用 Luinux 的内核功能（如命名空间和控制组）在操作系统上创建容器。

容器已经远远不是一个新技术：Google 已经使用他们自己的容器技术好多年了。其它的容器技术包括 Solaris Zones，BSD jails 和 LXC 也已经存在好多年。

那么为啥 Docker 会突然取得成功呢？

1. **使用简单**：Docker 使得任何人（开发人员，运维，架构师和其他人）都可以更轻松的利用容器的优势来快速构建和测试可移植的应用程序。它可以让任何人在他们的笔记本电脑上打包应用程序，不需要任何修改就可以让应用运行在公有云，私有云甚至裸机上。Docker 的口头禅是：“一次构建，处处运行”。

2. **速度**：Docker 容器非常轻量级和快速。因为容器只是运行在内核上的沙盒环境，因此它们占用的资源更少。与可能需要更多时间来创建的虚拟机相比，你可以在几秒钟内创建一个 Docker 容器，因为虚拟机每次都必须启动一个完整的操作系统。

3. **Docker Hub**：Docker 用户也可以从日益丰富的 Docker Hub 生态中受益，你可以把 Docker Hub 看作是 “Docker 镜像的应用商店”。Docker Hub 拥有数万个由社区构建的公共镜像，这些镜像都是随时可用的。在其中搜索符合你需求的镜像非常容易，你只需要准备拉取镜像而且几乎不需要任何修改。

4. **模块化和可扩展性**：Docker 可以让你轻松地把应用程序按功能拆分为单个独立的容器。比如说，你的 Postgre 数据库可以运行在一个容器中，Redis 服务运行在另一个容器中，而 Node.js 应用运行在另一个容器中。使用 Docker，将这个容器链接在一起以创建你的应用程序将会变得更简单，同时在将来可以很轻松地扩展和更新单独的组件。

最后但并不重要的是，有谁不喜欢 Docker 的鲸鱼（Docker 的标志）呢？：）

![](https://cdn-images-1.medium.com/max/800/1*sGHbxxLdm87_n7tKQS3EUg.png)

来自： [https://www.docker.com/docker-birthday](https://www.docker.com/docker-birthday)

### 基础的 Docker 概念

现在我们已经大致了解了 Docker，让我们依次讲下 Docker 的基础部分：

![](https://cdn-images-1.medium.com/max/800/1*K7p9dzD9zHuKEMgAcbSLPQ.png)

#### Docker Engine

Docker Engine 是 Docker 运行的底层。它是一个轻量级的运行时和工具，可以用于管理容器，镜像，构建等等。它在 Linux 本机上运行，由以下部分组成：

1. 在主机上运行的 Docker 守护进程。
2. Docker 客户端，用于和 Docker 守护进程通信来执行命令。
3. 用于远程和 Docker 守护进程交互的 REST API。

#### Docker 客户端 

Docker 客户端是用来和你（ Docker 的终端用户）交互的。可以把它想象成 Docker 的 UI。例如：

你是在和 Docker 客户端进行交互，然后 Docker 客户端会把你的指令传递给 Docker 守护进程。

```
docker build iampeekay/someImage .
```

#### Docker 守护进程

实际上发送到 Docker 客户端的命令是由 Docker 守护进程执行（比如像构建，运行和分发容器）。Docker 守护进程在主机上运行，但作为用户，你并不能直接和守护进程交互。Docker 客户端也可以在主机上运行，但这并不是必需的。它可以运行在不同的机器上并且与运行在主机上的 Docker 守护进程通信。

#### Dockerfile

你可以在 Dockerfile 中编写构建 Docker 镜像的指令。这些指令可以是：

*   **RUN apt-get y install some-package**：安装软件包
*   **EXPOSE 8000**： 暴露一个端口
*   **ENV ANT_HOME /usr/local/apache-ant**：传递环境变量

更进一步。一旦配置好的你的 Dockfile，就可以使用  **docker build** 命令从中构建镜像。这里是 Dockerfile 的一个例子：

简单的 Dockerfile：

```
# 构建基于 ubuntu 14.04 镜像
FROM ubuntu:14.04

MAINTAINER preethi kasireddy iam.preethi.k@gmail.com

# 用于 SSH 登陆和端口重定向
ENV ROOTPASSWORD sample

# 在安装包的过程中关闭提示
ENV DEBIAN_FRONTEND noninteractive
RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

# 更新包
RUN apt-get -y update

# 安装系统工具/库
RUN apt-get -y install python3-software-properties \
    software-properties-common \
    bzip2 \
    ssh \
    net-tools \
    vim \
    curl \
    expect \
    git \
    nano \
    wget \
    build-essential \
    dialog \
    make \
    build-essential \
    checkinstall \
    bridge-utils \
    virt-viewer \
    python-pip \
    python-setuptools \
    python-dev

# 安装 Node，npm
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN apt-get install -y nodejs

# 把 oracle-jdk7 添加到 Ubuntu 包仓库
RUN add-apt-repository ppa:webupd8team/java

# 确保包仓库是最新的
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

# 更新 apt
RUN apt-get -y update

# 安装 oracle-jdk7
RUN apt-get -y install oracle-java7-installer

# 导出 JAVA_HOME 环境变量
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# 执行 sshd
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo "root:$ROOTPASSWORD" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH 登陆修复。否则用户将在登陆后被踢出
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# 暴露 Node.js 应用端口
EXPOSE 8000

# 创建 tap-to-android 应用目录
RUN mkdir -p /usr/src/my-app
WORKDIR /usr/src/my-app

# 安装应用依赖
COPY . /usr/src/my-app
RUN npm install

# 添加 entrypoint 执行入口点
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["npm", "start"]
```

#### Docker 镜像

通过你 Dockerfile 中指令构建的镜像是一个只读的模版。镜像不仅定义了你希望打包的应用程序和其依赖，还有启动时要运行的进程。

Docker 镜像是使用 Dockerfile 构建的。 Dockerfile 中的每个指令都会为镜像添加一个新的“镜像层”，镜像层表示的是镜像文件系统中的一部分，可以添加或者替换位于它下面的镜像层内容。镜像层是 Docker 轻巧且强大结构的关键。Docker 使用 Union 文件系统来实现它：

#### Union 文件系统

Docker 使用  Union 文件系统来构建一个镜像。你可以把 Union 文件系统看作是可堆叠文件系统，这意味着不同文件系统（也被认为是分支）中的文件和目录可以透明的构成一个文件系统。

在重叠分支内拥有相同路径目录的内容会被视为单个合并的目录，这避免了需要为每一层创建单独副本。相反，它们都被赋予了指向同一个资源的指针；当某些镜像层需要被更改时，它就会创建一个副本并且修改本地的副本，而原来的镜像层保持不变。这种方式使得在外部看起来文件系统是可写的而实际上内部却并不可写。（换句话说，就是“写时复制”系统）

层级系统主要提供了两个优点：

1. **无复制：**镜像层有助于避免每次你使用镜像创建或者运行容器时复制整套文件，这使 docker 容器实例化非常快速和廉价。
2. **镜像层隔离：**当你更改一个镜像时会更快，Docker 更新只会传播到已改变的镜像层。

#### 卷

卷是容器的“数据部分”，它会在容器创建的时候初始化。卷允许你持久化并且共享容器中的数据。数据卷与镜像中默认的 Union 文件系统是分离的，并作为主机文件系统上的普通目录和文件存在。所以，即使你销毁，更新或者重新构建你的容器，数据卷也将保持不变。如果想更新数据卷，你也可以直接对其进行更改。（这功能额外的好处在于，数据卷可以在多个容器之间共享和重用，如此简洁优雅）

#### Docker 容器

如上所述，Docker 容器将应用程序的软件及其运行所需的全部东西打包到了不可见的沙箱中。这包括操作系统，应用代码，运行时，系统库等等。Docker 容器是基于 Docker 镜像构建的。因为镜像是只读的，所以 Docker 在镜像的只读文件系统上添加了一个读写文件系统来创建容器。


![](https://cdn-images-1.medium.com/max/800/1*hZgRPWerZVbaGT8jJiJZVQ.png)

来自：Docker

此外，Docker 创建容器还有很多步，它会创建一个网络接口以便容器和本地主机可以通信，再把可用的 IP 地址附加到容器上，并运行定义镜像时你所指定运行应用程序的进程。

成功创建了容器之后，你可以在任何环境中运行它而无需任何更改。

### 双击“容器”

唷！已经讲了好多部分了。有一件事总是让我感到好奇，那就是实际上容器是如何实现的，特别是容器相关并没有任何的抽象基础设施边界可以参照。经过大量地阅读之后，这一切都是值得的，所以下面是我尝试向你们解释它！：）

“容器”其实只是一个抽象的概念，用于描述不同的功能如何协同从而得到一个可视化的“容器”。让我们快速浏览这些功能：

#### 1) 命名空间

命名空间为容器提供了它们自己的底层 Linux 视图，限制了容器可以查看和访问的内容。当你运行一个容器的时候，Docker 会创建这个特定容器将会使用的命名空间。

Docker 使用了内核中提供的几种不同类型的命名空间，比如说：

a. **NET：**为容器提供了只有其自己可见的系统网络堆栈（例如，其自己的网络设备，IP 地址，IP 路由表，/proc/net 目录，端口号等）。
b. **PID：**PID 表示进程 ID。如果你曾在命令行中运行 **ps aux** 来检测系统上正在运行的进程，你将会看到有一列名叫 “PID”。PID 命名空间为容器提供了只有它们自己范围内可见和交互的进程视图。包括独立的 init 进程（PID 1），这个进程是容器内所有进程的“祖先”。
c. **MNT：**给容器一个自己的[系统“挂载”](http://www.linfo.org/mounting.html)视图。因此，在不同挂载命名空间的进程具有文件层级结构的不同视图。
d. **UTS：**UTS 代表 UNIX 分时系统。它允许进程识别系统标识符（即主机名，域名等）。UTS 让容器可以有自己的主机名和 NIS 域名，独立于其它容器和主机系统。
e. **IPC：**IPC 表示进程间通信。IPC 命名空间负责隔离每个容器中运行进程之间的 IPC 资源。
f. **USER：**这个命名空间用于隔离每个容器中的用户。相较于主机系统，它的功能是让容器具有 uid（用户 ID）和 gid（组 ID）范围的不同视图。因此，进程在用户命名空间内部的 uid 和 gid 可以和外部主机不同，这就允许在进程在容器外部的 uid 是非特权用户，而不会牺牲在容器内部进程 uid 的 root 权限。

Docker 将这些命名空间一起使用来隔离并开始创建容器。下面的功能叫做控制组。

#### 2) **控制组**

控制组（也叫做 cgroups）是一种 Linux 内核功能，用于隔离，确定优先级和统计一组进程的资源使用情况（CPU，内存，磁盘 I/O，网络等 ）。从这个意义上来说，控制组确保 Docker 容器只使用它们需要的资源-如果需要，还可以设置容器可以使用的资源限制。控制组还确保单个容器不会耗尽其中的资源从而导致系统奔溃。

最后，Union 文件系统是 Docker 使用的另一个功能：

#### 3) **隔离的 Union 文件系统：**

这个已经在上面 Docker 镜像部分描述过了：）

这就是 Docker 容器的全部内容（当然，魔鬼在实现细节中-比如如何管理不同组件之间的交互）。

### Docker 的未来：Docker 将于虚拟机共存

虽然 Docker 确实获得了很多支持，但我并不认为它会成为虚拟机真正的威胁。容器将继续发挥作用，但有很多情况下更适合使用虚拟机。

比如说，如果你需要在多个服务器上运行多个应用，则使用虚拟机可能是有意义的。另一方面，如果你需要运行单个应用的多个副本，Docker 则能提供一些引人注目的优点。

此外，虽然容器允许你将应用拆分为更多功能独立的部分从而创建关注点分离，它也意味着需要管理的部件会越来越多，这可能会变得难以处理。

安全性也是 Docker 容器所关注的一个领域-由于容器之间共享内核，容器之间的隔层会更薄。一个完整的虚拟机只能向主机的虚拟机管理程序发出超级调用，但是 Docker 容器却可以向主机内核发起系统调用，这导致其被攻击的范围相比之下会更大。当安全性特别重要时，开发人员可能会选择由抽象硬件隔离的的虚拟机-这可以使不同虚拟机之间进程的互相干扰变得更加困难。

当然，随着容器在生产环境中更多使用和用户的进一步审核，安全和管理等问题肯定会不断发展。就目前而言，关于容器与虚拟机之间的争论对于那些每天都接触它们的人来说真的是最好的。

### 结论

我希望你现在已经掌握了了解 Docker 所需要的知识，甚至有一天会在项目中使用它。

像往常一样，无论我在文中有任何错误或者您有任何帮助的建议，请在评论下留言！：）

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
