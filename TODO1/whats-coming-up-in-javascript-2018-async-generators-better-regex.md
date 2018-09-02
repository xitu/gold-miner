> * 原文地址：[What’s Coming Up in JavaScript 2018: Async Generators, Better Regex](https://thenewstack.io/whats-coming-up-in-javascript-2018-async-generators-better-regex/)
> * 原文作者：[Mary Branscombe](https://thenewstack.io/author/marybranscombe/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/whats-coming-up-in-javascript-2018-async-generators-better-regex.md](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-coming-up-in-javascript-2018-async-generators-better-regex.md)
> * 译者：
> * 校对者：

![](https://cdn.thenewstack.io/media/2018/08/ba3bc5a9-res-3615421_1920-1024x681.jpg)

The latest annual [ECMAScript update](http://www.ecma-international.org/ecma-262/9.0/index.html), published in June 2018, is the largest yearly release so far, although still far smaller than ECMAScript 6 with its backlog of already common features.

The two biggest developer features in this release are async generators and some long-awaited improvements to regular expressions, along with rest/spread properties, [Brian Terlson](https://github.com/bterlson), the editor of ECMAScript and Microsoft’s representative on the [ECMA TC39 committee](https://github.com/tc39), told The New Stack.

“Async generators and iterators are what you get when you combine an async function and an iterator so it’s like an async generator you can wait in or an async function you can yield from,” he explained. Previously, ECMAScript allowed you to write a function you could yield in or wait in but not both. “This is really convenient for consuming streams which are becoming more and more part of the web platform, especially with the Fetch object exposing streams.”

The async iterator is similar to the Observable pattern, but more flexible. “An Observable is a push model; once you subscribe to it, you get blasted with events and notifications at full speed whether you’re ready or not, so you have to implement buffering or sampling strategies to deal with chattiness,” Terlson explained. The async iterator is a push-pull model — you ask for a value and it gets sent to you — which works better for things like network IO primitives.

[Promise.prototype.finally](https://github.com/tc39/proposal-promise-finally) is also helpful for async programming, assign a final method to handle cleanup after a promise is either fulfilled or rejected.

## More Regular Regexps

Terlson is particularly excited about the improvements to regular expressions (where much of the work has been done by the V8 team, who already have early implementations of the four main features), as this is an area where the language has fallen behind.

“ECMAScript regexps haven’t advanced significantly since day one of JavaScript; pretty much every other programming language has regexp libraries with far more advanced capabilities than ECMAScript regexps.” ECMAScript 6 included [some minor updates](http://2ality.com/2015/07/regexp-es6.html) but he views ECMAScript 2018 as “the first update to significantly change the game for how you write regular expressions”.

The [dotAll flag](https://github.com/tc39/proposal-regexp-dotall-flag) makes the dot character match all characters, instead of failing to match some line breaks (like n or f). “You can’t use dot unless you’re in multiline mode and you don’t care about line endings,” he points out. Workarounds for that have created unnecessarily complex regexps and Terlson expects that “pretty much everyone will always engage that mode in regexp”.

[Named capture groups](https://github.com/tc39/proposal-regexp-named-groups) are similar to named groups in many other languages, where you can name the different portions of a string that a regular expression matches and treat that as an object. “It’s almost like a comment in your regular expression to explain what the group is trying to capture by giving it a name,” he explains. “This part of the pattern is the month, this is the date of birth… it’s really helpful to make your patterns maintainable by someone else in the future.”

There are other proposals for free spacing, which tells the regexp engine to ignore white space and line breaks inside a pattern match, and comments, which will allow comments at the end of lines after spaces, which may be included in future versions of ECMAScript and would further improve maintainability.

Previously ECMAScript has lookaheads but not lookbehinds. “People did tricks like reversing the string and then doing the match, or some other hacks,” notes Terlson. This will be particularly useful for regexps that do find and replace. “What you look at doesn’t become part of your match, so if you’re replacing a number that has a dollar sign on either side you can do that without having to do extra work to put the dollar sign back in.” The ECMAScript [lookbehind](https://github.com/tc39/proposal-regexp-lookbehind) allows variable length lookbehinds like C#, rather than only the fixed length patterns of Perl lookbehinds.

Especially for developers supporting international users, allowing [Unicode property escapes](https://github.com/tc39/proposal-regexp-unicode-property-escapes#ecmascript-proposal-unicode-property-escapes-in-regular-expressions) `\\p{…}` and `\\P{…}` in regular expressions will make it far easier to create Unicode-aware regexps. Today, that’s a lot of work for developers.

“Unicode defines numbers and numbers include not just the base Latin ASCII 0 to 9 but also mathematical numbers, bold numbers, outline numbers, fancy presentation numbers, tabular figures. If you want to match anything that’s a number in Unicode, a Unicode-aware application had to have the whole Unicode data tables available. By adding this feature, you can delegate all of that to Unicode,” he said. If you wanted to match Unicode characters in a rigorous way, say for doing form validation, and you want to do the right thing and not tell people that their names are invalid, that’s tough to do in a lot of cases but with Unicode character classes you can be explicit about the ranges of characters want by name. There are classes for different languages and scripts, so if you just want to deal with Greek or Chinese characters, you can. Emojis are becoming more common.

There are also some new internationalization APIs, for localized [date and time formats](https://github.com/tc39/proposal-intl-formatToParts), Euro currency formats, and [plurals](https://github.com/tc39/proposal-intl-plural-rules), which will make it easier to do things like localizing labels and buttons.

ECMAScript 2018 extends support for the rest and spread pattern (which is so common in the React ecosystem that many developers don’t realize it isn’t already fully standardized) [to objects](https://github.com/tc39/proposal-object-rest-spread) as well as arrays, which Terlson calls a small feature with an outsized impact. Rest and spread is useful for copying and cloning objects, for example, if you have an immutable structure where you want to change everything except one property, or you want to duplicate an object but add an additional property. This pattern is frequently used for assigning defaults for option records, Terlson notes. “It’s a very nice syntactical pattern for something you do all the time.”

A number of the ECMAScript 2018 features are already supported in transpilers like Babel and TypeScript. Browser support will arrive over time, and all of the new features are already in shipping versions of Chrome (for a full matrix of support, check the [ECMAScript compatibility table](http://kangax.github.io/compat-table/es2016plus/).)

[![](https://cdn.thenewstack.io/media/2018/08/cf694974-ecmascript.png)](https://cdn.thenewstack.io/media/2018/08/cf694974-ecmascript.png)

Browser support as detected by the ECMAScript Compatibility Table.

## Future Developments; ECMAScript 2019

Some interesting proposals haven’t yet made to the stage four level necessary to become part of the ECMAScript standard, including the slightly controversial idea of declarations for private fields and methods, which is covered by a number of alternative proposals.

When classes were introduced in ECMAScript 6 they were “maximally minimal”, which Terlson explains as meaning “deliberately small [in scope] with the idea being that we would go ahead and work on them later.” Private fields would allow developers to declare fields in a class that they could reference by name inside the class, but not have access to from outside the class,” he said. Not only does that offer better performance, because the runtime can optimize handling for objects better when all the fields are declared in the class constructor, but the privacy is enforced by the language in a way that private fields in TypeScript aren’t. Unlike symbols, where you can use get properties to list all the symbols on an object, private fields won’t allow reflection.

“Library authors are asking for a way to have private state so that developers can’t depend on it,” explained Terlson. “Libraries don’t like to break users even when they do things they’re not supposed to.” Private properties in classes would allow library authors to avoid exposing internal implementation details, for example, if they’re likely to change in the future.

Also at stage three is the BigInt proposal. Currently, ECMAScript has only the 64-bit floating point number type, but many platforms and web APIs use 64-bit integers — including the 64-bit integers that [Twitter uses as IDs for tweets](https://dev.twitter.com/overview/api/twitter-ids-json-and-snowflake). “You can’t represent tweet IDs in JavaScript as a number anymore,” Terlson explains; “they have to represented as a string.” Rather just adding 64-bit integers, BigInt is a more general proposal to add arbitrary precision integers. Cryptographic APIs and high-resolution timers will also take advantage of this, and Terlson expects that there may be some performance improvements from JIT JavaScript engines using native 64-bit fields to deliver big integers.

Two proposals have already made it to stage four; making catch binding optional (so that you no longer have to pass a variable to a catch block if you don’t need actually to use a variable), and [small syntax changes](https://github.com/tc39/proposal-json-superset) to deal with a mismatch between JSON and ECMAScript string formatting. These will arrive in ECMAScript 2019, along with the other proposals that progress during the next few months.

Microsoft is a sponsor of The New Stack.

Feature image [via](https://pixabay.com/en/res-the-wind-pbx-current-3615421/) Pixabay.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
