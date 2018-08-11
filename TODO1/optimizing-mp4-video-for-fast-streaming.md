> * 原文地址：[Optimizing MP4 Video for Fast Streaming](https://rigor.com/blog/2016/01/optimizing-mp4-video-for-fast-streaming)
> * 原文作者：[BILLY HOFFMAN](https://rigor.com/blog/2016/01/optimizing-mp4-video-for-fast-streaming)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/optimizing-mp4-video-for-fast-streaming.md](https://github.com/xitu/gold-miner/blob/master/TODO1/optimizing-mp4-video-for-fast-streaming.md)
> * 译者：
> * 校对者：

# Optimizing MP4 Video for Fast Streaming

With the [decline of Flash](http://thenextweb.com/apps/2015/09/01/adobe-flash-just-took-another-step-towards-death-thanks-to-google/) and the [explosive rise of mobile devices](http://searchengineland.com/its-official-google-says-more-searches-now-on-mobile-than-on-desktop-220369), more and more content is being delivered as HTML5 video. You can optimize the speed of your site by [replacing animated GIF video clips with HTML5 videos](http://rigor.com/blog/2015/12/optimizing-animated-gifs-with-html5-video). However, video files themselves have a number of optimizations that you can make to improve their performance.

One of the most important is that video files must be properly optimized for streaming online as HTML5 video. Without this optimization videos can be delayed for hundreds of milliseconds and megabytes of bandwidth can be wasted by visitors just trying to play your videos. In this post I will show you how to optimize your video files for fast streaming.

## How MP4 Streaming Works

As discussed in [our last post](http://rigor.com/blog/2015/12/optimizing-animated-gifs-with-html5-video), HTML5 video is a cross-browser way to watch video without needing a plug-in like Flash. As of 2016, [H.264 encoded video stored in an MP4 container file](https://en.wikipedia.org/wiki/MPEG-4_Part_14) (which I’ll just simply call an MP4 video) has emerged as the standard format for all online HTML5 video. So when we talk about optimizing HTML5 video, what we are really talking about is how to optimize an MP4 video for faster playback. And the way we do that has to do with the structure of the MP4 file, and how streaming video works.

[MP4 files consist of chunks of data](http://www.adobe.com/devnet/video/articles/mp4_movie_atom.html) called _atoms_. There are atoms to store things like subtitles or chapters, as well as obvious things like the video and audio data. Meta data about where the video and audio atoms are, as well as information about how to play the video like the dimensions and frames per second, is all stored in a special atom called the `moov` atom. You can think of the `moov` atom as a kind of _table of contents_ for the MP4 file.

When you play a video, the program looks through the MP4 file, locates the `moov` atom , and then uses that to find the start of the audio and video data and begin playing. Unfortunately, atoms can appear in any order, so the program doesn’t know where the `moov` atom will be ahead of time. Searching to find the `moov` works fine if you already have the entire video file. However another option is needed when you don’t have the entire video yet, such as when you are _streaming_ HTML5 video. That’s the whole point of streaming a video! You can start watching it without having to download the entire video first.

When streaming, your browser requests the video and starts receiving the beginning of the file. It looks to see if the `moov` atom is near the start. If the `moov` atom is not near the start, it must either download the entire file to try and find the `moov`, or the browser can download small different pieces of the video file, starting with data from the very end, in an attempt to find the `moov` atom.

All this seeking around trying to find the `moov` wastes time and bandwidth. Unfortunately, the video cannot play until the `moov` is located. We can see in the screen shot below a waterfall chart of a browser trying to stream an unoptimized MP4 file using HTML5 video:

![mp4-no-moov](http://rigor.com/wp-content/uploads/2016/01/mp4-no-moov.png)

You can see the browser makes 3 requests before it can start playing the video. In the first request, the browser downloads the first 552 KB of the video using an [HTTP range request](https://en.wikipedia.org/wiki/Byte_serving). We can tell this by the 206 Partial Content HTTP response code, and by digging in and looking at the request headers. However the `moov` atom is not there so the browser cannot start to play the video. Next, the browser requests the final 21 KB of the video file using another range request. This does contain the `moov` atom, telling the browser where the video and audio streams start. Finally, the browser makes a third and final request to get the audio/video data and can start to play the video. This has wasted over half a megabyte of bandwidth and delayed the start of the video by 210 ms! Simply because the browser couldn’t find the `moov` atom.

It gets even worse if you haven’t configured your server to support HTTP range requests; the browser can’t skip around to find the `moov` and **must download the entire file**. This is yet another reason why your should [optimize your site with partial download support](https://zoompf.com/blog/2010/03/performance-tip-for-http-downloads).

The ideal way to prepare a MP4 video for HTML5 streaming is to organize the file so that the `moov` is at the very beginning. This way the browser can avoid downloading the entire movie or waste time making additional requests in an attempt to find the `moov`. The waterfall of a website with a streaming-optimized video looks like this:

![mp4-fast-start](http://rigor.com/wp-content/uploads/2016/01/mp4-fast-start.png)

With `moov` at the start of the file, the video will load and play faster, resulting in a better user experience.

## How to Optimize MP4 for Faster Streaming

We have seen that to optimize a video for HTML5 streaming, you need to reorganize the MP4 atoms so the `moov` atom is at the start. So how do we do that? Most video encoding software has an _“optimize for web”_ or _“optimize for streaming”_ option which does this very thing. You should look at your video encoding settings when creating video to ensure it is optimized. For example, in the screenshot below, we see the [open source video encoder Handbrake](https://handbrake.fr/) which has an option _“Web Optimized”_, which places the `moov` atom at the start:

![handbrake](http://rigor.com/wp-content/uploads/2016/01/handbrake.png)

This is a workable solution if you are creating the MP4 file from the original source video, but what if you already have an MP4 file?

You can also reorganize an existing video to optimize it for web streaming. For example, the [open source command line video encoder FFMpeg](https://www.ffmpeg.org/) can reorganize the structure of the MP4 file to place the `moov` atom at the start. Unlike the initial encoding of the video which is very time consuming and CPU intensive, reorganizing the file is an easier operation. And, it will not alter the quality of the original video in any way. Before is an example of using ffmpeg to optimize a video named _input.mp4_* for streaming. The resulting video is named _output.mp4_

```
ffmpeg -i input.mp4 -movflags faststart -acodec copy -vcodec copy output.mp4
```

The `-movflags faststart` parameter is what tells ffmpeg to reorder the MP4 video atoms so that `moov` is at the start. We are also instructing ffmpeg to copy the video and audio data instead of re-encoding them, so nothing gets altered.

For Rigor customers, we have added a new check to Rigor Optimization, [our performance analysis and optimization product](https://zoompf.com/features), which will detect MP4 files which have not been optimized for HTM5 video streaming. If you just want a quick check of your site, you can use [our Free Performance Report](http://rigor.com/free-performance-report).

## Conclusions

Whether you are converting animated GIF video clips to MP4, or have a bunch of existing MP4 videos, you can make those videos load and start playing much faster if you optimize the structure of the file. By reordering the atoms so the `moov` atom is at the start, the browser avoids sending extra HTTP range requests to skip around and try to locate the `moov` atom. This allows the browser to instantly start streaming the video. You can usually configure an option when initially creating your video to optimize it for streaming. If you have an existing file, you can use a program like ffmpeg to reorder the file without altering its contents.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
