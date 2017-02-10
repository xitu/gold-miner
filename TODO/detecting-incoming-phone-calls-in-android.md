
> * 原文地址：[Detecting Incoming Phone Calls In Android](http://www.theappguruz.com/blog/detecting-incoming-phone-calls-in-android)
* 原文作者：[Parimal Gotecha](http://www.theappguruz.com/author/parimalgotecha)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[PhxNirvana](https://github.com/phxnirvana)
* 校对者：[XHShirley](https://github.com/XHShirley), [jamweak](https://github.com/jamweak)

# 在 Android 应用中监测来电信息




## 目标

本文的主要目标是监测 Android 中的来电状态信息。

**你想在你的 Android 应用中监测来电状态和来电号码么？**

**你在处理通话、摘机、空闲状态时无从下手么？**

**你想在收到来电、摘机（接听时的状态）或空闲（挂机状态）时做一些事情么？**

我最近搞的一个大工程中必须要用到监测电话信息。

如果你想知道我如何实现的话，就继续读下去吧。.

**即使应用关闭也可以监测来电信息**

你知道么，即使你的 Android 应用是关闭状态，也可以在应用中取到来电信息的。

这很酷，是吧？现在让我们看看该 **“怎么做”** ！

**关键点在于 Receiver**

你听说过 Android 里面的 receiver 么？

如果听说过的话，那么你会很容易的弄清楚手机状态这个概念的。

当然，没听说过也不要担心，我会告诉你 receiver 是什么以及如何在应用中使用它。

**RECEIVER 到底是个什么鬼东西？**

Broadcast receiver 帮助我们接收系统或其他应用的消息。

Broadcast receiver 响应来自系统本身或其他应用的广播信息（intent、event等）。

**点击以下链接获取更多知识：**

*   [https://developer.android.com/reference/android/content/BroadcastReceiver.html](https://developer.android.com/reference/android/content/BroadcastReceiver.html)

**在我们的应用里创建一个 Broadcast Receiver 需要执行以下两步：**

1.  创建 Broadcast Receiver
2.  注册 Broadcast Receiver

让我们先在 Android Studio 里建立一个带有空白 Activity 的简单工程。

**如果你第一次接触 Android studio 不知道如何创建新工程的话，点击以下链接：**

*   [http://www.theappguruz.com/blog/create-new-project-in-android-studio](http://www.theappguruz.com/blog/create-new-project-in-android-studio)

**让我们创建并注册 BROADCAST RECEIVER**

创建一个名为 **PhoneStateReceiver** 的 Java 类文件，并继承 **BroadcastReceiver** 类。

要注册 Broadcast Receiver的话，需要将以下代码写入 ```AndroidMainifest.xml``` 文件

```
<receiver android:name=".PhoneStateReceiver">
    <intent-filter>
        <action android:name="android.intent.action.PHONE_STATE" />
    </intent-filter>
</receiver>
```

### 注意

你必须在 ```<application>```标签内写这几行代码.



我们的主要目的是接收通话广播，所以我们需要将 ```android.intent.action.PHONE_STATE``` 作为 receiver 的 action。

**你的 ```AndroidMainifest.xml``` 文件应该和下图一样**:

![Phone State Receiver](http://www.theappguruz.com/app/uploads/2016/05/1-phonestatereceiver.png)

漂亮！我们成功的在项目中加入了一个 Broadcast Receiver。

**你得到权限了么？**

为了在应用中接收手机的通话状态广播，你需要取得对应的权限。

我们需要在 ```AndroidManifest.xml``` 文件中写入以下代码来获取权限。

```
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
``` 

**现在你的 ```AndroidManifest.xml``` 应该和下面这张图一样了**

![Read Phone State](http://www.theappguruz.com/app/uploads/2016/05/2-read_phone_state.png)

**关于 onReceive() 方法的来龙去脉**

现在让我们将目光转回到 继承了  **BroadcastReceiver** 的 **PhoneStateListener** 类中。

在这个类中我们需要重写 _```onReceive(Contex context, Intenet intent)```_ 方法，因为在基类（BroadcastReceiver）中这个方法是抽象方法（abstract method）。

**你对** onReceive() **方法了解多少呢？**

**如果我让你天马行空的想象一下这个方法的作用，你会怎么猜呢？**

**提示：** 它的名字已经解释了一切。

加油……努力……你离答案只有一步之遥了……

是的，就是你猜的那样。_**onReceive()**_ 使用 **Intent** 对象参数来接收每个消息。我们已经声明并在 **AndroidManifest.xml** 中注册了Broadcast Receiver。

现在，让我们将目光转向 **PhoneStateReciver.java** 文件来看看我们要在 _**onReceive()**_ 方法中做些什么。

    public void onReceive(Context context, Intent intent) {

        try {
            System.out.println("Receiver start");
            Toast.makeText(context," Receiver start ",Toast.LENGTH_SHORT).show();
        }
        catch (Exception e){
            e.printStackTrace();
        }

    }

我们已经做了一堆准备工作了，你觉得我们现在是不是可以检测到通话状态了呢？

先自己想一想。

目前只要收到来电就会弹出一个显示 **Receiver start** 消息的 toast，我们也会在控制台中收到同样的消息，因为我们已经将其输出到控制台中。
![Receiver Start](http://www.theappguruz.com/app/uploads/2016/05/receiver-start.png)

但……

**我们无法得知准确的通话状态，我们的目标是取到如下的状态：**

*   响铃
*   摘机
*   空闲

**保持冷静，继续探索手机状态**

那我们要怎么做来取到电话状态信息呢？ 你听说过 Android 里面的 Telephony Manager 么？

如果你对 Telephony Manager 不熟悉的话，别担心。我会教你什么是 Telephony Manager 以及如何用它取到通话状态的。

Telephony Manager 会将来自 Android 设备电话的全部状态信息告诉你。利用这些状态我们可以做许多事。

**想了解更多关于 Telephony Manager 的知识，请点以下链接：**

*   [https://developer.android.com/reference/android/telephony/TelephonyManager.html](https://developer.android.com/reference/android/telephony/TelephonyManager.html)

我们可以通过 **TelephonyManager.EXTRA_STATE** 来取得当前通话状态。它会用一个 **String** 对象来返回当前通话状态。

**以如下方式新建一个 String 对象来获取不同的通话状态信息：**

    String state = intent.getStringExtra(TelephonyManager.EXTRA_STATE);

**要获取不同的状态，我们可以用下面的代码达到目的：**

    if(state.equals(TelephonyManager.EXTRA_STATE_RINGING)){
        Toast.makeText(context,"Ringing State Number is -"+incomingNumber,Toast.LENGTH_SHORT).show();
    }
    if ((state.equals(TelephonyManager.EXTRA_STATE_OFFHOOK))){
        Toast.makeText(context,"Received State",Toast.LENGTH_SHORT).show();
    }
    if (state.equals(TelephonyManager.EXTRA_STATE_IDLE)){
        Toast.makeText(context,"Idle State",Toast.LENGTH_SHORT).show();
    }

现在我们的 **PhoneCallReceiver** 类应该如下所示：

![Broadcast Receiver](http://www.theappguruz.com/app/uploads/2016/05/4-broadcastreceiver-.png)

**是的，我们成功了！！！**

我们成功达到了目标，你可以用模拟器或真机来检验一下成果。

**如果你不知道如何打开模拟器的话，按照下面的步骤来：**

1.  打开 Android studio
2.  点击 Android Device Monitor。如果你找不到 Android Device Monitor 的话，看下面这张截图。

![Android Device Moniter](http://www.theappguruz.com/app/uploads/2016/05/android-device-moniter.png)

**下面这张图会显示如何操作模拟器**

![Emulator Control](http://www.theappguruz.com/app/uploads/2016/05/emulator-control.png)

如果你使用新版本的 Android Studio (2.1 +) 或者你有最新的 **HAXM** 那你要跟着下面这张图来

![Phone Device](http://www.theappguruz.com/app/uploads/2016/05/7-phone-device-1234567890.png)

就酱。你可以用模拟器来监测通话状态了，下面的截图显示了运行结果。

**结果 1\. 来电状态**

![Incoming Call State](http://www.theappguruz.com/app/uploads/2016/05/8-incoming-call-state.png)

**结果 2\. 接听状态**

![Call Receiver State](http://www.theappguruz.com/app/uploads/2016/05/9-call-receiver-state.png)

**结果 3\. 空闲状态**

![Call Idle State](http://www.theappguruz.com/app/uploads/2016/05/10-call-idle-state.png)

我们的主要目标就完成了。

**需要来电号码？**

你仔细看过 Telephony Manager 这个类么？

你看到 **TelephonyManager.EXTRA_INCOMING_NUMBER** 这个了么？

如果你已经了解了 **TelephonyManager.EXTRA_INCOMING_NUMBER**，那很好，证明你读过我在上面给的关于 Telephony Manager 类的链接了

**TelephonyManager.EXTRA_INCOMING_NUMBER** 用 String 的形式返回来电号码。

![Extra State](http://www.theappguruz.com/app/uploads/2016/05/11-extra-state.png)

    String incomingNumber = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER);

**如果你想在自己的应用中监测来电号码，可以利用下面的代码：**

    public class PhoneStateReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {

            try {
                String state = intent.getStringExtra(TelephonyManager.EXTRA_STATE);
                String incomingNumber = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER);

                if(state.equals(TelephonyManager.EXTRA_STATE_RINGING)){

                    Toast.makeText(context,"Ringing State Number is - " + incomingNumber, Toast.LENGTH_SHORT).show();
                }
            }
            catch (Exception e){
                e.printStackTrace();
            }

        }

啊哈！我们成功取到了来电号码！

但愿本篇博客在获取来电信息方面对你有所帮助。对于获取来电消息方面还有问题的话请留言，我会尽快回复的。

学习 Android 很棒，不是么？来看看其他的 [**Android 教程**](http://www.theappguruz.com/category/android) 吧。

有开发 Android 应用的灵感？还等什么，快 [**联系我们**](http://www.theappguruz.com/contact-us) ，灵感直播即将上线。我们的公司被提名为印度最好的  [**Android 应用开发公司**](http://www.theappguruz.com/android-app-development) 。
