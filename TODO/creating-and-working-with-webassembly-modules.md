> * 原文地址：[Creating and working with WebAssembly modules](https://hacks.mozilla.org/2017/02/creating-and-working-with-webassembly-modules/)
> * 原文作者：本文已获作者 [Lin Clark](https://code-cartoons.com/@linclark) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： [xilihuasi](https://github.com/xilihuasi)
> * 校对者：[Tina92](https://github.com/Tina92)、[zhouzihanntu](https://github.com/zhouzihanntu)

# 创建和使用 WebAssembly 组件
**这是 WebAssembly 系列文章的第四部分。如果你还没阅读过前面的文章，我们建议你[从头开始](https://github.com/xitu/gold-miner/blob/master/TODO/a-cartoon-intro-to-webassembly.md)。**

WebAssembly 是一种不同于 JavaScript 的在 web 页面上运行程序语言的方式。以前当你想在浏览器上运行代码来实现 web 页面不同部分的交互时，你唯一的选择就是 JavaScript。

因此当人们谈论 WebAssembly 运行迅速时，合理的比较对象就是 JavaScript。但这并不意味着你必须在 WebAssembly 和 JavaScript 二者中选择一个使用。

事实上我们希望开发者在同一应用中同时使用 WebAssembly 和 JavaScript。即使你不亲自写 WebAssembly 代码，你也可以使用它。

WebAssembly 组件定义的函数可以在 JavaScript 中使用。因此，就像现在你可以从 npm 上下载一个 lodash 这样的组件并且根据它的 API 调用方法一样，在未来你同样可以下载 WebAssembly 组件。

那么让我们看看如何创建 WebAssembly 组件，以及如何在 JavaScript 中使用这些组件吧。

## WebAssembly 处于哪个环节？

在上一篇关于[汇编](https://github.com/xitu/gold-miner/blob/master/TODO/a-crash-course-in-assembly.md)的文章里，我谈到过编译器怎么提取高级程序语言并且把它们翻译成机器码。

![Diagram showing an intermediate representation between high level languages and assembly languages, with arrows going from high level programming languages to intermediate representation, and then from intermediate representation to assembly language](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/04-01-langs09-500x306.png)

WebAssembly 对应这张图片的哪个部分？

你可能认为它只不过是又一个目标汇编语言。某种程度上是对的，不同之处在于那些语言(x86,ARM)中每个都对应一个特定的机器架构。

当你通过 web 向用户的机器上发送要执行的代码时，你并不知道你的代码将要在哪种目标架构上运行。

所以 WebAssembly 和其他的汇编有些细微的差别。它是概念机的机器语言，而非真实的物理机。

正因如此，WebAssembly 指令有时也被称为虚拟指令。它们比 JavaScript 源码有更直接的机器码映射。它们代表一类可以在常见的流行硬件上高效执行的指令集合。但是它们并不直接映射某一具体硬件的特定机器码。

![Same diagram as above with WebAssembly inserted between the intermediate representation and assembly](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/04-02-langs08-500x326.png)

浏览器下载 WebAssembly 后，它就能从 WebAssembly 转成目标机器的汇编码。

## 编译成 .wasm

LLVM 是当前对 WebAssembly 支持最好的编译工具链。很多前后端编译工具都可以嵌入 LLVM 中。

> 注：大部分 WebAssembly 组件开发者用 C 和 Rust 这样的语言编写代码，然后编译成 WebAssembly，但仍有其他的方法来创建 WebAssembly 组件。比如，有一个实验性的工具帮你[使用 TypeScript 构建 WebAssembly 组件](https://github.com/rsms/wasm-util)，或者你可以[直接在 WebAssembly 的文本表示上编码](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format)。

比如说我们想把 C 编译成 WebAssembly。我们可以使用 clang 编译器前端把 C 编译成 LLVM 中介码。一旦它处于 LLVM 的中间层，LLVM 编译它，LLVM 就可以展现一些性能优化。

要把 LLVM IR（[中介码](https://en.wikipedia.org/wiki/Intermediate_representation)）编译成 WebAssembly，我们需要一个后端支持。在 LLVM 项目中有一个这类后端正在开发中。这个后端项目已经接近完成并且应该很快就会定稿。然而，现在使用它还会有不少问题。

目前有一个稍微容易使用的工具叫 Emscripten。他有自己的后端，可以通过编译成其他对象(称为 asm.js)然后再转换成 WebAssembly 的方式来产生 WebAssembly。好像它底层仍旧使用 LLVM，因此你可以在 Emscripten 中切换这两种后端。

![Diagram of the compiler toolchain](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/04-03-toolchain07-500x411.png)

Emscripten 包含了许多附加工具和库来支持移植整个 C/C++ 代码库，因此它更像一个 SDK 而非编译器。举个例子，系统开发人员习惯于有一个文件系统用来读写，所以 Emscripten 可以使用 IndexedDB 模拟一个文件系统。

忽略你已经使用的工具链，最后得到的结果就是一个后缀名为 .wasm 的文件。下面我将着重解释 .wasm 文件的结构。首先，我们先看看怎样在JS中使用 .wasm 文件。

## 在 JavaScript 中载入一个 .wasm 组件

这个 .wasm 文件是一个 WebAssembly 组件，它可以在 JavaScript 中载入。在此情景下，载入过程稍微有些复杂。

    functionfetchAndInstantiate(url, importObject) {
      return fetch(url).then(response =>
        response.arrayBuffer()
      ).then(bytes =>
        WebAssembly.instantiate(bytes, importObject)
      ).then(results =>
        results.instance
      );
    }

你可以在[我们的文档](https://developer.mozilla.org/en-US/docs/WebAssembly)中深入了解这部分内容。

我们致力于让这个过程变得更容易。我们期望改进工具链，整合已存在的像 webpack 这样的模块打包工具以及类似 SystemJS 的动态加载器。我们相信载入 WebAssembly 组件可以像载入 JavaScript 组件一样简单。

不过，WebAssembly 组件和 JS 组件有一个显著的区别。目前，WebAssembly 函数只能使用数字（整型或浮点型数字）作为参数和返回值。

![Diagram showing a JS function calling a C function and passing in an integer, which returns an integer in response](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/04-04-memory04-500x93.png)

对于更加复杂的数据类型，如字符串，你必须使用 WebAssembly 组件存储器。

像 C，C++，和 Rust 这些更高性能的语言倾向于手动管理内存。如果你大部分时间都在使用 JavaScript，也许对直接访问存储器的操作不熟悉。WebAssembly 组件存储器模拟了你在这些语言中会看到的堆。

为了实现这个功能，它使用了 JavaScript 中的类型化数组(ArrayBuffer)。类型化数组是存放字节的数组。数组的索引就是对应的存储器地址。

如果想要在 JavaScript 和 WebAssembly 中传递字符串，你需要把这些字符转换成他们的字符码常量。然后把这些写入存储器阵列。既然索引是整数，那么单个索引值就可以传入 WebAssembly 函数中。这样字符串中第一个字符的索引就可以被当成一个指针使用。

![Diagram showing a JS function calling a C function with an integer that represents a pointer into memory, and then the C function writing into memory](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/04-05-memory12-500x400.png)

几乎所有想要开发供 web 开发者使用的 WebAssembly 组件的开发者，都会为组件创建一个包装器。这样以来，你作为组件的消费者并不需要了解内存管理。

如果想了解更多的话，查看我们关于[使用 WebAssembly 内存](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_objects/WebAssembly/Memory)的文档。

## .wasm 文件结构

如果你使用高级语言来编写代码然后把它编译成 WebAssembly，你不必知道 WebAssembly 组件的结构。但是它可以帮助你理解其基本原理。

如果你之前没有了解这些基本原理，我们建议你先阅读 [汇编文章](https://github.com/xitu/gold-miner/blob/master/TODO/a-crash-course-in-assembly.md) (part 3 of the series)。

下面是一个 C 函数，我们将把它转成 WebAssembly：

    int add42(int num) {
      return num + 42;
    }
    
你可以使用 [WASM Explorer](http://mbebenita.github.io/WasmExplorer/) 来编译这个函数。

如果你打开 .wasm 文件（假设你的编辑器支持显示），你将看到类似这样的内容：

    00 61 73 6D 0D 00 00 00 01 86 80 80 80 00 01 60
    01 7F 01 7F 03 82 80 80 80 00 01 00 04 84 80 80
    80 00 01 70 00 00 05 83 80 80 80 00 01 00 01 06
    81 80 80 80 00 00 07 96 80 80 80 00 02 06 6D 65
    6D 6F 72 79 02 00 09 5F 5A 35 61 64 64 34 32 69
    00 00 0A 8D 80 80 80 00 01 87 80 80 80 00 00 20
    00 41 2A 6A 0B


这是组件的“二进制”表示法。我把二进制加上引号是因为它通常显示的是十六进制符号，但这很容易转换成二进制符号，或者人类可读的格式。

举个例子，下图是 `num + 42` 的几种表现形式。

![Table showing hexadecimal representation of 3 instructions (20 00 41 2A 6A), their binary representation, and then the text representation (get_local 0, i32.const 42, i32.add)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/04-06-hex_binary_asm01-500x254.png)

### 代码如何运行：堆栈机

如果你想知道的话，下图是执行的一些指令说明。

![Diagram showing that get_local 0 gets value of first param and pushes it on the stack, i32.const 42 pushes a constant value on the stack, and i32.add adds the top two values from the stack and pushes the result](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/04-07-hex_binary_asm02-500x175.png)

你可能注意到了 `add` 操作并没有说明他的值应该从哪里来。这是因为 WebAssembly 是堆栈机的一个范例。这意味着一个操作所需的所有值在操作执行之前都在栈中排队。

例如 `add` 这类的操作指导它们需要多少值。如果 `add` 需要两个值，它将从栈顶取出两个值。这意味着 `add` 指令可以很短（单个字节），因为指令不需要指定源或者目的寄存器。这减少了 .wasm 文件的大小，也意味着下载的耗时更短。

即使 WebAssembly 就堆栈机而言是特定的，但那不是其在物理机上的工作方式。当浏览器把 WebAssembly 转化成其运行机器上对应的机器码时，将会用到寄存器。因为 WebAssembly 代码不指定寄存器，所以浏览器在当前机器上能更灵活的去使用最佳寄存器分配。

### 组件的 sections

除了 `add42` 函数自身，.wasm 文件还有其他部分。那就是 sections。一些 sections 对任何组件都是必需的，而有一些是可选的。

必选项：
1. **类型(Type)**。包括在该组件中定义的函数签名以及任何引入的函数。
2. **函数(Function)**。给每一个在该组件中定义的函数一个索引。
3. **代码(Code)**。该组件中定义的每一个函数的实际函数体。

可选项：
1. **导出(Export)**。使函数，内存，表以及全局变量对其他 WebAssembly 组件和 JavaScript 可用。这使独立编译的组件可以被动态链接在一起。这就是 WebAssembly 的 .dll 版本。
2. **导入(Import)**。从其他 WebAssembly 组件或 JavaScript 中导入指定的函数，内存，表以及全局变量。
3. **启动(Start)**。当 WebAssembly 组件载入时自动运行的函数(基本上类似一个主函数)。
4. **全局变量(Global)**。为组件声明全局变量。
5. **内存（Memory）**。定义组件将使用到的内存空间。
6. **表（Table）**。使把值映射到 WebAssembly 组件外部成为可能，就像 JavaScript 对象那样。这对于允许简介函数调用相当有用。
7. **数据（Data）**。初始化导入或本地内存。
8. **元素（Element）**。初始化导入或本地的表。

更多关于 sections 的阐释，这有一篇深度好文[解释这些 sections 如何运行](https://rsms.me/wasm-intro)。

## 接下来

现在你知道怎样使用 WebAssembly 组件了，让我们看看[为什么 WebAssembly 这么快](https://github.com/xitu/gold-miner/blob/master/TODO/what-makes-webassembly-fast.md)。
