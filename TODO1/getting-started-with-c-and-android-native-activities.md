> * 原文地址：[Getting Started with C++ and Android Native Activities](https://medium.com/androiddevelopers/getting-started-with-c-and-android-native-activities-2213b402ffff)
> * 原文作者：[Patrick Martin](https://medium.com/@pux0r3)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/getting-started-with-c-and-android-native-activities.md](https://github.com/xitu/gold-miner/blob/master/TODO1/getting-started-with-c-and-android-native-activities.md)
> * 译者：
> * 校对者：

# Getting Started with C++ and Android Native Activities

### Introduction

I would like to walk you through setting up a simple Android Native Activity. I will walk through the basic setup, and try to give you the tools you need to move forward.

Although my focus is on games, I will not be telling you how to write an OpenGL application or how to architect your own game engine. That is a discussion that literally fills up books.

### Why C++

On Android, the OS and its supporting infrastructure are designed to support applications written in the Java or Kotlin programming languages. Applications written in these languages benefit from tooling embedded deep into the system’s underlying architecture. Many core Android system features, such as the Android UI and Intent handling, are only exposed through Java interfaces.

By choosing to use C++, you are not being “more native” to Android than using a managed language such as Kotlin or Java. Counter intuitively, you are in some ways writing a foreign application with only a subset of Android features available. For most applications, you’re better off with languages like Kotlin.

There are a few exceptions to this rule. Near and dear to my own heart is game development. Since games typically use custom rendering logic, often written in OpenGL or Vulkan, it’s expected that a game looks different from a standard Android application. When you also consider that C and C++ are near universal to every computing platform, and the relative wealth of C libraries to support games development, it may become reasonable to set off down the path of native development.

If you want to make a game from scratch or port over an existing game, Android’s Native Development Kit (or NDK) and its supporting tooling are ready and waiting. In fact, the native activity I’ll be showing you provides an easy one-stop shop in which you can set up an OpenGL canvas and start gathering user input. You may find that despite C’s cognitive overhead, some common code challenges like building vertex attribute arrays from game data become easier in C++ than higher level languages.

### What I won’t Cover

I will stop short of showing you how to initialize a [Vulkan](https://www.khronos.org/vulkan/) or [OpenGL](https://www.khronos.org/opengles/) context. I recommend reading through the [samples](https://github.com/googlesamples/android-ndk/) Google provides, although I will provide some tips to make your life easier. You may opt instead to use a library like [SDL](https://www.libsdl.org/) or even Google’s [FPLBase](https://google.github.io/fplbase/) instead.

### Setup your IDE

First we need to make sure that you have everything installed for native development. For this, we need the Android NDK. Launch Android Studio:

![](https://cdn-images-1.medium.com/max/800/0*PA-Xq6EqB-lE3jrt)

And under “Configure” select “SDK Manager”:

![](https://cdn-images-1.medium.com/max/800/0*XkTYhsrl0frw9d1A)

From here install LLDB (the native debugger), CMake (the build system we’ll use), and the NDK itself:

![](https://cdn-images-1.medium.com/max/800/0*Uy97JiOnnh2aar8b)

### Create your project

Now that you have everything setup, we’ll create a project. We’ll want to create an empty project with no Activity:

![](https://cdn-images-1.medium.com/max/800/0*5gtGSseWGEljglcK)

NativeActivity has been in Android since Gingerbread, but I’d recommend choosing the highest target available to you at the time if you’re just learning.

![](https://cdn-images-1.medium.com/max/800/0*EHxm6XZy9PFoX1BJ)

Now we need to make a CMakeLists.txt to tell Android how to build our C++ project. Right click on your app in the project view, and create a new file:

![](https://cdn-images-1.medium.com/max/800/0*3174Sy0lsdV_izN8)

Named CMakeLists.txt:

![](https://cdn-images-1.medium.com/max/800/0*UjYrafAf-GIjfcp1)

And make a simple CMake file:

```
cmake_minimum_required(VERSION 3.6.0)

add_library(helloworld-c
    SHARED
    
    src/main/cpp/helloworld-c.cpp)
```

We’re stating that we’re using the latest CMake in Android Studio (3.6.0), and that we’re building a shared library called helloworld-c. I also added a source file that we have to create.

Why a shared library and not an executable? Android uses a process called Zygote, to accelerate the process of launching an application or service inside the Android Runtime. This applies to every user-facing process in Android, so the first chance your app will get to run code will actually be inside a managed VM. The managed code then must load a shared library file with your logic in it, which is handled for you if you use a native activity. Conversely, when building an executable the expectation is that the operating system will directly load your program and execute a C function called “main.” This is _possible_ in Android, but I haven’t found any practical uses for it.

Now to create the C++ file:

![](https://cdn-images-1.medium.com/max/800/0*3bEdMVWFetPHaLh8)

And relocate it to the directory we specified in the make file:

![](https://cdn-images-1.medium.com/max/800/1*0RgvGlIX1A5qXOO-W5K0Zw.png)

And let’s put in something small that will tell us if it’s building correctly:

```
//
// Created by Patrick Martin on 1/30/19.
//

#include <jni.h>
```

And finally, let’s link the C++ project into our application:

![](https://cdn-images-1.medium.com/max/800/0*peP9yeLNekk5o0Yg)

![](https://cdn-images-1.medium.com/max/800/0*Rkx1eC_6gH0nZ1N5)

If all goes well, the project will update successfully:

![](https://cdn-images-1.medium.com/max/800/0*gbNXngCYA7e990Vn)

And you can run a build without any issues:

![](https://cdn-images-1.medium.com/max/800/0*SpKDW8ZXatIV2ioE)

As for what changed in your build script. If you open your app’s build.gradle, you should see this `externalNativeBuild` entry:

```
android {
    compileSdkVersion 28
    defaultConfig {
        applicationId "com.pux0r3.helloworldc"
        minSdkVersion 28
        targetSdkVersion 28
        versionCode 1
        versionName "1.0"
        testInstrumentationRunner "android.support.test.runner.AndroidJUnitRunner"
    }
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    externalNativeBuild {
        cmake {
        path file('CMakeLists.txt')
        }
    }
}
```

### Create a Native Activity

An Activity is basically the window Android uses show an interface to your app. Normally you would write a class in Java or Kotlin that extends Activity, but Google created a special C equivalent called a native activity.

### Setup your build file

The best way to create a native activity is to include `native_app_glue`. Many samples copy it out of the SDK and into their project. There’s nothing wrong with this, but it’s my personal preference to leave it in place and make this a library that my game depends on. I’ll make this a STATIC library so I don’t pay the extra cost of dynamic library calls:

```
cmake_minimum_required(VERSION 3.6.0)

add_library(native_app_glue STATIC
    ${ANDROID_NDK}/sources/android/native_app_glue/android_native_app_glue.c)
target_include_directories(native_app_glue PUBLIC
    ${ANDROID_NDK}/sources/android/native_app_glue)

find_library(log-lib
    log)

set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -u ANativeActivity_onCreate")
add_library(helloworld-c SHARED
    src/main/cpp/helloworld-c.cpp)

target_link_libraries(helloworld-c
    android
    native_app_glue
    ${log-lib})
```

There’s a _lot_ to break down here, so lets start. First I `add_library` to create a library called `native_app_glue` and denote it as a `STATIC` library. Then I look for the automatically generated environment variable `${ANDROID_NDK}` to look for some files in the NDK installation. Using this, I pull out the implementation for native_app_glue: `android_native_app_glue.c`.

After I have my code associated with a target, I want to say where the target finds its header files. I use `target_include_directories` to pull in the folder with all of its headers and denote these as `PUBLIC` headers. Other options are `INTERNAL` or `PRIVATE` those scopes are irrelevant for now. Some tutorials might use `include_directories` instead of `target_include_directories`. This is an older practice. The more recent `target_include_directories` lets you associate the directories with a target, which helps reduce complexity on larger projects.

Now, I’m going to want to be able to log stuff to Android’s LogCat. Just writing to standard output (ex: `std::cout` or `printf`) doesn’t work as well as it does in normal C and C++ applications. Using `find_library` to locate `log`, we cache Android’s logging library to reference later.

Finally we tell CMake to make `helloworld-c` depend on `native_app_glue`, `android`, and the library we called `log-lib` using `target_link_libraries`. This will let us reference the native app logic in our C++ project. The `set` call before `add_library` also makes sure that helloworld-c doesn’t implement a function called `ANativeActivity_onCreate,` which is provided by `android_native_app_glue`.

### Write a simple native activity

Now we’re ready, let’s build our app!

```
//
// Created by Patrick Martin on 1/30/19.
//

#include <android_native_app_glue.h>
#include <jni.j>

extern "C" {
void handle_cmd(android_app *pApp, int32_t cmd) {
}
    
void android_main(struct android_app *pApp) {
    pApp->onAppCmd = handle_cmd;
    
    int events;
    android_poll_source *pSource;
    do {
        if (ALooper_pollAll(0, nullptr, &events, (void **) &pSource) >= 0) {
            if (pSource) {
                pSource->process(pApp, pSource);
            }
        }
    } while (!pApp->destroyRequested);
}
}
```

What’s happening here?

First, with `extern "C"{}`, we’re just telling the linker that we need to treat everything between those curly braces as C. You can still write C++ code inside of there, but the functions will look like C functions to the rest of our program.

I’m creating a small placeholder function `handle_cmd`. This will serve as our message loop in the future. Any touch events, window events, &c will come through here.

The meat of the program is `android_main`. This is called by `android_native_app_glue` when your application starts up. We start by pointing `pApp->onAppCmd` to our message loop so that system messages have somewhere to go.

Next we use `ALooper_pollAll` to handle all the system events that have queued up, and the first argument is a timeout. If we get a value greater than or equal to 0, we need to help `pSource` process the event. Otherwise we continue until the app closes.

We still can’t run this activity, but feel free to build to make sure everything’s still OK.

### Add the required information to your ApplicationManifest

Now we need to fill out your AndroidManifest.xml to tell your system how to run your app. You can find it under app>manifests>AndroidManfiest.xml:

![](https://cdn-images-1.medium.com/max/800/0*1A_awLp5-K82UG_z)

First we’ll tell Android android about the native activity (called “android.app.NativeActivity”) and tell it not to destroy the activity for orientation changes or keyboard state changes:

```
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.pux0r3.helloworldc">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/AppTheme">
        <activity android:name="android.app.NativeActivity"
            android:configChanges="orientation|keyboardHidden"
            android:label="@string/app_name"></activity>
    </application>
</manifest>
```

Then we tell the native activity where to find the code we want to run. If you’ve forgotten the name, check your CMakeLists.txt!

```
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.pux0r3.helloworldc">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/AppTheme">
        <activity
            android:name="android.app.NativeActivity"
            android:configChanges="orientation|keyboardHidden"
            android:label="@string/app_name">
            <meta-data
                android:name="android.app.lib_name"
                android:value="helloworld-c" />
        </activity>
    </application>
</manifest>
```

And we tell the Android operating system that this is a launcher activity and the main activity:

```
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.pux0r3.helloworldc">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/AppTheme">
        <activity
            android:name="android.app.NativeActivity"
            android:configChanges="orientation|keyboardHidden"
            android:label="@string/app_name">
            <meta-data
                android:name="android.app.lib_name"
                android:value="helloworld-c" />

            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
```

If everything goes well, you can hit debug and see a blank window!

![](https://cdn-images-1.medium.com/max/800/0*uxFZ9rm7AA3nokHt)

### Getting ready for OpenGL

There are already excellent OpenGL samples in the google samples repository:

- [**googlesamples/android-ndk**: Android NDK samples with Android Studio. Contribute to googlesamples/android-ndk development by creating an account on...](https://github.com/googlesamples/android-ndk/tree/master/native-activity "https://github.com/googlesamples/android-ndk/tree/master/native-activity")

I will give you a few helpful hints to get started. First, to use OpenGL, add the following lines to your CMakeLists.txt:

![](https://cdn-images-1.medium.com/max/800/0*3yD719x_3mGZ4qAy)

There’s a lot more intelligence that you can do here for various Android platforms, but adding EGL and GLESv3 to your target will be fine for recent versions of Android.

Next, I like to create a class called `Renderer` for handling my rendering. If you create one with a constructor to initialize your renderer, destructor to destroy it, and a `render()` function to render, I’d suggest making your app look like this:

```
extern "C" {
void handle_cmd(android_app *pApp, int32_t cmd) {
    switch (cmd) {
        case APP_CMD_INIT_WINDOW:
            pApp->userData = new Renderer(pApp);
            break;

        case APP_CMD_TERM_WINDOW:
            if (pApp->userData) {
                auto *pRenderer = reinterpret_cast<Renderer *>(pApp->userData);
                pApp->userData = nullptr;
                delete pRenderer;
            }
    }
}

void android_main(struct android_app *pApp) {
    pApp->onAppCmd = handle_cmd;
    pApp->userData;

    int events;
    android_poll_source *pSource;
    do {
        if (ALooper_pollAll(0, nullptr, &events, (void **) &pSource) >= 0) {
            if (pSource) {
                pSource->process(pApp, pSource);
            }
        }

        if (pApp->userData) {
            auto *pRenderer = reinterpret_cast<Renderer *>(pApp->userData);
            pRenderer->render();
        }
    } while (!pApp->destroyRequested);
}
}
```

So, the first thing I’ve done is start to use this little field in `android_app` called `userData`. You can store any one thing you want here, and every instance of this `android_app` will get it. I chose to add my renderer.

Next, I can only have a renderer after the window is initialized and must get rid of it when it’s destroyed. I use that `handle_cmd` function that I told you about earlier to do this.

Finally, if there is a renderer (ie: the window has been created), I retrieve it from `android_app` and ask it to render. Otherwise I just continue processing this loop.

### Conclusion

At this point, you’re ready to use OpenGL ES 3 as if you were on any other platform! Here are some helpful links if you need more resources or tutorials:

*   Google’s Android NDK samples were invaluable for me to piece together this tutorial: [https://github.com/googlesamples/android-ndk/](https://github.com/googlesamples/android-ndk/)
*   For the native-activity: [https://github.com/googlesamples/android-ndk/tree/master/native-activity](https://github.com/googlesamples/android-ndk/tree/master/native-activity)
*   CMake is my preferred build system on Android for C++, you can find the reference pages here: [https://cmake.org/](https://cmake.org/)
*   If you’re new to CMake, or if `target_include_directories` instead of `include_directories` is new to you, I recommend reading up on “modern” CMake: [https://cliutils.gitlab.io/modern-cmake/](https://cliutils.gitlab.io/modern-cmake/)
*   The OpenGL ES 3 Reference Pages: [https://www.khronos.org/registry/OpenGL-Refpages/es3.0/](https://www.khronos.org/registry/OpenGL-Refpages/es3.0/)
*   Android’s Java OpenGL tutorial. It is Java centric, but discusses many Android-specific concerns: [https://developer.android.com/training/graphics/opengl/](https://developer.android.com/training/graphics/opengl/)
*   NeHe’s OpenGL tutorials are a bit dated and focused on older desktop versions of OpenGL. I still have yet to find a better getting started tutorial on OpenGL: [http://nehe.gamedev.net/](http://nehe.gamedev.net/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
