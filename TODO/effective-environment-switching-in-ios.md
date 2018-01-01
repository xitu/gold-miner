> * 原文地址：[Effective Environment Switching in iOS](https://medium.com/@volbap/effective-environment-switching-in-ios-6df0b08e9556)
> * 原文作者：[Pablo Villar](https://medium.com/@volbap?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/effective-environment-switching-in-ios.md](https://github.com/xitu/gold-miner/blob/master/TODO/effective-environment-switching-in-ios.md)
> * 译者：
> * 校对者：

# Effective Environment Switching in iOS

![](https://cdn-images-1.medium.com/max/2000/1*phOfJPH1G1VTDfpyqVlkow.jpeg)

### Introduction

Engaging gears in a project involves powering up our everyday processes. In the iOS world, a very important one is how we deal with **environments** and other **settings** that need to be customized depending on the audience. Xcode does have a set of tools to help us along the way. Unfortunately, though, I've seen that most of the times teams are not even close to take the best of these tools. It's not their fault: I think Apple doesn't do very well at encouraging good practices, as they just provide _not-so-useful_ configurations by default.

In this article, we'll explore how we can take advantage of Xcode configurations, and how we can define our app's settings in an organized way.

### Xcode Configurations

The way Xcode can package different settings into your builds is through configurations. Roughly speaking, a configuration is just a bunch of settings that define how the compiler must create the build. The IDE lets you customize some settings depending on the different configurations. You've very likely seen these:

![](https://cdn-images-1.medium.com/max/800/1*3M9G9pHYcupklR3xdFX7PA.png)

… and so on.

#### Debug vs. Release

These are the two configurations that Xcode gives us by default. Of course, you can create your own, but this isn't a common practice since there aren't _universal_ conventions adopted by the iOS community about which configurations could be useful to have depending on the project.

These two default configurations have several differences, which I'm not going into detail here, but can be summarized in:

> In a **debug** build, the complete symbolic debug information is emitted to help while debugging applications and also the code optimization is not taken into account (faster build times). Whereas, in **release** build, the debug info is not emitted and the code execution is optimized (slower build times).

As for their usage, **debug** is the configuration we normally use in our everyday life, whereas **release** is what we use to distribute our apps to other people: testers, project managers, customers, the world.

The point is that, these two are usually not enough. What's more, devs often mislead ≪_debug vs. release_≫ with ≪_staging vs. production_≫, concepts that should not be mixed up.

#### We can do better

Some projects work with different environments: development, staging, production, pre-production, etc. Take whatever you want. This classification doesn't have a natural connection with the two default configurations we've discussed above. Even if we tried to force this correspondency, it wouldn't always work out very well. For instance, if you want to prepare a **_release_** build, it doesn't mean it should point to a **_production_** server: Take the situation where you have to prepare a release build for QA which needs to be tested against a staging server. Default configurations just won't work.

In consequence, I propose replacing the basic debug & release configurations by others that could help us a bit more. To keep it simple, I'll only include staging and production environments in this approach, but you'll observe that it's very easy to add more environments as you need them.

#### Let's redefine configurations

We can define these 4 configurations instead:

* Debug Staging
* Debug Production
* TestFlight Staging
* TestFlight Production

By just reading their name, you might have guessed what they are about. Here are the details:

* The first two of them (Debug Staging & Debug Production) behave as the original Debug configuration, but **each one points to a different environment**.
* Something similar happens with the last two (TestFlight ones). They behave as the original Release one, including compiler optimizations and excluding debug information, but **each one works on its corresponding environment**.

![](https://cdn-images-1.medium.com/max/800/1*E24WkTnP6IXFceTvE3MtxQ.png)

It's very simple to achieve this. Just go to your Project Settings > Info > Configurations, and hit the + button. Duplicate the Debug configuration and rename the original one to “Debug Staging” and the new one to “Debug Production”. Do the proper with Release too.

You should end up with something like this:

![](https://cdn-images-1.medium.com/max/1000/1*TalswynK3oCREkrhNBJGlg.png)

A project that has 4 different configurations

#### The Fifth Element

There is a reason why I chose to call the release configurations “_TestFlight_” instead of “_Release_”. There might be certain events in your code that need to happen only when the app is used by final users, not by testers or customers. A clear example is the usage of analytics to track events. It could be a requirement that event tracking should only be applied to final users, not to testers under production environments. In this case, we are talking about a _TestFlight Production_ configuration with some subtle differences, hence the need for a distinction. Introduce our fifth configuration:

* AppStore

This configuration can be quickly duplicated from TestFlight Production. Notice that you won't always need it, as you could not have to perform anything different than when on TestFlight Production.

Now, you might wonder **how you can manage different things to happen in your app depending on the selected configuration**. That's explained in the next section.

### Custom Settings

There are many ways to achieve what we need: Perform different actions based on which configuration is selected. There are precompiler directives, environment variables, different plist files, and more. Each one has its pros and cons. I'll just focus on the way I use to do it, which I consider a very clean one.

Those different actions that need to be done depending on the configuration can usually be encapsulated into variables, which will define our app's behavior. These variables are usually called **settings**. Example of settings are: the server's API's base URL, the Facebook App ID, the logs' detail level, whether or not offline access is enabled, etc.

Next up, I'll show you the way I currently manage custom settings to vary depending on the selected configuration, which I consider a very convenient approach so far, based on my experience.

#### Settings.swift

The app's custom settings can be easily accessible through a singleton.

```
struct Settings {
    static var shared = Settings()
    let apiURL: URL
    let isOfflineAccessEnabled: Bool
    let feedItemsPerPage: Int
    private init() {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let plist = NSDictionary(contentsOfFile: path) as! [AnyHashable: Any]
        let settings = plist["AppSetings"] as! [AnyHashable: Any]
        
        apiURL = URL(string: (settings["ServerBaseURL"] as! String))!
        isOfflineAccessEnabled = settings["EnableOfflineAccess"] as! Bool
        feedItemsPerPage = settings["FeedItemsPerPage"] as! Int
        
        print("Settings loaded: \(self)")
    }
}
```

This struct is in charge of reading and storing the settings (that we'll later define in the app's `Info.plist` file) so that they are available from anywhere in the codebase. I prefer to perform force unwraps here since if a setting is missing, I don't want my app to run.

#### Info.plist

We will define our settings in the `Info.plist` file. I recommend using a separate dictionary entry to group them all:

![](https://cdn-images-1.medium.com/max/1000/1*NlmqO1X2mvioMWhj9swBXg.png)

So far, we have set up a clean way to retrieve our app's settings. However, they don't vary among configurations yet. We're almost there.

#### User-Defined Settings

Let's think. What things normally change depending on the configuration in any project? Well, there is the compiler optimization level, there are the header search paths, the provisioning profiles, and much more. Wouldn't it be nice if we could define our own custom _things-that-vary-upon-selected-configuration_? Well, it turns out that we can, by creating User-Defined Settings.

![](https://cdn-images-1.medium.com/max/800/1*ilzKZsI_BCcgal5tzhkUWw.png)

Creating User-Defined settings is very easy, just go to your Target > Build Settings, hit the + button, and select “Create User-Defined Setting”. They can be created at the project level too; I just consider the target level to be a better fit for them.

Since your User-Defined Settings may have to live together with others that you haven't created, it's recommended that you use a prefix convention to name yours.

![](https://cdn-images-1.medium.com/max/800/1*25yr4QF6vBFNK2F1DOh6nw.png)

I used my initials here to prefix my User-Defined Settings. I suggest using the project's name initials.

Now, to refer to one of these from the `Info.plist` file, you just do it like this:

```
$(YOUR_USER_DEFINED_SETTING_NAME)
```

#### Integrating them all

This is where the magic occurs: You can replace all the fixed strings from the `Info.plist` entries that correspond to your settings with their corresponding references to each User-Defined Setting. You will need one User-Defined Setting for each custom setting that you have.

![](https://cdn-images-1.medium.com/max/1000/1*UMNV9ZDKIjr3J3UpWKOIbA.png)

When the `Info.plist` file is compiled, it'll take all the settings values that correspond to the selected configuration, and these will be fixed on each entry at compile time.

Now, you can _nicely_ refer to any setting from anywhere in your code like this:

```
if Settings.shared.isOfflineAccessEnabled {
    // do stuff
}
```

Finally, selecting which configuration to compile with is a piece of cake, either from Xcode:

![](https://cdn-images-1.medium.com/max/800/1*D5Z2ipWESxi1MW5s0xvmMw.png)

Or from CLI:

![](https://cdn-images-1.medium.com/max/800/1*MHK2NWnxjk0rPY4mFuzAZQ.png)

### Wrapping Up

By using this approach, we have gained these benefits:

* Organized builds workflow.
* Organized way to manage app's custom settings.
* Flexibility to change settings depending on the configuration.
* Easiness with continous integration (given that selecting which configuration to compile with is easily doable in command line tools).

However, there are some caveats that are worth the mention:

* There is no flexibility to change settings at run time, as they are packaged with the build at compile time.
* Switching often between configurations is not that nice: Xcode creates a build from scratch each time you change the build configuration, which means having to wait for the entire project to recompile in that case.
* Settings can only be modified through the `.xcodeproj`; there is no flexibility to change their values [_nicely_](https://hackernoon.com/system-settings-9ed72d5ef629) from the outside.
* User-Defined Settings are [**exposed to anyone that has access to the code**](https://medium.freecodecamp.org/how-to-securely-store-api-keys-4ff3ea19ebda)**,** so it's not a recommended place to put any key.

These pitfalls can be solved, though. The aim so far was just to improve our usage of these tools when coming from an almost zero-knowledge base. Mitigating these issues implies applying some modifications that complicates things a bit further, and they are out of the scope of this article, as I didn't want it to become too overwhelming. But believe me, we’ve done a lot. **In an upcoming second part, we will explore how to face these issues and take our projects to the next level…**

To be continued.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
