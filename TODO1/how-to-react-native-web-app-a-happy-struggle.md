> * 原文地址：[How to: React Native Web app. A Happy Struggle.](https://blog.bitsrc.io/how-to-react-native-web-app-a-happy-struggle-aea7906f4903)
> * 原文作者：[Lucas Mórawski](https://blog.bitsrc.io/@lucasmorawski?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-react-native-web-app-a-happy-struggle.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-react-native-web-app-a-happy-struggle.md)
> * 译者：[weibinzhu](https://github.com/weibinzhu)
> * 校对者：

# 怎么做：React Native 网页应用。 一场开心的挣扎

## 一个关于制作通用应用的简短而详细的教程

![](https://cdn-images-1.medium.com/max/2000/1*RiQRKKQ2ndxD6ddo8hXNLg.png)
你醒来。阳光灿烂，鸟儿在歌唱。没有战争，没有饥饿，代码可以轻易地被原生和 web 环境共享。是不是很赞？但很不幸，仅仅是后者，希望虽已经在地平线上，但仍然有一些事情需要我们去完成。

### 为什么你需要关心？

如今在技术缩写的海洋里面，PWA ([渐进式 Web 应用程序](https://en.wikipedia.org/wiki/Progressive_Web_Apps))是一个重要的三字词语,但是它仍然有[缺点](https://clutch.co/app-developers/resources/pros-cons-progressive-web-apps)。有很多被迫在开发原生应用以外还要开发 web 版的案例，其中也有很多技术难题。[Ian Naylor 写了一篇很棒的关于这个的文章](https://appinstitute.com/pwa-vs-native-apps/)。

但是，对于你的电子商务生意，仅仅开发一个原生应用也是一个大错误。因此制作一个能够在所有地方工作的软件似乎是一个合乎逻辑的操作。你可以减少工作时间，以及生产、维护的费用。这就是为什么我开始了这个小小的实验。

这是一个简单的用于在线订餐的电子商务通用应用例子。在此之上，我创建了一个样板，用于将来的项目以及更深入的实验。

![](https://cdn-images-1.medium.com/max/1000/1*hSTFw1TNjeqLZHq_DTBVRg.png)

Papu — 一个可用于安卓、iOS、web 的食物 APP

### 检查一下你的基元

我们使用 React 来开展我们的工作，因此我们应该将应用逻辑与 UI 分离。使用类似 Redux/MobX/other 这样的状态管理系统是最好的选择。这将使得我们的业务逻辑能在多个平台之间复用。

视图部分则是另外一个难题。为了构建你的应用的界面，你需要有一套通用的基本模块。他们需要能同时在 web 与原生环境下使用。不幸的是，web 上有着一套不一样的东西。

```
<div>这是一个标准的 web 上的容器</div>
```

而在原生上

```
<View>你好！我是 React Native 里面的一个基础容器</View>
```

有些聪明的人想到了如何解决这个问题。我最喜欢的解决方案之一就是由[Nicolas Gallagher](http://nicolasgallagher.com/)制作的伟大的[React Native Web](https://github.com/necolas/react-native-web)库。不仅仅是因为通过它能够让你在 web 上使用 React Native 组件（不是全部组件！）来解决基本模块的问题。它还暴露了一些 React Native 的 API，比如 Geolocation，Platform，Animated，AsyncStorage 等。 快来[RNW guides](https://github.com/necolas/react-native-web/tree/master/docs/guides)这里看一些很棒的示例。

### 首先是一个样板

我们已经知道如何解决基本模块的问题了。但是我们仍然要试着将 web 页与原生的生产环境『粘』在一起，让『奇迹』发生。在我的项目中，我使用了[RN](https://facebook.github.io/react-native/docs/getting-started)的初始化脚本（没有展示在这里），并且对于 web 部分我使用了[create-react-app](https://github.com/facebook/create-react-app)。首先我创建了一个叫`create-react-app rnw_web`的项目以及一个叫`react-native init raw_native`的项目。然后我在一个新的项目文件夹里面，『科学怪人式』地将他们的`package.json`合并成一个，并在上面应用 yarn. 最终的 package 文件长这样：

```
{
  "name": "rnw_boilerplate",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "react": "^16.5.1",
    "react-art": "^16.5.1",
    "react-dom": "^16.5.1",
    "react-native": "0.56.0",
    "react-native-web": "^0.9.0",
    "react-navigation": "^2.17.0",
    "react-router-dom": "^4.3.1",
    "react-router-modal": "^1.4.2"
  },
  "devDependencies": {
    "babel-jest": "^23.4.0",
    "babel-preset-react-native": "^5",
    "jest": "^23.4.1",
    "react-scripts": "1.1.5",
    "react-test-renderer": "^16.3.1"
  },
  "scripts": {
    "start": "node node_modules/react-native/local-cli/cli.js start",
    "test": "jest",
    "start-ios": "react-native run-ios",
    "start-web": "react-scripts start",
    "build": "react-scripts build",
    "test-web": "react-scripts test --env=jsdom",
    "eject-web": "react-scripts eject"
  }
}
```

React Native Web 样板的 package.json 文件（在这个版本里面没有导航）

 你需要将所有在 web 和 native 目录里的源代码文件复制到新的统一项目目录中。
 
![](https://cdn-images-1.medium.com/max/800/1*jBJPol8evebkL96FXEAFew.png)

需要复制到新项目的文件夹

下一步，我们将 App.js 与 App.native.js 放到我们新创建的 src 文件夹中。感谢 [webpack](https://webpack.js.org/) 我们可以通过文件拓展名来告诉打包器哪些文件用在哪些地方。这对于使用分离的 App 文件至关重要，因为我们准备使用不同的方式进行应用导航。

```
// App.js - WEB
import React, { Component } from "react";
import { View } from "react-native";
import WebRoutesGenerator from "./NativeWebRouteWrapper/index";
import { ModalContainer } from "react-router-modal";
import HomeScreen from "./HomeScreen";
import TopNav from "./TopNav";
import SecondScreen from "./SecondScreen";
import UserScreen from "./UserScreen";
import DasModalScreen from "./DasModalScreen";

const routeMap = {
  Home: {
    component: HomeScreen,
    path: "/",
    exact: true
  },
  Second: {
    component: SecondScreen,
    path: "/second"
  },
  User: {
    component: UserScreen,
    path: "/user/:name?",
    exact: true
  },
  DasModal: {
    component: DasModalScreen,
    path: "*/dasmodal",
    modal: true
  }
};

class App extends Component {
  render() {
    return (
      <View>
        <TopNav />
        {WebRoutesGenerator({ routeMap })}
        <ModalContainer />
      </View>
    );
  }
}

export default App;
```

给 web 的 App.js. 这里使用 react-router 进行导航。

```
// App.js - React Native

import React, { Component } from "react";
import {
  createStackNavigator,
  createBottomTabNavigator
} from "react-navigation";
import HomeScreen from "./HomeScreen";
import DasModalScreen from "./DasModalScreen";
import SecondScreen from "./SecondScreen";
import UserScreen from "./UserScreen";

const HomeStack = createStackNavigator({
  Home: { screen: HomeScreen, navigationOptions: { title: "Home" } }
});

const SecondStack = createStackNavigator({
  Second: { screen: SecondScreen, navigationOptions: { title: "Second" } },
  User: { screen: UserScreen, navigationOptions: { title: "User" } }
});

const TabNav = createBottomTabNavigator({
  Home: HomeStack,
  SecondStack: SecondStack
});

const RootStack = createStackNavigator(
  {
    Main: TabNav,
    DasModal: DasModalScreen
  },
  {
    mode: "modal",
    headerMode: "none"
  }
);

class App extends Component {
  render() {
    return <RootStack />;
  }
}

export default App;
```

给 React Native 的 App.js. 这里使用了 react-navigation.

我就是这样制作了一个简单的样板以及给应用构造了一个框架。你可以通过克隆我的 github 仓库来试一下我那个干净的样板。

* [**inspmoore/rnw_boilerplate**: 一个基于 React Native Web 库的，用于实现 React Native 与 ReactDOM 之间代码共享的样板](https://github.com/inspmoore/rnw_boilerplate "https://github.com/inspmoore/rnw_boilerplate")

下一步我们将通过加入路由/导航系统来让它弄复杂一些。

### 导航的问题与解决方案

除非你的应用只有一个页面，否则你需要一些导航。现在（2018 年 9 月）只有一种能够在 web 与原生中都能用的方法：[React Router](https://reacttraining.com/react-router/)。在 web 中这是一个导航方法，但对于 React Native 来说不完全是。

React Router Native 缺少页面过渡动画，对后退按钮的支持（安卓），模态框，导航条等等。而其他的库则提供这些功能，例如 [React Navigation](https://reactnavigation.org/).

我把它用在了我的项目中，但是你可以用其他的。于是我把 React Router 用在 web 端，把 React Navigation 用在原生。但这又导致了一个新问题。导航，以及传参，在这两个导航库中有着很大不同。

为了保持在所有地方都有着更多的原生体验这个 React Native Web 的精神，我通过制作网页路由并将它们包裹在一个 HOC 里面来解决这个问题。这样能暴露出类似 React Navigation 的 API.

这使得我们无需给两个『世界』分别制作组件即可实现在页面之间导航。
第一步是创建一个用于 web 路由的路径 map 对象：

import WebRoutesGenerator from "./NativeWebRouteWrapper"; //用于生成 React Router 路径并将其包裹在一个 HOC 中的自定义函数

```
import WebRoutesGenerator from "./NativeWebRouteWrapper"; //用于生成 React Router 路径并将其包裹在一个 HOC 中的自定义函数

const routeMap = {
  Home: {
    screen: HomeScreen,
    path: '/',
    exact: true
  },
  Menu: {
    screen: MenuScreen,
    path: '/menu/sectionIndex?'
  }
}

//在 render 方法中
<View>
  {WebRoutesGenerator({ routeMap })}
</View>
```

这个语法与 React Navigation 的 navigator 构造函数的一样，除了多了一个 React Router 特定的选项。然后，通过我的辅助函数，我创建了一个 `react-router` 路径。并将其包裹在一个 HOC 中。这回将页面组件拷贝一份，并在其 props 中添加一个 `navigation` 属性。这模拟了 React Navigation 并暴露出一些方法，像是 `navigate()`, `goBack()`, `getParam()`.

#### 模态框

通过它的 `createStackNavigator` React Navigation 提供了一个选项，让页面像一个模态框一样从底部滑出。为了在 web 端实现这个，我使用了由 [Dave Foley](https://github.com/davidmfoley) 写的 [React Router Modal](https://github.com/davidmfoley/react-router-modal) 库。为了将某个页面用作模态框，首先你需啊哟在路径 map 中添加一个模态框选项：

```
const routeMap = {
  Modal: {
    screen: ModalScreen,
    path: '*/modal',
    modal: true //路由会用 ModalRoute 组件来渲染这个路径
  }
}
```

此外你还需要添加一个 `react-router-modal` 库中的 `<ModalContainer />` 组件到你的应用中。 这是模态框将会被渲染的地方。

#### 页面之间导航

感谢我们自定义的 HOC （暂时称之为 NativeWebRouteWrapper, 话说这真是一个糟糕的名字），我们可以使用一套跟 React Navigation 中的几乎一样的函数来实现在 web 端进行页面切换：

```
const { product, navigation } = this.props
<Button 
  onPress={navigation.navigate('ProductScreen', {id: product.id})} 
  title={`Go to ${product.name}`}
/>
<Button 
  onPress={navigation.goBack}
  title="Go Back"
/>
```

#### 回到栈中的上一个页面

在 React Navigation 中，你可以回到导航栈中的前 n 个页面。然而在 React Router 中则做不到，因为这里没有栈。为了解决这个问题，你需要引入一个自定义的 pop 函数，以及传一些参数进去。

```
import pop from '/NativeWebRouteWrapper/pop'

render() { 
  const { navigation } = this.props
  return (
    <Button
      onPress={pop({screen: 'FirstScreen', n: 2, navigation})}
      title="Go back two screens" 
    />
  )
}
```

`screen`-页面名字（在 web 端给 React Router 使用的）
`n`-需要返回多少个页面(给 React Navigation 使用的)  
`navigation`-导航对象

### 结果

如果你想试一下这个想法，我制作了两个样板。

第一个只是一个给 web 与原生的通用生产环境。你可以在[这里](https://github.com/inspmoore/rnw_boilerplate)找到。

第二个则是第一个的加强版，添加了导航的解决方案。放到了[这里](https://github.com/inspmoore/rnw_boilerplate_nav)。

另外还有一个[基于这个想法的叫做 papu 的 demo 应用](https://github.com/inspmoore/papu)。它有很多 bug 以及死胡同，不过你可以制作你自己的版本并在你的浏览器和手机上查看，感受一下是怎么工作的。

### 下一步

我们真的很需要一个通用的导航库来使我们更容易地制作类似项目。让 React Navigation 也能用在 web 环境会是很赞的事情（事实上今天你就可以做到，不过这会是一次坎坷的旅途 - [可以到这里了解一下](https://pickering.org/using-react-native-react-native-web-and-react-navigation-in-a-single-project-cfd4bcca16d0)）

**感谢你花时间阅读！如果你喜欢这篇文章，希望你能分享出去。**[**这是我的推特**](https://twitter.com/pirx__) **有什么问题请在下方评论 😃**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
