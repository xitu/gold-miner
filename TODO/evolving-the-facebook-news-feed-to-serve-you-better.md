
  > * 原文地址：[Evolving the Facebook News Feed to Serve You Better](https://medium.com/facebook-design/evolving-the-facebook-news-feed-to-serve-you-better-f844a5cb903d)
  > * 原文作者：[Ryan Freitas](https://medium.com/@ryanchris)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/evolving-the-facebook-news-feed-to-serve-you-better.md](https://github.com/xitu/gold-miner/blob/master/TODO/evolving-the-facebook-news-feed-to-serve-you-better.md)
  > * 译者：
  > * 校对者：

  # Evolving the Facebook News Feed to Serve You Better

  ![](https://cdn-images-1.medium.com/max/2000/1*jQtKO4-gLZ1Y937qKDupKQ.jpeg)

Starting late last year, we set out to explore how we could make News Feed more readable, conversational, and easier to navigate. As you might imagine, designing for a community that connects two billion people can pose some unique challenges.

As managers of two teams of designers that bring News Feed to life each day, we are sensitive to the fact that any changes we make can resonate across the entire Facebook experience. In speaking with people who use Facebook around the world, we’ve heard that they felt News Feed had become cluttered and hard to navigate. Solving this problem meant evolving the News Feed design system, a significant challenge for a highly-optimized product. Small changes, like a few extra pixels of padding or the tint of a button, can have large and unexpected repercussions.

[![](https://fb-s-b-a.akamaihd.net/h-ak-fbx/v/t15.0-10/20903038_10155513750176390_6456020927531450368_n.jpg?oh=dc35a79787ee18078e1890f7f255d086&oe=5A37A267&__gda__=1508549353_65f797c69507a2979e014c72da9f149c)](https://www.facebook.com/v2.3/plugins/post.php?app_id=52049637695&channel=https%3A%2F%2Fstaticxx.facebook.com%2Fconnect%2Fxd_arbiter%2Fr%2FXBwzv5Yrm_1.js%3Fversion%3D42%23cb%3Dfa753d97d77ac8%26domain%3Dcdn.embedly.com%26origin%3Dhttps%253A%252F%252Fcdn.embedly.com%252Ff32992607cee04c%26relation%3Dparent.parent&container_width=700&href=https%3A%2F%2Fwww.facebook.com%2Fdesign%2Fvideos%2F10155513748726390%2F&locale=en_US&sdk=joey&width=700)

#### Improving readability on News Feed

Our design and research teams are in continuing dialog with real users, every day. Consistently, our audience lets us know what they care about most:

1. The **content** itself, such as a shared photo
2. The person **who **is sharing the content
3. How they can leave **feedback** (like a comment or reaction) to what they were seeing

With feedback from real users in mind, we took a look at the anatomy of our most common story types. The idea was to break things down into their atomic parts, and make certain the design choices we’d made in the past served the needs of our audience right now.

![](https://cdn-images-1.medium.com/max/2000/1*vQMq6O3HmzHVPP5twX5TiQ.png)

Before: This is what our existing News Feed story formats looked like when we started.

We asked ourselves if we were meeting three key objectives:

> How might we improve News Feed to be easier to read and distinguish key areas of content?

> How might we make the content itself more engaging and immersive?

> How might we make it easier to leave feedback?

These questions drove our exploration and experimentation in a design sprint, a week of coordinated brainstorming and prototyping of new ideas, across two teams of designers, researchers and content strategists. The sprint artifacts helped shape what became a north star for the future of News Feed.

![](https://cdn-images-1.medium.com/max/2000/1*-Kkl2bNRuk02FZ7tMipTEw.png)

The first iteration of updated story formats from our design sprint

We did a variety of design treatments to find opportunities on improving how each of these content types are displayed:

- Make the News Feed stories easier to read by improving visual hierarchy, increasing type size and color contrast
- Help people better understand and interact with News Feed actions by evolving our iconography and increasing tap target sizes
- Provide a more engaging content experience by expanding content full-width and reduce unnecessary UI elements

Our design sprints always include an opportunity for research to validate our explorations. With this sprint we made sure to put our work in front of real users to get their reactions.

![](https://cdn-images-1.medium.com/max/2000/1*COSpLOU6nblSxB45OzKIUQ.png)

User feedback from our first round of testing.

Through several rounds of iteration and testing, we learned that some of our initial design solutions helped to clean up the interface however there were decisions like placing the text on top of photos or removing explicit text labels that caused new legibility concerns. Each round of iteration got us closer to our final designs, with layouts and typography that are easier to consume without sacrificing comprehension.

![](https://cdn-images-1.medium.com/max/2000/1*KMsUJuKyk8UeWqt6PDOm-A.png)

After: Our final round of News Feed story improvements.

#### Making comments more conversational and engaging

Our goal is to make it easier to engage in meaningful conversations, make conversation more central to more interactions, and give people more ways to express themselves. Our existing formats were rooted in message board styles, with similarly limited affordances for personal expression. As we started to look at other formats for comments, it was obvious that messaging design paradigms have empowered people to converse better than they could before.

![](https://cdn-images-1.medium.com/max/2000/1*wVbXLamvms92BPrapEBigw.png)

Comments before (L) and after (R).

#### Making navigation between News Feed stories easier

Another area that we wanted to improve was how people moved to and from News Feed stories throughout the system. Depending on the content type, we watched people in lab studies open their feed and simply get stuck consuming content. We also saw how people would struggle to find the “back” button because we had been quite inconsistent with our execution on applying consistent affordances over the years.

![](https://cdn-images-1.medium.com/max/2000/1*pzPdxt8EiRfeJ8tfSlgLqA.png)

Navigation before (L) and after (R).

The team opted for consistent back affordances across all the immersive views in addition to reducing the redundancy between our navigation bar and the title of the story. We also improved the transition from News Feed to story view by making the content expand in place creating a sense of remaining in context. We improved navigational gestures by enabling people to swipe back out into News Feed.

[![](https://fb-s-d-a.akamaihd.net/h-ak-fbx/v/t15.0-10/20884290_10155513754036390_2163201085114679296_n.jpg?oh=054fbfb96418565834359c970c76b092&oe=5A1F9814&__gda__=1512720282_b3d048b53c0060bfcabd3f090b8a4b86)](https://medium.com/media/dd89d805e790715d32a15a67ce6e814d?postId=f844a5cb903d)

We’re continuing to build on to the system from here and nothing is ever “done” at Facebook. As Facebook designers, we put people at the center of everything we do, so we set out to improve the experience in a meaningful way. This is a unique design challenge because we did not want to just “fiddle at the edges”, but rather make something that billions of people use every day less frustrating. We’ll be continuing to learn, iterate and improve upon our new foundation, but we’re hopeful this is a step towards a better Facebook experience.

We’d like to offer launch day congratulations and a big thank you to everyone on the team! This would not have been possible without your tremendous effort and sacrifice. Christopher Welch, Kory Westerhold, Robin Clediere, Brian Frick, Cristobal Castilla, Dan Lebowitz, Crystine Gray, Emily Becklund, Nick Merola, Brittany Lawrence, Kara Fong, Paddy Underwood, Sylvia Lin, Tim Feeley, Davis Fields, Boris Ratchev, Suv Bhadra, Aaron Pang, Adam Bell, Juan Garibay, Thomas Reese, Jonathan Ballerano, Naren Hazareesingh, Michael Belkin, Zach Ritter, Joshua Wu, SheShe He, Anthony Overstreet, Kai Ding, Brody Larson, Mohammed Abid, Dragan Milisav, James Kao, Mathias Roth, Frank Yan, Patrik Chamelo, Sriram Ramasubramanian, Yohann Richard, Brian Amerige, Ergin Erant, Abhinav Jain, Alan Norbauer, Andrew Truong, Claire Lerner, Eric Guan, Inna Rubio, Jungi Kim, Kaya Tutuncuoglu, Lenino Colobong, Tyler Craft, Yuri Brunets, Wilson Ng, Steven Luscher

Also thank you Geoff Teehan, John Evans, Julie Zhuo, Lars Backstrom, Hady ElKheir, John Hegeman, Mark Hull, Adam Mosseri, Tom Alison, Chris Cox and Mark Zuckerberg and the many other people that touched this project for helping support, consult and push to the finish line.


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  