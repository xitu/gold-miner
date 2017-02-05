> * 原文地址：[Make Memory Management Great Again](https://medium.com/ios-geek-community/make-memory-management-great-again-f781fb29cea1#.w6wgnw1og)
* 原文作者：[Bob Lee](https://medium.com/@bobleesj)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Make Memory Management Great Again

## Swift 3 Automatic Reference Counting explained with ease for complete beginners without CS/CE degree

![](https://cdn-images-1.medium.com/max/2000/1*s0LCbddq8T4VN4kXtt9r2g.png)

Beautiful picture from Unsplash

### Audience

This article is written for those who may have close to zero understanding of `Memory Management`. Many iOS courses and books tend to skip this because it can be quite complicated for beginners. For example, have you seen those keywords like `weak` and `strong` when you create `IBOutlet` ? You probably have. You just do it because it somehow works.

Before we talk about Swift, let us build a strong foundation in terms of what `memory` is in the first place, and why we need it. You may skip this part.

The term `memory management` refers to an overview of how an operating system, iOS for example, handles saving and extracting data. As you may already know, there are two main ways to save information/data. **1. Disk** and **2. Random Access Memory (RAM)**.

#### Prerequisites:

A decent understanding of `Object Oriented Programming`, `Optionals`, and `Optional Chaining`. If you are stuck, feel free to check out my YouTube Swift series. [Here](https://www.youtube.com/playlist?list=PL8btZwalbjYlRZh8Q1VK80Ly0YsZ7PZxx)

### The purpose of RAM

Imagine you are playing a shooting game on your phone, and it needs to store a bunch of images and graphics so that you can continue playing even if you press the setting button, and you still expect your PR stay even if you come back. If not, that would be horrendous. 😅

But, when you shut down your phone, all those images are gone. So, as you might have guessed it, they are all stored in RAM. They are a temporary storage on your phone, and it’s much quicker, around 15,000 MB/s as supposed to 1,000MB/s of a normal hard drive. Those graphics do not get stored on your hard drive. If that was the case, your phone would be full of images and texts after playing a couple hours of the game.

Often times, teachers describe RAM as a short term memory. Take a look at the short clip below.

[![](https://i.ytimg.com/vi_webp/Zz7ShiQqLQg/maxresdefault.webp)](https://www.youtube.com/embed/Zz7ShiQqLQg?wmode=opaque&widget_referrer=https%3A%2F%2Fmedium.com%2Fmedia%2F7ffc9e0d06c547a5448c166284d7fe53%3FpostId%3Df781fb29cea1&enablejsapi=1&origin=https%3A%2F%2Fcdn.embedly.com&widgetid=1)

The chimp has a greater short-term memory than most that of humans. However. both will never remember the pattern in long term
My iPhone has a 4GB RAM and 128GB disk. So, when you are running your app, pretty much everything is stored in your RAM unless I specifically use `UserDefaults` or `CoreData` to store data on the disk.

### Ram Storage Limitation

This is another scenario. It’s 2AM, you are scrolling through Instagram or Facebook Feed on your bed. But, how is it possible that your phone is able to maintain a beautiful 60 frame per second, very smooth transition even if you scroll up and down? It’s because they those objects and data are temporarily stored in the RAM. However, you can’t store indefinitely.

When we say `memory management` specifically in iOS, we refer to the process of managing space available in your RAM. Although nowadays you rarely see it gets overloaded since it’s getting more powerful than your computer 5 years ago. However, the golden rule for iOS developers is to create an efficient app so that you don’t kill apps in the background. Let’s be respectful to other iOS developers. We want our apps to stay alive.

### Okay, What now? 😴

RAM is like a refrigerator. You can add food, drinks, and even clothes if you are like me. Similarly, in iOS, you can add a bunch of pictures, images, large objects such as UIView. However, just like a fridge, there is a physical limitation to how much you can store. You might have to take out a couple of beers so that you can add fresh sushi. 🍲

Fortunately, in iOS 10, the cleaning/freeing part has been automatically done by a library created by Apple Engineers. They have implemented what they call, `Automatic Reference Counting` to indicate whether an object is still being used or no longer needed. In other programming languages or back a couple years ago, however, you had to manually insert objects into the box and discard those objects — one by one.

So, let’s take a look at how `Automatic Reference Counting` works.

### Automatic Reference Counting

First of all, let’s create an object first. I’ve made a class called `Passport`which contains its citizenship and an optional property called `human` which is described later — You don’t need to know how the `Human` class is made up of for now since it’s an optional type.

    class Passport {
      var human: Human?
      let citizenship: String
     init(citizenship: String) {
      self.citizenship = citizenship
      print("You've made a passport object")
     }

    deinit {
      print("I, paper, am gone")
     }
    }

By the way, if you don’t know what `deinit` means, it’s the opposite of `init`. So when you `init`, you’ve created an object and inserted into the box/memory. `deinit` occurs when the specific location of the object in the box has been freed/deallocated/purged.

Let’s create an object **by itself** without creating `var` or `let`

    Passport(citizenship: "Republic of Korea")
    // "You've made a passport object"
    // "I, paper, am gone"

Wait, why is it being **deleted right** after you’ve made an instance/object? Well, it’s due to ARC and let me explain.

In order to maintain an object in memory, you must have a reference to something, and there must be a relationship. I know it sounds weird. Please bare with me for a bit.

    var myPassPort: Passport? = Passport(citizenship: "Republic of Korea")

![](https://cdn-images-1.medium.com/max/1600/1*onm_nN7Cyd9D2fNUZbVyCQ.png)

myPassport holds a reference/relationship with Passport

When you’ve created the `Passport` object by itself, it had **no relationship/reference count**. Now, however, there is a relationship between `myPassport` and `Passport` and the reference count is **one.**

> **The Only Rule**: If the reference count is zero/no relationship, the object gets purged out of the memory.

*You might be wondering what *`*strong*`* means. It’s a default relationship. One relationship adds reference count by one, and I will explain it later when we have to use *`*weak*`* in certain cases.*

Now, I’m going to create a class called `Human` which has an optional property whose type is `Passport`.

    class Human {
     var passport: Passport?
     let name: String
     init(name: String) {
      self.name = name
     }

     deinit {
      print("I'm gone, friends")
     }
    }

Since the variable `passport` is an optional type, we don’t have to set it when you first initialize a`Human` object.

    var bob: Human? = Human(name: "Bob Lee")

![](https://cdn-images-1.medium.com/max/1600/1*WGQoMfvMtiYU3QxOXqT9Sw.png)

bob to Human and myPassport to Passport
If you decide to make both `bob` and `myPassport` as `nil` then

    myPassport = nil // "I, paper, am gone"
    bob = nil // "I'm gone, friends"

![](https://cdn-images-1.medium.com/max/1600/1*aTt-hEdZ-p7SSA7NgcN6jA.png)

All gone and deallocated
As soon as you’ve set them as `nil` for each object, the relationship no longer exists, so the reference count for each becomes **0** which causes both objects to be deallocated.

**However, even if you set something to **`**nil**`** it may necessarily not deallocate **due to possible relationships with other objects, thus not reaching reference count to 0. It may sound crazy. So, let’s take a look.

The `Human1` class had an optional property whose type was `Passport `Also, `Passport` had an optional property whose type is `Human`.

    var newPassport: Passport? = Passport(citizenship: "South Korea")
    var bobby: Human? = Human(name: "Bob the Developer")

    bobby?.passport = newPassport
    newPassport?.human = bobby

To visualize the relationship, I’ve made a diagram for you.

![](https://cdn-images-1.medium.com/max/1600/1*dbWY94LQTZCCLGUvMPfQaA.png)

Okay, now, let’s do the same thing by setting those objects to `nil`.

    newPassport = nil
    bobby = nil
    // Nothing happens 🤔

Nothing happens. They remain. Why? It’s because there is still a relationship between `bobby` and `newPassport`.

![](https://cdn-images-1.medium.com/max/1600/1*aytSkuvT1dh0Fjk3HCiiXg.png)

It may look counter-intuitive. **You must break all the relationships associated among/between objects in order to purge both objects completely**. For example, even if `Human` with “Bob Lee” has been set to `nil`, it doesn’t get deallocated since there is a relationship (reference count 1) as `Passport` is referring to the `Human `object. So, now when you try to set `Passport` to `nil` , it doesn’t get deallocated because the `Human` object is still alive and has a reference to `Passport`. The reference count never reaches 0.

> “The Only Rule Converse: It doesn’t matter whether you’ve set objects to nil, it’s all about the reference count number. You must Destroy everything. nil != deallocation” — SangJoon Lee

### Critical Problem

We call this **reference cycle** and **memory leak**. Even if those objects are no longer used and you thought they had been deallocated, they remain in your phone and take up space like fat. (It’s one of the most common iOS interview questions). This is a nono. Imagine if there was memory leak when you scroll thousands of instagram posts or Facebook NewsFeed. Your limited 4GB of space would be filled with data objects and eventually your app would break. Not a great experience for many users.

### Bye Strong, Welcome Weak

Great, you’ve come a long way. Congratulations. Now, you are going to learn why we use `weak`. The only purpose is to allow **deallocating objects.**

Remember, **weak does not increase reference count. **Let’s add `weak` in front of the `passport` property within the `Human` class.

    class Passport {
    **weak var human: Human?
    **let citizenship: String

     init(citizenship: String) {
      self.citizenship = citizenship
      print("You've created an object")
     }

     deinit {
      print("I, papepr, am gone")
     }
    }

Every thing else remains the same.

![](https://cdn-images-1.medium.com/max/1600/1*Q0Mh1UxKEVwCuPPSLtFlfA.png)

Passport not has a weak reference to Human and does not increase reference cycle
Now, if you set

    newPassport = nil
    bobby = nil

    // "I, papepr, am gone"
    // "I'm gone, friends" 👋

![](https://cdn-images-1.medium.com/max/1600/1*7DKrMzcj38Hlvmi3vwY12g.png)

Destroyed and Deallocated
This is what happened. Since `weak` does not count as a relationship or does not increase the reference count, there is virtually only **one reference count** before you set `bobby` to `nil`. So, when you set `bobby` to `nil`, the reference count/relationship becomes `0` which successfully allows you destroy everything. I love when things get out of memory. Damn, this article took forever.

#### [Source Code](https://github.com/bobleesj/Blog_Memory_Management)

### Last Remarks

By now, I hope you understand what it means by `strong``and``weak`and how `reference count` works in Swift automatically. If you’ve learned something new with me, I’d appreciate your gratitude by gently tapping the ❤️ below or left. I was thinking of not putting those graphics since it added a lot more time, but anything for my lovely Medium readers.

In Part 2, I will talk about how **memory management works within closures **and you have seen something like`[weak self]` I will also talk about the purpose of using `self` and so on. So stay tuned and follow me so that you get notified first!

### Upcoming Course

I’m currently creating a course called, The UIKit Fundamentals with Bob on Udemy. This course is designed for Swift intermediates. It’s not one of those “Complete Courses”. It’s specific. So far, 200 readers have sent me emails since last month. If interested, shoot me an email for more into and register your spot for free until it is released. I will give you a form to sign up.`bobleesj@gmail.com`

#### Coaching

If you are looking for help to switch your career as an iOS developer or create your apps that would help the world, contact me for more detail.

### Swift Conference

[Andyy Hope](https://medium.com/@AndyyHope), a friend of mine, is currently organizing one of the largest and Swift Conferences in Melbourne, Australia. It’s called Playgrounds. It’s coming soon in about 3 weeks! I highly recommend you to take a look at speakers all from mega companies. 😲

[Playgrounds 🐨 (@playgroundscon) | Twitter
The latest Tweets from Playgrounds 🐨 (@playgroundscon). ● Swift and Apple Developers Conference ● Melbourne, February…twitter.com](https://twitter.com/playgroundscon)

#### Shoutout

A big thanks to my students! [Nam-Anh](https://medium.com/@yoowinks), [Kevin Curry](https://medium.com/@kevincurry_89695), David, [Akshay Chaudhary](https://medium.com/@Akshay_Webster).
