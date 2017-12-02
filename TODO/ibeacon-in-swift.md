
> * 原文地址：[A Guide to Interacting with iBeacons in iOS using Swift](https://spin.atomicobject.com/2017/01/31/ibeacon-in-swift/)
* 原文作者：[MATT NEDRICH](https://spin.atomicobject.com/author/nedrich/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[lovelyCiTY](https://github.com/lovelyCiTY)
* 校对者：[Gocy015](https://github.com/Gocy015)、[Danny1451](https://github.com/Danny1451)

#iOS 开发中使用 Swift 进行 iBeacons 交互指南


我最近致力于研究一个关于 [iBeacons](https://developer.apple.com/ibeacon/) 的 iOS 项目。本文中，我将全面的介绍如何使用 [Swift](https://developer.apple.com/swift) 进行 iOS 项目中 iBeacons 开发。我将介绍 iBeacons 是什么，如何进行使用以及在 iOS 项目中开发 iBeacons 交互你应该知道的编程模型。同时，我将分享一些在开发中学到的最佳实践方案。


##iBeacons 是什么

iBeacons 是一类使用 iBeacon 协议持续向周围发送自身标识信息的低功耗蓝牙设备。它们总是被放置在物理世界中（通常为室内）人们感兴趣的一些地方。当设备移动到一定范围内时，手机应用会收到推送并作出相应的响应。

你也许读过一些文章声称 iBeacons 是一种室内 GPS 信号不稳定时，取代 GPS 进行室内定位的解决方案。虽然这个的说法绝大部分是正确的，但是不能肯定的认为 iBeacons 是一个 GPS 完美的替代方案。他们在操作的模型和位置感知的准确性上比起传统的 GPS 有着相当大的区别。即便如此，带着一点创造性，你依然可以使用 iBeacons 做一些相当酷的事情。

## iBeacon 的应用

在我们了解 iBeacons 如何工作之前，讨论一下它的使用方法也许有些必要。现在有多种多样的 iBeacons 应用，我喜欢把他们分成两大类：1. 推送感知场景的信息 2.定位追踪。

### 推送感知场景的信息

当用户移动到他们感兴趣的区域时，iBeacons 可以用来给他们推送信息。博物馆就是一个典型的例子，设想在每一个展品的位置放置一个 iBeacons 设备，当用户走近展品的时候，手机应用自动展示看到展品的更多信息会有多棒! 这就需要手机应用侦听发射器来了解有哪些发射器接近哪些展品，通过这样的匹配，发射器将定位用户在博物馆中的位置并让应用做出合理的响应。

### 定位追踪

作为推送感知场景的信息概念的扩展，你也可以使用 iBeacons 作为一种追踪用户的方式。设想在一个博物馆或者杂货店的建筑中遍布 iBeacons ，随着用户的移动，由他们通过发射器的顺序，你可以侦测出他们的移动轨迹。这允许你追踪用户的行踪，并且总结出最普遍的行进路线和行进模式。

当然，除了那些简单的例子外这里还有数之不尽的 iBeacons 应用-[这个网站](http://blog.mowowstudios.com/2015/02/100-use-cases-examples-ibeacon-technology/) 很好地罗列出了这些项目。

## iBeacon 寻址方案

如果你过去开发过低功耗蓝牙设备，你也许熟悉蓝牙广播包的概念。iBeacons 本质上只是一个发送广播包的低功耗蓝牙设备。当广播包广播出去，其广播包中包含三个值：一个 **UUID**、一个 **主要值**和一个**次要值**。这三个数字组合起来定义一个 iBeacon 设备的唯一标识并且它是可以由用户进行配置的。

将 UUID 连同主要值以及次要值组合起来是一个很好地寻址方案。设想如果像沃尔玛这样的零售商在所有的商店里配置 iBeacons 设备，他们或许选择一个唯一的 UUID 来指代沃尔玛并且沃尔玛中的所有 iBeacons 都会使用这个 UUID(这使得 UUID 变得不再特殊，但是好像这是 iBeacons 中很常见的寻址方式).之后他们可以使用 iBeacons 的主要值来指代商店的编号和次要值去区别商店所在的不同的部门或区域。

## iBeacon 的制造商

iBeacons 的命名是因为苹果定义的 iBeacons 协议（比如广播出去的那些广播数据的形式），但是，他们并不是苹果生产或出售的。

而有几家公司是成产和销售 iBeacons 的，并且每一个生产商都有一点不同，比较主流的生产商包括 [Estimote](http://estimote.com/) 、 [Aruba](http://www.arubanetworks.com/products/mobile-engagement/aruba-beacons/?source=sem&amp;gclid=CMrEzpLaytECFVhYDQodPZ0AKg) 和 [Radius Networks](https://www.radiusnetworks.com/) .如果你正在打算使用 iBeacons ，上边的任何一家都会是个不错的选择。我个人曾使用过 Estimote 和 Radius Networks 两家公司的设备，所以我可以讲一下关于他们更多的细节。

下边是一些关于 Estimote 和 Radius Networks 两家生产商 iBeacons 的图片。

![](https://spin.atomicobject.com/wp-content/uploads/20170119182038/estimote-beacon2.jpg)

Estimote iBeacons

![](https://spin.atomicobject.com/wp-content/uploads/20170119181625/radius-networks-beacons.jpg) 

Radius Networks iBeacons.可拆卸式顶部能让你更简单地更换电池。

Radius Networks 的设备很好用因为你可以随意的打开和关闭并且可以方便地更换电池。 Estimote 的设备的电池使用寿命更久，但是当电量用完之后更换起来很麻烦，而且想关闭一个正在广播中的 Estimote 设备可不那么简单。

注：这还有几个和 iBeacons 相似的协议，比如 [Eddystone](https://en.wikipedia.org/wiki/Eddystone_(Google))，大部分的设备厂商生产的设备都是可以支持广播多种协议的。

###可配置性

当你购买了 iBeacons ，制造商通常会提供一个手机应用来帮助你对它进行相关的设置。你可以在应用中对 iBeacons 的 UUID 以及主要值和次要值进行设置，调整他们广播的速率和蓝牙广播的强度。一些设备上并不提供手机应用或者其他便捷的方式来配置他们生产的 iBeacons 。 如果没有什么特别的理由，我推荐你不要购买这些厂商的 iBeacons 。

下边是 Estimote 和 Radius Networks 两个厂商的 iBeacons 配置应用中的一些截图。

#### Estimote 应用配置截图

![](https://spin.atomicobject.com/wp-content/uploads/20170119182212/ea2.jpg)

![](https://spin.atomicobject.com/wp-content/uploads/20170119182215/ea3.jpg) 


在 Estimote 厂商的应用中，你可以在截图中看到调整设备的广播比率和蓝牙广播强度的设置。	 

#### Radius Networks 应用配置截图
![](https://spin.atomicobject.com/wp-content/uploads/20170117223648/rna1.jpg)

![](https://spin.atomicobject.com/wp-content/uploads/20170117223650/rna2.jpg) 

除了手机应用外，厂商之间的 iBeacons 还有如下的区别。当在选择 iBeacons 时，你应该去考虑如下的因素，因为厂商间趋向于在这些方便有所区别：

- 设备的电池寿命

- 设备的电池是否可更换

- 信号的最大、最小范围

- 设备是否有关闭的功能，至少是能否让他们停止广播

- 对其他协议的是否支持(比如 Eddystone)

- SDK 功能的完善性（如果一个存在你正打算使用的功能）

## iOS 编程模型

我们已经讨论了 iBeacons 是什么，如何工作并且比较了不同厂商的区别。现在让我们来看下一下 iOS 编程中和他们进行交互的模板。

iBeacons 的所有功能都是有 iOS 中的 CoreLocation 库提供，由于 iBeacons 其实是蓝牙设备，这个封装其实非常有趣。开发者无需了解抽象的库内部本质上其实是蓝牙设备的信号发射器。


### 权限

在你的应用中使用 iBeacons ，用户必须允许访问位置权限。你可以通过在 `Info.plist` 文件中添加指定键值来提示用户准许权限。`NSLocationWhenInUseUsageDescription` 关键词将在应用处于前台时提示用户打开他们的位置权限。如果你的应用需要在处于后台时接收 iBeacons 位置的推送，需要使用 `NSLocationAlwaysUsageDescription` 关键词进行替代。

设置好这些键值之后，你还需要在应用唤起时，在你的 CLLocationManager 实例中调用 requestWhenInUseAuthorization() 方法或者 requestAlwaysAuthorization() 方法。


### iBeacon 监听模式

接收 iBeacon 的通知有两种模型 ：**监听** 和 **范围**，他们之间有着很大的区别。你应该依据项目的需求，使用其中的一个或者全部都进行使用。


#### 监听

监听是两种模型中比较简单的一个，它可以在你的应用进入或者离开的一个区域的时候进行提醒。为了监听这些事件，需要实例化 `CLLocationManager` 类并且实现 `didEnterRegion` 和 `didExitRegion` 这两个代理方法。我的使用经验是退出事件可能会在你离开一个区域后推迟大概 30 秒后才会执行。但是进入一个区域的事件基本上在进入一个区域时马上就会触发，基本上是没有延迟的。如果你一开始是就是在一个区域中的，那么直到你离开这个区域之前不会收到任何的事件回调。

下边的是设置监听一个区域的代码。

Swift

```
var locationManager: CLLocationManager = CLLocationManager()
if let uuid = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D") {
    let beaconRegion = CLBeaconRegion(
        proximityUUID: uuid,
        major: 100,
        minor: 50.
        identifier: "iBeacon")
    locationManager.startMonitoringForRegion(beaconRegion)
}
```

在设置了监听之后，你可以通过实现下边的两个代理方法来监听进入和离开区域的回调 ：

Swift

```
func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    if let beaconRegion = region as? CLBeaconRegion {
        print("DID ENTER REGION: uuid: \(beaconRegion.proximityUUID.UUIDString)")
    }
}
    
func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    if let beaconRegion = region as? CLBeaconRegion {
        print("DID EXIT REGION: uuid: \(beaconRegion.proximityUUID.UUIDString)")
    }
}
```

这还有两个很有用的 `CLLocationManagerDelegate` 的代理方法 ：`didStartMonitoringForRegion` 方法来确认监听被正常启动了，如果监听启动的时候出错 `monitoringDidFailForRegion` 方法会提供错误信息。

你需要注意到的一大限制因素是：你同时最多只能监听 20 个设备。如果你有超过 20 个设备，你就需要持续管理维护应用正在监听的设备列表。

#### 范围

范围是 iBeacon 中的另一种推送模式，本质上它比起监听模式的信息量更大并且更频繁的发送更新数据到应用。设置范围模式和设置监听模式很相似，你只需要用 `startRangingBeaconsInRegion` 替换 `startMonitoringForRegion` 方法。一旦设置完成，你只需要监听 `didRangeBeacons` 方法的回调，这个代理方法实现如下：

Swift

```
func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
    for beacon in beacons {
        var beaconProximity: String;
        switch (beacon.proximity) {
        case CLProximity.Unknown:    beaconProximity = "Unknown";
        case CLProximity.Far:        beaconProximity = "Far";
        case CLProximity.Near:       beaconProximity = "Near";
        case CLProximity.Immediate:  beaconProximity = "Immediate";
        }
        print("BEACON RANGED: uuid: \(beacon.proximityUUID.UUIDString) major: \(beacon.major)  minor: \(beacon.minor) proximity: \(beaconProximity)")
    }
}
```

这些回调方法基本上每秒都会触发一次。每次回调返回一个`CLBeacon` 对象，其中范围内的设备信息如下：

- 接近度 - `CLProximity` 类描述设备的接近程度，值包括 `Near`, `Far`, `Immediate` 和 `Unknown`。

- 精确度 - `CLLocationAccuracy` 类捕获一个和设备间精确到米精确值。

- RSSI - 捕获一个 `Int` 类型的信息用来描述设备信号强度。

另外说明一下我们同是需要关注范围模式比起监听模式是更耗电。此外，尽管技术上你可以在后台使用范围模式，但这是个很不被认可的方案。网上的讨论中都说如果你在项目中这样使用会被苹果公司拒绝上线。


## 更多讨论

### 距离是否准确

网上有许多围绕每次 ranging event（指的就是范围模式的 didRangeBeacons 回调） 所返回的 `CLLocationAccuracy` 值的[讨论](http://stackoverflow.com/questions/20416218/understanding-ibeacon-distancing)。人们常把这个值当作手机与发射器的实际距离值。以我的经验来看，你当然可以把这个值当作实际的距离，但它并不总是那么准确。苹果文档建议你首先利用 `CLProxity` 枚举值来初步判定设备距离的远近，然后再用 `CLLocationAccuracy` 的值来区分其中接近度相近的值。

[这篇博客](https://shinesolutions.com/2014/02/17/the-beacon-experiments-low-energy-bluetooth-devices-in-action/) 进行了一些有趣的试验来测试精确的距离。

### 监听超过 20 个设备

正像我前边介绍的那样，你现在只能监听 20 个 iBeacons ，如果你需要监听超过 20 个设备，你将需要在应用运行的过程中更改监听的设置，一种实现方案是用图表来展示你的 iBeacons 网络，在网络中定义最顶层的 iBeacons 以及如果这些彼此接近的情况下能够连接到的边界。这样你就可以快速的查找到最接近的 20 个 iBeacons 并监听他们。这需要很多的工作，但是定义一个这样的拓扑是一种实现 20 个 iBeacons 限制的方式。

### 法拉第容器(用于静电屏蔽)

如果你的 iBeacons 不能关闭或者不能轻易的在广播数据的过程中被停止，你也许应该考虑购买一个法拉第包或笼。如果 iBeacon 不能被关闭的话，多个设备配置起来很麻烦，会互相干扰，所以需要法拉第笼来屏蔽其他设备，一个个来设置。我们很确定 Estimote 的 iBeacons 就有上述的问题，放置所有的设备除了其中一个放置在法拉第笼中，这将使你很容易使你想要配置的 iBeacons 被孤立出来。

## 示例工程

如果你在寻找一个允许用户定义 iBeacons 的监听和范围模式的简单示例工程。你可以看下我的[GitHub 项目](https://github.com/mattnedrich/beacon-scanner)。


