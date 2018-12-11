> * 原文地址：[Misunderstanding ES6 Modules, Upgrading Babel, Tears, and a Solution](https://blog.kentcdodds.com/misunderstanding-es6-modules-upgrading-babel-tears-and-a-solution-ad2d5ab93ce0)
> * 原文作者：[Kent C. Dodds](https://blog.kentcdodds.com/@kentcdodds?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/misunderstanding-es6-modules-upgrading-babel-tears-and-a-solution.md](https://github.com/xitu/gold-miner/blob/master/TODO1/misunderstanding-es6-modules-upgrading-babel-tears-and-a-solution.md)
> * 译者：
> * 校对者：

# Misunderstanding ES6 Modules, Upgrading Babel, Tears, and a Solution

![](https://cdn-images-1.medium.com/max/2000/1*2WG0tvoYhuwTt25y5B8IlA.png)

Those are supposed to be tears…

On [October 29th, 2015](http://babeljs.io/blog/2015/10/29/6.0.0/), [Sebastian McKenzie](https://medium.com/@sebmck), [James Kyle](https://medium.com/@thejameskyle), and the rest of the Babel team dropped a huge major release for frontend developers everywhere: Babel 6.0.0. It’s totally awesome. No longer just a transpiler, it’s now a super pluggable JavaScript tooling platform. As a community, we’ve only scratched the surface of what it is capable of and I’m excited (and cautiously optimistic) for what the future holds in JavaScript tooling.

All of that said, Babel 6.0.0 was an enormous breaking change. It had a bit of a rocky start. It’s not entirely straightforward to upgrade and takes some learning. This post isn’t going to talk about how you upgrade Babel, necessarily. I’m just going to touch on what I learned about my own code when Babel fixed a bug I relied on heavily… Here are some resources I recommend you check out before you try to upgrade your stuff from Babel 5 to Babel 6:

* [**Clearing up the Babel 6 Ecosystem**: With the somewhat recent release of Babel 6 comes a fairly dramatic shift from the older versions in that every...](https://medium.com/p/c7678a314bf3 "https://medium.com/p/c7678a314bf3")

* [**Quick guide: how to update Babel 5.x -> 6.x**: Recently Babel 6 was released.](https://medium.com/p/d828c230ec53 "https://medium.com/p/d828c230ec53")

#### ES6 Modules

Upgrading for me would not have been that difficult if I had understood the ES6 Modules specification correctly. Babel 5 allowed misuse of _export_ and _import_ statements and Babel 6 fixed this problem. At first I thought this may be a bug. I asked about it on [Stack Overflow](http://stackoverflow.com/q/33505992/971592) and [Logan Smyth](https://medium.com/@loganfsmyth) informed me that I fundamentally misunderstood ES6 modules and that Babel 5 had facilitated that misunderstanding (writing a transpiler is hard).

#### Near-midlife crisis

At first, I didn’t quite understand what Logan meant, but when I had the time to dedicate to upgrading my app, this happened:

> Am I crazy? Is this invalid ES6? export default { foo: 'foo', bar: 'bar', }
> 
> — [@kentcdodds](https://twitter.com/kentcdodds/status/671817302430515200)

[Tyler McGinnis](https://medium.com/@tylermcginnis), [Josh Manders](https://medium.com/@joshmanders), and I went back and forth quite a bit on this thread. It’s probably hard to follow, but this is when I realized that the problem wasn’t exporting the object as a default, but how I expected that I could import the object.

I always assumed that I could export an object as the default and then destructure the pieces out of that object I needed, like so:

```
// foo.js
const foo = {baz: 42, bar: false}
export default foo

// bar.js
import {baz} from './foo'
```

Babel 5 allowed this because of how it transpiled the export default statement. However this is technically incorrect according to the spec which is why Babel 6 (correctly) removed that capability and effectively broke over 200 of my modules in my application at work.

I finally figured out how things really work when I reviewed [Nicolás Bevacqua’s](https://twitter.com/nzgb) [blogpost](https://ponyfoo.com/articles/es6)

> Also, huge thanks to [@nzgb](http://twitter.com/nzgb)'s amazing 350 bullet points on ES6 because it is incredibly clear [https://ponyfoo.com/articles/es6#modules](https://ponyfoo.com/articles/es6#modules) ... [@rauschma](http://twitter.com/rauschma)
>
> — [@kentcdodds](https://twitter.com/kentcdodds/status/671831027787038721)

And I discovered why what I had been doing wouldn’t work when I read [Axel Rauschmayer](https://medium.com/@rauschma)’s [blogpost](http://www.2ality.com/2014/09/es6-modules-final.html)

> I need to thank [@rauschma](http://twitter.com/rauschma) for saving me from an early mid-life crisis with ES6 modules. I'm probably too invested in this....
>
> — [@kentcdodds](https://twitter.com/kentcdodds/status/671830544129265664)

Here’s the basic idea: ES6 modules are supposed to be statically analyzable (runtime cannot change the exports/imports) so it can’t be dynamic. In the example above, I could change the _foo_ object’s properties at runtime and then my _import_ statement could import that dynamic property, like this:

```
// foo.js
const foo = {}
export default foo
somethingAsync().then(result => foo[result.key] = result.value)

// bar.js
import {foobar} from './foo'
```

We’ll assume that _result.key_ is ‘foobar’. In CommonJS this would work just fine because the require statements happen at runtime (when they’re required):

```
// foo.js
const foo = {}
module.exports = foo
somethingAsync().then(result => foo[result.key] = result.value)

// bar.js
const {foobar} = require('./foo')
```

> However, because the ES6 specification states that imports and exports must be statically analyzable, you can’t accomplish this dynamic behavior in ES6.

So that’s the _why_ for Babel’s change. It’s no longer possible to do this and that’s a good thing.

#### What does this mean?

_Coming up with a good way to describe this in prose has proven difficult, so I hope a bunch of code examples and comparisons will be instructive_

The problem I had was I was combining ES6 _exports_ with CommonJS _require_. I would do something like this:

```
// add.js
export default (x, y) => x + y

// bar.js
const three = require('./add')(1, 2)
```

With the changes that Babel made, I had three choices:

**Option 1:** require with default

```
// add.js
export default (x, y) => x + y

// bar.js
const three = require('./add').default(1, 2)
```

**Option 2:** ES6 modules 100%

```
// add.js
export default (x, y) => x + y

// bar.js
import add from './add'
const three = add(1, 2)
```

**Option 3:** CommonJS 100%

```
// add.js
module.exports = (x, y) => x + y

// bar.js
const three = require('./add')(1, 2)
```

#### How did I fix it?

After a few hours I got the build running and the tests passing. I had two different approaches for different scenarios:

1.  I changed the export to be CommonJS (_module.exports_) rather than ES6 (_export default_) so I could continue to require it as I have been doing.

2.  I did a fancy regex find and replace (should have used a codemod) to change the other require statements from _require(‘./thing’)_ to _require(‘./thing’).default_

This worked out pretty well. The biggest challenge was just understanding how the ES6 modules spec works and how Babel transpiles it down to CommonJS so it can interoperate. Once I figured that out it was just monkey work to update my code to follow this convention.

#### Recommendations

Try to avoid mixing ES6 modules and CommonJS. I personally would say just go with ES6 modules for everything. One of the reasons that I mixed them in the first place was so I could do a one-liner require and immediately use the required module (like _require(‘./add’)(1, 2)_). But that’s really not a big enough benefit IMO.

If you feel like you must combine them, you might consider using one of the following babel plugins/presets:

* [**babel-preset-es2015-node5**: npm is the package manager for javascript](https://www.npmjs.com/package/babel-preset-es2015-node5 "https://www.npmjs.com/package/babel-preset-es2015-node5")

* [**babel-plugin-add-module-exports**: npm is the package manager for javascript](https://www.npmjs.com/package/babel-plugin-add-module-exports "https://www.npmjs.com/package/babel-plugin-add-module-exports")

* * *

#### Conclusion

The real lesson from all of this is that we should learn how things are supposed to work. I could have saved myself a great deal of time if I had just understood how the ES6 module spec actually is intended to work.

You may benefit from this Egghead.io lesson I made demonstrating how to upgrade from Babel 5 to Babel 6:

[https://egghead.io/lessons/angularjs-updating-babel-5-to-6](https://egghead.io/lessons/angularjs-updating-babel-5-to-6)

Also, remember that nobody’s perfect and we’re all learning here :-) See you on [Twitter](https://twitter.com)!

![](https://cdn-images-1.medium.com/max/800/1*Sa8ryLk8EgpsePcRkPfd6w.png)

* * *

#### Appendix…

**More examples:**

Before the change with Babel, a require statement was similar to:

```
import add from './add'
const three = add(1, 2)
```

But after the change in Babel, the require statement now becomes more like:

```
import * as add from './add'
const three = add.default(1, 2)
```

What caused the problem for me was that now the add variable is no longer the default export, but an object that has all the named exports and the default export (under the default key).

**Named Exports:**

It’s notable that you can also use named exports and I recommend this with utility modules. This will allow you to do the destructuring-like syntax in the import statement (**warning, despite what it looks like it’s not actually destructing due to the static analysis reasons mentioned earlier**). So you could do:

```
// math.js
const add = (x, y) => x + y
const subtract = (x, y) => x - y
const multiply = (x, y) => x * y
export {add, subtract, multiply}

// foo.js
import {subtract, multiply} from './math'
```

This gets really awesome/exciting with [tree shaking](http://www.2ality.com/2015/12/webpack-tree-shaking.html).

Personally, I generally recommend that for a component (like a React component or an Angular service) you’ll want to use default exports (you’re importing a specific thing, single file, single component, you know 😀). But for utility modules you generally have various pure functions that can be used independently. This is a great use case for named exports.

#### One more thing

If you thought this was interesting, you might like to [check out the rest of my blog](https://blog.kentcdodds.com) and [subscribe to my newsletter 💌](https://kcd.im/news) (newsletters are published to my blog 2 weeks after they’re emailed out).

[TestingJavaScript.com](https://testingjavascript.com) Learn the smart, efficient way to test any JavaScript application.

Thanks to [Tyler McG](https://medium.com/@tylermcginnis?source=post_page)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
