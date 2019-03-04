> * 原文地址：[Small Websites Are Dying](https://blog.bloomca.me/2018/12/03/small-websites.html)
> * 原文作者：[Seva Zaikov](https://blog.bloomca.me)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/small-websites-are-dying.md](https://github.com/xitu/gold-miner/blob/master/TODO1/small-websites-are-dying.md)
> * 译者：
> * 校对者：

# Small Websites Are Dying

Web is growing massively, JavaScript is being rapidly developed and improved, and to keep up, you need to [transpile](https://babeljs.io/) your code from the latest version to whatever (it is complicated, just [trust us](https://babeljs.io/docs/en/babel-preset-env)). Also, you can use [another language](https://www.typescriptlang.org/) completely. What is the deal, though? There were a lot of attempts ([1](http://www.gwtproject.org/), [2](https://coffeescript.org/), [3](https://clojurescript.org/), etc), but what is important to note is the fact they tried to tackle big applications specifically, while nowadays it is often advised to use it everywhere.

## Road to SPA

Historically small pages were made out of static HTML with some sprinkles of JavaScript here and there. I bet it is still the way to go in traditional server-side applications (like in [Django](https://www.djangoproject.com/) or [Ruby on Rails](https://rubyonrails.org/)), but it is not cool anymore, so even if people still use them, very often it is just an API. These pages (no matter static or server-side rendered) had a lot of adhoc scripts, which looked like crazy tangled mess. It was a nightmare to maintain and test, and they were either very long or concatenated in some bizarre way.

For this type of scripts move to [single page applications](https://en.wikipedia.org/wiki/Single-page_application) is definitely a good thing – now we get at least partially maintainable application, with [proper module importing](https://webpack.js.org/), and with new [shiny](https://reactjs.org/) [frameworks](https://vuejs.org/) which allow to handle complex interactions, routes, shared data across screens, reusing UI elements across applications (!) or even across the whole web (as open-source components). However, this article is not about them – I already [complained](https://blog.bloomca.me/2018/02/04/spa-is-not-silver-bullet.html) about SPA being a default choice nowadays for literally everything; this article is about _small_ websites.

## Rise and Fall of jQuery

Before this niche was dominated by [jQuery](https://jquery.com/) and its _huge_ ecosystem of plugins, with all sorts of sliders, image galleries and rich animations. Also, it was super simple to integrate it, usually just initializing some plugin with parameters (or even with defaults) and providing an element id. Everything else often was specified in the markup (or it required certain markup rules), and HTML, being a declarative language, was simple enough to figure it out. In fact, jQuery was so big that people [really wondered](https://webmasters.stackexchange.com/questions/84683/why-dont-browsers-have-jquery-installed) why not to include it in browsers by default. jQuery also had a lot of convenient functionality included (one might call it “missing” stdlib for DOM), which made making simple interactions super simple.

I actually believe jQuery is still big (can’t really provide any data, just my gut feeling), but there was an important shift. jQuery is [frowned upon](http://youmightnotneedjquery.com/) nowadays, and you won’t find a lot of tutorials how to quickly write a small script for your page without knowing JavaScript too much. Also, about ~5 years ago standard for libraries was to:

*   host their minified code on some CDN
*   attach all their functionality to some global variable (e.g. window.Backbone)

Nowadays some libraries still pack [UMD build](https://github.com/umdjs/umd), which is essentially a global variable version of loading libraries, but a lot of them don’t. Also, there are much more frameworks out there now, and all these widgets are only framework-specific, and not only require to use them (for jQuery plugins you needed the library as well), but often you need to make the whole page using that framework!

## Modern Solutions

This issue is, of course, addressed, and it is done by providing starters or special frameworks on top of existing ones, where you can use these widgets and compile a static site. Moreover, under the hood they use already mentioned tools for modules loading and code transpiling, so you can use the latest version of JavaScript and separate your logic into nice reusable logical pieces. Prominent examples of such apporach are [GatsbyJS](https://www.gatsbyjs.org/) and [Nuxt.js](https://nuxtjs.org/). Starters often exist in form of CLIs, like [create-react-app](https://github.com/facebook/create-react-app), hiding all the complexity away, and just giving an application that “just works”, so you write your components.

What is the issue with that change, though? Code is more maintainable (thanks to the modules), you can use the latest JavaScript version and can be sure everything missing will be polyfilled, which was a common source of errors before. Well, there are plenty of them, from my point of view:

*   you really have to know JavaScript this time (you have to understand much more)
*   not only JavaScript, but you might have to understand webpack (for static assets loading – imagine your surprise seeing requiring image in the source code!)
*   your workflow now consists of _building_ your application, using ~200MB files (rather than editing text files)
*   it is a slippery slope, when it is super easy to make your small app more bloated

The last part is the worst one, I think. All these tutorials out there will suggest to add some advanced data management library, refactoring code in some special, “more declarative” way (think how often somebody tried to convince to refactor your HTML), and some people will follow that! Now, this advice is good, but probably only for big applications, and not for a small GatsbyJS website, which would be a perfect folder with 5 `.html` files. Yes, you would not be able to reuse this menu, but you can just copy it (and CSS classes make it _sort of_ reusable).

## Conclusion

Maybe I am wrong, and it is not that bad. But using internet, reading blogs, looking at landing pages I feel that these small websites, previously accessible to everyone with HTML knowledge and minimal JS skills are slowly going away, now more and more often replaced with more “scalable” applications.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
