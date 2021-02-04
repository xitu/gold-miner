> * 原文地址：[Unexpected App Crashes on Android and How to Deal with Them](https://levelup.gitconnected.com/unexpected-app-crashes-on-android-and-how-to-deal-with-them-c5d07512d99f)
> * 原文作者：[Kunal Chaubal](https://medium.com/@kunalchaubal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/unexpected-app-crashes-on-android-and-how-to-deal-with-them.md](https://github.com/xitu/gold-miner/blob/master/article/2020/unexpected-app-crashes-on-android-and-how-to-deal-with-them.md)
> * 译者：
> * 校对者：

# Unexpected App Crashes on Android and How to Deal with Them

![Image by [testbytes](https://pixabay.com/users/testbytes-1013799/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=762486) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=762486)](https://cdn-images-1.medium.com/max/2560/1*4WT3_B3SVKgvexQOTE_ZqQ.jpeg)

If there’s anything common among all the developers out there, be it front-end, back-end, or even game developers, it is that we hate production bugs. Especially when these bugs result in apps crashing. It is an unpleasant experience to monitor these increasing crashes in your application when you have recently rolled out to production.

Some crashes are encountered because of the system/platform it runs on irrespective of the business logic of the app. In Android, you might have encountered a crash when you resume the app from the background state. Such crashes are unexpected and difficult to understand or process by just looking at the crash logs.

This article talks about such issues and ways to solve them.

## The Problem

While monitoring crash logs in production, I noticed some issues that were increasing day by day. The app seemed to work fine in normal testing conditions and the crash log was not replicable. This was until the application was brought back from the background tasks.

Every android app runs in its own process and this process has been allocated some memory by the Operating System. When your app is put in the background while the user interacts with other applications, the OS can kill your app process if there’s not enough memory available for your application. This generally occurs when another app is being run in the foreground which demands greater phone memory (RAM).

When the app process is killed, all the singleton objects and temporary data are also lost. Now, when you return back to your app, the system will create a new process and your app will resume from the activity that was at the top of your stack.

Since all your singleton objects were lost at this point, when the activity tries to access the same objects, the app crashes resulting in a NullPointerException.

This is a problem and before we move on to the solution, let us replicate this scenario.

## Replicating the Crash

1. Go ahead and run any of your applications from Android Studio in an emulator or an actual device connected by a USB cable.
2. Navigate to a random screen and press the ‘home’ button
3. Open terminal and type the following command to get the process ID (PID) of your application

```bash
adb shell pidof com.darktheme.example
```

The syntax for this command is ‘adb shell pidof ***APP_BUNDLE_ID*’**

Note the PID that you see on the terminal window. (This can be used to verify whether the existing app process was killed and a new process was started when we resume the app)

4. Type the following terminal command to kill your app process

```bash
adb shell am kill com.darktheme.example
```

At this point, your terminal windows should look like this:

![Process kill commands entered in terminal](https://cdn-images-1.medium.com/max/2276/1*pYpZN8FbnrYeo_6QPGqc0g.png)

Now open your app from the background tasks and check whether the app crashes. If yes, don’t worry we will discuss how to deal with this issue in the next section. If not, give yourself a pat on the back because you deserve it :)

Note: After opening the app from the background, check the PID of the new process. If the PID that you noted down in Step 3 and the new PID are equal, the process was never killed.

## Proposed Solution

There are two ways of dealing with this issue. Depending upon the situation that you are in, you can decide which one to go forward with:

#### Solution 1:

An easy and convenient solution would be to check whether our existing app process was killed and recreated when the user resumes the app from the background. If yes, you can navigate back to the launch screen, so that it appears like a fresh app launch scenario.

You can place this following code in your BaseActivity:

```Kotlin
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (savedInstanceState != null) {
            // Get current PID
            val currentPID = android.os.Process.myPid().toString()
            
            // Check current PID with old PID
            if (currentPID != savedInstanceState.getString(PID)) {
                
                // If current PID and old PID are not equal, new process was created, restart the app from SplashActivity
                val intent = Intent(applicationContext, SplashActivity::class.java)
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                startActivity(intent)
                finish()
            }
        }
    }

    override fun onSaveInstanceState(bundle: Bundle) {
        super.onSaveInstanceState(bundle)
        bundle.putString(PID, android.os.Process.myPid().toString())
    }
```

* Save your PID in a bundle by overriding ‘onSaveInstanceState’ function.
* In the ‘onCreate’ method, compare the current PID and the PID from the bundle.
* Redirect to the Splash Activity, if the process was recreated.

When the user navigates back to the app from the background, if the app process was killed, the app would restart from the SplashActivity as if it is a fresh app launch.

This will prevent the app from accessing any resources that might have been lost during the process recreation and hence prevent the app from crashing.

While this solution would prevent a crash, this approach restarts the app rather than resuming the app from where it was left off. If you are facing this issue in a production app and are desperately looking for a quick fix, this solution should work fine for you.

However, if you have recently started development from scratch, solution 2 would be ideal for you since it will resume the app from where it was left off

#### Solution 2:

By now, you must have noticed that you can save and access data from ‘Bundle’ objects. Save all the necessary information in each Activity/Fragment similar to how we have done in the previous example.

Since we are accessing data that was saved in a bundle, the app crash should be prevented and the app should resume from where it was left off. All the other Activities/Fragments would also be recreated.

For a RecyclerView in a Fragment, it would look something like this:

```Kotlin
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val recyclerView = view.findViewById(R.id.recyclerView)
        recyclerView.layoutManager = LinearLayoutManager(context)
        users = savedInstanceState?.getParcelableArrayList("userList") ?: viewModel.getUsers()
        rv.adapter = DataAdapter(users, this)
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putParcelableArrayList("userList", users as ArrayList)
    }
```

* Save the required information in a Bundle object by overriding the ‘onSaveInstanceState’ function.
* Check whether data from the bundle is available in ‘onViewCreated’ function, otherwise, get data from source through ViewModel.

## Conclusion

App Crashes due to process-kill are very common on the Android platform. With newer Android versions, it is observed that background apps are killed aggressively to save on phone battery.

Solution 1 can work as a quick fix to your existing production crashes.

However, I would suggest Solution 2 if you are developing an app from scratch since it ensures that the app is resumed from where it was previously left off. Hence resulting in a better user experience.

Investing the root cause of such crashes could become difficult so I hope this article has helped you in any way possible. Let me know what you guys think about the solutions that we discussed.

That’s all for this article. Happy Coding!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
