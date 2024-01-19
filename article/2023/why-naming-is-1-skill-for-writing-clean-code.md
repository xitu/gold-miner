> * 原文地址：[Why Naming is #1 Skill for Writing Clean Code](https://dev.to/wasp/why-naming-is-1-skill-for-writing-clean-code-4a5p)
> * 原文作者：[Martin Šošić](https://dev.to/martinsos)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2023/why-naming-is-1-skill-for-writing-clean-code.md](https://github.com/xitu/gold-miner/blob/master/article/2023/why-naming-is-1-skill-for-writing-clean-code.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)

在童话故事中，我们常常可以看到这么一个设定：**只要知道了恶魔的真名，我们便可以控制它**。无论是通过调查古籍还是巧妙的对话诱骗恶魔，一旦主角找到了这个名字，他便可以扭转局面，赶走恶魔！

我始终相信，写代码也亦是如此：只要我们能够为函数、变量和结构体找到好的名称，我们就能真正认识到我们在解决的问题的本质。**清晰之道不仅反映出好的名称，还有更整洁的代码和更稳健的架构。**

![命名在编程中的重要性](https://res.cloudinary.com/practicaldev/image/fetch/s--V94wO-D0--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/i9egdxs8uo4256ioir3x.png)

我甚至可以说，**要想写好整洁的代码，仅仅是取好名称就已完成 90% 了**。

这听起来很简单，但其实并不容易！

让我们看看几个例子。

## 例 #1

```javascript
// 传入名和姓，
// 返回所有匹配人员的人口统计（demography）数据。
async function demo (a, b) {
  const c = await users(a, b);
  return [
    avg(c.map(a => a.info[0])),
    median(c.map(a => a.info[1]))
  ];
}
```

这段代码有什么问题？

1.  函数名称 `demo` 的语义**非常模糊**：它可以表示“拆除（demolish）”，或者“演示（demonstration）”等等。
2.  变量名称 `a`、`b` 和 `c` **完全不能提供任何信息**。
3.  `map` 中的匿名函数重复使用了名称 `a`，**遮蔽（shadowing）​**了作为函数参数的 `a`，使读者感到困惑，并可能导致我们在未来修改代码时引用错误的变量。
4.  返回的数组并不能提供它的内容信息，相反地，**在使用时需小心元素的排列顺序**。
5.  `.info` 字段这个名称也**不能告诉我们任何有关其内容的信息**。更糟糕的是，由于我们是通过下标访问元素，如果它们的顺序有所变更，我们的代码将更倾向于在不被发现的情况下错误运行。

让我们修改一下：

```javascript
async function fetchDemographicStatsForFirstAndLastName (
  firstName, lastName
) {
  const users = await fetchUsersByFirstAndLastName(
    firstName, lastName
  );
  return {
    averageAge: avg(users.map(u => u.stats.age)),
    medianSalary: median(users.map(u => u.stats.salary))
  };
}
```

我们做了什么？

1.  **函数的名称准确的反映了其功能。​**名称中的 `fetch` 表示执行了 I/O 操作（从数据库中获取记录）。这个信息是值得被告知的，因为 I/O 操作较为昂贵，比起一般代码花费更多时间。
2.  **我们为其他名称提供了足够的信息**：不多不少，正好。
    -   **我们使用 `users` 来表示取到的用户**，而不是像 `usersWithSpecifiedFirstAndLastName` 或者 `fetchedUsers` 这样更长的名称：这是因为这个变量是局部的，存活时间很短，且上下文能清楚地表明这个变量是关于什么的。
    -   **在匿名函数中，我们使用了一个单字母的名称**，`u`。你可能觉得这做法并不好，但是，在这里，这并没什么问题：这个变量的存活时间非常短暂，并且从上下文中我们能很清楚地知道它代表什么。此外，我们也特意选择了字母“u”，因为它是“user”的首字母，使得这种联系更加显而易见。
3.  **我们在返回的的对象中命名了其包含的值**：`averageAge` 和 `medianSalary`。现在，任何使用我们的函数的代码都不需要依赖返回结果中项目顺序，提高了可读性。

最后，留意到这次我们已经不写注释了吗？**我们不需要注释了**：函数的名称和参数已非常简洁明了！

## 例 #2

```javascript
// 找到一个闲置 machine，如无则创建一个。
// 在该 machine 上，根据给定的 Docker 镜像配置新的 worker 和 CMD。
// 最后，在 worker 上开始执行任务并返回其 ID。
async function getJobId (
  machineType, machineRegion,
  workerDockerImage, workerSetupCmd,
  jobDescription
) {
  ...
}
```

在此示例中，我们忽略具体的实现细节，仅关注名称和参数。

这个代码有什么问题？

1.  **这个函数名称隐藏了许多具体操作的细节。​**它并没有说明它可能创建 machine 和 worker。它也没有说明该功能可能会创建一项任务并在后台运行。相反，由于动词“get”，它给人一种这件事很简单的感觉：我们只是获取一个已经存在的任务的 ID。想象一下在代码中的某个地方看到对此函数的调用：`getJobId(...)` → **你应该预料不到它会花费很长的时间，也不了解它具体干了什么，这是件很糟糕的事**。

好吧，这似乎很容易解决，让我们给它起一个更好的名字吧！

```javascript
async function procureFreeMachineAndSetUpTheDockerWorkerThenStartExecutingTheJob (
  machineType, machineRegion,
  workerDockerImage, workerSetupCmd,
  jobDescription
) {
  ...
}
```

**呃，这是一个又长又复杂的名字……​**但是，如果我们缩短这个函数名，那么就会丢失关于这个函数的实际操作和有用的信息。**进退两难**，我们找不到一个更好的名称！现在又该怎么办？

问题在于，**如果代码不够清晰，那又如何能给出一个好的名称呢**？因此，一个糟糕的名字不仅仅是命名失误，而且通常也表明其背后的代码有问题，是设计上的失败。代码存在问题，以至于你甚至不知道如何命名 → 我们找不到一个直接的名字，因为这不是一段直接的代码！

![糟糕的名称隐藏着糟糕的代码](https://res.cloudinary.com/practicaldev/image/fetch/s--PHgCAaqW--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/asuebjrs1mwtnrk2jdw4.png)

在这个例子中，问题来源于这个**函数一次做太多件事了**。冗长的函数名是一个很好的信号（在一些情况中这是 OK 的）。此外，名称中的“and”和“then”，还有参数的前缀（“machine”和“worker”）都暗示了这点。

解决方案是，将函数分解为多个较小的函数：

```javascript
async function procureFreeMachine (type, region) { ... }
async function setUpDockerWorker (machineId, dockerImage, setupCmd) { ... }
async function startExecutingJob (workerId, jobDescription) { ... }
```

## 怎么才算是一个好的名称？

让我们退一步来说，什么是坏名称，什么是好名称？我们又该如何分辨？

**好名字不误导、不遗漏、不假设。**

一个好的名称应该能让你更好地了解变量所包含的内容或函数的作用。一个好的名称会告诉你所有需要知道的事情，或者会告诉你足够多的信息，让你知道下一步该关注什么。它不会让你猜测或感到疑惑，更不会误导你。一个好的名字是显而易见的，是意料之内的，是统一的，不会太过“创意”。它也不会假设读者不可能拥有的背景或知识。

此外，在没有阅读上下文的情况下是无法评估一个名称的好坏的。`verifyOrganizationChainCredentials` 可以是一个糟糕的名称，也可以是一个很好的名称。`a` 可以是一个糟糕的名称，也可以是一个很好的名称。这取决于“故事”、环境以及代码要解决的问题。名字讲述一个故事，它们需要像故事一样组合在一起。

## 一些著名的糟糕名称

-   **JavaScript**
    -   我就是这个糟糕的名字的受害者：当我想学习 Java 时，我的父母给我买了一本关于 JavaScript 的书。
-   **HTTP Authorization 请求标头**
    -   虽然称为 `Authorization`（授权）但却用于身份验证（authentication）！二者有别：身份验证是关于识别你的身份，而授权是关于授予权限。更多内容请看：[https://stackoverflow.com/questions/30062024/why-is-the-http-header-for-authentication-called-authorization](https://stackoverflow.com/questions/30062024/why-is-the-http-header-for-authentication-called-authorization) .
-   **Wasp-lang**:
    -   这是我的错：[Wasp](https://wasp-lang.dev/) 是一个全栈的 JavaScript Web 框架。它使用了自定义配置语言作为其代码库的一小部分，但我在名称中添加了 `-lang`。这吓跑了很多人，因为他们认为这是一种全新的通用编程语言！

## 如何取一个好名字？

### 不要起名字，而是"找出"一个名字

最好的建议是，不要起名字，而是**找出**一个名字。你不应该像给宠物或孩子命名一样随意起一个自己的名字；相反，**你应寻找你所命名的事物的本质，并且名称应该基于此来呈现**。如果你不喜欢你找到的名称，则意味着你不喜欢你所命名的事物，并且你应该通过改进代码的设计来更改该名称（就像我们在例 #2 中所做的那样）。

![你不应该像给宠物命名一样命名你的变量，反之亦然](https://res.cloudinary.com/practicaldev/image/fetch/s--6nM5W6XW--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/svd322vp7ho9holekwbp.png)

### 起名时应考虑的事项

1.  **首先，确保这不是一个糟糕的名字 :)**。记得：不误导、不遗漏、不假设。
2.  **确保名称表示它所代表的内容。​**找到它的本质，在名称中反映出来。名称还是很丑吗？改进代码。你也可以善用类型签名和注释，当然这些都是次要的。
3.  **让名称与周围融合。​**它应该与其他名称有明确的关系，即，在同一个“世界”里。它应该与相似的事物相似，与相反的事物相反。它应该与周围的其他名称组成一个“故事”，应考虑它所处的上下文。
4.  **名称长度遵循变量的作用范围。​**一般来说，变量的寿命越短，范围越小，名称也可（应）以（该）越短，反之亦然。这就是为什么在简短的匿名函数中可以使用单字母变量名称。如果不确定，请选择较长的名称。
5.  **贯彻你在代码库中使用的术语。​**如果你一直以来使用的术语是 `server` 请不要混用 `backend`。此外，如果你使用了 `server` 一词，你或许不应该使用 `frontend`。`client` 与 `server` 更相关。
6.  **贯彻你在代码库中的使用的约定。​**举例来说，以下是我在代码库中的一些常用约定：
    -   当变量是布尔值是添加前缀 `is`（例：`isAuthEnabled`）
    -   为幂等函数添加前缀 `ensure` (例：`ensureServerIsRunning`)；这一类函数只有在尚未设置情况下才会执行操作（如分配资源），不会重复执行操作。

### 命名的技巧

如果你在起名字时遇到困难，请执行以下操作：

1.  在函数/变量上方写下注释，**用人类语言描述它是什么**，就像你向同事描述它一样。它可以是一个句子，也可以是多个句子。这就是函数/变量的本质，它是什么。
2.  现在，你是个雕刻家，通过将这些描述一块一块凿掉，塑造成一个函数/变量名称。当你觉得你的的“凿子”再敲击一下就会带走太多东西时，你就应该停下来了。
3.  你的名称还是太令人困惑吗？如果是这样，那就说明后面的代码太复杂了，你应该重新整理一下！**去重构代码吧。**
4.  **OK，全部完成** → 你有一个很好的名称了！
5.  函数/变量上方的注释呢？把一切能从名称 + 参数 + 类型签名中反映出来的东西删掉。此时，如果你可以删除整个注释那就太好了。但有时你不能，因为有些东西无法在名称中捕获（例如某些假设、解释、示例……），但这也没关系。但不要在注释中重复你可以在名称中表达的事物。**有时候，注释是不得不写的，它可以捕获你在名称和类型中不能传达的信息。**

不要过分执着于在一开始就找出完美的名称 → 你可以对代码进行多次迭代，每次迭代都会改进你的代码和名称。

## 在考虑命名的情况下审查代码

一旦你开始深入思索命名的问题，你将见识到它如何改变你的代码审查过程：焦点从查看实现细节转移到首先查看名称。

**当我进行代码审查时，我的主要想法是：“这个名字清楚吗？”​**从这开始，整个审查不断发展并导向整洁的代码。

检查名称是一个单一的压力点，它可以解开其背后的整个混乱局面。寻找糟糕的名字，如果存在，你迟早会发现糟糕的代码。

## 延伸阅读

我推荐 **Robert Martin 的《代码整洁之道》**。其中命名一章非常精彩，并且还进一步介绍了如何编写易于阅读和维护的代码。

最后的最后，[一个关于命名困难的笑话](https://martinfowler.com/bliki/TwoHardThings.html)。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。