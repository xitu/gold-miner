> * 原文地址：[Code Coverage for Vue Applications](https://vuejsdevelopers.com/2020/07/20/code-coverage-vue-cypress/)
> * 原文作者：[Gleb Bahmutov]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/code-coverage-vue-cypress.md](https://github.com/xitu/gold-miner/blob/master/article/2020/code-coverage-vue-cypress.md)
> * 译者：[tonylua](https://github.com/tonylua)
> * 校对者：[FateZeros](https://github.com/FateZeros)

# Vue 应用的代码覆盖率

![](https://vuejsdevelopers.com/images/posts/versions/code_coverage_1200.webp)

让我们像 [bahmutov/vue-calculator](https://github.com/bahmutov/vue-calculator) 应用一样，借助 [Vue CLI](https://cli.vuejs.org/) 来搭建一个 Vue 应用脚手架。在本文中，我将展示如何检测应用的源代码以收集其代码覆盖率信息。其后我们将利用该代码覆盖率报告来引导端到端测试的编写。

## 应用

示例应用可在 [bahmutov/vue-calculator](https://github.com/bahmutov/vue-calculator) 仓库中找到，该仓库 fork 自使用 Vue CLI 默认模版构建的 [kylbutlr/vue-calculator](https://github.com/kylbutlr/vue-calculator) 项目。其代码使用如下 `babel.config.js`  文件转译：

```js
// babel.config.js
module.exports = {
  presets: [
    '@vue/app'
  ]
}
```

当我们用 `npm run serve` 启动应用时，其实是执行了这条 NPM script

```json
{
  "scripts": {
    "serve": "vue-cli-service serve"
  }
}
```

应用默认运行在 8080 端口上。

![Vue 计算器应用](https://vuejsdevelopers.com/images/posts/code_coverage/calculator.png)

搞定！你可以计算任何想要的东西了。

## 检测源代码

我们可以通过向导出的 Babel 配置文件中添加 `plugins` 列表来检测应用代码。该插件列表应包含 [babel-plugin-istanbul](https://github.com/istanbuljs/babel-plugin-istanbul) 。

```js
// babel.config.js
module.exports = {
  presets: [
    '@vue/app'
  ],
  plugins: [
    'babel-plugin-istanbul'
  ]
}
```

现在，当应用运行时，我们应该能找到 `window.__coverage__` 对象，该对象包含了每条语句、每个函数，及每个文件的每一个分支的各种计数。

![应用覆盖率对象](https://vuejsdevelopers.com/images/posts/code_coverage/coverage.png)

不过上面展示的覆盖率对象，仅包含了单一条目 `src/main.js`，却缺失了 `src/App.vue` 和 `src/components/Calculator.vue` 两个文件。

让我们来告诉 `babel-plugin-istanbul` 我们想要同时检测 `.js` 和 `.vue` 文件吧。

```js
// babel.config.js
module.exports = {
  presets: [
    '@vue/app'
  ],
  plugins: [
    ['babel-plugin-istanbul', {
      extension: ['.js', '.vue']
    }]
  ]
}
```

**提示：** 我们可以将 `istanbul` 设置放在一个单独的 `.nycrc` 文件中（译注：[nyc](https://github.com/istanbuljs/nyc) ，Istanbul 提供的命令行接口工具），或将它们添加到 `package.json`。目前而言，还是先将这些设置一起保留在插件列表本身中吧。

当我们重启应用后，得到了一个包含 `.js` 和 `.vue` 文件条目的新 `window.__coverage__` 对象。

![被检测的 JS 和 Vue 文件](https://vuejsdevelopers.com/images/posts/code_coverage/vue-covered.png)

## 条件性检测

如果你观察应用的打包代码，就会看到测量所做的事情。其围绕每条语句都插入了计数器，用以保持跟踪一条语句被执行了多少次。对于每一个函数和每一个分支路径，也有单独的计数器。

![被检测的源代码](https://vuejsdevelopers.com/images/posts/code_coverage/instrumented.png)

我们并不想测量生产环境代码。应仅在 `NODE_ENV=test` 时测量代码，好利用收集到的代码覆盖率帮助我们编写更好的测试。

```js
// babel.config.js
const plugins = []
if (process.env.NODE_ENV === 'test') {
  plugins.push([
    "babel-plugin-istanbul", {
      // 在此为 NYC 测量工具指定一些选项
      // 如告知其同时测量 JavaScript 和 Vue 文件
      extension: ['.js', '.vue'],
    }
  ])
}
module.exports = {
  presets: [
    '@vue/app'
  ],
  plugins
}
```

可以通过设置环境变量启动带测量的应用。

```shell
$ NODE_ENV=test npm run serve
```

**提示：** 对于跨平台可移植性，可使用 [cross-env](https://github.com/kentcdodds/cross-env) 工具设置一个环境变量。

## 端到端测试

现在我们测量了源代码，使用其引导编写测试吧。我将用官方的 Vue CLI 插件 [@vue/cli-plugin-e2e-cypress](https://cli.vuejs.org/core-plugins/e2e-cypress.html) 安装 Cypress Test Runner。而后我将安装 [Cypress 代码覆盖率插件](https://github.com/cypress-io/code-coverage) 以在测试运行结束时将覆盖率对象转换为人和机器皆可读的报告。

```shell
$ vue add e2e-cypress
$ npm i -D @cypress/code-coverage
+ @cypress/code-coverage@3.8.1
```

[@vue/cli-plugin-e2e-cypress](https://cli.vuejs.org/core-plugins/e2e-cypress.html) 已经创建了 `tests/e2e` 文件夹，在其 support 和 plugins 子目录的文件中都可以加载代码覆盖率插件。

```js
// 文件 tests/e2e/support/index.js
import '@cypress/code-coverage/support'

// 文件 tests/e2e/plugins/index.js
module.exports = (on, config) => {
  require('@cypress/code-coverage/task')(on, config)
  // 重要：须返回包含任何改变过的环境变量的配置对象
  return config
}
```

让我们为被 [@vue/cli-plugin-e2e-cypress](https://cli.vuejs.org/core-plugins/e2e-cypress.html) 插入到 `package.json` 中的 NPM script 命令 `test:e2e`  设置环境变量 `NODE_ENV=test` 。
```json
{
  "scripts": {
    "serve": "vue-cli-service serve",
    "build": "vue-cli-service build",
    "test:e2e": "NODE_ENV=test vue-cli-service test:e2e"
  }
}
```

可将我们的首个端到端规格文件置于 `tests/e2e/integration` 文件夹：

```js
/// <reference types="cypress" />
describe('Calculator', () => {
  beforeEach(() => {
    cy.visit('/')
  })
  it('computes', () => {
    cy.contains('.button', 2).click()
    cy.contains('.button', 3).click()
    cy.contains('.operator', '+').click()
    cy.contains('.button', 1).click()
    cy.contains('.button', 9).click()
    cy.contains('.operator', '=').click()
    cy.contains('.display', 42)
    cy.log('**division**')
    cy.contains('.operator', '÷').click()
    cy.contains('.button', 2).click()
    cy.contains('.operator', '=').click()
    cy.contains('.display', 21)
  })
})
```

本地运行时，我将使用 `npm run test:e2e` 命令启动应用并打开 Cypress 。以上测试很快通过了。我们的计算器看起来加法除法运行良好。

![计算器测试](https://vuejsdevelopers.com/images/posts/code_coverage/calculator.gif)

正如你能从来自于 Test Runner 命令行日志信息的左侧看到的，测试覆盖率插件在运行结束时自动生成了代码覆盖率报告。报告被存储在 `coverage` 文件夹中，且默认有多种输出格式。

```text
coverage/
  lcov-report/
    index.html         # 人类可读的 HTML 报告
    ...
  clover.xml           # 面向 Clover Jenkins reporter 的覆盖率报告
  coverage-final.json  # 纯 JSON 输出
  lcov.info            # 面向第三方报告服务的行覆盖率
```

在本地运行测试时，我更喜欢打开 HTML 覆盖率报告：

```shell
$ open coverage/lcov-report/index.html
```

`index.html` 是一个展示了每个源代码文件夹覆盖率信息表格的静态页面。

![覆盖率报告](https://vuejsdevelopers.com/images/posts/code_coverage/coverage-report.png)

**提示：** 将整个 `coverage/lcov-report` 文件夹作为一个测试产物存储在你的持续集成（CI - Continuous Integration）服务器上。然后就能在测试运行后浏览或下载报告以查看收集到的代码覆盖率了。

端到端测试是 **有效的**。通过一个加载整个应用并与之交互的单一测试，我们覆盖了近 60% 的源代码。更棒的是，通过点开单独的文件，我们发现了在 `src/components/Calculator.vue` 中那些未曾被测试到的特性。

![Calculator.vue 中已覆盖/未覆盖的行](https://vuejsdevelopers.com/images/posts/code_coverage/covered-lines.png)

源码中高亮为红色的行正是测试中遗漏的。可以看到，虽然我们已经测试了录入数字和除法等，但仍需编写一个测试以覆盖“清除当前数字”、“改变正负号”、“设置小数点”、“乘法”等功能。代码覆盖率因此变为了编写端到端测试的向导；增加测试，直到所有红色标记的行都被干掉为止！

```
  Calculator
    ✓ computes adds and divides (1031ms)
    ✓ multiplies, resets and subtracts (755ms)
    ✓ changes sign (323ms)
    ✓ % operator (246ms)
```

随着编写更多的测试，我们在应用中快速收获了覆盖率和信心。在最后一项测试中我们将覆盖仍保留了红色的 `decimal () { ... }` 方法。

![没有被覆盖到的 Decimal 方法](https://vuejsdevelopers.com/images/posts/code_coverage/decimal.png)

以下测试键入了一个单数位数字并点击了 "." 按钮。显示结果应为 "5." 。

```js
it('decimal', () => {
  cy.contains('.button', '5').click()
  cy.contains('.button', '.').click()
  cy.contains('.display', '5.')
})
```

嘿，怪了，测试失败了。

![Decimal 测试失败](https://vuejsdevelopers.com/images/posts/code_coverage/decimal-fails.png)

Cypress 测试的一个强大之处就在于其运行在真实浏览器中。让我们来调试失败的测试。在 `src/components/Calculator.vue` 放置一个断点。

```js
decimal() {
  debugger
  if (this.display.indexOf(".") === -1) {
    this.append(".");
  }
},
```

打开浏览器的 DevTools 并再次运行测试。测试将运行，直到遇见应用代码中的 `debugger` 关键字。

![调试 decimal 方法](https://vuejsdevelopers.com/images/posts/code_coverage/debugger.png)

噢，`this.display` 是个数字，而非一个字符串。因此 `.indexOf()` 并不存在且 `this.display.indexOf(".")` 表达式抛出了一个错误。

**提示：** 如果想要在任何一次 Vue 捕获错误时都让 Cypress 测试失败，在你的应用代码中做如下设置：

```js
// 从代码覆盖率中排除这些行
/* istanbul ignore next */
if (window.Cypress) {
  // 将 Vue handler 捕获的任何错误发送给
  // Cypress 顶级错误处理器以使测试失败
  // https://github.com/cypress-io/cypress/issues/7910
  Vue.config.errorHandler = window.top.onerror
}
```

让我们来修复代码中的错误逻辑：

```js
decimal() {
  if (String(this.display).indexOf(".") === -1) {
    this.append(".");
  }
},
```

测试通过了。现在代码覆盖率报告又告诉我们条件语句的 "Else" 路径并未被考虑到。

![没有 Else 路径](https://vuejsdevelopers.com/images/posts/code_coverage/decimal-else.png)

扩展测试以在测试中两次点击 "." 操作符，这将覆盖所有代码路径并将整个方法覆盖率变为绿色。

```js
it('decimal', () => {
  cy.contains('.button', '5').click()
  cy.contains('.button', '.').click()
  cy.contains('.display', '5.')
  cy.log('**不会加两次**')
  cy.contains('.button', '.').click()
  cy.contains('.display', '5.')
})
```

![Decimal 测试通过](https://vuejsdevelopers.com/images/posts/code_coverage/decimal-test-passes.png)

![全覆盖的代码路径](https://vuejsdevelopers.com/images/posts/code_coverage/decimal-covered.png)

现在再次运行所有测试。所有测试在 3 秒钟之内通过了。

![所有测试都通过了](https://vuejsdevelopers.com/images/posts/code_coverage/all-tests.gif)

这些测试一起覆盖了我们整个的代码库。

![完整的代码覆盖率](https://vuejsdevelopers.com/images/posts/code_coverage/full-cover.png)

## 总结

* 向已经使用了 Babel 转译源代码的 Vue 项目添加代码测量工具很简单。向插件列表中添加 `babel-plugin-istanbul` 就能在 `window.__coverage__`  对象中获知代码覆盖率信息。
* 为了避免减慢生产环境代码的打包速度，你可能只想在测试时检测源代码。
* 因为运行了完整的应用，端到端测试对于覆盖大量代码非常有效。
* 由 `@cypress/code-coverage` 插件产生的代码覆盖率报告可以引导你编写测试以确保所有特性都被测试到

要获得更多信息，请参阅 [Cypress code coverage guide](https://on.cypress.io/code-coverage) 和 [@cypress/code-coverage](https://github.com/cypress-io/code-coverage) 文档。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
