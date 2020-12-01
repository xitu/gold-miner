> - 原文地址：[How to Avoid WiFi Throttling on Android Devices](https://medium.com/better-programming/how-to-avoid-wifi-throttling-on-android-devices-494a0cc29dd8)
> - 原文作者：[Elvina Sh](https://medium.com/@navigine)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-avoid-wifi-throttling-on-android-devices.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-avoid-wifi-throttling-on-android-devices.md)
> - 译者：[regon-cao](https://github.com/regon-cao)
> - 校对者：[zenblo](https://github.com/zenblo) [NieZhuZhu](https://github.com/NieZhuZhu)

# 如何避免 Android 设备的 WiFi 扫描节流

![Photo by [Gaspart](https://dribbble.com/Gaspart) on [Dribbble](https://dribbble.com/).](https://cdn-images-1.medium.com/max/3200/0*LvG0BzxbMunbCN3Z.png)

今天我想讨论一下关于新版本 Android 的 WiFi 扫描节流以及该如何避免它。[我曾经写过一篇文章](https://proandroiddev.com/android-wifi-scanning-frustrations-799d1d942aea)是关于最近发布的 Android R 版本的扫描机制。如果你读过这篇文章，你会了解到，与之前的 Android 版本相比，Google 限制了开发者们在新版本上调用 WiFi 扫描的频率。

我们首先了解之前 WiFi 扫描的工作方式，然后再阐述如何在 Android R 版本上得到与之前一样的效果。

## 之前的做法

之前的做法很简单而且没有任何节流限制，包括 Android Oreo 在内都可以不被限制的每秒扫描一次。下面一段简单的代码解释了之前的工作方式：

```Java
mWifiBroadcastReceiver = new BroadcastReceiver()
{
  @Override public void onReceive(Context c, Intent intent)
  {
    try
    {
      // 写上你的代码
    }
    catch (Throwable e)
    {
      Logger.d(TAG, 1, Log.getStackTraceString(e));
    }
  }
};
mContext.registerReceiver(mWifiBroadcastReceiver, new IntentFilter(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION));
```

你只需要在上下文中注册一个广播接收者用来获得和解析扫描结果，然后在 WiFi 管理器上调用 `start scan` 方法，一切就 OK 了。此时的 Android 允许 1 秒钟扫描 10 次 WiFi。你可以想象一下为高精度导航开辟的潜力。

Google 引入了对 WiFi 扫描的节流之后，事情就变的不对劲了。

## Android 9 和 10

在 Andorid 9 的发布上，Google 给了所有开发者一个 “惊喜”。WiFi 扫描被尽可能地限制了，现在 120 秒只能扫描 4 次 WiFi。

在之前的文章中，我描述了一个等间隔扫描和 WiFi RTT 工作的解决方案，但是值得注意的是，它并不能完全避免节流。

```Java
if (!mWifiScanning && timeNow > mWifiLastTime + WIFI_SLEEP_TIMEOUT)
{
  if (mWifiBroadcastReceiver != null && !mWifiRegistered)
  {
    mContext.registerReceiver(mWifiBroadcastReceiver, new IntentFilter(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION));
    mWifiRegistered = true;
  }

  if (mWifiManager.startScan())
  {
    mWifiTime = timeNow;

    try
    {
      mContext.unregisterReceiver(mWifiBroadcastReceiver);
      mWifiRegistered = false;
    } catch (Throwable e) { }
  }
}
```

顺便提一下，在 Android 10 中 Google 提供了一个解决方案。在开发者模式下他们提供了一个可以关闭 WiFi 节流的按钮，所以你可以关闭它并且不再受到节流的限制。但是如果你为所有设备编写一套通用的解决方案，你事先并不知道设备有没有关闭节流限制，最主要的问题是一些自定义的操作系统（例如华为，小米等）并没有提供关闭节流限制的选项。

## Android R 的解决方案

在几周前发布的 Android R 中，Google 引入了新的扫描机制，旧的扫描机制在 Android 9 中已经被废弃了。现在我们只需要添加一个检测节流是否关闭的方法即可：

```Java

..
if (!mWifiManager.isScanThrottleEnabled()) {
  // 扫描不再受限制
}
..
```

在判断节流关闭后我们就可以不受限制的调用扫描了。与此同时，这个方法只在本地测试应用的时候是可行的。对于通过应用市场或其他平台发布的应用, 用户体验会很糟糕因为他们需要打开设备的调试模式并找到开关在哪里。

## 结论

Google 限制了 WiFi 的扫描频率，但是又为我们提供了关闭这个限制的选项。他们似乎意识到了这个决策的问题并正在试图修复它。然而这一举动还是给开发者和用户带来了不少的麻烦。

另一方面，在 iOS 上是不能调用 WiFi 扫描的，所以我们应该感激我们所拥有的。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
