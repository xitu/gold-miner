> * 原文地址：[What Replaces JavaScript](https://medium.com/young-coder/what-replaces-javascript-a6493b4e2d6e)
> * 原文作者：[Matthew MacDonald](https://medium.com/@prosetech)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-replaces-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-replaces-javascript.md)
> * 译者：
> * 校对者：

# What Replaces JavaScript

> JavaScript is flourishing. But thanks to WebAssembly, its death may be just a matter of time.

![At end of the tunnel / [[Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=20180)]](https://cdn-images-1.medium.com/max/2560/1*KYJN2ynQlUSsGuhdpau0_A.jpeg)

Some programming languages are loved. Others are only tolerated. For many programmers, JavaScript is an example of the latter — a language that every front-end developer needs to understand but no one needs to like.

Ten years ago, it wasn’t obvious that JavaScript was set to rule the world. Other platforms, like Java, Flash, and Silverlight were also in the running. All three needed a browser plug-in to do their work, and all three replaced HTML with a different approach to user interface. This approach allowed them to get far in front of JavaScript with features — for example, adding video, animation, and drawing long before we had the `\<video>` element, the CSS Animations specification, or the HTML canvas. But it also spelled their downfall. When mobile browsing exploded and HTML shifted to embrace it, these other platforms became obsolete.

Here’s another irony. At the same time that JavaScript was conquering the world, a tiny seed was planted that may, sometime in the future, spell the end of JavaScript. That seed was an experimental technology called asm.js.

But before we get to that, let’s take a step back to survey the situation today.

## Transpiling: The current approach

As long as we’ve had JavaScript, developers have been trying to get around it. One early approach was to use plug-ins to take the code out of the browser. (That failed.) Another idea was to make development tools that could **convert** code — in other words, take code written in another more respectable language, and transform it into JavaScript. That way developers could get the run-everywhere support they wanted but still keep their hands clean.

The process of converting one language to another is called **transpiling**, and it has some obvious stumbling blocks. High-level languages have different features, syntax, and idioms, and you can’t always map a line in one to an equivalent construct in another. And even when you can, danger lurks. What happens if the community stops developing your favorite transpiler? Or if the transpiler introduces bugs of its own? What if you want to plug into a JavaScript framework like Angular, React, or Vue? And how do you collaborate on a team if you don’t speak the same language?

As in many cases with coding, the tool is only as good as the community behind it.

![](https://cdn-images-1.medium.com/max/2000/1*APeN4y8dugBc7C56ldFT9A.png)

Today, transpilers are common, but they’re almost always used in just one way — to handle backward compatibility.

Developers write the most modern JavaScript possible, and then use a transpiler like [Babel](https://babeljs.io/) to convert their code to the equivalent (but less elegant) old-school JavaScript code that works everywhere. Or — even better — they use TypeScript (a modernized flavor of JavaScript that adds features like strong typing, generics, and non-nullable types) and then transpile **that** into JavaScript. Either way, you’re still playing in the walled garden of JavaScript.

## Asm.js: A stepping stone

The first glimmer of a new possibility came from asm.js, a quirky experiment cooked up by the developers at Mozilla in 2013. They were looking for a way to run high-performance code inside a browser. But unlike plug-ins, asm.js didn’t try to go beside the browser. Instead, it aimed to tunnel straight **through** the JavaScript virtual machine.

At its heart, asm.js is a terse, optimized JavaScript syntax. It runs faster than normal JavaScript because it avoids the slow dynamic parts of the language. But web browsers that recognize it can also apply other optimizations, boosting performance much more dramatically. In other words, asm.js follows the golden rule — **don’t break the web** — while offering a pathway to future improvements. The Firefox team used asm.js, along with a transpiling tool called [Emscripten](https://en.wikipedia.org/wiki/Emscripten), to take real-time 3D games built in C++ and put them inside a web browser, running on nothing more than JavaScript and raw ambition.

![The Unreal engine running on asm.js](https://cdn-images-1.medium.com/max/2000/1*fJ0vTYKZy2na-qFu11d4nQ.png)

The most important part of asm.js was the way it forced developers to rethink the role of JavaScript. Asm.js code **is** JavaScript, but it’s not meant for coders to read or write by hand. Instead, asm.js code is meant to be built by an automated process (a transpiler) and fed straight to the browser. JavaScript is the medium but not the message.

## WebAssembly: A new technology

Although the asm.js experiment produced a few dazzling demos, it was largely ignored by working developers. To them, it was just another interesting piece of over-the-horizon technology. But that changed with the creation of WebAssembly.

WebAssembly is both the successor to asm.js, and a significantly different technology. It’s a compact, binary format for code. Like asm.js, WebAssembly code is fed into the JavaScript execution environment. It gets the same sandbox and the same runtime environment. Also like asm.js, WebAssembly is compiled in a way that makes further efficiencies possible. But now these efficiencies are [more dramatic than before](https://hacks.mozilla.org/2017/02/what-makes-webassembly-fast/), and the browser can skip the JavaScript parsing stage altogether. For an ordinary bit of logic (say, a time-consuming calculation), WebAssembly is far faster than regular JavaScript and nearly as fast as natively compiled code.

![A simplified look at the WebAssembly processing pipeline](https://cdn-images-1.medium.com/max/2000/1*IKpcysxZoB5yYyLV5JmQaQ.png)

If you’re curious what WASM looks like, imagine you have a C function like this:

```
int factorial(int n) {
  if (n == 0)
    return 1;
  else
    return n * factorial(n-1);
}
```

It would compile to WASM code that looks like this:

```
get_local 0
i64.eqz
if (result i64)
    i64.const 1
else
    get_local 0
    get_local 0
    i64.const 1
    i64.sub
    call 0
    i64.mul
end
```

When it’s sent over the wire, WASM code is further condensed into a binary encoding.

WebAssembly is designed to be a target for compilers. You’ll never write it by hand. (But you **could**, if you want to take a [deep-dive exploration](https://blog.scottlogic.com/2018/04/26/webassembly-by-hand.html).)

WebAssembly first appeared 2015. Today, it’s fully supported by the big four browsers (Chrome, Edge, Safari, and Firefox) on desktop and mobile. It isn’t supported in Internet Explorer, although backward compatibility is possible by converting the WebAssembly code to asm.js. (Performance will suffer. Please let IE [fade into obscurity](https://death-to-ie11.netlify.com/)!)

## WebAssembly and the future of web development

Out of the box, WebAssembly gives developers a way to write optimized code routines, usually in C++. This is powerful ability, but it has a relatively narrow scope. It’s useful if you need to improve the performance of complex calculations. (For example, fastq.bio used WebAssembly to [speed up](https://www.smashingmagazine.com/2019/04/webassembly-speed-web-app/) their DNA sequencing calculations.) It’s also important if you’re porting high-performance games or writing an [emulator](https://win95.ajf.me/) that runs inside your browser. If this is all there were to WebAssembly, it wouldn’t be nearly as exciting — and it wouldn’t have any hope of displacing JavaScript. But WebAssembly also opens a narrow pathway for framework developers to squeeze their platforms into the JavaScript environment.

Here’s where things take an interesting turn. WebAssembly can’t sidestep JavaScript, because it’s locked into the JavaScript runtime environment. In fact, WebAssembly needs to run alongside at least **some** ordinary JavaScript code, because it doesn’t have direct access to the page. That means it can’t manipulate the DOM or receive events without going through a layer of JavaScript.

This sounds like a deal-breaking limitation. But clever developers have found ways to smuggle their runtimes in through WebAssembly. For example, Microsoft’s [Blazor](https://dotnet.microsoft.com/apps/aspnet/web-apps/blazor) framework downloads a miniature .NET runtime as a compiled WASM file. This runtime deals with the JavaScript interop, and it provides basic services (like garbage collection) and higher-level features (layout, routing, and user interface widgets). In other words, Blazor uses a virtual machine that lives inside another virtual machine, which is either an Inception-level paradox or a clever way to create a non-JavaScript application framework that runs in the browser.

Blazor isn’t the only WebAssembly-powered experiment that’s out of the gate. Consider [Pyodide](https://hacks.mozilla.org/2019/04/pyodide-bringing-the-scientific-python-stack-to-the-browser/), which aims to put Python in the browser, complete with an advanced math toolkit for data analysis.

**This** is the future. WebAssembly, which started out to satisfy C++, Rust, and not much more, is quickly being exploited to create more ambitious experiments. Soon it will allow non-JavaScript frameworks to compete with JavaScript-based standbys like Angular, React, and Vue.

And WebAssembly is still evolving rapidly. It’s current implementation is a **minimum viable product** — just enough to be useful in some important scenarios, but not an all-purpose approach to developing on the web. As WebAssembly is adopted, it will improve. For example, if platforms like Blazor catch on, WebAssembly is likely to add support for direct DOM access. Browser makers are already planning to add garbage collection and multithreading, so runtimes don’t need to implement these details themselves.

If this path of evolution seems long and doubtful, consider the lessons of JavaScript. First, we saw that if something is possible in JavaScript, it is done. Then, we learned that if something is done often enough, browsers make it work better. And so on. If WebAssembly is popular, it will feed into a virtuous cycle of enhancement that could easily overtake the native advantages of JavaScript.

It’s often said that WebAssembly was not built to replace JavaScript. But that’s true of every revolutionary platform. JavaScript was not designed to replace browser-embedded Java. Web applications were not designed to replace desktop applications. But once they could, they did.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
