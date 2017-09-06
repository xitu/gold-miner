 
> * 原文地址：[How to write high-performance code in Golang using Go-Routines](https://medium.com/@vigneshsk/how-to-write-high-performance-code-in-golang-using-go-routines-227edf979c3c)
> * 原文作者：[Vignesh Sk](https://medium.com/@vigneshsk?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-write-high-performance-code-in-golang-using-go-routines.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-write-high-performance-code-in-golang-using-go-routines.md)
> * 译者：
> * 校对者：

# How to write high-performance code in Golang using Go-Routines

![](https://cdn-images-1.medium.com/max/800/1*jdAaUNHvhS0n1FjS2RUxgw.jpeg)

In order to write fast code in Golang, you need to check out this video by Rob Pike on [Go-Routines](https://www.youtube.com/watch?v=f6kdp27TYZs).

He is one of Golang’s creators. And if you haven’t seen it yet, keep reading, since this blog is my own take on the contents of that video. I don’t feel the video is complete. I guess Rob omitted some of the topics he felt were too trivial to deserve a mention in his time constrained video. But I, on the other hand with time at my disposal have written a comprehensive blog about go-routines. I have not covered all of the topics covered in the video. And I have included code from my own projects I use to solve common problems in Golang.

So, There are 3 concepts you need to absolutely understand, in order to write fast code in Golang. They are Go-Routines, Closures & Channels.

## Go-Routines

Let’s say your task is to move 100 boxes from one room to another. Let’s also say, you can carry only one box at a time and you will take 1 min to move one box. So, you will end up taking 100 mins to move 100 boxes.

Now, to speed up the process of moving 100 boxes, you can either figure out a way to move one box faster (which is analogous to finding a better algorithm to solve the problem) or you can hire an additional person to help you with moving boxes (which is analogous to increasing the number of CPU cores used to execute your algorithm).

The focus of this blog is the second approach. Writing go-routines and utilizing 1 or more CPU cores to speed up the execution of your application.

Any block of code is executed only by a single core by default unless that block of code has go-routines declared in it. So, if you have a program that is 70 lines long without go-routines. It will be taken up for execution only by a single core. And like our example, a single core can execute only one instruction at a time. So, you would need to use all the cores available in your system in order to speed up your application.

## So, What is a go-routine and How do we declare one in Golang ?

Let’s take a sample program and introduce go-routines in it.

### Sample Program 1

Let’s say moving a box is analogous to printing a line. So, in our sample program we have 10 print statements (since for loops are not being used, we are moving only 10 boxes).

```
package main
import "fmt"
func main() {
 fmt.Println("Box 1")
 fmt.Println("Box 2")
 fmt.Println("Box 3")
 fmt.Println("Box 4")
 fmt.Println("Box 5")
 fmt.Println("Box 6")
 fmt.Println("Box 7")
 fmt.Println("Box 8")
 fmt.Println("Box 9")
 fmt.Println("Box 10")
}
```

Since go-routines are not declared, the above code produces the following output.

### Output

```
Box 1
Box 2
Box 3
Box 4
Box 5
Box 6
Box 7
Box 8
Box 9
Box 10
```

So, if we want to use an additional core in moving our boxes, we declare a go-routine.

### Sample Program 2 with Go-Routines

```
package main
import "fmt"
func main() {
 go func() {
  fmt.Println("Box 1")
  fmt.Println("Box 2")
  fmt.Println("Box 3")
 }()
 fmt.Println("Box 4")
 fmt.Println("Box 5")
 fmt.Println("Box 6")
 fmt.Println("Box 7")
 fmt.Println("Box 8")
 fmt.Println("Box 9")
 fmt.Println("Box 10")
}
```

Here, a go-routine has been declared for the first 3 statements. Meaning whatever core has taken up the execution of the main method, will execute only statements 4–10. And a different core assigned to statements 1–3 will take up the responsibility of executing that block.

### Output

```
Box 4
Box 5
Box 6
Box 1
Box 7
Box 8
Box 2
Box 9
Box 3
Box 10
```

## Analysing the output

Whats happening here is, there are 2 cores running at the same time, trying to execute it’s tasks and both cores depend on stdout to accomplish it’s respective tasks (since we have used print statements in our example).
stdout (running on a single core of it’s own) on the other hand can accept only one task at a time. So, what you are seeing here is, the random order in which stdout decided to accept tasks from both core1 and core2.

## How we declared the go-routine?

There are 3 things we are doing here in order to declare our go-routine.

1. We are creating an anonymous function
2. We are calling the anonymous function
3. And we are calling it using “go” keyword

So, step 1 is accomplished by taking the syntax to define a function and omitting the name of the function in that syntax (anonymous).

```
func() {
  fmt.Println("Box 1")
  fmt.Println("Box 2")
  fmt.Println("Box 3")
}
```

Step 2 is accomplished by appending empty parenthesis to our anonymous function. The way one would call named functions.

```
func() {
  fmt.Println("Box 1")
  fmt.Println("Box 2")
  fmt.Println("Box 3")
} ()
```

And step 3 is accomplished by prepending it with the go keyword. What a go keyword does is, it declares a function block as an independently runnable block of code. Thus, letting it be taken up by any other free/idle core available in your system.

> #Trivia 1: What happens when there are more go-routines than there are cores?
>
> A single core achieves the illusion of several cores by executing several go-routines in parallel through context switching.
>
> #TryItYourself 1: Try removing go keyword from sample program 2 . What’s the output?
>
> Answer: Sample program 2 gives the same output as Sample program 1
>
> #TryItYourself 2: Try adding 8 statements to the anonymous function instead of 3. Does the output change?
>
> Answer: Yes. The main function is the mother go-routine (It’s the go-routine in which all go-routines are declared or created). So, when the mother go-routine completes execution, all other go-routines are killed even if they are midway to completion and the program returns.

We have seen what go-routines are now. Let’s move onto **Closures**.

For those of you who don’t know what closures are from python or Javascript, you can learn it now in Golang here. Others can save time by skipping this part as closures in Golang are just the same as they are in python or javascript.

Before we dive into closures. Let’s look at languages like C, C++ and Java where closure property is not supported. In these languages,

1. Functions have access to only two types of variables, variables declared in the global scope and variables declared in the local scope (body of the function).
2. No function gets access to variables declared in other functions.
3. And all variables declared inside a function cease to exist once it’s execution gets completed.

None of the above hold true in the case of languages like Golang, python & javascript where closure property is supported. The reason being, these languages allow the following flexibilities.

1. Functions can be declared inside functions.
2. And Functions can return functions.

> Extrapolation of #1: As functions can be declared inside functions, A nested chain of functions where each function is declared within the other is a commonly seen byproduct of this flexibility.

To understand why these 2 flexibilities completely change the game, let’s see what a closure is.

## So what is closure?

On top of getting access to local variables and global variables, functions get access to all local variables declared in functions enclosing it’s definition provided they are declared before (including all arguments passed to the enclosing function at runtime). And in the case of nesting, functions get access to variables of all functions enclosing it’s definition (irrespective of the level of enclosure).

To understand it better, let’s consider a simple scenario where there are only 2 functions one enclosing the other. We can bother about nesting after that.

```
package main
import "fmt"
var zero int = 0
func main() {
   var one int = 1
   child := func() {
       var two int = 3
       fmt.Println(zero)
       fmt.Println(one)
       fmt.Println(two) 
       fmt.Println(three)   // causes compilation Error
   }
   child()
   var three int = 2
}
```

There are 2 functions here — main and child, where child is defined inside main. Child gets access to

1. zero — since it’s global variable
2. one — closure property — one belongs to enclosing function and it’s declaration precedes child’s definition in the enclosing function.
3. two — since it’s local variable

> Note: It doesn’t get access to three —although declared in enclosing function “main” since it’s declaration doesn’t precede child’s definition.

Now the same with nesting.

```
package main
import "fmt"
var global func()
func closure() {
 var A int = 1
 func() {
  var B int = 2
  func() {
   var C int = 3
   global = func() {
    fmt.Println(A, B, C)
    fmt.Println(D, E, F) // causes compilation error
   }
   var D int = 4
  }()
  var E int = 5
 }()
 var F int = 6
}
func main() {
 closure()
 global()
}
```

If we consider the innermost function assigned to “global” declared above in the global scope.

1. It has access to A,B,C since the layer of enclosure does not matter.
2. It doesn’t have access to D,E,F since their declaration don’t precede.

> Note: Even after execution of “closure” function, it’s local variables were not destroyed. They were accessible in the call to “global” function.

Moving on to **Channels**.

Channels are the resources go-routines use to communicate with each other. And they can be of any type.

```
ch := make(chan string)
```

We have declared a string channel here called ch. Only strings can be communicated via this channel.

```
ch <- "Hi"
```

This is how you send messages into the channel.

```
msg := <- ch
```

And this is how you receive messages from a channel.

All operations (sending & receiving) on a channel are blocking in nature. Meaning if a go-routine is attempting to send a message through a channel, the send operation succeeds only if there exists another go-routine trying to receive a message from that channel. If no go-routines are waiting on the channel, the sender go-routine waits indefinitely trying to send the message to someone.

The important point to note here is, all statements following the channel operation in the go-routine don’t get executed. Once the channel operation completes, the go-routine can unblock itself and continue executing statements following the channel operation. This helps to synchronize the various go-routines which are otherwise independently executing blocks of code.

> Disclaimer: If no other go-routine is present except for the sender go-routine. A deadlock occurs and the go program crashes as a result of identifying the deadlock.
>
> Note: All of the above applies to receiver go-routines as well.

## Buffered Channels

```
ch := make(chan string, 100)
```

Buffered channels are channels that are semi-blocking in nature.

For example, ch is a buffered string channel, where the buffer length is 100. What this means, is any send operation on the channel is non-blocking for the first 100 messages. And it becomes blocking for any message after that.

Usefulness of this type of channels comes from the fact that receiving messages from the channel frees up the buffer again, meaning, if 100 new go-routines spring up suddenly each consuming a message from the channel, then the next 100 messages from the sender go-routine becomes non-blocking again.

So, a buffered channel behaves as a blocking channel as well as a non-blocking channel depending upon whether the buffer is free or not at runtime.
Closing Channels

## Closing Channels

```
close(ch)
```

This is how you close a channel. It helps save deadlock situations in Golang. Receiver go-routine can detect if a channel has been closed or not as shown below.

```
msg, ok := <- ch
if !ok {
  fmt.Println("Channel closed")
}
```

## Writing fast code in Golang

Now that concepts like go-routines, closures & channels have been covered. We can begin developing a generic solution in Golang to solve the problem of “moving boxes fast” given the algorithm used to move a box is already efficient and our concern is only about hiring the right number of individuals for the task.

Let’s take a closer look at our problem to redefine it generically.

We have 100 boxes to move from one room to another. An important point to note here is work involved in moving box1 is no different than work involved for box2. Therefore we can define a function for moving a box where argument ‘i’ is the box to be moved. We can call this function “Task” and the number of boxes to be moved as ‘N’. Any “Basics of Computer Programming 101” class will teach you how to solve this problem by writing a for loop that runs N times and calls the “Task” function each time. This causes the computation to be seized by a single core which is not what we are after. And the number of cores available in a system is a hardware question that depends upon the make, model & design of the system. So, being software developers we abstract hardware away from our problem and we talk in terms of go-routines rather than cores. The more the number of cores a system has, the more the number of go-routines it can support. Let’s say, ‘R’ is the number of go-routines our system with ‘X’ cores can support.

> FYI: ‘X’ number of cores can handle more than ‘X’ number of go-routines. How many number of go-routines a single core can support (R/X) depends on the nature of processing involved in the go-routines and the runtime platform. For example, if all go-routines involve only blocking calls such as network I/O or disk I/O, then a single core is enough to process all of them. This is true because, every go-routine has more waiting work to do than computation work. Therefore a single core can manage executing all of them by context switching between each of them.

Therefore a generic definition of our problem would be

> Assigning ‘N’ tasks to ‘R’ go-routines where all tasks are identical to each other.

If N≤R, we can solve the problem as shown below.

```
package main
import "fmt"
var N int = 100
func Task(i int) {
 fmt.Println("Box", i)
}
func main() {
 ack := make(chan bool, N)    // Acknowledgement channel
for i := 0; i < N; i++ {
   go func(arg int) {         // Point #1
    Task(arg)
    ack <- true              // Point #2
   }(i)                      // Point #3
 }
 
 for i := 0; i < N; i++ {
   <-ack                     // Point #2
 }
}
```

What we have done here is…

1. We have created a separate go-routine for each task. Our system is capable of supporting R go-routines at a time. And since N≤R, we are safe in doing so.
2. We have made sure the main function returns only after waiting for all go-routines to complete. We do this by waiting on the acknowledgement channel (“ack”), which is used by all go-routines (via closure property), to communicate their completion.
3. We pass the loop counter ‘i’ as an argument ‘arg’ to the go-routine instead of directly referencing it in the go-routine through closure property.
1. 
On the other hand if N>R, the above solution would prove problematic. It will create more go-routines than our system can handle. All cores trying to process more go-routines than their capacity, will end up spending more time in context switching than in processing (commonly known as thrashing). This overhead caused by context switching becomes more prominent when the difference between N and R goes up. Therefore, to always limit the number of go-routines to R and assign N tasks to R go-routines only.

We introduce **workers** function, which

```
var R int = 100
func Workers(task func(int)) chan int { // Point #4
 input := make(chan int)                // Point #1
 for i := 0; i < R; i++ {               // Point #1
   go func() {
     for {
       v, ok := <-input                   // Point #2
       if ok {
         task(v)                           // Point #4
       } else {
         return                            // Point #2
       }
     }
   }()
 }
 return input                          // Point #3
}
```

1. Creates a pool of ‘R’ go-routines. No less and no more, all listening to the ‘input’ channel referenced via closure property.
2. Creates go-routines that can kill itself if the input channel is closed by checking the ok parameter every time inside the for loop.
Returns the input channel to allow the caller function to assign tasks to the pool.
3. Takes in a ‘task’ argument to allow the caller function to define the body of the go-routines.

## Usage

```
func main() {
ack := make(chan bool, N)
workers := Workers(func(a int) {     // Point #2
  Task(a)
  ack <- true                        // Point #1
 })
for i := 0; i < N; i++ {
  workers <- i
 }
for i := 0; i < N; i++ {             // Point #3
  <-ack
 }
}
```

Here, (Point #1) By cleverly adding the call to acknowledgement channel using closure property in the (Point #2) definition for the task argument of the workers function, we make sure (Point #3) the main function has a way to figure out whether all go-routines in the pool have completed their tasks or not. Although this works, this is not good practice. All logic related to the go-routines should be contained within workers itself, since they were created in it. The main function shouldn’t have to know the inner working details of the workers function.

Therefore, to implement complete abstraction, we are going to introduce a “climax” function that runs only after all go-routines in the pool have completed. This is accomplished by setting up another go-routine that solely checks the status of the pool. Also different problem statements would require channels of different type. The same int channel cannot be used in all situations. Therefore, in order to write a more generic workers function, we will redefine workers function using [empty interface](https://tour.golang.org/methods/14).

```
package main
import "fmt"
var N int = 100
var R int = 100
func Task(i int) {
 fmt.Println("Box", i)
}
func Workers(task func(interface{}), climax func()) chan interface{} {
 input := make(chan interface{})
 ack := make(chan bool)
 for i := 0; i < R; i++ {
   go func() {
     for {
       v, ok := <-input
        if ok {
          task(v)
          ack <- true
        } else {
          return
        }
      }
   }()
 }
 go func() {
   for i := 0; i < R; i++ {
     <-ack
   }
   climax()
 }()
 return input
}
func main() {
 
 exit := make(chan bool)
 
 workers := Workers(func(a interface{}) {
  Task(a.(int))
 }, func() {
  exit <- true
 })
 
 for i := 0; i < N; i++ {
  workers <- i
 }
 close(workers)
 
 <-exit
}
```

With this, I have attempted to demonstrate the power of Golang. We also looked at how one can write expressive code in Golang that delivers high performance.

Do watch the Go-Routines video by Rob Pike and have a great time coding in Golang.

Until next time…

Thanks to [Prateek Nischal](https://medium.com/@prateeknischal25?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
