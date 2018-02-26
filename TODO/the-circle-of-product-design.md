> * 原文地址：[The Circle of Product Design](https://blog.prototypr.io/the-circle-of-product-design-6c78ade2010e)
> * 原文作者：[Francesca Negro](https://blog.prototypr.io/@francine.negro?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-circle-of-product-design.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-circle-of-product-design.md)
> * 译者：
> * 校对者：

# The Circle of Product Design

## In All Its Freudian Glory

Getting from point A to point B is sometimes messy even when we are simply walking — wondering if the path is right, if we are going in the right direction, what if we took that shortcut and so on.
But when point A is a user problem and point B is an implemented feature, it’s like navigating in open sea with an old map and a faulty compass.
That is why following a rigorous process — even when time is tight — is key to getting to that point B with as much confidence and data about the solution as possible and — additionally — to make it a little easier the following times (and to build an exhaustive documentation for future generations to come).

* * *

![](https://cdn-images-1.medium.com/max/1000/1*WEDplgz4D0kkDU_DzwseUA.jpeg)

The whole of the process in all its Freudian glory (all illustrations by me).

* * *

### **1.Understand the problem**

![](https://cdn-images-1.medium.com/max/600/1*JDwprV_DD-4C1t5Q4DflaA.jpeg)

Problems need understanding too.

First off, how did this request come to life? Was it a customer request, the CEO’s idea, a roadmap step towards the achievement of The Vision? Understanding where that issue on Jira or email or post it with the request came from is pivotal. Discerning the actual problem that triggered the request from the messenger’s added interpretation is often hard and also easy to overlook (and let’s face it, less time consuming).

Traveling back to that initial spark that triggered it means making sure the starting point of the design is the actual problem, and not one of the possible solutions.

Gather insights from customer care, from the CEO, from the Head of Product, whoever and — kind of like a Sigmund Freud of Product Design — dig into that until you hit the source, the original event that sparked the request.

### 2.Research the problem and gather data

![](https://cdn-images-1.medium.com/max/600/1*ddePyPmVjgUEUlCTmEQaCA.jpeg)

Probing that problem is part of the solution.

Step two means getting really good at bothering people and googling things. Once identified that event (might be a childhood trauma or a customer complaint) it’s now time to get as much information as possible on it.
How are other people handling that issue? Is it a widespread problem or a niche issue? Is there a way we can split that problem into smaller problems? And, most importantly, gather data on it.

Even if we are talking about a completely new feature and/or the product is still to be developed, there are metrics that relate to it (to some extent) that can be used. If it’s an improvement of an existing feature it _should_ be easier getting use data from analytics or any kind of metrics that _should_ have been implemented.

### 3.Re-frame the problem

![](https://cdn-images-1.medium.com/max/600/1*eWm3VEXR8OOb7lDylpD6dg.jpeg)

Blue steel ™.

With all that information by now, it should be easy to get a better picture of the problem and the context is exists in. Reframing the problem means getting a different set of eyes and looking at it from another perspective (see J.W. Getzels works on the “Problem of the Problem” and creative problem solving), thus spoiling it from any previous bias or interpretation that might have been added while collecting it.

So, while the original request might have been “we need a feature that allows to transfer money to the user when the balance is low” (which is a request that already contains the solution), the problem that originated it might have been “transferring money to the user is time consuming and requires constantly checking the balance”.
This new framing of the problem opens up new paths towards the solution (either implement a scheduler, or an automatic alert when the balance is low).

### 4.Design the solution

![](https://cdn-images-1.medium.com/max/600/1*v7DtBmuit2zTHBNyJvG0Gw.jpeg)

The Vitruvian Solution.

The problem is now identified and data is available to put it into the wider context of the product. It is now time to frame the solution as in “decide which one of these paths is leading to the solution better fit for the problem”. For this purpose it can be useful to put in the form of questions which features should the solution have — “should the user be able to set an automatic reminder?” “Should the user be able to import events?” — and build a list of possible solution approaches. The aim is to narrow down the options and form an assumption that will be tested with a prototype.

Since the aim is testing the assumption, the prototype would ideally be assumption-centered, ideally stripped from all the frills and unnecessary details that might distract the user when testing.
At this step it is also ideal to chat with the developers and anyone else that will be involved in the process (QA, wider design team, customer care) to gather their insights on the solution from their perspective.

### 5.Test the solution

![](https://cdn-images-1.medium.com/max/600/1*ntzjOH6hIm8Iae6jICLQng.jpeg)

“I wonder why they are making me take a math test”.

Depending on the resources and time available, user testing is always both challenging and necessary.
Even if the resources are low and time is tight, testing a sample of users that is representative of the larger user base of the product is extremely important, even more so than having a large sample which is not representative and thus, biased (see the Literary Digest case in 1936).

Collecting notes — or better yet record the audio — in the most exhaustive way means it is easier if the interviews are conducted with the help of a UX researcher (if possible, or at least another human being who can write) in order to keep both the quality of the notes and the interview high.

### 6.Implement the solution

![](https://cdn-images-1.medium.com/max/600/1*x9iGOrNVqpGhNBbeEfdmpQ.jpeg)

Not suited for children under 3.

So now, is the assumption validated or not? If so, what are the pain points and strengths of the design? Assuming it all went well (assumption validated and minor pain points) the prototype will have to be turned into actual screens and requirements to give the developers. In order to pave the path for future iterations, defining which are the KPIs and success indicators of the feature is a mandatory task that might require help from other team members (marketing people, BE and FE devs).

In case the assumption was not tested it would be necessary to go back to the previous step of designing the solution or even reviewing the problem itself, and start again.

When designing a complex solution — to, most likely, a complex problem — one of the possible strategies might be beginning with implementing the simplest version of the solution, and add complexity over time and releases.

### 7.Ship the feature

![](https://cdn-images-1.medium.com/max/600/1*cGhQi-bu3oMSW9VR4MhWsg.jpeg)

Arrrrrrrr!

Well, this is self explanatory. Just get it out there and let the world know it is out there.

### 8.Follow the feature’s success

![](https://cdn-images-1.medium.com/max/600/1*-iS0o-6nsFu8RnRJjL4s5A.jpeg)

Did he also make the best dressed list?

If everything was rightly done metrics should now be available for gathering.
Checking in with customer care and giving them the heads up about what is going on and setting a preferential channel for customer feedbacks regarding all aspects of the new feature is also a good idea to monitor the the situation.

### 9.Did the solution solve the problem?

![](https://cdn-images-1.medium.com/max/600/1*_4AplAayI8PgFIj-3H3xqQ.jpeg)

Solutions need understanding, too.

The feature has been shipped and available to the public for some time now (weeks or months), and depending on the roadmap and other issues it should be time to ask the question: did the larger user base actually found the problem solved by the implemented solution?

In the perfect world, there are large parties and gathering being held to celebrate the simple brilliant beauty of the solution and world famine is now a memory just because of this feature’s problem solving abilities.

In reality, not everyone is pleased (users and/or teammates), other issues have arisen and it might be time to solve niche problems or — regardless the entire process — we might have missed the mark.
So, let’s keep faith in the process and start all over again (with more insight).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
