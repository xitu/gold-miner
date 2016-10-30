> * 原文地址：[So You Want to be a Functional Programmer (Part 5)](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-5-c70adc9cf56a#.ewys56rfy)
* 原文作者：[Charles Scalfani](https://medium.com/@cscalfani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# So You Want to be a Functional Programmer (Part 5)


Taking that first step to understanding Functional Programming concepts is the most important and sometimes the most difficult step. But it doesn’t have to be. Not with the right perspective.

Previous parts: [Part 1](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-1-1f15e387e536), [Part 2](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-2-7005682cec4a), [Part 3](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-3-1b0fd14eb1a7), [Part 4](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-4-18fbe3ea9e49)

#### Referential Transparency









![](https://cdn-images-1.medium.com/max/1600/1*4QRVgRMKN2che7VG8H5FxA.png)





**_Referential Transparency_** is a fancy term to describe that a pure function can safely be replaced by its expression. An example will help illustrate this.

In Algebra when you had the following formula:

    y = x + 10

And were told:

    x = 3

You could substituted **_x_** back into the equation to get:

    y = 3 + 10

Notice that the equation is still valid. We can do the same kind of substitution with pure functions.

Here’s a function in Elm that puts single quotes around the supplied string:

    quote str =
        "'" ++ str ++ "'"

And here’s some code that uses it:

    findError key =
        "Unable to find " ++ (quote key)

Here **_findError_** builds an error message when a search for **_key_** is unsuccessful.

Since the **_quote_** function is pure, we can simply replace the function call in **_findError_** with the body of the **_quote_** function (which is just an expression):

    findError key =
       "Unable to find " ++ ("'" ++ str ++ "'")

This is what I call **_Reverse Refactoring_** (which makes more sense to me), a process that can be used by programmers or programs (e.g. compilers and test programs) to reason about code.

This can be especially helpful when reasoning about recursive functions.

#### Execution Order









![](https://cdn-images-1.medium.com/max/1600/1*k8zgyx2Mhlg6F82aSR9U4A.png)





Most programs are single-threaded, i.e. one and only one piece of code is being executed at a time. Even if you have a multithreaded program, most of the threads are blocked waiting for I/O to complete, e.g. file, network, etc.

This is one reason why we naturally think in terms of ordered steps when we write code:

    1\. Get out the bread
    2\. Put 2 slices into the toaster
    3\. Select darkness
    4\. Push down the lever
    5\. Wait for toast to pop up
    6\. Remove toast
    7\. Get out the butter
    8\. Get a butter knife
    9\. Butter toast

In this example, there are two independent operations: getting butter and toasting bread. They only become interdependent at step 9.

We could do steps 7 and 8 concurrently with steps 1 through 6 since they are independent from one another.

But the minute we do this, things get complicated:

    Thread 1
    --------
    1\. Get out the bread
    2\. Put 2 slices into the toaster
    3\. Select darkness
    4\. Push down the lever
    5\. Wait for toast to pop up
    6\. Remove toast

    Thread 2
    --------
    1\. Get out the butter
    2\. Get a butter knife
    3\. Wait for Thread 1 to complete
    4\. Butter toast

What happens to Thread 2 if Thread 1 fails? What is the mechanism to coordinate both threads? Who owns the toast: Thread 1, Thread 2 or both?

It’s easier to not think about these complexities and leave our program single threaded.

But when it’s worth squeezing out every possible efficiency of our program, then we must take on the monumental effort to write multithreading software.

However, there are 2 main problems with multithreading. First, multithreaded programs are difficult to write, read, reason about, test and debug.

Second, some languages, e.g. Javascript, don’t support multithreading and those that do, support it badly.

But what if order didn’t matter and everything was executed in parallel?

While this sounds crazy, it’s not as chaotic as it sounds. Let’s look at some Elm code to illustrate this:

    buildMessage message value =
        let
            upperMessage =
                String.toUpper message

            quotedValue =
                "'" ++ value "'"

        in
            upperMessage ++ ": " ++ value

Here **_buildMessage_** takes **_message_** and **_value_** then produces an uppercased **_message,_ **a colon and **_value_** in single quotes.

Notice how **_upperMessage_** and **_quotedValue_** are independent. How do we know this?

There are 2 things that must be true for independence. First, they must be pure functions. This is important because they must not be affected by the execution of the other.

If they were not pure, then we could never know that they’re independent. In that case, we’d have to rely on the order that they were called in the program to determine their execution order. This is how all Imperative Languages work.

The second thing that must be true for independence is that the output of one function is not used as the input of the other. If this was the case, then we’d have to wait for one to finish before starting the second.

In this case, **_upperMessage_** and **_quotedValue_** are both pure and neither requires the output of the other.

Therefore, these 2 functions can be executed in ANY ORDER.

The compiler can make this determination without any help from the programmer. This is only possible in a Pure Functional Language because it’s very difficult, if not impossible, to determine the ramifications of side-effects.

> The order of execution in a Pure Functional Language can be determined by the compiler.

This is extremely advantageous considering that CPUs are not getting faster. Instead, manufactures are adding more and more cores. This means that code can execute in parallel at the hardware level.

Unfortunately, with Imperative Languages, we cannot take full advantage of these cores except at a very coarse level. But to do so requires drastically changing the architecture of our programs.

With Pure Functional Languages, we have the potential to take advantage of the CPU cores at a fine grained level automatically without changing a single line of code.

#### Type Annotations









![](https://cdn-images-1.medium.com/max/1600/1*btL9u2b5VZwivpqNbfoVmw.png)





In Statically Typed Languages, types are defined inline. Here’s some Java code to illustrate:

    public static String quote(String str) {
        return "'" + str + "'";
    }

Notice how the typing is inline with the function definition. It gets even worse when you have generics:

    private final Map getPerson(Map people, Integer personId) {
       // ...
    }

I’ve bolded the types which makes them stand out but they still interfere with the function definition. You have to read it carefully to find the names of the variables.

With Dynamically Typed Languages, this is not a problem. In Javascript, we can write code like:

    var getPerson = function(people, personId) {
        // ...
    };

This is so much easier to read without all of that nasty type information getting in the way. The only problem is that we give up the safety of typing. We could easily pass in these parameters backwards, i.e. a _Number_ for **_people_** and an _Object_ for **_personId_**.

We wouldn’t find out until the program executed, which could be months after we put it into production. This would not be the case in Java since it wouldn’t compile.

But what if we could have the best of both worlds. The syntactical simplicity of Javascript with the safety of Java.

It turns out that we can. Here’s a function in Elm with Type Annotations:

    add : Int -> Int -> Int
    add x y =
        x + y

Notice how the type information is on a separate line. This separation makes a world of difference.

Now you may think that the type annotation has a typo. I know I did when I first saw it. I thought that the first **_->_** should be a comma. But there’s no typo.

When you see it with the implied parentheses it makes a bit more sense:

    add : Int -> (Int -> Int)

This says that **_add_** is a function that takes a _single_ parameter of type **_Int_** and returns a function that takes a _single_ parameter **_Int_** and returns an **_Int_**.

Here’s another type annotation with the implied parentheses shown:

    doSomething : String -> (Int -> (String -> String))
    doSomething prefix value suffix =
        prefix ++ (toString value) ++ suffix

This says that **_doSomething_** is a function that takes a _single_ parameter of type **_String_** and returns a function that takes a _single_ parameter of type **_Int_**and returns a function that takes a single parameter of type **_String_** and returns a **_String_**.

Notice how everything takes a _single_ parameter. That’s because every function is curried in Elm.

Since parentheses are always implied to the right, they are not necessary. So we can simply write:

    doSomething : String -> Int -> String -> String

Parentheses are necessary when we pass functions as parameters. Without them, the type annotation would be ambiguous. For example:

    takes2Params : Int -> Int -> String
    takes2Params num1 num2 =
        -- do something

is very different from:

    takes1Param : (Int -> Int) -> String
    takes1Param f =
        -- do something

**_takes2Param_** is a function that requires 2 parameters, an **_Int_** and another **_Int_**. Whereas, **_takes1Param_** requires 1 parameters a function that takes an **_Int_** and another **_Int_**.

Here’s the type annotation for **_map_**:

    map : (a -> b) -> List a -> List b
    map f list =
        // ...

Here parentheses are required because **_f_** is of type **_(a -> b)_**, i.e. a function that takes a single parameter of type **_a_** and returns something of type **_b_**.

Here type **_a_** is any type. When a type is uppercased, it’s an explicit type, e.g. **_String_**. When a type is lowercased, it can be any type. Here **_a_** can be **_String_**but it could also be **_Int_**.

If you see **_(a -> a)_** then that says that the input type and the output type MUST be the same. It doesn’t matter what they are but they must match.

But in the case of **_map_**, we have **_(a -> b)_**. That means that it CAN return a different type but it COULD also return the same type.

But once the type for **_a_** is determined, **_a_** must be that type for the whole signature. For example, if **_a_** is **_Int_** and **_b_** is **_String_** then the signature is equivalent to:

    (Int -> String) -> List Int -> List String

Here all of the **_a_**’s have been replaced with **_Int_** and all of the **_b_**’s have been replaced with **_String_**.

The **_List Int_** type means that a list contains **_Int_**s and **_List String_** means that a list contains **_String_**s. If you’ve used generics in Java or other languages then this concept should be familiar.

#### My Brain!!!!









![](https://cdn-images-1.medium.com/max/1600/1*IK5485-iZaHeZRfP8aWmYg.png)





Enough for now.

In the final part of this article, I’ll talk about how you can use what you’ve learned in your day-to-day job, i.e. Functional Javascript and Elm.

Up Next: [Part 6](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-6-db502830403)

_If you liked this, click the![💚](https://linmi.cc/wp-content/themes/bokeh/images/emoji/1f49a.png) below so other people will see this here on Medium._

If you want to join a community of web developers learning and helping each other to develop web apps using Functional Programming in Elm please check out my Facebook Group, **_Learn Elm Programming_**[https://www.facebook.com/groups/learnelm/](https://www.facebook.com/groups/learnelm/)

