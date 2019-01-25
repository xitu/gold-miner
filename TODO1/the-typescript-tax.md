> * 原文地址：[The TypeScript Tax: A Cost vs Benefit Analysis](https://medium.com/javascript-scene/the-typescript-tax-132ff4cb175b)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-typescript-tax.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-typescript-tax.md)
> * 译者：
> * 校对者：

# The TypeScript Tax: A Cost vs Benefit Analysis

![](https://cdn-images-1.medium.com/max/800/1*IwvkEcaGGVihZ8PBj_Y4hA.jpeg)

Photo: LendingMemo (CC BY 2.0)

TypeScript grew a great deal between 2017 and 2019, and in many ways, for good reason. There’s a lot to love about TypeScript. In the 2018 State of JavaScript survey, [almost half the respondents](https://2018.stateofjs.com/javascript-flavors/overview/) said they’d tried TypeScript and would use it again. But should you use it for your large scale app development project?

This article takes a more critical, data-driven approach to analyze the ROI of using TypeScript to build large scale applications.

### TypeScript Growth

TypeScript is one of the fastest growing languages, and is currently the leading compile-to-JavaScript language.

![](https://cdn-images-1.medium.com/max/800/1*5DLxM43Ih40MVQzpRupUUg.png)

Google Trends 2014–2019 TypeScript Topic Growth

![](https://cdn-images-1.medium.com/max/800/1*hIFVBWlTInmFBK29DRS7TQ.png)

GitHub Fastest Growing Languages by Contributor Numbers \[[Source](https://blog.github.com/2018-11-15-state-of-the-octoverse-top-programming-languages/)\]

This is very impressive traction that shouldn’t be discounted, but it is still far from dominating the over-all JavaScript ecosystem. You might say it’s a big wave in a much bigger ocean.

![](https://cdn-images-1.medium.com/max/800/1*YFY5uChmah9_Hm_e3TWUCQ.png)

Google Search Trends 2014–2018 JavaScript (Red) vs TypeScript (blue) Topic Interest

![](https://cdn-images-1.medium.com/max/800/1*plUmjDAw4PinUhx0j61clA.png)

GitHub Top Languages by Repositories Created: TypeScript is Not in the Top 5. [[Source](https://blog.github.com/2018-11-15-state-of-the-octoverse-top-programming-languages/)]

That said, TypeScript hit an inflection point in 2018, and in 2019, a large number of production projects will use it. As a JavaScript developer, you may not have a choice. The TypeScript decision will be made for you, and you shouldn’t be afraid of learning and using it.

But if you’re in the position of deciding whether or not to use it, you should have a realistic understanding of both the benefits and the costs. Will it have a positive or negative impact?

In my experience, it has both, but falls short of positive ROI. Many developers love using it, and there are many aspects of the TypeScript developer experience I genuinely love. But all of this comes with a cost.

### Background

I come from a background using statically typed languages including C/C++ and Java. JavaScript’s dynamic types were hard to adjust to at first, but once I got used to them, it was like coming out of a long, dark tunnel and into the light. There’s a lot to love about static types, but there’s a lot to love about dynamic types, too.

On and off over the last few years, I’ve gone all-in on TypeScript full time and racked up more than a year of hands-on daily experience. I went on to lead multiple large-scale production teams using TypeScript as the primary language, and got to see the high-level multi-project impact of TypeScript and compare it to similar large-scale native JavaScript builds.

In 2018, [decentralized applications took off](https://medium.com/the-challenge/blockchain-platforms-tech-to-watch-in-2019-f2bfefc5c23), and most of them use smart contracts and open-source software. When you’re dealing with the internet of value, bugs can cost users money. It’s more important than ever to write reliable code, and because these projects are generally open-source, I figured it was nice that we developed the code in TypeScript so that it’s easier for other TypeScript teams to integrate, while maintaining compatibility with projects using JavaScript, as well.

My understanding of TypeScript, including its benefits, costs, and weaknesses have deepened considerably. I’m saddened to say that it wasn’t as successful as I’d hoped. Unless it improves considerably, **I would not pick TypeScript for another large scale project.**

#### What I Love About TypeScript

I’m still long-term optimistic about TypeScript. **I want to love TypeScript,**  and there’s a lot I still do love about it. I hope that the TypeScript developers and proponents will read this as a constructive critique rather than a hostile take-down piece. TypeScript developers _can fix some of the issues,_ and if they do, I may repeat the ROI analysis and come to different results.

Static types can be very useful to help **document functions, clarify usage, and reduce cognitive overhead.** For example, I _usually_ find Haskell’s types to be helpful, low-cost, pain-free, and unobtrusive, but sometimes even Haskell’s flexible higher-kinded type system gets in the way. Try typing a transducer in Haskell (or TypeScript). It’s not easy, and probably a bit worse than the untyped equivalent.

I love that **type annotations can be optional** in TypeScript when they get in the way, and I love that TypeScript uses structural typing and has _some support_ for type inference (though there’s a lot of room for improvement with inference).

**TypeScript supports interfaces,** which are reusable (as opposed to inline) typings that you can apply in various ways to annotate and APIs and function signatures. A single interface can have many implementations. Interfaces are one of the best features of TypeScript, and _I wish this feature was built into JavaScript._

The best news: If you use one of the well supported editors (such as Atom or Visual Studio Code), TypeScript’s editor plugins still provide **the best IDE developer experience** in the JavaScript ecosystem, in my opinion. Other plugin developers should try them out and take notes on how they can improve.

### TypeScript ROI in Numbers

I’m going to rate TypeScript on several dimensions on a scale of `-10–10` to give you a better sense of how well suited TypeScript may or may not be for large scale applications.

Greater than 0 represents a positive impact. Less than 0 represents a negative impact. 3–5 points represent relatively strong impact. 2 points represents a moderate impact. 1 point represents a relatively low impact.

These numbers are hard to measure precisely, and will be somewhat subjective, but I’ve estimated the best I can to reflect the actual costs and rewards we saw on real projects.

All projects for which impact was judged were >50k LOC with several collaborators working over several months. One project was Angular 2 + TypeScript, compared against a similar project written in Angular 1 with standard JavaScript. All other projects were built with React and Node, and compared against React/Node projects written in standard JavaScript. Subjective bug density, subjective relative velocity, and developer feedback were estimated, but not precisely measured. All teams contained a mix of experienced and new TypeScript developers. All members had access to more experienced mentors to assist with TypeScript onboarding.

Objective data was too noisy in the small sampling of projects to make any definitive objective judgements with a reliable error margin. On one project, native JavaScript showed a 41% lower public bug density over TypeScript. In another, the TypeScript project showed a 4% lower bug density over the comparable native JavaScript version. Obviously, the implementation (or lack) of other quality measures had a much stronger effect than TypeScript, which skewed the numbers beyond usability.

With margin-of-error so broad, I gave up on objective quantification, and instead focused on feature delivery pace and observations of where we spent our time. You’ll see more of those details in the ROI point-by-point breakdown.

Because there’s a lot of subjectivity involved, you should allow for a margin of error in interpretation (pictured in the chart), but the over-all ROI balance should give you a good idea of what to expect.

![](https://cdn-images-1.medium.com/max/800/1*NAV3gF9ce4FSWXmHFa_8Sw.png)

TypeScript ROI Analysis

I can already hear the peanut gallery objections to the small benefits scores, and I don’t entirely disagree with the arguments. TypeScript does provide some very useful, powerful capabilities. There’s no question about that.

In order to understand the relatively small benefit scores, you have to have a good understanding of what I’m comparing TypeScript to: Not just JavaScript, but JavaScript _paired with tools built for native JavaScript._

Let’s look at each point in more detail.

**Developer Tooling:** My favorite feature of TypeScript, and arguably the most powerful practical benefit from using TypeScript is its ability to reduce the cognitive load of developers by providing interface type hints and catch potential errors in realtime as you’re programming. If none of that were possible in native JavaScript with some good plugins, I’d give TypeScript more points on the benefit side, but the 0 point is what’s already available using JavaScript, and the baseline is already pretty good.

Most TypeScript advocates don’t seem to have a good understanding of what TypeScript is competing against. The development tool choice isn’t TypeScript vs native JavaScript and _no tooling._ It’s between TypeScript and _the entire rich ecosystem of JavaScript developer tools_.  Native JavaScript autocomplete and error detection gets you 80% — 90% of the benefits of TypeScript when you use [autocomplete](https://github.com/atom/autocomplete-plus), [type inference](https://atom.io/packages/atom-ternjs), and [lint tooling](https://eslint.org/). When you’re running type inference, and [you use ES6 default parameters](https://medium.com/javascript-scene/javascript-factory-functions-with-es6-4d224591a8b1), you get type hints just like you would with type-annotated TypeScript code.

![](https://cdn-images-1.medium.com/max/800/1*13Zp1TW6jcnqsHCPl59_og.png)

Example of Native JavaScript Autocomplete with Type Inference

In fairness, if you use default parameters to provide type hints, you don’t need to supply the annotations for TypeScript code, either, which is a great trick to reduce type syntax overhead — one of the overhead costs of using TypeScript.

TypeScript’s tooling for these things is arguably a little better, and more all-in-one — but it’s not enough of an improvement to justify the costs.

**API Documentation:** Another great benefit of TypeScript is better documentation for APIs which is always in sync with your source code. You can even generate API documentation from your TypeScript code. This would also get a higher score, except you can get the same benefit using [JSDoc](http://usejsdoc.org/) and [Tern.js](http://ternjs.net/) in JavaScript, and documentation generators are abundant. Personally, I’m not a big fan of JSDoc, so TypeScript does get some points, here.

Even with the best inline documentation in the world, you still need real documentation, so TypeScript enhances, rather than replaces existing documentation options.

**Type safety doesn’t seem to make a big difference.** TypeScript proponents frequently talk about the benefits of type safety, but [there is little evidence that type safety makes a big difference](https://medium.com/javascript-scene/the-shocking-secret-about-static-types-514d39bf30a3) in production bug density. This is important because code review and TDD make a very big difference ([40% — 80% for TDD alone](https://www.computer.org/csdl/mags/so/2007/03/s3024-abs.html)). Pair TDD with design review, spec review, and code review, and you’re looking at 90%+ reductions in bug density. Many of those processes (particularly TDD) are capable of catching the same class of bugs that TypeScript catches, as well as many bugs that TypeScript will never be able to catch.

TypeScript is only capable of addressing [a theoretical maximum of 15% of “public bugs”](http://earlbarr.com/publications/typestudy.pdf), where public means that the bugs survived past the implementation phase and got committed to the public repository, according to Zheng Gao and Earl T. Barr from University College London, and Christian Bird from Microsoft Research.

Their study looked at bugs that were known in advance, including the exact lines that were changed to fix the bugs in question, where the problem and potential solutions were known prior to introduction of typings. What this means is that even knowing that the bugs existed in advance, TypeScript was _unable to detect 85% of public bugs._

Why are so many bugs undetectable by TypeScript, and why did I call that 15% reduction a “theoretical maximum” effect? For starters, [specification errors caused about 78% of the publicly classified bugs](http://earlbarr.com/publications/typestudy.pdf) studied on GitHub. The failure to correctly specify behaviors or correctly implement a specification is the most common type of bug by a huge margin, and that fact automatically renders an overwhelming majority of bugs impossible for TypeScript to detect or prevent. In “To Type or Not to Type”, the study authors identified and classified a range of “ts-undetectable” bugs.

![](https://cdn-images-1.medium.com/max/800/1*yjmeLd5YV-Fy4YzTtDta6Q.png)

Histogram of ts-undetectable bugs. Source: [“To Type or Not to Type”](http://earlbarr.com/publications/typestudy.pdf)

“StringError” above are the classification of errors where the string was the right type, but contained the wrong value (like an incorrect URL). There is some limited potential for static analysis to make a small dent in StringErrors by gaining some visibility into the values of strings, as dependent type systems are capable of, but that potential is a small percent of a small percent, so _there’s little potential that TypeScript will ever be capable of detecting more than 15%-18% of bugs._

**But a 15% sounds like a lot!** Why doesn’t TypeScript get much higher bug prevention points?

Because there are so many bugs that are not detectable by static types, it would be irresponsible to skip other quality control measures like design review, spec review, code review, and TDD. So it’s not fair to assume that TypeScript will be the only thing you’re employing to prevent bugs. In order to really get a sense of ROI, we have to apply the bug reduction math _after discounting the bugs caught by other measures._

Imagine your project would have contained 1,000 bugs with no bug prevention measures. After applying other quality measures, the potential production bug count is reduced to 100. **Now** we can look at how many additional bugs TypeScript would have prevented to get a truer sense of the bug catching return on our TypeScript investment. Since **close to 80% of bugs are not detectable by TypeScript,** and all TypeScript-detectable bugs can potentially be caught with other measures like TDD, we’ll use a generous 8% further reduction (assuming about half of ts-detectable bugs will be missed by our other measures).

*   No measures: 1000 bugs
*   After other measures: 100 bugs remain — _900 bugs caught_
*   After adding TypeScript to other measures: 92 bugs remain — _8 more bugs caught_

![](https://cdn-images-1.medium.com/max/800/1*28S2yRXynvm6kjCBOr4IfA.png)

Bar graph of bugs remaining after applying reduction measures: TypeScript provides little added benefit.

Some people argue that if you have static types, you don’t need to worry about writing so many tests. Those people are making a silly argument. There is really no contest. Even if you’re going to employ TypeScript, _you still need the other measures._

![](https://cdn-images-1.medium.com/max/800/1*rA-6sDx3ZbcjMYo8Sl3GMQ.png)

Bugs caught by TypeScript vs bugs caught by reviews, TDD. Other measures dominate.

In this scenario, TypeScript catches 150/1,000 bugs by itself, while other measures (not including TypeScript) catch 900/1,000 bugs. You obviously don’t have to pick one or the other, you can combine both and catch about 908 bugs out of 1,000 (remembering that the other measures will catch lots of the bugs you would have caught with TypeScript alone).

Having implemented quality control systems on large scale, multi-million dollar development projects, I can tell you that my expectations for effectiveness on costly system implementations are in the territory of 30% — 80% reductions. You can get those kinds of numbers from any of the following:

*   **Design and Spec Review** ([up to 80% reduction](http://earlbarr.com/publications/typestudy.pdf))
*   **TDD** ([40% — 80% reduction of remaining bugs](https://www.computer.org/csdl/mags/so/2007/03/s3024-abs.html))
*   **Code Review** ([an hour of code review saves 33 hours maintenance](http://www.ifsq.org/finding-ia-2.html))

It turns out that type errors are just _a small subset_ of the full range of possible bugs, and _there are other ways to catch type errors._ The data is in, and the result is very clear: **TypeScript won’t save you from bugs.** At best, you’ll get a very modest reduction, and you still need all your other quality measures.

> Type correctness does not guarantee program correctness.

It looks like neither developer tooling nor type safety are really living up to the TypeScript hype. But those can’t be the only benefits, right?

**New JavaScript Features and Compile to Cross-Browser JavaScript:** Babel does both for native JavaScript.

We’ve reached the end of the benefits, and I don’t know about you, but I’m feeling a little underwhelmed. If we can get type hints, autocomplete, and great bug reductions for native JavaScript using other tools, the only question that remains is, does the TypeScript difference pay off the investment required to use it?

To figure that out, we need to take a closer look at the costs of TypeScript.

**Recruiting:** While nearly half of The State of JavaScript respondents have used TypeScript and would use it again, and an additional 33.7% would like to learn, 5.4% have used TypeScript and **would not use it again**, and 13.7% are **not interested in learning TypeScript.** That reduces the recruiting pool by almost 20%, which could be a significant cost to teams who need to do a lot of hiring. Hiring is an expensive process which can drag on for months and cut into the productive time of your other developers (who, more often than not, are the people most qualified to assess new candidate’s skills).

On the other hand, if you only need to hire one or two developers, using TypeScript may make your opening _more attractive_ to almost half the candidate pool. For small projects, it may be a wash, or even slightly positive. For teams of hundreds or thousands, it’s going to swing into the negative side of the ROI error margin.

**Setup, Initial Training:** Because these are one-time costs, they’re relatively low. Teams already familiar with JavaScript tend to get productive in TypeScript within 2–3 months, and pretty fluent within 6–8 months. Definitely more costly than recruiting, but certainly worth the effort if this were the only cost.

**Missing Features — HOFs, Composition, Generics with Higher Kinded Types, Etc.:** _TypeScript is not fully coexpressive with idiomatic JavaScript._ This is one of my biggest challenges (and expenses) with TypeScript, because fluent JavaScript developers will frequently encounter situations which are difficult or impossible to type, but conscientious developers will be interested in doing things right. They’ll spend hours Googling for examples, trying to learn how to type things that TypeScript simply can’t type properly.

TypeScript could improve on this cost by providing better documentation and discovery of TypeScript’s current limitations, so developers waste less time trying to get it to behave well on higher order functions, declarative function compositions, transducers, and so on. In many cases, a well-behaved, readable, maintainable TypeScript typing simply isn’t going to happen. Developers need to be able to discover that quickly so that they can spend their time on more productive things.

**Ongoing Mentorship:** While people get productive with TypeScript pretty quickly, it does take quite a bit longer to get feeling confident. I still feel like there’s a lot more to learn. In TypeScript, there are different ways to type the same things, and figuring out the advantages and disadvantages of each, teasing out best practices, etc. takes quite a bit longer than the initial learning curve.

For example, new TypeScript developers tend to over-use annotations and inline typings, while more experienced TypeScript developers have learned to reuse interfaces and create separate typings to reduce the syntax clutter of inline annotations. More experienced developers will also spot ways to tighten up the typings to produce better errors at compile time.

This extra attention to typings is an ongoing cost you’ll see every time you onboard new developers, but also as your experienced TypeScript developers learn and share new tricks with the rest of the team. This kind of ongoing mentorship is just a normal side-effect of collaboration, and it’s a healthy habit that saves money in the long term when applied to other things, but it comes at a cost, and TypeScript adds significantly to it.

**Typing Overhead:** In the cost of typing overhead, I’m including all the extra time spent typing, testing, debugging, and maintaining type annotations. Debugging types is a cost that is often overlooked. Type annotations come with their own class of bugs. Typings that are too strict, too relaxed, or just wrong.

This cost center has gone down since I first explored it, because many third party libraries now contain typings, so you don’t have to do so much work trying to track them down or create them yourself. However, many of those typings are still broken and out-of-date in all but the most popular OSS packages, so you’ll still end up backfilling typings for third party libraries that you want type hints for. Often, developers try to get those typings added upstream, with widely varied results.

You may also notice greatly increased syntax noise. In languages like Haskell, typings are generally short one-liners listed above the function being defined. In TypeScript, particularly for generic functions, they’re often intrusive and defined inline by default.

Instead of adding to the readability of a function signature, TypeScript typings can often make them harder to read and understand. This is one reason experienced TypeScript developers tend to use more reusable typings and interfaces, and declare typings separately from function implementations. Large TypeScript projects tend to develop their own libraries of reusable typings that can be imported and used anywhere in the project, and maintenance of those libraries can become an extra — but worthwhile — chore.

Syntax noise is problematic for several reasons. You want to keep your code free of clutter for the same reasons you want to keep your house free of clutter:

*   More clutter = more places for bugs to hide = more bugs.
*   More clutter makes it harder to find the information you’re looking for.

Clutter is like static on a poorly tuned radio — more noise than signal. When you eliminate the noise, you can hear the signal better. Reducing syntax noise is like tuning the radio to the proper frequency: The meaning comes through more easily.

Syntax noise is one of the heavier costs of TypeScript, and it could be improved on in a couple ways:

*   Better support for generics using higher-kinded types, which can eliminate some of the template syntax noise. (See Haskell’s type system for reference).
*   Encourage separate, rather than inline typings, _by default._ If it became a best practice to avoid inline typings, the typing syntax would be isolated from the function implementation, which would make it easier to read both the type signature and the implementation, because they wouldn’t be competing with each other. This could be implemented as a documentation overhaul, along with some evangelism on Stack Overflow.

### Conclusion

I still love a lot of things about TypeScript, and I’m still hopeful that it improves. Some of these cost concerns may be adequately addressed in the future by adding new features and improving documentation.

However, we shouldn’t brush these problems under the rug, and it’s irresponsible for developers to overstate the benefits of TypeScript without addressing the costs.

TypeScript can and should get better at type inference, higher order functions, and generics. The TypeScript team also has a huge opportunity to improve documentation, including tutorials, videos, best practices, and an easy-to-find rundown of TypeScript’s limitations, which will help TypeScript developers save a lot of time and significantly reduce the costs of using TypeScript.

I’m hopeful that as TypeScript continues to grow, more of its users will get past the honeymoon phase and realize its costs and current limitations. With more users, more great minds can focus on solutions.

As TypeScript stands, I would definitely use it again in small open-source libraries, primarily to make life easier for other TypeScript users. But I will not use the current version of TypeScript in my next large scale application, because the larger the project is, the more the costs of using TypeScript compound.

This conclusion is ironic because the TypeScript tagline is “JavaScript that Scales”. A more honest tagline might add a word: “JavaScript that scales awkwardly.”

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
