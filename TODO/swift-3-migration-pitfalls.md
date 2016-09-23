> * 原文地址：[Swift 3 migration pitfalls](http://codelle.com/blog/2016/9/swift-3-migration-pitfalls/)
* 原文作者：[ Emil Loer](http://codelle.com/contact/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：shliujing
* 校对者：



[](http://codelle.com/blog/2016/9/swift-3-migration-pitfalls/)

万岁! Swift 3 got released, so let's migrate! In this post I will tell you about my experiences of migrating a 20K lines Swift project to version 3 of the language. In case you're curious, the project is my own implementation of the Cassowary linear constraint solving algorithm most famous for it's use in Auto Layout, but I'm using it for something totally different which I will write about in a future article.

### The Swift Migrator

The first step was to convert my project by running the Swift Migrator from Xcode. The migrator caught most of the things I had to change, so it saved me a lot of work. There were a few things I had to change afterwards. The two most interesting ones were permission changes (the new permission model default to making `public` classes and methods `open`, but I wanted to limit this in most cases) and a binary search function that I had to rewrite because of changes to the way collection index manipulation works. No big deal though.

### Nothing has changed

As is tradition now with any new Swift release my first compilation attempt segfaulted the compiler. The compiler log did output a list of errors before segfaulting and after I worked on these the crash disappeared and I was good to go.

The compilation errors I had to fix were related to two language changes that the migrator did not catch. I will highlight these in the next two sections.

### New Ranges

The first class of errors had to do with semantic changes to the `Range` structure. In Swift 3 ranges are now represented using four different structs to distinguish between countable/uncountable ranges and open/closed ranges. In Swift 2 open and closed ranges were represented using the same struct, so if you had some code that had to work on both types this needs some changes.

Consider this valid Swift 2 example:



    func doSomething(with range: Range) {
        for number in range {
            ...
        }
    }

    doSomething(with: 0..<10) 
    doSomething(with:="" 0...10)="" 



In Swift 2 this would work for both half-open and closed countable ranges. The migrator did not convert the struct name, so after migration this does not work anymore. In Swift 3 `Range` represents a half-open uncountable range. Since uncountable ranges don't support iteration we have to change this, and it would also be nice if we can make it work on both half-open and closed ranges. The solution is to either convert the input to an half-open countable range or use generics to make it work on both. This makes use of the fact that countable ranges implement the `Sequence` protocol.

Here is a Swift 3 version that works:



    func doSomething(for range: IterableRange) 
        where IterableRange: Sequence, IterableRange.Iterator.Element == Int {
        for number in range {
            ...
        }
    }

    doSomething(with: 0..<10) 
    doSomething(with:="" 0...10)="" 



### Tuple Conversion

Another thing the compiler complained about was named tuple conversion. The following is a piece of valid Swift 2 code:



    typealias Tuple = (foo: Int, bar: Int)

    let dict: [Int: Int] = [1: 100, 2: 200]

    for tuple: Tuple in dict {
        print("foo is \(tuple.foo) and bar is \(tuple.bar)")
    }



The migrator left this code untouched, but the compiler complains about the for loop's typecast to `Tuple`. When iterating over that dictionary the iterable element type is `(key: Int, value: Int)` and in Swift 2 it was perfectly fine to assign this directly to a variable having a named tuple type with the same member types but different names. Well, not anymore!

Although I think that this stricter typing is in general a good idea, it does mean that we now have to explicitly convert the tuple to our target type. We can replace the loop with the following code to make it work again:



    for tuple in dict {
        let tuple: Tuple = (foo: tuple.key, bar: tuple.value)
        print("foo is \(tuple.foo) and bar is \(tuple.bar)")
    }



Of course this is a contrived example, but if you're passing this tuple around or whatever it can keep the code more understandable if you're using semantically valid names instead of key/value, which are only relevant to the dictionary.

### PaintCode and Core Graphics

Something else worth mentioning is Core Graphics. Swift 3 introduces objectification of Core Foundation-style references, meaning that you can now use them as if they were Swift objects instead of a group of C functions. This is really neat for keeping your code readable. This new feature is most often seen with Core Graphics calls. The migrator converts most of these calls, but some of the lesser used functions (e.g. arc drawing) are not converted and have to be done manually.

In my projects I make a lot of use of PaintCode. With PaintCode's code generation being notorious for not fully supporting the most recent Swift syntax (the current version still produces warnings on Swift 2.3 even though it is a trivial issue to solve) I was afraid my graphics code might not convert properly. Fortunately the code gods smiled upon me because no additional issues were encountered after migration. You might still want to change the visibility from `open` to `internal` though to benefit from more compiler optimisations. (I have a script that does this with some regexing)

### Performance

Overall I noticed no significant changes in compilation time in my projects after migration. My benchmarking unit tests showed a slight performance drop in dictionary-heavy code, but otherwise nothing significant. My constraint solver still works in real-time. :)

### Final Thoughts

Overall, migration to Swift 3 was quite easy. The migrator helped me get through most of the changes, and the remaining stuff was easy to fix. It might be different if you're still a bit new to Swift though, so your mileage may vary.

A final tip that really helps: make sure you have plenty of unit tests for the algorithmic parts of your project (never a bad idea!) so you can verify that no semantic changes were introduced during migration, and if they were then you can locate them!

If you've enjoyed this post please follow me on [Twitter](https://twitter.com/codelleapps) or [Facebook](https://facebook.com/codelle.apps). I'd really appreciate it!



