> * 原文地址：[Ensure JavaScript Code Quality with Husky and Hooks](https://blog.bitsrc.io/ensure-javascript-code-quality-with-husky-and-hooks-6e338222662)
> * 原文作者：[Viduni Wickramarachchi](https://medium.com/@viduniwickramarachchi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/ensure-javascript-code-quality-with-husky-and-hooks.md](https://github.com/xitu/gold-miner/blob/master/article/2021/ensure-javascript-code-quality-with-husky-and-hooks.md)
> * 译者：
> * 校对者：

# Ensure JavaScript Code Quality with Husky and Hooks

## Enforce JavaScript Code Quality with Husky and Hooks

#### Building a robust eco-system to enforce code quality with JavaScript

![](https://cdn-images-1.medium.com/max/5760/1*HZ5lACmwUy-Zo8jTzWEmZw.jpeg)

Ensuring code quality is very important for a maintainable and scalable application. But how can we enforce these quality standards?

Well, with JavaScript, you can use ESLint to define coding conventions and use Prettier for consistent code formatting. If you have these two configured, the first step is complete.

Now that we have standards in place, how do we enforce them? This is where Husky comes to play. Husky is used to enforcing standards in Git-based projects. It acts similarly to how [Bit](https://bit.dev) enforces standards on [independent components](https://blog.bitsrc.io/independent-components-the-webs-new-building-blocks-59c893ef0f65) before they are tagged with a new release version, end exported to various remote scopes (more on that, later).

## What are Hooks?

When you initialize a project with Git (`git init` ), it automatically comes with a feature called Hooks. You can view these in`[projectPath]/.git/hooks` .

There are many Git Hooks. Some of them are as follows.

* `pre-commit` — The hook that is used to ensure that all coding standards are enforced before a commit is made. This will run when you make the `git commit` command.
* `pre-push` — Ensures coding rules are met before pushing to a remote repository.
* `pre-rebase` — Similar to the above, this enforces the rules before a rebase is done.

All the Hooks available and their usages can be found [here](https://git-scm.com/docs/githooks).

However, writing these Hooks manually and ensuring that all developers have them on their machines is a cumbersome process. This is where Husky comes into play.

## What is Husky?

Husky automates the process of adding Hooks. When the project dependencies are installed, Husky will make sure that all Hooks will be installed in the developer’s machine locally for that particular project based on the configs in the `package.json` . This makes it very easy to manage and distribute Hooks as no manual invention is required.

With Husky, the following happens.

* Hooks get created locally.
* Hooks are run when the relevant Git command is called.
* The policy that defines how someone can contribute to a project is enforced.

#### Setting up Husky in practice

You can install Husky using the following command.

`npm install husky --save-dev`

Configuring Husky is very easy. This can be added to the `package.json` .

```
"husky": {
  "hooks": {
    "pre-commit": "",  // pre-commit command goes here
    "pre-push": "",    // pre-push command goes here
    "...": "..."
  }
}
```

As such, any hook that you require can be included here.

Let’s look at an example.

If you want to ensure that all the lint rules are met before committing new changes, the following can be done.

```
{
  "scripts": {
    "lint": "eslint . --ext .js",
  },
  "husky": {
    "hooks": {
      "pre-commit": "npm run lint"
     }
  }
}
```

This should be included in the `package.json` . This will ensure that you cannot complete a Git commit without the `esLint` checks being passed.

## More uses of Husky in practice

So far, we have looked at the most basic use of Husky. Are there more things that we can do with this package? Let’s have a look.

1. Husky has the ability to run any command which is combined with other packages. (E.g.: Prettier, Linters such as EsLint, check linting for the files ready to be committed with lint-staged, etc.)
2. Husky has the ability to validate commit messages with the use `commit-msg` similar to `pre-commit` rules.
3. We can use the `pre-commit` command to run all our unit tests and integration tests, which makes sure that we don’t commit any breaking changes.

However, a point to note is that Husky commands can be skipped if you use the `no-verify` flag with your Git command.

#### Supported Hooks

Husky supports all Git Hooks defined [here](https://git-scm.com/docs/githooks). Server-side Hooks (`pre-receive`, `update` and `post-receive`) aren't supported.

## Features of Husky

There are few highlighted features of Husky that I would like to mention.

* Zero dependencies and lightweight (6KB)
* Powered by modern new Git feature (`core.hooksPath`)
* Follows [npm](https://docs.npmjs.com/cli/v7/using-npm/scripts#best-practices) and [Yarn](https://yarnpkg.com/advanced/lifecycle-scripts#a-note-about-postinstall) best practices regarding autoinstall
* User-friendly messages
* Optional install
* Husky 4 supports platforms such as macOS, Linux, and Windows
---

* Further, it supports Git GUIs, Custom directories, Monorepos

## Bonus: Enforcing a single standard on independent components

[Independent components](https://blog.bitsrc.io/independent-components-the-webs-new-building-blocks-59c893ef0f65) are developed and versioned in [Bit](https://bit.dev) workspaces. They are each independently developed, versioned, and collaborated on. They enable easy cross-project collaboration on components with a CI that propagates from a single modified component to all its direct and indirect dependent components.

![](https://cdn-images-1.medium.com/max/4000/0*qVFxXWEqek5dPCbq.png)

![[An independent ‘drop-down’ component](https://bit.dev/learn-harmony/design/dropdown) rendered in isolation. The component’s dependency graph was generated by Bit. It is used for component isolation and to propagate the CI from one component to all its dependents.](https://cdn-images-1.medium.com/max/4000/0*ep8m2QDvWg6d0E-_.png)

There is no single CI for all components. Instead, each independent component uses a CI that is part of the component dev environment. That means, decoupled and separately developed components may use the same CI in different workspaces or remote scopes.

When using Bit, the CI runs before a component is tagged with a new release version.

![[Bit.dev’](https://bit.dev)s Ripple CI that run on all dependent components, across projects](https://cdn-images-1.medium.com/max/4000/0*j0oHUoCtMz7G0AtQ.jpeg)

---
[**Bit: The platform for the modular web**
**Bit is a standard infrastructure for components. It's everything your teams need to enjoy autonomous development…**bit.dev](https://bit.dev)

## Summary

Using husky and Git Hooks, formatted, lint error-free buildable code can be achieved. This makes enforcing coding conventions very easy and fast.

Alternatively, you could consider tools like [Bit](https://bitdev) to enforce code quality.

From the day I started using Husky in my projects (small-scale or enterprise), coding life has gotten easier.

## Learn More
[**Building a React Component Library — The Right Way**
**Create an ultra-modular component library: Scalable, Maintainable, and with a Blazing-fast setup.**blog.bitsrc.io](https://blog.bitsrc.io/building-a-react-component-library-d92a2da8eab9)
[**Independent Components: The Web’s New Building Blocks**
**Why everything you know about microservices, micro frontends, monorepos, and even plain old component libraries, is…**blog.bitsrc.io](https://blog.bitsrc.io/independent-components-the-webs-new-building-blocks-59c893ef0f65)
[**Building a React Design System for Adoption and Scale**
**Achieve DS scale and adoption via independent components and a composable architecture — with examples.**blog.bitsrc.io](https://blog.bitsrc.io/building-a-react-design-system-for-adoption-and-scale-1d34538619d1)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
