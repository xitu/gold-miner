> * 原文地址：[What is Progressive Enhancement, and why it matters](https://medium.freecodecamp.org/what-is-progressive-enhancement-and-why-it-matters-e80c7aaf834a)
> * 原文作者：[Praveen Dubey](https://medium.freecodecamp.org/@edubey?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-progressive-enhancement-and-why-it-matters.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-progressive-enhancement-and-why-it-matters.md)
> * 译者：
> * 校对者：

# What is Progressive Enhancement, and why it matters

![](https://cdn-images-1.medium.com/max/2000/0*cs42aEkypTZorYk6)

Photo by [Émile Perron](https://unsplash.com/@emilep) on [Unsplash](https://unsplash.com)

Progressive Enhancement (PE) is a powerful methodology for developing web applications.

Here is a [formal](https://en.wikipedia.org/wiki/Progressive_enhancement) definition:

> **Progressive enhancement** is a strategy for web design that emphasizes core web page content first. This strategy then progressively adds more nuanced and technically rigorous layers of presentation and features on top of the content as the end-user’s browser/Internet connection allow. — Wikipedia

The proposed benefits of this strategy are that it allows everyone to access the basic content and functionality of a web page, using any browser or Internet connection, while also providing an enhanced version of the page to those with more advanced browser software or greater bandwidth.

And in a nutshell…

…it gives us basic user experience and cross compatibility across browsers to ensure **stability.**

```
let PE = "Progressive Enhancement";
```

The PE strategy consists of the following [core principles](http://www.wikiwand.com/en/Progressive_enhancement):

*   Basic **content** should be accessible to **all web browsers**
*   Basic **functionality** should be accessible to **all web browsers**
*   Sparse, semantic markup contains all content
*   Enhanced layout is provided by externally linked CSS
*   Enhanced behavior is provided by unobtrusive, externally linked JavaScript
*   End-user web browser preferences are respected

So when you build your next website with next-generation JavaScript / CSS frameworks which work only in the most **favorable environment** for your code and it breaks when it does not get it…. this is not a Progressive Enhancement strategy.

Instead, have a goal where development should start with providing basic features, stability across all browsers and devices, and a seamless experience to the user before introducing complexity.

### PE Examples

Let’s look at some of the examples which show how the PE strategy works.

#### Web Fonts

Web fonts are amazing and beautiful, but when the user is on a slow network with a heavy site, they surely degrades the user experience. Even in this situation, System font should be used as the fallback to render content and can be changed to a web font as and when they are loaded.

Showing content is better than waiting for web fonts — or getting nothing.

#### Initial HTML

Sites are loaded with script. It could be Angular, React or some other framework. When these scripts are responsible for initial content display, your user will be seeing the blank page on the browser or device when something went wrong with scripts or when the user is on the slow network.

It’s always good to consider loading initial content from HTML to provide a better user experience, rather than completely relying on scripts which are yet to load.

#### Feature Check

Good sites always does this part. When using a feature which is not supported based on different browsers or devices, always make sure to check if feature is available in the browser before using it in your JavaScript.

[Modernizr](https://modernizr.com/) is one popular library for feature detection which can help you.

You can load additional scripts to load fallback support only when it’s not available in the browser or device. This way you can avoid loading extra scripts when they are not required.

### Now, Why PE ?

Important reasons to focus on the PE strategy before building your next application:

#### Strong Foundation

PE focuses on the start of your project using only the very basic web technologies before introducing some of the very complex features. So in all cases, you have the foundation to back your complex features to make sure they work.

Once the team is confident that the core-experience of the site is stable, and will work without heavily relying on network speed, browser, and device, then you can start introducing layers of more complex features or sci-fi stuff.

#### Stability

`Quality Team` : “ Search Icon is not working in Safari for Offers page ”

`Dev Team` : “ Well it works on _my machine_, clear cache, reload or die ”

`Quality Team` (from heaven) : “ Still does not work, you are checking on Chrome, it’s breaking on Safari ”

`Dev Team` : “ When did we start supporting Safari ? wait…. patching patching………”

```
if(getBrowsers() == 'safari') {
Patch.magicHelpers.searchIconMagic()
}

Patch.magicHelpers = {
searchIconMagic: function() {
// Can't share magic, doing something
   }
};
```

“after 1 hour…… check now ”.

`Quality Team`: “ Working fine for Chrome and Safari but broke for Mozilla now…Ahhhhh !!!!!”

Well, we all have been in this situation at least once.

Cost for Stability and Maintenance of a project also depends on how the project starts. Setting up a project with frameworks and patching it will not work for the long term.

The PE strategy helps you build a strong foundation for your project where your HTML, CSS, and JS are aligned and aim to provide fallbacks. They try to make sure you’re not heavily relying only on browser specific features.

#### **SEO and Accessibility**

Everyone wants to get their application listed in the first page of the search engine, but it takes _consistent work and planning_ to build such amazing applications. The strong foundation for your project makes sure your application is focusing on the content-first approach.

Pages built with the PE strategy make sure **basic content** is **always** accessible for the search engine spider and is ready to be indexed. Avoid any dynamic content rendering that may hinder the spider crawling your content.

Progressive Web Apps  (PWA) are made to work for all users, regardless of their browser choice, because they’re built with progressive enhancement as a core principle.

### **Closing thoughts**

The PE strategy focuses on a strong foundation for your project. This strong foundation helps you in your vision for your product for a long term plan.

It’s easy to hook into a new JavaScript / CSS framework for your new project and start coding, but that may lead to Graceful Degradation. You will keep on patching your code with fallbacks for browsers or devices which do not support frameworks.

Although the PE strategy takes a bit more planning in the initial stages, it makes sure your user is able to experience at least basic functionality in the worst case also. PE is not workable in situations that rely heavily on JavaScript to achieve certain user interface presentations or behavior, but for a long-term project, it’s worth considering certain aspects of PE strategy.

Hopes this gave an overview of the Progressive Enhancement Strategy.

Feel free to drop a comment below.

Thank you for reading this article! If you have any questions, send me an email (praveend806@gmail.com).

Resources which talk about more about PE and case studies:

- [**Designing with Progressive Enhancement: Building the Web that Works for Everyone**: Progressive enhancement is an approach to web development that aims to deliver the best possible experience to the...](https://www.oreilly.com/library/view/designing-with-progressive/9780321659477/ "https://www.oreilly.com/library/view/designing-with-progressive/9780321659477/")

- [**Unboring.net | Workflow: Applying Progressive Enhancement on a WebVR project**: How I made an interactive content to be embedded on weather.com](https://unboring.net/workflows/progressive-enhancement/ "https://unboring.net/workflows/progressive-enhancement/")

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
