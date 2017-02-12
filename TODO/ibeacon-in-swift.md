> * 原文地址：[A Guide to Interacting with iBeacons in iOS using Swift](https://spin.atomicobject.com/2017/01/31/ibeacon-in-swift/)
* 原文作者：[MATT NEDRICH](https://spin.atomicobject.com/author/nedrich/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

#A Guide to Interacting with iBeacons in iOS using Swift#

#iOS 开发中使用 Swift 进行 iBeacons 交互指南


我最近致力于研究一个关于 [iBeacons](https://developer.apple.com/ibeacon/) 的 iOS 项目。本文中，我将全面的介绍如何使用 [Swift](https://developer.apple.com/swift) 进行 iOS 项目中 iBeacons 开发。我将介绍 iBeacons 是什么，如何进行使用以及在 iOS 项目中开发 iBeacons 交互你应该知道的编程模板。同时，我将分享一些在开发中学到的最佳实践方案。


##iBeacons 是什么

iBeacons 是一类使用 iBeacon 协议持续向周围发送自身标识信息的低功耗蓝牙设备。它关注物质世界中的地理位置（通常为室内）。当设备移动到一定范围内时，手机应用会收到通知并作出相应的响应。

你也许读过一些文章声称 iBeacons 是一种室内 GPS 信号不稳定时，取代 GPS 进行室内定位的解决方案。虽然这个的说法绝大部分是正确的，但是不能肯定的认为 iBeacons 是一个 GPS 完美的替代方案。他们在操作的模板和位置感知的准确性上比起传统的 GPS 有着相当大的区别。即便如此，带着一点创造性，你依然可以使用 iBeacons 做一些相当酷的事情。

## iBeacon 的应用

在我们了解 iBeacons 如何工作之前，讨论一下它的使用方法也许更有用。现在有多种多样的 iBeacons 应用，我喜欢把他们分成两大类：1. 感知信息的传输和 2.定位追踪。

### 感知信息的传输（译者注：这里不知道如何翻比较好，没有查到相关的较好翻法，个人理解的翻译方式）

iBeacons 可以用来在用户移动到接近目标区域的时候给他们发送消息。博物馆就是一个典型的例子，设想在每一个展品的位置放置一个 iBeacons 设备，当用户走近展品的时候，手机应用自动展示看到展品的更多信息会有多棒! 这就需要手机应用侦听发射器来了解有哪些发射器接近哪些展品，通过这样的匹配，发射器将决定用户在博物馆中的位置并让应用做出合理的响应。

### Passive tracking ###

### 定位追踪

作为感知信息的传输概念的扩展，你也可以使用 iBeacons 作为一种追踪用户的方式。设想在一个博物馆或者杂货店的建筑中遍布 iBeacons ，随着用户的移动，你可以侦测到用户在建筑中的移动轨迹通过他们经过的一系列设备。这将让你追踪到用户的轨迹并且了解常被走的路和交通模式。

当然，除了那些简单的例子外这里还有数之不尽的 iBeacons 应用-[这个网站](http://blog.mowowstudios.com/2015/02/100-use-cases-examples-ibeacon-technology/) 很好地罗列出了这些项目。

## iBeacon 寻址方案

如果你过去开发过低功效蓝牙设备，你也许熟悉蓝牙广播包的概念.iBeacons 本质上只是一个发送广播包的 BLE 设备。当广播包广播出去，其实广播包中包含三个值：一个 **UUID**、一个 **主要值**和一个**次要值**。这三个数字组合起来定义一个 iBeacon 设备的特殊标识并且它是可以由用户进行配置的。

考虑将 UUID 连同主要值以及次要值组合起来是一个很好地寻址方案。设想如果像沃尔玛这样的零售商在所有的商店里配置 iBeacons 设备，他们或许选择一个唯一的 UUID 来指代沃尔玛并且沃尔玛中的所有 iBeacons 都会使用这个 UUID(这使得 UUID 变得不再特殊，但是好像这是 iBeacons 中很常见的寻址方式).之后他们可以使用 iBeacons 的主要指来指代商店的编号和次要值去区别商店所在的不同的部门或区域。

## iBeacon 的制造商

iBeacons 的命名是因为苹果定义的 iBeacons 协议（比如广播出去的那些广播数据的形式），但是，他们并不是苹果生产或出售的。

而有几家公司是成产和销售 iBeacons 的，并且每一个生产商都有一点不同，比较主流的生产商包括 [Estimote](http://estimote.com/) 、 [Aruba](http://www.arubanetworks.com/products/mobile-engagement/aruba-beacons/?source=sem&amp;gclid=CMrEzpLaytECFVhYDQodPZ0AKg) 和 [Radius Networks](https://www.radiusnetworks.com/) .如果你正在打算使用 iBeacons ，上边的任何一家都会是个不错的选择。我个人曾使用过 Estimote 和 Radius Networks 两家公司的设备，所以我可以讲一下关于他们更多的细节。

下边是一些关于 Estimote 和 Radius Networks 两家生产商 iBeacons 的图片。

![](https://spin.atomicobject.com/wp-content/uploads/20170119182038/estimote-beacon2.jpg)

Estimote iBeacons

![](https://spin.atomicobject.com/wp-content/uploads/20170119181625/radius-networks-beacons.jpg) 

Radius Networks iBeacons.它可以打开顶部来更简单的使用电池。

Radius Networks 的设备很好用因为你可以随意的打开和关闭并且可以方便的更换电池。 Estimote 的设备的电池使用寿命更久，但是当电量用完之后更换起来很麻烦，此外你可能无法简单的使一个发送广播信号中的设备停止工作。

注：这还有几个和 iBeacons 相似的协议，比如 [Eddystone](https://en.wikipedia.org/wiki/Eddystone_(Google))，大部分的设备厂商生产的设备都是可以支持广播多种协议的。

###可配置性

当你购买了 iBeacons ，制造商通常会提供一个手机应用来帮助你对它进行相关的设置。你可以在应用中对 iBeacons 的 UUID 以及主要值和次要值进行设置，调整他们广播的比率和蓝牙广播的强度。一些设备上并不提供手机应用或者其他便捷的方式来配置他们生产的 iBeacons 。 除非能找不到一个特别好的理由，否则我推荐你不要购买这些厂商的 iBeacons 。

下边是 Estimote 和 Radius Networks 两个厂商的 iBeacons 配置应用中的一些截图。

#### Estimote 应用配置截图

![](https://spin.atomicobject.com/wp-content/uploads/20170119182212/ea2.jpg)

![](https://spin.atomicobject.com/wp-content/uploads/20170119182215/ea3.jpg) 


在 Estimote 厂商的应用中，你可以在截图中看到调整设备的广播比率和蓝牙广播强度的设置。6	 

#### Radius Networks Configuration App Screenshots ####

#### Radius Networks 应用配置截图
![](https://spin.atomicobject.com/wp-content/uploads/20170117223648/rna1.jpg)

![](https://spin.atomicobject.com/wp-content/uploads/20170117223650/rna2.jpg) 

除了手机应用外，厂商之间的 iBeacons 还有如下的区别。当在选择 iBeacons 时，你应该去考虑如下的因素，因为厂商间趋向于在这些方便有所区别：

- 设备的电池寿命

- 设备的电池是否可更换

- 最大和最下的设备范围

- 设备是否有关闭的功能，至少是能否让他们停止广播

- 对其他协议的是否支持(比如 Eddystone)

- SDK 功能的完善性（如果一个存在你正打算使用的功能）

## iOS 编程模板

我们已经讨论了 iBeacons 是什么，如何工作并且比较了不同厂商的区别。现在让我们来看下一下 iOS 编程中和他们进行交互的模板。

iBeacons 的所有功能都是有 iOS 中的 Corelocation 库提供，这实际上是一类有趣，给予蓝牙设备 iBeacons 功能的库。本质上蓝牙中 iBeacons 相关的部分完全是开发者抽象出来的。


### 权限

在你的应用中使用 iBeacons，用户必须允许访问位置权限。你可以提示用户开启权限通过在你的 `Info.plist` 文件中添加一些关键词。`NSLocationWhenInUseUsageDescription` 关键词将在应用处于前台的时候提示用户打开他们的位置权限。如果你的应用需要在处于后台的情况下接收 iBeacons 位置的通知，需要使用 `NSLocationAlwaysUsageDescription` 关键词进行替代。

此外你需要设置如下的关键词。当你的应用唤起是，你创建的 `CLLocationManager` 类需要调用 `requestWhenInUseAuthorization()` 方法或者 `requestAlwaysAuthorization()` 方法。


### iBeacon 监听模式

接受 iBeacon 的通知有两种模型 ：**监听** 和 **范围**，他们之间有着很大的区别。你应该依据项目的需求，使用其中的一个或者全部都进行使用。


#### 监听

监听是两种模型中比较简单的一个，它可以在你的应用进入或者离开的一个区域的时候进行提醒。为了监听这些事件，需要实例化 `CLLocationManager` 类并且实现 `didEnterRegion` 和 `didExitRegion` 这两个代理方法。我的使用经验是退出事件可能会在你离开一个区域后推迟大概30秒后才会执行。但是进入一个区域的事件基本上在进入一个区域时马上就会触发，基本上是没有延迟的。如果你一开始是就是在一个区域中的，那么直到你离开这个区域之前不会收到任何的事件回调。

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

After setting up monitoring, you can listen for enter and exit region callbacks by implementing the following two delegate methods:

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

这还有两个 `CLLocationManagerDelegate` 的代理方法会很有用 ：`didStartMonitoringForRegion` 方法来确认监听被正确的使用以及 `monitoringDidFailForRegion` 提供在设置监听中的出现的一些错误信息。

你应当意识到监听最大的限制在于你同时最多只能监听20个设备。如果你有超过20设备，那么你就需要持续的管理哪些设备是你的应用当前需要进行监听的。

#### 范围

范围是 iBeacon 中的另一种通知模式，本质上它比起监听模式的信息量更大并且更频繁的发送更新数据到应用。设置范围模式和设置监听模式很相似，你只需要用 `startRangingBeaconsInRegion` 替换 `startMonitoringForRegion` 方法。一旦设置完成，你只需要监听 `didRangeBeacons` 方法的回调，这个代理方法实现如下：

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

- 接近度 - `CLProximity` 类描述设备的接近程度，值包括 `Near`, `Far`, `Immediate`, 和 `Unknown`。

- 精确度 - `CLLocationAccuracy` 类捕获一个和设备间精确到米精确值。

- RSSI - 捕获一个 `Int` 类型的信息用来描述设备信号强度。

另外说明一下我们同是需要关注范围模式比起监听模式是更耗电。此外，你可能在后台使用范围模式，这是很不被认可的方案，网上的讨论中都说如果你在项目中这样使用会被苹果公司拒绝上线。


## 更多讨论

### 距离是否准确

[网上很多的讨论](http://stackoverflow.com/questions/20416218/understanding-ibeacon-distancing) 关于每次范围模式事件的 `CLLocationAccuracy` 类型返回值。人们通常都将这个值解释成到设备的实际值。我的经验是你可以把这个返回值解释成实际值，但有时这个值并不精确。苹果的官方文档建议开发者使用枚举 `CLProxity` 对象的值来作为初始化方案来决定范围模式中的哪一个设备最接近，然后使用 `CLLocationAccuracy` 值与这个值进行绑定。

[这篇博客](https://shinesolutions.com/2014/02/17/the-beacon-experiments-low-energy-bluetooth-devices-in-action/) 进行了一些有趣的试验来测试精确的距离。

### 监听超过20个设备

正像我前边介绍的那样，你现在只能监听20个 iBeacons ，如果你需要监听超过20个设备，你将需要在应用运行的过程中更改监听的设置，一种实现方案是用图表来展示你的 iBeacons 网络，在网络中定义最顶层的 iBeacons 以及如果这些彼此接近的情况下能够连接到边界。这样你就可以快速的查找到最接近的20个 iBeacons 并监听他们。这需要很多的工作，但是定义一个这样的拓扑是一种实现 20个 iBeacons 限制的方式。

### Faraday 容器

如果你的 iBeacons 不能关闭或者不能轻易的在广播数据的过程中被停止，你也许应该考虑购买一个法拉第包或笼。当附近有多个设备的时候，它可以尝试着一个接一个的去配置 iBeacons。我们很确定 Estimote 的 iBeacons 就有上述的问题，放置所有的设备除了其中一个放置在法拉第笼中，这将使你很容易是你想要配置的 iBeacons 被孤立出来。（译者注：这一段确实翻译的不太好。）

## 示例工程

如果你在寻找一个允许用户定义 iBeacons 的监听和范围模式的简单示例项目。你可以看下我的[GitHub 项目](https://github.com/mattnedrich/beacon-scanner)。


