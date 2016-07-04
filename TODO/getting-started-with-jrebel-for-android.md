>* 原文链接 : [Getting started with JRebel for Android](https://medium.com/@shelajev/getting-started-with-jrebel-for-android-426633cde736#.dtldka9ua)
* 原文作者 : [Oleg Šelajev](https://medium.com/@shelajev)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [edvardhua](https://github.com/edvardHua)
* 校对者: [DeadLion](https://github.com/DeadLion), [circlelove](https://github.com/circlelove)

只要你的项目相对较小，开发Android应用的用户体验还是很棒的。然而随着项目功能的增加，你会发现构建项目的时间也会随着增长。这种情况会导致你的大部分时间都花在如何更快的构建项目，而不是为应用增加更多的价值。

网上有很多教你如何加快Gradle构建速度的教程。有一些很好的文章，譬如“[Making Gradle builds faster](http://zeroturnaround.com/rebellabs/making-gradle-builds-faster/)”。 通过这些方法我们可以节省几秒甚至几分钟的构建时间，但是仍然存在一些构建上的瓶颈。举个例子，基于注释的依赖注入使得项目架构清晰，但是这对项目构建时间是有很大影响的。

但是你可以尝试一下使用[JRebel for Android](https://zeroturnaround.com/software/jrebel-for-android/?utm_source=medium&utm_medium=getting-started-jra-post&utm_campaign=medium)。每次改动代码后不需要重新安装新的 apk。而是在安装完一次应用后，通过增量包传递到设备或者模拟器上，并且能够在应用运行时进行更新。这个想法（热部署）已经在JRebel的java开发工具上面使用超过8年的时间。

拿Google IO 2015 app来看看如何使用JRebel for Android，以及它能为我们节省多少宝贵的时间。

### 安装 JRebel for Android

[JRebel for Android](https://zeroturnaround.com/software/jrebel-for-android/?utm_source=medium&utm_medium=getting-started-jra-post&utm_campaign=medium) 是一个Android Studio的插件，你可以直接点击IDE的 _Plugins > Browse Repositories_ 键入“JRebel for Android”来搜索和安装插件。

![](http://ww4.sinaimg.cn/large/a490147fgw1f3y7px3ajhj20hs0fzmzm.jpg)

如果因为某些原因你无法访问 maven 的公有仓库，你可以直接在 JetBrians 官网下载，然后通过 _Plugins > Install plugin from disk…_ 来安装插件。

当你安装完插件后，你需要重启Android Studio，在重启之后，你需要提供你的姓名和邮箱来得到JRebel for Android的21天免费使用。

### 用 JRebel for Android 来运行你的应用程序

安装完插件后，只需要点击 _Run with JRebel for Android_ 按钮，它会检测这次代码与上次是否有改动，然后决定是否构建一个新的apk。_Run with JRebel for Android_ 其实和Android Studio中的 _Run_ 操作是一样的。所以有同样的运行流程，首先需要你选择一个设备，然后再构建apk安装到那台设备上去。

为了更新代码和资源，JRebel for Android 需要处理项目 classes，并嵌入一个代理应用。JRebel for Android只会运行在调试模式下，所以对于正式发布的版本来说是没有影响的。另外，使用该插件也不需要你在项目中做任何改动。想要知道更多JRebel for Android的细节，请看[under the hood post](http://zeroturnaround.com/rebellabs/under-the-hood-of-jrebel-for-android/)。（译者注：InfoQ的一篇介绍JRebel for Android的[文章](http://www.infoq.com/cn/news/2016/01/jrebel-for-android-stable?appinstall=0)写的不错。）

所以在Google IO 2015应用上点击 _Run with JRebel for Android_ 将会得到如下的结果：

![](http://ww1.sinaimg.cn/large/a490147fgw1f3y7qkkn2jj20hs0b60ud.jpg)

### 在JRebel for Android应用代码修改

 _Apply changes_ 按钮是使用 JRebel for Android的关键，它将会做最少的工作来将你代码的改动更新到你的设备上去。如果你没有使用 _Run with JRebel for Android_ 来部署应用的话，_Apply changes_ 将会帮你做这部分的工作。

现在让我们在应用上做一个简单的功能改动。针对于GoogleIO中每一个举行的子会场你都可以发送反馈问卷，我们给这个问卷添加多一个输入框输入你的姓名，当你完成反馈的时候会弹出Toast来感谢你的反馈。

**步骤一：** 在  _session_feedback_fragment.xml_ 中添加一个EditTex组件。

    <FrameLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content">
        <EditText
            android:id="@+id/name_input"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"/>
    </FrameLayout>

![](http://ww3.sinaimg.cn/large/a490147fgw1f3y7qzqpp4j20ja0zaq5o.jpg)

**步骤2：** 调整间距

    <FrameLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:paddingLeft="@dimen/padding_normal"
        android:paddingStart="@dimen/padding_normal"
        android:paddingRight="@dimen/padding_normal"
        android:paddingEnd="@dimen/padding_normal"
        android:paddingTop="@dimen/spacing_micro"
        android:paddingBottom="@dimen/padding_normal">

![](http://ww1.sinaimg.cn/large/a490147fgw1f3y7rcrfolj20jk0ziacq.jpg)

**步骤3：** 添加提示

    <EditText
        android:id="@+id/name_input"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:hint="@string/name_hint"/>

![](http://ww1.sinaimg.cn/large/a490147fgw1f3y7romijnj20j80zgdij.jpg)

这些改动现在都是在同一个页面上，每一次按下 _Apply change_  按钮后，JRebel for Android都会调用[Activity.recreate()](https://developer.android.com/reference/android/app/Activity.html#recreate%28%29)。在最顶部的activity将会同样的回调方法，就像设备从纵向切换到横向那样。

到目前为止我们都还只是改动resource文件，下面我们来改动Java代码。

**步骤4：** 在 _SessionFeedbackFragment.sumbitFeedback()_ 方法中弹出Toast

    EditText nameInput = (EditText) 

    getView().findViewById(R.id.name_input);

    Toast.makeText(getActivity(), "Thanks for the feedback " + 

    nameInput.getEditableText().toString(), Toast.LENGTH_SHORT).show();

![](http://ww4.sinaimg.cn/large/a490147fgw1f3y7s07qioj20je0zi0wr.jpg)

### 应用重启动 vs Activity重启动

并不是所有的改动都会触发调用[Activity.recreate()](https://developer.android.com/reference/android/app/Activity.html#recreate%28%29)的。如果你在AndroidManifest改动了一些内容，一个新的 apk 将会被构建并增加安装。在这种情况下，应用将会重新启动。或者你替换或改动了已经被实现的superclass或者interfaces的时候也会导致应用重启动。下面有一份完整的对照表：

![](http://ww1.sinaimg.cn/large/a490147fgw1f3y7sb4pmdj20gq07kabk.jpg)

### 为什么我要尝试使用JRebel for Android

下面我列出了最有说服力的理由，来让你使用它。

*   可以快速看到自己代码改动的效果。
*   可以有时间打磨素完美的UI，而不用浪费时间在构建上。
*   不需要在项目中做任何改动来支持 JRebel for Android。
*   在调试程序的同时还能更新代码和资源文件。没错，[JRebel for Android](https://zeroturnaround.com/software/jrebel-for-android/?utm_source=medium&utm_medium=getting-started-jra-post&utm_campaign=medium)支持调试器的全部特性。
