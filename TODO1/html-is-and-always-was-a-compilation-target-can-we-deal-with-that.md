> * 原文地址：[HTML is and always was a compilation target – can we deal with that?](https://christianheilmann.com/2019/01/28/html-is-and-always-was-a-compilation-target-can-we-deal-with-that/)
> * 原文作者：[Christian Heilmann](https://christianheilmann.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/html-is-and-always-was-a-compilation-target-can-we-deal-with-that.md](https://github.com/xitu/gold-miner/blob/master/TODO1/html-is-and-always-was-a-compilation-target-can-we-deal-with-that.md)
> * 译者：
> * 校对者：

# HTML is and always was a compilation target – can we deal with that?

Every few weeks the webdevelopment Twitter world gets in a frenzy over terrible HTML. HTML that is only DIVs and SPANs with random classes on them. HTML lacking any sensible interfaces like anchors or buttons. HTML lacking any structure like headings and lists. Non-semantic HTML. Unreadable HTML.

HTML is well defined. It is also robust, inasmuch that it is forgiving. We tried to make HTML less forgiving in the XHTML days but the web was not in a state to allow for that. Developer mistakes should not result in user lock-out. Instead, browsers should be lenient with HTML and fix things on the fly when rendering. This should worry us, as we are forced to carry with us years of horrible browser decisions. That’s why – amongst other things – browsers are fat and slow.

## HTML is forgiving

This leniency, however, helped the web survive. It ensures that today’s browsers can show age-old content without us having to go back and change it. Years of Flash content now not available proves that this is a sensible thing to do in an environment as fluctuating as the web.

> It does mean, however, that there is no perceivable punishment for non-semantic HTML. DIVs and SPANs work, Table Layouts still work (oh, hai, [hackernews](https://news.ycombinator.com/)).

Browser showing anything should worry us as it makes writing “clean” and “semantic” HTML a nice to have. A special skill. The caligraphy of writing for the web, where most of the other content is random smeared scribbles on dog-eared sticky notes.

Semantic HTML is better, there is no question about it. You get a lot of free accessibility benefits from it. It tends to perform better. It often means that you have no third party dependencies. It is also much easier to read and understand. And many of us learned about the web by looking at the source of other web sites. This is an anachronism, and [I wrote about this in length a few months ago](https://christianheilmann.com/2018/07/09/different-views-on-view-source/).

It is time we start dealing with this on a more mature level rather than re-iterating the same complaints every few months.

> HTML is and has always been a compilation target. The wonderful world of “hand-crafted HTML” is one for a very small group of loud enthusiasts.

I am part of that group and I have been ever since I started blogging 14 years ago. I love that the web is accessible to all. All you needed was a text editor, some documentation and you’re off to publish on it.

## Hand-written HTML is a rarity, a collector’s item

However, even 20 years ago when I started as a web developer, this was not how people worked. This was not how most web products were created. In fact, it was even that uncommon that in any job description I wrote we specifically asked for “hand written HTML/CSS/JS skills”. It was an elite, highly interested and invested group who cared about that. Good people to hire if you want to make a change for a cleaner, more semantic web. But was that change even in demand?

The larger part of the web was based on other technology:

*   Server-Side-Includes (remember .shtml pages)
*   CGI/Perl templating systems
*   Content Management Systems with own templating languages rendering out HTML
*   WYSIWYG Editors that created something resembling HTML
*   Templating languages like PHP, ColdFusion, Template Toolkit, ASP and many others
*   Online editors and page generators like Geocities
*   Forum and Blog editors with sometimes own languages (remember BBCode?)

None of these were necessary to publish on the web. In the case of some of the enterprise CMS I worked with they were ridiculously complex and inflated. But people used them. Because they promised an easier, more defined and clearer publication path of web content. They solved developer and manager problems, not end user experience. In the case of Geocities and similar services they made it easier for people to publish on the web as they didn’t even need to write any code.

> What you see in the browser is almost never the source code. If you want to improve its quality, we need to go higher up the chain.

Even back then looking at the source of a document wasn’t the document that someone wrote. It was the result of lots of includes being put together by some server-side code, maybe even optimised and then thrown to the browser.

And that makes total sense. Having lots of different components allowed people to work on them in parallel. Often your site navigation was a global one even written and maintained by some other department or company. You didn’t even have access to the HTML, and – if you were lucky – you could fix a few issues with CSS.

## HTML is a compilation target

Fast forward to now. HTML is not cool. Writing your own templating language is. Markdown, Pug, Jade and many others keep getting invented. Meant to save us from the complexity of HTML and the compatibility issues it has with this or that environment.

> HTML has a bad reputation for being something that should work, but doesn’t reliably deliver. A framework that gives you more control and promises to be “modern” is much more exciting than an age-old technology that promises not to break.

It is irrelevant to most that the web shouldn’t be controlled by us but that our users need to cater the outcome to their needs. Most developers don’t get paid to think in those terms – they get paid to roll out a certain interface in a certain amount of time. We need to fix that.

HTML is not seen as a thing to worry about – as the execution environment is lenient about its quality. It is generally seen as a much better use of your time to learn higher abstractions. People don’t want to build a web site. They want to build an app. That in most cases they don’t need an app is not important. We dropped the ball in keeping HTML interesting. We wanted the web to give us more capabilities, to be on par with native code on mobiles. And this always results in more complexity. The [extensible web manifesto](https://extensiblewebmanifesto.org/) pretty much nailed that a publisher on the web needs to have a more developer mindset than a writer or publisher. We wanted control, we wanted to be in charge. Now we are.

What does this leave us with? For one thing, we need to come to peace with the fact HTML on the web in most cases is the result of some sort of compilation. Looking at the final result and bemoaning its quality makes no sense. Nobody ever edits this and it is not meant to be readable.

I am not giving up on semantic HTML and its merits, but I understand that we won’t sell it to developers by telling them their end product is terrible. We need to work with the framework developers, the creators of components. We need to help with the template code source, the framework renderers. We need to ensure that the conversion stage results in good HTML - not easy HTML.

And we need to work with tool developers to make sure that people learn about the value of semantics. In-editor linting and autocompletion goes a long way. We have a much bigger toolbox to choose from these days to make sure that developers do the right thing without having to think about it. I like that idea. Let’s fix the problems at the source rather than complaining about the symptoms.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
