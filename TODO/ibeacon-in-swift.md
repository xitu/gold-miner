> * 原文地址：[A Guide to Interacting with iBeacons in iOS using Swift](https://spin.atomicobject.com/2017/01/31/ibeacon-in-swift/)
* 原文作者：[MATT NEDRICH](https://spin.atomicobject.com/author/nedrich/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

#A Guide to Interacting with iBeacons in iOS using Swift#

I’ve recently been working on an iOS project that uses [iBeacons](https://developer.apple.com/ibeacon/) . In this post, I’ll provide a comprehensive guide for working with iBeacons in iOS using [Swift](https://developer.apple.com/swift) . I’ll describe what iBeacons are, how you can use them, and what you should know about the programming model for interacting with them in iOS. I’ll also share some of the best practices that I learned.

## What Are iBeacons? ##

iBeacons are a class of Bluetooth Low Energy (BLE) devices that continuously broadcast identifying information about themselves using the iBeacon protocol. They are meant to be placed in the physical world (usually indoors) at locations of interest. Mobile apps can then ask to be notified when they move within range of a beacon, and then react appropriately.

You may read things that claim that iBeacons act as an alternative to GPS for indoor location sensing, in situations where GPS does not work reliably. While this is largely true, you shouldn’t necessarily think of iBeacons as a perfect substitute for GPS. Their operating model and location sensing precision are quite different compared to traditional GPS. Still, with a little creativity, you can do some pretty cool things with iBeacons.

## iBeacon Applications ##

Before we get into how iBeacons work, it might be useful to discuss the ways you can use them. While there are a variety of different iBeacons applications, I like to group them into the following categories: 1. context-aware content delivery and 2. passive tracking.

### Context-aware content delivery ###

iBeacons can be used to deliver content to users when they move near an area of interest. One classic example involves a museum. Imagine placing an iBeacon near each museum exhibit, and when users move near an exhibit, automatically displaying more information about what they are viewing. This requires the mobile app listening for beacons to know which beacons are near which exhibits. With this association, though, the beacons help determine where the users are in the museum and allow the app to react appropriately.

### Passive tracking ###

Extending the concept of context-aware content delivery, you can also use iBeacons as a means to track users. Imagine placing iBeacons throughout a building–perhaps a museum or grocery store. As users move around, you can detect the route they take through the building by recording the sequence of beacons they pass. This would allow you to track users and learn common pathways and traffic patterns.

Of course, there are countless other iBeacon applications beyond these simple examples–[this website](http://blog.mowowstudios.com/2015/02/100-use-cases-examples-ibeacon-technology/) has a nice list of them.

## iBeacon Addressing Scheme ##

If you have worked with Bluetooth Low Energy devices in the past, you might be familiar with the concept of a Bluetooth advertising packet. iBeacons are essentially BLE devices that only send advertising packets. When they advertise themselves, they broadcast packets that contain three values: a **UUID**, a **major number**, and a **minor number**. The combination of these three numbers is used to uniquely identify an iBeacon, and it can be configured by the user.

The UUID, combined with the major and minor number, allows for nice hierarchal addressing schemes. Imagine if a retail chain like Walmart were to deploy iBeacons in their stores. They might choose to use a single UUID to denote Walmart and have all Walmart iBeacons use that UUID (which makes the UUID not unique at all, but this seems to be the common way to address iBeacons). They could then use the iBeacon major number to denote the store number, and the minor number to differentiate between different departments or locations within that store.

## iBeacon Manufacturers ##

iBeacons are named as such because Apple defined the iBeacon protocol (e.g., the format for the advertising data that they broadcast). However, they are not made or sold by Apple.

Instead, there are several companies that make and sell iBeacons, and each manufacturer is a little different. Some of the more popular manufacturers include [Estimote](http://estimote.com/) , [Aruba](http://www.arubanetworks.com/products/mobile-engagement/aruba-beacons/?source=sem&amp;gclid=CMrEzpLaytECFVhYDQodPZ0AKg) , and [Radius Networks](https://www.radiusnetworks.com/) . If you’re looking to get started with iBeacons, any of these manufacturers would be a good choice. I have personally used the Estimote and Radius Networks beacons, so I can talk about them in more detail.

Below are some photos of Estimote and Radius Networks iBeacons.

![](https://spin.atomicobject.com/wp-content/uploads/20170119182038/estimote-beacon2.jpg)

Estimote iBeacons

![](https://spin.atomicobject.com/wp-content/uploads/20170119181625/radius-networks-beacons.jpg) 

Radius Networks iBeacons. The top comes off for easy access to the battery.

The Radius Networks beacons are nice because you can turn them on and off and easily change their battery. The Estimote beacon battery lasts substantially longer, but you can’t easily change it when it dies, and you can not easily stop the Estimote beacons from broadcasting.

Note: There are several other similar protocols to iBeacon, such as [Eddystone](https://en.wikipedia.org/wiki/Eddystone_(Google)) . Most manufactures make beacons that broadcast several different protocols.

### Configurability ###

When you purchase iBeacons, the manufacturer usually provides a mobile app to help you configure them. This app allows you to do things like set each beacon’s UUID and major and minor number, adjust their advertising rate, and configure their Bluetooth broadcast strength. Some manufacturers don’t provide an app or any other easy way to configure their iBeacons. I would recommend avoiding these manufacturers unless you have a good reason not to.

Below are some screenshots of the Estimote and Radius Networks iBeacon configuration apps.

#### Estimote Configuration App Screenshots ####

![](https://spin.atomicobject.com/wp-content/uploads/20170119182212/ea2.jpg)

![](https://spin.atomicobject.com/wp-content/uploads/20170119182215/ea3.jpg) 

In the Estimote app (shown above), you can see the screens for adjusting the beacon’s advertising rate and Bluetooth broadcast strength.

#### Radius Networks Configuration App Screenshots ####
![](https://spin.atomicobject.com/wp-content/uploads/20170117223648/rna1.jpg)

![](https://spin.atomicobject.com/wp-content/uploads/20170117223650/rna2.jpg) 

In addition to the mobile app, there are several other iBeacon differences across manufacturers. When choosing an iBeacon, you may want to consider some of the following, as they tend to vary between vendors:

- Beacon battery life

- Beacon battery replaceability

- Minimum and maximum beacon range

- Ability to turn beacons off, or at least stop them from advertising

- Other protocols that the beacons support (e.g., Eddystone)

- SDK functionality (if one exists and you plan on leveraging it)

## iOS Programming Model ##

Now that we have discussed what iBeacons are, how they work, and how to compare some manufacturers, let’s take a look at the iOS programming model for interacting with them.

All iBeacon functionality is provided through the iOS CoreLocation library. This is actually kind of interesting, given that iBeacons are Bluetooth devices. The Bluetooth nature of the beacons is completely abstracted away from the developer.

### Permission ###

For your app to use iBeacons, users must allow it to access their location. You can prompt users for permission by adding keys to your `Info.plist` file. The `NSLocationWhenInUseUsageDescription` key will prompt users for permission to access their location when your app is in the foreground. If your app needs to receive iBeacon location notifications when in the background, the `NSLocationAlwaysUsageDescription` key should be used instead.

In addition to setting these keys, you will need to call `requestWhenInUseAuthorization()` or `requestAlwaysAuthorization()` on your `CLLocationManager` class instance when your app starts up.

### iBeacon Listening Modes ###

There are two modes for receiving iBeacon notifications: **monitoring** and **ranging**. They work quite differently. Depending on what your app does, you may need to use one or both of them.

#### Monitoring ####

Monitoring is the simpler of the two modes. It can alert your app of region enter and exit events, but that’s about it. To listen for these events, instantiate a new `CLLocationManager` and implement the `didEnterRegion` and `didExitRegion` delegate methods. In my experience, the exit events can be delayed for about 30 seconds after you leave a region. The enter events, however, seem to happen reliably with little delay. If you start inside of a region, you will not receive an event until you leave it (and trigger an exit event).

The code below sets up monitoring for a region.

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

There are also two `CLLocationManagerDelegate` methods that can be helpful: `didStartMonitoringForRegion` confirms that monitoring was started correctly, and `monitoringDidFailForRegion` provides error information if something goes wrong in the monitoring setup.

The big limitation to be aware of with monitoring is that you can only monitor for 20 beacons at a given time. If you have more than 20 beacons, you will need to continuously manage which ones your app is monitoring for.

#### Ranging ####

Ranging is the other iBeacon notification mode. It is substantially more informative than monitoring and sends updates to your app much more frequently. Setting up ranging is similar to monitoring, except you call `startRangingBeaconsInRegion` instead of `startMonitoringForRegion`. Once set up, you listen for `didRangeBeacons` callbacks. This delegate method can look like this:

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

These callbacks can happen as often as one per second. Each callback provides a `CLBeacon` object, which contains the following information about the beacon being ranged:

- Proximity – `CLProximity` describes how close the beacon is. Values include `Near`, `Far`, `Immediate`, and `Unknown`.

- Accuracy – `CLLocationAccuracy` captures a distance estimate to the beacon in meters.

- RSSI – `Int` captures the signal strength of the beacon measured in decibels.

The caveat with ranging is that it consumes significantly more power than monitoring. Further, while you can technically range in the background, it is strongly frowned upon. Most online discussions warn that Apple may reject your app if you do.

## Further Discussion ##

### Is the distance accurate? ###

There is a [lot of discussion online](http://stackoverflow.com/questions/20416218/understanding-ibeacon-distancing)  surrounding the `CLLocationAccuracy` value returned with each ranging event. Folks often want to interpret this as the literal distance to the beacon. In my experience, you can attempt to interpret the value as a literal distance, but it will not always be accurate. The Apple docs suggest you use the `CLProxity` enumeration value as the initial way to determine which beacons are closest, and then break ties using the `CLLocationAccuracy` value.

[This blog post](https://shinesolutions.com/2014/02/17/the-beacon-experiments-low-energy-bluetooth-devices-in-action/)  conducts some interesting experiments to test the accuracy of the distance value.

### Monitoring more than 20 beacons ###

As I mentioned earlier, you can only monitor 20 iBeacons concurrently. If you need to monitor more than 20, you will need to update the set being monitored as the app runs. One way to do this is to represent your iBeacon network as a graph, where the iBeacons are vertices and they are connected by an edge if they are near each other. When the user enters near an iBeacon, you can quickly search for its 20 nearest neighbors and monitor for them. This requires some work, but defining a topology like this is one way to work around the 20 iBeacon limitation.

### Faraday containers ###

If your iBeacons do not turn off or can’t easily be stopped from advertising, you might consider purchasing a Faraday bag or cage. It can be tricky attempting to configure each iBeacon, one at a time, when you have several nearby. We certainly had this problem with the Estimote iBeacons. Placing all but one in a Faraday cage will make it easy to isolate the beacon you want to configure.

## Example Project ##

If you are looking for a simple example project that allows you to monitor or range for user-defined iBeacons, check out this [GitHub project](https://github.com/mattnedrich/beacon-scanner) of mine.

