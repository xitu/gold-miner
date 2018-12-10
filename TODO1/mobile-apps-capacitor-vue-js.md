> * 原文地址：[Building Mobile Apps With Capacitor And Vue.js](https://www.smashingmagazine.com/2018/07/mobile-apps-capacitor-vue-js/)
> * 原文作者：[Ahmed](https://www.smashingmagazine.com/author/ahmed-bouchefra)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mobile-apps-capacitor-vue-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mobile-apps-capacitor-vue-js.md)
> * 译者：[nanjingboy](https://github.com/nanjingboy)
> * 校对者：[Mcskiller](https://github.com/Mcskiller), [GpingFeng](https://github.com/GpingFeng)

# 使用 Capacitor 和 Vue.js 构建移动应用

> 通过本教程，你将学到如何使用 Capacitor 以及如 Vue.js、Ionic 4 web 组件等前沿 web 技术来为 Android 和 iOS 构建跨平台移动应用。你还可以利用 Capacitor 的优势，用相同的代码来构建其他平台，比如桌面和 web。

最近，Ionic 团队发布了一项名叫 [Capacitor](https://capacitor.ionicframework.com/) 且继承了 Apache Cordova 和 Adobe PhoneGap 核心思想的开源项目。 Capacitor 允许你使用现代 web 技术来构建可在任意平台中运行的应用，从 web 浏览器到移动设备（Android 和 iOS），甚至是通过 Electron（Github 上比较流行的使用 Node.js 和前端 web 技术构建跨平台桌面应用的技术）构建的桌面应用平台。

Ionic - 最流行的混合移动应用开发框架 - 目前运行在 Cordova 之上，但在未来版本中，Capacitor 将成为 Ionic 应用的默认选择。Capacitor 也提供了兼容层从而允许在 Capacitor 项目中使用已有的 Cordova 插件。

除了在 Ionic 应用中使用 Capacitor，你也可以使用任何你喜欢的前端框架或 UI 库，比如 Vue、React、Angular with Material、Bootstrap 等。

在本教程中，我们将看到如何使用 Capacitor 和 Vue 来构建一个简单的 Android 移动应用。实际上，如上所述，你的应用也可以作为渐进式 web 应用（PWA）或作为主要操作系统中的桌面应用来运行，这只需要几个命令。

我们还将使用一些 Ionic 4 UI 组件来设计我们的演示移动应用。

### Capacitor 特性

Capacitor 拥有很多特性，以使其成为 Cordova 等其他解决方案的良好替代品。让我们看看一些 Capacitor 特性：

*   **开源并且免费**: Capacitor 是一个开源项目，根据 MIT 许可证授权，并由 [Ionic](http://ionicframework.com/) 和社区维护。
*   **跨平台**: 你可以使用 Capacitor 通过一份代码来构建多个平台。你可以通过命令行界面（CLI）运行一些命令来支持另外一个平台。
*   **访问平台 SDK**: 当你需要访问原生 SDK 时，Capacitor 不会妨碍你。
*   **标准 web 和浏览器技术**: 通过 Capacitor 构建的应用使用 web 标准 API，因此你的应用也将是跨浏览器，并将在遵循标准的所有现代浏览器中运行良好。
*   **可扩展**: 可以通过添加插件的形式来访问底层平台的原生功能，或者，如果你找不到符合你需求的插件，可以通过简单的 API 来创建一个自定义插件。

### 依赖

为了完成本教程，你的开发机器需要满足以下要求：

*   你需要在你的机器上安装 Node _v8.6+_ 和 npm _v5.6+_ 。只需访问 [官网](http://nodejs.org) 并且下载适用于你的操作系统的版本即可。
*   要构建 iOS 应用，你需要一台安装了 Xcode 的 Mac。
*   要构建 Android 应用，你需要安装 Java 8 JDK 和带有 Android SDK 的 Android Studio。

### 创建一个 Vue 项目

在这一节，我们将安装 Vue CLI 并且生成一个新的 Vue 项目。然后，我们将使用 Vue router 为我们的应用程序添加导航。最后我们将使用 Ionic 4 组件构建一个简单的 UI。

#### 安装 Vue CLI v3

让我们首先通过命令行运行以下命令以便从 npm 安装 Vue CLI v3：

```
$ npm install -g @vue/cli
```

你可能需要添加 `sudo` 来全局安装软件包，具体取决于你的 npm 配置。

#### 生成一个新的 Vue 项目

安装完 Vue CLI，让我们通过命令行运行以下命令用它来生成一下新的 Vue 项目：

```
$ vue create vuecapacitordemo
```

你可以进入项目的根目录并运行以下命令来启动开发服务器：

```
 $ cd vuecapacitordemo
 $ npm run serve
```

你的前端应用将在 `http://localhost:8080/` 下运行。

如果你通过 web 浏览器访问 `http://localhost:8080/`，你应该看到一下页面：

[![一个 Vue 应用](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/57960337-f55a-4b60-818d-a96a9b0b6605/welcome-vue-js-app.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/57960337-f55a-4b60-818d-a96a9b0b6605/welcome-vue-js-app.png)

一个 Vue 应用 ([查看大版本](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/57960337-f55a-4b60-818d-a96a9b0b6605/welcome-vue-js-app.png))

### 添加 Ionic 4

为了在你的应用中使用 Ionic 4 组件，你需要通过 npm 安装 Ionic 4 核心软件包。

所以，继续打开 `index.html` 文件，它位于你的 Vue 项目中的 `public` 目录，然后在文件头部添加以下标签 `<script src='https://unpkg.com/@ionic/core@4.0.0-alpha.7/dist/ionic.js'></script>`。

以下是 `public/index.html` 的内容：

```
<!DOCTYPE html>
<html>
<head>
<meta  charset="utf-8">
<meta  http-equiv="X-UA-Compatible"  content="IE=edge">
<meta  name="viewport"  content="width=device-width,initial-scale=1.0">
<link  rel="icon"  href="<%= BASE_URL %>favicon.ico">
<title>vuecapacitordemo</title>
</head>
<body>
<noscript>
<strong>We’re sorry but vuecapacitordemo doesn’t work properly without JavaScript enabled. Please enable it to continue.</strong>
</noscript>
<div  id="app"></div>
<!-- built files will be auto injected -->
<script  src='https://unpkg.com/@ionic/core@4.0.0-alpha.7/dist/ionic.js'></script>
</body>
</html>
```

你可以通过 [npm](https://www.npmjs.com/package/@ionic/core) 得到 Ionic 核心软件包的当前版本。

现在，打开 `src/App.vue`，删除其中的内容后，在 `template` 标签内添加以下内容：

```
<template>
<ion-app>
   <router-view></router-view>
</ion-app>
</template>
```

`ion-app` 是一个 Ionic 组件。它应该是包装其他组件的顶级组件。

`router-view` 是 Vue 的路由插槽。Vue router 将在此处呈现与路径匹配的组件。

将 Ionic 组件添加到你的 Vue 应用后，你将开始在浏览器控制台中收到类似以下内容的警告：

```
[Vue warn]: Unknown custom element: <ion-content> - did you register the component correctly? For recursive components, make sure to provide the "name" option.

found in

---> <HelloWorld> at src/components/HelloWorld.vue
       <App> at src/App.vue
         <Root>
```

这是因为 Ionic 4 组件实际上是 web 组件，所以你需要告诉 Vue 以 `ion` 前缀开头的组件不是 Vue 组件。你可以在 `src/main.js` 文件中添加以下内容进行设置：

```
Vue.config.ignoredElements = [/^ion-/]
```

现在这些警告应该消失了。

#### 添加 Vue 组件

让我们添加两个组件。首先，删除 `src/components` 目录下的所有文件（并且删除 `App.vue` 中有关 `HelloWorld.vue` 组件的任何导入），然后添加 `Home.vue` 和 `About.vue` 文件。

打开 `src/components/Home.vue` 并添加以下模板：

```
<template>
<ion-app>
<ion-header>
  <ion-toolbar color="primary">
    <ion-title>
      Vue Capacitor
    </ion-title>
  </ion-toolbar>
</ion-header>

<ion-content padding>
  The world is your oyster.
  <p>If you get lost, the <a href="https://ionicframework.com/docs">docs</a> will be your guide.</p>
</ion-content>
</ion-app>
</template>
```

接下来，在同一个文件中，添加以下代码：

```
<script>
export default {
  name: 'Home'
}
</script>
```

现在，打开 `src/components/About.vue` 并添加以下模板：

```
<template>
<ion-app>
<ion-header>
  <ion-toolbar color="primary">
    <ion-title>
      Vue Capacitor | About
    </ion-title>
  </ion-toolbar>
</ion-header>
<ion-content padding>
This is the About page.
</ion-content>
</ion-app>
</template>
```

同样的，在同一个文件中，添加以下代码：

```
<script>
export default {
  name: 'About'
}
</script>
```

#### 使用 Vue Router 添加导航

如果尚未安装 Vue router，需要首先安装，方法是在项目的根目录中执行以下命令：

```
npm install --save vue-router
```

然后，在 `src/main.js` 文件中，导入以下内容：

```
import  Router  from  'vue-router'
import  Home  from  './components/Home.vue'
import  About  from  './components/About.vue'
```

这将导入 Vue router、Home 和 About 组件。

添加以下内容：

```
Vue.use(Router)
```

创建一个包含路由数组的 `Router` 实例：

```
const  router  =  new  Router({
routes: [
{
path:  '/',
name:  'Home',
component:  Home
},
{
path:  '/about',
name:  'About',
component:  About
}
]
})
```

最后，告诉 Vue `Router` 实例：

```
new  Vue({router,
render:  h  =>  h(App)
}).$mount('#app')
```

现在我们已经设置了路由，让我们添加一些按钮和方法以便在 Home 和 About 两个组件之间进行导航。

打开 `src/components/Home.vue` 并添加 `goToAbout()` 方法：

```
...
export default {
  name: 'Home',
  methods: {
    goToAbout () {
      this.$router.push('about')
    },
```

在 `template` 块中，添加一个按钮用来触发 `goToAbout()` 方法：

```
<ion-button @click="goToAbout" full>Go to About</ion-button>
```

现在，当我们进入 About 组件时，我们需要添加一个按钮返回到主页。

打开 `src/components/About.vue` 并添加 `goBackHome()` 方法：

```
<script>
export default {
  name: 'About',
  methods: {
    goBackHome () {
      this.$router.push('/')
    }
  }
}
</script>
```

并且，在 `template` 块中，添加一个按钮用来触发 `goBackHome()` 方法：

```
<ion-button @click="goBackHome()" full>Go Back!</ion-button>
```

在真实的移动设备或模拟器上运行该应用时，你会注意到缩放问题。要解决这个问题，我们需要简单地添加一些正确设置 viewport 的 `meta` 标签。

打开 `public/index.html`，将以下代码添加到页面的 `head` 中：

```
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta name="format-detection" content="telephone=no">
<meta name="msapplication-tap-highlight" content="no">
```

### 添加 Capacitor

你可以通过两种方式使用 Capacitor：

*   从头开始创建一个新的 Capacitor 项目。
*   将 Capacitor 添加到已有的前端项目中。

在这篇教程中，我们将采用第二种方式，因为首先我们已经创建了一个 Vue 项目，现在我们将要把 Capacitor 添加到我们的 Vue 项目中。

#### 集成 Capacitor 与 Vue

Capacitor 旨在融入任何现代 JavaScript 应用。要将 Capacitor 添加到 Vue web 应用中，你需要执行以下几个步骤。

首先，通过 npm 安装 Capacitor CLI 和核心软件包。确保你在你的 Vue 项目中，并执行以下命令：

```
$ cd vuecapacitordemo
$ npm install --save @capacitor/core @capacitor/cli
```

接下来，运行以下命令，使用你的应用信息初始化 Capacitor：

```
$ npx cap init
```

我们使用 `npx` 运行 Capacitor 命令。`npx` 是 [npm v5.2.0](https://github.com/npm/npm/releases/tag/v5.2.0) 附带的实用程序，它用来简化托管在 npm 中的 CLI 程序和可执行文件的运行。比如，它允许开发人员使用本地安装的可执行文件，而无需 npm 运行脚本。

Capacitor CLI 的 `init` 命令还将为 Capacitor 添加默认的本地原生平台，比如 Android 和 iOS。

系统还会提示你输入有关应用的信息，比如名字、应用 ID（将主要用作 Android 应用的包名）和你的应用程序的目录。

输入所需的详细信息后，Capacitor 将被添加到你的 Vue 项目中。

你也可以通过以下命令来提供应用详情：

```
$ npx cap init vuecapacitordemo com.example.vuecapacitordemo
```

应用名为 `vuecapacitordemo`，ID 为 `com.example.vuecapacitordemo`。包名必须是有效的 Java 包名称。

你应该会看到一条消息， “Your Capacitor project is ready to go!”

你可能还注意到一个名为 `capacitor.config.json` 的文件被添加到了你的 Vue 项目的根目录中。

就像 CLI 在我们的 Vue 项目中初始化 Capacitor 时所建议的那样，我们现在可以添加我们想要构建的本地平台。这将把我们的 web 应用转换成我们添加的每个平台的原生应用。

但是在添加平台之前，我们需要告诉 Capacitor 在哪里查找构建文件 — 也就是我们的 Vue 项目的 `dist` 目录。当你第一次运行 Vue 应用的 `build`（`npm run build`） 命令时，将创建此目录，它位于 Vue 应用的根目录。

我们可以通过修改 `capacitor.config.json` 中的 `webDir` 来做到这一点，它是 Capacitor 的配置文件。所以，只需用 `dist` 替换 `www` 即可。以下是 `capacitor.config.json` 的内容：

```
{
  "appId": "com.example.vuecapacitordemo",
  "appName": "vuecapacitordemo",
  "bundledWebRuntime": false,
  "webDir": "dist"
}
```

现在，让我们创建 `dist` 目录并运行以下命令来构建我们的 Vue 项目：

```
$ npm run build
```

之后，我们可以使用以下命令添加 Android 平台：

```
npx cap add android
```

如果你查看你的项目，你会发现已经添加了一个 `android` 原生项目。

这就是整合 Capacitor 和 Android 的全部内容。如果你想要适配 iOS 或 Electron，只需分别运行 `npx cap add ios` 或 `npx cap add electron`。

### 使用 Capacitor 插件

Capacitor 提供了一个运行时以便开发人员能够使用 web 的三大支柱 - HTML、CSS 和 JavaScript - 来构建在 web 上以及主要桌面和移动平台上运行的应用程序。另外它还提供了一组插件用来访问设备的底层功能，例如相机，无需针对每个平台使用特定的低级代码；该插件将为你完成，并为此提供了统一规范的高级 API。

Capacitor 还提供了 API 以便你可以使用该 API 创建 Ionic 团队提供的官方插件未覆盖的自定义插件。你可以在 [如何创建插件](https://capacitor.ionicframework.com/docs/plugins/) 中学习。

你也可以在文档中找到有关 [API 和核心插件](https://capacitor.ionicframework.com/docs/apis/) 的更多详细信息。

#### 例子：添加一个 Capacitor 插件

让我们看一个在我们的应用中使用 Capacitor 插件的例子。

我们将使用 “Modals” 插件，该插件用于显示 alerts、confirmations、input prompts 和 action sheets 的原生模态窗口。

打开 `src/components/Home.vue`，并在 `script` 块的开头添加以下内容：

```
import { Plugins } from '@capacitor/core';
```

此代码从 `@capacitor/core` 中导入 `Plugins` 类。

接下来，添加以下方法来显示对话框：

```
…
  methods: {
    …
    async showDialogAlert(){
      await Plugins.Modals.alert({
          title: 'Alert',
          message: 'This is an example alert box'
      });
    }
```

最后，在 `template` 块里添加一个按钮用来触发这个方法：

```
<ion-button @click="showDialogAlert" full>Show Alert Box</ion-button>
```

以下是该对话框的屏幕截图：

[![Capacitor 原生模态框](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/1c9a76fc-9f6c-405a-b3b5-f39af7c07eda/capacitor-modal-box.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/1c9a76fc-9f6c-405a-b3b5-f39af7c07eda/capacitor-modal-box.png)

原生模态框 ([查看大版本](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/1c9a76fc-9f6c-405a-b3b5-f39af7c07eda/capacitor-modal-box.png))

你可以在 [文档](https://capacitor.ionicframework.com/docs/apis/modals) 找到更多详细信息。

#### 为目标平台构建应用

为了构建项目并为目标平台生成相关二进制文件，你需要执行几个步骤。让我们首先看一下它们：

1.  构建 Vue 应用的生产版本。
2.  将所有 web 资源复制到 Capacitor 生成的原生项目中（在我们的示例中为 Android）。
3.  在 Android Studio （或者 Xcode for iOS）中打开你的 Android 项目，并使用本地集成开发环境（IDE）在真实设备（如果已连接）或模拟器上构建和运行你的应用。

所以，运行以下命令来创建生产版本：

```
$ npm run build
```

接下来，使用 Capacitor CLI 的 `copy` 命令将 web 资源复制到原生项目：

```
$ npx cap copy
```

最后，你可以使用 Capacitor CLI 的 `open` 命令在本地 IDE（在我们的示例中为Android Studio）中打开你的原生项目（在我们的示例中为Android）：

```
$ npx cap open android
```

Android Studio 将与您的项目一起打开，或将打开包含原生项目文件的目录。

[![Android Studio 项目](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/d74af403-7ae3-4c55-a216-10eac8f29ee6/android-studio-project.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/d74af403-7ae3-4c55-a216-10eac8f29ee6/android-studio-project.png)

在 Android Studio 中打开 Capacitor 项目 ([查看大版本](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/d74af403-7ae3-4c55-a216-10eac8f29ee6/android-studio-project.png))

如果不能打开 Android Studio，那么只需手动打开你的 IDE，转到 ”File“ → ”Open…“，然后导航到你的项目并从 IDE 中打开 `android` 目录。

你现在可以使用 Android Studio 通过模拟器或真实设备来启动你的应用。

[![Capacitor demo 项目](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/578d5e2e-a2e2-4b47-a758-a9a9946d489f/capacitor-demo.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/578d5e2e-a2e2-4b47-a758-a9a9946d489f/capacitor-demo.png)

Capacitor demo 项目 ([查看大版本](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/578d5e2e-a2e2-4b47-a758-a9a9946d489f/capacitor-demo.png))

### 结论

在本教程中，我们使用了带有 Vue 和 Ionic 4 web 组件的 Ionic Capacitor 创建了一个使用 web 技术的移动 Android 应用。你可以在 [GitHub repository](https://github.com/techiediaries/vue-capacitor-ionic-app/tree/master) 中找到该演示应用的源代码。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
