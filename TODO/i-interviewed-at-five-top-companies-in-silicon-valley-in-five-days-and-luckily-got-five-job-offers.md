> * 原文地址：[I interviewed at five top companies in Silicon Valley in five days, and luckily got five job offers](https://medium.com/@XiaohanZeng/i-interviewed-at-five-top-companies-in-silicon-valley-in-five-days-and-luckily-got-five-job-offers-25178cf74e0f)
> * 原文作者：[Xiaohan Zeng](https://medium.com/@XiaohanZeng?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/i-interviewed-at-five-top-companies-in-silicon-valley-in-five-days-and-luckily-got-five-job-offers.md](https://github.com/xitu/gold-miner/blob/master/TODO/i-interviewed-at-five-top-companies-in-silicon-valley-in-five-days-and-luckily-got-five-job-offers.md)
> * 译者：
> * 校对者：

# I interviewed at five top companies in Silicon Valley in five days, and luckily got five job offers

![](https://cdn-images-1.medium.com/max/800/1*4IYF3JVZqF9GnuGzNgkSPA.png)

**In the five days from July 24th to 28th 2017, I interviewed at LinkedIn, Salesforce Einstein, Google, Airbnb, and Facebook, and got all five job offers.**

It was a great experience, and I feel fortunate that my efforts paid off, so I decided to write something about it. I will discuss how I prepared, review the interview process, and share my impressions about the five companies.

* * *

### **How it started**

I had been at Groupon for almost three years. It’s my first job, and I have been working with [an amazing team](http://www.builtinchicago.org/2017/07/14/data-science-engineering-Groupon) and on [awesome projects](https://www.linkedin.com/feed/update/urn:li:activity:6324643825717481472). We’ve been building cool stuff, making impact within the company, publishing papers and all that. But I felt my learning rate was being annealed (read: slowing down) yet my mind was craving more. Also as a software engineer in Chicago, there are so many great companies that all attract me in the Bay Area.

Life is short, and professional life shorter still. After talking with my wife and gaining her full support, I decided to take actions and make my first ever career change.

### **Preparation**

Although I’m interested in machine learning positions, the positions at the five companies are slightly different in the title and the interviewing process. Three are machine learning engineer (LinkedIn, Google, Facebook), one is data engineer (Salesforce), and one is software engineer in general (Airbnb). Therefore I needed to prepare for three different areas: coding, machine learning, and system design.

Since I also have a full time job, it took me 2–3 months in total to prepare. Here is how I prepared for the three areas.

#### Coding

While I agree that coding interviews might not be the best way to assess all your skills as a developer, there is arguably no better way to tell if you are a good engineer in a short period of time. IMO it is the necessary evil to get you that job.

I mainly used Leetcode and Geeksforgeeks for practicing, but Hackerrank and Lintcode are also good places. I spent several weeks going over common data structures and algorithms, then focused on areas I wasn’t too familiar with, and finally did some frequently seen problems. Due to my time constraints I usually did two problems per day.

Here are some thoughts:

1.  Practice, a lot. There is no way around it.
2.  But rather than doing all 600 problems on Leetcode, cover all types and spend time understanding each problem thoroughly. I did around 70 problems in total and felt that was enough for me. My thought is that if 70 problems isn’t helpful then you may not be doing it right and 700 won’t be helpful either.
3.  Go for the hardest ones. After those the rest all become easy.
4.  If stuck on one problem for over two hours, check out the solutions. More time might not be worth it.
5.  After solving one problem, check out the solutions. I was often surprised by how smart and elegant some solutions are, especially the Python one-liners.
6.  Use a language that you are most familiar with and that is common enough to be easily explained to your interviewer.

#### System design

This area is more closely related to the actual working experience. Many questions can be asked during system design interviews, including but not limited to system architecture, object oriented design，database schema design，distributed system design，scalability, etc.

There are many resources online that can help you with the preparation. For the most part I read articles on system design interviews, architectures of large-scale systems, and case studies.

Here are some resources that I found really helpful:

*   [http://blog.gainlo.co](http://blog.gainlo.co)
*   [http://horicky.blogspot.com](http://horicky.blogspot.com)
*   [https://www.hiredintech.com/classrooms/system-design/lesson/52](https://www.hiredintech.com/classrooms/system-design/lesson/52)
*   [http://www.lecloud.net/tagged/scalability](http://www.lecloud.net/tagged/scalability)
*   [http://tutorials.jenkov.com/software-architecture/index.html](http://tutorials.jenkov.com/software-architecture/index.html)
*   [http://highscalability.com/](http://highscalability.com/)

Although system design interviews can cover a lot of topics, there are some general guidelines for how to approach the problem:

1.  Understand the requirements first, then lay out the high-level design, and finally drill down to the implementation details. Don’t jump to the details right away without figuring out what the requirements are.
2.  There are no perfect system designs. Make the right trade-off for what is needed.

With all that said, the best way to practice for system design interviews is to actually sit down and design a system, i.e. your day-to-day work. Instead of doing the minimal work, go deeper into the tools, frameworks, and libraries you use. For example, if you use HBase, rather than simply using the client to run some DDL and do some fetches, try to understand its overall architecture, such as the read/write flow, how HBase ensures strong consistency, what minor/major compactions do, and where LRU cache and Bloom Filter are used in the system. You can even compare HBase with Cassandra and see the similarities and differences in their design. Then when you are asked to design a distributed key-value store, you won’t feel ambushed.

Many blogs are also a great source of knowledge, such as Hacker Noon and engineering blogs of some companies, as well as the official documentation of open source projects.

The most important thing is to keep your curiosity and modesty. Be a sponge that absorbs everything it is submerged into.

#### Machine learning

Machine learning interviews can be divided into two aspects, theory and product design.

Unless you are have experience in machine learning research or did really well in your ML course, it helps to read some textbooks. Classical ones such as the Elements of Statistical Learning and Pattern Recognition and Machine Learning are great choices, and if you are interested in specific areas you can read more on those.

Make sure you understand basic concepts such as bias-variance trade-off, overfitting, gradient descent, L1/L2 regularization，Bayes Theorem，bagging/boosting，collaborative filtering，dimension reduction, etc. Familiarize yourself with common formulas such as Bayes Theorem and the derivation of popular models such as logistic regression and SVM. Try to implement simple models such as decision trees and K-means clustering. If you put some models on your resume, make sure you understand it thoroughly and can comment on its pros and cons.

For ML product design, understand the general process of building a ML product. Here’s what I tried to do:

1.  Figure out what the objective is: prediction, recommendation, clustering, search, etc.
2.  Pick the right algorithm: supervised vs unsupervised, classification vs regression, generalized linear model / decision tree / neural network / etc. Be able to reason about the choice.
3.  Pick / engineer relevant features based on available data.
4.  Pick metrics for model performance.
5.  Optionally, comment on how to optimize the model for production.

Here I want to emphasize again on the importance of remaining curious and learning continuously. Try not to merely using the API for Spark MLlib or XGBoost and calling it done, but try to understand why stochastic gradient descent is appropriate for distributed training, or understand how XGBoost differs from traditional GBDT, e.g. what is special about its loss function, why it needs to compute the second order derivative, etc.

### The interview process

I started by replying to HR’s messages on LinkedIn, and asking for referrals. After a failed attempt at a rock star startup (which I will touch upon later), I prepared hard for several months, and with help from my recruiters, I scheduled a full week of onsites in the Bay Area. I flew in on Sunday, had five full days of interviews with around 30 interviewers at some best tech companies in the world, and very luckily, got job offers from all five of them.

#### Phone screening

All phone screenings are standard. The only difference is in the duration: For some companies like LinkedIn it’s one hour, while for Facebook and Airbnb it’s 45 minutes.

Proficiency is the key here, since you are under the time gun and usually you only get one chance. You would have to very quickly recognize the type of problem and give a high-level solution. Be sure to talk to the interviewer about your thinking and intentions. It might slow you down a little at the beginning, but communication is more important than anything and it only helps with the interview. Do not recite the solution as the interviewer would almost certainly see through it.

For machine learning positions some companies would ask ML questions. If you are interviewing for those make sure you brush up your ML skills as well.

To make better use of my time, I scheduled three phone screenings in the same afternoon, one hour apart from each. The upside is that you might benefit from the hot hand and the downside is that the later ones might be affected if the first one does not go well, so I don’t recommend it for everyone.

One good thing about interviewing with multiple companies at the same time is that it gives you certain advantages. I was able to skip the second round phone screening with Airbnb and Salesforce because I got the onsite at LinkedIn and Facebook after only one phone screening.

More surprisingly, Google even let me skip their phone screening entirely and schedule my onsite to fill the vacancy after learning I had four onsites coming in the next week. I knew it was going to make it extremely tiring, but hey, nobody can refuse a Google onsite invitation!

#### Onsite

**LinkedIn**

![](https://cdn-images-1.medium.com/max/800/1*JjnojejxqDmKWdDvF7JccQ.png)

This is my first onsite and I interviewed at the Sunnyvale location. The office is very neat and people look very professional, as always.

The sessions are one hour each. Coding questions are standard, but the ML questions can get a bit tough. That said, I got an email from my HR containing the preparation material which was very helpful, and in the end I did not see anything that was too surprising. I heard the rumor that LinkedIn has the best meals in the Silicon Valley, and from what I saw if it’s not true, it’s not too far from the truth.

Acquisition by Microsoft seems to have lifted the financial burden from LinkedIn, and freed them up to do really cool things. New features such as videos and professional advertisements are exciting. As a company focusing on professional development, LinkedIn prioritizes the growth of its own employees. A lot of teams such as ads relevance and feed ranking are expanding, so act quickly if you want to join.

**Salesforce Einstein**

![](https://cdn-images-1.medium.com/max/800/1*XNUUSjrUo-n7eU5ZOGeHog.png)

Rock star project by rock star team. The team is pretty new and feels very much like a startup. The product is built on the Scala stack, so type safety is a real thing there! Great talks on the Optimus Prime library by Matthew Tovbin at Scala Days Chicago 2017 and Leah McGuire at Spark Summit West 2017.

I interviewed at their Palo Alto office. The team has a cohesive culture and work life balance is great there. Everybody is passionate about what they are doing and really enjoys it. With four sessions it is shorter compared to the other onsite interviews, but I wish I could have stayed longer. After the interview Matthew even took me for a walk to the HP garage :)

**Google**

![](https://cdn-images-1.medium.com/max/800/1*VYDw0n3CgPOsrX1j-tchbw.png)

Absolutely the industry leader, and nothing to say about it that people don’t already know. But it’s huge. Like, really, really HUGE. It took me 20 minutes to ride a bicycle to meet my friends there. Also lines for food can be too long. Forever a great place for developers.

I interviewed at one of the many buildings on the Mountain View campus, and I don’t know which one it is because it’s HUGE.

My interviewers all look very smart, and once they start talking they are even smarter. It would be very enjoyable to work with these people.

One thing that I felt special about Google’s interviews is that the analysis of algorithm complexity is really important. Make sure you really understand what Big O notation means!

**Airbnb**

![](https://cdn-images-1.medium.com/max/800/1*Y9tdU5fecN2XIUqE3bC3gA.png)

Fast expanding unicorn with a unique culture and arguably the most beautiful office in the Silicon Valley. New products such as Experiences and restaurant reservation, high end niche market, and expansion into China all contribute to a positive prospect. Perfect choice if you are risk tolerant and want a fast growing, pre-IPO experience.

Airbnb’s coding interview is a bit unique because you’ll be coding in an IDE instead of whiteboarding, so your code needs to compile and give the right answer. Some problems can get really hard.

And they’ve got the one-of-a-kind cross functional interviews. This is how Airbnb takes culture seriously, and being technically excellent doesn’t guarantee a job offer. For me the two cross functionals were really enjoyable. I had casual conversations with the interviewers and we all felt happy at the end of the session.

Overall I think Airbnb’s onsite is the hardest due to the difficulty of the problems, longer duration, and unique cross-functional interviews. If you are interested, be sure to understand their culture and core values.

**Facebook**

![](https://cdn-images-1.medium.com/max/800/1*wgM997D8y7JHguhRESY8pA.png)

Another giant that is still growing fast, and smaller and faster-paced compared to Google. With its product lines dominating the social network market and big investments in AI and VR, I can only see more growth potential for Facebook in the future. With stars like Yann LeCun and Yangqing Jia, it’s the perfect place if you are interested in machine learning.

I interviewed at Building 20, the one with the rooftop garden and ocean view and also where Zuckerberg’s office is located.

I’m not sure if the interviewers got instructions, but I didn’t get clear signs whether my solutions were correct, although I believed they were.

By noon the prior four days started to take its toll, and I was having a headache. I persisted through the afternoon sessions but felt I didn’t do well at all. I was a bit surprised to learn that I was getting an offer from them as well.

Generally I felt people there believe the company’s vision and are proud of what they are building. Being a company with half a trillion market cap and growing, Facebook is a perfect place to grow your career at.

### Negotiation

This is a big topic that I won’t cover in this post, but I found [this article](https://medium.freecodecamp.org/how-not-to-bomb-your-offer-negotiation-c46bb9bc7dea) to be very helpful.

Some things that I do think are important:

1.  Be professional.
2.  Know your leverages.
3.  Be genuinely interested in the teams and projects.
4.  Keep your patience and confidence.
5.  Be determined but polite.
6.  Never lie.

### **My failed interview with Databricks**

![](https://cdn-images-1.medium.com/max/800/1*8ihczqhKMJ_dTZmRvMTAGg.png)

All successes start with failures, including interviews. Before I started interviewing for these companies, I failed my interview at Databricks in May.

Back in April, Xiangrui contacted me via LinkedIn asking me if I was interested in a position on the Spark MLlib team. I was extremely thrilled because 1) I use Spark and love Scala, 2) Databricks engineers are top-notch, and 3) Spark is revolutionizing the whole big data world. It is an opportunity I couldn’t miss, so I started interviewing after a few days.

The bar is very high and the process is quite long, including one pre-screening questionnaire, one phone screening, one coding assignment, and one full onsite.

I managed to get the onsite invitation, and visited their office in downtown San Francisco, where Treasure Island can be seen.

My interviewer were incredibly intelligent yet equally modest. During the interviews I often felt being pushed to the limits. It was fine until one disastrous session, where I totally messed up due to insufficient skills and preparation, and it ended up a fiasco. Xiangrui was very kind and walked me to where I wanted to go after the interview was over, and I really enjoyed talking to him.

I got the rejection several days later. It was expected but I felt frustrated for a few days nonetheless. Although I missed the opportunity to work there, I wholeheartedly wish they will continue to make greater impact and achievements.

### Afterthoughts

1.  Life is short. Professional life is shorter. Make the right move at the right time.
2.  Interviews are not just interviews. They are a perfect time to network and make friends.
3.  Always be curious and learn.
4.  Negotiation is important for job satisfaction.
5.  Getting the job offer only means you meet the minimum requirements. There are no maximum requirements. Keep getting better.

From the first interview in May to finally accepting the job offer in late September, my first career change was long and not easy.

It was difficult for me to prepare because I needed to keep doing well at my current job. For several weeks I was on a regular schedule of preparing for the interview till 1am, getting up at 8:30am the next day and fully devoting myself to another day at work.

Interviewing at five companies in five days was also highly stressful and risky, and I don’t recommend doing it unless you have a very tight schedule. But it does give you a good advantage during negotiation should you secure multiple offers.

I’d like to thank all my recruiters who patiently walked me through the process, the people who spend their precious time talking to me, and all the companies that gave me the opportunities to interview and extended me offers.

Lastly but most importantly, I want to thank my family for their love and support — my parents for watching me taking the first and every step, my dear wife for everything she has done for me, and my daughter for her warming smile.

Thanks for reading through this long post.

You can find me on [LinkedIn](https://www.linkedin.com/in/xiaohanzeng/) or [Twitter](https://twitter.com/XiaohanZeng).

Xiaohan Zeng

10/22/17


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
