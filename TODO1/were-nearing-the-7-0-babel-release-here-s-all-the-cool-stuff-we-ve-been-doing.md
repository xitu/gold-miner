> * 原文地址：[We’re nearing the 7.0 Babel release. Here’s all the cool stuff we’ve been doing.](https://medium.freecodecamp.org/were-nearing-the-7-0-babel-release-here-s-all-the-cool-stuff-we-ve-been-doing-8c1ade684039)
> * 原文作者：[Henry Zhu](https://medium.freecodecamp.org/@left_pad?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/were-nearing-the-7-0-babel-release-here-s-all-the-cool-stuff-we-ve-been-doing.md](https://github.com/xitu/gold-miner/blob/master/TODO1/were-nearing-the-7-0-babel-release-here-s-all-the-cool-stuff-we-ve-been-doing.md)
> * 译者：
> * 校对者：

# We’re nearing the 7.0 Babel release. Here’s all the cool stuff we’ve been doing.

![](https://cdn-images-1.medium.com/max/1000/1*vLtFVPTHJGDfw3XOl4C1Sw.jpeg)

Photo by [“My Life Through A Lens”](https://unsplash.com/photos/bq31L0jQAjU?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/search/photos/change?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)

Hey there 👋! I’m [Henry](http://twitter.com/left_pad), one of the maintainers on [Babel](http://babeljs.io).

> EDIT: I’ve [left Behance](https://www.henryzoo.com/blog/2018/02/15/leaving-behance.html) and have made a [Patreon](https://www.patreon.com/henryzhu) to try to pursue [working on open source full time](https://www.henryzoo.com/blog/2018/03/02/in-pursuit-of-open-source-part-1.html), please consider donating (ask your company).

#### A quick intro to Babel

Some people like to think of Babel as a tool that lets you write ES6 code. More specifically, a JavaScript compiler than will convert ES6 into ES5 code. That was pretty fitting back when its name was 6to5, but I think Babel has become a lot more than that.

Now let’s back up a bit. The reason why this is even necessary in the first place is because, unlike most languages on the server (even Node.js), the version of JavaScript that you can run depends on your specific browser version. So it doesn’t matter if you are using the latest browsers if your users (that you want to keep) are still on IE. If you want to write the `class A {}` , for example, then you’re out of luck — some number of your users will get a `SyntaxError` and a white page.

So that’s why Babel was created. It allows you to write the version of JavaScript you desire, knowing that it will run correctly on all the (older) browsers you support.

But it doesn’t just stop at “ES6” (some people like to say ES2015). Babel has certainly expanded upon its initial goal of only compiling ES6 code, and now compiles whatever ES20xx version you want (the latest version of JavaScript) to ES5.

#### The ongoing process

One of the interesting things about the project is that, as long as new JavaScript syntax is added, Babel will need to implement a transform to convert it.

But you might be thinking, why should we even send a compiled version (larger code size) to browsers that do support that syntax? How do we even know what syntax each browser supports?

Well, we made `[babel-preset-en](https://babeljs.io/docs/plugins/preset-env)v` to help with that issue by creating a tool that lets you specify which browsers you support. It will automatically only transform the things that those browsers don’t support natively.

Beyond that, Babel (because of its usage in the community) has a place in influencing the future of the JavaScript language itself! Given that it is a tool for transforming JS code, it can also be used to implement any of the proposals submitted to [TC39](http://2ality.com/2015/11/tc39-process.html) (Ecma Technical Committee 39, the group that moves JavaScript forward as a standard).

There is a whole process a “proposal” goes through, from Stage 0 to Stage 4 when it lands into the language. Babel, as a tool, is in the right place to test out new ideas and to get developers to use it in their applications so they can give feedback to the committee.

This is really important for a few reasons: the committee wants to be confident that the changes they make are what the community wants (consistent, intuitive, effective). Implementing an unspecified idea in the browser is slow (C++ in the browser vs. JavaScript in Babel), costly, and requires users to use a flag in the browser versus changing their Babel config file.

Since Babel is so ubiquitous, there is a good chance that real usage will occur. This will make the proposal much better off than if it was just implemented without any vetting from the developer community at large.

And it is not just useful in production. Our online [REPL](https://babeljs.io/repl) is useful for people learning JavaScript itself, and allows them to test things out.

I think Babel is in a great position to be an educational tool for programmers so they can continue to learn how JavaScript works. Through contributing to the project itself, they’ll learn many other concepts such as ASTs, compilers, language specification, and more.

I’m really excited about the future of the project and can’t wait to see where the team can go. Please join and help us!

#### My story

Those are some of the reasons I get excited to work on this project each day, especially as a maintainer. Most of the current maintainers, including myself, didn’t create the project but joined a year after — and it’s still [mindblowing](https://medium.com/@left_pad/ossthanks-some-thoughts-d0267706c2c6) to think where I started.

As for me, I recognized a need and an interesting project. I slowly and consistently got more involved, and now I’ve been able to get my employer, [Behance](https://www.behance.net/), to sponsor half my time on Babel.

Sometimes “maintaining” just means fixing bugs, answering questions on our Slack or [Twitter](https://twitter.com/babeljs/), or writing a changelog (it’s really up to each of us). But recently, I’ve decreased my focus on making bug fixes and features. Instead, I’ve been putting some time into thinking about more high level issues like: what’s the future of this project? How do we grow our community in terms of the number of maintainers versus of the number of users? How can we sustain the project in terms of funding? Where do we fit in the JavaScript ecosystem as a whole (education, [TC39](https://github.com/tc39/proposals), tooling)? And is there a role for us to play in helping new people join in open source ([RGSoC](https://twitter.com/left_pad/status/959439119960215552) and [GSoC](https://summerofcode.withgoogle.com/))?

Because of these questions, what I’m most excited about with this release isn’t necessarily the particulars in the feature set (which are many: initial implementations of new proposals like the [Pipeline Operator (a |> b)](https://github.com/babel/babel/tree/master/packages/babel-plugin-proposal-pipeline-operator), a [new TypeScript preset](https://github.com/babel/babel/tree/master/packages/babel-preset-typescript) with help from the TS team, and .babelrc.js files).

Rather, I’m excited about what all those features represent: a year’s worth of hard work trying not to break everything, balancing users’ expectations (why is the build so slow/code output so large, why is the code not spec-compliant enough, why doesn’t this work without configuration, why isn’t there an option for x), and sustaining a solid team of mostly volunteers.

And I know our industry has a huge focus on “major releases,” hyped features, and stars, but that’s just one day that fades. I’d like to suggest we continue thinking about what it takes to be consistent in pushing the ecosystem forward in a healthy fashion.

This could simply mean thinking about the mental and emotional burden of maintainer-ship. It could mean thinking about how to provide mentorship, expectation management, work/life balance advice, and other resources to people wanting to get involved, instead of just encouraging developers to expect immediate, free help.

#### Diving into the changelog

Well, I hope you enjoy the long changelog 😊. If you’re interested in helping us out, please let us know and we’d be glad to talk more.

![](https://cdn-images-1.medium.com/max/800/0*zvhm_vD3VWFaWA1c.png)

We started a new [videos page](https://babeljs.io/docs/community/videos/), since people wanted to learn more about how Babel works and contribute back. This page contains videos of conference talks on Babel and related concepts from team members and people in the community.

![](https://cdn-images-1.medium.com/max/800/0*8q5nV1APkAFKydrZ.png)

We also created a new [team page](https://babeljs.io/team)! We will be updating this page in the future with more information about what people work on and why they are involved. For such a large project, there are many ways to get involved and help out.

Here are some highlights and quick facts:

*   Babel turned 3 years old on [September 28, 2017](https://babeljs.io/blog/2017/10/05/babel-turns-three)!
*   Daniel [moved](https://twitter.com/left_pad/status/926096965565370369) `babel/babylon` and `babel/babel-preset-env` into the main Babel monorepo, [babel/babel](https://github.com/babel/babel). This includes all Git history, labels, and issues.
*   We received a [$1k/month donation](https://twitter.com/left_pad/status/923696620935421953) from Facebook Open Source!
*   This the highest monthly donation we have gotten since the start (next highest is $100/month).
*   In the meantime, we will use our funds to meet in person and to send people to TC39 meetings. These meetings are every 2 months around the world.
*   If a company wants to specifically sponsor something, we can create separate issues to track. This was difficult before, because we had to pay out of pocket or find a conference to speak at during the same week to help cover expenses.

#### How you can help

If your company would like to **give back** by supporting a fundamental part of JavaScript development and its future, consider donating to our [Open Collective](https://opencollective.com/babel). You can also donate developer time to help maintain the project.

#### #1: Help maintain the project (developer time at work)

![](https://i.loli.net/2018/05/10/5af3a5e7b9a3f.png)

The best thing for Babel is finding people who are committed to helping out with the project, given the massive amount of work and responsibility it requires. Again, [I never felt ready](https://dev.to/hzoo/im-the-maintainer-of-babel-ask-me-anything-282/comments/1k6d) to be a maintainer, but somehow stumbled upon it. But I’m just one person, and our team is just a few people.

#### #2: Help fund development

![](https://i.loli.net/2018/05/10/5af3a5e8009bc.png)

We definitely want to be able to fund people on the team so they can work full-time. Logan, in particular, left his job a while ago and is using our current funds to work on Babel part time.

#### #3 Contribute in other ways 😊

For example, [Angus](https://twitter.com/angustweets) made us an [official song](https://medium.com/@angustweets/hallelujah-in-praise-of-babel-977020010fad)!

#### Upgrading

We will also be working on an upgrade tool that will help [rewrite your package.json/.babelrc files](https://github.com/babel/notes/issues/44) and more. Ideally, this means it would modify any necessary version number changes, package renames, and config changes.

Please reach out to help and to post issues when trying to update. This is a great opportunity to get involved and help the ecosystem update!

#### Summary of the [previous post](https://babeljs.io/blog/2017/09/12/planning-for-7.0)

*   Dropped Node 0.10/0.12/5 support.
*   Updated [TC39 proposals](https://github.com/babel/proposals/issues)
*   Numeric Separator: `1_000`
*   Optional Chaining Operator: `a?.b`
*   `import.meta` (parseble)
*   Optional Catch Binding: `try { a } catch {}`
*   BigInt (parseble): `2n`
*   Split export extensions into `export-default-from` and `export-ns-form`
*   `.babelrc.js` support (a config using JavaScript instead of JSON)
*   Added a new Typescript Preset and separated the React/Flow presets
*   Added [JSX Fragment Support](https://reactjs.org/blog/2017/11/28/react-v16.2.0-fragment-support.html) and various Flow updates
*   Removed the internal `babel-runtime` dependency for smaller size

#### Newly updated TC39 proposals

*   Pipeline Operator: `a |> b`
*   Throw Expressions: `() => throw 'hi'`
*   Nullish Coalescing Operator: `a ?? b`

#### Deprecated yearly presets (e.g. babel-preset-es20xx)

TL;DR: use `babel-preset-env`.

What’s better than you having to decide which Babel preset to use? Having it done for you, automatically!

Even though the amount of work that goes into maintaining the lists of data is humongous — again, why we need help — it solves multiple issues. It makes sure users are up to date with the spec. It means less configuration/package confusion. It means an easier upgrade path. And it means fewer issues about what is what.

`babel-preset-env` is actually a pretty _old_ preset that replaces every other syntax preset that you will need (es2015, es2016, es2017, es20xx, latest, and so on).

![](https://cdn-images-1.medium.com/max/800/0*wgAjmRI1MVcI_Veg.png)

It compiles the latest yearly release of JavaScript (whatever is in Stage 4) which replaces all the old presets. But it also has the ability to compile according to target environments you specify: it can handle development mode, like the latest version of a browser, or multiple builds, like a version for IE. It even has another version for evergreen browsers.

#### Not removing the Stage presets (babel-preset-stage-x)

![](https://i.loli.net/2018/05/10/5af3a6239956e.png)

We can always keep it up to date, and maybe we just need to determine a better system than what the current presets are.

Right now, stage presets are just a list of plugins that we manually update after each TC39 meeting. To make this manageable, we need to allow major version bumps for these “unstable” packages. This is partly because the community will re-create these packages anyway. So we might as well do it from an official package, and then have the ability to provide better messaging and so on.

#### Renames: Scoped Packages (`@babel/x`)

Here is a poll I put out almost a year ago:

![](https://i.loli.net/2018/05/10/5af3a6402f8b7.png)

Back then, not a lot of projects used scoped packages, so most people didn’t even know they existed. You might have had to pay for an npm org account back then, whereas now it is free (and supports non-scoped packages, too).

The issues with searching for scoped packages are solved, and download counts work. The only stumbling block left is that some 3rd party registries still don’t support scoped packages. But I think we are at a point where it seems pretty unreasonable to wait on that.

Here’s why we prefer scoped packages:

*   Naming is difficult: we won’t have to check if someone else decided to use our naming convention for their own plugin
*   We have similar issues with package squatting
*   Sometimes people create `babel-preset-20xx` or some other package because it’s funny. We have to make an issue and email to ask for it back.
*   People have a legit package, but it happens to be the same name as what we wanted to call it.
*   People see that a new proposal is merging (like optional chaining or pipeline operator) and decide to fork and publish a version of it under the same name. Then, when we publish, it tell us the package was already published 🤔. So I have to find their email and email both them and npm support to get the package back and republish.
*   What is an “official” package and what is a user/community package with the same name? We get issue reports of people using misnamed or unofficial packages because they assumed it was part of Babel. One example of this was a report that `babel-env` was rewriting their `.babelrc` file. It took them a while to realize it wasn't `babel-preset-env`.

So, it seems pretty clear that we should use scoped packages, and, if anything, we should have done it much earlier 🙂!

Examples of the scoped name change:

*   `babel-cli` -> `@babel/cli`
*   `babel-core` -> `@babel/core`
*   `babel-preset-env` -> `@babel/preset-env`

#### Renames: `-proposal-`

Any proposals will be named with `-proposal-` now to signify that they aren't officially in JavaScript yet.

So `@babel/plugin-transform-class-properties` becomes `@babel/plugin-proposal-class-properties`, and we would name it back once it gets into Stage 4.

#### Renames: Drop the year from the plugin name

Previous plugins had the year in the name, but it doesn’t seem to be necessary now.

So `@babel/plugin-transform-es2015-classes` becomes `@babel/plugin-transform-classes`.

Since years were only used for es3/es2015, we didn’t change anything from es2016 or es2017. However, we are deprecating those presets in favor of preset-env, and, for the template literal revision, we just added it to the template literal transform for simplicity.

#### Peer dependencies and integrations

We are introducing a peer dependencies on `@babel/core` for all the plugins (`@babel/plugin-class-properties`), presets (`@babel/preset-env`), and top level packages (`@babel/cli`, `babel-loader`).

> peerDependencies are dependencies expected to be used by your code, as opposed to dependencies only used as an implementation detail. — [Stijn de Witt via StackOverflow](https://stackoverflow.com/a/34645112).

`babel-loader` already had a `peerDependency` on `babel-core`, so this just changes it to `@babel/core`. This change prevents people from trying to install these packages on the wrong version of Babel.

For tools that already have a `peerDependency` on `babel-core` and aren't ready for a major bump (since changing the peer dependency is a breaking change), we have published a new version of `babel-core` to bridge the changes over with the new version [babel-core@7.0.0-bridge.0](https://github.com/babel/babel-bridge). For more information, check out [this issue](https://github.com/facebook/jest/pull/4557#issuecomment-344048628).

Similarly, packages like `gulp-babel`, `rollup-plugin-babel`, and so on all used to have `babel-core` as a dependency. Now these will just have a `peerDependency` on `@babel/core`. Because of this, these packages don’t have to bump major versions when the `@babel/core` API hasn't changed.

#### [#5224](https://github.com/babel/babel/pull/5224): independent publishing of experimental packages

I mention this in [The State of Babel](http://babeljs.io/blog/2016/12/07/the-state-of-babel) in the `Versioning` section. Here’s the [Github Issue](https://github.com/babel/babylon/issues/275).

You might remember that after Babel 6, Babel became a set of npm packages with its own ecosystem of custom presets and plugins.

Since then, however, we have always used a “fixed/synchronized” versioning system (so that no package is on v7.0 or above). When we do a new release, such as `v6.23.0` , only packages that have updated code in the source are published with the new version. The rest of the packages are left as is. This mostly works in practice because we use `^` in our packages.

Unfortunately, this kind of system requires a major version to be released for all packages once a single package needs it. This either means that we make a lot small breaking changes (unnecessary), or we batch lots of breaking changes into a single release. Instead, we want to differentiate between the experimental packages (Stage 0, and so on) and everything else (es2015).

Because of this, we intend to make major version bumps to any experimental proposal plugins when the spec changes, rather than waiting to update all of Babel. So anything that is < Stage 4 would be open to breaking changes in the form of major version bumps. The same applies to the Stage presets themselves (if we don’t drop them entirely).

This goes along with our decision to require TC39 proposal plugins to use the `-proposal-` name. If the spec changes, we will do a major version bump to the plugin and the preset it belongs to (as opposed to just making a patch version which may break for people). Then, we will need to deprecate the old versions and setup an infrastructure which will automatically update people so that they’re up to date on what the spec will become (and so they don't get stuck on something. We haven’t been so lucky with decorators.).

#### The `env` option in `.babelrc` is not being deprecated!

Unlike in the [last post](https://babeljs.io/blog/2017/09/12/planning-for-7.0#deprecate-the-env-option-in-babelrc), we just fixed the merging behavior to be [more consistent](https://twitter.com/left_pad/status/936687774098444288).

The configuration in `env` is given higher priority than root config items. And instead of the weird approach of just using both, plugins and presets now merge based on their identity, so you can do this:

```
{  presets: [    ['env', { modules: false}],  ],  env: {    test: {      presets: [         'env'      ],    }  },}
```

with `BABEL_ENV=test` . It would replace the root env config with the one from test, which has no options.

#### Support `[class A extends Array](https://twitter.com/left_pad/status/940723982638157829)` (oldest caveat)

Babel will automatically wrap any native built-ins like `Array`, `Error`, and `HTMLElement` so that doing this just works when compiling classes.

#### Speed

*   Many [fixes](https://twitter.com/rauchg/status/924349334346276864) from [bmeurer](https://twitter.com/bmeurer) on the v8 team!
*   60% faster via the [web-tooling-benchmark](https://github.com/v8/web-tooling-benchmark) [https://twitter.com/left_pad/status/927554660508028929](https://twitter.com/left_pad/status/927554660508028929)

#### preset-env: `"useBuiltins": "usage"`

`babel-preset-env` introduced the idea of compiling syntax to different targets. It also introduced, via the `useBuiltIns` option, the ability to only add polyfills that the targets don't support.

So with this option, something like:

```
import "babel-polyfill";
```

can turn into

```
import "core-js/modules/es7.string.pad-start";import "core-js/modules/es7.string.pad-end";// ...
```

if the target environment happens to support polyfills other than `padStart` or `padEnd`.

But in order to make that even better, we should only import polyfills that are “used” in the codebase itself. Why import `padStart` if it is not even used in the code?

`"useBuiltins": "usage"` is our first attempt to tackle that idea. It performs an import at the top of each file, but only adds the import if it finds it used in the code. This approach means that we can import the minimum amount of polyfills necessary for the app (and only if the target environment doesn't support it).

So if you use `Promise` in your code, it will import it at the top of the file (if your target doesn't support it). Bundlers will dedupe the file if it is the same, so this approach won't cause multiple polyfills to be imported.

```
import "core-js/modules/es6.promise";var a = new Promise();
```

```
import "core-js/modules/es7.array.includes";[].includesa.includes
```

With type inference we can know if an instance method like `.includes` is for an array or not. Having a false positive is ok until that logic is better, since it is still better than importing the whole polyfill like before.

#### Misc updates

*   `[babel-template](https://github.com/babel/babel/blob/master/packages/babel-template)` is faster and easier to use
*   [regenerator](https://github.com/facebook/regenerator) was released under the [MIT License](https://twitter.com/left_pad/status/938825429955125248) — it’s the dependency used to compile generators/async
*   “lazy” option to the `modules-commonjs` plugin via [#6952](https://github.com/babel/babel/pull/6952)
*   You can now use `envName: "something"` in .babelrc or pass via cli `babel --envName=something` instead of having to use `process.env.BABEL_ENV` or `process.env.NODE_ENV`
*   `["transform-for-of", { "assumeArray": true }]` to make all for-of loops output as regular arrays
*   Exclude `transform-typeof-symbol` in loose mode for preset-env [#6831](https://github.com/babel/babel/pull/6831)
*   [Landed PR for better error messages with syntax errors](https://twitter.com/left_pad/status/942859244759666691)

#### To-dos Before Release

*   [Handle](https://github.com/babel/babel/issues/6766) `[.babelrc](https://github.com/babel/babel/issues/6766)` [lookup](https://github.com/babel/babel/issues/6766) (want this done before first RC release)
*   [“overrides” support](https://github.com/babel/babel/pull/7091): different config based on glob pattern
*   Caching and invalidation logic in babel-core.
*   Better story around external helpers.
*   Either implement or have a plan in place for versioning and handling polyfills independently from helpers, so we aren’t explicitly tied to core-js 2 or 3. People may have things that depend on one or the other, and won’t want to load both a lot of the time.
*   Either a [working decorator implementation](https://github.com/babel/babel/pull/6107), or functional legacy implementation, with clear path to land current spec behavior during 7.x’s lifetime.

#### Thanks

Shoutout to our team of volunteers:

[Logan](https://twitter.com/loganfsmyth) has been really pushing hard to fix a lot of our core issues regarding configs and more. He’s the one doing all of that hard work.

[Brian](https://twitter.com/existentialism) has been taking over maintenance of a lot of preset-env work and whatever else I was doing before 😛

[Daniel](https://twitter.com/TschinderDaniel) has always stepped in when we need the help, whether it be maintaining babel-loader or helping move the babylon/babel-preset-env repo’s over. And same with [Nicolo](https://twitter.com/NicoloRibaudo), [Sven](https://twitter.com/svensauleau), [Artem](https://twitter.com/yavorsky_), and [Diogo](https://twitter.com/kovnsk) who have stepped up in the last year to help out.

I’m really looking forward to a release (I’m tired too — it’s almost been a year 😝). But I also don’t want to rush anything just because. There’s been a lot of ups and downs throughout this release, but I’ve certainly learned a lot and I’m sure the rest of the team has as well.

And if I’ve learned anything at all this year, I should really heed this advice rather than just write about it.

![](https://i.loli.net/2018/05/10/5af3a67ab1365.png)

> Also thanks to [Mariko](https://twitter.com/kosamari) for the [light push](https://twitter.com/kosamari/status/944272286055530496) to actually finish this post (2 months in the making)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
