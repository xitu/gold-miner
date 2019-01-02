
> * 原文地址：[Upcoming Regular Expression Features](https://developers.google.com/web/updates/2017/07/upcoming-regexp-features)
> * 原文作者：[Jakob Gruber](https://developers.google.com/web/resources/contributors#jgruber)、[Yang Guo](https://developers.google.com/web/resources/contributors#yangguo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/upcoming-regexp-features.md](https://github.com/xitu/gold-miner/blob/master/TODO/upcoming-regexp-features.md)
> * 译者：[sunui](https://github.com/sunui)
> * 校对者：[atuooo](https://github.com/atuooo)、[Tina92](https://github.com/Tina92)

# 即将到来的正则表达式新特性

ES2015 给 JavaScript 语言引入了许多新特性，其中包括正则表达式语法的一些重大改进，新增了 Unicode 编码 （`/u`） 和粘滞位 （`/y`）两个修饰符。而在那之后，发展也并未停止。经过与 TC39（ECMAScript 标准委员会）的其他成员的紧密合作，V8 团队提议并共同设计了让正则表达式更强大的几个新特性。

这些新特性目前已经计划包含在 JavaScript 标准中。虽然提案还没有完全通过，但是它们已经进入 [TC39 流程的候选阶段](https://tc39.github.io/process-document/)了。我们已经以试验功能（见下文）在浏览器实现了这些特性，以便在最终定稿之前提供及时的设计和实现反馈给各自的提案作者。

本文给您预览一下这个令人兴奋的未来。如果您愿意跟着体验这些即将到来的示例，可以在 `chrome://flags/#enable-javascript-harmony` 页面中开启实验性 JavaScript 功能。

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


更糟糕的是，更改一个表达式可能会潜在地转变所有已存在的捕获的索引：

    /(a)(b)(c)\3\2\1/     // 一些简单的有序的反向引用。
    /(.)(a)(b)(c)\4\3\2/  // 所有都需要更新。


命名捕获是一个即将到来的特性，它允许开发者给捕获组分配名称来帮助尽可能地解决这些问题。语法类似于 Perl、Java、.Net 和 Ruby：

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


关于这个新特性的全部详情可以在[规范提案](https://github.com/tc39/proposal-regexp-named-groups)中查看。

## dotAll 修饰符

默认情况下，元字符 `.` 在正则表达式中匹配除了换行符以外的任何字符：

    /foo.bar/u.test('foo\nbar');   // false


一个提案引入了 dotAll 模式，通过 `/s` 修饰符来开启。在 dotAll 模式中，`.` 也可以匹配换行符。

    /foo.bar/su.test('foo\nbar');  // true


关于这个新特性的全部详情可以在[规范提案](https://github.com/tc39/proposal-regexp-dotall-flag)中查看。

## Unicode 属性逃逸（Unicode Property Escapes）

正则表达式语法已经包含了特定字符类的简写。`\d` 代表数字并且只能是 `[0-9]`；`\w` 是单词字符的简写，或者写成 `[A-Za-z0-9_]`。

自从 ES2015 引入了 Unicode，突然间大量的字符可以被认为是数字，例如圈一：①；或者被认为是字符的，例如中文字符：雪。

它们都不会被 `\d` 或 `\w` 匹配。而改变这些简写的含义将会破坏已经存在的正则表达式模式。

于是，新的字串类被[引入](https://github.com/tc39/proposal-regexp-unicode-property-escapes)。注意它们只在使用 `/u` 修饰符的 Unicode-aware 正则表达式中可用。

    /\p{Number}/u.test('①');      // true
    /\p{Alphabetic}/u.test('雪');  // true


排除型字符可以使用 `\P` 匹配。

    /\P{Number}/u.test('①');      // false
    /\P{Alphabetic}/u.test('雪');  // false


统一码联盟还定义了许多方式来分类码位，例如数学符号和日语平假名字符：

    /^\p{Math}+$/u.test('∛∞∉');                            // true
    /^\p{Script_Extensions=Hiragana}+$/u.test('ひらがな');  // true


全部受支持的 Unicode 属性类列表可以在目前的[规范提案](https://tc39.github.io/proposal-regexp-unicode-property-escapes/#sec-static-semantics-unicodematchproperty-p)中找到。更多示例请查看[这篇内容丰富的文章](https://mathiasbynens.be/notes/es-unicode-property-escapes)。

## 后行断言

先行断言从一开始就已经是 JavaScript 正则表达式语法的一部分。与之相对的后行断言也终于将被[引入](https://github.com/tc39/proposal-regexp-lookbehind)。你们中的一些人可能记得，这成为 V8 的一部分已经有一段时间了。我们甚至在底层已经用后行断言实现了 ES2015 规定的 Unicode 修饰符。

“后行断言”这个名字已经很好地描述了它的涵义。它提供一个方式来限制一个正则，只有后行组匹配通过之后才继续匹配。它提供匹配和非匹配两种选择：

    /(?<=\$)\d+/.exec('$1 is worth about ¥123');  // ['1']
    /(?<!\$)\d+/.exec('$1 is worth about ¥123');  //['123']


更多详细信息，查看我们[之前的一篇博文](https://v8project.blogspot.com/2016/02/regexp-lookbehind-assertions.html)，专门介绍了后行断言。相关示例可以查看[V8 测试用例](https://github.com/v8/v8/blob/master/test/mjsunit/harmony/regexp-lookbehind.js)。

## 致谢

本文的完成有幸得到了很多相关人士的帮助，他们的辛勤工作造就了这一切：特别是语言之王[Mathias Bynens](https://twitter.com/mathias)、[Dan Ehrenberg](https://twitter.com/littledan)、[Claude Pache](https://github.com/claudepache)、[Brian Terlson](https://twitter.com/bterlson)、[Thomas Wood](https://twitter.com/IgnoredAmbience)、Gorkem Yakin、和正则大师 [Erik Corry](https://twitter.com/erikcorry)；还有为语言规范作出努力的每一个人以及 V8 团队对这些特性的实施。

希望您能像我们一样为这些新的正则表达式特性而感到兴奋！



---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
