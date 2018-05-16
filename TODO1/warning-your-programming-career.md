> * 原文地址：[Warning: Your programming career](https://medium.com/sololearn/warning-your-programming-career-b9579b3a878b)
> * 原文作者：[Vardan Grigoryan (vardanator)](https://medium.com/@vardanator?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/warning-your-programming-career.md](https://github.com/xitu/gold-miner/blob/master/TODO1/warning-your-programming-career.md)
> * 译者：
> * 校对者：

# Warning: Your programming career

## How not to get lost in the dark forests of programming

![](https://cdn-images-1.medium.com/max/2000/1*SNOF9EOlDnAViwEZAoFwmg.jpeg)

The main thing that was bothering me while I was just starting my coding career was the language/technology choice. What should I learn, where should I start? What should I know to get my first job as a programmer? Back then (almost 10 years now) there wasn’t Coursera, or Udemy or [SoloLearn](https://www.sololearn.com/). I wasn’t able to figure out the exact direction, the complete path leading to a successful job myself. The highly paid, fully fed, kindly treated job of the astronaut of the 21st century: the programmer.

The very same problem still exists: beginners are stuck at the choice, there isn’t a straight path to become a good programmer and the community isn’t so warm in welcoming the newbie questions like “iz pythn a gut lang???”. The path to a successful programming career is even vaguer than before. You (supposing you are a beginner) should choose between C++/C++11/C++14/C++17, Java, C#, Kotlin, PHP (what?), Python, Node.js, JavaScript, (wait, with Angular, React or Vue?) and so on.

### The language, the technology, or the skills?

To answer your main question, I have to ask you one first. **What do you want?** Are you excited to build mobile apps, a website, a website like Facebook or a website like Medium, or do you want to build a desktop application like Photoshop? Maybe you are fully into the game development? Mobile? Desktop?

The most intelligent way to answer “**what should I know to get hired at a tech company as a software engineer**?” is to find out the main skills you should master to successfully pass the technical interview. But first, we should put things in order, let’s dive into the programming world, its countries and cities, its cultures and wars, its wins and losses. For those who aren’t patient enough, scroll down to the “Preparing for Coding Interviews” section.

Exploring the world of programming brings us to 3 main platforms:

1.  **Web** (Google Search, Facebook, Amazon, Twitter and others)
2.  **Desktop** (Dropbox, Photoshop, Visual Studio, Skype and others)
3.  **Mobile** ([SoloLearn](https://www.sololearn.com/), Instagram, Uber and others)

Most of the services above exist in almost all of the platforms, for instance, Skype is a desktop, mobile and (although poorly done) web application, Twitter is a web and mobile application and so on.

#### Web

Web itself is a huge concept in this context, to shed light on it, we should separate it into so-called front-end and back-end, the latter being my personal favorite. Front-end is what you see, back-end is what you need in order to see what you see. Again, front-end is the look and feel, back-end is the servers running the application which processes user requests, handles database queries and so forth.

**Front-end.** If you want to master the look and feel, i.e. build websites that are so beautiful that users fall in love, you should know HTML (the look), CSS (the look and feel), JavaScript (the feel). This isn’t just enough, using pure JavaScript is not enough nowadays, so you have to choose the right framework, currently popular Angular, React or Vue. Which one to choose is mostly based on the company you like the most, Google or Facebook? Go with Angular if you like Google, and with React if you like Facebook. If you don’t like any of them (weird), go with Vue. Simple! Besides these, you should master some fundamental concepts, like the inner workings of the HTTP Protocol, be familiar with web servers (at least you should not be scared of names like Apache or Nginx). Being a front-end developer means you get the data to render (beautify for users) from the back-end, so some minimum understanding of what an API is, what is JSON (and why it’s better than XML) is a must. (If anything sounds way too unfamiliar, check the References section at the end of this post).

![](https://cdn-images-1.medium.com/max/800/1*mJ_4xsEgEizLg9xenU1yUw.jpeg)

One of many memes on the web describing the difference between front-end and back-end.

**Back-end.** The unseen truth, the untold story. In the old days, knowing PHP was enough to call yourself a back-end developer, then Microsoft introduced ASP.NET. They were fighting each other until Node.js came and put things in their best order. Some concepts of event-driven development are best applied at Node.js, so if you choose it, you are doing a good favor to your project.

The confusing part of the back-end is its language diversity, well, you can use any language you want at the back-end, the point is, “back-end” is a short name for “query database, process data, respond to client and do it as efficient as you can” and choosing the “right” language/technology/database is not an option. While some developers go with Relational Databases like MySQL or PostgreSQL, newcomers choose the dark side, NoSQL (like Cassandra or MongoDB). The choice is really yours, but I’ve got a simple formula. Do you have a strict schema for your data and it won’t change much in the near future? Choose Relational Database. Do you have more than million visits per minute? Change to NoSQL (painfully). Does your product change rapidly? Choose NoSQL. Let’s say you chose the side, now, what concrete technology should you choose? Do you like Microsoft and you have Windows Servers? Choose MsSQL. Do you like Oracle? Choose Oracle. Are you ok with Oracle, but you hate Microsoft at the same time? Choose MySQL. You just really don’t want to hurt anyone? Choose PostgreSQL.

NoSQL comes in tricky. It really depends on your service and data architecture. You’ve got just documents and some weak connections among them? Choose MongoDB. You need to store a huge bunch of key-value pairs? Choose Redis. You are working with a graph-like structure (Facebook friends graph, Google knowledge graph, etc.)? Choose Neo4j. Aren’t really sure what exactly you need, but you feel that you need all of them? Choose ArangoDB.

While database holds all the necessary data, you should define an API through which your clients can request and read/write to the database. The most useful option here is Node.js, though you can go with PHP or ASP.NET or Ruby or Python, my personal recommendation would be Node.js. Well, Facebook uses PHP at its backend, kind of. They rewrote a huge part of PHP in C++. Some use Python while others prefer Ruby. It’s true that you can use almost any language at the back-end, for instance, Google uses C++, Java and Python (along with Go). For low-level data processing, C++ fits the best, for background jobs like updating user’s friend recommendations, Java is a good option. For data analysis or natural language processing or for nowadays highly popular AI-related tasks you most probably will use Python.

Again, besides various languages, frameworks, databases at back-end, there are some core concepts that you have to master.

*   **Caching**. Starting from the CPU cache (with different levels) and ending with browser cache. Caching used everywhere, for high load services like Google Search or Facebook, caching is extremely necessary.
*   **Servers**. While you might think this is related to the hardware (which will be great if you know how to setup several computers to work as one piece in storing and processing data), for the back-end developer server means the web server. Popular web server nowadays is Nginx and knowing how to setup and configure it will pay highly in your future endeavors.
*   **Sockets**. Cornerstone of the network programming. Everything you send/receive via network is done by sockets. Knowing low-level details of socket programming is a good bonus in your skills inventory (knowing difference between TCP sockets, UDP sockets and what are WebSockets is a huge plus).
*   **Database Design**. No matter what DBMS you choose or have to work with, operating with data will be one of your main tasks. Ability to see the complete picture, visualize data and connections between data units is a skill you will master during your whole programming career.
*   **Security**. As other concepts mentioned above, this one is very broad, too. You can’t master any of them completely, so you should at least be familiar with some best practices such as storing password hashes rather than as plain texts. Checking requests via API token, verifying user permissions for each request and so on.

#### Desktop

We will talk about the part of the desktop application that actually makes it a desktop application. There are tons of applications on Desktop platforms that need specific skill set, for instance, Photoshop is working with images, and knowing image processing algorithms and techniques is a must if you want to write something like Photoshop. Knowing socket programming is a must if you want to write something like Dropbox. Knowing how to engineer a compiler is a must of you want to build a compiler or IDE like Visual Studio. We won’t touch upon specifics, let’s just explore the languages you most probably will use if you want to work on desktop platform.

When it comes to languages for desktop applications programmers are having a hard time choosing among C++, Java or C#. There is a simple formula to make the right choice: if you like Microsoft, use C#. If you like Oracle, use Java. If you think that a programming language should not be owned by a particular company, use C++. If this isn’t helping much, let’s discuss the actual sub-platforms. If you write software only for Windows users, C# is the best choice. It’s kind of obvious as both are products of Microsoft and they fit together the best. Though C# developers insist that after the release of .Net Core, C# can be used in Linux environment, too, I personally suggest to go with C++ if you want to cover Linux. The point is, C++ was been created as a cross-platform programming language, which works great in all operating systems out there (yes, even MacOS). Well, cross-platform in this context supposes that you have to compile your C++ project in all operating systems separately to ship “different” executables of your application for each concrete OS. And, honestly, C++ lacks any GUI. The greatest excuse for that is the fact that “C++ is for hardcore developers, and hardcore developers use nothing but Terminal (command line interface)”. However, kind developers gathered together and created Qt, the very best cross-platform GUI library that fits perfectly with C++.

Finally, if you get angry with the complexity of C++ and the fact that you should connect a separate library like Qt to have complete GUI experience for your users and you hate to compile and ship different executables of your product for different OS, go with Java. Java has its virtual machine which makes it easy to ship the executable. Your application works equally fine on any OS where JVM (Java Virtual Machine) is installed.

#### Mobile

When speaking of Java, first thing that comes to mind is Android. Long before Kotlin has been introduced to the world, Java was the de facto language in order to implement Android apps. Nowadays, Kotlin takes hearts of developers and allows even better experience of developing apps for Android platform. So, if you want to make Android apps, you should choose between Java and Kotlin. To make the correct choice, we should look behind the scenes. The point is, Google is not so cool with Oracle. Oracle owns Java and Java dominates in Google’s Android, so to have some flexibility here, Google had to introduce an option for the light side (or the dark side, up to you) and introduced **Kotlin** as “_wow, why use Java if there is such a great language we support_”. I personally suggest you start with Kotlin if you are just starting your Android developer career, though to be a competent developer in the market, you have to support previously implemented apps in Java, so, knowing Java will be a good bonus in your CV.

And finally, iOS. The iLand. An entirely different story. For a long time Objective-C was the dominant language for iOS and to be completely honest, mastering Objective-C required a serious approach, tough look and some good perseverance. That was the main issue of relatively small number of Objective-C developers out there and Apple finally made the right move by introducing **Swift**. Swift is much easier to master than Objective-C, which lead to increase in the number of iOS developers. So, to be an iOS developer, you need to go with Swift, but to be a really confident developer, it is suggested to master Objective-C to support apps (tons of apps) already written in Objective-C.

I should mention React Native here, as it allows to write apps for both Android and iOS platforms using just JavaScript, however, as a new and rapidly changing player in the market, let’s just consider that it exists and you already can write simple apps if you know only JavaScript.

### **Preparing for Coding Interviews**

![](https://cdn-images-1.medium.com/max/2000/1*-m_hxcxFCO0_-ND-FBFz6g.jpeg)

There are concepts that are fundamental in programming world. Most of the technical interviews are meant to discover your problem solving skills and knowing those concepts, so besides mastering a programming language, you should be familiar with the concepts that are somewhat required in programmer’s arsenal. Here’s an excerpt from my recent lesson post in [SoloLearn](https://www.sololearn.com/) (below are the links to Android and iOS apps).

* [SoloLearn: Learn to Code for Free - Apps on Google Play](http://bit.ly/sololearn-android)
* [SoloLearn: Learn to Code on the App Store](http://bit.ly/sololearn-ios)

To successfully prepare for coding interviews you should be confident in the following areas:
1. Algorithms & Data Structures
2. Computer Organization & Operating Systems
3. Coding
4. System Design

**Algorithms & Data Structures**
This is the most wanted skill set for programmers. Here are the subjects every programmer must be familiar with:

**Algorithm Complexity:** Big-O notation and how to calculate algorithms complexity; knowing which algorithm is better based on their complexity, e.g. O(N) vs O(logN).

**Basic Data Structures & adapters:** Array, Linked List, Stack, Queue.

**Sorting & Searching:** Knowing various sorting algorithms helps you to identify the best possible implementation for your projects. For practice, try to implement insertion sort, selection sort or merge sort and spot the difference between linear search and binary search.

**Trees & Graphs:** Trees and Graphs are everywhere, starting from “friends graph” in Facebook to “knowledge graph” in Google Search.

**Hashtables:** Being one of the most efficient data structures in the world, hashtables are always a good choice. You should be able to implement a Hashtable and be familiar with techniques to solve collisions.

**Computer Organization & Operating Systems**
It is strongly advised to be familiar with topics like:

*   Bitwise operations
*   How does the CPU execute machine code
*   What’s the difference between static RAM and dynamic RAM
*   What kind of OS kernel types exist
*   What’s the difference between “mutex” and “semaphore”
*   What is a deadlock and what is a livelock

**Coding**
You should have really good knowledge of at least one programming language. Knowing all the pros and cons, best practices of your favorite language will always help you write efficient, elegant and readable code.
It is highly recommended to practice by solving challenging problems, such as (all the problems below could be found on [SoloLearn](https://www.sololearn.com/)):

*   The Josephus Problem
*   Tower of Hanoi
*   String Compression
*   Balanced Parenthesis
*   Twin Prime Numbers

**System Design**
Knowing Object-Oriented Programming is a must for a modern programmer.
System Design means thinking about the whole system, being able to design its architecture, dissect it into classes, define object interactions.
To be prepared try to answer the questions below:
- How would you design Google Search? What if there are millions of simultaneous requests per second?
- How would you implement Facebook’s friend search?
- Why would you use a Relational Database Management System?
- Why would you use a NoSQL DB?

It is highly recommended to know and use the correct design patterns. For example, you should know the difference between a Composite and a Decorator.

While junior developers are mostly required to have good problem solving skills and your first job won’t require knowing all the points listed above, this list will be a good help to plan your career.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
