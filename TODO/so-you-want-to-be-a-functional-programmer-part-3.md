> * 原文地址：[So You Want to be a Functional Programmer (Part 3)](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-3-1b0fd14eb1a7#.7e7fhqghb)
* 原文作者：[Charles Scalfani](https://medium.com/@cscalfani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# So You Want to be a Functional Programmer (Part 3)
Taking that first step to understanding Functional Programming concepts is the most important and sometimes the most difficult step. But it doesn’t have to be. Not with the right perspective.

Previous parts: [Part 1](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-1-1f15e387e536), [Part 2](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-2-7005682cec4a)

#### Function Composition









![](https://cdn-images-1.medium.com/max/1600/1*yGnDGRW4pTgmcDUi4oC8Uw.png)





As programmers, we are lazy. We don’t want to build, test and deploy code that we’ve written over and over and over again.

We’re always trying to figure out ways of doing the work once and how we can reuse it to do something else.

Code reuse sounds great but is difficult to achieve. Make the code too specific and you can’t reuse it. Make it too general and it can be too difficult to use in the first place.

So what we need is a balance between the two, a way to make smaller, reusable pieces that we can use as building blocks to construct more complex functionality.

In Functional Programming, functions are our building blocks. We write them to do very specific tasks and then we put them together like Lego™ blocks.

This is called **_Function Composition_**.

So how does it work? Let’s start with two Javascript functions:

    var add10 = function(value) {
        return value + 10;
    };
    var mult5 = function(value) {
        return value * 5;
    };

This is too verbose so let’s rewrite it using [**_fat arrow_**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) notation:

    var add10 = value => value + 10;
    var mult5 = value => value * 5;

That’s better. Now let’s imagine that we also want to have a function that takes a value and adds 10 to it and then multiplies the result by 5\. We _could_write:

    var mult5AfterAdd10 = value => 5 * (value + 10)

Even though this is a very simple example, we still don’t want to have to write this function from scratch. First, we could make a mistake like forget the parentheses.

Second, we already have a function that adds 10 and another that multiplies by 5\. We’re writing code that we’ve already written.

So instead, let’s use **_add10_** and **_mult5_** to build our new function:

    var mult5AfterAdd10 = value => mult5(add10(value));

We just used existing functions to create **_mult5AfterAdd10_**, but there’s a better way.

In math, **_f ∘ g_** is functional composition and is read **_“f composed with g”_** or, more commonly, **_“f after g”_**. So **_(f ∘ g)(x)_** is equivalent to calling **_f_** after calling **_g_** with **_x_** or simply, **_f(g(x))_**.

In our example, we have **_mult5 ∘ add10_** or **_“mult5 after add10”_**, hence the name of our function, **_mult5AfterAdd10_**.

And that’s exactly what we did. We called **_mult5_** after we called **_add10_** with **_value_** or simply, **_mult5(add10(value))_**.

Since Javascript doesn’t do Function Composition natively, let’s look at Elm:

    add10 value =
        value + 10

    mult5 value =
        value * 5

    mult5AfterAdd10 value =
        (mult5 << add10) value

The **_<<_** infixed operator is how you _compose_ functions in Elm. It gives us a visual sense of how the data is flowing. First, **_value_** is passed to **_add10_** then its results are passed to **_mult5_**.

Note the parentheses in **_mult5AfterAdd10_**, i.e. **_(mult5 << add10)_**. They are there to make sure that the functions are composed first before applying **_value_**.

You can compose as many functions as you like this way:

    f x =
       (g << h << s << r << t) x

Here **_x_** is passed to function **_t_** whose result is passed to **_r_** whose result is passed to **_s_** and so on. If you did something similar in Javascript it would look like **_g(h(s(r(t(x)))))_**, a parenthetical nightmare

#### Point-Free Notation









![](https://cdn-images-1.medium.com/max/1600/1*g2pWcQJ0jOUf1WKbTDIktQ.png)





There is a style of writing functions without having to specify the parameters called **_Point-Free Notation_**. At first, this style will seem odd but as you continue, you’ll grow to appreciate the brevity.

In **_mult5AfterAdd10_**, you’ll notice that **_value_** is specified twice. Once in the parameter list and once when it’s used.

    -- This is a function that expects 1 parameter

    mult5AfterAdd10 value =
        (mult5 << add10) value

But this parameter is unnecessary since **_add10,_ **the rightmost function in the composition, expects the same parameter. The following point-free version is equivalent:

    -- This is also a function that expects 1 parameter

    mult5AfterAdd10 =
        (mult5 << add10)

There are many benefits from using the point-free version.

First, we don’t have to specify redundant parameters. And since we don’t have to specify them, we don’t have to think up names for all of them.

Second, it’s easier to read and reason about since it’s less verbose. This example is simple, but imagine a function that took more parameters.

#### Trouble in Paradise









![](https://cdn-images-1.medium.com/max/1600/1*RE3Qxh6Bg9umzQ5dOrF6pw.png)





So far we’ve seen how Function Composition works and how we should specify our functions in Point-Free Notation for brevity, clarity and flexibility.

Now, let’s try to use these ideas in a slightly different scenario and see how they fare. Imagine we replace **_add10_** with **_add_**:

    add x y =
        x + y

    mult5 value =
        value * 5

How do we write **_mult5After10_** with just these 2 functions?

Think about it for a bit before reading on. No seriously. Think about. Try and do it.

Okay, so if you actually spent time thinking about it, you may have come up with a solution like:

    -- This is wrong !!!!

    mult5AfterAdd10 =
        (mult5 << add) 10

But this wouldn’t work. Why? Because **_add_** takes 2 parameters.

If this isn’t obvious in Elm, try to write this in Javascript:

    var mult5AfterAdd10 = mult5(add(10)); // this doesn't work

This code is wrong but why?

Because the **_add_** function is only getting 1 of its 2 parameters here then its _incorrect results_ are passed to **_mult5_**. This will produce the wrong results.

In fact, in Elm, the compiler won’t even let you write such mis-formed code (which is one of the great things about Elm).

Let’s try again:

    var mult5AfterAdd10 = y => mult5(add(10, y)); // not point-free

This isn’t point-free but I could probably live with this. But now I’m no longer just combining functions. I’m writing a new function. Also, if this gets more complicated, e.g. if I want to compose **_mult5AfterAdd10_** with something else, I’m going to get into real trouble.

So it would appear that Function Composition has limited usefulness since we cannot marry these two functions. That’s too bad since it’s so powerful.

How could we solve this? What would we need to make this problem go away?

Well, what would be really great is if we had some way of giving our **_add_**function only one of its parameters _ahead of time_ and then it would get its second parameter _later_ when **_mult5AfterAdd10_** is called.

Turns out there is way and it’s called **_Currying_**.

#### My Brain!!!!









![](https://cdn-images-1.medium.com/max/1600/1*IK5485-iZaHeZRfP8aWmYg.png)





Enough for now.

In subsequent parts of this article, I’ll talk about Currying, common functional functions (e.g map, filter, fold etc.), Referential Transparency, and more.

Up next: [Part 4](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-4-18fbe3ea9e49)