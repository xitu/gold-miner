> * 原文地址：[Using Web Workers to Speed-Up JavaScript Applications](https://blog.bitsrc.io/using-web-workers-to-speed-up-javascript-applications-5c567f209bdb)
> * 原文作者：[Bhagya](https://medium.com/@bhagya-16)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/using-web-workers-to-speed-up-javascript-applications.md](https://github.com/xitu/gold-miner/blob/master/article/2021/using-web-workers-to-speed-up-javascript-applications.md)
> * 译者：
> * 校对者：

# Using Web Workers to Speed-Up JavaScript Applications

![](https://cdn-images-1.medium.com/max/5760/1*dc6I4-IzvGDNryL2KpZX-Q.png)

Web Workers are a method of instructing the browser to run large, time-consuming tasks in the background. Its ability to spawn new threads allows you to prioritize work and address the blocking behavior in single-threaded languages like JavaScript.

But do we really need multi-threaded JavaScript? To answer that, let’s understand where single-threaded JavaScript hit its limits.

## Limitation with Single-Threaded JavaScript

Modern web applications demand more from the browsers. Some of these tasks are long-running that can cause the user interface to freeze for few seconds. By all means, it’s bad for the end-user experience.

To give you a better understanding, I have created a sample application to simulate it in the browser. Here the `Start_Animation `button will move the bicycles forward while the `Run_Calculation` button calculates the prime number sequence that demands more CPU.

```JavaScript
const prime = (num) => {
  for (let i = 0; i <= num; i++) {
    let flag = 0;
  
    // looping through 2 to user input number
    for (let j = 2; j < i; j++) {
        if (i % j == 0) {
            flag = 1;
            break;
        }
    }
  
    // if number greater than 1 and not divisible by other numbers
    if (i > 1 && flag == 0) {
        console.log(i);
    }
  }
};

const Run_Calculation = () => {
  const num = 50000;
  console.log(prime(num));
  return prime(num);
};

const Start_Animation = () => {
  for (let i = 0; i < 3; i++) {
    const shuttleID = `shuttle${i + 1}`;
    let shuttle = document.getElementById(shuttleID);

    let position = 0;
    setInterval(() => {
      if (position > window.innerWidth / 1.2) {
        position = 0;
      } else {
        position++;
        shuttle.style.left = position + "px";
      }
    }, 1);
  }
};

```

After you run the above code, you will see an output like below. If you look closely, you will notice a frozen animation for few seconds when you call the `Run_Calculation` function.

![Demo Application without a Web Worker](https://cdn-images-1.medium.com/max/2280/1*ccudXc7quomjAc-4KQ2Wrg.gif)

Since you have observed the limitations with single-threaded JavaScript, let’s see how we can use Web Workers to overcome this.

## Integrating Web Worker With JavaScript

Let’s see how we can use a Web Worker to optimize the above code.

### Step 1 — Split your functions.

There are 2 main functions in the previous example named as `Run_Calculation` and `Start_Animation`. Since running both these functions in the same thread caused one function to freeze, we need to separate these 2 and run them in separate threads.

So, I’ve created a new file called worker.js and moved the prime number generation part there.

> It is essential to use a separate JS file for the Web Workers. Since main script and web worker script must be fully independent to operate on different threads.

If not, you won’t be able to keep the execution context purely threadsafe, and it can cause unexpected errors in your parallel execution.

In general, a web worker is created in the main thread. So, you need to call the `[Worker()](https://developer.mozilla.org/en-US/docs/Web/API/Worker/Worker)` constructor, specifying the script’s location to execute in the worker thread.

```JavaScript
let worker = new Worker("./worker.js");

const Run_Calculation = () => {
  const num = 50000;
  worker.postMessage(num);
};

worker.onmessage = event => {
  const num = event.data;
  console.log(num);
};

const Start_Animation = () => {
  for (let i = 0; i < 3; i++) {
    const bikeID = `bike${i + 1}`;
    let bike = document.getElementById(bikeID);

    let position = 0;
    setInterval(() => {
      if (position > window.innerWidth / 1.2) {
        position = 0;
      } else {
        position++;
        bike.style.left = position + "px";
      }
    }, 5);
  }
};
```

I’m sure you must have noticed some modifications other than the earlier discussed functions. Don’t worry, I will explain them in the next step.

### Step 2 — Implement communication between 2 files.

Now, we have 2 separate scripts, and we need to implement a way to communicate between these two. For that, you need to understand how to pass data between your main thread and the web worker thread.

> The Web Worker API has a `postMessage()` method for sending messages and an `onmessage `event handler to receive messages.

If we consider a situation where we need to pass from the web worker thread to the main thread, we can use `postMessage()` function within the worker file, and the `worker.onmessage` listener inside the main thread to listen to messages from the worker.

Also, these same functions are used to pass data from the main thread to the web worker thread as well. The only difference we need to make is calling `worker.postMessage()` on the main thread and `onmessage` on the worker thread.

> **Tip:** It is important to keep in mind that, `onmessage` and `postMessage()` need to be hung off the worker object when used in the main thread, but not within the worker thread. This will improve the effectiveness of the worker while ensuring a safe **cross-origin communication**

As you noticed, I have already modified both files using `onmessage` event handler and `postMessage()` function to establish communication between the main thread and web worker thread.

```JavaScript
//worker.js file
self.onmessage = event => { 
  const num = event.data; 
  const result = prime(num); 
  self.postMessage(result); 
  self.close();
};

//main_scrpit.js
let worker = new Worker(“./worker.js”); 

const Run_Calculation = () => { 
  const num = 50000; 
  worker.postMessage(num);
}; 

worker.onmessage = event => { 
  const num = event.data;
};
```

> **Note:** When a message is passed between the main thread and worker, it will be completely moved. Not shared.

Now, it is all set, and you can reload the program in your browser, start the animation, and press the `Run_Calculation` button to start the calculation. You’ll notice that the prime number calculation result is still listed in the browser console, but this has no impact on the movement of the icons. So, We can see that our application’s performance has **greatly improved.**

![Demo Application With a Web Worker](https://cdn-images-1.medium.com/max/2280/1*x0judL4Qm9bdKJ8RM4yeyQ.gif)

### Step 3 — Terminate the web worker.

As a practice, it is better to terminate a worker after it has fulfilled its function since it frees up resources for other applications. You can wither use `terminate()` function or `close()` function for this.

> However, it is essential to know when to choose between terminate () and close() methods since they serve different purposes.

The `close()` function is only visible within the worker files. Hence this function can only be used within the worker file to terminate the worker. On the other hand, the `terminate()` method is a part of the worker object’s interface, and you can call it from the main JavaScript file.

```JavaScript
// immediately terminate the main JS file
worker.terminate();

// stop the worker from the worker code.
self.close();
```

You can find the full demo project in my [GitHub](https://github.com/bhagya327/Demo-Application) account.

## Final Thoughts

Web Workers are a simple way of spawning new threads to speed up your application. In my example, I used a computationally heavy task to show the difference.

In addition to that, there are many use cases of Web Workers like caching of data and web pages, background I/O operations, analyzing video or audio data, performing periodic tasks, etc.

Most importantly, you don’t have to limit yourself to a single web worker as well. You can spawn as many threads as you want and run tasks parallelly in them as you wish. But I always advise you not to create Web Workers and spawn additional threads without any use.

In this article, I’ve touched on what I feel are the most important points you need to know about multi-threaded executions with Web Workers.

Once you understand how Web Workers work, it will be easy to determine how to use them in your project. So, I invite you to get a hands-on experience with Web Workers and share your thoughts in the comments section.

Thank you for Reading !!!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
