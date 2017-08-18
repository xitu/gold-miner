
> * 原文地址：[Scaling Node.js Applications](https://medium.freecodecamp.org/scaling-node-js-applications-8492bd8afadc)
> * 原文作者：[Samer Buna](https://medium.freecodecamp.org/@samerbuna)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/scaling-node-js-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO/scaling-node-js-applications.md)
> * 译者：
> * 校对者：

# Scaling Node.js Applications

## Everything you need to know about Node.js built-in tools for scalability

![](https://cdn-images-1.medium.com/max/2000/1*5zOn0-deg1nQ5YzxUFGCPA.png)

Screenshot captured from my Pluralsight course — Advanced Node.js

Scalability in Node.js is not an afterthought. It’s something that’s baked into the core of the runtime. Node is named Node to emphasize the idea that a Node application should comprise multiple small distributed *nodes* that communicate with each other.

Are you running multiple nodes for your Node applications? Are you running a Node process on every CPU core of your production machines and load balancing all the requests among them? Did you know that Node has a built-in module to help with that?

Node’s *cluster* module not only provides an out-of-the-box solution to utilizing the full CPU power of a machine, but it also helps with increasing the availability of your Node processes and provides an option to restart the whole application with a zero downtime. This article covers all that goodness and more.

> This article is a write-up of part of [my Pluralsight course about Node.js](https://www.pluralsight.com/courses/nodejs-advanced). I cover similar content in video format there.

### Strategies of Scalability

The workload is the most popular reason we scale our applications, but it’s not the only reason. We also scale our applications to increase their availability and tolerance to failure.

There are mainly three different things we can do to scale an application:

#### 1 — Cloning

The easiest thing to do to scale a big application is to clone it multiple times and have each cloned instance handle part of the workload (with a load balancer, for example). This does not cost a lot in term of development time and it’s highly effective. This strategy is the minimum you should do and Node.js has the built-in module, `cluster`, to make it easier for you to implement the cloning strategy on a single server.

#### 2 — Decomposing

We can also scale an application by [decomposing](https://builttoadapt.io/whats-your-decomposition-strategy-e19b8e72ac8f) it based on functionalities and services. This means having multiple, different applications with different code bases and sometimes with their own dedicated databases and User Interfaces.

This strategy is commonly associated with the term *Microservice*, where micro indicates that those services should be as small as possible, but in reality, the size of the service is not what’s important but rather the enforcement of loose coupling and high cohesion between services. The implementation of this strategy is often not easy and could result in long-term unexpected problems, but when done right the advantages are great.

#### 3 — Splitting

We can also split the application into multiple instances where each instance is responsible for only a part of the application’s data. This strategy is often named *horizontal partitioning*, or *sharding*, in databases. Data partitioning requires a lookup step before each operation to determine which instance of the application to use. For example, maybe we want to partition our users based on their country or language. We need to do a lookup of that information first.

Successfully scaling a big application should eventually implement all three strategies. Node.js makes it easy to do so but I am going to focus on the cloning strategy in this article and explore the built-in tools available in Node.js to implement it.

Please note that you need a good understanding of Node.js *child processes *before reading this article. If you haven’t already, I recommend that you read this other article first:

[![](https://ws4.sinaimg.cn/large/006tNc79ly1fhzggwsiaej31400a6jsm.jpg)](https://medium.freecodecamp.org/node-js-child-processes-everything-you-need-to-know-e69498fe970a)

### The Cluster Module

The cluster module can be used to enable load balancing over an environment’s multiple CPU cores. It’s based on the child process module `fork` method and it basically allows us to fork the main application process as many times as we have CPU cores. It will then take over and load balance all requests to the main process across all forked processes.

The cluster module is Node’s helper for us to implement the cloning scalability strategy, but only on one machine. When you have a big machine with a lot of resources or when it’s easier and cheaper to add more resources to one machine rather than adding new machines, the cluster module is a great option for a really quick implementation of the cloning strategy.

Even small machines usually have multiple cores and even if you’re not worried about the load on your Node server, you should enable the cluster module anyway to increase your server availability and fault-tolerance. It’s a simple step and when using a process manager like PM2, for example, it becomes as simple as just providing an argument to the launch command!

But let me tell you how to use the cluster module natively and explain how it works.

The structure of what the cluster module does is simple. We create a *master *process and that master process forks a number of *worker* processes and manages them. Each worker process represents an instance of the application that we want to scale. All incoming requests are handled by the master process, which is the one that decides which worker process should handle an incoming request.

![](https://cdn-images-1.medium.com/max/2000/1*C7ICI8d7aAna_zTZvZ64MA.png)

Screenshot captured from my Pluralsight course — Advanced Node.js

The master process’s job is easy because it actually just uses a *round-robin* algorithm to pick a worker process. This is enabled by default on all platforms except Windows and it can be globally modified to let the load-balancing be handled by the operation system itself.

The round-robin algorithm distributes the load evenly across all available processes on a rotational basis. The first request is forwarded to the first worker process, the second to the next worker process in the list, and so on. When the end of the list is reached, the algorithm starts again from the beginning.

This is one of the simplest and most used load balancing algorithms. But it’s not the only one. More featured algorithms allow assigning priorities and selecting the least loaded server or the one with the fastest response time.

#### Load-Balancing an HTTP Server

Let’s clone and load balance a simple HTTP server using the cluster module. Here’s the simple Node’s hello-world example server slightly modified to simulate some CPU work before responding:

    // server.js

    const http = require('http');
    const pid = process.pid;

    http.createServer((req, res) => {
      for (let i=0; i<1e7; i++); // simulate CPU work
      res.end(`Handled by process ${pid}`);
    }).listen(8080, () => {
      console.log(`Started process ${pid}`);
    });

To verify that the balancer we’re going to create is going to work, I’ve included the process `pid` in the HTTP response to identify which instance of the application is actually handling a request.

Before we create a cluster to clone this server into multiple workers, let’s do a simple benchmark of how many requests this server can handle per second. We can use the [Apache benchmarking tool](https://httpd.apache.org/docs/2.4/programs/ab.html) for that. After running the simple `server.js` code above, run this `ab` command:

    ab -c200 -t10 http://localhost:8080/

This command will test-load the server with 200 concurrent connections for 10 seconds.

![](https://cdn-images-1.medium.com/max/2000/1*w8VmzV81atlTzHn7pDXu1g.png)

Screenshot captured from my Pluralsight course — Advanced Node.js

On my machine, the single node server was able to handle about 51 requests per second. Of course, the results here will be different on different platforms and this is a very simplified test of performance that’s not a 100% accurate, but it will clearly show the difference that a cluster would make in a multi-core environment.

Now that we have a reference benchmark, we can scale the application with the cloning strategy using the cluster module.

On the same level as the `server.js` file above, we can create a new file (`cluster.js`) for the master process with this content (explanation follows):

    // cluster.js

    const cluster = require('cluster');
    const os = require('os');

    if (cluster.isMaster) {
      const cpus = os.cpus().length;

      console.log(`Forking for ${cpus} CPUs`);
      for (let i = 0; i<cpus; i++) {
        cluster.fork();
      }
    } else {
      require('./server');
    }

In `cluster.js`, we first required both the `cluster` module and the `os` module. We use the `os` module to read the number of CPU cores we can work with using `os.cpus()`.

The `cluster` module gives us the handy Boolean flag `isMaster` to determine if this `cluster.js` file is being loaded as a master process or not. The first time we execute this file, we will be executing the master process and that `isMaster` flag will be set to true. In this case, we can instruct the master process to fork our server as many times as we have CPU cores.

Now we just read the number of CPUs we have using the `os` module, then with a for loop over that number, we call the `cluster.fork` method. The for loop will simply create as many workers as the number of CPUs in the system to take advantage of all the available processing power.

When the `cluster.fork` line is executed from the master process, the current file, `cluster.js`, is run again, but this time in *worker mode* with the `isMaster` flag set to false. *There is actually another flag set to true in this case if you need to use it, which is the *`*isWorker*`* flag.*

When the application runs as a worker, it can start doing the actual work. This is where we need to define our server logic, which, for this example, we can do by requiring the `server.js` file that we have already.

That’s basically it. That’s how easy it is to take advantage of all the processing power in a machine. To test the cluster, run the `cluster.js` file:

![](https://cdn-images-1.medium.com/max/1600/1*c0S-W4GYgCGB_maJ94ZLPw.png)

Screenshot captured from my Pluralsight course — Advanced Node.js
I have 8 cores on my machine so it started 8 processes. It’s important to understand that these are completely different Node.js processes. Each worker process here will have its own event loop and memory space.

When we now hit the web server multiple times, the requests will start to get handled by different worker processes with different process ids. The workers will not be exactly rotated in sequence because the cluster module performs some optimizations when picking the next worker, but the load will be somehow distributed among the different worker processes.

We can use the same `ab` command above to load-test this cluster of processes:

![](https://cdn-images-1.medium.com/max/2000/1*5_EogHG-Egf2uAMOj9PmCA.png)

Screenshot captured from my Pluralsight course — Advanced Node.js

The cluster I created on my machine was able to handle 181 requests per second in comparison to the 51 requests per second that we got using a single Node process. The performance of this simple application tripled with just a few lines of code.

#### Broadcasting Messages to All Workers

Communicating between the master process and the workers is simple because under the hood the cluster module is just using the `child_process.fork` API, which means we also have communication channels available between the master process and each worker.

Based on the `server.js`/`cluster.js` example above, we can access the list of worker objects using `cluster.workers`, which is an object that holds a reference to all workers and can be used to read information about these workers. Since we have communication channels between the master process and all workers, to broadcast a message to all them we just need a simple loop over all the workers. For example:

    Object.values(cluster.workers).forEach(worker => {
      worker.send(`Hello Worker ${worker.id}`);
    });

We simply used `Object.values` to get an array of all workers from the `cluster.workers` object. Then, for each worker, we can use the `send` function to send over any value that we want.

In a worker file, `server.js` in our example, to read a message received from this master process, we can register a handler for the `message` event on the global `process` object. For example:

    process.on('message', msg => {
      console.log(`Message from master: ${msg}`);
    });

Here is what I see when I test these two additions to the cluster/server example:

![](https://cdn-images-1.medium.com/max/2000/1*6XfoWiNKTCiDjqar7L5_xw.png)

Screenshot captured from my Pluralsight course — Advanced Node.js

Every worker received a message from the master process. *Note how the workers did not start in order.*

Let’s make this communication example a little bit more practical. Let’s say we want our server to reply with the number of users we have created in our database. We’ll create a mock function that returns the number of users we have in the database and just have it square its value every time it’s called (dream growth):

    // **** Mock DB Call
    const numberOfUsersInDB = function() {
      this.count = this.count || 5;
      this.count = this.count * this.count;
      return this.count;
    }
    // ****

Every time `numberOfUsersInDB` is called, we’ll assume that a database connection has been made. What we want to do here — to avoid multiple DB requests — is to cache this call for a certain period of time, such as 10 seconds. However, we still don’t want the 8 forked workers to do their own DB requests and end up with 8 DB requests every 10 seconds. We can have the master process do just one request and tell all of the 8 workers about the new value for the user count using the communication interface.

In the master process mode, we can, for example, use the same loop to broadcast the users count value to all workers:

    // Right after the fork loop within the isMaster=true block

    const updateWorkers = () => {
      const usersCount = numberOfUsersInDB();
      Object.values(cluster.workers).forEach(worker => {
        worker.send({ usersCount });
      });
    };

    updateWorkers();
    setInterval(updateWorkers, 10000);

Here we’re invoking `updateWorkers` for the first time and then invoking it every 10 seconds using a `setInterval`. This way, every 10 seconds, all workers will receive the new user count value over the process communication channel and only one database connection will be made.

In the server code, we can use the `usersCount` value using the same `message` event handler. We can simply cache that value with a module global variable and use it anywhere we want.

For example:

    const http = require('http');
    const pid = process.pid;

    **let usersCount;
    **
    http.createServer((req, res) => {
      for (let i=0; i<1e7; i++); // simulate CPU work
      res.write(`Handled by process ${pid}\n`);
    **res.end(`Users: ${usersCount}`);**
    }).listen(8080, () => {
      console.log(`Started process ${pid}`);
    });

    process.on('message', msg => {
    **usersCount = msg.usersCount;**
    });

The above code makes the worker web server respond with the cached `usersCount`value. If you test the cluster code now, during the first 10 seconds you’ll get “25” as the users count from all workers (and only one DB request would be made). Then after another 10 seconds, all workers would start reporting the new user count, 625 (and only one other DB request would be made).

This is all possible thanks to the communication channels between the master process and all workers.

#### Increasing Server Availability

One of the problems in running a single instance of a Node application is that when that instance crashes, it has to be restarted. This means some downtime between these two actions, even if the process was automated as it should be.

This also applies to the case when the server has to be restarted to deploy new code. With one instance, there will be downtime which affects the availability of the system.

When we have multiple instances, the availability of the system can be easily increased with just a few extra lines of code.

To simulate a random crash in the server process, we can simply do a `process.exit` call inside a timer that fires after a random amount of time:

    // In server.js

    setTimeout(() => {
      process.exit(1) // death by random timeout
    }, Math.random() * 10000);

When a worker process exits like this, the master process will be notified using the `exit` event on the `cluster` model object. We can register a handler for that event and just fork a new worker process when any worker process exits.

For example:

    // Right after the fork loop within the isMaster=true block

    **cluster**.on('**exit**', (worker, code, signal) => {
      if (code !== 0 && !worker.exitedAfterDisconnect) {
        console.log(`Worker ${worker.id} crashed. ` +
                    'Starting a new worker...');
    **cluster.fork();**
      }
    });

It’s good to add the if condition above to make sure the worker process actually crashed and was not manually disconnected or killed by the master process itself. For example, the master process might decide that we are using too many resources based on the load patterns it sees and it will need to kill a few workers in that case. To do so, we can use the `disconnect` methods on any worker and, in that case, the `exitedAfterDisconnect` flag will be set to true. The if statement above will guard to not fork a new worker for that case.

If we run the cluster with the handler above (and the random crash in `server.js`), after a random number of seconds, workers will start to crash and the master process will immediately fork new workers to increase the availability of the system. You can actually measure the availability using the same `ab` command and see how many requests the server will not be able to handle overall (because some of the unlucky requests will have to face the crash case and that’s hard to avoid.)

When I tested the code, only 17 requests failed out of over 1800 in the 10-second testing interval with 200 concurrent requests.

![](https://cdn-images-1.medium.com/max/2000/1*B72o6QhsyiNnEQU5Wx20RQ.png)

Screenshot captured from my Pluralsight course — Advanced Node.js

That’s over 99% availability. By just adding a few lines of code, we now don’t have to worry about process crashes anymore. The master guardian will keep an eye on those processes for us.

#### Zero-downtime Restarts

What about the case when we want to restart all worker processes when, for example, we need to deploy new code?

We have multiple instances running, so instead of restarting them together, we can simply restart them one at a time to allow other workers to continue to serve requests while one worker is being restarted.

Implementing this with the cluster module is easy. Since we don’t want to restart the master process once it’s up, we need a way to send this master process a command to instruct it to start restarting its workers. This is easy on Linux systems because we can simply listen to a process signal like `SIGUSR2`, which we can trigger by using the `kill` command on the process id and passing that signal:

    // In Node
    process.on('SIGUSR2', () => { ... });

    // To trigger that
    $ kill -SIGUSR2 PID

This way, the master process will not be killed and we have a way to instruct it to start doing something. `SIGUSR2` is a proper signal to use here because this will be a user command. If you’re wondering why not `SIGUSR1`, it’s because Node uses that for its debugger and you want to avoid any conflicts.

Unfortunately, on Windows, these process signal are not supported and we would have to find another way to command the master process to do something. There are some alternatives. We can, for example, use standard input or socket input. Or we can monitor the existence of a `process.pid` file and watch that for a remove event. But to keep this example simple, we’ll just assume this server is running on a Linux platform.

Node works very well on Windows, but I think it’s a much safer option to host production Node applications on a Linux platform. This is not just because of Node itself, but many other production tools that are much more stable on Linux. This is my personal opinion and feel free to completely ignore it.

*By the way, on recent versions of Windows, you can actually use a Linux subsystem and it works very well. I’ve tested it myself and it was nothing short of impressive. If you’re developing a Node applications on Windows, check out *[*Bash on Windows*](https://msdn.microsoft.com/en-us/commandline/wsl/about)* and give it a try.*

In our example, when the master process receives the `SIGUSR2` signal, that means it’s time for it to restart its workers, but we want to do that one worker at a time. This simply means the master process should only restart the next worker when it’s done restarting the current one.

To begin this task, we need to get a reference to all current workers using the `cluster.workers` object and we can simply just store the workers in an array:

    const workers = Object.values(cluster.workers);

Then, we can create a `restartWorker` function that receives the index of the worker to be restarted. This way we can do the restarting in sequence by having the function call itself when it’s ready for the next worker. Here’s an example `restartWorker` function that we can use (explanation follows):

    const restartWorker = (workerIndex) => {
      const worker = workers[workerIndex];
      if (!worker) return;

      worker.on('exit', () => {
        if (!worker.exitedAfterDisconnect) return;
        console.log(`Exited process ${worker.process.pid}`);

        cluster.fork().on('listening', () => {
          restartWorker(workerIndex + 1);
        });
      });

      worker.disconnect();
    };

    restartWorker(0);

Inside the `restartWorker` function, we got a reference to the worker to be restarted and since we will be calling this function recursively to form a sequence, we need a stop condition. When we no longer have a worker to restart, we can just return. We then basically want to disconnect this worker (using `worker.disconnect`), but before restarting the next worker, we need to fork a new worker to replace this current one that we’re disconnecting.

We can use the `exit` event on the worker itself to fork a new worker when the current one exists, but we have to make sure that the exit action was actually triggered after a normal disconnect call. We can use the `exitedAfetrDisconnect` flag. If this flag is not true, the exit was caused by something else other than our disconnect call and in that case, we should just return and do nothing. But if the flag is set to true, we can go ahead and fork a new worker to replace the one that we’re disconnecting.

When this new forked worker is ready, we can restart the next one. However, remember that the fork process is not synchronous, so we can’t just restart the next worker after the fork call. Instead, we can monitor the `listening` event on the newly forked worker, which tells us that this worker is connected and ready. When we get this event, we can safely restart the next worker in sequence.

That’s all we need for a zero-downtime restart. To test it, you’ll need to read the master process id to be sent to the `SIGUSR2 `signal:

    console.log(`Master PID: ${process.pid}`);

Start the cluster, copy the master process id, and then restart the cluster using the `kill -SIGUSR2 PID` command. You can also run the same `ab` command while restarting the cluster to see the effect that this restart process will have on availability. Spoiler alert, you should get ZERO failed requests:

![](https://cdn-images-1.medium.com/max/2000/1*NjG0e2ARIDQiYSHWNvdNPQ.png)

Screenshot captured from my Pluralsight course — Advanced Node.js

Process monitors like PM2, which I personally use in production, make all the tasks we went through so far extremely easy and give a lot more features to monitor the health of a Node.js application. For example, with PM2, to launch a cluster for any app, all you need to do is use the `-i` argument:

    pm2 start server.js -i max

And to do a zero downtime restart you just issue this magic command:

    pm2 reload all

However, I find it helpful to first understand what actually will happen under the hood when you use these commands.

#### Shared State and Sticky Load Balancing

Good things always come with a cost. When we load balance a Node application, we lose some features that are only suitable for a single process. This problem is somehow similar to what’s known in other languages as thread safety, which is about sharing data between threads. In our case, it’s sharing data between worker processes.

For example, with a cluster setup, we can no longer cache things in memory because every worker process will have its own memory space. If we cache something in one worker’s memory, other workers will not have access to it.

If we need to cache things with a cluster setup, we have to use a separate entity and read/write to that entity’s API from all workers. This entity can be a database server or if you want to use in-memory cache you can use a server like Redis or create a dedicated Node process with a read/write API for all other workers to communicate with.

![](https://cdn-images-1.medium.com/max/2000/1*dIR_CAkmtPFgtaGTOKBFkA.png)

Screenshot captured from my Pluralsight course — Advanced Node.js

Don’t look at this as a disadvantage though, because using a separate entity for your application caching needs is part of *decomposing* your app for scalability. You should probably be doing that even if you’re running on a single core machine.

Other than caching, when we’re running on a cluster, stateful communication in general becomes a problem. Since the communication is not guaranteed to be with the same worker, creating a stateful channel on any one worker is not an option.

The most common example for this is authenticating users.

![](https://cdn-images-1.medium.com/max/2000/1*jKAmrLPMer6_kmpIjyGzxA.png)

Screenshot captured from my Pluralsight course — Advanced Node.js

With a cluster, the request for authentication comes to the master balancer process, which gets sent to a worker, assuming that to be A in this example.

![](https://cdn-images-1.medium.com/max/2000/1*dNUlcuEXPkk44A63ct0s0g.png)

Screenshot captured from my Pluralsight course — Advanced Node.js

Worker A now recognizes the state of this user. However, when the same user makes another request, the load balancer will eventually send them to other workers, which do not have them as authenticated. Keeping a reference to an authenticated user session in one instance memory is not going to work anymore.

This problem can be solved in many ways. We can simply share the state across the many workers we have by storing these sessions’ information in a shared database or a Redis node. However, applying this strategy requires some code changes, which is not always an option.

If you can’t do the code modifications needed to make a shared storage of sessions here, there is a less invasive but not as efficient strategy. You can use what’s known as Sticky Load Balancing. This is much simpler to implement as many load balancers support this strategy out of the box. The idea is simple. When a user authenticates with a worker instance, we keep a record of that relation on the load balancer level.

![](https://cdn-images-1.medium.com/max/2000/1*P4LNRLkZ9n_p8OKtmRM9LA.png)

Screenshot captured from my Pluralsight course — Advanced Node.js

Then, when the same user sends a new request, we do a lookup in this record to figure out which server has their session authenticated and keep sending them to that server instead of the normal distributed behavior. This way, the code on the server side does not have to be changed, but we don’t really get the benefit of load balancing for authenticated users here so only use sticky load balancing if you have no other option.

The cluster module actually does not support sticky load balancing, but a few other load balancers can be configured to do sticky load balancing by default.

---

Thanks for reading. If you found this article helpful, please click the💚 below. Follow me for more articles on Node.js and JavaScript.

I create **online courses** for [Pluralsight](https://app.pluralsight.com/profile/author/samer-buna) and [Lynda](https://www.lynda.com/Samer-Buna/7060467-1.html). My most recent courses are [Advanced React.js](https://www.pluralsight.com/courses/reactjs-advanced), [Advanced Node.js](https://www.pluralsight.com/courses/nodejs-advanced), and [Learning Full-stack JavaScript](https://www.lynda.com/Express-js-tutorials/Learning-Full-Stack-JavaScript-Development-MongoDB-Node-React/533304-2.html).

I also do **online and onsite training** for groups covering beginner to advanced levels in JavaScript, Node.js, React.js, and GraphQL. [Drop me a line](mailto:samer@jscomplete.com) if you’re looking for a trainer. If you have any questions about this article or any other article I wrote, find me on [this **slack** account](https://slack.jscomplete.com/) (you can invite yourself) and ask in the #questions room.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
