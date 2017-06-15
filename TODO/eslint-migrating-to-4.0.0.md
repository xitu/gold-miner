> * 原文地址：[ESLint Migrating to v4.0.0](http://eslint.org/docs/user-guide/migrating-to-4.0.0)
> * 原文作者：[ESLint](http://eslint.org/docs/user-guide/migrating-to-4.0.0)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Migrating to v4.0.0

ESLint v4.0.0 is the fourth major version release. We have made several breaking changes in this release; however, we expect that most of the changes will only affect a very small percentage of users. This guide is intended to walk you through the changes.

The lists below are ordered roughly by the number of users each change is expected to affect, where the first items are expected to affect the most users.

### Breaking changes for users

1. [New rules have been added to `eslint:recommended`](#eslint-recommended-changes)
2. [The `indent` rule is more strict](#indent-rewrite)
3. [Unrecognized properties in config files now cause a fatal error](#config-validation)
4. [.eslintignore patterns are now resolved from the location of the file](#eslintignore-patterns)
5. [The `padded-blocks` rule is more strict by default](#padded-blocks-defaults)
6. [The `space-before-function-paren` rule is more strict by default](#space-before-function-paren-defaults)
7. [The `no-multi-spaces` rule is more strict by default](#no-multi-spaces-eol-comments)
8. [References to scoped plugins in config files are now required to include the scope](#scoped-plugin-resolution)

### Breaking changes for plugin/custom rule developers

1. [`RuleTester` now validates properties of test cases](#rule-tester-validation)
2. [AST nodes no longer have comment properties](#comment-attachment)
3. [Shebangs are now returned from comment APIs](#shebangs)

### Breaking changes for integration developers

1. [The `global` property in the `linter.verify()` API is no longer supported](#global-property)
2. [More report messages now have full location ranges](#report-locations)
3. [Some exposed APIs are now ES2015 classes](#exposed-es2015-classes)

---

## `eslint:recommended` changes[#-eslintrecommended-changes](#-eslintrecommended-changes)

Two new rules have been added to the [`eslint:recommended`](http://eslint.org/docs/user-guide/configuring#using-eslintrecommended) config:

- [`no-compare-neg-zero`](/docs/rules/no-compare-neg-zero) disallows comparisons to `-0`
- [`no-useless-escape`](/docs/rules/no-useless-escape) disallows uselessly-escaped characters in strings and regular expressions

**To address:** To mimic the `eslint:recommended` behavior from 3.x, you can disable these rules in a config file:

```
{
  "extends": "eslint:recommended",

  "rules": {
    "no-compare-neg-zero": "off",
    "no-useless-escape": "off"
  }
}
```

##  The `indent` rule is more strict

Previously, the [`indent`](/docs/rules/indent) rule was fairly lenient about checking indentation; there were many code patterns where indentation was not validated by the rule. This caused confusion for users, because they were accidentally writing code with incorrect indentation, and they expected ESLint to catch the issues.

In 4.0.0, the `indent` rule has been rewritten. The new version of the rule will report some indentation errors that the old version of the rule did not catch. Additionally, the indentation of `MemberExpression` nodes, function parameters, and function arguments will now be checked by default (it was previously ignored by default for backwards compatibility).

To make the upgrade process easier, we’ve introduced the [`indent-legacy`](/docs/rules/indent-legacy) rule as a snapshot of the `indent` rule from 3.x. If you run into issues from the `indent` rule when you upgrade, you should be able to use the `indent-legacy` rule to replicate the 3.x behavior. However, the `indent-legacy` rule is deprecated and will not receive bugfixes or improvements in the future, so you should eventually switch back to the `indent` rule.

**To address:** We recommend upgrading without changing your `indent` configuration, and fixing any new indentation errors that appear in your codebase. However, if you want to mimic how the `indent` rule worked in 3.x, you can update your configuration:

```
{
  rules: {
    indent: "off",
    "indent-legacy": "error" // replace this with your previous `indent` configuration
  }
}
```

##  Unrecognized properties in config files now cause a fatal error

When creating a config, users sometimes make typos or misunderstand how the config is supposed to be structured. Previously, ESLint did not validate the properties of a config file, so a typo in a config could be very tedious to debug. Starting in 4.0.0, ESLint will raise an error if a property in a config file is unrecognized or has the wrong type.

**To address:** If you see a config validation error after upgrading, verify that your config doesn’t contain any typos. If you are using an unrecognized property, you should be able to remove it from your config to restore the previous behavior.

##  .eslintignore patterns are now resolved from the location of the file

Due to a bug, glob patterns in an `.eslintignore` file were previously resolved from the current working directory of the process, rather than the location of the `.eslintignore` file. Starting in 4.0, patterns in an `.eslintignore` file will be resolved from the `.eslintignore` file’s location.

**To address:** If you use an `.eslintignore` file and you frequently run eslint from somewhere other than the project root, it’s possible that the patterns will be matched differently. You should update the patterns in the `.eslintignore` file to ensure they are relative to the file, not to the working directory.

##  The `padded-blocks` rule is more strict by default

By default, the [`padded-blocks`](/docs/rules/padded-blocks) rule will now enforce padding in class bodies and switch statements. Previously, the rule would ignore these cases unless the user opted into enforcing them.

**To address:** If this change results in more linting errors in your codebase, you should fix them or reconfigure the rule.

##  The `space-before-function-paren` rule is more strict by default

By default, the [`space-before-function-paren`](/docs/rules/space-before-function-paren) rule will now enforce spacing for async arrow functions. Previously, the rule would ignore these cases unless the user opted into enforcing them.

**To address:** To mimic the default config from 3.x, you can use:

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

##  The `no-multi-spaces` rule is more strict by default

By default, the [`no-multi-spaces`](/docs/rules/no-multi-spaces) rule will now disallow multiple spaces before comments at the end of a line. Previously, the rule did not check this case.

**To address:** To mimic the default config from 3.x, you can use:

```
{
  "rules": {
    "no-multi-spaces": ["error", {"ignoreEOLComments": true}]
  }
}
```

##  References to scoped plugins in config files are now required to include the scope

In 3.x, there was a bug where references to scoped NPM packages as plugins in config files could omit the scope. For example, in 3.x the following config was legal:

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

In other words, it was possible to reference a rule from a scoped plugin (such as `foo/some-rule`) without explicitly stating the `@my-organization` scope. This was a bug because it could lead to ambiguous rule references if there was also an unscoped plugin called `eslint-plugin-foo` loaded at the same time.

To avoid this ambiguity, in 4.0 references to scoped plugins must include the scope. The config from above should be fixed to:

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

**To address:** If you reference a scoped NPM package as a plugin in a config file, be sure to include the scope wherever you reference it.

---

## `RuleTester` now validates properties of test cases

Starting in 4.0, the `RuleTester` utility will validate properties of test case objects, and an error will be thrown if an unknown property is encountered. This change was added because we found that it was relatively common for developers to make typos in rule tests, often invalidating the assertions that the test cases were trying to make.

**To address:** If your tests for custom rules have extra properties, you should remove those properties.

## AST Nodes no longer have comment properties

Prior to 4.0, ESLint required parsers to implement comment attachment, a process where AST nodes would gain additional properties corresponding to their leading and trailing comments in the source file. This made it difficult for users to develop custom parsers, because they would have to replicate the confusing comment attachment semantics required by ESLint.

In 4.0, we have moved away from the concept of comment attachment and have moved all comment handling logic into ESLint itself. This should make it easier to develop custom parsers, but it also means that AST nodes will no longer have `leadingComments` and `trailingComments` properties. Conceptually, rule authors can now think of comments in the context of tokens rather than AST nodes.

**To address:** If you have a custom rule that depends on the `leadingComments` or `trailingComments` properties of an AST node, you can now use `sourceCode.getCommentsBefore()` and `sourceCode.getCommentsAfter()` instead, respectively.

Additionally, the `sourceCode` object now also has `sourceCode.getCommentsInside()` (which returns all the comments inside a node), `sourceCode.getAllComments()` (which returns all the comments in the file), and allows comments to be accessed through various other token iterator methods (such as `getTokenBefore()` and `getTokenAfter()`) with the `{includeComments:true}` option.

For rule authors concerned about supporting ESLint v3.0 in addition to v4.0, the now deprecated `sourceCode.getComments()` is still available and will work for both versions.

Finally, please note that the following `SourceCode` methods have been deprecated and will be removed in a future version of ESLint:

- `getComments()` - replaced by `getCommentsBefore()`, `getCommentsAfter()`, and `getCommentsInside()`
- `getTokenOrCommentBefore()` - replaced by `getTokenBefore()` with the `{includeComments:true}` option
- `getTokenOrCommentAfter()` - replaced by `getTokenAfter()` with the `{includeComments:true}` option

## `LineComment` and `BlockComment` events will no longer be emitted during AST traversal

Starting in 4.0, `LineComment` and `BlockComments` events will not be emitted during AST traversal. There are two reasons for this:

- This behavior was relying on comment attachment happening at the parser level, which does not happen anymore, to ensure that all comments would be accounted for
- Thinking of comments in the context of tokens is more predictable and easier to reason about than thinking about comment tokens in the context of AST nodes

**To address:** Instead of relying on `LineComment` and `BlockComment`, rules can now use `sourceCode.getAllComments()` to get all comments in a file. To check all comments of a specific type, rules can use the following pattern:

```
sourceCode.getAllComments().filter(comment => comment.type === "Line");
sourceCode.getAllComments().filter(comment => comment.type === "Block");
```

##  Shebangs are now returned from comment APIs

Prior to 4.0, shebang comments in a source file would not appear in the output of `sourceCode.getAllComments()` or `sourceCode.getComments()`, but they would appear in the output of `sourceCode.getTokenOrCommentBefore` as line comments. This inconsistency led to some confusion for rule developers.

In 4.0, shebang comments are treated as comment tokens of type `Shebang` and will be returned by any `SourceCode` method that returns comments. The goal of this change is to make working with shebang comments more consistent with how other tokens are handled.

**To address:** If you have a custom rule that performs operations on comments, some additional logic might be required to ensure that shebang comments are correctly handled or filtered out:

```
sourceCode.getAllComments().filter(comment => comment.type !== "Shebang");
```

---

##  The `global` property in the `linter.verify()` API is no longer supported

Previously, the `linter.verify()` API accepted a `global` config option, which was a synonym for the documented `globals` property. The `global` option was never documented or officially supported, and did not work in config files. It has been removed in 4.0.

**To address:** If you were using the `global` property, please use the `globals` property instead, which does the same thing.

##  More report messages now have full location ranges

Starting in 3.1.0, rules have been able to specify the *end* location of a reported problem, in addition to the start location, by explicitly specifying an end location in the `report` call. This is useful for tools like editor integrations, which can use the range to precisely display where a reported problem occurs. Starting in 4.0, if a *node* is reported rather than a location, the end location of the range will automatically be inferred from the end location of the node. As a result, many more reported problems will have end locations.

This is not expected to cause breakage. However, it will likely result in larger report locations than before. For example, if a rule reports the root node of the AST, the reported problem’s range will be the entire program. In some integrations, this could result in a poor user experience (e.g. if the entire program is highlighted to indicate an error).

**To address:** If you have an integration that deals with the ranges of reported problems, make sure you handle large report ranges in a user-friendly way.

##  Some exposed APIs are now ES2015 classes

The `CLIEngine`, `SourceCode`, and `RuleTester` modules from ESLint’s Node.js API are now ES2015 classes. This will not break any documented behavior, but it does have some observable effects (for example, the methods on `CLIEngine.prototype` are now non-enumerable).

**To address:** If you rely on enumerating the methods of ESLint’s Node.js APIs, use a function that can also access non-enumerable properties such as `Object.getOwnPropertyNames`.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
