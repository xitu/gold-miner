> * 原文地址：[Breakpoints: Debugging like a Pro](https://cheesecakelabs.com/blog/breakpoints-debugging-like-pro/)
> * 原文作者：[Alan Ostanik](https://cheesecakelabs.com/blog/author/alan/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/breakpoints-debugging-like-pro.md](https://github.com/xitu/gold-miner/blob/master/TODO/breakpoints-debugging-like-pro.md)
> * 译者：
> * 校对者：

# Breakpoints: Debugging like a Pro

![](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2017/06/Banner_xcode3.png)

When I started as an iOS developer, my biggest problem was with app crashes, that’s because I really didn’t know how iOS, Swift, and Objective-C worked. Back then, I wrote a lot of bad code, not worrying about memory usage, memory access, ARC or GCD. That’s simply because I didn’t know about that stuff. I was a beginner, for God sakes.

Like most beginners, [Stack Overflow](http://www.stackoverflow.com "Stack Overflow") community taught me a lot about “doing things the right way”. I’ve learned a lot of tricks that helped me improve my work process. In this article, I’ll share some of them about the most important tool used in this learning process: the **breakpoints**!

So, get your shovels and let’s go dig in 🙂

# Breakpoints

The Xcode Breakpoints is a powerful tool and there is no doubt about it. Its main purpose is to debug code, but what if I say that they can offer more than that? Ok, let’s start with the tricks!

## Conditioning breakpoints

Maybe you have already gotten yourself in a situation where your _TableView_ is working so well for all users models, but there is a particular one that is causing some trouble. To debug this entity, the first thing that you may think is: “_Ok, I will put a breakpoint on cell loading and see what is going on_”. But for each cell, even the working ones, your breakpoint will be activated and you will have to skip it until you have reached one that you want to debug.

[![The Office TV show gif, saying "please god, no"](https://media.giphy.com/media/12XMGIWtrHBl5e/giphy.gif)](https://media.giphy.com/media/12XMGIWtrHBl5e/giphy.gif)

To solve this issue, you can go ahead and give your breakpoint a condition to stop, like I did for the user named “Charlinho”.
![A conditional breakpoint screenshot](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2017/06/3.png)

## Symbolic Breakpoints

> _“Relax, I will use a pod, that should save us some work.”_

Who never said that? But using a pod or an external library you are importing external code into your project and the way it was written might be unknown. Let’s say that you tracked an error occurring on some function on a pod, but you don’t know where the function is in the code. Just take a breath, keep it cool… you have **_Symbolic Breakpoints_**_._

These breakpoints are activated when a previously declared _symbol_ is called. This _symbol_ can be any free functions, instance and class methods, whether in your own classes or not. So to add a breakpoint in a function, no matter who’s calling it, you just have to add a _Symbolic Breakpoint_ observing the function that you want to debug. In my sample below, I observe the method _UIViewAlertForUnsatisfiableConstraints_. This method will be called every time that Xcode finds some _Autolayout_ issue. You can see a more advanced tip on [this post](http://nshint.io/blog/2015/08/17/autolayout-breakpoints/).

![A Symbolic breakpoint option screenshot](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2017/06/2.png)

## Customizing breakpoints

Like I said previously, breakpoints are a powerful tool. Did you know that you can even add custom actions on a breakpoint? Yeah, you can do that! You can perform an AppleScript, Capture CPU Frame, use LLDB (Low-level Debugger) commands and even shell commands.

![](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2017/05/4.png)

To do that you can simply click on the right button and select _edit breakpoint_

### OK, you could be thinking: “Cool! But why?”

I’ll give you a good use case that will improve your work. The most common feature on an app is the Login, and sometimes testing it is a little bit boring. Having to type the user and password multiple times – if you are using an admin and a normal account – could make the process a little nasty. The common approach to “automate” the login screen is to create a _mocked_ entity and use it into an _if debug_ clause. Something like this:

```
struct TestCredentials {
    static let username = "robo1"
    static let password = "xxxxxx"
}

private func fillDebugData() {
     self.userNameTxtField.text = TestCredentials.username
     self.passwordTxtField.text = TestCredentials.password
}
```

### But hey, you can use breakpoints to make things a little easier!

Go into your login screen, add a breakpoint and then add two LLDB expressions that will fill your user and password. Like I did in the example below:

![A Custom breakpoint executing express commands. ](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2017/06/6.png)

With that in mind, you can add two breakpoints with different credentials. To switch between them, you just have to enable/disable the one that you want to test. There is no rebuild required once you are changing the user on the fly.

Pretty cool, huh?

# COMBO BREAKER!

The WWDC 2017 was happening while I was writing this article. They launched some cool stuff like the new Xcode 9, for example. If you want to know what is new with debug tools on Xcode 9, I strongly recommend watching the [Session 404](https://developer.apple.com/videos/play/wwdc2017/404/).

[![](https://media.giphy.com/media/l41m0ysPANVkPS8JW/giphy.gif)](https://media.giphy.com/media/l41m0ysPANVkPS8JW/giphy.gif)

That’s all folks! Now you know the basics Breakpoint tricks that helped me a lot when I was a beginner. Are there any cool tricks that I didn’t mention? Do you have any good ones too? Please feel free to share them in the comments!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
