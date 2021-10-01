> - 原文地址：[How JavaScript Works🔥 🤖 [Visually Explained]](https://dev.to/narottam04/how-javascript-works-visually-explained-269j)
> - 原文作者：[Narottam04](https://dev.to/narottam04)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/.md](https://github.com/xitu/gold-miner/blob/master/article/2021/.md)
> - 译者：
> - 校对者：

# How JavaScript Works🔥 🤖 [Visually Explained]

![banner](https://res.cloudinary.com/practicaldev/image/fetch/s--AC5E-9bo--/c_imagga_scale,f_auto,fl_progressive,h_420,q_66,w_1000/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/eiz3o1fe8lx4okxtmi27.gif)

JavaScript is one of the most loved and hated languages in the world. It is loved because it is potent. You can make a full-stack application by just learning JavaScript and nothing else. It is also hated because it behaves in unexpected and upsetting ways, which, if you're not invested in understanding the language, might make you hate it 💔.

This blog will explain how JavaScript executes code in the browser, and we will learn it through animated gifs 😆. After reading this blog, you will be one step closer to become a Rockstar Developer 🎸😎

[![https://media.giphy.com/media/EA4ZexjGOnfP2/giphy.gif](https://i.giphy.com/media/EA4ZexjGOnfP2/giphy.gif)](https://i.giphy.com/media/EA4ZexjGOnfP2/giphy.gif)

## Execution Context

"**Everything in JavaScript happens inside an Execution Context."**

I want everyone to remember this statement as it is essential. You can assume this Execution context to be a big container, invoked when the browser wants to run some JavaScript code.

In this container, there are two components 1. Memory component 2. Code component

Memory component is also known as variable environment. In this memory component, variables and functions are stored as key-value pairs.

Code component is a place in the container where code is executed one line at a time. This code component also has a fancy name, namely 'Thread of Execution'. I think it sounds cool!

[![Execution context](https://res.cloudinary.com/practicaldev/image/fetch/s--thFap99C--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/5sitpkprw51dgdjg7um5.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--thFap99C--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/5sitpkprw51dgdjg7um5.png)

**JavaScript is a synchronous, single-threaded language.** It is because it can only execute one command at a time and in a specific order.

## Execution of the code

Let's take a simple example,

```js
var a = 2;
var b = 4;

var sum = a + b;

console.log(sum);
```

In this simple example, we initialize two variables, a and b and store 2 and 4, respectively.

Then we add the value of **a** and **b** and store it in the **sum** variable.

Let's see how JavaScript will execute the code in the browser 🤖

[![Execution context 1.1](https://res.cloudinary.com/practicaldev/image/fetch/s--fPjnibrZ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jq3ufd0eru2ceax067m9.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--fPjnibrZ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jq3ufd0eru2ceax067m9.gif)

The browser creates a global execution context with two components, namely memory and code components.

The Browser will execute the JavaScript code in two-phase

1> Memory Creation Phase

2> Code Execution Phase

In the memory creation phase, JavaScript will scan through all the code and allocate memory to all the variables and functions in the code. For variables, JavaScript will store undefined in the memory creation phase, and for functions, it will keep the entire function code, which we will be looking at the following example.

[![Execution context 1.2](https://res.cloudinary.com/practicaldev/image/fetch/s--WmYga0PP--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/4ty49vslo873hpehxdrw.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--WmYga0PP--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/4ty49vslo873hpehxdrw.gif)

Now, in the 2nd phase, i.e. code execution, it starts going through the whole code line by line.

As it encounters **var a = 2,** it assigns 2 to 'a' in memory. Until now, the value of 'a' was undefined.

Similarly, it does the same thing for the b variable. It assigns 4 to 'b'. Then it calculates and stores the value of the sum in memory which is 6. Now, in the last step, it prints the sum value in the console and then destroys the global execution context as our code is finished.

## How Functions Are Called In Execution Context?

Functions in JavaScript, when you compare with other programming languages, work differently.

Let's take an simple example,

```js
var n = 2;

function square(num) {
 var ans = num * num;
 return ans;
}

var square2 = square(n);
var square4 = square(4);
```

The above example has an function which takes an argument of type number and returns the square of the number.

JavaScript will create a global execution context and allocate memory to all the variables and functions in the first phase when we run the code, as shown below.

For functions, It will store the entire function in the memory.

[![Execution context 1.3](https://res.cloudinary.com/practicaldev/image/fetch/s--GKNbYzk4--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/68nk5l6806bax94k0tky.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--GKNbYzk4--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/68nk5l6806bax94k0tky.gif)

Here comes the exciting part, When JavaScript runs functions, it will create an execution context inside the global execution context.

As it encounters var a = 2, it assigns 2 to 'n' in memory. Line number 2 is a function, and as the function has been allocated memory in the memory execution phase, it will directly jump to line number 6.

square2 variable will invoke the square function, and javascript will create a new execution context.

[![Execution context 1.4](https://res.cloudinary.com/practicaldev/image/fetch/s--Z5ZMX2Nr--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/zvfyis150o3i7bn1x6hy.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--Z5ZMX2Nr--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/zvfyis150o3i7bn1x6hy.gif)

This new execution context for the square function will assign memory to all the variables present in the function in the memory creation phase.

[![Execution context 1.5](https://res.cloudinary.com/practicaldev/image/fetch/s--BrZHpOr9--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/e67rsojvcqmowwj3w75b.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--BrZHpOr9--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/e67rsojvcqmowwj3w75b.gif)

After assigning memory to all the variables inside the function, it will execute the code line by line. It will get the value of num, which is equal to 2 for the first variable and then it will calculate ans. After ans has been calculated, it will return the value which will be assigned to square2.

Once the function returns the value, it will destroy its execution context as it has completed the work.

[![Execution context 1.6](https://res.cloudinary.com/practicaldev/image/fetch/s--NfH3YlZ7--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/b2zu35q2as6uy57qve9q.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--NfH3YlZ7--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/b2zu35q2as6uy57qve9q.gif)

Now it will follow a similar procedure for line number 7 or square4 variable, as shown below.

[![Execution context 1.7](https://res.cloudinary.com/practicaldev/image/fetch/s--NnMsUB9l--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/q7wlgf8uj91cpglpvh0z.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--NnMsUB9l--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/q7wlgf8uj91cpglpvh0z.gif)

Once all the code is executed, the global execution context will also be destroyed, and this is how JavaScript will execute the code behind the scene.

## Call Stack

When a function is invoked in JavaScript, JavaScript creates an execution context. Execution context will get complicated as we nest functions inside a function.

[![Call Stack](https://res.cloudinary.com/practicaldev/image/fetch/s--LjUZjJan--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/idywyfc19t2vsf1nyww1.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--LjUZjJan--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/idywyfc19t2vsf1nyww1.png)

JavaScript manages code execution context creation and deletion with the the help of Call Stack.

A stack (sometimes called a “push-down stack”) is an ordered collection of items where the addition of new items and the removal of existing items always takes place at the same end eg. stack of books.

Call Stack is a mechanism to keep track of its place in a script that calls multiple functions.

Let's take an example

```javascript
function a() {
    function insideA() {
        return true;
    }
    insideA();
}
a();
```

We are creating a function 'a', which calls another function 'insideA' that returns true. I know the code is dumb and doesn't do anything, but it will help us understand how JavaScript handles callback functions.

[![Call Stack](https://res.cloudinary.com/practicaldev/image/fetch/s--hLhHObuJ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/03bry7soja8z3ad143ry.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--hLhHObuJ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/03bry7soja8z3ad143ry.gif)

JavaScript will create a global execution context. Global execution context will assign memory to function 'a' and invoke' function a' in the code execution phase.

An execution context is created for function a, which is placed above the global execution context in the call stack.

**Function a** will assign memory and invoke function **insideA.** An execution context is created for **function insideA** and placed above the call stack of 'function a'.

Now, this insideA function will return true and will be removed from the call stack.

As there is no code inside 'function a' execution context will be removed from the call stack.

Finally, the global execution context is also removed from the call stack.

## Reference

- [Namaste JavaScript Playlist on YouTube](https://www.youtube.com/watch?v=pN6jk0uUrD8&list=PLlasXeu85E9cQ32gLCvAvr9vNaUccPVNP&ab_channel=AkshaySaini)

[![https://media.giphy.com/media/l4pTjOu0NsrLApt0Q/giphy.gif?cid=ecf05e47dtlkk3fe19ovkz96zbsihgjhtu6injewu9oy5v8e&rid=giphy.gif&ct=g](https://res.cloudinary.com/practicaldev/image/fetch/s--AJLnVv0U--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://media.giphy.com/media/l4pTjOu0NsrLApt0Q/giphy.gif%3Fcid%3Decf05e47dtlkk3fe19ovkz96zbsihgjhtu6injewu9oy5v8e%26rid%3Dgiphy.gif%26ct%3Dg)](https://res.cloudinary.com/practicaldev/image/fetch/s--AJLnVv0U--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://media.giphy.com/media/l4pTjOu0NsrLApt0Q/giphy.gif%3Fcid%3Decf05e47dtlkk3fe19ovkz96zbsihgjhtu6injewu9oy5v8e%26rid%3Dgiphy.gif%26ct%3Dg)

I hope this post was informative. 💪🏾 Feel free to reach out to me if you have any questions.

For more such insights, checkout my blog website [blog.webdrip.in](http://blog.webdrip.in/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。