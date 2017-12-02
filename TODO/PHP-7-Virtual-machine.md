> * 原文地址：[PHP 7 Virtual Machine](http://nikic.github.io/2017/04/14/PHP-7-Virtual-machine.html)
> * 原文作者：[nikic](http://nikic.github.io/aboutMe.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# PHP 7 Virtual Machine #
        
This article aims to provide an overview of the Zend Virtual Machine, as it is found in PHP 7. This is not a
comprehensive description, but I try to cover most of the important parts, as well as some of the finer details.

This description targets PHP version 7.2 (currently in development), but nearly everything also applies to PHP 7.0/7.1.
However, the differences to the PHP 5.x series VM are significant and I will generally not bother to draw parallels.

Most of this post will consider things at the level of instruction listings and only a few sections at the end deal with
the actual C level implementation of the VM. However, I do want to provide some links to the main files that make up the
VM upfront:

- [zend_vm_def.h](https://github.com/php/php-src/blob/master/Zend/zend_vm_def.h): The VM definition file.
- [zend_vm_execute.h](https://github.com/php/php-src/blob/master/Zend/zend_vm_execute.h): The generated virtual machine.
- [zend_vm_gen.php](https://github.com/php/php-src/blob/master/Zend/zend_vm_gen.php): The generating script.
- [zend_execute.c](https://github.com/php/php-src/blob/master/Zend/zend_execute.c): Most of the direct support code.

## Opcodes ##

In the beginning, there was the opcode. “Opcode” is how we refer to a full VM instruction (including operands), but may
also designate only the “actual” operation code, which is a small integer determining the type of instruction. The
intended meaning should be clear from context. In source code, full instructions are usually called “oplines”.

An individual instruction conforms to the following `zend_op` structure:

```
struct _zend_op {
    const void *handler;
    znode_op op1;
    znode_op op2;
    znode_op result;
    uint32_t extended_value;
    uint32_t lineno;
    zend_uchar opcode;
    zend_uchar op1_type;
    zend_uchar op2_type;
    zend_uchar result_type;
};
```

As such, opcodes are essentially a “three-address code” instruction format. There is an `opcode` determining the
instruction type, there are two input operands `op1` and `op2` and one output operand `result`.

Not all instructions use all operands. An `ADD` instruction (representing the `+` operator) will use all three. A
`BOOL_NOT` instruction (representing the `!` operator) uses only op1 and result. An `ECHO` instruction uses only op1.
Some instructions may either use or not use an operand. For example `DO_FCALL` may or may not have a result operand,
depending on whether the return value of the function call is used. Some instructions require more than two input
operands, in which case they will simply use a second dummy instruction (`OP_DATA`) to carry additional operands.

Next to these three standard operands, there exists an additional numeric `extended_value` field, which can be used to
hold additional instruction modifiers. For example for a `CAST` it might contain the target type to cast to.

Each operand has a type, stored in `op1_type`, `op2_type` and `result_type` respectively. The possible types are
`IS_UNUSED`, `IS_CONST`, `IS_TMPVAR`, `IS_VAR` and `IS_CV`.

The three latter types designated a variable operand (with three different types of VM variables), `IS_CONST` denotes
a constant operand (`5` or `"string"` or even `[1, 2, 3]`), while `IS_UNUSED` denotes an operand that is either actually
unused, or which is used as a 32-bit numeric value (an “immediate”, in assembly jargon). Jump instructions for example
will store the jump target in an `UNUSED` operand.

### Obtaining opcode dumps ###

In the following, I’ll often show opcode sequences that PHP generates for some example code. There are currently three
ways by which such opcode dumps may be obtained:

```
# Opcache, since PHP 7.1
php -d opcache.opt_debug_level=0x10000 test.php

# phpdbg, since PHP 5.6
phpdbg -p* test.php

# vld, third-party extension
php -d vld.active=1 test.php

```

Of these, opcache provides the highest-quality output. The listings used in this article are based on opcache dumps,
with minor syntax adjustments. The magic number `0x10000` is short for “before optimization”, so that we see the opcodes
as the PHP compiler produced them. `0x20000` would give you optimized opcodes. Opcache can also generate a lot more
information, for example `0x40000` will produce a CFG, while `0x200000` will produce type- and range-inferred SSA form.
But that’s getting ahead of ourselves: plain old linearized opcode dumps are sufficient for our purposes.

## Variable types ##

Likely one of the most important points to understand when dealing with the PHP virtual machine, are the three distinct
variable types it uses. In PHP 5 TMPVAR, VAR and CV had very different representations on the VM stack, along with
different ways of accessing them. In PHP 7 they have become very similar in that they share the same storage mechanism.
However there are important differences in the values they can contain and their semantics.

CV is short for “compiled variable” and refers to a “real” PHP variable. If a function uses variable `$a`, there will be
a corresponding CV for `$a`.

CVs can have `UNDEF` type, to denote undefined variables. If an UNDEF CV is used in an instruction, it will (in most
cases) throw the well-known “undefined variable” notice. On function entry all non-argument CVs are initialized to be
UNDEF.

CVs are not consumed by instructions, e.g. an instruction `ADD $a, $b` will *not* destroy the values stored in CVs `$a`
and `$b`. Instead all CVs are destroyed together on scope exit. This also implies that all CVs are “live” for the
entire duration of function, where “live” here refers to containing a valid value (not live in the data flow sense).

TMPVARs and VARs on the other hand are virtual machine temporaries. They are typically introduced as the result operand
of some operation. For example the code `$a = $b + $c + $d` will result in an opcode sequence similar to the following:

```
T0 = ADD $b, $c
T1 = ADD T0, $d
ASSIGN $a, T1

```

TMP/VARs are always defined before use and as such cannot hold an UNDEF value. Unlike CVs, these variable types *are*
consumed by the instructions they’re used in. In the above example, the second ADD will destroy the value of the T0
operand and T0 must not be used after this point (unless it is written to beforehand). Similarly, the ASSIGN will
consume the value of T1, invalidating T1.

It follows that TMP/VARs are usually very short-lived. In a large number of cases a temporary only lives for the space
of a single instruction. Outside this short liveness interval, the value in the temporary is garbage.

So what’s the difference between TMP and VAR? Not much. The distinction was inherited from PHP 5, where TMPs were VM
stack allocated, while VARs were heap allocated. In PHP 7 all variables are stack allocated. As such, nowadays the main
difference between TMPs and VARs is that only the latter are allowed to contain REFERENCEs (this allows us to elide
DEREFs on TMPs). Furthermore VARs may hold two types of special values, namely class entries and INDIRECT values. The
latter are used to handle non-trivial assignments.

The following table attempts to summarize the main differences:

```
       | UNDEF | REF | INDIRECT | Consumed? | Named? |
-------|-------|-----|----------|-----------|--------|
CV     |  yes  | yes |    no    |     no    |  yes   |
TMPVAR |   no  |  no |    no    |    yes    |   no   |
VAR    |   no  | yes |   yes    |    yes    |   no   |

```

## Op arrays ##

All PHP functions are represented as structures that have a common `zend_function` header. “Function” here is to be
understood somewhat broadly and includes everything from “real” functions, over methods, down to free-standing
“pseudo-main” code and “eval” code.

Userland functions use the `zend_op_array` structure. It has more than 30 members, so I’m starting with a reduced
version for now:

```
struct _zend_op_array {
    /* Common zend_function header here */

    /* ... */
    uint32_t last;
    zend_op *opcodes;
    int last_var;
    uint32_t T;
    zend_string **vars;
    /* ... */
    int last_literal;
    zval *literals;
    /* ... */
};
```

The most important part here are of course the `opcodes`, which is an array of opcodes (instructions). `last` is the
number of opcodes in this array. Note that the terminology is confusing here, as `last` sounds like it should be the
index of the last opcode, while it really is the number of opcodes (which is one greater than the last index). The same
applies to all other `last_*` values in the op array structure.

`last_var` is the number of CVs, and `T` is the number of TMPs and VARs (in most places we make no strong distinction
between them). `vars` in array of names for CVs.

`literals` is an array of literal values occurring in the code. This array is what `CONST` operands reference. Depending
on the ABI, each `CONST` operand will either a store a pointer into this `literals` table, or store an offset relative
to its start.

There is more to the op array structure than this, but it can wait for later.

## Stack frame layout ##

Apart from some executor globals (EG), all execution state is stored on the virtual machine stack. The VM stack is
allocated in pages of 256 KiB and individual pages are connected through a linked list.

On each function call, a new stack frame is allocated on the VM stack, with the following layout:

```
+----------------------------------------+
| zend_execute_data                      |
+----------------------------------------+
| VAR[0]                =         ARG[1] | arguments
| ...                                    |
| VAR[num_args-1]       =         ARG[N] |
| VAR[num_args]         =   CV[num_args] | remaining CVs
| ...                                    |
| VAR[last_var-1]       = CV[last_var-1] |
| VAR[last_var]         =         TMP[0] | TMP/VARs
| ...                                    |
| VAR[last_var+T-1]     =         TMP[T] |
| ARG[N+1] (extra_args)                  | extra arguments
| ...                                    |
+----------------------------------------+

```

The frame starts with a `zend_execute_data` structure, followed by an array of variable slots. The slots are all the
same (simple zvals), but are used for different purposes. The first `last_var` slots are CVs, of which the first
`num_args` holds function arguments. The CV slots are followed by `T` slots for TMP/VARs. Lastly, there can sometimes be
“extra” arguments stored at the end of the frame. These are used for handling `func_get_args()`.

CV and TMP/VAR operands in instructions are encoded as offsets relative to the start of the stack frame, so fetching
a certain variable is simply an offseted read from the `execute_data` location.

The execute data at the start of the frame is defined as follows:

```
struct _zend_execute_data {
    const zend_op       *opline;
    zend_execute_data   *call;
    zval                *return_value;
    zend_function       *func;
    zval                 This;             /* this + call_info + num_args    */
    zend_class_entry    *called_scope;
    zend_execute_data   *prev_execute_data;
    zend_array          *symbol_table;
    void               **run_time_cache;   /* cache op_array->run_time_cache */
    zval                *literals;         /* cache op_array->literals       */
};
```

Most importantly, this structure contains `opline`, which is the currently executed instruction, and `func`, which is
the currently executed function. Furthermore:

- `return_value` is a pointer to the zval into the which the return value will be stored.
- `This` is the `$this` object, but also encodes the number of function arguments and a couple of call metadata flags
in some unused zval space.
- `called_scope` is the scope that `static::` refers to in PHP code.
- `prev_execute_data` points to the previous stack frame, to which execution will return after this function finished
running.
- `symbol_table` is a typically unused symbol table used in case some crazy person actually uses variable variables or
similar features.
- `run_time_cache` caches the op array runtime cache, in order to avoid one pointer indirection when accessing this
structure (which is discussed later).
- `literals` caches the op array literals table for the same reason.

## Function calls ##

I’ve skipped one field in the execute_data structure, namely `call`, as it requires some further context about how
function calls work.

All calls use a variation on the same instruction sequence. A `var_dump($a, $b)` in global scope will compile to:

```
INIT_FCALL (2 args) "var_dump"
SEND_VAR $a
SEND_VAR $b
V0 = DO_ICALL   # or just DO_ICALL if retval unused

```

There are eight different types of INIT instructions depending on what kind of call it is. INIT_FCALL is used for calls
to free functions that we recognize at compile time. Similarly there are ten different SEND opcodes depending on the
type of the arguments and the function. There is only a modest number of four DO_CALL opcodes, where ICALL is used for
calls to internal functions.

While the specific instructions may differ, the structure is always the same: INIT, SEND, DO. The main issue that the
call sequence has to contend with are nested function calls, which compile something like this:

```
# var_dump(foo($a), bar($b))
INIT_FCALL (2 args) "var_dump"
    INIT_FCALL (1 arg) "foo"
    SEND_VAR $a
    V0 = DO_UCALL
SEND_VAR V0
    INIT_FCALL (1 arg) "bar"
    SEND_VAR $b
    V1 = DO_UCALL
SEND_VAR V1
V2 = DO_ICALL

```

I’ve indented the opcode sequence to visualize which instructions correspond to which call.

The INIT opcode pushes a call frame on the stack, which contains enough space for all the variables in the function and
the number of arguments we know about (if argument unpacking is involved, we may end up with more arguments). This call
frame is initialized with the called function, `$this` and the `called_scope` (in this case the latter are both NULL, as
we’re calling free functions).

A pointer to the new frame is stored into `execute_data->call`, where `execute_data` is the frame of the calling
function. In the following we’ll denote such accesses as `EX(call)`. Notably, the `prev_execute_data` of the new frame
is set to the old `EX(call)` value. For example, the INIT_FCALL for call `foo` will set the prev_execute_data to the
stack frame of the `var_dump` (rather than that of the surrounding function). As such, prev_execute_data in this case
forms a linked list of “unfinished” calls, while usually it would provide the backtrace chain.

The SEND opcodes then proceed to push arguments into the variable slots of `EX(call)`. At this point the arguments are
all consecutive and may overflow from the section designated for arguments into other CVs or TMPs. This will be fixed
later.

Lastly DO_FCALL performs the actual call. What was `EX(call)` becomes the current function and `prev_execute_data` is
relinked to the calling function. Apart from that, the call procedure depends on what kind of function it is. Internal
functions only need to invoke a handler function, while userland functions need to finish initialization of the stack
frame.

This initialization involves fixing up the argument stack. PHP allows passing more arguments to a function than it
expects (and `func_get_args` relies on this). However, only the actually declared arguments have corresponding CVs.
Any arguments beyond this will write into memory reserved for other CVs and TMPs. As such, these arguments will be moved
after the TMPs, ending up with arguments segmented into two non-continuous chunks.

To have it clearly stated, userland function calls do not involve recursion at the virtual machine level. They only
involve a switch from one execute_data to another, but the VM continues running in a linear loop. Recursive virtual
machine invocations only occur if internal functions invoke userland callbacks (e.g. through `array_map`). This is the
reason why infinite recursion in PHP usually results in a memory limit or OOM error, but it is possible to trigger a
stack overflow by recursion through callback-functions or magic methods.

### Argument sending ###

PHP uses a large number of different argument sending opcodes, whose differences can be confusing, no thanks to some
unfortunate naming.

SEND_VAL and SEND_VAR are the simplest variants, which handle sending of by-value arguments that are known to be
by-value at compile time. SEND_VAL is used for CONST and TMP operands, while SEND_VAR is for VARs and CVs.

SEND_REF conversely, is used for arguments that are known to be by-reference during compilation. As only variables can
be sent by reference, this opcode only accepts VARs and CVs.

SEND_VAL_EX and SEND_VAR_EX are variants of SEND_VAL/SEND_VAR for cases where we cannot determine statically whether the
argument is by-value or by-reference. These opcodes will check the kind of the argument based on arginfo and behave
accordingly. In most cases the actual arginfo structure is not used, but rather a compact bit vector representation
directly in the function structure.

And then there is SEND_VAR_NO_REF_EX. Don’t try to read anything into its name, it’s outright lying. This opcode is
used when passing something that isn’t really a “variable” but does return a VAR to a statically unknown argument. Two
particular examples where it is used are passing the result of a function call as an argument, or passing the result of
an assignment.

This case needs a separate opcode for two reasons: Firstly, it will generate the familiar “Only variables should be
passed by reference” notice if you try to pass something like an assignment by ref (if SEND_VAR_EX were used instead, it
would have been silently allowed). Secondly, this opcode deals with the case that you might want to pass the result of
a reference-returning function to a by-reference argument (which should not throw anything). The SEND_VAR_NO_REF variant
of this opcode (without the _EX) is a specialized variant for the case where we statically know that a reference is
expected (but we don’t know whether the argument is one).

The SEND_UNPACK and SEND_ARRAY opcodes deal with argument unpacking and inlined `call_user_func_array` calls
respectively. They both push the elements from an array onto the argument stack and differ in various details (e.g.
unpacking supports Traversables while call_user_func_array does not). If unpacking/cufa is used, it may be necessary
to extend the stack frame beyond its previous size (as the real number of function arguments is not known at the time
of initialization). In most cases this extension can happen simply by moving the stack top pointer. However if this
would cross a stack page boundary, a new page has to be allocated and the entire call frame (including already pushed
arguments) needs to be copied to the new page (we are not be able to handle a call frame crossing a page boundary).

The last opcode is SEND_USER, which is used for inlined `call_user_func` calls and deals with some of its peculiarities.

While we haven’t yet discussed the different variable fetch modes, this seems like a good place to introduce the
FUNC_ARG fetch mode. Consider a simple call like `func($a[0][1][2])`, for which we do not know at compile-time whether
the argument will be passed by-value or by-reference. In both cases the behavior will be wildly different. If the pass is
by-value and `$a` was previously empty, this could would have to generate a bunch of “undefined index” notices. If the
pass is by-reference we’d have to silently initialize the nested arrays instead.

The FUNC_ARG fetch mode will dynamically choose one of the two behaviors (R or W), by inspecting the arginfo of the
current `EX(call)` function. For the `func($a[0][1][2])` example, the opcode sequence might look something like this:

```
INIT_FCALL_BY_NAME "func"
V0 = FETCH_DIM_FUNC_ARG (arg 1) $a, 0
V1 = FETCH_DIM_FUNC_ARG (arg 1) V0, 1
V2 = FETCH_DIM_FUNC_ARG (arg 1) V1, 2
SEND_VAR_EX V2
DO_FCALL

```

## Fetch modes ##

The PHP virtual machine has four classes of fetch opcodes:

```
FETCH_*             // $_GET, $$var
FETCH_DIM_*         // $arr[0]
FETCH_OBJ_*         // $obj->prop
FETCH_STATIC_PROP_* // A::$prop

```

These do precisely what one would expect them to do, with the caveat that the basic FETCH_* variant is only used to
access variable-variables and superglobals: normal variable accesses go through the much faster CV mechanism instead.

These fetch opcodes each come in six variants:

```
_R
_RW
_W
_IS
_UNSET
_FUNC_ARG

```

We’ve already learned that _FUNC_ARG chooses between _R and _W depending on whether a function argument is by-value or
by-reference. Let’s try to create some situations where we would expect the different fetch types to appear:

```
// $arr[0];
V2 = FETCH_DIM_R $arr int(0)
FREE V2

// $arr[0] = $val;
ASSIGN_DIM $arr int(0)
OP_DATA $val

// $arr[0] += 1;
ASSIGN_ADD (dim) $arr int(0)
OP_DATA int(1)

// isset($arr[0]);
T5 = ISSET_ISEMPTY_DIM_OBJ (isset) $arr int(0)
FREE T5

// unset($arr[0]);
UNSET_DIM $arr int(0)

```

Unfortunately, the only actual fetch this produced is FETCH_DIM_R: Everything else is handled through special opcodes.
Note that ASSIGN_DIM and ASSIGN_ADD both use an extra OP_DATA, because they need more than two input operands. The
reason why special opcodes like ASSIGN_DIM are used, instead of something like FETCH_DIM_W + ASSIGN, is (apart from
performance) that these operations may be overloaded, e.g., in the ASSIGN_DIM case by means of an object implementing
ArrayAccess::offsetSet(). To actually generate the different fetch types we need to increase the level of nesting:

```
// $arr[0][1];
V2 = FETCH_DIM_R $arr int(0)
V3 = FETCH_DIM_R V2 int(1)
FREE V3

// $arr[0][1] = $val;
V4 = FETCH_DIM_W $arr int(0)
ASSIGN_DIM V4 int(1)
OP_DATA $val

// $arr[0][1] += 1;
V6 = FETCH_DIM_RW $arr int(0)
ASSIGN_ADD (dim) V6 int(1)
OP_DATA int(1)

// isset($arr[0][1]);
V8 = FETCH_DIM_IS $arr int(0)
T9 = ISSET_ISEMPTY_DIM_OBJ (isset) V8 int(1)
FREE T9

// unset($arr[0][1]);
V10 = FETCH_DIM_UNSET $arr int(0)
UNSET_DIM V10 int(1)

```

Here we see that while the outermost access uses specialized opcodes, the nested indexes will be handled using FETCHes
with an appropriate fetch mode. The fetch modes essentially differ by a) whether they generate an “undefined offset”
notice if the index doesn’t exist, and whether they fetch the value for writing:

```
      | Notice? | Write?
R     |  yes    |  no
W     |  no     |  yes
RW    |  yes    |  yes
IS    |  no     |  no
UNSET |  no     |  yes-ish

```

The case of UNSET is a bit peculiar, in that it will only fetch existing offsets for writing, and leave undefined ones
alone. A normal write-fetch would initialize undefined offsets instead.

### Writes and memory safety ###

Write fetches return VARs that may contain either a normal zval or an INDIRECT pointer to another zval. Of course, in
the former case any changes applied to the zval will not be visible, as the value is only accessible through a VM
temporary. While PHP prohibits expression such as `[][0] = 42`, we still need to handle this for cases like
`call()[0] = 42`. Depending on whether `call()` returns by-value or by-reference, this expression may or may not have an
observable effect.

The more typical case is when the fetch returns an INDIRECT, which contains a pointer to the storage location that is
being modified, for example a certain location in a hashtable data array. Unfortunately, such pointers are fragile
things and easily invalidated: any concurrent write to the array might trigger a reallocation, leaving behind a dangling
pointer. As such, it is critical to prevent the execution of user code between the point where an INDIRECT value is
created and where it is consumed.

Consider this example:

```
$arr[a()][b()]=c();
```

Which generates:

```
INIT_FCALL_BY_NAME (0 args) "a"
V1 = DO_FCALL_BY_NAME
INIT_FCALL_BY_NAME (0 args) "b"
V3 = DO_FCALL_BY_NAME
INIT_FCALL_BY_NAME (0 args) "c"
V5 = DO_FCALL_BY_NAME
V2 = FETCH_DIM_W $arr V1
ASSIGN_DIM V2 V3
OP_DATA V5

```

Notably, this sequence first executes all side-effects from left to right and only then performs any necessary write
fetches (we refer to the FETCH_DIM_W here as a “delayed opline”). This ensures that the write-fetch and the consuming
instruction are directly adjacent.

Consider another example:

```
$arr[0]=&$arr[1];
```

Here we have a bit of problem: Both sides of the assignment must be fetched for write. However, if we fetch `$arr[0]`
for write and then `$arr[1]` for write, the latter might invalidate the former. This problem is solved as follows:

```
V2 = FETCH_DIM_W $arr 1
V3 = MAKE_REF V2
V1 = FETCH_DIM_W $arr 0
ASSIGN_REF V1 V3

```

Here `$arr[1]` is fetched for write first, then turned into a reference using MAKE_REF. The result of MAKE_REF is no
longer INDIRECT and not subject to invalidation, as such the fetch of `$arr[0]` can be performed safely.

## Exception handling ##

Exceptions are the root of all evil.

An exception is generated by writing an exception into `EG(exception)`, where EG refers to executor globals. Throwing
exceptions from C code does not involve stack unwinding, instead the abortion will propagate upwards through return
value failure codes or checks for `EG(exception)`. The exception is only actually handled when control reenters the
virtual machine code.

Nearly all VM instructions can directly or indirectly result in an exception under some circumstances. For example any
“undefined variable” notice can result in an exception if a custom error handler is used. We want to avoid checking
whether `EG(exception)` has been set after each VM instruction. Instead a small trick is used:

When an exception is thrown the current opline of the current execute data is replaced with a dummy HANDLE_EXCEPTION
opline (this obviously does not modify the op array, it only redirects a pointer). The opline at which the exception
originated is backed up into `EG(opline_before_exception)`.

This means that when control returns into the main virtual machine dispatch loop, the HANDLE_EXCEPTION opcode will be
invoked. There is a slight problem with this scheme: It requires that a) the opline stored in the execute data is
actually the currently executed opline (otherwise opline_before_exception would be wrong) and b) the virtual machine
uses the opline from the execute data to continue execution (otherwise HANDLE_EXCEPTION will not be invoked).

While these requirements may sound trivial, they are not. The reason is that the virtual machine may be working on a
different opline variable that is out-of-sync with the opline stored in execute data. Before PHP 7 this only happened
in the rarely used GOTO and SWITCH virtual machines, while in PHP 7 this is actually the default mode of operation: If
the compiler supports it, the opline is stored in a global register.

As such, before performing any operation that might possibly throw, the local opline must be written back into the
execute data (SAVE_OPLINE operation). Similarly, after any potentially throwing operation the local opline must be
populated from execute data (mostly a CHECK_EXCEPTION operation).

Now, this machinery is what causes a HANDLE_EXCEPTION opcode to execute after an exception is thrown. But what does it
do? First of all, it determines whether the exception was thrown inside a try block. For this purpose the op array
contains an array of try_catch_elements that track opline offsets for try, catch and finally blocks:

```
typedef struct _zend_try_catch_element {
	uint32_t try_op;
	uint32_t catch_op;  /* ketchup! */
	uint32_t finally_op;
	uint32_t finally_end;
} zend_try_catch_element;
```

For now we will pretend that finally blocks do not exist, as they are a whole different rabbit hole. Assuming that we
are indeed inside a try block, the VM needs to clean up all unfinished operations that started before the throwing
opline and don’t span past the end of the try block.

This involves freeing the stack frames and associated data of all calls currently in flight, as well as freeing live
temporaries. In the majority of cases temporaries are short-lived to the point that the consuming instruction directly
follows the generating one. However it can happen that the live-range spans multiple, potentially throwing instructions:

```
# (array)[] + throwing()
L0:   T0 = CAST (array) []
L1:   INIT_FCALL (0 args) "throwing"
L2:   V1 = DO_FCALL
L3:   T2 = ADD T0, V1

```

In this case the T0 variable is live during instructions L1 and L2, and as such would need to be destroyed if the
function call throws. One particular type of temporary tends to have particularly long live ranges: Loop variables.
For example:

```
# foreach ($array as $value) throw $ex;
L0:   V0 = FE_RESET_R $array, ->L4
L1:   FE_FETCH_R V0, $value, ->L4
L2:   THROW $ex
L3:   JMP ->L1
L4:   FE_FREE V0

```

Here the “loop variable” V0 lives from L1 to L3 (generally always spanning the entire loop body). Live ranges are stored
in the op array using the following structure:

```
typedef struct _zend_live_range {
    uint32_t var; /* low bits are used for variable type (ZEND_LIVE_* macros) */
    uint32_t start;
    uint32_t end;
} zend_live_range;
```

Here `var` is the (operand encoded) variable the range applies to, `start` is the start opline offset (not including the
generating instruction), while `end` if the end opline offset (including the consuming instruction). Of course live
ranges are only stored if the temporary is not immediately consumed.

The lower bits of `var` are used to store the type of the variable, which can be one of:

- ZEND_LIVE_TMPVAR: This is a “normal” variable. It holds an ordinary zval value. Freeing this variable behaves like a
FREE opcode.
- ZEND_LIVE_LOOP: This is a foreach loop variable, which holds more than a simple zval. This corresponds to a FE_FREE
opcode.
- ZEND_LIVE_SILENCE: This is used for implementing the error suppression operator. The old error reporting level is
backed up into a temporary and later restored. If an exception is thrown we obviously want to restore it as well.
This corresponds to END_SILENCE.
- ZEND_LIVE_ROPE: This is used for rope string concatenations, in which case the temporary is a fixed-sized array of
`zend_string*` pointers living on the stack. In this case all the strings that have already been populated must be
freed. Corresponds approximately to END_ROPE.

A tricky question to consider in this context is whether temporaries should be freed, if either their generating or
their consuming instruction throws. Consider the following simple code:

```
T2 = ADD T0, T1
ASSIGN $v, T2

```

If an exception is thrown by the ADD, should the T2 temporary be automatically freed, or is the ADD instruction
responsible for this? Similarly, if the ASSIGN throws, should T2 be freed automatically, or must the ASSIGN take care
of this itself? In the latter case the answer is clear: An instruction is always responsible for freeing its operands,
even if an exception is thrown.

The case of the result operand is more tricky, because the answer here changed between PHP 7.1 and 7.2: In PHP 7.1 the
instruction was responsible for freeing the result in case of an exception. In PHP 7.2 it is automatically freed (and
the instruction is responsible for making sure the result is *always* populated). The motivation for this change is the
way that many basic instructions (such as ADD) are implemented. Their usual structure goes roughly as follows:

```
1. read input operands
2. perform operation, write it into result operand
3. free input operands (if necessary)

```

This is problematic, because PHP is in the very unfortunate position of not only supporting exceptions and destructors,
but also supporting throwing destructors (this is the point where compiler engineers cry out in horror). As such, step 3
can throw, at which point the result is already populated. To avoid memory leaks in this edge-case, responsiblility for
freeing the result operand has been shifted from the instruction to the exception handling mechanism.

Once we have performed these cleanup operations, we can continue executing the catch block. If there is no catch (and
no finally) we unwind the stack, i.e. destroy the current stack frame and give the parent frame a shot at handling the
exception.

So you get a full appreciation for how ugly the whole exception handling business is, I’ll relate another tidbit related
to throwing destructors. It’s not remotely relevant in practice, but we still need to handle it to ensure correctness.
Consider this code:

```
foreach (new Dtor as $value) {
    try {
        echo "Return";
        return;
    } catch (Exception $e) {
        echo "Catch";
    }
}

```

Now imagine that `Dtor` is a Traversable class with a throwing destructor. This code will result in the following opcode
sequence, with the loop body indented for readability:

```
L0:   V0 = NEW 'Dtor', ->L2
L1:   DO_FCALL
L2:   V2 = FE_RESET_R V0, ->L11
L3:   FE_FETCH_R V2, $value
L4:       ECHO 'Return'
L5:       FE_FREE (free on return) V2   # <- return
L6:       RETURN null                   # <- return
L7:       JMP ->L10
L8:       CATCH 'Exception' $e
L9:       ECHO 'Catch'
L10:  JMP ->L3
L11:  FE_FREE V2                        # <- the duplicated instr

```

Importantly, note that the “return” is compiled to a FE_FREE of the loop variable and a RETURN. Now, what happens if
that FE_FREE throws, because `Dtor` has a throwing destructor? Normally, we would say that this instruction is within
the try block, so we should be invoking the catch. However, at this point the loop variable has already been destroyed!
The catch discards the exception and we’ll try to continue iterating an already dead loop variable.

The cause of this problem is that, while the throwing FE_FREE is inside the try block, it is a copy of the FE_FREE in
L11. Logically that is where the exception “really” occurred. This is why the FE_FREE generated by the break is
annotated as being a FREE_ON_RETURN. This instructs the exception handling mechanism to move the source of the exception
to the original freeing instruction. As such the above code will not run the catch block, it will generate an uncaught
exception instead.

## Finally handling ##

PHP’s history with finally blocks is somewhat troubled. PHP 5.5 first introduced finally blocks, or rather: a really
buggy implementation of finally blocks. Each of PHP 5.6, 7.0 and 7.1 shipped with major rewrites of the finally
implementation, each fixing a whole slew of bugs, but not quite managing to reach a fully correct implementation. It
looks like PHP 7.1 finally managed to hit the nail (fingers crossed).

While writing this section, I was surprised to find that from the perspective of the current implementation and my
current understanding, finally handling is actually not all that complicated. Indeed, in many ways the implementation
became simpler through the different iterations, rather than more complex. This goes to show how an insufficient
understanding of a problem can result in an implementation that is both excessively complex and buggy (although, to be
fair, part of the complexity of the PHP 5 implementation stemmed directly from the lack of an AST).

Finally blocks are run whenever control exits a try block, either normally (e.g. using return) or abnormally (by
throwing). There are a couple interesting edge-cases to consider, which I’ll quickly illustrate before going into the
implementation. Consider:

```
try {
    throw new Exception();
} finally {
    return 42;
}
```

What happens? Finally wins and the function returns 42. Consider:

```
try {
    return 24;
} finally {
    return 42;
}
```

Again finally wins and the function returns 42. The finally always wins.

PHP prohibits jumps out of finally blocks. For example the following is forbidden:

```
foreach ($array as $value) {
    try {
        return 42;
    } finally {
        continue;
    }
}
```

The “continue” in the above code sample will generate a compile-error. It is important to understand that this
limitation is purely cosmetic and can be easily worked around by using the “well-known” catch control delegation
pattern:

```
foreach ($array as $value) {
    try {
        try {
            return 42;
        } finally {
            throw new JumpException;
        }
    } catch (JumpException $e) {
        continue;
    }
}
```

The only real limitation that exists is that it is not possible to jump *into* a finally block, e.g. performing a goto
from outside a finally to a label inside a finally is forbidden.

With the preliminaries out of the way, we can look at how finally works. The implementation uses two opcodes, FAST_CALL
and FAST_RET. Roughly, FAST_CALL is for jumping into a finally block and FAST_RET is for jumping out of it. Let’s
consider the simplest case:

```
try {
    echo "try";
} finally {
    echo "finally";
}
echo "finished";
```

This code compiles down to the following opcode sequence:

```
L0:   ECHO string("try")
L1:   T0 = FAST_CALL ->L3
L2:   JMP ->L5
L3:   ECHO string("finally")
L4:   FAST_RET T0
L5:   ECHO string("finished")
L6:   RETURN int(1)

```

The FAST_CALL stores its own location into T0 and jumps into the finally block at L3. When FAST_RET is reached, it jumps
back to (one after) the location stored in T0. In this case this would be L2, which is just a jump around the finally
block. This is the base case where no special control flow (returns or exceptions) occurs. Let’s now consider the
exceptional case:

```
try {
    throw new Exception("try");
} catch (Exception $e) {
    throw new Exception("catch");
} finally {
    throw new Exception("finally");
}
```

When handling an exception, we have to consider the position of the thrown exception relative to the closest surrounding
try/catch/finally block:

1. Throw from try, with matching catch: Populate `$e` and jump into catch.
2. Throw from catch or try without matching catch, if there is a finally block: Jump into finally block and this
time back up the exception into the FAST_CALL temporary (instead of storing the return address there.)
3. Throw from finally: If there is a backed-up exception in the FAST_CALL temporary, chain it as the previous exception
of the thrown one. Continue bubbling the exception up to the next try/catch/finally.
4. Otherwise: Continue bubbling the exception up to the next try/catch/finally.

In this example we’ll go through the first three steps: First try throws, triggering a jump into catch. Catch also
throws, triggering a jump into the finally block, with the exception backed up in the FAST_CALL temporary. The finally
block then also throws, so that the “finally” exception will bubble up with the “catch” exception set as its previous
exception.

A small variation on the previous example is the following code:

```
try {
    try {
        throw new Exception("try");
    } finally {}
} catch (Exception $e) {
    try {
        throw new Exception("catch");
    } finally {}
} finally {
    try {
        throw new Exception("finally");
    } finally {}
}
```

All the inner finally blocks here are entered exceptionally, but left normally (via FAST_RET). In this case the
previously described exception handling procedure is resumed starting from the parent try/catch/finally block. This
parent try/catch is stored in the FAST_RET opcode (here “try-catch(0)”).

This essentially covers the interaction of finally and exceptions. But what about a return in finally?

```
try {
    throw new Exception("try");
} finally {
    return 42;
}
```

The relevant portion of the opcode sequence is this:

```
L4:   T0 = FAST_CALL ->L6
L5:   JMP ->L9
L6:   DISCARD_EXCEPTION T0
L7:   RETURN 42
L8:   FAST_RET T0

```

The additional DISCARD_EXCEPTION opcode is responsible for discarding the exception thrown in the try block (remember:
the return in the finally wins). What about a return in try?

```
try {
    $a = 42;
    return $a;
} finally {
    ++$a;
}
```

The excepted return value here is 42, not 43. The return value is determined by the `return $a` line, any further
modification of `$a` should not matter. The code results in:

```
L0:   ASSIGN $a, 42
L1:   T3 = QM_ASSIGN $a
L2:   T1 = FAST_CALL ->L6, T3
L3:   RETURN T3
L4:   T1 = FAST_CALL ->L6      # unreachable
L5:   JMP ->L8                 # unreachable
L6:   PRE_INC $a
L7:   FAST_RET T1
L8:   RETURN null

```

Two of the opcodes are unreachable, as they occur directly after a return. These will be removed during optimization,
but I’m showing unoptimized opcodes here. There are two interesting things here: Firstly, `$a` is copied into T3 using
QM_ASSIGN (which is basically a “copy into temporary” instruction). This is what prevents the later modification of `$a`
from affecting the return value. Secondly, T3 is also passed to FAST_CALL, which will back up the value in T1. If the
return from the try block is later discarded (e.g, because finally throws or returns), this mechanism will be used to
free the unused return value.

All of these individual mechanisms are simple, but some care needs to taken when they are composed. Consider the
following example, where `Dtor` is again some Traversable class with a throwing destructor:

```
try {
    foreach (new Dtor as $v) {
        try {
            return 1;
        } finally {
            return 2;
        }
    }
} finally {
    echo "finally";
}
```

This code generates the following opcodes:

```
L0:   V2 = NEW (0 args) "Dtor"
L1:   DO_FCALL
L2:   V4 = FE_RESET_R V2 ->L16
L3:   FE_FETCH_R V4 $v ->L16
L4:       T5 = FAST_CALL ->L10         # inner try
L5:       FE_FREE (free on return) V4
L6:       T1 = FAST_CALL ->L19
L7:       RETURN 1
L8:       T5 = FAST_CALL ->L10         # unreachable
L9:       JMP ->L15
L10:      DISCARD_EXCEPTION T5         # inner finally
L11:      FE_FREE (free on return) V4
L12:      T1 = FAST_CALL ->L19
L13:      RETURN 2
L14:      FAST_RET T5 try-catch(0)
L15:  JMP ->L3
L16:  FE_FREE V4
L17:  T1 = FAST_CALL ->L19
L18:  JMP ->L21
L19:  ECHO "finally"                   # outer finally
L20:  FAST_RET T1

```

The sequence for the first return (from inner try) is FAST_CALL L10, FE_FREE V4, FAST_CALL L19, RETURN. This will first
call into the inner finally block, then free the foreach loop variable, then call into the outer finally block and
then return. The sequence for the second return (from inner finally) is DISCARD_EXCEPTION T5, FE_FREE V4,
FAST_CALL L19. This first discards the exception (or here: return value) of the inner try block, then frees the foreach
loop variable and finally calls into the outer finally block. Note how in both cases the order of these instructions is
the reverse order of the relevant blocks in the source code.

## Generators ##

Generator functions may be paused and resumed, and consequently require special VM stack management. Here’s a simple
generator:

```
function gen($x) {
    foo(yield $x);
}
```

This yields the following opcodes:

```
$x = RECV 1
GENERATOR_CREATE
INIT_FCALL_BY_NAME (1 args) string("foo")
V1 = YIELD $x
SEND_VAR_NO_REF_EX V1 1
DO_FCALL_BY_NAME
GENERATOR_RETURN null

```

Until GENERATOR_CREATE is reached, this is executed as a normal function, on the normal VM stack. GENERATOR_CREATE then
creates a `Generator` object, as well as a heap-allocated execute_data structure (including slots for variables and
arguments, as usual), into which the execute_data on the VM stack is copied.

When the generator is resumed again, the executor will use the heap-allocated execute_data, but will continue to use the
main VM stack to push call frames. An obvious problem with this is that it’s possible to interrupt a generator while a
call is in progress, as the previous example shows. Here the YIELD is executed at a point where the call frame for the
call foo() has already been pushed onto the VM stack.

This relatively uncommon case is handled by copying the active call frames into the generator structure when control is
yielded, and restoring them when the generator is resumed.

This design is used since PHP 7.1. Previously, each generator had its own 4KiB VM page, which would be swapped into the
executor when a generator was restored. This avoids the need for copying call frames, but increases memory usage.

## Smart branches ##

It is very common that comparison instructions are directly followed by condition jumps. For example:

```
L0:   T2 = IS_EQUAL $a, $b
L1:   JMPZ T2 ->L3
L2:   ECHO "equal"

```

Because this pattern is so common, all the comparison opcodes (such as IS_EQUAL) implement a smart branch mechanism:
they check if the next instruction is a JMPZ or JMPNZ instruction and if so, perform the respective jump operation
themselves.

The smart branch mechanism only checks whether the next instruction is a JMPZ/JMPNZ, but does not actually check whether
its operand is actually the result of the comparison, or something else. This requires special care in cases where the
comparison and subsequent jump are unrelated. For example, the code `($a == $b) + ($d ? $e : $f)` generates:

```
L0:   T5 = IS_EQUAL $a, $b
L1:   NOP
L2:   JMPZ $d ->L5
L3:   T6 = QM_ASSIGN $e
L4:   JMP ->L6
L5:   T6 = QM_ASSIGN $f
L6:   T7 = ADD T5 T6
L7:   FREE T7

```

Note that a NOP has been inserted between the IS_EQUAL and the JMPZ. If this NOP weren’t present, the branch would end
up using the IS_EQUAL result, rather than the JMPZ operand.

## Runtime cache ##

Because opcode arrays are shared (without locks) between multiple processes, they are strictly immutable. However,
runtime values may be cached in a separate “runtime cache”, which is basically an array of pointers. Literals may have
an associated runtime cache entry (or more than one), which is stored in their u2 slot.

Runtime cache entries come in two types: The first are ordinary cache entries, such as the one used by INIT_FCALL. After
INIT_FCALL has looked up the called function once (based on its name), the function pointer will be cached in the
associated runtime cache slot.

The second type are polymorphic cache entries, which are just two consecutive cache slots, where the first stores a
class entry and the second the actual datum. These are used for operations like FETCH_OBJ_R, where the offset of the
property in the property table for a certain class is cached. If the next access happens on the same class (which is
quite likely), the cached value will be used. Otherwise a more expensive lookup operation is performed, and the result
is cached for the new class entry.

## VM interrupts ##

Prior to PHP 7.0, execution timeouts used to handled by a longjump into the shutdown sequence directly from the signal
handler. As you may imagine, this caused all manner of unpleasantness. Since PHP 7.0 timeouts are instead delayed until
control returns to the virtual machine. If it doesn’t return within a certain grace period, the process is aborted.
Since PHP 7.1 pcntl signal handlers use the same mechanism as execution timeouts.

When a signal is pending, a VM interrupt flag is set and this flag is checked by the virtual machine at certain points.
A check is not performed at every instruction, but rather only on jumps and calls. As such the interrupt will not be
handled immediately on return to the VM, but rather at the end of the current section of linear control flow.

## Specialization ##

If you take a look at the [VM definition](https://github.com/php/php-src/blob/master/Zend/zend_vm_def.h) file, you’ll
find that opcode handlers are defined as follows:

```
ZEND_VM_HANDLER(1, ZEND_ADD, CONST|TMPVAR|CV, CONST|TMPVAR|CV)

```

The `1` here is the opcode number, `ZEND_ADD` its name, while the other two arguments specify which operand types the
instruction accepts. The [generated virtual machine code](https://github.com/php/php-src/blob/master/Zend/zend_vm_execute.h)
(generated by [zend_vm_gen.php](https://github.com/php/php-src/blob/master/Zend/zend_vm_gen.php)) will then contain
specialized handlers for each of the possible operand type combinations. These will have names like
ZEND_ADD_SPEC_CONST_CONST_HANDLER.

The specialized handlers are generated by replacing certain macros in the handler body. The obvious ones are OP1_TYPE
and OP2_TYPE, but operations such as GET_OP1_ZVAL_PTR() and FREE_OP1() are also specialized.

The handler for ADD specified that it accepts `CONST|TMPVAR|CV` operands. The TMPVAR here means that the opcode accepts
both TMPs and VARs, but asks for these to not be specialized separately. Remember that for most purposes the only
difference between TMP and VAR is that the latter can contain references. For an opcode like ADD (where references are
on the slow-path anyway) having a separate specialization for this is not worthwhile. Some other opcodes that do make
this distinction will use `TMP|VAR` in their operand list.

Next to the operand-type based specialization, handlers can also be specialized on other factors, such as whether their
return value is used. ASSIGN_DIM specializes based on the operand type of the following OP_DATA opcode:

```
ZEND_VM_HANDLER(147, ZEND_ASSIGN_DIM,
    VAR|CV, CONST|TMPVAR|UNUSED|NEXT|CV, SPEC(OP_DATA=CONST|TMP|VAR|CV))

```

Based on this signature, 2*4*4=32 different variants of ASSIGN_DIM will be generated. The specification for the second
operand also contains an entry for `NEXT`. This is not related to specialization, instead it specifies what the meaning
of an UNUSED operand is in this context: it means that this is an append operations (`$arr[]`). Another example:

```
ZEND_VM_HANDLER(23, ZEND_ASSIGN_ADD,
    VAR|UNUSED|THIS|CV, CONST|TMPVAR|UNUSED|NEXT|CV, DIM_OBJ, SPEC(DIM_OBJ))

```

Here we have that the first operand being UNUSED implies an access on `$this`. This is a general convention for object
related opcodes, for example `FETCH_OBJ_R UNUSED, 'prop'` corresponds to `$this->prop`. An UNUSED second operand again
implies an append operation. The third argument here specifies the meaning of the extended_value operand: It contains
a flag that distinguishes between `$a += 1`, `$a[$b] += 1` and `$a->b += 1`. Finally, the `SPEC(DIM_OBJ)` instructs that
a specialized handler should be generated for each of those. (In this case the number of total handlers that will be
generated is non-trivial, because the VM generator knows that certain combination are impossible. For example an UNUSED
op1 is only relevant for the OBJ case, etc.)

Finally, the virtual machine generator supports an additional, more sophisticated specialization mechanism. Towards the
end of the definition file, you will find a number of handlers of this form:

```
ZEND_VM_TYPE_SPEC_HANDLER(
    ZEND_ADD,
    (res_info == MAY_BE_LONG && op1_info == MAY_BE_LONG && op2_info == MAY_BE_LONG),
    ZEND_ADD_LONG_NO_OVERFLOW,
    CONST|TMPVARCV, CONST|TMPVARCV, SPEC(NO_CONST_CONST,COMMUTATIVE)
)

```

These handlers specialize not only based on the VM operand type, but also based on the possible types the operand might
take at runtime. The mechanism by which possible operand types are determined is part of the opcache optimization
infrastructure and quite outside the scope of this article. However, assuming such information is available, it should
be clear that this is a handler for an addition of the form `int + int -> int`. Additionally, the SPEC annotation tells
the specializer that variants for two const operands should not be generated and that the operation is commutative, so
that if we already have a CONST+TMPVARCV specialization, we do not need to generate TMPVARCV+CONST as well.

## Fast-path / slow-path split ##

Many opcode handlers are implemented using a fast-path / slow-path split, where first a few common cases are handled,
before falling back to a generic implementation. It’s about time we looked at some actual code, so I’ll just paste the
entirety of the SL (shift-left) implementation here:

```
ZEND_VM_HANDLER(6, ZEND_SL, CONST|TMPVAR|CV, CONST|TMPVAR|CV)
{
	USE_OPLINE
	zend_free_op free_op1, free_op2;
	zval *op1, *op2;

	op1 = GET_OP1_ZVAL_PTR_UNDEF(BP_VAR_R);
	op2 = GET_OP2_ZVAL_PTR_UNDEF(BP_VAR_R);
	if (EXPECTED(Z_TYPE_INFO_P(op1) == IS_LONG)
			&& EXPECTED(Z_TYPE_INFO_P(op2) == IS_LONG)
			&& EXPECTED((zend_ulong)Z_LVAL_P(op2) < SIZEOF_ZEND_LONG * 8)) {
		ZVAL_LONG(EX_VAR(opline->result.var), Z_LVAL_P(op1) << Z_LVAL_P(op2));
		ZEND_VM_NEXT_OPCODE();
	}

	SAVE_OPLINE();
	if (OP1_TYPE == IS_CV && UNEXPECTED(Z_TYPE_INFO_P(op1) == IS_UNDEF)) {
		op1 = GET_OP1_UNDEF_CV(op1, BP_VAR_R);
	}
	if (OP2_TYPE == IS_CV && UNEXPECTED(Z_TYPE_INFO_P(op2) == IS_UNDEF)) {
		op2 = GET_OP2_UNDEF_CV(op2, BP_VAR_R);
	}
	shift_left_function(EX_VAR(opline->result.var), op1, op2);
	FREE_OP1();
	FREE_OP2();
	ZEND_VM_NEXT_OPCODE_CHECK_EXCEPTION();
}
```

The implementation starts by fetching the operands using `GET_OPn_ZVAL_PTR_UNDEF` in BP_VAR_R mode. The `UNDEF` part
here means that no check for undefined variables is performed in the CV case, instead you’ll just get back an UNDEF
value as-is. Once we have the operands, we check whether both are integers and the shift width is in range, in which
case the result can be directly computed and we advance to the next opcode. Notably, the type check here doesn’t care
whether the operands are UNDEF, so the use of GET_OPn_ZVAL_PTR_UNDEF is justified.

If the operands do not happen to satisfy the fast-path, we fall back to the generic implementation, which starts with
SAVE_OPLINE(). This is our signal for “potentially throwing operations follow”. Before going any further, the case of
undefined variables is handled. GET_OPn_UNDEF_CV will in this case emit an undefined variable notice and return a NULL
value.

Next, the generic shift_left_function is called and writes its result into `EX_VAR(opline->result.var)`. Finally, the
input operands are freed (if necessary) and we advance to the next opcode with an exception check (which means the
opline is reloaded before advancing).

As such, the fast-path here saves two checks for undefined variables, a call to a generic operator function, freeing
of operand, as well as saving and reloading of the opline for exception handling. Most of the performance sensitive
opcodes are lain out in a similar fashion.

## VM macros ##

As can be seen from the previous code listing, the virtual machine implementation makes liberal use of macros. Some of
these are normal C macros, while others are resolved during generation of the virtual machine. In particular, this
includes a number of macros for fetching and freeing instruction operands:

```
OPn_TYPE
OP_DATA_TYPE

GET_OPn_ZVAL_PTR(BP_VAR_*)
GET_OPn_ZVAL_PTR_DEREF(BP_VAR_*)
GET_OPn_ZVAL_PTR_UNDEF(BP_VAR_*)
GET_OPn_ZVAL_PTR_PTR(BP_VAR_*)
GET_OPn_ZVAL_PTR_PTR_UNDEF(BP_VAR_*)
GET_OPn_OBJ_ZVAL_PTR(BP_VAR_*)
GET_OPn_OBJ_ZVAL_PTR_UNDEF(BP_VAR_*)
GET_OPn_OBJ_ZVAL_PTR_DEREF(BP_VAR_*)
GET_OPn_OBJ_ZVAL_PTR_PTR(BP_VAR_*)
GET_OPn_OBJ_ZVAL_PTR_PTR_UNDEF(BP_VAR_*)
GET_OP_DATA_ZVAL_PTR()
GET_OP_DATA_ZVAL_PTR_DEREF()

FREE_OPn()
FREE_OPn_IF_VAR()
FREE_OPn_VAR_PTR()
FREE_UNFETCHED_OPn()
FREE_OP_DATA()
FREE_UNFETCHED_OP_DATA()

```

As you can see, there are quite a few variations here. The `BP_VAR_*` arguments specify the fetch mode and support the
same modes as the FETCH_* instructions (with the exception of FUNC_ARG).

`GET_OPn_ZVAL_PTR()` is the basic operand fetch. It will throw a notice on undefined CV and will not dereference the
operand. `GET_OPn_ZVAL_PTR_UNDEF()` is, as we already learned, a variant that does not check for undefined CVs.
`GET_OPn_ZVAL_PTR_DEREF()` includes a DEREF of the zval. This is part of the specialized GET operation, because
dereferencing is only necessary for CVs and VARs, but not for CONSTs and TMPs. Because this macro needs to distinguish
between TMPs and VARs, it can only be used with `TMP|VAR` specialization (but not `TMPVAR`).

The `GET_OPn_OBJ_ZVAL_PTR*()` variants additionally handle the case of an UNUSED operand. As mentioned before, by
convention `$this` accesses use an UNUSED operand, so the `GET_OPn_OBJ_ZVAL_PTR*()` macros will return a reference to
`EX(This)` for UNUSED ops.

Finally, there are some `PTR_PTR` variants. The naming here is a leftover from PHP 5 times, where this actually used
doubly-indirected zval pointers. These macros are used in write operations and as such only support CV and VAR types
(anything else returns NULL). They differ from normal PTR fetches in that that they de-INDIRECT VAR operands.

The `FREE_OP*()` macros are then used to free the fetched operands. To operate, they require the definition of a
`zend_free_op free_opN` variable, into which the GET operation stores the value to free. The baseline `FREE_OPn()`
operation will free TMPs and VARs, but not free CVs and CONSTs. `FREE_OPn_IF_VAR()` does exactly what it says: free the
operand only if it is a VAR.

The `FREE_OP*_VAR_PTR()` variant is used in conjunction with `PTR_PTR` fetches. It will only free VAR operands and only
if they are not INDIRECTed.

The `FREE_UNFETCHED_OP*()` variants are used in cases where an operand must be freed before it has been fetched with
GET. This typically occurs if an exception is thrown prior to operand fetching.

Apart from these specialized macros, there are also quite a few macros of the more ordinary sort. The VM defines three
macros which control what happens after an opcode handler has run:

```
ZEND_VM_CONTINUE()
ZEND_VM_ENTER()
ZEND_VM_LEAVE()
ZEND_VM_RETURN()

```

CONTINUE will continue executing opcodes as normal, while ENTER and LEAVE are used to enter/leave a nested function
call. The specifics of how these operate depends on precisely how the VM is compiled (e.g., whether global registers are
used, and if so, which). In broad terms, these will synchronize some state from globals before continuing. RETURN is
used to actually exit the main VM loop.

ZEND_VM_CONTINUE() expects that the opline is updated beforehand. Of course, there are more macros related to that:

```
                                        | Continue? | Check exception? | Check interrupt?
ZEND_VM_NEXT_OPCODE()                   |   yes     |       no         |       no
ZEND_VM_NEXT_OPCODE_CHECK_EXCEPTION()   |   yes     |       yes        |       no
ZEND_VM_SET_NEXT_OPCODE(op)             |   no      |       no         |       no
ZEND_VM_SET_OPCODE(op)                  |   no      |       no         |       yes
ZEND_VM_SET_RELATIVE_OPCODE(op, offset) |   no      |       no         |       yes
ZEND_VM_JMP(op)                         |   yes     |       yes        |       yes

```

The table shows whether the macro includes an implicit ZEND_VM_CONTINUE(), whether it will check for exceptions and
whether it will check for VM interrupts.

Next to these, there are also `SAVE_OPLINE()`, `LOAD_OPLINE()` and `HANDLE_EXCEPTION()`. As has been mentioned in the
section on exception handling, SAVE_OPLINE() is used before the first potentially throwing operation in an opcode
handler. If necessary, it writes back the opline used by the VM (which might be in a global register) into the execute
data. LOAD_OPLINE() is the reverse operation, but nowadays it sees little use, because it has effectively been rolled
into ZEND_VM_NEXT_OPCODE_CHECK_EXCEPTION() and ZEND_VM_JMP().

HANDLE_EXCEPTION() is used to return from an opcode handler after you already know that an exception has been thrown. It
performs a combination of LOAD_OPLINE and CONTINUE, which will effectively dispatch to the HANDLE_EXCEPTION opcode.

Of course, there are more macros (there are always more macros…), but this should cover the most important parts.

If you liked this article, you may want to [browse my other articles](http://nikic.github.io/) or
            [follow me on Twitter](https://twitter.com/#!/nikita_ppv).
        
[blog comments powered by Disqus](http://disqus.com)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
