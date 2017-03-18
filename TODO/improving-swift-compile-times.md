* 原文地址：[Improving Swift compile times](https://medium.com/@johnsundell/improving-swift-compile-times-ee1d52fb9bd#.hfqaeq76p)
* 原文作者：[John Sundell](https://medium.com/@johnsundell?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：
# Improving Swift compile times #

For all its awesomeness, one thing that can sometimes be quite cumbersome when working with Swift on a bit larger scale is how long it can *currently* take to compile. While it’s expected that compile times are going to be longer in Swift compared to, for instance, Objective-C — since the Swift compiler does so much more in terms of assuring runtime safety — I wanted to look into if we can somehow help the compiler out to make it able to work faster.

So last week I dove into one of our larger Swift projects at [Hyper](http://www.hyper.no) . It has somewhere around 350 source files and 30,000 lines of code. In the end I managed to reduce the average time for a clean build on this project [by over 20%](https://twitter.com/johnsundell/status/837318595973611521)  — so I thought I’d spend this week’s blog post detailing how I did it.

Now, before we begin, I just want to say that **I don’t intend this post to in any way be critisism towards Swift or the team working on it** — I know the developers working on the Swift compiler, both at Apple and in the open source community, are continuously making major improvements in both the speed, functionality and stability of the compiler. Hopefully this blog post will be rendered redundant over time, but until then I just want to provide some practical tips & tricks that I’ve found can make compile times faster.

#### Step 1: Gather data ####

Before starting any optimization work, it’s always good to establish a baseline that you can measure your improvements against. For me, this was done through two simple scripts that I added as *Run script phases* for the app’s target in Xcode.

Before *Compile Sources*, I added the following script:

```
echo "$(date +%s)" > "buildtimes.log"
```

and at the end, I added this script:

```
startime=$(<buildtimes.log)
endtime=$(date +%s)
deltatime=$((endtime-startime))
newline=$'\n'

echo "[Start] $startime$newline[End] $endtime$newline[Delta] $deltatime" > "buildtimes.log"
```

Now, this measures only the time it takes to compile the **app’s own source files** (in order to measure the compile time for the entire app, you could use Xcode behaviors to hook into the *Build Starts* and *Build Succeeds* events). Since compile times vary a lot depending on what machine the code is being compiled on — I also *git ignored buildtimes.log*.

Next, I wanted to highlight what specific code blocks that take extra long to compile, in order to identify bottlenecks that I could then fix. To do this, you can simply set a threshold by passing the following arguments to the Swift compiler under the *Other Swift Flags *build setting in Xcode:

```
-Xfrontend -warn-long-function-bodies=500
```

Using the above arguments you will get a warning if any function in your project takes more than **500 miliseconds** to compile. This is the threshold I started out with (and the continously lowered it as I fixed more and more bottlenecks).

#### Step 2: Fix all the warnings ####

When enabling warnings for long function compile times, you will probably start to see a few of them in your project. At first, it can look seemingly random that a function takes long to compile, but soon patterns start to emerge. Here are two common patterns that I’ve noticed take particularly long to compile using the Swift 3.0 compiler:

**Custom operators (especially overloaded ones with generic parameters)**

One of the concepts that were new to many iOS & macOS developers when Swift came out is operator overloads, and like many new shiny things — we get excited about trying them out. Now, I’m not going to argue here whether custom operators & overloads are good or bad, but they can have a pretty big impact on compile times, especially if used it more complex expressions.

Consider the following operator, that adds two *IntegerConvertible* numbers to form a custom number type:

```
func +<A: IntegerConvertible,
       B: IntegerConvertible>(lhs: A, rhs: B) -> CustomNumber {
    return CustomNumber(int: lhs.int + rhs.int)
}
```

Which we then use to add a few numbers:

```
func addNumbers() -> CustomNumber {
    return CustomNumber(int: 1) +
           CustomNumber(int: 2) +
           CustomNumber(int: 3) +
           CustomNumber(int: 4) +
           CustomNumber(int: 5)
}
```

Looks simple enough, but the above* addNumbers()* function takes quite a long time to compile (over *300 ms* on my late 2013 MBP). Compare that to if we implement the same logic but using a protocol extension instead:

```
extension IntegerConvertible {
    func add<T: IntegerConvertible>(_ number: T) -> CustomNumber {
        return CustomNumber(int: int + number.int)
    }
}

func addNumbers() -> CustomNumber {
    return CustomNumber(int: 1).add(CustomNumber(int: 2))
                               .add(CustomNumber(int: 3))
                               .add(CustomNumber(int: 4))
                               .add(CustomNumber(int: 5))
}
```

With this change, our *addNumbers()* function now takes **less than 1 ms to compile**. That’s **~300 times faster!**

So, if you are making heavy use of custom/overloaded operators, especially ones with generic parameters (or if you’re using 3rd party libraries that do so — like many Auto Layout libraries), consider rewriting the same logic but using normal functions, protocol extensions or some other technique instead.

**Collection literals**

Another pattern that I’ve found to often become a compile time bottleneck is the use of collection literals, especially when the compiler needs to do a lot of work to infer the type of those literals. Let’s say you have a method that converts a model into a JSON-like dictionary, like this:

```
extension User {
    func toJSON() -> [String : Any] 
        return [
            "firstName": firstName,
            "lastName": lastName,
            "age": age,
            "friends": friends.map { $0.toJSON() },
            "coworkers": coworkers.map { $0.toJSON() },
            "favorites": favorites.map { $0.toJSON() },
            "messages": messages.map { $0.toJSON() },
            "notes": notes.map { $0.toJSON() },
            "tasks": tasks.map { $0.toJSON() },
            "imageURLs": imageURLs.map { $0.absoluteString },
            "groups": groups.map { $0.toJSON() }
        ]
    }
}
```

The above* toJSON()* function takes my computer about *500 ms* to compile. Now let’s try to construct that very same dictionary line-by-line instead of using a literal:

```
extension User {
    func toJSON() -> [String : Any] {
        var json = [String : Any]()
        json["firstName"] = firstName
        json["lastName"] = lastName
        json["age"] = age
        json["friends"] = friends.map { $0.toJSON() }
        json["coworkers"] = coworkers.map { $0.toJSON() }
        json["favorites"] = favorites.map { $0.toJSON() }
        json["messages"] = messages.map { $0.toJSON() }
        json["notes"] = notes.map { $0.toJSON() }
        json["tasks"] = tasks.map { $0.toJSON() }
        json["imageURLs"] = imageURLs.map { $0.absoluteString }
        json["groups"] = groups.map { $0.toJSON() }
        return json
    }
}
```

It now compiles in around *5 ms* — **100 times faster!**

#### Step 3: Conclusions ####

What both of the above examples make very clear is that some of the nice features of the Swift compiler, such as type inference and overloading, come at a time cost. This is, if we think about it, quite logical. Since the compiler has to do more work to perform inference, it will take longer. But as we can also see above, if we just slightly tweak our code to help the compiler resolve our expressions more easily — we can dramatically speed up our compile times.

Now, I’m not saying that you should always let compile times guide your decisions on how to write code. Sometimes it may be worth having the compiler do more work, if it makes your code clearer and easier to understand. But in large projects, coding techniques that drive compile times up in the 300–500 ms range (or higher) per function can quite quickly become a problem. My suggestion would be to keep monitoring your compile times, set a reasonable threshold for warnings using the above mentioned compiler flags, and address problems whenever they occur.

I’m sure the examples above don’t cover all potential areas of compile time improvements, so I’d love to hear from you if you have any other techniques that you’ve found useful to speed up compile times in large Swift projects. Either post a response here on Medium, or contact me on [**Twitter @johnsundell**](https://twitter.com/johnsundell).

Thanks for reading! 🚀
