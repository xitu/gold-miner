> * 原文地址：[Blazingly fast parsing, part 2: lazy parsing](https://v8.dev/blog/preparser)
> * 原文作者：[https://v8.dev](https://v8.dev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/blazingly-fast-parsing-part-2-lazy-parsing.md](https://github.com/xitu/gold-miner/blob/master/TODO1/blazingly-fast-parsing-part-2-lazy-parsing.md)
> * 译者：
> * 校对者：

# 超快速的分析器（二）：惰性解析

这是 V8 如何尽可能快地解析 JavaScript 系列文章的第二部分。在第一部分中已经讲解了如何让 V8 [扫描器](https://github.com/xitu/gold-miner/blob/master/TODO1/blazingly-fast-parsing-part-1-optimizing-the-scanner.md)更快。

解析是编译器提供的将源代码转换成中间表示的步骤（ V8 中，字节码编译器 [Ignition](https://v8.dev/blog/ignition-interpreter) ）。解析和编译发生在 web 页面开始渲染的关键过程中，而不是在页面渲染期间立即需要提供给浏览器的功能。尽管开发人员可以使用异步和延迟脚本，但这不是一直都能工作的。此外，许多 web 页面只提供某些功能所使用的的代码，在页面个别的运行期间，用户可能根本无法使用这些功能。

急于编译不必要的代码可能带来实际的资源消耗:

* CPU 周期用于创建代码，从而在启动时，实际上延迟了代码的有效性。
* 代码对象占用内存，至少在[字节码刷新](https://v8.dev/blog/v8-release-74#bytecode-flushing)确定当前不需要该代码并允许对其进行垃圾回收之前是这样的。
* 顶层脚本执行完成时，编译的代码最终被缓存在磁盘上，占用磁盘空间。

由于这些原因，素有主流浏览器都实现了“惰性解析”。解析器不是为每个函数都生成一个抽象语法树，然后将其编译为字节码，而是根据实际遇到的函数进行“预解析”，而不是全部都解析。这是通过切换到[预解析器](https://cs.chromium.org/chromium/src/v8/src/parsing/preparser.h?l=921&rcl=e3b2feb3aade83c02e4bd2fa46965a69215cd821)来做到的，它是一个解析器的副本，只做最基本的工作，否则就跳过函数。预解析器验证它跳过函数是语法有效的，并产生正确编译外部函数所需的所有信息。之后调用预解析的函数时，将根据需要，对其进行完全的解析和编译。

## 变量分配

让预解析复杂化的主要问题是变量分配。

处于性能原因考虑，在机器的栈上管理函数的激活。例如，如果一个函数 `g` 使用参数 `1` 和 `2` 调用了函数 `f` ：

```
function f(a, b) {
  const c = a + b;
  return c;
}

function g() {
  return f(1, 2);
  // 这里返回的是 `f` 的指针调用，返回结果指向这儿
  // （因为当 `f` 返回时，它会返回到这里）。
}
```

首先将接收者（比如 `f` 的 `this` 值，就是 `globalThis` ，因为它是一个随意的函数调用）推入栈中，然后是被调用的函数 `f` 。然后参数 `1` 和 `2` 被推入栈。这时函数 `f` 被调用。为了执行调用，我们首先在栈上保存 `g` 的状态：返回的指针（`rip`；我们需要返回什么代码） `f` 以及“帧指针”（`fp`；返回时栈应该是什么样的）。然后我们输入 `f` ，它为局部变量 `c` 分配空间，以及它可能需要的任何临时空间。这确保了函数被调用时如果超出作用域，那么函数使用的数据都会消失：只是简单地从栈中弹出。

![](https://v8.dev/_img/preparser/stack-1.svg)

调用函数 `f` 时的栈布局，在栈上分配参数 `a`、`b` 以及局部变量 `c` 。

这种情形的问题是函数可以引用在函数外部声明的变量。内部函数，可以比创建他们的调用，有效期更长：

```
function make_f(d) { // ← `d` 的声明
  return function inner(a, b) {
    const c = a + b + d; // ← `d` 的引用
    return c;
  };
}

const f = make_f(10);

function g() {
  return f(1, 2);
}
```

在上面的例子中，从 `inner` 到 `make_f` 中声明的局部变量 `d` 的引用在 `make_f` 返回后才计算的。为了实现这一点，使用词法闭包的语言虚拟机在一个称为“上下文”的结构中分配变量的引用，该引用来自堆上的内部函数。

![](https://v8.dev/_img/preparser/stack-2.svg)

调用 `make_f` 时的栈布局，将参数拷贝到分配在堆中的上下文中，以供稍后 `inner` 中捕获 `d` 时使用。

这意味着对于函数中声明的变量，我们需要知道内部函数是否引用了这个变量，以便于决定是在栈中存储，还是在堆分配的上下文中存储。当我们计算一个函数的字面量时，我们分配了一个闭包，它指向函数中的代码和当前上下文：上下文中包含它可能需要访问的变量值。

简单的说，我们至少需要跟踪预解析器中变量的引用。

如果我们只跟踪引用，就会高估变量的引用。在外部函数中声明的变量可以通过内部函数中的重新声明来隐藏，从而使来自内部函数的引用指向内部的声明，而不是外部的声明。如果没有限制的在上下文中保存外部变量，新能就会收到影响。因此，变量分配使预解析合理地执行，我们需要确保预解析的函数正确地跟踪变量引用和声明。

顶层代码是这个规则的一个例外。顶层脚本总是分配堆内存的，因为变量是跨脚本可见的。接近于更好的实现这个架构的一个简单方法是简单的运行预解析器，而不需要跟踪变量来快速解析最顶层函数；并只对内部函数使用完整的解析器，而跳过编译它们这个步骤。虽然这比预解析成本更高，因为我们不必要地构建整个 AST ，但它让我们启动并运行起来了。这些恰好是 V8 在 V8 v6.3 / Chrome 63 之前所做的。

## 告诉预解析器变量的信息

预解析器中的跟踪变量分配和引用非常复杂，因为在 JavaScript 中，从一开始就不清楚部分表达式的含义。例如，假设我们有一个带参数 `d` 的函数 `f` ，它有一个内部函数 `g` ，这个表达式看起来像是引用了 `d`。

```
function f(d) {
  function g() {
    const a = ({ d }
```

它最终可能引用 `d` ，因为我们看到的这些 `token` 是析构赋值表达式的一部分。

```
function f(d) {
  function g() {
    const a = ({ d } = { d: 42 });
    return a;
  }
  return g;
}
```

它也可能最终是一个带有析构参数 `d` 的箭头函数，在这种情况下，`f` 中的 `d` 不会被 `g` 引用。

```
function f(d) {
  function g() {
    const a = ({ d }) => d;
    return a;
  }

  return [d, g];

}
```

最初，我们的预解析器是作为解析器的独立副本来实现的，没有太多共用的东西，这导致两个解析器随着时间的推移而产生不同。通过将解析器和预解析器基于 `ParserBase` 重写，实现[模板递归模式](https://en.wikipedia.org/wiki/Curiously_recurring_template_pattern)，我们设法让其最大可能的共用，同时保持独立副本的性能优势。这大大简化了向预解析器添加所有变量的跟踪，因为大部分实现可以在解析器和预解析器之间共用。

实际上，忽略变量声明和引用甚至顶级函数也是不正确的。ECMAScript 规范要求在第一次解析脚本时检测各种类型的变量冲突。例如，如果一个变量在同一个作用域中被声明两次，那么它就被认为是一个[早期语法错误](https://tc39.github.io/ecma262/#early-error)。因为我们的预解析器只是跳过了变量声明，它将会在准备阶段错误地允许代码通过。这个时候，我们所认为的性能上的优化却违反了规范。但是，现在预解析器正确地跟踪变量，我们消除了这类与变量解析等违反规范的行为，并且没有显著的新能消耗。

## 跳过内部函数

正如之前所讲到的，当第一次调用预解析后的函数时，我们对其进行全面的解析，并将生成 AST 编译为字节码。

```
// 这是顶层作用域
function outer() {
  // 预解析完成
  function inner() {
    // 预解析完成
  }
}

outer(); // 全面解析并且编译 `outer` ，而不是 `inner` 。
```

该函数直接指向外部的上下文，其中包含内部函数需要使用声明变量的值。为了允许函数的延迟编译（并支持调试器），上下文指向一个名为 [`ScopeInfo`](https://cs.chromium.org/chromium/src/v8/src/objects/scope-info.h?rcl=ce2242080787636827dd629ed5ee4e11a4368b9e&l=36) 的元数据对象。`ScopeInfo` 对象描述了在上下文中列出的变量。这意味着在编译器内部函数中，我们可以计算变量在上下文链中的位置。

但是，要计算延迟编译函数本身是否需要上下文，我们需要再次执行作用域解析：我们需要知道嵌套在延迟编译函数中的函数是否引用了延迟函数声明的变量。我们可以通过再次预编译进行计算得出。这正是 V8 在 V8 v6.3 / Chrome 63 之前所实现的。但是这并不是理想的性能优化方法，因为它使源码大小和解析成本之间的关系变成非线性：我们将尽可能多地准备嵌套函数。除了动态程序的自然嵌套之外，JavaScript 打包器通常将代码封装在“[可直接调用的函数表达式](https://en.wikipedia.org/wiki/Immediately_invoked_function_expression)”中，使大多数 JavaScript 程序具有多个嵌套层。

![](https://v8.dev/_img/preparser/parse-complexity-before.svg)

每次重新解析至少会增加解析函数的成本

为了避免非线性性能开销，我们甚至在预解析过程中执行了全局作用域解析。我们存储了足够的元数据，以便以后可以简单的 _跳过_ 内部函数，而不必重新进行预解析。一种方法是存储内部函数引用的变量名。这是大开销的存储，而且要求我们依然进行重复工作：我们已经在预解析期间执行了变量解析。

相反，我们将序列化一些变量，这些变量作为标记每个变量的密集数组被分配。当我们延迟解析一个函数时，预解析器按照其所看到的重新创建变量，并且我们可以简单的将元数据应用于变量。现在这个函数已经被编译了，不再需要变量分配元数据，并且可以进行垃圾回收。由于我们只需要这个函数元数据实际上包含了内部函数，所以大部分函数甚至不需要这个元数据，从而显著降低了内存开销。

![](https://v8.dev/_img/preparser/parse-complexity-after.svg)

通过跟踪已经预解析的函数的元数据，我们可以完全跳过内部函数。

跳过内部函数所带来的性能影响是非线性的，就像重新预解析内部函数的所带来的开销一样。有些站点将所有功能提升到顶级范围内。因为它们的嵌套级别总是 0 ，所以开销也就总是 0 。然而，许多现代的网站，实际上有很深的嵌套功能。在这些站点上，当 V8 v6.3 / Chrome 63 启动该特性时，我们看到了显著的性能提升。主要优点是，如今网站的代码的嵌套深度不再重要：任何函数最多只发生一次预解析，一次完全解析 [\[1\]](#fn1)。

![](https://v8.dev/_img/preparser/skipping-inner-functions.svg)

主线程和非主线程解析时间，启动前后的“跳过内部函数”优化。

## Possibly-Invoked 函数表达式

如前所述，打包器通过将模块代码封装在一个它们立即调用的闭包中，将多个模块组合到一个文件中。这为模块间提供了隔离，允许他们像脚本中唯一的代码一样运行。这些函数本质上是嵌套脚本；脚本执行时立即调用这些函数。包装器通常提供 _可直接调用的函数表达式_ (IIFEs; 发音为 “iffies”) 作为括号函数： `(function(){…})()` 。

由于这些函数在脚本执行期间是马上需要用到的，所以预处理这些函数不是最好的方法。在脚本的顶层执行过程中，我们立即需要编译该函数，并完全解析和编译该函数。这意味着，我们在前面尝试加速启动时执行的解析越快，启动时就必然更加地会产生不必要的额外开销。

你可能会问，为什么不简单地编译调用的函数呢？虽然开发人员在调用函数时很容易注意到，但对于解析器则不是这样。解析器需要做决定 —— 甚至在开始解析函数之前！ —— 是否急于编译函数或推迟编译。语法中的歧义使得简单地快速扫描到函数末尾变得困难，而且成本很快就与常规预解析的相类似了。

因此 V8 有两个简单的模式，可以识别为 _possibly-invoked 函数表达式_ (PIFEs; 发音为 “piffies”)，根据这种模式可以更快的解析并编译一个函数：

* 如果函数是带括号的函数表达式，形如 `(function(){…})` ，我们假设它被调用。我们一下就看到这个模式的开始，即 `(function` 。
*   Since V8 v5.7 / Chrome 57 we also detect the pattern `!function(){…}(),function(){…}(),function(){…}()` generated by [UglifyJS](https://github.com/mishoo/UglifyJS2). This detection kicks in as soon as we see `!function`, or `,function` if it immediately follows a PIFE.
* 由于 V8 v5.7 / Chrome 57 ，我们还检测了由 [UglifyJS](https://github.com/mishoo/UglifyJS2) 生成的模式 `!function(){…}(),function(){…}(),function(){…}()` 。我们一看到 `!function`，或 `,function` 如果它紧跟着一个 PIFE 。

Since V8 eagerly compiles PIFEs, they can be used as [profile-directed feedback](https://en.wikipedia.org/wiki/Profile-guided_optimization)[\[2\]](#fn2), informing the browser which functions are needed for startup.

At a time when V8 still reparsed inner functions, some developers had noticed the impact of JS parsing on startup was pretty high. The package [`optimize-js`](https://github.com/nolanlawson/optimize-js) turns functions into PIFEs based on static heuristics. At the time the package was created, this had a huge impact on load performance on V8. We’ve replicated these results by running the benchmarks provided by `optimize-js` on V8 v6.1, only looking at minified scripts.

![](https://v8.dev/_img/preparser/eager-parse-compile-pife.svg)

Eagerly parsing and compiling PIFEs results in slightly faster cold and warm startup (first and second page load, measuring total parse + compile + execute times). The benefit is much smaller on V8 v7.5 than it used to be on V8 v6.1 though, due to significant improvements to the parser.

Nevertheless, now that we don’t reparse inner functions anymore and since the parser has gotten much faster, the performance improvement obtained through `optimize-js` is much reduced. The default configuration for v7.5 is in fact already much faster than the optimized version running on v6.1 was. Even on v7.5 it can still makes sense to use PIFEs sparingly for code that is needed during startup: we avoid preparse since we learn early that the function will be needed.

The `optimize-js` benchmark results don’t exactly reflect the real world. The scripts are loaded synchronously, and the entire parse + compile time is counted towards load time. In a real-world setting, you would likely load scripts using `<script>` tags. That allows Chrome’s preloader to discover the script _before_ it’s evaluated, and to download, parse, and compile the script without blocking the main thread. Everything that we decide to eagerly compile is automatically compiled off the main thread and should only minimally count towards startup. Running with off-the-main-thread script compilation magnifies the impact of using PIFEs.

There is still a cost though, especially a memory cost, so it’s not a good idea to eagerly compile everything:

![](https://v8.dev/_img/preparser/eager-compilation-overhead.svg)

Eagerly compiling _all_ JavaScript comes at a significant memory cost.

While adding parentheses around functions you need during startup is a good idea (e.g., based on profiling startup), using a package like `optimize-js` that applies simple static heuristics is not a great idea. It for example assumes that a function will be called during startup if it’s an argument to a function call. If such a function implements an entire module that’s only needed much later, however, you end up compiling too much. Over-eagerly compilation is bad for performance: V8 without lazy compilation significantly regresses load time. Additionally, some of the benefits of `optimize-js` come from issues with UglifyJS and other minifiers which remove parentheses from PIFEs that aren’t IIFEs, removing useful hints that could have been applied to e.g., [Universal Module Definition](https://github.com/umdjs/umd)\-style modules. This is likely an issue that minifiers should fix to get the maximum performance on browsers that eagerly compile PIFEs.

## Conclusions

Lazy parsing speeds up startup and reduces memory overhead of applications that ship more code than they need. Being able to properly track variable declarations and references in the preparser is necessary to be able to preparse both correctly (per the spec) and quickly. Allocating variables in the preparser also allows us to serialize variable allocation information for later use in the parser so we can avoid having to re-preparse inner functions altogether, avoiding non-linear parse behavior of deeply nested functions.

PIFEs that can be recognized by the parser avoid initial preparse overhead for code that’s needed immediately during startup. Careful profile-guided use of PIFEs, or use by packers, can provide a useful cold startup speed bump. Nevertheless, needlessly wrapping functions in parentheses to trigger this heuristic should be avoided since it causes more code to be eagerly compiled, resulting in worse startup performance and increased memory usage.

* * *

1.  For memory reasons, V8 [flushes bytecode](https://v8.dev/blog/v8-release-74#bytecode-flushing) when it’s unused for a while. If the code ends up being needed again later on, we reparse and compile it again. Since we allow the variable metadata to die during compilation, that causes a reparse of inner functions upon lazy recompilation. At that point we recreate the metadata for its inner functions though, so we don’t need to re-preparse inner functions of its inner functions again. [↩︎](#fnref1)
    
2.  PIFEs can also be thought of as profile-informed function expressions. [↩︎](#fnref2)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
