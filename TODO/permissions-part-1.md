> * 原文链接 : [Permissions – Part 1](https://blog.stylingandroid.com/permissions-part-1/)
* 原文作者 : [Styling Android](https://blog.stylingandroid.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Hugo Xie](https://github.com/xcc3641)
* 校对者 : [BOBO](https://github.com/CoderBOBO)，[markzhai](https://github.com/markzhai)

# 深入浅出 Android 权限（一）

因为 Marshmallow（Android 6.0）一个新的权限模型的引入，Android 开发者需要采取不同于以往的方式来获取 Android的权限。本系列中我们将从技术以及如何提供流畅用户体验的角度，讲解如何处理请求权限。

[![](http://ww1.sinaimg.cn/large/9b5c8bd8jw1f1ad3bu5htj206o06oq32.jpg)](https://blog.stylingandroid.com/?attachment_id=3476)
在我们陷入困境之前，需要明确一个应用必须申请权限的两种情况的其中之一是：那些权限是应用程序的运行的核心——如果没有申请到这些核心权限，该应用程序将不能正常工作。比如，对于一个相机应用来说，`CAMERA`权限是核心功能中的一部分，一个相机应用如果不能照相就毫无用处。然而，可能会有其他功能，比如像给图片标记位置（需要` ACCESS_FINE_LOCATION`权限），这是一个很好的功能，但应用可以不需要位置权限也可以运行。
所以为了接下来的一系列的文章，并且让大家都可以准备开始做app之前，需要申请以下两个权限`RECORD_AUDIO` and `MODIFY_AUDIO_SETTINGS`。为了去获得这些权限，像我们经常做的一样需要在`Manifest`文件里声明他们。

AndroidManifest.xml

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


从API 1开始这已经成为一种标准的方法去请求Android里的权限。不过，从`targetSdkVersion 23`或者已更新的版本，我们也需要在运行中去请求我们需要的权限。这是非常重要的，因为已经有很多开发者在他们的例子中只是简单地把`targetSdkVersion`设置为最新，然后他们发现自己的应用直接崩溃了，因为他们并没有在应用运行中实现必要的代码去请求权限。问题的是，一旦当你发布一个目标API 23的app到Google Play后，接着就没法用一个目标API更早的APK去替换它了。
值得一提的另外一件事情是在这一点上已经有一些旨在简化在运行中请求权限流程的库。这些库在代码质量和有效性上是多样化的，但是我觉得有必要了解底层流程再使用这种类型的库，否则你可能会遇到问题，因为你根本不了解你所使用的库实际上在做什么。这就是这一系列文章的主要动机。
我们需要这两个权限实际上是属于两个不同类别的权限：`RECORD_AUDIO` 是被认为一种高危的权限，`MODIFY_AUDIO_SETTINGS` 被认为是一种正常的权限。高危权限可能会危及到安全或隐私；尽管一个普通的权限是为了访问应用领域之外的资源，但是用户的隐私风险会有很少甚至没有。普通的权限会被系统自动地授予，然而高危的权限在运行过程中需要使用者明确地授予给你的应用。

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

这其实是非常直接的 —— `ContextCompat#checkSelfPermission` 方法是很容易理解的，未被授权将返回`PackageManager.PERMISSION_DENIED`已被授权将返回`PackageManager.PERMISSION_GRANTED`。
我对这个app添加好了一些进一步的逻辑，刚好可以实现它的这个功能：检测出任何没有被授权的但又是必要的权限。

值得重申的是_ContextCompat_能在这里为我们做什么。运行在 Marshmallow（Android6.0）以前的不支持新的运行权限模型的设备上时（旧的系统上是隐式授予权限）`checkSelfPermission()` 方法总会返回`PackageManger.PERMISSION_GRANTED`，因为`Manifest`的申明，只需要调用一个方法让它运行在所有版本系统中，并且我们不需要在自己的代码中写任何API-level 具体的checks。

之所以为此创建了一个具体的类，是因为我们以后需要在app中所有activity里做这些检查，这样把检查逻辑从Activity中分离出来可以减少重复代码，提高可维护性。

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

实际应用上非常简单。

在Marshamllow（Andorid 6.0）以前的设备上运行效果：

[![](http://ww3.sinaimg.cn/large/9b5c8bd8jw1f1ad406ecij208c069jr8.jpg)](https://blog.stylingandroid.com/?attachment_id=3479)

但我们还没有对Marshamllow（Android 6.0）和以后的版本进行缺少的权限的处理——只是展示了一个_Snackbar_：

[![](http://ww1.sinaimg.cn/large/9b5c8bd8jw1f1ad4dgmdhj208c069glh.jpg)>](https://blog.stylingandroid.com/?attachment_id=3480)

请求缺少的权限是一个非常复杂的变化过程，我们将会在下一篇文章进行讲解。

这篇文章的源码可以[在这里获取](https://github.com/StylingAndroid/Permissions/tree/Part1)。
