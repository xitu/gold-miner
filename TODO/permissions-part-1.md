* 原文链接 : [Permissions – Part 1](https://blog.stylingandroid.com/permissions-part-1/)
* 原文作者 : [Styling Android](https://blog.stylingandroid.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Hugo Xie](https://github.com/xcc3641)
* 校对者 :
* 状态 : 已翻译


With Marshmallow a new permissions model was added to Android which requires developers to take a somewhat different approach to permissions on Android. In this series we’ll take a look at ways to handle requesting permissions both from a technical perspective, and in term of how to provide a smooth user experience.  

因为 Marshmallow（Android 6.0）一个新的权限模型的引入，Android 开发者需要采取稍微不同的方式去获取 Android的权限。本系列中我们将讲解从技术的角度如何处理请求权限，并且在请求中如何提供流畅的用户体验。

[![](http://ww1.sinaimg.cn/large/9b5c8bd8jw1f1ad3bu5htj206o06oq32.jpg)  
](https://blog.stylingandroid.com/?attachment_id=3476)

Before we get stuck in it’s worth pointing out that permissions required by an app really fall in to one of two categories: Those that are core to the app’s operation – the app cannot function correctly without those core permissions; and those that are required for more peripheral features. For example, For a Camera app the `CAMERA` permission is part of the core functionality – a Camera app which couldn’t actually take any pictures would be pretty useless. However, there may be additional functionality such as tagging the picture with the location where it was taken (requiring `ACCESS_FINE_LOCATION`) which is a nice feature, but the app can operate without it.

在我们陷入困境之前，需要指出一个应用必须申请权限的两种情况的其中之一是：那些权限是应用程序的运行的核心——如果没有申请到这些核心权限，该应用程序将不能正确工作。比如，对于一个相机应用来说，` CAMERA`权限是核心功能的部分—— 一个相机应用不能照相根本毫无用处。然而，可能会有其他功能，比如像给图片标记位置（需要` ACCESS_FINE_LOCATION`权限），这是一个很好的功能，但应用可以不需要位置权限也可以运行。


So we’re going to start work on an app for the next series of posts, but it actually requires two permissions for it to be any use whatsoever: `RECORD_AUDIO` and `MODIFY_AUDIO_SETTINGS`. In order to obtain these permissions we need to declare them in the Manifest as we always have:

所以为了接下来一系列的文章要准备开始做app的工作，为了谁都可以使用，需要申请以下两个权限`RECORD_AUDIO` and `MODIFY_AUDIO_SETTINGS`。为了去获得这些权限，像我们经常做的一样需要在`Manifest`文件里声明他们。

<span>AndroidManifest.xml</span>

    <?xml version="1.0" encoding="utf-8"?>
    <manifest xmlns:android="http://schemas.android.com/apk/res/android" xmlns:tools="http://schemas.android.com/tools" package="com.stylingandroid.permissions">

      <uses-permission android:name="android.permission.RECORD_AUDIO">
      <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS">

      <application android:allowbackup="false" android:fullbackupcontent="false" android:icon="@mipmap/ic_launcher" android:label="@string/app_name" android:supportsrtl="true" android:theme="@style/AppTheme.NoActionBar" tools:ignore="GoogleAppIndexingWarning">

        <activity android:name=".MainActivity">

        <activity android:name=".PermissionsActivity" android:label="@string/title_activity_permissions" android:theme="@style/AppTheme.NoActionBar">
          <intent-filter>
            <action android:name="android.intent.action.MAIN">

            <category android:name="android.intent.category.LAUNCHER">
          </category></action></intent-filter>
        </activity>
      </activity></application>

    </uses-permission></uses-permission></manifest>


This has been the standard way of declaring permissions on Android since API 1\. However, as soon as we specify `targetSdkVersion 23` or later we also need to request the permissions we require at runtime. That is really important because there have already been many examples of developers who have simply bumped their `targetSdkVersion` to the latest, and then found their app crashing in the wild because they haven’t implemented the necessary code to request permissions at runtime. This is even more of an issue when you consider that once you have released an app targeting API 23 or later to Google Play, you cannot subsequently replace that APK with one targeting an earlier version.

从API1\开始这已经是一种标准的方法去请求Android里的权限。不过，从`targetSdkVersion 23`或者更新的版本，我们也需要在运行中去请求我们需要的权限。这是非常重要的，因为已经有很多开发者在他们的例子中只是简单地把`targetSdkVersion`设置为最新，然后他们发现自己的应用直接崩溃了，因为他们并没有在应用运行中实现必要的代码去请求权限。当你考虑到，一旦已经发布一款针对API23或者更新的应用程序到Google Play，你不能接着替换掉那个针对较早版本的APK。

Another thing worth mentioning at this point is that there are a number of libraries designed to simplify the runtime permissions request process. These vary in both quality and usefulness but I feel that it is essential to understand the underlying process before using such a library otherwise you could end up with problems becaue you simply do not understand what your library of choice is actuallydoing. This is the primary motivation for this series of posts.

值得一提的另外一件事情是在这一点上已经有一些旨在简化在运行中请求权限流程的库。这些在代码质量和可用性是多样化的，但是我觉得有必要了解底层流程再使用这种类型的库，否则你可能会遇到问题，因为你根本不了解你所使用的库实际上在做什么。这就是这一系列文章的主要动机。


The two permissions that we require actually fall in to two separate categories of permission: `RECORD_AUDIO` is considered a dangerous permission and `MODIFY_AUDIO_SETTINGS` is considered a normal permission. A dangerous permission is one which may compromise security or privacy; whereas a normal permission is for something which requires access to resources outside the apps’ domain, but has little or no risk to the users’ privacy. Normal permissions will be automatically granted by the system whereas dangerous permissions will require the user to explicitly grant that permission to your app at runtime.

我们需要这两个权限实际上是属于两个不同类别的权限：`RECORD_AUDIO` 是被认为一种高危的权限，`MODIFY_AUDIO_SETTINGS` 被认为是一种正常的权限。高危权限可能会危及到安全或隐私；尽管一个普通的权限是为了访问应用领域之外的资源，但是用户的隐私风险会有很少甚至没有。普通的权限会被系统自动地授予，然而高危的权限在运行过程中需要使用者明确地授予给你的应用。

The first thing that we need to do is part of this process is firstly determine whether we have been already granted the permissions we require. In API 23 some new methods were added to _Context_ to check whether specific permissions have already been granted. However, it’s always good to use _ContextCompat_ instead of accessing _Context_ directly and having to include your own API-level checking:

我们需要做的第一件事是这部分过程首先确定是否我们已经获得了我们所需要的权限。在API 23中， _Context_加入了新的方法去检查是否已被授予了特定的权限。

但是，现在推崇使用_ContextCompat_取代直接访问_Context_，包括您自己的 API-level 检查：


<span>PermissionChecker.java</span>

    class PermissionsChecker {
        private final Context context;

        public PermissionsChecker(Context context) {
            this.context = context;
        }

        public boolean lacksPermissions(String... permissions) {
            for (String permission : permissions) {
                if (lacksPermission(permission)) {
                    return true;
                }
            }
            return false;
        }

        private boolean lacksPermission(String permission) {
            return ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_DENIED;
        }

    }

This is actually really straightforward – The `ContextCompat#checkSelfPermission` method is pretty self-explanatory it either returns `PackageManager.PERMISSION_DENIED` or `PackageManager.PERMISSION_GRANTED`. I have added some further logic which is appropriate to the needs of this app which will check whether any of the required permissions have not been granted.

这其实是非常简单的 —— `ContextCompat#checkSelfPermission` 方法是很容易理解的，未被授权将返回`PackageManager.PERMISSION_DENIED`已被授权将返回`PackageManager.PERMISSION_GRANTED`。
我已经将附加的逻辑代码添加好了，它将适用于这个应用程序检查是否任何被请求的权限未被授予的。(z


It is worth re-iterating what _ContextCompat_ does for us here. The `checkSelfPermission()` method will always return `PackageManger.PERMISSION_GRANTED` when running on pre-Marshmallow devices which do not support the new runtime permissions model – the permissions are implicitly granted on older OS levels, so we simply have one method call which works across all OS levels because of the Manifest declaration, and we don’t need to write any API-level specific checks in to our code.

值得重申的是_ContextCompat_能在这里为我们做什么。运行在 Marshmallow（Android6.0）以前的不支持新的运行权限模型的设备上时（旧的系统上是隐式授予权限）`checkSelfPermission()` 方法总会返回`PackageManger.PERMISSION_GRANTED`，因为`Manifest`的申明，只需要调用一个方法让它运行在所有版本系统中，并且我们不需要在自己的代码中写任何API-level 具体的checks。

Just in case you’re wondering why I have created a specific class for this it is because later on we need to make these checks in all of the Activities within the app so having the checking logic separate from our _Activity_ makes for less duplication and improved maintainability of our code.

我为这个创建了一个具体的类是因为以后我们需要使用这些checks在应用中所有的Activities中，这样就可以将checking逻辑从我们的_Activity_分离出来，使减少重复和增加可维护性的代码。

So to actually use this in our _Activity_ we simply call it with the list of permissions the _Activity_ requires:

所以在实际应用在我们的_Activity_中，我们可以简单地把它称为_Activity_ 请求的权限清单。

<span>MainActivity.java</span>

    public class MainActivity extends AppCompatActivity {
        private static final String[] PERMISSIONS = new String[] {Manifest.permission.RECORD_AUDIO, Manifest.permission.MODIFY_AUDIO_SETTINGS};

        @Override
        protected void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.activity_main);

            PermissionsChecker checker = new PermissionsChecker(this);

            if (checker.lacksPermissions(PERMISSIONS)) {
                Snackbar.make(toolbar, R.string.no_permissions, Snackbar.LENGTH_INDEFINITE).show();
            }
        .
        .
        .
        }
    }

So that is actually fairly straightforward.

实际应用上非常简单。

This will work as-is on pre-Marshamllow devices:

在Marshamllow（Andorid 6.0）以前的设备上运行效果：

[![](http://ww3.sinaimg.cn/large/9b5c8bd8jw1f1ad406ecij208c069jr8.jpg)](https://blog.stylingandroid.com/?attachment_id=3479)

But we don’t yet have any missing handling for Marshmallow and later – we just display a _Snackbar_:

Marshamllow（Android 6.0）运行时，但是我们还没有对缺少的权限进行处理——只是展示了一个_Snackbar_：

[![](http://ww1.sinaimg.cn/large/9b5c8bd8jw1f1ad4dgmdhj208c069glh.jpg)>](https://blog.stylingandroid.com/?attachment_id=3480)

Requesting missing permissions is where some complexity begins to creep in. We’ll look at this in the next article.

请求缺少的权限是一个非常复杂的变化过程，我们将会在下一篇文章进行讲解。

The source code for this article is available [here](https://github.com/StylingAndroid/Permissions/tree/Part1).

这篇文章的资源代码可以[在这里获取](https://github.com/StylingAndroid/Permissions/tree/Part1)。