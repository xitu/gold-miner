> * 原文地址：[Should You Compile Your JavaScript Code?](https://blog.bitsrc.io/should-you-compile-your-javascript-code-a857ad2e3032)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/should-you-compile-your-javascript-code.md](https://github.com/xitu/gold-miner/blob/master/article/2021/should-you-compile-your-javascript-code.md)
> * 译者：
> * 校对者：

# Should You Compile Your JavaScript Code?

#### Are you missing out by not having native performance on your code?

![Image by [seznandy](https://pixabay.com/users/seznandy-15803435/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=5093898) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=5093898)](https://cdn-images-1.medium.com/max/3840/1*_7N-LnDFVgKcgEgzczZVmg.jpeg)

We all know and love (?) JavaScript, and we all just work with it by writing code and then executing it in our favorite runtime (namely the browser, node.js and Deno). But have you ever compiled it?

Wait, let’s back up for a second, JavaScript is a dynamic language, we all know that. It is also interpreted (well, mostly) and out of the usual runtimes, all of them use a [JIT compiler](https://blog.bitsrc.io/the-jit-in-javascript-just-in-time-compiler-798b66e44143) to optimize it during execution.

That’s a fact.

But can it be compiled? That’s a whole different deal. Compiling a dynamic language ahead of time (what is also known as AOT or Ahead-Of-Time compilation) is possible, yes, but is it worth it?

---

## AOT vs JIT

**Let me quickly go into a bit more detail about AOT and JIT, because otherwise, this article would just be too short (and well, these are relevant topics that you might find useful as well).**

The main difference between AOT and JIT is clearly in the moment they take place. While AOT is done before the execution of your code, JIT happens **during** that same execution. What else is different?

Almost everything else really.

AOT is usually meant for statically typed languages because for them, there is no dynamic behavior that needs to be examined and determined during execution. All the rules are laid out right there in the code, so the compiler can read it, understand how data flows internally and optimize accordingly, while at the same time, translating the code into a native interpretation (also known as machine code).

The JIT compiler, on the other hand, is meant to be used with dynamically typed languages, because it takes care of monitoring your code’s execution and based on the type of data it’s handling, it’ll optimize and create better machine code.

If you think about both cases in terms of Time-To-Optimize the compiled code, the AOT way will give you an optimized version of your code from the start. You’ll start your execution with an optimal version of it. While on the other hand, your JIT’ed code will take a while to pick-up speed, but it can potentially go further and better because [as you can read here](https://blog.bitsrc.io/the-jit-in-javascript-just-in-time-compiler-798b66e44143), there are other aspects to optimized during runtime than just the type definitions (aspects such as function calls can only be analyzed during execution).

There are definitely pros and cons for each one, but if I had to summarize and decide which one was better, I’d say:

* Go for an AOT alternative if your code is meant to run for a short time.
* Go for the JIT version on the cases when your code runs for longer periods, thus allowing for potentially better optimizing after some runtime analysis is done.

---

## But what about compiling your JavaScript code?

Again, there is a reason why JavaScript is interpreted and JIT’ed and not directly compiled into native code: the dynamic nature of the language lends itself much better to a Just-In-Time compilation strategy.

Careful though, I’m not referring to [WebAssembly](https://blog.bitsrc.io/whats-wrong-with-web-assembly-3b9abb671ec2) here. In that case, WASM is compiling any code (C, C++, or any other) into a Javascript runtime-compatible native code. That is not the same as compiling JavaScript.

To be honest, there aren’t many projects out there trying to compile JavaScript into native machine code, because I’m sure it can prove to be quite a task, I mean, just consider compiling the following code:

```JavaScript
let result = null;

if(my_complex_function()) {
  result = 10;
} else {
  result = "something else"
}

console.log("The result is " + result)
```

Can you really know the type of the `result` variable ahead of time? You probably need to take into consideration all potential types and dynamically define different alternatives that will adapt during runtime. However you solve it, you’d be adding a lot of logic on top of the execution, just to be able to execute it. That doesn’t sound too performant.

There is a project however, that is trying to achieve this, despite not being ideal (at least on paper): [NectarJS](https://github.com/NectarJS/nectarjs)

---

## Compiling with NectarJS

This project aims to compile JavaScript into native code so you can run it on any compatible platform. Right now, that list includes Windows, Linux, Arduino, [STM32 Nucleo](https://www.st.com/en/evaluation-tools/stm32-nucleo-boards.html), Android, Web ([WASM](https://blog.bitsrc.io/whats-wrong-with-web-assembly-3b9abb671ec2?source=your_stories_page-------------------------------------)), macOS and SunOS.

While it is true that most of these platforms already have an interpreter that you can run your JavaScript with, the aim is to make the final compiled output more performant than the currently available options.

According to their results, they have already made some improvements on Windows using Node.js (v12). Not necessarily improving speed in some situations, but rather the memory footprint and even the output file-size.

![Table taken from NectarJS’ site](https://cdn-images-1.medium.com/max/3036/1*HyX7ShDvXey6u9mo9_3ezg.png)

Granted, the project stills has its limitations, especially the fact that as of now, it only supports around 80% of ES3, which means the JS you can write is very limited and not up to today’s standards.

But then again, it might not be required for you to write ES6-compatible code for your particular project, and having the ability to compile it and run it natively on your Arduino board might come-in very handy.

#### Installing and testing NectarJS

The project can be installed directly as an NPM module, so all you have to do, is run the following line (assuming you already have Node installed, of course):

```
$ npm install nectarjs -g
```

After installation, and provided you have the [requirements installed](https://github.com/NectarJS/nectarjs/blob/master/docs/ADVANCED_USAGE.md#requirements-and-compilation), you can write a basic HelloWorld example and compile it:

```JavaScript
console.log("Hello compiled world!")
```

To compile it, simply use the following command:

```
$ nectar your-file.js
```

Here is the output I get when I run it on my OSX:

![](https://cdn-images-1.medium.com/max/2028/1*7i_ihlwJ8Kx49n7v3wrePw.png)

Notice the file created without an extension, that is the binary file. If you give it execution permissions, you’re ready to execute it. That simple, and it works.

---

## Is this the future of JavaScript?

Personally, I wouldn’t bet on it. The project itself seems to still be at its early age, having its documentation unfinished, and only partial support for an older version of the language. However, it’s under active development and these things can change very soon.

As for the practice of compiling your JavaScript, I don’t think it’ll become a big trend, after all, the current runtimes have already proven to be good enough for their most common use cases. Can it be useful for a niche audience that is looking to have native performance and is not willing to switch to another technology? Absolutely, this is just another example of how versatile JavaScript can be.

Would you consider compiling your JS code? Leave a comment with your thoughts!

---

#### Share your components between projects using Bit (Github).

Bit makes it simple to author, document, and share independent components across web projects.

Use Bit to maximize code reuse, speed-up delivery, and build apps that scale.

[**Bit**](https://bit.dev/) supports Node, TypeScript, React, Vue, Angular, and more.

![Exploring shared components shared on [Bit.dev](https://bit.dev)](https://cdn-images-1.medium.com/max/2000/1*T6i0a9d9RykUYZXNh2N-DQ.gif)
[**The shared component cloud**
**Bit is a scalable and collaborative way to build and reuse components. It's everything you need from local development…**bit.dev](https://bit.dev)

---

## Related Stories
[**The JIT in JavaScript: Just In Time Compiler**
**Understanding JS interpreters and just-in-time compilers — using that to write a more optimized code.**blog.bitsrc.io](https://blog.bitsrc.io/the-jit-in-javascript-just-in-time-compiler-798b66e44143)
[**Introduction to Aleph - The React Framework in Deno**
**Aleph is a JavaScript framework that offers you the best developer experience in building modern web applications with…**blog.bitsrc.io](https://blog.bitsrc.io/introduction-to-aleph-the-react-framework-in-deno-322ec26d0fa9)
[**A Deep Dive Into JavaScript Modules**
**Understanding the various JavaScript module types.**blog.bitsrc.io](https://blog.bitsrc.io/a-deep-dive-into-javascript-modules-550ad88d8839)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
