> * 原文地址：[As bad as anything else: Part 2](https://ferd.ca/the-zen-of-erlang.html)
> * 原文作者：[Fred T-H](https://ferd.ca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-zen-of-erlang-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-zen-of-erlang-2.md)
> * 译者：
> * 校对者：

# As bad as anything else

## The Zen of Erlang

**如果你还没看本文的第一部分，请先阅读第一部分：[Erlang 之禅：第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/the-zen-of-erlang-1.md)。**

![Bugs that Happen in production](https://ferd.ca/static/img/zen-of-erlang/015.png)

The next connection I want to make is regarding the frequency each of these types of bugs have in production (in my experience). There's no obvious proof that there is any connection between the use of finding bugs and their incidence in production systems, but my gut feeling would tell me that such a connection does exist.

First of all, easy repeatable bugs in core features should just not make it to production. If they do, you have essentially shipped a broken product and no amount of restarting or support will help your users. Those require modifying the code, and may be the result of some deeply entrenched issues within the organisation that produced them.

Repeatable bugs in side-features will pretty often make it to production. I do think this is a result of not taking the time to test them properly, but there's also a strong possibility that secondary features often get left behind when it comes to partial refactorings, or that the people behind their design do not fully consider whether the feature will coherently fit with the rest of the system.

On the other hand, transient bugs will show up all the damn time. Jim Gray, who coined these terms, reported that on 132 bugs noted at a given set of customer sites, only one was a Bohrbug. 131/132 of errors encountered in production tended to be heisenbugs. They're hard to catch, and if they're truly statistical bugs that may show once in a million times, it just takes some load on your system to trigger them all the time; a once in a billion bug will show up every 3 hours in a system doing 100,000 requests a second, and a once in a million bug could similarly show up once every 10 seconds on such a system, but their occurrence would still be rare in tests.

That's a lot of bugs, and a lot of failures if they are not handled properly.

![Bugs Handled by Restarts](https://ferd.ca/static/img/zen-of-erlang/016.png)

So really, how efficient is restarting as a strategy?

Well for repeatable bugs on core features, restarting is useless. For repeatable bugs in less frequently used code paths, it depends; if the feature is a thing very important to a very small amount of users, restarting won't do much. If it's a side-feature used by everyone, but to a degree they don't care much about, then restarting or ignoring the failure altogether can work well. For example, if the facebook 'poke' feature were to be broken (would it still exist), not too many users would notice or see their experience ruined by its failure.

For transient bugs though, restarting is extremely effective, and they tend to be the majority of bugs you'll meet live. Because they are hard to reproduce, that their showing up is often dependent on very specific circumstances or interleavings of bits of state in the system, and that their appearance tends to be in a very small fraction of all operations, restarting tends to make them disappear altogether.

Rolling back to a known stable state and trying again is unlikely to hit the same weird context that causes them. And just like that, what could have been a catastrophe has become little more than a hiccup for the system, something users quickly learn to live with.

You can then make use of logging, tracing, or a variety of introspection tools (which all come out of the box in Erlang) to later find, understand, and fix the issues so they stop happening. Or you could just decide to tolerate them were the effort required to fix the issues too large.

![notorious bsd](https://ferd.ca/static/img/zen-of-erlang/017.png)

This question was asked to me on a forum where I was discussing programming stuff and discussing the Erlang model. I copied it verbatim because it's a great example of a question a lot of people ask when they hear about restarting and Erlang's features.

I want to address it specifically by giving a realistic example of how a system could be designed in Erlang, which will highlight its peculiarities.

![supervision tree demo](https://ferd.ca/static/img/zen-of-erlang/018.png)

With supervisors (rounded squares), we can start creating deep hierarchies of processes. Here we have a system for elections, with two trees: a tally tree and a live reports tree. The tally tree takes care of counting and storing results, and the live reports tree is about letting people connect to it to see the results.

By the order the children are defined, the live reports will not run until the tally tree is booted and functional. The district subtree (about counting results per district) won't run unless the storage layer is available. The storage's cache is only booted if the storage worker pool (which would connect to a database) is operational.

The supervision strategies I mentioned earlier let us encode these requirements in the program structure, and they are still respected at run time, not just at boot time. For example, the tally supervisor may be using a one for one strategy, meaning that districts can individually fail without effecting each other's counts. By contrast, each district (Quebec and Ontario's supervisors) could be employing a rest for one strategy. This strategy could therefore ensure that the OCR process can always send its detected vote to the 'count' worker, and it can crash often without impacting it. On the other hand, if the count worker is unable to keep and store state, its demise interrupts the OCR procedure, ensuring nothing breaks.

The OCR process itself here could be just monitoring code written in C, as a standalone agent, and be linked to it. This would further isolate the faults of that C code from the VM, for better isolation or parallelisation.

Another thing I should point out is that each supervisor has a configurable tolerance to failure; the district supervisor might be very tolerant and deal with 10 failures a minute, whereas the storage layer could be fairly intolerant to failure if expected to be correct, and shut down permanently after 3 crashes an hour if we wanted it to.

In this program, critical features are closer to the root of the tree, unmoving and solid. They are unimpacted by their siblings' demise, but their own failure impacts everyone else. The leaves do all the work and can be lost fairly well — once they have absorbed the data and operated their photosynthesis on it, it is allowed to go towards the core.

So by defining all of that, we can isolate risky code in a worker with a high tolerance or a process that is being monitored, and move data to stabler process as information matures into the system. If the OCR code in C is dangerous, it can fail and safely be restarted. When it works, it transmits its information to the Erlang OCR process. That process can do validation, maybe crash on its own, maybe not. If the information is solid, it moves it to the Count process, whose job is to maintain very simple state, and eventually flush that state to the database via the storage subtree, safely independent.

If the OCR process dies, it gets restarted. If it dies too often, it takes its own supervisor down, and that bit of the subtree is restarted too — without affecting the rest of the system. If that fixes things, great. If not, the process is repeated upwards until it works, or until the whole system is taken down as something is clearly wrong and we can't cope with it through restarts.

There's enormous value in structuring the system this way because error handling is baked into its structure. This means I can stop writing outrageously defensive code in the edge nodes — if something goes wrong, let someone else (or the program's structure) dictate how to react. If I know how to handle an error, fine, I can do that for that specific error. Otherwise, just let it crash!

This tends to transform your code. Slowly you notice that it no longer contains these tons of if/else or switches or try/catch expressions. Instead, it contains legible code explaining what the code should do when everything goes right. It stops containing many forms of second guessing, and your software becomes much more readable.

![supervision subtrees](https://ferd.ca/static/img/zen-of-erlang/019.png)

When taking a step back and looking at our program structure, we may in fact find that each of the subtrees encircled in yellow seem to be mostly independent from each other in terms of what they do; their dependency is mostly logical: the reporting system needs a storage layer to query, for example.

It would also be great if I could, for example, swap my storage implementation or use it independently in other systems. It could be neat, too, to isolate the live reports system into a different node or to start providing alternative means (such as SMS for example).

What we now need is to find a way to break up these subtrees and turn them into logical units that we can compose, reuse together, and that we can otherwise configure, restart, or develop independently.

![OTP apps](https://ferd.ca/static/img/zen-of-erlang/020.png)

OTP applications are what Erlang uses as a solution here. OTP applications are pretty much the code to construct such a subtree, along with some metadata. This metadata contains basic stuff like version numbers and descriptions of what the app does, but also ways to specify dependencies between applications. This is useful because it lets me keep my storage app independent from the rest of the system, but still encode the tally app's need for it to be there when it runs. I can keep all the information I had encoded in my system, but now it is built out of independent blocks that are easier to reason about.

In fact, OTP applications are what people consider to be libraries in Erlang. If your code base isn't an OTP application, it isn't reusable in other systems. [Sidenote: there are ways to specify OTP libraries that do not actually contain subtrees, just modules to be reused by other libraries]

With all of this done, our Erlang system now has all of the following properties defined:

*   what is critical or not to the survival of the system
*   what is allowed to fail or not, and at which frequency it can do so before it is no longer sustainable
*   how software should boot according to which guarantees, and in what order
*   how software should fail, meaning it defines the legal states of partial failures you find yourself in, and how to roll back to a known stable state when this happens
*   how software is upgraded (because it can be upgraded live, based on the supervision structure)
*   how components interdepend on each other

This is all extremely valuable. What's more valuable is forcing every developer to think in such terms from early on. You have less defensive code, and when bad things happen, the system keeps running. All you have to do is go look at the logs or introspect the live system state and take your time to fix things, if you feel it's worth the time.

![sleep at night](https://ferd.ca/static/img/zen-of-erlang/021.png)

With all of this done, I should be able to sleep at night, right? Hopefully yes. What I included here is a small pixelated diagram from a new software deploy we ran at Heroku a couple of years ago.

The leftmost side of the diagram is around September. By that time, our new proxying layer ([vegur](https://github.com/heroku/vegur)) had been in production for maybe 3 months, and we had ironed out most of the kinks in it. Users had no problem, the transition was going smoothly and new features were being used.

At some point, a team member got a very expensive credit card bill for the logging service we were using to aggregate exceptions. That's when we took a look at it and saw the horror on the leftmost side of the diagram: we were generating between 500,000 to 1,200,000 exceptions a day! Holy cow, that was a lot. But was it? If the issue was a heisenbug, and our system was seeing, say 100,000 requests a second, what were the odds of it happening? Something between 1/17000 and 1/7000. Somewhat very frequent, but because it had no impact on service, we didn't notice it until the bandwidth and storage bill came through.

It took us a short while to figure out the error, and we fixed it. You can see that there is still a low rate of exceptions after that, maybe a few dozen thousands a day. They're all things we know of, but are impact-free. Two years later and we haven't bothered to fix it because the system works fine despite that.

![expect failure](https://ferd.ca/static/img/zen-of-erlang/022.png)

At the same time, you can't always just sleep at night. Failures can be out of your control despite your best design efforts.

A couple of years ago I was on a flight to Vancouver starting on its descent when the pilot used the intercom to tell us something a bit like this: "this is your captain speaking, we will be landing shortly. Do not be alarmed as we will stay on the tarmac for a few minutes while the fire department looks over the plane. We have lost some hydraulic component and they want to ensure there is no risk of fire. There are two backup systems for the broken one, and we should be fine."

And we were fine. In this case the airplane was amazingly well designed.

The image for this slide isn't that flight though, it's another one I was on two weeks ago, while the Eastern US were being burrowed under 24 inches of snow. The plane (flight United 734), which I'm sure was as reliable, landed on the runway. When it came time to break though, it made a loud noise, what I assume is the ABS equivalent of aircrafts, but it still kept going.

We ran over the red lights at the end of the runway you see on the picture, and at the end of the tarmac, the plane skid off the runway, missed the onramp, and the front wheel ended up in the grass. Everyone was fine, but this is an example of why great engineering cannot save the day every time.

![danger zone](https://ferd.ca/static/img/zen-of-erlang/023.png)

In fact, operations will always remain a huge factor in successful systems being deployed. This slide is heavily inspired (pretty much stolen in fact) from presentations by Richard Cook. If you don't know him, I urge you to go watch videos of his talks on youtube, they're pretty much all fantastic.

Proper system architecture and development practices can still not replace, or can be broken by inadequate operations; the efficiency and usefulness of tools, playbooks, monitoring, automation, and so on, all tend to implicitly rely on the knowledge and respect of well-defined operating conditions (throughput, load, overload management, etc.) If defined at all, these operational limits let you know when things are about to go bad, and when they are good again.

The problem with these limits is that as operators get used to them, and get used to frequently breaking them without negative consequences, there is a risk of slowly pushing the envelope towards the edge of the danger zone, where nasty large-scale failures happen. Your reaction time and margin to adapt to higher loads erodes, and you eventually end in a position where things are constantly broken with no respite in sight.

So we have to be careful and aware of this kind of thing, and to the importance that people using and operating the software has on it. It is always harder to scale up a good team than it is to scale up a program. Plan for emergencies even if they don't happen; they will some day and you'll be happy you ran simulations and have recipes to follow to fix it all up.

![plane emergency measures](https://ferd.ca/static/img/zen-of-erlang/024.png)

In the case of my flight, as I said, nobody was injured. Still, this is the circus that was deployed for it all: busses to escort passengers back to the terminal, since moving a stranded plane could be risky. Pick-up trucks to escort the busses safely from the runway to the terminal. Police cars, a whole lot of fire trucks, and that black car that I don't know what it does but I'm sure it's super useful.

They deploy all of that despite everyone being fine, despite planes being super reliable. They do things right.

![other goodies](https://ferd.ca/static/img/zen-of-erlang/025.png)

Here's another bunch of things you gain by using Erlang. I don't really have much to say about them, just that I do tend to have some kind of interest in you switching to use it, so here it is.

The last point is worth commenting though. One of the risks that happen in languages that are very flexible in their approach in system design is that libraries you use may not want to do things the way you feel would be appropriate in your case, and you're left either not using the lib, or having to operate codebases with an incoherent design. This doesn't happen in Erlang as everyone uses the same proven approach to do things.

![how things interact](https://ferd.ca/static/img/zen-of-erlang/026.png)

In a nutshell, the Zen of Erlang and 'let it crash' is really all about figuring out how components interact with each other, figuring out what is critical and what is not, what state can be saved, kept, recomputed, or lost. In all cases, you have to come up with a worst-case scenario and how to survive it. By using fail-fast mechanisms with isolation, links & monitors, and supervisors to give boundaries to all of these worst-case scenarios' scale and propagation, you make it a really well-understood regular failure case.

That sounds simple, but it's surprisingly good; if you feel that your well-understood regular failure case is viable, then all your error handling can fall-through to that case. You no longer need to worry or write defensive code. You write what the code should do and let the program's structure dictate the rest. Let it crash.

![zen of erlang](https://ferd.ca/static/img/zen-of-erlang/027.png)

That’s the Zen of Erlang: building interactions first, making sure the worst that can happen is still okay. Then there will be few faults or failures in your system to make you nervous (and when it happens, you can introspect everything at run time!) You can sit back and relax.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
