> * 原文地址：[Using Node.js to Read Really, Really Large Files (Pt 1)](https://itnext.io/using-node-js-to-read-really-really-large-files-pt-1-d2057fe76b33)
> * 原文作者：[Paige Niedringhaus](https://medium.com/@paigen11)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-node-js-to-read-really-really-large-files-pt-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-node-js-to-read-really-really-large-files-pt-1.md)
> * 译者：
> * 校对者：

# Using Node.js to Read Really, Really Large Files (Pt 1)

![](https://cdn-images-1.medium.com/max/3686/1*-Nq1fQSPq9aeoWxn4WFbhg.png)

This blog post has an interesting inspiration point. Last week, someone in one of my Slack channels, posted a coding challenge he’d received for a developer position with an insurance technology company.

It piqued my interest as the challenge involved reading through very large files of data from the Federal Elections Commission and displaying back specific data from those files. Since I’ve not worked much with raw data, and I’m always up for a new challenge, I decided to tackle this with Node.js and see if I could complete the challenge myself, for the fun of it.

Here’s the 4 questions asked, and a link to the data set that the program was to parse through.

* Write a program that will print out the total number of lines in the file.
* Notice that the 8th column contains a person’s name. Write a program that loads in this data and creates an array with all name strings. Print out the 432nd and 43243rd names.
* Notice that the 5th column contains a form of date. Count how many donations occurred in each month and print out the results.
* Notice that the 8th column contains a person’s name. Create an array with each first name. Identify the most common first name in the data and how many times it occurs.

Link to the data: ​[https://www.fec.gov/files/bulk-downloads/2018/indiv18.zip](https://www.fec.gov/files/bulk-downloads/2018/indiv18.zip)

When you unzip the folder, you should see one main `.txt` file that’s 2.55GB and a folder containing smaller pieces of that main file (which is what I used while testing my solutions before moving to the main file).

Not too terrible, right? Seems doable. So let’s talk about how I approached this.

#### The Two Original Node.js Solutions I Came Up With

Processing large files is nothing new to JavaScript, in fact, in the core functionality of Node.js, there are a number of standard solutions for reading and writing to and from files.

The most straightforward is [`fs.readFile()`](https://nodejs.org/api/fs.html#fs_fs_readfile_path_options_callback) wherein, the whole file is read into memory and then acted upon once Node has read it, and the second option is [`fs.createReadStream()`](https://nodejs.org/api/fs.html#fs_fs_createreadstream_path_options), which streams the data in (and out) similar to other languages like Python and Java.

#### The Solution I Chose to Run With & Why

Since my solution needed to involve such things as counting the total number of lines and parsing through each line to get donation names and dates, I chose to use the second method: `fs.createReadStream()`. Then, I could use the [`rl.on(‘line’,...)`](https://nodejs.org/api/readline.html#readline_event_line) function to get the necessary data from each line of code as I streamed through the document.

It seemed easier to me, than having to split apart the whole file once it was read in and run through the lines that way.

#### Node.js CreateReadStream() & ReadFile() Code Implementation

Below is the code I came up with using Node.js’s `fs.createReadStream()` function. I’ll break it down below.

![](https://cdn-images-1.medium.com/max/2704/1*szFus-f7Xllx17AuSc_TQw.png)

The very first things I had to do to set this up, were import the required functions from Node.js: `fs` (file system), `readline`, and `stream`. These imports allowed me to then create an `instream` and `outstream` and then the `readLine.createInterface()`, which would let me read through the stream line by line and print out data from it.

I also added some variables (and comments) to hold various bits of data: a `lineCount`, `names` array, `donation` array and object, and `firstNames` array and `dupeNames` object. You’ll see where these come into play a little later.

Inside of the `rl.on('line',...)` function, I was able to do all of my line-by-line data parsing. In here, I incremented the `lineCount` variable for each line it streamed through. I used the JavaScript `split()` method to parse out each name and added it to my `names` array. I further reduced each name down to just first names, while accounting for middle initials, multiple names, etc. along with the first name with the help of the JavaScript `trim()`, `includes()` and `split()` methods. And I sliced the year and date out of date column, reformatted those to a more readable `YYYY-MM` format, and added them to the `dateDonationCount` array.

In the `rl.on('close',...)` function, I did all the transformations on the data I’d gathered into arrays and `console.log`ged out all my data for the user to see.

The `lineCount` and `names` at the 432nd and 43,243rd index, required no further manipulation. Finding the most common name and the number of donations for each month was a little trickier.

For the most common first name, I first had to create an object of key value pairs for each name (the key) and the number of times it appeared (the value), then I transformed that into an array of arrays using the ES6 function `Object.entries()`. From there, it was a simple task to sort the names by their value and print the largest value.

Donations also required me to make a similar object of key value pairs, create a `logDateElements()` function where I could nicely using ES6’s string interpolation to display the keys and values for each donation month. And then create a `new Map()` transforming the `dateDonations` object into an array of arrays, and looping through each array calling the `logDateElements()` function on it. Whew! Not quite as simple as I first thought.

But it worked. At least with the smaller 400MB file I was using for testing…

After I’d done that with `fs.createReadStream()`, I went back and also implemented my solutions with `fs.readFile()`, to see the differences. Here’s the code for that, but I won’t go through all the details here — it’s pretty similar to the first snippet, just more synchronous looking (unless you use the `fs.readFileSync()` function, though, JavaScript will run this code just as asynchronously as all its other code, not to worry.

![](https://cdn-images-1.medium.com/max/2704/1*mLYx43qMKJBpbZ8TUp_qrA.png)

If you’d like to see my full repo with all my code, you can see it [here](https://github.com/paigen11/file-read-challenge).

#### Initial Results from Node.js

With my working solution, I added the file path into `readFileStream.js` file for the 2.55GB monster file, and watched my Node server crash with a `JavaScript heap out of memory` error.

![Fail. Whomp whomp…](https://cdn-images-1.medium.com/max/5572/1*S26hQHQCuzlPDHMnDR_s3g.png)

As it turns out, although Node.js is streaming the file input and output, in between it is still attempting to hold the entire file contents in memory, which it can’t do with a file that size. Node can hold up to 1.5GB in memory at one time, but no more.

So neither of my current solutions was up for the full challenge.

I needed a new solution. A solution for even larger datasets running through Node.

#### The New Data Streaming Solution

I found my solution in the form of [`EventStream`](https://www.npmjs.com/package/event-stream), a popular NPM module with over 2 million weekly downloads and a promise “to make creating and working with streams easy”.

With a little help from EventStream’s documentation, I was able to figure out how to, once again, read the code line by line and do what needed to be done, hopefully, in a more CPU friendly way to Node.

#### EventStream Code Implementation

Here’s my code new code using the NPM module EventStream.

![](https://cdn-images-1.medium.com/max/2704/1*iZFzB0v46FoAaMTR0ANrCQ.png)

The biggest change was the pipe commands at the beginning of the file — all of that syntax is the way EventStream’s documentation recommends you break up the stream into chunks delimited by the `\n` character at the end of each line of the `.txt` file.

The only other thing I had to change was the `names` answer. I had to fudge that a little bit since if I tried to add all 13MM names into an array, I again, hit the out of memory issue. I got around it, by just collecting the 432nd and 43,243rd names and adding them to their own array. Not quite what was being asked, but hey, I had to get a little creative.

#### Results from Node.js & EventStream: Round 2

Ok, with the new solution implemented, I again, fired up Node.js with my 2.55GB file and my fingers crossed this would work. Check out the results.

![Woo hoo!](https://cdn-images-1.medium.com/max/2000/1*HJBlTYxNUCPXCDeKI9RTMg.png)

Success!

#### Conclusion

In the end, Node.js’s pure file and big data handling functions fell a little short of what I needed, but with just one extra NPM package, EventStream, I was able to parse through a massive dataset without crashing the Node server.

Stay tuned for [part two](https://bit.ly/2JdcO2g) of this series where I compare my three different ways of reading data in Node.js with performance testing to see which one is truly superior to the others. The results are pretty eye opening — especially as the data gets larger…

Thanks for reading, I hope this gives you an idea of how to handle large amounts of data with Node.js. Claps and shares are very much appreciated!

**If you enjoyed reading this, you may also enjoy some of my other blogs:**

* [Postman vs. Insomnia: Comparing the API Testing Tools](https://medium.com/@paigen11/postman-vs-insomnia-comparing-the-api-testing-tools-4f12099275c1)
* [How to Use Netflix’s Eureka and Spring Cloud for Service Registry](https://medium.com/@paigen11/how-to-use-netflixs-eureka-and-spring-cloud-for-service-registry-8b43c8acdf4e)
* [Jib: Getting Expert Docker Results Without Any Knowledge of Docker](https://medium.com/@paigen11/jib-getting-expert-docker-results-without-any-knowledge-of-docker-ef5cba294e05)

---

**References and Further Resources:**

* Node.js Documentation, File System: [https://nodejs.org/api/fs.html](https://nodejs.org/api/fs.html)
* Node.js Documentation, Readline: [https://nodejs.org/api/readline.html#readline_event_line](https://nodejs.org/api/readline.html#readline_event_line)
* Github, Read File Repo: [https://github.com/paigen11/file-read-challenge](https://github.com/paigen11/file-read-challenge)
* NPM, EventSream: [https://www.npmjs.com/package/event-stream](https://www.npmjs.com/package/event-stream)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
