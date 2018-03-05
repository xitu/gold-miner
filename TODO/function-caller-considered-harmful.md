> * 原文地址：[function.caller considered harmful](https://medium.com/@bmeurer/function-caller-considered-harmful-45f06916c907)
> * 原文作者：[Benedikt Meurer](https://medium.com/@bmeurer?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/function-caller-considered-harmful.md](https://github.com/xitu/gold-miner/blob/master/TODO/function-caller-considered-harmful.md)
> * 译者：
> * 校对者：

# function.caller considered harmful

Today I received this question from Microsoft’s Patrick Kettner, which I realized is a question that I answered fairly often already, but usually in a slightly different form.

![Snipaste_2018-03-05_14-09-37.png](https://i.loli.net/2018/03/05/5a9cdf3029af2.png)

As it turned out, I even misunderstood the question in the first place and so I didn’t pay close attention to it anymore after other folks started to respond on Twitter.

![Snipaste_2018-03-05_14-10-35.png](https://i.loli.net/2018/03/05/5a9cdf5faff49.png)

But later Patrick pinged me again, and I finally realized that he wasn’t particularly interested in arguments.caller, but rather the magical “caller” property on function objects — sloppy function objects to be exact.

Historically some JavaScript implementations provided a magical foo.caller property, which would return the function that called foo. This had all kinds of problems, for example it would present a security issue with cross realm calls, and an implementation of this in a sophisticated JavaScript engine is neither very efficient, nor easy to maintain and test, plus optimizations like inlining, or escape analysis and scalar replacement of closures can even make this impossible, or even worse, the presence of the magical “caller” accessor can make these optimizations impossible.

* * *

All of this magic is limited to sloppy mode functions. Strict mode functions have an accessor installed for “caller” via [AddRestrictedFunctionProperties](https://tc39.github.io/ecma262/#sec-addrestrictedfunctionproperties) that just throws a TypeError on each property access.

![](https://cdn-images-1.medium.com/max/800/1*c_2sPWSdvAKKPq1Lz9BD7A.png)

For sloppy mode functions, the current EcmaScript specification is pretty vague and basically allows almost everything. In section [16.2 Forbidden Extensions](https://tc39.github.io/ecma262/#sec-forbidden-extensions) it says:

> If an implementation extends non-strict or built-in function objects with an own property named “caller” the value of that property, as observed using [[Get]] or [[GetOwnProperty]], must not be a strict function object. If it is an accessor property, the function that is the value of the property’s [[Get]] attribute must never return a strict function when called.

So “caller” property of sloppy mode function is more or less completely implementation defined behavior. The only restriction is that if it yields a value, then that value must not be a strict mode function. So it’d be perfectly valid to install a value 42 as default “caller” on sloppy mode functions. Obviously implementations don’t do that — although it’s tempting to add that to V8 to really discourage everyone from using foo.caller nowadays.

* * *

So here’s how we currently implement the (mis)feature in V8 — and thereby how it works in Chrome and Node.js. The “caller” property on sloppy mode functions is a special accessor [FunctionCallerGetter](https://cs.chromium.org/chromium/src/v8/src/accessors.cc?type=cs&l=1044) implemented in accessors.cc, with the core logic being [FindCaller](https://cs.chromium.org/chromium/src/v8/src/accessors.cc?type=cs&l=1000) in the same file. It’s arguably difficult to understand the underlying rules, so here’s what we do in a nutshell when you access foo.caller for a sloppy mode function foo:

1.  We try to find the most recent activation of function foo, i.e. the last invocation of foo that didn’t return to it’s caller yet.
2.  If there’s no current activation of foo, we return null immediately.
3.  If there’s an activation, we apply some voodoo magic to find the parent activation, looking through top level code non-user JavaScript activations.
4.  If there’s no parent activation according to these rules, we return null.
5.  Otherwise if there’s a parent activation, but it’s either a strict mode function or we don’t have access to it — i.e. it’s a function from a different realm — then we also return null.
6.  Otherwise we return the closure from the parent activation.

Here’s a simple example of how it works:

![](https://cdn-images-1.medium.com/max/800/1*ulOC-6Xuiy9FGDKk19ge0A.png)

Now that you have a basic understanding of how foo.caller works, I strongly recommend that you never use it again. As said above, it’s basically a _best effort_ feature. We might continue to support it for a while, but as with arguments.caller that was mentioned in [crbug.com/691710](https://bugs.chromium.org/p/chromium/issues/detail?id=691710), we might also just remove it at some point — for example because we want to be able to escape analyze closures and do scalar replacement for them — so don’t rely on it — obviously also because other JavaScript engines might not support it anyways.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
