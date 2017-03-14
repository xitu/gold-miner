> * 原文地址：[A crash course in assembly](https://hacks.mozilla.org/2017/02/a-crash-course-in-assembly/)
* 原文作者：[Lin Clark](https://code-cartoons.com/@linclark)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[zhouzihanntu](https://github.com/zhouzihanntu)
* 校对者：

# A crash course in assembly
# 汇编快速入门

*This is the third part in a series on WebAssembly and what makes it fast. If you haven’t read the others, we recommend [starting from the beginning](https://hacks.mozilla.org/2017/02/a-cartoon-intro-to-webassembly/).*
**本文是 WebAssembly 系列文章的第三部分。如果你还没有阅读过前面的文章，我们建议你 [从头开始](https://hacks.mozilla.org/2017/02/a-cartoon-intro-to-webassembly/).**

To understand how WebAssembly works, it helps to understand what assembly is and how compilers produce it.
理解汇编和编译器如何生成它的有助于你后续理解 WebAssembly 的工作原理，

In the [article on the JIT](https://hacks.mozilla.org/2017/02/a-crash-course-in-just-in-time-jit-compilers/), I talked about how communicating with the machine is like communicating with an alien.
在 [介绍 JIT 的文章](https://hacks.mozilla.org/2017/02/a-crash-course-in-just-in-time-jit-compilers/)里，我谈到了与机器交流和与外星人通信是如何相似。

![A person holding a sign with source code on it, and an alien responding in binary](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/03-01-alien03-500x286.png)

I want to take a look now at how that alien brain works—how the machine’s brain parses and understands the communication coming in to it.
我现在真想看看外星人大脑的思考方式——即机器大脑解析和理解通信的机制。

There’s a part of this brain that’s dedicated to the thinking—things like adding and subtracting, or logical operations. There’s also a part of the brain near that which provides short-term memory, and another part that provides longer-term memory.
大脑中有一部分专门用来思考（例如做加减或其他逻辑运算），一部分提供短期存储，还有一部分提供长期存储。
 
These different parts have names.
这几个不同的部分都有各自对应的名称：

- The part that does the thinking is the Arithmetic-logic Unit (ALU).
- 负责思维的部分称为算术逻辑单元 (ALU)。
- The short term memory is provided by registers.
- 短期存储由寄存器提供。
- The longer term memory is the Random Access Memory (or RAM).
- 长期存储由随机存取存储器 (RAM) 提供。

![A diagram showing the CPU, including ALU and Registers, and RAM](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/03-02-computer_architecture09-500x302.png)

The sentences in machine code are called instructions.
机器码中的句子被称为指令。

What happens when one of these instructions comes into the brain? It gets split up into different parts that mean different things.
当一条指令进入大脑时会发生什么？它会被分解成带不同含义的不同部分。

The way that this instruction is split up is specific to the wiring of this brain.
指令分解的方式是特定于当前大脑构造的。

For example, a brain that is wired like this might always take the first six bits and pipe that in to the ALU. The ALU will figure out, based on the location of ones and zeros, that it needs to add two things together.
例如，这种结构的大脑可能总是将前六个字节传送给 ALU。ALU 根据接收到的序列中 1 和 0 的排列，就会明白需要将两个东西加在一起。

This chunk is called the “opcode”, or operation code, because it tells the ALU what operation to perform.
这个字段称为操作码(opcode)，它的作用是告诉 ALU 要执行的操作。

![6-bits being taken from a 16-bit instruction and being piped into the ALU](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/03-03-computer_architecture12-500x354.png)

Then this brain would take the next two chunks of three bits each to determine which two numbers it should add. These would be addresses of the registers.
接下来大脑会取后续两个三字节的字段来确定要相加的两个数。这两个数会存储在寄存器中。

![Two 3-bit chunks being decoded to determine source registers](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/03-04-computer_architecture17-500x352.png)

Note the annotations above the machine code here, which make it easier for us humans to understand what’s going on. This is what assembly is. It’s called symbolic machine code. It’s a way for humans to make sense of the machine code.
注意这里机器码上方的注释，有助于我们人类理解是怎么回事。这就叫做汇编。这段代码称为符号机器码。符号机器码是人类理解机器码的一种方式。

You can see here there is a pretty direct relationship between the assembly and the machine code for this machine. Because of this, there are different kinds of assembly for the different kinds of machine architectures that you can have. When you have a different architecture inside of a machine, it is likely to require its own dialect of assembly.
你会发现汇编和这台机器的机器码有相当直接的关系。因此对应不同的机器架构有不同的汇编方式。当你遇到使用不同架构的机器时，可能就得按它们自己的方式进行汇编。

So we don’t just have one target for our translation. It’s not just one language called machine code. It’s many different kinds of machine code. Just as we speak different languages as people, machines speak different languages.
因此，我们的翻译对象并不止一个。机器码不止一种语言，有许许多多种类的机器码。就像我们人类会说不同的语言一样，机器也会使用不同的语言。		

With human to alien translation, you may be going from English, or Russian, or Mandarin to Alien Language A or Alien language B. In programming terms, this is like going from C, or C++, or Rust to x86 or to ARM.
随着人类和外星人之间的翻译问题解决，你也可以将英语、俄语、普通话等语言转化成外星文A、外星文B了。对编程而言，就是将 C、C++、Rust 等语言转化成 x86、ARM。

You want to be able to translate any one of these high-level programming languages down to any one of these assembly languages (which corresponds to the different architectures). One way to do this would be to create a whole bunch of different translators that can go from each language to each assembly.
如果你想将任意一种高级语言编译成对应任意体系结构的汇编语言。一种方法是创建一整套不同语言到不同汇编的转化器。

![Diagram showing programming languages C, C++, and Rust on the left and assembly languages x86 and ARM on the right, with arrows between every combination](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/03-05-langs05-500x308.png)

That’s going to be pretty inefficient. To solve this, most compilers put at least one layer in between. The compiler will take this high-level programming language and translate it into something that’s not quite as high level, but also isn’t working at the level of machine code. And that’s called an intermediate representation (IR).
但这样的做法非常低效。大部分编译器会在中间放置至少一个中间层。编译器接收高级编程语言并将其转化成相对底层的形式，转化结果也不能和机器码一样直接运行。这类形式称为中间表示(IR)。

![Diagram showing an intermediate representation between high level languages and assembly languages, with arrows going from high level programming languages to intermediate representation, and then from intermediate representation to assembly language](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/03-06-langs06-500x317.png)

This means the compiler can take any one of these higher-level languages and translate it to the one IR language. From there, another part of the compiler can take that IR and compile it down to something specific to the target architecture. 
这意味着编译器可以将任意一种高级编程语言翻译成一种 IR 语言。编译器的另一部分将得到的 IR 内容编译成特定于目标架构的东西。

The compiler’s front-end translates the higher-level programming language to the IR. The compiler’s backend goes from IR to the target architecture’s assembly code.
编译器的前端将高级编程语言翻译成 IR 语言，再由后端将它们从 IR 语言编译成目标架构的汇编代码。

![Same diagram as above, with labels for front-end and back-end](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/03-07-langs09-500x306.png)

## Conclusion
## 总结

That’s what assembly is and how compilers translate higher-level programming languages to assembly. In the [next article](https://hacks.mozilla.org/?p=30512), we’ll see how 
WebAssembly fits in to this.
以上就是汇编的简要说明，以及编译器将高级程序语言转成汇编的过程。在[下一篇文章](https://hacks.mozilla.org/?p=30512)里，我们将会看到 WebAssembly 是如何实现的。