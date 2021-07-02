> * 原文地址：[The JavaScript Landscape in 2021](https://medium.com/javascript-in-plain-english/the-javascript-landscape-in-2021-573d5e7a43c6)
> * 原文作者：[Richard Bultitude](https://medium.com/@rbultitudezone)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/the-javascript-landscape-in-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/the-javascript-landscape-in-2021.md)
> * 译者：
> * 校对者：

# The JavaScript Landscape in 2021

![Photo by [Sergey Pesterev](https://unsplash.com/@sickle?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/landscape?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/17792/1*seEhUyV_-leofR3E1CYGwg.jpeg)

In web development our world changes quickly, but what can we pin down what 2021 will bring? By scrutinizing data from the 2020 developer surveys, I’ve highlighted what I think the big JavaScript stories will be.

Before going into the detail, a quick note on JavaScript surveys. Sadly, the next edition of the excellent [Front End Tooling Survey](https://ashleynolan.co.uk/blog/frontend-tooling-survey-2019-results), will not be published for some time, which makes finding trends a little harder. Whilst we may be down one good survey, a new one has popped up in its stead: [The State of Front End](https://tsh.io/state-of-frontend/). Though there’s no previous annual data to help us see trends, it was filled in by a whopping 4,500 developers from around the world, so it’s definitely a valuable resource.

Let’s dive in and explore the insights I’ve garnered from the data.

## Package Managers

[Last year](https://medium.com/engineered-publicis-sapient/the-javascript-landscape-in-2020-b8e5898b847e) I suggested we watch out for the rise of [PNPM](https://pnpm.js.org/), which aims to avoid version conflicts and play well with monorepos. It has some [passionate advocates](https://medium.com/better-programming/the-case-for-pnpm-over-npm-or-yarn-2b221607119) and reached 9.5k stars on Github last year, so it’s clearly winning developers over. However, I feel it’s unlikely to seriously [compete on usage](https://www.npmtrends.com/yarn-vs-pnpm-vs-npm) in 2021, given how embedded [Yarn](https://yarnpkg.com/) and [NPM](https://www.npmjs.com/) are in live projects and how much energy both have put into shipping new features. Some of these features have been developed in direct response to PNPM, in particular [Workspaces](https://classic.yarnpkg.com/en/docs/workspaces/). This just goes to show how important competition is in driving open source software forward.

## Testing

In 2019, [Cypress](https://www.cypress.io/) and [Puppeteer](https://github.com/puppeteer/puppeteer) stood out as high new entries and both of them have continued to be successful in 2020. However, Microsoft have brought a new E2E testing tool to the party in the form of [Playwright](https://github.com/microsoft/playwright), which seemed to appear out of nowhere and gained just under 20k stars in 2020 alone. As one of the world’s biggest software companies they have the clout to widely promote their wares, but that only partially explains the tool’s popularity. The main reason is its feature set and simple migration path from [Puppeteer](https://pptr.dev/).

![Playright tops the Rising Stars testing frameworks chart despite not having featured at all in 2019](https://cdn-images-1.medium.com/max/2000/1*uYLDgxsDdacIUtiOnAWTFw.png)

Since [Nadella](https://en.wikipedia.org/wiki/Satya_Nadella) took over as CEO, Microsoft have developed a habit of producing popular and powerful open source tools. [VSCode anyone](https://2020.stateofjs.com/en-US/other-tools/#text_editors)?

## JavaScript Flavours

I said last year that [TypeScript](https://www.typescriptlang.org/) had, slowly but surely, taken over the JavaScript world; that trend has intensified. Countless open source projects eagerly list it as asupported feature. [Deno](https://deno.land/), which was **the** [most starred Github project in 2020](https://risingstars.js.org/2020/en#section-all), comes with the Typescript compiler built in.

Last [year I suggested we keep an eye on PureScript](http://www.purescript.org/), given the interest in static types **and** functional programming, that it enforces. However, uptake wasn’t so strong in 2020, with only 641 new stars on Github and [interest dropping by 3%](https://2020.stateofjs.com/en-US/technologies/javascript-flavors/). Looking at the [huge usage gap](https://www.npmtrends.com/typescript-vs-elm-vs-coffee-script-vs-purescript-vs-reason) between TypeScript and its competitors, it feels like the language war is over and Microsoft’s product has won out. Any newcomer will struggle to get our attention after years of deliberation in the community and an atmosphere of language overload.

This is an area I am relieved to see the community converge on. Now, we avoid the distraction of different super-sets and focus more on the language itself.

## UI frameworks

[Vue](https://vuejs.org/) was the most starred framework of 2019, which was big news at the time and sent a clear message: developers **love** it. [It’s the same story in 2020](https://risingstars.js.org/2020/en#section-framework). However, the [React](https://reactjs.org/) market share is still enormous when we look at [NPM downloads](https://www.npmtrends.com/react-vs-vue-vs-svelte).

![React downloads in the past year](https://cdn-images-1.medium.com/max/2332/1*PJFyaoF6Bz3AKmt9Npzx6w.png)

There are two other useful metrics: tags in GitHub and advertised jobs. Currently there are over 80k repos tagged ‘React’ on GitHub, compared with 25k as ‘Vue’. Looking at the job market, last May Career Karma reported [10,005](https://www.indeed.com/q-React-Developer-jobs.html?vjk=2873485b3446c4bc) jobs on Indeed.com for React Developers in the USA with only [1,025](https://www.indeed.com/q-Vue-Js-Developer-jobs.html?vjk=9216260d28c3fda3) for Vue. React is ubiquitous and is weathering some stiff competition.

I can’t conclude this section without mentioning [Svelte](https://svelte.dev/) and [Angular](https://angularjs.org/). Angular is still very popular — it gained [13.3k new stars last year](https://risingstars.js.org/2020/en#section-framework) and gets almost 2.5million downloads a week on NPM. This may come as a surprise to some, given React’s dominance, but these stats deserve recognition. Svelte, is very young by comparison, but [tops the satisfaction chart in State of JS](https://2020.stateofjs.com/en-US/technologies/front-end-frameworks/). However, I only expect it to make modest gains in 2021 due to the steep learning curve for React and Vue devs.

## Backend

This is now a complicated space where frameworks for static site generation sit alongside ones for API production. If we break it down a little and take a look at server only frameworks, we can see [Express](https://expressjs.com/) still sitting pretty with 51.5k stars. However, [Nest](https://nestjs.com/) has exploded onto the scene with a staggering 10.3k **new** stars in 2020, taking its total to 33.6k. Developers have taken to it because they’re attracted to its opinionated approach, which can speed up development and simplify maintenance. Oh and did I mention it uses TypeScript?

Looking at the proliferation of full-stack frameworks, there is a very important battle for hearts and minds going on in this space because they have such a big impact on architecture, performance and ways of working. The two React-based frameworks, [NextJS](https://nextjs.org/) and [Gatsby](https://www.gatsbyjs.com/), are still considerably more popular than their VueJS counterparts in terms of usage, but that only confirms what we already know about the UI framework ecosystem. What’s really noteworthy is how much [Gatsby’s satisfaction rating has gone down](https://2020.stateofjs.com/en-US/technologies/back-end-frameworks/). Anecdotal evidence suggests that it has a confusing [DX](https://medium.com/swlh/what-is-dx-developer-experience-401a0e44a9d9), though there is plenty of evidence to refute that online. With NextJS being developed by [Vercel](https://vercel.com/) and adding features like static site generation to its arsenal, I can only see it going from strength to strength this year.

## Build tools

This area has some noteworthy competition right now. Despite complaints about Webpack’s DevX, it reigned supreme for a long time and [still has the highest usage](https://www.npmtrends.com/webpack-vs-gulp-vs-rollup-vs-parcel) among the majors. Last year, we saw [Rome](https://github.com/rome/tools) challenging this space and this year we have [esbuild](https://github.com/evanw/esbuild), [Snowpack](https://www.snowpack.dev/) and Vite making their way up the [Rising stars charts](https://risingstars.js.org/2020/en#section-build). Esbuild’s remit is simple: speed up build time. This is clearly really valuable to many engineering teams and explains the move towards it.

![esbuild and Snowpack are joint top of the State of JS 2020 build tools chart](https://cdn-images-1.medium.com/max/2000/1*LqoAdgne6TToTpeX4qBhYg.png)

Whilst GitHub stars are one metric, Snowpack tops the **Interest** chart in the State of JS survey, but more importantly, it’s joint top of the [**Satisfaction** chart](https://2020.stateofjs.com/en-US/technologies/build-tools/). Whilst usage may still be quite low, I feel its time is coming. Snowpack and Vite’s popularity sends an important message: native ES modules are being taken seriously by the community. This is a huge topic because of its implications on the build process, caching and dev/prod module symmetry.

## State management

What UI framework would be complete without its companion state manager? Setting aside debates about complexity vs future proofing, this area is particularly interesting because Redux is being challenged from two angles: from within React itself and independent newcomers.

I know from personal experience how powerful React’s Hooks and Context APIs can be, but they do have their limitations. Either way, they’re certainly a big hit with React developers, with [almost half the State of Front End participants](https://tsh.io/state-of-frontend/#frameworks) stating they use them.

![State of Front End 2020 Survey State Management Category](https://cdn-images-1.medium.com/max/2000/1*GbKC2D1NEt8Fj_bjNwHmKA.png)

## Conclusion

In last year’s article, I explored the theme of **consolidation**. After years of diverging patterns, frameworks and libraries it feels like we’re aligning on patterns and practices. Whilst I feel that the trend continued in 2020, it’s clear that JavaScript’s popularity has led to a proliferation of tools in markets that were previously the preserve of other languages; illustrated by the growing number of E2E testing and machine learning tools.

The key theme that emerged from the 2020 data is that the JavaScript landscape is being defined by the big software vendors. Microsoft’s TypeScript is becoming an industry standard and projects that are built on it have a better chance of success, NestJS and NextJS (not to be confused) being great examples.

The influence of the [JAMStack](https://jamstack.org/) approach and need for speed are influencing factors too, with static site generators and tools like ESbuild rising to prominence very quickly.

The JavaScript landscape just keeps on expanding, fueled by rapid evolution of features, browser support, runtimes and an ever-widening digital horizon.

> This article was kindly reviewed by George Adamson and Joanne Parkes.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
