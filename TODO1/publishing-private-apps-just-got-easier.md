> * 原文地址：[Publishing private apps just got easier](https://medium.com/androiddevelopers/publishing-private-apps-just-got-easier-40399c424b8a)
> * 原文作者：[Jon Markoff](https://medium.com/@jmarkoff)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/publishing-private-apps-just-got-easier.md](https://github.com/xitu/gold-miner/blob/master/TODO1/publishing-private-apps-just-got-easier.md)
> * 译者：[Qiuk17](https://github.com/Qiuk17)
> * 校对者：[PeachChou](https://github.com/PrinceChou), [xiaxiayang](https://github.com/xiaxiayang)

# 轻松发布私有 App

![](https://cdn-images-1.medium.com/max/800/1*pMcEGyuowOHWqtbwVs74-g.png)

来自插图 [Virginia Poltrack](https://twitter.com/VPoltrack)

不论你的团队拥有 5 个还是 100 个 App，你总能找到帮你管理 Play Store 列表的自动化工具。[Google Play](https://developers.google.com/android-publisher/) 允许你通过其开发者 API 来管理你的 Play Store 列表、打包好的 APK 等。2017 年 1 月的时候，Google 从 Twitter 收购了名为 [Fabric](http://fabric.io/blog/fabric-joins-google/) 的开发者套件，其中包含了可以自动化截图、管理测试版部署、签名并将 App 推送到 Play Store 的 [_fastlane_](https://fastlane.tools/)。

除此之外，[私有 App 发布 API](https://developers.google.com/android/work/play/custom-app-api/get-started) 允许拥有管理权限的 Google Play 用户在跳过 [最低版本检查](https://developer.android.com/distribute/best-practices/develop/target-sdk) 的情况下创建并发布私有的 App。[Managed Google Play](https://support.google.com/googleplay/work/answer/6137711?hl=en) 是为企业版 Android 用户提供私有应用程序支持的应用商店。[私有 App](https://support.google.com/a/answer/2494992?hl=en) 只会被分发给内部用户而不会被大众获取。私有 App 的部署可以在被创建后的几分钟内完成。[Jan Piotrowski](https://github.com/janpio) 向 _fastlane_ 提出的这个 [pull request](https://github.com/fastlane/fastlane/pull/13421)，让零代码部署 App 成为可能。对此特性的请求历史可以在 [这里](https://github.com/fastlane/fastlane/issues/13122) 看到。如果想要更多了解 Managed Google Play 和 Google Play 项目，请看看这篇 [博客](https://www.blog.google/products/android-enterprise/safely-and-quickly-distribute-private-enterprise-apps-google-play/)。

**这为什么很重要**：私有 App 发布 API 或者 _fastlane_ 大大简化了迁移到 Managed Google Play 的流程，并且可以方便地被集成到 CI 工具中。

### 配置私有 App 功能

**重要**：在创建用于调试或产品的 keystore 时，请确保使用最佳的 [app 签名方式](https://developer.android.com/studio/publish/app-signing)。千万别丢失您用于生产的 keystore！因为一旦你将它应用于 Google Play 上的某一个 App ID（包括私有 App），你将永远不能在不创建新的应用程序列表及修改其 App ID 的情况下更换 keystore。

**推荐**：利用 [Google Play App Signing](https://developer.android.com/studio/publish/app-signing#google-play-app-signing) 来为你的 APK 文件签名。这是保管的 keystore 的一个好方法。你可以在 [这里](https://support.google.com/googleplay/android-developer/answer/7384423?hl=en) 看到此方法的细节。

**重要**：在 Google Play 上的所有 App（包括私有 App）必须具有一个唯一的且不可重用的 App ID。

在发布你的私有 App 之前，你只需要三步。

跟着这篇 [指导说明](https://developers.google.com/android/work/play/custom-app-api/get-started) 进行如下三步：

1. 在 Cloud API 控制台中启用 Google Play 的 私有 App 发布 API；
2. 创建一个服务账户，并下载其 JSON 格式的私钥；
3. 启用私有 App 功能。

### 配置 fastlane

*   请阅读这篇 [文档](https://docs.fastlane.tools/getting-started/android/setup/) 来安装 _fastlane_ 。其中包含了 Managed Google Play 支持。

### 启用私有 App — 获取你的开发者账户 ID

这篇 [指南](https://developers.google.com/android/work/play/custom-app-api/get-started) 将告诉你如何创建一个需要通过 OAuth 回调来获取开发者账户 ID 的私有 App。有两种方法来启用私有 App 功能：使用 fastlane 或者使用 API。下面将向你展示如何使用这两种方法并比较其复杂程度：

#### 使用 fastlane — 非常简单

```
> fastlane run get_managed_play_store_publishing_rights
```

**样例输出：**

```
[13:20:46]: To obtain publishing rights for custom apps on Managed Play Store, open the following URL and log in:

[13:20:46]: https://play.google.com/apps/publish/delegatePrivateApp?service_account=SERVICE-ACCOUNT-EMAIL.iam.gserviceaccount.com&continueUrl=https://fastlane.github.io/managed_google_play-callback/callback.html

[13:20:46]: ([Cmd/Ctrl] + [Left click] lets you open this URL in many consoles/terminals/shells)

[13:20:46]: After successful login you will be redirected to a page which outputs some information that is required for usage of the `create_app_on_managed_play_store` action.
```

把这个链接粘贴到你的浏览器中你就可以向这个 Managed Google Play 的账户所有者发起授权请求了。

#### 使用 API — 有点复杂

**如果** 你不打算为了管理你的 App 做一个基于 Web 的前端页面，你可以使用下面的 node 脚本以及 Firebase 的功能来快速获取你的开发者账户 ID。如果你不在意跳转的 URL（continueUrl）的话，你可以把它设置成类似于 [https://foo.bar](https://foo.bar) 这样的假 URL。但是出于安全的考虑，这么做是不被推荐的。

**配置 Firebase 的云功能**

这篇 [指南](https://firebase.google.com/docs/functions/get-started) 将告诉你怎样去配置 Firebase 的云功能。下面的代码可被用于你的终端。

```
const functions = require('firebase-functions');

exports.oauthcallback = functions.https.onRequest((request, response) => {
  response.send(request.query.developerAccount);
});
```

functions/index.js

### 创建私有 App 列表

#### 使用 fastlane — 非常简单

```
  ENV['SUPPLY_JSON_KEY'] = 'key.json'
  ENV['SUPPLY_DEVELOPER_ACCOUNT_ID'] = '111111111111000000000'
  ENV['SUPPLY_APP_TITLE'] = 'APP TITLE'
  desc "Create the private app on the Google Play store"
  lane :create_private_app do
      gradle(
        task: 'assemble',
        build_type: 'Release'
      )

      # Finds latest APK
      apk_path = Actions.lane_context[SharedValues::GRADLE_APK_OUTPUT_PATH]

      create_app_on_managed_play_store(
        json_key: ENV['SUPPLY_JSON_KEY'],
        developer_account_id: ENV['SUPPLY_DEVELOPER_ACCOUNT_ID'],
        app_title: ENV['SUPPLY_APP_TITLE'],
        language: "en_US",
        apk: apk_path
      )
    end
```

样例 Fastfile

```
> fastlane create_private_app
```

#### 使用 API — 有点复杂

或许你应当先读读 [API 文档](https://developers.google.com/android/work/play/custom-app-api/publish)。Google 提供了 [Java](https://developers.google.com/api-client-library/java/apis/playcustomapp/v1)、[Python](https://developers.google.com/api-client-library/python/apis/playcustomapp/v1)、[C#](https://developers.google.com/api-client-library/dotnet/apis/playcustomapp/v1) 和 [Ruby](https://developers.google.com/api-client-library/ruby/apis/playcustomapp/v1) 的用户端库文件。

#### API 样例

下面这段 Ruby 代码在使用 [Google 服务账户](https://developers.google.com/android/work/play/custom-app-api/get-started#create_a_service_account) 的 JSON 格式密钥文件认证之后，通过调用 Play Custom App 服务创建了一个私有 App 并上传了其第一版 APK 文件。这段代码只应当在第一次创建 App 时使用，后续更新应使用 Google Play 的发布 API 中的上传 APK 功能。

```
require "google/apis/playcustomapp_v1"

# Auth Info
KEYFILE = "KEYFILE.json" # PATH TO JSON KEYFILE
DEVELOPER_ACCOUNT = "DEVELOPER_ACCOUNT_ID" # DEVELOPER ACCOUNT ID

# App Info
APK_PATH = "FILE_NAME.apk" # PATH TO SIGNED APK WITH V1+V2 SIGNATURES
APP_TITLE = "APP TITLE"
LANGUAGE_CODE = "EN_US"

scope = "https://www.googleapis.com/auth/androidpublisher"
credentials = JSON.parse(File.open(KEYFILE, "rb").read)
authorization = Signet::OAuth2::Client.new(
 :token_credential_uri => "https://oauth2.googleapis.com/token",
 :audience => "https://oauth2.googleapis.com/token",
 :scope => scope,
 :issuer => credentials["client_id"],
 :signing_key => OpenSSL::PKey::RSA.new(credentials["private_key"], nil),
)
authorization.fetch_access_token!

custom_app = Google::Apis::PlaycustomappV1::CustomApp.new title: APP_TITLE, language_code: LANGUAGE_CODE
play_custom_apps = Google::Apis::PlaycustomappV1::PlaycustomappService.new
play_custom_apps.authorization = authorization

play_custom_apps.create_account_custom_app(
 DEVELOPER_ACCOUNT,
 custom_app,
 upload_source: APK_PATH,
) do |created_app, error|
 unless error.nil?
   puts "Error: #{error}"
 else
   puts "Success: #{created_app}."
 end
end
```

### 更新私有 App

创建 Play Store 列表之后，一旦你创建了一个私有 App，你就可以使用 [Google Play 发布 API](https://developers.google.com/android-publisher/) 来推送你的新 APK 文件。_fastlane_ 支持这个功能。你可以在 [这里](https://docs.fastlane.tools/getting-started/android/release-deployment/) 找到更多信息。

### 部署到用户

Managed Google Play 需要 EMM （Enterprise Mobility Management）系统将 App 分发给用户。[了解更多请戳这里](https://support.google.com/googleplay/work/answer/6145139?hl=en)。

部署和管理企业私有 App 从未变得如此容易。这两种使用 Managed Google Play 来部署 App 的方法都是可行的。使用哪一种取决于你的持续集成系统以及你是否想要写代码。试试 [fastlane](https://fastlane.tools) 吧，你会省下很多时间的。

如果你在使用 fastlane 的时候遇到任何问题或者 bug，请在 [github](https://github.com/fastlane/fastlane/issues) 上给我们提 issue。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
