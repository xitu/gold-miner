> * 原文地址：[Why You Should Make Your Code as Simple as Possible](https://medium.com/better-programming/why-you-should-make-your-code-as-simple-as-possible-3b35e89f137)
> * 原文作者：[Dr. Derek Austin 🥳](https://medium.com/@DoctorDerek)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/why-you-should-make-your-code-as-simple-as-possible.md](https://github.com/xitu/gold-miner/blob/master/article/2020/why-you-should-make-your-code-as-simple-as-possible.md)
> * 译者：
> * 校对者：

# Why You Should Make Your Code as Simple as Possible

#### You’ll program faster if you try to make your code simple, even repetitive, when you first write it

![Photo by [Simon Berger](https://unsplash.com/@8moments?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/wallpapers/design/simple?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/7844/1*Fe3m631Fw9jUsAPM7rTu0g.jpeg)

Programming is a lot like writing — you should start with a “[bad first draft](https://medium.com/@jeffgoins/dont-waste-your-words-how-to-write-a-first-draft-that-is-crappy-but-usable-c5dbf977f5a5)” that solves the problem, then immediately edit it two or three times before you move on to the next problem.

Engineers scoff at being compared to measly “writers” — but who wrote the documentation that you used earlier today? And don’t you “write code?”

Software developers have the luxury of working in the most creative type of engineering. After all, software engineers get to call a lot more shots when building an app than civil engineers do when building a bridge.

Working in a creative profession means that you can learn a great deal from writers whose words will never execute. And one of the best pieces of writing advice is something typically recommended to solve writer’s block.

Let me introduce you to the “bad first draft” — because it will make you a much faster coder than ever before.

---

## The “Bad First Draft” Method

The idea of a “bad first draft” is so commonplace that you’ve probably heard about it at some point in an English class even if you’ve never gone down the rabbit hole of internet bloggers offering tips about writer’s block.

The idea of a “bad first draft” is that you just need to finish the first draft even if it completely sucks — because any first draft is better than a blank page.

Editing your own work is easier than writing from scratch, so you need to try to write something (anything!), right now. Just make the code work.

To put it another way, would you rather have written 100 lines of bad code (that works) or zero lines of perfect code by lunch today?

Sure, at the end of the day, you may still end up with 50 lines of perfect code either way. But there’s a psychological advantage to writing a “bad first draft:” **you’ll feel more successful with less stress.**

**You’ll write code and have fun doing it!** What beats that?

---

## How I Approach First Drafts

I prefer to think that I should aim to start with a “simple first draft” because a “bad first draft” seems to carry a negative judgment about my abilities.

Do you want to be a “bad programmer” writing “bad code” because you read a tip about writing a “bad first draft”?

No, you want to be a “successful programmer” writing “great code” because you are following this tip about starting with a “simple first draft.”

If you’ve ever copied a code sample and then tweaked it for your own use, then you’ve actually already done the “simple first draft.”

When using a code sample, you inevitably change things quite a bit, but the key is to get it working first and then immediately improve upon it.

You can use the concept of a “simple first draft” to complete any programming task — whether you’re brand new to coding or already an expert.

---

## Why the “Simple First Draft” Works

When you write code that works, you feel successful, which puts you in a better mindset. Simple code is more likely to work the first time.

Plus, simple code is straightforward to write, saving you time. Yes, it may feel repetitious, and the clever part of your brain is going to be begging you for a “better” solution with greater micro-performance in fewer lines of code.

**Ignore it.**

The trick is to sip a beverage when you get those feelings, then forge ahead in the pursuit of simplicity. Once the code works, you’re going to refactor it right away — and you can be as clever as you want once you have a working copy. But until you get there, keep things as simple as possible.

Writing coach [August Birch](undefined) calls this “[leapfrog writing](https://medium.com/@augustbirch/why-writing-crappy-first-drafts-is-terrible-advice-fa5d7f53cdd):” Write the whole thing, then edit it immediately. You alternate writing and editing.

Here’s where programming differs from writing, though: Developers know when the first draft is “good enough” because the code executes successfully. When your code works, that’s your cue to immediately edit your “simple first draft,” polishing it up a few times before you move on.

For anyone just learning to code, this approach improves two crucial skills: writing code that works, and improving existing code without breaking it.

---

## A Code Example

I was recently mentoring a junior engineer via LinkedIn, and he was struggling with an overly-complicated coding challenge. While such coding challenges become less useful once you have real projects to work on, they’re a great example of how to write a “simple first draft.”

Since the problem was complicated, he tried to write a complicated solution. Let’s take a look at the challenge:

> “Write a function `addWeirdStuff`, which adds the sum of all the odd numbers in `arrayTwo` to each element under 10 in `arrayOne`.
>
> Similarly, `addWeirdStuff` should also add the sum of all the even numbers in `arrayTwo` to those elements 10 or greater in `arrayOne`.
>
> Bonus: If any element in `arrayTwo` is greater than 20, add 1 to every element in `arrayOne`.”

Note that, just like in real life, he got incomplete instructions: The function `addWeirdStuff` is supposed to return a new array containing the items from `arrayOne` followed by the items from `arrayTwo`.

He initially tried to solve it with a single `[for](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for)` loop, which was setting himself up for failure. That’s a complex cognitive task guaranteed to challenge your working memory, and he was getting nowhere with it.

This particular individual had contacted me previously for help with another coding challenge where he’d accidentally put the return statement into the body of a complex `[for](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for)` loop. He’s not ready to write concise code just yet.

I told him that he needed to use two separate `[for](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for)` loops and that he should make them `[for…of](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for...of)` loops for simplicity’s sake. Here’s the JavaScript code, including the tests he was given to check if the code works:

![[View the raw code](https://gist.github.com/djD-REK/9c0ac6c85465c28c8e1d800436c89cf0) as a GitHub gist](https://cdn-images-1.medium.com/max/3004/1*-ALV_1zyyKAnmKUr1ekiIg.png)

It’s ugly, and it performs poorly, but it works! And it’s super-readable, especially for a brand-new coder struggling with basic concepts.

The next step is to polish up this “simple first draft.”

---

## Time to Refactor

Refactoring, love it or hate it, is better known to writers as the editing process. In both programming and other types of writing, editing is easier when you’ve written the text yourself, especially when done right away.

Use simple language in order to reduce the complexity of the text at first, and then edit immediately. It works for all types of writing, including coding.

Taking our “simple first draft” from above, I refactored to the following:

![[View the raw code](https://gist.github.com/djD-REK/a6c16202a8d2a441f1f750f883853476) as a GitHub gist](https://cdn-images-1.medium.com/max/3180/1*eVSyFkneW5d9joK4ytU2Zw.png)

This is still a challenging problem, and there are a ton of other ways to approach it, but this revision felt like a step in the right direction.

In this version of the first draft, I added [the reducer pattern](https://reedbarger.com/what-is-a-reducer-in-javascript/) because I prefer to use [functional programming](https://medium.com/javascript-in-plain-english/what-are-javascript-programming-paradigms-3ef0f576dfdb) techniques in my code.

Remember: “Perfect is the enemy of good.” This is just your first draft, and you can edit it again! That’s the leapfrogging process.

I’m also prioritizing readability over performance since I now call `[.some()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/some)` inside each iteration of a loop. That’s a loop within a loop, for [O(n²)](https://medium.com/@jorgesmulevici/o-n%C2%B2-is-not-what-you-think-bb3a2a5f58b1) run-time. For small arrays, that won’t matter a bit, but it probably won’t get you that job at Google. It’s also trivial to refactor out in my next edit of this first draft.

I made one more round of changes to add the `[.map()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map)` method before I decided I was done with my “simple first draft:”

![[View the raw code](https://gist.github.com/djD-REK/b93a5480e648778fd27284980e937f6b) as a GitHub gist](https://cdn-images-1.medium.com/max/3108/1*Yluuogf6Co9gsr5tTtgybw.png)

That’s a “polished first draft.” I’ve changed two `[for…of](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for...of)` loops to a `[.reduce()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce)`, a `[.some()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/some)`, and a `[.map()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map)`. I prefer this style of coding, but honestly, there was nothing “wrong” with my very first draft — it worked, didn’t it?

Now, this would be a great time to switch tasks and plan to review this particular code again tomorrow.

---

## The Application to Real Code

In our real work, we often receive confusing instructions combined with deadline pressure, particularly when working with new APIs. Every coder wonders at times, “Why doesn’t this code work the way it should?”

For the student I was mentoring, he went from being unable to conceptualize a problem to solving it easily because he started with simple `[for…of](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for...of)` loops. Instead of feeling challenged and like a failure, he was left feeling successful and accomplished, all thanks to the “simple first draft.”

If you’re more experienced, and writing `[.reduce()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce)` the first time feels natural, go for it! But if you need to look up the syntax, see if you can do without it and then refactor to it later. In coding, you can always edit later.

Similarly, you will probably want to go back to add [type checking](https://medium.com/javascript-in-plain-english/the-best-way-to-type-check-in-vanilla-js-55197b4f45ec) if you’re working in JavaScript. For a coding challenge, that’s not going to be necessary, but that’s something to consider adding the next day.

The other real-world carryover of the “simple first draft” approach to coding is that you’ll be making frequent [git commits](https://www.git-tower.com/learn/git/commands/git-commit): at a minimum, you should commit each version of the first draft as you’re leapfrogging. You may have three or four working versions committed by the time you’ve polished up the first draft.

You’ll appreciate having the commits if you find a bug when working on the code later because you’ll have a few solutions to review in the repository.

Plus, making commits **feels** super productive to me, especially when I’m working as part of a remote team. There’s that positive psychology again.

---

## What About Testing?

Depending on your personal preferences for testing, it’s totally fine to write your tests before the code. Just follow the same approach: Write the simplest tests possible, and then refactor them as soon as they work.

Or, like most programmers, you probably prefer testing after you have a working piece of code — and that’s totally fine. After you write your code and refactor it once or twice, write some simple tests, then refactor them.

The fastest way I know to write code is to do exactly the following:

1. Write simple code
2. Write simple tests
3. Refactor simple code, using simple tests
4. Refactor simple tests

Personally, I find that focusing on a “bad first draft” (or a “simple first draft” as I like to say) makes me much more likely to write tests in the first place because I’m not worried about writing perfect tests.

You might even consider testing to be creating a “second draft” of your work and put off that task until tomorrow. Do whatever works for you, your project, and your organization — just don’t forget about testing.

---

## Conclusion

Whether you’re a code newbie, junior engineer, or expert, you’re going to write more code faster if you don’t focus on perfection. Start with a “simple first draft” then immediately edit your code once it works.

Take it from a technical writer who’s worked with 10 programming languages professionally and written 100,000 words about JavaScript in the last year — this writing tip works just as well for developers as for writers.

My genuine advice for programmers of all levels is that your first draft should be repetitious and even feel like a “hack.” Forget about [coding principles](https://medium.com/dailyjs/principles-to-code-by-3c516ad61fcc) like “DRY” (Don’t Repeat Yourself) at first, and stick with the most basic rule of coding:

**“KISS” (Keep It Simple, Stupid!)**

You will be able to make your code beautiful once it works, but your whole day will be shot if you have to spend hours debugging — before you even get that piece of code to work even one time. **Trust me, I’ve been there!**

And, if you’re just learning a new programming language, development tool, or codebase, then this advice is mandatory, not optional.

Happy coding!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
