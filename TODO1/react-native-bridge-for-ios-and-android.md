> * 原文地址：[React Native Bridge for iOS and Android](https://hackernoon.com/react-native-bridge-for-ios-and-android-43feb9712fcb)
> * 原文作者：[Abhishek Nalwaya](https://hackernoon.com/@abhisheknalwaya)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-bridge-for-ios-and-android.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-bridge-for-ios-and-android.md)
> * 译者：
> * 校对者：

# React Native Bridge for iOS and Android

graf graf--p graf-after--h3">One of the biggest reason for the popularity of React Native is that we can create a bridge between the Native language and JavaScript code. Which means we can reuse all the reusable libraries created in iOS and Android world.

To create a production grade application some point of time you need to use Native Bridge. There are very less article and tutorial on cross-platform React Native bridge which works on both iOS and Android. In this article, we will create a Native Bridge to access Swift and Java class from JavaScript.

This is the first part, second post on **Native Bridge of UI component** can be found [here](https://hackernoon.com/react-native-bridge-for-android-and-ios-ui-component-782cb4c0217d).

> The code of this article can be found here -> [https://github.com/nalwayaabhishek/LightApp](https://github.com/nalwayaabhishek/LightApp)

### Create the LightApp

To better understand Native Module we will create a simple LightApp example using react-native CLI.

```
$ react-native init LightApp
$ cd LightApp
```

Next, we will create a class `Bulb` in Swift for iOS and Java for Android, and this will be used this app in a React component. **This will be cross-platform example and the same React code will work in both iOS and Android.**

As we have created a basic skeleton of the project, next we have divided this article into two sections:

_Section 1 — Native Bridge in iOS_

_Section 2 — Native Bridge in Android_

#### **Section 1 —Native Bridge iOS**

In this section, we will focus on iOS and create a bridge between Swift/Objective C and your React Component. It has these three steps:

_Step 1) Create a Bulb class and Bridge Header_

_Step 2) Understanding GCD Queue and fixing the warning:_

_Step 3) Accessing a variable in JavaScript from Swift and Callbacks_

**Step 1) Create a Bulb class and Bridge Header**

To get started we will create a Bulb class in swift, which will have a static class variable `isOn` and a few other functions. And then we will access this swift class from Javascript. Let's start by opening _LightApp.xcodeproj_ file in ios folder. It should open Xcode with your ios code.

Once you open the project in Xcode, then create a new Swift file Bulb.swift as shown:

