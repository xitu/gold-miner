> * 原文地址：[Why Naming is #1 Skill for Writing Clean Code](https://dev.to/wasp/why-naming-is-1-skill-for-writing-clean-code-4a5p)
> * 原文作者：[Martin Šošić](https://dev.to/martinsos)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2023/why-naming-is-1-skill-for-writing-clean-code.md](https://github.com/xitu/gold-miner/blob/master/article/2023/why-naming-is-1-skill-for-writing-clean-code.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：

在童话故事中，我们常常可以看到这么一个设定：**只要知道了恶魔的真名，我们便可以控制它**。无论是通过调查古籍还是巧妙的对话诱骗恶魔，一旦主角找到了这个名字，他便可以扭转局面，赶走恶魔！

我始终相信，写代码也亦是如此：只要我们能够为函数、变量和结构体找到好的名称，我们就能真正认识到问题的本质。**清晰之道不仅反映出好的名称，还有更整洁的代码和更稳健的架构。**

![取名在编程中的重要性](https://res.cloudinary.com/practicaldev/image/fetch/s--V94wO-D0--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/i9egdxs8uo4256ioir3x.png)

我甚至可以说，**要想写好整洁的代码，仅仅是取好名称就已完成 90% 了。**

这听起来很简单，但其实并不容易！

让我们看看几个例子。

## 例 #1

```
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

这个代码有什么问题？

1.  函数名称 `demo` 的语义**非常模糊**：它可以表示“拆除（demolish）”，或者“演示（demonstration）”等等。
2.  变量名称 `a`、`b` 和 `c` **完全不能提供任何信息**。
3.  `map` 中的匿名函数重复使用了名称 `a`, **遮蔽（shadowing）**了作为函数参数的 `a`，使读者感到困惑，并可能导致我们在未来修改代码时引用错误的变量。
4.  返回的数组并不能提供它的内容信息，相反地，**在使用时需小心元素的排列顺序**。
5.  `.info` 字段这个名称也**不能告诉我们任何有关其内容的信息**。更糟糕的是，由于我们是通过下标访问元素，如果他们的顺序发生变化，我们的代码将会在毫无征兆下出错。

让我们修改一下：

```
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

1.  **函数的名称准确的反映了其功能。**名称中的 `fetch` 表示执行了 I/O 操作（从数据库中获取记录）。这个信息是值得被告知的，因为 I/O 操作较为昂贵，比起一般代码花费更多时间。
2.  **我们为其他名称提供了足够的信息**：不多不少，正好。
    -   **我们使用 `users` 来表示取到的用户**，而不是像 `usersWithSpecifiedFirstAndLastName` 或者 `fetchedUsers` 这样更长的名称：这是因为这个变量是局部的，存活时间很短，且上下文能清楚地表明这个变量是关于什么的。
    -   **在匿名函数中，我们使用了一个单字母的名称**，`u`。你可能觉得这做法并不好，但是，在这里，这并没什么问题：这个变量的存活时间非常短暂，并且从上下文中我们能很清楚地知道它代表什么。此外，我们也特意选择了字母“u”，因为它是“user”的首字母，使得这种联系更加显而易见。
3.  **我们在返回的的对象中命名了其包含的值**：`averageAge` 和 `medianSalary`。现在，任何使用我们的函数的代码都不需要依赖返回结果中项目顺序，提高了可读性。

最后，留意到这次我们已经不写注释了吗？**我们不需要注释了**：函数的名称和参数已非常简洁明了！

## 例 #2

```
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

1.  **这个函数名称隐藏了许多具体操作的细节。**它并没有说明它可能创建 machine 和 worker。它也没有说明该功能可能会创建一项任务并在后台运行。相反，由于动词“get”，它给人一种这件事很简单的感觉：我们只是获取一个已经存在的任务的 ID。想象一下在代码中的某个地方看到对此函数的调用：`getJobId(...)` → **你应该预料不到它会花费很长的时间，也不了解它具体干了什么，这是件很糟糕的事**。

好吧，这似乎很容易解决，让我们给它起一个更好的名字吧！

```
async function procureFreeMachineAndSetUpTheDockerWorkerThenStartExecutingTheJob (
  machineType, machineRegion,
  workerDockerImage, workerSetupCmd,
  jobDescription
) {
  ...
}
```

**呃，这是一个又长又复杂的名字……**但是，如果我们缩短这个函数名，那么就会丢失关于这个函数的实际操作和有用的信息。**进退两难**，我们找不到一个更好的名称！现在又该怎么办？

问题在于，**如果代码不够清晰，那又如何能给出一个好的名称呢**？因此，一个糟糕的名字不仅仅是命名失误，而且通常也表明其背后的代码有问题，是设计上的失败。代码存在问题，以至于你甚至不知道如何命名 → 我们找不到一个直接的名字，因为这不是一段直接的代码！

![糟糕的名称隐藏着糟糕的代码](https://res.cloudinary.com/practicaldev/image/fetch/s--PHgCAaqW--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/asuebjrs1mwtnrk2jdw4.png)

在这个例子中，问题来源于这个**函数一次做太多件事了**。冗长的函数名是一个很好的信号（在一些情况中这是 OK 的）。此外，名称中的“and”和“then”，还有参数的前缀（“machine”和“worker”）都暗示了这点。

解决方案是，将函数分解为多个较小的函数：

```
async function procureFreeMachine (type, region) { ... }
async function setUpDockerWorker (machineId, dockerImage, setupCmd) { ... }
async function startExecutingJob (workerId, jobDescription) { ... }
```

## 怎么才算是一个好的名称？

But let’s take a step back - what is a bad name, and what is a good name? What does that mean, how do we recognize them?

**Good name doesn’t misdirect, doesn’t omit, and doesn’t assume**.

A good name should give you a good idea about what the variable contains or function does. A good name will tell you all there is to know or will tell you enough to know where to look next. It will not let you guess, or wonder. It will not misguide you. A good name is obvious, and expected. It is consistent. Not overly creative. It will not assume context or knowledge that the reader is not likely to have.

Also, **context is king:** you can’t evaluate the name without the context in which it is read. `verifyOrganizationChainCredentials` could be a terrible name or a great name. `a` could be a great name or a terrible name. It depends on the story, the surroundings, on the problem the code is solving. Names tell a story, and they need to fit together like a story.

## [](https://dev.to/wasp/why-naming-is-1-skill-for-writing-clean-code-4a5p#examples-of-famous-bad-names)Examples of famous bad names

-   **JavaScript**
    -   I was the victim of this bad naming myself: my parents bought me a book about JavaScript while I wanted to learn Java.
-   **HTTP Authorization header**
    -   It is named `Authorization`, but is used for authentication! And those are not the same: authentication is about identifying yourself, and authorization is about granting permissions. More about it can be found here: [https://stackoverflow.com/questions/30062024/why-is-the-http-header-for-authentication-called-authorization](https://stackoverflow.com/questions/30062024/why-is-the-http-header-for-authentication-called-authorization) .
-   **Wasp-lang**:
    -   This one is my fault: [Wasp](https://wasp-lang.dev/) is a full-stack JS web framework that uses a custom config language as only a small part of its codebase, but I put `-lang` in the name and scared a lot of people away because they thought it was a whole new general programming language!

## 如何取一个好名字？

## Don’t give a name, find it

The best advice is maybe not to give a name, but instead to **find out** a name. You shouldn’t be making up an original name, as if you are naming a pet or a child; **you are instead looking for the essence of the thing you are naming, and the name should present itself based on it**. If you don’t like the name you discovered, it means you don’t like the thing you are naming, and you should change that thing by improving the design of your code (as we did in the example #2).

[![You shouldn't name your variables the same way you name your pets, and vice versa](https://res.cloudinary.com/practicaldev/image/fetch/s--6nM5W6XW--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/svd322vp7ho9holekwbp.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--6nM5W6XW--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/svd322vp7ho9holekwbp.png)

## 起名时应考虑的事项

1.  **First, make sure it is not a bad name :)**. Remember: don’t misdirect, don’t omit, don’t assume.
2.  **Make it reflect what it represents.** Find the essence of it, capture it in the name. Name is still ugly? Improve the code. You have also other things to help you here → type signature, and comments. But those come secondary.
3.  **Make it play nicely with the other names around it.** It should have a clear relation to them - be in the same “world”. It should be similar to similar stuff, opposite to opposite stuff. It should make a story together with other names around it. It should take into account the context it is in.
4.  **Length follows the scope**. In general, the shorter-lived the name is, and the smaller its scope is, the shorter the name can/should be, and vice versa. This is why it can be ok to use one-letter variables in short lambda functions. If not sure, go for the longer name.
5.  **Stick to the terminology you use in the codebase**. If you so far used the term `server`, don’t for no reason start using the term `backend` instead. Also, if you use `server` as a term, you likely shouldn't go with `frontend`: instead, you will likely want to use `client`, which is a term more closely related to the `server`.
6.  **Stick to the conventions you use in the codebase**. Examples of some of the conventions that I often use in my codebases:
    -   prefix `is` when the variable is Bool (e.g. `isAuthEnabled`)
    -   prefix `ensure` for the functions that are idempotent, that will do something (e.g allocate a resource) only if it hasn’t been set up so far (e.g. `ensureServerIsRunning`).

## [](https://dev.to/wasp/why-naming-is-1-skill-for-writing-clean-code-4a5p#the-simple-technique-for-figuring-out-a-name-every-time)The simple technique for figuring out a name every time

If you are ever having trouble coming up with a name, do the following:

1.  Write a comment above the function/variable where you **describe what it is, in human language**, as if you were describing it to your colleague. It might be one sentence or multiple sentences. This is the essence of what your function/variable does, what it is.
2.  Now, you take the role of the sculptor, and you chisel at and **shape that description of your function/variable until you get a name**, by taking pieces of it away. You stop when you feel that one more hit of your imagined chisel at it would take too much away.
3.  Is your name still too complex/confusing? If that is so, that means that the code behind is too complex, and should be reorganized! **Go refactor it**.
4.  **Ok, all done** → you have a nice name!
5.  That comment above the function/variable? Remove everything from it that is now captured in the name + arguments + type signature. If you can remove the whole comment, great. Sometimes you can’t, because some stuff can’t be captured in the name (e.g. certain assumptions, explanations, examples, …), and that is also okay. But don’t repeat in the comment what you can say in the name instead. **Comments are a necessary evil and are here to capture knowledge that you can’t capture in your names and/or types**.

Don’t get overly stuck on always figuring out the perfect name at the get-go → it is okay to do multiple iterations of your code, with both your code and name improving with each iteration.

## [](https://dev.to/wasp/why-naming-is-1-skill-for-writing-clean-code-4a5p#reviewing-code-with-naming-in-mind)Reviewing code with naming in mind

Once you start thinking a lot about naming, you will see how it will change your code review process: focus shifts from looking at implementation details to looking at names first.

**When I am doing a code review, there is one predominant thought I will be thinking about: “Is this name clear?”**. From there, the whole review evolves and results in clean code.

Inspecting a name is a single point of pressure, that untangles the whole mess behind it. Search for bad names, and you will sooner or later uncover the bad code if there is some.

## 增广

我推荐 Robert Martin 的《代码整洁之道》If you haven’t yet read it, I would recommend reading the book **Clean Code by Robert Martin**. It has a great chapter on naming and also goes much further on how to write code that you and others will enjoy reading and maintaining.

Also, [A popular joke about naming being hard](https://martinfowler.com/bliki/TwoHardThings.html).

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。