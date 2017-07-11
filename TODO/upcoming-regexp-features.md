
> * 原文地址：[Upcoming Regular Expression Features](https://developers.google.com/web/updates/2017/07/upcoming-regexp-features)
> * 原文作者：[Jakob Gruber](https://developers.google.com/web/resources/contributors#jgruber)、[Yang Guo](https://developers.google.com/web/resources/contributors#yangguo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/upcoming-regexp-features.md](https://github.com/xitu/gold-miner/blob/master/TODO/upcoming-regexp-features.md)
> * 译者：[sunui](https://github.com/sunui)
> * 校对者：

# 即将到来的正则表达式新特性

ES2015 给 JavaScript 语言引入了许多新特性，其中包括正则表达式语法的一些重大改进，新增了 Unicode （`/u`） 和粘滞位 （`/y`）两个修饰符。但从那以后，发展从未止步。经过与 TC39（ECMAScript 标准委员会）的其他成员的紧密合作，V8 团队提议并共同设计了让正则表达式更强大的几个新特性。

这些新特性目前已经计划包含在 JavaScript 标准中。即使提案还没有完全通过，它们已经进入 [TC39 流程的候选阶段](https://tc39.github.io/process-document/)了。我们已经在一个 flag（见下文）之后实现了这些功能，以便在最终定稿之前提供及时的设计和实现反馈给各自的提案作者。

本文给您预览一下这个令人兴奋的未来。如果您愿意跟着体验这些即将到来的示例，可以在 `chrome://flags/#enable-javascript-harmony` 开启实验性 JavaScript 功能。

## 命名捕获

正则表达式可以包含所谓的捕获（或捕获组），它可以捕获一部分匹配的文本。到目前为止，开发者只能通过索引来引用这些捕获，这取决于其在正则匹配中的位置。

    const pattern =/(\d{4})-(\d{2})-(\d{2})/u;
    const result = pattern.exec('2017-07-10');
    // result[0] === '2017-07-10'
    // result[1] === '2017'
    // result[2] === '07'
    // result[3] === '10'


但正则表达式已经因难于读、写和维护而臭名昭著，并且数字引用会使事情进一步复杂化。例如，在一个更长的表达式中判断一个独特捕获的索引是很困难的事：

    /(?:(.)(.(?<=[^(])(.)))/  // 最后一个捕获组的索引是？


更糟糕的是，更改一个表达式可能会潜在得转变所有已存在的捕获的索引：

    /(a)(b)(c)\3\2\1/     // 一些简单的有序的反向引用。
    /(.)(a)(b)(c)\4\3\2/  // 所有都需要更新。


命名捕获是一个即将到来的特性，它允许开发者给捕获组分配名称来帮助缓解这些问题。语法类似于 Perl、Java、.Net 和 Ruby：

    const pattern =/(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/u;
    const result = pattern.exec('2017-07-10');
    // result.groups.year === '2017'
    // result.groups.month === '07'
    // result.groups.day === '10'


命名捕获组也可以被命名的反向引用来引用，并传入 `String.prototype.replace`：

    // 命名反向引用。
    /(?<LowerCaseX>x)y\k<LowerCaseX>/.test('xyx');  //true

    // 字符串替换。
    const pattern =/(?<fst>a)(?<snd>b)/;
    'ab'.replace(pattern,'$<snd>$<fst>');                              // 'ba'
    'ab'.replace(pattern,(m, p1, p2, o, s,{fst, snd})=> fst + snd);  // 'ba'


关于这个新特性的全部详情可以在[规范提议](https://github.com/tc39/proposal-regexp-named-groups)中查看。

## dotAll 修饰符

默认情况下，元字符 `.` 在正则表达式中匹配除了换行符以外的任何字符：

    /foo.bar/u.test('foo\nbar');   // false


一个提案引入了 dotAll 模式，通过 `/s` 修饰符来开启。在 dotAll 模式中，`.` 也可以匹配换行符。

    /foo.bar/su.test('foo\nbar');  // true


关于这个新特性的全部详情可以在[规范提议](https://github.com/tc39/proposal-regexp-dotall-flag)中查看。

## Unicode Property Escapes

Regular expression syntax has always included shorthands for certain character classes. `\d` represent digits and is really just `[0-9]`; `\w` is short for word characters, or `[A-Za-z0-9_]`.

With Unicode awareness introduced in ES2015, there are suddenly many more characters that could be considered numbers, for example the circled digit one: ①; or considered word characters, for example the Chinese character for snow: 雪.

Neither of these can be matched with `\d` or `\w`. Changing the meaning of these shorthands would break existing regular expression patterns.

Instead, new character classes are being [introduced](https://github.com/tc39/proposal-regexp-unicode-property-escapes). Note that they are only available for Unicode-aware regular expressions denoted by the `/u` flag.

    /\p{Number}/u.test('①');      // true
    /\p{Alphabetic}/u.test('雪');  // true


The inverse can be matched by with `\P`.

    /\P{Number}/u.test('①');      // false
    /\P{Alphabetic}/u.test('雪');  // false


The Unicode consortium defines many more ways to classify code points, for example math symbols or Japanese Hiragana characters:

    /^\p{Math}+$/u.test('∛∞∉');                            // true
    /^\p{Script_Extensions=Hiragana}+$/u.test('ひらがな');  // true


The full list of supported Unicode property classes can be found in the current [specification proposal](https://tc39.github.io/proposal-regexp-unicode-property-escapes/#sec-static-semantics-unicodematchproperty-p). For more examples, take a look at [this informative article](https://mathiasbynens.be/notes/es-unicode-property-escapes).

## Lookbehind Assertions

Lookahead assertions have been part of JavaScript’s regular expression syntax from the start. Their counterpart, lookbehind assertions, are finally being [introduced](https://github.com/tc39/proposal-regexp-lookbehind). Some of you may remember that this has been part of V8 for quite some time already. We even use lookbehind asserts under the hood to implement the Unicode flag specified in ES2015.

The name already describes its meaning pretty well. It offers a way to restrict a pattern to only match if preceded by the pattern in the lookbehind group. It comes in both matching and non-matching flavors:

    /(?<=\$)\d+/.exec('$1 is worth about ¥123');  // ['1']
    /(?<!\$)\d+/.exec('$1 is worth about ¥123');  //['123']


For more details, check out our [previous blog post](https://v8project.blogspot.com/2016/02/regexp-lookbehind-assertions.html) dedicated to lookbehind assertions, and examples in related [V8 test cases](https://github.com/v8/v8/blob/master/test/mjsunit/harmony/regexp-lookbehind.js).

## 致谢

This blog post wouldn’t be complete without mentioning some of the people that have worked hard to make this happen: especially language champions [Mathias Bynens](https://twitter.com/mathias), [Dan Ehrenberg](https://twitter.com/littledan), [Claude Pache](https://github.com/claudepache), [Brian Terlson](https://twitter.com/bterlson), [Thomas Wood](https://twitter.com/IgnoredAmbience), Gorkem Yakin, and Irregexp guru [Erik Corry](https://twitter.com/erikcorry); but also everyone else who has contributed to the language specification and V8’s implementation of these features.

We hope you’re as excited about these new regular expression features as we are!



---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
