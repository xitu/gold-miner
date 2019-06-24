> * 原文地址：[Streams For the Win: A Performance Comparison of NodeJS Methods for Reading Large Datasets (Pt 2)](https://itnext.io/streams-for-the-win-a-performance-comparison-of-nodejs-methods-for-reading-large-datasets-pt-2-bcfa732fa40e)
> * 原文作者：[Paige Niedringhaus](https://medium.com/@paigen11)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/streams-for-the-win-a-performance-comparison-of-nodejs-methods-for-reading-large-datasets-pt-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/streams-for-the-win-a-performance-comparison-of-nodejs-methods-for-reading-large-datasets-pt-2.md)
> * 译者：
> * 校对者：

# Streams For the Win: A Performance Comparison of NodeJS Methods for Reading Large Datasets (Pt 2)

## How readFile(), createReadStream() and event-stream Stack Up Against One Another

![](https://cdn-images-1.medium.com/max/2000/1*fsseXIPGEhwmg6kfgXyIjA.jpeg)

If you’ve been keeping up with my writing, a few weeks ago, I published a [blog](https://itnext.io/using-node-js-to-read-really-really-large-files-pt-1-d2057fe76b33) talking about a variety of ways to use Node.js to read really large datasets.

To my surprise, it did exceptionally well with readers — this seemed (to me) like a topic many others have already covered in posts, blogs and forums, but for whatever reason, it got the attention of a lot of people. So, thank you to all of you who took the time to read it! I really appreciate it.

One particularly astute reader ([Martin Kock](undefined)), went so far as to ask how long it took to parse the files. It seemed as if he’d read my mind, because part two of my series on using Node.js to read really, really large files and datasets involves just that.

> Here, I’ll evaluate the three different methods in Node.js I used to read the files, to determine which is most performant.

#### The Challenge From Part 1

I won’t go into the specifics of the challenge and solution, because you can read my first post for all the details [here](https://itnext.io/using-node-js-to-read-really-really-large-files-pt-1-d2057fe76b33), but I will give you the high level overview.

A person from a Slack channel I’m a member of, posted a coding challenge he’d received, which involved reading in a very large dataset (over 2.5GB in total), parsing through the data and pulling out various pieces of information.

It challenged programmers to print:

* Total lines in the file,
* Names in the 432nd and 43243rd indexes,
* Counts for total numbers donations per month,
* And the most common first name in the files and how a count of how often it occurred.

Link to the data: ​[https://www.fec.gov/files/bulk-downloads/2018/indiv18.zip](https://www.fec.gov/files/bulk-downloads/2018/indiv18.zip)

#### The Three Different Solutions Possible For Smaller Datasets

As I worked towards my ultimate end goal of processing a large dataset, I came up with three solutions in Node.js.

**Solution #1: [`fs.readFile()`](https://nodejs.org/api/fs.html#fs_fs_readfile_path_options_callback)**

The first involved Node.js’s native method of `fs.readFile()`, and consisted of reading in the whole file, holding it in memory and performing the operations on the entire file, then returning the results. At least for smaller files, it worked, but when I got to the largest file size, my server crashed with a JavaScript `heap out of memory` error.

**Solution #2: [fs.createReadStream()](https://nodejs.org/api/fs.html#fs_fs_createreadstream_path_options) & [rl.readLine()](https://nodejs.org/api/readline.html#readline_event_line)**

My second solution also involved another couple of methods native to Node.js: `fs.createReadStream()` and `rl.readLine()`. In this iteration, the file was streamed through Node.js in an `input` stream, and I was able to perform individual operations on each line, then cobble all those results together in the `output` stream. Again, this worked pretty well on smaller files, but once I got to the biggest file, the same error happened. Although Node.js was streaming the inputs and outputs, it still attempted to hold the whole file in memory while performing the operations (and couldn’t handle the whole file).

**Solution #3: [`event-stream`](https://www.npmjs.com/package/event-stream)**

In the end, I came up with only one solution in Node.js that was able to handle the full 2.55GB file I wanted to parse through, at one time.

> Fun fact: Node.js can only hold up to 1.67GB in memory at any one time, after that, it throws JavaScript `heap out of memory` error.

My solution involved a popular NPM package called [event-stream](https://www.npmjs.com/package/event-stream), which actually let me perform operations on the **throughput stream** of data, instead of just the input and output streams, as Node.js’s native capabilities allow.

You can see all three of my solutions [here](https://github.com/paigen11/file-read-challenge) in Github.

And I solved the problem, which was my initial goal, but it got me thinking: was my solution really the most performant of the three options?

#### Comparing Them To Find The Optimal Solution

Now, I had a new goal: determine which of my solutions was best.

Since I couldn’t use the full 2.55GB file with the Node.js native solutions, I chose to use one of the smaller files that was about 400MB worth of data, that I’d used for testing while I was developing my solutions.

For performance testing Node.js, I came across two ways to keep track of the file and individual function processing times, and I decided to incorporate both to see how great the differences were between the two methods (and make sure I wasn’t completely off the rails with my timing).

**[`console.time()`](https://nodejs.org/api/console.html#console_console_time_label) & [`console.timeEnd()`](https://nodejs.org/api/console.html#console_console_timeend_label)**

Node.js has some handy, built-in methods available to it for timing and performance testing, called `console.time()` and `console.timeEnd()`, respectively. To use these methods, I only had to pass in the same label parameter for both `time()` and `timeEnd()`, like so, and Node’s smart enough to output the time between them after the function’s done.

```
// timer start
console.time('label1');

// run function doing something in the code
doSomething();

// timer end, where the difference between the timer start and timer end is printed out
console.timeEnd('label1');

// output in console looks like: label1 0.002ms
```

That’s one method I used to figure out how long it took to process the dataset.

[**`performance-now`**](https://www.npmjs.com/package/performance-now)

The other, tried and well-liked performance testing module I came across for Node.js is hosted on NPM as [`performance-now`](https://www.npmjs.com/package/performance-now).

7+ million downloads per week from NPM, can’t be too wrong, right??

Implementing the `performance-now` module into my files was also almost as easy as the native Node.js methods, too. Import the module, set a variable for the start and end of the instantiation of the method, and compute the time difference between the two.

```
// import the performance-now module at the top of the file
const now = require('performance-now');

// set the start of the timer as a variable
const start = now();

// run function doing something in the code
doSomething();

// set the end of the timer as a variable
const end = now();

// Compute the duration between the start and end
console.log('Performance for timing for label:' + (end — start).toFixed(3) + 'ms';

// console output looks like: Performance for timing label: 0.002ms
```

I figured that by using both Node’s `console.time()` and `performance-now` at the same time, I could split the difference and get a pretty accurate read on how long my file parsing functions were really taking.

Below are code snippets implementing `console.time()` and `performance-now` in each of my scripts. These are only snippets of one function each — for the full code, you can see my repo [here](https://github.com/paigen11/file-read-challenge).

**Fs.readFile() Code Implementation Sample**

![](https://cdn-images-1.medium.com/max/2568/1*n48UZ77lvktwjN6IDR0x1g.png)

Since this script is using the `fs.readFile()` implementation, where the entire file is read into memory before any functions are executed on it, this is the most synchronous-looking code. It’s not actually synchronous, that’s an entirely separate Node method called `fs.readFileSync()`, it just resembles it .

But it’s easy to see the total line count of the file and the two timing methods bookending it to determine how long it takes to execute the line count.

**Fs.createReadStream() Code Implementation Sample**

**Input Stream (line-by-line):**

![](https://cdn-images-1.medium.com/max/2568/1*XwIXtNCMSmCJBu7DX4zxGA.png)

**Output Stream (once full file’s been read during input):**

![](https://cdn-images-1.medium.com/max/2568/1*rhhHpFIS5b-UdluXYgLaIg.png)

As the second solution using `fs.createReadStream()` involved creating an input and output stream for the file, I broke the code snippets into two separate screenshots, as the first is from the input stream (which is running through the code line by line) and the second’s the output stream (compiling all the resulting data).

**Event Stream Code Implementation Sample**

**Through Stream (also line-by-line):**

![](https://cdn-images-1.medium.com/max/2568/1*UzzXjaStCYMgUHHE_qBiqw.png)

**On Stream End:**

![](https://cdn-images-1.medium.com/max/2568/1*rgZQKTXROxXn6T9Gmqc0oA.png)

The `event-stream` solution looks pretty similar to the `fs.createReadStream()`, except instead of an **input stream**, the data is processed in a **throughput stream**. And then once the whole file’s been read and all the functions have been done on the file, the stream’s ended and the required information is printed out.

#### Results

Now on to the moment we’ve all been waiting for: the results!

I ran all three of my solutions against the same 400MB dataset, which contained almost 2 million records to parse through.

![Streams for the win!](https://cdn-images-1.medium.com/max/4056/1*K3fMjpvkyTMccexwsa3gjw.png)

As you can see from the table, `fs.createReadStream()` and `event-stream` both fared well, but overall, `event-stream` has to be the grand winner in my mind, if only for the fact that it can process much larger file sizes than either `fs.readFile()` or `fs.createReadStream()`.

The percentage improvements are included at the end of the table above as well, for reference.

`fs.readFile()` just got blown out of the water by the competition. By streaming the data, processing times for the file improved by at least 78% — sometimes close to almost a 100%, which is pretty darn, impressive.

Below are the raw screenshots from my terminal for each of my solutions.

**Solution #1: [`fs.readFile()`](https://nodejs.org/api/fs.html#fs_fs_readfile_path_options_callback)**

![The solution using only: fs.readFile()](https://cdn-images-1.medium.com/max/2000/1*luMWmrPikShHXtu6yScO9g.png)

**Solution #2: [fs.createReadStream()](https://nodejs.org/api/fs.html#fs_fs_createreadstream_path_options) & [rl.readLine()](https://nodejs.org/api/readline.html#readline_event_line)**

![The solution using fs.createReadStream() and rl.readLine()](https://cdn-images-1.medium.com/max/2000/1*rhF6hIxI7aE3VsMubmVUOQ.png)

**Solution #3: [`event-stream`](https://www.npmjs.com/package/event-stream)**

![The solution using event-stream](https://cdn-images-1.medium.com/max/2000/1*WzQIXZKNvGfrZzXtEP_31g.png)

**Bonus**

Here’s a screenshot of my `event-stream` solution churning through the 2.55GB monster file, as well. And here’s the time difference between the 400MB file and the 2.55GB file too.

![Look at those blazing fast speeds, even as the file size climbs by almost 6X.](https://cdn-images-1.medium.com/max/2548/1*Zxbn3FCHM59DrDvY7P6bXg.png)

**Solution #3: [`event-stream`](https://www.npmjs.com/package/event-stream) (on the 2.55GB file)**

![](https://cdn-images-1.medium.com/max/2000/1*v-7OzvyTjFTjrxnO0rXYiA.png)

#### Conclusion

In the end, streams both native to Node.js and not, are way, WAY more efficient at processing large data sets.

Thanks for coming back for part 2 of my series using Node.js to read really, really large files. If you’d like to read the first blog again, you can get it [here](https://itnext.io/using-node-js-to-read-really-really-large-files-pt-1-d2057fe76b33).

I’ll be back in a couple weeks with a new JavaScript topic — possibly debugging in Node or end-to-end testing with Puppeteer and headless Chrome, so please follow me for more content.

Thanks for reading, I hope this gives you an idea of how to handle large amounts of data with Node.js efficiently and performance test your solutions. Claps and shares are very much appreciated!

**If you enjoyed reading this, you may also enjoy some of my other blogs:**

* [Using Node.js to Read Really, Really Large Datasets & Files (Pt 1)](https://itnext.io/using-node-js-to-read-really-really-large-files-pt-1-d2057fe76b33)
* [Sequelize: The ORM for Sequel Databases with Node.js](https://medium.com/@paigen11/sequelize-the-orm-for-sql-databases-with-nodejs-daa7c6d5aca3)
* [Why a Spring Cloud Config Server is Crucial to a Good CI/CD Pipeline and How To Set It Up (Pt 1)](https://medium.com/@paigen11/why-a-cloud-config-server-is-crucial-to-a-good-ci-cd-pipeline-and-how-to-set-it-up-pt-1-fa628a125776)

---

**References and Further Resources:**

* Github, Read File Repo: [https://github.com/paigen11/file-read-challenge](https://github.com/paigen11/file-read-challenge)
* Node.js Documentation, File System: [https://nodejs.org/api/fs.html](https://nodejs.org/api/fs.html)
* Node.js Documentation, Console.Time: [https://nodejs.org/api/console.html#console_console_time_label](https://nodejs.org/api/console.html#console_console_time_label)
* NPM, Performance Now: [https://www.npmjs.com/package/performance-now](https://www.npmjs.com/package/performance-now)
* NPM, EventSream: [https://www.npmjs.com/package/event-stream](https://www.npmjs.com/package/event-stream)
* Link to the FEC data: [https://www.fec.gov/files/bulk-downloads/2018/indiv18.zip](https://www.fec.gov/files/bulk-downloads/2018/indiv18.zip)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
