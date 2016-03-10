>* 原文链接 : [Building a Kotlin project 1/2](http://cirorizzo.net/2016/03/04/building-a-kotlin-project/)
* 原文作者 : [CIRO RIZZO](https://github.com/cirorizzo)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态： 认领中


###### _Part 1_

The best way to learn a new language is to use it in a real use case.  
That's way this new series of posts are focused on building a proper Android project using Kotlin.

#### Scenario

To cover as many scenarios as possible the project will require:

*   Accessing to the network
*   Retrieving data through out a REST API call
*   Deserialize data
*   Showing Images in a list

For this purpose why not have an app showing kittens? ;)  
Using the [http://thecatapi.com/](http://thecatapi.com/) API we can retrieve several funny cat images  
![KittenApp](http://cirorizzo.net/content/images/2016/03/xkittenApp.png.pagespeed.ic.ulo4yWl6Cg.png)

#### Dependencies

It looks like a very good chance to try out some very cool libraries like

*   [Retrofit2](http://square.github.io/retrofit/) for the network access, REST API calls and deserializing data
*   [Glide](https://github.com/bumptech/glide) for showing images
*   [RxJava](https://github.com/ReactiveX/RxJava) to bind data
*   [RecyclerView CardView](http://developer.android.com/training/material/lists-cards.html) as UI
*   Everything wrapped in a [MVP](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter) pattern

#### Set Up the Project

Using [Android Studio](http://developer.android.com/sdk/index.html) is extremely simple create a new project from scratch

**_Start a new Android Project_**
![Create New Project](http://cirorizzo.net/content/images/2016/03/xAndroidStudio_NewProject.png.pagespeed.ic.7fDR0qSTJd.png)

**_Create a new project_**

![New Project](http://cirorizzo.net/content/images/2016/03/xAndroidStudio_NewProject_Create_NEW-1.png.pagespeed.ic.rtJ-FIVYiG.png)

**_Select Target Android Device_**
![Target](http://cirorizzo.net/content/images/2016/03/xAndroidStudio_NewProject_Target.png.pagespeed.ic.bXlb6fWH62.png)

**_Add an activity_** ![Empty Activity](http://cirorizzo.net/content/images/2016/03/xAndroidStudio_NewProject_Empty.png.pagespeed.ic.VYxIdhZ3Xk.png)

**_Customize the Activity_** 

![Customize Activity](http://cirorizzo.net/content/images/2016/03/xAndroidStudio_NewProject_Activity.png.pagespeed.ic.3g2X5Gs9Bn.png)

Press on Finish, the new project from the chosen template will be created.

![Basic Template](http://cirorizzo.net/content/images/2016/03/xAndroidStudio_Basic_Template.png.pagespeed.ic.3iX8nv51PP.png)

This is the starting point of our Kitten App!  
However the code is still in Java, later we’re going to see how to convert it.

#### Defining Gradle Build Tool

The next step is to adjust the Build Tool and defining which libraries we're going to use for the project.

> _Before starting with this phase, have a look at what you need for an Android Kotlin project on this [post](http://www.cirorizzo.net/kotlin-code/)_

Open the Module App `build.gradle` (highlighted with a red rectangle in the picture)

![Build.Gradle Customizing](http://cirorizzo.net/content/images/2016/03/xAndroidStudio_Basic_Gradle_High.png.pagespeed.ic.0SHrJn4YZc.png)

It's a very good practice collecting all the libraries' version and Android properties in separate scripts and accessing to them through the `ext` property object provided by Gradle.

The easiest way is to add at the beginning of the `build.gradle` file the following snippet

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

Then adding the Kotlin plugins as shown

    apply plugin: 'com.android.application'
    apply plugin: 'kotlin-android'
    apply plugin: 'kotlin-android-extensions'

Before adding the dependencies for the libraries we're going to use in the project starting to change all the version numbers of the script with the `ext` properties added early at the beginning of the file

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

One more change to the `builTypes` section

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

Next step is to declare the Libraries used in the project

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

Finally the `build.gradle` is ready to work with the project.

Just one more thing is to add the `uses-permission` to access to Internet, so add the following line to the `AndroidManifest.xml`

    <uses-permission android:name="android.permission.INTERNET" />

And now we are ready to go to the next step

#### Designing Project Structure

Another good practice is to structure the project having different packages and folders for different group of Classes composing our project so we can structure our project as shown below.

![Project Structure](http://cirorizzo.net/content/images/2016/03/xProjectStructure.png.pagespeed.ic.pltXQ_UkqX.png)

> _Right Click on the Root Package `com.github.cirorizzo.kshows` and then `New->Package`_

#### Coding

The next [post](http://www.cirorizzo.net/2016/03/04/building-a-kotlin-project-2/) is on how to code the elements of the Kitten app

