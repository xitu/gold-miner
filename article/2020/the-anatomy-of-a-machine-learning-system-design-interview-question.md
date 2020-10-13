> * 原文地址：[The Anatomy of a Machine Learning System Design Interview Question](https://medium.com/better-programming/the-anatomy-of-a-machine-learning-system-design-interview-question-1d9a1a5d23e)
> * 原文作者：[The Educative Team](https://medium.com/@educative)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/the-anatomy-of-a-machine-learning-system-design-interview-question.md](https://github.com/xitu/gold-miner/blob/master/article/2020/the-anatomy-of-a-machine-learning-system-design-interview-question.md)
> * 译者：
> * 校对者：

# The Anatomy of a Machine Learning System Design Interview Question

#### Break down the structure of the question so you can answer it well

![Image credit: Author](https://cdn-images-1.medium.com/max/2048/1*Ep0crcTbOZBLZwVW8W3JDQ.png)

**Written by Educative Co-Founder, Fahim ul Haq.**

Machine learning system design interviews have become increasingly common as more industries adopt ML systems. While similar in some ways to generic system design interviews, ML interviews are different enough to trip up even the most seasoned developers. The most common problem is to get stuck or intimidated by the large scale of most ML solutions.

Today we’ll prepare you for your next ML system design interview by breaking down how they’re unique, what you should do to prepare, and the five steps you should use to solve any ML problem.

**Today we’ll cover:**

* What’s different about the ML system design interview
* How to prepare for an ML system design interview
* Five steps to solve any ML system design problem
* Wrapping up and resources

---

## What’s Different About the ML System Design Interview

The general setup of a machine learning system design interview is similar to a generic SDI. For both, you’ll be placed with an interviewer for 45 to 60 minutes and be asked to think through the components of a program.

ML interviews generally focus more on the macro-level (like architecture, recommendation systems, and scaling) and avoid deeper design discussions on topics like availability and reliability.

In ML interviews, you’ll be asked high-level questions on how you’d set up each component of a system (data gathering, ML algorithm, signals) to handle a heavy workload and still adapt quickly.

For the machine learning SDI, you’ll be expected to explain how your program acquires data and achieves scalability.

---

## How to Prepare for an ML System Design Interview

An ML system design interview will test your knowledge of two things: your knowledge of the setups and design choices behind large-scale ML systems and your ability to articulate ML concepts as you apply them.

Let’s look at three ways to prepare both your knowledge and articulation.

---

## Know the Common ML Interview Questions

The best way to prepare for these questions is to practice ML SDI problems on your own. There are only a few types of ML interview questions asked in modern ML SDIs.

**The most common are iterations of:**

* “Create a Twitter-style social media feed to display relevant posts to users.”
* “Build a recommendation system to suggest products/services.”
* “Design a Google-style search engine that tailors results to the user.”
* “Build an advertising system that presents personalized ads to users.”
* “Design an ML system that identifies bad actors in a social network.”

Search in the target job’s description for mentions of specific systems you’d work with and study similar systems for the interview. For jobs without a clear leaning toward any question type, focus on the media feed and recommendation systems, as these are the two most asked questions.

---

## Focus on the 4 Parts of Every ML Solution

![Image source: Author](https://cdn-images-1.medium.com/max/2000/0*Dp0BQjXD6BO-tbnO)

**Each ML solution has four major parts:**

* Machine learning algorithm
* Training data
* Signals (sometimes called **features**)
* Validation and metrics

For **algorithms**, what algorithm will you choose and why? Deep learning, linear regression, random forest? What are the strengths and weaknesses of each? What do they accomplish per your system’s needs?

For **data**, where will you get test data? What data points will you draw from? How many data points will you handle?

For **signals**, what metric does your program use to determine relevant data? Will you signal to focus on one aspect of the data or synthesize it from multiple? How long does it take to determine data relevancy?

For **metrics**, what metrics will you track for success and program learning? How would you measure the success of your system? How will you validate your hypothesis?

---

## Practice Explaining Out Loud

Many interviewees will study concepts and algorithms but fail to practice the spoken component of the interview.

Practice explaining your system’s architecture aloud throughout the process. Narrate any decisions you make, briefly explaining why you made that choice. This is a great opportunity to show the interviewer how you think, not just what you know.

Also, practice your answers to common probing questions. The interviewer will ask you to clarify any decision points or uncertainties in your program. Make sure you can justify the design choices you make at any point in the process.

**Some common probe questions are:**

* How will this program perform at scale?
* How will you acquire your training data?
* What will you do to keep latency low?

---

## 5 Steps to Solve Any ML System Design Problem

An ML SDI interview will usually have a strict time limit of either 45 or 60 minutes, with five minutes at the start and end for introductions/wrap up.

So generally, you’ll be expected to cover all key areas of your ML program in 35 to 50 minutes. It’s important to come with a structured plan of how you’ll draft the system, to ensure you stay on track.

Next, we’ll look at how to break up your time to ace any ML question. To help understand the process, we’ll also demonstrate each step through an example feed-type question in a 45-minute interview.

You can adapt these steps to a 60-minute interview if you scale up the time of each step.

**Our question is: Create a content feed to display personalized posts to users.**

![](https://cdn-images-1.medium.com/max/4830/1*089x6xZcQvuXGZY3A9AtRQ.png)

#### Step 1. Clarify requirements (5 minutes)

For the first five minutes, we’ll clarify our **system goal** and **requirements** with the interviewer. These interview questions are deliberately vague to make you directly ask for the information you’ll need. Your clarifying questions will help steer your design and decide your system’s end goal.

**Some common clarifying questions would be:**

* How many users do we expect this program to handle?
* What metrics are we currently tracking?
* What do we want to achieve with this system? What do we want to optimize for?
* What type of input do we expect?

**Step 1. Example**

If we were clarifying the feed question, we’d ask:

* What type of feed will this be? Purely text? Text and images?
* How many users do we expect to have? How many posts does each make per day?
* What metric does our system optimize for? Do we want more engagement per post or to increase the number of posts?
* Do we have a target latency?
* How quickly will our system apply new learning?

#### Step 2. High-level design (5 minutes)

For the next five minutes, create a high-level design that handles data from input to use. Chart this visually and connect all components that interact. The interviewer will ask probing questions as you build, so look out for questions that suggest you’re missing a component.

Remember to keep this abstract: Decide how many layers, how data will enter the system, how data will be parsed, and how you will decide on relevant data.

Make sure to explicitly mention any choices you make for scalability or response time.

**Step 2. Example**

We’d write that our training data is from our current social media platform. Fresh live data will enter the system each time a new post is created, based on the creator’s location, the popularity of the creator’s past posts, and the accounts that follow that creator.

We’ll use these metrics to determine how relevant a post is to a user. Relevancy will be determined when the app is launched. Our goal is to increase engagement per post.

#### Step 3: Data deep dive (10 minutes)

For the next ten minutes, take a deep dive to explain your data. Make sure to cover both training data and live data. Think about how the data will need to transform through the process.

ML interviewers are looking for candidates who understand the importance of data sampling. You’ll be expected to clarify where you’d get the training data, what data points you’d use that are present within the current system, and what data you want to begin tracking.

This differs from a generic SDI, where the interviewee only considers what happens to the data after it enters the program flow.

**For training data, consider:**

* What source will I get my training data from?
* How will I ensure it is unbiased?

**For live data, consider:**

* What signal will I use in my data?
* Why is this signal relevant?
* Are there any situations in which this signal would not reflect my desired outcome?
* How reactive is my algorithm? Will changes occur within ten minutes or ten hours, etc.?
* How much data can my program handle at once? Does it perform worse with more input?

**Step 3. Example**

We’ll expect each user to follow 300 accounts and each account to make an average of three posts per day. We’ll have three layers of data evaluation to keep latency low when the system evaluates the 1,000 posts. The first layer quickly cuts a majority of posts based on the posts’ popularity.

The second layer uses locational data to cut posts based on locality. This is our second-quickest layer. The third layer will be the longest and will cut posts using cross-engagement data between the follower and followed.

#### Step 4. Machine learning algorithms (10 minutes)

For the next ten minutes, break down your choice of machine learning algorithm(s) to the interviewer. Each algorithm handles certain tasks differently, and the interviewer will want you to know the strengths and weaknesses of different algorithms.

If you use several algorithms to handle scale, mention how their results will factor together and your reasons for choosing multiple algorithms.

Make sure to mention how each algorithm utilizes your signals to create a cohesive solution. The same signal may not be as effective in one algorithm as it is in another.

**Step 4. Example**

We’ll use the feedforward neural network algorithm to predict relevancy. This algorithm works well with our creator/user interactions signal because it forms predictions from non-circular connection webs.

#### Step 5. Experimentation (5 minutes)

In the final five minutes, stake a hypothesis of what your system will accomplish. This section is a sort of conclusion for your program where you can summarize how the components together achieve a certain goal.

Your hypothesis may be broad, like “posts ordered by relevance will get more engagement than chronological,” or it may be specific, like “the addition of a location signal will increase engagement by 0.5%.”

From here, explain how you’d test this hypothesis. Make sure to cover the initial offline evaluations and also how to evaluate online.

* What offline evaluations would you use?
* How big an offline data set would you need?
* When online, what will you do if there is a bug?
* How will you track user satisfaction with the change?
* Do you count engagement using comments or using any form of interaction with the post?

ML engineers constantly test out hypotheses in their day-to-day work. A focus on experimentation will set you apart from other applicants, as it shows that you can synthesize the functionality of your program and possess the right mindset for the job.

**Step 5. Example**

Our relevancy-based feed will increase user engagement by 0.5%. We’ll first use offline models programmed to simulate users and see what types of posts come through to the feed.

Once we move online, we’ll track posts with the keywords “update” and “relevance” to determine effectiveness.

---

## 5-Step Summary

Step 1. Clarify requirements (5 minutes)

Step 2. High-level design (5 minutes)

Step 3. Data deep dive (10 minutes)

Step 4. Machine learning algorithms (10 minutes)

Step 5. Experimentation (5 minutes)

---

## Wrapping Up and Resources

You now have everything you need to ace your next ML interview. By preparing ML study material and a timed solution plan, you’ll set yourself apart from others still unfamiliar with this rising interview type.

Happy interviewing!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
