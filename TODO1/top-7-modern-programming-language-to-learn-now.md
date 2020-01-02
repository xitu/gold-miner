> * 原文地址：[Top 7 Modern programming languages to learn now](https://towardsdatascience.com/top-7-modern-programming-language-to-learn-now-156863bd1eec)
> * 原文作者：[Md Kamaruzzaman](https://medium.com/@md.kamaruzzaman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/top-7-modern-programming-language-to-learn-now.md](https://github.com/xitu/gold-miner/blob/master/TODO1/top-7-modern-programming-language-to-learn-now.md)
> * 译者：
> * 校对者：

# Top 7 Modern programming languages to learn now

> How Rust, Go, Kotlin, TypeScript, Swift, Dart, Julia can boost your career and improve your software development skills

![Photo by [h heyerlein](https://unsplash.com/@heyerlein?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/future?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/6000/1*sY77VQEyI1Dbm_RnO0bxIA.jpeg)

If we think about modern human civilization as a car, then the software development industry is like the engine of the car and programming languages are like fuel to the engine. **Which programming language should you learn?**

Learning a new programming language is a big investment in **time, energy, and brainpower**. But learning a new Programming language can improve your Software development skillset and give you career boost as I have written in a separate Blog post:
[**5 reasons to learn a new Programming Language in 2020**
**Learn a new programming language to boost your career and skillset**medium.com](https://medium.com/@md.kamaruzzaman/5-reasons-to-learn-a-new-programming-language-in-2020-bfc9a4b9a763)

Usually, choose a programming language that gives you a boost in your career. Also, learn a language whose popularity is ascending. This means that you should learn established and hugely popular programming languages.

I have huge respect in mainstream programming languages. But here I will give you **a list of modern programming languages that can improve your productivity, boost your career, and make you a better developer**. Also, I will cover **a wide variety of domains: system programming, app development, web development, scientific computing**.

![](https://cdn-images-1.medium.com/max/2000/1*Jzzxrhl0uGWD1USctYOzyg.jpeg)

The term “**Modern programming language**” is ambiguous. Many consider languages like Python, JavaScript as modern programming languages. At the same time, they consider Java as an Old programming language. In reality, all of them appeared around the same time: **1995**.

Most of the mainstream programming languages were developed in the last century, mainly in the **1970s (e.g. C), 1980s (e.g. C++), 1990s (e.g. Java, Python, JavaScript)**. These languages were not designed to take advantage of modern-day software development ecosystems: **Multi-Core CPU, GPU, fast networking, mobile devices, Container, and Cloud**. Although many of them have **retrofit features like Concurrency** in their language and adapted themselves, they also offer Backward compatibility and could not throw away the old, obsolete features.

Python did a Good job (or Bad depending on the context) by making a clear cut between Python 2 and Python 3. Those languages **often offer 10 ways to do the same things and do not care about developer ergonomics**. According to the StackOverflow developer survey, most of the mainstream old programming languages share top spots in the “**most dreaded language**” category:

![Source: [Stackoverflow](https://insights.stackoverflow.com/survey/2019#most-loved-dreaded-and-wanted)](https://cdn-images-1.medium.com/max/2000/1*ohNTSynK0hp_v73Y_aEl2A.jpeg)

I would put a clear boundary between the old and new programming languages is on **June 29, 2007,** when the first iPhone was released. After that, the landscape has transformed. In this list, I will consider **post-2007 programming languages**.

![](https://cdn-images-1.medium.com/max/2000/1*vcX14UokG4fZNdORE4_Q6A.jpeg)

First, **modern programming languages are developed to take the full advantages of modern computer hardware (Multi-Core CPU, GPU, TPU)**, **mobile devices, large-set of data, fast networking, Container, and Cloud**. Also, most of the modern programming languages offer much **higher developer Ergonomics** as given below:

* Concise and terse code (less boilerplate coding)
* Built-in support for concurrency
* Null pointer safety
* Type Inference
* The much simpler feature set
* Lower cognitive load
* Blending the best features of all programming paradigms

Second, many programming languages of the list are **disruptive and will change the software industry forever**. Some of them are already mainstream programming languages, while others are poised to make the breakthrough. It is wise to learn those languages at least as a second programming language.

In a previous blog post: “20 predictions about software development trends in 2020”, I have predicted breakthrough of many modern languages in 2020:
[**20 Predictions about Software Development trends in 2020**
**Cloud, Container, Programming, Database, Deep Learning, Software Architecture, Web, App, Batch, Streaming, Data Lake…**towardsdatascience.com](https://towardsdatascience.com/20-predictions-about-software-development-trends-in-2020-afb8b110d9a0)

---

## Rust

![Source: [Thoughtram](https://thoughtram.io/rust-and-nickel/#/11)](https://cdn-images-1.medium.com/max/2406/1*fr1Gjc_bt6gB06fUlfQNPQ.jpeg)

The System programming language landscape is dominated by near-Metal languages like C, C++. Although they give full control over programs and hardware, they lack memory safety. Even if they support concurrency, it is challenging to write Concurrent programs using C/C++ as there is no Concurrency safety. The other popular programming languages are interpreted languages like Java, Python, Haskell. They offer safety but need a bulky runtime or Virtual Machine. Because of their large runtime, languages like Java are not suitable for System programming.

**There were many attempts to combine the power of C/C++ and the safety of Haskell, Java**. It looks like Rust is the first production-grade programming language that did the trick.

**Graydon Hoare** first developed Rust as a side project. He was inspired by the research programming language **Cyclone**. Rust is open source and Mozilla is leading the language development along with many other companies and communities. Rust is first released in 2015 and has soon caught the eye of the community. In a previous post, I have taken a deeper look into Rust and argued why it is a better choice to use Rust over C++, Java in Big Data domain:
[**Back to the metal: Top 3 Programming language to develop Big Data frameworks in 2019**
**C++, Rust, Go over Java for Data Intensive frameworks**towardsdatascience.com](https://towardsdatascience.com/back-to-the-metal-top-3-programming-language-to-develop-big-data-frameworks-in-2019-69a44a36a842)

**Key Features:**

* Offers Memory Safety and Concurrency safety with the concept of **Ownership and Borrowing**.
* **Compile-time guarantee of memory safety and concurrency** safety i.e. if a program code compiles, then it is both memory safe and data-race free. This is the most appealing feature of Rust.
* It also offers the expressiveness of ML, Haskell. With Immutable Data Structures and functional programming features, Rust offers functional Concurrency and Data Concurrency.
* Rust is Blazingly fast. Idiomatic Rust gives better performance than Idiomatic C++ as per [**Benchmark Game**](https://benchmarksgame-team.pages.debian.net/benchmarksgame/fastest/rust-gpp.html).
* With no Runtime, Rust offers full control of modern Hardware (TPU, GPU, Multi-Core CPU).
* Rust has **LLVM** support. As a result, Rust offers first-class interoperability with **WebAssembly** and allows the Blazingly fast Web Code.

**Popularity:**

Since its debut in 2015, Rust is well accepted by the Developers and voted as the Most beloved language for **four consecutive years (2016, 2017, 2018, 2019)** in StackOverflow developers survey:

![Source: [Stackoverflow](https://insights.stackoverflow.com/survey/2019#most-loved-dreaded-and-wanted)](https://cdn-images-1.medium.com/max/2000/1*JQSUr9o0igYb22h_RnYTlA.jpeg)

According to GitHub Octoverse, Rust is the second-fastest-growing language just behind Dart:

![Source: [Octoverse](https://octoverse.github.com/)](https://cdn-images-1.medium.com/max/2000/1*gwjGGcibFfZhUZSJKqpT-A.jpeg)

Also, programming language Popularity website PyPl has ranked Rust in 18th position with an upward trend:

![Source: [PyPl](http://pypl.github.io/PYPL.html)](https://cdn-images-1.medium.com/max/2000/1*evWgcSuw1qfOb9wpr3ckqQ.jpeg)

Comparing the feature set it offers, it is no wonder that giant Tech companies like **Microsoft, Amazon, Google** finally announced their investment on Rust as a long term System programming language.

In the last 5 years, Rust has been getting increasing traction every year, as shown by Google trends:

![Source: Google Trends](https://cdn-images-1.medium.com/max/2302/1*0gKyrINweN2dGDD_gj8EVw.jpeg)

**Main Use Cases:**

* System Programming
* Serverless Computing
* Business Applications

**Main competitor Languages:**

* C
* C++
* Go
* Swift

## Go

![Source: Wikimedia](https://cdn-images-1.medium.com/max/7722/1*7kbd-tVk3co-9RiilFN1TA.png)

Google is one of the biggest Web Scale companies. At the beginning of this century, Google has faced two scaling problems: **Development Scaling and Application Scaling**. Development scaling means that they could not add more features by throwing more developers. Application scaling means that they could not easily develop an application that can scale to the “Google” scale machine cluster. Around 2007, Google started to create a new “**pragmatic**” programming language that can solve these two scaling problems. In **Rob Pike** (UTF-8) and **Ken Thompson** (UNIX OS), they had two most talented Software Engineer in the world to create a new language.

In 2012, Google has released the first official version of the **Go** programming language. Go is a system programming language but different from Rust. It also has a Runtime and Garbage collector (a few Megabytes). But unlike Java or Python, this runtime is packed with the generated code. In the end, Go generates a single native binary code that can run in a machine without additional dependency or Runtime.

**Key Features:**

* Go has first-class support of Concurrency. It does not offer the ‘**Shared Memory**’ concurrency via Thread and Lock as it is much more difficult to program. Instead, it offers a **CSP based message-passing concurrency** (based on **Tony Hoare** paper). Go uses “**Goroutine**” (lightweight Green thread) and “**Channel**” for message passing.
* The most killer feature of Go is its simplicity. It is the most simple system programming language. A new Software Developer can write productive code in a matter of days like Python. Some of the biggest Cloud Native projects (**Kubernetes, Docker**) is written in Go.
* Go also has embedded Garbage Collector which means developers do not need to worry about Memory management like C/C++.
* Google has invested heavily in Go. As a result, Go has massive Tooling support. For new Go developers, there is a large ecosystem of tools.
* Usually, developers spent 20% of their time writing new code and 80% time they maintain existing code. Because of its simplicity, Go excels in the language maintenance field. Nowadays, Go used heavily in Business Applications.

**Popularity:**

Since Go first appears, the Software Development community has accepted it with arms. In **2009** (right after its debut) and **2018**, Go has entered the **Programming Language Hall of Fame** list by the [**TIOBE index**](https://www.tiobe.com/tiobe-index/). It is no wonder that the success of Go has paved the way for a new generation of programming languages like Rust.

Go is already a mainstream programming language. Recently, Go team has announced the work on “**Go 2**” to only make the language more solid:

In almost all popular programming languages comparing websites, Go ranks high and has surpassed many existing languages. Here is the **TIOBE index** rating from December 2019 where Go ranks 15th:

![Source: TIOBE](https://cdn-images-1.medium.com/max/2328/1*4otADyzXwAXDqCjbiJnszw.jpeg)

According to the Stackoverflow survey, Go is one of the top 10 most loved programming languages:

![Source: [Stackoverflow](https://insights.stackoverflow.com/survey/2019#most-loved-dreaded-and-wanted)](https://cdn-images-1.medium.com/max/2000/1*AlZjgpQhANe7uJ_pJMQmdQ.jpeg)

Go is also one of the top 10 fastest growing languages according to GitHub Octoverse:

![Source: [Octoverse](https://octoverse.github.com/)](https://cdn-images-1.medium.com/max/2000/1*avYTdU-SuMxL3qMufe9Xag.jpeg)

Google trends also show increasing traction for Go over the last five years:

![Source: Google Trends](https://cdn-images-1.medium.com/max/2312/1*Dm_Tfz6rQKYHP14woSpd7A.jpeg)

**Main Use Cases:**

* System Programming
* Serverless Computing
* Business Applications
* Cloud-Native Development

**Main competitor Languages:**

* C
* C++
* Rust
* Python
* Java

## Kotlin

![](https://cdn-images-1.medium.com/max/2400/1*6MRnGxzKEA7tPJz-0fKLBQ.png)

Java is the undisputed king of Enterprise Software Development. In recent times, Java has become the target of much criticism: It is verbose, needs lots of boilerplate coding, prone to accidental complexity. However, there is little argument about the **Java Virtual Machine (JVM)**. JVM is a masterpiece of Software Engineering and offers a battle-hardened runtime that has passed the test of time. In a previous post, I have discussed in detail the advantages of JVM:
[**Programming language that rules the Data Intensive (Big Data+Fast Data) frameworks.**
**A brief overview on Big Data frameworks**towardsdatascience.com](https://towardsdatascience.com/programming-language-that-rules-the-data-intensive-big-data-fast-data-frameworks-6cd7d5f754b0)

Over the years, JVM languages like **Scala** tried to answer the shortcomings of Java and wanted to be better Java but failed. Finally, in Kotlin, it looks like a search for better Java is over. Jet Brains (the company behind the popular IDE IntelliJ) has developed Kotlin, which runs on JVM and answers the shortcomings of Java and offered many modern features. The best part is that unlike Scala, **Kotlin is much simpler** than Java and offers Go or Python-like developer productivity in JVM.

Google has declared Kotlin as a first-class language to develop **Android** and boosted Kotlin’s acceptance in the community. Also popular **Java Enterprise framework Spring** has started to support Kotlin in the Spring eco-system since 2017. I have used Kotlin with Reactive Spring and the experience was amazing.

**Main Features:**

* The USP of Kotlin is its language design. I always view Kotlin as Go/Python on JVM because of its clean, concise code. As a result, Kotlin is highly productive.
* Like many other modern languages, Kotlin offers features like Null pointer safety, Type Inference.
* As Kotlin also runs in JVM, you can use the existing huge eco-system of Java libraries.
* Kotlin is a first-class language to develop Android App and has already surpassed Java as the number one programming language to develop Android App.
* Kotlin is backed by JetBrains and Open Source. So, Kotlin has excellent tooling support.
* There are two interesting projects: **Kotlin Native** (to compile Kotlin into native code) and **kotlin.js** (Kotlin to JavaScript). If they become successful, then Kotlin can be used outside JVM.
* Kotlin also offers a simple way to write **DSL** (Domain Specific Language)

**Popularity:**

Since its first release in 2015, the popularity of Kotlin is soaring. As per Stack Overflow, Kotlin is the fourth most loved Programming language in 2019:

![Source: [Stackoverflow](https://insights.stackoverflow.com/survey/2019#most-loved-dreaded-and-wanted)](https://cdn-images-1.medium.com/max/2000/1*PmUb6Ozt9Cngh0IA9DCpAg.jpeg)

Kotlin is also one of the fastest-growing programming languages and ranked 4th:

![Source: Github Octoverse](https://cdn-images-1.medium.com/max/2000/1*P03_CPbYksuJzpdFxGiulA.jpeg)

Popular programming language ranking website PyPl has ranked Kotlin as the 12th most popular programming language with a **high upward trend**:

![Source: [Pypl](http://pypl.github.io/PYPL.html)](https://cdn-images-1.medium.com/max/2000/1*YKOiuBgCDHSKU4TQBbYbXw.jpeg)

Since Google has declared Kotlin as the first-class language to develop Android Apps, Kotlin has experienced a huge positive boost in trending as shown below:

![Source: Google Trends](https://cdn-images-1.medium.com/max/2308/1*ZqVPhJii9fxTTZZ_Pj3HZA.jpeg)

**Main Use Cases:**

* Enterprise Application
* Android App Development

**Main competitor Languages:**

* Java
* Scala
* Python
* Go

## TypeScript

![](https://cdn-images-1.medium.com/max/2000/1*TpbxEQy4ckB-g31PwUQPlg.png)

JavaScript is an excellent language but pre-2015 JavaScript had many shortcomings. Even noted Software Engineer **Douglas Crockford** has written a book **“JavaScript: The Good Parts”** and implied that JavaScript has **bad parts and ugly parts**. With no modularization and with “Callback Hell”, developers did not like to maintain especially large JavaScript projects.

Google even developed a platform to transcompile Java code to JavaScript code (**GWT**). Many companies or people tried to develop better JavaScript e.g. **CoffeeScript, Flow, ClojureScript**. But **TypeScript** from Microsoft arguably hit the Jackpot. A group of engineers in Microsoft, led by famous **Anders Hejlsberg (creator of Delphi, Turbo Pascal, C#)**, created TypeScript as a Statically Typed, Modular superset of JavaScript.

TypeScript is transcompiled to JavaScript during compilation. First released in 2014, it quickly attracted the attention of the community. Google was also planning to develop a Statically Typed superset of JavaScript back then. Google was so impressed by TypeScript that instead of developing a new language, they co-operated with Microsoft to improve TypeScript.

Google has used TypeScript as the main programming language for its SPA framework **Angular2+**. Also, the popular SPA framework **React** offers support for TypeScript. The other popular JavaScript framework Vue.js has declared that they will use TypeScript to develop the new **Vue.js** 3:

![Source: [Vue.js Roadmap](https://github.com/vuejs/roadmap)](https://cdn-images-1.medium.com/max/2278/1*8Kaj35gc8dr3FmdlnmN6_A.jpeg)

Also, node.js creator **Ryan Dahl** has decided to use TypeScript to develop a secure **Node.js** alternative, **Deno**.

**Key Features:**

* Like Go or Kotlin in the list, the principal feature of TypeScript is the language design. With its crisp and clean code, **it is one of the most elegant programming languages out there**. In terms of Developer productivity, it is on par with Kotlin on JVM or Go/Python. TypeScript is the most productive JavaScript superset hands down.
* TypeScript is a strongly typed superset of JavaScript. It is especially suited for large Projects and rightly termed as “**JavaScript that Scales**”.
* The “Big Three” Single Page Application framework (**Angular, React, Vue.js**) offers excellent support for TypeScript. In Angular, TypeScript is the preferred programming language. In React and Vue.js, TypeScript is getting increasingly popular.
* Two of the biggest Tech Giants: **Microsoft and Google** are working together to develop TypeScript supported by a vibrant open source community. As a result, the tooling support for TypeScript is one of the best.
* As TypeScript is a superset of JavaScript, it can runs where JavaScript runs: **everywhere**. TypeScript can run on **Browser, Server, Mobile Devices, IoT devices, and Cloud**.

**Popularity:**

Developers love TypeScript for its elegant language design. In the Stackoverflow Developer survey, it has ranked joint second with Python in the most beloved language category:

![Source: [Stackoverflow](https://insights.stackoverflow.com/survey/2019#most-loved-dreaded-and-wanted)](https://cdn-images-1.medium.com/max/2000/1*t6wkuoA1IdPg9ncsg4bLBQ.jpeg)

TypeScript is one of the fastest-growing Web programming languages and ranked fifth according to GitHub Octoverse:

![Source: [Octoverse](https://octoverse.github.com/)](https://cdn-images-1.medium.com/max/2000/1*JTRjZ8ZBee5T-cfcH64Jtg.jpeg)

TypeScript also entered the Top 10 List (ranked 7th) according to the GitHub Contributions:

![Source: [Octoverse](https://octoverse.github.com/)](https://cdn-images-1.medium.com/max/2046/1*Ad7zxTCZGSzt4ioC0ylf5A.jpeg)

TypeScript is having more and more eyeballs in each passing year, which is reflected by Google Trends:

![Source: Google Trends](https://cdn-images-1.medium.com/max/2308/1*STnhuXU-ZRMw2Bc3O6pV7w.jpeg)

**Main Use Cases:**

* Web UI Development
* Server-side development

**Main competitor Languages:**

* JavaScript
* Dart

## Swift

![](https://cdn-images-1.medium.com/max/2400/1*OVgSA8lppCUu7idWMgMMyw.png)

**Steve Jobs** has refused to support **Java** (and JVM) in iOS as he has famously quoted that Java is no more a major programming language. We now know that Steve Jobs was wrong with his assessment with Java, but iOS is still not supporting Java. Instead, Apple has chosen **Objective-C** as the first-class programming language in iOS. Objective-C is a hard language to master. Also, it does not support the high developer productivity required by modern programming languages.

In Apple, **Chris Lattner** and others have developed **Swift** as a multi-paradigm, general-purpose, compiled programming language that gives an alternative to Objective-C. The first stable version of Swift was released in 2014. Swift also supports **LLVM** compiler Toolchain (also developed by **Chris Lattner**). Swift has excellent interoperability with Objective-C codebase and has already established itself as the main programming language in iOS App development.

**Main Features:**

* One of the killer features of Swift is its language design. With simpler, concise and clean syntax, it offers a more productive alternative to Objective-C.
* Swift also offers features of modern program languages: null safety. Also, it offers syntactic sugar to avoid the “**Pyramid of Doom**”.
* As a compiled language, Swift is as fast as C++.
* Swift has support for LLVM Compiler Toolchain. So, we can use Swift in server-side programming or even Browser programming (using WebAssembly).
* Swift offers **Automatic Reference Counting (ARC)** support and thus limits memory mismanagement.

**Popularity:**

Developers love Swift programming language like many other modern languages. According to the StackOverflow survey, Swift ranked 6th as the most beloved programming language:

![](https://cdn-images-1.medium.com/max/2000/1*BxHjlXZ_UfQSNbnVY0F7nQ.jpeg)

In the programming language ranking of TIOBE, Swift has moved to the number 10 ranking in 2019. Considering how young the language is (5 years), this is quite a feat:

![Source: TIOBE Index](https://cdn-images-1.medium.com/max/2332/1*wO5MgevW6NqQ0ujfNqMBZw.jpeg)

Google trends also show a sharp rise in the Popularity of Swift followed by a slight decrease in trending in the last couple of saturation:

![Source: Google Trends](https://cdn-images-1.medium.com/max/2298/1*EO-TFNeitbEz_T4I3pRoIw.jpeg)

**Main Use Cases:**

* iOS App Development
* System Programming
* Client-side development (via WebAssembly)

**Main competitor Languages:**

* Objective-C
* Rust
* Go

## Dart

![](https://cdn-images-1.medium.com/max/5300/1*QCajckOeBhRaLzi0RoFqig.png)

**Dart** is the second programming language in this list made by Google. Google is a key player in the Web and Android domain, and it is no surprise that Google has developed its own programming language in the Web and App Development domain. Led by the famous Danish Software Engineer **Lars Bak (who lead the Development of Chrome’s V8 JavaScript Engine)**, Google has released Dart in 2013.

Dart is a general-purpose programming language which supports Strong typing and Objected-Oriented programming. Dart can also be transcompiled to JavaScript and can run where JavaScript runs means virtually everywhere (e.g. Web, Mobile, Server).

**Main Features:**

* Like other Google language Go, Dart also heavily focuses on developer productivity. Dart is hugely productive and loved by developers because of its clean, simple, terse syntax.
* Dart also offers Strong Typing and Object-Oriented programming. Dart is also a second language in this list which fits the ‘**Scalable JavaScript**’ tag.
* Dart is one of the few languages which supports **JIT compilation (compilation during Runtime) and AOT compilation (compilation during creation time)**. Thus Dart can target JavaScript runtime (V8 Engine) and Dart can be compiled to fast Native code (AOT compilation)
* The **Cross-Platform Native App Development platform Flutter** has chosen Dart as the programming language to develop both iOS and Android App. Since then, Dart has become more popular.
* Like other Google programming language Go, Dart also has excellent Tooling support and the huge Ecosystem of Flutter. The increasing popularity of **Flutter** will only increase the adoption of Dart.

**Popularity:**

According to Github Octoverse, Dart is the **fastest-growing Programming language in 2019 and its popularity has five-folded in last year**:

![](https://cdn-images-1.medium.com/max/2000/1*4yH5ZWzBmI9MJXAdNWkqyw.jpeg)

According to the TIOBE index, Dart stands 23rd position and has already surpassed many other existing and modern programming languages in only 4 years:

![Source: TIOBE index](https://cdn-images-1.medium.com/max/2324/1*mct61ZNxjiZuLa40tdOKTg.jpeg)

It is also one of the most beloved programming languages as ranked 12th in StackOverflow developer Survey:

![Source: StackOverflow](https://cdn-images-1.medium.com/max/2000/1*X9_wQ80-LQWgDJ2AMLchSA.jpeg)

Along with Flutter, Dart has also experienced huge traction in the last two years as clear by Google Trends:

![Source: Google Trends](https://cdn-images-1.medium.com/max/2310/1*HMfM_TSQmmpbKxqFiUHfYA.jpeg)

**Main Use Cases:**

* App Development
* UI Development

**Main competitor languages:**

* JavaScript
* TypeScript

## Julia

![](https://cdn-images-1.medium.com/max/2400/1*claL_4fuNqq9ZO8F5RkYqA.png)

Most of the programming languages in this list are developed by large corporations except Julia. In **technical computing**, usually dynamic languages like **Python, Matlab** are used. These languages offer easy-to-use syntax but are not fit for large-scale Technical computation. They use C/C++ libraries for the CPU intensive tasks which gives the famous **Two-Language** problem as they need **Glue Code** to bind both languages. As Code is translated between two languages, there is always some performance loss.

To tackle the issue, a group of researchers at MIT planned to create a new language from the ground-up which takes the advantages of modern hardware and combines the best parts of other languages. They work in the MIT innovation lab with the following Manifesto:

![Source: [Julia Presentation](https://genome.sph.umich.edu/w/images/3/3e/Julia_presentation.pdf)](https://cdn-images-1.medium.com/max/2756/1*sqvWUec74Co1DpySnbQihg.jpeg)

Julia is a **dynamic, high-level programming language** that offers first-class support for **Concurrent, Parallel and Distributed Computing**. The first stable version of Julia is released in **2018** and soon got the attraction of the community and industry. Julia can be used in Scientific Computing, Artificial Intelligence, and many other fields and **can finally solve the “Two-Language”** problem.

**Features:**

* Like Rust, the key feature of Julia is the design of the languages. It tries to combine some of the best features of the existing programming language in high performance and Scientific computing without sacrificing performance. Until now it has done a great job.
* Julia is a dynamic programming language with optionally typed. Thus, Julia is easy to learn a programming language and highly productive.
* It uses **multiple-dispatch** programming paradigm at its core.
* It has built-in support for **Concurrent, Parallel and Distributed Computing**.
* It also offers **asynchronous I/O** for I/O intensive tasks.
* It is **Blazingly fast** and can be used in Scientific Computing where millions of threads are required.

**Popularity:**

Julia mainly competes with Python in many areas. As Python is one of the most popular programming languages, it will take a few years until Julia will be mainstream.

Julia is relatively new (only one-year-old) but still ranks 43rd in the TIOBE index:

![Source: TIOBE](https://cdn-images-1.medium.com/max/2356/1*hL8eYaOW8yUpCzZDUPZXSA.jpeg)

Google Trends also shows a stable interest in Julia over the years.

![](https://cdn-images-1.medium.com/max/2306/1*nIsvOaYZdfAYgcbuEiN32g.jpeg)

But considering the feature set and the number of companies is working behind Julia such as **NSF, DARPA, NASA, Intel,** it is just a matter of when instead of if for Julia to make a breakthrough:

**Main Use Cases:**

* Scientific Computing
* High-performance computing
* Data Science
* Visualization

**Main competitor languages:**

* Python
* Matlab

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
