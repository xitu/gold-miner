> * 原文地址：[Why does console.log() return ‘undefined’?](https://blog.bitsrc.io/why-does-console-log-return-undefined-e06d44b4d0f8)
> * 原文作者：[Daniel Pericich](https://medium.com/@dpericich)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/why-does-console-log-return-undefined.md](https://github.com/xitu/gold-miner/blob/master/article/2022/why-does-console-log-return-undefined.md)
> * 译者：
> * 校对者：

# Why does console.log() return ‘undefined’?

If you’ve spent time exploring your browser’s console, or the Node.js command line tool in your terminal, you may have seen some strange behavior relating to a common JavaScript method. If you enter `console.log()` in the terminal, you will get back two values, though you may have only expected to receive one.

The first value printed if you enter `console.log(‘hello world’)` will be `‘hello world’`. Just what you expected, right?

However, looking at the next line you will see a second returned value of ‘undefined.’ Why is there a second value if all we asked for and expected was our value of ‘hello world?’

This is due to the nature of REPLs, which are command line tools that scripting languages use to create a command based sandbox.

### What is a REPL?

You may be wondering what is a REPL? This acronym stands for Read, Evaluate, Print, Loop. REPLs are a coding environment tool that is a common feature among scripting languages. Whether you access it with ‘irb’ for Ruby, ‘node’ for JavaScript or ‘python’ for Python, entering into a REPL creates a sandbox environment for you to explore your code.

This exploration can include observing built in classes and functions, building and testing functions or even evaluating both simple and complex expressions. If you are familiar with the concept of PEMDAS in math, then REPL will make perfect sense.

REPLs work in a straightforward, routine way. First, they read whatever code you have entered in your current terminal expression using the language native to your version of the REPL. If you are using a Node.js REPL then your REPL will read the code as JavaScript.

After the code has been read, all evaluations will be run. This could include any arithmetic, loop structures, string, array or object manipulation or any other possible operations. The remaining code should only contain print statements as any data manipulation, database calls or other operations should be completed.

Once the main evaluations have been performed, we then print whatever the REPL was informed to print. This is the evaluation of items that would be printed out to the console and can be `console.log()` (or any flavor of `console.`*) for JavaScript, puts or pp for Ruby or print for Python.

The final step of the REPL is to loop. No, this doesn’t relate to a for or while loop. What we mean with loop is that once all of your statements or code have been read, evaluated and any information printed, we loop back to a state in which the computer is ready for more input. Thus after every bit of code you enter in the REPL is read, evaluated and printed, the computer prepares itself to run more operations.

REPLs are very handy tools for doing proof of concepts on models or checking for output from UIs. They are generally very helpful for back end work in which you don’t have visuals to confirm that what you are doing produces the intended product. Now let’s get back to the JavaScript.

### Why Node.js REPLs are how they are

Now that we have a better understanding of what a REPL is, let’s return to our undefined return value for `console.log()`. When we are calling `console.log()` from our browser console or the terminal, we are really calling it from a JavaScript REPL.

With our new understanding of what REPLs are and how they work we can work through the process of `console.log(“Hello, Daniel!”)`. First, the REPL will read in our command as JavaScript. Then it will look to evaluate parts of our command. The evaluate step will always return something, like the sum of 2 + 2 or a modified array, but in this case there is nothing to evaluate. Therefore it returns `undefined`.

![Figure 1. The result of calling “console.log(“Hello, Daniel!”) in Node.js REPL](https://cdn-images-1.medium.com/max/2000/1*oRXhxIJaSy_meLMsIxXjdw.png)

Read and evaluate are done so now we need to print whatever we told the computer to print. In our case we told our REPL to print `“Hello, Daniel!”` so the REPL moves to print this to the console. And with that we are ready to loop back to a state where the REPL can take our next set of instructions. Easy!

### Conclusion

Now you should have an understanding of what a REPL is and more specifically how REPLs work for Node.js. I hope you can use this base knowledge to be more confident during your Node.js sandboxing sessions, or to more quickly learn a new language using its REPL. Let me know in the comments any fun things you have learned while working in your language’s REPL.

### References

* [https://stackoverflow.com/questions/24342748/why-does-console-log-say-undefined-and-then-the-correct-value](https://stackoverflow.com/questions/24342748/why-does-console-log-say-undefined-and-then-the-correct-value)
* [https://codewith.mu/en/tutorials/1.1/repl](https://codewith.mu/en/tutorials/1.1/repl)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
