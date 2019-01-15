> * 原文地址：[Let's talk JS ⚡: documentation](https://areknawo.com/lets-talk-js-documentation/)
> * 原文作者：[Arek Nawo](https://areknawo.com/author/areknawo/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lets-talk-js-documentation.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lets-talk-js-documentation.md)
> * 译者：
> * 校对者：

# Let's talk JS ⚡: documentation

If you were ever making any kind of open source project or any for that matter that's so big that it needs a proper documentation, you might know how important it is to make it properly. Also, documentation needs to be always up-to-date and should cover the whole public API. So, how to make **the perfect docs**? That's the question, this post aims to answer in JS style! ⚡  

![two person holding ceramic mugs](https://images.unsplash.com/photo-1521798552185-ee955b1b91fa?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjExNzczfQ)

Photo by [rawpixel](https://unsplash.com/@rawpixel?utm_source=ghost&utm_medium=referral&utm_campaign=api-credit) / [Unsplash](https://unsplash.com/?utm_source=ghost&utm_medium=referral&utm_campaign=api-credit)

## And then there were two...

There are only two ways of doing documentation for your project. These are **writing it yourself** and **generating it**. No black magic here, there's just no other way.

So, let's investigate “writing docs yourself” option first. In, this scenario you can easily create beautiful docs site. Of course, it will require a bit more work for you to do, but if you think it's worth it, then go for it. 👍 Also, you need to consider that keeping your docs updated will also create an additional overhead. On the side of pros, customizability is the biggest player. Your docs will probably be written using **markdown** (most commonly **[GFM](https://guides.github.com/features/mastering-markdown)**) - it's just kind of standard. You can make it look beautiful, which is especially important if you're creating OSS. There are some libraries to aid you in this task and I'll dig into that a bit later.

Next, we've got an option to generate docs from the code itself. Obviously, it isn't as straight-forward either. First, you have to use a tool like [**JSDoc**](http://usejsdoc.org) to write your documentation in form of **JavaDoc-like** comments. So, you're not going to just generate your docs from nothing. Now, **JSDoc** is quite great. I mean, just look at its official docs and see how many tags you can use. In addition, modern code editors will pick up your type definitions and other descriptions and will aid you later in the process of development with autocompletion and pop-up documentation functionality. You won't achieve the same effect when writing plain markdown. Naturally, you'll have to write things like **README** separately and generated docs will fell a bit procedural, but I don't think that this would be any bigger problem.

## Choose the right tool...

So, let's say that you've decided to create your documentation by hand (or should I say keyboard) and used markdown (or you've just got markdown from some other source). Now you'll most likely need a so-called **renderer** which will turn your MD (markdown) into a beautiful combination of HTML, CSS etc. Of course, that's only when you don't want to just publish MD to GitHub, GitHub's wiki etc. or to just have plain MD with an additional **reader** ([like this](https://typora.io)). Now, let me help you decide and list some of the best tools for that job (IMHO). 😉

### [Docsify](https://docsify.js.org)

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-19-27-21.png)

Docsify landing page

**Docsify** is being showcased as _A magical documentation site generator._ and well... it does its job quite nicely. What's important is that it renders your documentation **on the fly**, which means that you don't have to parse your MD to HTML - just put your files, where they should be and you're good to go! Also, Docsify has a great number of plugins and some themes to choose from. It's also well-documented (like a documentation generator should be). I might be a little biased as [my own project's documentation](https://areknawo.github.io/Rex) is using this tool. The only problems with it (at least for me) is that's its compatibility with IE10+ (as written on its page) is not really good (but they're working on it) and it **lacks support for relative links**.

### [Docute](https://docute.org)

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-19-49-19.png)

Docute v4 documentation

**Docute** is a similar tool to Docsify with _a cute name_. The newest version (v4) feels a bit less documented than [the previous one](https://v3.docute.org) but it also simplifies things a little bit. Generated docs look minimalistic, simple and elegant. The theme can be customized using **CSS variables**. Docute doesn't have so robust plugin system as Docsify, but it has its own advantages. It's built on Vue.js, which result in slightly bigger bundle size than that of Docsify but also allows for a lot of extendability. For example, in your MD files, you can use some of the built-in Vue components or even your own ones.

### [Slate](https://github.com/lord/slate)

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-20-19-16.png)

Slate documentation

**Slate** is probably the leader when it comes to documenting your projects and its stars on GitHub (**~25,000**). Its docs feature clean and readable syntax with the _everything-on-one-page_ feature. It comes with pretty solid GH wiki documentation. It allows for [vast theming](https://github.com/lord/slate/wiki/Custom-Slate-Themes) but you'll have to do digging yourself as the documentation doesn't provide much info. Sadly, it isn't much extendable, but quite feature-packed. It seems like especially good option for those who need nice docs for **REST** API. Keep in mind that Slate generates static HTML files instead of doing this at runtime.

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-20-35-03.png)

Docusaurus landing page

### [Docusaurus](https://docusaurus.io)

**Docusaurus** is a tool for _easy to maintain open source documentation websites_. It's built by Facebook using - you guessed it - React. It allows for easy translation and integration with React component and library as a whole for creating custom pages. It also features an ability to set up additional **blog** straightly integrated with your docs website or even only by itself! It can be well-integrated with [Algolia DocSearch](https://community.algolia.com/docsearch) for making your docs easy to navigate. Just like Slate, it generates static HTML files.

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-21-27-48.png)

VuePress landing page

### [VuePress](https://vuepress.vuejs.org)

**VuePress** is a _Vue-powered static site generator_ made by the same guys who created Vue.js. It's the power behind Vue.js documentation. As a generator, it has really great documentation. It also features a robust plugin and theming system and, naturally, great Vue.js integration. VuePress is advertised as SEO-friendly because of the fact that it generates static HTML files as an output.

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-21-39-29.png)

GitBook landing page

### [GitBook](https://www.gitbook.com)

**GitBook** is a service for writing MD documentations & texts. It gives you AiO experience with an online editor and free **.gitbook.io** domain. The online editor is great - no doubt about that, but there aren't many customizability options when it comes to layout. The editor also has its legacy desktop version. But, unless you're doing an open source project, you'll most likely have to pay for it.

## ...and generator!

Now that we've covered the best of the best documentation-making tools, let's get to the generators, shall we? Generators mainly allow you to create documentation from your annotated code.

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-21-54-31.png)

JSDoc landing page

### [JSDoc](http://usejsdoc.org)

**JSDoc** is probably the most obvious and well-known docs generator for JS. It has support for many, many tags and is welcomed in almost all editors and IDEs with autocompletion support. Its output can be customized in many various ways using themes. Believe me, or not - there's plethora of them. What's even more interesting that with this and many other generators, you can output **markdown** for later use with any of documentation tools listed above.

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-22-01-26.png)

TypeDoc landing page

### [TypeDoc](https://typedoc.org)

**TypeDoc** can be considered as JSDoc for [TypeScript](https://www.typescriptlang.org). It's worth including in this list mainly as one of not-so-many (or any) documentation generators that support TS types. By utilizing this tool, you can generate your documentation based on TypeScript type system including structures like interfaces and enums. Sadly, it supports only a small subset of JSDoc tags and doesn't have as big community as JSDoc does. Thus, it doesn't have many themes either and its documentation is lacking. The best way IMO to use this tool effectively is to use the **markdown** theme plugin and use one of the documentation tools with that.

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-15-09-44-43.png)

ESDoc landing page

### [ESDoc](https://esdoc.org)

**ESDoc** is similar in its functionality to JSDoc. It supports a set of tags similar to the one of JSDoc. It has optional support for documentation linting and coverage. It has really vast plugin collection. Also, there are some proof-of-concept plugins for likes of TypeScript, Flow and markdown output.

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-15-09-54-29.png)

### [Documentation.js](https://documentation.js.org)

**Documentation.js** is modern documentation generator, which can output HTML, JSON or markdown for great flexibility. It has support for features like ES2017, JSX, Vue templates, and Flow types. It is also capable of **type inference** and naturally - JSDoc tags. It has deep theming options based on underscore templates. Sadly, (for me) it doesn't support TypeScript. 😕

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-15-10-14-11.png)

DocumentJS landing page

### [DocumentJS](https://documentjs.com)

**DocumentJS** is a bit less popular than its competitors above, solution for documentation generation. It supports most of JSDoc and Google Closure Compiler tags with the additional functionality of adding yours. By default, it can only generate themeable HTML but it has vast extending capabilities.

## Something different...

So, above I've listed some of standard documentation tools and generators. Naturally, they can be used together to create nice docs. But I'd like to present you with yet one more tool. Have you ever heard about **literate programming**? In general, it means that you'll be documenting your code by writing comments **with markdown syntax**. It literally turns your code into poetry.

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-15-10-33-58.png)

Docco landing page

Then, you use a tool like **[Docco](http://ashkenas.com/docco)** to turn your markdown-commented code into markdown with code snippets. I can say that this is something new to try. 😁

## There you have it 😉

I hope that this article has at least made your life a little easier when it comes to creating docs. The list above consist of only the best and (for now) mostly well-maintained project. If you like this article, consider sharing it, following me on Twitter or subscribing to the mailing list below for more nice content. 🦄

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
