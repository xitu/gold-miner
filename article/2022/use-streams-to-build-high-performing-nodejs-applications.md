> * 原文地址：[Use Streams to Build High-Performing Node.js Applications](https://blog.appsignal.com/2022/02/02/use-streams-to-build-high-performing-nodejs-applications.html)
> * 原文作者：[Deepal Jayasekara](https://blog.appsignal.com/authors/deepal-jayasekara)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/use-streams-to-build-high-performing-nodejs-applications.md](https://github.com/xitu/gold-miner/blob/master/article/2022/use-streams-to-build-high-performing-nodejs-applications.md)
> * 译者：
> * 校对者：

# Use Streams to Build High-Performing Node.js Applications

The moment you type something on a keyboard, read a file from a disk or download a file over the internet, a stream of information (bits) flows through different devices and applications.

If you learn to work with these streams of bits, you'll be able to build performant and valuable applications. For example, think of when you watch a video on YouTube. You don't have to wait until the full video downloads. Once a small amount buffers, it starts to play, and the rest keeps on downloading as you watch.

Node.js includes a built-in module called `stream` which lets us work with streaming data. In this article, we will explain how you can use the `stream` module with some simple examples. We'll also describe how you can build pipelines gluing different streams together to build performant applications for complex use cases.

Before we dive into building applications, it's important to understand the features provided by the Node.js `stream` module.

Let's get going!

## Types of Node.js Streams

Node.js `streams` provides four types of streams:

* Readable Streams
* Writable Streams
* Duplex Streams
* Transform Streams

[See the official Node.js docs for more detail on the types of streams](https://nodejs.org/api/stream.html#stream_types_of_streams).

Let's look at each stream type at a high level.

### Readable Streams

A readable stream can read data from a particular data source, most commonly, from a file system. Other common uses of readable streams in Node.js applications are:

* `process.stdin` - To read user input via `stdin` in a terminal application.
* `http.IncomingMessage` - To read an incoming request's content in an HTTP server or to read the server HTTP response in an HTTP client.

### Writable Streams

You use writable streams to write data from an application to a specific destination, for example, a file.

`process.stdout` can be used to write data to standard output and is used internally by `console.log`.

Next up are duplex and transform streams, which you can define as 'hybrid' stream types built on readable and writable streams.

### Duplex Streams

A duplex stream is a combination of both readable and writable streams. It provides the capability to write data to a particular destination and read data from a source. The most common example of a duplex stream is `net.Socket`, used to read and write data to and from a socket.

It's important to know that readable and writable sides operate independently from one another in a duplex stream. The data does not flow from one side to the other.

### Transform Streams

A transform stream is slightly similar to a duplex stream, but the readable side is connected to the writable side in a transform stream.

A good example would be the `crypto.Cipher` class which implements an encryption stream. Using a `crypto.Cipher` stream, an application can write plain text data into the writable side of a stream and read encrypted ciphertext out of the readable side of the stream. The transformative nature of this type of stream is why they are called 'transform streams'.

**Side-note**: Another transform stream is `stream.PassThrough`, which passes data from the writable side to the readable side without any transformation. Though this might sound trivial, Passthrough streams are very useful for building custom stream implementations and pipelines (e.g., creating multiple copies of one stream's data).

## Read Data From Readable Node.js Streams

Once a readable stream is 'connected' to a source that generates data (e.g., a file), there are a few ways to read data through the stream.

First, let's create a sample text file named `myfile`, with 85 bytes of 'lorem ipsum' text:

```
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur nec mauris turpis.
```

Now, let's look at two different methods of reading data from a readable stream.

### 1. Listen to 'data' Events

The most common way to read data from a readable stream is by listening to `'data'` events emitted by the stream. The following program demonstrates this approach:

```js
const fs = require('fs')
const readable = fs.createReadStream('./myfile', { highWaterMark: 20 });

readable.on('data', (chunk) => {
    console.log(`Read ${chunk.length} bytes\n"${chunk.toString()}"\n`);
})
```

The `highWaterMark` property, passed as an option to `fs.createReadStream`, determines how much data buffers inside the stream. The data is then flushed to the reading mechanism (in this case, our `data` handler). By default, readable `fs` streams have their `highWaterMark` set to 64kB. We deliberately override this to 20 bytes to trigger multiple `data` events.

If you run the above program, it will read 85 bytes from `myfile` in five iterations. You will see the following output in the console:

```
Read 20 bytes
"Lorem ipsum dolor si"

Read 20 bytes
"t amet, consectetur "

Read 20 bytes
"adipiscing elit. Cur"

Read 20 bytes
"abitur nec mauris tu"

Read 5 bytes
"rpis."
```

### 2. Use Async Iterators

An alternative way of reading data from a readable stream is by using async iterators:

```js
const fs = require('fs')
const readable = fs.createReadStream('./myfile', { highWaterMark: 20 });

(async () => {
    for await (const chunk of readable) {
        console.log(`Read ${chunk.length} bytes\n"${chunk.toString()}"\n`);
    }
})()
```

If you run this program, you will get the same output as the previous example.

## State of a Readable Node.js Stream

When a listener is attached to a readable stream's `'data'` events, the stream switches to a 'flowing' state (unless it is explicitly paused). You can inspect the stream's flowing state using the stream object's `readableFlowing` property.

We can demonstrate this using a slightly modified version of our previous example with the `'data'` handler:

```js
const fs = require('fs')
const readable = fs.createReadStream('./myfile', { highWaterMark: 20 });

let bytesRead = 0

console.log(`before attaching 'data' handler. is flowing: ${readable.readableFlowing}`);
readable.on('data', (chunk) => {
    console.log(`Read ${chunk.length} bytes`);
    bytesRead += chunk.length

    // Pause the readable stream after reading 60 bytes from it.
    if (bytesRead === 60) {
        readable.pause()
        console.log(`after pause() call. is flowing: ${readable.readableFlowing}`);

        // resume the stream after waiting for 1s.
        setTimeout(() => {
            readable.resume()
            console.log(`after resume() call. is flowing: ${readable.readableFlowing}`);
        }, 1000)
    }
})
console.log(`after attaching 'data' handler. is flowing: ${readable.readableFlowing}`);
```

In this example, we read from `myfile` via a readable stream, but we temporarily 'pause' the data flow for 1s after reading 60 bytes from the file. We also log the value of the `readableFlowing` property at different times to understand how it changes.

If you run the above program, you will get the following output:

```
before attaching 'data' handler. is flowing: null
after attaching 'data' handler. is flowing: true
Read 20 bytes
Read 20 bytes
Read 20 bytes
after pause() call. is flowing: false
after resume() call. is flowing: true
Read 20 bytes
Read 5 bytes
```

We can explain the output as follows:

1. When our program starts, `readableFlowing` has the value `null` because we don't provide any mechanism of consuming from the stream.
2. After the 'data' handler is attached, the readable stream changes to 'flowing' mode, and `readableFlowing` changes to `true`.
3. Once 60 bytes are read, the stream is 'paused' by calling `pause()`, which, in turn, changes `readableFlowing` to `false`.
4. After waiting for 1s, the stream switches to 'flowing' mode again by calling `resume()`, changing `readableFlowing` to `true`. The rest of the file content then flows through the stream.

## Processing Large Amounts of Data with Node.js Streams

Thanks to streams, applications do not have to keep large blobs of information in memory: small chunks of data can be processed as they are received.

In this section, let's combine different streams to build a real-life application that can handle large amounts of data. We'll use a small utility program that generates an SHA-256 of a given file.

But first, let's create a large 4GB dummy file for testing. You can do this using a small shell command, as follows:

* On macOS: `mkfile -n 4g 4gb_file`
* On Linux: `xfs_mkfile 4096m 4gb_file`

After creating our dummy `4gb_file`, let's generate the SHA-256 hash of the file without using the `stream` module:

```js
const fs = require("fs");
const crypto = require("crypto");

fs.readFile("./4gb_file", (readErr, data) => {
  if (readErr) return console.log(readErr)
  const hash = crypto.createHash("sha256").update(data).digest("base64");
  fs.writeFile("./checksum.txt", hash, (writeErr) => {
    writeErr && console.error(err)
  });
});
```

If you run the above code, you may get the following error:

```
RangeError [ERR_FS_FILE_TOO_LARGE]: File size (4294967296) is greater than 2 GB
    at FSReqCallback.readFileAfterStat [as oncomplete] (fs.js:294:11) {
  code: 'ERR_FS_FILE_TOO_LARGE'
}
```

The above error occurs because the JavaScript runtime cannot handle arbitrarily large buffers. The max size of a buffer that the runtime can handle depends on your operating system architecture. You can check this by using the [`buffer.constants.MAX_LENGTH`](https://nodejs.org/api/buffer.html#bufferconstantsmax_length) variable in the built-in `buffer` module.

Even if we didn't see the above error, keeping large files in memory is problematic. The physical memory we have available will restrict the amount of memory our application can use. High memory usage can also cause poor application performance in terms of CPU usage, as garbage collection becomes expensive.

## Reduce Your App's Memory Footprint Using `pipeline()`

Now, let's look at how we can modify our application to use streams and avoid encountering this error:

```js
const fs = require("fs");
const crypto = require("crypto");
const { pipeline } = require("stream");

const hashStream = crypto.createHash("sha256");
hashStream.setEncoding('base64')

const inputStream = fs.createReadStream("./4gb_file");
const outputStream = fs.createWriteStream("./checksum.txt");

pipeline(
    inputStream,
    hashStream,
    outputStream,
    (err) => {
        err && console.error(err)
    }
)
```

In this example, we use the streaming approach provided by the `crypto.createHash` function. It returns a "transform stream" object `hashStream`, generating hashes for arbitrarily large files.

To feed the file content into this transform stream, we have created a readable stream — `inputStream` — to `4gb_file` using `fs.createReadStream`. We pipe the output from the `hashStream` transform stream to the writable `outputStream` and the `checksum.txt`, created using `fs.createWriteStream`.

If you run the above application, you will see that the `checksum.txt` file populates with the SHA-256 hash of our 4GB file.

### Using `pipeline()` vs `pipe()` for Streams

In our previous example, we used the `pipeline` function to connect multiple streams. An alternative common approach is to use the `.pipe()` function, as shown below:

```js
inputStream
  .pipe(hashStream)
  .pipe(outputStream)
```

However, using `.pipe()` in production applications is not recommended for several reasons. If one of the piped streams is closed or throws an error, `pipe()` will not automatically destroy the connected streams. This can cause memory leaks in applications. Also, `pipe()` does not automatically forward errors across streams to be handled in one place.

`pipeline()` was introduced to cater for these problems, so it's recommended you use `pipeline()` instead of `pipe()` to connect multiple streams. We can rewrite the above `pipe()` example to use the `pipeline()` function, as follows:

```js
pipeline(
    inputStream,
    hashStream,
    outputStream,
    (err) => {
        err && console.error(err)
    }
)
```

`pipeline()` accepts a callback function as the last parameter. Any forwarded errors from any of the piped streams will call the callback, so it's easier to handle errors for all streams in one place.

## Wrap Up: Reduce Memory and Improve Performance Using Node.js Streams

Using streams in Node.js helps us build performant applications that can handle large amounts of data.

In this article, we covered:

* The four types of Node.js streams (readable, writable, duplex, and transform streams).
* How you can read data from readable Node.js streams by either listening to 'data' events or using async iterators.
* Reducing the memory footprint of your applications by using `pipeline` to connect multiple streams.

**A quick, small word of warning**: You likely won't encounter many situations where streams are a necessity, and a stream-based approach can increase the complexity of your application. Make sure you confirm that the benefits of using streams outweigh the complexity they'll bring.

I'd encourage you to [read the official Node.js `stream` documentation](https://nodejs.org/api/stream.html#stream) to learn more and to explore more advanced use cases of streams out there.

Happy coding!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
