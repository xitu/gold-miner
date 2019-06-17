> * 原文地址：[Comparing the Same Project in Rust, Haskell, C++, Python, Scala and OCaml](http://thume.ca/2019/04/29/comparing-compilers-in-rust-haskell-c-and-python/)
> * 原文作者：[Tristan](http://thume.ca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/comparing-compilers-in-rust-haskell-c-and-python-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/comparing-compilers-in-rust-haskell-c-and-python-1.md)
> * 译者：
> * 校对者：

# Comparing the Same Project in Rust, Haskell, C++, Python, Scala and OCaml - Part 1

During my final term at UWaterloo I took [the CS444 compilers class](https://www.student.cs.uwaterloo.ca/~cs444/) with a project to write a compiler from a substantial subset of Java to x86, in teams of up to three people with a language of the group’s choice. This was a rare opportunity to compare implementations of large programs that all did the same thing, written by friends I knew were highly competent, and have a fairly pure opportunity to see what difference design and language choices could make. I gained a lot of useful insights from this. It’s rare to encounter such a controlled comparison of languages, it’s not perfect but it’s much better than most anecdotes people use as the basis for their opinions on programming languages.

We did our compiler in Rust and my first comparison was with a team that used Haskell, which I expected to be much terser, but their compiler used similar amounts or more code for the same task. The same was true for a team that used OCaml. I then compared with a team that used C++, and as expected their compiler was around 30% larger largely due to headers and lack of sum types and pattern matching. The next comparison was my friend who did a compiler on her own in Python and used less than half the code we did because of the power of metaprogramming and dynamic types. A friend whose team used Scala also had a smaller compiler than us. The comparison that surprised me most though was with another team that also used Rust, but used 3 times the code that we did, because of different design decisions. In the end, the largest difference in the amount of code required was within the same language!

I’ll go over why I think this is a good comparison, some information on each project, and I’ll explain some of the sources of the differences in compiler size. I’ll also talk about what I learned from each comparison. Feel free to use these links to skip ahead to what interests you:

## Table of Contents

* Why I think this is insightful
* [Rust (baseline)](#rust-baseline)
* [Haskell](#haskell): 1.0-1.6x the size depending on how you count for interesting reasons
* [C++](#c): 1.4x the size for mundane reasons

## Why I think this is insightful

Now before you reply that amount of code (I compared both lines and bytes) is a terrible metric, I think that it can provide a good amount of insight in this case for a number of reasons. This is at least subjectively the most well controlled instance of different teams writing the same **large** program that I’ve ever heard of or read about.

* Nobody (including me) knew I would ask this until after we were done, so nobody was trying to game the metric, everyone was just doing their best to finish the project quickly and correctly.

* Everyone (with the exception of the Python project I’ll discuss later) was implementing a program with the sole goal of passing the same automated test suite by the same deadlines, so the results can’t be confounded much by some groups deciding to solve different/harder problems.

* The project was done over a period of months, with a team, and needed to be gradually extended and pass both known and unknown tests. This means that it was helpful to write clean understandable code and not hack everything together.

* Other than passing the course tests, the code wouldn’t be used for anything else, nobody would read it and being a compiler for a limited subset of Java to textual assembly it wouldn’t be useful.

* No libraries other than the standard library were allowed, and no parsing helpers even if they’re in the standard library. This means the comparison can’t be confounded by powerful compiler libraries not used by all teams.

* There were secret tests which we couldn’t see that were run once after the final submission deadline, which meant there was an incentive to write your own test code and make sure that your compiler was robust, correct and could handle tricky edge cases.

* While everyone involved was a student, the teams I talk about are all composed of people I consider quite competent programmers. Everyone has at least 2 years of full time work experience doing internships, mostly at high end tech companies sometimes even working on compilers. Nearly all have been programming for 7-13 years and are enthusiasts who read a lot on the internet beyond their courses.

* Generated code wasn’t counted, but grammar files and code that generated code was counted.

Thus I think the amount of code provides a decent approximation of how much effort each project took, and how much there would be to maintain if it was a longer term project. I think the smaller differences are also large enough to rule out extraordinary claims, like the ones I’ve read that say writing a compiler in Haskell takes less than half the code of C++ by virtue of the language.

## Rust (baseline)

Me and one of my teammates had each written over 10k lines of Rust before, and my other teammate had written maybe 500 lines of Rust for some hackathon projects. Our compiler was 6806 lines by `wc -l`, 5900 source lines of code (not including blanks and comments), and 220kb by `wc -c`.

One thing I discovered is that these measures were related by approximately the same factors in the other projects where I checked, with minor exceptions that I’ll note. For the rest of the post when I refer to lines or amount I mean by `wc -l`, but this result means it doesn’t really matter (unless I note a difference) and you can convert with a factor.

I wrote [another post describing our design](http://thume.ca/2019/04/18/writing-a-compiler-in-rust/) [[译文]](https://github.com/xitu/gold-miner/blob/master/TODO1/writing-a-compiler-in-rust.md) , which passed all the public and secret tests. It also included a few extra features that we did for fun and not to pass tests, that probably added around 400 extra lines. Also around 500 lines of our total was unit tests and a test harness.

## Haskell

The Haskell team was composed of two of my friends who’d written maybe a couple thousand lines of Haskell each before plus reading lots of online Haskell content, and a bunch more in other similar functional languages like OCaml and Lean. They had one other teammate who I didn’t know well but seems like a strong programmer and had used Haskell before.

Their compiler was 9750 lines by `wc -l`, 357kb and 7777 SLOC. This team also had the only significant differences between measure ratios, with their compiler being 1.4x the lines, 1.3x the SLOC, and 1.6x the bytes. They didn’t implement any extra features but passed 100% of public and secret tests.

It’s important to note that including the tests is the least fair to this team since they were the most thorough with correctness, with 1600 lines of tests, they caught a few edge cases that our team did not, they just happened to not be edge cases that were tested by the course tests. So not counting tests on both sides (8.1kloc vs 6.3kloc) their compiler was only 1.3x the raw lines.

I also am inclined towards bytes as the more reasonable measure of amount of code here because the Haskell project has longer lines on average since it doesn’t have lots of lines dedicated to just a closing brace, and it’s one-liner function chains aren’t split onto a bunch of lines by `rustfmt`.

Digging into the difference in size with one of my friends on the team, we came up with the following to explain the difference:

* We used a hand-written lexer and recursive descent parsing, where they used a [NFA](https://en.wikipedia.org/wiki/Nondeterministic_finite_automaton) to [DFA](https://en.wikipedia.org/wiki/Deterministic_finite_automaton) lexer generator, and an [LR parser](https://en.wikipedia.org/wiki/LR_parser) and then a pass to turn the parse tree into an AST ([Abstract Syntax Tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree), a more convenient representation of the code). This took them substantially more code, 2677 lines compared to our 1705, for about an extra 1k lines.

* They used a fancy generic AST type that transitioned to different type parameters as more information was added in each pass. This is and more helper functions for rewriting are probably why their AST code has about 500 lines more than our implementation where we build with struct literals and mutate `Option<_>` fields to add information as passes progress.

* They have about 400 more lines of code in their code generation that are mostly attributable to more abstraction necessary to generate and combine code in a purely functional way where we just use mutation and string writing.

These differences plus the tests explain all of the difference in lines. In fact our files for middle passes like constant folding and scope resolution are very close to the same size. However that still leaves some difference in bytes because of longer average lines, which I’d guess is because they require more code to rewrite their whole tree at every pass where we just use a visitor with mutation.

Bottom line, I’d say setting aside design decisions Rust and Haskell are similarly expressive, with maybe a slight edge to Rust because of ability to easily use mutation when it’s convenient. It was also interesting to learn that my choice to use a recursive descent parser and hand-written lexer paid off, this was a risk since it wasn’t what the professor recommended and taught but I figured it would be easier and was right.

Haskell fans my object that this team probably didn’t use Haskell to its fullest potential and if they were better at Haskell they could have done the project with way less code. I believe that someone like [Edward Kmett](https://github.com/ekmett) could write the same compiler in substantially fewer lines of Haskell, in that my friend’s team didn’t use a lot of fancy super advanced abstractions, and weren’t allowed to use fancy combinator libraries like [lens](http://hackage.haskell.org/package/lens). However, this would come at a cost to how difficult it would be to understand the compiler. The people on the team are all experienced programmers, they knew that Haskell can do extremely fancy things but chose not to pursue them because they figured it would take more time to figure them out than they would save and make their code harder for the teammates who didn’t write it to understand. This seems like a real tradeoff to me and the claim I’ve seen of Haskell being magical for compilers devolves into something like “Haskell has an extremely high skill cap for writing compilers as long as you don’t care about maintainability by people who aren’t also extremely skilled in Haskell” which is less generally applicable.

Another interesting thing to note is that at the start of every offering of the course the professor says that students can use any language that can run on the school servers, but issues a warning that teams using Haskell have the highest variance in mark of any language, with many teams using Haskell overestimating their ability and crashing and burning then getting a terrible mark, more than any other language, while some Haskell teams do quite well and get perfect like my friends.

## C++

Next I talked to my friend who was on a team using C++, I only knew one person on this team, but C++ is used in multiple courses at UWaterloo so presumably everyone on the team had C++ experience.

Their project was 8733 raw lines and 280kb not including test code but including around 500 lines of extra features. Making it 1.4x the size of our non-test code that also had around 500 lines of extra features. They passed 100% of public tests but only passed 90% of secret tests, presumably because they didn’t implement the fancy array vtables required by the spec, which take maybe 50-100 lines of code.

I didn’t dig very deeply into these differences with my friend. I speculate that it’s mostly explained by:

* Them using an LR parser and tree rewriter instead of a recursive descent parser
* The lack of sum types and pattern matching in C++, which we used extensively and were very helpful.
* Needing to duplicate all the signatures in header files, which Rust doesn’t have.

Another thing we compared was compile times. On my laptop our compiler takes 9.7s for a clean debug build, 12.5s for clean release, and 3.5s for incremental debug. My friend didn’t have timings on hand for their C++ build (using parallel make) but said those sounded quite similar to his experience, with the caveat that they put the implementations of a bunch of small functions in header files to save the signature duplication at the cost of longer times (this is also why I can’t measure the pure header file line count overhead).

> 欢迎继续阅读本系列文章的下半部分：
>
> - [Comparing the Same Project in Rust, Haskell, C++, Python, Scala and OCaml - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/comparing-compilers-in-rust-haskell-c-and-python-2.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
