> * 原文地址：[Making Magic with WebSockets and CSS3](https://medium.com/outsystems-engineering/making-magic-with-websockets-and-css3-ec22c1dcc8a8#.4d13ybtra)
* 原文作者：[Hélio Dolores](https://medium.com/@helio.dolores?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Making Magic with WebSockets and CSS3 #

![](https://cdn-images-1.medium.com/max/1000/0*Nkkza8wGZFucca1c.)

> *“Any sufficiently advanced technology is indistinguishable from magic.”
>  ― Arthur C. Clarke*

Magic has a way of captivating attention and interest, and you can’t go wrong with magic tricks if you want to amaze people.

When I started programming, impressing people was easy to do with just a few lines of code. However, nowadays technology plays such a big role in our lives that we need to push ourselves constantly. And, we have to be really creative to amaze people.

Fortunately, the Internet of Things creates a world of opportunities to bring this kind of magic back.

You have the most unexpected objects getting connected to the internet, as well as a plethora of interactions with users and between… things.

### Bringing the Magic Back with … a Shopping App? Seriously? ###

Just a few months ago, a few colleagues and I participated in a hackathon. The goal was to reinvent the way people shop for clothing.

We designed an application that would help a shopping assistant search for items the customers requested inside the store. The assistant could just easily swipe those clothing items onto a much bigger screen, so the customer would get a visual of what those items would look like.

Even though we didn’t win that particular competition — [a different group of colleagues did](https://www.outsystems.com/blog/2016/10/outsystems-wins-hackathon.html) and brilliantly — we noticed that particular kind of interaction, the swiping, had a big wow effect.

The audience saw images being pushed from a tablet and projected on a much bigger screen (that’s a little bit IoT). They appeared to travel by air, from starting point to destination. It was magically awesome.

![](https://cdn-images-1.medium.com/max/800/0*bLcvjqKyjmSrsKst.)

### Unveiling the Magic Trick ###

I’m going to show you how we did this. And I’ll be using a very appropriate, classic magician’s tool: a deck of playing cards:

[![](https://thumbs.gfycat.com/DefiantAdventurousCamel-mobile.jpg)](https://gfycat.com/DefiantAdventurousCamel)
点击图片查看视频

There are two main factors in this interaction: real-time communication with WebSockets and optical illusions with CSS3. The devices synchronize the animation of the two different cards so the audience believes they’re the same instance.

[![](https://thumbs.gfycat.com/UnrulySaltyAnnelida-mobile.jpg)](https://gfycat.com/UnrulySaltyAnnelida)
点击图片查看视频

So, let’s dive into the deets of how this magic really happens.

### Real-time Communication with WebSockets ###

The internet we know was mainly built using the HTTP protocol, which relies on a simple request-response paradigm. This means that a typical web application won’t receive any information it did not explicitly request.

In my card example, I really need to inform the page that a card was thrown by the user on the phone. The most efficient way to do this is by opening a real-time communication channel both applications can access — the one running on the phone and the one displaying the card table.

I’ll show you how to build a simple real-time service that provides this capability. It requires running [node.js](https://nodejs.org/en/) on a server.

The following code delivers a simple web server that listens to WebSocket connections. The logic is simple. When it receives a message called *table-connect* it stores the device socket to redirect any message called *phone-throw-card* from a mobile phone socket.

![Markdown](http://p1.bqimg.com/1949/480525a214b3e257.png)

Once the server is running the WebSocket service, it’s time to connect applications to it.

For this example, I used a library called [socket.io](http://socket.io/) . This library does more than just simplify the way I deal with WebSockets. It also creates a nice fallback for older versions of browsers that do not support the WebSocket protocol.

The card table application must connect to the real-time server and send (emit) a message for the server to identify and store the socket (*table-connect*).

It also registers a callback to deal with the arrival of the new card event (*phone-throw-card*) that will animate the entry of that card.

![Markdown](http://p1.bqimg.com/1949/2a6c79da0542372c.png)

On the phone side, the code is also very simple. I just need to store the socket for use when I want to throw a new card on the table.

![Markdown](http://p1.bqimg.com/1949/19bd3c09fc9cbca7.png)

### Optical Illusions with CSS3 ###

We can make animations smooth as butter with CSS3 [by following the best practices](https://medium.com/outsystems-experts/how-to-achieve-60-fps-animations-with-css3-db7b98610108). For this simple trick and illusion, both devices have the same animation effect, but they are moving in opposite directions.

For the card to appear as if it landed on the table from the bottom of the phone, I created the element outside the viewport. Then, I animated it with a simple translateY transition so that it appears to slide into view.

I changed the table script (phone-throw-card event) to call a function that injects an HTML element on the page, outside the viewport, and after that I added a CSS class to trigger the animation.

You can check the codepen here for an example and — who knows? — maybe get some inspiration.

[![](https://s3-us-west-2.amazonaws.com/i.cdpn.io/914234.ZBQJEJ.7422cae8-a613-4170-925f-c19f5c7e2839.png)](https://codepen.io/heliodolores/embed/preview/ZBQJEJ?amp%3Bdefault-tabs=css%2Cresult&amp%3Bembed-version=2&amp%3Bhost=http%3A%2F%2Fcodepen.io&amp%3Bslug-hash=ZBQJEJ&height=600&referrer=https%3A%2F%2Fmedium.com%2Fmedia%2F4ddf88ce43d5a88b77917f85fb079fe7%3FpostId%3Dec22c1dcc8a8)
点击查看源代码

### Going the Extra Mile ###

After everything’s up and running, it’s time to do some tweaking. The video showed the cards appearing to drop on the table from the bottom. By animating a reduction of size (scale) and using a shadow, it’s possible to get this more realistic effect.

As for the card dropping in the direction you set from the phone, most browsers already implement an [API](https://developer.mozilla.org/en-US/docs/Web/API/Detecting_device_orientation) to read those values from mobile devices. If you add it, along with swipe intensity, to your previous phone-throw-card event, you should be able to make this example work on your side.

For help with these animations, check out this codepen:

[![Markdown](http://i1.piimg.com/1949/bea41e853fc7d113.png)](http://codepen.io/heliodolores/pen/vyLJPL)

Now that I’ve shared this trick with you, I really hope you’ll be inspired to make some magic of your own.

For my next trick, I need a volunteer… How about you, dear reader? Don’t be shy. Okay, now sit still while I download your brain through a WebSocket — Hey, where are you going!?

Oh! You’re running to tell your friends about my magic show? Good thinking! Try [Facebook](http://bit.ly/share-magic-websockets-on-facebook), [LinkedIn](http://bit.ly/share-magic-websockets-linkedin), [Twitter](http://bit.ly/share-magic-websockets-on-twitter), and [Email]()!
