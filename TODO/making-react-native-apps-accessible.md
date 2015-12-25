> * 原文链接 : [Making React Native apps accessible | Engineering Blog | Facebook Code | Facebook](https://code.facebook.com/posts/435862739941212/making-react-native-apps-accessible/)
* 原文作者 : [	Chace Liang](https://www.facebook.com/chaceliang)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态 :  待定

With the recent launch of React on web and React Native on mobile, we've provided a new front-end framework for developers to build products. One key aspect of building a robust product is ensuring that anyone can use it, including people who have vision loss or other disabilities. The Accessibility API for React and React Native enables you to make any React-powered experience usable by someone who may use assistive technology, like a screen reader for the blind and visually impaired.

For this post, we're going to focus on React Native apps. We've designed the React Accessibility API to look and feel similar to the iOS and Android APIs. If you've developed accessible applications for the web, iOS, or Android before, you should feel comfortable with the framework and nomenclature of the React AX API. For instance, you can make a UI element _accessible_ (therefore exposed to assistive technology) and use _accessibilityLabel_ to provide a string description for the element:

Let's walk through a slightly more involved application of the React AX API by looking at one of Facebook's own React-powered products: the **Ads Manager app**.

The [Ads Manager app(https://www.facebook.com/business/news/ads-manager-app) allows advertisers on Facebook to manage their accounts and create new ads on the go. It’s Facebook's first cross-platform app, and it was built with React Native.

Ads can be complicated, as there can be a lot of contextual information in them. When we were designing these interactions for accessibility, we decided to group related information together. For example, a campaign list item displays the campaigner's name, campaign result, and campaign status in one single list item (e.g., "Hacker and Looper, Page Post Engagement, 29,967 Post Engagements, Status Active").



![](https://scontent-hkg3-1.xx.fbcdn.net/hphotos-xpt1/t39.2365-6/12057083_429032550627060_1728546419_n.jpg)



We can implement this behavior with React Native's Accessibility API easily. We just need to set accessible={true} on the parent component, and it will then gather all accessibility labels from its children.



      Hacker and Looper, Page Post Engagement
      29,967 Post Engagements



Nested UI elements, such as a switch inside a table row, also require specific accessibility support. When a user highlights a row with a screen reader, we want all the information in that row to be read back, as well as to indicate that there is an actionable element inside that row. The Accessibility API provides the ability to fetch the accessibility environment from the system and to listen to setting changes from the system. Now we can simply change the parent's behavior and inform the user through screen readers like VoiceOver or TalkBack (e.g., “double tap on row to toggle switch inside that row”). In the Ads Manager app, we use this switch to toggle the notification setting. When the row is highlighted, it will read out: "Ad Approved. On. Double tap to toggle setting."



![](https://scontent-hkg3-1.xx.fbcdn.net/hphotos-xtp1/t39.2365-6/12057155_921685684567792_354128754_n.jpg)



React Native's Accessibility API allows us to query the system's accessibility status:



    AccessibilityInfo.fetch().done((enabled) => {
      this.setState({
        AccessibilityEnabled: enabled,
      });
    });



We can then listen for accessibility status changes:



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



With these APIs, our product teams can then toggle touch actions based on the system's current accessibility info. For example, in the screenshot above, there are a lot of switches to toggle push notifications. When someone is using a screen reader, we can then read out the entire information in the row, including the toggle and state, e.g., “Ad Approved, Status On” — the user can then toggle the status by double tapping the highlighted area, e.g., double tap the row.



    var onSwitchValueChange = this.props.onValueChange;
    var onRowPress = null;
    if (this.state.isAccessibilityEnabled) {
      onSwitchValueChange = null;
      onRowPress = this.props.onValueChange;
    }

    var switch = 
    return



React Native provides a powerful way for you to build applications on iOS and Android, and it enables efficient reuse of code. With the React Native Accessibility API, you can make sure the great experiences you are creating will be usable by people with disabilities and other users of assistive technology.

For more information on the React Native AX API, check out our [developer documentation](https://www.facebook.com/l.php?u=https%3A%2F%2Ffacebook.github.io%2Freact-native%2Fdocs%2Faccessibility.html&h=NAQEjh5Hy&s=1).

