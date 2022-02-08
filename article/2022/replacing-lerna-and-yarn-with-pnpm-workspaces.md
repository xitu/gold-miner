> * 原文地址：[Replacing Lerna + Yarn with PNPM Workspaces](https://www.raulmelo.dev/blog/replacing-lerna-and-yarn-with-pnpm-workspaces)
> * 原文作者：[Raul Melo](https://www.raulmelo.dev/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/replacing-lerna-and-yarn-with-pnpm-workspaces.md](https://github.com/xitu/gold-miner/blob/master/article/2022/replacing-lerna-and-yarn-with-pnpm-workspaces.md)
> * 译者：[CarlosChenN](https://github.com/CarlosChenN)
> * 校对者：

# 用 PNPM Workspaces 替换 Lerna + Yarn

近年来，Monorepo 架构以越来越流行，鉴于它解决的问题，这是可以理解的。然而，最大的挑战是找到一个简单易用的工具去处理类似的架构。

如果你 Google “monorepo tool javascript”，你会找到许多文章描述我们现有最流行的选项，每个都尝试使用不同的方式去解决这个问题。

从我们现有的选项，一些已经存在一段时间（像 Lerna），但已经不再持续维护了；一些还没渡过方案（像 Bolt），一些在运行，但只适用于某种特定的项目。

不幸的是，我们没有一个好的工具匹配所有 JavaScript/Typescript 类型的项目和所有团队规模，这是可以理解的。

然而，现在有一个新选项，可能在大多数例子中，对我们有所帮助：**pnpm workspaces**。

但在谈到 pnpm 之前，让我告诉你，我的 monorepo/workspaces 用法，以及我是如何一开始就解决这个问题的。

## 我的博客

在我第一次创建我的博客，我自己做了一个 Next.js 应用，把他放到一个 git 仓库，还推一些脚手架代码在那里。

在此之后，我需要建立一个 CMS（内容管理系统）去存放我的内容。然后，我创建一个 Strapi 应用，把它放到另一个 git 仓库，然后将它推送到另一个 Github 仓库。

然后，我决定 fork 一个叫 `mdx-prism` 的仓库去修复一些小问题和自动化部署。再一次，建立另一个新的包含它的代码的 git 仓库。

我有 3 个 git 仓库，意味着，我有了三个 eslint，prettier，jest，babel，和 typescript 配置，我处理了一阵子。

很快的，我被每个依赖更新（像 TypeScript）感到烦恼；我不得不更新所有仓库（三次 pull 请求）。我学到每个新事物像新的 eslint 规则，我同意，我不得不到里面改三次等等。

我的第一反应是：

> 如果我把所有项目放到一个单独的文件夹和仓库里，创建我的基础配置，然后用它去扩展到每个项目配置里呢？

不幸的是，我无法简单放一些文件在那，扩展，希望它运行，因为实际比那复杂得多。工具需要 module/file 解决方案，我不想在我想要部署的时候，传送到所有的项目里。

在那瞬间，我意识到我需要一个 monorepo 工具去链接，让我的体验更好。

我尝试一些解决方案，最简单构建和运行的方式 Lerna + Yarn Workspaces。

当然，在构建流程中，我有一些感悟，比如理解为什么有些构建失败（不是所有的应用喜欢提升依赖关系），必须适配我的管道，以及如何我如何部署每个项目。尽管如此，我还是管理所有东西，并有个合适的配置。

With the bare minimum setup, I started to create even more small independent modules/apps to re-use, extend and try out new tools without impacting my existing code. That was the moment I saw with my own eyes how amazing it's working a monorepo.

## About Lerna + Yarn Workspaces

Lerna is a high-level monorepo tool that provides abstractions to simultaneously manage a single or multiple apps/packages.

You can run commands (e.g., build, test, lint) for all the projects you control with a single command-line instruction, or if you prefer, you can even filter a specific project with the flag `--scope`.

Yarn Workspaces is a low-level tool that handles the packages installation, creates a symlink between projects, and allocates the modules in root and controlled projects folders.

You can use either Lerna or Yarn Workspaces to manage your repository, but you may have noticed that they are more complementary than exclusionary. In other words, they work really well together.

Even nowadays, this combination is still a good choice, but some "problems" might be highlighted:

* Yarn Workspaces (at least for v1) is no longer receiving new features and improvements (the last update was from 2018);
* Lerna documentation is OK, but you have to figure out a lot of things by yourself;
* Lerna publishing system is not as simple as it seems, especially to generate automated publishes with commit lint;
* You can easily get lost on understanding the commands you have to run or what commands are being run by other commands you invoke;
* Lerna CLI has problems like [you cannot install multiple dependencies at the same time](https://github.com/lerna/lerna/issues/2004);
* Lerna CLI `--scope` is not reliable and hard to understand and use;
* There's a [wizard](https://github.com/webuniverseio/lerna-wizard) to help us with regular tasks, but it seems to be being maintained outside the main repo;
* [Lerna is currently unmaintained](https://github.com/lerna/lerna/issues/2703#issuecomment-744601134);

By the time it was created (in 2015), Lerna had come up to help us with this lack of tooling to manage JS monorepos, and it did amazingly well.

Though because they might not have a dedicated team (or a few people) to work on that, plan the future of the tool, Lerna is slowly dying.

I'm not here to blame creators and maintainers, the open-source world has a lot of problems, but this is a subject for another post.

You're probably now thinking:

> If Lerna is in this stage, what's the option we have now?

## pnpm Introduction

In case you don't know, like **npm** and **Yarn**, **pnpm** is also a package manager tool for JavaScript projects. It does the same job but in a more efficient way.

The biggest deal around **pnpm** was that they solved one problem that **npm** introduced and that **Yarn** copied, which it's the way of installing dependencies.

There are two big problems that **pnpm** comes to solve:

### Disk Space

Let's say you have five projects that have `react@17.0.2` as a dependency.

When you **npm** or **Yarn** install in all projects, each will have its copy of React inside `node_modules`. Considering that React has approximately **6.9kB**, in 5 repositories, we'll have **34.5kB** of the same dependency in your disk.

This example seems too little, but everyone that works with JS knows that sometimes `node_modules` can easily hit gigabytes.

Installing dependencies with **pnpm**, it first downloads it in its own "store" (`~/.pnpm-store`). After downloading it there, it creates a hard link from that module to the node_module in your project.

In the same example as before, **pnpm** will install `react@17.0.2` on its store and, when we install the project dependencies, it'll first check if React at version 17.0.2 is already saved. If so, it creates a hard link (pointing to a file in disk) in the projects `node_modules`.

Now, instead of having five `react@17.0.2` copies (**34.5kB**) in our disk, we'll have a single version (**6.9kB**) on the pnpm store folder and a hard link (which does the same job as a copied file) in every project that uses react in this version.

Consequently, we save a lot of disk space and have much faster installation for new projects that use dependencies we already have installed.

## Phantom dependencies

When we install dependencies with **npm**, it downloads all dependencies and dependencies and puts everything inside `node_modules`. This is what they call the "flat way".

Let's see this in practice. The following `package.json:

```json
{
  "dependencies": {
    "unified": "10.1.0"
  }
}
```

After running `npm install`, will result in the following `node_modules`:

```text
node_modules
├── @types
├── bail
├── extend
├── is-buffer
├── is-plain-obj
├── trough
├── unified
├── unist-util-stringify-position
├── vfile
└── vfile-message
```

Though this approach has been working for years, it can lead to some problems called "phantom dependency".

The only dependency we have declared in our project is `unified`, but we still can import `is-plain-obj` (dependency of unified) in our code:

```js
import ob from "is-plain-obj";

console.log(ob); // [Function: isPlainObject]
```

Because this is possible, our dependencies and the dependencies of our dependencies can also make this mistake and import something from `node_modules` without declaring it as dependency/peerDependency.

Now, let's see how **pnpm** does that.

Using the same `package.json` and running `pnpm install`, we'll have the following `node_modules`:

```text
node_modules
├── .pnpm
├── @types
├── unified -> .pnpm/unified@10.1.0/node_modules/unified
└── .modules.yaml
```

As you can see, the only dependency we have is `unified`, and it's "the one" we have, but... there is this arrow that indicates this module is a symlink.

Let's then inspect what's inside `.pnpm`:

```text
node_modules
├── .pnpm
│ ├── @types+unist@2.0.6
│ ├── bail@2.0.1
│ ├── extend@3.0.2
│ ├── is-buffer@2.0.5
│ ├── is-plain-obj@4.0.0
│ ├── node_modules
│ ├── trough@2.0.2
│ ├── unified@10.1.0
│ ├── unist-util-stringify-position@3.0.0
│ ├── vfile-message@3.0.2
│ ├── vfile@5.2.0
│ └── lock.yaml
├── @types
│ └── unist -> ../.pnpm/@types+unist@2.0.6/node_modules/@types/unist
├── unified -> .pnpm/unified@10.1.0/node_modules/unified
└── .modules.yaml
```

**pnpm** installs every dependency with its version as suffix inside the `.pnpm` folder and only moves to the `node_modules` root what's actually defined in your package.json.

Now, if we try to do the same code as before, we'll get an error because `is-plain-obj` is not inside `node_modules`:

```
internal/process/esm_loader.js:74
 internalBinding('errors').triggerUncaughtException(
 ^

Error [ERR_MODULE_NOT_FOUND]: Cannot find package 'is-plain-obj' imported from /Users/raulmelo/development/sandbox/test-pnpm-npm/pnpm/index.js
```

Although installing `node_modules` in this way is more reliable, this may break compatibility with some apps that may have been built on top of the flat `node_modules`.

> An example of it is Strapi v3. As you can see [here](https://github.com/strapi/strapi/issues/9604), they are aware about that and will fix some day.

For our luck, **pnpm** took those cases into account and provided a flag called [`shamefully-hoist`](https://pnpm.io/npmrc#shamefully-hoist).

The dependencies will be installed in the "flat way" when we use this flag, and apps like Strapi will just work.

## pnpm Workspaces

**pnpm** introduced workspaces feature on v2.

Its goal was to fill this gap of the easy-to-use and well-maintained monorepo tool we currently have.

Since they already had the low-level part (package manager), they only added a new module to handle workspaces whenever you have a `pnpm-workspace.yaml` file in the root level of your project.

It's almost the exact config as Lerna + Yarn Workspaces with the three significant advantages:

1. We grasp from **pnpm** disk space fix;
2. We use their nifty CLI (it's well-built and has an excellent DX);
3. It solves many Lerna CLI problems like filtering, installing multiple versions.

In (almost) all commands, **pnpm** allow us to run with a flag called `--filter`. I think it's self-explanatory, but it runs that command for the filtered repositories.

So imagine you have two full apps which have two separated pipelines. With Lerna + **npm** or **Yarn**, we install dependencies for every single project when we run an installation.

This means, in some cases, downloading 1GB of dependencies instead of 300MB.

With **pnpm** though, I can simply run:

```bash
pnpm install --filter website
```

And now, only the root dependencies and the dependencies from my website will be installed.

The filter command is already good enough, but it goes beyond and offers much more flexibility.

I do recommend you to take a look at [pnpm's "Filtering" documentation](https://pnpm.io/filtering) and take a look at how amazing it's.

> Another recommendation: ["pnpm vs Lerna: filtering in a multi-package repository"](https://medium.com/pnpm/pnpm-vs-lerna-filtering-in-a-multi-package-repository-1f68bc644d6a)

It seems a minimal thing, but those little details make a lot of difference while working in different environments.

## Migration

If you want to see the PR I've merged containing the whole migration, you can check it [here](https://github.com/raulfdm/raulmelo-studio/pull/803). I'll only highlight the overall changes I needed to perform.

### Replacing Commands

I had a bunch of scripts that invoke `yarn` CLI. For those, I only need to replace with `pnpm <command>` or `pnpm run <command>`;

### Removing Yarn Workspace config

In my package.json, I had declared the workspaces field for Yarn and also defined some packages not to hoist to root node_modules:

```json
{
"workspaces": {
   "packages": [
     "packages/*",
     "apps/*"
   ],
   "nohoist": [
     "**/netlify-lambda",
     "**/netlify-lambda/**"
   ]
 }
}
```

All this was gone.

### Replacing `lerna.json` with `pnpm-workspace.yml`

I've removed the following config:

```json
{
  "version": "independent",
  "packages": ["packages/*", "apps/*"],
  "npmClient": "yarn",
  "useWorkspaces": true,
  "command": {
    "version": {
      "allowBranch": "main"
    },
    "publish": {
      "conventionalCommits": true,
      "message": "chore(release): publish",
      "ignoreChanges": ["*.md", "!packages/**/*"]
    }
  }
}
```

With:

```yml
prefer-workspace-packages: true
packages:
  - 'packages/*'
  - 'apps/*'
```

### Adapting pipelines, Dockerfile, and Host platform

One thing I had to change was to make sure I always install `pnpm` before installing the dependencies in my Github Actions, Docker image, and Vercel's install script:

```bash
npm install -g pnpm && pnpm install --filter <project-name>
```

It's an essential step because most of the environment contains yarn out-of-the-box but not pnpm (I hope this will change soon).

### Remove `yarn.lock` file

This file is no longer needed. Pnpm creates its own `pnpm-lock.yaml` lock file to control the dependencies version.

### Adapt build command

When I run `lerna run build` for my website, it automatically understands that it also has to build the packages my website uses.

With **pnpm**, I have to make this explicit:

```bash
pnpm run build --filter website # Only build the website

pnpm run build --filter website... # Builds first all dependencies from the website and only then, the website
```

This is important because not all packages I publish to NPM.

### Add a `.npmrc`

pnpm accepts a bunch of flags and options via CLI. If we don't want to pass them all the time, we can define all of them inside a `.npmrc` file.

The only option I added there was:

```bash
shamefully-hoist=true
```

As I explained before, Strapi doesn't work with pnpm's way of installing node_modules which is ashamed.

By committing this file, I ensure that the dependencies are correctly installed everywhere I run `pnpm install`.

### Replacing semantic-release with Changesets

I have to confess that I haven't fully tested this yet.

To summarize, in my previous setup, I was forced to write commits in a specific way so that semantic release could checkout my changes, understand automatically what has changed by reading the messages, bump a version and publish my package.

It was working fine, but some gotchas, especially considering how the Github Actions environment works.

Though, Pnpm recommends we use [changesets from Atlassian](https://pnpm.io/using-changesets).

The approach is a bit different. Now, if I do a change, I have to create a .md file with some meta info and description and changesets will, based on this file, understand how to generate change longs and which version should be bumped.

I still have to finish this setup and maybe write an article about that. 😅

## Conclusion

And that's was basically all I needed to replace Lerna + Yarn Workspaces with **pnpm** workspaces.

To be honest, it was easier than I initially thought.

The more I use **pnpm**, the more I enjoy it. The project is solid, and the user experience is joyful.

## References

* [https://pnpm.io](https://pnpm.io)
* [https://github.com/lerna/lerna](https://github.com/lerna/lerna)
* [https://classic.yarnpkg.com/lang/en/docs/workspaces/](https://classic.yarnpkg.com/lang/en/docs/workspaces/)
* [https://medium.com/pnpm/pnpm-vs-lerna-filtering-in-a-multi-package-repository-1f68bc644d6a](https://medium.com/pnpm/pnpm-vs-lerna-filtering-in-a-multi-package-repository-1f68bc644d6a)
* [https://github.com/raulfdm/raulmelo-studio/pull/803/files](https://github.com/raulfdm/raulmelo-studio/pull/803/files)
* [https://medium.com/@307/hard-links-and-symbolic-links-a-comparison-7f2b56864cdd](https://medium.com/@307/hard-links-and-symbolic-links-a-comparison-7f2b56864cdd)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
