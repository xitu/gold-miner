>* 原文链接 : [Detecting low power mode](http://useyourloaf.com/blog/detecting-low-power-mode/)
* 原文作者 : [useyourloaf](http://useyourloaf.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

I read a story this week about the Uber App knowing when your phone is in power saving mode. [Uber found people more likely to pay](http://www.npr.org/2016/05/17/478266839/this-is-your-brain-on-uber) higher rates when their phone is about to die. The company claims they do not use the data to set prices but it got me wondering **how can you detect low power mode with iOS?**

### Low Power Mode

With iOS 9 Apple added a [Low Power Mode](https://support.apple.com/en-gb/HT205234) to the iPhone. It extends battery life by stopping some battery heavy features such as email fetch, Hey Siri and background app refresh until you can recharge the device.

It is important to understand that it is the user who decides to enter low power mode. You need to go into the battery settings to turn it on. When you do the battery in the status bar turns yellow:

![Low Power Mode](http://ww3.sinaimg.cn/large/72f96cbajw1f4dvuztcnej20m80et0u9)

It turns off automatically once you charge the device to 80%.

### Detecting Low Power mode

It turns out that it is easy to test for low power mode in iOS 9\. You can check if the user has switched to low power mode from the `NSProcessInfo` class:

    // Swift
    if NSProcessInfo.processInfo().lowPowerModeEnabled {
      // stop battery intensive actions
    }

If you are doing this in Objective-C:

    // Objective-C
    if ([[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
      // stop battery intensive actions
    }

To respond when the user changes the mode you need to listen for the `NSProcessInfoPowerStateDidChangeNotification` notification. For example, in the `viewDidLoad` method of a view controller:

    // Swift
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: #selector(didChangePowerMode(_:)),
      name: NSProcessInfoPowerStateDidChangeNotification,
      object: nil)

    // Objective-C
    [[NSNotificationCenter defaultCenter] addObserver:self
      selector:@selector(didChangePowerMode:)
      name:NSProcessInfoPowerStateDidChangeNotification
      object:nil];

_As somebody reminded me after I first posted this it is not necessary to remove the observer when the view controller goes away as long as we are only targetting iOS 9._

Then in the action check the power mode and respond:

    // Swift
    func didChangePowerMode(notification: NSNotification) {
        if NSProcessInfo.processInfo().lowPowerModeEnabled {
          // low power mode on
        } else {
          // low power mode off
        }
    }

    // Objective-C
    - (void)didChangePowerMode:(NSNotification *)notification {
      if ([[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
        // low power mode on
      } else {
        // low power mode off
      }
    }

Notes:

*   The notification method and the property on NSProcessInfo are new in iOS 9\. If you are supporting iOS 8 or earlier you will need to [test for availability](http://useyourloaf.com/blog/checking-api-availability-with-swift/) before using either.

*   Low power mode is an iPhone only feature. Testing for it on an iPad will always return false.

Detecting that the user has turned low power mode on is only useful if your app is able to take some energy-saving measures to prolong battery life. Some suggestions from Apple:

*   Stop location updates
*   Limit the use of animations
*   Stop background activities such as networking
*   Disable motion effects

