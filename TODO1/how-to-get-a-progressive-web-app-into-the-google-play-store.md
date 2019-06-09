> * 原文地址：[How to Get a Progressive Web App into the Google Play Store](https://css-tricks.com/how-to-get-a-progressive-web-app-into-the-google-play-store/)
> * 原文作者：[Mateusz Rybczonek](https://css-tricks.com/author/mateuszrybczonek/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-get-a-progressive-web-app-into-the-google-play-store.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-get-a-progressive-web-app-into-the-google-play-store.md)
> * 译者：[Baddyo](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[linxiaowu66](https://github.com/linxiaowu66), [Xuyuey](https://github.com/Xuyuey)

# 如何在 Google Play 应用商店中发布 PWA

[PWA（Progressive Web Apps，渐进式网络应用）](https://developers.google.com/web/progressive-web-apps/)已经面世了有一段时间了。然而，每当我向客户介绍 PWA 时，他们都会问同样的问题：“我的客户能从应用商店下载安装这种 PWA 吗？” 以前的答案是不能，但自从 Chrome 72 发布之后答案就不一样了，因为该版本增加了一种叫做 [TWA（Trusted Web Activities，受信式网络应用）](https://developers.google.com/web/updates/2019/02/using-twa)的新功能。

> **TWA** 使用一种全新的方式来集成你的 Web 应用内容（比如 PWA）到 Android 应用，它使用了一种基于 Custom Tabs 的协议。

在本文中，我会借助 [Netguru](https://www.netguru.com/) 现有的 PWA（[Wordguru](https://wordguru.netguru.com/)）来逐步说明如何使 PWA 支持直接从 Google Play 应用商店安装。

对 Android 开发者来说，某些我们将要提及的内容可能听起来很傻，但本文是从前端开发者的角度来写的，特别是没有用过 Android Studio 或者做过 Android 应用的前端开发者。同时要注意，我们在本文中探讨的很多概念都仅支持 Chrome 72 及以上版本，因此很有实验性、很超前。

### 步骤一：配置一个 TWA 项目

配置 TWA 并不需要写 Java 代码，但你需要安装 [Android Studio](https://developer.android.com/studio/)（译者注：原文给出的 Android Studio 链接打不开，可访问 [https://developer.android.google.cn/studio](https://developer.android.google.cn/studio)）。如果你之前开发过 iOS 或 Mac 软件，那你会感觉到 Android Studio 非常像 Xcode，它提供了良好的开发环境，旨在简化 Android 开发过程。那么，快去安装吧，咱们稍后再见。

#### 在 Android Studio 中新建一个 TWA 项目

把 Android Studio 安装妥当了吗？嗯……我也听不到你的回答，就当你已经装好了吧。打开 Android Studio，点击 “开始一个新的 Android Studio 项目（Start a new Android Studio project）”。在这里，我们选择 “不添加 Activity（Add No Activity）” 选项，以便我们手动配置项目。

尽管配置过程相当直观，但还是要明白下面这些概念：

* **名称（Name）**：应用的名称（我敢打赌你肯定知道这个）。
* **包名称（Package name）**：Android 应用在 [Play 应用商店](https://play.google.com)的[唯一标识](https://developer.android.com/guide/topics/manifest/manifest-element#package)。这个包名称必须是独一无二的，因此我建议你用 PWA 的 URL 的倒序字符串（如 `com.netguru.wordguru`）。
* **保存位置（Save location）**：项目在本地的保存位置。
* **语言（Language）**：允许你选择一门特定的编程语言，但因为我们用到的应用已经是写好的了，所以此项不用设置。保留默认选项 —— Java —— 就好。
* **最低 API 版本（Minimum API level）**：这是我们用到的 Android API 版本，支持库（后面会说到）需要该配置项。我们选择 API 19 版本。

在这些选项下面还有几个复选框。它们与本次实践无关，所以让它们保持未选中状态，然后点击 “完成（Finish）”。

![](https://css-tricks.com/wp-content/uploads/2019/04/s_B0873689EA50413EA11DE0E251C79D95AC091600D224AE9E30EBEB80DF5C9068_1550759941286_Screenshot2019-02-21at15.38.48.png)

#### 添加 TWA 支持库

TWA 不能没有支持库。好在我们仅需修改两个文件就行了，并且这两个文件都在同一个项目文件夹中：`Gradle Scripts`。它们俩的文件名都是 `build.gradle`，但我们可以通过圆括号中的描述文字区分二者。

![](https://css-tricks.com/wp-content/uploads/2019/04/play-02.jpg)

在此我要介绍一款 Android 应用专用的 Git 包管理工具，叫做 [JitPack](https://jitpack.io/)。它功能很强大，而最基本的功能就是可以让应用的发布变得轻而易举。虽然它是付费服务，但如果这是你首次在 Google Play 应用商店发布应用，我得说这笔开销物有所值。

**笔者提示**：这里不是给 JitPack 打广告。之所以值得一提，是因为本文是写给不熟悉 Android 应用开发或者没有在 Google Play 应用商店发布过应用的人看的，本文读者使用它来管理一个与应用商店直连的 Android 应用代码库会很轻松。言外之意，这个工具并非开发必需品。

打开 JitPack 后，就可以把自己的项目接入了。打开刚才看到的 `build.gradle (Project: Wordguru)` 文件，做如下修改以便让 JitPack 管理应用代码库。

```javascript
allprojects {
  repositories {
    ...
    maven { url 'https://jitpack.io' }
    ...
  }
}
```

现在打开另一个 `build.gradle` 文件。我们可在此文件中添加项目所需的依赖包，当然我们确实要添加一个：

```javascript
// build.gradle (模块：app)

dependencies {
  ...
  implementation 'com.github.GoogleChrome:custom-tabs-client:a0f7418972'
  ...
}
```

TWA 使用 Java 8 的功能，因此我们要启用 Java 8。我们要在刚才的文件中添加 `compileOptions` 字段：

```javascript
// build.gradle (模块：app)

android {
  ...
  compileOptions {
    sourceCompatibility JavaVersion.VERSION_1_8
    targetCompatibility JavaVersion.VERSION_1_8
  }
  ...
}
```

还要添加 `manifestPlaceholders` 这一组变量，我们在下一小节再细说它们。就目前而言，权且先把下列代码加上，用来定义应用的托管域名、默认 URL 和应用名称：

```javascript
// build.gradle (模块：app)

android {
  ...
  defaultConfig {
    ...
    manifestPlaceholders = [
      hostName: "wordguru.netguru.com",
      defaultUrl: "https://wordguru.netguru.com",
      launcherName: "Wordguru"
    ]
    ...
  }
  ...
}
```

#### 在 Android 应用配置清单（Manifest）中提供应用细节

每个 Android 应用都有一个 [Android 应用说明（Android App Manifest）](https://developer.android.com/guide/topics/manifest/manifest-intro)，它提供了应用的基本细节，例如操作系统支持、包信息、设备兼容性以及其他诸多信息，这些信息有助于 Google Play 应用商店显示该应用的运行条件。

这里我们真正关心的是 [Activity](https://developer.android.com/guide/topics/manifest/activity-element)（`<activity>`）。Activity 被用于实现用户界面，代表的正是 “TWA” 中的 “A”。

有趣的是，我们在 Android Studio 中配置项目时，却选择了 “不添加 Activity（Add No Activity）” 选项，那是因为我们的应用说明是空的，只包含应用标签。

先打开 manifest 文件。我们要把已有的 `package` 值换成自己的应用 ID，并把 `label` 值换成对应的 `launcherName` 变量 —— 上个小节中我们在 `manifestPlaceholders` 变量组中定义过。

接着，我们要真正给 TWA 添加 Activity 组件了，即在 `<application>` 标签中添加一个 `<activity>` 标签。

```html
<manifest
  xmlns:android="http://schemas.android.com/apk/res/android"
  package="com.netguru.wordguru"> // 重点

  <application
    android:allowBackup="true"
    android:icon="@mipmap/ic_launcher"
    android:label="${launcherName}" // 重点
    android:supportsRtl="true"
    android:theme="@style/AppTheme">

    <activity
      android:name="android.support.customtabs.trusted.LauncherActivity"
      android:label="${launcherName}"> // 重点

      <meta-data
        android:name="android.support.customtabs.trusted.DEFAULT_URL"
        android:value="${defaultUrl}" /> // 重点

      
      <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
      </intent-filter>

      
      <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE"/>
        <data
          android:scheme="https"
          android:host="${hostName}"/> // 重点
      </intent-filter>
    </activity>
  </application>
</manifest>
```

到这里，乡亲们，咱们就完成第一步了。接着走第二步。

### 步骤二：验证网站与应用之间的关系

TWA 需要把 Android 应用和 PWA 联结起来。因此我们要用到[数字资产链接（Digital Asset Links）](https://developers.google.com/digital-asset-links/v1/getting-started)。

该连接的两端都必须设置，TWA 是应用端，而 PWA 是网站端。

我们得再次修改 `manifestPlaceholders`，才能建立连接。这回，我们要添加一个额外的元素，叫做 `assetStatements`，它记录着 PWA 的相关信息。

```javascript
// build.gradle (模块：app)

android {
  ...
  defaultConfig {
    ...
    manifestPlaceholders = [
      ...
      assetStatements: '[{ "relation": ["delegate_permission/common.handle_all_urls"], ' +
        '"target": {"namespace": "web", "site": "https://wordguru.netguru.com"}}]'
      ...
    ]
    ...
  }
  ...
}
```

此时我们要新增一个 `meta-data` 标签到 `application` 中。此标签告知 Android 应用，我们想要与 `manifestPlaceholders` 中指定的应用建立连接。

```javascript
<manifest
  xmlns:android="http://schemas.android.com/apk/res/android"
  package="${packageId}">

  <application>
    ...
      <meta-data
        android:name="asset_statements"
        android:value="${assetStatements}" />
    ...
  </application>
</manifest>
```

这就行了！我们已经建立了应用到网站的连接关系。现在进入从网站到应用的联结过程。

要想建立反方向的连接关系，我们得创建一个 `.json` 文件，该文件的路径为应用的 `/.well-known/assetlinks.json`。该文件可用 Android Studio 内置的生成器生成。你看，我没骗你吧，Android Studio 能简化开发过程！

生成此文件需要设置 3 个值：

* **托管网站域名（Hosting site domain）**：这是 PWA 的 URL（如 `https://wordguru.netguru.com/`）。
* **应用包名称（App package name）**：这是 TWA 的包名称（如 `com.netguru.wordguru`）。
* **应用包密钥（App package fingerprint）（SHA256）**：这是一个唯一的加密哈希值，基于 Google Play 应用商店的密钥库生成。

我们已经有了前两个值。而最后一个值，要借助 Android Studio 生成。

先要生成带签名的 APK。在 Android Studio 中找到：构建（Build） → 生成带签名的包或 APK（Generate Signed Bundle or APK） → APK：

![](https://css-tricks.com/wp-content/uploads/2019/04/s_B0873689EA50413EA11DE0E251C79D95AC091600D224AE9E30EBEB80DF5C9068_1550496798628_Screenshot2019-02-18at14.33.09.png)

接下来，如果你已经有了密钥库，就使用已有的；如果没有，那就点击 “新建（Create new）…” 创建一个。

接着就把表单填完。务必记住这些凭证，它们是你的应用的签名，能够确认你对应用的拥有权。

![](https://css-tricks.com/wp-content/uploads/2019/04/play-03.jpg)

上述操作会创建一个密钥库文件，该文件被用来生成应用包密钥（SHA256）。**此文件及其重要**，因为它能证明你拥有此应用。如果此文件丢失，你将再也无法在应用商店更新对应的应用。

接着我们来选包（bundle）的类型。这里要选 “release”，因为它可以为我们生成一个生产环境的应用。我们还需要检查签名版本。

![](https://css-tricks.com/wp-content/uploads/2019/04/s_B0873689EA50413EA11DE0E251C79D95AC091600D224AE9E30EBEB80DF5C9068_1550496985643_Screenshot2019-02-18at14.36.03.png)

这步操作将生成 APK 文件，稍后会把它发布在 Google Play 应用商店里。创建密钥库后，就要用它生成所需的应用包密钥（SHA256 格式）。

再回到 Android Studio，找到工具（Tools） → 应用链接助手（App Links Assistant）。来到第 3 步，“发起网站连接（Declare Website Association）”，填写所需信息：`Site domain` 和 `Application ID`。之后，选择上一步生成的密钥库文件。

![](https://css-tricks.com/wp-content/uploads/2019/04/s_B0873689EA50413EA11DE0E251C79D95AC091600D224AE9E30EBEB80DF5C9068_1550760222016_Screenshot2019-02-21at15.43.26.png)

表单填写完毕后，点击 “生成数字资产链接文件（Generate Digital Asset Links file）”，就会生成 `assetlinks.json` 文件。如果你打开该文件，你会看到这样的内容：

```javascript
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.netguru.wordguru",
    "sha256_cert_fingerprints": ["8A:F4:....:29:28"]
  }
}]
```

这正是我们需要在应用的 `/.well-known/assetlinks.json` 路径下使用的文件。我就不讲解怎么在该路径下使用该文件了，因为这因项目而异，超出本文讨论范畴。

我们可以点击 “连接并验证（Link and Verify）” 按钮来测试连接关系。如果一切顺利，你就能看到 “成功（Success）！” 这样的确认信息。

![](https://css-tricks.com/wp-content/uploads/2019/04/s_B0873689EA50413EA11DE0E251C79D95AC091600D224AE9E30EBEB80DF5C9068_1550497970710_9.png)

666！我们成功地在 Android 应用和 PWA 之间建立了双向连接关系。完成了这一步，前途就一片光明了。

### 步骤三：上传必需物料（assets）

Google Play 应用商店需要一些物料来确保应用能够详尽展示。具体来说，我们需要：

* **应用图标（App Icons）**：我们需要各种尺寸的图标，包括 48 x 48、72 x 72、96 x 96、144 x 144 和 192 x 192 等等。或者我们可以使用 [适应性 icon](https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive)。
* **高清图标（High-res Icon）**：这是一个尺寸为 512 x 512 的 PNG 图片，在应用商店里到处都会用到它。
* **功能图（Feature Graphic）**：这是一个尺寸为 1024 x 500 的 JPG 图片或者 24 位的 PNG（无 alpha 通道）图片，应用商店用来展示应用的具体功能。
* **截屏（Screenshots）**：Google Play 应用商店会用这些截屏图片来展示应用的不同界面，以便用户在下载前查看。

![](https://css-tricks.com/wp-content/uploads/2019/04/play-05.jpg)

做完这些工作，我们就可以进入 [Google Play 应用商店的开发者控制台](https://play.google.com/apps/publish)发布应用啦！

### 步骤四：光荣发布！

让我们临门一脚，上传应用到应用商店吧。

我们需要在 [Google Play 控制台](https://play.google.com/apps/publish/) 中，把之前生成的 APK 文件（在 `AndroidStudioProjects` 目录下）上传。上传过程恕不赘述，因为引导程序很清晰明了，会一步一步地指导我们完成发布过程。

应用的审查和核准可能需要几个小时，核准后就会陈列在应用商店中了。

如果你找不到 APK 文件了，你可以再新建一个：构建（Build） → 生成带签名的包或 APK（Generate signed bundle / APK） → 构建 APK（Build APK）、传入已经生成的密钥库文件、填写生成密钥库时用的别名和密码即可。生成 APK 文件后，你会看到一个提示窗口，点击其中的 “文件位置（Locate）” 链接，就能直达文件目录。

### 恭喜恭喜，你的应用在 Google Play 应用商店发布啦！

成功！我们成功地把 PWA 发布到 Google Play 应用商店了。这个过程没有我们想得那么难，但还是付出了一些努力的，相信我，当你看见你自己做的应用跻身于大千世界中，你会得到极大的满足感。

有必要指出，这项功能仍是非常超前的，我暂时把它看作是**实验性**功能。我**不推荐**你现在就用这项功能发布产品，因为它仅支持于 Chrome 72 及以上版本 —— 低于 Chrome 72 的版本中，也能安装 TWA，但应用会立即崩溃，这可不是什么最佳用户体验。

而且，官方发布的 `custom-tabs-client` 目前还不支持 TWA。如果你好奇为何我们不用官方库版本，反而用 GitHub 的原生链接，喏，这就是原因。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
