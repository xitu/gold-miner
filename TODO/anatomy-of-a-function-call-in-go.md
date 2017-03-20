> * 原文地址：[Anatomy of a function call in Go](https://syslog.ravelin.com/anatomy-of-a-function-call-in-go-f6fc81b80ecc#.povigaliw)
> * 原文作者：[Phil Pearl](https://syslog.ravelin.com/@philpearl?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Anatomy of a function call in Go #

Let’s take a look at a couple of simple Go functions and see if we can see how function calls work. We’ll do this by looking at the assembly language the Go compiler generates for the functions. This might be a little ambitious for a small blog post, but don’t worry, assembly language is simple. Even a CPU can understand it.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*CKK4XrLm3ylzsQzNbOaroQ.png">

By Rob Baines [https://github.com/telecoda/inktober-2016](https://github.com/telecoda/inktober-2016) 

Here’s our first function. Yep, we’re just adding two numbers.

```
func add(a, b int) int {
        return a + b
}
```

We’ll build it with optimisations disabled to make the assembly easier to follow. We do this with `go build -gcflags ‘-N -l’`. We can then dump out the assembly for our function with `go tool objdump -s main.add func` (func is the name of our package and the executable we just built with go build).

If you’ve never looked at assembly language before, then, well, congratulations, this is a new thing for you today. I’ve done this on a Mac, so the assembly is Intel 64-bit.

```
 main.go:20 0x22c0 48c744241800000000 MOVQ $0x0, 0x18(SP)
 main.go:21 0x22c9 488b442408  MOVQ 0x8(SP), AX
 main.go:21 0x22ce 488b4c2410  MOVQ 0x10(SP), CX
 main.go:21 0x22d3 4801c8   ADDQ CX, AX
 main.go:21 0x22d6 4889442418  MOVQ AX, 0x18(SP)
 main.go:21 0x22db c3   RET
```

What are we looking at here? Each line breaks down into 4 sections as follows.

- The source file name and line number (main.go:15). The source code at this line is translated to the instructions marked with that line number. One line of Go is likely translated to multiple lines of assembly.
- the offset into the object file (e.g. 0x22C0).
- The machine code (e.g. 48c744241800000000). This is the actual binary machine code the CPU executes. We’re not going to look at this! Almost nobody ever does.
- The assembly language representation of the machine code. This is the bit we can hope to understand.

Let’s focus in on that last section, the assembly code.

- MOVQ, ADDQ and RET are instructions. They tell the CPU what operation to perform. They are followed by parameters telling the CPU what to perform the operation on.
- SP, AX and CX are CPU registers. These are places where the CPU can store working values. There are several other registers the CPU can use.
- SP is a special purpose register and is used to store the current stack pointer. The stack is an area of memory where the local variables, function parameters and function calls are recorded. There’s one stack per goroutine. As one function calls another, then another, each gets its own area on the stack. Areas are created during the function call by reducing the value of SP by the size of the area needed.
- 0x8(SP) refers to the memory location that is 8 bytes past the memory location that SP points to.

So, our ingredients are memory locations, CPU registers, instructions to move values between memory and registers, and operations on registers. And that’s pretty much all a CPU does.

Now lets look at the assembly in detail, starting with the first instruction. Remember we have two parameters `a` & `b` which we need to load from memory somewhere, add together, then return to the caller somehow.

1. `MOVQ $0x0, 0x18(SP)` puts 0 in the memory location SP+0x18. This is a bit mysterious.
2. `MOVQ 0x8(SP), AX` puts the contents of memory location SP+0x8 in CPU register AX. Perhaps this is loading one of our parameters from memory?
3. `MOVQ 0x10(SP), CX` puts the contents of memory location SP+0x10 in CPU register CX. This could be our other parameter.
4. `ADDQ CX, AX` adds CX to AX, leaving the result in AX. Well, that’s adding the two parameters surely.
5. `MOVQ AX, 0x18(SP)` stores the contents of register AX at the memory location SP+0x18. And that’s saving the result of the addition.
6. `RET` returns to the calling function.

Remember our function has two parameters `a` & `b`, and it calculates `a+b` and returns the result. `MOVQ 0x8(SP), AX` is moving parameter `a` to AX. `a` is passed into the function on the stack at SP+0x8. `MOVQ 0x10(SP), CX` moves parameter `b` to CX. Parameter `b` is passed into the function on the stack at SP+0x10. `ADDQ CX, AX` adds `a` & `b`. `MOVQ AX, 0x18(SP)` stores the result at SP+0x18. The result is passed out of the function by placing it on the stack at SP+0x18. When the function returns the calling function can read the result off the stack.

[I’ve assumed `a` is the first parameter and `b` is the second. I’m not sure that’s right. We’d need to play around a bit to work that out, but this post is getting pretty long already]

So what’s that mysterious first line doing? `MOVQ $0x0, 0x18(SP)` is storing 0 in location SP+0x18, which is where our result is finally stored. We can guess that this is because Go sets uninitialised values to zero, and we’ve turned off optimisations so the compiler still does this even if it’s unnecessary.

So what have we learnt.

- Well, it looks like parameters are stored on the stack, with the first at SP+0x8, and the others at following at higher-numbered addresses.
- And it looks like returned values are stored after the parameters, at yet-higher still addresses.

Let’s now look at another function. This one has a local variable, but we’ve still kept it simple.

```
func add3(a int) int {
    b := 3
    return a + b
}
```

We use the same procedure to get an assembly listing.

```
TEXT main.add3(SB) 
/Users/phil/go/src/github.com/philpearl/func/main.go
 main.go:15 0x2280 4883ec10  SUBQ $0x10, SP
 main.go:15 0x2284 48896c2408  MOVQ BP, 0x8(SP)
 main.go:15 0x2289 488d6c2408  LEAQ 0x8(SP), BP
 main.go:15 0x228e 48c744242000000000 MOVQ $0x0, 0x20(SP)
 
 main.go:16 0x2297 48c7042403000000 MOVQ $0x3, 0(SP)
 
 main.go:17 0x229f 488b442418  MOVQ 0x18(SP), AX
 main.go:17 0x22a4 4883c003  ADDQ $0x3, AX
 main.go:17 0x22a8 4889442420  MOVQ AX, 0x20(SP)
 main.go:17 0x22ad 488b6c2408  MOVQ 0x8(SP), BP
 main.go:17 0x22b2 4883c410  ADDQ $0x10, SP
 main.go:17 0x22b6 c3   RET
```

Oh! That looks quite a bit more complicated. Let’s try to work it out.

The first 4 instructions are listed against source code line 15. Here is that line:

```
func add3(a int) int {
```

That line doesn’t seem to do much. So perhaps this is some kind of function preamble. Let’s break it down.

- `SUBQ $0x10, SP` subtracts 0x10=16 from SP. This gives us 16 bytes more space on the stack
- `MOVQ BP, 0x8(SP)` stores the value of the register BP at SP+8, then `LEAQ 0x8(SP), BP` loads the address SP+8 into BP. So we’ve made a space to store the old value of BP, then loaded BP with the address of that space. This helps establish the chain of stack areas (or *stack frames*). This is a bit mysterious, and I’m afraid we won’t solve this in this post.
- Finally in this section we have `MOVQ $0x0, 0x20(SP)` which, similar to the last function we considered, initialises the return value to 0.

The next line of the assembly corresponds to `b := 3` in the source code. The instruction is `MOVQ $0x3, 0(SP)`, which puts the value 3 into memory at SP+0. This solves one mystery. When we subtracted 0x10=16 from SP we made room for 2 8-byte values: our local variable `b` stored at SP+0, and the old value of BP stored at SP+0x08.

The next 6 lines of assembly correspond to `return a + b`. This needs to cover loading `a` & `b` from memory, adding them, and returning the result. Let’s look at each line in turn.

- `MOVQ 0x18(SP), AX` moves the function parameter `a` stored at SP+0x18 into register AX
- `ADDQ $0x3, AX` adds 3 to AX (for some reason it doesn’t use our local variable `b` at SP+0, even though optimisations are turned off)
- `MOVQ AX, 0x20(SP)` stores the result of `a+b` at SP+0x20, which is where our return value is stored.
- Next we have `MOVQ 0x8(SP), BP` and `ADDQ $0x10, SP`. These restore the old value of BP, then adds 0x10 to SP, setting it back to the value it was at the start of the function.
- Finally we have `RET`, which returns to the caller.

So what have we learnt?

- The calling function makes space on the stack for the returned values and function parameters. The space for returned values is higher up the stack than the parameters.
- If the called function has local variables it makes room for them by decreasing the value of the stack pointer SP. It also does something mysterious with the register BP.
- When the function returns any manipulations of SP & BP are reversed.

Let’s map out how the stack was used in the add3() function:

```
SP+0x20: the return value


SP+0x18: the parameter a


SP+0x10: ??


SP+0x08: the old value of BP

SP+0x0: the local variable b
```

If you look we didn’t see any mention of SP+0x10, so we don’t *know* what this is used for. But I can tell you that this is where the return address is stored. This is how the `RET` instruction knows where to return to.

Well, that’s enough for one post. Hopefully if you didn’t know how this stuff worked you now feel you understand it a little more, and if you were intimidated by assembly it’s perhaps a little less opaque. If you’d like any more detail on this stuff please write a comment and I’ll consider it for a future post.

If you got this far and enjoyed it or learned something, please hit that heart-button so other people can find it.
