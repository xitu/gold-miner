> * 原文地址：[Creating and working with WebAssembly modules](https://hacks.mozilla.org/2017/02/creating-and-working-with-webassembly-modules/)
* 原文作者：[Lin Clark](https://code-cartoons.com/@linclark)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

---
# Creating and working with WebAssembly modules
# 创建和使用WebAssembly组件
*This is the fourth part in a series on WebAssembly and what makes it fast. If you haven’t read the others, we recommend [starting from the beginning](https://hacks.mozilla.org/2017/02/a-cartoon-intro-to-webassembly/).*
*这是WebAssembly系列文章的第四部分。如果你还没阅读过前面的文章，我们建议你[从头开始](https://hacks.mozilla.org/2017/02/a-cartoon-intro-to-webassembly/)。*
WebAssembly is a way to run programming languages other than JavaScript on web pages. In the past when you wanted to run code in the browser to interact with the different parts of the web page, your only option was JavaScript.
WebAssembly 是一种不同于JavaScript的在web页面上运行程序语言的方式。以前当你想在浏览器上运行代码来实现web页面不同部分的交互时，你唯一的选择就是JavaScript。
So when people talk about WebAssembly being fast, the apples to apples comparison is to JavaScript. But that doesn’t mean that it’s an either/or situation—that you are either using WebAssembly, or you’re using JavaScript.
因此当人们谈论WebAssembly运行迅速时，合理的比较对象就是JavaScript。但这并不意味着一个非此即彼的选择——你使用WebAssembly还是JavaScript。
*situation是否可以翻译成选择存疑*
In fact, we expect that developers are going to use both WebAssembly and JavaScript in the same application. Even if you don’t write WebAssembly yourself, you can take advantage of it.
事实上我们希望开发者在同一应用中同时使用WebAssembly和JavaScript。即使你不亲自写WebAssembly代码，你也可以利用它。
*take advantage of 利用 or 使用*
WebAssembly modules define functions that can be used from JavaScript. So just like you download a module like lodash from npm today and call functions that are part of its API, you will be able to download WebAssembly modules in the future.
WebAssembly组件定义的函数可以在JavaScript中使用。因此就像现在你可以从npm上下载一个lodash这样的组件并且根据它的API调用方法一样，在未来你同样可以下载WebAssembly组件。
So let’s see how we can create WebAssembly modules, and then how we can use them from JavaScript.
所以让我们看看如何创建WebAssembly组件，以及怎样在JavaScript中使用。
## Where does WebAssembly fit?
## WebAssembly在哪里适用？
In the article about [assembly](https://hacks.mozilla.org/2017/02/a-crash-course-in-assembly/), I talked about how compilers take high-level programming languages and translate them to machine code.
在这篇关于[assembly](https://hacks.mozilla.org/2017/02/a-crash-course-in-assembly/)的文章里，我谈到过编译器怎么接收高级程序语言并且把它们翻译成机器码。
*take 使用 or 接收 ？*
![Diagram showing an intermediate representation between high level languages and assembly languages, with arrows going from high level programming languages to intermediate representation, and then from intermediate representation to assembly language](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/04-01-langs09-500x306.png)

Where does WebAssembly fit into this picture?
WebAssembly对应这张图片的哪个部分？
You might think it is just another one of the target assembly languages. That is kind of true, except that each one of those languages (x86, ARM ) corresponds to a particular machine architecture.
你可能认为它只不过是又一个目标汇编语言。某种程度上是对的，除了那些语言(x86,ARM)中每个都对应一个特定的机器架构。
*kind of true ? *
When you’re delivering code to be executed on the user’s machine across the web, you don’t know what your target architecture the code will be running on.
当你通过web向用户的机器上发送要执行的代码时，你并不知道你的代码将要在那种目标架构上运行。
So WebAssembly is a little bit different than other kinds of assembly. It’s a machine language for a conceptual machine, not an actual, physical machine.
所以WebAssembly和其他的汇编有些细微的差别。它是概念机的机器语言，而非真实的物理机。
Because of this, WebAssembly instructions are sometimes called virtual instructions. They have a much more direct mapping to machine code than JavaScript source code. They represent a sort of intersection of what can be done efficiently across common popular hardware. But they aren’t direct mappings to the particular machine code of one specific hardware.
正因如此，WebAssembly指令有时也被称为虚拟指令。它们比JavaScript源码有更直接的机器码映射。它们代表一套可以在常见的流行硬件上高效执行的指令集合。但是它们并不直接映射某一具体硬件的特定机器码。
*a sort of intersection*
![Same diagram as above with WebAssembly inserted between the intermediate representation and assembly](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/04-02-langs08-500x326.png)

The browser downloads the WebAssembly. Then, it can make the short hop from WebAssembly to that target machine’s assembly code.
浏览器下载WebAssembly。然后，它就可以从WebAssembly跳转到目标机器的汇编码。
## Compiling to .wasm
## 编译成.wasm
The compiler tool chain that currently has the most support for WebAssembly is called LLVM. There are a number of different front-ends and back-ends that can be plugged into LLVM.
LLVM是当前对WebAssembly支持最好的编译工具链。很多前后端编译工具都可以嵌入LLVM中。
> Note: Most WebAssembly module developers will code in languages like C and Rust and then compile to WebAssembly, but there are other ways to create a WebAssembly module. For example, there is an experimental tool that helps you [build a WebAssembly module using TypeScript](https://github.com/rsms/wasm-util), or you can [code in the text representation of WebAssembly directly](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format).
> 注：大部分WebAssembly组件开发者用C和Rust这样的语言编写代码，然后编译成WebAssembly，但仍有其他的方法来创建WebAssembly组件。比如，有一个实验性的工具帮你[使用TypeScript构建WebAssembly组件](https://github.com/rsms/wasm-util)，或者你可以[直接在WebAssembly的文本表示上编码](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format)。
Let’s say that we wanted to go from C to WebAssembly. We could use the clang front-end to go from C to the LLVM intermediate representation. Once it’s in LLVM’s IR, LLVM understands it, so LLVM can perform some optimizations.
比如说我们想把C编译成WebAssembly。我们可以使用clang前端把C编译成LLVM中介码。一旦它处于LLVM的中间层，LLVM编译它，LLVM就可以展现一些性能优化。
*LLVM intermediate representation  VS  LLVM’s IR  中介码 or 中间层*
To go from LLVM’s IR ([intermediate representation](https://en.wikipedia.org/wiki/Intermediate_representation)) to WebAssembly, we need a back-end. There is one that’s currently in progress in the LLVM project. That back-end is most of the way there and should be finalized soon. However, it can be tricky to get it working today.
要把LLVM中介码（[intermediate representation](https://en.wikipedia.org/wiki/Intermediate_representation)）编译成WebAssembly，我们需要一个后端支持。在LLVM项目中有一个这类后端正在开发中。这个后端项目已经接近完成并且应该很快就会定稿。然而，现在使用它还会有不少问题。
There’s another tool called Emscripten which is a bit easier to use at the moment. It has its own back-end that can produce WebAssembly by compiling to another target (called asm.js) and then converting that to WebAssembly. It uses LLVM under the hood, though, so you can switch between the two back-ends from Emscripten.
目前有一个稍微容易使用的工具叫Emscripten。他有自己的后端，可以通过编译成其他对象(称为asm.js)然后再转换成WebAssembly的方式来产生WebAssembly。好像它底层仍旧使用LLVM，因此你可以在Emscripten中切换这两种后端。
![Diagram of the compiler toolchain](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/04-03-toolchain07-500x411.png)

Emscripten includes many additional tools and libraries to allow porting whole C/C++ codebases, so it’s more of a software developer kit (SDK) than a compiler. For example, systems developers are used to having a filesystem that they can read from and write to, so Emscripten can simulate a file system using IndexedDB.
Emscripten包含了许多附加工具和库来支持移植整个C/C++代码库，因此它更像一个SDK而非编译器。举个例子，系统开发人员习惯于有一个文件系统用来读写，所以Emscripten可以使用IndexedDB模拟一个文件系统。
Regardless of the toolchain you’ve used, the end result is a file that ends in .wasm. I’ll explain more about the structure of the .wasm file below. First, let’s look at how you can use it in JS.
忽略你已经使用的工具链，最后得到的结果就是一个后缀名为.wasm的文件。下面我将着重解释.wasm文件的结构。首先，我们先看看怎样在JS中使用.wasm文件。
## Loading a .wasm module in JavaScript
## 在JavaScript中载入一个.wasm组件
The .wasm file is the WebAssembly module, and it can be loaded in JavaScript. As of this moment, the loading process is a little bit complicated.
这个.wasm文件是一个WebAssembly组件，它可以在JavaScript中载入。在此情景下，载入过程稍微有些复杂。
    
    functionfetchAndInstantiate(url, importObject) {
      return fetch(url).then(response =>
        response.arrayBuffer()
      ).then(bytes =>
        WebAssembly.instantiate(bytes, importObject)
      ).then(results =>
        results.instance
      );
    }
    

You can see this in more depth in [our docs](https://developer.mozilla.org/en-US/docs/WebAssembly).
你可以在[我们的文档](https://developer.mozilla.org/en-US/docs/WebAssembly)中深入了解这部分内容。
We’re working on making this process easier. We expect to make improvements to the toolchain and integrate with existing module bundlers like webpack or loaders like SystemJS. We believe that loading WebAssembly modules can be as easy as as loading JavaScript ones.
我们致力于让这个过程变得更容易。我们期望改进工具链，整合已存在的模块打包工具如webpack以及动态加载器如SystemJS。我们相信载入WebAssembly组件可以像载入JavaScript组件一样简单。
There is a major difference between WebAssembly modules and JS modules, though. Currently, functions in WebAssembly can only use numbers (integers or floating point numbers) as parameters or return values.
不过，WebAssembly组件和JS组件有一个显著的区别。目前，WebAssembly函数只能使用数字（整型或浮点型数字）作为参数和返回值。
![Diagram showing a JS function calling a C function and passing in an integer, which returns an integer in response](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/04-04-memory04-500x93.png)

For any data types that are more complex, like strings, you have to use the WebAssembly module’s memory.
对于更加复杂的数据类型，如字符串，你必须使用WebAssembly组件存储器。
If you’ve mostly worked with JavaScript, having direct access to memory isn’t so familiar. More performant languages like C, C++, and Rust, tend to have manual memory management. The WebAssembly module’s memory simulates the heap that you would find in those languages.如果你几乎只使用过JavaScript，对于直接访问存储器不那么熟悉。更高性能的语言比如C，C++，和Rust，倾向于手动内存管理。WebAssembly组件存储器模拟了你在这些语言中会看到的堆。
To do this, it uses something in JavaScript called an ArrayBuffer. The array buffer is an array of bytes. So the indexes of the array serve as memory addresses.
为了实现这个功能，它使用了JavaScript中的类型化数组(ArrayBuffer)。类型化数组是存放字节的数组。数组的索引就是对应的存储器地址。
If you want to pass a string between the JavaScript and the WebAssembly, you convert the characters to their character code equivalent. Then you write that into the memory array. Since indexes are integers, an index can be passed in to the WebAssembly function. Thus, the index of the first character of the string can be used as a pointer.
如果想要在JavaScript和WebAssembly中传递字符串，你需要把这些字符转换成他们的字符码当量。然后把这些写入存储器阵列。既然索引是整数，那么单个索引值就可以传入WebAssembly函数中。这样字符串中第一个字符的索引就可以被当成一个指针使用。
![Diagram showing a JS function calling a C function with an integer that represents a pointer into memory, and then the C function writing into memory](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/04-05-memory12-500x400.png)

It’s likely that anybody who’s developing a WebAssembly module to be used by web developers is going to create a wrapper around that module. That way, you as a consumer of the module don’t need to know about memory management.
几乎任何想要开发供web开发者使用的WebAssembly组件的开发者，都会为组件创建一个包装器。这样以来，你作为一个组件的消费者并不需要了解内存管理。
If you want to learn more, check out our docs on [working with WebAssembly’s memory](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_objects/WebAssembly/Memory).
如果想了解更多的话，查看我们关于[working with WebAssembly’s memory](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_objects/WebAssembly/Memory)的文档。
## The structure of a .wasm file
## .wasm文件结构
If you are writing code in a higher level language and then compiling it to WebAssembly, you don’t need to know how the WebAssembly module is structured. But it can help to understand the basics.
如果你使用高级语言来编写代码然后把它编译成WebAssembly，你不必知道WebAssembly组件的结构。但是它可以帮助你理解其基本原理。
If you haven’t already, we suggest reading the [article on assembly](https://hacks.mozilla.org/2017/02/a-crash-course-in-assembly/) (part 3 of the series).
如果你之前没有了解这些基本原理，我们建议你先阅读 [article on assembly](https://hacks.mozilla.org/2017/02/a-crash-course-in-assembly/) (part 3 of the series)。
Here’s a C function that we’ll turn into WebAssembly:
下面是一个C函数，我们将把它转成WebAssembly:

    intadd42(int num) {
      return num + 42;
    }
    

You can try using the [WASM Explorer](http://mbebenita.github.io/WasmExplorer/) to compile this function.
你可以使用[WASM Explorer](http://mbebenita.github.io/WasmExplorer/)来编译这个函数。
If you open up the .wasm file (and if your editor supports displaying it), you’ll see something like this.
如果你打开.wasm文件（如果你的编辑器支持显示的话），你讲看到类似这样的内容：
    
    00 61 73 6D 0D 00 00 00 01 86 80 80 80 00 01 60
    01 7F 01 7F 03 82 80 80 80 00 01 00 04 84 80 80
    80 00 01 70 00 00 05 83 80 80 80 00 01 00 01 06
    81 80 80 80 00 00 07 96 80 80 80 00 02 06 6D 65
    6D 6F 72 79 02 00 09 5F 5A 35 61 64 64 34 32 69
    00 00 0A 8D 80 80 80 00 01 87 80 80 80 00 00 20
    00 41 2A 6A 0B
    

That is the module in its “binary” representation. I put quotes around binary because it’s usually displayed in hexadecimal notation, but that can be easily converted to binary notation, or to a human readable format.
这是组件的“二进制”表示法。我把二进制加上引号是因为它通常显示的是十六进制符号，但这很容易转换成二进制符号，或者人类可读的格式。
For example, here’s what `num + 42` looks like.
举个例子，下图是`num + 42`的几种表现形式。
![Table showing hexadecimal representation of 3 instructions (20 00 41 2A 6A), their binary representation, and then the text representation (get_local 0, i32.const 42, i32.add)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/04-06-hex_binary_asm01-500x254.png)

### How the code works: a stack machine
### 代码如何运行：堆栈机
In case you’re wondering, here’s what those instructions would do.
如果你想知道的话，下图是执行的一些指令说明。
![Diagram showing that get_local 0 gets value of first param and pushes it on the stack, i32.const 42 pushes a constant value on the stack, and i32.add adds the top two values from the stack and pushes the result](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/04-07-hex_binary_asm02-500x175.png)

You might have noticed that the `add` operation didn’t say where its values should come from. This is because WebAssembly is an example of something called a stack machine. This means that all of the values an operation needs are queued up on the stack before the operation is performed.
你可能注意到了`add`操作并没有说明他的值应该从哪里来。这是因为WebAssembly是堆栈机的一个范例。这意味着一个操作所需的所有值在操作执行之前都在栈中排队。
Operations like `add` know how many values they need. Since `add` needs two, it will take two values from the top of the stack. This means that the `add` instruction can be short (a single byte), because the instruction doesn’t need to specify source or destination registers. This reduces the size of the .wasm file, which means it takes less time to download.
例如`add`这类的操作指导它们需要多少值。如果`add`需要两个值，它将从栈顶取出两个值。这意味着`add`指令可以很短（单个字节），因为指令不需要指定源或者目的寄存器。这减少了.wasm文件的大小，也意味着下载的耗时更短。
Even though WebAssembly is specified in terms of a stack machine, that’s not how it works on the physical machine. When the browser translates WebAssembly to the machine code for the machine the browser is running on, it will use registers. Since the WebAssembly code doesn’t specify registers, it gives the browser more flexibility to use the best register allocation for that machine.
即使WebAssembly就堆栈机而言是特定的，那不是其在物理机上的工作方式。当浏览器把WebAssembly转化成其运行机器上对应的机器码时，将会用到寄存器。因为WebAssembly代码不指定寄存器，它赋予浏览器在当前机器上使用最优寄存器分配更多的灵活性。
### Sections of the module
### 组件的sections
Besides the `add42` function itself, there are other parts in the .wasm file. These are called sections. Some of the sections are required for any module, and some are optional.
除了`add42`函数自身，.wasm文件还有其他部分。那就是sections。一些sections对任何组件都是必需的，而有一些是可选的。
Required:

1. **Type**. Contains the function signatures for functions defined in this module and any imported functions.
2. **Function**. Gives an index to each function defined in this module.
3. **Code**. The actual function bodies for each function in this module.
必须项：
1.**类型(Type)**。包括在该组件中定义的函数签名以及任何引入的函数。
2.**函数(Function)**。给每一个在该组件中定义的函数一个索引。
3.**代码(Code)**。该组件中定义的每一个函数的实际函数体。
Optional:

1. **Export**. Makes functions, memories, tables, and globals available to other WebAssembly modules and JavaScript. This allows separately-compiled modules to be dynamically linked together. This is WebAssembly’s version of a .dll.
2. **Import**. Specifies functions, memories, tables, and globals to import from other WebAssembly modules or JavaScript.
3. **Start**. A function that will automatically run when the WebAssembly module is loaded (basically like a main function).
4. **Global**. Declares global variables for the module.
5. **Memory**. Defines the memory this module will use.
6. **Table**. Makes it possible to map to values outside of the WebAssembly module, such as JavaScript objects. This is especially useful for allowing indirect function calls.
7. **Data**. Initializes imported or local memory.
8. **Element**. Initializes an imported or local table.
可选项：
1.**导出(Export)**。使函数，内存，表以及全局变量对其他WebAssembly组件和JavaScript可用。这使独立编译的组件可以被动态链接在一起。这就是WebAssembly的.dll版本。
2.**导入(Import)**。从其他WebAssembly组件或JavaScript中导入指定的函数，内存，表以及全局变量。
3.**启动(Start)**。当WebAssembly组件载入时自动运行的函数(基本上类似一个主函数)。
4.**全局变量(Global)**。为组件声明全局变量。
5.**内存（Memory）**。定义组件将使用到的内存空间。
6.**表（Table）**。使把值映射到WebAssembly组件外部成为可能，就像JavaScript对象那样。这对于允许简介函数调用相当有用。
7.**数据（Data）**。初始化导入或本地内存。
8。**元素（Element）**。初始化导入或本地的表。

For more on sections, here’s a great in-depth [explanation of how these sections work](https://rsms.me/wasm-intro).
更多关于sections的阐释，这有一篇深度好文[解释这些sections如何运行](https://rsms.me/wasm-intro)。
## Coming up next
## 接下来
Now that you know how to work with WebAssembly modules, let’s look at [why WebAssembly is fast](https://hacks.mozilla.org/2017/02/what-makes-webassembly-fast/).
现在你知道怎样使用WebAssembly组件了，让我们看看[为什么WebAssembly这么快](https://hacks.mozilla.org/2017/02/what-makes-webassembly-fast/)。
