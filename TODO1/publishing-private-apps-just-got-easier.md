> * 原文地址：[Publishing private apps just got easier](https://medium.com/androiddevelopers/publishing-private-apps-just-got-easier-40399c424b8a)
> * 原文作者：[Jon Markoff](https://medium.com/@jmarkoff)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/publishing-private-apps-just-got-easier.md](https://github.com/xitu/gold-miner/blob/master/TODO1/publishing-private-apps-just-got-easier.md)
> * 译者：[Qiuk17](https://github.com/Qiuk17)
> * 校对者：

# 轻松发布私有 App

![](https://cdn-images-1.medium.com/max/800/1*pMcEGyuowOHWqtbwVs74-g.png)

来自 [Virginia Poltrack](https://twitter.com/VPoltrack) 的插图

不论你的公司拥有 5 个还是 100 个 App，你总能找到帮你管理 Play Store 列表的自动化工具。[Google Play](https://developers.google.com/android-publisher/) 允许你通过其开发者 API 来管理你的 Play Store 列表、打包好的 APK 等。2017 年 1 月的时候，Google 从 Twitter 收购了名为 [Fabric](http://fabric.io/blog/fabric-joins-google/) 的开发者套件，其中包含了可以自动化截图、管理测试版部署、签名并将 App 推送到 Play Store 的  [_fastlane_](https://fastlane.tools/)。

除此之外，[自定义的发布 API](https://developers.google.com/android/work/play/custom-app-api/get-started) 允许拥有管理权限的 Google Play 用户在跳过[最低版本检查](https://developer.android.com/distribute/best-practices/develop/target-sdk)的情况下创建并发布私有的 App。[Managed Google Play](https://support.google.com/googleplay/work/answer/6137711?hl=en) 是为企业版 Android 用户提供私有应用程序支持的应用商店。[私有 App](https://support.google.com/a/answer/2494992?hl=en) 只会被分发给内部用户而不会被大众获取。私有 App 的部署可以在被创建后的几分钟内完成。[Jan Piotrowski](https://github.com/janpio) 向 _fastlane_ 提出的这个 [pull request](https://github.com/fastlane/fastlane/pull/13421), 让无代码部署 App 成为可能。对此特性的请求历史可以在[这里](https://github.com/fastlane/fastlane/issues/13122)看到。如果想要更多了解 Managed Google Play 和 Google Play 项目，请看看这篇[博客](https://www.blog.google/products/android-enterprise/safely-and-quickly-distribute-private-enterprise-apps-google-play/)。

**Why this is important:** The Custom App Publishing API or _fastlane_ greatly simplifies and reduces the friction of migrating to Managed Google Play and integrates into continuous integration tools and processes.

### Setup

**Important:** Make sure to use the following best practices for [app signing](https://developer.android.com/studio/publish/app-signing) when creating debug and production keystores. Do not lose your production keystore! Once it has been used with an application id on Google Play (including private apps), you cannot change the keystore without creating a new application listing and modifying the application id.

**Recommended:** Utilize [Google Play App Signing](https://developer.android.com/studio/publish/app-signing#google-play-app-signing) to sign your APKs. This is a safe option to make sure that your keystore will not be lost. Please see the implementation details [here](https://support.google.com/googleplay/android-developer/answer/7384423?hl=en).

**Important:** All apps (including private apps) on Google Play must have a unique application id and cannot be reused.

When publishing private apps, there are 3 steps you need to take before this is available.

Please follow the [Setup Instructions](https://developers.google.com/android/work/play/custom-app-api/get-started) which will guide you through the following steps:

1.  Enable the Google Play Custom App Publishing API in the Cloud API Console
2.  Create a service account, download a new private key in JSON format.
3.  Enable Private Apps, instructions to follow.

### fastlane setup

*   Please see this [doc](https://docs.fastlane.tools/getting-started/android/setup/) to install _fastlane._ Managed google play support is included with fastlane.

### Enable Private Apps — Get the Developer Account Id

This [guide](https://developers.google.com/android/work/play/custom-app-api/get-started) shows the steps to create private apps which requires creating an OAuth callback to receive the developerAccount id. There are two methods for enabling private apps: using fastlane or using the API. Here’s how to use each and their level of difficulty:

#### Use fastlane — Easy

```
> fastlane run get_managed_play_store_publishing_rights
```

**Example Output:**

```
[13:20:46]: To obtain publishing rights for custom apps on Managed Play Store, open the following URL and log in:

[13:20:46]: https://play.google.com/apps/publish/delegatePrivateApp?service_account=SERVICE-ACCOUNT-EMAIL.iam.gserviceaccount.com&continueUrl=https://fastlane.github.io/managed_google_play-callback/callback.html

[13:20:46]: ([Cmd/Ctrl] + [Left click] lets you open this URL in many consoles/terminals/shells)

[13:20:46]: After successful login you will be redirected to a page which outputs some information that is required for usage of the `create_app_on_managed_play_store` action.
```

Pasting the link into a web browser and authenticating with your account owner of the managed play account will send forward

#### Use the API — Moderate

**If** you don’t plan to build a web user interface for managing your apps, you can use this basic node script below and launch with Firebase functions to quickly and easily get the developerAccountId. If you don’t care, you can set the continueUrl to [https://foo.bar](https://foo.bar) (or another fake url) to get the developerAccountId although this is not recommended for security purposes.

**Cloud Functions for Firebase setup**

This [guide](https://firebase.google.com/docs/functions/get-started) shows how to set up cloud functions. The following code can be used for the endpoint.

```
const functions = require('firebase-functions');

exports.oauthcallback = functions.https.onRequest((request, response) => {
  response.send(request.query.developerAccount);
});
```

functions/index.js

### Create Private App Listing

#### Use fastlane — Easy

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

Example Fastfile

```
> fastlane create_private_app
```

#### Use the API — Moderate

API [documentation](https://developers.google.com/android/work/play/custom-app-api/publish). Client libraries are available in [Java](https://developers.google.com/api-client-library/java/apis/playcustomapp/v1), [Python](https://developers.google.com/api-client-library/python/apis/playcustomapp/v1), [C#](https://developers.google.com/api-client-library/dotnet/apis/playcustomapp/v1), and [Ruby](https://developers.google.com/api-client-library/ruby/apis/playcustomapp/v1).

#### API Example

Written in Ruby, this sample code authenticates with a [Google service account](https://developers.google.com/android/work/play/custom-app-api/get-started#create_a_service_account) json keyfile and then calls the Play Custom App Service to create and upload the first version of a private APK. This code is only used for the first time an app is created, and subsequent updates should use the upload apk functionality in the Play Publishing API.

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

### Updating Private Apps

Once a private app has been created, the [Google Play Publishing API](https://developers.google.com/android-publisher/) can push new APKs after the initial creation of the Play store listing. _fastlane_ supports this feature to upload new APKs to Play, and more info can be found [here](https://docs.fastlane.tools/getting-started/android/release-deployment/).

### Deployment to users

Managed Google Play requires an EMM (Enterprise Mobility Management) system to distribute apps to users. More information [here](https://support.google.com/googleplay/work/answer/6145139?hl=en).

It has never been easier to deploy and manage your private enterprise apps. Both methods of deploying apps through Managed Google Play are viable, it all comes down to you your CI system and if you want to write any code. Give [fastlane](https://fastlane.tools) a shot, and it should save you tons of time.

If you run into any issues, bugs can be filed against fastlane on [github](https://github.com/fastlane/fastlane/issues).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
