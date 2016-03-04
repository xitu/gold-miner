>* 原文链接 : [2016 - the year of web streams](https://jakearchibald.com/2016/streams-ftw/)
* 原文作者 : [Jake](https://github.com/jakearchibald/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态： 认领中


Yeah, ok, it's a touch bold to talk about something being _the thing of the year_ as early as January, but the potential of the web streams API has gotten me all excited.

TL;DR: Streams can be used to do fun things like [turn clouds to butts](#cloud-to-butt), [transcode MPEG to GIF](#mpeg-to-gif), but most importantly, they can be combined with service workers to become [_the fastest_ way to serve content](#streaming-results).

## Streams, huh! What are they good for?

Absolutely… some things.

Promises are a great way to represent async delivery of a single value, but what about representing multiple values? Or multiple parts of larger value that arrives gradually?

Say we wanted to fetch and display an image. That involves:

1.  Fetching some data from the network
2.  Processing it, turning it from compressed data into raw pixel data
3.  Rendering it

We could do this one step at a time, or we could stream it:

<img src="http://ww4.sinaimg.cn/large/675f4a91jw1f1ih0ffq90g20jn0c0tk2.gif"/>

If we handle & process the response bit by bit, we get to render _some_ of the image way sooner. We even get to render the whole image sooner, because the processing can happen in parallel with the fetching. This is streaming! We're _reading_ a stream from the network, _transforming_ it from compressed data to pixel data, then _writing_ it to the screen.

You could achieve something similar with events, but streams come with benefits:

*   **Start/end aware** - although streams can be infinite
*   **Buffering of values that haven't been read** - whereas events that happen before listeners are attached are lost
*   **Chaining via piping** - you can pipe streams together to form an async sequence
*   **Built-in error handling** - errors will be propagated down the pipe
*   **Cancellation support** - and that cancellation message is passed back up the pipe
*   **Flow control** - you can react to the speed of the reader

That last one is really important. Imagine we were using streams to download and display a video. If we can download and decode 200 frames of video per second, but only want to display 24 frames a second, we could end up with a huge backlog of decoded frames and run out of memory.

This is where flow control comes in. The stream that's handling the rendering is pulling frames from the decoder stream 24 times a second. The decoder notices that it's producing frames faster than they're being read, and slows down. The network stream notices that it's fetching data faster than it's being read by the decoder, and slows the download.

Because of the tight relationship between stream & reader, a stream can only have one reader. However, an unread stream can be "teed", meaning it's split into two streams that receive the same data. In this case, the tee manages the buffer across both readers.

Ok, that's the theory, and I can see you're not ready to hand over that 2016 trophy just yet, but stay with me.

The browser streams loads of things by default. Whenever you see the browser displaying parts of a page/image/video as it's downloading, that's thanks to streaming. However, it's only recently, thanks to a [standardisation effort](https://streams.spec.whatwg.org/), that streams are becoming exposed to script.

## Streams + the fetch API

[`Response`](https://developer.mozilla.org/en-US/docs/Web/API/Response) objects, as defined by the [fetch spec](https://fetch.spec.whatwg.org/#response-class), let you read the response as a variety of formats, but `response.body` gives you access to the underlying stream. `response.body` is supported in the current stable version of Chrome.

Say I wanted to get the content-length of a response, without relying on headers, and without keeping the whole response in memory. I could do it with streams:

    // fetch() resolves once headers have been received
    fetch(url).then(response => {
      // response.body is a readable stream.
      // Calling getReader() gives us exclusive access to
      // the stream's content
      var reader = response.body.getReader();
      var bytesReceived = 0;

      // read() resolves when content has been received
      reader.read().then(function processResult(result) {
        // Result objects contain two properties:
        // done  - true if the stream has already given
        //         you all its data.
        // value - some data. Always undefined when
        //         done is true.
        if (result.done) {
          console.log("Fetch complete");
          return;
        }

        // result.value for fetch streams is a Uint8Array
        bytesReceived += result.value.length;
        console.log('Received', bytesReceived, 'bytes of data so far');

        // Read some more, and call this function again
        return reader.read().then(processResult);
      });
    });

**[View demo](http://jsbin.com/vuqasa/edit?js,console)** (1.3mb)

The demo fetches 1.3mb of gzipped HTML from the server, which decompresses to 7.7mb. However, the result isn't held in memory. Each chunk's size is recorded, but the chunks themselves are garbage collected.

`result.value` is whatever the creator of the stream provides, which can be anything: a string, number, date, ImageData, DOM element… but in the case of a fetch stream it's always a [`Uint8Array`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Uint8Array) of binary data. The whole response is each `Uint8Array` joined together. If you want the response as text, you can use [`TextDecoder`](https://developer.mozilla.org/en-US/docs/Web/API/TextDecoder/TextDecoder):

    var decoder = new TextDecoder();
    var reader = response.body.getReader();

    // read() resolves when content has been received
    reader.read().then(function processResult(result) {
      if (result.done) return;
      console.log(
        decoder.decode(result.value, {stream: true})
      );

      // Read some more, and recall this function
      return reader.read().then(processResult);
    });

`{stream: true}` means the decoder will keep a buffer if `result.value` ends mid-way through a UTF-8 code point, since a character like ♥ is represented as 3 bytes: `[0xE2, 0x99, 0xA5]`.

`TextDecoder` is currently a little clumsy, but it's likely to become a transform stream in the future (once transform streams are defined). A transform stream is an object with a writable stream on `.writable` and a readable stream on `.readable`. It takes chunks into the writable, processes them, and passes something out through the readable. Using transform streams will look like this:

<style>.hypothetical-code { background: #732525; color: #fff; font-size: 0.8rem; margin: 1em -20px 0; padding: 7px 20px; } @media screen and (min-width: 530px) { .hypothetical-code { margin-left: -32px; margin-right: 0; padding-left: 32px; padding-right: 0; } } .hypothetical-code + .codehilite { margin-top: 0; }</style>

Hypothetical future-code:

    var reader = response.body
      .pipeThrough(new TextDecoder()).getReader();

    reader.read().then(result => {
      // result.value will be a string
    });

The browser should be able to optimise the above, since both the response stream and `TextDecoder` transform stream are owned by the browser.

### Cancelling a fetch

A stream can be cancelled using `stream.cancel()` (so `response.body.cancel()` in the case of fetch) or `reader.cancel()`. Fetch reacts to this by stopping the download.

**[View demo](https://jsbin.com/gameboy/edit?js,console)** (also, note the amazing random URL JSBin gave me).

This demo searches a large document for a term, only keeps a small portion in memory, and stops fetching once a match is found.

Anyway, this is all so 2015\. Here's the fun new stuff…

## Creating your own readable stream

In Chrome Canary with the "Experimental web platform features" flag enabled, you can now create your own streams.

    var stream = new ReadableStream({
      start(controller) {},
      pull(controller) {},
      cancel(reason) {}
    }, queuingStrategy);

*   `start` is called straight away. Use this to set up any underlying data sources (meaning, wherever you get your data from, which could be events, another stream, or just a variable like a string). If you return a promise from this and it rejects, it will signal an error through the stream.
*   `pull` is called when your stream's buffer isn't full, and is called repeatedly until it's full. Again, If you return a promise from this and it rejects, it will signal an error through the stream. Also, `pull` will not be called again until the returned promise fulfills.
*   `cancel` is called if the stream is cancelled. Use this to cancel any underlying data sources.
*   `queuingStrategy` defines how much this stream should ideally buffer, defaulting to one item - I'm not going to go into depth on this here, [the spec has more details](https://streams.spec.whatwg.org/#blqs-class).

As for `controller`:

*   `controller.enqueue(whatever)` - queue data in the stream's buffer.
*   `controller.close()` - signal the end of the stream.
*   `controller.error(e)` - signal a terminal error.
*   `controller.desiredSize` - the amount of buffer remaining, which may be negative if the buffer is over-full. This number is calculated using the `queuingStrategy`.

So if I wanted to create a stream that produced a random number every second, until it produced a number `> 0.9`, I'd do it like this:

    var interval;
    var stream = new ReadableStream({
      start(controller) {
        interval = setInterval(() => {
          var num = Math.random();

          // Add the number to the stream
          controller.enqueue(num);

          if (num > 0.9) {
            // Signal the end of the stream
            controller.close();
            clearInterval(interval);
          }
        }, 1000);
      },
      cancel() {
        // This is called if the reader cancels,
        //so we should stop generating numbers
        clearInterval(interval);
      }
    });

**[See it running](https://jsbin.com/fahavoz/edit?js,console)**. **Note:** You'll need Chrome Canary with `chrome://flags/#enable-experimental-web-platform-features` enabled.

It's up to you when to pass data to `controller.enqueue`. You could just call it whenever you have data to send, making your stream a "push source", as above. Alternatively you could wait until `pull` is called, then use that as a signal to collect data from the underlying source and then `enqueue` it, making your stream a "pull source". Or you could do some combination of the two, whatever you want.

Obeying `controller.desiredSize` means the stream is passing data along at the most efficient rate. This is known has having "backpressure support", meaning your stream reacts to the read-rate of the reader (like the video decoding example earlier). However, ignoring `desiredSize` won't break anything unless you run out of device memory. The spec has a good example of [creating a stream with backpressure support](https://streams.spec.whatwg.org/#example-rs-push-backpressure).

Creating a stream on its own isn't particularly fun, and since they're new, there aren't a lot of APIs that support them, but there is one:

    new Response(readableStream);

You can create an HTTP response object where the body is a stream, and you can use these as responses from a service worker!

## Serving a string, slowly

**[View demo](https://jakearchibald.github.io/isserviceworkerready/demos/simple-stream/)**. **Note:** You'll need Chrome Canary with `chrome://flags/#enable-experimental-web-platform-features` enabled.

You'll see a page of HTML rendering (deliberately) slowly. This response is entirely generated within a service worker. Here's the code:

    // In the service worker:
    self.addEventListener('fetch', event => {
      var html = '…html to serve…';

      var stream = new ReadableStream({
        start(controller) {
          var encoder = new TextEncoder();
          // Our current position in `html`
          var pos = 0;
          // How much to serve on each push
          var chunkSize = 1;

          function push() {
            // Are we done?
            if (pos >= html.length) {
              controller.close();
              return;
            }

            // Push some of the html,
            // converting it into an Uint8Array of utf-8 data
            controller.enqueue(
              encoder.encode(html.slice(pos, pos + chunkSize))
            );

            // Advance the position
            pos += chunkSize;
            // push again in ~5ms
            setTimeout(push, 5);
          }

          // Let's go!
          push();
        }
      });

      return new Response(stream, {
        headers: {'Content-Type': 'text/html'}
      });
    });

When the browser reads a response body it expects to get chunks of `Uint8Array`, it fails if passed something else like a plain string. Thankfully `TextEncoder` can take a string and returns a `Uint8Array` of bytes representing that string.

Like `TextDecoder`, `TextEncoder` should become a transform stream in future.

## Serving a transformed stream

Like I said, transform streams haven't been defined yet, but you can achieve the same result by creating a readable stream that produces data sourced from another stream.

### "Cloud" to "butt"

**[View demo](https://jakearchibald.github.io/isserviceworkerready/demos/transform-stream/)**. **Note:** You'll need Chrome Canary with `chrome://flags/#enable-experimental-web-platform-features` enabled.

What you'll see is [this page](https://jakearchibald.github.io/isserviceworkerready/demos/transform-stream/cloud.html) (taken from the cloud computing article on Wikipedia) but with every instance of "cloud" replaced with "butt". The benefit of doing this as a stream is you can get transformed content on the screen while you're still downloading the original.

[Here's the code](https://github.com/jakearchibald/isserviceworkerready/blob/master/src/demos/transform-stream/sw.js), including details on some of the edge-cases.

### MPEG to GIF

Video codecs are really efficient, but videos don't autoplay on mobile. GIFs autoplay, but they're huge. Well, here's a _really stupid_ solution:

**[View demo](https://jakearchibald.github.io/isserviceworkerready/demos/gif-stream/)**. **Note:** You'll need Chrome Canary with `chrome://flags/#enable-experimental-web-platform-features` enabled.

Streaming is useful here as the first frame of the GIF can be displayed while we're still decoding MPEG frames.

So there you go! A 26mb GIF delivered using only 0.9mb of MPEG! Perfect! Except it isn't real-time, and uses a lot of CPU. Browsers should really allow autoplaying of videos on mobile, especially if muted, and it's something Chrome is working towards right now.

Full disclosure: I cheated somewhat in the demo. It downloads the whole MPEG before it begins. I wanted to get it streaming from the network, but I ran into an `OutOfSkillError`. Also, the GIF really shouldn't loop while it's downloading, that's a bug we're looking into.

## Creating one stream from multiple sources to supercharge page render times

This is probably the most practical application of service worker + streams. The benefit is _huge_ in terms of performance.

A few months ago I built a [demo of an offline-first wikipedia](https://wiki-offline.jakearchibald.com/). I wanted to create a truly progressive web-app that worked fast, and added modern features as enhancements.

In terms of performance, the numbers I'm going to talk about are based on a lossy 3g connection simulated using OSX's Network Link Conditioner.

Without the service worker it displays content sent to it by the server. I put a lot of effort into performance here, and it paid off:

![](http://ww4.sinaimg.cn/large/a490147fjw1f1igoc3j3dj20np04b0t0.jpg)

**[View demo](https://wiki-offline.jakearchibald.com/wiki/Google?use-url-flags&prevent-sw=1)**

Not bad. I added a service worker to mix in some offline-first goodness and improve performance further. And the results?

![](http://ww3.sinaimg.cn/large/a490147fjw1f1igpzwl7cj20my04mdg8.jpg)

**[View demo](https://wiki-offline.jakearchibald.com/wiki/Google?use-url-flags&client-render=1&prevent-streaming=1&no-prefetch)**

So um, first render is faster, but there's a massive regression when it comes to rendering content.

The _fastest_ way would be to serve the entire page from the cache, but that involves caching all of Wikipedia. Instead, I served a page that contained the CSS, JavaScript and header, getting a fast initial render, then let the page's JavaScript set about fetching the article content. And that's where I lost all the performance - client-side rendering.

HTML renders as it downloads, whether it's served straight from a server or via a service worker. But I'm fetching the content from the page using JavaScript, then writing it to `innerHTML`, bypassing the streaming parser. Because of this, the content has to be fully downloaded before it can be displayed, and that's where the two second regression comes from. The more content you're downloading, the more the lack of streaming hurts performance, and unfortunately for me, Wikipedia articles are pretty big (the Google article is 100k).

This is why you'll see me whining about JavaScript-driven web-apps and frameworks - they tend to throw away streaming as step zero, and performance suffers as a result.

I tried to claw some performance back using prefetching and pseudo-streaming. The pseudo-streaming is particularly hacky. The page fetches the article content and reads it as a stream. Once it receives 9k of content, it's written to `innerHTML`, then it's written to `innerHTML` again once the rest of the content arrives. This is horrible as it creates some elements twice, but hey, it's worth it:

![](http://ww1.sinaimg.cn/large/a490147fjw1f1igqvtyyrj20n405vdgi.jpg)

**[View demo](https://wiki-offline.jakearchibald.com/wiki/Google?use-url-flags&client-render=1)**

So the hacks improve things but it still lags behind server render, which isn't really acceptable. Furthermore, content that's added to the page using `innerHTML` doesn't quite behave the same as regular parsed content. Notably, inline `<script>`s aren't executed.

This is where streams step in. Instead of serving an empty shell and letting JS populate it, I let the service worker construct a stream where the header comes from a cache, but the body comes from the network. It's like server-rendering, but in the service worker:

![](http://ww2.sinaimg.cn/large/a490147fjw1f1igs5zb6mj20me0743zb.jpg)

**[View demo](https://wiki-offline.jakearchibald.com/wiki/Google?sw-stream)**. **Note:** You'll need Chrome Canary with `chrome://flags/#enable-experimental-web-platform-features` enabled.

Using service worker + streams means you can get an almost-instant first render, then beat a regular server render by piping a smaller amount of content from the network. Content goes through the regular HTML parser, so you get streaming, and none of the behavioural differences you get with adding content to the DOM manually.

<img src="http://ww1.sinaimg.cn/large/675f4a91jw1f1ilwzss9vg207403gwga.gif"/>

### Crossing the streams

Because piping isn't supported yet, combining the streams has to be done manually, making things a little messy:

    var stream = new ReadableStream({
      start(controller) {
        // Get promises for response objects for each page part
        // The start and end come from a cache
        var startFetch = caches.match('/page-start.inc');
        var endFetch = caches.match('/page-end.inc');
        // The middle comes from the network, with a fallback
        var middleFetch = fetch('/page-middle.inc')
          .catch(() => caches.match('/page-offline-middle.inc'));

        function pushStream(stream) {
          // Get a lock on the stream
          var reader = stream.getReader();

          return reader.read().then(function process(result) {
            if (result.done) return;
            // Push the value to the combined stream
            controller.enqueue(result.value);
            // Read more & process
            return read().then(process);
          });
        }

        // Get the start response
        startFetch
          // Push its contents to the combined stream
          .then(response => pushStream(response.body))
          // Get the middle response
          .then(() => middleFetch)
          // Push its contents to the combined stream
          .then(response => pushStream(response.body))
          // Get the end response
          .then(() => endFetch)
          // Push its contents to the combined stream
          .then(response => pushStream(response.body))
          // Close our stream, we're done!
          .then(() => controller.close());
      }
    });

There are some templating languages such as [Dust.js](http://www.dustjs.com/) which stream their output, and also handle streams as values within the template, piping the content too and even HTML-escaping it on the fly. All that's missing is support for web streams.

## The future for streams

Aside from readable streams, the streams spec is still being developed, but what you can already do is pretty incredible. If you're wanting to improve the performance of a content-heavy site and provide an offline-first experience without rearchitecting, constructing streams within a service worker will become the easiest way to do it. It's how I intend to make this blog work offline-first anyway!

Having a stream primitive on the web means we'll start to get script access to all the streaming capabilities the browser already has. Things like:

*   Gzip/deflate
*   Audio/video codecs
*   Image codecs
*   The streaming HTML/XML parser

It's still early days, but if you want to start preparing your own APIs for streams, there's a [reference implementation](https://github.com/whatwg/streams/tree/master/reference-implementation/) that can be used as a polyfill in some cases.

Streaming is one of the browser's biggest assets, and 2016 is the year it's unlocked to JavaScript.
