> * 原文地址：[Rules for Autocomplete](http://jeremymikkola.com/posts/2019_03_19_rules_for_autocomplete.html)
> * 原文作者：[Jeremy](http://jeremymikkola.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/rules-for-autocomplete.md](https://github.com/xitu/gold-miner/blob/master/TODO1/rules-for-autocomplete.md)
> * 译者：
> * 校对者：

# Rules for Autocomplete

Autocompleting text with known values seems like an easy problem to solve, but so so so many UIs get it wrong. I see this frequently enough that, rather than complain about them individually, I though I’d just write down the set of rules they often break.

There may be cases where some of these rules aren’t the best thing to do, but there should be a good reason for breaking one of these rules (for example, some of these rules don’t apply if a field must be filled with a value from a fixed set, like the list of US states). Following these rules should always result in at very least a sane experience:

*   Exact matches always come first. If the user types in an option exactly, other options must always go below the one matching what they typed.

*   Besides exact matches, prefix matches come first. If I type “Fr” I want “Fresno” not “San Francisco.”

*   After prefix matches, it can fall back to substring matches. Starting with substring matches would almost always be the wrong thing to do since users start typing words at the beginning not somewhere in the middle.

*   If there are no substring matches, it can optionally fall back to subsequence matching. This is only useful in some cases.

*   If there are no subsequence/substring matches, it can optionally fall back to approximate matches. This is rarely necessary to provide.

*   Matches should be sorted alphabetically.

*   When one option is the prefix of another, put the _shortest one first_.

*   The matching should probably be case insensitive unless there are two options that differ only by case. In that case (pun intended), prefer the one that more closely matches the user’s input.

*   The action to make use of the selection (e.g. to search the term) must be a different key than the action to accept the first suggestion _unless_ you have to do something first to start using autocomplete suggestions (e.g. hit the down arrow). The user should never have to take extra steps to _not_ use autocomplete.

*   The tab key should always accept the current autocomplete option, if there is one (whether it is highlighted in a dropdown or suggested inline).

*   If an autocomplete selection is highlighted, pressing enter should always make use of that selection. It should never revert to a default selection, even if part of the page is loading. If something is still loading, it is better to ignore the enter press than to navigate to the wrong destination.

*   Autocomplete should almost never activate on keypresses when the field using autocomplete is not focused.

*   The results should come in <100ms in the common case.

*   It’s OK to pause autocompleting when the user is rapidly typing additional letters, but don’t show results from the middle of that burst of letters after the user has finished typing. It’s better to wait longer and change the results once than to show results that appear finished but aren’t. (I admit that this rule is quite subjective.)

*   If an option is highlighted, never change it, even if new data is loaded.

There are some optional features that make sense in certain kinds of autocompletion and not others. I’m sure there are more correct names for these features than what I listed.

*   Show options I’ve used before when I focus the field but haven’t entered anything yet.

*   Autocompletion to the nearest ambiguous prefix. If I type “g” and that matches both “Google” and “GoodReads”, this operation would fill in the two “o”s, allowing me to then type either “g” or “d” to select the option I want.

*   Multipart matching. This is useful for autocompleting file paths, where I might enter “e/b/a” to autocomplete “env/bin/activate”. `ZSH` does this well.

*   Recursive matching. Since autocompletion sometimes serves dual purpose as a quick way to browse options, sometimes you want to start with a broad filter and then search within those results. For example, if I enter “.pdf” to see all pdf files, I can then hit some key (perhaps comma) to start searching within those results, even though what I am now typing actually appears in the name _before_ what I typed previously.

*   Spelling correction. This tends to be useful in search engines.

*   Aliases. When trying to autocomplete a username, the person’s first/last name could be allowed to autocomplete to their username. The same goes for state abbreviations suggesting the full state.

*   Additional information in the results. If you are autocompleting function names, it is nice to see a list of the arguments they take.

*   Context-aware suggestions. This is useful when autocompleting code or a word (usually on a mobile phone) where the context is very predictive of what the desired result is likely to be.

*   Make it possible to go back to what I’ve typed after accepting an autocomplete suggestion. (The up arrow key tends to be a nice way to allow this.)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
