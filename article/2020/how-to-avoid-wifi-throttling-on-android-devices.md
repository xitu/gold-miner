> * 原文地址：[How to Avoid WiFi Throttling on Android Devices](https://medium.com/better-programming/how-to-avoid-wifi-throttling-on-android-devices-494a0cc29dd8)
> * 原文作者：[Elvina Sh](https://medium.com/@navigine)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-avoid-wifi-throttling-on-android-devices.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-avoid-wifi-throttling-on-android-devices.md)
> * 译者：
> * 校对者：

# How to Avoid WiFi Throttling on Android Devices

![Photo by [Gaspart](https://dribbble.com/Gaspart) on [Dribbble](https://dribbble.com/).](https://cdn-images-1.medium.com/max/3200/0*LvG0BzxbMunbCN3Z.png)

Today, I want to discuss WiFi scan throttling in new Android versions and how to avoid it. [Previously, I wrote an article](https://proandroiddev.com/android-wifi-scanning-frustrations-799d1d942aea) about a new scan mechanism on the recently released Android R. If you read that article, you know that Google limits developers’ opportunities to scan WiFi as in previous Android versions.

So let’s start our article by reviewing how it worked earlier and how to get similar results now with new Android R.

## How It Worked Earlier

This part of the article will be simple and without any restrictions. There were not any restrictions including Android Oreo and you could scan every second without any throttling. Here is a simple code snippet explaining how it worked earlier:

```Java
mWifiBroadcastReceiver = new BroadcastReceiver()
{
  @Override public void onReceive(Context c, Intent intent)
  {
    try
    {
      // Your code here
    }
    catch (Throwable e)
    {
      Logger.d(TAG, 1, Log.getStackTraceString(e));
    }
  }
};
mContext.registerReceiver(mWifiBroadcastReceiver, new IntentFilter(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION));
```

You just register the broadcast receiver in your context for getting scan results and parse them. Then you call the `start scan` method on your WiFi manager and it works like a charm. There was a time when Android allowed scanning WiFi up to ten times per second. Just imagine the potential that opens up for high-quality navigation.

But then everything went wrong and Google introduced WiFi scan restrictions.

## Android 9 and 10

Upon the release of Android 9, Google presented a surprise to all developers. The WiFi scan was cropped as much as possible. Now you can start the scan only four times every 120 seconds. If you try to start the scan more times, then all your attempts will be throttled.

In my previous article, I described a solution for scanning with equal intervals and working with WiFi RTT, but it’s worth noting that you cannot avoid throttling altogether.

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

By the way, Google introduced a solution with the release of Android 10. They added a button that allows you to turn off the WiFi scan throttling in the Developer settings, so now you can turn it off and scan without restrictions. But if you write the common solution for all the devices, then you will not know if this option is turned off or not. And the main problem is devices with a custom OS (e.g. Huawei, Xiaomi, etc.) because they do not have the option for turning off throttling.

## Android R and the Solution

Android R was released a few weeks ago and Google introduced the new scan because the old one was deprecated with the release of Android 9. So now they added a function for checking if the throttling is turned off:

```Java

..
if (!mWifiManager.isScanThrottleEnabled()) {
  // scan without any restrictions
}
..
```

You just need to check that throttle is disabled and you can scan without any restrictions. By the way, this solution is only good if you test your local application. For distributing it through Play Market and other platforms, this solution could be very bad because users will need to turn on the Developer mode and find this option there.

## Conclusion

Google restricted frequent WiFi scans but added the option for turning off throttling. It looks like they understood their poor decision-making and are trying to somehow fix it. However, this still creates difficulties for both developers and users.

On the other hand, there is no way to scan WiFi on iOS at all, so we should be grateful for what we have.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