![](https://cdn-images-1.medium.com/max/800/1*FxPFgst2EC5MBA0bx0OcJA.gif)

We have also clicked on Create Bridging Header which will create a file `LightApp-Bridging-Header.h` This will help to communicate between Swift and Objective C code. Remember that in a project we have only one Bridge Header file. So if we add new files, we can reuse this file.

Update following code in `LightApp-Bridging-Header.h`file:

```
#import "React/RCTBridgeModule.h"
```

RCTBridgeModule will provide an interface to register a bridge module.

Next update `Bulb.swift`with the following code:

```
import Foundation

@objc(Bulb)
class Bulb: NSObject {

    @objc
    static var isOn = false

    @objc
    func turnOn() {
        Bulb.isOn = true
        print("Bulb is now ON")
    }
}
```

We have created `Bulb` class which is inherited from _NSObject_. The root class of most Objective-C class hierarchies is _NSObject_, from which subclasses inherit a basic interface to the runtime system and the ability to behave as Objective-C objects. We can see that we have used @objc before a function and class, this will make that class, function or object available to Objective C

> The @objc attribute makes your Swift API available in Objective-C and the Objective-C runtime.

Now create a new file from _File -> New -> File_ and select Objective-C file and then name the file as _Bulb.m_ and update following code:

```
#import "React/RCTBridgeModule.h"
@interface RCT_EXTERN_MODULE(Bulb, NSObject)
RCT_EXTERN_METHOD(turnOn)
@end
```

React Native will not expose any function of Bulb to React JavaScript unless explicitly done. To do so we have used **_RCT_EXPORT_METHOD()_** macro. So we have exposed Bulb class and _turnOn_ function to our Javascript code. Since Swift object is converted to Javascript object, there is a type of conversation. RCT_EXPORT_METHOD supports all standard JSON object types:

*   NSString to string
*   NSInteger, float, double, CGFloat, NSNumber to number
*   BOOL to boolean
*   NSArray to array
*   NSDictionary to object with string keys and values of any type from this list
*   RCTResponseSenderBlock to function

Now let’s update JavaScript code and access this _Bulb_ class from our React component. To do so open _App.js_ and update with the following code:

```
import React, {Component} from 'react';
import {StyleSheet, Text, View, NativeModules, Button} from 'react-native';

export default class App extends Component{
  turnOn = () => {
    NativeModules.Bulb.turnOn();
  }
  render() {
  return (
    <View style={styles.container}>
    <Text style={styles.welcome}>Welcome to Light App!!</Text>
    <Button
        onPress={this.turnOn}
    title="Turn ON "
    color="#FF6347" />
    </View>
  );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
});
```

Now run the iOS simulator:

![](https://cdn-images-1.medium.com/max/800/1*hJrsUtQqoewxbrBm1wLbtg.png)

Now open Xcode console to see the logs and we can see that Swift _turnOn_ method is called from JavaScript code. (As we have done logging in the method)

![](https://cdn-images-1.medium.com/max/800/1*g_GBqo8jCm_DThSX-QkIPQ.png)

**Step 2) Understanding GCD Queue and fixing the warning:**

Now let's fix the warning shown at the bottom of the simulator and in browser console:

_Module Bulb requires main queue setup since it overrides `init` but doesn’t implement `requiresMainQueueSetup`. In a future release React Native will default to initializing all native modules on a background thread unless explicitly opted-out of._

To understand it better let's understand about all the thread React Native runs:

*   **Main thread**: where UIKit work
*   **Shadow queue:** where the layout happens
*   **JavaScript thread:** where your JS code is actually running

Every native module has its own GCD Queue unless it specifies otherwise. Now since this Native module will run on a different thread and our main thread is depended on it, it's showing this warning. And to make this code to run on MainQueue, open Bulb.swift and add this function.

```
@objc
static func requiresMainQueueSetup() -> Bool {
  return true
}
```

You can explicitly mention _return false_ to run this in separate threat.

**Step 3) Accessing a variable in JavaScript from Swift and Callbacks**

Now let's add the Bulb Status(ON or OFF) value to our React screen. To do so we will add _getStatus_ function to _Bulb.swift_ and call that method from JavaScript code. We will create this method as a callback.

> React Native bridge is asynchronous, so the only way to pass a result to JavaScript is by using callbacks or emitting events

Let's update the code in bold in _Bulb.swift_

```
@objc(Bulb)
class Bulb: NSObject {
    @objc
    static var isOn = false

    @objc
    func turnOn() {
        Bulb.isOn = true
        print("Bulb is now ON")
    }

    @objc
    func turnOff() {
        Bulb.isOn = false
        print("Bulb is now OFF")
    }

    @objc
    func getStatus(_ callback: RCTResponseSenderBlock) {
        callback([NSNull(), Bulb.isOn])
    }

    @objc
        static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
```

_getStatus()_ method receives a callback parameter that we will pass from your JavaScript code. And we have called the callback with array of values, which will be exposed in JavaScript. We have passed NSNull() as the first element, which we have considered as an error in the callback.

We need to expose this Swift method to JavaScript so following bold lines to _Bulb.m_:

```
@interface RCT_EXTERN_MODULE(Bulb, NSObject)
RCT_EXTERN_METHOD(turnOn)
RCT_EXTERN_METHOD(turnOff)
RCT_EXTERN_METHOD(getStatus: (RCTResponseSenderBlock)callback)
@end
```

We have exposed (RCTResponseSenderBlock)_callback_ as params to the function _getStatus_

And then finally update the React Code:

```
import React, {Component} from 'react';
import {StyleSheet, Text, View, NativeModules, Button} from 'react-native';

export default class App extends Component{
    constructor(props) {
      super(props);
      this.state = { isOn: false };
      this.updateStatus();
    }

    turnOn = () => {
      NativeModules.Bulb.turnOn();
      this.updateStatus()
    }

    turnOff = () => {
      NativeModules.Bulb.turnOff();
      this.updateStatus()
    }

    updateStatus = () => {
      NativeModules.Bulb.getStatus( (error, isOn)=>{
      this.setState({ isOn: isOn});
    })
}

render() {
    return (
    <View style={styles.container}>
    <Text style={styles.welcome}>Welcome to Light App!!</Text>
    <Text> Bulb is {this.state.isOn ? "ON": "OFF"}</Text>
    {!this.state.isOn ? <Button
    onPress={this.turnOn}
    title="Turn ON "
    color="#FF6347"
    /> :
    <Button
    onPress={this.turnOff}
    title="Turn OFF "
    color="#FF6347"
    /> }
    </View>
    );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
});
```

Rebuild the code and run the app, you can see the Bulb Status value and when you click on _Turn ON_ then it will show _Bulb is ON_

> Do remember to rebuild the code instead of refresh, as we changed Native Code.

![](https://cdn-images-1.medium.com/max/800/1*f1zYWgIxlMsLKJxt6OCVSw.gif)

#### Section 2 — Native Bridge in Android

In this section, we will make the same Javascript code which we return for iOS to work with Android. This time we will create _Bulb_ class in Java and expose the same function _turnOn, TurnOff_ ant _getStatus_ to Javascript.

Open Android Studio and click on _Open an existing Android Studio_ project and then select the _android_ folder inside our LightApp. Once all gradle dependency is downloaded, create a Java Class Bulb.java as shown:

![](https://cdn-images-1.medium.com/max/800/1*MQStamkgePwYb-wpqwT8wA.gif)

And update the following code in Bulb.java:

```
package com.lightapp;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

public class Bulb extends ReactContextBaseJavaModule  {
    private static Boolean isOn = false;
    public Bulb(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @ReactMethod
    public void getStatus(
        Callback successCallback) {
        successCallback.invoke(null, isOn);

    }

    @ReactMethod
    public void turnOn() {
        isOn = true;
        System.out.println("Bulb is turn ON");
    }
    @ReactMethod
    public void turnOff() {
        isOn = false;
        System.out.println("Bulb is turn OFF");
    }

    @Override
    public String getName() {
        return "Bulb";
    }

}
```

We have created a _Bulb_ Java class which is inherited from _ReactContextBaseJavaModule_. _ReactContextBaseJavaModule_ requires that a function called _getName_ is always implemented. The purpose of this method is to return the string name of the NativeModule which represents this class in JavaScript. So here we will call this _Bulb_ so that we can access it through _React.NativeModules.Bulb_ in JavaScript. Instead of Bulb, we can have a different name also.

> Not all function is exposed to Javascript explicitly, to expose a function to JavaScript a Java method must be annotated using _@ReactMethod._ The return type of bridge methods is always void.

We have also created a _getStatus_ function which has params as callback and it returns a _callback_ and passes the value of static variable _isOn_.

Next step is to register the module, if a module is not registered it will not be available from JavaScript. Create a file by clicking on Menu File -> New -> Java Class and the file name as _BulbPackage_ and then click OK. And then add following code to _BulbPackage.java_

```
package com.lightapp;
import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class BulbPackage implements ReactPackage  {
    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }

    @Override
    public List<NativeModule> createNativeModules(
            ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();

        modules.add(new Bulb(reactContext));

        return modules;
    }

}
```

We need to Override _createNativeModules_ function and add the Bulb object to modules array. If this is not added here then it will not be available in JavaScript.

_BulbPackage_ package needs to be provided in the _getPackages_ method of the _MainApplication.java_ file. This file exists under the android folder in your react-native application directory. Update the following code in _android/app/src/main/java/com/LightApp /MainApplication.java_

```
public class MainApplication extends Application implements ReactApplication {
...

    @Override
    protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
          new MainReactPackage(),
          new BulbPackage()
      );
    }

....
}
We don’t need to
```

We don’t need to change any JavaScript code written in iOS, as we have exposed the same class name and function. If you have skipped the iOS part then you need to copy the React Javascript code from App.js

Now run the App through Android Studio or from _react-native run-android_:

![](https://cdn-images-1.medium.com/max/800/1*8GXAFDoWvuqteHFzE7NibA.gif)

Woo!! we can see the Bulb status on the screen and can switch ON or OFF from the button. The great thing is that we have created a Native Bridge which is Cross Platform.

![](https://cdn-images-1.medium.com/max/600/1*3zDOMH-c_oORS9C7D2xe0Q.gif)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
