
> * 原文地址：[Tracing Patterns that Might Hinder Performance](https://www.netguru.co/blog/tracing-patterns-hinder-performance)
> * 原文作者：[Jakub Rożek](https://www.netguru.co/blog/tracing-patterns-hinder-performance)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/tracing-patterns-hinder-performance.md](https://github.com/xitu/gold-miner/blob/master/TODO/tracing-patterns-hinder-performance.md)
> * 译者：
> * 校对者：

# Tracing Patterns that Might Hinder Performance

There is a pretty good chance you will encounter at least one unresponsive app or a slowly loading web page today. It’s 2017 already, and we want to do everything more quickly, yet we still experience annoying delays. How is that possible? Doesn’t our Internet connection improve every year? Doesn’t our browser perform better day by day? In this article, we will cover the latter.


Indeed, browsers and their engines are getting faster, new features are added all the time, and some other legacy features are becoming obsolete. The same happens to websites and apps. They also become heavier and larger, therefore we must take into account that even though browsers and hardware are always improving, we still need to take care of the performance – at least to some extent. You will find out shortly how to avoid a few popular pitfalls and improve the overall performance of apps and websites, but before that, let’s have a bit of an overview.

## Optimisation

I could probably write an entire book explaining the pipeline, but in this article, I want to focus on the key aspects that will help you optimise the process. I will describe the common mistakes that can substantially hurt performance. For the sake of brevity, I will not talk about parsing, AST, machine code generation, GC (Garbage Collector), feedback collection or OSR (on-stack replacement), but fear you not – we’ll give those issues more space in future articles.

### The Old World

Let’s start with the old world (baseline compiler + Crankshaft), which became obsolete as of Chrome M59.

The baseline compiler doesn’t perform any magical optimisations. It just compiles the code quickly and lets it execute. You must be aware that the generating efficiently optimised code relies heavily on speculative optimisations, which in turn require type feedback to speculate on, so you need to run the baseline first.

In case your function becomes “hot” (it’s a common definition for function that the engine finds worth optimising), Crankshaft kicks in and does its magic. The performance of such code is very, very decent, comparable to Java. This approach was one of the first in the industry and it brought about a massive performance boost. As a result, JS could finally be executed smoothly and frontend developers were able to create complex web applications.

### The New World

As the web evolved, new frameworks arrived, and specifications changed, extending Crankshaft capabilities became troublesome. Some patterns had never been given much love by Crankshaft, for instance certain accesses to arguments object (the safe uses were on unmonkey-patched Function.prototype.apply, length access and in-bound indices) or using a try catch statement. There were lots of [other patterns too](https://github.com/petkaantonov/bluebird/wiki/Optimization-killers). Luckily, Ignition and TurboFan can solve a few of those performance bottlenecks. Now, some patterns can be optimised in a more sophisticated way. As stated earlier, optimisation is expensive, and it takes some resources (which might be little on mobile low-end devices). In most cases, however, you would still like your function to be optimised.

When it comes to TurboFan, there were [a few reasons](https://docs.google.com/presentation/d/1H1lLsbclvzyOF3IUR05ZUaZcqDxo7_-8f4yJoxdMooU/edit#slide=id.g18ceb14721_0_39) it was introduced:

- Providing a uniform code generation architecture
- Reducing porting / maintenance overhead of V8 (currently 10 ports!)
- Removing performance cliffs due to slow builtins
- Making experimenting with new features easier (i.e. changes to load/store ICs, bootstrapping an interpreter)

Of course, this had to be done without sacrificing the performance. Generating bytecode is relatively cheap, but interpreting bytecodes can be up to 100x slower than executing optimised code. Obviously, it depends on the complexity of compiler. The baseline compiler was never meant to produce very fast code, but it is still faster (not much though, but in some cases fullcodegen is faster 3x-4x) than Ignition – taking into account just executing the code. TurboFan was aimed to replace Crankshaft – the previous optimising compiler.

## Do We Need the Optimisations?

Yes and no.

If we run our function once or twice, optimisation may not be worth it. However, if it’s likely to be executed multiple times, and the types of the values and the shapes of the objects are stable, then you should probably consider optimising your code. We might not be aware of some quirks that are present in the specification. The steps needed to be taken by the engine are often difficult to understand. For instance, when accessing a property, the engine has to take care of edge cases that are very unlikely to happen in the real world. Why is that? Sometimes due to backwards compatibility, sometimes there is another reason – each case is different. However, if we find something redundant, we might not actually need to do it! The process of optimising spots such situations and tries to remove the redundant operations. A function with removed redundant operations is called a stub.

Since JS is a dynamically typed language, we always have to make plenty of assumptions. It is best to keep our property access site monomorphic or, in other words, it should have only one known path. If our assumptions mismatch, we encounter a deopt and our optimised function is no longer valid. We definitely want to avoid it whenever possible. Each process optimisation is more or less expensive. Once we optimise again, we need to take into account all previous circumstances to prevent further deopts, so our property access site will no longer be monomorphic. It’s polymorphic and will stay polymorphic as long as there are no more than four paths. If there are more than four paths, it’s megamorphic.

## Before you start

All functions with the percent sign as a prefix are available only if you pass --allow-natives-syntax.

Normally, you **should not** access them. If you want to find their definition, go to src/runtime (V8 source code). All bailout (deopt) reasons are available here https://cs.chromium.org/chromium/src/v8/src/bailout-reason.h

If you want to see whether your function is optimised or not, pass the --trace-opt flag. If you want to be notified once your optimised function gets deoptimised, pass the --trace-deopt flag.

## Examples

## Example 1

We will start with a very straightforward example.

We will declare a very simple add function that takes two arguments and returns the sum of them. Quite simple, right? Let's see then.

```
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

```
d8 --trace-deopt --print-opt-code --allow-natives-syntax --code-comments --turbo add.js
```

If you run V8 older than 5.9, you must pass the --turbo flag explicitly to make sure your function goes through TurboFan.

If you run the above, you will get something like this:

```
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

As you can see, there are at least three different situations in which our function may be eagerly deopted.

If we took lazy deopts into account, we would find even more, but let’s focus on eager deopts.

By the way, at the moment here are three types of deopts: eager, lazy and soft.

It may look a bit awkward and scary, but don't worry! You will get it soon.

Let's start with the first likely deopt.

```
// ;; debug: deopt index 0
```

A deopt reason 'not a Smi'. If you have already heard about Smi, you can skip the next paragraph sentences.

Basically, a Smi is a shorthand for small integer. It varies quite a lot from other objects represented in V8.

If you dig into V8 source code, you will find a file objects.h there (https://chromium.googlesource.com/v8/v8.git/+/master/src/objects.h).

As you can see, a Smi is not a HeapObject.

A HeapObject is a "superclass for everything allocated in the heap". Basically, what we have access to (as frontend developers) is subclasses of JSReceiver.

For example, a plain array (JSArray) or function (JSFunction) inherits that class.

So, as you can see, a Smi is something different. You can find some information about this if you look for Javascript tagging schemes.

A Smi is a 32-bit signed int on 64-bit architectures and a 31-bit signed int on 32-bit architectures.

If you pass anything else than such a number your function will be deopted.

For example:

```
add(2 ** 31, 0)
```

will be deopted because 2 ** 31 is higher than 2 ** 31 - 1.

Of course, if you don't pass a number but a string, array or anything else, you will get a deopt as well, for example:

```
add([], 0);

add({ foo: 'bar' }, 2);
```

Let's move to the second deopt index

```
;; debug: deopt index 1
```

The same flow applies here. The only difference is that now it's a check for the second argument called ‘b’.

```
add(0, 2 ** 31) // would cause a deopt as well.
```

Okay, let's move to the last deopt index.

```
;; debug: deopt index 2
```

'Overlow'

Since you know what a Smi is, it's quite easy to understand what happens here.

Basically, that reason will be triggered once the previous checks pass, but the function doesn't return a Smi. For instance,

```
add(1, 2 ** 31 - 1); // returned value higher than 2 ** 31 - 1
```

### Example 2

Let's move forward then and declare a function that looks identical.

```
function concat(a, b) {
  return a + b;
}

concat('netguru', ' .com');
concat('p0lip loves ', 'v8');
%OptimizeFunctionOnNextCall(concat);
concat('optimized now! ', 'wooohooo');
```

A similar function, but a result that’s way different. Why?! Don't the same checks apply to all identically looking functions?

Nope! These checks are type-dependent, meaning that the engine doesn’t make assumptions in advance. It just adjusts its behavior and optimisations during runtime and once the function is executed. Therefore, even though the function looks the same, you have a different path.

In this case, our function is optimised by Crankshaft.

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

Okay, so let's discuss this case.

```
;; debug: deopt index 1
```

A deopt occurs once you pass a HeapObject instead of a Smi. In fact it's the opposite of 'Not a smi', so I will skip explaining it. I can only add that this check applies to the first argument called ‘a’.

```
;; debug: deopt index 2
```

'wrong instance type' – this is more interesting. We haven't seen it yet!

Quite easy to guess. This check fails if you don't pass a string or when you pass nothing.

```
concat([], 'd');

concat(new String('d'), 'xx');
```

The last 2 reasons are exactly the same as above, but apply to the second argument ('b').

### Example 3

Okay, let’s move on and have a go at a slightly different example.

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

Before we start explaining the new reasons, we have to make sure we know what a (hidden) map (aka a hidden class) is. As we have already mentioned, the engine must make assumptions in order to spend less time processing redundant operations. Still, we must know the elements well. Each element has a kind. V8 implements [TypeFeedbackVector](https://github.com/v8/v8/blob/master/src/feedback-vector.h). I encourage you to read [this](http://ripsawridge.github.io/articles/stack-changes/) article if you want to get some more information. [The known kinds are available here](https://chromium.googlesource.com/v8/v8.git/+/master/src/elements-kind.h).

We also do have a few native functions that help us check whether our element fits into a given type. Their definitions are located in the file above, but their [native names are available here](https://chromium.googlesource.com/v8/v8.git/+/master/src/runtime/runtime.h#590). 

So let’s get back to deopts.

```
;; debug: deopt reason 'Smi' 

;; debug: deopt index 0
```

Trivial. It happens when you pass a Smi as the function’s first argument called ‘arr’.

```
;; debug: deopt reason 'wrong map'
;; debug: deopt index 1
```

Unfortunately, this tends to happen very often.

Our map is: `<Map(FAST_SMI_ELEMENTS)>`

So any time our array ‘arr’ contains something different than a Smi element, the map will no longer match. Of course, this also happens when we don’t pass a plain array but something else, for instance:

```
elemAt([‘netguru’], 0);

elemAt({ 0: ‘netguru’ }, 0);
```

If you want to check whether our array consists of Smi elements, you can run a native method I mentioned before.

```
print(%HasFastSmiElements([2, 4, 5])); // prints true

print(%HasFastSmiElements([2, 4, 'd'])); // prints false

print(%HasFastSmiElements([2.1])); // prints false

print(%HasFastSmiElements({})); // prints false
```

Okay, now we are performing checks on the second argument ('index'). As you will quickly notice, its deopt reasons rely on the first argument.

```
;; debug: deopt reason 'out of bounds'
;; debug: deopt index 2
```

'Out of bounds'. Literally, when your index is higher than the length of the array or lower than 0, this will cause a deopt.

In other words, you are trying to access the element whose index doesn't belong to the array.

Examples:

```
elemAt([2,3,5], 4);
```

```
;; debug: deopt reason 'not a heap number'
;; debug: deopt index 4
```

'not a heap number' – not a number (not to be confused with smi as it's doesn’t mean the same), examples:

```
elemAt([2,3,5], '2');

elemAt([2,3,5], new Number(5));
```

```
;; debug: deopt reason 'lost precision or NaN'
;; debug: deopt index 5
```

If you encounter this check, it means you have passed a number, but... is it a valid number?

Lost precision – not an int, for example 1.1

```
elemAt([0, 1], 1.1);

elemAt([0], NaN);
```

```
;; debug: deopt reason 'minus zero'
;; debug: deopt index 6
```

Easy peasy.

```
add(0, -0); // weird, I know
```

Easy task.

Yet another example – a combination of the previous ones. We won’t explain it in detail, and I’ve thought it as more of a task for you :)

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

In case you don’t have d8:

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

That’s that.

We went through two very simple examples, but hopefully you’ve got the general idea.

If you want to be notified once your function is deopted, just pass --trace-deopt.

To sum up – don’t over-optimize, because it may hurt the code readability in some cases (see our third example and the function elem-at). You can pass arrays of strings, etc. as well, there is really nothing wrong with it. However, don’t optimize if you don’t really need to. As far as the first example is concerned, in my opinion, even though the functions are pretty much the same, it’s better to have two separate functions with different namings, because when a different developer sees something like concat or sum, they can quickly find out what this function does.

In the future, you can add a case in concat specific for strings, like for instance, (a + b).toUpperCase() etc. and you don’t have add any special cases to the ‘sum’ function.

Last but not least, you should always keep in mind that over-optimising might hurt readability and you may end up with unmaintainable code. Just try not to use any weird patterns you wouldn’t use in a compiled language.

Finally, I would like to thank [Benedikt Meurer](https://twitter.com/bmeurer), a Software Engineer at Google and Tech Lead of the V8 team in Munich, who reviewed this article. Check out his [blog](http://benediktmeurer.de/) as well.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
