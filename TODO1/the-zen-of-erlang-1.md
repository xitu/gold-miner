> * 原文地址：[As bad as anything else: Part 1](https://ferd.ca/the-zen-of-erlang.html)
> * 原文作者：[Fred T-H](https://ferd.ca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-zen-of-erlang-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-zen-of-erlang-1.md)
> * 译者：
> * 校对者：

# As bad as anything else
# 就像其它的任何事物一样糟糕

## The Zen of Erlang
## Erlang 之禅

* [As bad as anything else: Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/the-zen-of-erlang-1.md)
* [As bad as anything else: Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/the-zen-of-erlang-2.md)

* [就像其它的任何事物一样糟糕的任何事物一样糟糕：第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/the-zen-of-erlang-1.md)
* [就像其它的任何事物一样糟糕的任何事物一样糟糕：第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/the-zen-of-erlang-2.md)

This is a loose transcript (or long paraphrasing?) of a presentation given at ConnectDev'16, a conference organized by Genetec in which I was invited to speak.
我在由 Genetec 组织的 ConnectDev'16 会上受邀演讲，这个是我所介绍部分的一个松散的副本（或者也可以说是长的释义）

![Erlang 之禅](https://ferd.ca/static/img/zen-of-erlang/001.png)

I assume most people here have never used Erlang, have possibly heard of it, maybe just the name. As such, this presentation will only cover the high level concepts of Erlang, in such a way that it may be useful to you in your work or side projects even if you never touch the language.
我假定这里的大多数人都没有用过 Erlang 进行开发，或许这些人可能听说过它，或许就只是知道名字。在这种情况下，这个介绍只会包含 Erlang 的高层次理念，使用这种方式来讲述的话即使你从未接触过这个语言，它也会对你的工作或小项目有所帮助。

![就让它奔溃吧](https://ferd.ca/static/img/zen-of-erlang/002.png)

If you've ever looked at Erlang before, you've heard about that "Let it crash" motto. My first encounter with it had me wondering what the hell this was about. Erlang was supposed to be great for concurrency and fault tolerance, and here I was being told to let things crash, the entire opposite of what I actually want to happen in a system. The proposition is surprising, but the "Zen" of Erlang is related to it directly nonetheless.

如果你之前曾经了解过 Erlang，那你应该已经听过“就让它奔溃”的箴言。当我第一次遇到它时就在想这到底是什么鬼玩意。Erlang 应该对并行和容错有着很好的支持，但是我却被告知就让它奔溃吧，这完全和我想要这个系统发生的相反。这个主张让人不可思议，但是 Erlang 之禅却和它息息相关。

![爆炸](https://ferd.ca/static/img/zen-of-erlang/003.png)

In some ways it would be as funny to use 'Let it Crash' for Erlang as it would be to use 'Blow it up' for rocket science. 'Blow it up' is probably the last thing you want in rocket science — the Challenger disaster is a stark reminder of that. Then again, if you look at it differently, rockets and their whole propulsion mechanism is about handling dangerous combustibles that can and will explode (and that's the risky bit), but doing it in such a controlled manner that they can be used to power space travel, or to send payloads in orbit.

在一定程度上，在 Erlang 中使用“就让它奔溃”这句话就和在火箭科学中使用“就让它爆炸”一样好笑。在火箭科学中“就让它爆炸”也许是你最不想发生的事-挑战者号空难就是一个鲜明的提醒。相对的如果你用不同的方式来看待这个，火箭和它的整个推进机制都是要处理危险会爆炸的可燃物（这是其中危险的一个点），但是它通过可控的方式来使用这种能量驱动空间旅行或者把载荷送上轨道。

The point here is really about control; you can try and see rocket science as a way to properly harness explosions — or at least their force — to do what we want with them. Let it crash can therefore be seen under the same light: it's all about fault tolerance. The idea is not to have uncontrolled failures everywhere, it's to instead transform failures, exceptions, and crashes into tools we can use.
这里的重点在于控制；你可以尝试把火箭科学看作是一种如何正确驾驭爆炸的方式-或者至少是其中包含的能量-用于做我们想要的事情。就让它奔溃在同样的视角下也是一样的道理：它所有一切都是关于容错。这个想法并不是说让不可控制的错误遍布各处，而是把失败，异常和奔溃转化为我们可以使用的工具。

![用火来灭火](https://ferd.ca/static/img/zen-of-erlang/004.png)

Back-burning and controlled burns are a real world example of fighting fire with fire. In Saguenay–Lac-Saint-Jean, the region I come from, blueberry fields are routinely burnt down in a controlled manner to help encourage and renew their growth. To prevent forest fires, it is fairly frequent to see unhealthy parts of a forest cleaned up with fire, so that it can be done under proper supervision and control. The main objective there is to remove combustible material in such a way an actual wildfire cannot propagate further.
背面燃烧和受控制的燃烧是真实世界中用火来灭火的真实例子。在我出生的加拿大萨格内-圣约翰，蓝莓田会例行以受控的方式烧毁，以帮助支持和延续它们之后的生长。为了防止森林火灾，使用火来清除森林中不健康的部分是很常见的行为，这样森林也能被合适的监督和控制。这里的主要目的是用这种方式来去除可燃材料，这样真实的火灾就不能进一步传播。


In all of these situations, the destructive power of fire going through crops or forests is being used to ensure the health of the crops, or to prevent a much larger, uncontrolled destruction of forested areas.
在所有这些情况下，火对庄稼或者森林的破坏性力量被用于确保庄稼的健康或者是防止森林地区发生更大的无法控制的火灾。

I think this is what 'Let it crash' is about. If we can embrace failures, crashes and exceptions and do so in a very well-controlled manner, they stop being this scary event to be avoided and instead become a powerful building block to assemble large reliable systems.
我认为这就是“就让它奔溃”所描述的。如果我们可以通过一种非常好的控制方式来拥抱失败，奔溃和异常，它们就不会是需要避免的可怕事物，而是成为构建大型可靠系统的强大基石。

![进程/蜜蜂](https://ferd.ca/static/img/zen-of-erlang/005.png)

So the question becomes to figure out how do we ensure that crashes are enablers rather than destructors. The basic game piece for this in Erlang is the process. Erlang's processes are fully isolated, and they share nothing. No process can go and reach into another one's memory, or impact the work it's doing by corrupting the data it operates on. This is good because it means that a process dying is essentially guaranteed to keep its issues to itself, and that provides very strong fault isolation into your system.
所以这个问题就变成想出一个办法确保奔溃是促进者而不是毁灭者。对于这个，Erlang 使用进程作为它的棋子。Erlang 的进程是完全独立的，进程之间不分享任何东西。任何进程都不能进入到其它进程的内存，或者通过破坏它操作的数据来影响它的工作。这样就很棒了，因为这意味着我们可以保证一个进程死亡只会把问题保留在进程内，这就为你的系统带来了非常强大的故障隔离。

Erlang's processes are also extremely lightweight, so that you can have thousands and thousands of them without problem. The idea is to use as many processes as you _need_, rather than as many as you _can_. The common comparison there is to say that if you had an object-oriented language where you could only have 32 objects running at a any given time, you'd rapidly find it overly constraining and quite ridiculous to build programs in that language. Having many small processes does ensure a higher granularity in how thing break, and in a world where we want to harness the power of these failures, this is good!
Erlang 的进程也非常轻量，你就算运行成千上万个也不是问题。这里的想法是使用你_需要_运行数量的进程，而不是你_能_运行数量的进程。这里通常的比较就是说，如果你有一个面向对象的语言，在任何运行时间中只能有 32 个对象，你很快就会发现过度的限制在这种语言中构建程序是非常荒谬的。拥有许多小的进程可以在拆分事物中确保更高的粒度，而且在一个我们想要利用这些失败力量的世界中，这很棒！

Now it can be a bit weird to picture how these processes work exactly. When you write a C program, you have one big `main()` function that does a lot of stuff. This is your entry point into the program. In Erlang, there is no such thing. No process is the designated master of the program. Every one of them runs a function, and that function plays the role of `main()` within that single process.
现在想象这样进程是如何工作的可能会有些奇怪。当你写一个 C 程序时，你有一个大的 `main()` 函数做大量的事情。这个函数是你程序的入口点。在 Erlang 中就没有这样的东西。没有进程是这个程序指定的主进程。每一个进程都运行一个函数，这个函数在那个进程中扮演着 `main()` 函数的角色。

We now have that swarm of bees, but it is probably very hard to direct them to strengthen the hive if they cannot communicate in any way. Where bees dance, Erlang processes pass messages.
我们现在有一群蜜蜂，但是它们如果不能通过任何方式沟通，那就很难管理它们加固蜂巢。蜜蜂是通过舞蹈，而 Erlang 的进程是通过消息传递。

![消息传递](https://ferd.ca/static/img/zen-of-erlang/006.png)

Message passing is the most intuitive form of communication in a concurrent environment there is. It's the oldest one we've worked with, from the days where we wrote letters and sent them via couriers on horse to find their destination, to fancier mechanisms like the Napoleonic semaphores shown on the slide. In this case you'd just take a bunch of guys up into towers, give them a message, and they'd wave flags around to pass data over long distances in ways that were faster than horses, which could tire. This eventually got replaced by the telegraph, which got replaced by the phone and the radio, and now we have all the fancy technologies to pass messages really far and really fast.
在并行环境中，进程间消息传递是最直观的通信形式。这是我们工作过最古老的通信方式，从我们开始写信通过邮差骑马来送到目的地的日子，到这个幻灯片中展示的拿破仑信号塔。在这里，你只需要带着一群人进入塔楼，给他们一个信息，他们就会挥舞旗帜以比骑马更快的方式把信息传递到远方，但这很容易让人疲劳。最终这些都被电报取代了，之后又被电话和收音机取代了，现在我们有了所有很棒的技术来传递消息，消息可以传的很远而且很快。

A critical aspect of all this message passing, especially in the olden days, is that everything was asynchronous, and with the messages being copied. No one would stand on their porch for days waiting for the courier to come back, and no one (I suspect) would sit by the semaphore towers waiting for responses to come back. You'd send the message, go back to your daily activities, and eventually someone would tell you you got an answer back.
所有这些日子特别是过去的消息传递方式其中一个关键在于它们都是异步的，而且消息都会被复制。没有人会站在门廊上等上好几天只是为了寄信的信使回来，也没有人（至少我认为）会坐在信号塔中等消息的响应发回来。你只是会把消息发送出去，然后回去做你的日常工作，最终会有人告诉你有回信了。

This is good because if the other party doesn't respond, you're not stuck doing nothing but waiting on your porch until you die. Conversely, the receiver on the other end of the communication channel does not see the freshly arrived message vanish or change as by magic if you do die. Data _should_ be copied when messages are sent. These two principles ensure that failure during communication does not yield a corrupted or unrecoverable state. Erlang implements both of these.
这很棒因为如果另一边没有回应，你不会傻傻的什么事都不做，而是等在你的门廊前一直到死去。相反，如果你死了，交流通道另一边的接受者所收到的信息不回奇迹般的消失或者改变。我们_应该_在发送消息时把消息复制一遍。这两个原则确保通信过程中的失败不会导致一个损坏或者无法恢复的状态。Erlang 实现了这两个原则。

To read messages, each process has a single mailbox. Everyone can write to a process' mailbox, but only the owner can look into it. The messages are by default read in the order they arrived, but it is possible, through features such as pattern matching [which were discussed in a prior talk during the day] to only or temporarily focus on one kind of message and drive various priorities around.
为了能阅读信息，每个进程都有一个邮箱。每一个进程都可以写信息到一个进程的邮箱，但是只有拥有这个邮箱的进程能查看它。这些信息会默认以它们到达的顺序被读取，但是也有可能通过模式匹配[我们在先前的演讲中讨论过这个]之类的特征来让进程临时只关注一种类型的信息从而驱动不同优先级消息的执行顺序。

![连接&监视器](https://ferd.ca/static/img/zen-of-erlang/007.png)

Some of you will have noticed something in what I have mentioned so far; I keep repeating that isolation and independence are great so components of a system are allowed to die and crash without influencing others, but I did also mention having conversations across many processes or agents.

你们之中的部分人会注意到我刚才所提到的一些事项；我一再重申隔离和独立性是很好的，这样一个系统的组件就可以在不影响其它组件的情况下死亡和奔溃，但是我也提到了在多个进程或者代理之间进行交流。

Every time two processes start having a conversation, we create an implicit dependency between them. There is some implicit state in the system that binds both of them together. If process A sends a message to process B and B dies without responding, A can either wait forever, or give up on having a conversation after a while. The latter is a valid strategy, but it's a very vague one: it is unclear if the remote end has died or is just taking long, and off-band messages can land in your mailbox.



每当有两个进程开始交流数据，我们在它们之间就创建了一个隐形的依赖。系统中会有一些隐形的依赖将它们绑定在一起。如果进程 A 向进程 B 发送了一个消息，但是 B 进程已经死亡而没有响应，那么 A 进程所能做的要么就是永远等着，要么就是在一段时间后放弃和 B 进程的交流。后者是一个有效的策略，但是它也是一个十分模糊的策略：它并不知道远端的那个进程是已经死了还只是处理时间比较长，off-band 消息会发送到你的邮箱。

Instead Erlang gives us two mechanisms to deal with this: monitors and links.

相反，Erlang 为我们提供了处理这种情况的两种机制：监视器和链接

Monitors are all about being an observer, a creeper. You decide to keep an eye on a process, and if it dies for whatever reason, you get a message in your mailbox telling you about it. You can then react to this and make decisions with your newly found information. The other process will never have had an idea you were doing all of this. Monitors are therefore fairly decent if you're an observer or care about the state of a peer.

监视器所做的全部就是一个观察者，一个爬行者。你决定去留意一个进程，如果该进程出于任何原因死亡了，你就可以在你的信箱中获取到关于这个的消息。你就可以对此作出反应并且通过你新发现的信息来做出决定。其它的进程永远也会知道你对于这件事所做的全部事情。如果你是一个观察者或者关注对等进程的状态，那么监视器可以是非常棒的工具。

Links are bidirectional, and setting one up binds the destiny of the two processes between which they are established. Whenever a process dies, all the linked processes receive an exit signal. That exit signal will in turn kill the other processes.

链接是双向的，建立一个链接就会将其所相连的两个进程命运绑定。无论是其中任何一个进程死了，所有相连接的进程都会收到一个退出信号。这个退出信号反过来会杀死其它的所有进程。

Now this gets to be really interesting because I can use monitors to quickly detect failures, and I can use links as an architectural construct letting me tie multiple processes together so they fail as a unit. Whenever my independent building blocks start having dependencies among themselves, I can start codifying that into my program. This is useful because I prevent my system from accidentally crashing into unstable partial states. Links are a tool letting developers ensure that in the end, when a thing fails, it fails entirely and leaves behind a clean slate, still without impacting components that are not involved in the exercise.

现在这就变得很有趣了，因为我们使用监控器来快速的检测到失败，而且我还能使用链接作为一个架构构造能够把多个进程绑定在一起共同作为一个失败的单元。无论何时我独立构建的模块开始有相互之间的依赖，我能够开始把这些依赖写入我的代码中。这很有用，因为这样就可以防止我的系统意外奔溃进入到一个不稳定的局部状态。链接是一种工具，它可以开发人员确保当其中一件事失败时，最终会完全失败并留下一个空的白板，而不会影响这个运行中没有牵涉到的组件。

For this slide, I picked a picture of mountain climbers roped together. Now if mountain climbers only had links between them, they would be in a sorry state. Every time a climber from your team would slip, the rest of the team would instantly die. Not a great way to go about things.

在这个幻灯片中，我选了一张登山者通过绳子连在一起的照片。现在如果登山者之间只有这个链接，他们恐怕会陷入一个遗憾的状态。任何时间你队伍里的登山者滑倒，队里的其他人也会马上滑倒死去。这并不是一个做事情的好办法。

Erlang instead lets you specify that some processes are special and can be flagged with a `trap_exit` option. They can then take the exit signals sent over links and transform them into messages. This lets them recover faults and possibly boot a new process to do the work of the former one. Unlike mountain climbers, a special process of that kind cannot prevent a peer from crashing; that is the responsibility of that peer by using `try ... catch` expressions, for example. A process that traps exits still has no way to go play in another one's memory and save it, but it can avoid dying of it.

相反，Erlang 可以让你指定某些进程是特殊的，这些进程会使用 `trap_exit` 选项作为标记。然后他们可以接受链接发送过来的退出信号并且将它们转化为消息。这可以让它们从错误中恢复过来并且可能启动一个新的进程来做之前死掉进程的工作。不像登山者那样，这种特殊的进程不能防止一个对等进程奔溃；这是这个对等进程的责任来确保自己不会挂掉，比如说通过 `try ... catch` 表达式。一个收到退出信号的进程没有办法可以进入另一个进程的内存并且保存这些内存，但是它可以避免因为这个而死去。

This turns out to be a critical feature to implement supervisors. If you haven't heard of them, we'll get to them soon enough.
这成为了实施监督者的关键特性。如果你从来没有听说过这些，我们很快就会接触到这些。

![抢先式调度](https://ferd.ca/static/img/zen-of-erlang/008.png)

Before going to supervisors, we still have a few ingredients to be able to successfully cook a system that leverages crashes to its own benefit. One of them is related to how processes are scheduled. For this one, the real world use case I want to refer to is Apollo 11's lunar landing.
在进入监督者这部分之前，我们仍需要一点调料才能成功的烘焙一个系统，这个系统利用奔溃来实现自身的优势。其中之一与流程如何调度有关。对于这方面，我想提到的真实世界例子是 Apollo 11 号的登月

Apollo 11 is the mission that went to the moon in '69. In the slide right there, we see the lunar module with Buzz Aldrin and Neil Armstrong on board, with a photo taken by a person I assume to be Michael Collins, who stayed in the command module for the mission.
Apollo 11 号是在 69 年的登月任务。在这个幻灯片中，我们看到 Buzz Aldrin 和 Neil Armstrong 的登月舱，这张照片我认为是  Michael Collins 拍的，他在这次任务汇总留在了指挥舱中。

While on their way to land on the moon, the lunar module was being guided by the Apollo PGNCS (Primary Guidance, Navigation and Control System). The guidance system had multiple tasks running on it, taking a carefully accounted for number of cycles. NASA had also specified that the processor was only to be used to 85% capacity, leaving 15% free.
在他们登月的途中，登月舱将由 Apollo PGNCS（主要指挥，导航和控制系统） 所操纵。这个指导系统有多个任务在运行，它们的运行周期数是被仔细斟酌过的。NASA 也指出所有任务运行至占用了处理器 85% 的容量，还剩下 15% 的空间。

Now because the astronauts in this case wanted a decent backup plan in case they needed to abort, they had left a rendezvous radar up in case it would come in handy. That took up a decent chunk of the capacity the CPU had left. As Buzz Aldrin started entering commands, error messages would pop up about overflow and basically going out of capacity. If the system was going haywire on this, it possibly couldn't do its job and we could end up with two dead astronauts.
现在因为宇航员在想要中断运行的情况下需要一个完善的备份计划，他们已经在处理器中留下一个会合雷达运行以防万一它能派上用场。这会用掉 CPU 剩余的大部分容量。随着 Buzz Aldrin 开始输入指令，关于溢出的错误消息会出现并且基本上用光了全部容量。如果这个系统在这方面出现了出了问题，它可能就无法完成它的工作最终我们可能会有两名死去的宇航员。


This was mostly because the radar had known hardware bugs causing its frequency to be mismatched with the guidance computer, and caused it to steal far more cycles than it should have had otherwise. Now NASA people weren't idiots, and they reused components with which they knew the rare bugs they had rather than just greenfielding new tech for such a critical mission, but more importantly, they had devised priority scheduling.
这主要是由于雷达存在已知的硬件错误，导致它的频率和指导计算机不匹配，这就导致它窃取了比其本来应该有更多的运行周期。现在 NASA 的人也不是白痴，在这种关键的任务中他们重用了他们所知道之前用过有罕见错误的组件，而不是研发一个新的技术。但是更重要的是，他们设计了优先级调度。


This meant that even in the case where either this radar or possibly the commands entered were overloading the processor, if their priority were too low compared to the absolutely life-critical stuff, the task would get killed to give CPU cycles to what really, really needed it. That was in 1969; today there's still plenty of languages or frameworks that give you _only_ cooperative scheduling and nothing else.
这意味着即使因为这种雷达或者输入命令导致处理器过载的情况下，如果它们的运行优先级与性命攸关的事件相比很低，那么这些任务将被杀死，从而把 CPU 运行周期给真正，真正需要它的任务。那是在 1969 年；在今天仍然有大量的语言或者框架给你的_只是_合作调度，除此之外别无他有。


Erlang is not a language you'd use for life-critical systems — it only respects soft-real time constraints, not hard real time ones and it just wouldn't be a good idea to use it in these scenarios. But Erlang does provide you with preemptive scheduling, and with process priorities. This means that you do not _have_ to care, as a developer or system designer, about making sure that absolutely everyone carefully counts all the CPU usage they're going to be doing across all their components (including libraries you use) to ensure they don't stall the system. They just won't have that capacity. And if you need some important task to always run when it must, you can also get that.
Erlang 并不是一种用于构建生命攸关系统的语言 - 它只遵循软实时时间约束，而不是实时时间约束所以在这些场景中使用它并不是一个好主意。但是 Erlang 为你提供了抢先试调度以及进程优先级。这就意味着作为一个开发者或者系统设计人员，你并不_需要_去关心关于确保每个人都仔细统计他们所有组件（包括使用的库）CPU 使用量确保不会拖延整系统。他们并没有这个能力。而且如果你需要一些重要任务在它必须运行时总能运行，你也能实现这个。

This may not seem like a big or common requirement, and people still ship really successful projects only with cooperative scheduling of concurrent tasks, but it certainly is extremely valuable because it protects you against the mistakes of others, and also against your own mistakes. It also opens up the door to mechanisms like automated load-balancing, punishing or rewarding good and bad processes or giving higher priorities to those with a lot of work waiting for them. Those things can end up giving you systems that are fairly adaptive to production loads and unforeseen events.
这似乎并不是一个大的或者通用的需求，人民还是能通过协作式的并发任务开发真正成功的项目，但是它确实十分有价值，因为它可以保护你免受其他人的错误，而且也可以抵制你自己的错误。它还为像自动负载平衡，惩罚和奖励好或者坏的进程或者给予等待做大量工作的进程更高优先级提供了实现机制。这些东西最终都会使你的系统更好的适应生产环境负载和处理意外事件。

![网络意识](https://ferd.ca/static/img/zen-of-erlang/009.png)

The last ingredient I want to discuss in getting decent fault tolerance is network awareness. In any system we develop that we need to stay up for long periods of time, having more than one computer to run it on quickly becomes a prerequisite. You don't want to be sitting there with your own golden machine locked behind titanium doors, unable to tolerate any disruption with effecting your users in major ways.
我想讨论获得优雅容错性的最后一个调料是网络意识。在任何我们开发的需要长时间运行的系统中，让多台计算机快速的运行这个系统是一个先决条件。你不会想坐在你由钛门所在里面的金色机器旁边，却不能忍受任何方式引起的中断影响到你的用户。



So you eventually need two computers so one can survive a broken other, and maybe a third one if you want to deploy with broken computers part of your system.
所以最终你需要两台计算机，这样一台机器可以在另一台破环时继续提供服务，如果你想要在破掉的计算机还是你系统一部分的时候部署，那么你或许就需要第三台。

The plane on the slide is the F-82 twin mustang, an aircraft that was designed during the second world war to escort bombers over ranges most other fighters just couldn't cover. It had two cockpits so that pilots could take over and relay each other over time when tired; at some point they also fit it so one would pilot while the other would operate radars in an interceptor role. Modern aircrafts still do something similar; they have countless failovers, and often have crew members sleeping in transit during flight time to make sure there's always someone who's alert ready to pilot the plane.
这个幻灯片中的飞机是 F-82 双生野马，这是一架在第二次世界大战期间设计的飞机，用于护送大多数其它战机无法覆盖范围内的轰炸机。它有两个驾驶舱，这样随着时间推移，驾驶员可以互相替换当另一个觉得累时；在一些情况下，他们也能配合它其中一个人飞行的时候，另一个可以操作雷达作为拦截者的角色。现代飞机仍然在做类似的一些事情；他们数不清的缺陷，经常有机组人员在飞行期间的途中睡觉，以确保总有人能警惕地准备好驾驶飞机。

When it comes to programming languages or development environments, most of them are designed ignoring distribution altogether, even though people know that if you write a server stack, you need more than one server. Yet, if you're gonna use files, there's gonna be stuff in the standard library for that. The furthest most languages go is giving you a socket library or an HTTP client.
当这个说法用于编程语言或者开发环境，他们中大多数的设计都完全忽略了分布式，尽管人门都知道如果你写的是服务器栈，那么你就需要不止一台服务器。然而，如果你要使用文件，就会有标准库帮你完成这些事情。大多数语言更进一步就是给你一个套接字库或者 HTTP 客户端。

Erlang acknowledges the reality of distribution and gives you an implementation for it, which is documented and transparent. This lets people set up fancy logic for failing over or taking over applications that crash to provide more fault tolerance, or even lets other languages pretend they are Erlang nodes to build polyglot systems.
Erlang 意识到了分布式的现实并且为你提供了一个实现，这个实现是有文档记录而且透明的。这可以让人们为故障转移设或者是接管奔溃的应用设置设想的逻辑从而提供更高的容错性，甚至可以让其它语言假装它们是 Erlang 的节点来构建多边形系统。

![就让它奔溃吧。](https://ferd.ca/static/img/zen-of-erlang/010.png)

So those are all the basic ingredients in the recipe for Erlang Zen. The whole language is built with the purpose of taking crashes and failures, and making them so manageable it becomes possible to use them as a tool. Let it crash starts making sense, and the principles seen here are for the most part things that can be reused as inspiration in non-Erlang systems.
所以所有这些就是 Erlang 之禅食铺的基本调料。这整个语言的目的在于获得崩溃和失败，并使它们如此易于管理，从而有可能将它们用作工具。让它崩溃开始有道理起来了，这里看到的原则大部分都是可以在非 Erlang 系统中作为灵感重用的。

How to compose them together is the next challenge.
如何将它们组合在一起是下一个挑战。

![监管树](https://ferd.ca/static/img/zen-of-erlang/011.png)

Supervision trees is how you impose structure to your Erlang programs. They start with a simple concept, a supervisor, whose only job is to start processes, look at them, and restart them when they fail. By the way, supervisor are one of the core components of 'OTP', the general development framework used in the name 'Erlang/OTP'.

监管树描述的是如何实施你的 Erlang 程序架构。它们源自于一个简单的观念，有一个监管者，它唯一的工作就是启动进程，关注进程的运行，然后在它们运行失败时重启它们。顺便提下，监管者是 ‘OTP’ 的核心组件之一，它是被广泛使用的开发框架名字叫做 ‘Erlang/OTP’。

The objective of doing that is to create a hierarchy, where all the important stuff that must be very solid accumulate closer to the root of the tree, and all the fickle stuff, the moving parts, accumulate at the leaves of the tree. In fact, that's what most trees look like in real life: the leaves are mobile, there's a lot of them, they can all fall down in autumn, the tree stays alive.
这样做的目的是创建一个层级结构，在这个结构中所有重要必须稳定运行的东西越接近树的根部，而所有易变的移动的部分则会积累在叶子部分。事实上，这就是现实生活中大多数树木的样子：树叶不是固定的，树上会有很多树叶，在秋天它们都会飘落下来，而这个树仍然活着。


That means that when you structure Erlang programs, everything you feel is fragile and should be allowed to fail has to move deeper into the hierarchy, and what is stable and critical needs to be reliable is higher up.
这意味着当你构建 Erlang 程序时，任何你觉得脆弱的可以运行失败的进程应该这个层级的更深处，而稳定而且可靠性要求很高的应该移到层级上面。

![监管者们](https://ferd.ca/static/img/zen-of-erlang/012.png)

Supervisors can do that through usage of links and trapping exits. Their job begins with starting their children in order, depth-first, from left to right. Only once a child is fully started does it go back up a level and start the next one. Each child is automatically linked.
监管者是通过使用链接和捕捉杀害来实现这个功能的。它们的工作从一次启动它们的子进程开始，从上往下，从左到右。只有当一个子进程完全开始之后它才会返回上个层级开始创建下一个子进程。每一个子进程都会被自动的链接。

Whenever a child dies, one of three strategies is chosen. The first one on the slide is 'one for one', enacted by only replacing the child process that died. This is a strategy to use whenever the children of that supervisor are independent from each other.
每当一个子进程死亡时，有以下三个策略可供选择。第一个策略在这个幻灯片中就是 ‘一对一’，通过替换死去的子进程来实现。当监管者的所有子进程相互之间都独立时，都可以使用这个策略。

The second strategy is 'one for all'. This one is to be used when the children depend on each other. When any of them dies, the supervisor then kills the other children before starting them all back. You would use this when losing a specific child would leave the other processes in an uncertain state. Let's imagine a conversation between three processes that ends with a vote. If one of the process dies during the vote, it is possible that we have not programmed any code to handle that. Replacing that dead process with a new one would now bring a new peer to a table that has no idea what is going on either!
第二个策略是‘一即是全部’。这个策略用于子进程之间存在相互依赖关系。当它们中的任何一个死去时，监管者就会把它们全部重新启动之前把其它所有子进程都杀掉。当失去一个特殊的子进程会使其它进程变为一个不确定的状态时，你就可以使用这个策略。让我们想象三个进程之间以投票结束的一个对话。如果在投票过程中其中一个进程死亡，那么可能我们并没有编写任何代码来处理这个问题。用一个新的替换死去的进程会在表格上带来一个新的同伴，而其中的所有进程都不知道接下来该做什么。

This inconsistent state is possibly dangerous to be in if we haven't really defined what goes on when a process wreaks havoc through a voting procedure. It is probably safer to just kill all processes, and start afresh from a known stable state. By doing so, we're limiting the scope of errors: it is better to crash early and suddenly than to slowly corrupt data on a long-term basis.
如果我们没有真正定义当一个进程在投票过程中造成严重破坏时要怎么做，那么这种不一致的状态可能是有危险的。相比于这个，杀死所有的进程可能更安全，然后从已知稳定的状态重新开始。通过这样做我们就可以限制错误的范围：在错误发生时早点立即奔溃会比慢慢且长时间毁坏数据要更好。

The last strategy happens whenever there is a dependency between processes according to their booting order. Its name is 'rest for one' and if a child process dies, only those booted after it are killed. Processes are then restarted as expected.
当进程之间根据它们的启动顺序有依赖关系时通常可以用最后这种策略。它的命名叫做‘一个所剩下的’，当一个子进程死亡时，之后在它后面启动的进程会被杀死。然后进程就会像之前预期的那样重新启动。

Each supervisor additionally has configurable controls and tolerance levels. Some supervisors may tolerate only 1 failure per day before aborting while others may tolerate 150 per second.
每个监管者还额外有课配置的控制和忍耐级别。一些监管者可能中断之前每天只能忍受一个故障，而其它的或许可以每秒承受 150 个故障。

![Heisenbugs](https://ferd.ca/static/img/zen-of-erlang/013.png)

The comment that usually comes right after I mention supervisors is usually to the tune of "but if my configuration file is corrupted, restarting won't fix anything!"
在我提到监管者之后大家通常都会提及的评论就是“但是如果我的配置文件就是错的，重启并不能解决任何问题”。

That is entirely right. The reason restarting works is due to the nature of bugs encountered in production systems. To discuss this, I have to refer to the terms 'Bohrbug' and 'Heisenbug' coined by Jim Gray in 1985 (I do recommend you read as many Jim Gray papers as you can, they're pretty much all great!)
这完全正确。重启有效的原因在于生产环境系统中所遇到的错误性质。为了讨论这个问题，我必须提及 Jim Gray 在 1985 年提出的 ‘Bohrbug’ 和 ‘Heisenbug’ 这两个术语（我建议你尽可能多读下  Jim Gray 的论文，它们几乎都写的很棒！）。

Basically, a bohrbug is a bug that is solid, observable, and easily repeatable. They tend to be fairly simple to reason about. Heisenbugs by contrast, have unreliable behaviour that manifests itself under certain conditions, and which may possibly be hidden by the simple act of trying to observe them. For example, concurrency bugs are notorious for disappearing when using a debugger that may force every operation in the system to be serialised.
基本上来看，一个 bohrbug 是一个稳定的，可观察的而且可复现的错误。它们倾向于开发者可以容易地推测出原因。相反 Heisenbug 具有不可靠的行为，它不会在必然的条件中出现，而且如果只是采取简单的行为尝试去观测这些问题时它们可能会被隐藏起来。比如说在系统中使用每个操作都会被序列执行的调试器时，并发错误就无法查找出来。

Heisenbugs are these nasty bugs that happen once in a thousand, million, billion, or trillion times. You know someone's been working on figuring one out for a while once you see them print out pages of code and go to town on them with a bunch of markers.
Heisenbugs 是这些在一千次，百万次，十亿次或者万亿次错误中才会出现一次的令人讨厌的错误。当你看到有人打印了一页又一页的代码以及在它们中填上一大推标记时，你就知道他是处理这种类型的错误有一段时间了。

With these terms defined, let's look at what should be their frequencies.
定义了这些术语之后，让我们来看看它们的出现频率应该是多少。

![在生产环节中查找错误就是这么简单](https://ferd.ca/static/img/zen-of-erlang/014.png)

Here I'm classifying bohrbugs as repeatable, and heisenbugs as transient.
在这里，我把 bohrbugs 列为可重复的错误类型，把 heisenbugs 列为暂时的错误类型。

If you have bohrbugs in your system's core features, they should usually be very easy to find before reaching production. By virtue of being repeatable, and often on a critical path, you should encounter them sooner or later, and fix them before shipping.
如果你在你系统的核心功能中有 bohrbugs，那么当这个系统到达生产环境之前它们应该很容易被找出来。通过可重复性，以及这类错误通常在程序运行的关键路径上，你应该迟早会遇到它们，而且在到下一个阶段之前修复它们。

Those that happen in secondary, less used features, are far more of a hit and miss affair. Everyone admits that fixing all bugs in a piece of software is an uphill battle with diminishing returns; weeding out all the little imperfections takes proportionally more time as you go on. Usually, these secondary features will tend to gather less attention because either fewer customers will use them, or their impact on their satisfaction will be less important. Or maybe they're just scheduled later and slipping timelines end up deprioritising their work.
那些发生在次要的，更少使用的功能上的错误，更像是提醒和错过的事。每个人都承认的是修复软件中的全部错误是一件艰苦的战争，为此得到的收益是递减的；随着你继续编写代码，除去其中的小缺陷可能要花越来越多的时间。通常情况下，这些次要功能往往会收到较少的关注，不仅因为较少的客户会使用它们，还因为它们对满意度的影响并没有那么重要。或者也许它们只是要晚些时候安排修复而且把时间表拖后最终会降低开发人员处理这个的重要度。

In any case, they are somewhat easy to find, we just won't spend the time or resources doing so.
在任何情况下，它们在一定程度上都挺容易找到的，我们只是没有时间或者资源来做这件事。

Heisenbugs are pretty much impossible to find in development. Fancy techniques like formal proofs, model checking, exhaustive testing or property-based testing may increase the likelihood of uncovering some or all of them (depending on the means used), but frankly, few of us use any of these unless the task at hand is extremely critical. A once in a billion issue requires quite a lot of tests and validation to uncover, and chances are that if you've seen it, you won't be able to generate it again just by luck.
Heisenbugs 几乎不可能在开发过程中发现它们。像形式证明，模型检查，穷举测试或者基于属性的测试这些很棒的技术可能会增加发现其中一部分或者全部（取决于所用方法）的可能性，但是坦白讲，除非手头上的任务是非常关键的，否则我们中很少有人使用这些技术。在数十亿次中出现一次的问题就需要大量的测试和验证才能发现，而且如果你已经看到过这个错误，那么很可能没那么好运行再次产生这个错误。

**更多内容请见本文第二部分：[Erlang 之禅：第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/the-zen-of-erlang-2.md)。**

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
