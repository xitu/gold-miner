> * 原文链接 : [Making React Native apps accessible | Engineering Blog | Facebook Code | Facebook](https://code.facebook.com/posts/435862739941212/making-react-native-apps-accessible/)
* 原文作者 : [Chace Liang](https://www.facebook.com/chaceliang)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [void-main](https://github.com/void-main)
* 校对者: [aleen42](https://github.com/aleen42)
* 状态 :  翻译完成


最近，随着面向 Web 的 React 框架和面向移动端的 React Native 框架相继发布，我们为开发者提供了一个可用于构建应用的全新前端框架。构建成熟产品的一个关键因素就是确保每个人都能使用它，乃至于那些有视觉缺陷或其它残障的用户。为 React 和 React Native 设计的无障碍(Accessibility)API使你基于React开发的应用可以被那些需要辅助工具，比如为盲人或视觉受损的用户设计的读屏器，的用户使用。


本文中我们将重点关注 React Native 应用。在设计 React 无障碍 API 的时候，我们力求与 iOS 和 Android 相关 API 相似。如果你曾经在 Web、IOS 或 Android 平台上开发过无障碍应用，那么你应该会习惯 React AX API 所提供的框架与术语。举例来说，你可以把一个 UI 元素标记为 _accessible_ (由此会暴露给辅助工具)，并使用 _accessibilityLabel_ 为这个元素提供一个文字描述。

```
<View accessible={true} accessibilityLabel=”This is simple view”>
```

让我们通过研究 Facebook 自己的一个基于 React 的产品来深入了解 React AX API：**广告管理APP(Ads Manager app)**。


[广告管理app](https://www.facebook.com/business/news/ads-manager-app) 使 Facebook 的广告商们可以随时管理他们的账户并创建新的广告。这是 Facebook 第一款跨平台的应用，而且它是用 React Native 构建的。


广告可能很复杂，因为广告中会有很多基于上下文的信息。当我们为无障碍设计交互时，我们决定把所有这些相关联的信息组合在一起。例如，一个活动列表项会在一个条目中展示活动领导者的名称，活动的结果以及活动的状态（示例："活动 Hacker and Looper, 页面发帖参与，29967人参与，目前处于有效状态"）。


![](https://scontent-hkg3-1.xx.fbcdn.net/hphotos-xpt1/t39.2365-6/12057083_429032550627060_1728546419_n.jpg)


使用 React Native 的无障碍 API 我们可以轻松实现这个效果。我们只需要在父组件上设置 `accessible={true}`，然后无障碍API就会收集所有子组件的无障碍标签。


    <View
      accessible={true}
      style={{
        flex: 1,
        backgroundColor: 'white',
        padding: 10,
        paddingTop: 30,
      }}>
      <Text>Hacker and Looper, Page Post Engagement</Text>
      <Text>29,967 Post Engagements</Text>
      <AdsManagerStatus
        accessibilityLabel={'Status ' + this.props.status}
        status={this.props.status}
      />
    </View>


嵌套的 UI 元素，例如列表行里的开关，也需要特定的无障碍支持。当用户使用读屏器选择了列表中的某一行，我们需要读出这一行中的所有信息，并且告知用户这一行中有可以操作的元素。无障碍 API 提供了从系统中获取无障碍环境以及监听系统设置变化的能力。因此，我们只需简单地改变父元素的行为，就可以通过像 VoiceOver 或者 TalkBack 这样的读屏器来通知用户(示例："双击这一行来改切换里的开关状态")。在广告管理应用中，我们是用这种开关来切换通知设置项的。当这一行被选中的时候，它就会说："允许广告。开启。双击来切换设置"。

![](https://scontent-hkg3-1.xx.fbcdn.net/hphotos-xtp1/t39.2365-6/12057155_921685684567792_354128754_n.jpg)



通过 React Native 的无障碍 API，使得我们可以查询某系统的无障碍状态：


    AccessibilityInfo.fetch().done((enabled) => {
      this.setState({
        AccessibilityEnabled: enabled,
      });
    });



我们也可以监听无障碍状态变化：


    componentDidMount: function() {
      AccessibilityInfo.addEventListener(
        'change',
        this._handleAccessibilityChange
      );
      ...   
    },
    
    _handleAccessibilityChange: function(isEnabled: boolean) {
      this.setState({
        AccessibilityEnabled: isEnabled,
      });
    },



通过这些 API，我们的产品团队可以根据系统当前的无障碍设置信息来控制触摸事件。例如，在上面的截图中，有许多控制推送通知的开关。如果用户正在使用读屏器，我们就会朗读这一行中的所有信息，包括开关和状态，例如，"允许广告，开启状态"——然后用户就可以通过双击选中区域，比如双击这一行，来切换状态。


    var onSwitchValueChange = this.props.onValueChange;
    var onRowPress = null;
    if (this.state.isAccessibilityEnabled) {
      onSwitchValueChange = null;
      onRowPress = this.props.onValueChange;
    }
    
    var switch = <Switch onValueChange={onSwitchValueChange} ... />
    return
      <InfoRow
        action={switch}
        onPress={onRowPress}
        ...
      />


React Native 为你在 iOS 和 Android 平台开发应用提供了一种强大的方式，而且，它还能使你能有效地复用代码。通过 React Native 无障碍 API，你可以确保你的产品同样能使得有残疾或需要使用辅助工具的用户得到精致的体验。

更多关于 React Native AX API 的信息，请参考我们的[开发文档](https://www.facebook.com/l.php?u=https%3A%2F%2Ffacebook.github.io%2Freact-native%2Fdocs%2Faccessibility.html&h=NAQEjh5Hy&s=1)。
