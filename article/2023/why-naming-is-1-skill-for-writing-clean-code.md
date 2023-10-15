> * 原文地址：[Why Naming is #1 Skill for Writing Clean Code](https://dev.to/wasp/why-naming-is-1-skill-for-writing-clean-code-4a5p)
> * 原文作者：[Martin Šošić](https://dev.to/martinsos)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2023/why-naming-is-1-skill-for-writing-clean-code.md](https://github.com/xitu/gold-miner/blob/master/article/2023/why-naming-is-1-skill-for-writing-clean-code.md)
> * 译者：

In stories, you will often find the motif of a powerful demon that **can be controlled only by knowing its true name**. Once the hero finds out that name, through cunning dialogue or by investigating ancient tomes, they can turn things around and banish the demon!

I firmly believe writing code is not much different: through finding good names for functions, variables, and other constructs, we truly recognize the essence of the problem we are solving. **The consequence of clarity gained is not just good names but also cleaner code and improved architecture**.

[![The power of correct naming in programming](https://res.cloudinary.com/practicaldev/image/fetch/s--V94wO-D0--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/i9egdxs8uo4256ioir3x.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--V94wO-D0--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/i9egdxs8uo4256ioir3x.png)

I would go as far as to say that **90% of writing clean code is “just” naming things correctly**.  
Sounds simple, but it is really not!

Let’s take a look at a couple of examples.

## [](https://dev.to/wasp/why-naming-is-1-skill-for-writing-clean-code-4a5p#example-1)Example #1

```
// Given first and last name of a person, returns the
// demographic statistics for all matching people.
async function demo (a, b) {
  const c = await users(a, b);
  return [
    avg(c.map(a => a.info[0])),
    median(c.map(a => a.info[1]))
  ];
}
```

Enter fullscreen mode Exit fullscreen mode

What is wrong with this code?

1.  The name of the function `demo` is **very vague**: it could stand for “demolish”, or as in “giving a demo/presentation”, … .
2.  Names `a`, `b`, and `c` are **completely uninformative**.
3.  `a` is reused in lambda inside the `map`, **shadowing** the `a` that is a function argument, confusing the reader and making it easier to make a mistake when modifying the code in the future and reference the wrong variable.
4.  The returned object doesn’t have any info about what it contains, instead, **you need to be careful about the order of its elements** when using it later.
5.  The name of the field `.info` in the result of a call to `users()` function gives us **no information as to what it contains**, which is made further worse by its elements being accessed by their position, also hiding any information about them and making our code prone to silently work wrong if their ordering changes.

Let’s fix it:  

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

Enter fullscreen mode Exit fullscreen mode

What did we do?

1.  **The name of the function now exactly reflects what it does, no more no less**. `fetch` in the name even indicates it does some IO (input/output, in this case fetching from the database), which can be good to know since IO is relatively slow/expensive compared to pure code.
2.  **We made other names informative enough**: not too much, not too little.
    -   Notice how **we used the name `users` for fetched users**, and not something longer like `usersWithSpecifiedFirstAndLastName` or `fetchedUsers`: there is no need for a longer name, as this variable is very local, short-lived, and there is enough context around it to make it clear what it is about.
    -   **Inside lambda, we went with a single-letter name**, `u`, which might seem like bad practice. But, here, it is perfect: this variable is extremely short-lived, and it is clear from context what it stands for. Also, we picked specifically the letter `u` for a reason, as it is the first letter of `user`, therefore making that connection obvious.
3.  **We named values in the object that we return**: `averageAge` and `medianSalary`. Now any code that will use our function won’t need to rely on the ordering of items in the result, and also will be easy and informative to read.

Finally, notice how there is no comment above the function anymore. The thing is, **the comment is not needed anymore**: it is all clear from the function name and arguments!

## [](https://dev.to/wasp/why-naming-is-1-skill-for-writing-clean-code-4a5p#example-2)Example 2

```
// Find a free machine and use it, or create a new machine
// if needed. Then on that machine, set up the new worker 
// with the given Docker image and setup cmd. Finally,
// start executing a job on that worker and return its id.
async function getJobId (
  machineType, machineRegion,
  workerDockerImage, workerSetupCmd,
  jobDescription
) {
  ...
}
```

Enter fullscreen mode Exit fullscreen mode

In this example, we are ignoring the implementation details and will focus just on getting the name and arguments right.

What is wrong with this code?

1.  **The function name is hiding a lot of details about what it is doing**. It doesn’t mention at all that we have to procure the machine or set up the worker, or that function will result in the creation of a job that will continue executing somewhere in the background. Instead, it gives a feeling that we are doing something simple, due to the verb `get`: we are just obtaining an id of an already existing job. Imagine seeing a call to this function somewhere in the code: `getJobId(...)` → **you are not expecting it to take long or do all of the stuff that it really does, which is bad**.

Ok, this sounds easy to fix, let’s give it a better name!  

```
async function procureFreeMachineAndSetUpTheDockerWorkerThenStartExecutingTheJob (
  machineType, machineRegion,
  workerDockerImage, workerSetupCmd,
  jobDescription
) {
  ...
}
```

Enter fullscreen mode Exit fullscreen mode

**Uff, that is one long and complicated name**. But the truth is, that we can’t really make it shorter without losing valuable information about what this function does and what we can expect from it. Therefore, **we are stuck**, we can’t find a better name! What now?

The thing is, **you can't give a good name if you don't have clean code behind it**. So a bad name is not just a naming mishap, but often also an indicator of problematic code behind it, a failure in design. Code so problematic, that you don’t even know what to name it → there is no straightforward name to give to it, because it is not a straightforward code!

[![Bad name is hiding bad code](https://res.cloudinary.com/practicaldev/image/fetch/s--PHgCAaqW--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/asuebjrs1mwtnrk2jdw4.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--PHgCAaqW--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/asuebjrs1mwtnrk2jdw4.png)

In our case, the problem is that this **function is trying to do too much at once**. A long name and many arguments are indicators of this, although these can be okay in some situations. Stronger indicators are the usage of words “and” and “then” in the name, as well as argument names that can be grouped by prefixes (`machine`, `worker`).

The solution here is to clean up the code by breaking down the function into multiple smaller functions:  

```
async function procureFreeMachine (type, region) { ... }
async function setUpDockerWorker (machineId, dockerImage, setupCmd) { ... }
async function startExecutingJob (workerId, jobDescription) { ... }
```

Enter fullscreen mode Exit fullscreen mode

## [](https://dev.to/wasp/why-naming-is-1-skill-for-writing-clean-code-4a5p#what-is-a-good-name)What is a good name?

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

## [](https://dev.to/wasp/why-naming-is-1-skill-for-writing-clean-code-4a5p#support-us-%EF%B8%8F)Support us! 🙏⭐️

![GH star click](https://res.cloudinary.com/practicaldev/image/fetch/s--V5AGmRxg--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/id9s6t8rcvfxty40bv2m.gif)

To help us improve our name at Wasp-lang 😁, [consider giving us a star on Github](https://github.com/wasp-lang/wasp)! Everything we do at Wasp is open source, and your support helps us make web development easier and motivates us to write more articles like this one.

![Image description](https://res.cloudinary.com/practicaldev/image/fetch/s--xlfkBbiL--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/qgbmn45pia04bxt6zf83.gif)

## [](https://dev.to/wasp/why-naming-is-1-skill-for-writing-clean-code-4a5p#how-to-come-up-with-a-good-name)How to come up with a good name

## [](https://dev.to/wasp/why-naming-is-1-skill-for-writing-clean-code-4a5p#dont-give-a-name-find-it)Don’t give a name, find it

The best advice is maybe not to give a name, but instead to **find out** a name. You shouldn’t be making up an original name, as if you are naming a pet or a child; **you are instead looking for the essence of the thing you are naming, and the name should present itself based on it**. If you don’t like the name you discovered, it means you don’t like the thing you are naming, and you should change that thing by improving the design of your code (as we did in the example #2).

[![You shouldn't name your variables the same way you name your pets, and vice versa](https://res.cloudinary.com/practicaldev/image/fetch/s--6nM5W6XW--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/svd322vp7ho9holekwbp.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--6nM5W6XW--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/svd322vp7ho9holekwbp.png)

## [](https://dev.to/wasp/why-naming-is-1-skill-for-writing-clean-code-4a5p#things-to-look-out-for-when-figuring-out-a-name)Things to look out for when figuring out a name

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

## [](https://dev.to/wasp/why-naming-is-1-skill-for-writing-clean-code-4a5p#further-reading)Further reading

If you haven’t yet read it, I would recommend reading the book **Clean Code by Robert Martin**. It has a great chapter on naming and also goes much further on how to write code that you and others will enjoy reading and maintaining.

Also, [A popular joke about naming being hard](https://martinfowler.com/bliki/TwoHardThings.html).

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。