> * 原文地址：[Native Modules for React Native Android](https://shift.infinite.red/native-modules-for-react-native-android-ac05dbda800d#.cdjn1o88w)
* 原文作者：[Ryan Linton](https://shift.infinite.red/@ryanlntn)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[XHShirley](https://github.com/XHShirley)
* 校对者：[zhouzihanntu](https://github.com/zhouzihanntu), [PhxNirvana](https://github.com/phxnirvana)


# React Native Android 的 native 模块





当我们使用 React Native 开发一个安卓应用时，可能需要访问一个还没有对应的 React Native 模块的 API。我们可以通过用 Java 编写自己的 native 模块并向 React Native 选择性地开放接口来解决。让我们一起来试一试。

#### 我们将要做的事


在写这篇文章的时候，React Native 包含 ImagePickerIOS 组件却没有对应的安卓 ImagePicker 组件。我们打算创建一个功能行为大致跟 ImagePickerIOS 一样的简单的 ImagePicker 组件。







![](https://cdn-images-1.medium.com/max/800/1*HJh6eG8DnlT85X2mG86ryw.gif)




**根据下列步骤写一个安卓的 native 模块**

1. 创建一个 **ReactPackage** 对象，这个对象可以把许多模块组合到一起（包括 native 和 JavaScript)。在 **MainActivity** 中把它写进 **getPackages** 方法中。
2. 创建一个继承 **ReactContextBaseJavaModule** 的 Java 类来实现目标功能，并将这个类和我们的 **ReactPackage** 绑定。
3. 在上面创建的类里重写 **getName** 方法。它返回的名字会成为 JavaScript 中的 native 模块的名字。
4. 通过添加注解 **@ReactMethod** 的方式向 JavaScript 暴露想要的公有方法。
5. 最后，在你的 JavaScript 代码中导入 **NativeModules** 里的模块并调用这些方法。

让我们来看看实际中时什么样子。


#### 创建一个 ReactPackage


启动 AndroidStudio 并逐层找到 **MyApp/android/app/src/main/java/com/myapp/MainActivity.java** 文件。它看起来差不多应该是下面这个样子：

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
        	return Arrays.asList(new MainReactPackage());
        }
    }






我们准备乐观地把我们还未定义的包引进来。















	import com.myapp.imagepicker.*; // 导入包

	public class MainActivity extends ReactActivity { 

		@Override protected List getPackages() { 
			return Arrays.asList(new MainReactPackage(), new ImagePickerPackage()); // 把它包括进 getPackages 里 
		}
		
	}












现在，我们才来真正定义这个包。我们会为它创建一个名为 **imagepicker** 的新目录并把下面的代码添加进 **ImagePickerPackage** ：

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
    
        	return modules;
    	}
    
        @Override
        public List<Class> createJSModules() {
        	return Collections.emptyList();
        }
    
        @Override
        public List createViewManagers(ReactApplicationContext reactContext) {
        	return Collections.emptyList();
        }
    }


既然我们已经创建了一个包并且也把它放进了 **MainActivity** 。我们现在可以开始定义自己的模块了。

#### 创建一个 **ReactContextBaseJavaModule** 模块


我们将开始创建一个继承 **ReactContextBaseJavaModule** 的类 **ImagePickerModule**.





    package com.myapp.imagepicker;

    import com.facebook.react.bridge.ReactContextBaseJavaModule;

    public class ImagePickerModule extends ReactContextBaseJavaModule {
        public ImagePickerModule(ReactApplicationContext reactContext) {
        	super(reactContext);
    	}
    }


这是一个好的开端，但为了让 React Native 在 **NativeModules** 中找到我们的模块，我们需要重写 **getName** 方法。



	@Override 
	public String getName() { 
		return "ImagePicker"; 
	}


现在，我们有可以导入到 JavaScript 代码的功能完备的 native 模块了。让我们再让它做点有趣的事情。

#### 暴露方法

