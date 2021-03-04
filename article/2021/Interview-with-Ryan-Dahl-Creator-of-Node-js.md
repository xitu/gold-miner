> * 原文地址：[Interview with Ryan Dahl, Creator of Node.js](https://evrone.com/ryan-dahl-interview)
> * 原文作者：[Ryan Dahl](https://evrone.com/ryan-dahl-interview)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Interview-with-Ryan-Dahl-Creator-of-Node-js.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Interview-with-Ryan-Dahl-Creator-of-Node-js.md)
> * 译者：
> * 校对者：

# **Interview with Ryan Dahl, Creator of Node.js**

## Introduction

Ryan Dahl is a software engineer and the original developer of the Node.js, and the Deno JavaScript and TypeScript runtime. We are glad to have had an opportunity to speak to Ryan about his projects, the main challenges in Deno, hear his thoughts on the future of JavaScript and TypeScript, find more about the third-party Deno ecosystem projects and discuss how he would have changed his approach to Node.js if he could travel back in time!

## The Interview

**Evrone:** Your new Deno project is quite an impact among developers. What are you doing right now most of the time?

**Ryan:** I'm working on Deno most of the time! Deno is actually a moderately large collection of software that comes together in the executable that we ship. We are improving the Deno runtime but we are also working on applying the underlying infrastructure in commercial projects too.

**Evrone:** You have hands-on experience with lots of programming languages: C, Rust, Ruby, JavaScript, TypeScript. Which one do you enjoy the most to work with?

**Ryan:** I have the most fun writing Rust these days. It has a steep learning curve and is not appropriate for many problems; but for the stuff I'm working on now it's perfect. It's a much better C++. I'm convinced that I will never start a new C++ project. Rust is beautiful in its ability to express low-level machinery with such simplicity.

JavaScript has never been my favorite language - it's just the most common language - and for that reason it is a useful way to express many ideas. I don't consider TypeScript a separate language; its beauty is that it's just marked up JavaScript. TypeScript allows one to build larger, more robust systems in JavaScript, and I'd say it's my go-to language for small everyday tasks.

With Deno we are trying to remove a lot of the complexity inherent in transpiling TypeScript code down to JavaScript with the hope this will enable more people to utilize it.

**Evrone:** Gradual typing was successfully added into core Python, PHP, and Ruby. What, in your opinion, is the main showstopper for adding types into JavaScript?

**Ryan:** Types were added to JavaScript (with TypeScript) far more successfully than has been accomplished in Python, PHP, or Ruby. TypeScript is JavaScript with types. The better question is: what is blocking the JavaScript standardization organization (TC39) from adopting TypeScript? Standardization, by design, moves slowly and carefully. They are first looking into proposing Types-As-Comments, which would allow the JavaScript runtimes to execute TypeScript syntax by ignoring the types. I think eventually TypeScript (or something like it) will be proposed as part of the JavaScript standard, but that will take time.

**Evrone:** As a respectable VIM user, what do you think of modern programmer editors like Visual Studio Code? Are they good enough for the old guard?

**Ryan:** Everyone I work with uses vscode and they love it. Probably most people should use that.

I continue to use VIM for two reasons. 1) I'm just very familiar and fast with it, I like being able to work over ssh and tmux and I enjoy the serenity of a full screen terminal. 2) It's important for software infrastructure to be text-based and accessible with simple tools. In the Java world they made the mistake of tying the IDEs too much into the worldflows of the language, creating a situation where practically one was forced to use an IDE to program Java. By using simple tooling myself, I ensure that the software I develop does not become unnecessarily reliant on IDEs. If you use grep instead of jump-to-definition too much indirection becomes intolerable. For what I do, I think this results in better software.

**Evrone:** The Deno runtime showcased the possible ways to fix long-standing issues with dependency management, security, and more. Do you want it to be like Haskell, a place for experiments, or do you have any usage in mind where it can be the best practical choice?

**Ryan:** Don't mistake newness for experimental. Deno is absolutely meant to be practical and it is built on many years of prior experience in server-side JS. My colleagues and I are committed to building a practical dynamic language runtime. The design choices we've made around dependency management and security are quite conservative. We could have easily introduced yet another centralized NPM-like system, but instead have opted for a web standard URL based linking system. We could have more easily opened all sorts of security holes into the file system and network; instead we chose to carefully manage access, like in the browser.

Deno is new software - that makes it inherently inappropriate for many use cases. But Deno is also a large Rust code base with strong velocity, a solid always-green CI, and regular scheduled releases. It is not an experiment.

**Evrone:** In 2020 most software developer conferences became "online" and "virtual". Have you tried the new format and what do you think about it?

**Ryan:** I have attended some; but I am avoiding them for now. For me the best part of conferences are the "hallway tracks". This is a critical missing aspect of online conferences. I prefer to watch talks on youtube, in my own time, at 2x speed. Hopefully I will be able to attend some non-virtual conferences later in 2021.

**Evrone:** The idea to decentralize the dependency graph from one file into individual source code files was championed by Webpack and praised by many developers. But dependency management is challenging, it took Node.js years to move from Common.js to ESM. What are the main dependency management challenges you want to solve with Deno?

**Ryan:** Browsers have not blessed any one CDN for distributing JavaScript - the decentralized nature of the web is its greatest strength. I don't see why this can't also work for server-side JavaScript too. Thus I want Deno to not be reliant on any centralized code database.

**Evrone:** Python and JavaScript are competing to be the best general-purpose programming language we should teach first to new developers. What is your opinion on that?

**Ryan:** Scripting languages are good for beginners. Python and JavaScript are, in essence, fairly similar systems, with different syntax and slightly different semantics. JavaScript is managed by an international standards committee, runs everywhere, is about an order of magnitude faster (when comparing V8 to cpython), and has a larger user base. For certain domains there are more Python libraries available, particularly in scientific computing. Depending on what a new programmer is trying to do, Python might be appropriate. However, generally, I think JavaScript is a better introductory language.

**Evrone:** The asynchronous concurrency paradigm with one main thread and small "handler" callables was one of the Node.js cornerstones. Now, this idea is elevated even more with a new "async/await" syntax and "coroutines" concept. As a platform author, what do you think about them and their available alternatives like Go "goroutines" or Ruby thread-based concurrency?

**Ryan:** OS threads do not scale well to high concurrency applications. Don't use Ruby if you will have many concurrent connections.

Goroutines are wonderfully simple to use and achieve peak performance. Node and Deno are, like Go, built on non-blocking I/O and OS event notification systems (epoll, kqueue). JavaScript is inherently a single threaded system, so a single instance of Node or Deno generally cannot take advantage of all the CPU cores on a system without starting creating new instances. Node/Deno are optimal for JavaScript, but Go is ultimately a better choice for high concurrency systems in the absence of other requirements that might lean preference towards JS.

**Evrone:** With so much competition around, how do you see the future of JavaScript and TypeScript, especially related to the backend, embedded, and ML areas?

**Ryan:** Dynamic (or 'Scripting') languages are useful. Very often the problem a programmer is addressing is not CPU bound. More often the problem is engineering-time bound. It's more important to be able to develop and deploy quickly. Of the dynamic languages, JavaScript (pure JavaScript or JavaScript with types) is the most popular and by far the fastest. In the future, I believe the only dynamic language we reach for will be this strange evolved language that grew out of web browsers. With Deno we are working towards removing the obstacles in applying JS in places where it is currently infrequently used, like in ML. For example, we are likely going to add WebGPU support to Deno, allowing easy out-of-the-box GPU programming that will eventually allow systems like TensorFlow.js to run on Deno.

As I mentioned before, dynamic languages have their limitations and are not appropriate for all problem domains. If you are programming a database, it makes sense to write in a language that gives you the most control over the computer - like Rust or C++. If you're writing a high concurrency API server, it is hard to imagine a better choice than Go.

**Evrone:** Modern operating systems and your new Deno runtime introduce granular permissions to offset the security risks of third-party software and dependencies. But is it possible for end users and developers who use dependencies to make good decisions while "allowing" and "declining" application security requests? What do you think about the risk that within a few years we will auto-click on "allow everything" like most of us do with website cookie "security confirmations" right now?

**Ryan:** Website cookie popups are not the best analogy - they're a fairly useless legal byproduct. Better is the built-in dialog that says "Allow this website to access your camera" or "Allow desktop notifications" or "Allow this website to see your location". These are not useless - these are fairly important security features.

Programmers run many random automations on their computer. No one has the time to audit all the code they're about to run, nor is it sufficient to run everything in a Docker container: When you run lint, is that isolated? No, the answer is you must trust that the lint script will not hack your system. I think it's very appropriate to allow users to see and potentially reject unnecessary system access.

**Evrone:** The new "full-stack" idea promotes developers to write both frontend and backend code, which is now surprisingly easy with the same language and shared technology stack like TypeScript. Do you think it's a good idea for lots of developers to put so many different things into their everyday work scope?

**Ryan:** Reducing complexity is always beneficial. The fewer languages, VMs, frameworks, concepts a programmer has to interact with, the better.

**Evrone:** How are you planning to handle version updates for the TypeScript language itself? Within the Node.js ecosystem, JavaScript syntax updates with the V8 engine often result in some packages not working.

**Ryan:** The TypeScript language is very nearly feature complete. Users depending on cutting edge language features may experience instability - don't do that.

**Evrone:** How do you see good education for a software developer? Do we need a "science" like "computer science" with all math, algorithms, and data structures or do we need something else?

**Ryan:** People who want a career in programming should go to university and study computer science. One can, of course, get by with a degree in a related fields (like electrical engineering, physics, mathematics); there are many very capable engineers who have no degree at all. But there is really something to be gained by spending some years learning the fundamentals and doing a lot of very difficult labs.

**Evrone:** Are there any third-party Deno ecosystem projects already implemented that you really like?

**Ryan:** Yes, sure:

- A React Framework
- Web framework (like express)
- web-based GUIs for desktop applications
- puppeteer (same as in Node)
- visualize module graphs
- A minimal but flexible static site generator

**Evrone:** With the introduction of social platforms like GitHub, it's now easy for both individual developers and big companies to use open source and contribute back. Is it a "golden age of open source" right now or are there issues that are not visible at first sight?

**Ryan:** Certainly open source is now standard, the licensing situation is widely understood and generally settled. There are still open questions about the incentive model for maintenance, maybe Github Sponsors is helping in that direction. It's better than it was, but I expect we'll figure out a way for people who maintain important bits of software to be independently paid for their effort.

**Evrone:** Deno is already a few years old. What are the main technical challenges for the project right now?

**Ryan:** There's a lot going on: We're building bindings to the Hyper web server, which will provide HTTP/2, and likely be much faster than the current web server. We're building "deno lsp", which provides the Language Server Protocol so that VSCode (and other IDEs) can talk directly to Deno to get syntax highlighting, type checking, formatting, etc - expect the editing experience to improve dramatically over the next couple months. We're working to pass as much of the Web Platform Tests as possible - so Deno is becoming much more web compatible over time. Check out the Q1 roadmap for more details.

**Evrone:** Our signature time-travel question: if you could travel back in time and give only one piece of advice to your younger self when you just started to develop Node.js, what advice would it be?

**Ryan:** Early on in Node I was quite unsure if asynchronous I/O was tractably usable in large projects by novice programmers. I went around giving talks making this claim, but I was rather unsure how it would work out. If I could go back in time, I would reassure myself that it will work. I'd then tell myself that Node is going to become a pivotal piece of software, and that large software projects require different concerns than small projects: budget, communication, organization. I would tell myself to spend more time on these meta problems.

**Evrone:** Any advice for developers who want to support Deno with their npm packages?

**Ryan:** Use ES modules and have a look at our Node compatibility layer.

## The conclusion

We were glad to speak with Ryan and learn more about his life, thoughts & projects. At Evrone, we frequently use Node.js to develop custom solutions for our clients. If you love it as much as we do — just send us a message via the form below, and let's have a chat!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
