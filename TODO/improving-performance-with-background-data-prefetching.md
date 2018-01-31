> * 原文地址：[Improving performance with background data prefetching](https://engineering.instagram.com/improving-performance-with-background-data-prefetching-b191acb39898)
> * 原文作者：[Instagram Engineering](https://engineering.instagram.com/@InstagramEng?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/improving-performance-with-background-data-prefetching.md](https://github.com/xitu/gold-miner/blob/master/TODO/improving-performance-with-background-data-prefetching.md)
> * 译者：[再也不悍跳的阿哲](https://juejin.im/user/5a30a026f265da43070340dd)
> * 校对者：[realYukiko](https://github.com/realYukiko)，[foxxnuaa](https://github.com/foxxnuaa)

# 通过后台数据预获取技术实现性能提升

Instagram 社区变得比从前要更加庞大和多样化。每月有 8 亿人访问 Instagram，其中有 80% 的访问来自美国之外的地方。随着社区的不断扩大，面对多样复杂的网络状况、种类繁多的设备和非传统的使用模式，我们的 app 是否能依旧表现出色，这个问题变得越来越重要。来自纽约的客户端性能优化团队正在致力于使 Instagram 变得更流畅，性能更强大，让来自任何地区的任意用户都能有较好的体验。

具体而言，我们团队的工作重点是在不浪费任何网络和硬盘资源的情况下，做即时的内容分发。最近我们决定着重研发高效的后台数据预获取技术，通过这项技术，可以让 Instagram 在网络不可用或用户流量套餐受限的情况下依然能正常使用。

### 遇到的问题

#### **网络可用性**

![](https://cdn-images-1.medium.com/max/800/1*PBdWAki8iEpmu9td-oZmuQ.png)

世界上大部分地区的网络质量都不容乐观。我们的数据科学家 Michael Midling 绘制出了上方这张地图来表示世界上不同国家地区使用 Instagram 的平均网络带宽。深绿色的区域，比如加拿大，有约 4+Mbps 的带宽。相比较而言，像印度这种浅绿色的区域，就只有 1Mbps 的平均带宽。

当用户打开 Instagram，开始查看分享内容或者滑动浏览 feed 时，我们不能假设这些媒体资源都是可用的。如果你想在印度开发一款流畅的媒体应用，由于他们的网络不够发达且网络传输延迟可能高达 2 秒以上，所以你需要使用不一样的数据加载策略而不是实时加载数据。如果我们希望每个人都能畅通无阻地访问 Instagram，浏览来自亲密的朋友和兴趣列表中的视频和图片，那么我们必须能够应付不同的网络带宽速率。创造能适应所有这些网络情况的应用是一种挑战。

#### **手机网络敏感**

我们的一个解决方案是将用户的网络类型写到我们的日志系统中。这样，我们便可以观察不同网络类型用户的使用情况，来帮助我们适配。我们努力做到适配每个人的数据流量套餐并最大化免费网络连接的数据传输。

![](https://cdn-images-1.medium.com/max/800/1*faugldkdFzZnbSLPJ_QZug.png)

上图展示了全球的用户是通过什么网络来访问我们的应用。比如在印尼，当人们的流量套餐快要用完时，他们会切换 SIM 卡，然后主要使用蜂窝网访问。但是，在巴西，人们大部分时间都是通过 wifi 来访问我们的应用的。

#### **网络连接失败**

![](https://cdn-images-1.medium.com/max/800/1*FbEns6UiItiTeigVAkjLww.png)

如果网络连接全部都失败了会怎么样？之前，我们会将未获取到的图片、视频显示为灰色的方块，希望用户在网络情况变好时回来重试。但是这样体验不好。

![](https://cdn-images-1.medium.com/max/600/1*l3QwYVR5cIdtuRlhqpo3mA.png)

分散的网络连接和蜂窝网络拥塞都是我们关心的问题。当用户处于上方地图中带宽较低的浅绿色区域时，我们需要想出一个办法来减小或消除用户的加载等待时间。

我们的目标是让用户对于网络连接断开无感知，但是对于此并没有找到一个通用的解决方案。为了满足不同网络条件和使用场景下的离线体验，我们提出了如下几种解决方案。

### 解决方案

我们提出了一系列的解决策略。首先，我们将重点放在构建离线模式的用户体验。从中，我们实现了从磁盘获取数据进行内容分发的技术，使得数据就好像是从网络获取的一样。其次，利用这个缓存架构，我们建立了一个中心化的后台数据预获取框架，用预获取的未展现数据来填充该缓存。

#### **离线体验的原则**

通过数据分析和用户调研，我们提出了一些能代表主要痛点和地区的改进原则：

1. 离线是一种状态，而不是错误
2. 离线体验应该是无感知的
3. 通过明确的沟通来建立信任

你可以看到上述原则是如何在下方视频中体现的:

<iframe width="700" height="393" src="https://www.youtube.com/embed/fFH4MSrjcrY" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

#### **应用是否可用与网络无关**

利用存储的请求数据以及图片、视频的缓存，当网络不可用时，我们依旧可以将内容呈现到用户的屏幕上，相当于模仿了一次成功的网络请求。

我们有 3 个主要组件：设备屏幕、组成 HttpRequests 的设备网络层和负责向服务器端发送网络请求的设备网络引擎。

实现了从磁盘中获取数据的技术后，在高速增长的市场下，我们发现用户使用 Instagram 的体验得到了提升。我们认为与其让用户看到白屏和灰色方块，不如让用户能看到之前的内容，这样的体验应该会更好，基于此才决定将网络请求数据缓存到本地。但是，最理想的方案仍然是展现最新的内容。这就是后台数据预获取技术的由来。

### 架构

在 Instagram，有一句工程师口号是“从最简单的做起”，所以第一步并不是做一个完美的后台数据预获取框架。而是，当 app 在后台运行且仅在手机连着 wifi 时去做数据预获取。BackgroundPrefetcher 程序循环遍历任务列表并依次执行。

这样的首个原型程序可以做到：

1. 循环预取各种内容数据
2. 从用户体验的角度去分析向用户呈现最新的媒体内容缓存的实际效果
3. 以此作为基准去评测最终框架（的稳定性）

```
public void registerJob(Runnable job) {
  mBackgroundJobs.add(job);
}
@Override
public void onAppBackgrounded() {
  if (NetworkUtil.isConnectedWifi(AppContext.getContext())) {
    while (!mBackgroundJobs.isEmpty()){   
    mSerialExecutor.execute(mBackgroundJobs.poll());
  }
 }
}
```

现实情况是，apps 是很复杂的，同时用户也是多种多样的！你必须很仔细地分析用户的使用习惯，才能决定到底去预获取什么类型的媒体内容。比如，一些用户会比其他人更加频繁地使用某个功能。

我们的主页包含缤纷多彩的内容，从热门分享到个人分享应有尽有。我们也可以预获取 feed 中的图片和视频、待处理的消息、搜索的内容以及最近的通知。就我们的情况而言，我们决定从简单的开始，只去提前获取你搜索的内容、热门分享和首页 feed。

构建一个可以灵活地适应不同使用场景的中心化架构有利于保持高效且方便扩容。

除了做到在 app 后台运行时，通过我们的框架去调度任务自动预获取数据之外，我们还在 app 的顶部添加了额外的逻辑。将数据预获取逻辑集中到一个点上，让我们能够对其设置规则并验证其是否满足某些条件，比如：

* 控制网络连接类型 -> 不计费的
* 任务停止 -> 如果条件变化或 app 在前台运行，我们要能够停止正在进行的后台数据预获取任务
* 合并请求，在 2 次会话之间找到最佳时间仅做一次数据预获取
* 指标收集 -> 所有的任务完成需要花费多长时间？调度运行后台数据预获取任务的成功率是多少？

#### **工作流**

![](https://cdn-images-1.medium.com/max/800/1*3HPnnJvGFatk5R-nwL942A.png)

让我们来看看后台数据预获取策略在安卓系统上的工作流程：

* 当 main activity 启动时（即 app 在前台运行），我们将 BackgroundWifiPrefetcherScheduler 实例化，同时激活即将被运行的一类任务。
* 这个对象将它自身注册为一个 BackgroundDetectorListener。在上下文中，我们实现了这样的代码结构，每当 app 进入后台运行时都会发送通知，这样我们便可以在 app 进程被杀死前做一些事情（比如将分析数据发送到服务器）。
* 当 BackgroundWifiPrefetcherScheduler 收到通知时，它会调用我们自己写的 AndroidJobScheduler 来对后台数据预获取任务进行调度。JobInfo 参数会被传入，该参数包含了这些信息：需要启动哪些服务以及启动这个任务需要满足哪些条件。

我们的主要条件是延迟和不计费的网络连接。针对 Android 系统，其他一些条件也要被考虑进来，比如省电模式是否开启。我们已经测试了不同程度的延迟，并仍在努力提供个性化的服务体验。现阶段，我们在 2 次会话之间仅做一次后台预获取数据。当 app 进入后台运行时，到底应该在什么时刻运行这个任务，为了找到这个最佳时间，我们计算了用户每次打开会话的平均间隔时间（用户访问 Instagram 的频率是多少？），并使用标准差去除异常值（比如，一个频繁使用 Instagram 的用户的睡眠时间不应该被计算在内）。我们的目标是恰好在平均时间之前开始数据预获取。

* 在这个时间点后，程序会检查网络连接是否满足条件（不计费/wifi）。如果满足，BackgroundPrefetcherJobService 将会启动。如果不满足，BackgroundPrefetcherJobService 的启动会被挂起直到条件满足。（且当手机未处于省电模式下）
* BackgroundService 将创建一个 serialExecutor 通过串行方式运行每一个后台任务。当然，在收到了 http 请求响应后，我们会以异步的方式去预获取媒体数据。
* 在所有任务完成后，我们会向操作系统发送一个通知，告知其我们的进程可以被杀死了，这样一来可以延长内存/电池的使用寿命。在 Android 系统中，杀死这些正在运行的服务是很重要的，使得那些不会再被使用的内存资源得以释放。

所有这些工作都是用户级别的。程序要能够处理用户注销或切换身份的情况。如果用户注销了，我们会停止调度的任务以避免它们做一些没必要的服务启动工作。

#### **IgJobScheduler**

针对安卓，我们具体做了如下几点:

1. 寻找一种高效的后台任务调度方法，让我们能够在会话中将数据持久化并指定网络连接需求。
2. 在 Lollipop（安卓在 2014 年发布的操作系统）之前，Android 的 API 还不支持 JobScheduler 接口，所以我们分析了有多少用户的安卓手机系统是低于此版本的。这是一个我们无法绕过的问题......对于这些用户，我们需要开发一个兼容的版本。
3. 寻找一个适用于低版本安卓系统的现有开源解决方案去调度任务。尽管我们找到了很多优秀的第三方库，但是它们都不适用于我们的场景，因为它们会依赖 Google Play Service。根据现有情况，我们认为 APK 的大小是 Instagram 能维持排行榜第一的主要因素。
4. 最后，我们为 Android JobScheduler APIs 创造了一套可定制的高性能兼容解决方案。

#### **评测**

在 Instagram，我们是数据驱动的，对于我们研发的每个系统，都会严格地评估它的影响。这也就是为什么我们在设计后台数据预获取框架的同时，也会思考应该收集什么样的指标才能得到正确的反馈。

事实是，中心化的架构也有利于收集更高层次的指标。能够准确地评估利弊，知道有多少预获取的数据字节被浪费了或者能分析是什么造成了全局 CPU 的波动，这些都是很重要的。

![](https://cdn-images-1.medium.com/max/800/1*IBawymkWEafmzIQY1y8uNg.png)

我们通过网络请求策略给每个网络请求打上标签来标识其行为和类型，这十分有用。它已经被内置到 app 中了，但是我们利用它来切分我们的指标。我们将请求策略关联到发出的 http 请求上，并标出它是否是预获取数据的请求。另外，请求策略还会给每个网络请求打上类型标签。请求的类型可以为图片、视频、API 和分析数据等等。这可以帮助我们：

* 设置请求优先级
* 通过全局 CPU 使用率曲线、数据使用情况和缓存利用率等这些维度，更好地对系统做分析和权衡

```
/**
 * 网络请求策略中的 Behavior 枚举类描述了被标记的请求返回数据是否需要渲染到屏幕上（比如预获取数据的请求就不需要立刻渲染）
 */
public enum Behavior {
 Undefined(-1),
 OffScreen(0),
 OnScreen(1),
 ;
 int weight;
 Behavior(int weight) {
  this.weight = weight;
 }
}
```

上方展示了 Android 源码中 requestPolicy 类的一部分代码片段。我们将一个请求标注为“on screen”，就意味着用户正在等待该请求的返回数据。有约大于 1% 的 offScreen 的请求返回的数据不会与用户交互。

#### **高效缓存日志**

我们希望知道有多少预获取的字节被真正使用到了，所以我们对缓存中的数据的使用情况做了调研。我们构建了整个缓存日志系统，它满足以下几点：

* 系统可扩展。能支持通过 API 新增缓存实例。
* 系统是健壮的，可以支持容错。能够忍受缓存失效（没有日志记录）或者某些时刻数据不一致的情况。
* 系统是可靠的。在会话之间可以持久化数据。
* 写日志时，使用最小的磁盘空间和最低的延迟。缓存的读/写经常发生，所以我们需要将其开销限制到最小。缓存读/写时的日志记录可能会带来更多的崩溃和更高的延迟。

![](https://cdn-images-1.medium.com/max/800/1*JVMxN09z3NE43Ev8tOvyUQ.png)

我们也想知道，当新增一个后台数据预获取请求时，到底有多少数据被使用了。我们在手机上有一个分层的基础网络引擎，正如之前所说的，每个网络请求都被附加了一个 requestPolicy。这让我们能够很轻松地追踪 app 中的数据使用情况以及观察下载图片、视频和 JSON 数据等到底消耗了多少流量。

同时，我们也想分析对比在 wifi 和蜂窝网下的数据使用分布情况。这使得我们有可能针对不同网络连接尝试不同的数据预获取模式。
 
#### **其他好处**

后台数据预获取技术除了可以消除对网络可用性的依赖以及降低蜂窝网的流量使用，还有什么其他的好处么？如果我们减少了大量的请求，那么我们便降低了整体的网络阻塞。通过合并未来的请求，我们可以节省开销和延长电池寿命。

#### **防止 CPU 曲线波动**

在研发后台数据预处理程序之前，我们就考虑到了它可能造成全局 CPU 使用率升高这一潜在风险。

CPU 使用率怎么会升高呢？请看下面这个例子。假设有一个获取 Instagram 热门 feed 的接口。每次用户 A 打开 Instagram 获取第一页的最新 feed 时，他的设备便会请求一次该接口。这个接口会做一些 CPU 密集型操作，比如排序和根据用户选择的条件进行内容分类。如果在每次用户打开 Instagram 的时候去做后台数据预获取，便会增加 CPU 负载，没错吧？

为了最小化服务端的 CPU 使用率波动，在第一版的后台数据预获取系统中，内容推荐团队的工程师 Fei Huang 为我们新开了一个接口地址。这个接口只获取前20条没有被显示的新分享内容。

### 结论

这是我们构建系统时的工作流程。我们小组不会将 API 开放给其他工程师直到我们能确保框架的质量且用户能从中受益。

随着越来越多的人加入 Instagram，这项工作只会变得越来越重要。我们期望能不断提升 Instagram 的效率和性能，从而使世界各地的人都能畅快无阻地使用 Instagram。

_Lola Priego 是一位来自 Instagram 纽约地区客户端性能优化团队的工程师。_

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
