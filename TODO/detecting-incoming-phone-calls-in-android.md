> * 原文地址：[Detecting Incoming Phone Calls In Android](http://www.theappguruz.com/blog/detecting-incoming-phone-calls-in-android)
* 原文作者：[Parimal Gotecha](http://www.theappguruz.com/author/parimalgotecha)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Detecting Incoming Phone Calls In Android




## Objective

The main objective of this blog post is to give you an idea about how to detect phone call state in Android.

**Are you trying to detect incoming call and incoming call number in your Android app?**

**Are you facing problem in detecting whether your phone is in ringing state, receiving state (off hook) or idle state?**

**Do you wish to take any action when there is an incoming call or when the phone goes into off hook state (Phone goes into off hook state when you receive a call) or when the phone goes into idle state (when you cut your call)?**

I was working on a pretty huge Android project recently. In that I had to detect the state of the phone.

So if you wish to know how I achieved that, read on further.

**DETECT PHONE CALL STATE EVEN YOUR APPLICATION IS CLOSED**

Do you know, even when your app is closed you can detect phone call states in your Android phone from within your app?

Cool…right? Now lets concentrate on **"How to do"** that!

**RECEIVERS ARE THE KEY**

Have you heard about receivers in Android?

If yes, then learning the phone state concept would be pretty easy for you

And don’t worry if you are not familiar with receivers, I will tell you what actually receiver is and how to use it in our app.

**WHAT THE HELL ARE RECEIVERS?**

Broadcast receivers help us to receive messages from system or other applications.

Broadcast receiver respond to broadcast messages (intent, events etc.) from system it self or other applications.

**To know more about Broadcast Receiver, follow below link:**

*   [https://developer.android.com/reference/android/content/BroadcastReceiver.html](https://developer.android.com/reference/android/content/BroadcastReceiver.html)

**To implement Broadcast Receiver in our app, we have to follow below 2 steps:**

1.  Create Broadcast Receiver
2.  Register Broadcast Receiver

Lets first create a simple project in Android Studio with blank activity.

**If you are new to Android studio and don’t know how to create new project, please check the following link:**

*   [http://www.theappguruz.com/blog/create-new-project-in-android-studio](http://www.theappguruz.com/blog/create-new-project-in-android-studio)

**LETS CREATE & REGISTER A BROADCAST RECEIVER**

Create one Java class named **PhoneStateReceiver** and it should extend **BroadcastReceiver** class.

To register Broadcast Receiver, write below codes in **AndroidMainifest.xml** file.

    
        
            
        
    





### Note

You must write these lines between ****tag.



Our main goal is to receive mobile phone call state. So for that we have to define **android.intent.action.PHONE_STATE** as an action.

**Now your AndroidMainifest.xml file should look like below**:

![Phone State Receiver](http://www.theappguruz.com/app/uploads/2016/05/1-phonestatereceiver.png)

Voila! We have successfully integrated Broadcast Receiver to our project.

**HAVE YOU TAKEN PERMISSION FROM USER?**

In order to receive phone call state in an application, you have to take permission from the users.

To take permission, we need to write below line in our **AndroidManifest.xml** file.

    

**Now your AndroidManifest.xml file should look like below:**

![Read Phone State](http://www.theappguruz.com/app/uploads/2016/05/2-read_phone_state.png)

**THE STORY OF onReceive() METHOD**

Now lets get back to our **PhoneStateListener** class, where we have extended **BroadcastReceiver**.

In this class, we must override _**onReceive(Contex context, Intenet intent)**_ method because it’s an abstract method of BroadcastReceiver class.

_Do you have any idea about **onReceive()** method?_

_If I ask you to take a wild guess about what the method should be doing, what your guess would be?_

_**Hint:** The name itself is self-explanatory._

_Guess… Guess… Guess..._

Yes, you have done it. Your thinking is totally right that _**onReceive()**_ method receives each message as an **Intent** object parameter. We have already declared Broadcast Receiver & registered it in **AndroidManifest.xml**.

Now, let’s take a look at **PhoneStateReciver.java** file and specifically we would be focusing upon _**onReceive()**_ method of that class.

    public void onReceive(Context context, Intent intent) {

        try {
            System.out.println("Receiver start");
            Toast.makeText(context," Receiver start ",Toast.LENGTH_SHORT).show();
        }
        catch (Exception e){
            e.printStackTrace();
        }

    }

_We are done with lot of stuff. Do you think now we would be able to detect phone state?_

_Think over it._

Right now, whenever a phone call comes we’ll get a toast message that says **Receiver start** and we’ll also be able to see that in our console since we have also printed the statement on the console.

![Receiver Start](http://www.theappguruz.com/app/uploads/2016/05/receiver-start.png)

But…

**We won’t be able to identify the different states of the phone. Our objective was to find the states like:**

*   Ringing
*   Off Hook
*   Idle

**KEEP CALM AND KEEP IT UP TO DETECT PHONE STATES**

_What we have to do to detect all phone states? Do you know about Telephony Manager in Android?_

_Don’t worry if you are not familiar with Telephony Manager. I’ll guide you what is Telephony Manager and how we can use it to detect phone call states._

Telephony Manager gives you all the states information of Android devices calls. Using these states, we can preform various actions.

**If you wish to learn more about Telephony Manager, please go through below link:**

*   [https://developer.android.com/reference/android/telephony/TelephonyManager.html](https://developer.android.com/reference/android/telephony/TelephonyManager.html)

We can detect our phone call states using **TelephonyManager.EXTRA_STATE**. It indicates the current call state and it will return phone state as a **String Object**.

**So declare one String object like below and get different phone call states:**

    String state = intent.getStringExtra(TelephonyManager.EXTRA_STATE);

**To get different phone call states, we have to implement our code like below:**

    if(state.equals(TelephonyManager.EXTRA_STATE_RINGING)){
        Toast.makeText(context,"Ringing State Number is -"+incomingNumber,Toast.LENGTH_SHORT).show();
    }
    if ((state.equals(TelephonyManager.EXTRA_STATE_OFFHOOK))){
        Toast.makeText(context,"Received State",Toast.LENGTH_SHORT).show();
    }
    if (state.equals(TelephonyManager.EXTRA_STATE_IDLE)){
        Toast.makeText(context,"Idle State",Toast.LENGTH_SHORT).show();
    }

So now our **PhoneCallReceiver** class looks like below:

![Broadcast Receiver](http://www.theappguruz.com/app/uploads/2016/05/4-broadcastreceiver-.png)

**YES, FINALLY WE DID IT..!!!**

We have successfully implemented all the things. You can check using emulator as well as installing app into your device.

**If you don’t know how to check in emulator using device monitor, please follow below steps:**

1.  Start Android studio
2.  Click on Android Device Monitor. See below screenshot if you can’t find Android Device Monitor.

![Android Device Moniter](http://www.theappguruz.com/app/uploads/2016/05/android-device-moniter.png)

**Follow below screenshots to get more idea:**

![Emulator Control](http://www.theappguruz.com/app/uploads/2016/05/emulator-control.png)

If you are using new version of Android Studio (2.1 +) or if you have latest **HAXM** then you have to follow screenshot steps:

![Phone Device](http://www.theappguruz.com/app/uploads/2016/05/7-phone-device-1234567890.png)

_That’s it… You are finished with all the things and now you can detect all the phone states using emulator. You can find outputs like below screenshots._

**OUTPUT 1\. INCOMING CALL STATE DETECTED**

![Incoming Call State](http://www.theappguruz.com/app/uploads/2016/05/8-incoming-call-state.png)

**OUTPUT 2\. RECEIVING CALL STATE DETECTED**

![Call Receiver State](http://www.theappguruz.com/app/uploads/2016/05/9-call-receiver-state.png)

**OUTPUT 3\. IDEAL STATE DETECTED**

![Call Idle State](http://www.theappguruz.com/app/uploads/2016/05/10-call-idle-state.png)

We’re done with our main goal of detect phone states.

**NEED INCOMING CALL NUMBER?**

_Have you read Telephony Manager class in detail?_

_Have you seen **TelephonyManager.EXTRA_INCOMING_NUMBER**?_

_If you are already aware about **TelephonyManager.EXTRA_INCOMING_NUMBER**, that’s good it means you already read my given link of Telephony Manager class._

**TelephonyManager.EXTRA_INCOMING_NUMBER** returns an incoming call number as a string.

![Extra State](http://www.theappguruz.com/app/uploads/2016/05/11-extra-state.png)

    String incomingNumber = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER);

**If you wish to detect incoming call number in your app then you can do so using below code:**

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

_Yupii...We have successfully detected Incoming call number..!!!_

I hope you find this blog post very helpful while with Detecting incoming phone calls concept. Let me know in comment if you have any questions regarding Detecting incoming phone calls. I will reply you ASAP.

Learning Android sounds fun, right? Why not check out our other [**Android Tutorials**](http://www.theappguruz.com/category/android)?

Got an Idea of Android App Development? What are you still waiting for? [**Contact Us**](http://www.theappguruz.com/contact-us) now and see the Idea live soon. Our company has been named as one of the best [**Android Application Development Company**](http://www.theappguruz.com/android-app-development) in India.