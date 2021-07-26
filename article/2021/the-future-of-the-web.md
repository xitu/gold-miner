> * 原文地址：[The Future Of The Web](https://www.hazem.cool/blog/the-future-of-the-web)
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/the-future-of-the-web.md](https://github.com/xitu/gold-miner/blob/master/article/2021/the-future-of-the-web.md)
> * 译者：
> * 校对者：

![](https://www.hazem.cool/static/7858b1b89c0b19aeb9c7671418a6e1a7/4ec5b/the%20web%203.0.webp)

# The Future Of The Web

## The Old Web

There was a time when the web wasn't a big part of our life as it is today, it was mostly for checking the weather, mail, news, Yahoo answers, downloading an mp3, or playing flash games.

The web was static, single-player, as if part of the printing era got carried over to the web. though I have to say it was a bit [quirky and fun](https://www.spacejam.com/1996/).

## The Commercial Web

With the rise of web apps, social media, video streaming, and the move to mobile, the web moved from being a utility to a way of living.

A fountain of gold has erupted, tech companies started funneling in money in the billions. And when there is that amount of money floating around, the emphasis on fun and the end-user privacy and best interest won't really be on the top of their priority list.

So websites became more addictive. Companies started creating their own website. It's like every company and their dog had a landing page and if you squint your eyes enough it would seem like they all are using the same template with the same headlines of "The All in One Solution for Automated Organizational Collaborative Workplace Remote Communication Delivery.", "Be 10x more productive in 100x less time!!!", or "Toilets...Reinvented!". Other than a few texts, styles, and imagery here and there, It would be hard to spot the difference. It's like someone took the whole internet and bleached all the creativity and fun out of it.

The web became too commercial, too predictable, too...boring.

## Things are Changing



> There exists a future so bright that if you squint your eyes in the right direction you can see it shimmering in the distance.
> 
> **— Jesse Jacobs, Safari Honeymoon**

The web is changing, it's on its way to becoming more dynamic, more immersive, more multi-player, in fact, if you take a closer look, you'd see that it already did.



### The Death of Desktop

If you look at the apps that you use in your day to day they might be apps like Twitter, Facebook, Gmail, Zoom, YouTube, Slack, Discord, Microsoft Teams, Google Drive, Google sheets, Office 365, or Notion.

can you guess which of those aren't web apps? well, the only one that has a desktop client that isn't based on web technologies is Zoom which can also work on your browser just as well.

Even Microsoft Office applications, the **"de facto"** desktop applications, their interface was [rewritten in react which is a web-based technology](https://react-etc.net/entry/microsoft-office-rewrite-to-react-js-nears-completion).



#### Professional Heavy Apps

You could say but apps like Photoshop, After Effects, Final Cut Pro, Blender, and Visual Studio are desktop applications and they're too heavy and complex to be on the web.

But if you haven't noticed already, these types of apps are already moving to the web.



[Photobea](https://www.photopea.com/), and [Avocode](https://avocode.com/)
* After Effect → [Rive](https://rive.app/)
* Blender → [Spline](https://spline.design/)
* Microsoft Office → [Google slides](https://www.google.com/slides/about/), [Google sheets](https://www.google.com/sheets/about/), and [Notion](https://www.notion.so/)
* Skype → [Slack](https://slack.com/), [Teams](https://www.microsoft.com/en-ww/microsoft-teams/group-chat-software), [Zoom](https://zoom.us/), and [Discord](https://discord.com/)
* Visual Studio & Other IDEs → [CodeSandBox](https://codesandbox.io/), [Next.js Live](https://nextjs.org/blog/next-11#nextjs-live-preview-release)
* Unreal Engine, Unity → [Three.js](https://threejs.org/), [Babylon](https://www.babylonjs.com/), [Play Canvas](https://playcanvas.com/#!), and [RogueEngine](https://rogueengine.io/)
* AutoCad, Sketchup → [AutoCad Web](https://web.autocad.com/) and [Sketchup Web](https://app.sketchup.com/app)
* Audacity → [Soundation](https://soundation.com/)
* VLC Media Player → [VLC.js](https://code.videolan.org/jbk/vlc.js)

Heck, you can even [SaaS product ad?](https://youtu.be/cxUN1dZ0Edk)).

There is also a [windows paint clone,](https://jspaint.app/) [windows 98](https://copy.sh/v86/?profile=windows98), and [windows XP](https://winxp.vercel.app/) that can run on your browser.

If you haven't noticed yet dear reader, traditional desktop apps are already on their way to the digital graveyard.

### Mobile Isn't That Far From The Reaper

Mobile apps have that "Native" feel, they can live on your home screen, send notifications, have access to the camera, contacts, file system, etc. have smooth animations and gestures. things you don't see on your normal clicky and tappy websites.

When a company wants to support mobile they don't create a mobile-friendly web app, they create a native mobile app. Why? Because the web doesn't have access to the same APIs and features as the native apps, and it's usually thought of as not as performant, and you would have a hard time trying to implement gestures and animation that would work cross-browser and doesn't interfere with the device default gestures, and obviously you can't submit a website to the app store (or can you 👀?)

Some frameworks enable you to write cross-platform apps with web technologies like [React Native](https://reactnative.dev/), they mostly give you access to the same APIs and features of native apps, although they are less performant.

Some companies already adopted React Native such as Facebook, Instagram, Discord, Tesla, Skype, Pinterest, and Uber eats.

But I believe there is something better on the horizon, there is a type of web app that can run and feel like a native app and they go by the name of "progressive web apps". They are installable, [have access to APIs such as storage, camera, notifications, etc.](https://whatwebcando.today/) can be instantly updated (unlike native apps that require a build on the app store), don't have to be submitted to an app store, easily accessible (the power of the URL), and with libraries like [use-gestures](https://use-gesture.netlify.app/), [react-spring](https://react-spring.io/), and [framer motion](https://www.framer.com/motion/) you can easily implement smooth animation and gestures (Try out [Bottom Sheet](https://zuwji.csb.app/), [Multi-Gestures](https://rkgzi.csb.app/), [Slide Show](https://v364z.csb.app/), and [App Store Like Cards](https://ecgc2.csb.app/) demos on your phone).

Probably the most famous example is the Twitter PWA.

Google play store and Microsoft store already allow PWAs to be submitted to their marketplace.

Let's hope Apple adds more support and lift some of the limitations it has on PWA on iOS soon 🤞.

With time I predict more companies will move to PWA and we'll see them live side by side with native apps until one day PWA will become a standard (hopefully 😁) and we'll then wonder why the heck were we building the same application multiple times for each platform 😲!

## The Immersive Web

### The Web is Getting Powerful

You might be wondering? Isn't the web slow, chrome is hogging all my CPU and RAM and indeed the web wasn't meant for heavy apps but with [Web Assembly](https://webassembly.org/), that doesn't have to be the case anymore.

Web Assembly lets you run compiled code on the web from [multiple languages](https://github.com/appcypher/awesome-wasm-langs) such C++, Rust, Go, Java, etc. at near machine code speed. This will open the door for new types of applications on the web, such as:

* [Figma's rendering engine](https://www.figma.com/blog/webassembly-cut-figmas-load-time-by-3x/)
* [Google porting C++ code from its desktop application to the web](https://web.dev/earth-webassembly/)
* [Soundation audio computation](https://soundation.com/station/soundation-is-the-first-online-music-production-software-to-implement-webassembly-threads-gains-over-70-performance-improvement/)
* [Squoosh by Google image compression](https://squoosh.app/) (even with formats not supported natively by the web)
* [Google Sketchup 3D modeling](https://madewithwebassembly.com/showcase/sketchup/)
* [VLC media player being ported to the web](https://madewithwebassembly.com/showcase/vlc/)
* [Lichess chess engine analysis](https://madewithwebassembly.com/showcase/lichess/)
* [PSPDFKit](https://pspdfkit.com/blog/2017/webassembly-a-new-hope/) & [PDFTron](https://www.pdftron.com/blog/wasm/wasm-vs-pnacl/) PDF rendering engine
* [TenserFlow now supports web assembly](https://blog.tensorflow.org/2020/03/introducing-webassembly-backend-for-tensorflow-js.html)

### The Third Dimension

The web is traditionally two-dimensional, that's because it was mainly for sharing documents and not for "apps".

But 3D has been lurking in the webs for a while and it's not just for purely aesthetic reasons.

Here are some examples of 3D experiences on the web:

* [Google Earth](https://earth.google.com/web/) (Obviously 👀)
* [NASA Mars 2020 simulation](https://eyes.nasa.gov/apps/mars2020/#/home)
* [NASA Jet Propulsion Laboratory Open Source Rover](https://opensourcerover.jpl.nasa.gov/#!/home)
* [SpaceX ISS Docking Simulator](https://iss-sim.spacex.com/)
* [Stars Chrome Experiment](https://stars.chromeexperiments.com/)
* [Wikiverse](http://wikiverse.io/)
* [Zenly Landing Page](https://zen.ly/)
* [Bruno Simon Portfolio](https://bruno-simon.com/)
* [Lusion Site](https://lusion.co/)
* [Paper Lanes](https://paperplanes.world/)
* [Google Arts & Culture - Blob Opera](https://artsandculture.google.com/experiment/blob-opera/AAHWrq360NcGbw)
* [Google Cloud Infrastructure](https://cloud.withgoogle.com/infrastructure/)

### XR Experiences

VR and AR didn't hit mainstream yet, but they'll have their place on the web.

[WebXR](https://developer.mozilla.org/en-US/docs/Web/API/WebXR_Device_API) is an API that allows to create mixed reality (VR & AR) experiences on the web, so now we'll be able to create experiences that can work across different headsets and not just exclusive to one.

Here are some examples of WebXR experiences:

* [Shopify 3D Product Models](https://www.shopify.com/3d)
* [A-Painter: Paint in 3D](https://aframe.io/a-painter/)
* [Spiderman VR Experience](https://spiderman.webvr.link/)
* [Google WebXR Experiments](https://experiments.withgoogle.com/collection/webxr)
* [KonterBall: Ping Pong](https://konterball.com/)
* [Tonite Dance by Google](https://tonite.dance/)
* [Moon Rider (beat saber clone)](https://moonrider.xyz/)
* [Hubs: Virtual Room by Mozilla](https://hubs.mozilla.com/)
* [Plockle: Puzzle Game](https://plockle.com/)

### The Start of The Web Gaming Era

Video games have always lived on consoles and PCs. The web was left off with just mini flash games, the web wasn't really ready for the video game industry at the time.

But with Web Assembly, things are starting to change. Now you can port games that are written in other languages like C++ directly to the web.

[Unity announced that it will support Web Assembly](https://blog.unity.com/technology/webassembly-is-here), and with tools like [Three.js](https://threejs.org/), [Babylon](https://www.babylonjs.com/), [Play Canvas](https://playcanvas.com/#!), and [RogueEngine](https://rogueengine.io/), Things look a bit bright for gaming on the web.

Here are some examples of games running on the web:

* [Unity: Angry Bots](https://beta.unity3d.com/jonas/AngryBots/)
* [Doom 3 (ported via Web Assembly)](https://wasm.continuation-labs.com/d3demo/)
* [Heraclos](https://heraclosgame.com/)
* [Ouigo - Pinball](http://letsplay.ouigo.com/)
* [pmndrs - racing game](https://racing.pmnd.rs/#)
* [Classic Minecraft](https://classic.minecraft.net/)
* [After The Flood](https://playcanv.as/p/44MRmJRU/)
* [Trolli](https://trollideliciouslydarkescape.com/)
* [HexGL - Racer Game](http://hexgl.bkcore.com/play/)
* [Robostorm](https://robostorm.io/)
* [Foosball World Cup](https://www.foosballworldcup18.com/)

#### Why The Web is a Good Place for Game Development

The web is the only platform that is backward compatible, imagine creating a game that will work till the end of the internet!

You can launch your game to the masses without a publisher or a game store taking 30% out of your hard-earned revenue.

You can run your game technically on any device, no need to port your games to different consoles and architectures, PC gaming won't be exclusive for just windows anymore.

Easily accessible, anybody can access your game through a URL, no need to download gigabytes of data to test out a game.

You can instantly update your game without letting your users wait to download the latest update.

You can embrace the web streaming capabilities with code splitting and lazy loading assets, the user can play and test out your game instantly (in theory).

Imagine when wanting to play a game with a friend, you don't see which friend has the same console/PC as you (because most games are not cross-platform), or wait for both of you to download the whole game or download the latest 10GB update! all you need to do is share a URL for your game session and you're in, the gaming barrier will be so low it will essentially be non-existent.

## Decentralized 🕸, The Giant Slayer

Most of the internet is monopolized by 4-5 companies aka FAANG (Facebook, Amazon, Apple, Netflix, and Google).

They're pumping Tera-tons of your data into their data centers, they can control what content gets put on and what doesn't in their platform, they can influence your decisions by curating which content you see and which you don't, they can show their products on top when you search for their competitors, they can take a big cut out of your revenue for placing your product in their marketplace, they can lock you in their bubble by taking your data hostage and not letting you easily export it to other applications.

So a company having control over something as essential as the internet is let's say rather worrisome 😅.

So what do we do? Are we doomed to follow FAANGs wishes?

To that I say imagine a web where your data is truly yours, you can transfer it from one app to another, you don't need to give an application your email, password, phone number, address, social idenitiy, or your picture just to sign up, all you need is your virtual key. Imagine the internet not run by a few obese data-hungry giants but run by all of us. Imagine true anonymity, you choose what to make public and what stays private, no more middlemen.

This is what decentralized apps hope to do. You might have known about them from bitcoin but it's way bigger than that, we are just seeing early glimpses of what it could be. And if there is one thing that will save the internet from FAANGs chokehold, it would be decentralized apps that would finally slay the tech giants.

## Why The Web Survives

The web will never die (unless we all get nuked 💣) and that is because the web is an extension of us.

Unlike closed systems, the web is open and accessible from all devices, isn't run by one giant corporation, always backward compatible, there is no middle man between you and the people you want to connect to, and it's constantly evolving.

There was always a dream in the developers' ecosystem of **"write once, run everywhere"** what they didn't realize is that it was always there under their nose, the web has always been cross-platform.

##  or Fall Behind

I have a theory that all closed systems eventually die. The only thing they can do is prolong their existence, why so? Although they can keep watering their walled gardens, there will come a time when the weather they grew in won't be the same, so the leaves fall and the apple rots and the garden turns into a museum, a historic site, a reminder of what was.

For them to survive they'll have to open their gardens and embrace the seasons and the coming season is all web.

## The Final Operating System

The web will be the final OS, all connected, forever evolving.

There will come a time when somebody points to their computer device and they'll not point to their laptop, or their phone, or their glasses, or even their microwave, they'll point to the sky and say "it's somewhere...everywhere!"

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
