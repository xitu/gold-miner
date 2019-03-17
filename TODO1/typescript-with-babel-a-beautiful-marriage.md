> * 原文地址：[TypeScript With Babel: A Beautiful Marriage](https://iamturns.com/typescript-babel/)
> * 原文作者：[Matt Turnbull](https://iamturns.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/typescript-with-babel-a-beautiful-marriage.md](https://github.com/xitu/gold-miner/blob/master/TODO1/typescript-with-babel-a-beautiful-marriage.md)
> * 译者：[zsky](https://github.com/zsky)
> * 校对者：[xionglong58](https://github.com/xionglong58), [brilliantGuo](https://github.com/brilliantGuo)

# TypeScript 和 Babel：美丽的结合

![Babel and TypeScript](https://iamturns.com/static/babel-typescript-36d1d3a0edfdd9f9391a86a4503c75a2-bea90.png)

由于 TypeScript 和 Babel 团队官方合作了一年的项目：[TypeScript plugin for Babel](https://babeljs.io/docs/en/babel-preset-typescript.html)（`@babel/preset-typescript`），[TypeScript](https://www.typescriptlang.org/) 的使用变得比以往任何时候都容易。这篇文章会告诉你为何 TypeScript 和 Babel 是完美配对的 4 点原因，并会教你在 10 分钟内一步步地升级到 TypeScript。

## 哈？什么？为什么？

我一开始并不理解这个 preset 的必要性。

Babel 和 TypeScript 不是两个完全不一样的东西么？Babel 能怎么处理 TypeScript 的类型检查？TypeScript 早已能像 Babel 一样输出 ES5 代码，这有什么意义呢？把 Babel 和 TypeScript 合并起来不是会把事情复杂化么？

在几个小时的调研后，我的结论是：

**TypeScript 和 Babel 是美丽的结合。**

让我来告诉你原因。

## 1）你早已使用 Babel（或者应该如此）

你属于这三个类别之一：

1. 你早已使用 Babel。如果不是直接使用，你的 Webpack 配置会把 `*.js` 文件提供给 Babel（大多数脚手架都是这种情况，包括  [create-react-app](https://github.com/facebook/create-react-app)）
2. 使用了 TypeScript，**却没有用** Babel。针对这种情况，你可以考虑把 Babel 加入你的武器库中，因为它提供了许多独特的功能。继续阅读，你会了解更多！
3. 你不使用 Babel？是时候开始用了。

### 编写现代 JavaScript 而不破坏任何东西

你的 JavaScript 代码需要在旧浏览器中运行？没问题，Babel 会转换代码，而且不会出现任何问题。使用最新和最好的功能，无需担心。

TypeScript 编译器具有类似的功能，可通过将 `target` 设置为 `ES5` 或 `ES6` 来实现。但 Babel 配置通过 [babel-preset-env](https://babeljs.io/docs/en/babel-preset-env/) 改进了这方面功能。你可以列出需要支持的环境，而不是锁定一组特定的 JavaScript 功能（ES5，ES6 等）：

```json
"targets": {
  "browsers": ["last 2 versions", "safari >= 7"],
  "node": "6.10"
}
```

Babel 使用 [compat-table](https://kangax.github.io/compat-table/) 来检查要转换的 JavaScript 功能以及针对这些特定目标环境做 polyfill。

![compat-table](https://iamturns.com/static/compat-table-4011bf23893b052a3c08c9a89da0548e-bea90.png)

花点时间欣赏那个将这个项目命名为 ‘[compat-table](https://kangax.github.io/compat-table/)’ 的天才。

[create-react-app](https://github.com/facebook/create-react-app/blob/96ba7bddc1600d6f5dac9da2418ee69793c22eca/packages/react-scripts/package.json#L82-L94) 使用了一种有趣的技术：在开发期间以最新的浏览器进行编译（为了速度），并在生产中以更大范围的浏览器进行编译（为了兼容性）。漂亮。

### Babel 是超级可配置的

想要 JSX？ Flow？TypeScript？只需安装一个插件，Babel 就可以处理它。有大量的 [官方插件](https://babeljs.io/docs/en/plugins)，主要涵盖即将推出的 JavaScript 语法。 还有很多第三方插件：[improve lodash imports](https://github.com/lodash/babel-plugin-lodash)，[enhance console.log](https://github.com/mattphillips/babel-plugin-console)，或 [strip console.log](https://github.com/betaorbust/babel-plugin-groundskeeper-willie)。在 [awesome-babel](https://github.com/babel/awesome-babel) 列表中找到更多信息。

不过要小心。如果插件显著改变了语法，那么 TypeScript 可能无法解析它。例如，备受期待的 [optional chaining proposal](https://github.com/tc39/proposal-optional-chaining) 提议有一个 Babel 插件：

![Optional chaining](https://iamturns.com/static/optional-chaining-4e8453e2d02f36a6771957310609d1c5-605fa.png)

[@babel/plugin-proposal-optional-chaining](https://babeljs.io/docs/en/babel-plugin-proposal-optional-chaining.html)

但不幸的是，TypeScript 无法理解这种更新的语法。

不要紧张，有另一种选择...

### Babel 宏

你知道 [Kent C Dodds](https://twitter.com/kentcdodds) 吗？他创造了一个改变游戏规则的 Babel 插件：[babel-plugin-macros](https://github.com/kentcdodds/babel-plugin-macros)。

你可以将宏安装为依赖项并将其导入代码中，而不是将插件添加到 Babel 配置文件中。当 Babel 正在编译时，宏会启动，并根据需要修改代码。

来看一个例子。 它使用 [idx.macro](https://www.npmjs.com/package/idx.macro) 来解决痛点，直到 [optional chaining proposal](https://github.com/tc39/proposal-optional-chaining) 提议通过：

```js
import idx from 'idx.macro';

const friends = idx(
  props,
  _ => _.user.friends[0].friends
);
```

编译为：

```js
const friends =
  props.user == null ? props.user :
  props.user.friends == null ? props.user.friends :
  props.user.friends[0] == null ? props.user.friends[0] :
  props.user.friends[0].friends
```

宏是相当新的，但很快就越来越受欢迎。特别是集成在 [create-react-app v2.0](https://reactjs.org/blog/2018/10/01/create-react-app-v2.html) 后。 CSS in JS 被覆盖：[styled-jsx](https://www.npmjs.com/package/styled-jsx#using-resolve-as-a-babel-macro)、[styled-components](https://www.styled-components.com/docs/tooling#babel-macro) 和 [emotion](https://emotion.sh/docs/babel-plugin-emotion#babel-macros)。Webpack 插件在被移植中：[raw-loader](https://github.com/pveyes/raw.macro)、[url-loader](https://github.com/Andarist/data-uri.macro) 和 [filesize-loader](https://www.npmjs.com/package/filesize.macro)。还有更多列在 [awesome-babel-macros](https://github.com/jgierer12/awesome-babel-macros)。

这是最好的部分：与 Babel 插件不同，**所有** Babel 宏都与 TypeScript 兼容。它们还可以帮助减少运行时依赖，避免一些客户端计算，并在构建时提前捕获错误。 查看 [此帖子](https://babeljs.io/blog/2017/09/11/zero-config-with-babel-macros) 了解更多详情。

![Improved console.log](https://iamturns.com/static/console.72e0a8b3.gif)

更好的 console.log：[scope.macro](https://github.com/mattphillips/babel-plugin-console#macros)

## 2）管理一个编译器更容易

TypeScript 需要它自己的编译器 — 它提供了惊人的类型检查超能力。

### 令人沮丧的日子（在 Babel 7 之前）

将两个独立的编译器（TypeScript 和 Babel）链接在一起并非易事。编译流程变为：`TS > TS Compiler > JS > Babel > JS (again)`。

Webpack 经常用于解决这个问题。调整 Webpack 配置以将 `*.ts` 提供给 TypeScript，然后将结果提供给 Babel。但是你使用哪种 TypeScript loader？两个流行的选择是 [ts-loader](https://github.com/TypeStrong/ts-loader) 和 [awesome-typescript-loader](https://github.com/s-panferov/awesome-typescript-loader)。[awesome-typescript-loader](https://github.com/s-panferov/awesome-typescript-loader) 的 `README.md` 提到它对一些工作负载来说可能更慢，并建议使用 [ts-loader](https://github.com/TypeStrong/ts-loader) 加上 [HappyPack](https://github.com/amireh/happypack) 或 [thread-loader](https://webpack.js.org/loaders/thread-loader/)。[ts-loader](https://github.com/TypeStrong/ts-loader) 的 `README.md` 推荐结合 [fork-ts-checker-webpack-plugin](https://github.com/Realytics/fork-ts-checker-webpack-plugin)，[HappyPack](https://github.com/amireh/happypack)，[thread-loader](https://github.com/webpack-contrib/thread-loader)，和（或）[cache-loader](https://github.com/webpack-contrib/cache-loader)。

啊。不。这是大多数人不堪重负的地方，并把 TypeScript 放在“太难”的篮子里。我不怪他们。

![One does not simply configure TypeScript](https://iamturns.com/static/simply-configure-typescript-1933ffec04eb2221fd05695a070016a5-27dc3.jpg)

### 阳光灿烂的日子（有了 Babel 7）

拥有**一个** JavaScript 编译器不是很好吗？无论你的代码是否具有 ES2015、JSX、TypeScript 或疯狂的自定义功能 - 编译器都知道该怎么做。

我只是描述了 Babel。厚脸皮了。

通过允许 Babel 充当单个编译器，不需要使用一些复杂的 Webpack 魔术来管理，配置或合并两个编译器。

它还简化了整个 JavaScript 生态系统。他们只需要支持 Babel，而不是支持不同编译器的语法检查、测试运行器、构建系统和脚手架。然后，配置 Babel 以满足你的特定需求。告别 [ts-node](https://github.com/TypeStrong/ts-node)、[ts-jest](https://github.com/kulshekhar/ts-jest)、[ts-karma](https://github.com/monounity/karma-typescript) 和 [create-react-app-typescript](https://github.com/wmonk/create-react-app-typescript) 等，并使用 Babel 支持代替。对 Babel 的支持无处不在，请查看 [Babel 设置](https://babeljs.io/en/setup) 页面：

![Babel and TypeScript](https://iamturns.com/static/babel-support-83d89cdf00af707da859a373ff56dbf5-b1cd8.png)

[Babel 覆盖你的需求。](https://babeljs.io/en/setup)

## 3）编译速度更快

警告！有一个震惊的消息，你可能想坐下来好好听下。

Babel 如何处理 TypeScript 代码？**它删除它**。

是的，它删除了所有 TypeScript，将其转换为“常规的” JavaScript，并继续以它自己的方式愉快处理。

这听起来很荒谬，但这种方法有两个很大的优势。

第一个优势：️⚡️**闪电般快速**⚡️。

大多数 Typescript 开发人员在开发/监视模式下经历过编译时间长的问题。你正在编写代码，保存一个文件，然后...它来了...再然后...**最后**，你看到了你的变更。哎呀，错了一个字，修复，保存，然后...啊。它**只是**慢得令人烦恼并打消你的势头。

很难去指责 TypeScript 编译器，它在做很多工作。它在扫描那些包括 `node_modules` 在内的类型定义文件（`*.d.ts`），并确保你的代码正确使用。这就是为什么许多人将 Typescript 类型检查分到一个单独的进程。然而，Babel + TypeScript 组合仍然提供更快的编译，这要归功于 Babel 的高级缓存和单文件发射架构。

因此，如果 Babel 剥离掉 TypeScript 代码，那么编写 TypeScript 有什么意义呢？这带来了第二个优势...

## 4）只有在准备好后才检查类型错误

你为了快速做出一个解决方案来看看你的想法是否有根据，会把一些代码改到一起。当你按下保存按钮的时候，TypeScript 向你尖叫：

> “不！我不会编译这个！你的代码在 42 个不同的文件中有问题！”

是的，你**知道**它已经不能运行了。你可能也破坏了一些单元测试。但是你只是在这一点上进行实验。要在**所有**时间持续确保**所有**代码是类型安全的，这一点让人火大。

这是 Babel 在编译期间剥离 TypeScript 代码的第二个优点。你编写代码，保存，并且编译（非常快）**而不**检查类型安全性。继续尝试解决方案，直到你准备好检查代码是否有错误。这种工作流程可让你在编码时保持专注。

那么如何检查类型错误？添加一个调用 TypeScript 编译器的 `npm run check-types` 脚本。我将我的 `npm test` 命令调整为首先检查类型，然后继续运行单元测试。

## 这不是完美的结合

根据 [公告文章](https://blogs.msdn.microsoft.com/typescript/2018/08/27/typescript-and-babel-7/)，有四种 TypeScript 功能由于其单文件发射架构而无法在 Babel 中编译。

别担心，它没有那么糟糕。当启用 `isolatedModules` 标志时，TypeScript 将对这些问题发出警告。

**1）命名空间。**

解决方案：不要使用它们！他们已经过时了。请改用行业标准 ES6 模块（`import` / `export`）。[推荐 tslint 规则](https://github.com/palantir/tslint/blob/21358296ad11a857918b45e6a9cc628290dc3f96/src/configs/recommended.ts#L89) 确保命名空间**不**被使用。

**2）使用**`<newtype>x` **语法转换类型。**

解决方案：使用 `x as newtype`。

**3）[Const 枚举](https://www.typescriptlang.org/docs/handbook/enums.html#const-enums)。**

这很羞愧。现在需要使用常规枚举。

**4）传统风格的 import / export 语法。**

示例：`import foo = require(...)` 和 `export = foo`。

在我多年 TypeScript 的使用中，我从未遇到过这种情况。谁这样编码？停下来！

## 好的，我准备尝试使用 Babel 和 TypeScript！

![Yeah!](https://iamturns.com/static/yeah-6e69b732a6647969c78b6249f42ca636-f6c13.jpg)

由 [rawpixel.com](https://www.rawpixel.com/image/384992/yeah-text-paper-and-colorful-party-confetti-background-party-concept) 拍摄

我们开工吧！它应该只需要大约 10 分钟。

我假设你设置了 Babel 7。如果没有，请参阅 [Babel 迁移指南](https://babeljs.io/docs/en/v7-migration.html)。

**1）将 .js 文件重命名为 .ts**

假设你的文件位于 `/src` 中：

```bash
find src -name "*.js" -exec sh -c 'mv "$0" "${0%.js}.ts"' {} ;
```

**2）将 TypeScript 添加到 Babel。**

安装一些依赖：

```bash
npm install --save-dev @babel/preset-typescript @babel/plugin-proposal-class-properties @babel/plugin-proposal-object-rest-spread
```

在你的 Babel 配置文件里（`.babelrc` 或 `babel.config.js`）添加：

```json
{
  "presets": [
    "@babel/typescript"
  ],
  "plugins": [
    "@babel/proposal-class-properties",
    "@babel/proposal-object-rest-spread"
  ]
}
```

TypeScript 有一些 Babel 需要了解的额外功能（通过上面列出的两个插件）。

Babel 默认查找 .js 文件，遗憾的是，这在 Babel 配置文件中是不可配置的。

如果你使用 Babel CLI，添加 `--extensions '.ts'`

如果你使用 Webpack，添加 `'ts'` 到 `resolve.extensions` 数组。

**3）添加 “check-types” 命令。**

在 `package.json` 里添加：

```json
"scripts": {
  "check-types": "tsc"
}
```

这个命令只是简单地调用 TypeScript 编译器（`tsc`）。

`tsc` 来自哪里？我们需要安装 TypeScript：

```bash
npm install --save-dev typescript
```

为了配置 TypeScript（和 `tsc`），我们需要在根目录下有 `tsconfig.json` 文件：

```
{
  "compilerOptions": {
    // Target latest version of ECMAScript.
    "target": "esnext",
    // Search under node_modules for non-relative imports.
    "moduleResolution": "node",
    // Process & infer types from .js files.
    "allowJs": true,
    // Don't emit; allow Babel to transform files.
    "noEmit": true,
    // Enable strictest settings like strictNullChecks & noImplicitAny.
    "strict": true,
    // Disallow features that require cross-file information for emit.
    "isolatedModules": true,
    // Import non-ES modules as default imports.
    "esModuleInterop": true
  },
  "include": [
    "src"
  ]
}
```

**完成。**

好了，**设置**完成了。现在运行 `npm run check-types`（监听模式：`npm run check-types -- --watch`）并确保 TypeScript 对你的代码满意。你可能会发现一些你不知道但却存在的错误。这是件好事！这份 [从 Javascript 迁移](https://www.typescriptlang.org/docs/handbook/migrating-from-javascript.html) 指南也会给你一些帮助。

Microsoft 的 [TypeScript-Babel-Starter](https://github.com/Microsoft/TypeScript-Babel-Starter) 指南包含其他设置说明，包括从头开始安装 Babel，生成类型定义（d.ts）文件，以及将其与 React 一起使用。

## 关于语法检查呢？

使用 [tslint](https://palantir.github.io/tslint/)。

**更新**（2019 年 2 月）：使用 ESlint！自1月份以来，TypeScript 团队一直 [专注于 ESLint 集成](https://github.com/Microsoft/TypeScript/issues/29288)。由于 [@typesript-eslint](https://github.com/typescript-eslint/typescript-eslint) 项目，很容易配置 ESLint。如需参考，请查看我的 [超级 ESLint 配置](https://github.com/iamturns/create-exposed-app/blob/master/.eslintrc.js)，其中包括 TypeScript、Airbnb、Prettier 和 React。

## Babel + TypeScript = 美丽的结合

![Love hearts](https://iamturns.com/static/love-6816a7c4005415586f0da1a9fea5407b-f6c13.jpg)

由 [Akshar Dave](https://unsplash.com/photos/1GRvY9WUu08) 拍摄

Babel 是你需要的唯一一个 JavaScript 编译器。它可以被配置去处理任何事情。

没有必要与两个相互竞争的 JavaScript 编译器斗争。简化你的项目配置，并充分利用 Babel 与语法检查、测试运行器、构建系统和脚手架的惊人集成。

Babel 和 TypeScript 组合可以快速编译，并允许你专注地编码，只有在你准备好时才检查类型。

## 预测：TypeScript 使用将会上升

根据最新的 [Stack Overflow 开发者调查](https://insights.stackoverflow.com/survey/2018/#technology-programming-scripting-and-markup-languages)，JavaScript 是最流行的语言，TypeScript 排在第 12 位。 对于TypeScript 来说，这仍然是一项伟大的成就，击败了 Ruby、Swift 和 Go。

![Developer survey results](https://iamturns.com/static/dev-survey-7e7416c3e24796eb8de66d34164a8777-aef05.png)

我预测 TypeScript 将在明年进入前 10 名。

TypeScript 团队正在努力推广。这个 Babel preset 是为期一年的合作，他们的新焦点是在 [改进 ESLint 集成](https://github.com/Microsoft/TypeScript/issues/29288)。这是一个聪明的举措 — 利用现有工具的功能、社区和插件。开发有竞争力的编译器和语法检查是浪费精力。

通往 TypeScript 的路径已经被铺平了，我们只需调整我们喜爱的工具配置即可。进入的障碍已被打破。

随着 [VS Code](https://code.visualstudio.com/) 的普及，开发人员已经设置了一个很棒的 TypeScript 环境。写代码时的自动补全将带来欢乐的泪水。

它现在也集成到 [create-react-app v2.0](https://reactjs.org/blog/2018/10/01/create-react-app-v2.html) 中，将 TypeScript 展现给每月有 20 万次下载的用户。

如果你因为设置太难而推迟使用 TypeScript，这不再是一个借口。是时候试一试了。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
