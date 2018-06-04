> * 原视频地址：[James Bennett - A Bit about Bytes: Understanding Python Bytecode - PyCon 2018](https://www.youtube.com/watch?v=cSSpnq362Bk)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-python-bytecode-pycon-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-python-bytecode-pycon-2018.md)
> * 译者：
> * 校对者：

# James Bennett - A Bit about Bytes: Understanding Python Bytecode - PyCon 2018

> 本文为 PyCon 2018 视频之 James Bennett - A Bit about Bytes: Understanding Python Bytecode 的中文字幕，您可以搭配原视频食用。

0:07  all right hi welcome to a bit about

0:11  bytes about looking a Python byte code

0:14  so in addition to being a clever play on

0:17  words would be some useful information

0:20  so without much further ado we have

0:22  James Bennett Django core developer so

0:25  let's get the talk underway hi so I want

0:36  to start with a sort of an existential

0:38  question why are we here

0:41  at PyCon we're here because we love

0:45  Python right right and why do we love

0:52  Python we love Python because we all

0:55  understand this great truth of

0:57  programming did we read code much more

1:00  often than we write it and so we should

1:03  write our code to be as readable as we

1:05  can make it and of course we love Python

1:08  because we don't even built around that

1:12  simple idea that code should be easy to

1:15  read and that language is Python clear

1:19  easy to read understandable Python even

1:24  people who aren't necessarily

1:25  programmers can at least be a look at

1:28  some Python and follow the logic of

1:30  what's going on right okay so this

1:36  actually is Python or at least this is

1:39  how Python works if you go download

1:41  Python from Python org you know we call

1:44  the C Python distribution this is how it

1:47  executes your code we're going to learn

1:50  about where this comes from how this

1:53  works what sorts of useful things we can

1:56  learn from understanding it and how we

1:59  can apply that you know both practically

2:01  and in a sort of theoretical sense but

2:05  before we do that we need to understand

2:07  a little bit about how computers work

2:08  and we need to understand a little bit

2:10  how programming languages

2:12  work now I love this because it is

2:14  beautiful and it is true but we do need

2:19  to understand how a computer actually

2:21  works deep down inside you have your CPU

2:24  your processor it's a little wafer of

2:26  silicon and inscribed on it are these

2:29  electrical circuits and they're set up

2:32  so if I send a certain pattern

2:33  electricity in I get another different

2:35  pattern of electricity out it's very

2:37  predictable and we give names and

2:40  meanings to these patterns we treat them

2:42  as if they do mean something so we say

2:45  this pattern of electricity actually

2:46  means add two numbers together that's

2:49  how your computer actually works

2:51  those names we give to them we call them

2:53  instructions for the CPU sometimes you

2:56  hear them called machine code for the

2:58  CPU if we show it in a slightly more

3:00  human readable format you'll sometimes

3:01  hear called assembly but it's not all

3:05  that friendly to humans to look at this

3:08  stuff anybody ever looked at assembly

3:11  how many of you would like to write like

3:13  that all the time so you want to write

3:19  source code which is the beautiful clear

3:22  easy to read easy to understand human

3:24  friendly version but your computer wants

3:26  these binary instructions so how are we

3:29  gonna get from one to the other there

3:33  are some options there are some

3:34  different ideas that have been tried

3:35  over the years some languages you're

3:37  going to run a program called a compiler

3:39  courtesy of Rear Admiral Grace Hopper

3:41  which will take your source code and

3:43  transform it directly into those machine

3:45  code instructions we call those compiled

3:47  languages some languages you just invoke

3:51  the language itself with your program it

3:53  runs your program directly translating

3:55  source code into machine code as it goes

3:57  we call that an interpreted language

3:59  people often say pythons an interpreted

4:02  language we talk about a Python

4:03  interpreter but there's actually a third

4:06  way some languages compiled to a set of

4:10  instructions that's not for any real

4:12  physical CPU that exists I mean I

4:16  suppose you could go build one but it

4:18  doesn't exist right now these languages

4:20  compile to instructions for the CPU that

4:22  doesn't exist and then the interpreter

4:25  is a piece of software that implements

4:28  that CPU that understands those

4:30  instructions and how to translate them

4:32  into the specific instructions for

4:34  whatever actual processor you're running

4:36  it on we call that byte code there are a

4:39  lot of languages that do this anybody

4:41  ever use Java Java compiler bytecode

4:45  you've run it on the Java Virtual

4:47  Machine anybody ever use one of the

4:48  dotnet languages c-sharp c-sharp

4:51  compiles to bytecode runs on the.net vm

4:55  and python python compiles to bytecode

4:58  which runs on the Python virtual machine

5:02  so let's take a look at how this works

5:04  we're gonna look at Python function this

5:08  calculates two Bonacci numbers so this

5:11  should be pretty easy to understand

5:13  we've got you know a little if we're

5:15  less than two return otherwise loop

5:18  figuring out what the next two Bonacci

5:20  number is eventually return it how will

5:23  Python actually execute this function

5:25  well is anybody we're seeing a file with

5:29  an extension dot py c especially if you

5:33  use Python to python to use to drop

5:35  these directly next to your source code

5:37  in the same directory python 3 we have a

5:40  directory called pi cache with double

5:42  underscores that's where your py c files

5:44  go you may have heard these described as

5:47  you know compiled Python or some sort of

5:50  you know time saver for when you rerun

5:52  it again that is python bytecode that's

5:55  what's in that file it's actually the

5:56  binary bytecode that python compiled

5:59  your source code into so next time you

6:01  run that or next time you import that

6:03  module Python doesn't have to compile it

6:06  all over again but that's the actual

6:08  form that Python wants that code in in

6:10  order to be able to execute it so how

6:13  could we get at this and understand

6:15  what's going on well suppose you typed

6:17  in that Fibonacci function into a Python

6:20  interpreter and you looked at it it's a

6:22  function object and it would have this

6:25  little attribute on it double underscore

6:27  code this is a Python code object

6:32  did nobody go to Emily Morehouse's talk

6:34  yesterday about parsing and the ast

6:36  there's really good talk and you

6:38  learned a little bit about code objects

6:40  and how Python uses them we're gonna

6:42  look at some slightly different

6:43  attributes than what Emily was talking

6:45  about because we're looking at the other

6:46  side of this is what happens after the

6:48  parsing so this code object this

6:51  contains everything Python needs to

6:52  execute the function and it has

6:54  attributes we can poke at to see how

6:56  it's going to do that so one interesting

6:59  attribute is called Co Const this is a

7:02  tuple it contains all of the literal or

7:04  constant values that were referenced in

7:06  the body of our function so we see our

7:09  integers you ate a 2 in there we had a 0

7:11  we had a 1 we had a tuple of a 0 and a 1

7:13  and we have none now none is kind of

7:17  weird to see there because the body of

7:20  that function didn't include a literal

7:22  none anywhere the Python put it in there

7:24  anyway

7:25  there's a reason for that which is if

7:28  Python is executing our function and it

7:31  finishes executing without reaching any

7:33  explicit return statement it's going to

7:36  return none so Python needs to have none

7:40  already loaded up already ready to go in

7:43  that tuple so it can reference it

7:45  because the time Python is compiling

7:47  this it has no way of knowing whether

7:48  any explicit return statement is ever

7:51  going to be reached in fact that's a

7:52  really hard / impossible thing to do in

7:55  advance so these are our literals

7:59  there's another one called Co VAR names

8:01  this is a tuple containing the names of

8:04  all the local variables of the function

8:06  we had 3 of those and current.next so

8:09  they're all in there then we have this

8:12  one called Co names this would be any

8:15  non-local names that we referenced in

8:17  the body of the function now the

8:18  Fibonacci function didn't include any

8:20  non-local names so this is an empty

8:22  tuple and finally we're gonna get to the

8:25  fun part Co code this is the bytecode of

8:30  the Fibonacci function this is not a

8:33  string this is a Python bites object

8:36  because this is being done in Python 3

8:38  like it should be some of these

8:42  characters do print or some of these

8:44  bytes do print as ASCII characters

8:46  that's just because that's how Python

8:47  defaults to representing a bytes object

8:49  but it's not a string we can't treat it

8:51  a string it's a sequence of bytes now

8:55  suppose we want to understand what's

8:57  going on in this big long sequence of

9:00  bytes well we can look at it that first

9:02  byte printed as a pipe character now I

9:06  don't know about any of you I have not

9:08  memorized an ASCII table so I don't

9:10  actually know what decimal byte value

9:13  produces a pipe character in ascii

9:15  fortunately I can ask Python and it will

9:18  tell me Python will tell me the pipe

9:21  character is decimal value 1 2 4 so the

9:24  first byte of that byte code was a byte

9:26  with value 1 2 4 that still doesn't tell

9:30  me very much luckily there's a module in

9:33  the standard library called disk with

9:36  this list in it called up name it's a

9:38  list of all the Python bytecode

9:39  instructions and at each index is the

9:42  instruction name that goes with that

9:44  decimal value so what's the hundred and

9:46  twenty fourth bytecode operation it's

9:48  called load fast ok so now we know the

9:52  first byte of this is a decimal one to

9:54  four that's a load fast instruction the

9:57  next byte of it was a zero so it's a

10:00  load fast zero I don't know how much

10:02  attention you paid to that first slide

10:05  but that's what it started with load

10:08  fast zero that's a Python bytecode

10:12  instruction and specifically what this

10:15  means is look up in that sea of our

10:18  names tuple whatever item is at index

10:21  zero which is local variable n push that

10:26  on top of the evaluation stack we're

10:29  gonna get to what the evaluation stack

10:31  is in just a minute but first I'm gonna

10:33  show you the shortcut I showed you the

10:35  hard laborious way to read byte code

10:38  here's the easy way use the disk module

10:41  import disks call the function disk disk

10:44  you can pass in almost anything you want

10:47  to here and passing in a function you

10:48  can pass in strings of source code you

10:50  can pass in all sorts of Python objects

10:52  and this will disassemble them print a

10:56  human readable version of the byte code

10:58  that they compile into and what you'll

11:00  get out of that from that Fibonacci

11:02  function is the contents of that first

11:05  Lyde this is the bytecode of that

11:08  Fibonacci function there's a couple

11:11  things that are worth knowing here this

11:12  output you'll see over on the left

11:14  you'll see these numbers two three four

11:17  five six seven eight

11:18  those are the line numbers in the source

11:20  code that's where each lines

11:22  instructions are beginning you'll notice

11:25  each line of Python source code turned

11:27  into multiple bytecode instructions and

11:30  then each instruction has a number next

11:32  to it as well and they're always even

11:34  does anybody want to guess why that is

11:38  this is a nuez of python 3.6 those

11:41  numbers are the offsets into the byte

11:44  code if you grabbed that bytes object Co

11:46  code on that code object and indexed

11:49  into it say go to index 6 you would find

11:53  a pop jump if false up code there the

11:57  reason that those are even numbers is as

11:59  of Python 3.6 not every byte code

12:02  instruction actually uses an argument

12:04  but as of Python 3.6 they all get an

12:07  argument whether they want one or not

12:08  because that makes every one of these

12:10  exactly two bytes which makes it much

12:14  easier to work with there are some

12:16  instructions that if their argument gets

12:19  too large to fit in a byte can actually

12:21  split over multiple bytes but it's

12:22  always a multiple of two bytes if you're

12:24  looking at python 3.5 or earlier and you

12:28  put in this same function you might see

12:29  some odd-numbered offsets because not

12:31  everything actually got an argument in

12:33  python 3.5 one other thing worth noting

12:37  here is we see some rate pointing angle

12:40  brackets we see them like line four

12:42  offset 12 at that load Const

12:44  line five offset 22

12:47  those are jump targets this is Python

12:50  telling you these are instructions that

12:53  may be jumped to by some other

12:55  instruction that's going on here so you

12:57  remember that Fibonacci function had a

12:59  loop in it with the test at the

13:01  beginning every time we go to the

13:04  beginning of the loop we're doing a jump

13:06  back to an earlier instruction those

13:08  angle brackets are just there to tell

13:10  you these are potential jump targets of

13:12  other

13:12  instructions so now we've seen some byte

13:17  code we understand how we can actually

13:19  get at the raw byte code as bytes how we

13:22  could decipher it manual if we wanted to

13:24  and now we know the easy shortcut we got

13:26  actually talked about how Python works

13:29  how it uses byte code so pythons VM the

13:33  virtual machine in C Python is stack

13:35  oriented it's built around the stack as

13:38  a fundamental data structure if you've

13:40  never worked with stacks they're sort of

13:43  list like but they support two very

13:45  important operations a stack has has two

13:48  ends which we'll call a top and a bottom

13:49  you have a push operation which means

13:52  take this value put it on top and a pop

13:55  operation which means take whatever is

13:57  on top remove it return it each time you

14:01  call a function in Python you're pushing

14:04  a new entry a call frame on to a call

14:07  stack that keeps track of every function

14:09  being executed when one of those

14:11  functions returns that call frame gets

14:14  popped right back off the stack the

14:17  return value gets pushed into the

14:18  calling frame so you know if somebody

14:21  calls bar Fibonacci function as we'll

14:23  see in a minute we get that return value

14:24  back now while you're executing this in

14:28  that call frame in the call stack we're

14:31  gonna use two more stacks one is an

14:34  evaluation stack sometimes you also see

14:36  called

14:36  a data stack this is where Python is

14:40  going to keep all of the data it's

14:41  actually working with this is where most

14:43  of the execution happens inside a Python

14:46  function most of the instructions are

14:49  about manipulating what's on top of that

14:50  evaluation stack there's also a second

14:53  one called a block stack a block stack

14:55  keeps track of how many different blocks

14:57  are active right now blocks are things

15:00  like a try except with block you know

15:03  anything like that

15:04  Python needs that because there are some

15:06  statements like break and continue that

15:09  affect whatever the current block is so

15:11  Python needs to know what is the current

15:13  block and it does that by simply

15:15  managing a stack like every time you go

15:17  into certain constructs like this it

15:19  pushes a new item on the block stack

15:21  when it finishes pops that item back off

15:24  so let's look at how we execute a

15:27  function suppose we want to know the

15:29  eighth Fibonacci number we're just going

15:31  to ask Python to calculate that using

15:33  our Fibonacci function that turns into

15:35  three bytecode instructions load global

15:39  load Const call function so let's take a

15:42  look at what's going on here we start

15:44  this we've got an empty evaluation stack

15:46  so we get to our first instruction load

15:48  global we're going to load the global

15:52  name fib which is our Fibonacci function

15:54  this is what's gonna go look in that Co

15:57  names tuple that tuple of non local

15:59  names it's going to look up that

16:01  function push the function object on top

16:04  of our evaluation stack next we're gonna

16:06  have a load Const in this case it's

16:09  going to get the first item out of our

16:10  tuple of constants because remember Ida

16:12  index zero is none so the first item in

16:15  there at index one is the integer eight

16:17  which is gonna be the argument to our

16:19  function push that on to the stack then

16:22  we hit a call function instruction has

16:26  an argument of one the way Python is

16:29  calling this function we're only using

16:31  positional arguments is it pushes the

16:34  function onto the stack pushes the

16:36  positional arguments on top of it then

16:39  call function the argument is the number

16:42  of positional arguments to the function

16:43  it pops all those off it knows the

16:46  function is the next thing there pops

16:48  that off pushes a new stack onto the

16:51  call frame or onto the call stack

16:54  execute our Fibonacci function inside

16:56  that new frame gets a return value of 21

17:00  pops the call stack get that frame off

17:03  return value goes on to the top of our

17:06  evaluation stack right here where we

17:08  called the Fibonacci function and that

17:10  is step by step how python is going to

17:12  execute this function now the call

17:14  function instruction is only for

17:16  function calls that involve positional

17:18  arguments if you used keyword arguments

17:20  there's a different instruction called

17:22  call function kW if you use any of the

17:26  iterator or mapping unpacking syntax the

17:30  asterisk double Asterix and syntax in

17:33  your function call there's one called

17:34  call function e^x

17:36  that gets used to do that so that's how

17:39  we're executing a function now if you

17:42  want to you can go dig into the Python

17:45  standard library documentation the dis

17:47  module is extremely handy it has a list

17:50  of all of the things in the module all

17:53  of the bytecode instructions what they

17:55  do what kind of arguments they take

17:58  anything you could want to know about

18:00  how Python bytecode works is all in

18:03  there there are a couple things I want

18:05  to point out though they're kind of cool

18:07  one is another function that's in that

18:09  module it's called disty be how many

18:12  times have you looked at an exception

18:15  and wondered where the heck did that

18:17  come from

18:18  what made that happen well this function

18:21  disk dot dis TB you can call it either

18:25  right after an exception has occurred or

18:27  if you have a python trace back object

18:29  that you've captured somehow you can

18:31  pass it in and what it will do is

18:33  disassemble whatever call frame on the

18:36  call stack was active at the time show

18:39  you the byte code that was being

18:41  executed and give you a pointer

18:43  specifically to the instruction where

18:46  that exception got raised so for example

18:48  here you can see I divided by 0 whoops

18:51  Python raised an exception import dis

18:54  dis TB and here I can see exactly what

18:57  happened if you really want to

19:00  understand what's going on I'm gonna

19:02  have a link at the very end to where you

19:04  can go look at the actual internals of

19:07  the Python interpreter which are written

19:08  in C this is the beginning of the actual

19:11  real honest-to-goodness Python bytecode

19:14  interpreter as it existed on github

19:16  about two hours ago it is a gigantic

19:19  switch statement that simply looks at

19:22  whatever decimal value instruction was

19:25  passed into it and figures out what to

19:27  do with that so now we know some things

19:31  about bytecode but what can we learn

19:34  from this what use is it what good is it

19:37  to us to know about bytecode has anybody

19:40  here ever written any forth or if your

19:46  little newer maybe played with a

19:48  language like factor

19:50  or heard of languages like forth and

19:52  factor these are what are called stack

19:54  oriented programming languages Python

19:57  virtual machine is also stack oriented

19:59  we saw this it all Orient's around

20:01  pushing things on top of a stack

20:03  manipulating the top of the stack

20:05  popping things back off this is a very

20:08  different way of doing programming than

20:09  what we're used to but there have been

20:11  entire languages built around it and

20:13  understanding this way of programming is

20:15  actually kind of cool you may never even

20:18  get any practical use out of it but it's

20:20  a thing you can learn and it's a thing

20:22  will broaden your understanding of

20:24  different styles of programming in

20:25  different ways you can do programming

20:27  and it really is amazing if you look at

20:30  a stack oriented language or a stack

20:32  oriented virtual machine to see just how

20:34  much you can do with so few instructions

20:37  and so few basic operations on a stack

20:39  it's actually really really neat of

20:42  course there are also some practical

20:44  purposes people like to joke about see

20:46  they like to call see a sort of portable

20:49  assembler or portable assembly language

20:51  because you can write C and read C and

20:54  reason pretty well about what kind of

20:57  machine code a given bit of C is going

20:59  to turn into Python is sort of the same

21:03  way we can learn Python bytecode and

21:05  learn how to understand it and then we

21:07  can reason about what kind of bytecode

21:10  is Python going to turn my source code

21:11  into how is this actually going to

21:14  execute when I hand it off to the Python

21:16  interpreter studying that can give you

21:19  some insights also you can learn a bit

21:22  about how Python works and how Python

21:24  can help you and then of course what

21:26  everybody wants to know is how you can

21:28  look at it and reason about performance

21:30  so here's a couple of functions both of

21:33  these do the same thing they both

21:35  calculate the number of seconds in a

21:37  week except one of them is faster than

21:40  the other can you guess which one it is

21:42  I very cleverly hidden it I want you to

21:46  stop and think why would one of these

21:49  functions be faster than the other and

21:52  how could we figure out why that is and

21:55  the answer is we can look at the byte

21:56  code we can ask the Dismal to

21:59  disassemble these for us there's a big

22:02  difference in what those turn

22:04  into you notice that first one stored

22:07  the number of seconds in a day in a

22:09  variable which meant we had to load a

22:12  constant Stewart in a variable then look

22:15  up what was stored in a variable load

22:17  another constant do a multiplication and

22:19  finally return the value the second one

22:22  only used multiplication with two

22:24  integer constants and Python when it was

22:27  compiling this noticed we're using

22:30  arithmetic on to editor constants

22:32  they're not going to change the values

22:35  of seven and 86,400 are not going to

22:38  change anytime soon so python can just

22:41  optimize that away python can do that

22:43  multiplication at compile time and now

22:45  this function is just returned 600 4800

22:49  there's nothing else to it so it's kind

22:51  of a cool optimization Python will do

22:53  that sort of constant folding anytime

22:55  you have these operations on constants

22:57  that it can optimize a way it isn't the

23:00  only sneaky offer sneaky optimization

23:03  Python does has anybody heard about

23:05  specter and meltdown anybody familiar

23:08  with those these were attacks against

23:11  branch prediction where processors try

23:14  to predict what's gonna happen on the

23:16  other end of an if statement Python

23:18  actually tries to predict what bytecode

23:20  operations will happen some byte code

23:22  operations come in pairs like a

23:24  comparison is usually followed by a jump

23:27  instruction of some type and the Python

23:29  bytecode interpreter optimizes this and

23:31  tries to predict what's going to come

23:33  next in order to work with your CPUs

23:35  branch predictor to make these run even

23:37  faster so there are some cool things

23:39  going on here you can also answer some

23:41  perennial questions about Python

23:44  performance people always ask things

23:46  like why is a literal list or a literal

23:48  dictionary faster than calling lists or

23:51  dict well right there's your answer we

23:55  just do a literal dict using that brief

23:57  syntax that's two instructions we

24:00:00  actually call the Dix function that's

24:02:00  three instructions and one of them is a

24:04:00  call instruction so we actually have to

24:06:00  push another frame on the call stack

24:07:00  execute a function body in there pop it

24:10:00  back off you can see this in your own

24:12:00  code here's a simple example this is

24:15:00  just a function that calculates the

24:17:00  first

24:17:00  perfect squares and this isn't the whole

24:20:00  bytecode this is just the body of that

24:22:00  loop that while loop 15 bytecode

24:25:00  instructions long we do better than that

24:28:00  what if we change that while loop with a

24:30:00  counter to a four loop with a range well

24:34:00  suddenly it's a much shorter loop body

24:36:00  now it's nine instructions what if we go

24:39:00  really idiomatic Python and say this

24:42:00  really ought to be a list comprehension

24:43:00  what's that gonna turn into now the

24:47:00  whole function body is nine instructions

24:48:00  long but this is deceptive this is why I

24:54:00  put this up here notice it's nine

24:57:00  instructions but it involves building a

25:00:00  function and calling a function so it

25:02:00  has to push another frame onto the call

25:03:00  stack execute another function body in

25:05:00  there pop it back off return a value

25:08:00  that's a slightly more expensive

25:10:00  operation even though this is fewer

25:13:00  bytecode instructions not all bytecode

25:15:00  instructions are equally expensive to

25:18:00  execute so this is where we start

25:21:00  talking about comparing different

25:23:00  bytecode at different bytecode

25:24:00  operations and people always want to

25:26:00  know about these micro optimizations the

25:28:00  very first thing I want to tell you is

25:30:00  Python is slow if you're worrying about

25:32:00  how fast a Python bytecode operation is

25:35:00  you're probably missing the forest for

25:37:00  the trees because python is so much

25:39:00  slower than C that it's not even worth

25:42:00  worrying about that kind of micro

25:43:00  optimization if you want to learn how to

25:46:00  write really fast Python really blazing

25:49:00  great performance Python the first thing

25:52:00  you should do is take a good look

25:54:00  through the standard library standard

25:56:00  modules built-in functions and classes

25:58:00  find out which of them are implemented

26:01:00  in C versus which ones are implemented

26:03:00  in Python because the speed difference

26:05:00  there like some of these bytecode

26:07:00  instructions you might gain you know

26:09:00  this much

26:10:00  whereas getting it in C you're gonna

26:12:00  gain this much it's just no contest but

26:16:00  you probably want some general

26:18:00  guidelines so here are a few you ever

26:22:00  seen a Python optimization guide that

26:24:00  says don't refer to names inside a loop

26:27:00  always alias it to something and then

26:30:00  the alias inside the loop this is why

26:32:00  not all load operations are equal load

26:35:00  constant load fast are very fast load

26:38:00  name load global are comparatively quite

26:40:00  slow going into the details of why it's

26:43:00  because the lookups for non local names

26:45:00  can be fairly complex it may have to

26:47:00  search in multiple namespaces before it

26:49:00  finally finds what it's looking for if

26:52:00  you go look at the actual interpreter

26:53:00  implementation you can see the

26:56:00  implementations of these instructions

26:57:00  are pretty large another thing loops and

27:01:00  blocks are really expensive avoid them

27:03:00  if you can you'll see these instructions

27:06:00  sort of jump out at you set up loop set

27:08:00  up with set up exception anytime you

27:10:00  enter or exit a loop or a block or

27:13:00  anything like that you need multiple

27:15:00  instructions to get into the loop set up

27:18:00  all the context push on to the block

27:19:00  stack execute the body of the loop jump

27:22:00  back if you're if you're doing the loop

27:24:00  the jumps back then finally pop

27:26:00  everything back off and clean up that's

27:27:00  an expensive operation avoid that one if

27:30:00  you can attribute accesses dictionary

27:34:00  lookups list indexing all of these

27:36:00  things really stick out in byte code

27:38:00  these load ad or binary subscript C

27:42:00  people say if you need something out of

27:44:00  a dictionary or something out of a list

27:45:00  and you're gonna loop and you're gonna

27:47:00  refer to it every time through the loop

27:49:00  alias it to a local variable before you

27:51:00  do that because otherwise you're doing

27:53:00  this expensive look up every single time

27:55:00  through the loop these are relatively

27:57:00  expensive bytecode instructions a lot

28:01:00  more of this you can learn by sort of

28:03:00  looking through the documentation for

28:05:00  the disk module look at all these

28:06:00  different operations and what they do

28:08:00  there are also some good resources I'm

28:10:00  gonna recommend three here one is

28:13:00  there's a free online book called inside

28:15:00  the Python virtual machine you can read

28:18:00  it at no charge you can also pay some

28:20:00  money to the author to thank him for

28:21:00  writing it this is a complete tour of

28:24:00  how Python works inside the Python

28:27:00  interpreter

28:28:00  all of the internal mechanics all of

28:31:00  those stacks all of the bytecode

28:32:00  operations the whole thing Allyson

28:36:00  Kaptur has written a Python interpreter

28:38:00  in Python

28:39:00  she walks you through and by the way she

28:40:00  gave a great talk here at PyCon

28:43:00  she walks you through how to build a

28:46:00  Python bytecode interpreter with all the

28:48:00  correct data structures and handling all

28:50:00  of the byte code operations in Python

28:52:00  itself and then finally of course you

28:55:00  can read the bytecode interpreter which

28:57:00  is that gigantic switch statement that I

28:59:00  showed you part of earlier that switch

29:00:00  statement I think is around a thousand

29:02:00  lines long or at least it was in one

29:04:00  version that I looked at it is

29:05:00  definitely hundreds of lines long but

29:08:00  you can actually read through it it's

29:09:00  fairly clear fairly well written C pipe

29:11:00  C Python source code tends to be on the

29:13:00  readable side as C goes so all of those

29:18:00  are really good resources also if you

29:21:00  want to I am on Twitter I will be

29:24:00  heading out of here I can take maybe one

29:27:00  or two questions in the hallway

29:28:00  afterward and you can find me online and

29:32:00  follow up so thank you all for showing

29:36:00  up hopefully you learn something

29:42:00  you

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
