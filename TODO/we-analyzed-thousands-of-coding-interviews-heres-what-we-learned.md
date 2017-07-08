
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

*注意：我写了这个帖子中的绝大部分内容，但传说中的 *[*Dave Holtz*](https://twitter.com/daveholtz)* 完成了数据处理的主要工作。我们可以在 *[*他的博客*](http://daveholtz.net/)*中看到他的其它成果。*

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

Before getting into the thick of it, it’s worth noting that the conclusions below are based on observational data, which means we can’t make strong causal claims… but we can still share surprising relationships we’ve observed and explain what we found so you can draw your own conclusions.

#### Having seen the interview question before

> *“We’re talking about practice!”* -Allen Iverson

First thing’s first. It doesn’t take a rocket scientist to suggest that one of the best ways to do better in interviews is to… practice interviewing. There are a number of resources out there to help you practice, ours among them. One of the main benefits of working through practice problems is that you reduce the likelihood of being asked to solve something you’ve never seen before. Balancing that binary search tree will be much less intimidating if you’ve already done it once or twice.

We looked at a sample of ~3000 interviews and compared the outcome to whether the interviewee had seen the interview question before. You can see the results in the plot below.

![](https://cdn-images-1.medium.com/max/1600/1*0ha_0_L7WbspbayJet6N1g.png)

**Unsurprisingly, interviewees who had seen the question were 16.6% more likely to be considered hirable by their interviewer.** This difference is statistically significant — all error bars in this post represent a 95% confidence interval.

#### Does it matter what language you code in?

> *“Whoever does not love the language of his birth is lower than a beast and a foul smelling fish.” — *Jose Rizal

You might imagine that different languages lead to better interviews. For instance, maybe the readability of Python gives you a leg up in interviews. Or perhaps the fact that certain languages handle data structures in a particularly clean way makes common interview questions easier. We wanted to see whether or not there were statistically significant differences in interview performance across different interview languages.

To investigate, we grouped interviews on our platform by interview language and filtered out any languages that were used in fewer than 5 interviews (this only threw out a handful of interviews). After doing this, we were able to look at interview outcome and how it varied as a function of interview language.

The results of that analysis are in the chart below. Any non-overlapping confidence intervals represent a statistically significant difference in how likely an interviewee is to ‘pass’ an interview, as a function of interview language.

Although we don’t do a pairwise comparison for every possible pair of languages, the data below suggest that generally speaking,** there aren’t statistically significant differences between the success rate when interviews are conducted in different languages. **(There were more languages than these on our platform, but the more obscure the language, the less data points we have. For instance, all interviews in [Brainf***](https://en.wikipedia.org/wiki/Brainfuck) were clearly successful. Kidding.)

![](https://cdn-images-1.medium.com/max/2000/1*S1-Aj4ZEKgyuihnFftCD6w.png)

That said, one of the most common mistakes we’ve observed qualitatively is people choosing languages they’re not comfortable in and then messing up basic stuff like array length lookup, iterating over an array, instantiating a hash table, and so on.

This is especially mortifying when interviewees purposely pick a fancy-sounding language to impress their interviewer. Trust us, wielding your language of choice comfortably beats out showing off in a fancy-sounding language you don’t know well, every time.

#### Even if language doesn’t matter… is it advantageous to code in the company’s language of choice?

> *“God help me, I’ve gone native.”* — Margaret Blaine

It’s all well and good that, in general, interview language doesn’t seem particularly correlated with performance. However, you might imagine that there could be an effect depending on the language that a given company uses. You could imagine a Ruby shop saying “we only hire Ruby developers, if you interview in Python we’re less likely to hire you.”

On the flip side, you could imagine that a company that writes all of their code in Python is going to be much more critical of an interviewee in Python — they know the ins and outs of the language, and might judge the candidate for doing all sorts of “non-pythonic” things during their interview.

The chart below is similar to the chart which showed differences in interview success rate (as measured by interviewers being willing to hire the interviewee) for C++, Java, and Python. However, this chart also breaks out performance by whether or not the interview language is in the company’s stack.

We restrict this analysis to C++, Java and Python because these are the three languages where we had a good mixture of interviews where the company did and did not use that language.** The results here are mixed. When the interview language is Python or C++, there’s no statistically significant difference between the success rates for interviews where the interview language is or is not a language in the company’s stack. However, interviewers who interviewed in Java were more likely to succeed when interviewing with a Java shop **(p=0.037).

So, why is it that coding in the company’s language seems to be helpful when it’s Java, but not when it’s Python or C++? One possible explanation is that the communities that exist around certain programming languages (such as Java) place a higher premium on previous experience with the language. Along these lines, it’s also possible that interviewers from companies that use Java are more likely to ask questions that favor those with a pre-existing knowledge of Java’s idiosyncrasies.

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
