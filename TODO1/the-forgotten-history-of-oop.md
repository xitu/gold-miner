> * 原文地址：[The Forgotten History of OOP](https://medium.com/javascript-scene/the-forgotten-history-of-oop-88d71b9b2d9f)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-forgotten-history-of-oop.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-forgotten-history-of-oop.md)
> * 译者：
> * 校对者：

# The Forgotten History of OOP

![](https://cdn-images-1.medium.com/max/2000/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)

> Note: This is part of the “Composing Software” series on learning functional programming and compositional software techniques in JavaScript ES6+ from the ground up. Stay tuned. There’s a lot more of this to come!  
> [< Previous](https://github.com/xitu/gold-miner/blob/a9a689ee3df732ea0c9e88207ad6cf0a10ad7d4b/TODO1/abstraction-composition.md) | [<< Start over at Part 1](https://github.com/xitu/gold-miner/blob/a9a689ee3df732ea0c9e88207ad6cf0a10ad7d4b/TODO1/composing-software-an-introduction.md)

The functional and imperative programming paradigms we use today were first explored mathematically in the 1930s with lambda calculus and the Turing machine, which are alternative formulations of universal computation (formalized systems which can perform general computation). The Church Turing Thesis showed that lambda calculus and Turing machines are functionally equivalent — that anything that can be computed using a Turing machine can be computed using lambda calculus, and vice versa.

> Note: There is a common misconception that Turing machines can compute anything computable. There are classes of problems (e.g., [the halting problem](https://en.wikipedia.org/wiki/Halting_problem)) that can be computable for some cases, but are not generally computable for all cases using Turing machines. When I use the word “computable” in this text, I mean “computable by a Turing machine”.

Lambda calculus represents a top-down, function application approach to computation, while the ticker tape/register machine formulation of the Turing machine represents a bottom-up, imperative (step-by-step) approach to computation.

Low level languages like machine code and assembly appeared in the 1940s, and by the end of the 1950s, the first popular high-level languages appeared. Lisp dialects are still in common use today, including Clojure, Scheme, AutoLISP, etc. FORTRAN and COBOL both appeared in the 1950s and are examples of imperative high-level languages still in use today, though C-family languages have replaced both COBOL and FORTRAN for most applications.

Both imperative programming and functional programming have their roots in the mathematics of computation theory, predating digital computers. “Object-Oriented Programming” (OOP) was coined by Alan Kay circa 1966 or 1967 while he was at grad school.

Ivan Sutherland’s seminal Sketchpad application was an early inspiration for OOP. It was created between 1961 and 1962 and published in his [Sketchpad Thesis](https://dspace.mit.edu/handle/1721.1/14979) in 1963. The objects were data structures representing graphical images displayed on an oscilloscope screen, and featured inheritance via dynamic delegates, which Ivan Sutherland called “masters” in his thesis. Any object could become a “master”, and additional instances of the objects were called “occurrences”. Sketchpad’s masters share a lot in common with JavaScript’s prototypal inheritance.

> **Note:** The TX-2 at MIT Lincoln Laboratory was one of the early uses of a graphical computer monitor employing direct screen interaction using a light pen. The EDSAC, which was operational between 1948–1958 could display graphics on a screen. The Whirlwind at MIT had a working oscilloscope display in 1949. The project’s motivation was to create a general flight simulator capable of simulating instrument feedback for multiple aircraft. That led to the development of the SAGE computing system. [The TX-2 was a test computer for SAGE](http://www.computerhistory.org/revolution/real-time-computing/6/123).

The first programming language widely recognized as “object oriented” was Simula, specified in 1965. Like Sketchpad, Simula featured objects, and eventually introduced classes, class inheritance, subclasses, and virtual methods.

> Note: A **virtual method** is a method defined on a class which is designed to be overridden by subclasses. Virtual methods allow a program to call methods that may not exist at the moment the code is compiled by employing dynamic dispatch to determine what concrete method to invoke at runtime. JavaScript features dynamic types and uses the delegation chain to determine which methods to invoke, so does not need to expose the concept of virtual methods to programmers. Put another way, all methods in JavaScript use runtime method dispatch, so methods in JavaScript don’t need to be declared “virtual” to support the feature.

### The Big Idea

> _“I made up the term ‘object-oriented’, and I can tell you I didn’t have C++ in mind.” ~ Alan Kay, OOPSLA ‘97_

Alan Kay coined the term “object oriented programming” at grad school in 1966 or 1967. The big idea was to use encapsulated mini-computers in software which communicated via message passing rather than direct data sharing — to stop breaking down programs into separate “data structures” and “procedures”.

“The basic principal of recursive design is to make the parts have the same power as the whole.” ~ Bob Barton, the main designer of the B5000, a mainframe optimized to run Algol-60.

Smalltalk was developed by Alan Kay, Dan Ingalls, Adele Goldberg, and others at Xerox PARC. Smalltalk was more object-oriented than Simula — everything in Smalltalk is an object, including classes, integers, and blocks (closures). The original Smalltalk-72 did not feature subclassing. [That was introduced in Smalltalk-76 by Dan Ingalls](http://worrydream.com/EarlyHistoryOfSmalltalk).

While Smalltalk supported classes and eventually subclassing, Smalltalk was not about classes or subclassing things. It was a functional language inspired by Lisp as well as Simula. Alan Kay considers the industry’s focus on subclassing to be a distraction from the true benefits of object oriented programming.

> “I’m sorry that I long ago coined the term “objects” for this topic because it gets many people to focus on the lesser idea. The big idea is messaging.”  
> ~ Alan Kay

In [a 2003 email exchange](http://www.purl.org/stefan_ram/pub/doc_kay_oop_en), Alan Kay clarified what he meant when he called Smalltalk “object-oriented”:

> “OOP to me means only messaging, local retention and protection and hiding of state-process, and extreme late-binding of all things.”  
> ~ Alan Kay

In other words, according to Alan Kay, the essential ingredients of OOP are:

*   Message passing
*   Encapsulation
*   Dynamic binding

Notably, inheritance and subclass polymorphism were NOT considered essential ingredients of OOP by Alan Kay, the man who coined the term and brought OOP to the masses.

### The Essence of OOP

The combination of message passing and encapsulation serve some important purposes:

*   **Avoiding shared mutable state** by encapsulating state and isolating other objects from local state changes. The only way to affect another object’s state is to ask (not command) that object to change it by sending a message. State changes are controlled at a local, cellular level rather than exposed to shared access.
*   **Decoupling** objects from each other — the message sender is only loosely coupled to the message receiver, through the messaging API.
*   **Adaptability and resilience to changes** at runtime via late binding. Runtime adaptability provides many great benefits that Alan Kay considered essential to OOP.

These ideas were inspired by biological cells and/or individual computers on a network via Alan Kay’s background in biology and influence from the design of Arpanet (an early version of the internet). Even that early on, Alan Kay imagined software running on a giant, distributed computer (the internet), where individual computers acted like biological cells, operating independently on their own isolated state, and communicating via message passing.

> “I realized that the cell/whole-computer metaphor would get rid of data\[…\]”  
> ~ Alan Kay

By “get rid of data”, Alan Kay was surely aware of shared mutable state problems and tight coupling caused by shared data — common themes today.

But in the late 1960s, [ARPA programmers were frustrated by the need to choose a data model representation](https://www.rand.org/content/dam/rand/pubs/research_memoranda/2007/RM5290.pdf) for their programs in advance of building software. Procedures that were too tightly coupled to particular data structures were not resilient to change. They wanted a more homogenous treatment of data.

> “[…] the whole point of OOP is not to have to worry about what is inside an object. Objects made on different machines and with different languages should be able to talk to each other […]” ~ Alan Kay

Objects can abstract away and hide data structure implementations. The internal implementation of an object could change without breaking other parts of the software system. In fact, with extreme late binding, an entirely different computer system could take over the responsibilities of an object, and the software could keep working. Objects, meanwhile, could expose a standard interface that works with whatever data structure the object happened to use internally. The same interface could work with a linked list, a tree, a stream, and so on.

Alan Kay also saw objects as algebraic structures, which make certain mathematically provable guarantees about their behaviors:

> “My math background made me realize that each object could have several algebras associated with it, and there could be families of these, and that these would be very very useful.”  
> ~ Alan Kay

This has proven to be true, and forms the basis for objects such as promises and lenses, both inspired by category theory.

The algebraic nature of Alan Kay’s vision for objects would allow objects to afford formal verifications, deterministic behavior, and improved testability, because algebras are essentially operations which obey a few rules in the form of equations.

In programmer lingo, algebras are like abstractions made up of functions (operations) accompanied by specific laws enforced by unit tests those functions must pass (axioms/equations).

Those ideas were forgotten for decades in most C-family OO languages, including C++, Java, C#, etc., but they’re beginning to find their way back into recent versions of most widely used OO languages.

You might say the programming world is rediscovering the benefits of functional programming and reasoned thought in the context of OO languages.

Like JavaScript and Smalltalk before it, most modern OO languages are becoming more and more “multi-paradigm languages”. There is no reason to choose between functional programming and OOP. When we look at the historical essence of each, they are not only compatible, but complementary ideas.

Because they share so many features in common, I like to say that JavaScript is Smalltalk’s revenge on the world’s misunderstanding of OOP. Both Smalltalk and JavaScript support:

*   Objects
*   First-class functions and closures
*   Dynamic types
*   Late binding (functions/methods changeable at runtime)
*   OOP without class inheritance

What is essential to OOP (according to Alan Kay)?

*   Encapsulation
*   Message passing
*   Dynamic binding (the ability for the program to evolve/adapt at runtime)

What is non-essential?

*   Classes
*   Class inheritance
*   Special treatment for objects/functions/data
*   The `new` keyword
*   Polymorphism
*   Static types
*   Recognizing a class as a “type”

If your background is Java or C#, you may be thinking static types and Polymorphism are essential ingredients, but Alan Kay preferred dealing with generic behaviors in algebraic form. For example, from Haskell:

```
fmap :: (a -> b) -> f a -> f b
```

This is the functor map signature, which acts generically over unspecified types `a` and `b`, applying a function from `a` to `b` in the context of a functor of `a` to produce a functor of `b`. Functor is math jargon that essentially means “supporting the map operation”. If you're familiar with `[].map()` in JavaScript, you already know what that means.

Here are two examples in JavaScript:

```
// isEven = Number => Boolean
const isEven = n => n % 2 === 0;

const nums = [1, 2, 3, 4, 5, 6];

// map takes a function `a => b` and an array of `a`s (via `this`)
// and returns an array of `b`s.
// in this case, `a` is `Number` and `b` is `Boolean`
const results = nums.map(isEven);

console.log(results);
// [false, true, false, true, false, true]
```

The `.map()` method is generic in the sense that `a` and `b` can be any type, and `.map()` handles it just fine because arrays are data structures that implement the algebraic `functor` laws. The types don't matter to `.map()` because it doesn't try to manipulate them directly, instead applying a function that expects and returns the correct types for the application.

```
// matches = a => Boolean
// here, `a` can be any comparable type
const matches = control => input => input === control;

const strings = ['foo', 'bar', 'baz'];

const results = strings.map(matches('bar'));

console.log(results);
// [false, true, false]
```

This generic type relationship is difficult to express correctly and thoroughly in a language like TypeScript, but was pretty easy to express in Haskell’s Hindley Milner types with support for higher kinded types (types of types).

Most type systems have been too restrictive to allow for free expression of dynamic and functional ideas, such as function composition, free object composition, runtime object extension, combinators, lenses, etc. In other words, static types frequently make it harder to write composable software.

If your type system is too restrictive (e.g., TypeScript, Java), you’re forced to write more convoluted code to accomplish the same goals. That doesn’t mean static types are a bad idea, or that all static type implementations are equally restrictive. I have encountered far fewer problems with Haskell’s type system.

If you’re a fan of static types and you don’t mind the restrictions, more power to you, but if you find some of the advice in this text difficult because it’s hard to type composed functions and composite algebraic structures, blame the type system, not the ideas. People love the comfort of their SUVs, but nobody complains that they don’t let you fly. For that, you need a vehicle with more degrees of freedom.

If restrictions make your code simpler, great! But if restrictions force you to write more complicated code, perhaps the restrictions are wrong.

### What is an Object?

Objects have clearly taken on a lot of connotations over the years. What we call “objects” in JavaScript are simply composite data types, with none of the implications from either class-based programming or Alan Kay’s message-passing.

In JavaScript, those objects can and frequently do support encapsulation, message passing, behavior sharing via methods, even subclass polymorphism (albeit using a delegation chain rather than type-based dispatch). You can assign any function to any property. You can build object behaviors dynamically, and change the meaning of an object at runtime. JavaScript also supports encapsulation using closures for implementation privacy. But all of that is opt-in behavior.

Our current idea of an object is simply a composite data structure, and does not require anything more to be considered an object. But programming using these kinds of objects does not make your code “object-oriented” any more than programming with functions makes your code “functional”.

#### OOP is not Real OOP Anymore

Because “object” in modern programming languages means much less than it did to Alan Kay, I’m using “component” instead of “object” to describe the rules of _real OOP._ Many _objects_ are owned and manipulated directly by other code in JavaScript, but **components** should encapsulate and control their own state.

Real OOP means:

*   Programming with **components** (Alan Kay’s “object”)
*   Component state must be encapsulated
*   Using message passing for inter-object communication
*   Components can be added/changed/replaced at runtime

Most component behaviors can be specified generically using algebraic data structures. Inheritance is not needed here. Components can reuse behaviors from shared functions and modular imports without sharing their data.

Manipulating _objects_ or using _class inheritance_ in JavaScript does not mean that you’re “doing OOP”. Using components in this way _does._ But popular usage is how words get defined, so perhaps we should abandon OOP and call this “Message Oriented Programming (MOP)” instead of “Object Oriented Programming (OOP)”?

Is it coincidence that mops are used to clean up messes?

### What Good MOP Looks Like

In most modern software, there is some UI responsible for managing user interactions, some code managing application state (user data), and code managing system or network I/O.

Each of those systems may require long-lived processes, such as event listeners, state to keep track of things like the network connection, ui element status, and the application state itself.

Good MOP means that instead of all of these systems reaching out and directly manipulating each other’s state, the system communicates with other components via message dispatch. When the user clicks on a save button, a `"SAVE"` message might get dispatched, which an application state component might interpret and relay to a state update handler (such as a pure reducer function). Perhaps after the state has been updated, the state component might dispatch a `"STATE_UPDATED"` message to a UI component, which in turn will interpret the state, reconcile what parts of the UI need to be updated, and relay the updated state to the subcomponents that handle those parts of the UI.

Meanwhile, the network connection component might be monitoring the user’s connection to another machine on the network, listening for messages, and dispatching updated state representations to save data on a remote machine. It’s internally keeping track of a network heartbeat timer, whether the connection is currently online or offline, and so on.

These systems don’t need to know about the details of the other parts of the system. Only about their individual, modular concerns. The system components are decomposable and recomposable. They implement standardized interfaces so that they are able to interoperate. As long as the interface is satisfied, you could substitute replacements which may do the same thing in different ways, or completely different things with the same messages. You may even do so at runtime, and everything would keep working properly.

Components of the same software system may not even need to be located on the same machine. The system could be decentralized. The network storage might shard the data across a decentralized storage system like [IPFS](https://en.wikipedia.org/wiki/InterPlanetary_File_System), so that the user is not reliant on the health of any particular machine to ensure their data is safely backed up, and safe from hackers who might want to steal it.

OOP was partially inspired by Arpanet, and one of the goals of Arpanet was to build a decentralized network that could be resilient to attacks like atomic bombs. According to director of DARPA during Arpanet development, Stephen J. Lukasik ([“Why the Arpanet Was Built”](https://ieeexplore.ieee.org/document/5432117)):

> “The goal was to exploit new computer technologies to meet the needs of military command and control against nuclear threats, achieve survivable control of US nuclear forces, and improve military tactical and management decision making.”

**_Note:_** _The primary impetus of Arpanet was convenience rather than nuclear threat, and its obvious defense advantages emerged later. ARPA was using three separate computer terminals to communicate with three separate computer research projects. Bob Taylor wanted a single computer network to connect each project with the others._

A good MOP system might share the internet’s robustness using components that are hot-swappable while the application is running. It could continue to work if the user is on a cell phone and they go offline because they entered a tunnel. It could continue to function if a hurricane knocks out the power to one of the data centers where servers are located.

It’s time for the software world to let go of the failed class inheritance experiment, and embrace the math and science principles that originally defined the spirit of OOP.

It’s time for us to start building more flexible, more resilient, better-composed software, with MOP and functional programming working in harmony.

> Note: The MOP acronym is already used to describe “monitoring-oriented programming” and its unlikely OOP is going to go away quietly.

> Don’t be upset if MOP doesn’t catch on as programming lingo.  
> Do MOP up your OOPs.

### Learn More at EricElliottJS.com

Video lessons on functional programming are available for members of EricElliottJS.com. If you’re not a member, [sign up today](https://ericelliottjs.com/).

* * *

**_Eric Elliott_** _is the author of_ [_“Programming JavaScript Applications”_](http://pjabook.com) _(O’Reilly), and cofounder of the software mentorship platform,_ [_DevAnywhere.io_](https://devanywhere.io/)_. He has contributed to software experiences for_ **_Adobe Systems_**_,_ **_Zumba Fitness_**_,_ **_The Wall Street Journal_**_,_ **_ESPN_**_,_ **_BBC_**_, and top recording artists including_ **_Usher_**_,_ **_Frank Ocean_**_,_ **_Met_**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
