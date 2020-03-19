> * 原文地址：[The Dao of Immutability](https://medium.com/javascript-scene/the-dao-of-immutability-9f91a70c88cd)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-dao-of-immutability.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-dao-of-immutability.md)
> * 译者：
> * 校对者：

# The Dao of Immutability

> The Way of the Functional Programmer

## Forward

I was wandering the archives of an old library, and found a dark tunnel that led to the chamber of computation. There I found a scroll that seemed to have fallen on the floor, forgotten.

The scroll was encased in a dusty steel tube and labeled: “From the archives of **The Church of Lambda**.”

It was wrapped in a thin sheet of paper that read:

---

**A master programmer and his apprentice sat in Turing meditation, contemplating the Lambda. The apprentice looked at the master and asked, “Master, you tell me to simplify, but programs are complex. Frameworks ease the work of creation by removing hard choices. Which is better, a class or a framework?”**

**The master programmer looked at his apprentice and asked, “did you not read the teachings of wise master Carmack?”, quoting…**

> “Sometimes, the elegant implementation is just a function. Not a method. Not a class. Not a framework. Just a function.”

**“But master,” the apprentice started — but the master interrupted, asking:**

**“Is it not true that the word for ‘not functional’ is ‘dysfunctional’?”**

**And then the apprentice understood.**

---

On the back of the sheet was an index that seemed to refer to many books in the chamber of computation. I peeked inside the books, but they were filled with big words I did not understand, so I put them back and continued to read the scroll. I noticed that the margins of the index were filled with short commentary, which I will reproduce here, faithfully, along with the writing from the scroll:

---

> **Immutability:** The true constant is change. Mutation hides change. Hidden change manifests chaos. Therefore, the wise embrace history.

If you have a dollar, and I give you another dollar, it does not change the fact that a moment ago you only had one dollar, and now you have two. Mutation attempts to erase history, but history cannot be truly erased. When the past is not preserved, it will come back to haunt you, manifesting as bugs in the program.

> **Separation:** Logic is thought. Effects are action. Therefore the wise think before acting, and act only when the thinking is done.

If you try to perform effects and logic at the same time, you may create hidden side effects which cause bugs in the logic. Keep functions small. Do one thing at a time, and do it well.

> **Composition:** All things in nature work in harmony. A tree cannot grow without water. A bird cannot fly without air. Therefore the wise mix ingredients together to make their soup taste better.

Plan for composition. Write functions whose outputs will naturally work as inputs to many other functions. Keep function signatures as simple as possible.

> **Conservation:** Time is precious, and effort takes time. Therefore the wise reuse their tools as much as they can. The foolish create special tools for each new creation.

Type-specific functions can’t be reused for data of a different type. Wise programmers lift functions to work on many data types, or wrap data to make it look like what the function is expecting. Lists and items make great universal abstractions.

> **Flow:** still waters are unsafe to drink. Food left alone will rot. The wise prosper because they let things flow.

**[Editor’s note: The only illustration on the scroll was a row of different-looking ducks floating down a stream just above this verse. I have not reproduced the illustration because I don’t believe I could do it justice. Curiously, it was captioned:]**

---

> A list expressed over time is a stream.

---

**[The corresponding note read:]**

Shared objects and data fixtures can cause functions to interfere with each other. Threads competing for the same resources can trip each other up. A program can be reasoned about and outcomes predicted only when data flows freely through pure functions.

**[Editor’s note: The scroll ended with this final verse, which had no commentary:]**

> **Wisdom:** The wise programmer understands the way before walking the path. Therefore the wise programmer is functional, while the unwise get lost in [the jungle](https://medium.com/javascript-scene/the-two-pillars-of-javascript-ee6f3281e7f3).
>
---

> **Note:** This is part of the “Composing Software” serie**s [(now a book!)](https://leanpub.com/composingsoftware)** on learning functional programming and compositional software techniques in JavaScriptES6+ from the ground up. Stay tuned. There’s a lot more of this to come!
**[Buy the Book](https://leanpub.com/composingsoftware) | [Index](https://medium.com/javascript-scene/composing-software-the-book-f31c77fc3ddc) | [\< Previous](https://medium.com/javascript-scene/composing-software-an-introduction-27b72500d6ea) | [Next >](https://medium.com/javascript-scene/the-rise-and-fall-and-rise-of-functional-programming-composable-software-c2d91b424c8c)**

---

## Learn More at EricElliottJS.com

Video lessons with interactive code challenges are available for members of EricElliottJS.com. If you’re not a member, [sign up today](https://ericelliottjs.com/).

---

****Eric Elliott** is a distributed systems expert and author of the books, [“Composing Software”](https://leanpub.com/composingsoftware) and [“Programming JavaScript Applications”](https://ericelliottjs.com/product/programming-javascript-applications-ebook/). As co-founder of [DevAnywhere.io](https://devanywhere.io/), he teaches developers the skills they need to work remotely and embrace work/life balance. He builds and advises development teams for crypto projects, and has contributed to software experiences for **Adobe Systems,Zumba Fitness,** **The Wall Street Journal,** **ESPN,** **BBC,** and top recording artists including **Usher, Frank Ocean, Metallica,** and many more.**

**He enjoys a remote lifestyle with the most beautiful woman in the world.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
