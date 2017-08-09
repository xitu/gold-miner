
  > * 原文地址：[Towards a JavaScript Binary AST](https://yoric.github.io/post/binary-ast-newsletter-1/)
  > * 原文作者：[Yoric](https://yoric.github.io/about/)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/binary-ast-newsletter-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/binary-ast-newsletter-1.md)
  > * 译者：
  > * 校对者：

  # Towards a JavaScript Binary AST

  In this blog post, I would like to introduce the JavaScript Binary AST, an
ongoing project that we hope will help make webpages load faster, along with
a number of other benefits.

# A little background

Over the years, JavaScript has grown from one of the slowest scripting languages
available to a high-performance powerhouse, fast enough that it can run desktop,
server, mobile and even embedded applications, whether through web browsers or
other environments.

As the power of JavaScript has grown, so has the complexity of applications
and their size. Whereas, twenty years ago, few websites used more than a few
Kb of JavaScript, many websites and non-web applications now need to deliver
and load several Mb of JavaScript before the user can start actually using
the site/app.

While the sound of “several Mb of JavaScript” may sound odd, recall that a
native application such as Steam weighs 3.1Mb (pure binary, without resources, without
debugging symbols, without dynamic dependencies, measured on my Mac),
Telegram weights 11Mb and the Opera *updater* weighs 5.8Mb. I’m not adding the
size of a web browser, because web browsers are architected essentially
from dynamic dependencies, but I expect that both Firefox and Chromium
weigh 100+ Mb.

Of course, large JavaScript source code has several costs, including:

- heavy network transfers;
- slow startup.

We have reached a stage at which the simple duration of parsing the JavaScript
source code of a large web application such as Facebook can easily last
500ms-800ms on a fast computer – that’s *before* the JavaScript code can be
compiled to bytecode and/or interpreted.
There is very little reason to believe that JavaScript
applications will get smaller with time.

So, a joint team from Mozilla and Facebook decided to get started working on a novel mechanism
that we believe can dramatically improve the speed at which an application can
start executing its JavaScript: the Binary AST.

# Introducing the Binary AST

The idea of the JavaScript Binary AST is simple: instead of sending text source
code, what could we improve by sending *binary* source code?

Let me clarify: the Binary AST source code is equivalent to the text
source code. It is *not* a new programming language, or a subset of
JavaScript, or a superset of JavaScript, it *is* JavaScript.
It is *not* a bytecode, rather a binary representation of the source
code. If you prefer, this Binary AST representation is a form of *source
compression*, designed specifically for JavaScript, and optimized to
improve parsing speed. We are also building a decoder that provides a perfectly
readable, well-formatted, source code. For the moment, the format does not
maintain comments, but there is a proposal to allow comments to be maintained.

Producing a Binary AST file will require a build step and we hope that, in time,
build tools such as WebPack or Babel will be able to produce Binary AST files,
hence making switching to Binary AST as simple as passing a flag to the build
chains already used by many JS developers.

I plan to detail the Binary AST, our benchmarks and our current status it in
future blog posts. For the moment, let me just mention that early experiments
suggest that we can both obtain very good source compression and considerable
parsing speedups.

We have been working on Binary AST for a few months now and the project was
just accepted as a Stage 1 Proposal at at ECMA TC-39. This is encouraging, but
it will take time until you see implemented in all JavaScript VMs and toolchains.

# Comparing with…

## …compression formats

Most webservers already send JavaScript data using a compression format such as
gzip or brotli. This considerably reduces the time spent waiting for the data.

What we’re doing here is a format specifically designed for JavaScript. Indeed,
our early prototype uses gzip internally, among many other tricks,
and has two main advantages:

- it is designed to make *parsing* much faster;
- according to early experiments, we beat gzip or brotli by a large margin.

Note that our main objective is to make parsing faster, so in the future, if we
need to choose between file size and parsing speed, we are most likely to pick
faster parsing. Also, the compression formats used internally may change.

## …minifiers

The tool traditionally used by web developers to decrease the size of JS files
is the minifier, such as UglifyJS or Google’s Closure Compiler.

Minifiers typically remove unused whitespace and comments, rewrite variable
names to shorten then, and use a number of other transformations to make the
program shorter.

While these tools are definitely useful, they have two main shortcomings:

- they do not attempt to make parsing faster – indeed, we have witnessed a
number of cases in which minification accidentally makes parsing slower;
- they have the side-effect of making the JavaScript code much harder to read,
including renaming unreadable names to variables and functions,
using exotic features to pack variable declarations, etc.

By opposition, the Binary AST transformation:

- is designed to make parsing faster;
- maintains the source code in such a manner that it can be easily decoded
and read, with all variable names, etc.

Of course, obfuscation and Binary AST transformation can be combined for
applications that do not wish to keep the source code readable.

## …WebAssembly

Another exciting web technology designed to improve performance in certain
cases is WebAssembly (or wasm). wasm is designed to let native applications
be compiled in a format that can both be transferred efficiently, parsed
quickly and executed at native speed by the JavaScript VM.

By design, however, wasm is limited to native code, so it doesn’t work
with JavaScript out of the box.

I am not aware of any project that achieves compilation of JavaScript to wasm.
While this would certainly be feasible, this would be a rather risky undertaking,
as this would involve developing a compiler that is at least as complex as a
new JavaScript VM, while making sure that it is still compatible with
JavaScript (which is both a very tricky language and a language whose
specifications are clarified or extended at least once per year). Of course,
this task ends up useless if the resulting code is slower than today’s JavaScript
VMs (which tend to be really, really fast) or so large that it makes startup
prohibitively slow (because that’s the problem we are trying to solve here)
or if it doesn’t work with existing JavaScript libraries or (for browser
applications) the DOM.

Now, exploring this would definitely be an interesting work, so if anybody
wants to prove us wrong, by all means, please do it :)

## …improving caching

When JavaScript code is downloaded by a browser, it is stored in the browser’s
cache, so as to avoid having to re-download it later. Both Chromium and Firefox
have recently improved their browsers to be able to cache not just the JavaScript
source code but also the bytecode, hence side-stepping nicely the issue of
parse time for the second load of a page. I have no idea of the status of
Safari or Edge on the topic, so it is possible that they may have comparable
technologies.

Congratulation to both teams, these technologies are great! Indeed, they nicely
improve the performance of reloading a page. This works very well for pages that
have not updated their JavaScript code since the last time they were accessed.

The problem we are attempting to solve with Binary AST is different:
while we all have some pages that we visit and revisit often,
there is a larger number of pages that we visit for the first time,
in addition to the pages that we revisit but that that have been updated since
our latest visit. In particular, a
growing number of applications get updated very, very often – for instance, Facebook
ships new JavaScript code several times per day, and I would be surprised if
Twitter, LinkedIn, Google Docs et al didn’t follow similar practices. Also, if
you are a JS
developer shipping a JavaScript application – whether web or otherwise – you
want the first contact between you and your users to be as smooth as possible,
which means that you want the first load (or first load since update) to be very
fast, too.

These are problems that we address with Binary AST.

# What if…

## …we improved caching?

Additional technologies have been discussed to let browsers prefetch and
precompile JS code to bytecode.

These technologies are
definitely worth investigating and would also help with some of the scenarios
for which we are developing Binary AST – each technology improving the other.
In particular, the better resource-efficiency of Binary AST would thus help
limit the resource waste when such technologies are misused, while also
improving the cases in which these techniques cannot be used at all.

## …we used an existing JS bytecode?

Most, if not all, JavaScript Virtual Machines already use an internal
representation of code as JS bytecode. I seem to remember that at least
Microsoft’s Virtual Machine supports shipping JavaScript bytecode for
privileged application.

So, one could imagine browser vendors exposing their bytecode and letting
all JS applications ship bytecode. This, however, sounds like a pretty bad
idea, for several reasons.

The first one affects VM developers. Once you have exposed your internal
representation of JavaScript, you are doomed to maintain it. As it turns out,
JavaScript bytecode changes regularly, to adapt to new versions of the language
or to new optimizations. Forcing a VM to keep compatibility with an old version
of its bytecode forever would be a maintenance and/or performance disaster, so
I doubt that any browser/VM vendor will want to commit to this, except perhaps
in a very limited setting.

The second affects JS developers. Having several bytecodes would mean
maintaining and shipping several binaries – possibly several dozens if you want to
fine-time optimizations to successive versions of each browser’s bytecode. To
make things worse, these bytecodes will have different semantics, leading to
JS code compiled with different semantics.
While
this is in the realm of the possible – after all, mobile and native developers
do this all the time – this would be a clear regression upon the current JS landscape.

## …we had a standard JS bytecode?

So what if the JavaScript VM vendors decided to come up with a novel bytecode
format, possibly as an extension of WebAssembly, but designed specifically for
JavaScript?

Just to be clear: I have heard people regretting that such a format did not
exist but I am not aware of anybody actively working on this.

One of the reasons people have not done this yet is that designing and
maintaining bytecode for a language that changes all the time is
quite complicated – doubly so for a language that is already as complex
as JavaScript. More importantly, keeping the interpreted-JavaScript
and the bytecode-JavaScript in touch would most likely be a losing battle,
one that would eventually result in two subtly incompatible JavaScript languages,
something that would deeply hurt the web.

Also, whether such a bytecode
would actually help code size and performance, remains to be demonstrated.

## …we just made the parser faster?

Wouldn’t it be nice if we could *just* make the parser faster? Unfortunately,
while JS parsers have improved considerably, we are long past the point of
diminishing returns.

Let me quote a few steps that simply cannot be skipped or made infinitely
efficient:

- dealing with exotic encodings, Unicode byte order marks and other niceties;
- finding out if this `/` character is a division operator, the start of a
comment or a regular expression;
- finding out if this `(` character starts an expression, a list of arguments
for a function call, a list of arguments for an arrow function, …;
- finding out where this string (respectively string template, array, function,
…) stops, which depends on all the disambiguation issues, …;
- finding out whether this `let a` declaration is valid or whether it
collides with another `let a`, `var a` or `const a` declaration –
which may actually appear later in the source code;
- upon encountering a use of `eval`, determine which of the 4 semantics
of `eval` to use;
- determining how truly local local variables are;
- …

Ideally, VM developers would like to be able to parallelize parsing and/or
delay it until we know for sure that the code we parse is actually used.
Indeed, most recent VMs implement these strategies. Sadly, the numerous
token ambiguities in the JavaScript syntax considerably the opportunities
for concurrency while the constraints on when syntax errors must be thrown
considerably limit the opportunities for lazy parsing.

In either case, the VM needs to perform an expensive pre-parse step that can
often backfire into being slower than regular parsing, typically when applied
to minified code.

Indeed, the Binary AST proposal was designed to overcome the performance
limitations imposed by the syntax and semantics of text source JavaScript.

# What now?

We are posting this blog entry early because we want you, web developers,
tooling developers to be in the loop as early as possible. So far, the
feedback we have gathered from both groups is pretty good, and we are looking
forward to working closely with both communities.

We have completed an early prototype for benchmarking purposes (so, not really
usable) and are working on an advanced prototype, both for the tooling and
for Firefox, but we are still a few months away from something useful.

I will try and post more details in a few weeks time.

For more reading:

- [Bug tracking early experiments in Firefox](https://bugzilla.mozilla.org/show_bug.cgi?id=1349917).
- [ECMA TC-39 Proposal](https://github.com/syg/ecmascript-binary-ast).
- [Tooling](https://github.com/Yoric/binjs-ref) (this is a WIP version of the advanced prototype, but it doesn’t reimplement everything from the early prototype yet).


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  