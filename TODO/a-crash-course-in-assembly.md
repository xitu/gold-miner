> * 原文地址：[A crash course in assembly](https://hacks.mozilla.org/2017/02/a-crash-course-in-assembly/)
> * 原文作者：本文已获作者 [Lin Clark](https://code-cartoons.com/@linclark) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[zhouzihanntu](https://github.com/zhouzihanntu)
> * 校对者：[Tina92](https://github.com/Tina92)、[zhaochuanxing](https://github.com/zhaochuanxing)

# 汇编快速入门

**本文是 WebAssembly 系列文章的第三部分。如果你还没有阅读过前面的文章，我们建议你 [从头开始](https://github.com/xitu/gold-miner/blob/master/TODO/a-cartoon-intro-to-webassembly.md)。**

理解汇编和编译器如何生成它的有助于你后续理解 WebAssembly 的工作原理，

在 [介绍 JIT 的文章](https://hacks.mozilla.org/2017/02/a-crash-course-in-just-in-time-jit-compilers/)里，我谈到了与机器交流的方式和与外星人通信是相似的。

![A person holding a sign with source code on it, and an alien responding in binary](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/03-01-alien03-500x286.png)

我现在真想看看外星人大脑的思考方式——即机器大脑解析和理解通信的机制。

大脑中有一部分专门用来思考（例如做加减或其他逻辑运算），一部分提供短期记忆存储，还有一部分提供长期记忆存储。

这几个不同的部分都有各自的名称：

- 负责思维的部分称为算术逻辑单元 (ALU)。
- 短期存储由寄存器提供。
- 长期存储由随机存取存储器 (RAM) 提供。

![A diagram showing the CPU, including ALU and Registers, and RAM](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/03-02-computer_architecture09-500x302.png)

机器码中的句子被称为指令。

当一条指令进入大脑时会发生什么？它会被分解成带不同含义的不同部分。

指令分解的方式是特定于当前大脑构造的。

例如，这种结构的大脑可能总是将前六个字节传送给 ALU。ALU 根据接收到的序列中 1 和 0 的排列，就会明白需要将两个东西加在一起。

这个字段称为操作码(opcode)，它的作用是告诉 ALU 要执行的操作。

![6-bits being taken from a 16-bit instruction and being piped into the ALU](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/03-03-computer_architecture12-500x354.png)

接下来大脑会取后续两个三字节的字段来确定要相加的两个数。这两个数会存储在寄存器中。

![Two 3-bit chunks being decoded to determine source registers](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/03-04-computer_architecture17-500x352.png)

注意这里机器码上方的注释，有助于我们理解这个过程。这就叫做汇编。这段代码称为符号机器码。符号机器码是人类理解机器码的一种方式。

你会发现汇编和这台机器的机器码有很直接的关系。因此不同的机器架构对应有不同的汇编方式。当你遇到使用不同架构的机器时，可能就得按它们自己的方式进行汇编。

因此，我们的翻译对象并不止一个。机器码不止一种语言，有许多不同种类的机器码。就像我们人类会说不同的语言一样，机器也会使用不同的语言。

随着人类和外星人之间的翻译问题解决，你也可以将英语、俄语、普通话等语言转化成外星文A、外星文B了。对编程而言，就是将 C、C++、Rust 等语言转化成 x86、ARM。

如果你想将任意一种高级语言编译成对应任意体系结构的汇编语言，一种方法是创建一整套不同语言到不同汇编的转化器。

![Diagram showing programming languages C, C++, and Rust on the left and assembly languages x86 and ARM on the right, with arrows between every combination](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/03-05-langs05-500x308.png)

但这样的做法非常低效。大部分编译器会在中间放置至少一个中间层。编译器接收高级编程语言并将其转化成相对底层的形式，转化结果也不能和机器码一样直接运行。这类形式称为中间表示(IR)。

![Diagram showing an intermediate representation between high level languages and assembly languages, with arrows going from high level programming languages to intermediate representation, and then from intermediate representation to assembly language](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/03-06-langs06-500x317.png)

这意味着编译器可以将任意一种高级编程语言翻译成一种 IR 语言。编译器的另一部分将得到的 IR 内容编译成特定于目标架构的语言。

编译器的前端部分将高级编程语言翻译成 IR 语言，再由后端将它们从 IR 语言编译成目标架构的汇编代码。

![Same diagram as above, with labels for front-end and back-end](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/03-07-langs09-500x306.png)

## 总结

以上就是汇编的简要说明，以及编译器将高级程序语言转成汇编的过程。在[下一篇文章](https://github.com/xitu/gold-miner/blob/master/TODO/creating-and-working-with-webassembly-modules.md)里，我们将会看到 WebAssembly 是如何实现的。
