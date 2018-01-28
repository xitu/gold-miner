> * 原文地址：[Debugging Swift code with LLDB](https://medium.com/flawless-app-stories/debugging-swift-code-with-lldb-b30c5cf2fd49)
> * 原文作者：[Ahmed Sulaiman](https://medium.com/@ahmedsulaiman?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/debugging-swift-code-with-lldb.md](https://github.com/xitu/gold-miner/blob/master/TODO/debugging-swift-code-with-lldb.md)
> * 译者：
> * 校对者：

# Debugging Swift code with LLDB

![](https://cdn-images-1.medium.com/max/2000/1*_o1ATofHFOE2zlbbPSFz-Q.png)

As engineers we spend almost 70% of our time on debugging. The rest 20% goes on thinking about the architectural approaches + communication with teammates and just 10% actually on writing code.

> Debugging is like being the detective in a crime movie where you are also the murderer.
>
> — [Filipe Fortes](https://twitter.com/fortes) via Twitter

So it’s extremely important to make this 70% of our time as pleasant as possible. LLDB comes to rescue. Fancy Xcode Debugger UI shows you all available information without typing a single LLDB command. However, the console is still a big part of our workflow. Let’s break down some of the most useful LLDB tricks. I personally use them daily for debugging.

### Where should we go first?

LLDB is an enormous tool and it has a lot of useful commands inside. I won’t describe them all. I’d like to walk you through the most useful commands instead. So here is our plan:

1. Explore variables values: `expression`, `e`, `print`, `po`, `p`
2. Get overall app’s state + language specific commands: `bugreport`, `frame`, `language`
3. Control app’s execution flow: `process`, `breakpoint`, `thread`, `watchpoint`
4. Honorable mentions: `command`, `platform`, `gui`

I have also prepared the map of useful LLDB commands with description and examples. If you need you can hang it above your Mac to remember these commands 🙂

![](https://cdn-images-1.medium.com/max/800/1*bDt6SNjK1QN9Tfz-roasDg.png)

Download full size version with this link — [https://www.dropbox.com/s/9sv67e7f2repbpb/lldb-commands-map.png?dl=0](https://www.dropbox.com/s/9sv67e7f2repbpb/lldb-commands-map.png?dl=0)

### 1. Explore variables value and state

Commands: `expression`, `e`, `print`, `po`, `p`

![](https://cdn-images-1.medium.com/max/1000/1*HcuIHN3WucfxG2Mk80wldw.png)

The basic function of a debugger is to explore and modify variables’ values. This is what `expression` or `e` is made for (and much more actually). You can evaluate basically any expression or command in a runtime.

Let’s assume you’re debugging some function `valueOfLifeWithoutSumOf()` which do a summation of two numbers and extract the result from 42.

![](https://cdn-images-1.medium.com/max/800/1*ZRG-coIMk9udSc4edkMO6w.png)

Let’s also assume you keep getting the wrong answer and you don’t know why. So to find a problem you can do something like this:

![](https://cdn-images-1.medium.com/max/800/1*LOFplcSqjYiO2BAjPi--4A.png)

Or… it’s better to use LLDB expression instead to change the value in the runtime. And find out where the problem has happened. First, set a breakpoint to a place you interested in. Then run your app.

To print the value of specific variable in LLDB format you should call:

```
(lldb) e <variable>
```

And the very same command is used to evaluate some expression:

```
(lldb) e <expression>
```

![](https://cdn-images-1.medium.com/max/800/1*MCBw_pKgO2N5uPZKYmS0fQ.png)

```
(lldb) e sum 
(Int) $R0 = 6 // You can also use $R0 to refer to this variable in the future (during current debug session)

(lldb) e sum = 4 // Change value of sum variable

(lldb) e sum 
(Int) $R2 = 4 // sum variable will be "4" till the end of debugging session
```

`expression` command also has some flags. To distinct flags and actual expression LLDB uses double-dash notation `--` after `expression` command like this:

```
(lldb) expression <some flags> -- <variable>
```

`expression` has almost ~30 different flags. And I encourage you to explore them all. Write the command below in the terminal to get full documentation:

```
> lldb
> (lldb) help # To explore all available commands
> (lldb) help expression # To explore all expressions related sub-commands
```

I’d like to stop on the following `expression`'s flags:

* `-D <count>` (`--depth <count>`) — Set the max recurse depth when dumping aggregate types (default is infinity).
* `-O` (`--object-description`) — Display using a language-specific description API, if possible.
* `-T` (`--show-types`) — Show variable types when dumping values.
* `-f <format>` (`--format <format>`) –– Specify a format to be used for display.
* `-i <boolean>` (`--ignore-breakpoints <boolean>`) — Ignore breakpoint hits while running expressions

Let’s say we have some object called `logger`. This object contains some string and structure as properties. For example, you want to explore first-level properties only. Just use `-D` flag with appropriate depth level to do so:

```
(lldb) e -D 1 -- logger

(LLDB_Debugger_Exploration.Logger) $R5 = 0x0000608000087e90 {
  currentClassName = "ViewController"
  debuggerStruct ={...}
}
```

By default LLDB will look infinitely into the object and show you a full description of every nested object:

```
(lldb) e -- logger

(LLDB_Debugger_Exploration.Logger) $R6 = 0x0000608000087e90 {
  currentClassName = "ViewController"
  debuggerStruct = (methodName = "name", lineNumber = 2, commandCounter = 23)
}
```

You can also explore object description with `e -O --` or simply using alias `po` like in the example below:

```
(lldb) po logger

<Logger: 0x608000087e90>
```

Not so descriptive, isn’t it? To get human-readable description you have to apply your custom class to `CustomStringConvertible` protocol and implement `var description: String { return ...}` property. Only then `po` returns you readable description.

![](https://cdn-images-1.medium.com/max/1000/1*v1JRHrSQmGIOkEUiQ5CZXA.png)

At the beginning of this section, I’ve also mentioned `print` command.
Basically `print <expression/variable>` is the same as `expression -- <expression/variable>`. Except `print` command doesn’t take any flags or additional arguments.

### 2. Get overall app’s state + language specific commands

`bugreport`, `frame`, `language`

![](https://cdn-images-1.medium.com/max/1000/1*1OpRvgpxYDjA5ZeEpbh55Q.png)

How often have you copied and pasted and paste crash logs into your task manager to explore the issue later? LLDB has this great little command called `bugreport` which will generate a full report of current app’s state. It could be really helpful if you encounter some problem but want to tackle it a bit later. In order to restore your understand of app’s state, you can use `bugreport` generated report.

```
(lldb) bugreport unwind --outfile <path to output file>
```

The final report will look like example on the screenshot below:

![](https://cdn-images-1.medium.com/max/1000/1*ziOW_lKhI6cBgGHl204kDg.png)

Example of `bugreport` command output.

![](https://cdn-images-1.medium.com/max/1000/1*05j2Rp0t2hWAHsCW3tReqg.png)

Let’s say you want to get a quick overview of the current stack frame in current thread. `frame` command can help you with that:

![](https://cdn-images-1.medium.com/max/800/1*nAyd2l2m679XpH_In968YQ.png)

Use snippet below to get a quick understanding where you are and what surrounding conditions are at the moment:

```
(lldb) frame info

frame #0: 0x000000010bbe4b4d LLDB-Debugger-Exploration`ViewController.valueOfLifeWithoutSumOf(a=2, b=2, self=0x00007fa0c1406900) -> Int at ViewController.swift:96
```

This information will be useful in breakpoint management later in the article.

![](https://cdn-images-1.medium.com/max/1000/1*uLXBPbMvpDGU3Y9ElPQPsA.png)

LLDB has a couple of commands for a specific language. There are commands for C++, Objective-C, Swift and RenderScript. In this case, we’re interested in Swift. So here are these two commands: `demangle` and `refcount`.

`demangle` as written in its name just demangle mangled Swift type name (which Swift generates during compilation to avoid namespace problem). If you’d like to learn more on that I’d suggest you watch this WWDC14 session — [“Advanced Swift Debugging in LLDB”](https://developer.apple.com/videos/play/wwdc2014/410/).

`refcount` is also a pretty straightforward command. It shows you reference count for the specific object. Let’s see the output example with an object we used in the previous section — `logger`:

```
(lldb) language swift refcount logger

refcount data: (strong = 4, weak = 0)
```

For sure, this could be quite useful if you are debugging some memory leaks.

### 3. Control app’s execution flow

`process`, `breakpoint`, `thread`

This part is my favorite. Because using these command from LLDB (`breakpoint` command in particular) you can automate a lot of routine stuff during debugging. Which eventually speed up your debugging process a lot.

![](https://cdn-images-1.medium.com/max/1000/1*mLGvusUvwDjWnuRGIaM6zw.png)

With `process` you can basically control debug process and attach to a specific target or detach a debugger from it. But since Xcode does the process attachment for us automatically (LLDB is attached by Xcode every time you run a target) I won’t stop on that. You can read how to attach to a target using terminal in this Apple guide — [“Using LLDB as a Standalone Debugger”](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/gdb_to_lldb_transition_guide/document/lldb-terminal-workflow-tutorial.html).

Using `process status` you can explore a current place where the debugger is waiting for you:

```
(lldb) process status

Process 27408 stopped
* thread #1, queue = 'com.apple.main-thread', stop reason = step over
frame #0: 0x000000010bbe4889 LLDB-Debugger-Exploration`ViewController.viewDidLoad(self=0x00007fa0c1406900) -> () at ViewController.swift:69
66
67           let a = 2, b = 2
68           let result = valueOfLifeWithoutSumOf(a, and: b)
-> 69           print(result)
70
71
72
```

In order to continue execution of the target until the next breakpoint occur, run this command:

```
(lldb) process continue

(lldb) c // Or just type "c" which is the same as previous command
```

It’s the equivalent of “continue” button in the Xcode debugger toolbar:

![](https://cdn-images-1.medium.com/max/1000/1*gv020i3Uihl0JCxg4D6FyQ.png)

`breakpoint` command allows you to manipulate breakpoints in any possible way. Let’s skip the most obvious commands like: `breakpoint enable`, `breakpoint disable` and `breakpoint delete`.

First things first, to explore all your breakpoints let’s use `list` sub-command like in the example below:

```
(lldb) breakpoint list

Current breakpoints:
1: file = '/Users/Ahmed/Desktop/Recent/LLDB-Debugger-Exploration/LLDB-Debugger-Exploration/ViewController.swift', line = 95, exact_match = 0, locations = 1, resolved = 1, hit count = 1

1.1: where = LLDB-Debugger-Exploration`LLDB_Debugger_Exploration.ViewController.valueOfLifeWithoutSumOf (Swift.Int, and : Swift.Int) -> Swift.Int + 27 at ViewController.swift:95, address = 0x0000000107f3eb3b, resolved, hit count = 1

2: file = '/Users/Ahmed/Desktop/Recent/LLDB-Debugger-Exploration/LLDB-Debugger-Exploration/ViewController.swift', line = 60, exact_match = 0, locations = 1, resolved = 1, hit count = 1

2.1: where = LLDB-Debugger-Exploration`LLDB_Debugger_Exploration.ViewController.viewDidLoad () -> () + 521 at ViewController.swift:60, address = 0x0000000107f3e609, resolved, hit count = 1
```

The first number in the list is a breakpoint ID which you can use to refer to any specific breakpoint. Let’s set some new breakpoint right from the console:

```
(lldb) breakpoint set -f ViewController.swift -l 96

Breakpoint 3: where = LLDB-Debugger-Exploration`LLDB_Debugger_Exploration.ViewController.valueOfLifeWithoutSumOf (Swift.Int, and : Swift.Int) -> Swift.Int + 45 at ViewController.swift:96, address = 0x0000000107f3eb4d
```

In this example `-f` is a name of the file where you’d like to put a breakpoint. And `-l` is a line number of a new breakpoint. There is a shorter way to set the very same breakpoint with `b` shortcut:

```
(lldb) b ViewController.swift:96
```

You can also set a breakpoint with a specific regex (function name, for example) using the command below:

```
(lldb) breakpoint set --func-regex valueOfLifeWithoutSumOf

(lldb) b -r valueOfLifeWithoutSumOf // Short version of the command above
```

It’s sometimes useful to set a breakpoint for only one hit. And then instruct the breakpoint to delete itself right away. For sure, there is a flag for that:

```
(lldb) breakpoint set --one-shot -f ViewController.swift -l 90

(lldb) br s -o -f ViewController.swift -l 91 // Shorter version of the command above
```

Now let’s tackle the most interesting part — breakpoint automation. Did you know you can set a specific action which will execute as soon as breakpoint occurs? Yes, you can! Do you use `print()` in the code to explore values you’re interested in for debugging? Please don’t do that, there is a better way. 🙂

With `breakpoint command`, you can setup commands which will execute right when the breakpoint is hit. You can even make “invisible” breakpoints which won’t interrupt execution. Well, technically these “invisible” breakpoints will interrupt execution but you won’t notice it if you add `continue` command at the end of commands chain.

```
(lldb) b ViewController.swift:96 // Let's add a breakpoint first

Breakpoint 2: where = LLDB-Debugger-Exploration`LLDB_Debugger_Exploration.ViewController.valueOfLifeWithoutSumOf (Swift.Int, and : Swift.Int) -> Swift.Int + 45 at ViewController.swift:96, address = 0x000000010c555b4d

(lldb) breakpoint command add 2 // Setup some commands 

Enter your debugger command(s).  Type 'DONE' to end.
> p sum // Print value of "sum" variable
> p a + b // Evaluate a + b
> DONE
```

To ensure you’ve added correct commands use `breakpoint command list <breakpoint id>` sub-command:

<pre name="17bc" id="17bc" class="graf graf--pre graf-after--p">(lldb) breakpoint command list 2</pre>

```
(lldb) breakpoint command list 2

Breakpoint 2:
Breakpoint commands:
p sum
p a + b
```

Next time when this breakpoint hit we’ll get the following output in the console:

```
Process 36612 resuming
p sum
(Int) $R0 = 6

p a + b
(Int) $R1 = 4
```

Great! Exactly what we’re looking for. You can make it even smoother by adding `continue` command at the end of the commands chain. So you won’t even stop on this breakpoint.

```
(lldb) breakpoint command add 2 // Setup some commands

Enter your debugger command(s).  Type 'DONE' to end.
> p sum // Print value of "sum" variable
> p a + b // Evaluate a + b
> continue // Resume right after first hit
> DONE
```

So the result would be:

```
p sum
(Int) $R0 = 6

p a + b
(Int) $R1 = 4

continue
Process 36863 resuming
Command #3 'continue' continued the target.
```

![](https://cdn-images-1.medium.com/max/1000/1*Hd2VNOZsUZ2Lsmk_oznRig.png)

With `thread` command and its subcommands you can fully control execution flow: `step-over`, `step-in`, `step-out` and `continue`. These are direct equivalent of flow control buttons on Xcode debugger toolbar.

![](https://cdn-images-1.medium.com/max/800/1*_CILKjcJsdVco-hG9rDmhg.png)

There is also a predefined LLDB shortcut for these particular commands:

```
(lldb) thread step-over
(lldb) next // The same as "thread step-over" command
(lldb) n // The same as "next" command

(lldb) thread step-in
(lldb) step // The same as "thread step-in"
(lldb) s // The same as "step"
```

In order to get more information about the current thread just call `info` subcommand:

```
(lldb) thread info 

thread #1: tid = 0x17de17, 0x0000000109429a90 LLDB-Debugger-Exploration`ViewController.sumOf(a=2, b=2, self=0x00007fe775507390) -> Int at ViewController.swift:90, queue = 'com.apple.main-thread', stop reason = step in
```

To see a list of all currently active threads use `list` subcommand:

```
(lldb) thread list

Process 50693 stopped

* thread #1: tid = 0x17de17, 0x0000000109429a90 LLDB-Debugger-Exploration`ViewController.sumOf(a=2, b=2, self=0x00007fe775507390) -> Int at ViewController.swift:90, queue = 'com.apple.main-thread', stop reason = step in

  thread #2: tid = 0x17df4a, 0x000000010daa4dc6  libsystem_kernel.dylib`kevent_qos + 10, queue = 'com.apple.libdispatch-manager'
  
  thread #3: tid = 0x17df4b, 0x000000010daa444e libsystem_kernel.dylib`__workq_kernreturn + 10

  thread #5: tid = 0x17df4e, 0x000000010da9c34a libsystem_kernel.dylib`mach_msg_trap + 10, name = 'com.apple.uikit.eventfetch-thread'
```

### Honorable mentions

`command`, `platform`, `gui`

![](https://cdn-images-1.medium.com/max/1000/1*X9Dl7gaVB1elSpD8WycZGA.png)

In the LLDB you can find a command for managing other commands. Sounds weird but in practice, it’s quite useful little tools. First, it allows you to execute some LLDB commands right from the file. So you can create a file with some useful commands and execute them at once as if it would be a single LLDB command. Here is a simple example of the file:

```
thread info // Show current thread info
br list // Show all breakpoints
```

And here is how the actual command looks like:

```
(lldb) command source /Users/Ahmed/Desktop/lldb-test-script

Executing commands in '/Users/Ahmed/Desktop/lldb-test-script'.

thread info
thread #1: tid = 0x17de17, 0x0000000109429a90 LLDB-Debugger-Exploration`ViewController.sumOf(a=2, b=2, self=0x00007fe775507390) -> Int at ViewController.swift:90, queue = 'com.apple.main-thread', stop reason = step in

br list
Current breakpoints:
1: file = '/Users/Ahmed/Desktop/Recent/LLDB-Debugger-Exploration/LLDB-Debugger-Exploration/ViewController.swift', line = 60, exact_match = 0, locations = 1, resolved = 1, hit count = 0
1.1: where = LLDB-Debugger-Exploration`LLDB_Debugger_Exploration.ViewController.viewDidLoad () -> () + 521 at ViewController.swift:60, address = 0x0000000109429609, resolved, hit count = 0
```

There is also a downside, unfortunately, you can’t pass any argument to the source file (unless you’ll create a valid variable in the script file itself).

If you need something more advanced you can always use `script` sub-command. Which will allow you to manage (`add`, `delete`, `import` and `list`) custom Python scripts. With the `script` a real automation becomes possible. Please check out this nice guide on [Python scripting for LLDB](http://www.fabianguerra.com/ios/introduction-to-lldb-python-scripting/). Just for the demo, let’s create a script file _script.py_ and write a simple command _print_hello()_ which will just print “Hello Debugger!” in the console:

```
import lldb

def print_hello(debugger, command, result, internal_dict):
	print "Hello Debugger!"
    
def __lldb_init_module(debugger, internal_dict):
	debugger.HandleCommand('command script add -f script.print_hello print_hello') // Handle script initialization and add command from this module
	print 'The "print_hello" python command has been installed and is ready for use.' // Print confirmation that everything works
```

Then we need to import a Python module and start using our script command normally:

```
(lldb) command import ~/Desktop/script.py

The "print_hello" python command has been installed and is ready for use.

(lldb) print_hello

Hello Debugger!
```

![](https://cdn-images-1.medium.com/max/1000/1*6fRizbW5TQ02_DzHnUinzg.png)

You can quickly check current platform information with a `status` subcommand. `status` will tell you: SDK path, processor architecture, OS version and even list of available devices for this SDK.

```
(lldb) platform status

Platform: ios-simulator
Triple: x86_64-apple-macosx
OS Version: 10.12.5 (16F73)
Kernel: Darwin Kernel Version 16.6.0: Fri Apr 14 16:21:16 PDT 2017; root:xnu-3789.60.24~6/RELEASE_X86_64
Hostname: 127.0.0.1
WorkingDir: /
SDK Path: "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"

Available devices:
614F8701-3D93-4B43-AE86-46A42FEB905A: iPhone 4s
CD516CF7-2AE7-4127-92DF-F536FE56BA22: iPhone 5
0D76F30F-2332-4E0C-9F00-B86F009D59A3: iPhone 5s
3084003F-7626-462A-825B-193E6E5B9AA7: iPhone 6
...
```

![](https://cdn-images-1.medium.com/max/1000/1*S914ih9-vrEoXKllCJpl0g.png)

Well, you can’t use LLDB GUI mode in the Xcode, but you can always do it from the terminal.

```
(lldb) gui

// You'll see this error if you try to execute gui command in Xcode
error: the gui command requires an interactive terminal.
```

![](https://cdn-images-1.medium.com/max/800/1*iN9X46pAI6cDv-ZL5v4L-w.png)

This is how LLDB GUI mode looks like.

### Conclusion:

In this article, I just scratched the surface of true LLDB’s power. Even though LLDB here with us for ages, there are still many people who don’t use its full potential. I have made a quick overview of basic functions and how LLDB can automate debugging process. I hope it was useful.

So much LLDB functions were left behind. There are also some view debugging techniques which I didn’t even mention. If you are interested in such topic, please leave a comment below. I’d be more than happy to write about it.

I strongly encourage you to open a terminal, enable LLDB and just type `help`. This will show you a full documentation. And you can spend hours reading it. But I guarantee this would be a reasonable time investment. Because knowing your tools is the only way for engineers to become truly productive.

* * *

#### References and useful articles on LLDB

* [Official LLDB site](http://lldb.llvm.org) — you’ll find here all possible materials related to LLDB. Documentation, guides, tutorials, sources and much more.
* [LLDB Quick Start Guide by Apple](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/gdb_to_lldb_transition_guide/document/Introduction.html#//apple_ref/doc/uid/TP40012917-CH1-SW1) — as usual, Apple has a great documentation. This guide will help you to get started with LLDB really quickly. Also, they’ve described how to do debugging with LLDB without Xcode.
* [How debuggers work: Part 1 — Basics](http://eli.thegreenplace.net/2011/01/23/how-debuggers-work-part-1 "Permalink to How debuggers work: Part 1 - Basics") — I enjoyed this series of articles a lot. It’s Just fantastic overview how debuggers really work. Article describes all underlying principles using code of hand-made debugger written in C. I strongly encourage you to read all parts of these great series ([Part 2](http://eli.thegreenplace.net/2011/01/27/how-debuggers-work-part-2-breakpoints), [Part 3](http://eli.thegreenplace.net/2011/02/07/how-debuggers-work-part-3-debugging-information)).
* [WWDC14 Advanced Swift Debugging in LLDB](https://developer.apple.com/videos/play/wwdc2014/410/) — great overview what’s new in LLDB in terms of Swift debugging. And how LLDB helps you be more productive with an overall debugging process using built-in functions and features.
* [Introduction To LLDB Python Scripting](http://www.fabianguerra.com/ios/introduction-to-lldb-python-scripting/) — the guide on Python scripting for LLDB which allows you to start really quickly.
* [Dancing in the Debugger. A Waltz with LLDB](https://www.objc.io/issues/19-debugging/lldb-debugging) — a clever introduction to some LLDB basics. Some information is a bit outdated (like `(lldb) thread return` command, for example. Unfortunately, it doesn't work with Swift properly because it can potentially bring some damage to reference counting). Still, it’s a great article to start your LLDB journey.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
