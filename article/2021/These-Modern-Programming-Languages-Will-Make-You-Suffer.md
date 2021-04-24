> * 原文地址：[These Modern Programming Languages Will Make You Suffer](https://betterprogramming.pub/modern-languages-suck-ad21cbc8a57c)
> * 原文作者：[Ilya Suzdalnitski](https://suzdalnitski.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/These-Modern-Programming-Languages-Will-Make-You-Suffer.md](https://github.com/xitu/gold-miner/blob/master/article/2021/These-Modern-Programming-Languages-Will-Make-You-Suffer.md)
> * 译者：
> * 校对者：

# These Modern Programming Languages Will Make You Suffer

![](https://cdn-images-1.medium.com/max/10250/1*5zFs-VAB35APZwad--qnvw.jpeg)

What are the pros and cons of a particular programming language? Is X a good language for my task? Googling “best programming language” will give you a standard list of “Python, Java, JavaScript, C#, C++, PHP” with a vague list of pros and cons. Seeing such articles makes me cringe — their authors must have been outright lazy, inexperienced, and lacking any imagination. Let’s dive deep and find out what really sucks — and what doesn’t.

In this article, I’ll attempt to give an objective and, hopefully, unbiased overview of popular (and not so popular) modern programming languages, ranked from the worst to best.

Bear in mind, there’s no single perfect programming language. Some work best for back end / API development, others are great for system programming.

I’m going to cover two of the most common language families in the world: [languages descended from C](https://en.wikipedia.org/wiki/List_of_C-family_programming_languages), and [languages descended from ML](https://en.wikipedia.org/wiki/ML_(programming_language)).

Programming languages are just tools in a developer’s toolbox. It’s important to choose the right tool for the job. I really hope that this guide will help you choose the most suitable programming language for your task. Making the right choice might save you months (or even years) of development effort.

## What Language Characteristics Really Matter?

![](https://cdn-images-1.medium.com/max/7000/1*TqsvzacHhqF2rF0ev0ON0Q.jpeg)

Most other similar articles base their comparisons on factors like **popularity** and **earning potential**. Popularity is rarely a good measure, especially in the world of software (although a big community & ecosystem helps). Instead I’ll be taking into account the **strengths and weaknesses** of a particular language.

I’ll be using a thumbs-up 👍 (i.e. +1 ), a thumbs-down 👎, or an ok 👌 (neither good nor bad) emojis to signify the score of a particular language characteristic.

Now, how will we measure? In other words, what really matters, other than language popularity?

## Type System

Many people swear by type systems. That’s why languages like TypeScript have picked up in popularity in recent years. I tend to agree that type systems eliminate a large number of errors in programs and make refactoring easier. However, having a type system is only one part of the story.

If a language has a type system, then it is also very useful to have **type inference**. The best type systems are able to infer most of the types, without annotating function signatures explicitly. Unfortunately, most of the programming languages only provide rudimentary type inference.

It is also nice for a type system to support Algebraic Data Types (more on this later).

The most powerful type systems support higher-kinded types, which are one level of abstraction above generics, and allow us to program at an even higher level of abstraction.

We also have to keep in mind that people tend to put too much importance on type systems. There are things that matter far more than static typing, and the presence or lack of a type system shouldn’t be the only factor when choosing a language.

## Learning Effort

We might have the perfect programming language, but what use is it if onboarding new developers might take months or even years (upfront investment)? On the other side of the spectrum, some programming paradigms take years to become good at.

A good language should be approachable by beginners and shouldn’t take years to master.

![](https://cdn-images-1.medium.com/max/2000/1*caUNu6RMeBKLIht997tR8Q.png)

## Nulls

> **I call it my billion-dollar mistake. It was the invention of the null reference in 1965. At that time, I was designing the first comprehensive type system for references in an [object oriented](https://suzdalnitski.com/oop-will-make-you-suffer-846d072b4dce) language. My goal was to ensure that all use of references should be absolutely safe, with checking performed automatically by the compiler. But I couldn’t resist the temptation to put in a null reference, simply because it was so easy to implement. This has led to innumerable errors, vulnerabilities, and system crashes, which have probably caused a billion dollars of pain and damage in the last forty years.**
>
> - Tony Hoare, the inventor of Null References

Why are null references bad? Null references break type systems. When null is the default value, we can no longer rely on the compiler to check the validity of the code. Any nullable value is a bomb waiting to explode. What if we attempt to use the value that we didn’t think might be null, but it in fact is null? We get a runtime exception.

```JavaScript
function capitalize(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
}

capitalize("john");  // -> "John"
capitalize(null);   // Uncaught TypeError: Cannot read property 'charAt' of null
```

We have to rely on **manual runtime checks** to make sure that the value we’re dealing with isn’t null. Even in a statically-typed language, null references take away many benefits of a type system.

```JavaScript
function capitalize(string) {
  if (string == null) throw "string is required";
    
  return string.charAt(0).toUpperCase() + string.slice(1);
}

```

Such runtime checks (sometimes called null guards) in reality are workarounds around bad language design. They litter our code with boilerplate. And worst of all, there are no guarantees that we won’t forget to check for null.

In a good language, the lack or presence of a value should be type-checked at compile-time.

Languages that encourage other mechanisms of working with missing data will be ranked higher.

## Error Handling

**Catching** exceptions is a bad way to handle errors. Throwing exceptions is fine, but only in **exceptional** circumstances, when the program has no way to recover, and has to crash. Just like nulls, exceptions break the type system.

When exceptions are used as a primary way of error handling, it’s impossible to know whether a function will return an expected value or blow up. Functions throwing exceptions are also impossible to compose.

```JavaScript
function fetchAllComments(userId) {
  const user = fetchUser(userId); // may throw
  
  const posts = fetchPosts(user); // may throw
  
  return posts    // posts may be null, which again may cause an exception
          .map(post => post.comments)
          .flat();
}

```

Obviously, it’s not ok for an entire application to crash simply because we couldn’t fetch some data. Yet, more often than we’d like to admit, this is what happens.

One option is to manually check for raised exceptions, but this approach is fragile (we may forget to check for an exception) and adds a lot of noise:

```JavaScript
function fetchAllComments(userId) {
  try {
    const user = fetchUser(userId);

    const posts = fetchPosts(user);

    return posts
            .map(post => post.comments)
            .flat();
  } catch {
    return [];
  }
}
```

Nowadays there are much better mechanisms of error handling. Possible errors should be type-checked at compile-time. Languages that do not use exceptions by default will be ranked higher.

## Concurrency

We’ve reached the end of Moore’s law: Processors will not get any faster, period. We live in the era of multi-core CPUs. Any modern application has to take advantage of multiple cores.

Unfortunately, most of the programming languages in use today were designed in the era of single-core computing and simply do not have the features to effectively run on multiple cores.

Libraries that help with concurrency are an afterthought, they simply add band-aids to languages that weren’t initially designed for concurrency. This doesn’t really count as good developer experience. In a modern language, concurrency support has to be built-in (think Go/Erlang/Elixir).

![](https://cdn-images-1.medium.com/max/2000/1*caUNu6RMeBKLIht997tR8Q.png)

## Immutability

> **I think that large [objected-oriented](https://suzdalnitski.com/oop-will-make-you-suffer-846d072b4dce) programs struggle with increasing complexity as you build this large object graph of mutable objects. You know, trying to understand and keep in your mind what will happen when you call a method and what will the side effects be.**
>
> **— [Rich Hickey](http://www.se-radio.net/2010/03/episode-158-rich-hickey-on-clojure/), creator of Clojure.**

Programming with immutable values nowadays is becoming more and more popular. Even modern UI libraries like `React` are intended to be used with immutable values. Languages with first-class support for immutable data values will be ranked higher. Simply because immutability eliminates a whole category of bugs from our code.

What is [immutable state](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4)? Simply put, it’s data that doesn’t change. Just like strings in most programming languages. For example, capitalizing a string will never change the original string — a new string will always be returned instead.

Immutability takes this idea further and makes sure that nothing is ever changed. A new array will always be returned instead of changing the original one. Updating the user’s name? A new user object will be returned with its name updated, leaving the original one intact.

With immutable state, nothing is shared, therefore we no longer have to worry about the complexity of thread safety. Immutability makes our code easy to parallelize.

Functions that do not mutate(change) any state are called pure and are significantly easier to test, and to reason about. When working with pure functions, we never have to worry about anything outside of the function. Just focus on just this one function that you’re working with and forget about everything else. You can probably imagine how much easier development becomes (in comparison to OOP, where an entire graph of objects has to be kept in mind).

## Ecosystem / Tooling

A language may not be very good, but it may have a large ecosystem which makes it appealing. Having access to good libraries may save months or even years of development effort.

We’ve seen this happen with languages like JavaScript and Python.

## Speed

How fast does the language **compile**? How fast do the programs start? What is their runtime performance like? All of these things matter and will be included in the ranking.

## Age

Although there are some exceptions, generally, newer languages will be better than older ones. Simply because newer languages learn from the mistakes of their predecessors.

## C++

![](https://cdn-images-1.medium.com/max/2000/1*gqSGrN8Zj8LY-q-VnpzVBQ.png)

![](https://cdn-images-1.medium.com/max/2000/1*CzKWXYzsEZwZJuqNyf4udQ.png)

Let’s begin our rating with the worst of the worst, probably one of the biggest mistakes of computer science, C++. Yes, C++ is not considered a shiny modern programming language. But it’s still in wide use today and had to be included in the list.

Language family: **C.**

![](https://cdn-images-1.medium.com/max/2000/1*caUNu6RMeBKLIht997tR8Q.png)

#### 👎 Language features

![](https://cdn-images-1.medium.com/max/2374/1*EGTBjWdsyDsaiL2Ys3WUQA.jpeg)

> **C++ is a horrible language… And limiting your project to C means that people don’t screw things up with any idiotic “[object model](https://suzdalnitski.com/oop-will-make-you-suffer-846d072b4dce)” c&@p.
>  — Linus Torvalds, the creator of Linux.**

C++ is bloated with features. It attempts to do everything, without being good at any particular thing. C++ has `goto` , pointers, references, OOP, operator overloading, and many other non-productive features.

Why is C++ so bad? In my opinion, the biggest reason is its age. C++ was designed long ago, in 1979. At that time the designers lacked experience and had no idea what to focus on. The features added might have seemed like a good idea at the time. The language was very popular, which meant that many more features were added to support various use cases (creating an even bigger mess of features).

#### 👎 Speed

C++ is notorious for its slow compilation time. It’s significantly slower than Java, though not as bad as Scala.

The runtime performance, along with the startup time, is good though.

#### 👎 Ecosystem/tooling

![](https://cdn-images-1.medium.com/max/2000/1*nHGnpD9luB6O2OjUaoP1Ig.png)

The above tweet makes a good point. The C++ compiler error messages aren’t very user-friendly beginners. More often than not figuring out the exact cause of an error can take some time.

#### 👎👎 Garbage collection

> **I had hoped that a garbage collector which could be optionally enabled would be part of C++0x, but there were enough technical problems…**
>
> - Bjarne Stroustrup, creator of C++

Garbage collection was never added into C++. Manual memory management is extremely error-prone. The developers have to worry about manually releasing and allocating memory. I will never miss the days when I was using non-garbage-collected languages, the innumerous number of bugs that are nowadays easily prevented in garbage-collected languages.

#### 👎 A failed attempt at Object-Oriented Programming

> I invented the term [Object-Oriented](https://suzdalnitski.com/oop-will-make-you-suffer-846d072b4dce), and I can tell you I did not have C++ in mind.

> - Alan Kay, the inventor of object-oriented programming.

Having appeared in the late 60s, OOP was a cool new technology when the work on C++ has started. Unfortunately, C++ made a few crucial mistakes in their implementation of OOP (unlike languages like Smalltalk), which has turned a really good idea into a nightmare.

One good thing about C++, in comparison to Java, is that OOP in C++ is at least optional.

#### 👎👎 Learning effort

![Mercurial_Rhombus on [Reddit](https://www.reddit.com/r/ProgrammerHumor/comments/k09yty/my_friend_sent_me_this_thought_it_belonged_here/)](https://cdn-images-1.medium.com/max/2000/1*guc9SVj1TmOmPGr9jMF7OA.png)

C++ is a complicated low-level language with no automated memory management. Due to its feature bloat, beginners have to spend a lot of time learning the language.

#### 👎 Concurrency

C++ was designed in the era of single-core computing and has only rudimentary concurrency mechanisms that were added in the past decade.

#### 👎 Error handling

Catching/throwing errors is the preferred error handling mechanism.

#### 👎 Immutability

Has no built-in support for [immutable](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4) data structures.

#### 👎 Nulls

In C++, all references are nullable.

#### 👎 GOTO

C++ probably is the only modern programming language still supporting the goto statement. In the past, it was the leading cause of bugs, yet C++ has decided to put this dreadful relic of the past in. After all, more features is always better, right?

![](https://cdn-images-1.medium.com/max/2000/1*caUNu6RMeBKLIht997tR8Q.png)

#### Verdict

![](https://cdn-images-1.medium.com/max/2000/1*CzKWXYzsEZwZJuqNyf4udQ.png)

Originally intended to be a better version of C, C++ failed to deliver.

The best use of C++ is probably system programming. However, given much better and modern alternatives in existence (Rust and Go), C++ shouldn’t even be used for that. I don’t think that C++ has any pros at all, feel free to prove me wrong.

C++, it’s your time to go.

## Java

![](https://cdn-images-1.medium.com/max/2000/1*fWv6_uU9u4058LsY3lwtgw.png)

![](https://cdn-images-1.medium.com/max/2000/1*M78xqGKHewErNZGkXLQPVQ.png)

> **Java is the most distressing thing to happen to computing since MS-DOS.**

> **- Alan Kay, the [inventor](http://www.cc.gatech.edu/fac/mark.guzdial/squeak/oopsla.html) of [object-oriented programming](https://suzdalnitski.com/oop-will-make-you-suffer-846d072b4dce).**

Having first appeared in 1995, Java is 16 years younger than C++. Java is a much simpler language, which likely has contributed to its popularity.

Language family: **C**.

#### 👍 Garbage collection

One of the biggest benefits that Java provides over C++ is garbage collection, which by itself eliminates a large category of bugs.

#### 👍 Ecosystem

Java has been around for a long time and it has a huge ecosystem for back end development, which significantly reduces development effort.

#### 👎 Object-oriented language

I won’t too deeply into the drawbacks of OOP here, for a more detailed analysis you may read my other article [Object-Oriented Programming — The Trillion Dollar Disaster](https://medium.com/better-programming/object-oriented-programming-the-trillion-dollar-disaster-92a4b666c7c7).

Instead, I’ll simply quote some of the most prominent people in computer science, to get their opinion on OOP:

> I’m sorry that I long ago coined the term “objects” for this topic because it gets many people to focus on the lesser idea. The big idea is messaging.
>  — Alan Kay, the inventor of OOP

Alan Kay is right, the mainstream OOP languages focus on the wrong thing — classes and objects — and ignore messaging. Thankfully, there are modern languages that did get this idea right (e.g. Erlang/Elixir).

> **With OOP-inflected programming languages, computer software becomes more verbose, less readable, less descriptive, and harder to modify and maintain.**

> **— [Richard Mansfield](http://www.4js.com/files/documents/products/genero/WhitePaperHasOOPFailed.pdf)**

Anyone who’s used an OOP language (like Java or C#), and then had experience working in a non-OOP language, can probably relate.

#### 👌 Speed

Java, obviously, runs on top of Java Virtual Machine, which is notorious for its slow startup times. I’ve seen programs running on top of JVM take 30 seconds and longer to startup, which is unacceptable for modern cloud-native programs.

The compilation speed is slow on bigger projects, significantly impacting developer productivity (although nowhere as bad as Scala).

On the upside, the runtime performance of the JVM is really good.

#### 👎 Learning effort

While Java is a rather simple language, its focus on [object-oriented programming](https://suzdalnitski.com/oop-will-make-you-suffer-846d072b4dce) makes becoming good really hard. One can easily write a simple program. However, knowing how to write reliable and maintainable object-oriented code may take well over a decade.

#### 👎 Concurrency

Java was designed in the era of single-core computing and like C++ has only rudimentary concurrency support.

#### 👎 Nulls

In Java, all references are nullable.

#### 👎 Error handling

Catching/throwing errors is the preferred error handling mechanism.

#### 👎 Immutability

Has no built-in support for [immutable](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4) data structures.

#### Verdict

![](https://cdn-images-1.medium.com/max/2000/1*M78xqGKHewErNZGkXLQPVQ.png)

Java was a decent language when it has appeared. It's too bad that, unlike Scala, it has always focused exclusively on OOP. The language is very verbose and suffers a lot from boilerplate code.

The time has come for Java to retire.

## C#

![](https://cdn-images-1.medium.com/max/2000/1*ws5PiT3jBtq3IbYZPTyNYQ.png)

![](https://cdn-images-1.medium.com/max/2000/1*3-dK26VxHTbpgmWEZZjwBw.png)

Fundamentally, there’s little difference between C# and Java (since the early versions of C# were actually a Microsoft implementation of Java).

C# shares most of its cons with Java. Having first appeared in 2000, C# is 5 years younger than Java and has learned a few things from Java’s mistakes.

Language family: **C**.

#### 👌 Syntax

C# syntax has always been a little ahead of Java. C# suffers less from boilerplate code than Java. Although being an OOP language, C# is more on the verbose side. It’s good to see C# syntax being improved with every release, with the addition of features like expression-bodied function members, pattern matching, tuples, and others.

#### 👎 Object-Oriented language

Just like Java, C# focuses mostly on OOP. Once again, I’m not going to spend too much time here trying to convince you of the drawbacks of OOP, I’ll simply quote a few more prominent people in computer science.

> **I think the lack of reusability comes in [object-oriented languages](https://suzdalnitski.com/oop-will-make-you-suffer-846d072b4dce), not in functional languages. Because the problem with object-oriented languages is they’ve got all this implicit environment that they carry around with them. You wanted a banana but what you got was a gorilla holding the banana and the entire jungle.**

> **— Joe Armstrong, creator of Erlang**

I have to agree with Joe Armstrong, reusing object-oriented code is very difficult, in comparison with functional (or even imperative) code.

> [Object oriented](https://suzdalnitski.com/oop-will-make-you-suffer-846d072b4dce) programs are offered as alternatives to correct ones…
>  — Edsger W. Dijkstra, pioneer of computer science

Having worked with both OOP and non-OOP languages throughout my career, I have to agree that OOP code is much harder to get right than non-OOP code.

#### 👎 Multi-paradigm?

C# claims to be a multi-paradigm language. In particular, C# claims to support functional programming. I must disagree, having support for first-class functions is simply not enough for a language to be called functional.

What functional features should a language have? At the very least, built-in support for [immutable](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4) data structures, pattern matching, pipe operator for function composition, Algebraic Datatypes.

#### 👎 Concurrency

C# was created in the era of single-core computing, and like Java has only rudimentary concurrency support.

#### 👎 Nulls

In C#, all references are nullable.

#### 👎 Error handling

Catching/throwing errors is the preferred error handling mechanism.

#### 👎 Immutability

Has no built-in support for immutable data structures.

![](https://cdn-images-1.medium.com/max/2000/1*caUNu6RMeBKLIht997tR8Q.png)

#### Verdict

![](https://cdn-images-1.medium.com/max/2000/1*3-dK26VxHTbpgmWEZZjwBw.png)

I’ve spent a large chunk of my career working with C#, and was always mostly frustrated with the language. Just like with Java, I’d recommend looking for more modern alternatives. It is the same Java under the hood, with a little more modern syntax.

Unfortunately, there’s nothing “sharp” about C#.

## Python

![](https://cdn-images-1.medium.com/max/2000/1*TYakjZNa7mi-XwTVpstXhw.png)

![](https://cdn-images-1.medium.com/max/2000/1*OBGMrbqEbZ_37MvR9j5jfA.png)

Having first appeared in 1991, Python is an old language. Along with JavaScript, Python is one of the most popular languages in the world.

Language family: **C**.

#### 👍 Ecosystem

Python has a library almost for everything. Unlike JavaScript, Python can’t be used for front end web development. However, it easily makes up for this with a huge number of data science libraries.

#### 👍 Learning effort

Python is a very simple language that can be picked up by beginners in a couple of weeks.

#### 👎 Type system

Python is dynamically typed, there’s not much more to say about the type system.

#### 👎 Speed

Python is an interpreted language and is notorious for being one of the slowest programming languages, in terms of runtime performance. Using Cython instead of plain Python may be a good solution where runtime performance is critical.

Python is also pretty slow to start up, in comparison to native languages.

#### 👎 Tooling

Having used Python along with other modern languages, it’s hard not to be disappointed with Python’s dependency management. There’s pip, pipenv, virtualenv, `pip freeze` and others. By comparison, NPM in JavaScript is the only tool you’ll ever need.

#### 👎 Concurrency

Python was not created with concurrency in mindand has only rudimentary concurrency support.

#### 👎 Nulls

In Python, all references are nullable.

#### 👎 Error handling

Catching/throwing errors is the preferred error handling mechanism.

#### 👎 Immutability

Has no built-in support for [immutable](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4) data structures.

#### Verdict

![](https://cdn-images-1.medium.com/max/2000/1*OBGMrbqEbZ_37MvR9j5jfA.png)

It’s really unfortunate that Python has no proper support for functional programming. Functional Programming is suited extremely well for problems that data science is trying to solve. Even for very pythonic tasks like web scraping, functional languages (like Elixir) are a much better fit.

I don’t recommend using Python for large projects, the language was not built with serious software engineering in mind.

Python shouldn’t be used for anything other than data science, when no other alternatives are available. [Julia](https://en.wikipedia.org/wiki/Julia_(programming_language)) seems to be a good modern alternative to Python in the field of data science, although its ecosystem is not nearly as mature as Python’s.

## TypeScript

![](https://cdn-images-1.medium.com/max/2000/1*Nx4nt_MUJj_tToFkoZ6pVQ.png)

![](https://cdn-images-1.medium.com/max/2000/1*OBGMrbqEbZ_37MvR9j5jfA.png)

TypeScript is a compile-to-js language. Its main goal is to make a “better JavaScript” by adding static typing to JavaScript. Just like JavaScript, TypeScript is being used for both frontend and backend development.

TypeScript was designed by Anders Hejlsberg, the same person who designed C#. TypeScript code feels very C-sharpy, and fundamentally can be thought of as C# for the browser.

Language family: **C**.

#### 👎 Superset of JavaScript

Yes, being a superset of JavaScript has helped a lot with the adoption of TypeScript. After all, a lot of people already know JavaScript.

However, being a superset of JavaScript is more of a drawback. This means that TypeScript carries all of the JavaScript baggage. It is limited by all the bad design decisions made in JavaScript.

For example, how many of you like the `this` keyword? Probably nobody, yet TypeScript has deliberately decided to keep that in.

How about the type system acting really weird at times?

```
[] == ![];    // -> true
NaN === NaN;  // -> false
```

In other words, TypeScript shares all of the drawbacks of JavaScript. Being a superset of a bad language can’t turn out to be good.

#### 👍 Ecosystem

TypeScript has access to the entire JavaScript ecosystem, which is enormous. A huge benefit. Node Package Manager is a real pleasure to work with, especially in comparison to other languages, like Python.

The drawback is that not all JavaScript libraries have usable TypeScript declarations. Think Ramda, Immutable.js.

#### 👌 Type system

I’m not too excited about the type system in TypeScript, it’s ok.

On the bright side, it even supports Algebraic Data Types (Discriminated Unions):

```TypeScript
// Taken from: https://stackoverflow.com/questions/33915459/algebraic-data-types-in-typescript

interface Square {
    kind: "square";
    size: number;
}

interface Rectangle {
    kind: "rectangle";
    width: number;
    height: number;
}

interface Circle {
    kind: "circle";
    radius: number;
}

type Shape = Square | Rectangle | Circle;

function area(s: Shape) {
    switch (s.kind) {
        case "square": return s.size * s.size;
        case "rectangle": return s.height * s.width;
        case "circle": return Math.PI * s.radius ** 2;
    }
}

```

Let’s take a look at the same piece of code implemented in ReasonML:

```Reason
type shape = 
   | Square(int)
   | Rectangle(int, int)
   | Circle(int);

let area = fun
   | Square(size) => size * size
   | Rectangle(width, height) => width * height
   | Circle(radius) => 2 * pi * radius;
```

The TypeScript syntax is not as good as in functional languages. Discriminated Unions were added in TypeScript 2.0 as an afterthought. In the `switch`, we’re matching on strings which is error-prone, and the compiler won’t warn us if we miss a case.

TypeScript provides only rudimentary type inference. Also, when using TypeScript, you will find using `any` more often than you’d like to.

#### 👌 Nulls

TypeScript 2.0 has added support for non-nullable types, it can optionally be enabled using the`--strictNullChecks` compiler flag. But…programming with non-nullable types is not the default, and is not considered to be idiomatic in TypeScript.

#### 👎 Error handling

In TypeScript, errors are handled by throwing/catching exceptions.

#### 👎 New JS features

JavaScript gets support for cool new features sooner than TypeScript. Even experimental features can be enabled in JavaScript with the use of Babel, which can’t be done for TypeScript.

#### 👎 Immutability

Dealing with immutable data structures in TypeScript is significantly worse than in JavaScript. While JavaScript developers can use libraries that help with immutability, TypeScript developers typically have to rely on the native array/object spread operators (copy-on-write):

```JavaScript
const oldArray = [1, 2];
const newArray = [...oldArray, 3];



const oldPerson = {
   name: {
     first: "John",
     last: "Snow"
   },
   age: 30
};

// Performing deep object copy is rather cumbersome
const newPerson = {
  ...oldPerson,
  name: {
     ...oldPerson.name,
     first: "Jon"
  }
};
```

Unfortunately, the native spread operator doesn’t perform a deep copy, and manually spreading deep objects is cumbersome. Copying large arrays/objects is also not good for performance.

The `readonly` keyword in TypeScript is nice, it makes properties immutable. However, it’s a long way from having support proper immutable data structures.

JavaScript has good libraries for working with immutable data (like Rambda/Immutable.js). However, getting such libraries to work with the TypeScript type system can be tricky.

#### 👎 TypeScript & React — a match made in hell?

> Dealing with immutable data in JavaScript[and TypeScript] is more difficult than in languages designed for it, like [Clojure](https://clojure.org/).
>
> - Straight from [React Documentation](https://reactjs.org/docs/update.html)

Continuing from the previous drawback, if you’re doing front end web development, then the chances are that you’re using React.

React was not made for TypeScript. React initially was made for a functional language (more on this later). There’s a conflict between programming paradigms — TypeScript is OOP-first, while React is functional-first.

React expects its props (i.e. function arguments) to be immutable, while TypeScript has no proper built-in support for [immutable](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4) data structures.

The only real benefit that TypeScript provides over JavaScript for React development is not having to worry about PropTypes.

#### TypeScript or Hypescript?

Is TypeScript just hype? That’s up to you to decide. I think it is. Its biggest benefit is access to the entire JavaScript ecosystem.

So, why is HypeScript so popular? The same reason Java and C# became popular—being backed by multi-billion corporations with huge marketing budgets.

#### Verdict

![](https://cdn-images-1.medium.com/max/2000/1*OBGMrbqEbZ_37MvR9j5jfA.png)

Although TypeScript is generally thought to be a “better JavaScript,” I’m rating it lower than JavaScript. The benefits it provides over JavaScript are overrated, especially for front end web development with React.

TypeScript has really failed to deliver by keeping all of the bad parts of JavaScript, effectively inheriting decades of bad design decisions made in JavaScript.

## Go

![](https://cdn-images-1.medium.com/max/2000/1*tH31jAu2X4dJbHAFCvuYhA.png)

![](https://cdn-images-1.medium.com/max/2000/1*dtfqjauA1Rvt0pbvNsLrkA.png)

Go was designed to help with programming productivity in the era of multicore processors and large codebases. The designers of Go were primarily motivated by their mutual dislike of C++, which was widely used at Google at that time.

Language family: **C**.

#### 👍 Concurrency

Concurrency is Go’s “killer” feature, Go was built from the ground up for concurrency. Just like Erlang/Elixir, Go follows the mailbox model of concurrency. Unfortunately, goroutines in Go do not provide the same fault tolerance features that Erlang/Elixir processes have. In other words, an exception in a goroutine will bring down the entire program, whereas an exception in an Elixir process will bring down just that one process.

#### 👍 👍 Speed

One of the major reasons Google created Go is compilation speed. There’s even a joke that says Google created Go while waiting for their C++ code to compile.

Go is a fast language. The startup time of Go programs is very fast. Go compiles to native code, so its runtime speed is also amazing.

#### 👍 Learning effort

Go is a simple language, which can probably be learned in about a month by someone with previous programming experience.

#### 👍 Error handling

Go doesn’t support exceptions. Instead, Go makes the developer handle possible errors explicitly. Similarly to Rust, Go returns two values — the result of a call, and a potential error. If everything goes well, then the error will be nil:

```Go
result, err := someFunction( args... );

if err != nil {
  // handle error
} else {
  // handle success
}
```

#### 👍 No object-oriented programming

While some may disagree, I personally think that the lack of OOP features is a big advantage.

To repeat Linus Torvalds:

> **C++ is a horrible [object-oriented] language… And limiting your project to C means that people don’t screw things up with any idiotic “object model” c&@p.
>  — Linus Torvalds, the creator of Linux**

Linus Torvalds is widely known for his open criticism of C++ and OOP. One thing he was 100% right about is **limiting** programmers in the choices they can make. In fact, the **fewer choices** programmers have, the more **resilient** their code becomes.

In my opinion, Go intentionally omitted many OOP features, so as to not repeat the mistakes of C++.

#### 👌 Ecosystem

> Some of the standard libraries are really dumb. Large parts of it are inconsistent with Go’s own philosophy of returning out-of-band errors (e.g. they return a value like -1 for an index instead of `**(int, error)**`), and others rely on global state, such as `**flag**` and `**net/http**`.

There’s a lack of standardization in Go’s standard libraries. For example, some libraries in case of an error return `(int, error)` , others return values like `-1` , while others rely on global state such as `flag`.

The ecosystem is nowhere as big as JavaScript.

#### 👎 Type System

![](https://cdn-images-1.medium.com/max/2272/0*59MR7_xA1YrdHs8U.png)

Pretty much every modern programming language has generics in one form or another (including the dreaded C#/Java, and even C++ has templates). Generics allow the developer to reuse function implementations for different types. Without generics you’d have to implement the `add` function separately for integers, for doubles, and for floats, resulting in a lot of code duplication. In other words, the [lack of generics in Go](https://www.reddit.com/r/ProgrammerHumor/comments/eho336/larry_tesler_did_not_have_go_in_mind_when_he/) results in a large amount of duplicate code. As some people say, “Go” is short for “Go write some boilerplate.”

#### 👎 Nulls

It’s unfortunate that Go has included nulls into the language when safer alternatives have been available for decades.

#### 👎 Immutability

Go has no built-in support for [immutable](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4) data structures.

#### Verdict

![](https://cdn-images-1.medium.com/max/2000/1*dtfqjauA1Rvt0pbvNsLrkA.png)

> Go is not a good language. It’s not bad; it’s just not good. We have to be careful using languages that aren’t good, because if we’re not careful, we might end up stuck using them for the next 20 years.

> - Will Yager in [Why Go Is No Good](http://yager.io/programming/go.html)

If you’re not Google and don’t have use cases similar to Google’s, then Go probably is not a good choice. Go is a simple language best suited for system programming. Go is not a great option for API development (simply because there are much better options available, more on that later).

I think that overall Go is a better choice than Rust (albeit with a weaker type system). It is a simple language that is really fast, is easy to learn, and has great concurrency features. And yes, Go successfully accomplished its design goal of being a “better C++”.

#### Best System Language Award

![](https://cdn-images-1.medium.com/max/2000/1*hZKZMyfynZ664pj97oPJpA.png)

The **Best System Language** award goes to Go. Undoubtedly, Go is the perfect choice for system programming. Go is a low-level language and the fact that it’s a great fit for this field is confirmed by a large number of successful projects built with it, such as Kubernetes, Docker, and Terraform.

## Rust

![](https://cdn-images-1.medium.com/max/2000/1*FMNHqDU0UzSkyvJKx-TQig.png)

![](https://cdn-images-1.medium.com/max/NaN/1*dtfqjauA1Rvt0pbvNsLrkA.png)

Rust is a modern low-level language, initially designed as a replacement for C++.

Language family: **C**.

#### 👍 Speed

Rust was designed from the ground up to be fast. Compilation of Rust programs takes longer than compilation of Go programs. The runtime performance of Rust programs is a little faster than Go.

#### 👍 Nulls

The first language on our list with a modern null alternative! Rust doesn’t have a null or nil value, and Rust developers use the `Option` pattern instead.

```Rust
// Source: https://doc.rust-lang.org/rust-by-example/std/option.html

// The value returned is either a Some of type T, or None
enum Option<T> {
    Some(T),
    None,
}

// An integer division that doesn't `panic!`
fn checked_division(dividend: i32, divisor: i32) -> Option<i32> {
    if divisor == 0 {
        // Failure is represented as the `None` variant
        None
    } else {
        // Result is wrapped in a `Some` variant
        Some(dividend / divisor)
    }
}

// This function handles a division that may not succeed
fn try_division(dividend: i32, divisor: i32) {
    // `Option` values can be pattern matched, just like other enums
    match checked_division(dividend, divisor) {
        None => println!("{} / {} failed!", dividend, divisor),
        Some(quotient) => {
            println!("{} / {} = {}", dividend, divisor, quotient)
        },
    }
}

```

#### 👍 Error handling

Rust takes a modern functional approach to error handling and uses a dedicated `Result` type to signify an operation that might fail. It’s very similar to the `Option` above, however the `None` case now also has a value.

```Rust
// The Result is either the Ok value of type T, or an Err error of type E
enum Result<T,E> {
    Ok(T),
    Err(E),
}

// A function that might fail
fn random() -> Result<i32, String> {
    let mut generator = rand::thread_rng();
    let number = generator.gen_range(0, 1000);
    if number <= 500 {
        Ok(number)
    } else {
        Err(String::from(number.to_string() + " should be less than 500"))
    }
}

// Handling the result of the function
match random() {
    Ok(i) => i.to_string(),
    Err(e) => e,
}
```

#### 👎 Concurrency

Due to the lack of garbage collection, concurrency is rather hard in Rust. Developers have to worry about things like boxing and pinning, which typically are done automatically in a garbage-collected language.

#### 👎 Ecosystem

As of the time of writing, Rust ecosystem is still being developed, and isn’t too mature.

#### 👎 Low-level language

Being a low-level language, developer productivity in Rust can’t be as high as in other higher-level languages. This also makes the learning effort significantly harder.

#### Verdict

![](https://cdn-images-1.medium.com/max/NaN/1*dtfqjauA1Rvt0pbvNsLrkA.png)

Rust is a good fit for system programming. Although more complex than Go, it provides a powerful type system, and overall is a better language. Rust provides a modern alternative to nulls and a modern way of handling errors.

Why is Rust still ranked below JavaScript? It’s a low-level language designed for system programming. Rust is not a good fit for Backend/Web API development, its ecosystem isn’t as developed as in other languages.

## JavaScript

![](https://cdn-images-1.medium.com/max/2000/1*lXUoWcu97jvGX3_sv0zfZw.png)

![](https://cdn-images-1.medium.com/max/2000/1*dtfqjauA1Rvt0pbvNsLrkA.png)

Being the most popular programming language in the world, JavaScript doesn’t need an introduction.

And no, this isn’t a mistake — JavaScript really is ranked above Rust, TypeScript, and Go. Let’s find out why.

Language family: **C**.

#### 👍 👍 Ecosystem

The biggest benefit of JavaScript is its ecosystem. JavaScript is being used for everything you can think of — front ent/back end web development, CLI programming, data science, and even machine learning. JavaScript probably has a library for everything you can think of.

#### 👍 Learning effort

JavaScript (along with Python) is one of the easiest programming languages to learn. One can become productive in JavaScript in a couple of weeks.

#### 👎 Type system

Just like Python, JavaScript is dynamically typed. There’s not much more to say. JavaScript’s type system sometimes can be very weird:

```JavaScript
[] == ![] // -> true
NaN === NaN; // -> false
[] == ''   // -> true
[] == 0    // -> true
```

#### 👌 Immutability

As already noted in the TypeScript section, the spread operator can be bad for performance and doesn’t even perform a deep copy when copying objects. JavaScript lacks built-in support for immutable data structures, although there are libraries that can help with that (Ramda/Immutable.js).

#### 👎 React wasn’t made for JavaScript

Using PropTypes is a must when using React in JavaScript. However, this also means that the PropTypes have to be maintained, which can become a nightmare.

Also, subtle performance issues can be introduced if you’re not careful:

```JavaScript
<HugeList options=[] />
```

Such innocent-looking code can become a performance nightmare, since in JavaScript `[] != []` . The above code will cause the `HugeList` to re-render on every single update, even though the `options` value hasn’t changed. Such issues can compound until the UI eventually becomes impossible to use.

#### 👎 this keyword

The biggest anti-feature of JavaScript probably is the `this` keyword. Its behavior is consistently inconsistent. It’s finicky and can mean completely different things in different contexts. Its behavior even depends on who has called a given function. Using this keyword often results in subtle and weird bugs that can be hard to debug.

#### 👌 Concurrency

JavaScript supports single-threaded concurrency using an event loop. This eliminates the need for thread synchronization mechanisms (like locking). Although JavaScript was not built with concurrency in mind, working with concurrent code is much easier, in comparison to most other languages.

#### 👍 New JS features

JavaScript gets support for cool new features sooner than TypeScript. Even experimental features can be enabled in JavaScript with the use of Babel.

#### 👎 Error handling

Catching/throwing errors is the preferred error handling mechanism.

#### Verdict

![](https://cdn-images-1.medium.com/max/2000/1*dtfqjauA1Rvt0pbvNsLrkA.png)

JavaScript is not a well-designed language. The initial version of JavaScript was put together in ten days (although the future releases have addressed many of its shortcomings).

Despite its shortcomings, JavaScript is a decent choice for full-stack web development. With [proper discipline](https://medium.com/better-programming/js-reliable-fdea261012ee) and linting, JavaScript can be a good language.

## Functional Programming == Peace of Mind

![Photo by [Ante Hamersmit](https://unsplash.com/@ante_kante?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/9078/1*Y23gE1vV5Ta8ba4DPFJSEA.jpeg)

Let’s make a small detour before we continue our ranking. Why bother with functional programming? Because functional programming gives us **peace of mind.**

Yes, functional programming may sound scary, but actually, there’s nothing to be afraid of. Simply put, functional languages made many **right design decisions**, where others made the wrong decisions. In most cases, functional languages will have just the right features: a powerful type system with algebraic data type support, no nulls, no exceptions for error handling, built-in immutable data structures, pattern matching, and function composition operators.

What **common strengths** do functional programming languages have that puts them so high up in our ranking?

#### Programming with pure functions

Unlike imperative(mainstream languages), functional programming languages encourage programming with **pure** functions.

What is a pure function? The idea is very simple — a pure function will always return the same output, given the same input. For example, `2 + 2` will always return `4`, which means that the addition operator `+` is a pure function.

Pure functions are not allowed to interact with the outside world (making API calls, or even writing to the console). They’re not even allowed to change state. It’s the exact opposite of the approach taken by OOP, where any method can freely mutate the state of other objects.

One can easily tell pure functions from impure functions — does the function take no arguments, or return no value? Then it is an impure function.

Here’s an example of a few impure functions:

```JavaScript
// Impure, returns different values on subsequent calls.
// Giveaway: takes no arguments.
Math.random(); // => 0.5456412841544522
Math.random(); // => 0.7542151348966241
Math.random(); // => 0.4534865342354886


let result;
// Impure, mutates outside state (the result variable)
// Giveaway: returns nothing
function append(array, item) {
  result = [ ...array, item ];
}
```

And a couple of pure functions:

```JavaScript
// Pure, doesn't mutate anything outside the body of the function
function append(array, item) {
  return [ ...array, item ];
}

// Pure, always returns the same output given the same input.
function square(x) { return x * x; }
```

Such an approach may seem to be very limiting and can take some time getting used to. It certainly was confusing for me at first!

What are the benefits of pure functions? The’re very easy to test (no need for mocks and stubs). Reasoning about pure functions is easy — unlike in OOP, there’s no need to keep in mind the entire application state. You only need to worry about the current function you’re working on.

Pure functions can be composed easily. Pure functions are great for concurrency, since no state is shared between functions. Refactoring pure functions is pure joy — just copy and paste, no need for complex IDE tooling.

Simply put, pure functions bring the joy back into programming.

Functional programming encourages the use of pure functions — it is good when more than 90% of the codebase consists of pure functions. Some languages take this to an extreme and disallow non-pure functions altogether (not always a great idea).

#### Immutable data structures

![](https://cdn-images-1.medium.com/max/2000/1*4Ll21mV5rnojqyPO0UdpEQ.png)

All of the functional languages below have built-in support for [immutable](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4) data structures. The data structures are also **persistent**. This simply means that whenever a change is being made, we don’t have to create a deep copy of the entire structure. Imaging copying over an array of over 100,000 items over and over again, that must be slow, right?

Instead of creating a copy, persistent data structures simply reuse a reference to the older data structure, while adding in the desired changes.

#### Algebraic data types

![](https://cdn-images-1.medium.com/max/2000/1*eDq6g8kW45BUvq4CfgyG9g.png)

ADTs are a powerful way of modeling application state. One can think of them as Enums on steroids. We specify the possible “subtypes” that our type can be composed of, along with its constructor parameters:

```Reason
type shape = 
   | Square(int)
   | Rectangle(int, int)
   | Circle(int);
```

The type “shape” above can be either a `Square`, a `Rectangle`, or a `Circle`. The `Square` constructor takes a single `int` parameter (width), `Rectangle` takes two `int`parameters (width and height), and `Circle` takes a single `int` parameter (its radius).

Here’s similar code, implemented in Java:

```Java
interface Shape {}

public class Square implements Shape {
  private int width;

  public int getWidth() {
    return width;
  }

  public void setWidth(int width) {
    this.width = width;
  }
}

public class Rectangle implements Shape {
  private int width;
  private int height;

  public int getWidth() {
    return width;
  }

  public void setWidth(int width) {
    this.width = width;
  }
  
  public int getHeight() {
    return height;
  }

  public void setHeight(int height) {
    this.height = height;
  }
}


public class Circle implements Shape {
  private int radius;

  public int getRadius() {
    return radius;
  }

  public void setRadius(int radius) {
    this.radius = radius;
  }
}

```

I don’t know about you, but I’d definitely go with the former version — using ADTs in a functional language.

#### Pattern matching

![](https://cdn-images-1.medium.com/max/2000/1*tWlxgrAoEkXN9tRu-dvoMA.png)

All of the functional languages have great support for pattern matching. In general, pattern matching allows one to write very expressive code.

Here’s an example of pattern matching on an `option(bool)` type:

```Reason
type optionBool =
   | Some(bool)
   | None;

let optionBoolToBool = (opt: optionBool) => {
  switch (opt) {
  | None => false
  | Some(true) => true
  | Some(false) => false
  }
};
```

Here’s the same code, without pattern matching:

```Reason
let optionBoolToBool = opt => {
  if (opt == None) {
    false
  } else if (opt === Some(true)) {
    true
  } else {
    false
  }
}

```

No doubt, the pattern matching version is much more expressive and clean.

Pattern matching also provides compile-time exhaustiveness guarantees, meaning that we won’t forget to check for a possible case. No such guarantees are given in non-functional languages.

#### Nulls

![](https://cdn-images-1.medium.com/max/2000/1*VB3sHbpJAtenCRYGzvWrsg.png)

Functional programming languages generally avoid using the null reference. Instead, the `Option` pattern is used (similar to Rust):

```Reason
let happyBirthday = (user: option(string)) => {
  switch (user) {
  | Some(person) => "Happy birthday " ++ person.name
  | None => "Please login first"
  };
};
```

#### Error handling

![](https://cdn-images-1.medium.com/max/2000/1*n5Xo7XE9ZB4I-U6R0cPyyA.png)

The use of exceptions is generally discouraged in functional languages. Instead, the `Result` pattern is used (once again, similar to Rust):

```Reason
type result('value, 'error) =
  | Ok('value)
  | Error('error);

let happyBirthday = (user: result(person, string)) => {
  switch (user) {
  | Ok(person) => "Happy birthday " ++ person.name
  | Error(error) => "An error occured: " ++ error
  };
};

```

For a great introduction into functional ways of error handling, make sure to read [Composable Error Handling in OCaml](https://keleshev.com/composable-error-handling-in-ocaml).

#### Pipe forward operator

![](https://cdn-images-1.medium.com/max/2000/1*ImQTFdaczUMFhxrpIGdJ_A.png)

Without the pipe forward operator, function calls tend to become deeply nested, which makes them less readable:

```Reason
let isValid = validateAge(getAge(parseData(person)));
```

Functional languages have a special pipe operator that makes this task much easier:

```Reason
let isValid =
  person
    |> parseData
    |> getAge
    |> validateAge;
```

## Haskell

![](https://cdn-images-1.medium.com/max/2000/1*FuriusxduWPT_PjuzQKQOA.png)

![](https://cdn-images-1.medium.com/max/2000/1*IuGZE_Nhzamew8hfy8f2Iw.png)

Haskell can rightfully be called the “mother” of all Functional Programming languages. Haskell is 30 years old — even older than Java. Many of the best ideas in functional programming originated in Haskell.

Language family: **ML**.

#### 👍 👍 Type system

There’s no type system more powerful than Haskell. Obviously, Haskell supports algebraic data types, but it also supports typeclasses. Its type checker is able to infer pretty much anything.

#### 👎👎 Learning effort

Oh boy! It’s no secret that in order to use Haskell productively, one has to be well-versed in category theory first (I’m not kidding). Whereas OOP requires years of experience to write decent code, Haskell requires a very significant investment in learning before one can even be productive.

Writing even a simple “hello world” program in Haskell requires understanding of Monads (IO Monads in particular).

#### 👎👎 Community

> The Haskell community, in my experience, is far more academic. A recent post to the Haskell libraries mailing list began with:

> “It was pointed out to me in a private communication that the tuple function \x->(x,x) is actually a special case of a diagonalization for biapplicative and some related structures monadicially.”

> It received 39 pretty enthusiast replies.

> — momentoftop on [Hacker News](https://news.ycombinator.com/item?id=24978238)

The quote above sums up the Haskell community pretty well. The Haskell community is more interested in academic discussions (and category theory) than in solving real-world problems.

#### 👎 Functional purity

As we’ve already learned, pure functions are amazing. Side effects (e.g. interacting with the outside world, including mutating state) are a cause of a large number of errors in programs. Being a **pure** functional language, Haskell disallows them altogether. This means that functions can never change any values and aren’t even allowed to interact with the outside world (even things like logging aren’t technically allowed).

Of course, Haskell provides workarounds to interact with the outside world. How does it work you may ask? We provide a set of **instructions** (IO Monad). Such instructions may say, “read keyboard input, then use that input in some function, and then print the result to the console.” The language runtime then takes such instructions and executes them for us. We never execute code that interacts with the outside world directly.

> Avoid success at all costs!

> — Haskell’s unofficial motto.

In practice, such focus on functional purity significantly increases the number of abstractions, which increases complexity, and consequently **decreases developer productivity**.

#### 👍 Nulls

Just like Rust, Haskell has no null reference. It uses the Option pattern to signify a value that may not be present.

#### 👍 Error handling

While some functions may throw errors, idiomatic Haskell code uses a pattern similar to the `Result` type in Rust.

#### 👍 Immutability

Haskell has first-class support for [immutable](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4) data structures.

#### 👍 Pattern matching

Haskell has great pattern matching support.

#### 👎 Ecosystem

The standard library is a mess, especially the default prelude (the core library). By default, Haskell uses functions that throw exceptions instead of returning **option** values (the gold standard of functional programming). To add to the mess, Haskell has two package managers — Cabal and Stack.

#### Verdict

![](https://cdn-images-1.medium.com/max/2000/1*IuGZE_Nhzamew8hfy8f2Iw.png)

> **Hardcore** functional programming is not going to ever become mainstream — it requires deeply understanding many highly abstract concepts.

> — David Bryant Copeland in [Four Better Rules for Software Design](https://naildrivin5.com/blog/2019/07/25/four-better-rules-for-software-design.html#conceptual-overhead-creates-confusion-and-complexity)

I really wanted to like Haskell. Unfortunately, Haskell will likely forever be confined to academic circles. Is Haskell the worst of functional programming languages? It’s up to you to decide, but I think it is.

## OCaml

![](https://cdn-images-1.medium.com/max/2000/1*IbB7WSa0aPdzDZCwLkZipQ.png)

![](https://cdn-images-1.medium.com/max/2000/1*IuGZE_Nhzamew8hfy8f2Iw.png)

OCaml is a functional programming language. OCaml stands for Object [Caml](https://en.wikipedia.org/wiki/Caml), however, the irony is that you will [rarely find](https://stackoverflow.com/questions/10779283/when-should-objects-be-used-in-ocaml) anyone using objects in OCaml.

OCaml is almost as old as Java, and the “Objects” part of the name probably reflects the “Objects” hype of that era. OCaml simply picks up where [Caml](https://en.wikipedia.org/wiki/Caml) left off.

Language family: **ML**.

#### 👍 👍 Type system

The type system of OCaml is almost as good as that of Haskell. The biggest drawback is the lack of typeclasses, but it supports functors (higher-order modules).

OCaml is statically typed — its type inference is almost as good as Haskell’s.

#### 👎👎 Ecosystem

OCaml community is small, meaning that you won’t find high-quality libraries for common use cases. For example, OCaml lacks a decent web framework.

The documentation for OCaml libraries is quite bad compared with other languages.

#### 👎 Tooling

The tooling is a mess. There’re three package managers — Opam, Dune, and Esy.

OCaml is known for pretty bad compiler error messages. While not a deal breaker, this is somewhat frustrating, and can affect developer productivity.

#### 👎 Learning resources

The go-to book for learning OCaml is [Real World OCaml](https://www.amazon.com/Real-World-OCaml-Functional-programming/dp/144932391X). The book hasn’t been updated since 2013 and many of the examples are outdated. Following the book is impossible with modern tooling.

The language tutorials are generally extremely poor (in comparison to other languages). They’re mostly lecture notes from academic courses.

#### 👎 Concurrency

“Multicore is coming Any Day Now™️” sums up the story with concurrency in OCaml. OCaml developers have been waiting for proper multicore support for years and it doesn’t seem like it is going to be added to the language in the near future. OCaml seems to be the only functional language that lacks proper multicore support.

#### 👍 Nulls

OCaml has no null reference, and uses the Option pattern to signify a value that may not be present.

#### 👍 Error handling

Idiomatic OCaml code uses the `Result` type pattern.

#### 👍 Immutability

OCaml has first-class support for [immutable](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4) data structures.

#### 👍 Pattern matching

OCaml has great pattern matching support.

#### Verdict

![](https://cdn-images-1.medium.com/max/2000/1*IuGZE_Nhzamew8hfy8f2Iw.png)

OCaml is a good functional language. Its main drawbacks are poor concurrency support and a small community (hence a small ecosystem and a lack of learning resources).

Given its shortcomings, I would not recommend using OCaml in production.

* [Leaving OCaml](https://blog.darklang.com/leaving-ocaml/)

## Scala

![](https://cdn-images-1.medium.com/max/2000/1*3YvmksPPR068HBXkGkHADg.png)

![](https://cdn-images-1.medium.com/max/2000/1*IuGZE_Nhzamew8hfy8f2Iw.png)

Scala is one of the few **truly multi-paradigm** languages, having really good support for both Object-Oriented and Functional programming.

Language family: **C**.

#### 👍 Ecosystem

Scala runs on top of the Java Virtual Machine, which means that it has access to the huge ecosystem of Java libraries. This is a true boon for developer productivity when working on the back end.

#### 👍 Type System

Scala probably is the only typed functional language with an unsound type system that also lacks proper type inference. The type system in Scala is not as good as in other functional languages.

On the bright side, Scala supports Higher-Kinded Types and typeclasses.

Despite its shortcomings, the type system still is very good, hence a thumbs up.

#### 👎 Conciseness/readability

While Scala code is very concise, especially in comparison with Java, the code isn’t very readable.

Scala is one of the few functional languages that actually belong to the C-family of programming languages. C-family languages were intended to be used with imperative programming, while ML-family languages were intended to be used with functional programming. Therefore functional programming in C-like syntax in Scala may feel weird at times.

There’s no proper syntax for Algebraic Data Types in Scala, which adversely affect readability:

```Scala
sealed abstract class Shape extends Product with Serializable

object Shape {
  final case class Square(size: Int) extends Shape
  final case class Rectangle(width: Int, height: Int) extends Shape
  final case class Circle(radius: Int) extends Shape
}
```

ADTs in ReasonML:

```Reason
type shape = 
   | Square(int)
   | Rectangle(int, int)
   | Circle(int);
```

ADTs in an ML language is a clear winner in terms of readability.

#### 👎 👎 Speed

Scala probably is one of the worst programming languages out there in terms of compilation speed. A simple “hello world” program might take up to 10 seconds to compile on older hardware. Scala compiler is not concurrent (compiles code using a single core), which doesn’t help with compilation speed.

Scala runs on top of Java Virtual Machine, which means that programs will take longer to start up.

#### 👎 Learning effort

Scala has a lot of features, which makes it harder to learn. Just like C++, the language is bloated with features.

Scala is one of the most difficult functional languages (second only to Haskell). In fact, its poor learnability is number one deciding factor for companies when leaving Scala.

#### 👍 Immutability

Scala has first-class support for [immutable](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4) data structures (using **case classes**).

#### 👌 Nulls

On the downside, Scala supports null references. On the upside, the idiomatic way of working with potentially missing values is using the `Option` pattern (just like other functional languages).

#### 👍 Error handling

Just like in other functional languages, it is idiomatic is Scala to use the `Result` pattern for error handling.

#### 👌 Concurrency

Scala runs on top of the JVM, which wasn’t really built for concurrency. On the upside, the [Akka](https://en.wikipedia.org/wiki/Akka_(toolkit)) toolkit is very mature, and provides Erlang-like concurrency on the JVM.

#### 👍 Pattern matching

Scala has great pattern matching support.

#### Verdict

![](https://cdn-images-1.medium.com/max/2000/1*IuGZE_Nhzamew8hfy8f2Iw.png)

I really wanted to like Scala, but I just couldn’t. Scala attempts to do too much. Its designers had to make many tradeoffs in order to support both OOP and FP. As the Russian proverb goes — “The Person Who Chases Two Rabbits Catches Neither”.

## Elm

![](https://cdn-images-1.medium.com/max/2000/1*bpRljdoYNwkkwzPEQ8_xTg.png)

![](https://cdn-images-1.medium.com/max/2000/1*7zkcv0rLUoLT79Bec9HXNA.png)

Elm is a functional compile-to-js language used primarily for frontend web development.

What makes Elm unique is its promise of no runtime exceptions, ever. Applications written in Elm are very robust.

Language family: **ML**.

![](https://cdn-images-1.medium.com/max/2000/1*caUNu6RMeBKLIht997tR8Q.png)

#### 👍 Very nice error messages

The Elm compiler provides some of the nicest error messages I’ve ever seen, which makes the language much more approachable even to complete beginners.

#### 👍 Error handling

Elm has no runtime errors. The language doesn’t support exceptions, period. Elm is a pure functional language with no runtime exceptions. This means that if your codebase is 100% Elm, then you will never see runtime errors. The only time when you’ll encounter runtime errors with Elm is when interacting with outside JavaScript code.

How does Elm handle errors? Just like many other functional languages, using the `Result` data type.

#### 👎 Functional purity

Just like Haskell, Elm is a pure functional language.

Does Elm make you more productive by eliminating all runtime exceptions, or does it make you less productive by forcing functional purity everywhere? In my experience, any significant refactoring in Elm is a nightmare, because of the significant amount of “plumbing” involved.

Decide for yourself, but I’ll give this characteristic of Elm a thumbs down.

#### 👎 Overly opinionated

![Quigglez on [Reddit](https://www.reddit.com/r/ProgrammerHumor/comments/8we9zh/im_learning_elm_and_it_immediately_declared_war/)](https://cdn-images-1.medium.com/max/2000/0*WDEERYs8Wc_Cp6Pv.png)

The Elm is an opinionated language. To the point that using tabs is considered a syntactic error.

Elm’s focus on “no errors ever” is killing the language. The latest version (0.19) has introduced a breaking change, which makes interop with JavaScript libraries next to impossible. The intention, of course, is for people to write their own libraries in Elm to help the ecosystem grow. However, few companies have the resources to reimplement everything in Elm. This made many people to leave Elm for good.

The designer of Elm seems to be too focused on functional purity, taking the “no errors ever” idea to the extreme.

#### 👎 No React

Elm makes use of its own Virtual DOM and, unlike languages like ReasonML, it doesn’t use React. This means that the developers have no access to the vast ecosystem of libraries and components made for React.

#### 👎 👎 Language development

Sadly, it’s been over a year since a new version of Elm has been released (0.19.1). There’s zero transparency on the development process, there’s no way for anyone to contribute to the development. With every major release Elm has introduced breaking changes which made the language impossible to use for some. We haven’t really heard anything from its creator for over a year now. We don’t even know whether or not he’s still working full-time on Elm. The language might actually be dead by now.

#### 👍 Pattern matching

Elm has great pattern matching support.

#### 👍 Immutability

Elm has first-class support for [immutable](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4) data structures.

#### 👍 Nulls

Elm doesn’t support nullable references, and just like other functional languages makes use of the `Option` pattern instead.

#### Verdict

![](https://cdn-images-1.medium.com/max/2000/1*7zkcv0rLUoLT79Bec9HXNA.png)

Elm is an excellent language. Unfortunately, it doesn’t seem to have a future. But it can be a great way to get into Functional Programming.

* [The Biggest Problem with Elm by Charles Scalfani](https://medium.com/@cscalfani/the-biggest-problem-with-elm-4faecaa58b77)
* [Why I’m leaving Elm by Luke Plant](https://lukeplant.me.uk/blog/posts/why-im-leaving-elm/)

## F#

![](https://cdn-images-1.medium.com/max/2000/1*6XYhMTeTvSLgkiVI3W3Yew.png)

![](https://cdn-images-1.medium.com/max/2000/1*d0QM_oPhJjHDJ_aR35dGwQ.png)

F# can be summed up as OCaml for .NET. Its syntax is very similar to OCaml, with a few minor differences. Having first appeared in 2005, F# is a very mature language with great tooling and a rich ecosystem.

Language family: **ML**.

#### 👍 👍 Type system

The only type system drawback is the lack of Higher-Kinded Types. Still the type system is very solid, the compiler is able to infer pretty much anything. F# has proper support for ADTs.

#### 👍 Functional but not pure

Unlike Haskell/Elm, F# is very pragmatic, and does not enforce function purity.

#### 👍 Learning resources

F# has some really [good learning resources](https://fsharpforfunandprofit.com/), probably on par with Elixir.

#### 👍 Learning effort

F# is one of the easiest functional languages to pick up.

#### 👌 Ecosystem

F# community is rather small, and unlike languages like Elixir, it simply doesn’t have the same great libraries.

#### 👍 C# interop

On the upside, F# has access to the entire .NET/C# ecosystem. Interop with existing C# code is really good.

#### 👌 Concurrency

F# runs on top of CLR, which doesn’t have the same superb concurrency support that Elixir enjoys from the Erlang VM (more on this later).

#### 👍 Nulls

The null value is not normally used in F# code. It uses the Option pattern to signify a value that may not be present.

#### 👍 Error handling

Idiomatic F# code uses the `Result` pattern for error handling.

#### 👍 Immutability

F# has first-class support for [immutable](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4) data structures.

#### 👍 Pattern matching

F# has great pattern matching support.

#### Verdict

![](https://cdn-images-1.medium.com/max/2000/1*d0QM_oPhJjHDJ_aR35dGwQ.png)

F# is a very solid programming language with a really good type system. It’s almost as good as Elixir for Web API development (more on this later). However, the problem with F# is not what it has, but what it doesn’t have. To draw comparison with Elixir, its concurrency features, rich ecosystem, and amazing community, outweigh any static typing benefits that F# provides.

* [Dark’s new backend will be in F#](https://blog.darklang.com/new-backend-fsharp/)

#### Awards

![](https://cdn-images-1.medium.com/max/2000/1*uSNPih5UwouMt-5PptT3VQ.png)

F# receives two awards.

F# gets the **Best Language for Fintech** award. It’s no secret that finances is one of the biggest applications of F#.

F# also gets the **Best Language for Enterprise Software** award. Its rich type system allows for the modeling of complex business logic. [Domain Modeling Made Functional](https://pragprog.com/titles/swdddf/domain-modeling-made-functional/) is a highly recommended book to read.

## ReasonML

![](https://cdn-images-1.medium.com/max/2000/1*pyf_-AQH2lu14dyRnYIH0g.png)

![](https://cdn-images-1.medium.com/max/2000/1*4IyuKsPlzIO3q5zKa_pMMA.png)

ReasonML is a functional compile-to-js language used primarily for frontend web development.

ReasonML is not a new language, it is a new syntax for OCaml (an old and tried programming language). ReasonML is backed by Facebook.

By leveraging the JavaScript ecosystem, ReasonML doesn’t suffer from the same drawbacks as OCaml.

Language family: **ML**.

#### 👍 Not a superset of JavaScript

ReasonML’s syntax is similar to JavaScript, which makes it much more approachable to anyone with JavaScript experience. However, unlike TypeScript, ReasonML doesn’t even attempt to be a superset of JavaScript (a good thing as we’ve already learned). Unlike TypeScript, ReasonML didn’t have to inherit decades of bad design decisions made by JavaScript.

#### 👍 Learning effort

Since ReasonML doesn’t even attempt to be a superset of JavaScript, it makes the language much simpler than JavaScript. Somebody with functional programming experience in JavaScript can pick up ReasonML in about a week.

ReasonML truly is one of the simplest programming languages out there.

#### 👍 Functional, but not pure

Unlike Elm, ReasonML doesn’t even attempt to be a pure functional language, and has no goal of “no runtime errors ever.” This means that ReasonML is very pragmatic, focused on developer productivity and achieving results fast.

#### 👍 👍 Type system

ReasonML really is OCaml, which means that its type system is almost as good as Haskell’s. The biggest drawback is the lack of typeclasses, but it supports functors (higher-order modules).

ReasonML is statically typed and its type inference is almost as good as Haskell.

#### 👍 👍 Ecosystem

Just like TypeScript, ReasonML has access to the entire JavaScript ecosystem.

#### 👍 JavaScript/TypeScript interop

ReasonML compiles to plain JavaScript. Therefore it is possible to use both ReasonML and JavaScript/TypeScript in the same project.

#### 👍 ReasonML and React — a match made in heaven

If you’re doing front end web development, then the chances are that you’re using React. Did you know that React initially was written in OCaml and only then was ported to JavaScript to help with adoption?

Since ReasonML is statically-typed, there’s no need to worry about PropTypes.

Remember the innocent-looking example from the section on JavaScript that can cause performance disasters?

```JavaScript
<HugeList options=[] />
```

ReasonML has proper support for [immutable](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4) data structures and such code will not create performance issues:

```Reason
<Person person={
    id: "0",
    firstName: "John",
  }
  friends=[samantha, liz, bobby]
  onClick={id => Js.log("clicked " ++ id)}
/> 
```

Unlike JavaScript, with ReasonML nothing gets unnecessarily re-rendered — you get great React performance out of the box!

#### 👎 Tooling

ReasonML isn’t nearly as mature as the alternatives, like TypeScript, and there may be some issues with the tooling. For example, the officially recommended VSCode extension [reason-language-server](https://github.com/jaredly/reason-language-server) is currently broken. However, [other alternatives](https://github.com/ocamllabs/vscode-ocaml-platform) exist.

ReasonML uses the OCaml compiler under the hood, and OCaml is known for pretty bad compiler error messages. While not a deal breaker, this is somewhat frustrating, and can affect developer productivity.

I expect the tooling to improve as the language becomes more mature.

#### 👍 Nulls

ReasonML has no null reference and uses the Option pattern to signify a value that may not be present.

#### 👍 Immutability

ReasonML has first-class support for [immutable](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4) data structures.

#### 👍 Pattern matching

ReasonML has great pattern matching support.

#### Verdict

![](https://cdn-images-1.medium.com/max/2000/1*4IyuKsPlzIO3q5zKa_pMMA.png)

ReasonML probably is what TypeScript always aimed to be but failed. ReasonML adds static typing to JavaScript, while removing all of the bad features (and adding in modern features that truly matter).

#### Best Frontend Language Award

![](https://cdn-images-1.medium.com/max/2000/1*UxzOra01CjpZvDpSm1Uw9Q.png)

The **Best Frontend Language** award goes to ReasonML. Undoubtedly, ReasonML is the best option for frontend web development.

## Elixir

![](https://cdn-images-1.medium.com/max/2000/1*6G-q2LUMk0wFO6FcNVdJ0g.png)

![](https://cdn-images-1.medium.com/max/2000/1*4IyuKsPlzIO3q5zKa_pMMA.png)

Elixir probably is the most popular functional programming language in the world. Just like ReasonML, Elixir is not really a new language. Instead, Elixir builds upon more than three decades of Erlang’s success.

Elixir is Go’s functional cousin. Just like Go, Elixir was designed from the ground up for concurrency to take advantage of multiple processor cores.

Unlike some other functional languages, Elixir is very pragmatic. It’s focused on getting results. You won’t find long academic discussions in the Elixir community. The [Elixir Forum](http://elixirforum.com) is full of solutions to actual, real-world problems, and the community is very friendly to beginners.

Language family: **ML**.

#### 👍 👍 Ecosystem

What really makes Elixir shine is its ecosystem. In most other languages there’s the language and there’s the ecosystem — **two separate things**. In Elixir, the core frameworks in the ecosystem are being developed by the core Elixir team. José Valim, the creator of Elixir is also the main contributor in [Phoenix](https://github.com/phoenixframework/phoenix) and [Ecto](https://github.com/elixir-ecto/ecto) — the super cool libraries in the Elixir ecosystem.

In most other languages there’re many different libraries focused on the same task — many different web servers, many different ORMs, etc. In Elixir, the development efforts are really focused on the core few libraries, which results in outstanding library quality.

The documentation of Elixir libraries is very good, with plenty of examples. Unlike some other languages, the standard library is also very well documented.

#### 👍 Phoenix framework

The slogan of the Phoenix framework is “Phoenix just feels right”. Unlike frameworks in other languages, Phoenix has a lot of functionality built-in. Out of the box, it supports WebSockets, routing, HTML templating language, internationalization, JSON encoders/decoders, seamless ORM integration(Ecto), sessions, SPA toolkit, and a lot more.

Phoenix framework is known for its great performance, being able to handle [millions of simultaneous connections](https://www.phoenixframework.org/blog/the-road-to-2-million-websocket-connections) on a single machine.

#### 👍 Fullstack Elixir

The Phoenix framework has recently introduced [LiveView](https://elixirschool.com/blog/phoenix-live-view/), which allows building rich realtime web interfaces right within Elixir (think Single-Page Applications). No JavaScript needed, no React!

LiveView even takes care of synchronizing the client and server state, which means that we don’t have to worry about developing and maintaining a REST/GraphQL API.

#### 👍 Data processing

Elixir can be a solid alternative to Python for a lot of tasks related to data-processing. Having built a web scraper in both Python and Elixir, Elixir is hands down a much better language and ecosystem for the task.

Tools like [Broadway](https://github.com/dashbitco/broadway) allow building data ingestion/data processing pipelines in Elixir.

#### 👌 Type System

In my opinion, the lack of proper static typing is the biggest drawback of Elixir. While Elixir isn’t statically typed, the compiler (along with [dialyzer](http://erlang.org/doc/apps/dialyzer/dialyzer_chapter.html#:~:text=Dialyzer%20is%20a%20static%20analysis,entire%20(sets%20of)%20applications.)) will report a lot of errors at compile-time. This goes a long way over dynamically typed languages (like JavaScript, Python and Clojure).

#### 👍 Speed

Elixir compiler is multi-threaded and offers blazing fast compilation speeds. Unlike Java Virtual Machine, the Erlang VM is fast to start. The runtime performance is very good for Elixir’s use cases.

#### 👍👍 Reliability

Elixir builds on top of Erlang, which was used for over 30 years to build the most reliable software in the world. Some programs running on top of the Erlang VM have been able to achieve [99.9999999% reliability](https://stackoverflow.com/questions/8426897/erlangs-99-9999999-nine-nines-reliability). No other platform in the world can boast the same level of reliability.

#### 👍 👍 Concurrency

Most other programming languages have not been designed for concurrency. This means that writing code that makes use of multiple threads/processor cores is far from trivial. Other programming languages make use of threads that execute parallel code (and shared memory, that the threads read from/write to). Such approach typically is error-prone, prone to deadlocks, and causes exponential increases in complexity.

Elixir builds on top of Erlang, which is known for its great concurrency features, and takes an entirely different approach to concurrency, called the [actor model](https://www.brianstorti.com/the-actor-model/). Within this model, **nothing is shared** between the processes(actors). Each process maintains its own internal state, and the only way to communicate between the various processes is by **sending messages**.

By the way, the actor model really is [OOP as first intended](https://medium.com/better-programming/object-oriented-programming-the-trillion-dollar-disaster-92a4b666c7c7) by its creator, Alan Kay, where nothing is shared, and objects only communicate by passing messages.

Let’s draw a quick comparison between Elixir, and its imperative cousin Go. Unlike Go, Elixir was designed from the ground up for fault tolerance. Whenever a goroutine crashes, the **entire Go program goes down**. In Elixir, whenever a process dies, **only that single process dies**, without affecting the rest of the program. Even better, the failed process will get restarted automatically by its supervisor. This allows the failed process to retry the operation that has failed.

Elixir processes are also very lightweight, one can easily spin hundreds of thousands of processes on a single machine.

#### 👍 👍 Scaling

Let’s draw another comparison with Go. Concurrency in both Go and Elixir makes use of message passing between concurrent processes. Go programs will run faster on the first machine since Go compiles to native code.

However, once you start scaling beyond the first machine, Go programs start losing. Why? Because Elixir was designed from the ground up to run on multiple machines. The Erlang VM that Elixir runs on top of really shines when it comes to distribution and scaling. It seamlessly takes care of many tedious things like clustering, RPC functionality, and networking.

In a sense, the Erlang VM was doing microservices decades before microservices became a thing. Every process can be thought of as a microservice — just like microservices, processes are independent from one another. It’s not uncommon for processes to run across multiple machines, with communication mechanism built into the language.

Microservices without the complexity of Kubernetes? Check. That’s what Elixir was really designed for.

#### 👍 Error handling

Elixir takes a very unique approach to error handling. While pure functional languages (Haskell/Elm) are designed to minimize the probability of errors, Elixir assumes that **errors will inevitably happen**.

Throwing exceptions is fine in Elixir, while catching exceptions generally is discouraged. Instead, the process supervisor will **restart the failed process** automatically to keep the program running.

#### 👌 Learning effort

Elixir is a simple language that one can [pick up](https://pragprog.com/titles/elixir16/programming-elixir-1-6/) in a month or two. What makes the learning somewhat harder is OTP.

OTP is the killer feature of Elixir. OTP is a set of tools and libraries from Erlang that Elixir builds upon. It is the secret sauce that significantly simplifies building concurrent and distributed programs.

While Elixir itself is pretty simple, [wrapping one’s head around OTP](https://pragprog.com/titles/jgotp/designing-elixir-systems-with-otp/) can take some time — it certainly did for me.

#### 👍 Learning resources

Being the most popular functional programming language, Elixir has a wealth of learning resources. There are a dozen amazing Elixir books on the [Pragmatic Programmers](https://pragprog.com/categories/elixir-phoenix-and-otp/). The learning resources almost always are super friendly to beginners.

#### 👍 Pattern matching

Elixir has great pattern matching support.

#### 👎 Crunching numbers

Elixir doesn’t handle computationally-intensive tasks well. A compile-to-native language should be chosen instead for such tasks (Go/Rust are good options).

#### Ok, what’s the deal with Erlang?

For all intents and purposes, Elixir and Erlang are identical under the hood. Erlang is a powerful language with a weird syntax. Elixir can be thought of as a nicer and more modern syntax for Erlang (along with a very nice ecosystem and community).

#### Verdict

![](https://cdn-images-1.medium.com/max/2000/1*4IyuKsPlzIO3q5zKa_pMMA.png)

Elixir probably is the most mature of all functional languages. It also runs on top of a virtual machine made for functional programming. It was designed for concurrency from the ground up and is a perfect fit for the modern era of multicore processors.

Watch the short [Elixir Documentary](https://www.youtube.com/watch?v=lxYFOM3UJzo) to learn more.

#### Awards

![](https://cdn-images-1.medium.com/max/2000/1*RwH0ya2xr07QWPeOux963A.png)

Elixir receives two awards.

Its resiliency, functional-first approach, and amazing ecosystem makes it the **Best Language for Building Web APIs**.

OTP and the actor model make Elixir the **Best Language for Building Concurrent and Distributed Software**. Unlike its imperative cousin Go, software written in Elixir can scale horizontally to thousands of servers and comes with fault tolerance out of the box.

## Why Not Use the Right Tool for the Job?

![Photo by [Haupes Co.](https://unsplash.com/@haupes?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/tool?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/3072/1*F57kq5OAo_8OShoWxxNLIA.jpeg)

Would you use a screwdriver to drive a nail? Probably not. So we probably shouldn’t attempt to use one programming language for everything — every language has its place.

Go is the best language for system programming. The best option to use for front end development is undoubtedly ReasonML, it ticks most of the requirements of a great programming language. The absolute winner for Web API Development is Elixir, its only drawback is a lack of static type system (which is being offset by a great ecosystem, community, reliability, and concurrency features). The best option for any sort of concurrent/distributed software is once again Elixir.

If you’re working with data science, then, unfortunately, the only reasonable choice is Python.

I really hope that this article was useful. Comparing programming languages is no easy task, but I did my best.

What are your thoughts and experience? Have I missed anything important? Should some language be ranked lower or higher? Let me know in the comments.

## What’s next?

* [Hate bugs? Use This Simple Trick To Become a Kickass Programmer](https://suzdalnitski.com/terrible-coding-mistake-aa1fbebd83b4)
* [Object-Oriented Programming — The Trillion Dollar Disaster](https://betterprogramming.pub/object-oriented-programming-the-trillion-dollar-disaster-92a4b666c7c7)
* [Object-Oriented Programming is The Biggest Mistake of Computer Science](https://suzdalnitski.com/oop-will-make-you-suffer-846d072b4dce)
* [Functional Programming? Don’t Even Bother, It’s a Silly Toy](https://betterprogramming.pub/fp-toy-7f52ea0a947e) (a satire)
* [OOP Design Patterns Considered Harmful](https://suzdalnitski.com/oop-design-patterns-bd2c4fb3014c)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
