* 原文链接 : [Permissions – Part 2](https://blog.stylingandroid.com/permissions-part-2/)
* 原文作者 : [Styling Android](https://blog.stylingandroid.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Hugo](https://github.com/xcc3641)
* 校对者 : 
* 状态 : 翻译完成 

# 深入浅出Android权限（二）

因为 Marshmallow（Android 6.0）一个新的权限模型的引入，Android 开发者需要采取不同于以往的方式来获取 Android的权限。本系列中我们将从技术以及如何提供流畅用户体验的角度，讲解如何处理请求权限。  

[![](http://ww3.sinaimg.cn/large/9b5c8bd8jw1f0krztdaoej206o06o0sy.jpg)](https://blog.stylingandroid.com/permissions-part-1/icon_no_permission/)  

以前我们可以检查是否已经被授予了请求的权限，但是没有机制去请求任何缺少的权限。在这篇文章中，我们来看看如何包括检查和请求必要的权限并且在所有Activies中无需大量的重复代码。请牢记随后的一切都是特定于` Marshmallow`或者更高的版本（早期的版本已经从` Manifest`中隐式授予了权限），并且你需要检查是否你已经在你的项目中指定了` targetSdkVersion=23`或者更高的版本。

接下来的第一件事情我们需要去了解权限请求模型是如何实现的。正如我们已经讨论过的，普通的权限可被隐式授予但高危权限需要请求用户明确地授予。用户授予我们请求的权限是很容易的，但艰难的是我们需要防止的是用户拒绝我的权限请求。对于这个我们将要开发的应用，它也许对用户来说为什么会需要` RECORD_AUDIO`权限是不能理解的，所以我们需要做一些准备告知用户为什么会请求这个权限。

从用户的角度来看，在第一次运行程序的时候，用户会被询问是否授予所需权限：

![](http://ww2.sinaimg.cn/large/675f4a91jw1f1dpk1jhhlj21kw16ogof.jpg)

如果用户授予了所需权限，一切都很好，我们可以继续下去。但是，如果他们拒绝授予权限，我们可以反复询问用户所需的权限：

![](http://ww3.sinaimg.cn/large/675f4a91jw1f1dpivkftsj21kw16odiq.jpg)

但是注意，如果用户已经在之前拒绝了这个所需权限，我们应该提供一个“不再询问”的选项给用户。如果用户选择了这个选项，任何附加的功能所需的权限请求，应该通过我们编程自动拒绝而不是提示用户。显然地，这会对我们开发者造成问题，所以我们需要考虑到这一点。

这是可以进一步混合的，因为在任何时候，用户都可以在设置页面对我们的应用任何所需的权限进行授予或者拒绝。因为权限可能随时会改变，这就是为什么不仅仅在应用启动时，也要在每个_Activity_中，去检查所需的权限是否被授予是非常重要的。

所以我们管理这种请求方式需要有单独的_Activity_用来请求权限，然后应用中其他所有的Activities需要检查它们有自身所需的权限，如果它们所需的权限没有被授予，把控制返回给_PermissionsActivity_。

接下来我们稍微改动下_MainActivity_：

<span>MainActivity.java</span>

    public class MainActivity extends AppCompatActivity {

        static final String[] PERMISSIONS = new String[]{Manifest.permission.RECORD_AUDIO, Manifest.permission.MODIFY_AUDIO_SETTINGS};
        private PermissionsChecker checker;

        @Override
        protected void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.activity_main);

            Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
            setSupportActionBar(toolbar);

            checker = new PermissionsChecker(this);
        }

        @Override
        protected void onResume() {
            super.onResume();

            if (checker.lacksPermissions(PERMISSIONS)) {
                startPermissionsActivity();
            }
        }

        private void startPermissionsActivity() {
            PermissionsActivity.startActivity(this, PERMISSIONS);
        }
    }


我们把权限检查移动到了`onResume()`里。这是考虑到用户可能暂停我们的应用，切换到设置页面，拒绝一个权限，然后回到我们的应用的情况。好吧，这是一些极端情况，但是这是非常值得得去防止可能让应用崩溃掉情况。

所以我们需要实现的基本方法是，每当_Activity_恢复的时候，我们需要确认该_Activity_的所需权限再运行。如果不这样做，就需要我们把控制传递给负责获取所需的权限的_PermissionsActivity_。
虽然这感觉确实就像一种抵御方式，但是我认为这真是一种明智的并且实际上不需要大量代码的做法。所有的检查逻辑都封装到_PermissionsChecker_，然后请求逻辑在_PermissionsActivity_进行处理。

拥有权限检查的相对轻量组件是非常重要的，因为我们可以用相对低的成本，检查所需的权限和只有当Activity一定需要所缺少的权限时才进行权限请求。

在下一篇文章中，我们来看看_PermissionsActivity_中实际上是如何处理权限请求和探讨在用户拒绝我们权限请求的时候，如何进一步告知用户为什么这个权限是应用需要的。

这篇文章的源码在这里可以[获取](https://github.com/StylingAndroid/Permissions/tree/Part2). 在_PermissionsActivity_中有一个占位符，我们将在下一篇文章中扩展，所以它并不是完整功能的代码。

