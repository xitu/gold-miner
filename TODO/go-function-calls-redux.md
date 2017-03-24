> * 原文地址：[Go Function Calls Redux](https://hackernoon.com/go-function-calls-redux-609fdd1c90fd#.jsh5r78wp)
> * 原文作者：[Phil Pearl](https://hackernoon.com/@philpearl?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Go Function Calls Redux #

Some time ago in a [previous post](https://syslog.ravelin.com/anatomy-of-a-function-call-in-go-f6fc81b80ecc#.gpqsgzmjc)  I promised to take a further look at how function calls and call stacks in Go work. I’ve think found a neat way to make good on that promise, so here goes.

So what is a call stack? Well, it’s an area of memory used to hold local variables and call parameters, and to track where functions should return to. Each goroutine has it’s own stack. You could almost say a goroutine is its stack.

Here’s the code I’m going to use to show the stack in action. It’s just a sequence of simple function calls. main() calls [f1(0xdeadbeef)](https://en.wikipedia.org/wiki/Hexspeak) , which then calls `f2(0xabad1dea)`, which calls `f3(0xbaddcafe)`. `f3()` then adds one to it’s parameter, and stores it in a local variable called `local`. It then takes the address of `local` and prints out memory starting at that address. Because `local` is on the stack, this prints the stack.

```
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

Here’s the output of the program. It is a dump of memory starting at the address of `local`, shown as a list of 8-byte integers in hex. The address of each integer is on the left, and the int at the address is on the right.

We know `local` should equal 0xBADDCAFE + 1, or 0xBADDCAFF, and this is indeed what we see at the start of the dump.

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

- The next number is 0xC42003FF48, which is the address of the 5th line of the dump.
- After that we have 0x1088BEB. It turns out this is an address of executable code, and if we feed it into `runtime.FuncForPC` we see it is the address of line 19 of main.go, which is the last line of `f2()`. This is the address we return to when `f3()` returns.
- Next we have 0xBADDCAFE, the parameter to our call to `f3()`

If we carry on we continue to see this pattern. Below I’ve marked up the memory dump showing how the stack pointers track back through the dump and where the function parameters and return addresses sit.

```
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

From this we can see many things.

- First, the stack starts at a high address, and the stack address reduces as function calls are made.
- When a function call is made, the caller pushes the parameters onto the stack, then the return address (the address of the next instruction in the calling function), then a pointer to a higher point in the stack.
- This pointer is used to find the previous function call on the stack when unwinding the stack when the call returns.
- Local variables are stored after the stack pointer.

We can use the same technique to look at some slightly more complicated function calls. I’ve added more parameters, and some return values to `f2()` in this version.
```
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

This time I’ve jumped straight to the marked-up output.

```
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

From this we can see that

- the calling function makes space for the return values of the called function before the function parameters. (Note the values are uninitialised because the function hasn’t returned yet!)
- parameters are pushed onto the stack in reverse order.

Hopefully all that made sense! If you got this far and enjoyed it or learned something, please hit that heart-button. I can’t earn internet points without you.

*By day, Phil fights crime at* [*ravelin.com*](https://ravelin.com) *. You can join him:* [*https://angel.co/ravelin/jobs*](https://angel.co/ravelin/jobs) .
