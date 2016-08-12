> * 原文地址：[Stop designing interfaces, Start designing experiences](https://medium.com/blablacar-design/stop-designing-interfaces-start-designing-experiences-d82def0b802c#.tm2nitn97)
* 原文作者：[DUVAL Nicolas](https://medium.com/@nicolaseek?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者： 

> This article is part of a series on our new Interface Guidelines.

#### Messy process, messy results

8 months ago, after spending some time in agencies, I decided to take on a new challenge and I proudly joined the design team of BlaBlaCar.

In my first few weeks I remember being struck by the way they worked... Their tools more or less consisted of an empty Sketch file with empty art boards and two testing phones to make screenshots of the application.

![](https://cdn-images-1.medium.com/max/800/1*o4z8igVxDHWdYsH2gyxytg.png)
Tools designers used to use at BlaBlaCar: an empty Sketch file and 2 testing phones.
To work on a page or a flow they would import their screenshots to Sketch, crop them, work directly on them, mask some elements, create some new ones, open old sketch files to get components they would have had created before… And all the while asking themselves questions like “what are the right margins?”, “what’s the right size for a button?”, “what’s the right color?”, etc. I found myself constantly asking my fellow designers which file I could open to get a button or a top bar… just to end up creating a new one… and finishing with a totally inconsistent result.

![](https://cdn-images-1.medium.com/max/800/1*oBE_ubLfATsMbN2F7mNaAg.png)
This is actually what the same private profile page looks like on Android, iOS, MWeb and Web. Why is it so different?

#### Mess to harmony

I remember asking myself: “How are they managing, for a same page, different designs with different logics on different platforms?”. The answer is relatively simple: **they weren’t managing.**

Their way of working was OK for a team of 3, but we saw already that it could be challenging to maintain consistency with a rapidly growing team. We all agreed that we didn’t want to spend too much time on interfaces anymore, but focus essentially on the experience.

We decided to solve our problem and the solution we came up with is really simple:

![](https://cdn-images-1.medium.com/max/800/1*l9TGf5aMciH_R_0QXq_0rA.jpeg)
Lego metaphor in design: lego bricks are the equivalent of our bricks of UI components.
LEGOS! You‘ve probably heard of the metaphor of Lego in design already, lego bricks are the equivalent of our bricks of components. If I take a box of the same Legos I can build all this…

![](https://cdn-images-1.medium.com/max/800/1*rOkcMUYTg-GuqdKf1UrEeQ.jpeg)

…a seaplane, a muscle car and even a fucking T-Rex!

So we created a library of UI Lego Bricks to allow our designers to do the same! Now with our UI Lego Bricks…

![](https://cdn-images-1.medium.com/max/800/1*8zglU_HkFzdWwV7wO2M45Q.png)
Sample of UI bricks designers use at BlaBlaCar.
…they can quickly build a page or even a flow, and so iterate and test faster.

![](https://cdn-images-1.medium.com/max/1200/1*9spx7jXBRpSrHquOVdnP7A.png)
Designers can now build, iterate and test faster.

#### How much time does this really save?

You probably wonder how much time we can actually save by using this method. We had some doubts about it too, so we decided to do a simple test. We took the private profile page, and asked our designers to rebuild it, some with our UI Lego Bricks, some without.

![](https://cdn-images-1.medium.com/max/1200/1*rkFKD6Y69_YqG3NqCEJmEA.png)
This is the page we asked our designers to build with and without lego bricks.

We timed them while they did the work, and the results were really positive: on average they would spend 24 minutes building the page without Lego Bricks while they would only spend 13 minutes with the Lego Bricks. We’re not saying that we’re trying to focus on productivity, that’s not the point, but our designers actually **spent 50% less time thinking about pixels and 50% more time thinking about the experience **and that’s exactly what we want.

#### No more repetitive work

At BlaBlaCar we’re never satisfied and after using our UI Bricks for a while, and improving them with a few small iterations, we thought “Surely we can save even more time!”

We kept looking at their most repetitive and time-consuming tasks. There is actually one that all designers face on a daily basis: multiple platforms!

![](https://cdn-images-1.medium.com/max/800/1*WlvXE-kPz2foWIVHfGbzPQ.png)
One component = Multiple platforms
We all know how annoying it is to build a page for iOS to then build it again for Android and Mobile Web. We worked hard to create a library of components that would be identical for every platform while remaining platform-compliant. Now, our designers can design for just one platform, safe in the knowledge that, for example, a front-end developer can use an iOS or Android design to build the same page for mobile web.

#### Take shortcuts

We managed to make our designers save 50% time on building interfaces, we’re trying to reduce the number of platforms they’re designing for, but we still want to save a lot more than that. If we take a look at the process of creating interfaces today at BlaBlaCar, this is what it looks like:

**Designers are sketching → they next move to wireframes → then prototypes → and then finalised designs → that would then go to development.**

As you’ve already understood, we don’t want our designers to spend time on pixels! So the next step is for our designers to go directly from sketches to development phase.

![](https://cdn-images-1.medium.com/max/800/1*EbgfUlo0iolc4tfllCTruA.png)

This might seem a little too much but we’re so confident in our design system that we believe a designer could give a sketch to a developer and get a production version totally aligned with our library of components.

![](https://cdn-images-1.medium.com/max/800/1*fxjoQN3wIGeFIuKOfyUfYg.png)

> We don’t want our designers to spend any more time on interfaces, we want them to focus on the experience only.

#### The rules we followed

We took our inspiration from the [Atomic Design](http://bradfrost.com/blog/post/atomic-web-design/) methodology created by Brad Frost who was inspired by chemistry and the way that complex organisms are made of molecules which are in turn made of atoms. If you don’t already know this methodology I strongly advise you to read his article [here](http://bradfrost.com/blog/post/atomic-web-design/).

We applied this methodology to a powerful metaphor (LEGO) that was deep and dense in meaning and that helped us communicate so people would understand it quickly and connect with the idea. People from every field in the company would easily share the idea without having us explaining it.

After several months working on our design system I was able to pull out some big rules about how to approach it. It’s not rocket science but it really helped us to not get lost:

- **Metaphor**: choose a strong metaphor to help people understand quickly what you’re talking about without even explaining it. We chose the LEGOS but there are other ideas you can use (chemistry, fordism, ecology…)
- **Communication**: this is one important rule about how not to make your project fail. Communicate as early as possible with everyone in the company: developers, PMs, data scientists, designers, the CEO… Let them be part of the project.
- **Common language**: anything that has no name doesn’t exist. Make sure that everybody is aligned with the names you give to the components. You don’t need it to be too technical, the important thing is that everybody calls a component the same way.
- **Rules**: for every UI choice you need to make a clear rule. If you can’t explain a choice, find a rule. (I will talk more about this in another article)
- **No exceptions**: Exception is what can quickly lead you to total inconsistency. Keep to your rules and component designs and even if it looks weird at first, don’t make any exceptions. Exceptions are taken care of when your product is fully aligned with your guidelines.

I’m not saying that my method is the right one, I would even say that what we’re trying to achieve fits our product vision but probably wouldn’t fit in an agency environment. I’ve met many people who were interested in working on a design system and I’m totally open to discussion, feedback and debates so please share your thoughts. I’ll soon be writing a more precise article on the way we created our design system, but in the meantime, please contact me if you want more information! ;)
