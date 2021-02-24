> * 原文地址：[Understanding Rust: ownership, borrowing, lifetimes
](https://medium.com/@bugaevc/understanding-rust-ownership-borrowing-lifetimes-ff9ee9f79a9c)
> * 原文作者：[bugaevc](hhttps://medium.com/@bugaevc)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/understanding-rust-ownership-borrowing-lifetimes.md](understanding-rust-ownership-borrowing-lifetimes.md)
> * 译者：
> * 校对者：

# Understanding Rust: ownership, borrowing, lifetimes
Here’s my take on describing these things. Once you grasp it, it all seems intuitively obvious and beautiful, and you have no idea what part of it you were missing before.

I am not going to teach you from scratch, nor repeat what The Book says (although sometimes I will) — if you haven’t yet, you should read the [corresponding chapters](https://doc.rust-lang.org/book/ownership.html) from it now. This post is meant to complement The Book, not replace it.

I can also recommend you to read [this](http://blog.skylight.io/rust-means-never-having-to-close-a-socket/) excellent article. It actually talks about similar topics, but focuses on other aspects of them.

Let’s talk resources. Resource is something valuable, “heavy”, something that can be acquired and released (or destroyed) — think a socket, an open file, a semaphore, a lock, an area of heap memory. All these things are traditionally created by calling a function that returns some kind of reference to the resource itself — a memory pointer, a file descriptor — that needs to be explicitly closed when the program considers itself done with the resource.

There are problems with this approach. First, it’s all too easy to forget to release some resource, causing what is known as *leak*. Even worse, one might attempt to access a resource that has already been released (use-after-free). If lucky, they would get an error message that will hopefully help them to identify and fix the bug. Otherwise, the reference they have — while invalid as far as the logic goes — might still refer to some “place” which has already been taken by some other resource: memory where something else is already stored, file descriptor some other open file uses. Trying to access the old resource via an invalid reference can corrupt the other resource or completely crash the program.

These issues I’m talking about are not imaginary. They happen all the time. Look, for example, at the [Google Chrome release blog](http://googlechromereleases.blogspot.ru/search/label/Stable%20updates): there are lots of vulnerabilities and crashes getting fixed that were caused by use-after-free — and it costs them a lot of time and work (and money) to identify and fix those.

It’s not that developers are dumb and oblivious. The logic flow itself is error-prone: it *requires* you to release resources, but doesn’t *enforce* it. Furthermore, you do not usually notice that you forgot to release a resource as there rarely is an observable effect.

Sometimes achieving simple goals requires inventing complex solutions, and those bring complicated logic. It’s hard not to get lost in a giant codebase, and it’s not surprising that bugs always pop out here and there. Most of them are easy to spot. These resource-related bugs are however hard to notice, yet very dangerous if they are exploited in the wild.

Of course, a new language like Rust cannot fix your bugs for you. What it can do though — and it perfectly succeeds in it — is influence your way of thinking, bringing some structure into your thoughts, thus making these kinds of errors a lot less likely to appear.

Rust provides you with a safe and clear way to manage your resources. And it doesn’t let you manage them in any other way. This is, well, very restrictive, but this is what we came for.

These restrictions are awesome for several reasons:

- They make you think in the right way. After some Rust experience, you will often find yourself trying to apply the same concepts when developing in other languages, even if they are not built right into the syntax.
- They make your code *safe*. Except for several pretty rare [corner cases](https://doc.rust-lang.org/std/mem/fn.forget.html) all of your “[safe](https://doc.rust-lang.org/nomicon/meet-safe-and-unsafe.html)” Rust code is guaranteed to be free of the bugs we’re talking about.
- Rust feels as pleasurable as high-level languages with garbage collection (*who am I kidding by saying JavaScript is pleasurable?*), yet being as fast and as native as other low-level compiled languages.

With that in mind, let’s look at some goodies Rust has.

# **Ownership**

In Rust, there are very clear rules about which piece of code *owns* a resource. In the simplest case, it’s the block of code that created the object representing the resource. At the end of the block the object is destroyed and the resource is released. The important difference here is that the object is not some kind of a “weak reference” that is easy to “just forget”. While internally the object is just a wrapper for the exact same reference, from the outside it appears to *be* the resource it represents. Dropping it — that is, reaching the end of the code that owns it — automatically and predictably releases the resource. There is no way to “forget to do it” — it is done for you, automatically, in a predictable and fully specified manner.

(At this point you might be asking yourself why I am describing these trivial, obvious things instead of just telling you that smart guys call it [RAII](https://wikiwand.com/en/RAII). Okay, you’re right. Let’s proceed.)

This concept works fine for temporary objects. Say, we need to write some text into a file. The dedicated block of code (say, a function) would open a file — getting a file object (that wraps a file descriptor) as a result — then do some work with it, then at the end of the block the file object would get dropped and the file descriptor closed.

But in many cases this concept doesn’t work. You may want to pass your resource to someone else, share it among several “users” or even between threads.

Let’s go over these. First, you may want to pass the resource to someone else — transfer ownership — so that it’s them who now own the resource, do whatever they want with it and, perhaps more importantly, are responsible for releasing it.

Rust supports this very well — in fact, this is what happens to resources by default when you give them to someone else.

```jsx
fn print_sum(v: Vec<i32>) {
    println!("{}", v[0] + v[1]);
    // v is dropped and deallocated here
}

fn main() {
    let mut v = Vec::new(); // creating the resource
    for i in 1..1000 {
        v.push(i);
    }
    // at this point, v is using
    // no less than 4000 bytes of memory
    // -------------------
    // transfer ownership to print_sum:
    print_sum(v);
    // we no longer own nor anyhow control v
    // it would be a compile-time error to try to access v here
    println!("We're done");
    // no deallocation happening here,
    // because print_sum is responsible for everything
}
```

The process of transferring ownership is also called *moving*, because resource is moved from the old location (say, a local variable) to the new location (a function argument). Performance-wise, it’s only the “weak reference” being moved, so everything is still blazing fast; yet to the code it seems like we actually moved the whole resource to the new place.

Moving is different from *copying*. Under the hood, they both mean copying the data (which in this case would be the “weak reference”, if Rust allowed copying resources), but after a move, the contents of the original variable are considered no longer valid or important. Rust actually pretends the variable is “[logically uninitialized](https://doc.rust-lang.org/nomicon/checked-uninit.html)” — that is, filled with some garbage, like those variables that were just created. It is forbidden to use such variable (unless you re-initialize it with a new value). When it gets dropped, there is no resource deallocation: whoever owns the resource now is responsible for cleaning up when they’re done.

Moving is not limited to passing arguments. You can move to a variable. You can move to the “return value” — or *from* the return value — or from a variable, or a function argument, for that matter. Basically, it’s everywhere where there is an explicit or implicit assignment.

While move semantics can be the perfectly reasonable way to deal with a resource — and I’m going to demonstrate it in a moment — for plain old primitive (numeric) variables they would be a disaster (imagine not being able to copy one `int` value to another!). Fortunately, Rust has the `[Copy` trait](https://doc.rust-lang.org/std/marker/trait.Copy.html). Types that implement it (all the primitive ones do) use copy semantics when assigning, all the other types use move semantics. Pretty straightforward. You can implement `Copy` trait for your own type if you want it to be copied — that’s an opt-in.

```jsx
fn print_sum(a: i32, b: i32) {
    println!("{}", a + b);
    // the copied a and b are dropped and deallocated here
}

fn main() {
    let a = 35;
    let b = 42;
    // copy the values and transfer
    // ownership over the copies to print_sum:
    print_sum(a, b);
    // we still retain full control over
    // the original a and b variables here
    println!("We still have {} and {}", a, b);
    // the original a and b are dropped and deallocated here
}
```

Now, why would move semantics *ever* be useful? It’s all so perfect without them. Well, not quite. Sometimes it’s the most logical thing to do. Consider a function (like [this one](https://doc.rust-lang.org/std/string/struct.String.html#method.with_capacity)) that allocates a string buffer and then returns it to the caller. The ownership is transferred, and the function doesn’t care about the buffer’s fate anymore, whereas the caller gets full control over the buffer, including being responsible for its deallocation.

(It’s the same in C. Functions like `strdup` would allocate memory, hand it to you, and expect *you* to manage and eventually deallocate it. The difference is that it’s just a pointer and the most they can do is ask/remind you to `free()` it when you’re done — and the linked documentation above almost fails to do it — whereas in Rust it’s an unalienable part of the language.)

Another example would be an iterator adapter [like this one](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.count) that *consumes* the iterator it gets, so it would make no sense to access the iterator afterwards anyway.

The opposite question is under which circumstances we would need to have multiple references to the same resource. The most obvious use case is when you’re doing multithreading. Otherwise, if all of your operations are performed sequentially, move semantics might almost always work. Still, it would be very inconvenient to *move* things back and forth all the time.

Sometimes, despite the code being run strictly sequentially, it still *feels* like there are several things happening simultaneously. Imagine iterating over a vector. The iterator could transfer you the ownership over the vector in question *after the loop is done*, but you wouldn't be able to get any access to the vector inside the loop — that is, unless you kick around the ownership between your code and the iterator on the each iteration, which would be a terrible mess. It also seems like there would be no way to traverse a tree without destructuring it onto the stack — and then constructing it back, provided that you want to do something else with it afterwards.

And we wouldn’t be able to do multithreading. And it’s not convenient. Even ugly. Thankfully, there is another cool Rust concept that is going to help us. Enter borrowing!

# **Borrowing**

There are multiple ways to reason about borrowing:

- It allows us to have multiple references to a resource while still adhering to the “single owner, single place of responsibility” concept.
- References are similar to pointers in C.
- A reference is an object too. Mutable references are *moved*, immutable ones are *copied*. When a reference is dropped, the borrow ends (subject to the lifetime rules, see the next section).
- In the simplest case references behave “just like” moving ownership back and forth without doing it explicitly.

Here’s what I mean by the last one:

```jsx
// without borrowing
fn print_sum1(v: Vec<i32>) -> Vec<i32> {
    println!("{}", v[0] + v[1]);
    // returning v as a means of transferring ownership back
    // by the way, there's no need to use "return" if it's the last line
    // because Rust is expression-based
    v
}

// with borrowing, explicit references
fn print_sum2(vr: &Vec<i32>) {
    println!("{}", (*vr)[0] + (*vr)[1]);
    // vr, the reference, is dropped here
    // thus the borrow ends
}

// this is how you should actually do it
fn print_sum3(v: &Vec<i32>) {
    println!("{}", v[0] + v[1]);
    // same as in print_sum2
}

fn main() {
    let mut v = Vec::new(); // creating the resource
    for i in 1..1000 {
        v.push(i);
    }
    // at this point, v is using
    // no less than 4000 bytes of memory

    // transfer ownership to print_sum and get it back after they're done
    v = print_sum1(v);
    // now we again own and control v
    println!("(1) We still have v: {}, {}, ...", v[0], v[1]);
    
    // take a reference to v (borrow it) and pass this reference to print_sum2
    print_sum2(&v);
    // v is still completely ours
    println!("(2) We still have v: {}, {}, ...", v[0], v[1]);
    
    // exacly the same here
    print_sum3(&v);
    println!("(3) We still have v: {}, {}, ...", v[0], v[1]);
    
    // v is dropped and deallocated here
}
```

Let’s see what’s going on here. First, we could get away with always transferring ownership — but we’re already convinced that’s not what we want.

The second one is more interesting. We take a reference to the vector, then pass it to the function. Just like in C, we explicitly dereference it to get to the object behind it. Since there is no complicated lifetime stuff going on, the borrow ends as soon as the reference is dropped. While it otherwise looks just like the first example, there is an important difference. The main function is responsible for the vector all the time — it’s just a bit limited in what it can do to the vector while it’s borrowed. In this example the main function doesn’t have a chance to even observe the vector while it’s borrowed, so it’s not a big deal.

The third function combines the nice parts of the first one (no need to dereference) and the second one (no messing with ownership). It works due to Rust [auto-dereferencing rules](http://stackoverflow.com/questions/28519997/what-are-rusts-exact-auto-dereferencing-rules). Those are a little complicated, but for the most part they allow you to write your code almost as if references were just the objects they point to — thus being similar to C++ references.

Out of the blue, here is another example:

```jsx
// takes v by (immutable) reference
fn count_occurences(v: &Vec<i32>, val: i32) -> usize {
    v.into_iter().filter(|&&x| x == val).count()
}

fn main() {
    let v = vec![2, 9, 3, 1, 3, 2, 5, 5, 2];
    // borrowing v for the iteration
    for &item in &v {
        // the first borrow is still active
        // we borrow it the second time here!
        let res = count_occurences(&v, item);
        println!("{} is repeated {} times", item, res);
    }
}
```

You don’t need to care what is happening inside `count_occurrences` function, suffice it to say that it borrows the vector (again, without moving it). The loop is borrowing the vector too, so we have two borrows being active *at the same time*. After the loop ends, the main function drops the vector.

(I am going to be a bit evil. I mentioned multithreading as a primary reason to have references, yet all the examples I show are single-threaded. If you are really interested, you can get some details on multithreading in Rust [here](https://doc.rust-lang.org/book/concurrency.html) and [here](http://blog.rust-lang.org/2015/04/10/Fearless-Concurrency.html).)

Acquiring and dropping references seems to work as if there was garbage collection involved. This is not the case. Everything is done at compile-time. To accomplish this, Rust needs one more magical concept. Let’s consider this sample code:

```jsx
fn middle_name(full_name: &str) -> &str {
    full_name.split_whitespace().nth(1).unwrap()
}

fn main() {
    let name = String::from("Harry James Potter");
    let res = middle_name(&name);
    assert_eq!(res, "James");
}
```

It works, while this doesn’t:

```jsx
// this does not compile

fn middle_name(full_name: &str) -> &str {
    full_name.split_whitespace().nth(1).unwrap()
}

fn main() {
    let res;
    {
        let name = String::from("Harry James Potter");
        res = middle_name(&name);
    }
    assert_eq!(res, "James");
}
```

First, let me clarify the confusion with [string types](http://doc.rust-lang.org/book/strings.html). A `String` is an owned string buffer, and a `&str` **— a string slice — is a “view” into someone else’s `String`, or into some other memory (it doesn’t really matter here).

To make it even more obvious, let me write something similar in pure C:

(Unrelated note: in C, you cannot have a “view” into a middle of a string, because marking its end would require changing the string, so we’re limited to only finding the last name here.)

```jsx
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

const char *last_name(const char *full_name)
{
    return strrchr(full_name, ' ') + 1;
}

int main() {
    const char *buffer = strcpy(malloc(80), "Harry Potter");
    const char *res = last_name(buffer);
    free(buffer);
    printf("%s\n", res);

    return 0;
}
```

You see it now? The buffer is dropped and deallocated before the result is used. That’s a trivial example of use-after-free. This C code compiles and runs just fine provided that `printf` implementation doesn’t immediately reuse the memory for something else. Still, in a less trivial example it would be a source of crashes, bugs and security vulnerabilities. That’s exactly what we talked about before introducing ownership.

You wouldn’t even be able to compile it in Rust (the Rust code above, I mean). This static analysis machinery is built right into the language and works via *lifetimes*.

# **Lifetimes**

Resources in Rust have lifetimes. They live from the moment they are created to the moment they are dropped. The lifetimes are usually thought of as being *scopes*, or blocks, but that is not actually an accurate representation because a resource can be moved between blocks, as we have already seen. It’s not possible to have a reference to an object that hasn’t yet been created or has already been dropped, and we’ll soon see how this requirement is enforced. Otherwise, it’s all pretty obvious and not really different from the concept of ownership.

So here’s the hard part. References, among other objects, have lifetimes too, and those can be different to the lifetime of the *borrow* they represent (called the *associated lifetime*).

Let me rephrase it. A borrow may last longer than the reference it is controlled by. That is generally because it’s possible to have *another* reference that is dependent on the borrow being active — either borrowing the same object or its part, like a string slice in the example above.

In fact, each reference remembers the lifetime of the borrow it represents — that is, there is a lifetime attached to each and every reference. Like all the “borrow checking”-related things, this is done at compile time and accounts for exactly zero runtime overhead. Unlike other things, you must sometimes specify lifetime details explicitly.

With all of that said, let’s dive right in:

```jsx
fn middle_name<'a>(full_name: &'a str) -> &'a str {
    full_name.split_whitespace().nth(1).unwrap()
}

fn main() {
    let name = String::from("Harry James Potter");
    let res = middle_name(&name);
    assert_eq!(res, "James");
    
    // won't compile:
    
    /*
    let res;
    {
        let name = String::from("Harry James Potter");
        res = middle_name(&name);
    }
    assert_eq!(res, "James");
    */
}
```

We didn’t have to explicitly denote lifetimes in the previous examples because those were trivial enough for the Rust compiler to automatically figure out (see [lifetime elision](https://doc.rust-lang.org/book/lifetimes.html#lifetime-elision) for details). Here we’ve done it anyway in order to demonstrate how they work.

The `<>` thing means that the function is *generic over a lifetime* we call `a`, that is, for any input reference with an associated lifetime it would return another reference with *the same* associated lifetime. (Let me remind you again that an associated lifetime means the lifetime of the borrow, not that of the reference.)

It might not be immediately obvious as to what it means in practice, so let’s look at it the reverse way. The returned reference is being stored in the `res` variable which lives for the whole scope of `main()`. That is the lifetime of the reference, so the borrow (the associated lifetime) lives at least as long. This means that the associated lifetime of the function input argument must have been the same, so we can conclude that `name` must be borrowed for the whole function. And this is exactly what happens.

In the use-after-free example (commented out here) the lifetime of `res` is still the whole function, whereas `name` just “doesn’t live long enough” for the borrow to last the whole function. This is the exact error you would get if you try to compile this code.

So what happens is Rust compiler tries to make the borrow lifetime as short as possible, ideally ending as soon as the reference is dropped (this is “the simplest case” I was talking about at the beginning of the *Borrowing* section). The constraints like “this borrow lives as long as that one” — working in the reverse way, from the lifetime of the result to that of the original borrow — drag the lifetime to be longer and longer. This process stops as soon as all the constraints are satisfied, and if it’s impossible to achieve you’re left with an error.

Oh, and you can’t fool Rust by saying your function returns a borrowed value with a completely unrelated lifetime, because then you would get the same “does not live long enough” error *within the function*, since that unrelated lifetime can be a lot longer than the input one. (OK, I’m lying. Actually, the error would be different, but it’s nice to think it’s the same one.)

Let’s go over this example:

```jsx
fn search<'a, 'b>(needle: &'a str, haystack: &'b str) -> Option<&'b str> {
    // imagine some clever algorithm here
    // that returns a slice of the original string
    let len = needle.len();
    if haystack.chars().nth(0) == needle.chars().nth(0) {
        Some(&haystack[..len])
    } else if haystack.chars().nth(1) == needle.chars().nth(0) {
        Some(&haystack[1..len+1])
    } else {
        None
    }
}

fn main() {
    let haystack = "hello little girl";
    let res;
    {
        let needle = String::from("ello");
        res = search(&needle, haystack);
    }
    match res {
        Some(x) => println!("found {}", x),
        None => println!("nothing found")
    }
    // outputs "found ello"
}
```

The `search` function accepts two references with totally unrelated associated lifetimes. While there is a constraint on the `haystack`, the only thing we require about the `needle` is that the borrow must be valid while the function itself is executed. After it’s done, the borrow immediately ends and we can safely deallocate the associated memory, while still keeping the function result around.

The `haystack` is initialized with a string literal. Those are string slices of type `&’static str` **— a “borrow” that is always “active”. Thus we are able to keep the `res` variable around for as long as we need it. This is an exception to the *borrow lasts as short as it can* rule. You can think of it as of another constraint on the “borrowed string” — the string literal borrow must last for the whole execution time of the program.

Finally, we’re returning not the reference itself, but a compound object to which it is an internal field. This is totally supported and doesn’t influence our lifetime logic.

So in this example, the function accepted two arguments and was generic over two lifetimes. Let’s see what happens if we force the lifetimes to be the same:

```jsx
fn the_longest<'a>(s1: &'a str, s2: &'a str) -> &'a str {
    if s1.len() > s2.len() { s1 } else { s2 }
}

fn main() {
    let s1 = String::from("Python");
    // explicitly borrowing to ensure that
    // the borrow lasts longer than s2 exists
    let s1_b = &s1;
    {
        let s2 = String::from("C");
        let res = the_longest(s1_b, &s2);
        println!("{} is the longest if you judge by name", res);
    }
}
```

I’ve made an explicit borrow outside the inner block so that the borrow has to last for the rest of `main()`. That is clearly not the same lifetime as `&s2`. Why is it OK to call the function if it only accepts two arguments with the *same* associated lifetimes?

Turns out that associated lifetimes are a subject to [type coercion](https://www.wikiwand.com/en/Type_conversion). Unlike in most languages (at least those known to me) primitive (integer) values in Rust *do not coerce* — you have to always cast them explicitly. You can still find coercion in some less obvious places, like these associated lifetimes and [dynamic dispatch with type erasure](http://doc.rust-lang.org/book/trait-objects.html#dynamic-dispatch).

I’m going to bring this piece of C++ code for comparison:

```jsx
struct A {
    int x;
};

struct B: A {
    int y;
};

struct C: B {
    int z;
};

B func(B arg)
{
    return arg;
}

int main() {
    A a;
    B b;
    /* this works fine:
     * a B value is a valid A value
     * to put it another way, you can use a B value
     * whenever an A value is expected
     */
    a = b;
    /* on the other hand,
     * this would be an error:
     */

    // b = a;

    // this works just fine
    C arg;
    A res = func(arg);
    return 0;
}
```

Derived types coerce to their base types. When we’re passing an instance of `C`, it coerces to `B`, only to be returned back, coerced to `A` and then stored in the `res` variable.

Similarly, in Rust longer borrows can coerce to be shorter. It won’t affect the borrow itself, but only make it accepted wherever a shorter borrow is wanted. So you can pass a function a borrow with a longer lifetime than it expects — it will be coerced — and you can coerce the borrow it returns to be even shorter.

Considering this example one more time:

```jsx
fn middle_name<'a>(full_name: &'a str) -> &'a str {
    full_name.split_whitespace().nth(1).unwrap()
}

fn main() {
    let name = String::from("Harry James Potter");
    let res = middle_name(&name);
    assert_eq!(res, "James");
    
    // won't compile:
    
    /*
    let res;
    {
        let name = String::from("Harry James Potter");
        res = middle_name(&name);
    }
    assert_eq!(res, "James");
    */
}
```

One would often wonder whether such function declaration means that the argument’s associated lifetime must be (at least) as long as the return value’s — or vice versa.

The answer should be obvious now. To the function, both lifetimes are exactly the same. But due to coercion, you can pass it a longer borrow and even possibly shorten the associated lifetime of the result after you obtain it. Thus the right answer is — argument must live at least as long as the return value.

And if you create a function that takes several arguments by reference and declare they must be of an equal associated lifetime — like in our previous example — the actual arguments the function will be given would be going to be coerced to the shortest lifetime among them. It simply means that the result can’t outlive *any* of the argument borrows.

This plays nicely with the *reverse constraints* rule we were talking about earlier. The callee does not care — it just gets and returns borrows of the same lifetime. The caller, on the other hand, makes sure that arguments’ associated lifetimes are never shorter than that of the result, achieving it by extending them.

# **Random additional notes**

- You can’t *move out* of a borrowed value, because after the borrow ends the value must stay valid. You can’t move out of it even if you move something back in the very next line. But there is `[mem::replace](https://doc.rust-lang.org/std/mem/fn.replace.html)` that lets you do *both* at the same time.
- If you want an owning pointer — something like `unique_ptr` in C++, there is the `[Box](https://doc.rust-lang.org/std/boxed/index.html)` type.
- If you want some basic reference counting — like `shared_ptr` and `weak_ptr` in C++, there is [this standard module](https://doc.rust-lang.org/std/rc/index.html).
- If you really really need to get around the restrictions Rust puts on you, you can always resort to [unsafe code](https://doc.rust-lang.org/nomicon/meet-safe-and-unsafe.html).

**Thanks to Meredith Summer.**