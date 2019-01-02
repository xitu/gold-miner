> * 原文链接 : [Building a Kotlin project 1/2](http://cirorizzo.net/2016/03/04/building-a-kotlin-project/)
* 原文作者 : [CIRO RIZZO](https://github.com/cirorizzo)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Jing KE](https://github.com/jingkecn)
* 校对者: [lizhuo](https://github.com/huanglizhuo)、[JOJO](https://github.com/Sausure)

# 创建一个基于 Kotlin 的 Android 项目（上集）

###### _第 1 部分_

学习一门新语言的最好途径是在实际情景中使用它。
  
这个新系列的文章正是以此方式来集中使用 Kotlin 建立一个真正的 Android 项目。

#### 情景

为适用尽可能多的场合，该项目将需要：

*   接入网络
*   通过 REST API 访问取得数据
>   【译注】[这里](https://zh.wikipedia.org/wiki/REST)了解 REST API 概念。
*   反序列化数据
>   【译注】[这里](https://zh.wikipedia.org/wiki/%E5%BA%8F%E5%88%97%E5%8C%96)了解**序列化**与**反序列化**概念。
*   在一个列表中展示图片

为此，何不干脆让此应用展示小猫咪呢？;)  

使用 [http://thecatapi.com/](http://thecatapi.com/) API 我们可以获取几张有趣的小猫图片：

![KittenApp](http://cirorizzo.net/content/images/2016/03/xkittenApp.png.pagespeed.ic.ulo4yWl6Cg.png)

#### 依赖

看来这是个很好的机会以尝试一些非常酷的库：

*   [Retrofit2](http://square.github.io/retrofit/) 用于网络接入，访问 REST API 以及反序列化数据
*   [Glide](https://github.com/bumptech/glide) 用于展示图片
*   [RxJava](https://github.com/ReactiveX/RxJava) 用来绑定数据
*   [RecyclerView CardView](http://developer.android.com/training/material/lists-cards.html) 作为用户界面
*   采用 [MVP](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter) 架构

#### 创建项目

使用 [Android Studio](http://developer.android.com/sdk/index.html) 可以非常简单地从头开始新建一个项目。

**_开始一个新的 Android 项目_**

![Create New Project](http://cirorizzo.net/content/images/2016/03/xAndroidStudio_NewProject.png.pagespeed.ic.7fDR0qSTJd.png)

**_创建一个新项目_**

![New Project](http://cirorizzo.net/content/images/2016/03/xAndroidStudio_NewProject_Create_NEW-1.png.pagespeed.ic.rtJ-FIVYiG.png)

**_选择目标 Android 设备_**

![Target](http://cirorizzo.net/content/images/2016/03/xAndroidStudio_NewProject_Target.png.pagespeed.ic.bXlb6fWH62.png)

**_添加一个 `Activity`_**

![Empty Activity](http://cirorizzo.net/content/images/2016/03/xAndroidStudio_NewProject_Empty.png.pagespeed.ic.VYxIdhZ3Xk.png)

**_定制 `Activity`_**

![Customize Activity](http://cirorizzo.net/content/images/2016/03/xAndroidStudio_NewProject_Activity.png.pagespeed.ic.3g2X5Gs9Bn.png)

按下 Finish，新的项目将按选定模板创建：

![Basic Template](http://cirorizzo.net/content/images/2016/03/xAndroidStudio_Basic_Template.png.pagespeed.ic.3iX8nv51PP.png)

这里开始是我们小猫应用的基础部分！

尽管代码仍然是 Java，后文我们将看到如何将其转换。

#### 定义 Gradle Build 工具

下一步是调整 Build 工具以及确定我们会将到哪些库用于项目。

> _此阶段开始之前，请前往这篇[文章](http://www.cirorizzo.net/kotlin-code/)去看看你在一个 Android Kotlin 项目中需要用到什么。_

打开 Module App `build.gradle` (图中用红色矩形框圈出)：

![Build.Gradle Customizing](http://cirorizzo.net/content/images/2016/03/xAndroidStudio_Basic_Gradle_High.png.pagespeed.ic.0SHrJn4YZc.png)

一个非常好的实践是，将所有库的版本号 (version) 和 Android 特性配置 (properties) 集中于一个单独的脚本中，然后通过 Gradle 提供的 `ext` 属性去访问它们。

最简单的方法就是将以下代码片段添加到 `build.gradle` 文件的开头：

    buildscript {
      ext.compileSdkVersion_ver = 23
      ext.buildToolsVersion_ver = '23.0.2'

      ext.minSdkVersion_ver = 21
      ext.targetSdkVersion_ver = 23
      ext.versionCode_ver = 1
      ext.versionName_ver = '1.0'

      ext.support_ver = '23.1.1'

      ext.kotlin_ver = '1.0.0'
      ext.anko_ver = '0.8.2'

      ext.glide_ver = '3.7.0'
      ext.retrofit_ver = '2.0.0-beta4'
      ext.rxjava_ver = '1.1.1'
      ext.rxandroid_ver = '1.1.0'

      ext.junit_ver = '4.12'

      repositories {
          mavenCentral()
      }

      dependencies {
          classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_ver"
      }
    }

然后添加 Kotlin 插件，如下所示：

    apply plugin: 'com.android.application'
    apply plugin: 'kotlin-android'
    apply plugin: 'kotlin-android-extensions'

在为库添加依赖之前，我们将在项目中利用此前在文件开头添加的 `ext` 属性来更改脚本中的所有版本号：

    android {
      compileSdkVersion "$compileSdkVersion_ver".toInteger()
      buildToolsVersion "$buildToolsVersion_ver"

      defaultConfig {
        applicationId "com.github.cirorizzo.kshows"
        minSdkVersion "$minSdkVersion_ver".toInteger()
        targetSdkVersion "$targetSdkVersion_ver".toInteger()
        versionCode "$versionCode_ver".toInteger()
        versionName "$versionName_ver"
    }
    ...

再更改一下 `buildTypes` 部分：

    buildTypes {
        debug {
            buildConfigField("int", "MAX_IMAGES_PER_REQUEST", "10")
            debuggable true
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }

        release {
            buildConfigField("int", "MAX_IMAGES_PER_REQUEST", "500")
            debuggable false
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

下一步是声明项目中用到的库：

    dependencies {
      compile fileTree(dir: 'libs', include: ['*.jar'])
      testCompile "junit:junit:$junit_ver"

      compile "com.android.support:appcompat-v7:$support_ver"
      compile "com.android.support:cardview-v7:$support_ver"
      compile "com.android.support:recyclerview-v7:$support_ver"
      compile "com.github.bumptech.glide:glide:$glide_ver"

      compile "com.squareup.retrofit2:retrofit:$retrofit_ver"
      compile ("com.squareup.retrofit2:converter-simplexml:$retrofit_ver") {
        exclude module: 'xpp3'
        exclude group: 'stax'
    }

      compile "io.reactivex:rxjava:$rxjava_ver"
      compile "io.reactivex:rxandroid:$rxandroid_ver"
      compile "com.squareup.retrofit2:adapter-rxjava:$retrofit_ver"

      compile "org.jetbrains.kotlin:kotlin-stdlib:$kotlin_ver"
      compile "org.jetbrains.anko:anko-common:$anko_ver"
    }

至此项目的 `build.gradle` 已准备就绪。

还有一点就是添加 `uses-permission` 来接入网络，因此将下面这行添加到 `AndroidManifest.xml` 中：

```xml
    <uses-permission android:name="android.permission.INTERNET" />
```

现在我们可以准备进行下一步了。

#### 设计项目结构

另一个较好的实践是，在项目使用不同的包 (packages) 和文件夹 (folders) 来组织构成我们项目的不同类集合，所以我们可以这样组织我们的项目：

![Project Structure](http://cirorizzo.net/content/images/2016/03/xProjectStructure.png.pagespeed.ic.pltXQ_UkqX.png)

> _右击根目录包 `com.github.cirorizzo.kshows` 然后选择 `New->Package`。_

#### 编写代码

下一篇[文章](http://www.cirorizzo.net/2016/03/04/building-a-kotlin-project-2/)将论述如何为小猫应用的各部分编码。

