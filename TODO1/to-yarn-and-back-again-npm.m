> * 原文地址：[To Yarn and Back (to npm) Again](https://mixmax.com/blog/to-yarn-and-back-again-npm)
> * 原文作者：[Spencer Brown](http://spencer.sx/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/to-yarn-and-back-again-npm.md](https://github.com/xitu/gold-miner/blob/master/TODO1/to-yarn-and-back-again-npm.md)
> * 译者：
> * 校对者：

# To Yarn and Back (to npm) Again

Last year, [we decided to move all of our JavaScript projects from npm to Yarn](https://mixmax.com/blog/yarn-ifying-mixmax).

We did so for two primary reasons:

*   `yarn install` was 20x faster than `npm install`. `npm install` was taking upward of 20 minutes in many of our larger projects.
*   Yarn's dependency locking was singificantly more reliable than npm's.

Check out last year's blog post (linked above) for more details.

## 13 months with Yarn

Yarn solved the annoying problems we faced using npm, but it came with issues of its own:

*   Yarn has shipped [very bad regressions](https://github.com/yarnpkg/yarn/issues/3765), which made us afraid of upgrading.
*   Yarn often produces `yarn.lock` files that are invalid when you run `add`, `remove`, or `update`. This results in engineers needing to perform tedious work to `remove` and `add` offending packages until Yarn figures out how to untangle itself so that `yarn check` passes.
*   Frequently when engineers would run `yarn` after pulling down a project's latest changes, their `yarn.lock` files would become dirty due to Yarn [making optimizations](https://github.com/yarnpkg/yarn/issues/4379#issuecomment-332512206). Resolving this required engineers to make and push commits unrelated to their work. Yarn should perform these optimizations when commands update `yarn.lock`, not the next time `yarn` is run.
*   `yarn publish` is unreliable (broken?) ([tracked issues #1](https://github.com/yarnpkg/yarn/issues/1619), [tracked issue #2](https://github.com/yarnpkg/yarn/issues/1182)), which meant that we had to use `npm publish` to publish packages. It was easy to forget that we needed to use npm in this special case and accidentally publishing with Yarn resulted in published packages being un-installable.

Unfortunately, none of these workflow-breaking issues were fixed during the 13 months we used Yarn.

After a couple of especially painful weeks full of 15-minute Yarn untangling sessions, we decided to take a look at moving back to npm.

## npm 6

npm made significant improvements during the time we used Yarn in an attempt to catch up to Yarn's speed and locking - the issues that originally led us to Yarn. As annoying as our Yarn issues were, we couldn't afford to lose these benefits, so we first had to validate that npm had addressed our original issues.

We decided to trial the latest version of npm available at the time, `npm@​6.0.0`, since we wanted to take advantage of as many speed improvements and bug fixes as possible. `npm​@6.0.0` was [reportedly a relatively minor major update](https://github.com/npm/npm/releases/tag/v6.0.0-next.0), so we figured that using it wouldn't be dangerously risky. Strangely, `npm​@5.8.1` the version of npm we had tested prior to 6.0.0's release, failed to install dependencies on several of our engineers' machines (OS X Sierra/High Sierra, `node​@v8.9.3`) with various errors (eg [`cb() never called!`](https://github.com/npm/npm/issues?utf8=%E2%9C%93&q=is%3Aissue+is%3Aopen+cb+never+called)).

### Speed

We were happy to find that in a trial of five samples per package manager, npm performed about the same as Yarn on average:

*   Yarn: `$ rm -rf node_modules && time yarn`: 126s
*   npm: `$ rm -rf node_modules && time npm i`: 132s

A step in the right direction. Our investigation continued :).

### Locking

npm introduced [`package-lock.json`](https://docs.npmjs.com/files/package-lock.json) in `npm@​5.0.0` \- the npm-equivalent of Yarn's `yarn.lock`. [`npm shrinkwrap`](https://docs.npmjs.com/cli/shrinkwrap) can still be used to create [`npm-shrinkwrap.json`](https://docs.npmjs.com/files/shrinkwrap.json) files, but the use case for these files is a bit different per [npm's docs](https://docs.npmjs.com/files/shrinkwrap.json):

> The recommended use-case for npm-shrinkwrap.json is applications deployed through the publishing process on the registry: for example, daemons and command-line tools intended as global installs or devDependencies. It's strongly discouraged for library authors to publish this file, since that would prevent end users from having control over transitive dependency updates.

`package-lock.json` files, on the other hand, [are not published with packages](https://docs.npmjs.com/files/package-lock.json). This is equivalent to how Yarn does not respect dependencies' `yarn.lock` files - the parent project manages its own dependencies and subdependencies (with the caveat that if libraries _do_ publish `npm-shrinkwrap.json` files when they shouldn't, you'll be stuck using their dependencies).

#### Locking validation

npm doesn't have an equivalent to Yarn's [`yarn check`](https://yarnpkg.com/lang/en/docs/cli/check/), but it looks like some folks ([like Airbnb](https://github.com/npm/npm/issues/17722#issuecomment-355454948)) use `npm ls >/dev/null` to check for installation errors such as missing packages.

Unfortunately that check counts peer dependency warnings as errors, which has prevented us from using it, since [we often fulfill peer dependencies via CDN](https://mixmax.com/blog/rollup-externals).

npm recently introduced [`npm ci`](https://docs.npmjs.com/cli/ci), which fortunately provides some validation. `npm ci` ensures that `package-lock.json` and `package.json` are in sync as one form of validation. It also provides some other benefits - check out the documentation for details.

We never observed `install` inconsistencies when using npm previously (only Yarn seems to have these issues :)), so we figured that we would be safe using only `npm ci`.

### Yarn annoyances

In addition to catching up to Yarn's speed and locking guarantees, it seemed that npm did not have any of the issues that had been bothering us with Yarn!

### Check, check, check

`npm​@6.0.0` checked all of the boxes for us, so we decided to move forward with it!

After a successful 3-week trial in one of our services, we migrated the rest of our services and projects!

## Recommendations

### `deyarn`

We've published an open-source module called [`deyarn`](https://github.com/mixmaxhq/deyarn) to help you convert your projects from Yarn to npm!

### Using `engines` to enforce npm use

We recommend using [the `engines` option](https://docs.npmjs.com/files/package.json#engines) to help yourself avoid accidentally using Yarn when you want to use npm.

We've added a configuration like:

```
{
    "engines": {
    "yarn": "NO LONGER USED - Please use npm"
    }
}
```
    

to all of the `package.json`s in our internal projects. `deyarn` (linked above) takes care of this for you :).

### Try it out!

We tested that this flow would work for our needs and we suggest you do too. If you need the absolute fastest package manager, then you may still find [Yarn to be best](https://www.google.com/search?q=yarn%20vs%20npm%20speed). But if you're looking to simplify your setup, we've found that npm 6 recaptures a critical balance between speed and reliability.

[Want to help us build the future of communication using npm?](https://mixmax.com/careers)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
