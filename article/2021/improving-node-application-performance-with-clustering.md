> * 原文地址：[Improving Node.js Application Performance With Clustering](https://blog.appsignal.com/2021/02/03/improving-node-application-performance-with-clustering.html)
> * 原文作者：[Joyce Echessa](https://echessa.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/improving-node-application-performance-with-clustering.md](https://github.com/xitu/gold-miner/blob/master/article/2021/improving-node-application-performance-with-clustering.md)
> * 译者：
> * 校对者：

# Improving Node.js Application Performance With Clustering

When building a production application, you are usually on the lookout for ways to optimize its performance while keeping any possible trade-offs in mind. In this post, we’ll take a look at an approach that can give you a quick win when it comes to improving the way your Node.js apps handle the workload.

An instance of Node.js runs in a single thread which means that on a multi-core system (which most computers are these days), not all cores will be utilized by the app. To take advantage of the other available cores, you can launch a cluster of Node.js processes and distribute the load between them.

Having multiple threads to handle requests improves the throughput (requests/second) of your server as several clients can be served concurrently. We’ll see how to create child processes with the Node.js cluster module and then later, we’ll take a look at how to manage clustering with the PM2 Process Manager.

## A Look at Clustering

The Node.js [Cluster module](https://nodejs.org/api/cluster.html) enables the creation of child processes (workers) that run simultaneously and share the same server port. Each spawned child has its own event loop, memory, and V8 instance. The child processes use IPC (Inter-process communication) to communicate with the parent Node.js process.

Having multiple processes to handle incoming requests means that several requests can be processed simultaneously and if there is a long-running/blocking operation on one worker, the other workers can continue handling other incoming requests — your app won’t have come to a standstill until the blocking operation completes.

Running multiple workers also makes it possible to update your app in production with little to no downtime. You can make changes to your app and restart workers one at a time, waiting for one child process to fully spawn before restarting another. This way, there will always be workers running while you update the app.

Incoming connections are distributed among child processes in one of two ways:

* The master process listens for connections on a port and distributes them across the workers in a round-robin fashion. This is the default approach on all platforms, except Windows.
* The master process creates a listen socket and sends it to interested workers that will then be able to accept incoming connections directly.

## Using Clusters

To see the advantages that clustering offers, we’ll start with a sample Node.js app that doesn’t use clusters and compare it with one that uses clusters:

```js
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello World!');
})

app.get('/api/:n', function (req, res) {
  let n = parseInt(req.params.n);
  let count = 0;

  if (n > 5000000000) n = 5000000000;

  for(let i = 0; i <= n; i++){
    count += i;
  }

  res.send(`Final count is ${count}`);
})

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
})
```

It’s a bit contrived and not something you would find in a real-world situation, but it will suit our needs. The app contains two routes — a root route that returns the string “Hello World” and another route that takes a route parameter `n` and adds numbers up to `n` to a variable `count` before returning a string containing the final count.

The operation is an `0(n)` operation so it offers us an easy way to simulate long-running operations on the server — if we feed it a large enough value for `n`. We cap `n` off at `5,000,000,000` — let’s spare our computer from having to run so many operations.

If you run the app with `node app.js` and pass it a decently small value for `n` (e.g. `http://localhost:3000/api/50`), it will execute quickly and return a response almost immediately. The root route (`http://localhost:3000`) also returns a response quickly.

When you pass it a large `n`, you will start seeing the problem that running the app on a single thread offers. Try passing it `5,000,000,000` (via `http://localhost:3000/api/5000000000`).

The app will take a few seconds to complete the request. If you open another browser tab and try to send another request to the server (to either `/` or `/api/:n` route), the request will take a few seconds to complete as the single thread will be busy processing the other long-running operation. The single CPU core has to complete the first request before it can handle another.

Now, let’s use the cluster module in the app to spawn some child processes and see how that improves things.

Below is the modified app:

```js
const express = require('express');
const port = 3000;
const cluster = require('cluster');
const totalCPUs = require('os').cpus().length;

if (cluster.isMaster) {
  console.log(`Number of CPUs is ${totalCPUs}`);
  console.log(`Master ${process.pid} is running`);

  // Fork workers.
  for (let i = 0; i < totalCPUs; i++) {
    cluster.fork();
  }

  cluster.on('exit', (worker, code, signal) => {
    console.log(`worker ${worker.process.pid} died`);
    console.log("Let's fork another worker!");
    cluster.fork();
  });

} else {
  const app = express();
  console.log(`Worker ${process.pid} started`);

  app.get('/', (req, res) => {
    res.send('Hello World!');
  })

  app.get('/api/:n', function (req, res) {
    let n = parseInt(req.params.n);
    let count = 0;

    if (n > 5000000000) n = 5000000000;

    for(let i = 0; i <= n; i++){
      count += i;
    }

    res.send(`Final count is ${count}`);
  })

  app.listen(port, () => {
    console.log(`App listening on port ${port}`);
  })

}
```

The app does the same thing as before, but this time, we are spawning up several child processes that will all share port `3000` and that will be able to handle requests sent to this port. The worker processes are spawned using the [`child_process.fork()`](https://nodejs.org/api/child_process.html#child_process_child_process_fork_modulepath_args_options) method. The method returns a [`ChildProcess`](https://nodejs.org/api/child_process.html#child_process_child_process) object that has a built-in communication channel that allows messages to be passed back and forth between the child and its parent.

We create as many child processes as there are CPU cores on the machine the app is running. It is recommended to not create more workers than there are logical cores on the computer as this can cause an overhead in terms of scheduling costs. This happens because the system will have to schedule all the created processes so that each gets a turn on the few cores.

The workers are created and managed by the master process. When the app first runs, we check to see if it’s a master process with `isMaster`. This is determined by the `process.env.NODE_UNIQUE_ID` variable. If `process.env.NODE_UNIQUE_ID` is `undefined`, then `isMaster` will be `true`.

If the process is a master, we then call `cluster.fork()` to spawn several processes. We log the master and worker process IDs. Below, you can see the output from running the app on a four-core system. When a child process dies, we spawn a new one to keep utilizing the available CPU cores.

```
Number of CPUs is 4
Master 67967 is running
Worker 67981 started
App listening on port 3000
Worker 67988 started
App listening on port 3000
Worker 67982 started
Worker 67975 started
App listening on port 3000
App listening on port 3000
```

To see the improvement clustering offers, run the same experiment as before: first make a request to the server with a large value for `n` and quickly run another request in another browser tab. The second request will complete while the first is still running — it doesn’t have to wait for the other request to complete. With multiple workers available to take requests, both server availability and throughput are improved.

Running a request in one browser tab and quickly running another one in a second tab might work to show us the improvement offered by clustering for our example, but it’s hardly a proper or reliable way to determine performance improvements. Let’s take a look at some benchmarks that will better demonstrate how much clustering has improved our app.

## Performance Metrics

Let’s run a load test on our two apps to see how each handles a large number of incoming connections. We’ll use the [loadtest](https://www.npmjs.com/package/loadtest) package for this.

The `loadtest` package allows you to simulate a large number of concurrent connections to your API so that you can measure its performance.

To use `loadtest`, first install it globally:

```bash
$ npm install -g loadtest
```

Then run the app that you want to test with `node app.js`. We’ll start by testing the version that doesn’t use clustering.

With the app running, open another Terminal and run the following load test:

```bash
$ loadtest http://localhost:3000/api/500000 -n 1000 -c 100
```

The above command will send `1000` requests to the given URL, of which `100` are concurrent. The following is the output from running the above command:

```
Requests: 0 (0%), requests per second: 0, mean latency: 0 ms

Target URL:          http://localhost:3000/api/500000
Max requests:        1000
Concurrency level:   100
Agent:               none

Completed requests:  1000
Total errors:        0
Total time:          1.268364041 s
Requests per second: 788
Mean latency:        119.4 ms

Percentage of the requests served within a certain time 50%      121 ms
  90%      132 ms
  95%      135 ms
  99%      141 ms
 100%      142 ms (longest request)
```

We see that with the same request (with `n` = `500000`) the server was able to handle `788` requests per second with a mean latency of `119.4` milliseconds (the average time it took to complete a single request).

Let’s try it again but with more requests this time (and with no clusters):

```sh
$ loadtest http://localhost:3000/api/5000000 -n 1000 -c 100
```

Below’s the output:

```
Requests: 0 (0%), requests per second: 0, mean latency: 0 ms
Requests: 573 (57%), requests per second: 115, mean latency: 798.3 ms

Target URL:          http://localhost:3000/api/5000000
Max requests:        1000
Concurrency level:   100
Agent:               none

Completed requests:  1000
Total errors:        0
Total time:          8.740058135 s
Requests per second: 114
Mean latency:        828.9 ms

Percentage of the requests served within a certain time 50%      869 ms
  90%      874 ms
  95%      876 ms
  99%      879 ms
 100%      880 ms (longest request)
```

With a request where `n` = `5000000` the server was able to handle `114` requests per second with a mean latency of `828.9` milliseconds.

Let’s compare this result with that of the app that uses clusters.

Stop the non-cluster app, run the clustered one and, finally, run the same load tests.

Below are the results for testing for `http://localhost:3000/api/500000`:

```
Requests: 0 (0%), requests per second: 0, mean latency: 0 ms

Target URL:          http://localhost:3000/api/500000
Max requests:        1000
Concurrency level:   100
Agent:               none

Completed requests:  1000
Total errors:        0
Total time:          0.701446328 s
Requests per second: 1426
Mean latency:        65 ms

Percentage of the requests served within a certain time 50%      61 ms
  90%      81 ms
  95%      90 ms
  99%      106 ms
 100%      112 ms (longest request)
```

Tested with the same requests (when `n` = `500000`), the app that uses clustering was able to handle `1426` requests per second — a significant increase, compared to the `788` requests per second of the app with no clusters. The mean latency of the clustered app is `65` milliseconds, compared to `119.4` of the app with no clusters. You can clearly see the improvement that clustering added to the app.

And below are the results for testing for `http://localhost:3000/api/5000000`:

```
Requests: 0 (0%), requests per second: 0, mean latency: 0 ms

Target URL:          http://localhost:3000/api/5000000
Max requests:        1000
Concurrency level:   100
Agent:               none

Completed requests:  1000
Total errors:        0
Total time:          2.43770738 s
Requests per second: 410
Mean latency:        229.9 ms

Percentage of the requests served within a certain time 50%      235 ms
  90%      253 ms
  95%      259 ms
  99%      355 ms
 100%      421 ms (longest request)
```

Here (when `n` = `5000000`), the app was able to run `410` requests per second, compared to `114` of the app with no clusters, with a latency of `229.9`, compared with `828.9` of the other app.

Before moving on to the next section, let’s take a look at a scenario where clustering may not offer much performance improvement.

We’ll run two more tests for each of our apps. We’ll test requests that aren’t CPU-intensive and that run fairly quickly without overloading the Event Loop.

With the no-cluster app running, execute the following test:

```sh
$ loadtest http://localhost:3000/api/50 -n 1000 -c 100
```

The following represents the summarized results:

```
Total time:          0.531421648 s
Requests per second: 1882
Mean latency:        50 ms
```

With the same no-cluster app still running, execute the following test:

```sh
$ loadtest http://localhost:3000/api/5000 -n 1000 -c 100
```

Here are the summarized results:

```
Total time:          0.50637567 s
Requests per second: 1975
Mean latency:        47.6 ms
```

Now, stop the app and run the clustered one once more.

With the cluster app running, execute the following test:

```sh
$ loadtest http://localhost:3000/api/50 -n 1000 -c 100
```

The summarized results:

```
Total time:          0.598028941 s
Requests per second: 1672
Mean latency:        56.6 ms
```

The clustered app ran `1672` requests per second compared to `1882` of the no-cluster one and had a mean latency of `56.6` milliseconds compared to `50` of the no-cluster one.

Let’s run the other test. With the same cluster app still running, execute the test below:

```sh
$ loadtest http://localhost:3000/api/5000 -n 1000 -c 100
```

The summarized results:

```
Total time:          0.5703417869999999 s
Requests per second: 1753
Mean latency:        53.7 ms
```

Here, the clustered app ran `1753` requests per second compared to `1975` of the no-cluster one and had a mean latency of `53.7` milliseconds compared to `47.6` of the no-cluster one.

Based on those tests, you can see that clustering didn’t offer much improvement to the app’s performance. In fact, the clustered app performed a bit worse compared to the one that doesn’t use clusters. How come?

In the tests above, we call our API with a fairly small value for `n`, which means that the number of times the loop in our code will run is considerably small. The operation won’t be that CPU-intensive. Clustering shines when it comes to CPU-intensive tasks. When your app is likely to run such tasks, then clustering will offer an advantage in terms of the number of such tasks it can run at a time.

However, if your app isn’t running a lot of CPU-intensive tasks, then it might not be worth the overhead to spawn up so many workers. Remember, each process you create has its own memory and V8 instance. Because of the additional resource allocations, spawning a large number of child Node.js processes is not always recommended.

In our example, the clustered app performs a bit worse than the no-cluster app because we are paying the overhead for creating several child processes that don’t offer much advantage. In a real-world situation, you can use this to determine which apps in your microservice architecture could benefit from clustering — run tests to check if the benefits for the extra complexity are worth it.

## Using PM2 to Manage a Node.js Cluster

In our app, we are using the Node.js `cluster` module to manually create and manage worker processes. We first determine the number of workers to spawn (using the number of CPU cores), then manually spawn the workers, and finally, listen for any dead workers so we can spawn new ones. In our very simple app, we’ve had to write a decent amount of code just to handle clustering. In a production app, you can expect to write even more.

There is a tool that can help manage the process a bit better — the [PM2](https://pm2.keymetrics.io/) process manager. PM2 is a Production Process Manager for Node.js applications with a built-in Load Balancer. When properly configured, PM2 will automatically run your app in cluster mode, spawn workers for you, and take care of spawning new workers when a worker dies. PM2 makes it easy to stop, delete, and start processes and it also has some monitoring tools that can help you to monitor and tweak your app’s performance.

To use PM2, first install it globally:

```sh
$ npm install pm2 -g
```

We’ll use it to run our first unmodified app:

```js
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello World!');
})

app.get('/api/:n', function (req, res) {
  let n = parseInt(req.params.n);
  let count = 0;

  if (n > 5000000000) n = 5000000000;

  for(let i = 0; i <= n; i++){
    count += i;
  }

  res.send(`Final count is ${count}`);
})

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
})
```

Run the app with:

```sh
$ pm2 start app.js -i 0
```

`-i <number of workers>` will tell PM2 to launch the app in `cluster_mode` (as opposed to `fork_mode`). If `<number of workers>` is set to `0`, PM2 will automatically spawn as many workers as there are CPU cores.

And just like that, your app is running in cluster mode — no need for code changes. You can now run the same tests of the previous sections after which you can expect the same results of the app that used clusters. Behind the scenes, PM2 also uses the Node.js `cluster` module as well as other tools that make process management easier.

In the Terminal, you’ll get a table displaying some details of the spawned processes:

![PM2 Cluster](https://d33wubrfki0l68.cloudfront.net/95a8689e159614b649e45f6f24bb12f1ecf6ae3a/83cd2/images/blog/2021-02/pm2_cluster.png)

You can stop the app with the following command:

```sh
$ pm2 stop app.js
```

The app will go offline and the Terminal output will show all processes with a `stopped` status.

![Stopped app](https://d33wubrfki0l68.cloudfront.net/3f2289bd93daf31b044a86b88c1966da0ac07fd4/91949/images/blog/2021-02/stopped_app.png)

Rather than always passing in configurations when you run the app with `pm2 start app.js -i 0`, you can save them to a separate configuration file — called [Ecosystem File](https://pm2.keymetrics.io/docs/usage/application-declaration/#ecosystem-file). The file also allows you to set up specific configurations for different applications, which can be particularly useful for micro-service apps, for example.

You can generate an Ecosystem File with the following command:

```sh
$ pm2 ecosystem
```

It will generate a file named `ecosystem.config.js`. As for our app, we need to modify it as shown below:

```js
module.exports = {
  apps : [{
    name: "app",
    script: "app.js",
    instances : 0,
    exec_mode : "cluster"
  }]
}
```

By setting `exec_mode` with the `cluster` value, you instruct PM2 to load balance between each instance. The `instances` are set to `0` just as before, which will spawn as many workers as there are CPU cores.

The `-i` or `instances` option can be set to:

* `0` or `max` (deprecated) to spread the app across all CPUs
* `-1` to spread the app across all CPUs - 1
* `number` to spread the app across a `number` of CPUs

You can now run the app with:

```sh
$ pm2 start ecosystem.config.js
```

The app will run in cluster mode, just as before.

You can start, restart, reload, stop and delete an app with the following commands, respectively:

```sh
$ pm2 start app_name
$ pm2 restart app_name
$ pm2 reload app_name
$ pm2 stop app_name
$ pm2 delete app_name

# When using an Ecosystem file:

$ pm2 [start|restart|reload|stop|delete] ecosystem.config.js
```

The `restart` command immediately kills and restarts the processes while the `reload` command achieves a 0-second-downtime reload where workers are restarted one by one, waiting for a new worker to spawn before killing the old one.

You can also check the status, logs, and metrics of running applications.

The following lists the status of all application managed by PM2:

```sh
$ pm2 ls
```

The following displays logs in realtime:

```sh
$ pm2 logs
```

The following displays a realtime dashboard in your Terminal:

```sh
$ pm2 monit
```

For more on PM2 and its [cluster mode](https://pm2.keymetrics.io/docs/usage/cluster-mode/), check the [documentation](https://pm2.io/blog/2018/04/20/Node-js-clustering-made-easy-with-PM2).

## Conclusion

Clustering offers a way of improving your Node.js app performance by making use of system resources in a more efficient way. We saw noticeable improvements in throughput when an app was modified to use clusters. We then took a brief look at a tool that can help you make the process of managing clusters a bit easier. I hope this article was useful to you. For more on clustering, check the [cluster module](https://nodejs.org/api/cluster.html) documentation and [PM2’s](https://pm2.keymetrics.io/docs/usage/quick-start/) documentation. You can also check out this [tutorial](https://leanpub.com/thenodejsclustermodule/read).

**Our guest author Joyce Echessa is a full stack web developer. She occasionally puts down her thoughts in technical articles as a way of documenting the various things she’s learned.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
