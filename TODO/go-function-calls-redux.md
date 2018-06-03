> * 原文地址：[Go Function Calls Redux](https://hackernoon.com/go-function-calls-redux-609fdd1c90fd#.jsh5r78wp)
> * 原文作者：[Phil Pearl](https://hackernoon.com/@philpearl?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[xiaoyusilen](http://xiaoyu.world)
> * 校对者：[1992chenlu](https://github.com/1992chenlu)，[Zheaoli](https://github.com/Zheaoli)

# Go 函数调用 Redux #

前段时间在一篇[文章](https://syslog.ravelin.com/anatomy-of-a-function-call-in-go-f6fc81b80ecc#.gpqsgzmjc)中我答应写一篇进一步分析 Go 中如何进行函数调用和堆栈调用在 Go 中如何工作的文章。现在我找到了一种简洁的方式来向大家展示上述内容，所以有了现在这篇文章。

什么是堆栈调用？它是一个用于保存局部变量和调用参数的内存区域，并且跟踪每个函数应该返回到哪里去。每个 goroutine 都有它自己的堆栈。你甚至可以说每个 goroutine 就是它自己的堆栈。

下面是我用于演示堆栈的代码。就是一系列简单的函数调用，main() 函数调用 [f1(0xdeadbeef)](https://en.wikipedia.org/wiki/Hexspeak)，然后调用 `f2(0xabad1dea)`，再调用 `f3(0xbaddcafe)`。然后 `f3()` 将其中一个作为它的参数，并且将它存储在名为 `local` 的本地变量中。然后获取 `local` 的内存地址并且从那里开始输出。因为 `local` 在栈内，所以输出的就是栈。

```go
package main

import (
	"fmt"
	"runtime"
	"unsafe"
)

func main() {
	f1(0xdeadbeef)
}

func f1(val int) {
	f2(0xabad1dea)
}

func f2(val int) {
	f3(0xbaddcafe)
}

func f3(val int) {
	local := val + 1

	display(uintptr(unsafe.Pointer(&local)))
}

func display(ptr uintptr) {
	mem := *(*[20]uintptr)(unsafe.Pointer(ptr))
	for i, x := range mem {
		fmt.Printf("%X: %X\n", ptr+uintptr(i*8), x)
	}

	showFunc(mem[2])
	showFunc(mem[5])
	showFunc(mem[8])
	showFunc(mem[11])
}

func showFunc(at uintptr) {
	if f := runtime.FuncForPC(at); f != nil {
		file, line := f.FileLine(at)
		fmt.Printf("%X is %s %s %d\n", at, f.Name(), file, line)
	}
}
```

下面是上述代码的输出结果。它是从 `local` 的地址开始的内存转储，是以十六进制形式展示的 8 字节列表。左边是每个整数的存储地址，右边是地址内存储的整数。

我们知道 `local` 应该等于 0xBADDCAFE + 1，或者 0xBADDCAFF，这确实是我们转储开始时看到的。

```
C42003FF28: BADDCAFF
C42003FF30: C42003FF48
C42003FF38: 1088BEB
C42003FF40: BADDCAFE
C42003FF48: C42003FF60
C42003FF50: 1088BAB
C42003FF58: ABAD1DEA
C42003FF60: C42003FF78
C42003FF68: 1088B6B
C42003FF70: DEADBEEF
C42003FF78: C42003FFD0
C42003FF80: 102752A
C42003FF88: C420064000
C42003FF90: 0
C42003FF98: C420064000
C42003FFA0: 0
C42003FFA8: 0
C42003FFB0: 0
C42003FFB8: 0
C42003FFC0: C4200001A0

1088BEB is main.f2 /Users/phil/go/src/github.com/philpearl/stack/main.go 19

1088BAB is main.f1 /Users/phil/go/src/github.com/philpearl/stack/main.go 15

1088B6B is main.main /Users/phil/go/src/github.com/philpearl/stack/main.go 11

102752A is runtime.main /usr/local/Cellar/go/1.8/libexec/src/runtime/proc.go 194
```

- 下一个数字是 0xC42003FF48，它是转储的第五行的地址。
- 然后我们可以得到 0x1088BEB。事实上这是一个可执行代码的地址，如果我们将它作为 `runtime.FuncForPC` 的参数，我们知道它是 main.go 的第19行代码的地址，也是 f2() 的最后一行代码。这是 f3() 返回时我们得到的地址。
- 接下来我们得到 0xBADDCAFE，这是我们调用 `f3()` 时的参数。

如果继续我们将看到类似上面的输出结果。下面我已经标记了内存转储，显示堆栈指针如何跟踪转储，参数和返回地址在哪里。

```go
  C42003FF28: BADDCAFF    Local variable in f3()
+-C42003FF30: C42003FF48 
| C42003FF38: 1088BEB     return to f2() main.go line 19
| C42003FF40: BADDCAFE    f3() parameter
+-C42003FF48: C42003FF60
| C42003FF50: 1088BAB     return to f1() main.go line 15
| C42003FF58: ABAD1DEA    f2() parameter
+-C42003FF60: C42003FF78
| C42003FF68: 1088B6B     return to main() main.go line 11
| C42003FF70: DEADBEEF    f1() parameter
+-C42003FF78: C42003FFD0
  C42003FF80: 102752A     return to runtime.main()
```

通过这些我们可以看出：

- 首先，堆栈从高地址开始，堆栈地址随着函数调用变小。
- 当进行函数调用时，调用者将参数放入栈内，然后是返回地址（调用函数中的下一条指令的地址），接着是指向堆栈中较高的指针。
- 当调用返回时，这个指针用于在堆栈中查找先前调用的函数。
- 局部变量存储在堆栈指针之后。

我们可以使用相同的技巧来分析一些稍微复杂的函数调用。这次，我添加了更多的参数，`f2()` 函数也返回了更多的值。

```go
package main

import (
	"fmt"
	"runtime"
	"unsafe"
)

func main() {
	f1(0xdeadbeef)
}

func f1(val int) {
	f2(0xabad1dea0001, 0xabad1dea0002)
}

func f2(val1, val2 int) (r1, r2 int) {
	f3(0xbaddcafe)
	return
}

func f3(val int) {
	local := val + 1

	display(uintptr(unsafe.Pointer(&local)))
}
```

这次我们直接看被我标记好的输出结果。

```go
  C42003FF10: BADDCAFF      local variable in f3()
+-C42003FF18: C42003FF30
| C42003FF20: 1088BFB       return to f2()
| C42003FF28: BADDCAFE      f3() parameter
+-C42003FF30: C42003FF60
| C42003FF38: 1088BBF       return to f1()
| C42003FF40: ABAD1DEA0001  f2() first parameter
| C42003FF48: ABAD1DEA0002  f2() second parameter
| C42003FF50: 110A100       space for f2() return value
| C42003FF58: C42000E240    space for f2() return value
+-C42003FF60: C42003FF78
| C42003FF68: 1088B6B       return to main()
| C42003FF70: DEADBEEF      f1() parameter
+-C42003FF78: C42003FFD0
  C42003FF80: 102752A       return to runtime.main()
```

从结果中我们可以看出：

- 调用函数在函数参数之前为被调用函数的返回值提供空间。（注意这些值是没有初始化的，因为这个函数还没有返回！）
- 参数在栈内的顺序与入栈顺序相反。

希望我都讲清楚了。既然你已经看到这儿了，如果喜欢我的这篇文章或者可以从中学到一点什么的话，那么请给我点个赞。不然我就没办法获得积分。

**Phil 白天在 [ravelin.com](https://ravelin.com) 的工作主要是防止网上欺诈，你可以加入他 https://angel.co/ravelin/jobs。**