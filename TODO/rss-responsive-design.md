> * 原文地址：[The real responsive design challenge? RSS.](https://begriffs.com/posts/2016-05-28-rss-responsive-design.html)
* 原文作者：[Joe "begriffs" Nelson](https://github.com/begriffs)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


The web is a diverse place, just check your server logs. You’ll see bots and fringe mobile devices, user agents on all kinds of screens and operating systems. It’s easy to get used to the way that _you_ use the web and neglect the user experience for the world at large.

For instance I noticed that a chunk of my own traffic are the feed readers accessing my Atom feed. Out of curiousity I decided to investigate what it’s like to use these Atom readers to read my content. It wasn’t pretty. The feed problems uncovered deeper usability problems whose solution is applicable to web design in general.

Before reading on you might like to try this for yourself. If you host an RSS or Atom feed then load it in a variety of readers and see how it looks. Here are ones I’ve noticed who hit my site: Newsbeuter, Newsflow, Sismics reader, Tiny Tiny RSS, Feedly, Feedbin, Akregator, Feed Wrangler, NewsBlur, FeedHQ, Feed Spot, Livedoor reader, Miniflux, Liferea, Readerrr, and Mozilla reader.

The first thing you’ll notice is that they disregard Javascript and CSS but preserve images. Sometimes they add their own CSS, other times they leave the document completely unstyled. Taking control of the style allows these programs to offer adjustible line spacing and switchable themes like a darkened night browsing mode. You may not have seen your site without any CSS clothes for a while, and may realize it needs to go to the markup gym.

Here are tips to make your site work better for everyone.

*   Font-Awesome is not so awesome at gracefully degrading. Instead use SVG images which still resize perfectly and work without CSS. In fact loading SVGs with an `img` tag allows you to set the `alt` attribute to provide context for non-graphical and non-visual user agents. Use inline height and width styling so that the SVG will keep the correct size without CSS. You can get a full SVG replacement for Font-Awesome at [encharm/Font-Awesome-SVG-PNG](https://github.com/encharm/Font-Awesome-SVG-PNG).
*   Add manual workarounds for multimedia tags. For example the `` tag on many of my posts looked terrible in feed readers. Some readers made it vanish without a trace! Others loaded the videos at a monstrous size, but would not allow them to play. In an environment unable to play video, the most useful information is a link to the video content itself for downloading or playing with another program. Hence I now provide links to the video files inside `` tags. I also removed the video tag from the page markup and now add it with Javascript after the page loads. I can’t trust the behavior of this element in a non-Javascript situation.
*   Don’t duplicate titles and dates between markup and metadata. Unlike the wild west of HTML, feed formats have designated places to specify an article’s who, what, and when. Headers and footers with a timestamp, title, and email contact are unnecesary inside an Atom feed.
*   Choose raster images of appropriate natural size. Some of my posts used CSS to shrink large images for presentation. Without CSS enabled the images were huge and crazy looking (not to mention less efficient to transmit).
*   Mind the `summary` vs `content` in Atom items. Some static site generators (cough, _hakyll_…) dump the whole post body into the summary.

This experiment opened my eyes to the spectrum of user agent capabilities. It’s not as black and white as full browsers vs text based browsers or screen readers. People access web sites with all permutations of JS, CSS, and graphics enabled, and you can make easy changes to help everyone enjoy your site.
