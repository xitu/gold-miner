>* 原文链接 : [Detecting low power mode](http://useyourloaf.com/blog/detecting-low-power-mode/)
* 原文作者 : [useyourloaf](http://useyourloaf.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Zheaoli](https://github.com/Zheaoli)
* 校对者 : [LoneyIsError](https://github.com/LoneyIsError), [wild-flame](https://github.com/wild-flame)


这个星期，我阅读了一篇关于Uber怎样检测手机处于省电模式的文章。（注：文章连接是[Uber found people more likely to pay](http://www.npr.org/2016/05/17/478266839/this-is-your-brain-on-uber)） 在人们手机快要关机时，使用Uber可能会面临更高的价格。 这家公司（注：指Uber）宣称他们不会利用手机是否处于节能模式这一数据来进行定价， 但是这里我想知道 **我们怎么知道用户的iPhone处于低电量模式**


### 低电量模式

在iOS 9中，苹果为iPhone手机新添加了 [低电量模式](https://support.apple.com/en-gb/HT205234) 功能。在你能充电之前，低电量模式通过关闭诸如邮件收发，Siri，后台消息推送能耗电功能来延长你的电池使用时间。

在这里面，很重要的一点是，是否进入低电量模式是由用户自行决定的。 你需要进入电池设置中去开启低电量模式。当你进入低电量模式的时候，状态栏上的电池图标会变成黄色。

![Low Power Mode](http://ww3.sinaimg.cn/large/72f96cbajw1f4dvuztcnej20m80et0u9)

当你充电至80%以上时，系统会自动关闭低电量模式。

### 低电量模式检测

事实证明，在iOS 9中获取低电量模式信息是很容易的一件事。 你可以通过**NSProcessInfo**这个类来判断用户是否进入了低电量模式：

~~~ Swift
    if NSProcessInfo.processInfo().lowPowerModeEnabled {
      // stop battery intensive actions
    }

~~~

如果你想用Objective-C来实现这个功能:

~~~ Objective-C
    if ([[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
      // stop battery intensive actions
    }

~~~

如果你监听了**NSProcessInfoPowerStateDidChangeNotification**通知，在用户切换进入低电量模式的时候你将接收到一个消息。比如，在视图控制器中的**viewDidLoad**方法中:

~~~ Swift
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: #selector(didChangePowerMode(_:)),
      name: NSProcessInfoPowerStateDidChangeNotification,
      object: nil)
~~~

~~~ Objective-C
    [[NSNotificationCenter defaultCenter] addObserver:self
      selector:@selector(didChangePowerMode:)
      name:NSProcessInfoPowerStateDidChangeNotification
      object:nil];
~~~

在我第一次发布这篇文章后，很多人提醒我：对于只对iOS 9.X适配的开发者而言，没有必要在 **ViewController** 消失时去移除 **Observer** 。

接着在这个方法会监视电池模式并在切换的时候给予一个响应。

~~~ swift
    func didChangePowerMode(notification: NSNotification) {
        if NSProcessInfo.processInfo().lowPowerModeEnabled {
          // low power mode on
        } else {
          // low power mode off
        }
    }
~~~

~~~ Objective-C
    - (void)didChangePowerMode:(NSNotification *)notification {
      if ([[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
        // low power mode on
      } else {
        // low power mode off
      }
    }
~~~
小贴士:

*   这个通知方法和NSProcessInfo里的属性是在iOS 9系统中新提供的方法。如果你想让你的APP兼容iOS8或者更早版本的系统，你需要去这个网站 [test for availability](http://useyourloaf.com/blog/checking-api-availability-with-swift/)测试你的代码是否能正常运行。

*   低电量模式是iPhone独有的特性，如果你在iPad上测试前面的代码，会一直返回false。


只有在你的 App 能够采取一些节能措施来延长电池寿命的情况下，检测用户开启了低电量模式才是有用的。这里，苹果给了一些建议：



*   停止更新位置
*   减少用户交互动画
*   关闭数据流量这样的后台操作
*   关闭特效
