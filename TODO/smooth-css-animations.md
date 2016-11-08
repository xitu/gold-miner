> * 原文地址：[10 principles for smooth web animations](https://blog.gyrosco.pe/smooth-css-animations-7d8ffc2c1d29#.oqnbskp19)
* 原文作者：[Anand Sharma](https://blog.gyrosco.pe/@aprilzero)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# 10 principles for smooth web animations




Since we launched [_Gyroscope_](https://gyrosco.pe/) last year, many people have asked about the JavaScript library we use for our animations. We thought about releasing it to the public, but that’s actually not where the magic happens.

We don’t want people to feel like they’re dependent on some special JavaScript plugin that magically solves these problems. For the most part, we’re just taking advantage of the recent improvements in browser performance, GPU’s and the CSS3 spec.

There is no silver bullet for great animations, besides spending a lot of time testing and optimizing them. However, after years of experimentation and hitting the limits of browser performance, we’ve come up with a series of design & code principles that seem to reliably result in nice animations. These techniques should get you pages that feel smooth, work in modern desktop and mobile browsers, and—most importantly—are easy to maintain.









![](https://cdn-images-1.medium.com/max/800/1*MkkJ55Tz5Qgnl8xMzP5I4Q.gif)





The technology and implementation will be slightly different for everyone, but the general principles should be helpful in almost any situation.

### What is an animation?

Animations have been around since before the internet, and making them great is something you could spend a lifetime learning. However, there are some unique constraints and challenges in doing them for the internet.

For smooth 60fps performance, each frame needs to be rendered in less than 16ms! That’s not very much time, so we need to find very efficient ways to render each frame for smooth performance.













![](https://cdn-images-1.medium.com/max/400/1*jOzKe6AFCM1ReUdqzhAabA.gif)













![](https://cdn-images-1.medium.com/max/400/1*FgDvnrIo_NLY_mWWOevcpQ.gif)













![](https://cdn-images-1.medium.com/max/400/1*s3-q-j6Qt60mWW4Ut-731A.gif)



[Some classical animation principles](http://the12principles.tumblr.com/)







There are dozens of ways to achieve animations on the web. For example, the filmstrip is an approach has been around since before the internet, with slightly different hand-drawn frame being swapped out many times a second to create the illusion of motion.

Twitter recently used this simple approach for their new heart animation, flipping through a sprite of frames.









![](https://cdn-images-1.medium.com/max/800/1*FuG1AF-xgf0Ie6EIuab-FA.png)





This effect could’ve been done with a ton of tiny elements individually animating, or perhaps as an SVG, but that would be unnecessarily complex and probably not be as smooth.









![](https://cdn-images-1.medium.com/max/800/1*6BGvScGs5cxxqPJn9qQLCA.gif)





In many cases, you’ll want to use the CSS transition property to automatically animate an element as it changes. This technique is also known as “tweening”—as in transitioning be_tween_ two different values. It has the benefit of being easily cancellable or reversible without needing to build all that logic. This is ideal for “set and forget” style animations, like intro sequences, etc. or simple interactions like hovers.

Further reading: [All you need to know about CSS Transitions](https://blog.alexmaccaw.com/css-transitions)









![](https://cdn-images-1.medium.com/max/800/1*dKga2QEWB_ZI0nnj0m2XPA.gif)





In other cases, the keyframe-based CSS animation property may be ideal for continuously running background details. For example, the rings in the Gyroscope logo are scheduled to constantly spin. Other types of things that would benefit from the CSS animation syntax are gear ratios.

So without further ado, here are some tips that will hopefully greatly improve your animation performance…

> #1

### Don’t change any properties besides opacity or transform!

_Even if you think it might be ok, don’t!_

Just this one basic principle should get you 80% of the way there, even on mobile. You’ve probably heard this one before—it’s not an original idea but it is seldom followed. It is the web equivalent of “eat healthy and exercise” that sounds like good advice but you probably ignore.

It is quite straightforward once you get used to thinking that way, but may be a big jump for those used to animating traditional CSS properties.

For example, if you wanted to make something smaller, you could use_transform: scale()_ instead of changing the width. If you wanted to move it around, instead of messing with margins or paddings — which would need to rebuild the whole page layout for every frame — you could just use a simple_transform: translateX_ or _transform: translateY_.

#### Why does this work?

To a human, changing width, margin or other properties may not seem like a big deal — or preferable since it is simpler — but in terms of what the computer has to do they are worlds apart and one is much, much worse.

The browser teams have put a lot of great work into optimizing these operations. Transforms are really easy to do efficiently, and can often take advantage of your graphics card without re-rendering the elements.

You can go crazy when first loading the page — round all the corners, use images, put shadows on everything, if you’re feeling especially reckless you could even do a dynamic blur. If it just happens once, a few extra milliseconds of calculation time doesn’t matter. But once the content is rendered, you don’t want to keep recalculating everything.

Further reading: [Moving elements with translate (Paul Irish)](https://www.paulirish.com/2012/why-moving-elements-with-translate-is-better-than-posabs-topleft/)

> #2

### _Hide content in plain sight._

_Use pointer-events: none along with no opacity to hide elements_

This one may have some cross-browser caveats, but if you’re just building for webkit and other modern browsers, it will make your life much easier.

A long time ago, when animations had to be handled via jQuery’s animate(), much of the complexity of fading things in and out came from switching between display: none to block at the right time. Too early and the animation wouldn’t finish, but too late and you’d have invisible zero-opacity content covering up your page. Everything needed callbacks to do cleanup after the animation was finished.

The CSS pointer-events property (which has been around for quite a long time now, but is not often used) basically makes things not respond to clicks or interactions, as if they were just not there. It can be switched on and off easily via CSS without interrupting animations or affecting the rendering/visibility in any way.

Combined with an opacity of zero, it basically has the same effect as display none, but without the performance impact of triggering new renders. When hiding things, I can usually just set the opacity to 0 and turn off pointer-events, and then forget about the element knowing it will take care of itself.

This works especially well with absolutely positioned elements, because you can be confident that they are having absolutely no impact on anything else on the page.

It also gives you a bit more leeway, as the timing doesn’t have to be perfect — it isn’t the end of the world if an element is clickable or covering other things for a second longer than it was visible, or if it only become clickable once it fully faded in.

> #3

### Don’t animate everything at the same time.

_Rather, use choreography._

A single animation may be smooth on its own, but at the same time as a many others will probably mess it up. It is very easy to create a basic demo of almost anything running smoothly — but an order of magnitude harder to maintain that performance with a full site. Therefore, it is important to schedule them properly.

You will want to spread the timings out so everything isn’t starting or running at the exact same time. Typically, 2 or 3 things can be moving at the same time without slowing down, especially if they were kicked off at slightly different times. More than that and you risk lag spikes.

Unless there is literally only one thing on your pages, it is important to understand the concept of _choreography_. It might seem like a dance term, but it is equally important for animating interfaces. Things need to come in from the right direction and at the right time. Even though they are all separate, they should feel like part of one well-designed unit.

Google’s material design has some interesting suggestions on this subject. It is not the only right way to do things, but something you should be thinking about and testing.









![](https://cdn-images-1.medium.com/max/800/1*l3nlHJxVEvs6mwSzCt34Fg.png)





Further reading: [Google Material Design · Motion](https://material.google.com/motion/material-motion.html)

> #4

### Slightly increasing transition delays makes it easy to choreograph motion.

Choreographing animations is really important and will take a lot of experimentation and testing to get feeling right. However, the code for it doesn’t have to be very complicated.

I typically change a single class on a parent element (often on body) to trigger a bunch of transitions, and each one has its own own varying transition-delay to come in at the right time. From a code perspective you just have to worry about one state change, and not maintain dozens of timings in your JavaScript.









![](https://cdn-images-1.medium.com/max/800/1*1-oJmR242qUrcNke-RLFgQ.gif)



Animations in the [Gyroscope Chrome Extension](https://gyrosco.pe/chrome/)



Staggering a series of elements is an easy and simple way to choreograph your elements. It’s powerful because it simultaneously looks good while also buying you precious performance—remember you want to have only a few things happening at the same time. You’ll want to spread them out enough that each one feels smooth, but not so much that the whole thing feels too slow. Enough should be overlapping that it feels like a continuous flow rather than a chain of individual things.

#### Code Sample

There are a couple simple techniques to stagger your elements—especially if it is a long list of things. If there are less than 10 items, or a very predictable amount (like in a static page), then I usually specify the values in CSS. This is the simplest and easiest to maintain.









![](https://cdn-images-1.medium.com/max/800/1*NyyitMSOXlxOPrk7xNQJgA.png)



A simple SASS loop



For longer lists or very dynamic content, the timings can be set dynamically by looping through each item.









![](https://cdn-images-1.medium.com/max/800/1*T5S3EyM3rw-zrM8dmRFRqw.png)



A simple javascript loop



There are typically two variables: your base delay and then the time delay between each item. It is a tricky balance to find, but when you hit the right set of numbers it will feel just perfect.

> #5

### Use a global multiplier to design in slow motion

_And then speed everything up later._

With animation design, timing is everything. 20% of the work will be implementing something, and the other 80% will be finding the right parameters & durations to get everything in sync and feeling smooth.

Especially when working on choreography of multiple things, and trying to squeeze performance and concurrency out of the page, seeing the whole thing go in slow motion will make it a lot easier.

Whether you’re using Javascript, or some sort of CSS preprocessor like SASS (which we love), it should be fairly straightforward to do a little extra math and build using variables.

You should make sure it is convenient to try different speeds or timings. For example, if an animation stutters even at 1/10 speed, there might be something fundamentally wrong. If it goes smoothly when stretched out 50x, then it is just a matter of finding the fastest speed it will run at. It may be hard to notice 5-millisecond issues at full speed, but if you slow the whole thing down they will become extremely obvious.

Especially for very complex animations, or solving tricky performance bottle necks, the ability to see things in slow motion can be really useful.

The main idea is you want to pack a lot of perfect details while it is going slow, and then speed the whole thing up so it feels perfect. It will be very subtle but the user will notice the smoothness and details.

This feature is actually part of OS X—if you shift-click the minimize button or an app icon, you’ll see it animate in slow motion. At one point, we even implemented this slow-motion feature on Gyroscope to activate when you press shift.

















> #6

### Take videos of your UI and replay them to get a valuable third-person perspective.

Sometimes a different perspective helps you see things more clearly, and video is a great way to do this.

Some people build a video in after effects and then try to implement that on a site. I often end up going the other way around, and try to make a good video from the UI of a site.

















Being able to post a Vine* or video of something is a fairly high bar. One day I was excited about something I built, and tried to make a recording to share with some friends.

However, when I watched it again I noticed a bunch of things that were not great. There was a big lag spike and all the timings were slightly wrong. It made me cringe a bit and instead of sending it I realized there was a lot more work to do.

It is easy to gloss over these while you’re using it in realtime, but watching animations on video — over and over again or in slow motion — makes any issues extremely obvious.

















They say the camera adds 10 pounds. Perhaps it also adds 10 frames.

















It has now become an important part of my workflow to watch slow-motion videos of my pages and make changes if any of the frames don’t feel right. It’s easy to just blame it on slow browsers, but with some more optimization and testing it’s possible to work through all of those problems.

Once you’re not embarrassed by catching lag spikes on video, and feel like the video is good enough to share, then the page is probably ready to release.

> #7

### Network activity can cause lag.

_You should preload or delay big HTTP requests_

Images are a big culprit for this one, whether a few big ones (a big background perhaps) or tons of little ones (imagine 50 avatars loading), or just a lot of content (a long page with images going down to the footer).

When the page is first loading, tons of things are being initialized and downloaded. Having analytics, ads, and other 3rd party scripts makes that even worse. Sometimes, delaying all the animations by just a few hundred milliseconds after load will do wonders for performance.

Don’t over-optimize for this one until it becomes necessary, but a complicated page might require very precise delays and timings of content to run smoothly. In general, you’ll want to load as little data as possible at the beginning, and then continue loading the rest of the page once the heavy lifting and intro animations are done.

On pages with a lot of data, the work to get everything loaded can be considerable. An animation that works well with static content may fall apart once you start loading it with real data at the same time. If something seems like it should work, or sometimes works smoothly and other times doesn’t, I would suggest checking the network activity to make sure you aren’t doing other stuff at the same time.

> #8

### Don’t bind directly to scroll.

_Seems like a cool idea, but it really isn’t great._

Scrolling-based animations sometimes have gained a lot of popularity over the last few years, especially ones involving parallax or some other special effects. Whether or not they are good design is up for debate, but there are better and worse ways to technically implement them.

A moderately performant way to do things in this category is to treat reaching a certain scroll distance as an event — and just fire things once. Unless you really know what you’re doing, I would suggest avoiding this category since it is so easily to go wrong and really hard to maintain.

Even worse is building your own scroll bar functionality instead of using the default one—aka _scrolljacking_. Please don’t do this.

This is one of those rules that is especially useful for mobile, but also probably good practice for the ideal user experience.

If you do have a specific type of experience you want that is focused on scrolling or some special events, I would suggest building a quick prototype of it to make sure that it can perform well before spending much time designing it.

> #9

### Test on mobile early & often.

Most websites are built on a computer, and likely tested most often on the same machine they’re built on. Thus the mobile experience & animation performance will often be an afterthought. Some technologies (like canvas) or animation techniques may not perform as well on mobile.

However, if coded & optimized properly (see rule #1), a mobile experience can be even smoother than on a computer. Mobile optimization was once a very tricky subject, but new iPhones are now faster than most laptops! If you’ve been following the previous tips, you may very well end up with great mobile performance out of the box.









![](https://cdn-images-1.medium.com/max/600/1*VTK6jzkOcCd-MMqspmrbfw.jpeg)





Mobile usage will be a large and very important part of almost any site. It may seem extreme, but I would suggest viewing it exclusively from your phone for a whole week. It shouldn’t feel like a punishment to be forced to use the mobile version, but often it will.

Keep making design improvements & performance enhancements until it feels just as polished and convenient as the big version of the site.

If you force yourself to only use your mobile site for a week, you will probably end up optimizing it to be an even better experience than the big one. Being annoyed by using it regularly is worth it though, if it means that the issues get fixed before your users experience them!

> #10

### Test frequently on multiple devices

_Screen size, density, or device can all have big implications_

There are many factors besides mobile vs desktop that can drastically affect performance, like whether a screen is “retina” or not, the total pixel count of the window, how old the hardware is, etc.

Even though Chrome and Safari are both Webkit based browsers with similar syntax, they also both have their own quirks. Each Chrome update can fix things and introduce new bugs, so you need to constantly be on your toes.

Of course, you don’t only want to build for the lowest common denominator, so finding clever ways to progressively add or remove the enhancements can be really useful.

I regularly switch between my tiny MacBook Air and huge iMac, and each cycle reveals small issues and improvements to be made — especially in terms of animation performance but also for overall design, information density, readability, etc.

Media queries can be really powerful tools to address these different segments—styling differently by height or width is a typical use of media queries, but they can can also be used to add targeting by pixel density or other properties. Figuring out the OS and type of device can also be useful, as mobile performance characteristics can be very different than computers.



