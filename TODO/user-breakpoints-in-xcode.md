
> * 原文地址：[User Breakpoints in Xcode](https://pspdfkit.com/blog/2017/user-breakpoints-in-xcode/)
> * 原文作者：[Michael Ochs](https://twitter.com/_mochs)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/user-breakpoints-in-xcode.md](https://github.com/xitu/gold-miner/blob/master/TODO/user-breakpoints-in-xcode.md)
> * 译者：
> * 校对者：

# User Breakpoints in Xcode

Everybody uses breakpoints in Xcode, but are you aware of user breakpoints? I am going to show you how to use them and what to use them for. If you already know what user breakpoints are and how to use them, check out the list at the end of the article and see what we use them for at PSPDFKit. Maybe there is something new for you to add to your list! 

## A Regular Breakpoint

When creating a regular breakpoint, they show up in Xcode’s breakpoint navigator either under the workspace or the project, depending on what you are working on at the moment. You can activate or deactivate a breakpoint by clicking its breakpoint symbol in the list or right at the code it is referring to.

![A regular breakpoint](https://pspdfkit.com/images/blog/2017/user-breakpoints-in-xcode/regular-breakpoint@2x-a201ce1c.png)

These breakpoints are stored inside the personal settings for this particular workspace or project and are visible only for you, even if you commit your personal settings to the project. Colleagues working on the same project will not see your breakpoints in their Xcode.

## Shared Breakpoints

By right-clicking a breakpoint and selecting ‘Share Breakpoint’ that breakpoint becomes visible to everybody else working on the project. This is useful in case there are code paths in a project where you want to stop every time, such as a custom exception handler or any other project specific code that should not be executed under normal conditions. In combination with breakpoint options and automatically continuing breakpoints, this can also be very helpful to improve the general debugging experience.

Another slightly less useful thing you can do with this: add a shared breakpoint in a commonly executed code path of your app, such as the completion of a network request, make it continue automatically and let it play a sound every time it is hit – yes, you can make your breakpoints play sounds. Commit and watch your co-workers go nuts when they try to figure out where that sound is coming from! 😁 Sadly trolling your co-workers is the one thing that doesn’t quite work in a remote environment, which is why I have not done that at PSPDFKit... but that might be something to entertain for [our retreats](https://pspdfkit.com/blog/2016/the-importance-of-retreats-for-a-remote-company/).

## User Breakpoints

There is another thing you can do with your breakpoints though. It is a very powerful feature; just a bit hard to find in Xcode. You can move your breakpoint to become a user breakpoint by right-clicking it and selecting ‘Move Breakpoint To > User’.

![A regular breakpoint](https://pspdfkit.com/images/blog/2017/user-breakpoints-in-xcode/move-to-user@2x-d63238f8.png)

This moves the breakpoint out of the workspace or project scope and into a user-wide scope. This means the breakpoint then shows up on your machine in all projects. While this is not very helpful for project related things, there are a bunch of breakpoints that make sense to be added to the user-wide list. The most obvious things are the Objective-C exception and the Swift error breakpoints which probably everyone has added to all their projects that use the corresponding languages. With user breakpoints, you just need to add them once, and they automatically show up in all your projects.

Another breakpoint I have in the user space is the one that activates Reveal on application launch. Reveal is a great tool for debugging view related issues and I use it a lot. It requires a server to be integrated into your app and this server needs to be launched. This can be done through the debugger to remove the need to add debugging code to your app. When moving this breakpoint to your user space you no longer need to add that to every project, instead, if your project contains the reveal server, it is automatically started when your app launches. This approach is also mentioned in Reveal’s [integration guide](http://support.revealapp.com/kb/getting-started/load-the-reveal-server-via-an-xcode-breakpoint).

There are a couple of other breakpoints that are very helpful in every project. Keep in mind that you can deactivate them and only switch them on if needed; many of mine are off by default, but they are there in case I need them. This is a list of the favorite breakpoints used by our team at PSPDFKit:

- **Symbol:**`UIViewAlertForUnsatisfiableConstraints`

    Automatically stops on auto layout constraint issues. This brings much more attention to the issue that otherwise would just print a log message in the console inside Xcode. It helps a lot with identifying layout issues early.

- **Symbol:**`NSKVODeallocateBreak`

    Breaks in places where KVO complains about observers still being in place.

- **Symbol:**`UIApplicationMain`
*Debugger command:*`e @import UIKit`

    Imports UIKit into the debugger, removing the need to cast structs in a lot of places. Are you writing things like `p (CGRect)[self bounds]` a lot? This removes the need to cast to `CGRect`.

- **Symbol:**`-[UIViewController initWithNibName:bundle:]`
    *Debugger command:*`po $arg1`

    Prints the class of a view controller during its initialization. When working on large projects or if you are new to a project, you do not know all the names of the view controllers. If you are trying to figure out what the name of the view controller is that you want to make changes to, just activate this breakpoint and then navigate the app to the view controller in question. You will see the name of it printed in the console.

- **Symbol:**`-[UIApplication sendAction:toTarget:fromSender:forEvent:]`

    Stops when an event is delivered, such as the touch of a button. This is pretty similar to the one above. Activate this breakpoint if you do not know what method a button calls on touch. `p (SEL)$arg3` will print the selector that is invoked and `po $arg4` the target it is invoked on.

- **Exception Breakpoint:** Objective-C
    *Debugger command:*`po $arg1`

    Stops when an Objective-C breakpoint is hit, printing the exception to Xcode’s console.

- **Exception Breakpoint:** C++

    Stops when a C++ exception is hit.

- **Swift Error Breakpoint**

    Stops when a Swift Error is encountered.

- **Symbol:**`_XCTFailureHandler`

    Breaks if a unit test produces an error. If you are running unit tests and want them to break if a test encounters an error, this is what you need.

If you have anything else on your list that you think might be useful, [please let me know](https://twitter.com/_mochs). If you want to read more about what awesomeness can be done with Xcode breakpoints and how to [debug a specific instance with scripted breakpoints](https://pspdfkit.com/blog/2016/scripted-breakpoints/) check out our blog! 


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
