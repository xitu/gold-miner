* 原文链接 : [Permissions – Part 1](https://blog.stylingandroid.com/permissions-part-1/)
* 原文作者 : [Styling Android](https://blog.stylingandroid.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者 :
* 状态 : 认领中


With Marshmallow a new permissions model was added to Android which requires developers to take a somewhat different approach to permissions on Android. In this series we’ll take a look at ways to handle requesting permissions both from a technical perspective, and in term of how to provide a smooth user experience.  

[![](http://ww1.sinaimg.cn/large/9b5c8bd8jw1f1ad3bu5htj206o06oq32.jpg)  
](https://blog.stylingandroid.com/?attachment_id=3476)Before we get stuck in it’s worth pointing out that permissions required by an app really fall in to one of two categories: Those that are core to the app’s operation – the app cannot function correctly without those core permissions; and those that are required for more peripheral features. For example, For a Camera app the `CAMERA` permission is part of the core functionality – a Camera app which couldn’t actually take any pictures would be pretty useless. However, there may be additional functionality such as tagging the picture with the location where it was taken (requiring `ACCESS_FINE_LOCATION`) which is a nice feature, but the app can operate without it.

So we’re going to start work on an app for the next series of posts, but it actually requires two permissions for it to be any use whatsoever: `RECORD_AUDIO` and `MODIFY_AUDIO_SETTINGS`. In order to obtain these permissions we need to declare them in the Manifest as we always have:


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

Another thing worth mentioning at this point is that there are a number of libraries designed to simplify the runtime permissions request process. These vary in both quality and usefulness but I feel that it is essential to understand the underlying process before using such a library otherwise you could end up with problems becaue you simply do not understand what your library of choice is actuallydoing. This is the primary motivation for this series of posts.

The two permissions that we require actually fall in to two separate categories of permission: `RECORD_AUDIO` is considered a dangerous permission and `MODIFY_AUDIO_SETTINGS` is considered a normal permission. A dangerous permission is one which may compromise security or privacy; whereas a normal permission is for something which requires access to resources outside the apps’ domain, but has little or no risk to the users’ privacy. Normal permissions will be automatically granted by the system whereas dangerous permissions will require the user to explicitly grant that permission to your app at runtime.

The first thing that we need to do is part of this process is firstly determine whether we have been already granted the permissions we require. In API 23 some new methods were added to _Context_ to check whether specific permissions have already been granted. However, it’s always good to use _ContextCompat_ instead of accessing _Context_ directly and having to include your own API-level checking:


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

It is worth re-iterating what _ContextCompat_ does for us here. The `checkSelfPermission()` method will always return `PackageManger.PERMISSION_GRANTED` when running on pre-Marshmallow devices which do not support the new runtime permissions model – the permissions are implicitly granted on older OS levels, so we simply have one method call which works across all OS levels because of the Manifest declaration, and we don’t need to write any API-level specific checks in to our code.

Just in case you’re wondering why I have created a specific class for this it is because later on we need to make these checks in all of the Activities within the app so having the checking logic separate from our _Activity_ makes for less duplication and improved maintainability of our code.

So to actually use this in our _Activity_ we simply call it with the list of permissions the _Activity_ requires:


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

This will work as-is on pre-Marshamllow devices:

[![](http://ww3.sinaimg.cn/large/9b5c8bd8jw1f1ad406ecij208c069jr8.jpg)](https://blog.stylingandroid.com/?attachment_id=3479)

But we don’t yet have any missing handling for Marshmallow and later – we just display a _Snackbar_:

[![](http://ww1.sinaimg.cn/large/9b5c8bd8jw1f1ad4dgmdhj208c069glh.jpg)>](https://blog.stylingandroid.com/?attachment_id=3480)

Requesting missing permissions is where some complexity begins to creep in. We’ll look at this in the next article.

The source code for this article is available [here](https://github.com/StylingAndroid/Permissions/tree/Part1).
