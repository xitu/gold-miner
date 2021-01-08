> * 原文地址：[Widgets on iOS](https://medium.com/@nrakshith94/widgets-on-ios-e0156a2e7239)
> * 原文作者：[Rakshith N](https://medium.com/@nrakshith94)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/widgets-on-ios.md](https://github.com/xitu/gold-miner/blob/master/article/2020/widgets-on-ios.md)
> * 译者：
> * 校对者：

# Widgets on iOS

Apple recently got on board with supporting widgets for iOS. They provide minimal but yet useful information to the user, without accessing the application.

![source: [computer world](https://www.computerworld.com/article/3564605/ios-14-how-to-use-widgets-on-ipad-and-iphone.html)](https://cdn-images-1.medium.com/max/2400/1*TRYbj13rl7VonfzuVL46RQ.jpeg)

This article aims at introducing this new world of Widgets. We will explore the WidgetKit SDK extensively and understand the components and procedure of building widgets.
You would need to be familiar with SwiftUI as building widgets makes extensive use of SwiftUI. As a widget is not an application in its true nature, it does not make use of app delegates or navigation stacks. Moreover a widget exists only with a parent application, it is not a standalone entity.
To summarise, widgets provide the user with a snapshot of the application information. The OS triggers the widget at set times to refresh its view, more on this in just a while.

#### Requirements

First, to start working with widgets, you would need the following:

1. Mac OS 10.15.5 or later.
2. Xcode 12 and above, [link](https://developer.apple.com/download/more/) to xcode 12, (this in case the update from app store does not work, mainly due to lack of space on the disk)

## The Setup

As previously mentioned, a widget cannot exist without a parent application. So first create a single view application. 
For the life cycle option I am selecting SwiftUI lifecycle, this would use the new convention of the @main attribute to determine the starting point in the code. 
Once done, we now need to add a new widget extension which will house the code for our widget.

> **Select File -> New -> Target -> Widget extension.**

![](https://cdn-images-1.medium.com/max/2940/1*a-KEHHxPtDKzcIIS1rVcGQ.png)

Give the widget any name you want, make sure you uncheck the option ‘**Include Configuration Intent**’. I will get to explaining this in just a while.

![](https://cdn-images-1.medium.com/max/2924/1*RBapNhpn2b858rtzyCNd5Q.png)

Next, click Finish and you would see a pop up asking you to activate your widget extension scheme, click on activate, and viola, your setup is complete.

![](https://cdn-images-1.medium.com/max/2000/1*ynPcdI0jU-bWjNmypreylA.png)

Now, select the swift file under the widget extension, you would see that Xcode has already generated most of the skeleton code. Let us understand each of these parts before we go ahead.
Navigate to the struct of type Widget, it would be the name of the widget file you entered during setup. You will notice the ‘@main’ attribute for this struct, indicating that this is the starting point for your widget. Let us break down the different properties here.

```Swift
       StaticConfiguration(kind: kind, provider: Provider()) { entry in
           Static_WidgetEntryView(entry: entry)
               .frame(maxWidth: .infinity, maxHeight: .infinity)
               .background(Color.black)
       }
       .configurationDisplayName("My Widget")
       .description("This is an example widget.")
```

**Kind :** this is an identifier for the widget, which can be used for performing updates or making queries.
**Provider :** this value is of type **‘TimelineProvider’**, which is the data source for the widget. It is responsible for determining what data needs to be displayed on the widget at different points of time.
**Content :** This is the SwiftUI view which will be displayed to the user.

Notice that under the WidgetConfiguration we are returning a StaticConfiguration instance. There exist two types of Widget configurations, static and intent. The intent configuration allows the user to configure the widget at run time. In the current configuration, the data displayed is static, that is, the user cannot change the data which is displayed on the widget during run time.

Moving on, let us talk about the **‘SimpleEntry’** struct. This is of type **‘TimelineEntry’**. It forms the data model for the widget. In our example we have only a date parameter, you could add other values based on your requirement. If for example you want to display a text to the user based on certain conditions, you would add the text parameter in here. Your struct needs to implement the date requirement as this provides the OS with different timestamps of your data.

Next up is the content of the widget, the struct **‘Static_WidgetEntryView’** is where you can let your creativity soar and design your widget. Keep in mind that there are certain restrictions on the size of the widget.

![image source: [https://withintent.com/blog/do-i-need-ios-widgets-for-my-mobile-app/](https://withintent.com/blog/do-i-need-ios-widgets-for-my-mobile-app/)](https://cdn-images-1.medium.com/max/4000/1*1_zg9sp_4LG7V5HM8UMTyA.png)

#### Supporting different sizes for the widget

WidgetKit supports three sizes, namely, small, medium and large.
Use the **‘supportedFamilies’** option during initiation of your widget to determine which sizes you would want to support, by default all sizes are enabled.

```
supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
```

Given that users can choose from three sizes for the widget, we would need to incorporate the UI for the widget likewise, to have the best look and feel for each size. In our View file, we need to be able to determine which size family has been selected by the user in order to change the UI in line with it. For this, widget kit provides an environment variable of the family size selected. We could then set up the UI based on the selected size.

```Swift
struct Static_WidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {

        switch family {
        case .systemSmall:
            ViewForSystemSmall(entry: entry)
        case .systemMedium:
            ViewForSystemMedium(entry: entry)
        case .systemLarge:
            ViewForSystemLarge(entry: entry)
        @unknown default:
            fatalError()
        }
    }
}
```

#### The TimeLine Provider

The last bit comprising our building blocks is the Provider. The struct Provider is of type **‘TimelineProvider’**, which implements three methods

```Swift
func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ())
func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ())
func placeholder(in context: Context) -> SimpleEntry
```

One to provide a placeholder for the widget, second to provide the snapshot and third to return the current timeline.

**The snapshot** is used by the OS when it is required to return a view as quickly as possible, without loading any data or making network calls. It is used in the Widget gallery, which lets the user preview the widget before adding it to the home screen. Ideally for a snapshot, configure a mocked view of the widget.

**The getTimeline function**, this method configures what the widget needs to display at different points in time. The **Timeline** is basically an array of objects that conform to the **TimelineEntry** protocol. For example, if you decide to create a widget to countdown the days left to a particular event. You would need to create some views starting from the current date up until the deadline.

![source: wwdc video](https://cdn-images-1.medium.com/max/5760/1*kgxFM7tdR4AZYHjVmWqHYw.png)

This is also where you would make any async network calls. The widget can make network calls to fetch data or it could use a container shared from the main host application to procure the data. The widget will display the data once the completion is called.

**Timeline Reload Policy**
In order to decide when the OS needs to update to the next set of views, it uses the ‘TimelineReloadPolicy’. 
The ‘**.atEnd**’ reload policy specifies that the OS will reload the timeline entries once there are no more entries. You will notice I have created a timeline separated by a duration of one minute. Five entries of the view are added, this way the widget will update after each minute and show the time accordingly. Once the duration of 5 minutes has elapsed, the ‘**getTimeline**’ method is invoked to retrieve the next set of views.
The TimelineReloadPolicy also provides options such as ‘**after(date)**’ and ‘**never**’, to update the timeline after a said date and to never update the timeline respectively.

```Swift
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        //enteries are separated by a minute
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
```

Run the project, on the home screen long press and click the ‘+’ on the top left. From the list of options select your widget app, you can then select the widget style you wish to add and click on ‘Add Widget’. You should see the widget displaying the current time.

## Dynamic Widget Configuration

So far our widget has been more or less static, the user cannot interact with the widget or define what the widget displays during runtime. Using the Intent configuration, we would be able to make our widget dynamic.
Initially when we setup the project we unchecked the option of ‘**Include Configuration Intent**’ to make the widget customisable, let us now see how we can make our widget more interactive.

For the purpose of this demonstration, we will setup our widget to let the user select from a list of options, in this case a list of cities.

## Setup for a custom intent

1) We need to create a custom intent definition, we will make use of ‘**SiriKit Intent Definition**’ for this. Click on the File menu option, select the New File option and proceed to select ‘SiriKit Intent Definition’, give it a name, I am naming it ‘CityNamesIntent’.

![](https://cdn-images-1.medium.com/max/4668/1*ABRRWfIFJfgSV5BgWhnD5w.png)

2) Select the newly created intent file, we now need to add a new Intent. To do this, click on the ‘+’ icon at the bottom left, select **New Intent**, let’s name it CityNames. Next under the **Custom Intent** section on the right, set the category to **‘View’** and make sure the option **‘Intent is eligible for widgets’** is selected.

![](https://cdn-images-1.medium.com/max/4664/1*1AezXCgg9qByWSpko1NOKA.png)

3) With the new intent added, we now need to define the properties that the intent will handle. In our case a simple enum for the city names will suffice. Click on the ‘+’ icon again, select **‘New Enum’**. Click on the newly created enum to access its properties. Under the **Cases section**, click the ‘+’ icon to add values to the enum, I have added different city names as you can see.

4) Lastly, head back to the CityName custom intent we created, under the parameter section, click the ‘+’ icon at the bottom and add a new parameter, name it cities. Provide an appropriate Display name and under the **‘type’** select the CityNamesEnum we created previously.

With that our custom intent definition is now complete. However our widget needs to be able to access this intent in order for us to use it. To expose the intent to our widget, head over to the **Project Targets** and under the **Supported Intents**, select the intent we created.

We now need to update our widget from Static to Intent configuration. 
For this, first let us create a new provider instance. Create a struct ‘ConfigurableProvider’ of type **IntentTimelineProvider**. We define the same three functions as we did in the case of TimelineProvider, the noticeable change here is the addition of the parameter ‘**configuration’**, which is of the type CityNamesIntent which we defined.
This configuration parameter can now be accessed to get the value chosen by the user and accordingly update or modify your timeline.

```Swift
struct ConfigurableProvider: IntentTimelineProvider {

    typealias Entry = SimpleEntry

    typealias Intent = CityNamesIntent

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(for configuration: CityNamesIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(for configuration: CityNamesIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
```

One last thing to update is changing the definition of our widget from Static to IntentConfiguration.
Under the **Static_Widget** definition, add a new IntentConfiguration, we notice it requires an intent instance, provide the **CityNameIntent** here. For the provider, use the **ConfigurableProvider** we created. The rest remains the same.

```Swift
@main
struct Static_Widget: Widget {
    let kind: String = "Static_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: CityNamesIntent.self,
                            provider: ConfigurableProvider(),
                            content: { entry in
                                Static_WidgetEntryView(entry: entry)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.black)
                            })
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
            .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
```

With that, our widget is now configurable. Run the application, long press the widget and select Edit Widget, you will see a list with city names we provided.
When any selection is made, you can access the selected value in the Provider and accordingly change the view.

![](https://cdn-images-1.medium.com/max/2000/1*iLhD0gNJKOIsZ5ICLtQ5lQ.png)

That brings us to the end of this article, I hope you were able to learn the basics of working with widgets. Widgets offer a new way of engaging the user and the possibilities are numerous. I strongly encourage you to explore other possibilities with widgets such as deep linking.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
