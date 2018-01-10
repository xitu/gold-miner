> * 原文地址：[A Simple Web App in Rust, Conclusion: Putting Rust Aside for Now](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-conclusion/)
> * 原文作者：[Joel's Journal](http://joelmccracken.github.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-conclusion.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-conclusion.md)
> * 译者：
> * 校对者：

# A Simple Web App in Rust, Conclusion: Putting Rust Aside for Now

_Warning: this whole piece is full of opinion. It probably isn't surprising to anyone in the Rust community, but I want punctuate the series._

Several years ago, I worked on a series of blog posts entitled "Building a Simple Webapp in Rust". I hoped to return to it at some point, but I have not, and I doubt I ever will finish the series – at this point, almost everything in the post is probably out of date.

In one important sense, the project was a success: I learned a ton about Rust.

I did eventually stop the project, and stop learning Rust. Why? In short, I began to doubt that Rust held enough value **for me** versus other avenues of interest. It is clear to me that Rust is a great language for situations that require tight control over the hardware and performance. Given a project with these requirements, I would absolutely start using Rust again. If I had any situation where I would otherwise write C++, I would use Rust.

However, hardware control is not the most important factor in most of the software I write. I never write software in C++. Clarity and maintainability are the most important factors, balanced against development time. Performance issues can almost always be addressed after the software works, by performance testing and making smart optimizations.

There was one compelling reason for me to continue investigating Rust: I have heard some say Rust is the most productive language for them, and they believe this would apply to programmers in general. The reasoning goes that the ownership system makes them think more about their code, and in some ways significantly influences design for the better. I think this is quite possible, but I am not convinced enough to invest a significant amount of time in Rust. I think my time is best spent elsewhere.

Ultimately, I decided that my time would be better spent learning other things. Specifically, Haskell (by way of Elm initially) and other languages with powerful effects systems.

—

Series: A Simple Web App in Rust

* [Part 1](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-1/)
* [Part 2a](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2a/)
* [Part 2b](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2b/)
* [Part 3](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-3/)
* [Part 4](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-4-cli-option-parsing/)
* [Conclusion](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-conclusion/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
