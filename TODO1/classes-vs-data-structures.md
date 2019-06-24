> * 原文地址：[Classes vs. Data Structures](http://blog.cleancoder.com/uncle-bob/2019/06/16/ObjectsAndDataStructures.html)
> * 原文作者：[Robert C. Martin](http://blog.cleancoder.com/uncle-bob/2019/06/16/ObjectsAndDataStructures.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/classes-vs-data-structures.md](https://github.com/xitu/gold-miner/blob/master/TODO1/classes-vs-data-structures.md)
> * 译者：
> * 校对者：

# Classes vs. Data Structures

> **What is a class?**

A class is the specification of a set of similar objects.

> **What is an object?**

An object is a set of functions that operate upon encapsulated data elements.

> **Or rather, an object is a set of functions that operate on** implied **data elements.**

What do you mean by **implied** data elements”?

> **The functions of an object imply the existence of some data elements; but that data is not directly accessible or visible outside of the object.**

Isn’t the data inside the object?

> **It could be; but there’s no rule that says it must be. From the point of view of the user, an object is nothing more than a set of functions. The data that those functions operate upon must exist, but the location of that data is unknown to the user.**

Hmmm. OK, I’ll buy that for the moment.

> **Good. Now, what is a data structure?**

A data structure is a cohesive set of data elements.

> **Or, in other words, a data structure is a set of data elements operated upon by implied functions.**

OK, OK. I get it. The functions that operate on the data structure are not specified by the data structure but the existence of the data structure implies that some operations must exist.

> **Right. Now what do you notice about those two definitions?**

They are sort of the opposite of each other.

> **Indeed. They are complements of each other. They fit together like a hand in a glove.**

> * **An Object is a set of functions that operate upon implied data elements.**
> * **A Data Structure is a set of data elements operated upon by implied functions**

Wow, so objects aren’t data structures.

> **Correct. Objects are the opposite of data structures.**

So a DTO – a Data Transfer Object – is not an object?

> **Correct. DTOs are data structures.**

And so database tables aren’t objects either are they?

> **Correct again. Databases contain data structures, not objects.**

But wait. Doesn’t an ORM – And Object Relational Mapper – map database tables to objects?

> **Of course not. There is no mapping between database tables and objects. Database tables are data structures, not objects.**

So then what do ORMs do?

> **They transfer data between data structures.**

So they don’t have anything to do with Objects?

> **Nothing whatever. There is no such thing as an Object Relational Mapper; because there is no mapping between database tables and objects.**

But I thought ORMs built our business objects for us.

> **No, ORMs extract the data that our business objects operate upon. That data is contained in a data structure loaded by the ORM.**

But then doesn’t the business object contain that data structure?

> **It might. It might not. That’s not the business of the ORM.**

That seems like a minor semantic point.

> **Not at all. The distinction has significant implications.**

Such as?

> **Such as the design of the database schema vs. the design of the business objects. Business objects define the structure of the business** behavior. **Database schemas define the structure of the business data. Those two structures are constrained by very different forces. The structure of the business data is not necessarily the best structure for the business behavior.**

Hmmm. That’s confusing.

> **Think of it this way. The database schema is not tuned for just one application; it must serve the entire enterprise. So the structure of that data is a compromise between many different applications.**

OK, I get that.

> **Good. But now consider each individual application. The Object model of each application describes the way the behavior of those applications are structured. Each application will have a different object model, tuned to that application’s behavior.**

Oh, I see. Since the database schema is a compromise of all the various applications, that schema will not conform to the object model of any particular application.

> **Right! Objects and Data Structures are constrained by very different forces. They seldom line up very nicely. People used to call this the Object/Relational impedance mismatch.**

I’ve heard of that. But I thought that impedance mismatch was solved by ORMs.

> **And now you now differently. There is no impedance mismatch because objects and data structures are complementary, not isomorphic.**

Say what?

> **They are opposites, not similar entities.**

Opposites?

> **Yes, in a very interesting way. You see, objects and data structures imply diametrically opposed control structures.**

Wait, what?

> **Consider a set of object classes that all conform to a common interface. For example, imagine classes that represent two dimensional shapes that all have functions for calculating the `area` and `perimeter` of the shape.**

Why does every software example always involve shapes?

> **Let’s just consider two different types: `Square`s and `Circle`s. It should be clear that the `area` and `permimeter` functions of these two classes operate on different implied data structures. It should also be clear that the way those operations are called is via dynamic polymorphism.**

Wait. Slow down. What?

> **There are two different `area` functions; one for `Square`, the other for `Circle`. When the caller invokes the `area` function on a particular object, it is that object that knows what function to call. We call that dynamic polymorphism.**

OK. Sure. The object knows the implementation of its methods. Sure.

> **Now let’s turn those objects into data structures. We’ll use Discriminated Unions.**

Discoominated whats?

> **Discriminated Unions. In our case that’s just two different data structures. One for `Square` and the other for `Circle`. The `Circle` data structure has a center point, and a radius for data elements. It’s also got a type code that identifies it as a `Circle`.**

You mean like an enum?

> **Sure. The `Square` data structure has the top left point, and the length of the side. It also has the type discriminator – the enum.**

OK. Two data structures with a type code.

> **Right. Now consider the `area` function. Its going to have a switch statement in it, isn’t it?**

Um. Sure, for the two different cases. One for `Square` and the other for `Circle`. And the `perimeter` function will need a similar switch statement

> **Right again. Now think about the structure of those two scenarios. In the object scenarios the two implementations of the `area` function are independent of each other and belong (in some sense of the word) to the type. `Square`’s `area` function belongs to `Square` and `Circle`’s `area` function belongs to `Circle`.**

OK, I see where you are going with this. In the data structure scenario the two implementations of the `area` function are together in the same function, they don’t “belong” (however you mean that word) to the type.

> **It gets better. If you want to add the `Triangle` type to the object scenario, what code must change?**

No code changes. You just create the new `Triangle` class. Oh, I suppose the creator of the instance has to be changed.

> **Right. So when you add a new type, very little changes. Now suppose you want to add a new function - say the `center` function.**

Well then you’d have to add that to all three types, `Circle`, `Square` ,and `Triangle`.

> **Good. So adding new functions is hard, you have to change each class.**

But with data structures it’s different. In order to add `Triangle` you have to change each function to add the `Triangle` case to the switch statements.

> **Right. Adding new types is hard, you have to change each function.**

But when you add the new `center` function, nothing has to change.

> **Yup. Adding new functions is easy.**

Wow. It’s the exact opposite.

> **It certainly is. Let’s review:**

> * **Adding new functions to a set of classes is hard, you have to change each class.**
> * **Adding new functions to a set of data structures is easy, you just add the function, nothing else changes.**
> * **Adding new types to a set of classes is easy, you just add the new class.**
> * **Adding new types to a set of data structures is hard, you have to change each function.**

Yeah. Opposites. Opposites in an interesting way. I mean, if you know that you are going to be adding new functions to a set of types, you’d want to use data structures. But if you know you are going to be adding new types then you want to use classes.

> **Good observation! But there’s one last thing for us to consider today. There’s yet another way in which data structures and classes are opposites. It has to do with dependencies.**

Dependencies?

> **Yes, the direction of the source code dependencies.**

OK, I’ll bite. What’s the difference?

> **Consider the data structure case. Each function has a switch statement that selects the appropriate implementation based upon the type code within the discriminated union.**

OK, that’s true. But so what?

> **Consider a call to the `area` function. The caller depends upon the `area` function, and the `area` function depends upon every specific implementation.**

What do you mean by “depends”?

> **Imagine that each of the implementations of `area` is written into it’s own function. So there’s `circleArea` and `squareArea` and `triangleArea`.**

OK, so the switch statement just calls those functions.

> **Imagine those functions are in different source files.**

Then the source file with the switch statement would have to import, or use, or include, all those source files.

> **Right. That’s a source code dependency. One source file depends upon another source file. What is the direction of that dependency?**

The source file with the switch statement depends upon the source files that contain all the implementations.

> **And what about the caller of the `area` function?**

The caller of the `area` function depends upon the source file with the switch statement which depends upon all the implementations.

> **Correct. All the source file dependencies point in the direction of the call, from the caller to the implementation. So if you make a tiny change to one of those implementations…**

OK, I see where you are going with this. A change to any one of the implementations will cause the source file with the switch statement to be recompiled, which will cause everyone who calls that switch statement – the `area` function in our case – to be recompiled.

> **Right. At least that’s true for language systems that depend upon the dates of source files to figure out which modules should be compiled.**

That’s pretty much all of them that use static typing, right?

> **Yes, and some that don’t.**

That’s a lot of recompiling.

> **And a lot of redeploying.**

OK, but this is reversed in the case of classes?

> **Yes, because the caller of the `area` function depends upon an interface, and the implementation functions also depend upon that interface.**

I see what you mean. The source file of the `Square` class imports, or uses, or includes the source file of the `Shape` interface.

> **Right. The source files of the implementation point in the opposite direction of the call. They point from the implementation to the caller. At least that’s true for statically typed languages. For dynamically typed languages the caller of the `area` function depends upon nothing at all. The linkages get worked out at run time.**

Right. OK. So if you make a change to one of the implementations…

> **Only the changed file needs to be recompiled or redeployed.**

And that’s because the dependencies between the source files point against the direction of the call.

> **Right. We call that Dependency Inversion.**

OK, so let me see if I can wrap this up. Classes and Data Structures are opposites in at least three different ways.

* Classes make functions visible while keeping data implied. Data structures make data visible while keeping functions implied.
* Classes make it easy to add types but hard to add functions. Data structures make it easy to add functions but hard to add types.
* Data Structures expose callers to recompilation and redeployment. Classes isolate callers from recompilation and redeployment.

> **You got it. These are issues that every good software designer and architect needs to keep in mind.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
