> * 原文地址：[How to set up a Continuous Integration server for Android development (Ubuntu + Jenkins + SonarQube)](https://pamartinezandres.com/how-to-set-up-a-continuous-integration-server-for-android-development-ubuntu-jenkins-sonarqube-43c1ed6b08d3#.sylq0wmfq)
* 原文作者：[Pablo A. Martínez](https://pamartinezandres.com/@pamartineza?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[skyar2009](https://github.com/skyar2009)
* 校对者：[jifaxu](https://github.com/jifaxu), [tanglie1993](https://github.com/tanglie1993)

# 如何搭建安卓开发持续化集成环境（Ubuntu + Jenkins + SonarQube） #

我最近换了一台新的 MacBook Pro 作为我的 Android 开发机。旧的 Mac BookPro （13英寸，2011款，16GB 内存，500G SSD，i5 内核 2.4GHz，64位）我并没有卖掉或丢掉，而是装了 MacOS-Ubuntu 双系统作为持续化集成环境服务器。

本文目标是总结安装步骤，以便广大开发者朋友和我自己将来在搭建自己的 CI 时参考，主要内容如下：

- 在全新的 Ubuntu 环境下安装 Android SDK。

- 搭建 Jenkins CI 服务，在其基础上从 GitHub 上获取代码、编译一个多模块的 Android 项目，并对其进行测试。

- 安装 Docker 容器，并在其上安装 MySQL 服务和 SonarQube，以实现 Jenkins 触发的静态代码分析。

- Android App 配置需求。

### 第 1 步 —— 安装 Ubuntu： ###

我之所以选择 Ubuntu 作为 CI 的操作系统，是因为它有着强大的社区，方便对可能遇到的问题寻求帮助，我个人建议使用最新的 LTS 版本，目前是 16.04 LTS。因为有许多 Ubuntu 安装教程（虚拟机和真机），所以这里我只提供下载链接。

[安装 Ubuntu 16.04 LTS 桌面版](https://www.ubuntu.com/download/desktop)

你可能会对我选择桌面版而不是选择服务器版而感到疑惑，这只是个人的偏好，我并不介意因为有界面交互而带来的性能和可用内存的少量损失，因为我认为 GUI 对提高工作效率的帮助大过消耗。

### 第 2 步 —— 远程访问管理： ###

#### **SSH服务:** ####

Ubuntu 桌面版默认并没有安装 ssh 服务，因此如果需要远程管理你的服务器还需要手动安装，安装命令如下：

```
$ sudo apt-get install openssh-server
```

#### **NoMachine 远程桌面：** ####

可能你的 CI 没在你眼前而是在你的路由器附近、别的屋子甚至几公里外的地方。我使用过多种远程桌面程序，IMHO NOMachine 是最好的一款，它平台无关并且仅仅需要你的 ssh 凭证。（当然 CI 服务器和你的本机都需要进行安装）


[**NoMachine - 对任何人都免费**](https://www.nomachine.com/download)


### 第 3 步 —— 环境配置 ###

下面我将安装 Jenkins pull 代码、编译运行 android 项目所依赖工具，包括 JAVA8，Git，和 Android SDK。

#### **SDKMAN!:** ####

SDKMAN! 是一个非常酷的命令行工具，它支持主流的 SDK（例如：Gradle, Groovy, Grails, Kotlin, Scala 等），它可以提供可用列表供我们选择并可以方便地在不同版本之间进行切换。

[**SDKMAN! 软件开发工具管理器**](http://sdkman.io/) 

SDKMAN! 最近支持了 JAVA8，所以我选择使用它而不是主流的 webupd8 库来安装 JAVA 环境，当对你而言用不用 SDKMAN! 都可以，不过我认为将来你一定会用。

安装 SDKMAN! 只需要执行下面的命令：

```
$ curl -s "https://get.sdkman.io" | bash
```


#### Oracle JAVA8: ####

如果前面已经安装了 SDKMAN! ，安装 JAVA8 只需要简单的执行下面的命令：

```
$ sdk install java
```

或者使用 webupd8 库进行安装：

[**Ubuntu 或 Linux Mint 通过 PPA 库安装 Java 8 [JDK8]**](http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html)


#### **Git:** ####

安装 git 非常简单，不需要多说：

```
$ sudo apt install git
```


#### **Android SDK:** ####

在本页的底部：

[**下载 Android Studio 和 SDK 工具 | Android Studio**](https://developer.android.com/studio/index.html)


你可以看到 “**Get just the command line tools**”，复制像下面的链接：

[https://dl.google.com/android/repository/tools_r25.2.3-linux.zip](https://dl.google.com/android/repository/tools_r25.2.3-linux.zip) 


然后下载并解压到 /opt/android-sdk-linux

```
$ cd /opt
$ sudo wget [https://dl.google.com/android/repository/tools_r25.2.3-linux.zip](https://dl.google.com/android/repository/tools_r25.2.3-linux.zip)
$ sudo unzip tools_r25.2.3-linux.zip -d android-sdk-linux
```

因为我们是使用 root 用户创建的目录，我们需要修改目录权限允许主用户对其读和写：

```
$ sudo chown -R YOUR_USERNAME:YOUR_USERNAME android-sdk-linux/
```

接下来修改 /.bashrc 来配置 SDK 环境变量：

```
$ cd
$ nano .bashrc
```

在文件的底部（SDKMAN! 配置之前）添加如下内容：

```
export ANDROID_HOME="/opt/android-sdk-linux"
export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"
```

关掉终端并重新打开一个，以确认环境变量配置正确（译者注：不关闭，执行 source ~/.bashrc 也可以）

```
$ echo $ANDROID_HOME
/opt/android-sdk-linux
```

接着打开 Android SDK Manager 的窗口程序，安装你需要的平台版本以及依赖

```
$ android
```

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*Q4o_LpfC5A3evFUwd62MOQ.png">

Android SDK Manager 界面


### 第 4 步 —— Jenkins 服务: ###

接下来我将描述 Jenkins 的安装与配置，并创建一个 Jenkins 任务来拉取 Android 项目代码并对其进行编译和测试，以及查看控制台输出。

#### Jenkins 安装: ####

Jenkins 可以从官网获得：

[**Jenkins**](https://jenkins.io/)

有多方式可以运行 **Jenkins**，例如运行一个 **.war** 文件，作为一个 linux **服务**， 作为一个 Docker **容器** 等。

我的第一反应是使用 Docker 容器的方式安装，但我发现那简直是个噩梦，因为我需要配置代码目录、android-sdk 目录的可见性，以及运行 Android 测试的物理可插拔设备 USB 的可见性。

为了方便使用，我最终选择将它作为服务使用，通过 **apt** 来安装、更新稳定的版本

```
$ wget -q -O - [https://pkg.jenkins.io/debian-stable/jenkins.io.key](https://pkg.jenkins.io/debian-stable/jenkins.io.key)| sudo apt-key add -
```

修改 sources.list 文件

```
$ sudo nano /etc/apt/sources.list
```

添加如下内容

```
#Jenkin Stable
deb https://pkg.jenkins.io/debian-stable binary/
```

然后安装

```
sudo apt-get update
sudo apt-get install jenkins
```

将 *jenkins* 用户添加到你的用户组，确保其对 Android SDK 目录有读写权限

```
$ sudo usermod -a -G YOUR_USERNAME jenkins
```

Jenkins 服务会在开机的时候自启动，可以通过 [http://localhost:8080](http://localhost:8080) 进行访问

为了安全起见，刚刚装完显示的是如下的页面，只需要跟着说明就可以完成 Jenkins 的启动了。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*gN6-ncU7mRdQWL3wmlS_5g.png">

解锁成功安装的 Jenkins 服务

#### Jenkins 配置: ####

Jenkins 解锁后需要安装插件，点击 “**Select plugins to Install**” 浏览、选择如下建议的插件，然后进行安装

- JUnit

[**JUnit Plugin - Jenkins - Jenkins Wiki**](https://wiki.jenkins-ci.org/display/JENKINS/JUnit+Plugin)

- JaCoCo

[**JaCoCo Plugin - Jenkins - Jenkins Wiki**](https://wiki.jenkins-ci.org/display/JENKINS/JaCoCo+Plugin)


- EnvInject

[**EnvInject Plugin - Jenkins - Jenkins Wiki**](https://wiki.jenkins-ci.org/display/JENKINS/EnvInject+Plugin) 

- GitHub plugins

[**GitHub Plugin - Jenkins - Jenkins Wiki**](https://wiki.jenkins-ci.org/display/JENKINS/GitHub+Plugin)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*xvG06qRSCvfw5OQgQleG0A.png">

安装 Jenkins 插件

创建 admin 完成安装。

在配置完成之前，我们还要配置 ANDROID_HOME 和 JAVA_HOME：

点击进入 Manage Jenkins > Configure 页面


滚动到 **Global properties** 部分，勾选 **Environment variables** 选项，将 *ANDROID_HOME* 和 *JAVA_HOME* 填好

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*rpgkUsqWhkHk4xOKCGPcvw.png">

添加全局的环境变量

#### **创建 “Jenkins 任务”** ####

Jenkins 任务由一系列连续执行的步骤组成。我在 GitHub 上准备了一个 “Hello Jenkins” 的 Android 工程，如果你是跟着本教程做的，你可以用来测试你的Jenkins配置。这只是一个简单的多模块 app，包括单元测试、Android 测试 以及 JaCoCo 和 SonarQube 插件。

[**pamartineza/helloJenkins**](https://github.com/pamartineza/helloJenkins)

首先新建一个 **自由风格工程项目** 并取个名字例如 “**Hello_Android**” （Jenkins 任务名不要有空格，避免将来与 SonarQube 的兼容性问题）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*ITE7xIrbsrChWv45PSlPPw.png">

创建自由风格的 Jenkins 任务

下面让我们一起进行配置，我会对每个部分截图

**General:**

该部分和我们最终的目标关系不大，在这你可以修改任务名，添加描述，如果使用的是 GitHub 项目可以添加项目的 URL，（不要带 *.git, 这个 url 项目的 url 不是 repo）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*7QF2pfgM73FVIWTfQhcbEA.png">

项目 Url 配置


**源代码管理:**

这里我们需要选择 Git 作为 CVS 选项，并且填写代码库地址（需要包含 *.git）并选择要获取的分支。这是一个公开的 GitHub 仓库，因此不需要添加凭证，否则需要填写你的用户名和密码。

我建议你重新创建一个只有你私有仓库只读权限 GitHub 账户 供你的 Jenkins 使用，而不是直接使用你的真实 GitHub 账户。

此外如果你开启了双重身份验证 Jenkins 将不能获取代码，这时为 Jenkins 单独创建账户是能够正常获取私有仓库代码的方法。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*wkzdL70XrCzIpXDsHPA2Pg.png">

仓库配置


**构建触发器:**

构建可以被以下方式触发：手动的、远程的、周期性的、另一个任务构建、检测到变更时等等。

理想的最好的情景是，当新的变更推送到仓库是触发构建，GitHub 提供了一个叫 Webhooks的系统

[**Webhooks | GitHub Developer Guide**](https://developer.github.com/webhooks/)

我们可以配置 Webhooks 发送事件到 CI 服务触发构建，但是这需要我们的 CI 服务器对 GitHub 在线并可以通过 GitHub 访问。

可能处于安全考虑你的 CI 是放在私有网络里的，这时唯一的解决方案就是周期性的查询 GitHub。就我个人而言，我一工作就会打开 CI，在下面的截图中我配置的是每 15 分钟查询一次 GitHub。查询的频次与 **CRON** 语法一样，如果你对其不熟悉，可以点击右面的帮助按钮获得帮助文档。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*eONz8DAwJ9PW7uc8VQw7wQ.png">

任务配置


**构建环境:**

我推荐配置构建的 **stuck** 超时时间，避免 Jenkins 当意外错误发生时阻塞占用内存和 CPU。这里也可以配置环境变量和账号密码等。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*Y6FgbIQq8pMk6D72Sr9KdQ.png">

错误构建超时


**构建:**

这里是最神奇的地方！添加一个 **构建步骤** 选择 **执行 Gradle 脚本**  选择 Gradle Wrapper （Android 项目默认情况下都包含 Gradle Wrapper，不要忘记将其添加到 Git）并且配置需要执行的任务：

1. **clean:** 删除所有之前构建产生的输出，确保本次构建没有任何缓存。

2. **assembleDebug:** 生成 debug .apk

3. **test:** 对所有模块执行单元测试

4. **connectedDebugAndroidTest:** 在连接到 CI 的真机上执行 Android 测试。（通过安装 Android Emulator Jenkins 插件也可以在 Android 模拟器上运行 Android 测试，但是并不支持所有版本的模拟器，并且配置非常琐碎）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*D0HDPOUYCWzsWKiLv4LrBA.png">

Gradle 任务配置


**构建后操作**

这部分我们添加 **发布 JUnit 测试结果报告**，本步骤由 JUnit 插件提供，收集 JUnit 测试产生的 .XML 报告，并生成测试结果图表报告。

该部分对 debug 包来说测试结果的路径是：

**app/build/test-results/debug/*.xml**

在多模块工程中，“纯” Java 模块的测试结果路径是：

**/build/test-results/*.xml**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*ZQtamiQ_8PzAFBd-pMfvdg.png">


同时添加 **Record JaCoCo coverage report** 以生成展示代码变更进程的图标

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*wKaFykDl0qg-c79QwRTR2w.png">


#### 运行 Jenkins 任务 ####

如果有新的任务推送到仓库，上面的任务会每个 15 分钟运行一次；如果不想等下次自动运行而是想立即看到修改，也可以手动触发。点击 **立即构建** 之后当前的构建会出现在 **构建历史** 中，点击它可以查看详情。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*vKi-BGQ2blimaoTl7PTXtQ.png">

手动执行任务

最有趣的部分是控制台输出，可以看到 Jenkins 是如何获取代码并且如何执行前面配置的 Gradle 任务（例如 **clean.**）。


<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*dbtmlSr2owrj_CQfGXjdsw.png">

控制台输出的开头

如果所有任务都成功执行控制台输出会如下图（仓库连接错误、单元测试问题或者 Android 测试问题都会导致构建失败）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*WpOH-aHuuNRDYmY710ecLQ.png">

构建成功和测试结果收集


### 第 5 步 —— SonarQube ###

这部分我将介绍使用 Docker 容器安装配置 SonarQube 和它的伴侣 MySQL数据库。

[**Continuous Code Quality | SonarQube**](https://www.sonarqube.org/)

SonarQube 是一个静态代码分析工具，它可以帮助开发者编写干净的代码、发现 bug、学习好的经验，并且可以跟踪代码覆盖、测试结果、技术债务等。所有 SonarQube 检测到的问题都可以导入到安装了插件的 Android Studio/IntelliJ 中，并修复。

[**JetBrains Plugin Repository :: SonarQube Community Plugin**](https://plugins.jetbrains.com/idea/plugin/7238-sonarqube-community-plugin)

#### 安装 Docker: ####

按照 Docker 官方文档进行安装非常的简单：

[**Install Docker on Ubuntu**](https://docs.docker.com/engine/installation/linux/ubuntulinux/)
[**在 Ubuntu 上安装 Docker**](https://docs.docker.com/engine/installation/linux/ubuntulinux/)


#### 创建容器： ####

**MySQL:**

下面我们创建 MySQL 5.7.17 叫做 **mysqlserver** 的服务容器，配置如下：自启动、安装到你自己的目录下、配置密码、以及端口 3306 *（ YOUR_USER 和 YOUR_MYSQL_PASSWORD 用真实值替换）*

```
$ docker run --name mysqlserver --restart=always -v /home/YOUR_USER/mysqlVolume:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=YOUR_MYSQL_PASSWORD -p 3306:3306 -d mysql:5.7.17
```


**phpMyAdmin:** 

我使用 phpMyAdmin 管理 MySQL 服务，当然最简单的方法就是创建一个叫做 **phpmyadmin** 的容器关联到 **mysqlserver**，配置如下：自启动、端口 9090、使用最新的版本

```
$ docker run --name phpmyadmin --restart=always --link mysqlserver:db -p 9090:80 -d phpmyadmin/phpmyadmin
```

通过访问 localhost:**9090** 使用 phpMyAdmin, 使用 **root** 账户登录，并创建 **sonar** 数据库，字符集设为 **utf8_general_ci**。新建一个 **sonar** 用户并授权 **sonar** 数据库的全部权限


**SonarQube:**

下面我们开始创建 SonarQube 容器，取名 **sonarqube** 配置如下：自启动、关联到刚刚配置的 db，端口 9000，使用 5.6.4（LTS）版。

```
$ docker run --name sonarqube --restart=always --link mysqlserver:db -p 9000:9000 -p 9092:9092 -e "SONARQUBE_JDBC_URL=jdbc:mysql://db:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance" -e "SONARQUBE_JDBC_USER=sonar" -e "SONARQUBE_JDBC_PASSWORD=YOUR_SONAR_PASSWORD" -d sonarqube:5.6.4
```

#### SonarQube 配置: ####

如果一切 OK，访问 localhost:9000 将会看到下图：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*tcgww8PENXdyrLS3K95ZEw.png">

下面安装必要的插件和 Quality Profiles

1. 右上角登录（默认的管理员账号是 admin/admin）

2. 点击 Administration > System > Update Center > **Updates Only**

- 如果需要请更新 **Java** 插件

3. 切换到 **Available** 并安装如下插件：

- **Android** （提供 Android lint 规则）

- **Checkstyle**

- **Findbugs**

- **XML**

4. 回到顶部，点击重启完成安装


#### SonarQube 配置: ####

我们已经安装的插件定义了一系列用来评估代码质量的规则。

一个项目只能应用一个配置，但是我们为一个配置指定父配置来继承它，所以我们可以新建一个自定义配置将所有配置串起来，来评价项目。

点击 Quality Profiles > Create 并取个名字（例如 **CustomAndroidProfile**）

添加 Android Lint 作为父配置，然后切换到 **Android Lint** 并将 **FindBugs Security Minimal** 设为父配置，继续设置直到将所有配置串联起来，最后将 **CustomAndroidProfile** 设为默认配置

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*w2CvH8uAOUcvajzjsOoCgQ.png">

继承链


#### 运行 SonarQube 分析: ####

现在 SonarQube 已经配置好，接下来只需要添加 Gradle 任务， **sonarqube**，并在 Jenkins任务的最后一步执行：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*EDAjalNzmdU-ptjhWzuCcQ.png">

添加 sonarqube gradle 任务

再运行一次 Jenkins 任务，任务成功完成后在 localhost:9000 可以看到：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*n7dKdPXyUPj1AZe6ujL3vw.png">

分析结果页面

我们可以通过点击工程名来切换仪表盘，这里面包含了很多内容，其中最重要的是 Issues 部分。

下面的截图显示的是一个被标记为空构造方法的 **major** 问题。对我个人而言，使用 Sonarqube 最大价值是当你点击 period … 后，屏幕下方显示的非常宝贵的学习编程经验和技巧。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*KKM9T2qHzanraAetghYCqg.png">

获得问题的说明


### 第 6 步 —— 其它：配置其它 Android 应用 ###

配置一个 Android 应用获得覆盖统计和 sonarqube 结果，只需要使用 JsCoCo 和 SonarQube 插件就可以了。可以在我的 demo 应用 **HelloJenkins** 中找到详细的配置：

[**pamartineza/helloJenkins**](https://github.com/pamartineza/helloJenkins)

### The end! ###


本文到了该结束的时候！希望能对您有所帮助。如果您发现任何问题或有所疑问不吝赐教，我会尽最大努力帮助您。如果您喜欢本文，麻烦分享一下。

![Markdown](http://i1.piimg.com/1949/7d2d44d03dd76bdc.png)
