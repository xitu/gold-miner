> * 原文地址：[Why I've stopped exporting defaults from my JavaScript modules](https://humanwhocodes.com/blog/2019/01/stop-using-default-exports-javascript-module/)
> * 原文作者：[Nicholas C. Zakas](https://humanwhocodes.com/blog/2019/01/stop-using-default-exports-javascript-module/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/stop-using-default-exports-javascript-module.md](https://github.com/xitu/gold-miner/blob/master/TODO1/stop-using-default-exports-javascript-module.md)
> * 译者：
> * 校对者：

# Why I've stopped exporting defaults from my JavaScript modules

After years of fighting with default exports, I've changed my ways.

Last week, I tweeted something that got quite a few surprising responses:

> In 2019, one of the things I’m going to do is stop exporting things as default from my CommonJS/ES6 modules.
> 
> Importing a default export has grown to feel like a guessing game where I have a 50/50 chance of being wrong each time. Is it a class? Is it a function?
> 
> — Nicholas C. Zakas (@slicknet) [January 12, 2019](https://twitter.com/slicknet/status/1084101377297506304?ref_src=twsrc%5Etfw)

I tweeted this after realizing that a lot of problems I had with JavaScript modules could be traced back to fights with default exports. It didn’t matter if I was using JavaScript modules (or ECMAScript modules, as many prefer to call them) or CommonJS, I was still stumbling over importing from modules with default exports. I got a variety of responses to the tweet, many of which questioned how I could come to this decision. This post is my attempt to clarify my thinking.

## A few clarifications

As is the case with all tweets, my tweet was meant as a snapshot into an opinion I had rather than a normative reference for my entire opinion. To clarify a few points people seem confused by on Twitter:

*   The use case of knowing whether an export is a function or a class was an example of the type of problems I’ve encountered. It is not the _only_ problem I’ve found named exports solve for me.
*   The problems I’ve encountered don’t just happen with files in my own projects, they also happen with importing library and utility modules that I don’t own. That means naming conventions for filenames don’t solve all of the problems.
*   I’m not saying that everyone should abandon default exports. I’m saying that in modules I’m writing, I will choose not to use default exports. You may feel differently, and that’s fine.

Hopefully those clarifications setup enough context to avoid confusion throughout the rest of this post.

## Default exports: A primer

To the best of my knowledge, default exports from modules were first popularized in CommonJS, where a module can export a default value like this:

```
class LinkedList {}
module.exports = LinkedList;
```

This code exports the `LinkedList` class but does not specify the name to be used by consumers of the module. Assuming the filename is `linked-list.js`, you can import that default in another CommonJS module like this:

```
const LinkedList = require("./linked-list");
```

The `require()` function is returning a value that I just happened to name `LinkedList` to match what is in `linked-list.js`, but I also could have chosen to name it `foo` or `Mountain` or any random identifier.

The popularity of default module exports in CommonJS meant that JavaScript modules were designed to support this pattern:

> ES6 favors the single/default export style, and gives the sweetest syntax to importing the default.
> 
> — David Herman [June 19, 2014](https://mail.mozilla.org/pipermail/es-discuss/2014-June/037905.html)

So in JavaScript modules, you can export a default like this:

```
export default class LinkedList {}
```

And then you can import like this:

```
import LinkedList from "./linked-list.js";
```

Once again, `LinkedList` is this context is an arbitrary (if not well-reasoned) choice and could just as well be `Dog` or `symphony`.

## The alternative: named exports

Both CommonJS and JavaScript modules support named exports in addition to default exports. Named exports allow for the name of a function, class, or variable to be transferred into the consuming file.

In CommonJS, you create a named export by attaching a name to the `exports` object, such as:

```
exports.LinkedList = class LinkedList {};
```

You can then import in another file like this:

```
const LinkedList = require("./linked-list").LinkedList;
```

Once again, the name I’ve used with `const` can be anything I want, but I’ve chosen to match it to the exported name `LinkedList`.

In JavaScript modules, a named export looks like this:

```
export class LinkedList {}
```

And you can import like this:

```
import { LinkedList } from "./linked-list.js";
```

In this code, `LinkedList` cannot be a randomly assigned identifier and must match an named export called `LinkedList`. That’s the only significant difference from CommonJS for the goals of this post.

So the capabilities of both module types support both default and named exports.

## Personal preferences

Before going further, it’s helpful for you to know some of my own personal preferences when it comes to writing code. These are general principles I apply to all code that I write, regardless of the programming language I use:

1.  **Explicit over implicit.** I don’t like having code with secrets. What something does, what something should be called, etc., should always be made explicit whenever possible.

2.  **Names should be consistent throughout all files.** If something is an `Apple` in one file, I shouldn’t call it `Orange` in another file. An `Apple` should always be an `Apple`.

3.  **Throw errors early and often.** If it’s possible for something to be missing then it’s best to check as early as possible and, in the best case, throw an error that alerts me to the problem. I don’t want to wait until the code has finished executing to discover that it didn’t work correctly and then hunt for the problem.

4.  **Fewer decisions mean faster development.** A lot of the preferences I have are for eliminating decisions during coding. Every decision you make slows you down, which is why things like coding conventions lead to faster development. I want to decide things up front and then just go.

5.  **Side trips slow down development.** Whenever you have to stop and look something up in the middle of coding, I call that a side trip. Side trips are sometimes necessary but there are a lot of unnecessary side trips that can slow things down. I try to write code that eliminates the need for side trips.

6.  **Cognitive overhead slows down development.** Put simply: the more detail you need to remember to be productive when writing code, the slower your development will be.

The focus on speed of development is a practical one for me. As I’ve struggled with my health for years, the amount of energy I’ve had to code continued to decrease. Anything I could do to reduce the amount of time spent coding while still accomplishing my task was key.

## The problems I’ve run into

With all of this in mind, here are the top problems I’ve run into using default exports and why I believe that named exports are a better choice in most situations.

### What is that thing?

As I mentioned in my original tweet, I find it difficult to figure out what I’m importing when a module only has a default import. If you’re using a module or file you’re unfamiliar with, it can be difficult to figure out what is returned, for example:

```
const list = require("./list");
```

In this context, what would you expect `list` to be? It’s unlikely to be a primitive value, but it could logically be a function, class, or other type of object. How will I know for sure? I need a side trip. In this case, a side trip might be any of:

*   If I own `list.js`, then I may open the file and look for the export.
*   If I don’t own `list.js`, then I may open up some documentation.

In either case, this now becomes an extra bit of information you need in your brain to avoid a second side trip penalty when you need to import from `list.js` again. If you are importing a lot of defaults from modules then either your cognitive overhead is increasing or the number of side trips is increasing. Both are suboptimal and can be frustrating.

Some will say that IDEs are the answer to this problem, that the IDEs should be smart enough to figure out what is being imported and tell you. While I’m all for smarter IDEs to help developers, I believe requiring IDEs to effectively use a language feature is problematic.

### Name matching problems

Named exports require consuming modules to at least specify the name of the thing they are importing from a module. The benefit is that I can easily search for everywhere that `LinkedList` is used in a code base and know that it all refers to the same `LinkedList`. As default exports are not prescriptive of the names used to import them, that means naming imports becomes more cognitive overhead for each developer. You need to determine the correct naming convention, and as extra overhead, you need to make sure every developer working in the application will use the same name for the same thing. (You can, of course, allow each developer to use different names for the same thing, but that introduces more cognitive overhead for the team.)

Importing a named export means at least referencing the canonical name of a thing everywhere that it’s used. Even if you choose to rename an import, the decision is made explicit, and cannot be done without first referencing the canonical name in some way. In CommonJS:

```
const MyList = require("./list").LinkedList;
```

In JavaScript modules:

```
import { LinkedList as MyList } from "./list.js";
```

In both module formats, you’ve made an explicit statement that `LinkedList` is now going to be referred to as `MyList`.

When naming is consistent across a codebase, you’re able to easily do things like:

1.  Search the codebase to find usage information.
2.  Refactor the name of something across the entire codebase.

Is it possible to do this when using default exports and ad-hoc naming of things? My guess is yes, but I’d also guess that it would be a lot more complicated and error-prone.

### Importing the wrong thing

Named exports in JavaScript modules have a particular advantage over default exports in that an error is thrown when attempting to import something that doesn’t exist in the module. Consider this code:

```
import { LinkedList } from "./list.js";
```

If `LinkedList` doesn’t exist in `list.js`, then an error is thrown. Further, tools such as IDEs and ESLint[1](#fn:1) are easily able to detect a missing reference before the code is executed.

## Worse tooling support

Speaking of IDEs, WebStorm is able to help write `import` statements for you.[2](#fn:2) When you have finished typing an identifier that isn’t defined in the file, WebStorm will search the modules in your project to determine if the identifier is a named export in another file. At that point, it can do any of the following:

1.  Underline the identifier that is missing its definition and show you the `import` statement that would fix it.
2.  Automatically add the correct `import` statement (if you have enable auto import) can now automatically add an `import` statement based on an identifier that you type. In fact, WebStorm is able to help you a great deal when using named imports:

There is a plugin for Visual Studio Code[3](#fn:3) that provides similar functionality. This type of functionality isn’t possible when using default exports because there is no canonical name for things you want to import.

## Conclusion

I’ve had several productivity problems importing default exports in my projects. While none of the problems are necessarily impossible to overcome, using named imports and exports seems to better fit my preferences when coding. Making things explicit and leaning heavily on tooling makes me a productive coder, and insofar as named exports help me do that, I will likely favor them for the foreseeable future. Of course, I have no control over how third-party modules I use export their functionality, but I definitely have a choice over how my own modules export things and will choose named exports.

As earlier, I remind you that this is my opinion and you may not find my reasoning to be persuasive. This post was not meant to persuade anyone to stop using default exports, but rather, to better explain to those that inquired why I, personally, will stop exporting defaults from the modules I write.

## References

1.  [esling-plugin-import `import/named` rule](https://github.com/benmosher/eslint-plugin-import/blob/master/docs/rules/named.md) [↩](#fnref:1)
    
2.  [WebStorm: Auto Import in JavaScript](https://www.jetbrains.com/help/webstorm/javascript-specific-guidelines.html#ws_js_auto_import) [↩](#fnref:2)
    
3.  [Visual Studio Extension: Auto Import](https://marketplace.visualstudio.com/items?itemName=NuclleaR.vscode-extension-auto-import) [↩](#fnref:3)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
