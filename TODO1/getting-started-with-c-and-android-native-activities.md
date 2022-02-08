> * 原文地址：[Getting Started with C++ and Android Native Activities](https://medium.com/androiddevelopers/getting-started-with-c-and-android-native-activities-2213b402ffff)
> * 原文作者：[Patrick Martin](https://medium.com/@pux0r3)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/getting-started-with-c-and-android-native-activities.md](https://github.com/xitu/gold-miner/blob/master/TODO1/getting-started-with-c-and-android-native-activities.md)
> * 译者：[Feximin](https://github.com/Feximin)
> * 校对者：[twang1727](https://github.com/twang1727)

# C++ 和 Android 本地 Activity 初探

### 简介

我会带你完成一个简单的 Android 本地 Activity。我将介绍一下基本的设置，并尽力将进一步学习所需的工具提供给你。

虽然我的重点是游戏编程，但我不会告诉你如何写一个 OpenGL 应用或者如何构建一款自己的游戏引擎。这些东西得写整本书来讨论。

### 为什么用 C++

在 Android 上，系统及其所支持的基础设施旨在支持那些用 Java 或 Kotlin 写的程序。用这些语言编写的程序得益于深度嵌入系统底层架构的工具。Android 系统很多核心的特性，比如 UI 界面和 Intent 处理，只通过 Java 接口公开。

使用 C++ 并不会比 Kotlin 或 Java 这类语言对 Android 来说更“本地化”。与直觉相反，你通过某种方式编写了一个只有 Android 部分特性可用的程序。对于大多数程序，Koltin 这类语言会更合适。

然而此规则有一些意外情况。对我来说最接近的就是游戏开发。由于游戏一般会使用自定义的渲染逻辑（通常使用 OpenGL 或 Vulkan 编写），所以预计游戏看起来会与标准的 Android 程序不同。当你还考虑到 C 和 C++ 几乎在所有平台上都通用，以及相关的支持游戏开发的 C 库时，使用本地开发可能更合理。

如果你想从头开始或者在现有游戏的基础上开发一款游戏，Android 本地开发包（NDK）已备好待用。实际上，即将展示给你的本地 activity 提供了一键式操作，你可以在其中设置 OpenGL 画布并开始收集用户的输入。你可能会发现，尽管 C 有学习成本，但使用 C++ 解决一些常见代码难题，比如从游戏数据中构建顶点属性数组，会比用高级语言更容易。

### 我不打算讲的内容

我不会告诉你如何初始化 [Vulkan](https://www.khronos.org/vulkan/) 或 [OpenGL](https://www.khronos.org/opengles/) 的上下文。尽管我会给一些提示让你学习的轻松一点，但还是建议你阅读 Google 提供的[示例](https://github.com/googlesamples/android-ndk/)。你也可以选择使用类似 [SDL](https://www.libsdl.org/) 或者 Google 的 [FPLBase](https://google.github.io/fplbase/) 这样的库。

### 设置你的 IDE

首先需要确保你已经安装了本地开发所需的内容。为此，我们需要用到 Android NDK。启动 Android Studio：

![](https://cdn-images-1.medium.com/max/800/0*PA-Xq6EqB-lE3jrt)

在 “Configure” 下面选择 “SDK Manager”：

![](https://cdn-images-1.medium.com/max/800/0*XkTYhsrl0frw9d1A)

从这里安装 LLDB（本地调试器）、CMake（构建系统）和 NDK 本身：

![](https://cdn-images-1.medium.com/max/800/0*Uy97JiOnnh2aar8b)

### 创建工程

到此你已经设置好了所有内容，我们将建一个工程。我们想创建一个没有 Activity 的空工程：

![](https://cdn-images-1.medium.com/max/800/0*5gtGSseWGEljglcK)

NativeActivity 自 Android Gingerbread 开始就有了，如果你刚开始学习，建议选择当前可用的最高目标版本。

![](https://cdn-images-1.medium.com/max/800/0*EHxm6XZy9PFoX1BJ)

现在我们需要建一个 CmakeLists.txt 文件来告诉 Android 如何构建我们的 C++ 工程。在工程视图下右击 app 创建一个新文件：

![](https://cdn-images-1.medium.com/max/800/0*3174Sy0lsdV_izN8)

命名为 CMakeLists.txt：

![](https://cdn-images-1.medium.com/max/800/0*UjYrafAf-GIjfcp1)

创建一个简单的 CMake 文件：

```cmake
cmake_minimum_required(VERSION 3.6.0)

add_library(helloworld-c
    SHARED
    
    src/main/cpp/helloworld-c.cpp)
```

我们声明了在 Android Studio 中使用最新版本的 CMake（3.6.0），将构建一个名为 hellworld-c 的共享库。我还添加了一个必须要创建的源文件。

为什么是共享库而不是可执行文件呢？Android 使用一个名为 Zygote 的进程来加速在 Android Runtime 内部启动的应用或服务的过程。这对 Android 内所有面向用户的进程都适用，因此你的代码首次运行的地方是在一个虚拟机内。然后代码必须加载一个含有你的逻辑的共享库文件，如果你使用了本地 Activity，该共享库将为你处理。与之相反，当构建一个可执行文件时，我们希望操作系统直接加载你的程序并运行一个名为 “main” 的 C 方法。在 Android 里也有可能，但是我还没找到这方面的任何实践用途。

现在创建 C++ 文件：

![](https://cdn-images-1.medium.com/max/800/0*3bEdMVWFetPHaLh8)

将其放入我们在 make 文件内指定的目录下：

![](https://cdn-images-1.medium.com/max/800/1*0RgvGlIX1A5qXOO-W5K0Zw.png)

再加入少量内容以告诉我们是否构建成功：

```cpp
//
// Created by Patrick Martin on 1/30/19.
//

#include <jni.h>
```

最后让我们把这个 C++ 工程链接到我们的应用上：

![](https://cdn-images-1.medium.com/max/800/0*peP9yeLNekk5o0Yg)

![](https://cdn-images-1.medium.com/max/800/0*Rkx1eC_6gH0nZ1N5)

如果一切顺利，工程会更新成功：

![](https://cdn-images-1.medium.com/max/800/0*gbNXngCYA7e990Vn)

然后你可以不出错地执行一次构建操作：

![](https://cdn-images-1.medium.com/max/800/0*SpKDW8ZXatIV2ioE)

至于在你的构建脚本中发生了什么变化，如果你打开 app 下的 build.gradle 文件，你会看到 `externalNativeBuild`：

```gradle
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

### 创建一个本地 Activity

一个 Activity 是 Android 用来显示你的应用的用户界面的基本窗口。通常你会用 Java 或 Kotlin 编写一个继承自 Activity 的类，但是 Google 创建了一个等价的用 C 写的本地 Activity。

### 设置你的构建文件

创建一个本地 Activity 最好的方式是包含 `native_app_glue`。很多示例程序将其从 SDK 拷贝至他们的工程中。这没什么错，但是我个人更愿意将其做为我的游戏可以依赖的库。我把它做成静态库，所以不需要动态库调用的额外开销：

```cmake
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

这里有不少事情要做，我们继续。首先用 `add_library` 建了一个名为 `native_app_glue` 的库并把它标记为一个 `STATIC` 的库。然后在 NDK 的安装路径下查找自动生成的环境变量 `${ANDROID_NDK}` 从而来寻找一些文件。如此，我找到了 native_app_glue 的实现：`android_native_app_glue.c`。

将代码与目标关联后，我想说一下目标是在哪里找到它的头文件的。我使用 `target_include_directories` 将包含它的所有头文件的文件夹包含进来并将设置为 `PUBLIC`。其他选项还有 `INTERNAL` 或 `PRIVATE` 但目前还用不到。有些教程可能会用 `include_directories` 代替 `target_include_directories`。这是一种较早的做法。最近的 `target_include_directories` 可以让你的目录关联到目标，这有助于降低较大工程的复杂性。

现在，我想在在 Android 的 Logcat 中打印一些内容。只使用与普通 C 或 C++ 应用中那样的标准的输出（如：`std::cout` 或 `printf`）是无效的。使用 `find_library` 去定位 `log`，我们缓存了 Android 的日志库以便稍后使用。

最后我们通过 target_link_libraries 告诉 CMake，helloworld-c 要依赖 native_app_glue、native_app_glue 和被命名为 log-lib 的库。如此可以在我们的 C++ 工程中引用本地应用的逻辑。在 `add_library` 之前的 `set` 也确保 helloworld-c 不会实现名为 `ANativeActivity_onCreate` 的方法，该方法由 `android_native_app_glue` 提供。

### 写一个简单的本地 Activity

现在一切就绪，构建我们的 app 吧！

```cpp
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

这里发生了什么？

首先，通过 `extern "C"{}`，我们告诉链接器把花括号中的内容当成 C 看待。这里你仍然可以写 C++ 代码，但这些方法在我们程序其余部分看起来都像是 C 方法。

我写了一个小的占位方法 `handle_cmd`。将来其可以作为我们的消息循环。任何的触摸事件、窗口事件都会经过这里。

这段代码最主要的是 `android_main`。当你的应用启动的时候这个方法会被 `android_native_app_glue` 调用。我们首先将 `pApp->onAppCmd` 指向我们的消息循环以便让系统消息有一个可去的地方。

接着我们用 `ALooper_pollAll` 处理所有已排队的系统事件，第一个参数是超时参数。如果上述方法返回的值大于或等于 0，我们需要借助 `pSource` 来处理事件，否则，我们将继续直到应用程序关闭。

现在依然不能运行这个 Activity，却可以随意构建以确保一切正常。

### 在 ApplicationManifest 中添加必需的信息

现在我们需要在 AndroidManifest.xml 填入内容来告诉系统如何运行你的应用。该文件位于 app>manifests>AndroidManfiest.xml：

![](https://cdn-images-1.medium.com/max/800/0*1A_awLp5-K82UG_z)

首先我们告诉系统是哪个本地 Activity（名为 “android.app.NativeActivity”) 并在屏幕方向变化或者键盘状态变化的时候不销毁这个 Activity：

```xml
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

然后我们告诉该本地 Activity 去哪里找我们想运行的代码。如果你忘了名字的话，去检查你的 CMakeLists.txt 文件吧！

```xml
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

我们还告诉 Android 操作系统这是启动 Activity 也是主 Activity：

```xml
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

如果一切顺利，你可以点击调试并会看到一个空白窗口！

![](https://cdn-images-1.medium.com/max/800/0*uxFZ9rm7AA3nokHt)

### 准备 OpenGL

在谷歌的示例库中已有优秀的 OpenGL 示例程序了：

- [**googlesamples/android-ndk**: Android Studio 下的 NDK 示例程序。注册账号来为 googlesamples/android-ndk 做出贡献吧]("https://github.com/googlesamples/android-ndk/tree/master/native-activity")

我会给你一些有用的提示。首先，为了使用 OpenGL，在你的 CMakeLists.txt 文件中添加以下内容：

![](https://cdn-images-1.medium.com/max/800/0*3yD719x_3mGZ4qAy)

这里你可以对不同的 Android 架构平台做很多处理，但对最近版本的 Android 来说，添加 EGL 和 GLESv3 到你的目标是一个不错的操作。

接下来，我创建了一个名为 `Renderer` 的类来处理渲染逻辑。如果你建了一个类，它用构造器来初始渲染器、用析构器来销毁它、用 `render()` 方法来渲染，那么我建议你的 app 看起来应该像这样：

```cpp
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

所以，我所做的第一件事就是在 `android_app` 使用名为 `userData` 的字段。你可以在这里存储任何你想存储的东西，每一个 `android_app` 实例都可以获取它。我把它加入到我的渲染器中。

接着，只有在窗口初始化后才能得到一个渲染器并且必须在窗口销毁的时候释放它。我使用前面提到过的 `handle_cmd` 方法来执行此操作。

最后，如果有了一个渲染器（即：窗口已创建），我从 `android_app` 中获取并使其执行渲染操作。否则只是继续处理这个循环。

### 总结

现在你可以像在其他平台一样使用 OpenGL ES 3 了。如果你需要更多资源或教程的话，下面是一些有用的链接：

*   Google 的 Android NDK 示例在本教程的编写上给了我极大的帮助：[https://github.com/googlesamples/android-ndk/](https://github.com/googlesamples/android-ndk/)
*   本地 Activity：[https://github.com/googlesamples/android-ndk/tree/master/native-activity](https://github.com/googlesamples/android-ndk/tree/master/native-activity)
*   CMake 是我在 Android 上使用 C++ 时首选的构建系统，可以在这里找到参考页面：[https://cmake.org/](https://cmake.org/)
*   如果你刚开始学 CMake，或者你对以 target_include_directories 替代 include_directories 的用法不甚了解，建议你看一下 “modern” 版本的 CMake：[https://cliutils.gitlab.io/modern-cmake/](https://cliutils.gitlab.io/modern-cmake/)
*   OpenGL ES 3 参考：[https://www.khronos.org/registry/OpenGL-Refpages/es3.0/](https://www.khronos.org/registry/OpenGL-Refpages/es3.0/)
*   Android 上 OpenGL 的 Java 版本的教程。它以 Java 为中心，但是讨论了很多 Android 特有的问题：[https://developer.android.com/training/graphics/opengl/](https://developer.android.com/training/graphics/opengl/)
*   NeHe 的 OpenGL 教程有点过时且侧重于较旧的 OpenGL 桌面版本。我还没找到一个比这个更好的 OpenGL 入门教程：[http://nehe.gamedev.net/](http://nehe.gamedev.net/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
