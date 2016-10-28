> * 原文地址：[So You Want to be a Functional Programmer (Part 4)](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-4-18fbe3ea9e49#.1p212lwov)
* 原文作者：[Charles Scalfani](https://medium.com/@cscalfani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# So You Want to be a Functional Programmer (Part 4)


Taking that first step to understanding Functional Programming concepts is the most important and sometimes the most difficult step. But it doesn’t have to be. Not with the right perspective.

Previous parts: [Part 1](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-1-1f15e387e536), [Part 2](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-2-7005682cec4a), [Part 3](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-3-1b0fd14eb1a7)

#### Currying









![](https://cdn-images-1.medium.com/max/1600/1*zihd0We3yAkjAxleLPL2aA.png)





If you remember from [Part 3](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-3-1b0fd14eb1a7), the reason that we were having problems composing **_mult5_** and **_add_** (in ) is because **_mult5_** takes 1 parameter and **_add_**takes 2.

We can solve this easily by just restricting all functions to take only 1 parameter.

Trust me. It’s not as bad as it sounds.

We simply write an add function that uses 2 parameters but only takes 1 parameter at a time. **_Curried_** functions allow us to do this.

> A Curried Function is a function that only takes a single parameter at a time.

This will let us give **_add_** its first parameter before we compose it with **_mult5_**. Then when **_mult5AfterAdd10_** is called, **_add_** will get its second parameter.

In Javascript, we can accomplish this by rewriting **_add_**:

    var add = x => y => x + y

This version of **_add_** is a function that takes one parameter now and then another one later.

In detail, the **_add_** function takes a single parameter, **_x_**, and returns a **_function_** that takes a single parameter, **_y_**, which will ultimately return the **_result of adding x and y_**.

Now we can use this version of **_add_** to build a working version of **_mult5AfterAdd10_**:

    var compose = (f, g) => x => f(g(x));
    var mult5AfterAdd10 = compose(mult5, add(10));

The compose function takes 2 parameters, **_f_** and **_g_**. Then it returns a function that takes 1 parameter, **_x_**, which when called will apply **_f after g_** to **_x_**.

So what did we do exactly? Well, we converted our plain old **_add_** function into a curried version. This made **_add_** more flexible since the first parameter, 10, can be passed to it up front and the final parameter will be passed when **_mult5AfterAdd10_** is called.

At this point, you may be wondering how to rewrite the add function in Elm. Turns out, you don’t have to. In Elm and other Functional Languages, all functions are curried automatically.

So the **_add_** function looks the same:

    add x y =
        x + y

This is how **_mult5AfterAdd10_** should have been written back in [Part 3](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-3-1b0fd14eb1a7):

    mult5AfterAdd10 =
        (mult5 << add 10)

Syntactically speaking, Elm beats Imperative Languages like Javascript because it’s been optimized for Functional things like currying and composition.

#### Currying and Refactoring









![](https://cdn-images-1.medium.com/max/1600/1*kbFszF2qDVeeN591mpq8Ug.png)





Another time currying shines is during refactoring when you create a generalized version of a function with lots of parameters and then use it to create specialized versions with fewer parameters.

For example, when we have the following functions that put brackets and double brackets around strings:

    bracket str =
        "{" ++ str ++ "}"

    doubleBracket str =
        "{{" ++ str ++ "}}"

Here’s how we’d use it:

    bracketedJoe =
        bracket "Joe"

    doubleBracketedJoe =
        doubleBracket "Joe"

We can generalize **_bracket_** and **_doubleBracket_**:

    generalBracket prefix str suffix =
        prefix ++ str ++ suffix

But now every time we use **_generalBracket_** we have to pass in the brackets:

    bracketedJoe =
        generalBracket "{" "Joe" "}"

    doubleBracketedJoe =
        generalBracket "{{" "Joe" "}}"

What we really want is the best of both worlds.

If we reorder the parameters of **_generalBracket_**, we can create **_bracket_** and **_doubleBracket_** by leveraging the fact that functions are curried:

    generalBracket prefix suffix str =
        prefix ++ str ++ suffix

    bracket =
        generalBracket "{" "}"

    doubleBracket =
        generalBracket "{{" "}}"

Notice that by putting the parameters that were most likely to be static first, i.e. **_prefix_** and **_suffix,_** and putting the parameters that were most likely to change last, i.e. **_str_**, we can easily create specialized versions of **_generalBracket_**.

> Parameter order is important to fully leverage currying.

Also, notice that **_bracket_** and **_doubleBracket_** are written in point-free notation, i.e. the **_str_** parameter is implied. Both **_bracket_** and **_doubleBracket_**are functions waiting for their final parameter.

Now we can use it just like before:

    bracketedJoe =
        bracket "Joe"

    doubleBracketedJoe =
        doubleBracket "Joe"

But this time we’re using a generalized curried function, **_generalBracket_**.

#### Common Functional Functions









![](https://cdn-images-1.medium.com/max/1600/1*I7nCgMOzuVxKPj_amfQxNw.png)





Let’s look at 3 common functions that are used in Functional Languages.

But first, let’s look at the following Javascript code:

    for (var i = 0; i < something.length; ++i) {
        // do stuff
    }

There’s one major thing wrong with this code. It’s not a bug. The problem is that this code is boilerplate code, i.e. code that is written over and over again.

If you code in Imperative Languages like Java, C#, Javascript, PHP, Python, etc., you’ll find yourself writing this boilerplate code more than any other.

That’s what’s wrong with it.

So let’s kill it. Let’s put it in a function (or a couple of functions) and never write a for-loop again. Well, almost never; at least until we move to a Functional Language.

Let’s start with modifying an array called **_things_**:

    var things = [1, 2, 3, 4];
    for (var i = 0; i < things.length; ++i) {
        things[i] = things[i] * 10; // MUTATION ALERT !!!!
    }
    console.log(things); // [10, 20, 30, 40]

UGH!! Mutability!

Let’s try that again. This time we won’t mutate **_things_**:

    var things = [1, 2, 3, 4];
    var newThings = [];

    for (var i = 0; i < things.length; ++i) {
        newThings[i] = things[i] * 10;
    }
    console.log(newThings); // [10, 20, 30, 40]

Okay, so we didn’t mutate **_things_** but technically we mutated **_newThings_**. For now, we’re going to overlook this. We are in Javascript after all. Once we move to a Functional Language, we won’t be able to mutate.

The point here is to understand how these functions work and help us to reduce noise in our code.

Let’s take this code and put it in a function. We’re going to call our first common function **_map_** since it maps each value in the old array to new values in the new array:

    var map = (f, array) => {
        var newArray = [];

        for (var i = 0; i < array.length; ++i) {
            newArray[i] = f(array[i]);
        }
        return newArray;
    };

Notice the function, **_f_**, is passed in so that our **_map_** function can do anything we want to each item of the **_array_**.

Now we can call rewrite our previous code to use **_map_**:

    var things = [1, 2, 3, 4];
    var newThings = map(v => v * 10, things);

Look ma. No for-loops. And much easier to read and therefore reason about.

Well, technically, there are for-loops in the **_map_** function. But at least we don’t have to write that boilerplate code anymore.

Now let’s write another common function to **_filter_** things from an array:

    var filter = (pred, array) => {
        var newArray = [];

    for (var i = 0; i  x % 2 !== 0;
    var numbers = [1, 2, 3, 4, 5];
    var oddNumbers = filter(isOdd, numbers);
    console.log(oddNumbers); // [1, 3, 5]

Using our new **_filter_** function is so much simpler than hand-coding it with a for-loop.

The final common function is called **_reduce_**. Typically, it’s used to take a list and reduce it to a single value but it can actually do so much more.

This function is usually called **_fold_** in Functional Languages.

    var reduce = (f, start, array) => {
        var acc = start;
        for (var i = 0; i < array.length; ++i)
            acc = f(array[i], acc); // f() takes 2 parameters
        return acc;
    });

The **_reduce_** function takes a reduction function, **_f_**, an initial **_start_** value and an **_array_**.

Notice that the reduction function, **_f_**, takes 2 parameters, the current item of the **_array_**, and the accumulator, **_acc_**. It will use these parameters to produce a new accumulator each iteration. The accumulator from the final iteration is returned.

An example will help us understand how it works:

    var add = (x, y) => x + y;
    var values = [1, 2, 3, 4, 5];
    var sumOfValues = reduce(add, 0, values);
    console.log(sumOfValues); // 15

Notice that the **_add_** function takes 2 parameters and adds them. Our **_reduce_**function expects a function that takes 2 parameters so they work well together.

We start with a **_start_** value of zero and pass in our array, **_values_**, to be summed. Inside the **_reduce_** function, the sum is accumulated as it iterates over **_values_**. The final accumulated value is returned as **_sumOfValues_**.

Each of these functions, **_map_**, **_filter_** and **_reduce_** let us do common manipulation operations on arrays without having to write boilerplate for-loops.

But in Functional Languages, they are even more useful since there are no loop constructs just recursion. Iteration functions aren’t just extremely helpful. They’re necessary.

#### My Brain!!!!









![](https://cdn-images-1.medium.com/max/1600/1*IK5485-iZaHeZRfP8aWmYg.png)





Enough for now.

In subsequent parts of this article, I’ll talk about Referential Integrity, Execution Order, Types, and more.

Up Next: [Part 5](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-5-c70adc9cf56a)

_If you liked this, click the![💚](https://linmi.cc/wp-content/themes/bokeh/images/emoji/1f49a.png) below so other people will see this here on Medium._

If you want to join a community of web developers learning and helping each other to develop web apps using Functional Programming in Elm please check out my Facebook Group, **_Learn Elm Programming_**[https://www.facebook.com/groups/learnelm/](https://www.facebook.com/groups/learnelm/)

