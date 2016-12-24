> * 原文地址：[10 things I learned making the fastest site in the world
](https://hackernoon.com/10-things-i-learned-making-the-fastest-site-in-the-world-18a0e1cdf4a7#.3u7qvm8ta)
* 原文作者：[David Gilbertson](https://hackernoon.com/@david.gilbertson)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[]()
* 校对者：[]()

# 10 things I learned making the fastest site in the world

This post is about performance techniques, so I hope you won’t mind that the site in question is not *quite* finished.

But you need something to click on so you can decide whether you value my opinion or not, so here you go: [https://knowitall-9a92e.firebaseapp.com/](https://knowitall-9a92e.firebaseapp.com/)

Hopefully that opened quickly and I have established credibility. If that sounds immodest it’s because I’m awesome.

Let me practice my pitch for the site: “have you ever wondered what you don’t know about the web? What hidden property or method or attribute has managed to evade your attention? Wouldn’t you like to go through a long list and tick off the stuff you know, to be left with a glorious summary of things to go and learn?”

If you’re wondering why I’m writing about this site when it’s not finished… because feedback. Performance is a series of tricks and ways of thinking about things. I certainly hope I don’t know everything there is to know, and I would be most pleased if you had something to offer me. The [source is here](https://github.com/davidgilbertson/know-it-all) if you would like to get your feet wet.

### Let’s talk speed

What’s that, you want a chart?

What’s that, you want it to be *unnecessarily stylised*?

![](https://cdn-images-1.medium.com/max/800/1*FGWpR_rcxj7IhhozihOgdw.png)

### Is it a fair fight?

Oh no, not at all. These sites do completely different things, it’s not sensible to think they should all take the same time to load. But these are all sites that have put effort into performance and aiming to make a site load faster than the Google home page keeps the pressure on.

### Why it isn’t very impressive

If by chance you are impressed, I suggest you cool your jets (for the moment). I don’t have to read from a database to produce content, or sign you in, or load seven 3rd party ads that each do 40 redirects before they load a flash file. I don’t even have any pictures. Oh and page count = 1.

### Why it isn’t completely unimpressive

In the time before the site is loaded and ready to go, I’m downloading and parsing a 75,000 line JSON file. The result is a tree that, if expanded, would be 9,986 rows (yep, I read all the specs and typed all that out).

And, I’m using a library. Libraries are slow, no matter how fast they are.

---

I learned a few things along the way and changed my attitude about as much as I’m capable of changing my attitude, and have rounded it all up into ten little learnings. Seven of these I would have found quite useful two months ago, three are just rubbish.

I’m not telling you which three.

### #1 Try not to make a slow site

I heard this recently from a non-web-developer: “I was on mercedes.com the other day and it was *so slow*, how can they even make a site that slow?”

I was getting a tattoo at the time so my response was mostly in the upper register and not what one would call comprehensible. But I was *thinking* that it’s really easy to make a slow site, all you have to do is not try to make a fast one.

(It’s a bear with a machine gun.)

This is good news, because if all you do is *try* to make a fast site, you will automatically get a faster site. You have to try non stop, but it’s like being a jerk, it’s actually pretty easy with a bit of practice.

For this site, at every step of the way, I took a few moments to think of the performance impact of what I was doing. For literally every library that I’ve used in this app, I’ve timed three metrics before and after:

- first meaningful paint
- time to interactive
- expanding one DOM node

If a library had a negative impact, out it goes. For example, because I’m an idiot head, I was at one point doing a lodash `deepClone` on my 75,000 prop JS object. Switching that out for `Immutable.js` made a big difference.

I’m using React, and at one point brought in the `classnames` library. Then I measured my metrics again and … no difference. `classnames`, you may stay.

The annoying five minutes you have to spend every time you import a new library or make a big change is a pretty cheap way to get performance gains. It’s exactly the same as buying a dolphin, right? If you take the time upfront to get matching bandanas oh I’m not sure where I was going with that. On to …

### #2 Do mobile first. Like, really do it.

There are two “mobile first” strategies.

In the first one (which I have done up until this project), I sit at my 27" monitor with a website imax style in front of me with a monster fan-cooled CPU and oceans of RAM doing whatever I ask of them.

Then I write my CSS media queries with `min-width` and tell my friends I’m doing mobile first.

![](https://cdn-images-1.medium.com/max/1000/1*CG8BUSNsCzk7tC4h28_IZg.png)

For this project I actually did *real *mobile first. That is, developed the site with it running on a **mobile** device. I did this **first**, and when I was satisfied with the UI and the performance, I went about getting it to work on a big computer.

You’d be surprised how easy it is to get a fast site to run on a fast machine!

(The story isn’t quite that simple, I started the project with my old bad habits, then halfway through got all grown up and started developing on mobile by default. This post is genuinely a list of ten things I learned, except the three rubbish ones.)

Now, running your site only on a phone is the dream, but for comparing performance metrics over many days and weeks, you want a consistent benchmark. If you [watch this video](https://www.youtube.com/watch?v=4bZvq3nodf4&amp;index=17&amp;list=PLNYkxOF6rcIBTs2KPy1E6tIYaWoFcG3uj) you will learn that testing on a mobile device for-reals is not at all consistent. You will also learn why I said “fan-cooled CPU” like that was a big deal.

When you do your benchmarking, you should use the Chrome DevTools and throttle your CPU and network. I use a 10x CPU slowdown and set the network to “Good 3G”. I know that’s maybe not quite as slow as the average phone, but I don’t want to get so frustrated with slow speeds that I get out of the habit of really doing this.

Because the key is to not just nod and agree it’s a good idea, but to actually, really, do it.

![](https://cdn-images-1.medium.com/max/1000/1*YIpE12eX50W6tPUhVd94TQ.png)

Here’s something I find surprising: really loud noises.

Here’s something else I find surprising: I have a big fat i7 CPU that I do most of my work on, and a brand new Pixel XL: the fastest phone in the world. What do you think the phone performance will be? 80% of the desktop? 60%? Any other guess above 10%?

Wrong! It’s only 10%. If I slow my i7 down *by ten times*, it is the same speed as the $1,400 phone in front of me.

That’s the difference between a 20ms click and a 200ms click. Or a frame taking 16ms to render vs 160ms.

(Let me know in the comments if you would like more examples of numbers multiplied by 10).

### #3 Be a benchmark hussy

My ego came into play here (it was outside). Once I got one good score on a benchmarking site I wanted to go to all the benchmarking sites to bask in their automated praise.

When I ran lighthouse over the site and only got a 97 the basking ceased quick smart. Where the hell are my last three points!

![](https://cdn-images-1.medium.com/max/800/1*368wXO3XzjX4KubqA41olw.png)

Oh I see, I’m being told I have an input latency of 285ms. That would be quite appalling, *if it were true.* But I know it’s only 20ms.

Clearly the lighthouse people are wrong idiots.

Then I reluctantly admitted to myself that perhaps I should look into this, despite the fact that I was obviously right and an algorithm written by Google was clearly in the wrong.

This prompted me to start the whole CPU slowdown thing, and sure enough, the response times that I *thought* were instant became 200+ ms laggards.

So I did some good ‘ol profiling and it looked like a lot of the time was being spent in React land. I had already done all the React performance best practices, I had no ‘wasted updates’ (something that’s easy to just do as you go along).

I even did some silly stuff memoizing low-cardinality components. (I don’t *really* know what cardinality means, but I think I used it right.)

I should point out here that I am a huge React fan. I have named three of my pets React (dog, possum, possum), I only stopped because they kept dying and I wondered if it was something in the name.

Such is my love for React that I felt like I was on Ashley Madison when I was looking up other front-end frameworks. But performance beats fidelity and into the loving embrace of Preact I flopped.

At first I tried `preact-compat`. It took about 15 minutes to convert my codebase. Immediate improvement. Sweeeet.

I told the dude who wrote Preact and he said I should try full Preact and *wowsers* it was even faster.

Y’all want a chart, don’t y’all?

![](https://cdn-images-1.medium.com/max/800/1*sOt-hI-gzfnGSanKocQ2rg.png)

Another tweeter chimed in that I should try Inferno (wait, can *everyone* see everyone’s tweets? We must warn the others!). So I converted my app to `inferno` to squeeze a few extra drops of that sweet sweet performance juice.

What? Chart? Green?

![](https://cdn-images-1.medium.com/max/800/1*NN4ipFryJOtaTzh7Yyps4Q.png)

OK, I tried, and Inferno is fast, but not quite as fast as Preact. So I rolled back that change.

There’s a lesson here, don’t be shy about throwing work out. But you should be shy in general. No one likes an extrovert. With their “fun” and their “talking”.

Whenever I feel reluctant to throw out some work, I recall that life is pointless, and nothing we do even exists if the power goes out. There’s a handy hint for ya.

And now …

![](https://cdn-images-1.medium.com/max/800/1*gnMQQam81ZgIXjmSgJeW_A.png)

Next up I tested on yslow. I almost got top marks, except they gave me a D (!) for having too many DOM nodes. Which is ridiculous because I know how many DOM nodes I need and no one else can tell me what to do because I’m the boss of me.

Clearly the yslow people are wrong and stupid.

Then I reluctantly thought that I should *maybe* have a look at reducing the number of DOM nodes I rendered. So I changed which branches of my tree are expanded by default.

Chart?

White on blue this time?

![](https://cdn-images-1.medium.com/max/800/1*AQ15w9wzbpx5LmDuEXAkmw.png)

Thanks, yslow people, turns out that was a pretty good suggestion.

---

They were the rubbish three, the rest are pure gold.

### #4 Client Side Rendering is expensive

Client Side Rendering (CSR), or as I call it “setting money on fire and throwing it in a river” has its uses, but for this site would have been madness.

I don’t have anything user-specific on the page so I can send out the same HTML to everyone. Also I have a relatively hefty processing job to do on the client, making CSR even worse. CSR was clearly not the fastest way for me to get my pixels into your eye holes.

Here’s my advice if you are building a site for a company that has — and desires to maintain — a revenue stream:

- Go into your analytics and discover what percentage of traffic comes from Bing. (For my employer it’s 1.6%).
- Yes that’s right, Bing. Because they do not execute JS when indexing and will thus not index a CSR site.
- Multiply your employer’s yearly revenue by 1.6%.
- Ask your employer if they’re happy for that number of dollars to go to the competition because you won’t be in the Bing search results any more.

Yes that logic has more holes than a, um, net. But you get the idea.

I have digressed.

Just send rendered HTML from your server.

### #5 Don’t server-render HTML

Well that certainly seems contradictory, what sort of trickery is this? How do you serve HTML without server-rendering HTML? You do what people probably did in the 90s…

React (and its faster little siblings) will take a few dozen milliseconds to render a modest page of HTML. (Does anyone have stats on how long PHP or JSP takes? I’d be interested to see a comparison.) That means a single core can only service maybe 50 people per second; additional requests would be neatly queued, this is no good.

For my little site I am sending the same HTML in every response. If your site happens to be the same, then you don’t need a web server sitting there rendering HTML and sending out CSS and JS files on demand. You can **generate your HTML at build time** and ship the whole lot from static hosting (or cache it on a good CDN). Github and Firebase and probably other people will give you static hosting just because they’re nice.

This idea doesn’t apply to many so I won’t be upset if you skip this one. But if you have any pages that can be rendered at build time (e.g. the home page of LinkedIn, PayPal, GitHub) then take advantage of that.

I actually came about this backwards. I was looking at some blog and I realised that it was only 96 milliseconds ago that I had clicked on the link to said blog. (Yet somehow I maintain that *mine* is the fastest site in the world — reality doesn’t really come into it.)

I did some digging and discovered the blog was hosted as a static site with Firebase. I have already fathered a child with Firebase and quite enjoyed myself so I thought I’d try out their static hosting.

But that would mean I have to generate my HTML at build time.

[scratches chin with squinty eyes]

If only React was capable of outputting its generated DOM as a string. Then I could just save that string to an HTML file as part of my build script.

For those not in the know, the above is very funny because React *does* have a method, called `renderToString`.

(As it happens, it’s a good opportunity to run the HTML through a minifier before saving to disk.)

### #6 Inline stuff, probably

Every time I’ve sat down to work out if inlining CSS is worth it or not, I have come the conclusion that … it depends.

If you’re facebook.com and 99.9% of page views are return visitors, then have a separate CSS file and cache it. If you’re a funeral home website that doesn’t get many repeat visits, you might want to inline your CSS and save a network request.

If your life is too easy and you want to create a never ending stream of tears and frustration you can try and inline the CSS that applies to elements above the fold and have the rest load in a separate CSS file.

My personal rule now (so I don’t have to think about it): if you can get all your CSS into your HTML and keep the lot under 14 KB, do it. (Don’t know why 14? [Read this](https://hpbn.co/building-blocks-of-tcp/#slow-start).)

My CSS + HTML (minified) is 3.5 KB, so it’s a no brainer — I’ve inlined my CSS.

### #7 Preload, then load

Our `<scripts>`, much like our feet, should be at the bottom of our `<body>`. Oh I just realised that’s why they call it a footer! OMG and header too! Oh holy crap, body as well! I’ve just blown my own mind.

[five minutes later…]

![](https://cdn-images-1.medium.com/max/800/1*N0FXMcRze-eZU0bauRx-1g.png)

Sometimes I think I’m too easily distracted. I was once told that my mind doesn’t just wander, it runs around screaming in its underpants.

What are you doing here?

Ah yes, blog post about site speed.

---

A common pattern in React with SSR (Server Side Rendering, if you’d forgotten) is this:

1. On the server, generate the HTML by passing in some data for the components to render.
2. Write that data into the HTML document like `window.APP_DATA = data;`
3. Send both the rendered DOM (based on the data) *and the data* back in the HTML payload.
4. In the browser, read `window.APP_DATA` and ‘rehydrate’ the app with it.

I always thought that was a bit wasteful size-wise, but that it doesn’t really matter because the HTML will be rendered in the same time, it’s just the JavaScript will be delayed a bit. This doesn’t matter if your site works just fine before JavaScript is loaded. But my site does sweet fudge all if there isn’t any JavaScript.

So, this is what I wanted to happen:

- Start downloading the data as soon as possible (without blocking the HTML).
- Start downloading the app’s JavaScript as soon as possible (without blocking the HTML).
- When both the script and the data are downloaded, and the HTML has been parsed, run the script which will breath life into the page.

I could have done all sorts of fancy footwork in JavaScript to get this working, but I have a better solution. Well, it works, but I have a nagging feeling I’m doing something dumb.

Browser experts get your magnifying glasses out…

- In the `<head>` I have a `<link rel="preload" … >` for both the JSON and and the JS (I have `prefetch` as well for browsers that don’t support preload yet)
- At the end of the body I load the application JS in a regular `<script>` tag.
- When the JS executes, it’s does a `fetch()` for the JSON file, and `.then()` kicks off the rendering of the React app.

That looks something like this.

![](https://cdn-images-1.medium.com/max/800/1*UukeZpaCEwvFobNZNRl1jg.png)

Once any asset is on the way down, further calls to download it won’t go out to the network. The network calls look like this:

![](https://cdn-images-1.medium.com/max/800/1*F1jae2bU7NmudJiz8ey6Uw.png)

---

So unless I’m wrong, I see no reason to not preload *everything* at the top of the page.

Side story: when doing this I wanted to give my JSON file a hash in the name so I could cache it for forever. I broke my own rule and went straight to npm like a sucker. I faffed around for a while before coming to learn that the `crypto` library built right there into Node does the trick without too much fuss. It’s so little effort it’s *barely* worth going to create the gist…

```
const fileHash = crypto.createHash('md5').update(fileContents).digest('hex');
```

### #8 Reward good behaviour

Your users who are running Chrome and Edge and Firefox are good people. Is it fair that you ship 30 KB of polyfills to them? No, it is not.

I have always done this. I have production sites out there shipping 30 KB polyfills millions of times a day and it makes me feel icky now.

For this project, I just create a separate polyfill file and load it if I have to. In my HTML I have something like this:

```
var scripts = ['app.a700a9a3e91a84de5dc0.js']; // script for all users

var newBrowser = (
  'fetch' in window &&
  'Promise' in window &&
  'assign' in Object &&
  'keys' in Object
);

if (!newBrowser) {
  scripts.unshift('polyfills.a700a9a3e91a84de5dc0.js'); // script for the less fortunate
}

scripts.forEach(function(src) {
  var scriptEl = document.createElement('script');
  scriptEl.src = src;
  scriptEl.async = false;
  document.head.appendChild(scriptEl);
});
```

To generate these two packages with webpack is actually crazy simple.

```
config.entry = {
  app: [
    path.resolve(__dirname, `../app/client/client.jsx`),
  ],
  polyfills: [
    `babel-polyfill`,
    `whatwg-fetch`,
  ],
};
```

This took my build size down from 90 KB to 60 KB.

You may have noticed that up until now I haven’t spoken about download size. That’s because file size isn’t relevant.

If you’re measuring the “time to interactive” of your site, then you’re already taking the file size into account; both download time *and *parse time. If you hear someone saying that they reduced their CSS file by 5 KB, ask for that figure in milliseconds.

But I feel like a chart, so here’s the file size of my app + React with all the polyfills vs without and then with the tiny Preact.

![](https://cdn-images-1.medium.com/max/800/1*0flH_4x4a9wnwYUF15_sIQ.png)

If you want to get clever and tailor polyfills to each browser, [polyfill.io](https://qa.polyfill.io/v2/docs/) has already done it. It’s by the serious people at the financial times, but here’s why you’re crazy if you use it:

- At any point, if they do something wrong, your whole site can break. And it might break in a browser that you don’t use all the time. Maybe your site is broken right now in some browsers. How would you know?
- It’s crazy fast, but it’s a blocking script at the top of your site. If they take a second to load, there’s not a thing you can do about it.

So I simply serve the smallest package to those using the good browsers and everyone else can suck a 30 KB egg.

(I feel like I’m being mean to Safari by leaving them out — Safari 10 has spectacular JavaScript support — but without `fetch` I’m afraid they don’t make the list of modern browsers in my eyes.)

### #9 Service workers: like me in high school

(cool and easy)

I’ve been putting off learning service workers for a long time. I figured one day I would put aside 400 hours and get down to figuring out what made them tick. When I decided to make this — the fastest site on the planet — I thought it was about time.

Five hours later I was done. I shit you not. And 4 hours and 35 minutes of that was making mistakes. This is how it works:

- My build script does it’s thing and the end result is a bunch of files in a directory called public (including my `index.html`). Normal stuff.
- Then I tell Google’s `sw-precache` library to create a service worker file that will cache every file in that directory and allow my site to work offline.
- My client-side code registers that service worker that `sw-precache` created.
- Srsly, that’s it.

There are 16 lines of code required.

13 in the build script (once all my junk is in `/public`)

```
swPrecache.write(path.resolve(__dirname, `../public/service-worker.js`), {
  cacheId: `know-it-all`,
  filename: `service-worker.js`,
  stripPrefix: `public/`,
  staticFileGlobs: [
    `public/app.*.js`, // don't include the polyfills version
    `public/*.{html,ico,json,png}`,
  ],
  dontCacheBustUrlsMatching: [
    /\.(js|json)$/, // I'm cache busting js and json files myself
  ],
  skipWaiting: true,
}, (err) => {
  if (err) {
    reject(err);
  } else {
    resolve();
  }
});
```

(I don’t cache the polyfills because browsers that need polyfills don’t have service workers.)

Then three lines in the client where I need to load the service worker:

```
if (`serviceWorker` in navigator) {
  navigator.serviceWorker.register(`service-worker.js`);
}
```

Once you’ve loaded the site once, it operates without needing the network. If a new version is available, it will install in the background if you’re online and when you refresh you’ll get the new version.

The future is here people. Well, it was here a few years ago but now *I’ve *learned it, so it’s really here. Spread the word, use service workers. DO IT.

Unfortunately the 50% of you reading this on Safari/iOS at the moment don’t get service workers. Apple *must *be working on them, otherwise it will get to the point where you buy an Android if you want fast internet.

### #10 Computers have nice fonts

I’m always torn when it comes to web fonts. They’re a pain, performance-wise. But it’s nice to have nice things.

I gave it a bit of a think-over for this site and came to a stunning realisation in four parts:

- macOS has nice fonts
- Android has nice fonts
- Windows has nice fonts
- iOS has nice fonts

So why not use them? I have selected Calibri Light, Roboto and Helvetica Neue. If you tell yourself you need the same, custom font on all devices then things have already gone too far and there is no hope for you.

Throw in a few other rules and it looks good enough. So here is what I think every single website should have as their typography base.

Nice text, no network request.

```
body {
    color: #212121;
    font-family: "Helvetica Neue", "Calibri Light", Roboto, sans-serif;
    text-rendering: optimizeLegibility;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    letter-spacing: 0.02em;
}
```
---

Writing a fast website is like raising a puppy, it requires constancy and consistency (both over time and from everyone involved). You can do a great job keeping everything lean and mean, but if you get sloppy and use an 11 KB library to format a date and let the puppy shit in the bed just one time, you’ve undone a lot of hard work and have some cleaning up to do.
