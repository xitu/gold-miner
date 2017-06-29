> * 原文地址：[ESLint Migrating to v4.0.0](http://eslint.org/docs/user-guide/migrating-to-4.0.0)
> * 原文作者：[ESLint](http://eslint.org/docs/user-guide/migrating-to-4.0.0)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[吃土小2叉](https://github.com/xunge0613)
> * 校对者：[薛定谔的猫](https://github.com/Aladdin-ADD)、[sqrthree](https://github.com/sqrthree)

# ESLint v4.0.0 升级指南

ESLint v4.0.0 是 ESLint 的第 4 个主版本。当然，我们希望大多数变更只影响极少数用户。本文旨在帮助您了解具体有哪些更改。

以下列表大致按每个更改可能影响的用户数量进行排序，排序越靠前影响的用户数越多。

### ESLint 使用者请注意

1. [`eslint:recommended` 新增规则](#eslint-recommended-changes)
2. [`indent` 规则将更严格](#indent-rewrite)
3. [现在配置文件中未识别的属性会报告严重错误](#config-validation)
4. [忽略文件将从 .eslintignore 文件所在目录开始解析](#eslintignore-patterns)
5. [默认情况下 `padded-blocks` 规则将更严格](#padded-blocks-defaults)
6. [默认情况下 `space-before-function-paren` 规则将更严格](#space-before-function-paren-defaults)
7. [默认情况下 `no-multi-spaces` 规则将更严格](#no-multi-spaces-eol-comments)
8. [现在必须包含命名空间，才能引用限定在命名空间下的插件](#scoped-plugin-resolution)


### ESLint 插件开发者和自定义规则开发者请注意

1. [现在 `RuleTester` 将验证测试用例对象的属性](#rule-tester-validation)
2. [AST 节点不再具有注释属性](#comment-attachment)
3. [在 AST 遍历期间不会触发 `LineComment` 和 `BlockComments` 事件](#)
4. [现在 Shebang 可以通过注释 API 返回](#shebangs)

### 集成开发者请注意

1. [`linter.verify()` API 不再支持 `global` 属性](#global-property)
2. [现在更多报告消息具有完整的位置范围](#report-locations)
3. [部分暴露的 API 将使用 ES2015 中的类](#exposed-es2015-classes)


---

## `eslint:recommended` 新增规则

[`eslint:recommended`](http://eslint.org/docs/user-guide/configuring#using-eslintrecommended) 中新增了两条规则：

- [`no-compare-neg-zero`](http://eslint.org/docs/rules/no-compare-neg-zero) 不允许与 `-0` 进行比较
- [`no-useless-escape`](http://eslint.org/docs/rules/no-useless-escape) 不允许在字符串和正则表达式中使用无意义的换行符
 
**注:** 如果要与 ESLint 3.x 的 `eslint:recommended` 保持一致，您可以在配置文件中禁用上述规则：

```
{
  "extends": "eslint:recommended",

  "rules": {
    "no-compare-neg-zero": "off",
    "no-useless-escape": "off"
  }
}
```

## `indent` 规则将更严格

过去的 [`indent`](http://eslint.org/docs/rules/indent) 规则在检查缩进方面是相当宽容的：过去的缩进校验规则会忽略许多代码模式。而这会让用户产生困扰，因为他们偶尔会有不正确的代码缩进，并且他们本期望 ESLint 能够发现这些问题（译者补充：然而并没有发现）。

在 ESLint v4.0.0 中，`indent` 规则被重写。新版规则将报告出旧版规则无法发现的缩进错误。另外，`MemberExpression` 节点、函数声明参数以及函数调用参数将默认进行缩进检查（过去为了向后兼容，这些默认都被忽略了）。

为了方便升级到 ESLint 4.0.0，我们引入了 [`indent-legacy`](/docs/rules/indent-legacy) 规则作为 ESLint 3.x 中 `indent` 规则的快照。如果你在升级过程中遇到了 `indent` 规则的相关问题，那么您可以借助于 `indent-legacy` 规则来维持与 3.x 一致。然而，`indent-legacy` 规则已被弃用并且在将来不再维护，所以您最终还是应该使用 `indent` 规则。

**注：** 推荐在升级过程中不要更改 `indent` 配置，并修正新的缩进错误。然而如果要与 ESLint 3.x 的 `indent` 规则保持一致，您可以这样配置：

```
{
  rules: {
    indent: "off",
    "indent-legacy": "error" // 用之前的 `indent` 配置替换此处
  }
}
```

##  现在配置文件中未识别的属性会报告严重错误

在创建配置文件时，用户有时候会犯拼写错误或者弄错配置文件的结构。在以前，ESLint 并不会验证配置文件中的属性，因此很难调试配置文件中的拼写错误。而从 ESLint v4.0.0 起，当配置文件中存在未识别的属性或者属性类型有错误时，ESLint 会抛出一个错误。

**注：** 升级后如果发现配置文件验证出错，请检查配置文件中是否存在拼写错误。如果使用了未识别的属性，那么应该将之从配置文件中移除，从而使 ESLint 恢复正常。

## 忽略文件将从 .eslintignore 文件所在目录开始解析

过去由于一个 bug，`.eslintignore` 文件的路径名模板是从进程的当前工作目录解析，而不是 `.eslintignore` 文件的位置。从 ESLint 4.0 开始，`.eslintignore` 文件的路径名模板将从 `.eslintignore` 文件的位置解析。

**注：** 如果您使用 `.eslintignore` 文件，并且您经常从项目根目录以外的地方运行 ESLint，则可能会以不同的模式匹配路径名。您应该更新 `.eslintignore` 文件中的匹配模式，以确保它们与该文件相关，而不是与工作目录相关。

##  默认情况下 `padded-blocks` 规则将更严格

现在默认情况下， [`padded-blocks`](http://eslint.org/docs/rules/padded-blocks) 规则要求在类内填充空行以及在 switch 语句中填充空行。而过去除非用户更改配置，否则默认情况下这条规则会忽略上述情况的检查。

**注：** 如果此更改导致代码库中出现更多的错误，您应该修复它们或重新配置规则。

##  默认情况下 `space-before-function-paren` 规则将更严格

现在默认情况下， [`space-before-function-paren`](http://eslint.org/docs/rules/space-before-function-paren) 规则要求异步箭头函数的圆括号与 `async` 关键词之间存在空格。而过去除非用户更改配置，否则默认情况下这条规则会忽略对异步箭头函数的检查。

**注：** 如果要与 ESLint 3.x 的默认配置保持一致，您可以这样配置：

```
{
  "rules": {
    "space-before-function-paren": ["error", {
      "anonymous": "always",
      "named": "always",
      "asyncArrow": "ignore"
    }]
  }
}
```

##  默认情况下 `no-multi-spaces` 规则将更严格

现在默认情况下， [`no-multi-spaces`](http://eslint.org/docs/rules/no-multi-spaces) 规则禁止行尾注释前存在多个空格。而过去这条规则不对此进行检查。

**注：** 如果要与 ESLint 3.x 的默认配置保持一致，您可以这样配置：

```
{
  "rules": {
    "no-multi-spaces": ["error", {"ignoreEOLComments": true}]
  }
}
```

## 现在必须包含命名空间，才能引用限定在命名空间下的插件

在 ESLint 3.x 中存在一个 bug：引用限定在命名空间下的插件可能会忽略该命名空间。举个例子，在 ESLint 3.x 中以下配置是合法的：

```
{
  "plugins": [
    "@my-organization/foo"
  ],
  "rules": {
    "foo/some-rule": "error"
  }
}
```

换句话说，过去可以引用限定命名空间的插件的规则（例如 `foo/some-rule`），同时无需明确声明 `@my-organization` 的命名空间。这是一个 bug，因为如果同时加载了一个名为 `eslint-plugin-foo` 的不限定命名空间的插件，可能会导致引用规则时产生歧义。

为了避免歧义，在 ESLint 4.0 中必须包含命名空间，才能引用限定在命名空间下的插件。

```
{
  "plugins": [
    "@my-organization/foo"
  ],
  "rules": {
    "@my-organization/foo/some-rule": "error"
  }
}
```

**注：** 如果您在配置文件中引用了限定在命名空间下的插件，那么请确保在引用的时候包含命名空间。

---

## 现在 `RuleTester` 将验证测试用例对象的属性

从 ESLint 4.0 开始，`RuleTester` 工具将验证测试用例对象的属性，如果遇到未知属性，将抛出错误。这番改动是因为我们发现开发人员在测试规则时的拼写错误是比较常见的，且通常会使测试用例试图作出的断言无效。

**注：** 如果您对自定义规则的测试用例对象具有额外的属性，则应该移除这些属性。

## AST 节点不再具有注释属性

在 ESLint 4.0 之前，ESLint 需要解析器实现附加注释的解析，这个过程中，AST 节点将从源文件的前后置注释中获取额外的相关联属性。这就使得用户很难去开发自定义解析器，因为他们不得不去重复解析那些令人困惑同时又是 ESlint 必需的附加注释语义。

在 ESLint 4.0 中，我们已经摆脱了附加注释的概念，并将所有的注释处理逻辑转移到了 ESLint 本身。这样可以更容易地开发自定义解析器，但这也意味着 AST 节点将不再具有 `leadingComments` 和 `trailingComments` 属性。 从概念上来说，规则作者现在可以在 tokens 上下文而不是 AST 节点的上下文中考虑注释。

**注：** 如果您有一个依赖于 AST 节点的 `leadingComments` 或 `trailingComments` 属性的自定义规则，则可以分别使用 `sourceCode.getCommentsBefore()` 和 `sourceCode.getCommentsAfter()` 替代。

此外，`sourceCode` 对象现在也有 `sourceCode.getCommentsInside()` 方法（它返回一个节点内的所有注释），`sourceCode.getAllComments()` 方法（它返回文件中的所有注释），并允许注释通过各种其他 token 迭代器方法（例如 `getTokenBefore()` 和 `getTokenAfter()`）并设置选项`{includeComments：true}` 进行访问。

对于想要同时兼容 ESLint v3.0 和 v4.0 的规则作者，现在已经不推荐使用的 `sourceCode.getComments()` 仍然可用，并且这两个版本都兼容。

最后请注意，以下 `SourceCode` 方法已被弃用，将在以后的 ESLint 版本中被移除：

- `getComments()` - 请使用 `getCommentsBefore()`、`getCommentsAfter()` 和 `getCommentsInside()` 来替换
- `getTokenOrCommentBefore()` - 请使用 `getTokenBefore()` 方法并设置选项 `{includeComments:true}` 来替换
- `getTokenOrCommentAfter()` -  请使用 `getTokenAfter()` 方法并设置选项 `{includeComments:true}` 来替换

## 在 AST 遍历期间不会触发 `LineComment` 和 `BlockComments` 事件

从 ESLint 4.0 开始，在 AST 遍历期间不会触发 `LineComment` 和 `BlockComments` 事件。原因如下：

- 过去这种行为依赖于在解析器级别的注释附属物，而自 ESLint 4.0 开始不再如此，以确保所有注释将被考虑
- 在 tokens 上下文中考虑注释更容易预测和更容易理解，而非在 AST 节点上下文中考虑注释 token

**注：** 规则现在可以使用`sourceCode.getAllComments()` 来获取文件中的所有注释，而非依赖于 `LineComment` 和 `BlockComment`。要检查特定类型的所有注释，规则可以使用以下模式：

```
sourceCode.getAllComments().filter(comment => comment.type === "Line");
sourceCode.getAllComments().filter(comment => comment.type === "Block");
```

##  现在 Shebang 可以通过注释 API 返回

（译者注：Shebang 是一个由井号和叹号构成的字符序列 ` #!`，其出现在文本文件的第一行的前两个字符。参考：[Shebang_(Unix)](https://en.wikipedia.org/wiki/Shebang_(Unix))）

在 ESLint 4.0 之前，源文件中的 shebang 注释不会出现在 `sourceCode.getAllComments()` 或 `sourceCode.getComments()` 的输出中，但它们将作为行注释出现在 `sourceCode.getTokenOrCommentBefore` 的输出中。这种不一致会给规则开发者带来困惑。

在 ESLint 4.0 中，shebang 注释被视为 `Shebang` 类型的注释 tokens，并可以通过任何返回注释的 `SourceCode` 方法返回。该变化的目的是为了让 shebang 的评论更符合其他 tokens 的处理方式。

**注：** 如果您有一个自定义规则对注释执行操作，可能需要一些额外的逻辑来确保 shebang 注释被正确处理或被正常过滤掉：

```
sourceCode.getAllComments().filter(comment => comment.type !== "Shebang");
```

---

## `linter.verify()` API  不再支持 `global` 属性

过去，`linter.verify()` API 接受  `global` 属性作为一个配置项，它与官方文档中的 `globals` 作用相同。但是，`global` 属性从未出现在官方文档中或者被官方支持，并且在配置文件中该属性会失效。自 ESLint 4.0 起，该属性已被移除。

**注：** 如果您先前使用了 global 属性，请用 globals 属性替换，其作用与 global 相同。

## 现在更多报告消息具有完整的位置范围

从 ESLint 3.1.0 开始，除了开始位置之外，规则还可以通过调用 `report` 时明确指定一个结束位置来指定问题报告的**结束**位置。这对于编辑器集成这样的工具很有用，可以使用范围来精确显示出现问题的位置。从 ESLint 4.0 开始，如果报告了**节点**而不是一个具体位置，则该结束位置的范围将自动从节点的结束位置推断出来。因此，更多报告的问题将会有结束位置。

这不会带来兼容性问题。然而，这可能会导致比以前更大的报告位置范围。例如，如果一条规则报告的是 AST 的根节点，则问题的范围将是整个程序。在某些集成中，这可能导致用户体验不佳（例如，如果整个程序都被高亮显示以指示错误）。

**注：** 如果您有处理报告问题范围的集成，请确保以对用户友好的方式处理大型报告范围。

## 部分暴露的 API 将使用 ES2015 中的类

现在部分 ESLint 的 Node.js API，比如 `CLIEngine`、`SourceCode` 以及 `RuleTester` 模块使用了 ES2015 中的类。当然这不会影响到接口的正常使用，不过这的确会产生一些明显的影响（举个例子，`CLIEngine.prototype` 将不可枚举）。

**注：** 如果您需要对 ESLint 的 Node.js API 提供的方法进行枚举遍历，可以用诸如 `Object.getOwnPropertyNames` 的函数来访问不可枚举属性。（译者注：可参考[ MDN 文档：属性的可枚举性和所有权](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Enumerability_and_ownership_of_properties)）

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
