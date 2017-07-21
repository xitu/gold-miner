
> * 原文地址：[Reflections on ESLint's success](https://www.nczonline.net/blog/2016/02/reflections-on-eslints-success/)
> * 原文作者：[Nicholas C. Zakas](http://www.twitter.com/slicknet/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/reflections-on-eslints-success.md](https://github.com/xitu/gold-miner/blob/master/TODO/reflections-on-eslints-success.md)
> * 译者：
> * 校对者：

# Reflections on ESLint's success

It's hard for me to believe, but I first conceived and created ESLint[1] in June 2013 and first announced it's availability in July 2013[2]. As frequent readers might recall, the primary goal of ESLint was to create a linter with rules that could be loaded at runtime. I had seen some problems in our JavaScript at work and really wanted some automation to validate those mistakes weren't repeated.

In the two and a half years since ESLint was introduced, its popularity exploded. This past month, we surpassed 1.5 million npm downloads in 30 days, something I never thought possible back in the day when an average month of downloads was 600.

And all of this happened while I've been extremely ill with Lyme disease and barely able to leave my house for the past two years. That meant I couldn't go to conferences or meetups to speak about ESLint (the previous two years I was a conference regular). Yet somehow, ESLint gained traction and has continued to gain in popularity. I think it's a good time to look back and try to understand why.

## People are writing more JavaScript

Over the past three years, we've continued to see growth in the amount of JavaScript being sent to browsers. According to HTTP Archive[3], the average page now has over 100KB more JavaScript than it had in 2013.

![Chart - Increasing JavaScript Usage in Browsers 2013-2016](https://www.nczonline.net/images/posts/blog-js-chart-2016.png)

Another factor is the explosive popularity of Node.js. Whereas previously the amount of JavaScript written was limited to client-side usage, Node.js ensured that a whole new group of developers would be writing JavaScript. With JavaScript running in the browser and on the server, that would naturally lead to an increase in demand for JavaScript tooling. Since ESLint can be used for both browser and Node.js JavaScript, it was well-suited to address this demand.

## Linting has become more popular

As the demand for JavaScript tooling increased, so too did the demand for JavaScript linting. This logically makes sense because the more JavaScript you write, the more you're going to need help keeping it functional and avoiding common mistakes. You can see this general trend by looking at the npm download numbers for JSHint, JSCS, and ESLint since mid-2013.

![Chart - Increasing downloads for all JavaScript linters](https://www.nczonline.net/images/posts/blog-eslint-chart.png)

JSCS and ESLint were created right around the same time, so it's interesting to see the growth trajectories for each as compared to JSHint. JSHint has continued its domination of JavaScript linting popularity into the beginning of 2016. Both JSCS and ESLint continue to grow over time, as well. Perhaps the most interesting part of this data is that all three tools are continuing grow their download counts over time, implying that there are more people download linters each month than there are people switching linters.

So ESLint is really just part of a larger trend towards more JavaScript linting by the development community.

## The ECMAScript 6/Babel factor

The excitement around ECMAScript 6 has been growing steadily for the past four years, so much so that it made Babel a massively successful project. The ability to start using ECMAScript 6 syntax and features without waiting for official support in browsers and Node.js meant demand for a new class of JavaScript tools. There just wasn't enough tooling for ECMAScript 6 code, and in this regard, JSHint fell pretty far behind.

ESLint, on the other hand, had a very big advantage: you could swap out the default parser for another one so long as it produced the same format as Esprima (or Espree). That meant those who wanted to use ECMAScript 6 could use the now-discontinued Facebook fork of Esprima with ES6 support immediately to get some basic linting for their code. Espree was also updated to support ES6 (mostly by pulling features from the Facebook Esprima fork). That made developers using ES6 quite happy.

Of course, Babel didn't stop at implementing ES6 features, going on to include experimental features. That meant there was demand for tools that could deal with not just the standard features, but anything that was in any stage of development for JavaScript. Here, ESLint's pluggable parser capability also made a big difference because babel-eslint[4] was created by the Babel team as a wrapper around Babel that ESLint could use.

Before long, ESLint was the recommended linter for anyone using ECMAScript 6 or Babel, and it was made possible by a decision to allow the default parser to be swapped out for a compatible one.

Today, babel-eslint is used in roughly 41% of ESLint installs (based on npm download statistics).

## The React factor

It's impossible to talk about ESLint's popularity without talking about React. A key part of React is the ability to embed JSX code inside of JavaScript, and that was something no other linter was capable of doing at first. ESLint not only implemented JSX as part of the default parser, but with pluggable parsers, you could use babel-eslint or Facebook's Esprima fork to get JSX support. React users were starting to turn to ESLint because of this.

There were a lot of requests to create React-specific rules in ESLint itself, but as a policy, I never wanted library-specific rules as those would inevitably require a lot of maintenance. In December 2014, eslint-plugin-react[5] was introduced with React-specific rules and really caught on quickly with React developers.

Then, in February 2015, Dan Abramov wrote, "Lint like it's 2015"[6]. In that post, he described how well ESLint worked with React, and had high praise:

> If you haven't heard of it, ESLint is the linter I always wanted JSHint to be.

Dan also walked people through setting up ESLint and how to use babel-eslint, providing some much-needed documentation for the process. It's pretty clear to see that this was a big turning point for ESLint as the monthly download count nearly doubled from 89,000 in February 2015 to 161,000 in March 2015. That really seemed to kick off a period of rapid growth for ESLint that has continued to this day.

Today, eslint-plugin-react is used in a bit more than 45% of ESLint installs (based on npm download statistics).

## Extensibility was key

From the beginning, I had this idea that ESLint could be a small core utility at the center of a larger ecosystem. My goal was to make ESLint ageless by allowing enough extension points that my failure to deliver features would not stop ESLint from acquiring new capabilities. While ESLint hasn't yet met that vision completely, it is extremely flexible:

- You can add new rules at runtime, allowing anyone to write their own rules. I saw this as key if I wanted to avoid spending every day with a laundry list of random rules people wanted. Now, there's nothing stopping anyone from writing an ESLint rule.
- The pluggable parser means that ESLint can work with anything outputting the same format as Espree. As I've already discussed, this has been a big reason for ESLint's popularity.
- Shareable configurations all people to package up their configs and share them, making it easy to have multiple projects adhere to the same configuration (eslint-config-airbnb is used in 15% of ESLint installs).
- Plugins allow people to easily package and share their rules, text processors, environments, and configurations with anyone.
- A rational Node.js API that made it easy to create build tool plugins (for Grunt, Gulp, and more) as well as led to the creation of no-configuration linters like Standard and XO.

I'm hoping we can add more extension points to ESLint as it continues to evolve.

## Listening to the community

One of the things I tried very hard to do was really listen to the ESLint community. While I was pretty stubborn early on about my vision for ESLint, I came to realize that there is a definitely a wisdom in crowds. The more you hear the same suggestions over and over, the more likely it's a real pain point that should be addressed. I'm much better now about watching for these patterns, as the community has really come through with some great ideas that have led to ESLint's success:

1. **The pluggable parser feature** - a direct request from Facebook so they could use their own fork of Esprima with ESLint.
2. **JSX support** - early on, I was very against including JSX support by default. But the request kept coming up, so I eventually agreed. And as mentioned earlier, that has been a key part of ESLint's success.
3. **Shareable configs** - this came about due to the emergence of Standard and other wrappers around ESLint whose sole purpose was to run ESLint with a specific configuration. It seemed like the community really wanted an easy way to share configs, and so shareable configs were born.
4. **Plugins** - early on, the only way to load your own rules was from the filesystem using the `--rulesdir` command line option. Pretty soon, people started packaging up their rules into npm packages and publishing them. This was a bit of a painful process, and it was hard to use more than one package at a time, so we ended up adding plugins so that rules could easily be shared.

It's pretty clear that the ESLint community has some fantastic ideas for how the project should grow, and there's little doubt that ESLint's success is directly to them.

## Grassroots support

Since ESLint was created, I wrote exactly two blog posts about it. The first was the intro post on my personal blog[2] and the second was a followup on Smashing Magazine[7] last September. Other than that, the extend of my marketing for ESLint was limited to mention it on Twitter and managing the ESLint Twitter account. If I had been well enough to give talks, I'm sure I could have done a better job marketing ESLint, but since I wasn't, I decided that I wouldn't even try to promote it.

I was pleasantly surprised when I started seeing other people giving talks and writing articles about ESLint. In the beginning, it was people that I didn't know and had never heard of. Articles (such as Dan's) were popping up and people were posting videos of conference and meetup talks about ESLint. The popularity grew organically as more content was posted online.

An interesting contrast is in the growth story of JSCS. Early on, JSCS got JSHint's endorsement as a companion to JSHint. JSHint had decided to remove stylistic rules altogether and JSCS serves as a replacement for those rules. As such, the JSHint team was referring people to JSCS when questions arose. Having the support of the undeniable leader in the space is huge, and for most of the early days, JSCS usage far outpaced ESLint usage. At several points during that first year, I thought that JSCS would crush ESLint and I could go back to having my nights and weekends free. But that didn't happen.

The strong grassroots support sustained ESLint and eventually helped it onto a tremendous growth spurt. Users were creating more users and more buzz, and ESLint was along for the ride.

## Focusing on usefulness not competition

One of the things I'm most proud of is the story that came along with ESLint. At no point did I make any claims that ESLint was better than anything else. I never asked people to switch from JSHint or JSCS. My main message was that ESLint was better for your project is you wanted to write custom rules. That was it. To this day, the ESLint README says (in the FAQ):

> I'm not trying to convince you that ESLint is better than JSHint. The only thing I know is that ESLint is better than JSHint for what I'm doing. In the off chance you're doing something similar, it might be better for you. Otherwise, keep using JSHint, I'm certainly not going to tell you to stop using it.

That's been my position, and now the position of the team, all along. I still believe JSHint is a good tool and has a lot of advantages. JSCS, as well, is a good tool that has some real benefits. Many people use a combination of JSHint and JSCS and are quite happy, and for those people, I'd encourage them to continue doing so.

The focus of ESLint is really just to be as useful as possible and let developers decide if it's right for them. All decisions are made based on how useful changes are to our community and not based on competition with other tools. There's plenty of room in the world for multiple linting tools, there doesn't have to be just one.

## Patience pays off

I've mentioned before[8] that there seems to be a frantic race to create popular open source projects, with a focus on popularity over everything else. ESLint is a good example of how long it takes for a project to organically grow into a success. For the first nearly two years of its existence, ESLint downloads were a distant third behind JSHint and JSCS. It took time for both ESLint and its community to mature. The "overnight" success of ESLint didn't happen over night, it happened by continuing to improve the project based on usefulness and community feedback.

## A great team

I've been truly blessed with a fantastic team of contributors to ESLint. As I've had less energy and time to work on ESLint, they have picked up a lot of the slack. The thing that amazes me constantly is that I've never met these people in real life, nor have I ever heard their voices, yet they've become a group of people I look forward to conversing with every day. Their undying passion and creativity has kept ESLint going as I've struggled with my health, and while I started ESLint alone, they are undoubtedly the reason it survived long enough to reach its current level of popularity.

A huge thanks to Ilya Volodin, Brandon Mills, Gyandeep Singh, Mathias Schreck, Jamund Ferguson, Ian VanSchooten, Toru Nagashima, Burak Yiğit Kaya, and Alberto Rodríguez for all of your hard work.

## Conclusion

There are a lot of factors that have led to the success of ESLint, and by sharing them, I'm hoping to give others a roadmap for what it takes to create a successful open source project. As with most worthwhile endeavors, a bit of luck coupled with the support of others and a clear vision for what I was trying to accomplish were all key parts of this story. I'm a big believer that if you focus on creating something useful, and you're willing to put in the hard work, eventually the work will get the recognition it deserves.

ESLint is continuing to grow and change, and the team and community are growing and changing as well. I'm very excited to see where ESLint goes next.

## References

1. [ESLint](http://eslint.org) (eslint.org)
2. [Introducing ESLint](https://www.nczonline.net/blog/2013/07/16/introducing-eslint/) (nczonline.net)
3. [HTTP Archive Trends 2013-2016](http://httparchive.org/trends.php?s=All&amp;minlabel=Jul+15+2013&amp;maxlabel=Jan+15+2016#bytesJS&amp;reqJS) (httparchive.org)
4. [babel-eslint](https://github.com/babel/babel-eslint) (github.com)
5. [eslint-plugin-react](https://github.com/yannickcr/eslint-plugin-react) (github.com)
6. [Lint like it's 2015](https://medium.com/@dan_abramov/lint-like-it-s-2015-6987d44c5b48#.giue3dxsd) (medium.com)
7. [ESLint: The Next Generation JavaScript Linter](https://www.smashingmagazine.com/2015/09/eslint-the-next-generation-javascript-linter/) (smashingmagazine.com)
8. [Why I'm not using your open source project](https://www.nczonline.net/blog/2015/12/why-im-not-using-your-open-source-project/) (nczonline.net)

Disclaimer: Any viewpoints and opinions expressed in this article are those of Nicholas C. Zakas and do not, in any way, reflect those of my employer, my colleagues, [Wrox Publishing](http://www.wrox.com/), [O'Reilly Publishing](http://www.oreilly.com/), or anyone else. I speak only for myself, not for them.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
