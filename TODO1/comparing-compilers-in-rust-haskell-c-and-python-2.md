> * 原文地址：[Comparing the Same Project in Rust, Haskell, C++, Python, Scala and OCaml](http://thume.ca/2019/04/29/comparing-compilers-in-rust-haskell-c-and-python/)
> * 原文作者：[Tristan](http://thume.ca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/comparing-compilers-in-rust-haskell-c-and-python-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/comparing-compilers-in-rust-haskell-c-and-python-2.md)
> * 译者：
> * 校对者：

# Comparing the Same Project in Rust, Haskell, C++, Python, Scala and OCaml - Part 2

> 如果你还没阅读本系列文章的上半部分，建议先阅读上半部分：
>
> - [Comparing the Same Project in Rust, Haskell, C++, Python, Scala and OCaml - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/comparing-compilers-in-rust-haskell-c-and-python-1.md)

During my final term at UWaterloo I took [the CS444 compilers class](https://www.student.cs.uwaterloo.ca/~cs444/) with a project to write a compiler from a substantial subset of Java to x86, in teams of up to three people with a language of the group’s choice. This was a rare opportunity to compare implementations of large programs that all did the same thing, written by friends I knew were highly competent, and have a fairly pure opportunity to see what difference design and language choices could make. I gained a lot of useful insights from this. It’s rare to encounter such a controlled comparison of languages, it’s not perfect but it’s much better than most anecdotes people use as the basis for their opinions on programming languages.

We did our compiler in Rust and my first comparison was with a team that used Haskell, which I expected to be much terser, but their compiler used similar amounts or more code for the same task. The same was true for a team that used OCaml. I then compared with a team that used C++, and as expected their compiler was around 30% larger largely due to headers and lack of sum types and pattern matching. The next comparison was my friend who did a compiler on her own in Python and used less than half the code we did because of the power of metaprogramming and dynamic types. A friend whose team used Scala also had a smaller compiler than us. The comparison that surprised me most though was with another team that also used Rust, but used 3 times the code that we did, because of different design decisions. In the end, the largest difference in the amount of code required was within the same language!

I’ll go over why I think this is a good comparison, some information on each project, and I’ll explain some of the sources of the differences in compiler size. I’ll also talk about what I learned from each comparison. Feel free to use these links to skip ahead to what interests you:

## Table of Contents

* [Python](#python): half the size because of fancy metaprogramming!
* [Rust (other group)](#rust-other-group): 3x the size because of different design decisions!
* [Scala](#scala): 0.7x the size
* [OCaml](#ocaml): 1.0-1.6x the size depending on how you count, similar to Haskell

## Python

I have one friend who is an extraordinarily good programmer who chose to do the project alone and in Python. She also implemented more extra features (for fun) than any other team including an SSA intermediate representation with register allocation and other optimizations. On the other hand because she was working alone and implementing a bunch of extra features, she dedicated the least effort to code quality, for example by throwing an undifferentiated exception for all errors (relying on backtraces for debugging) instead of having error types and messages like we did.

Her compiler was 4581 raw lines and passed all public and secret tests. She also implemented way more extra features than any other team I compare with, but it’s hard to determine how extra code that took because many of her extra features were more powerful versions of simple things everyone needed to implement like constant folding and code generation. The extra features probably account for 1000-2000 lines at least though, so I’m confident her code was at least twice as expressive as ours.

One large part of this difference is likely dynamic typing. Our `ast.rs` alone has 500 lines of type definitions, and there are many more types defined throughout our compiler. We also are always constrained in what we do by the type system. For example we need infrastructure for ergonomically adding new info to our AST as it progresses through passes and accessing that later. Whereas in Python you can just set new fields on your AST nodes.

Powerful metaprogramming also explains part of the difference. For example although she used an LR parser instead of a recursive descent parser, in her case I think it needed less code, because instead of a tree rewriting pass, her LR grammar included Python code snippets to construct the AST, which the generator could turn into Python functions using `eval`. Part of the reason we didn’t use an LR parser is because constructing an AST without a tree rewriting pass would require a lot of ceremony (either generating Rust files or procedural macros) to tie the grammar to snippets of Rust code.

Another example of the power of metaprogramming and dynamic typing is that we have a 400 line file called `visit.rs` that is mostly repetitive boilerplate code implementing a visitor on a bunch of AST structures. In Python this could be a short ~10 line function that recursively introspects on the fields of the AST node and visits them (using the `__dict__` attribute).

As a fan of Rust and statically typed languages in general I’m inclined to point out that the type system is very helpful for avoiding bugs and for performance. Fancy metaprogramming can also make it more difficult to understand how code works. However, this comparison surprised me in that I hadn’t expected the difference in the amount of code to be quite so large. If the difference in general is really close to needing to write twice the amount of code, I still think Rust is worth the tradeoff, but 2x is nothing to sneeze at and in the future I’ll be more inclined to hack something together in Ruby/Python if I just need to get it done quickly without a team and then throw it away after.

## Rust (other group)

The last comparison I did and also the most interesting to me was with my friend who did the project in Rust with one teammate (who I didn’t know). My friend had a good amount of Rust experience having contributed to the Rust compiler and done lots of reading, I don’t know about his teammate.

Their project was 17,211 raw lines, 15k source lines, and 637kb not including test code and generated code. It had no extra features and passed only 4/10 secret tests and 90% of the public code generation tests, because they didn’t find the time before the final deadline to implement fancier pieces of the spec. This is 3 times the size of our compiler written in the same language, but with strictly less functionality!

This result was really surprising to me and dwarfed all the between-language differences I had investigated thus far. So we compared `wc -l` file size listings, as well as spot checking how we each implemented some specific things that had very different code sizes.

It seems to come down to consistently making different design decisions. For example, their front end (lexing, parsing, AST building) is 7597 raw lines to our 2164. They used a DFA-based lexer and LALR(1) parser, but the other groups did similar things without as much code. Looking at their weeder file, I noticed a number of different design decisions:

* They chose to use a fully typed parse tree instead of the standard string-based homogeneous parse tree. This presumably required a lot more type definitions and additional transformation code in the parsing stage or a more complex parser generator.

* They used `TryFrom` trait implementations for converting between the parse tree types and the AST types while validating their correctness. This lead to tons of 10-20 line `impl` blocks. We used functions that returned `Result` types to accomplish the same thing, which had less line overhead and also freed us from the type structure a bit more, making parameters and re-use easier. Some things that for us were single line `match` branches were 10 line impl statements for them.

* Our types were structured in a way that required less copy-pasting. For example they used separate `is_abstract`, `is_native` and `is_static` fields whose constraint checking code needed to be copy-pasted twice, once for their void-typed methods and once for their methods with a return type, with slight modifications. Whereas for us `void` was just a special type, and we came up with a taxonomy of modifiers into `mode` and `visibility` enums that enforced the constraints at the type level and constraint errors were generated in the default case of the match statement that translated the modifier sets to the mode and visibility.

I didn’t look at the code of the analysis passes of their compiler, but they are similarly large. I talked to my friend and it seems they didn’t implement anything like the visitor infrastructure that we did. I’m guessing this along with some other smaller design differences account for the size difference of this part. The visitor allowed our analysis passes to only pay attention to the parts of the AST they needed instead of having to pattern match down through the entire AST structure, saving a lot of code.

Their code generation is 3594 lines where ours is 1560. I looked at their code for this and it seems that nearly all of the difference is that they chose to have an intermediate data structure for assembly instructions, where we just used string formatting to directly output assembly. This required defining types and output functions for all the instructions and operand types they used. It also meant that constructing assembly instructions took way more code, where we might have a formatting statement that used terse instructions like `mov ecx, [edx]`, they needed a giant statement `rustfmt` split over 6 lines which constructed the instruction with a bunch of intermediate nested types for the operands involving 6 levels of nested parentheses at its deepest. We could also output blocks of related instructions like a function preamble in one formatting statement, where they had to do the full construction for each instruction.

Our team considered using such an abstraction. It would make it easier to have the option of either outputting textual assembly or directly emitting machine code, however that wasn’t a requirement of the course. The same thing could also be accomplished with less code and better performance using an `X86Writer` trait with methods like `push(reg: Register)`. Another angle we considered was that it might make debugging and testing easier, but we realized that looking at the generated textual assembly would actually be easier to read and test with [snapshot testing](https://docs.rs/insta/0.8.1/insta/) as long as we inserted comments liberally. But we (apparently correctly) predicted that it would take a lot of extra code, and there wasn’t any real benefit given what we knew we were going to need, so we didn’t bother.

A good comparison is with the intermediate representation the C++ group used as an extra feature, which only took them closer to 500 extra lines. They used a very simple structure (making for simple type definitions and construction code) that used operations close to what Java required. This meant that their IR was much smaller (and thus required less construction code) than the resulting assembly, since many language operations like calls and casts expanded into many assembly instructions. They also say it really helped debugging since it cut out a lot of the cruft and was easy to read. The higher level representation also allowed them to do some simple optimizations on their IR. The C++ team came up with a really nice design which got them much more benefit with much less code.

Overall it seems like the overall 3x size multiplier is due to consistently making different design decisions both large and small in the direction of larger code. They implemented a number of abstractions that we didn’t which added more code, and missed out on some of the abstractions we implemented which lead to less code.

This result really surprised me, I knew design decisions mattered but I wouldn’t have guessed beforehand that they would lead to any differences this large, given that I was only surveying people that I consider strong competent programmers. Of all the results from this comparison, this is the one I learned the most from. Something that I think helped was that I had read a lot about how to write compilers before I took the course, so I could take advantage of clever designs other people had come up with and found worked well like AST visitors and recursive descent parsing even when they weren’t taught in the course.

One thing this really made me think about is the cost of abstraction. Abstractions may make things easier to extend in the future, or guard against certain types of errors, but they need to be considered against the fact that you may end up with 3 times the amount of code to understand and refactor, 3 times the amount of possible locations for bugs and less time left to spend on testing and further development. Our course was unlike the real world in that we knew exactly what we needed to implement and that we’d never touch the code afterwards, which eliminates the benefits of pre-emptive abstraction. However if you were going to challenge me to extend a compiler with an arbitrary feature you’d tell me later, and I had to pick which compiler I’d start from, I’d choose ours even setting aside familiarity. Because there’d simply be much less code that I’d need to understand how to change, and I could potentially choose a better abstraction for the requirements (like the C++ team’s IR) once I knew how I needed to extend things.

It also solidified the taxonomy in my head of abstractions that you expect to remove code given only your current requirements, like our visitor pattern, and abstractions you expect to add code given only your immediate requirements, but that may provide extensibility, debuggability or correctness benefits.

## Scala

I also talked to a friend of mine who did the project in a previous term using Scala, but the project and tests were the exact same ones. Their compiler was 4141 raw lines and ~160kb of code not counting tests. They passed 8/10 secret tests and 100% of public tests and didn’t implement any extra features. So comparing with our 5906 lines without extra features and tests, their compiler is 0.7x the size.

One design factor in their low line count was that they used a different approach to parsing. The course allowed you to use a command line LR table generator tool that the course provided, which this team used but no other team I mention did. This saved them having to implement an LR table generator. They also managed to avoid writing the LR grammar using a 150 line Python script which scraped a Java grammar web page they found online and translated it into the input format of the generator tool. They still needed to do some tree building in Scala but overall their parsing stage came in at 1073 lines to our 1443, where most other teams use of LR parsing lead to larger parsers than our recursive descent one.

The rest of their compiler was similarly smaller than ours though without any obvious large design differences, although I didn’t dig into the code. I suspect this is probably due to differences in expressiveness between Scala and Rust. Scala and Rust have similar functional programming features helpful for compilers, like pattern matching, but Scala’s managed memory saves on code required to make the Rust borrow checker happy. Scala also has more miscellaneous syntactic sugar than Rust.

## OCaml

Since my team had all interned at [Jane Street](https://www.janestreet.com/) the other language we considered using was OCaml, we decided on Rust but I was curious about how OCaml might have turned out so I talked to someone else I knew had interned at Jane Street and they indeed did their compiler in OCaml with two other former Jane Street interns.

Their compiler was 10914 raw lines and 377kb including a small amount of test code and no extra features. They passed 9/10 secret tests and all public tests.

Like other groups it looks like a lot of the size difference is due to them using an LR parser generator and tree rewriting for parsing, as well as a regex->NFA->DFA conversion pipeline for lexing. Their front-end (lexing+parsing+AST construction) is 5548 lines where ours is 2164, with similar ratios for bytes. They also used [expect tests](https://blog.janestreet.com/testing-with-expectations/) for their parser where we used similar snapshot tests that put the expected output outside the code, so their parser tests were ~600 lines of that total where ours were ~200.

That leaves 5366 lines (461 lines of which is interface files with just type declarations) for the rest of their compiler and 4642 for ours, only 1.15x larger if you count interface files and basically the same size if you don’t count them. So it looks like setting aside our parsing design decisions, Rust and OCaml seem similarly expressive except that OCaml needs interface files and Rust doesn’t.

## Conclusion

Overall I’m very glad I did this comparison, I learned a lot from it and was surprised many times. I think my overall takeaway is that design decisions make a much larger difference than the language, but the language matters insofar as it gives you the tools to implement different designs.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
