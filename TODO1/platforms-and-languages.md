> * 原文地址：[Programming Languages and Platforms: an annotated twitter thread](https://medium.learningbyshipping.com/platforms-and-languages-f41960af9ec)
> * 原文作者：[Steven Sinofsky](https://medium.learningbyshipping.com/@stevesi?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/platforms-and-languages.md](https://github.com/xitu/gold-miner/blob/master/TODO1/platforms-and-languages.md)
> * 译者：
> * 校对者：

# Programming Languages and Platforms: an annotated twitter thread

## Languages and platforms are intertwined, often because platform makers are deliberate about choosing a language. A brief exploration based on recent feedback on Swift.

![](https://cdn-images-1.medium.com/max/800/1*pF4SnccOwcPW0p_06-8GzA@2x.jpeg)

Covers of the ACM SIGPLAN conference books on “History of Programming Languages” See http://research.ihost.com/hopl/HOPL.html

> An annotation of this twitter thread.

![](https://i.loli.net/2018/06/29/5b35a337c2ab5.png)

Thoughtful post and definitely worth a read for specifics but also for the general issue of language design and platforms.

Apple developing its own language was inevitable and its DNA. Most platforms desire to have their own language for a variety of reasons. Thread thoughts…

![](https://i.loli.net/2018/06/29/5b35a3873ccc4.png)

> The post by @monkeydom was of course a bit of a “rant” as are most writeups about programming languages. The topic is emotional and if you read through the normal emotions, you can see the very real question, “what problem did Swift solve and with what costs”? Turns out, imho, that this is almost always the reality in programming languages.

> I think the most interesting thing to explore is the relationship between programming languages and platforms. First some history.

Long ago, computer science == developing languages. It was like getting a PhD was an exercise in creating a programming language. We all used YACC, Lex constantly.

That came from the era of languages dramatically improving programming compared to assembly language.

> Really hard to overstate the lens of “programming languages” that permeated Computer Science in the 70s and 80s. Basically the field was “languages” and “theory” in most departments and things were either theories expressed in programming languages or programming languages to support/explore theory.

> For example, the first language I used in college was called PL/CS, a derivative of the proprietary language developed at IBM as a merger of FORTRAN and COBOL (“programming language/1”). The CS stood for the theoretical underpinnings of reducing programming errors by finding mistakes like uninitialized variables and bad loops at compile time — this was an invention and predecessor to tools like lint or even IDEs (in fact we used the first interactive editor/compiler called the [Cornell Program Synthesizer](https://www.researchgate.net/publication/213880306_The_Cornell_program_synthesizer_a_syntax-directed_programming_environment)).

> Every CS class was about learning a different language. Every conversation about CS was about what language were you using. Every resume, job interview, and more was about what languages you coded in. Even my interview at Microsoft in 1989 bounced from language to language and each interviewer asked me about a different language on resume.

> My summer job at the missile factory (Martin Lockheed) was originally to write COBOL programs. But when they found out I knew C (I actually didn’t but they had a Lattice C compiler I could use), they basically told me to write whatever I wanted and teach the COBOL programmers C. I spent the summer writing a MS-DOS version of a file copy/rename utility I used on CP/M…oh and also a tool to make “backup” copies of Lotus 1–2–3 copy-protected floppies.

> As early as sophomore year it was not uncommon for classes to create languages. The most popular junior level class was to build a compiler. A thorough tour through the “[Dragon book](https://www.amazon.com/Compilers-Principles-Techniques-Alfred-Aho/dp/0201100886/ref=pd_lpo_sbs_14_t_0?_encoding=UTF8&psc=1&refRID=V8RXCGW8XRNMK6KSD1YF)” building all aspects of a multi-pass compiler using all the tools of Unix.

Literally every conversation in the “computer basement” (actual physical place) devolved into a debate over which language was better. 4 years of college and 2 years of grad school (in PLs!) debating imperative, declarative, object, GC, functional, etc.

> By the time I got to graduate school the debates were in full force in the field because of the rapid expansion of teaching programming: what language is the best way to learn programming. Pascal was the traditional teaching language. But FORTRAN and COBOL were for jobs. Most of the university world was on Unix and thus C, but that was viewed as an “ugly” language. In fact, even though it was used to implement most research projects the academic view of PLs was to favor Lisp, Scheme, M, Algol (in Europe), Prolog, of course Smalltalk (we built an interpreter in our lab as a research bed) and so on. If you sense a theme across those languages it would be that none of them achieved commercial success.

> Because languages were so top of mind, there were a great many “memes” that would be printed out (on wide, green bar paper in dot matrix print) and hung in the computer rooms in the basement.

[Real Programmers Don’t Use Pascal](http://web.mit.edu/humor/Computers/real.programmers)

![](https://cdn-images-1.medium.com/max/800/1*x3RKdmnnYBw39Q_m3uR3Jw@2x.jpeg)

Dilbert 1992

![](https://cdn-images-1.medium.com/max/800/1*p0LRnrv99HEQUlwoF3DXlA@2x.jpeg)

Or this classic “[Shooting yourself in the foot in various programming languages](http://www.toodarkpark.org/computers/humor/shoot-self-in-foot.html)”

![](https://cdn-images-1.medium.com/max/800/1*L0-bq3gK56kHvxZoXMAMiA@2x.jpeg)

Then along came C, which seemed to break all the rules of advances in programming languages of abstraction, abstract data types, and so on. It was almost like ASM to academics. It was cringe-worthy.

Then it won.

> But what really happened was the broad commercialization of programming. Nearly everyone who came back from a summer job (like I did) came back having worked in C or found out they needed to learn C for next summer. Literally no place used Pascal and while you could use PL/1 if you worked at IBM, even IBM wasn’t totally committed. Plus we were doing all of our work on Sun Workstations and so C was clearly the language to use. I bought my first K&R used for $5 and then found it it was a pirated copy printed in India “illegally” (so also my introduction to copyright law). C clearly one. There were even complaints from freshman about using PL/1 and about how they were forced to use Pascal in high school (the AP test was just starting in the mid 80s).

Early on both MS-DOS and Mac were dominated by ASM (for real™️ programmers) and Pascal. Even some effort to port COBOL and FORTRAN. Mainframes mired in the world legacy and PL/1. On there was BASIC :-)

But then a race to move to C and most commercial PC s/w was C+ASM.

> The primary reason for the love of C was that more and more programming was moving from mainframes to PCs (the IBM mainframe lacked a C compiler even!). While across campus you could get lots of part time work porting mainframe code to PCs, most people realized that was futile and there was much more excitement about making new solutions on PCs using cheap tools like Lattice C and especially Turbo C. Basic was not as popular then as you could imagine, though many places were now teaching it simply because of the ubiquity of PCs. In 1984 there was even Mac Basic from Microsoft (which was actually used in the Cornell Hotel School freshman classes).

> PCs until Windows 3.0/i386 were severely memory constrained and so there was also a lot of assembly (ASM) programming. Compilers were still not so great and a lot of things like floating point math or I/O could be (or had to be) done with ASM. It was common to see the C construct _inline{} and system calls or floating point computation in most commercial code.

The Mac in 1984 really wanted to be Pascal (elegant) and all the early tools from Apple were Pascal. C was supported. Eventually C came to dominate Mac development as well.

Obj-C on NeXT and then iOS was inevitable.

> The Mac was always about elegance, control, vertical integration, and to a great extent “education” from the start. It was natural for the Mac to have chosen Pascal, especially given the timing of the start of the project. Like most 1983 Mac Programmers I was using Pascal. The first Toolbox books and Apple tools (MPW wasn’t quite ready) were all Pascal based. In fact if you started early enough, you had to be a lucky owner of a Lisa in order to do any Mac development at all since it was hosted there.

> This didn’t last long as the third party world like Lightspeed and others were hard at work delivering “professional” languages like C. I switched to Lightspeed before there was MPW or C and never looked back.

> The key to Pascal was that it allowed a very clear API documentation with no ambiguities or craziness around #define or other things that I am sure all seemed rather messy. The documentation for the Toolbox was incredible in that regard.

> For those reasons, fast-forwarding a few years to NeXT it was inevitable that with the rise of “object-oriented” and C++ that they would choose Objective-C to replace Pascal where they could have OO features like classes along with memory management/garbage collection which would solve a lot of programs with that had dogged the non-virtualized Mac OS.

Graphical platforms have always had a strong desire to “own” a language. This comes from a desire to be in control fo expressing the OS in the most consistent way possible.

Some would argue, in an old school way, this was about being “proprietary”.

> It is important to keep in mind that the separation we see today between platforms and languages through abstraction layers didn’t really exist back then. The ability to use both C and Pascal to write a Mac program was pretty unique in the world of graphical interfaces. And of course graphical interfaces themselves were proprietary — proprietary was a key thing in terms of how vendors approached everything. It was also a negative for how customers viewed everything, because “proprietary = lock-in” and pretty much what everyone was afraid of was being subject to another round of proprietary “small computers”.

Developers would always want to port their code from one OS to another. And as talked about a lot here, early in platform evolution the platforms are more common than different and this seems possible.

So a proprietary language is viewed as “lock in”.

As a practical matter though once most of your code is calling OS APIs, using a standard/public/official language is perfectly “proprietary”.

Think of how much code (or how intertwined) code AND architecture is when writing for a platform. Lots.

That doesn’t stop the big push within a platform to own a language. As platforms evolve the ability to build great tools (especially symbolic debuggers) can be made easier with a focus on one language you control.

> This mindset contributed to a desire for platform vendors to have their own languages. It made things that much more difficult to move from one GUI to another. Of course this all seems (and even at the time seemed) somewhat silly since once you’re writing a bunch of code on a platform that does user interaction, chances are pretty much zero that code will work anywhere else.

> Still, in the world where new graphical interfaces were more in common than different (sort of like how mobile was 5 years ago) customers were really pushing for standard languages. This led vendors to “support” C, Pascal, Basic, and even COBOL to program their GUIs. But this was a bit of a head fake — mostly it meant providing header files/imports for those languages but not really documentation, samples, etc, which were left to language/compiler vendors.

> In order to drive more certainty around ownership of APIs and languages, platform makers were always extending their compilers. They would add little things to make their libraries/APIs easier to read or generate better code. Sometimes these were done through legit extension mechanisms (like in C, you could make up keywords if they had __ in front of them like __cdecl).

> To me this was always weird, because all your GUI code couldn’t port anyway so it didn’t matter either way if the language was “standard” or not. If you were the customer it didn’t matter, and if you were the vendor why use dev resources to make a compiler on your own different which would take away from other improvements that mattered (code gen or link speed for example).

Fun story. Some huge internal debates we had building the Microsoft Foundation Classes for Win/C++ was internal mandate to extend C++ unilaterally.

I always thought idea of adding to C++ was crazy, given that ANSI couldn’t even stop adding junk! I held out as long as I could.

> It was just crazy though the pressure when building a C++ library for Windows to add compiler extensions. The marketing team wanted it. The OS group wanted. The NT team really wanted extensions (to improve their compile speed!) Even the CEO :-) I spent a lot of time in meetings trying to defend the reality we were dealing with which is that C++ itself had not yet standardized (ANSI XJ316 wasn’t done).

> A cool moment was when our main competitor, Borland Object Windows Library (OWL) added extensions to make it easier to deal with Windows WM_ message handling. I though that was totally lame and our team (all 3 of us) had spent a lot of time making sure our “Message Maps” used straight C++ and had no overhead. There is a great USENET newsgroup battle between me and my Borland friends over this debate. We won. :-)

Hence we see Android, iOS, and .net among others with their own languages. Ugh.

> Still this mindset of control, expression, trying to focus efforts, and more leads to where we are today with each platform having a language. I just think this is part of the evolution of platforms and not an evil plot. Ultimately, it sort of doesn’t matter so long as the platform maker is a good steward of the toolset, not just the language semantics.

> iOS had Objective-C and now Swift; Android had Java and now Kotlin; Even Azure is about .net and C#. Of course *all* of them support C and have tons of examples of many languages.

> Of course through all of this the browser and HTML/Script are the leading language by number of programmers, lines of code, and consumption of code. Quite remarkable. Even though I am rooted in compiled “professional languages” I am a huge fan of that runtime because it is so accessible and it is the “right” tool for so many people. My faith has been tested quite a bit with the advent of massive numbers of frameworks that stretch the definition of script though (though many would say what Office did with HTML and CSS is quite similar in terms of usage versus original intent). That’s another post :-)

> But a big thing has changed, and that is the cloud. Not just the location of code, but the types of programs are fundamentally different and there is a need for other languages. Those languages, Python, and more, and evolved quite a bit.

The cloud and APIs have a way of hiding programming languages and led to a resurgence of new languages. Part of this is b/c tooling used by most is a lot like early compute days: VI (or emacs 😩) and lots of logs/diagnostics (+ some A+ platform specific tools for sure!).

> One of the big drivers of having a dedicated platform language is from needing to invest in tools for the platform. Tools are *very* platform centric and require a lot of work. In fact often what brings success to a platform is not the quality of the platform or APIs, but the tools. The winner isn’t the best platform but the platform with the best tools. Curse XCode all you want but boy it was pretty darn good 8 years ago compared to Android. And Visual Studio is a juggernaut for enterprise team development.

> The cloud, however, brought new scenarios and importantly no single owner. Services and APIs come from all over. So today there is enormous diversity in cloud “languages” and it is not uncommon to look at something like Stripe or Twilio and see code examples and imports in several/many languages. And this is done on purpose and with a big investment.

While you can see from StackOverflow there is a diversity of language usage (https://insights.stackoverflow.com/survey/2018/). It is likely that the platforms will begin to drive a convergence there as well — for the same reasons that we saw on the client side.

Language diversity is great but tooling requires some focus. While we see innovation, by and large we see incremental improvements in expressiveness in exchange for “static” tooling.

> This is where we are today, where there is an appearance that from Python, PHP, Ruby, Typescrpt, to Scalr we see a massive diversity in languages. This seems great. In practice this can be kind of a headache for a developer or an engineering manager. I see a lot of startups with multiple languages in play and think about scaling challenges they will have in terms of hiring, load balancing, managing toolchains, and more. With diversity come benefits and challenges.

The cloud does hide languages but cloud platforms will become closer to languages as well.

> The cloud does hide these differences between vendors though. It seems like a positive. My view is that this is a “point in time”. That as cloud vendors invest more “irrationally” in tools in order to win the platform war, languages will consolidate and there will be a much shorter list of supported languages.

> While today this seems evil because most people are riding “above” the platform, as the platforms become richer and more than “infrastructure” the code written to a given cloud provider will be more intertwined and benefits of improved tooling, documentation, even samples will lead to a customer betting more and more on the vendor and language. While this is what the platform vendor wants, it also helps the customer even if it seems evil.

> Ultimately, the platform with the best tools is likely to win, especially in the enterprise where tools matters even more (larger number of employees with diverse skills and backgrounds compared to a small startup of recent grads).

// PS: Paul Graham’s very early posts on programming languages are super fun to read (and always shocking as Cornellian that he used Lisp!) paulgraham.com/avg.html

> This essay is a classic and really captures the zeitgeist of the language debate in the 80s. Blurb!!

// PPS: Two universal learnings on languages:

1/ Great programmers don’t program “in” a language but “into” a language —> any language will work and they adapt style.

2/ Building a product is not building a language test suite. Don’t use all the features b/c they are cool/new.

> 1/ is straight out of the first day of Cornell CS 211 taught by the extremely well known David Gries, a pioneer in the area of programming correctness and one of the leaders of the PL/CS project. To say this statement had an impact on me would be an understatement. This is why I sort of exaggerated by C knowledge that summer of 1984. I figured he had taught be PL/CS and I could easily program “into” C.

> 2/ is straight out of a learning I had from a talk that Martin Carrol (then of AT&T) gave at the 1991 USENIX C++ conference which had a similar impact on me in . There’s a whole long story (which should be a podcast) about the history of building the Microsoft Foundation Classes and how we built the first version using every “object oriented” trick like multiple inheritance, operator overloads, virtual bases and more. We threw the whole thing away and declared ourselves as a team “_recovering oopaholics_”.

> Part of my support group was going to USENIX and getting a dose of some hacker views of C++. I was the youngest person there and the only Windows (and OS/2) person for sure. But Martin’s talk was basically a rant against all the things proposed for the 2.0 definition of C++ (templates, exceptions, and more) and I \*loved\* it. I came back and the 4 of us met deciding how to move forward and we decided two things:

> • We are building a class library, not a compiler test suite. So no templates, exceptions, operator overloading, virtual bases, references, and more. We’re about performance, readability, Windows, and so on.

> • We will just use standard C++ and not worry about extending the language. Importantly we would not be dependent on language features still being debated in the ANSI committee (which would take 5 years or more to finalize to the brown book).

> So this is where MFC’s platform architecture came from. A reaction to “oopaholism”.

> Is is also why I liked @monkeydom’s post so much. It reminded me of the rant I wrote against the polluting of C++ and how everyone got too excited over a language and forgot what we were here to do — make Windows programming easier.

— Steven Sinofsky

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
