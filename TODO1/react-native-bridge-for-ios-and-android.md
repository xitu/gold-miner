> * 原文地址：[React Native Bridge for iOS and Android](https://hackernoon.com/react-native-bridge-for-ios-and-android-43feb9712fcb)
> * 原文作者：[Abhishek Nalwaya](https://hackernoon.com/@abhisheknalwaya)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-bridge-for-ios-and-android.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-bridge-for-ios-and-android.md)
> * 译者：
> * 校对者：

# React Native 与 iOS 和 Android 通信

React Native 流行的最大原因之一是我们可以在 Native 语言和 JavaScript 代码之间建立桥梁。 这意味着我们可以复用在 iOS 和 Android 中创建的所有可重用库。

要创建一个商业级的应用程序，您需要使用Native Bridge。React Native 可以同时在 iOS 和 Android 上运行，但关于它如何跨平台的文章教程非常少。 在本文中，我们将创建一个 Native Bridge ，以便从 JavaScript 访问 Swift 和 Java 类。

文本是此系列的第一部分，第二部分可以在 **Native Bridge of UI component** 中找到 [这里](https://hackernoon.com/react-native-bridge-for-android-and-ios-ui-component-782cb4c0217d)。

> 代码可以在这里找到 -> [https://github.com/nalwayaabhishek/LightApp](https://github.com/nalwayaabhishek/LightApp)

### 创建一个 LightApp（手电筒）

为了更好地理解 Native Module，我们将使用 react-native CLI 创建一个简单的 LightApp 示例。

```
$ react-native init LightApp
$ cd LightApp
```

接下来，我们将在 Swift 和 Java 中创建一个 `Bulb` 类，稍后将在 React 组件中使用它。**这是一个跨平台的示例，相同的 React 代码将同时适用于iOS和Android。**

现在我们已经创建了项目的基本框架，接下来我们将本文分为两部分：

_第一节 — 与原生 iOS 通信_

_第二节 — 与原生 Android 通信_

#### **第一节 — 与原生 iOS 通信**

在本节中，我们将重点关注 iOS，了解如何在 Swift/Objective C 和 React 组件间建立桥梁。有以下三个步骤：

_步骤 1) 创建一个  Bulb 类 并且完整初步通信_

_步骤 2) 理解 GCD Queue 并且解决出现的警告_

_步骤 3) 从 Swift 和 Callbacks 访问 JavaScript 中的变量_

**步骤 1) 创建一个  Bulb 类 并且完成初步通信**

首先，我们将在 swift 中创建一个 Bulb 类，它将具有一个静态类变量 `isOn` 和一些其他函数。然后我们将从 Javascript 访问这个 swift 类。让我们首先在 ios 文件夹中打开 _LightApp.xcodeproj_ 文件。此时 Xcode 应该会被打开。

在 Xcode 中打开项目后，创建一个新的 Swift文件 Bulb.swift，如下所示：

