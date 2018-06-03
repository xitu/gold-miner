
> * 原文地址：[Tracing Patterns that Might Hinder Performance](https://www.netguru.co/blog/tracing-patterns-hinder-performance)
> * 原文作者：[Jakub Rożek](https://www.netguru.co/blog/tracing-patterns-hinder-performance)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/tracing-patterns-hinder-performance.md](https://github.com/xitu/gold-miner/blob/master/TODO/tracing-patterns-hinder-performance.md)
> * 译者：[薛定谔的猫](https://github.com/Aladdin-ADD/)
> * 校对者：[AceLeeWinnie](https://github.com/AceLeeWinnie)、[HydeSong](https://github.com/HydeSong)

# 找出可能影响性能的代码（模式）

现在你很可能会遇到不止一个响应迟钝的 app 或加载缓慢的页面。已经是 2017 年了，我们当然希望一切变的很快，但我们仍然会体验到恼人的延时。怎么会这样呢？难道我们的网络连接不是逐年变快的么？我们的浏览器性能不是也变的更好？我们将在下文中讨论这些。

事实上，浏览器和引擎越来越快，新特性也在不停的增加，一些过时的特性也在被废弃。网站和 app 也是如此。同时，它们也更大、更重了，因此即使浏览器和硬件越来越好，我们也需要考虑性能 -- 至少在某种程度上。我们来看看如何找出常见的性能陷阱，来改善网站和 app 的性能，但在此之前，我们先来看一下概览。

## 优化

关于流水线（pipeline）我可以写一本书，但本文中我还是想关注有助于优化过程的关键点。我会阐述一些会极大影响性能的常见错误。为了简洁，我不会讨论 parsing、AST、机器码生成、GC（垃圾收集）、反馈收集、OSR(on-stack replacement) -- 别担心，我会在未来的文章中解释它们。

### 旧版本

旧版本使用的基准编译器（baseline compiler）和优化编译器 Crankshaft，已经在 Chrome M59 中被废弃。

基准编译器并不会进行任何优化，它仅仅是快速编译代码，然后使其被执行。需要注意的是，生成优化代码严重依赖于假设，它反过来又需要假设类型反馈，因此需要首先执行基准编译器。

一旦某个函数被频繁执行（hot，通常引擎认为它值得优化），Crankshaft 就发挥（优化）作用了。它生成的代码性能非常好，接近于 Java。这种优化方式是业内第一，它带来了巨大的性能提升。因此 JS 才能有较好的性能，前端开发者也能够用它来创建复杂的 web 应用。

### 新版本

随着 web 的发展，新的框架诞生，规范也在更新升级，在 Crankshaft 基础上扩展变得非常困难。有的代码不会被 Crankshaft 优化，比如操作 arguments 对象的某些方法（安全的方式有 unmonkey-patched Function.prototype.apply、length属性、未越界的下标），try-catch 语句和[其它](https://github.com/petkaantonov/bluebird/wiki/Optimization-killers)。幸运的是，新的架构 Ignition 和 TurboFan 可以解决其中一些性能瓶颈。现在，有一些模式可以得到更好的优化。如前文所述，优化也是有成本的，需要耗费一些资源（在低端的移动设备上资源可能很有限）。但在多数情况下，你还是希望你的函数能够得到优化。

引入 TurboFan 的[原因](https://docs.google.com/presentation/d/1H1lLsbclvzyOF3IUR05ZUaZcqDxo7_-8f4yJoxdMooU/edit#slide=id.g18ceb14721_0_39)有：

- 提供统一的代码生成架构
- 减少 V8 的移植/维护成本
- 去除性能陷阱
- 新特性实验更容易 (i.e. changes to load/store ICs, bootstrapping an interpreter)

当然，前提是不牺牲性能。生成字节码相对很快，但解释字节码可能比执行优化后的代码慢 100 倍。它显然取决于编译器的复杂度。基准编译器的目的从来就不是生成很快的代码，但将执行时间考虑在内的话，它仍然比 Ignition 快（不是快很多，在某些场景下快 3-4 倍）。TurboFan 的目的是取代上一代的优化编译器 -- Crankshaft。

## 我们需要优化吗?

不一定。

如果一个函数只会执行一两次，并不值得优化。但如果可能执行多次，值类型和对象结构固定的话，你就很可能需要考虑优化你的代码了。我们可能不会意识到规范中的一些异常。而引擎需要处理（这些异常），通常很难理解。举例：读取属性时，引擎需要考虑到各种边界情况，通常在真实场景下不会发生。为什么会这样呢？有时是为了向后兼容，有时是其它原因 -- 每种情况都有不同。如果发现多余的操作，我们根本就不需要执行！优化引擎会发现这样的场景，尝试去除掉多余的操作。去除后的函数就称为 stub。

由于 JS 是动态类型语言，我们需要做很多假设。所以最好让属性保持单态 -- 换句话说，应该只有一个路径。一旦假设不匹配，就会发生反优化（deopt），优化过的函数也就不再生效。这无疑是我们要避免的。每次优化都是或多或少需要耗费资源，再次优化时就需要考虑到之前的情况，以避免属性不是单态。只要不多于 4 条路径，它就会保持多态（polymorphic）。多于 4 条路径的话，称为 megamorphic。

## 开始之前

只有传递了参数 `--allow-natives-syntax`， 才可以使用 `%` 为前缀的函数。

一般情况下，你**不应该**使用它们。在 V8 的源码（src/runtime）中可以找到它们的定义。所有会引起反优化的原因（bailout/deopt reasons）:https://cs.chromium.org/chromium/src/v8/src/bailout-reason.h)

传递参数 `--trace-opt`，可以查看你的函数是否被优化；传递 `--trace-deopt`，查看已优化的函数出现反优化的情况。

## 举例

## 例子 1

先来看一个非常简单的例子。

首先我们定义一个计算加法的函数 add，它接收 2 个加数，返回它们相加后的结果。很简单，对吧？继续看后面的代码：

```js
function add(a, b) {
  return a + b;
}

// 1. IC feedback unitialized
add(23, 44);
// 2. now it's pre-monomorphic
add(2, 88);
// let’s optimize 'add' on its next call
%OptimizeFunctionOnNextCall(add);
add(2, 7); // now we call our optimized function, feedback has been collected, let's see whether we can retrieve some deopts reason.
```

```bash
d8 --trace-deopt --print-opt-code --allow-natives-syntax --code-comments --turbo add.js
```

如果运行的 V8 版本低于 5.9，必须显式传递 `--turbo` 参数，以调用 TurboFan。

运行上面的命令，会得到以下类似输出：

```bash
--- Raw source ---
(a, b) {
  return a + b;
}


--- Optimized code ---
optimization_id = 0
source_position = 12
kind = OPTIMIZED_FUNCTION
name = add
stack_slots = 4
compiler = turbofan
Instructions (size = 151)
                  -- <add.js:1:13> --
                  -- B0 start (construct frame) --
0x19b11ce84220     0  55             push rbp
0x19b11ce84221     1  4889e5         REX.W movq rbp,rsp
0x19b11ce84224     4  56             push rsi
0x19b11ce84225     5  57             push rdi
0x19b11ce84226     6  493ba5700c0000 REX.W cmpq rsp,[r13+0xc70]
0x19b11ce8422d    13  0f863d000000   jna 80  (0x19b11ce84270)
                  -- B2 start --
                  -- B3 start (deconstruct frame) --
                  -- <add.js:2:12> --
0x19b11ce84233    19  488b4518       REX.W movq rax,[rbp+0x18]
0x19b11ce84237    23  a801           test al,0x1
0x19b11ce84239    25  0f8548000000   jnz 103  (0x19b11ce84287)
0x19b11ce8423f    31  488b5d10       REX.W movq rbx,[rbp+0x10]
0x19b11ce84243    35  f6c301         testb rbx,0x1
0x19b11ce84246    38  0f8540000000   jnz 108  (0x19b11ce8428c)
0x19b11ce8424c    44  488bd3         REX.W movq rdx,rbx
0x19b11ce8424f    47  48c1ea20       REX.W shrq rdx, 32
0x19b11ce84253    51  488bc8         REX.W movq rcx,rax
0x19b11ce84256    54  48c1e920       REX.W shrq rcx, 32
0x19b11ce8425a    58  03d1           addl rdx,rcx
0x19b11ce8425c    60  0f802f000000   jo 113  (0x19b11ce84291)
                  -- <add.js:3:1> --
0x19b11ce84262    66  48c1e220       REX.W shlq rdx, 32
0x19b11ce84266    70  488bc2         REX.W movq rax,rdx
0x19b11ce84269    73  488be5         REX.W movq rsp,rbp
0x19b11ce8426c    76  5d             pop rbp
0x19b11ce8426d    77  c21800         ret 0x18
                  -- B4 start (no frame) --
                  -- B1 start (deferred) --
                  -- <add.js:1:13> --
0x19b11ce84270    80  48bb00d66b0201000000 REX.W movq rbx,0x1026bd600    ;; external reference (Runtime::StackGuard)
0x19b11ce8427a    90  33c0           xorl rax,rax
0x19b11ce8427c    92  488b75f8       REX.W movq rsi,[rbp-0x8]
0x19b11ce84280    96  e81bffdfff     call 0x19b11cc841a0     ;; code: STUB, CEntryStub, minor: 8
0x19b11ce84285   101  ebac           jmp 19  (0x19b11ce84233)
0x19b11ce84287   103  e874fdc7ff     call 0x19b11cb04000     ;; debug: deopt position, script offset '32'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'not a Smi'
                                                             ;; debug: deopt index 0
                                                             ;; deoptimization bailout 0
0x19b11ce8428c   108  e879fdc7ff     call 0x19b11cb0400a     ;; debug: deopt position, script offset '32'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'not a Smi'
                                                             ;; debug: deopt index 1
                                                             ;; deoptimization bailout 1
0x19b11ce84291   113  e87efdc7ff     call 0x19b11cb04014     ;; debug: deopt position, script offset '32'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'overflow'
                                                             ;; debug: deopt index 2
                                                             ;; deoptimization bailout 2
0x19b11ce84296   118  90             nop
0x19b11ce84297   119  90             nop
0x19b11ce84298   120  90             nop
0x19b11ce84299   121  90             nop
0x19b11ce8429a   122  90             nop
0x19b11ce8429b   123  90             nop
0x19b11ce8429c   124  90             nop
0x19b11ce8429d   125  90             nop
0x19b11ce8429e   126  90             nop
0x19b11ce8429f   127  90             nop
0x19b11ce842a0   128  90             nop
0x19b11ce842a1   129  90             nop
0x19b11ce842a2   130  90             nop
0x19b11ce842a3   131  90             nop
                  ;;; Safepoint table.

Source positions:
 pc offset  position
         0        12
        19        32
        66        37
        80        12

Inlined functions (count = 0)

Deoptimization Input Data (deopt points = 4)
 index  ast id    argc     pc
     0       0       0     -1
     1       0       0     -1
     2       0       0     -1
     3       0       0    101

Safepoints (size = 19)
0x19b11ce84285   101  0000 (sp -> fp)       3

RelocInfo (size = 169)
0x19b11ce84220  comment  (-- <add.js:1:13> --)
0x19b11ce84220  comment  (-- B0 start (construct frame) --)
0x19b11ce84233  comment  (-- B2 start --)
0x19b11ce84233  comment  (-- B3 start (deconstruct frame) --)
0x19b11ce84233  comment  (-- <add.js:2:12> --)
0x19b11ce84262  comment  (-- <add.js:3:1> --)
0x19b11ce84270  comment  (-- B4 start (no frame) --)
0x19b11ce84270  comment  (-- B1 start (deferred) --)
0x19b11ce84270  comment  (-- <add.js:1:13> --)
0x19b11ce84272  external reference (Runtime::StackGuard)  (0x1026bd600)
0x19b11ce84281  code target (STUB)  (0x19b11cc841a0)
0x19b11ce84287  deopt script offset  (32)
0x19b11ce84287  deopt inlining id  (-1)
0x19b11ce84287  deopt reason  (not a Smi)
0x19b11ce84287  deopt index
0x19b11ce84288  runtime entry  (deoptimization bailout 0)
0x19b11ce8428c  deopt script offset  (32)
0x19b11ce8428c  deopt inlining id  (-1)
0x19b11ce8428c  deopt reason  (not a Smi)
0x19b11ce8428c  deopt index
0x19b11ce8428d  runtime entry  (deoptimization bailout 1)
0x19b11ce84291  deopt script offset  (32)
0x19b11ce84291  deopt inlining id  (-1)
0x19b11ce84291  deopt reason  (overflow)
0x19b11ce84291  deopt index
0x19b11ce84292  runtime entry  (deoptimization bailout 2)
0x19b11ce842a4  comment  (;;; Safepoint table.)

--- End code ---
```

如你所见，这里有至少 3 种不同情况，我们的函数（add）出现反优化（deopt）。

如果将 lazy deopt 考虑在内，会发现更多，但我们还是关注 eager deopt。

顺便讲一句，此时这里有三种类型的反优化：eager、lazy、soft。

可能看起来有些难懂可怕，别担心，你很快就会明白的！

从第一个反优化开始：

```
// ;; debug: deopt index 0
```

原因是：“not a Smi”。如果已经听说过 Smi，你就可以直接跳过这一段了。

Smi 本质上就是小整数的缩写（small integer）。它与 V8 中其它对象有很多不同。在 V8 的源码中位于 objects.h: https://chromium.googlesource.com/v8/v8.git/+/master/src/objects.h

你会发现，Smi不是堆对象。

堆对象，指所有分配于堆上的变量的超类。我们（前端开发者）能够存取的变量本质上是 JSReceiver 的子类。

比如，我们经常用的数组（JSArray）和函数（JSFunction）就继承自这个类（JSReceiver）。

查找 Javascript schemes 标签的相关信息，你会发现 Smi 不同于它们。

在 64 位机器上，Smi 是 32 位有符号整数；而在 32 位机器上，它是 31 位有符号整数。

如果传给它这个这个范围之外的值，这个函数就会发生反优化。

比如：

```
add(2 ** 31, 0)
```

因为 2\*\*31 大于 2\*\*31 - 1，所以会发生反优化。

当然，如果传给它数字之外的值，比如字符串、数组或其它类型的值，也会发生反优化。例如：

```
add([], 0);

add({ foo: 'bar' }, 2);
```

接下来看第二个反优化的情况。

```
;; debug: deopt index 1
```

与上面的情况类似，唯一的区别是它检查的是第二个参数 `b`。
```
add(0, 2 ** 31) // would cause a deopt as well.
```

好，来看最后一个情况：

```
;; debug: deopt index 2
```

'Overlow'

你已经明白 Smi 是什么了，这儿就很容易理解了。

根本原因是，参数检查通过了，但函数的返回值却不是 Smi。例子：

```
add(1, 2 ** 31 - 1); // returned value higher than 2 ** 31 - 1
```

### 例子2

我们继续来声明一个看起来相同的函数。

```
function concat(a, b) {
  return a + b;
}

concat('netguru', ' .com');
concat('p0lip loves ', 'v8');
%OptimizeFunctionOnNextCall(concat);
concat('optimized now! ', 'wooohooo');
```

看起来一样的函数，结果却不相同。为什么呢？同样的函数检查却不相同？

不！这些检查是类型相关的，也就是说 -- 引擎并不会提前做出假设，它仅在函数执行过程中做出调整和优化。因此，即使这两个函数看起来一样，但是路径（path）却不相同。

这个例子中，我们的函数是由 Crankshaft 优化。

```
--- Raw source ---
(a, b) {
  return a + b;
}


--- Optimized code ---
optimization_id = 0
source_position = 15
kind = OPTIMIZED_FUNCTION
name = concat
stack_slots = 5
compiler = crankshaft
Instructions (size = 194)
0x3ba8de705000     0  55             push rbp
0x3ba8de705001     1  4889e5         REX.W movq rbp,rsp
0x3ba8de705004     4  56             push rsi
0x3ba8de705005     5  57             push rdi
0x3ba8de705006     6  4883ec08       REX.W subq rsp,0x8
0x3ba8de70500a    10  50             push rax
0x3ba8de70500b    11  b801000000     movl rax,0x1
0x3ba8de705010    16  49baefdeefbeaddeefbe REX.W movq r10,0xbeefdeadbeefdeef
0x3ba8de70501a    26  4c8914c4       REX.W movq [rsp+rax*8],r10
0x3ba8de70501e    30  ffc8           decl rax
0x3ba8de705020    32  75f8           jnz 26  (0x3ba8de70501a)
0x3ba8de705022    34  58             pop rax
                  ;;; <@0,#0> -------------------- B0 --------------------
                  ;;; <@8,#5> prologue
                  ;;; Prologue begin
                  ;;; Prologue end
                  ;;; <@12,#7> -------------------- B1 --------------------
                  ;;; <@14,#8> context
0x3ba8de705023    35  488b45f8       REX.W movq rax,[rbp-0x8]
                  ;;; <@15,#8> gap
0x3ba8de705027    39  488945e8       REX.W movq [rbp-0x18],rax
                  ;;; <@18,#12> -------------------- B2 --------------------
                  ;;; <@19,#12> gap
0x3ba8de70502b    43  488bf0         REX.W movq rsi,rax
                  ;;; <@20,#14> stack-check
0x3ba8de70502e    46  493ba5700c0000 REX.W cmpq rsp,[r13+0xc70]
0x3ba8de705035    53  7305           jnc 60  (0x3ba8de70503c)
0x3ba8de705037    55  e86426efff     call StackCheck  (0x3ba8de5f76a0)    ;; code: BUILTIN
                  ;;; <@22,#14> lazy-bailout
                  ;;; <@23,#14> gap
0x3ba8de70503c    60  488b5d18       REX.W movq rbx,[rbp+0x18]
                  ;;; <@24,#16> check-non-smi
0x3ba8de705040    64  f6c301         testb rbx,0x1
0x3ba8de705043    67  0f8447000000   jz 144  (0x3ba8de705090)
                  ;;; <@26,#17> check-instance-type
0x3ba8de705049    73  4c8b53ff       REX.W movq r10,[rbx-0x1]
0x3ba8de70504d    77  41f6420b80     testb [r10+0xb],0x80
0x3ba8de705052    82  0f853d000000   jnz 149  (0x3ba8de705095)
                  ;;; <@27,#17> gap
0x3ba8de705058    88  488b4d10       REX.W movq rcx,[rbp+0x10]
                  ;;; <@28,#18> check-non-smi
0x3ba8de70505c    92  f6c101         testb rcx,0x1
0x3ba8de70505f    95  0f8435000000   jz 154  (0x3ba8de70509a)
                  ;;; <@30,#19> check-instance-type
0x3ba8de705065   101  4c8b51ff       REX.W movq r10,[rcx-0x1]
0x3ba8de705069   105  41f6420b80     testb [r10+0xb],0x80
0x3ba8de70506e   110  0f852b000000   jnz 159  (0x3ba8de70509f)
                  ;;; <@31,#19> gap
0x3ba8de705074   116  488b75e8       REX.W movq rsi,[rbp-0x18]
0x3ba8de705078   120  488bd3         REX.W movq rdx,rbx
0x3ba8de70507b   123  488bc1         REX.W movq rax,rcx
                  ;;; <@32,#20> string-add
0x3ba8de70507e   126  e8fd63e2ff     call 0x3ba8de52b480     ;; code: STUB, StringAddStub, minor: 0
                  ;;; <@34,#20> lazy-bailout
                  ;;; <@36,#22> return
0x3ba8de705083   131  488be5         REX.W movq rsp,rbp
0x3ba8de705086   134  5d             pop rbp
0x3ba8de705087   135  c21800         ret 0x18
0x3ba8de70508a   138  660f1f440000   nop
                  ;;; -------------------- Jump table --------------------
0x3ba8de705090   144  e875efc7ff     call 0x3ba8de38400a     ;; debug: deopt position, script offset '35'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'Smi'
                                                             ;; debug: deopt index 1
                                                             ;; deoptimization bailout 1
0x3ba8de705095   149  e87aefc7ff     call 0x3ba8de384014     ;; debug: deopt position, script offset '35'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'wrong instance type'
                                                             ;; debug: deopt index 2
                                                             ;; deoptimization bailout 2
0x3ba8de70509a   154  e87fefc7ff     call 0x3ba8de38401e     ;; debug: deopt position, script offset '35'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'Smi'
                                                             ;; debug: deopt index 3
                                                             ;; deoptimization bailout 3
0x3ba8de70509f   159  e884efc7ff     call 0x3ba8de384028     ;; debug: deopt position, script offset '35'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'wrong instance type'
                                                             ;; debug: deopt index 4
                                                             ;; deoptimization bailout 4
                  ;;; Safepoint table.

Source positions:
 pc offset  position
        64        35
        73        35
        73        35
        88        35
        92        35
       101        35
       101        35
       116        35
       126        35
       131        35
       131        35
       131        35
       131        35
       138        35

Inlined functions (count = 0)

Deoptimization Input Data (deopt points = 6)
 index  ast id    argc     pc
     0       4       0     60
     1       4       0     -1
     2       4       0     -1
     3       4       0     -1
     4       4       0     -1
     5       4       0    131

Safepoints (size = 30)
0x3ba8de70503c    60  10000 (sp -> fp)       0
0x3ba8de705083   131  10000 (sp -> fp)       5

RelocInfo (size = 320)
0x3ba8de705023  comment  (;;; <@0,#0> -------------------- B0 --------------------)
0x3ba8de705023  comment  (;;; <@8,#5> prologue)
0x3ba8de705023  comment  (;;; Prologue begin)
0x3ba8de705023  comment  (;;; Prologue end)
0x3ba8de705023  comment  (;;; <@12,#7> -------------------- B1 --------------------)
0x3ba8de705023  comment  (;;; <@14,#8> context)
0x3ba8de705027  comment  (;;; <@15,#8> gap)
0x3ba8de70502b  comment  (;;; <@18,#12> -------------------- B2 --------------------)
0x3ba8de70502b  comment  (;;; <@19,#12> gap)
0x3ba8de70502e  comment  (;;; <@20,#14> stack-check)
0x3ba8de705038  code target (BUILTIN)  (0x3ba8de5f76a0)
0x3ba8de70503c  comment  (;;; <@22,#14> lazy-bailout)
0x3ba8de70503c  comment  (;;; <@23,#14> gap)
0x3ba8de705040  comment  (;;; <@24,#16> check-non-smi)
0x3ba8de705049  comment  (;;; <@26,#17> check-instance-type)
0x3ba8de705058  comment  (;;; <@27,#17> gap)
0x3ba8de70505c  comment  (;;; <@28,#18> check-non-smi)
0x3ba8de705065  comment  (;;; <@30,#19> check-instance-type)
0x3ba8de705074  comment  (;;; <@31,#19> gap)
0x3ba8de70507e  comment  (;;; <@32,#20> string-add)
0x3ba8de70507f  code target (STUB)  (0x3ba8de52b480)
0x3ba8de705083  comment  (;;; <@34,#20> lazy-bailout)
0x3ba8de705083  comment  (;;; <@36,#22> return)
0x3ba8de705090  comment  (;;; -------------------- Jump table --------------------)
0x3ba8de705090  deopt script offset  (35)
0x3ba8de705090  deopt inlining id  (-1)
0x3ba8de705090  deopt reason  (Smi)
0x3ba8de705090  deopt index
0x3ba8de705091  runtime entry  (deoptimization bailout 1)
0x3ba8de705095  deopt script offset  (35)
0x3ba8de705095  deopt inlining id  (-1)
0x3ba8de705095  deopt reason  (wrong instance type)
0x3ba8de705095  deopt index
0x3ba8de705096  runtime entry  (deoptimization bailout 2)
0x3ba8de70509a  deopt script offset  (35)
0x3ba8de70509a  deopt inlining id  (-1)
0x3ba8de70509a  deopt reason  (Smi)
0x3ba8de70509a  deopt index
0x3ba8de70509b  runtime entry  (deoptimization bailout 3)
0x3ba8de70509f  deopt script offset  (35)
0x3ba8de70509f  deopt inlining id  (-1)
0x3ba8de70509f  deopt reason  (wrong instance type)
0x3ba8de70509f  deopt index
0x3ba8de7050a0  runtime entry  (deoptimization bailout 4)
0x3ba8de7050a4  comment  (;;; Safepoint table.)

--- End code ---
```

```
;; debug: deopt index 1
```

一旦你不传给它 Smi，而是传递一个堆对象时，就会发生反优化。事实上，它与 “Not a Smi” 相反，所以我不会详细解释它。它仅仅检查了参数“a”？
```
;; debug: deopt index 2
```

'wrong instance type' – 有趣！目前为止，我们还没见过它！

很容易猜到，这次检查失败是因为你没有传递 string，或者没有传值。
```
concat([], 'd');

concat(new String('d'), 'xx');
```

最后 2 个原因和上面相同，但是检查第 2 个参数 “b”。

### 例子 3

我们来看一个稍微不同的例子。

```
function elemAt(arr, index) {
  return arr[index];
}

elemAt([2, 3, 4], 0);
elemAt([9, 4, 1], 2);
%OptimizeFunctionOnNextCall(elemAt);
elemAt([2], 0);
```

```
d8 --trace-deopt --code-comments --print-opt-code --allow-natives-syntax --turbo elem-at.js
```

```
--- Raw source ---
(arr, index) {
  return arr[index];
}


--- Optimized code ---
optimization_id = 0
source_position = 15
kind = OPTIMIZED_FUNCTION
name = elemAt
stack_slots = 6
compiler = turbofan
Instructions (size = 327)
                  -- <elemAt.js:1:16> --
                  -- B0 start (construct frame) --
0x1aa58ba04220     0  55             push rbp
0x1aa58ba04221     1  4889e5         REX.W movq rbp,rsp
0x1aa58ba04224     4  56             push rsi
0x1aa58ba04225     5  57             push rdi
0x1aa58ba04226     6  4883ec10       REX.W subq rsp,0x10
0x1aa58ba0422a    10  493ba5700c0000 REX.W cmpq rsp,[r13+0xc70]
0x1aa58ba04231    17  0f8675000000   jna 140  (0x1aa58ba042ac)
                  -- B2 start --
                  -- B3 start --
                  -- <elemAt.js:2:14> --
0x1aa58ba04237    23  488b4518       REX.W movq rax,[rbp+0x18]
0x1aa58ba0423b    27  a801           test al,0x1
0x1aa58ba0423d    29  0f84e3000000   jz 262  (0x1aa58ba04326)
0x1aa58ba04243    35  48bb793c503e5d080000 REX.W movq rbx,0x85d3e503c79    ;; object: 0x85d3e503c79 <Map(FAST_SMI_ELEMENTS)>
0x1aa58ba0424d    45  483958ff       REX.W cmpq [rax-0x1],rbx
0x1aa58ba04251    49  0f85d4000000   jnz 267  (0x1aa58ba0432b)
0x1aa58ba04257    55  488b580f       REX.W movq rbx,[rax+0xf]
0x1aa58ba0425b    59  488b5017       REX.W movq rdx,[rax+0x17]
0x1aa58ba0425f    63  488b4d10       REX.W movq rcx,[rbp+0x10]
0x1aa58ba04263    67  f6c101         testb rcx,0x1
0x1aa58ba04266    70  0f855a000000   jnz 166  (0x1aa58ba042c6)
                  -- B8 start --
0x1aa58ba0426c    76  488bf1         REX.W movq rsi,rcx
0x1aa58ba0426f    79  48c1ee20       REX.W shrq rsi, 32
                  -- B9 start (deconstruct frame) --
0x1aa58ba04273    83  48c1ea20       REX.W shrq rdx, 32
0x1aa58ba04277    87  8bfe           movl rdi,rsi
0x1aa58ba04279    89  49ba0000000001000000 REX.W movq r10,0x100000000
0x1aa58ba04283    99  4c3bd7         REX.W cmpq r10,rdi
0x1aa58ba04286   102  7310           jnc 120  (0x1aa58ba04298)
                  Abort message: 
                  32 bit value in register is not zero-extended
0x1aa58ba04288   104  48ba0000000001000000 REX.W movq rdx,0x100000000
0x1aa58ba04292   114  e889fedfff     call Abort  (0x1aa58b804120)    ;; code: BUILTIN
0x1aa58ba04297   119  cc             int3l
0x1aa58ba04298   120  3bf2           cmpl rsi,rdx
0x1aa58ba0429a   122  0f8390000000   jnc 272  (0x1aa58ba04330)
0x1aa58ba042a0   128  488b44fb0f     REX.W movq rax,[rbx+rdi*8+0xf]
                  -- <elemAt.js:3:1> --
0x1aa58ba042a5   133  488be5         REX.W movq rsp,rbp
0x1aa58ba042a8   136  5d             pop rbp
0x1aa58ba042a9   137  c21800         ret 0x18
                  -- B10 start (no frame) --
                  -- B1 start (deferred) --
                  -- <elemAt.js:1:16> --
0x1aa58ba042ac   140  48bb00f6900701000000 REX.W movq rbx,0x10790f600    ;; external reference (Runtime::StackGuard)
0x1aa58ba042b6   150  33c0           xorl rax,rax
0x1aa58ba042b8   152  488b75f8       REX.W movq rsi,[rbp-0x8]
0x1aa58ba042bc   156  e8dffedfff     call 0x1aa58b8041a0     ;; code: STUB, CEntryStub, minor: 8
0x1aa58ba042c1   161  e971ffffff     jmp 23  (0x1aa58ba04237)
                  -- B4 start (deferred) --
                  -- <elemAt.js:2:14> --
0x1aa58ba042c6   166  488b41ff       REX.W movq rax,[rcx-0x1]
0x1aa58ba042ca   170  49394550       REX.W cmpq [r13+0x50],rax
0x1aa58ba042ce   174  0f8561000000   jnz 277  (0x1aa58ba04335)
0x1aa58ba042d4   180  c5fb104107     vmovsd xmm0,[rcx+0x7]
0x1aa58ba042d9   185  c5fb2cf0       vcvttsd2si rsi,xmm0
0x1aa58ba042dd   189  c5f157c9       vxorpd xmm1,xmm1,xmm1
0x1aa58ba042e1   193  c5f32ace       vcvtlsi2sd xmm1,xmm1,rsi
0x1aa58ba042e5   197  c5f92ec8       vucomisd xmm1,xmm0
0x1aa58ba042e9   201  0f8a4b000000   jpe 282  (0x1aa58ba0433a)
0x1aa58ba042ef   207  0f8545000000   jnz 282  (0x1aa58ba0433a)
0x1aa58ba042f5   213  48895de8       REX.W movq [rbp-0x18],rbx
0x1aa58ba042f9   217  488955e0       REX.W movq [rbp-0x20],rdx
0x1aa58ba042fd   221  83fe00         cmpl rsi,0x0
0x1aa58ba04300   224  0f850f000000   jnz 245  (0x1aa58ba04315)
                  -- B5 start (deferred) --
                  -- B6 start (deferred) --
0x1aa58ba04306   230  660f3a16c001   pextrd rax,xmm0,1
0x1aa58ba0430c   236  83f800         cmpl rax,0x0
0x1aa58ba0430f   239  0f8c2a000000   jl 287  (0x1aa58ba0433f)
                  -- B7 start (deferred) --
0x1aa58ba04315   245  488b5de8       REX.W movq rbx,[rbp-0x18]
0x1aa58ba04319   249  488b4518       REX.W movq rax,[rbp+0x18]
0x1aa58ba0431d   253  488b55e0       REX.W movq rdx,[rbp-0x20]
0x1aa58ba04321   257  e94dffffff     jmp 83  (0x1aa58ba04273)
0x1aa58ba04326   262  e8d5fcc7ff     call 0x1aa58b684000     ;; debug: deopt position, script offset '43'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'Smi'
                                                             ;; debug: deopt index 0
                                                             ;; deoptimization bailout 0
0x1aa58ba0432b   267  e8dafcc7ff     call 0x1aa58b68400a     ;; debug: deopt position, script offset '43'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'wrong map'
                                                             ;; debug: deopt index 1
                                                             ;; deoptimization bailout 1
0x1aa58ba04330   272  e8dffcc7ff     call 0x1aa58b684014     ;; debug: deopt position, script offset '43'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'out of bounds'
                                                             ;; debug: deopt index 2
                                                             ;; deoptimization bailout 2
0x1aa58ba04335   277  e8eefcc7ff     call 0x1aa58b684028     ;; debug: deopt position, script offset '43'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'not a heap number'
                                                             ;; debug: deopt index 4
                                                             ;; deoptimization bailout 4
0x1aa58ba0433a   282  e8f3fcc7ff     call 0x1aa58b684032     ;; debug: deopt position, script offset '43'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'lost precision or NaN'
                                                             ;; debug: deopt index 5
                                                             ;; deoptimization bailout 5
0x1aa58ba0433f   287  e8f8fcc7ff     call 0x1aa58b68403c     ;; debug: deopt position, script offset '43'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'minus zero'
                                                             ;; debug: deopt index 6
                                                             ;; deoptimization bailout 6
0x1aa58ba04344   292  90             nop
0x1aa58ba04345   293  90             nop
0x1aa58ba04346   294  90             nop
0x1aa58ba04347   295  90             nop
0x1aa58ba04348   296  90             nop
0x1aa58ba04349   297  90             nop
0x1aa58ba0434a   298  90             nop
0x1aa58ba0434b   299  90             nop
0x1aa58ba0434c   300  90             nop
0x1aa58ba0434d   301  90             nop
0x1aa58ba0434e   302  90             nop
0x1aa58ba0434f   303  90             nop
0x1aa58ba04350   304  90             nop
0x1aa58ba04351   305  0f1f00         nop
                  ;;; Safepoint table.

Source positions:
 pc offset  position
         0        15
        23        43
       133        51
       140        15
       166        43

Inlined functions (count = 0)

Deoptimization Input Data (deopt points = 7)
 index  ast id    argc     pc
     0       0       0     -1
     1       0       0     -1
     2       0       0     -1
     3       0       0    161
     4       0       0     -1
     5       0       0     -1
     6       0       0     -1

Safepoints (size = 19)
0x1aa58ba042c1   161  000000 (sp -> fp)       3

RelocInfo (size = 329)
0x1aa58ba04220  comment  (-- <elemAt.js:1:16> --)
0x1aa58ba04220  comment  (-- B0 start (construct frame) --)
0x1aa58ba04237  comment  (-- B2 start --)
0x1aa58ba04237  comment  (-- B3 start --)
0x1aa58ba04237  comment  (-- <elemAt.js:2:14> --)
0x1aa58ba04245  embedded object  (0x85d3e503c79 <Map(FAST_SMI_ELEMENTS)>)
0x1aa58ba0426c  comment  (-- B8 start --)
0x1aa58ba04273  comment  (-- B9 start (deconstruct frame) --)
0x1aa58ba04288  comment  (Abort message: )
0x1aa58ba04288  comment  (32 bit value in register is not zero-extended)
0x1aa58ba04293  code target (BUILTIN)  (0x1aa58b804120)
0x1aa58ba042a5  comment  (-- <elemAt.js:3:1> --)
0x1aa58ba042ac  comment  (-- B10 start (no frame) --)
0x1aa58ba042ac  comment  (-- B1 start (deferred) --)
0x1aa58ba042ac  comment  (-- <elemAt.js:1:16> --)
0x1aa58ba042ae  external reference (Runtime::StackGuard)  (0x10790f600)
0x1aa58ba042bd  code target (STUB)  (0x1aa58b8041a0)
0x1aa58ba042c6  comment  (-- B4 start (deferred) --)
0x1aa58ba042c6  comment  (-- <elemAt.js:2:14> --)
0x1aa58ba04306  comment  (-- B5 start (deferred) --)
0x1aa58ba04306  comment  (-- B6 start (deferred) --)
0x1aa58ba04315  comment  (-- B7 start (deferred) --)
0x1aa58ba04326  deopt script offset  (43)
0x1aa58ba04326  deopt inlining id  (-1)
0x1aa58ba04326  deopt reason  (Smi)
0x1aa58ba04326  deopt index
0x1aa58ba04327  runtime entry  (deoptimization bailout 0)
0x1aa58ba0432b  deopt script offset  (43)
0x1aa58ba0432b  deopt inlining id  (-1)
0x1aa58ba0432b  deopt reason  (wrong map)
0x1aa58ba0432b  deopt index
0x1aa58ba0432c  runtime entry  (deoptimization bailout 1)
0x1aa58ba04330  deopt script offset  (43)
0x1aa58ba04330  deopt inlining id  (-1)
0x1aa58ba04330  deopt reason  (out of bounds)
0x1aa58ba04330  deopt index
0x1aa58ba04331  runtime entry  (deoptimization bailout 2)
0x1aa58ba04335  deopt script offset  (43)
0x1aa58ba04335  deopt inlining id  (-1)
0x1aa58ba04335  deopt reason  (not a heap number)
0x1aa58ba04335  deopt index
0x1aa58ba04336  runtime entry  (deoptimization bailout 4)
0x1aa58ba0433a  deopt script offset  (43)
0x1aa58ba0433a  deopt inlining id  (-1)
0x1aa58ba0433a  deopt reason  (lost precision or NaN)
0x1aa58ba0433a  deopt index
0x1aa58ba0433b  runtime entry  (deoptimization bailout 5)
0x1aa58ba0433f  deopt script offset  (43)
0x1aa58ba0433f  deopt inlining id  (-1)
0x1aa58ba0433f  deopt reason  (minus zero)
0x1aa58ba0433f  deopt index
0x1aa58ba04340  runtime entry  (deoptimization bailout 6)
0x1aa58ba04354  comment  (;;; Safepoint table.)

--- End code ---
```

在解释这个之前，我们要先确保已经了解 hidden map（也称 hidden class）。如上文中提到的，引擎会做很多假设来减少一些无用操作花费的时间。然而，我们也要了解元素 -- 每个元素都有类型。V8 实现了 [TypeFeedbackVector](https://github.com/v8/v8/blob/master/src/feedback-vector.h)。推荐你阅读[这篇文章](http://ripsawridge.github.io/articles/stack-changes/)了解更多详情。已知类型见 https://chromium.googlesource.com/v8/v8.git/+/master/src/elements-kind.h

也有一些原生函数可以帮助我们检查元素是否匹配已有类型。它们的定义见上段链接，对应的原生名称见 https://chromium.googlesource.com/v8/v8.git/+/master/src/runtime/runtime.h#590 。

现在再来看反优化。

```
;; debug: deopt reason 'Smi' 

;; debug: deopt index 0
```

显而易见。这是由于你给函数的第一个参数 “arr” 传递了 Smi。

```
;; debug: deopt reason 'wrong map'
;; debug: deopt index 1
```

很不幸，这种情况经常发生。

我们的 map（类型）是： `<Map(FAST_SMI_ELEMENTS)>`

因此，一旦“arr”中的元素不同于 Smi 元素，map 就不再匹配。当我们向它传递的参数不是普通数组而是其它类型时，这种情况就会发生。比如：

```
elemAt([‘netguru’], 0);

elemAt({ 0: ‘netguru’ }, 0);
```

如果你想检查数组是否由 Smi 元素组成，可以使用上面提到的原生函数 `%HasFastSmiElements`。

```
print(%HasFastSmiElements([2, 4, 5])); // prints true

print(%HasFastSmiElements([2, 4, 'd'])); // prints false

print(%HasFastSmiElements([2.1])); // prints false

print(%HasFastSmiElements({})); // prints false
```

好，我们现在来检查第二个参数 `index`，你很快就发现，它的反优化依赖于第二个参数。

```
;; debug: deopt reason 'out of bounds'
;; debug: deopt index 2
```

“Out of bounds“，从字面上看，当索引大于数组的长度，或者小于 0 时，就会导致反优化。
也就是说，你在试图读取索引不属于数组的元素。

举例：

```
elemAt([2,3,5], 4);
```

```
;; debug: deopt reason 'not a heap number'
;; debug: deopt index 4
```

'not a heap number' – 不是数字（注意不要与 Smi 混淆），举例：

```
elemAt([2,3,5], '2');

elemAt([2,3,5], new Number(5));
```

```
;; debug: deopt reason 'lost precision or NaN'
;; debug: deopt index 5
```

如果你遇到这种检查，意味着你传递了一个数字，但不是正常值。
丢失精度 -- 不是整数， 例子 1.1

```
elemAt([0, 1], 1.1);

elemAt([0], NaN);
```

```
;; debug: deopt reason 'minus zero'
;; debug: deopt index 6
```

太容易了！

```
add(0, -0); // weird, I know
```

也很容易理解！

还有一个例子 -- 上面例子组合的情况。这儿就不详细解释了，还是留给你做练习吧 :)

```
let secondIndex = 0;

function elemAtComplex(arr, index) {
  return arr[secondIndex + index];
}

elemAtComplex(['v8 ',' is',' awesome'], 0);
secondIndex++;
elemAtComplex(['netguru ',' loves',' Node.js'], 1);
secondIndex++;
%OptimizeFunctionOnNextCall(elemAtComplex);
elemAtComplex(['wooo','dooo','dooboo'], 0);
```

给出结果，以免你没有安装 d8 :)

```
--- Raw source ---
(arr, index) {
  return arr[secondIndex + index];
}


--- Optimized code ---
optimization_id = 0
source_position = 44
kind = OPTIMIZED_FUNCTION
name = elemAtComplex
stack_slots = 4
compiler = turbofan
Instructions (size = 314)
0xc145e604220     0  55             push rbp
0xc145e604221     1  4889e5         REX.W movq rbp,rsp
0xc145e604224     4  56             push rsi
0xc145e604225     5  57             push rdi
0xc145e604226     6  493ba5700c0000 REX.W cmpq rsp,[r13+0xc70]
0xc145e60422d    13  0f86c1000000   jna 212  (0xc145e6042f4)
0xc145e604233    19  48b8c11323e96e3f0000 REX.W movq rax,0x3f6ee92313c1    ;; object: 0x3f6ee92313c1 <FixedArray[5]>
0xc145e60423d    29  488b402f       REX.W movq rax,[rax+0x2f]
0xc145e604241    33  493945a8       REX.W cmpq [r13-0x58],rax
0xc145e604245    37  0f8523000000   jnz 78  (0xc145e60426e)
0xc145e60424b    43  48b8690c23e96e3f0000 REX.W movq rax,0x3f6ee9230c69    ;; object: 0x3f6ee9230c69 <String[11]: secondIndex>
0xc145e604255    53  50             push rax
0xc145e604256    54  48bb50680d0501000000 REX.W movq rbx,0x1050d6850    ;; external reference (Runtime::ThrowReferenceError)
0xc145e604260    64  b801000000     movl rax,0x1
0xc145e604265    69  488b75f8       REX.W movq rsi,[rbp-0x8]
0xc145e604269    73  e832ffdfff     call 0xc145e4041a0       ;; code: STUB, CEntryStub, minor: 8
0xc145e60426e    78  a801           test al,0x1
0xc145e604270    80  0f8598000000   jnz 238  (0xc145e60430e)
0xc145e604276    86  488b5d10       REX.W movq rbx,[rbp+0x10]
0xc145e60427a    90  f6c301         testb rbx,0x1
0xc145e60427d    93  0f8590000000   jnz 243  (0xc145e604313)
0xc145e604283    99  488bd3         REX.W movq rdx,rbx
0xc145e604286   102  48c1ea20       REX.W shrq rdx, 32
0xc145e60428a   106  488bc8         REX.W movq rcx,rax
0xc145e60428d   109  48c1e920       REX.W shrq rcx, 32
0xc145e604291   113  03d1           addl rdx,rcx
0xc145e604293   115  0f807f000000   jo 248  (0xc145e604318)
0xc145e604299   121  488b4d18       REX.W movq rcx,[rbp+0x18]
0xc145e60429d   125  f6c101         testb rcx,0x1
0xc145e6042a0   128  0f8477000000   jz 253  (0xc145e60431d)
0xc145e6042a6   134  48be713be83d350d0000 REX.W movq rsi,0xd353de83b71    ;; object: 0xd353de83b71 <Map(FAST_ELEMENTS)>
0xc145e6042b0   144  483971ff       REX.W cmpq [rcx-0x1],rsi
0xc145e6042b4   148  0f8568000000   jnz 258  (0xc145e604322)
0xc145e6042ba   154  488b710f       REX.W movq rsi,[rcx+0xf]
0xc145e6042be   158  8b791b         movl rdi,[rcx+0x1b]
0xc145e6042c1   161  49ba0000000001000000 REX.W movq r10,0x100000000
0xc145e6042cb   171  4c3bd7         REX.W cmpq r10,rdi
0xc145e6042ce   174  7310           jnc 192  (0xc145e6042e0)
0xc145e6042d0   176  48ba0000000001000000 REX.W movq rdx,0x100000000
0xc145e6042da   186  e841fedfff     call Abort  (0xc145e404120)    ;; code: BUILTIN
0xc145e6042df   191  cc             int3l
0xc145e6042e0   192  3bd7           cmpl rdx,rdi
0xc145e6042e2   194  0f833f000000   jnc 263  (0xc145e604327)
0xc145e6042e8   200  488b44d60f     REX.W movq rax,[rsi+rdx*8+0xf]
0xc145e6042ed   205  488be5         REX.W movq rsp,rbp
0xc145e6042f0   208  5d             pop rbp
0xc145e6042f1   209  c21800         ret 0x18
0xc145e6042f4   212  48bb00b60d0501000000 REX.W movq rbx,0x1050db600    ;; external reference (Runtime::StackGuard)
0xc145e6042fe   222  33c0           xorl rax,rax
0xc145e604300   224  488b75f8       REX.W movq rsi,[rbp-0x8]
0xc145e604304   228  e897fedfff     call 0xc145e4041a0       ;; code: STUB, CEntryStub, minor: 8
0xc145e604309   233  e925ffffff     jmp 19  (0xc145e604233)
0xc145e60430e   238  e801fdc7ff     call 0xc145e284014       ;; debug: deopt position, script offset '84'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'not a Smi'
                                                             ;; debug: deopt index 2
                                                             ;; deoptimization bailout 2
0xc145e604313   243  e806fdc7ff     call 0xc145e28401e       ;; debug: deopt position, script offset '84'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'not a Smi'
                                                             ;; debug: deopt index 3
                                                             ;; deoptimization bailout 3
0xc145e604318   248  e80bfdc7ff     call 0xc145e284028       ;; debug: deopt position, script offset '84'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'overflow'
                                                             ;; debug: deopt index 4
                                                             ;; deoptimization bailout 4
0xc145e60431d   253  e810fdc7ff     call 0xc145e284032       ;; debug: deopt position, script offset '84'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'Smi'
                                                             ;; debug: deopt index 5
                                                             ;; deoptimization bailout 5
0xc145e604322   258  e815fdc7ff     call 0xc145e28403c       ;; debug: deopt position, script offset '84'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'wrong map'
                                                             ;; debug: deopt index 6
                                                             ;; deoptimization bailout 6
0xc145e604327   263  e81afdc7ff     call 0xc145e284046       ;; debug: deopt position, script offset '84'
                                                             ;; debug: deopt position, inlining id '-1'
                                                             ;; debug: deopt reason 'out of bounds'
                                                             ;; debug: deopt index 7
                                                             ;; deoptimization bailout 7
0xc145e60432c   268  90             nop
0xc145e60432d   269  90             nop
0xc145e60432e   270  90             nop
0xc145e60432f   271  90             nop
0xc145e604330   272  90             nop
0xc145e604331   273  90             nop
0xc145e604332   274  90             nop
0xc145e604333   275  90             nop
0xc145e604334   276  90             nop
0xc145e604335   277  90             nop
0xc145e604336   278  90             nop
0xc145e604337   279  90             nop
0xc145e604338   280  90             nop
0xc145e604339   281  0f1f00         nop

Source positions:
 pc offset  position
         0        44
        19        61
        54        72
        78        84
       205        94
       212        44

Inlined functions (count = 0)

Deoptimization Input Data (deopt points = 9)
 index  ast id    argc     pc
     0      12       0     78
     1      12       0     -1
     2      21       0     -1
     3      21       0     -1
     4      21       0     -1
     5      21       0     -1
     6      21       0     -1
     7      21       0     -1
     8       0       0    233

Safepoints (size = 30)
0xc145e60426e    78  0000 (sp -> fp)       1
0xc145e604309   233  0000 (sp -> fp)       8

RelocInfo (size = 142)
0xc145e604235  embedded object  (0x3f6ee92313c1 <FixedArray[5]>)
0xc145e60424d  embedded object  (0x3f6ee9230c69 <String[11]: secondIndex>)
0xc145e604258  external reference (Runtime::ThrowReferenceError)  (0x1050d6850)
0xc145e60426a  code target (STUB)  (0xc145e4041a0)
0xc145e6042a8  embedded object  (0xd353de83b71 <Map(FAST_ELEMENTS)>)
0xc145e6042db  code target (BUILTIN)  (0xc145e404120)
0xc145e6042f6  external reference (Runtime::StackGuard)  (0x1050db600)
0xc145e604305  code target (STUB)  (0xc145e4041a0)
0xc145e60430e  deopt script offset  (84)
0xc145e60430e  deopt inlining id  (-1)
0xc145e60430e  deopt reason  (not a Smi)
0xc145e60430e  deopt index
0xc145e60430f  runtime entry  (deoptimization bailout 2)
0xc145e604313  deopt script offset  (84)
0xc145e604313  deopt inlining id  (-1)
0xc145e604313  deopt reason  (not a Smi)
0xc145e604313  deopt index
0xc145e604314  runtime entry  (deoptimization bailout 3)
0xc145e604318  deopt script offset  (84)
0xc145e604318  deopt inlining id  (-1)
0xc145e604318  deopt reason  (overflow)
0xc145e604318  deopt index
0xc145e604319  runtime entry  (deoptimization bailout 4)
0xc145e60431d  deopt script offset  (84)
0xc145e60431d  deopt inlining id  (-1)
0xc145e60431d  deopt reason  (Smi)
0xc145e60431d  deopt index
0xc145e60431e  runtime entry  (deoptimization bailout 5)
0xc145e604322  deopt script offset  (84)
0xc145e604322  deopt inlining id  (-1)
0xc145e604322  deopt reason  (wrong map)
0xc145e604322  deopt index
0xc145e604323  runtime entry  (deoptimization bailout 6)
0xc145e604327  deopt script offset  (84)
0xc145e604327  deopt inlining id  (-1)
0xc145e604327  deopt reason  (out of bounds)
0xc145e604327  deopt index
0xc145e604328  runtime entry  (deoptimization bailout 7)

--- End code ---
```

就到这儿，结束了！

我们看了 2 个非常简单的例子，希望你能明白总的思想。

想看你的函数反优化的情况，只要传递 `--trace-opt`就好。

总的来说，不要过度优化，因为可能会伤害代码可读性（比如函数 ele-at 的第 3 个例子）。你也可以传递字符串数组或其它，这没问题。然而，如果真的不需要优化，就不要（优化）。就第 1 个例子而言，我认为即使 2 个函数看起来相同，最好还是能分成 2 个不同名称的函数，这样其他开发者看到 concat 或者 sum，马上就知道这个函数的作用。

未来，你可以添加 string 特有的操作，比如 (a + b).toUpperCase()，而不需要对 sum 函数做任何特殊处理。

最后，你应该牢记过度优化可能会伤害可读性，最终导致不可维护的代码。尽量不要使用任何编译语言中不适用的奇怪模式。

最后的最后，我要感谢 Google 的软件工程师、V8 团队软件工程师兼技术领导 [Benedikt Meurer](https://twitter.com/bmeurer)，是他帮助校对了本文。这里是他的博客：http://benediktmeurer.de/

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
