
> * 原文地址：[We analyzed thousands of coding interviews. Here’s what we learned](https://medium.freecodecamp.org/we-analyzed-thousands-of-coding-interviews-heres-what-we-learned-99384b1fda50)
> * 原文作者：[Aline Lerner](https://medium.freecodecamp.org/@alinelernerllc)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/we-analyzed-thousands-of-coding-interviews-heres-what-we-learned.md](https://github.com/xitu/gold-miner/blob/master/TODO/we-analyzed-thousands-of-coding-interviews-heres-what-we-learned.md)
> * 译者：tanglie1993[https://github.com/tanglie1993]
> * 校对者：

# 我们对数千个编程面试的分析结果

---

# 我们对数千个编程面试的分析结果

![](https://cdn-images-1.medium.com/max/2000/1*nJCm0Uc5BOq12faK2KR4Dw.jpeg)

*注意：我写了这个帖子中的绝大部分内容，但传说中的 *[*Dave Holtz*](https://twitter.com/daveholtz)* 完成了数据处理的主要工作。我们可以在 *[*他的博客*](http://daveholtz.net/) *中看到他的其它成果。*

如果你正在读这个帖子，很有可能，你正打算重新进入疯狂而可怕的技术面试的世界。

也许你是一个在读或刚毕业的学生，即将首次经历面试的流程。也许你是一个有经验的软件工程师，已经有几年没考虑过参加面试了。

无论哪种情况，面试流程的第一步，通常是读一堆在线面试指南（特别是由你感兴趣的公司写的那些），并和朋友们聊起他们面试（作为面试官和面试者）的经验。

More likely than not, what you read and learn in this first, “exploratory” phase of the interview process will inform how you choose to prepare moving forward.

There are a few issues with this typical approach to interview preparation:

- 绝大多数面试指南是从一个公司的角度写的。可能A公司很重视高效的代码，而B公司更重视的是高级的问题解决能力。除非你一心想去A公司，否则你大概不想太侧重于他们所关心的能力。
- 人们有时会撒谎，虽然可能不是故意的。他们可能会写“我们不关心具体的编程语言”，或是“哪怕答案不正确，解释你的思路也是值得的”。但是，实际上他们未必会这样做！我们并不是说科技公司是故意误导求职者的骗子。我们只是认为：有时候不明显的偏见会偷偷产生，人们甚至没有意识到它。
- 你从朋友或认识的人那里听到的传闻并不一定有事实根据。很多人认为短的面试意味着失败。同样，每个人都可以回忆起一个很长的面试，在这面试结束后他们以为：“我成功打动了面试官，我肯定可以进入下个阶段”。过去， [我们发现人们衡量自己面试表现的能力相当差](http://blog.interviewing.io/people-are-still-bad-at-gauging-their-own-interview-performance-heres-the-data/)。现在，我们打算直接观察诸如面试时长之类的指标，看看它们是否真的重要。

在我的公司 [interviewing.io](http://interviewing.io)中，我们用独特的数据驱动方式去分析技术面试及其结果。我们有一个平台，可以让面试者匿名练习技术面试。如果事情顺利，他们可以解锁匿名参加真实面试的功能。他们可以在任何时间参加 Uber, Lyft, 和 Twitch等顶级公司的面试。

有意思的是，练习面试和真实面试都发生在 interviewing.io 生态系统内。结果，我们可以收集到相当多的面试数据，用来分析并帮助我们更好地理解技术面试：它们传递的信号，什么有用，什么没有用，以及面试的哪些方面可能真的影响结果。

每一个面试，无论是真实的还是用于练习的，开始时都有面试官和面试者，他们在一个合作式的编程环境中，有语音、文字聊天，以及一块白板。他们可以直接开始讨论技术问题。

面试问题通常属于后端开发电话面试中常见的问题。

**在这些面试中，我们收集发生的一切。包括音频、面试者写的代码的数据和元数据，面试官和面试者对面试过程和对方的评价。**

如果你好奇，你可以在下方看到面试者和面试官的反馈表格的样子——除了一个直接的是/否问题以外，我们还问了不同方面的面试表现（使用1-4分的评分表）。

我们还问了面试者一些额外的问题，这部分问题面试官是不知道的。其中一个问题是，面试者以前有没有见过刚才的面试问题。

![](https://cdn-images-1.medium.com/max/1600/1*WG4CovbdT88jxPEqXZBuiQ.png)

面试官反馈表格

![](https://cdn-images-1.medium.com/max/1600/1*FRfeOXn8visxr36sKprDNw.png)

面试者反馈表格

### 结果

在深入探究之前，需要注意：这些结论都是基于观察数据的，这意味着我们不能声称其中有很强的因果关系。但我们仍然可以分享观察到的奇特规律，并且解释我们发现了什么，以便让你做出自己的结论。

#### Having seen the interview question before

> *“我们正在讨论的是练习！”* ——阿伦·艾弗森

从首要的东西开始。不算很聪明的人就能发现，最好的提升面试表现的方法之一是……练习面试。现在有大量的资源帮助你练习，包括我们自己的。做练习题的主要好处之一是：你被问到没见过的问题的概率会降低。如果你已经做过一两次的话，平衡一棵二叉树就显得不那么可怕了。

我们观察了3000个左右的面试，并把面试者见过与没有见过面试问题的结果相比较。你可以在下面的图中看到结果。

![](https://cdn-images-1.medium.com/max/1600/1*0ha_0_L7WbspbayJet6N1g.png)

**不出意料，见过题目的面试者通过的概率比没有见过的多16.6%。** 这个差异是统计显著的——所有的误差条都表示95%置信区间。

#### 用什么语言编程重要吗？

> *“Whoever does not love the language of his birth is lower than a beast and a foul smelling fish.” — *Jose Rizal

你可能认为，使用不同的语言会使面试得到更好的结果。比如，Python的可读性会对面试有帮助。或者，有些语言处理数据结构的方式特别干净，会让常见的面试问题变得简单。我们想看看，使用不同的语言是否会对面试结果产生显著影响。

我们把自己平台上的面试按照语言分组，并过滤掉了面试数量小于5个的语言（这只删去了少量的几个面试）。然后，我们就可以看到面试结果随语言变化的函数。

分析结果在下表中显示。任何不重叠的置信区间都表示不同语言通过面试概率的显著差异。

虽然我们没有把所有语言逐对比较，但是下面的数据显示，总的来说，** 不同语言的面试通过率没有显著的差异。**（我们的平台上还有其它的语言，但语言越没名气，我们的数据点就越少。例如，所有用 [Brainfuck](https://en.wikipedia.org/wiki/Brainfuck) 的面试都很成功。开个玩笑。）

![](https://cdn-images-1.medium.com/max/2000/1*S1-Aj4ZEKgyuihnFftCD6w.png)

我们观察到的最常见的错误之一是：人们选择自己并不熟悉的语言，然后弄错了查看数组长度、遍历数组、创建哈希表之类的基本操作。但这只是我们定性的结论，没有统计数据支持。

当面试者故意选择一种时髦的语言，以试图打动面试官的时候，这种错误对他非常不利。相信我们，选择自己熟悉的语言，比时髦但不熟悉的语言更好。每一次都是这样。

#### 哪怕语言并不重要……使用该公司选用的语言是否有优势？

> *“救命，我已经变成本地人了。”* — Margaret Blaine

总的来说，语言和面试表现并没有特别紧密的关系。这很好。但是对方公司使用的语言可能会影响面试结果。一个使用 Ruby 的公司可能会说：“我们只雇佣 Ruby 程序员，如果你使用 Python 我们就不太可能雇你。”

而在另一方面，一个完全使用 Python 的公司会对使用 Python 的面试者更苛刻——他们完全了解这种语言，可能会因为面试者对 Python 的使用不完全地道而对他有意见。

下面的表和使用不同语言的面试成功率（也是用面试官愿意雇用面试者的概率来表示）的表很相似。但是，这个表是用面试语言是否在公司的技术栈内来分类的。

我们把这个分析限制在 C++, Java 和 Python ，因为这三种语言都有很多公司用和不用它们。** 结果并不一致。对于 Python 和 C++而言，面试者使用的语言是否在公司的技术栈内，并不会对成功率产生显著的影响。但是，使用 Java 的面试者在使用 Java 的公司面试时，更有可能成功**(p=0.037)。

那么，为什么公司使用的语言是 Java 时，So, why is it that coding in the company’s language seems to be helpful when it’s Java, but not when it’s Python or C++? One possible explanation is that the communities that exist around certain programming languages (such as Java) place a higher premium on previous experience with the language. Along these lines, it’s also possible that interviewers from companies that use Java are more likely to ask questions that favor those with a pre-existing knowledge of Java’s idiosyncrasies.

![](https://cdn-images-1.medium.com/max/2000/1*scSrZGC6Zy9a_ij1S0kZsg.png)

#### What about the relationship between what language you program in and how good of a communicator you’re perceived to be?

> *“To handle a language skillfully is to practice a kind of evocative sorcery.”* — Charles Baudelaire

Even if language choice doesn’t matter that much for overall performance (Java-wielding companies notwithstanding), we were curious whether different language choices led to different outcomes in other interview dimensions.

For instance, an extremely readable language, like Python, may lead to interview candidates who are assessed to have communicated better. On the other hand, a low-level language like C++ might lead to higher scores for technical ability.

Furthermore, very readable or low-level languages might lead to correlations between these two scores (for instance, maybe they’re a C++ interview candidate who can’t explain at all what he or she is doing but who writes very efficient code). The chart below suggests that there isn’t really any observable difference between how candidates’ technical and communication abilities are perceived, across a variety of programming languages.

![](https://cdn-images-1.medium.com/max/1600/1*Cin1yM1gw62D2Gl1fhdG-w.png)

**Furthermore, no matter what, poor technical ability seems highly correlated with poor communication ability — regardless of language, it’s relatively rare for candidates to perform well technically but not effectively communicate what they’re doing (or vice versa)**, largely (and fortunately) debunking the myth of the incoherent, fast-talking, awkward engineer.

(The best engineers I’ve met have also been legendarily good at breaking down complex concepts and explaining them to laypeople. Why the infuriating myth of the socially awkward, incoherent tech nerd continues to exist, I have absolutely no idea.)

#### Interview duration

> *“It’s fine when you careen off disasters and terrifyingly bad reviews and rejection and all that stuff when you’re young; your resilience is just terrific.” — *Harold Prince

We’ve all had the experience of leaving an interview and just feeling like it went poorly. Often, that feeling of certain underperformance is motivated by rules of thumb that we’ve either come up with ourselves or heard repeated over and over again. You might find yourself thinking, “the interview didn’t last long? That’s probably a bad sign… ” or “I barely wrote anything in that interview! I’m definitely not going to pass.” Using our data, we wanted to see whether these rules of thumb for evaluating your interview performance had any merit.

First, we looked at the length of the interview. Does a shorter interviewer mean you were such a train wreck that the interviewer just had to stop the interview early? Or was it maybe the case that the interviewer had less time than normal, or had seen in just a short amount of time that you were an awesome candidate? The plot below shows the distributions of interview length (measured in minutes) for both successful and unsuccessful candidates.

**A quick look at this chart suggests that there is no difference in the distribution of interview lengths between interviews that go well and interviews that don’t — the average length of interviews where the interviewer wanted to hire the candidate was 51.00 minutes, whereas the average length of interviews where the interviewer did not was 49.95 minutes. This difference is not statistically significant**.

(For every comparison of distributions in this post, we use both a Fisher-Pitman permutation test to compare the difference in the means of the distributions.)

![](https://cdn-images-1.medium.com/max/1600/1*kUsYEVIdbSKNWH5Ea-ks_w.png)

#### Amount of code written

> *“Brevity is the soul of wit.”* -William Shakespeare

You may have experienced an interview where you were totally stumped. The interviewer asks you a question you barely understand, you repeat back to him or her “binary search what?”, and you basically write no code during your interview. You might hope that you could still pass an interview like this through sheer wit, charm, and high-level problem-solving skills. In order to assess whether or not this was true, we looked at the final character length of code written by the interviewee. The plot below shows the distributions of character length for both successful and unsuccessful. A quick look at this chart suggests that there is a difference between the two — interviews that don’t go well tend to have less code. There are two phenomena that may contribute to this. First, unsuccessful interviewers may write less code to begin with. Additionally, they may be more prone to delete large swathes of code they’ve written that either don’t run or don’t return the expected result.

![](https://cdn-images-1.medium.com/max/2000/1*OyxyeBmyDfMdJaYyCDi6ng.png)

**On average, successful interviews had final interview code that was on average 2045 characters long, whereas unsuccessful ones were, on average, 1760 characters long.** That’s a big difference! This finding is statistically significant and probably not very surprising.

#### Code modularity

> *“The mark of a mature programmer is willingness to throw out code you spent time on when you realize it’s pointless.” — *Bram Cohen

In addition to just look at *how much* code you write, we can also think about the type of code you write. Conventional wisdom suggests that good programmers don’t recycle code — they write modular code that can be reused over and over again. We wanted to know if that type of behavior was actually rewarded during the interview process. In order to do so, we looked at interviews conducted in Python[5](http://blog.interviewing.io/#guide-fn5) and counted how many function definitions appeared in the final version of the interview. We wanted to know if successful interviewees defined more functions — while having more function handlers is not the definition of modularity, in our experience, it’s a pretty strong signal of it. As always, it’s impossible to make strong causal claims about this — it might be the case that certain interviewers (who are more or less lenient) ask interview questions that lend themselves to more or fewer functions. Nonetheless, it is an interesting trend to investigate!

The plot below shows the distribution of the number of Python functions defined for both candidates who the interviewer said they would hire and candidates who the interviewer said they would not hire. A quick look at this chart suggests that there *is* a difference in the distribution of function definitions between interviews that go well and interviews that don’t. Successful interviewees seem to define *more* functions.

![](https://cdn-images-1.medium.com/max/2000/1*tJ71vF6YBjv-fq489afxSg.png)

**On average, successful candidates interviewing in Python define 3.29 functions, whereas unsuccessful candidates define 2.71 functions. This finding is statistically significant. The upshot here is that interviewers really do reward the kind of code they say they want you to write.**

#### Does it matter if your code runs?

> *“Move fast and break things. Unless you are breaking stuff, you are not moving fast enough.” — *Mark Zuckerberg

> *“The most effective debugging tool is still careful thought, coupled with judiciously placed print statements.” — *Brian Kernighan

A common refrain in technical interviews is that interviewers don’t actually care if your code runs — what they care about is problem-solving skills. Since we collect data on the code interviewees run and whether or not that code compiles, we wanted to see if there was evidence for this in our data. Is there any difference between the percentage of code that compiles error-free in successful interviews versus unsuccessful interviews? Furthermore, can interviewees actually still get hired, even if they make tons of syntax errors?

In order to get at this question, we looked at the data. We restricted our dataset to interviews longer than 10 minutes with more than 5 unique instances of code being executed. This helped filter out interviews where interviewers didn’t actually want the interviewee to run code, or where the interview was cut short for some reason. We then measured the percent of code runs that resulted in errors.[5](http://blog.interviewing.io/#guide-fn5) Of course, there are some limitations to this approach — for instance, candidates could execute code that does compile but gives a slightly incorrect answer. They could also get the right answer and write it to stderr! Nonetheless, this should give us a directional sense of whether or not there’s a difference.

The chart below gives a summary of this data. The x-axis shows the percentage of code executions that were error-free in a given interview. So an interview with 3 code executions and 1 error message would count towards the “30%-40%” bucket. The y-axis indicates the percentage of all interviews that fall in that bucket, for both successful and unsuccessful interviews. Just eyeballing the chart below, one gets the sense that on average, successful candidates run more code that goes off without an error. But is this difference statistically significant?

![](https://cdn-images-1.medium.com/max/2000/1*434O4qWrzxlU6YltbN6sIw.png)

On average, successful candidates’ code ran successfully (didn’t result in errors) 64% of the time, whereas unsuccessful candidates’ attempts to compile code ran successfully 60% of the time, and this difference was indeed significant. **Again, while we can’t make any causal claims, the main takeaway is that successful candidates do usually write code that runs better, despite what interviewers may tell you at the outset of an interview.**

#### Should you wait and gather your thoughts before writing code?

> *“Never forget the power of silence, that massively disconcerting pause which goes on and on and may at last induce an opponent to babble and backtrack nervously.” — *Lance Morrow

We were also curious whether or not successful interviewees tended to take their time in the interview. Interview questions are often complex! After being presented with a question, there might be some benefit to taking a step back and coming up with a plan, rather than jumping right into things. In order to get a sense of whether or not this was true, we measured how far into a given interview candidates first executed code. Below is a histogram showing how far into interviews both successful and unsuccessful interviewees first ran code. Looking quickly at the histogram, you can tell that successful candidates do in fact wait a bit longer to start running code, although the magnitude of the effect isn’t huge.

![](https://cdn-images-1.medium.com/max/2000/1*I0npBvlvkI3JVWr5Toi1_g.png)

More specifically, **on average, candidates with successful interviews first run code 27% of the way through the interview, whereas candidates with unsuccessful interviews first run code 23.9% of the way into the interview, and this difference is significant**. Of course, there are alternate explanations for what’s happening here. For instance, perhaps successful candidates are better at taking the time to sweet-talk their interviewer. Furthermore, the usual caveat that we can’t make causal claims applies — if you just sit in an interview for an extra 5 minutes in complete silence, it won’t help your chances. Nonetheless, there does seem to be a difference between the two cohorts.

### Conclusions

All in all, this post was our first attempt to understand what does and does not typically lead to an interviewer saying “you know what, I’d really like to hire this person.” Because all of our data are observational, its hard to make causal claims about what we see.

While successful interviewees may exhibit certain behaviors, adopting those behaviors doesn’t guarantee success. Nonetheless, it does allow us to support (or call BS on) a lot of the advice you’ll read on the internet about how to be a successful interviewee.

That said, there is much still to be done. This was a first, quantitative pass over our data (which is, in many ways, a treasure trove of interview secrets), but we’re excited to do a deeper, qualitative dive and actually start to categorize different questions to see which carry the most signal as well as really get our head around 2nd order behaviors that you can’t measure easily by running a regex over a code sample or measuring how long an interview took.

If you want to help us with this and are excited to listen to a bunch of technical interviews, [drop me a line](mailto:aline@interviewing.io)!

---

*Want to become awesome at technical interviews and land your next job in the process? *[*Join interviewing.io*](http://www.interviewing.io)*!*


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