![](https://cdn-images-1.medium.com/max/800/1*FxPFgst2EC5MBA0bx0OcJA.gif)

我们还要点击 Create Bridging Header，创建一个文件 `LightApp-Bridging-Header.h` 它将有助于 Swift 和 Objective C 代码之间的通信。请记住，在项目中，我们只有一个 Bridge Header 文件。因此，如果我们添加新文件，我们可以重用此文件。

将以下代码加入 `-Bridging-Header.h` 文件：

```
#import "React/RCTBridgeModule.h"
```

RCTBridgeModul 将提供一个接口，用于注册 Bridge 模块。

接下来将以下代码输入 `Bulb.swift`：

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

我们创建了 `Bulb` 类，它继承自  _NSObject_。大多数 Objective-C 类的根类是 _NSObject_，子类从该类继承运行时系统的基本接口，因此它们有与 Objective-C 对象相同的能力。我们在函数和类之前使用了 @objc，这将使那个类，方法或对象可用于 Objective C。

> @objc 注解使您的 Swift API 在 Objective-C 和 Objective-C 运行时可用。

现在选择 _File -> New -> File_ 创建一个新文件，然后选择 Objective-C 文件，然后将该文件命名为 _Bulb.m_ 并添加以下代码：

```
#import "React/RCTBridgeModule.h"
@interface RCT_EXTERN_MODULE(Bulb, NSObject)
RCT_EXTERN_METHOD(turnOn)
@end
```

除非显式地指定，否则 React Native 不会将任何 Bulb 中的函数暴露给 React JavaScript 。 为此，我们使用了 **RCT_EXPORT_METHOD()**  宏。 所以我们已经暴露了 Bulb 类和  _turnOn_  函数给了我们的  Javascript 代码。 由于 Swift 对象被转换为了 Javascript 对象，因此其中一定存在一种对应关系。 RCT_EXPORT_METHOD 支持所有标准 JSON 对象类型：

*   NSString 对应 string
*   NSInteger, float, double, CGFloat, NSNumber 对应 number
*   BOOL 对应 boolean
*   NSArray 对应 array
*   NSDictionary 对应 包含此列表中的字符串键和任何类型的值的对象
*   RCTResponseSenderBlock 对应 function

现在让我们更新 JavaScript 代码并从我们的 React 组件访问这个 _Bulb_ 类。 为此，请打开 _App.js_ 并更新为以下代码：

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

现在运行iOS模拟器：

![](https://cdn-images-1.medium.com/max/800/1*hJrsUtQqoewxbrBm1wLbtg.png)

现在打开 Xcode 控制台查看日志，我们可以看到从 JavaScript 代码调用 Swift _turnOn_ 方法。 （因为我们已经看到了方法中执行的日志）

![](https://cdn-images-1.medium.com/max/800/1*g_GBqo8jCm_DThSX-QkIPQ.png)



**步骤 2) 理解 GCD Queue并且解决出现的警告:**

现在让我们修复模拟器底部和浏览器控制台中显示的警告：

_Bulb 模块_ 需要主队列设置，因为它覆盖 `init`但 没有实现 `requiresMainQueueSetup` 。 在以后的版本中，React Native 将默认初始化后台线程上的所有原生模块，除非明确选择不需要。

为了更好地理解，让我们了解 React Native 运行的所有线程：

*   **Main thread**: UI 渲染执行的线程 - 
*   **Shadow queue:** 布局发生的地方
*   **JavaScript thread:** JS 代码实际执行的地方


除非另有说明，否则每个原生模块都有自己的 GCD 队列。 现在，由于这个原生模块将在不同的线程上运行，并且我们的主线程依赖于它，它会显示此警告。 要使此代码在 MainQueue 上运行，请打开 Bulb.swift 并添加此函数。

```
@objc
static func requiresMainQueueSetup() -> Bool {
  return true
}
```

您可以明确提及 _return false_ 以让它在单独的线程中运行。

**步骤 3) 从Swift和Callbacks访问JavaScript中的变量**

现在让我们将 Bulb 的开关（ON 或 OFF）值添加到 React 屏幕。 为此，我们将 _getStatus_ 函数添加到 _Bulb.swift_ 并从 JavaScript 代码调用该方法。 我们将创建此方法作为回调。

> React Native 桥是异步的，因此将结果传递给 JavaScript 的唯一方法是使用回调或触发事件

让我们用粗体更新 _Bulb.swift_ 中的代码:

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

_getStatus()_ 方法接收一个我们将从您的  JavaScript 代码传递的回调参数。 我们用值数组调用了回调函数，这些函数将暴露在 JavaScript 中。 我们已经将 NSNull() 作为第一个元素传递，我们将其视为回调中的错误。

我们需要将这个 Swift 方法暴露给 JavaScript，所以添加下方的粗体行代码到 _Bulb.m_ 中：

```
@interface RCT_EXTERN_MODULE(Bulb, NSObject)
RCT_EXTERN_METHOD(turnOn)
RCT_EXTERN_METHOD(turnOff)
RCT_EXTERN_METHOD(getStatus: (RCTResponseSenderBlock)callback)
@end
```

我们已将 (RCTResponseSenderBlock)_callback_ 暴露为函数 _getStatus_ 的参数

然后最后更新React代码：

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

重新变异代码并运行应用程序，您可以看到 Bulb Status 的值，当您单击 _Turn ON_ 时，它将显示 _Bulb 为 ON_

> 请记住重新编译代码而不是刷新，因为我们更改了原生代码。

![](https://cdn-images-1.medium.com/max/800/1*f1zYWgIxlMsLKJxt6OCVSw.gif)

#### Section 2 — Native Bridge in Android

在本节中，我们将使用与 iOS 相同的 Javascript 代码，它同样可以应用在 Android 中。 这次我们将在 Java 中创建 _Bulb_ 类并将相同的函数 _turnOn，TurnOff_ 和 _getStatus_ 暴露给 Javascript。

打开 Android Studio 并单击_打开现有的 Android Studio_ 项目，然后在 LightApp 中选择 _android_ 文件夹。 下载所有 gradle 依赖项后，创建一个 Java 类 Bulb.java ，如下所示：

![](https://cdn-images-1.medium.com/max/800/1*MQStamkgePwYb-wpqwT8wA.gif)

并将 Bulb.java 中代码更新为：

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

我们创建了一个 _Bulb_ Java 类，它继承自 _ReactContextBaseJavaModule_ 。 _ReactContextBaseJavaModule_ 要求一定要实现名一个为 _getName_ 的函数。 此方法的作用是返回在 JavaScript 中表示此类的 NativeModule 的字符串名称。 所以在这里我们将调用 _Bulb_，以便我们可以通过 JavaScript 中的 _React.NativeModules.Bulb_ 来访问它。 我们可以使用其它不同的名称代替 Bulb。

> 并非所有函数都显式地暴露给 Javascript ，要向 JavaScript 公开函数，必须使用 _@ReactMethod_ 注解 Java 方法。桥接方法的返回类型始终为 void 。

我们还创建了一个 _getStatu_ 函数，它具有参数作为回调，它返回一个 _callback_ 并传递静态变量 _isOn_ 的值。

下一步是注册模块，如果模块未注册，则无法从 JavaScrip t获得。 通过单击菜单"文件” - >“新建” - >“ Java 类”并将文件名设置为 _BulbPackage_ 来创建文件，然后单击“确定”。 然后将以下代码添加到 _BulbPackage.java_

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

我们需要覆盖 _createNativeModules_ 函数并将 Bulb 对象添加到 modules 数组中。 如果这里没有添加，那么它将无法在 JavaScript 中使用。

需要在 _MainApplication.java_ 文件的 _getPackages_ 方法中提供 _BulbPackage_ 包。 此文件存在于 react-native 应用程序目录中的 android 文件夹下。 在 _android / app / src / main / java / com / LightApp /MainApplication.java_中更新以下代码

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

我们不需要更改在 iOS 中编写的任何 JavaScript 代码，因为我们已经公开了相同的类名和函数。 如果您已跳过 iOS部分，则需要从 App.js 复制 React Javascript 代码

现在通过 Android Studio 或 react-native run-android 运行 App：

![](https://cdn-images-1.medium.com/max/800/1*8GXAFDoWvuqteHFzE7NibA.gif)

哇唔！ 我们可以在屏幕上看到 Bulb 状态，并可以从按钮切换 ON 或 OFF 。 最棒的是我们创建了一个跨平台的应用。

![](https://cdn-images-1.medium.com/max/600/1*3zDOMH-c_oORS9C7D2xe0Q.gif)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
