> * 原文地址：[Native Modules for React Native Android](https://shift.infinite.red/native-modules-for-react-native-android-ac05dbda800d#.cdjn1o88w)
* 原文作者：[Ryan Linton](https://shift.infinite.red/@ryanlntn)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Native Modules for React Native Android






When developing an Android application with React Native you may need to access an API that doesn’t yet have a corresponding React Native module. This can easily be done by writing your own native module in Java and selectively exposing its public API to React Native. Let’s give it a try!

#### What We’ll Be Making

At the time of this writing, React Native contains the component ImagePickerIOS but no corresponding ImagePicker component for Android. We’re going to build our own simple ImagePicker component that roughly mirrors the behavior of ImagePickerIOS.







![](https://cdn-images-1.medium.com/max/800/1*HJh6eG8DnlT85X2mG86ryw.gif)



**Writing a native module for Android involves the following steps:**

1.  Create a _ReactPackage_, a wrapper object grouping many modules (both native and JavaScript) together, and include it in the _getPackages_ method of _MainActivity_.
2.  Create a Java class extending _ReactContextBaseJavaModule_ that implements the desired functionality and register it with our _ReactPackage_.
3.  Override the _getName_ method in the aforementioned class. This will be the name of the native module in JavaScript.
4.  Expose desired public methods to JavaScript by annotating them with _@ReactMethod_.
5.  Finally, import the module from _NativeModules_ in your JavaScript code and call the methods.

Let’s see what this looks like in practice.

#### Creating a ReactPackage

Fire up AndroidStudio and navigate to _MyApp/android/app/src/main/java/com/myapp/MainActivity.java_. It should look something like this:

    package com.myapp;

    import com.facebook.react.ReactActivity;
    import com.facebook.react.ReactPackage;
    import com.facebook.react.shell.MainReactPackage;

    import java.util.Arrays;
    import java.util.List;

    public class MainActivity extends ReactActivity {
    @Override
    protected String getMainComponentName() {
    return "MyApp";
    }

    @Override
    protected boolean getUseDeveloperSupport() {
    return BuildConfig.DEBUG;
    }
    @Override
    protected List getPackages() {
    return Arrays.asList(
    new MainReactPackage()
    );
    }
    }





We’re going to be optimistic and include the package we haven’t yet defined.















import com.myapp.imagepicker.*; // import the package public class MainActivity extends ReactActivity { @Override protected List getPackages() { return Arrays.asList( new MainReactPackage(), new ImagePickerPackage() // include it in getPackages ); }}











Now let’s actually define that package. We’ll create a new directory for it called _imagepicker_ and include the following in _ImagePickerPackage_:

    package com.myapp.imagepicker;

    import com.facebook.react.ReactPackage;
    import com.facebook.react.bridge.JavaScriptModule;
    import com.facebook.react.bridge.NativeModule;
    import com.facebook.react.bridge.ReactApplicationContext;
    import com.facebook.react.uimanager.ViewManager;

    import java.util.ArrayList;
    import java.util.Collections;import java.util.List;

    public class ImagePickerPackage implements ReactPackage {
    @Override
    public List createNativeModules(ReactApplicationContext reactContext) {
    List modules = new ArrayList<>();

    modules.add(new ImagePickerModule(reactContext));

    return modules;}

    @Override
    public List<Class> createJSModules() {
    return Collections.emptyList();
    }

    @Override
    public List createViewManagers(ReactApplicationContext reactContext) {
    return Collections.emptyList();}
    }

Now that we’ve created the package and included it in the _MainActivity_we’re ready to start defining our module.

#### Creating a _ReactContextBaseJavaModule_

We’ll start by creating the _ImagePickerModule_ class, and extending _ReactContextBaseJavaModule._





    package com.myapp.imagepicker;

    import com.facebook.react.bridge.ReactContextBaseJavaModule;

    public class ImagePickerModule extends ReactContextBaseJavaModule {
    public ImagePickerModule(ReactApplicationContext reactContext) {
    super(reactContext);
    }
    }

That’s a good start, but in order for React Native to find our module in _NativeModules_ we’ll need to override the _getName_ method.



@Override public String getName() { return "ImagePicker"; }

We now have a fully functional (if totally useless) native module that we can import in our JavaScript code. Let’s make it do something a bit more interesting.

#### Exposing Methods

_ImagePickerIOS_ defines an _openSelectDialog_ method that takes a config object and success and cancel callbacks. Let’s define a similar method in _ImagePickerModule_.

    import com.facebook.react.bridge.Callback;
    import com.facebook.react.bridge.ReadableMap;

    public class ImagePickerModule extends ReactContextBaseJavaModule {
    @ReactMethod
    public void openSelectDialog(ReadableMap config, Callback successCallback, Callback cancelCallback) {
    Activity currentActivity = getCurrentActivity();

    if (currentActivity == null) {
    cancelCallback.invoke("Activity doesn't exist");return;
    }
    }
    }













Here we import _Callback_ and _ReadableMap_ from React Native bridge which correspond to JavaScript _object_ and _function_ respectively. We annotate the method with _@ReactMethod_ exposing it to JavaScript as part of the _ImagePicker_ module. In the body of the method we get the current activity or call the cancel callback if it doesn’t exist. We now have a working method, but it doesn’t do anything interesting yet. Let’s add to it to make it open the image gallery.

    @Override
    public void onActivityResult(final int requestCode, final int resultCode, final Intent intent) {
    if (pickerSuccessCallback != null) {
    if (resultCode == Activity.RESULT_CANCELED) {
    pickerCancelCallback.invoke("ImagePicker was cancelled");
    } else if (resultCode == Activity.RESULT_OK) {
    Uri uri = intent.getData();

    if (uri == null) {
    pickerCancelCallback.invoke("No image data found");
    } else {
    try {
    pickerSuccessCallback.invoke(uri);
    } catch (Exception e) {
    pickerCancelCallback.invoke("No image data found");

First, we set the callbacks as instance variables for reasons that will become clear later. Then we create our _Intent,_ configure it and pass it to _startActivityForResult_. Finally, we wrap the whole thing in a try/catch block to handle any exceptions we might run into.

You should now see an image gallery when you call _openSelectDialog_ on _ImagePicker_. However when you select an image the gallery will just dismiss itself without doing anything. In order to actually return any image data we’ll need to handle the activity result in our module.

First we’ll need to add an activity event listener to our react context:



public class ImagePickerModule extends ReactContextBaseJavaModule implements ActivityEventListener { public ImagePickerModule(ReactApplicationContext reactContext) { super(reactContext); reactContext.addActivityEventListener(this); } }

Now that we can listen to activity events we can handle _onActivityResult_ and return the image data we want.

    @Override
    public void onActivityResult(final int requestCode, final int resultCode, final Intent intent) {
    if (pickerSuccessCallback != null) {
    if (resultCode == Activity.RESULT_CANCELED) {
    pickerCancelCallback.invoke("ImagePicker was cancelled");
    } else if (resultCode == Activity.RESULT_OK) {
    Uri uri = intent.getData();

    if (uri == null) {
    pickerCancelCallback.invoke("No image data found");
    } else {
    try {
    pickerSuccessCallback.invoke(uri);
    } catch (Exception e) {
    pickerCancelCallback.invoke("No image data found");





With this in place we should now be receiving the image URI in the success callback of our call to _openSelectDialog_.





    NativeModules.ImagePicker.openSelectDialog(
    {}, // no config yet 
    (uri) => { console.log(uri) },
    (error) => { console.log(error) }
    )

To further mirror the behavior of _ImagePickerIOS,_ we could build on the configuration options allowing users to pick images, video, or both as well as support opening the camera directly. As these features would be building on the same concepts already demonstrated, we’ll leave them as an exercise to the reader.











* * *







### Special Thanks

I could not have done this without the help and support of [Infinite Red](http://infinite.red/)Technical Lead [Gant Laborde](https://medium.com/u/6ca0fe37eac1). His intimate knowledge of toast saved my bacon.

### About Ryan Linton

Ryan Linton is a Senior Software Engineer at [Infinite Red](http://infinite.red/) who enjoys working closely with clients while bringing their projects to life. When not tweaking styles and queries he can often be found traveling the world or desperately trying to make a dent in his ever growing reading list.





