> * 原文地址：[Automated npm releases with Travis CI](https://tailordev.fr/blog/2018/03/15/automated-npm-releases-with-travis-ci/)
> * 原文作者：[TailorDev](https://tailordev.fr)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/automated-npm-releases-with-travis-ci.md](https://github.com/xitu/gold-miner/blob/master/TODO/automated-npm-releases-with-travis-ci.md)
> * 译者：
> * 校对者：

# Automated npm releases with Travis CI

Releasing a package on the [npm registry](https://www.npmjs.com/) should be boring. In this blog post, we describe how we set up [Travis CI](https://travis-ci.org/) to release npm packages on each git tag.

![Automated npm releases with Travis CI](/img/post/2018/03/automated-npm-releases.png "Automated npm releases with Travis CI")

At TailorDev, we like to automate many important steps required to build software. One of these steps is to release the final, production-ready, bundle of an application, also known as artifact or package. Today, we focus on the JavaScript world and we describe how to automate the release process of packages on the npm registry without any effort.

First thing first, npm has introduced [two-factor authentication](https://docs.npmjs.com/getting-started/using-two-factor-authentication) (2FA for short) in 2017 and that was an excellent idea until we discovered that it was “all or nothing” ![:confused:](https://assets.github.com/images/icons/emoji/unicode/1f615.png ":confused:"). Indeed, npm 2FA relies on [One Time Passwords](https://en.wikipedia.org/wiki/One-time_password) to protect everything related to your account and automating that would defeat the purpose of enabling 2FA.

_But, why is it so important?_ I am glad you ask! Because we need an API token in the sequel, and it is currently not possible to generate and use tokens without triggering the 2FA mechanism. In other words, with 2FA enabled, it is nearly impossible to automate the npm release process, “nearly” because npm implements [two levels of authentication](https://docs.npmjs.com/getting-started/using-two-factor-authentication#levels-of-authentication): `auth-only` and `auth-and-writes`. By restricting the 2FA usage to `auth-only`, it becomes possible to use API tokens in an automated fashion, but it is less secure. We really hope npm will allow to generate auth tokens designed for automated tasks in the near future, meanwhile:

```
$ npm profile enable-2fa auth-only
```

Once your account has 2FA enabled for `auth-only` usage (which is better than not having 2FA enabled by the way), let’s create a token:

```
$ npm token create

+----------------+--------------------------------------+
| token          | a73c9572-f1b9-8983-983d-ba3ac3cc913d |
+----------------+--------------------------------------+
| cidr_whitelist |                                      |
+----------------+--------------------------------------+
| readonly       | false                                |
+----------------+--------------------------------------+
| created        | 2017-10-02T07:52:24.838Z             |
+----------------+--------------------------------------+
```

This token will be used by Travis CI to authenticate on your behalf. We can either [encrypt this token as an environment variable using the Travis CLI](https://docs.travis-ci.com/user/environment-variables/#Encrypting-environment-variables) or [define a variable in Travis CI repository settings](https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings), which we find to be more convenient. Declare two secret environment variables `NPM_EMAIL` and `NPM_TOKEN`:

![Travis CI settings](/img/post/2018/03/travis-ci-settings.png)

Now, the most important part is to create a job to actually release the npm package. We decided to leverage the [build stages (beta) feature](https://docs.travis-ci.com/user/build-stages/) combined to [Travis CI recommended way to release npm packages](https://docs.travis-ci.com/user/deployment/npm/). For the record, we want to release the package only once per build, no matter the existing build matrix and we also want to release npm packages on git tags to be consistent between the npm releases and the GitHub releases.

We start with a standard `.travis.yml` file for JavaScript projects, where the code is linted and tested for both Node 8 and 9, and [yarn](https://yarnpkg.com/) is used as package manager:

```
language: node_js
node_js:
  - "8"
  - "9"

cache: yarn

install: yarn
script:
  - yarn lint
  - yarn test
```

![Standard Travis CI output with two JavaScript
jobs](/img/post/2018/03/travis-ci-two-jobs-node.png)

We can now configure our “deploy” job by adding the configuration below to our previous `.travis.yml` file:

```
jobs:
  include:
    - stage: npm release
      if: tag IS present
      node_js: "8"
      script: yarn compile
      before_deploy:
        - cd dist
      deploy:
        provider: npm
        email: "$NPM_EMAIL"
        api_key: "$NPM_TOKEN"
        skip_cleanup: true
        on:
          tags: true
```

Let’s break it line by line. First, we “include” a new stage `npm release` if and only if `tag IS present`, which means the build has been triggered by a git tag. We select node `8` (our production version) and we execute `yarn compile` to build our package. This script creates a `dist/` folder containing our package files ready to be published on the npm registry. Last but not the least, we invoke the Travis CI `deploy` command to actually publish the package on the npm registry (and we restrict this command to git tags only as an extra protection layer).

Note: `skip_cleanup` must be set to `true` to prevent Travis CI to clean up any additional files and changes you made before the release.

![Travis CI with build stages for
JavaScript](/img/post/2018/03/travis-ci-build-stages.png)

How cool is this? ![:sunglasses:](https://assets.github.com/images/icons/emoji/unicode/1f60e.png ":sunglasses:")

## Bonus: npm releases like a pro

In order to create a new release, we use [`npm version`](https://docs.npmjs.com/cli/version) (it is built-in in npm ![:rocket:](https://assets.github.com/images/icons/emoji/unicode/1f680.png ":rocket:")). Assuming we are at version `0.3.2` and we want to release `0.3.3`. Locally, on the `master` branch, we run the following command:

```
$ npm version patch
```

This command performs the following tasks:

1.  bump (update) the version number in `package.json`
2.  create a new commit
3.  create a git tag

We can use `npm version minor` to release `0.4.0` from `0.3.1` (it bumps the second number and resets the last number). We can also use `npm version major` to release `1.0.0` from `0.3.1`.

Once done with the `npm version` command, you can just run `git push origin master --tag` and wait a bit until your package is published on the npm registry ![:tada:](https://assets.github.com/images/icons/emoji/unicode/1f389.png ":tada:")


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
