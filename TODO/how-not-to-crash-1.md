> * 原文地址：[How Not to Crash](http://blog.supertop.co/post/152615019837/how-not-to-crash-1)
* 原文作者：[Padraig](https://twitter.com/supertopsquid)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# How Not to Crash


Sometimes apps crash. Crashes can interrupt the user’s workflow, cause data to be lost, and interfere with the background operation of an app. For developers, some of the hardest crashes to fix are the ones that are hard to recreate or worse still, hard to detect.

I recently discovered and fixed a bug that was causing many hard-to-detect crashes in Castro, and I want to share the story, along with some advice that might help you track down similar issues.

Oisin and I released Castro 2.1 in September. Soon afterwards the number of Castro crashes reported through iTunes Connect increased sharply.

![Chart showing Castro 2 crash report counts rising after version 2.1](http://supertop.co/images/crashes.png)

### iTunes Connect Crash Reports

Interestingly, these crashes did not appear in our usual crash reporting service, HockeyApp, so it actually took us a while to realize that we had a problem. To be aware of all crashes, developers need to check for crash reports through iTunes Connect or Xcode too. (Update: Greg Parker [points out](https://twitter.com/gparker/status/794076875249225728) that _“3rd party crash reporters use an in-process handler to record. But if the OS kills you from outside then that handler never runs.”_ Additionally, Andreas Linde, co-founder of HockeyApp, [linked](https://twitter.com/therealkerni/status/794275740631973888) to an article that explains what kinds of [crashes Hockey can and cannot find](http://t.umblr.com/redirect?z=https%3A%2F%2Fsupport.hockeyapp.net%2Fkb%2Fclient-integration-ios-mac-os-x-tvos%2Fwhich-types-of-crashes-can-be-collected-on-ios-and-os-x&t=M2RkMzgyMDY2MzU0ZWNmZmVjNDdiOTQ4MjljYWZhNjFiNDgwOGZhOCxXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1).)

If you’re an app developer and signed in to your account, Xcode allows you to review the crash reports collected by Apple from users of your app. The feature is found in the Organizer window, Crashes Tab. You can choose the app version and it’ll download crash reports that Apple collected from users who opted-in to sharing information with developers.

![Xcode's Crashes Tab showing crashes received from users.](http://supertop.co/images/crashes_tab.png)

I’ve found this part of Xcode to be prone to crashing itself, particularly when toggling open and closed the disclosure arrows on threads in the crash report. A handy work-around is to right click on the crash in the list pane, and choose “Show in Finder”. If you dig into the revealed bundle, you can see the crash reports as simple text files.

### Investigating the crash

The crash itself was triggered by a variety of code-paths, but it always ended in a database query execution method.

At first I suspected a threading issue, because after years of torment at the hands of threading bugs, that’s always the first thing I suspect. By opening the crash report as a text file, I could see more details than Xcode shows. The exception type was `EXC_CRASH (SIGKILL)` the note was `EXC_CORPSE_NOTIFY`, and the termination reason was `Code 0xdead10cc`. I started trying to track down what `0xdead10cc` means. There isn’t much on Google or the Apple Developer Forums about this, but [Technical Note 2151](http://t.umblr.com/redirect?z=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Fcontent%2Ftechnotes%2Ftn2151%2F_index.html&t=MTJmNGU4NThiODlmYzE1ZWJhMTM2MWFlODU3MzFiYTFmZGU2NWY4OSxXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1) says:

> The exception code 0xdead10cc indicates that an application has been terminated by iOS because it held on to a system resource (like the address book database) while running in the background.

At this point I knew that iOS was terminating the app because of a policy violation, and not some simple mistake in our code. However, Castro doesn’t use the Address Book database or any comparable system resources that I could think of. I wondered if the app was working for too long in the background without cancelling, but I noticed from our crash reports that in some cases the app had run for just 2 seconds.

I eventually reasoned that the many stack traces pointing to the crash happening in the database meant that the issue was probably with our database SQLite file. But what had changed in 2.1 that suddenly brought on this crash?

### Shared App Container

The 2.1 release of Castro introduced an iMessages App to allow easy sharing of recently played episodes. In order to allow the messages app to access the database, we had to move the database into a shared app container.

I wondered if the rules for file locking are stricter when the file is in a shared location. Perhaps when iOS tries to suspend an app, it checks if it’s using files that could be used by another process, if it is, iOS terminates the app. This seemed like a reasonably possible explanation.

### How to Crash

It’s good practice for programmers to figure out how to recreate crashes that they’re trying to fix. This can involve temporarily rewriting parts of the code to behave in an artificial way that makes the crash more likely. If we can reliably see the crash happen, it goes some distance to confirming suspicions and it gives us something to test potential fixes against. The alternative is to try a fix blindly, release it, and wait to see if we get crash reports. Sometimes that is the only way, but it’s a tedious process, and all the way through the app is still crashing for users.

This crash in particular was very challenging to recreate. I think there’s a fair critique to be made of iOS development here. The operating system enforces its rules aggressively. This is good, for the most part, because it improves security, battery life and stability. Testing and debugging apps under these circumstances however, is harder than it needs to be. The rules change quietly, and manually testing apps in each of the possible life-cycle states is awkward, and sometimes impossible.

In this case, I am aware of no way to trigger the suspension of an app that is connected to the debugger. In fact the debugger [prevents suspension, and the simulators don’t accurately simulate it.](http://t.umblr.com/redirect?z=https%3A%2F%2Fforums.developer.apple.com%2Fthread%2F14855&t=NmNmMmFhODVlZTk0Y2E3NDkzMzBmMWY5NzRhODY3NWRiY2MwNDExMSxXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1) Without the debugger, the only option is to experiment and then review logs on the device.

The new Console app in macOS Sierra provides a view into the system log of any attached iPhone. Before Sierra, I relied on Lemon Jar’s [iOS Console](http://t.umblr.com/redirect?z=https%3A%2F%2Flemonjar.com%2Fiosconsole%2F&t=ZDQ0Y2E0YjdiNDJkMDliYzA3ZDViYTMxYTUyYThiM2Y3NjU5MzY3ZixXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1) for this, but it’s great to see Apple offer access to these logs and know that this technique is accepted and supported. It is well worth spending the time to learn how to use the new Console app. It reveals a lot of the workings of iOS that the Xcode debugger alone does not. There’s a lot of irrelevant noise because this is a unified log for the whole system, but you can easily set up filters to narrow down to just the messages that are relevant to your app.

To contrive my `dead10cc` crash:

*   I set up the `applicationDidEnterBackground` method to do a few hundred database queries.
*   On my Mac, I opened Console and filtered for messages mentioning Castro.
*   I installed the app through Xcode but ran it normally by tapping the icon.
*   I pressed the home button to move the app to the background and then immediately opened Pokémon Go in the hope that the memory pressure would suspend Castro.

After following these steps a few times, I was able to see in Console that I had managed to recreate the crash. The backtrace looked the same as the real crashes, so I was pretty confident of the cause of the crash now.

I was then able to find and fix a place in the app where background work was being triggered that would access the database: on network reachability change, the app was doing a refresh without a background task. If the app was suspended while this refresh was accessing the database, iOS would kill it.

### Background Fetch Gotcha

I was surprised by one more thing that I’d like to share. In Castro 2, our server tells the app that a new episode has been released, which triggers a refresh of the user’s feed. When iOS passes this message to our app, it calls a method called `didReceiveRemoteNotification`, which includes a completion block. From the documentation:

> Your app has up to 30 seconds of wall-clock time to process the notification and call the specified completion handler block. In practice, you should call the handler block as soon as you are done processing the notification. The system tracks the elapsed time, power usage, and data costs for your app’s background downloads.

Here’s the crazy thing: As I mentioned earlier, Castro was sometimes being killed within 2 seconds. I could tell from the stack trace that it hadn’t yet called that completion block. So, although the documentation says that the app should be safe for up to 30 seconds, it was getting suspended anyway.

I found this so surprising that I decided to use one of our developer technical support incidents to see what was up. I got some very helpful responses from Kevin Elliott, the engineer assigned to my case:

As suspected the `dead10cc` issue was caused by file locking:

> “What’s actually triggering this is that iOS has found a locked file (in this case, an SQLite lock) in your apps container at the time your app is suspending. This check here was actually added as a way to manage and reduce data corruption inside applications. The problem here is that the locked file indicates that the file is still being actively modified and may be in an incoherent state. In other words, the only reason an app would lock a given file is because it intends to do a series of reads and/or writes to that file over time and it wants to guarantee all of those writes can complete without any writes being inserted in between. That, by extension, means that the fact the file is still locked means the app hasn’t finished writing it’s data out. A file in this state has a few potential problems:
> 
> *   If the app is killed while the app is suspended, then the data that “should” have been written won’t be, corrupting the data.
> *   If the file is shared between two apps and the second app/extension runs, then that second app is going to be forced to either break the lock and try to restore the file to a consistent state, leaving the first app in an inconsistent state, or ignore the shared file entirely.”

Regarding the 30 seconds of background time:

> … the right answer here is to side step the issue entirely- if you can’t finish all of your work within the delegate method then just start a background task and now iOS will tell you before it suspends your app (in the completion block)…

Apps that access files in a shared container while the app is running in the background should create a background task and not assume that the 30 second completion block time covers them. To work around this, developers can create a background task using the `beginBackgroundTaskWithName:expirationHandler` method on UIApplication and call `endBackgroundTask` when the background work is finished.

Additionally, Kevin also suggested that apps should close the database when they go into the background as a way to ensure they’ve finished flushing data and to surface rare bugs more reliably:

> Closing the file as part of normal operation converts the potentially rare and mysterious bug “things sometimes don’t work in the background” into the much clearer “my app doesn’t work in the background”, at which point you can address the problem directly.

This seems pretty smart; it hadn’t occurred to me to think of shutting down parts of the app when going into the background, but it makes a lot of sense. I’m going to look into closing the database in the background in the next update to Castro.

### Conclusion

By adding background tasks around any work that continues in the background, I have fixed this issue in our beta. We’ll release an update soon that includes this fix.

Here’s a quick summary of what I learned:

*   Apple reports some crashes that other services don’t. Check for crash reports through iTunes Connect or Xcode as well as any external services.
*   The rules for file locking are stricter when your database is in a shared location.
*   It’s not enough to rely on a background fetch completion block, don’t do _any_ work in the background without an active background task.
*   It’s hard to debug issues that only manifest in particular stages of the app lifecycle. If you haven’t tried it yet, learn how to use the new Sierra Console.app.
*   Don’t forget about [Technical Support Incidents](http://t.umblr.com/redirect?z=https%3A%2F%2Fdeveloper.apple.com%2Fsupport%2Ftechnical%2F&t=MmJjYzRkN2JmNTg0YjlmYjEyMmZkN2QwMzFmNzAyMGNjYTZjYzI1NixXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1), you get 2 included in your developer account payment every year. (Thanks Kevin!)

If you enjoyed this post, you might also enjoy the [Supertop podcast](http://t.umblr.com/redirect?z=https%3A%2F%2Fitunes.apple.com%2Fca%2Fpodcast%2Fsupertop-podcast%2Fid1143273587%3Fmt%3D2&t=OGRlZTk5NmVhMDc2YmNlMmRmN2FhYmRjMzJmMTgxODYyZDcwNzFmZSxXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1) and our podcast app, [Castro](http://t.umblr.com/redirect?z=http%3A%2F%2Fsupertop.co%2Fcastro%2Fdownload%3Fcampaign%3DCastroBGCrashPost&t=OTJiNjAwYTgwOWJhNzNmNzI2NWNiMDI3Y2RhNGFhOWNiNDVmOWY2OCxXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1).

The title of this post is a reference to Brent Simmons’ ["How Not to Crash”](http://t.umblr.com/redirect?z=http%3A%2F%2Finessential.com%2Fhownottocrash&t=YWQwOTk2YWRiOTZlYmU3ZDIyYzUwM2I5OWEzOTBiMGYxZDA0ODNjNSxXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1) series, which you should read if you haven’t already.

