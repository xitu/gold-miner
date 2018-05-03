> * 原文地址：[Managing different environments in your Swift project with ease](https://medium.com/flawless-app-stories/manage-different-environments-in-your-swift-project-with-ease-659f7f3fb1a6)
> * 原文作者：[Yuri Chukhlib](https://medium.com/@YuriD4?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/manage-different-environments-in-your-swift-project-with-ease.md](https://github.com/xitu/gold-miner/blob/master/TODO1/manage-different-environments-in-your-swift-project-with-ease.md)
> * 译者：
> * 校对者：

# Managing different environments in your Swift project with ease

![](https://cdn-images-1.medium.com/max/2000/1*Rk8JulyapCiTCUtLsnsEcQ.png)

Imagine that you have completed development and testing of your app and now you’re ready to submit it for production release. But here is the problem: all your API keys, URLs, icons or other setups are configured for the test environment. So before submitting your app, you will have to modify all these things to fit your production mode. Obviously, it does not sound very good. Also, you might forget to change something in your huge app, so your services won’t work as they should.

Instead of such messy approach, it would be much better to have several environments and simply change them when needed. Today we will run through the most popular methods where we will try to organise different environments:

1.  **Using comments.**
2.  **Using global variable or Enum.**
3.  **Using configurations and schemes with a global flag.**
4.  **Using configurations and schemes with several *.plist files.**

### 1. Using comments

When you have 2 separated environments, your application needs to know to which environment it should connect. Imagine, you have `Production`, `Development` and `Staging` environments and API endpoints. The fastest and the easiest way to handle this is to have 3 different variables and to comment 2 of them:

```
// MARK: - Development
let APIEndpointURL = "http://mysite.com/dev/api"
let analyticsKey = "jsldjcldjkcs"

// MARK: - Production
// let APIEndpointURL = "http://mysite.com/prod/api"
// let analyticsKey = "sdcsdcsdcdc"
// MARK: - Staging
// let APIEndpointURL = "http://mysite.com/staging/api"
// let analyticsKey = "lkjllnlnlk"
```

This approach is very dirty, messy and will make you cry a lot. Sometimes I use it on hackathons, when the quality of code doesn’t play any role and only speed & flexibility matter. In any other cases, I highly recommend you not to use it at all.

### 2. Using global variable or Enum

Another popular approach is to have a global variable or `Enum` (this one will be much better) to handle different configurations. You will have to declare your `Enum` with 3 environments and somewhere (in the `AppDelegate` file for example) set its value:

```
enum Environment {
    case development
    case staging 
    case production
}
 
let environment: Environment = .development
 
switch environment {
case .development:
    // set web service URL to development
    // set API keys to development
    print("It's for development")
case .staging:
    // set web service URL to staging
    // set API keys to development
    print("It's for staging")
case .production:
    // set web service URL to production
    // set API keys to production
    print("It's for production")
}
```

This approach requires you to set your environment only once in the code every time you want to change it. Comparing with the previous method, this one is a much better. It’s very quick, more/less readable but it has a lot of limitations. First of all, while running any environment you always have the same Bundle ID. It means you won’t be able to have 2 same apps with different environments on your device at the same time. It’s not comfortable at all.

Also, it’s a nice idea to have different icons for every environment, but with this approach you won’t be able to change your icons. And again, if you forget to change this global variable before publishing the app, you will definitely have problems.

* * *

Let’s move to implementing two more approaches for fast switch between our builds. These methods are suitable for both new and existing large projects. So you can easily use one of your existing projects to follow along in this tutorial.

After applying these approaches your app will have the same codebase for every environment, but you will be able to have different icons and different Bundle ID’s for every configuration. The distribution process also will be very easy. And what is the most important, your managers and testers will be able to have all your environments as separated apps on their devices. So they will fully understand which version they’re trying out.

### 3. Using configurations and schemes with a global flag

In this approach we will have to create 3 different configurations, 3 different schemes, connect schemes with their configurations. To do this I will create a new project “Environments”, you may also create a new project or do it in the existing one.

Go to project’s settings in the Project Navigator panel. Under the Targets sections, right click the existing target and select Dublicate to copy your current target.

![](https://cdn-images-1.medium.com/max/800/0*kJt7iX0pJ_OCbYH7.)

Now we have one more target and one more build scheme which is called ‘Environments copy’. Let’s rename it to a proper name. Just left click on your new target and press “Enter” to change its name to ‘Environments Dev’.

Next, go to “Manage Schemes…”, select the new scheme created in the previous step and press “Enter”. Also make its name the same to your target’s name to avoid any mess with naming.

![](https://cdn-images-1.medium.com/max/800/0*pAV3RMB8AJBsTIgL.)

Also let’s create a new icon asset, so testers and managers will know what app configuration they launch.

Go to Assets.xcassets, click on “+” and choose “New iOS App Icon”. Change its name to “AppIcon-Dev”.

![](https://cdn-images-1.medium.com/max/800/0*Wuq-Rd6IHVMAgTm0.)

Now we have to connect this new icons asset with our Dev environment. Go to “Targets”, left click your Dev environment, find “App Icon Source” and choose your new icons asset.

![](https://cdn-images-1.medium.com/max/800/0*LyxuDi3gg8Ca69p7.)

That’s it, now you have different icons for every configuration. Please note, when we created the second configuration, the second *.plist file was also generated for our second environment.

Important notice: now we have 2 different approaches how to handle 2 different configurations:

1.  **To add a preprocessing macro/compiler flag for both production and development targets.**
2.  **To add variables right into the *.plist.**

We will run through both methods starting from the first one.

To add a flag that indicates a development environment, select the development target. Go to “Build Settings” and find a “Swift Compiler — Custom Flags” section. Set the value to `-DEVELOPMENT` to mark your target as a development build.

![](https://cdn-images-1.medium.com/max/800/0*Henhnxiv07NEtDkk.)

And your configurations handling will look something like this in the code:

```
#if DEVELOPMENT
let SERVER_URL = "http://dev.server.com/api/"
let API_TOKEN = "asfasdadasdass"
#else
let SERVER_URL = "http://prod.server.com/api/"
let API_TOKEN = "fgbfkbkgbmkgbm"
#endif
```

Now if you select the Dev scheme and run your project, you will automatically run your app with the development configurations set.

### 4. Using configurations and schemes with several *.plist files

In this approach we should repeat all the steps to create several schemes and configurations from the previous approach. After that, instead of adding a global flag we will add necessary values right into our *.plist files. Also, we will add a `serverBaseURL` variable of a String type in every of 2 *.plist files and fill it with URLs. Now every *.plist file contains a URL and we have to call it from the code. I think, it would be a nice idea to create an extension for our Bundle like the following:

```
extension Bundle {
    var apiBaseURL: String {
	return object(forInfoDictionaryKey: "serverBaseURL") as? String ?? ""
    }
}

//And call it from the code like this:
let baseURL = Bundle.main.apiBaseURL
```

Personally, I like this approach more because here you shouldn’t check your configurations in the code at all. You simply ask your main Bundle for a row, and it returns a value depending on its current configuration.

#### Some moments while using several Targets

*   Remember that your data stored in a *.plist file may be read and potentially is very unsafe. As a solution, add your sensitive keys in the code and leave only its keys in the *.plist file.
*   While adding a new file don’t forget to select both targets to keep your code synced in both configurations.
*   If you use continuous integration services such as [Travis CI](https://travis-ci.org/) or [Jenkins](https://jenkins-ci.org/), don’t forget to configure them in a proper way.

### Conclusion

It’s always useful to separate your app environments in a readable and flexible way from the very beginning. Even with the simplest techniques we can avoid typical problems in handling many configurations and significantly improve our code quality.

Today we briefly covered several approaches starting from the simplest. But there are a lot of other possible ways to organise many configurations. And I would love to read about your approaches in the comments section below.

Thanks for reading :)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
