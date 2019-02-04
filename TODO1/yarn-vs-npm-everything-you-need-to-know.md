> * 原文地址：[Yarn vs npm: Everything You Need to Know](https://www.sitepoint.com/yarn-vs-npm/)
> * 原文作者：[Tim Severien](https://www.sitepoint.com/author/tseverien/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/yarn-vs-npm-everything-you-need-to-know.md](https://github.com/xitu/gold-miner/blob/master/TODO1/yarn-vs-npm-everything-you-need-to-know.md)
> * 译者：
> * 校对者：

# Yarn vs npm: Everything You Need to Know

Yarn is a new JavaScript package manager built by Facebook, Google, Exponent and Tilde. As can be read in the [official announcement](https://code.facebook.com/posts/1840075619545360), its purpose is to solve a handful of problems that these teams faced with npm, namely:

*   installing packages wasn’t fast/consistent enough, and
*   there were security concerns, as npm allows packages to run code on installation.

But, don’t be alarmed! This is not an attempt to replace npm completely. Yarn is only a new CLI client that fetches modules from the npm registry. Nothing about the registry itself will change — you’ll still be able to fetch and publish packages as normal.

Should everyone jump aboard the Yarn hype train now? Chances are you never encountered these problems with npm. In this article, we’re going to compare npm and Yarn, so you can decide which is best for you.

![Yarn logo](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2016/10/1476870188yarn.jpg)

## Yarn vs npm: Functional Differences

At a first glance Yarn and npm appear similar. As we peek under the hood though, we realize what makes Yarn different.

### The yarn.lock File

In `package.json`, the file where both npm and Yarn keep track of the project’s dependencies, version numbers aren’t always exact. Instead, you can define a range of versions. This way you can choose a specific major and minor version of a package, but allow npm to install the latest patch that might fix some bugs.

In an ideal world of [semantic versioning](http://semver.org/), patched releases won’t include any breaking changes. This, unfortunately, is not always true. The strategy employed by npm may result into two machines with the same `package.json` file, having different versions of a package installed, possibly introducing bugs.

To avoid package version mis-matches, an exact installed version is pinned down in a lock file. Every time a module is added, Yarn creates (or updates) a `yarn.lock` file. This way you can guarantee another machine installs the exact same package, while still having a range of allowed versions defined in `package.json`.

In npm, the `npm shrinkwrap` command generates a lock file as well, and `npm install` reads that file before reading `package.json`, much like how Yarn reads `yarn.lock` first. The important difference here is that Yarn always creates and updates `yarn.lock`, while npm doesn’t create one by default and only updates `npm-shrinkwrap.json` when it exists.

1.  [yarn.lock documentation](https://yarnpkg.com/en/docs/configuration#toc-use-yarn-lock-to-pin-your-dependencies)
2.  [npm shrinkwrap documentation](https://docs.npmjs.com/cli/shrinkwrap)

### Parallel Installation

Whenever npm or Yarn needs to install a package, it carries out a series of tasks. In npm, these tasks are executed per package and sequentially, meaning it will wait for a package to be fully installed before moving on to the next. Yarn executes these tasks in parallel, increasing performance.

For comparison, I installed the [express](https://www.npmjs.com/package/express) package using both npm and Yarn without a shrinkwrap/lock file and with a clean cache. This installs 42 packages in total.

propertag.cmd.push(function() { proper_display('sitepoint_content_1'); });

*   npm: 9 seconds
*   Yarn: 1.37 seconds

I couldn’t believe my eyes. Repeating the steps yielded similar results. I then installed the [gulp](https://www.npmjs.com/package/gulp) package, resulting in 195 dependencies.

*   npm: 11 seconds
*   Yarn: 7.81 seconds

It seems the difference closely depends on the amount of packages that are being installed. Either way, Yarn is consistently faster.

### Cleaner Output

By default npm is very verbose. For example, it recursively lists all installed packages when running `npm install <package>`. Yarn on the other hand, isn’t verbose at all. When details can be obtained via other commands, it lists significantly less information with appropriate emojis (unless you’re on Windows).

![The output of the "yarn install" command](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2016/10/1476651912yarn-install-output.png)

## Yarn vs npm: CLI Differences

Other than some functional differences, Yarn also has different commands. Some npm commands were removed, others modified and a couple of interesting commands were added.

### yarn global

Unlike npm, where global operations are performed using the `-g` or `--global` flag, Yarn commands need to be prefixed with `global`. Just like npm, project-specific dependencies shouldn’t need to be installed globally.

The `global` prefix only works for `yarn add`, `yarn bin`, `yarn ls` and `yarn remove`. With the exception of `yarn add`, these commands are identical to their npm equivalent.

1.  [yarn global documentation](https://yarnpkg.com/en/docs/cli/global)

### yarn install

The `npm install` command will install dependencies from the `package.json` file and allows you to add new packages. `yarn install` only installs the dependencies listed in `yarn.lock` or `package.json`, in that order.

1.  [yarn install documentation](https://yarnpkg.com/en/docs/cli/install)
2.  [npm install documentation](https://docs.npmjs.com/cli/install)

### yarn add [–dev]

Similar to `npm install <package>`, `yarn add <package>` allows you to add and install a dependency. As the name of the command implies, it adds a dependency, meaning it automatically saves a reference to the package in the `package.json` file, just as npm’s `--save` flag does. Yarn’s `--dev` flag adds the package as a developer dependency, like npm’s `--save-dev` flag.

1.  [yarn add documentation](https://yarnpkg.com/en/docs/cli/add)
2.  [npm install documentation](https://docs.npmjs.com/cli/install)

### yarn licenses [ls|generate-disclaimer]

At the time of writing, no npm equivalent is available. `yarn licenses ls` lists the licenses of all installed packages. `yarn licenses generate-disclaimer` generates a disclaimer containing the contents of all licenses of all packages. Some licenses state that you must include the project’s license in your project, making this a rather useful tool to do that.

1.  [yarn licenses documentation](https://yarnpkg.com/en/docs/cli/licenses)

### yarn why

This command peeks into the dependency graph and figures out why given package is installed in your project. Perhaps you explicitly added it, perhaps it’s a dependency of a package you installed. `yarn why` helps you figure that out.

1.  [yarn why documentation](https://yarnpkg.com/en/docs/cli/why)

### yarn upgrade [package]

This command upgrades packages to the latest version conforming to the version rules set in `package.json` and recreates `yarn.lock`. This is similar to `npm update`.

Interestingly, when specifying a package, it updates that package to latest release and updates the tag defined in `package.json`. This means this command might update packages to a new major release.

1.  [yarn upgrade documentation](https://yarnpkg.com/en/docs/cli/upgrade)

### yarn generate-lock-entry

The `yarn generate-lock-entry` command generates a `yarn.lock` file based on the dependencies set in `package.json`. This is similar to `npm shrinkwrap`. This command should be used with caution, as the lock file is generated and updated automatically when adding and upgrading dependencies via `yarn add` and `yarn upgrade`.

1.  [yarn generate-lock-entry documentation](https://yarnpkg.com/en/docs/cli/generate-lock-entry)
2.  [npm shrinkwrap documentation](https://docs.npmjs.com/cli/shrinkwrap)

## Stability and Reliability

Could the Yarn hype train become derailed? It did receive a lot of [issue reports](https://github.com/yarnpkg/yarn/issues) the first day it was released into the public, but the rate of resolved issues is also astounding. Both indicate that the community is working hard to find and remove bugs. Looking at the number and type of issues, Yarn appears stable for most users, but might not yet be suitable for edge cases.

Note that although a package manager is probably vital for your project, it is just a package manager. If something goes wrong, reinstalling packages shouldn’t be difficult, and nor is reverting back to npm.

## The Future

Perhaps you’re aware of the history between Node.js and io.js. To recap: io.js was a fork of Node.js, created by some core contributors after some disagreement over the project’s governance. Instead, io.js chose an open governance. In less than a year, both teams came to an agreement, io.js was merged back into Node.js, and the former was discontinued. Regardless of the rights or wrongs, this introduced a lot of great features into Node.js.

I’m seeing similar patterns with npm and Yarn. Although Yarn isn’t a fork, it improves several flaws npm has. Wouldn’t it be cool if npm learned from this and asked Facebook, Google and the other Yarn contributors to help improve npm instead? Although it is way too early to say if this will happen, I hope it will.

Either way, Yarn’s future looks bright. The community appears excited and is receiving this new package manager well. Unfortunately, no road map is available, so I am not sure what surprises Yarn has in store for us.

## Conclusion

Yarn scores points with way better defaults compared to npm. We get a lockfile for free, installing packages is blazing fast and they are automatically stored in `package.json`. The impact of installing and using Yarn is also minimal. You can try it on just one project, and see if it works for you or not. This makes Yarn a perfect drop-in substitute for npm.

propertag.cmd.push(function() { proper_display('sitepoint_content_2'); });

I would definitely recommend trying Yarn on a single project sooner or later. If you are cautious about installing and using new software, give it a couple of months. After all, npm is battle-tested, and that is definitely worth something in the world of software development.

If you happen to find yourself waiting for npm to finish installing packages, that might be the perfect moment to read the [migration guide](https://yarnpkg.com/en/docs/migrating-from-npm) ;)

What do you think? Are you using Yarn already? Are you willing to give it a try? Or is this just contributing to the further fragmentation of an already fragmented ecosystem? Let me know in the comments below.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
