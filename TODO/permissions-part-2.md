> * 原文链接 : [Permissions – Part 2](https://blog.stylingandroid.com/permissions-part-2/)
* 原文作者 : [Styling Android](https://blog.stylingandroid.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Hugo](https://github.com/xcc3641)
* 校对者 : [Adam Shen](https://github.com/shenxn), [JOJO](https://github.com/Sausure)

# 深入浅出 Android 权限（二）

因为 Marshmallow（Android 6.0）一个新的权限模型的引入，Android 开发者需要采取不同于以往的方式来获取 Android 的权限。本系列中我们将从技术以及如何提供流畅用户体验的角度，讲解处理权限请求的方法。  

[![](http://ww3.sinaimg.cn/large/9b5c8bd8jw1f0krztdaoej206o06o0sy.jpg)](https://blog.stylingandroid.com/permissions-part-1/icon_no_permission/)  

以前我们可以检查是否已经被授予了请求的权限，但是没有机制去请求任何缺少的权限。在这篇文章中，我们来看看如何在不往 Activities 中加入大量重复代码的情况下，引入必要的权限检查和请求。请牢记下文的一切都是特定于` Marshmallow`或者更高的版本（早期的版本已经从` Manifest`中隐式授予了权限），并且你需要检查是否你已经在你的项目中指定了` targetSdkVersion=23`或者更高的版本。

接下来的第一件事情我们需要去了解权限请求模型是如何实现的。正如我们已经讨论过的，普通的权限可被隐式授予但高危权限需要明确地请求用户授予。如果用户给了我们需要的权限，事情就非常简单了，但是我们需要尽量避免被用户拒绝权限请求。对于我们将要开发的这个程序来说，用户可能并不明白我们为什么要请求 RECORD_AUDIO 权限，所以我们需要通过一些条款来告知用户我们为什么需要这个权限。

从用户的角度来看，在第一次运行程序的时候，用户会被询问是否授予所需权限：

![](http://ww2.sinaimg.cn/large/675f4a91jw1f1dpk1jhhlj21kw16ogof.jpg)

如果用户授予了所需权限，我们就可以继续我们要做的操作了。但是，如果他们拒绝授予权限，我们可以反复询问用户所需的权限：

![](http://ww3.sinaimg.cn/large/675f4a91jw1f1dpivkftsj21kw16odiq.jpg)

但是注意，如果用户已经在之前拒绝了这个所需权限，系统会给用户提供一个“不再询问”的选项。如果用户选择了这个选项，那我们代码随后发出的任何该权限请求都会被系统自动拒绝，而不会再次询问用户。显然地，这会对我们开发者造成问题，所以我们需要考虑到这一点。

这个问题可以变得更复杂，因为在任何时候，用户都可以在设置页面对我们应用所需的任何权限进行授予或者拒绝。因为权限可能随时会改变，所以我们不仅仅应该在应用启动时，也要在每个 Activity 中，去检查所需的权限是否被授予。

所以我们处理这个问题的方式是使用一个单独的 Activity 专门用来请求权限，并且所有应用中的其他 Activity 都需要检查它们是否拥有需要的权限，如果它们所需的权限被拒绝，就交由 PermissionsActivity 处理。

接下来我们稍微改动下_MainActivity_：

MainActivity.java

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


我们把权限检查移动到了`onResume()`里。这是考虑到用户可能先暂停我们的应用，切换到设置页面，拒绝了一个权限后再回到我们的应用的情况。好吧，这是一些极端情况，但是为了防止这种情况导致的程序崩溃，这样做是值得的。

所以我们实现的基本方法是，每当Activity恢复的时候，我们需要先确认该 Activity 拥有所需的权限再运行。如果所需权限被拒绝，就需要我们把控制传递给负责获取所需的权限的_PermissionsActivity_。虽然这感觉确实就像一种抵御方式，但是我认为这真是一种明智的并且实际上不需要大量代码的做法。所有的检查逻辑都封装到_PermissionsChecker_，然后请求逻辑在_PermissionsActivity_进行处理。

使得权限检查组件相对轻量是非常重要的，因为这样我们就可以用相对低的成本来检查组件，并且只在完全必要的情况下，才使用切换 Activity 这种成本高得多的途径来请求缺失的权限。

在下一篇文章中，我们来看看_PermissionsActivity_中实际上是如何处理权限请求和探讨在用户拒绝我们权限请求的时候，如何进一步告知用户为什么这个权限是应用需要的。

这篇文章的源码在这里可以[获取](https://github.com/StylingAndroid/Permissions/tree/Part2). 在_PermissionsActivity_中有一个占位符，我们将在下一篇文章中扩展，所以它并不是完整功能的代码。