**ImagePickerIOS** 中定义了一个以 config 对象以及成功和取消两个回调对象为参数的 **openSelectDialog** 方法。让我们在 **ImagePickerModule** 中也定义一个类似的方法。

    import com.facebook.react.bridge.Callback;
    import com.facebook.react.bridge.ReadableMap;
    
    public class ImagePickerModule extends ReactContextBaseJavaModule {
        @ReactMethod
        public void openSelectDialog(ReadableMap config, Callback successCallback, Callback cancelCallback) {
        	Activity currentActivity = getCurrentActivity();
    
        	if (currentActivity == null) {
        		cancelCallback.invoke("Activity doesn't exist");
        		return;
    		}
    	}
    }














这里我们从 React Native 的 bridge 包导入分别对应 JavaScript **object** 和 **function** 的 **Callback** 和 **ReadableMap** 类。我们给这个方法添加注解 **@ReactMethod，**作为 **ImagePicker** 模块的一部分暴露给 JavaScript. 在这个方法体里， 我们获取当前的 activity ，如果它不存在的话也可以调用取消回调。现在我们就有一个能工作的方法了，但它还没有做任何有趣的事情。让我们给它添加打开画册的功能吧。

    public class ImagePickerModule extends ReactContextBaseJavaModule {
    private static final int PICK_IMAGE = 1;
    
    private Callback pickerSuccessCallback;
    private Callback pickerCancelCallback;
    
    @ReactMethod
    public void openSelectDialog(ReadableMap config, Callback successCallback, Callback cancelCallback) {
        Activity currentActivity = getCurrentActivity();
    
        if (currentActivity == null) {
            cancelCallback.invoke("Activity doesn't exist");
            return;
        }
    
        pickerSuccessCallback = successCallback;
        pickerCancelCallback = cancelCallback;
    
        try {
            final Intent galleryIntent = new Intent();
    
            galleryIntent.setType("image/*");
            galleryIntent.setAction(Intent.ACTION_GET_CONTENT);
    
            final Intent chooserIntent = Intent.createChooser(galleryIntent, "Pick an image");
    
            currentActivity.startActivityForResult(chooserIntent, PICK_IMAGE);
        } catch (Exception e) {
            cancelCallback.invoke(e);
        }
    }

首先，我们设置回调作为实例变量，原因之后会阐明。接着创建和配置我们的 **Intent** 并传入 **startActivityForResult**。最后，我们用 try/catch 语句块把整段代码囊括起来，处理期间可能产生的异常。

现在当你在 **ImagePicker** 调用 **openSelectDialog** 时应该看到一个图片画册。但是当选择一个图片时，画册会不做任何操作并消失。为了能返回图片数据，我们需要在模块中处理 activity 的结果。

首先我们需要在我们的 **react** 代码里添加一个 **activity** 的事件监听函数：



	public class ImagePickerModule extends ReactContextBaseJavaModule implements ActivityEventListener { 
		public ImagePickerModule(ReactApplicationContext reactContext) { 
			super(reactContext);
			reactContext.addActivityEventListener(this); 
		} 
	}

既然我们可以监听 activity 事件，我们就可以通过处理 **onActivityResult** 返回我们想要的图片数据。

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
    		    	}
    	    	}
        	}
    	}
    }






有了这段代码，当我们调用 **openSelectDialog** 时，应该能持续从成功回调中接收到图片的 URI。





    NativeModules.ImagePicker.openSelectDialog(
    {}, // no config yet 
    (uri) => { console.log(uri) },
    (error) => { console.log(error) }
    )


为了进一步模仿 **ImagePickerIOS** 的行为，我们可以建立设置选项，允许用户选择图片，视频或者同时支持直接开启摄像头。因为这些功能都是基于相同的概念，前面已经演示过了，所以就作为练习留给读者吧。











* * *







### 特别鸣谢

多亏 [Infinite Red](http://infinite.red/) 的技术主管 [Gant Laborde](https://medium.com/u/6ca0fe37eac1) 的帮助和支持，我才能写出这篇文章。他的丰富知识帮了我大忙。

### 关于 Ryan Linton

Ryan Linton 是 [Infinite Red](http://infinite.red/) 的资深软件工程师。他喜欢在把他们的项目带到生活中的同时与客户密切合作。在不折腾前端样式和后台数据库的时候，他会到世界各地去旅行，或者试图从他那飞速增长的书单上划去一两本（已经读过的书）。





