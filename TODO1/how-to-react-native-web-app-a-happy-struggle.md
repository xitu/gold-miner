> * 原文地址：[How to: React Native Web app. A Happy Struggle.](https://blog.bitsrc.io/how-to-react-native-web-app-a-happy-struggle-aea7906f4903)
> * 原文作者：[Lucas Mórawski](https://blog.bitsrc.io/@lucasmorawski?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-react-native-web-app-a-happy-struggle.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-react-native-web-app-a-happy-struggle.md)
> * 译者：
> * 校对者：

# How to: React Native Web app. A Happy Struggle.

## A short yet detailed tutorial to building a universal application.

![](https://cdn-images-1.medium.com/max/2000/1*RiQRKKQ2ndxD6ddo8hXNLg.png)

You wake up. Sun is shining, birds are singing. There are no wars, no hunger and code can be easily shared between native and web environment. Wouldn’t that be nice? Unfortunately, only in the latter one, hope is on the horizon, but there are still some caveats on the way.

### Why should you care?

PWA ([Progressive Web App](https://en.wikipedia.org/wiki/Progressive_Web_Apps)) is now a big three-letter word in the sea of tech acronyms, but this approach still has it’s [drawbacks](https://clutch.co/app-developers/resources/pros-cons-progressive-web-apps). There are tons of technological difficulties and use cases where you’re forced to build a native app alongside a web variety. [There’s a great article by Ian Naylor about that](https://appinstitute.com/pwa-vs-native-apps/).

But, building only a native app for your e-commerce business is also a big mistake. So making one piece of software working everywhere seems like a logical step. You cut working hours, production and maintenance costs. That is why I started this little experiment.

A simple e-commerce universal example app for online food order. Upon that I created a boilerplate for future projects and further experimentation.

![](https://cdn-images-1.medium.com/max/1000/1*hSTFw1TNjeqLZHq_DTBVRg.png)

Papu — food app on Android/iOS/Web

### Check your primitives

We’re working here with React, so we should separate the app logic from the UI. Using some state managing system like Redux/MobX/other is the best choice. That move already makes business logic universal and shareable among the platforms.

The visual part is yet a different beast. To construct your app’s interface you need to have a common set of primitive building blocks. They need to work on the web, as well as in the native environment. Unfortunately web speaks a different dialect

```
<div>Aye there Cap! Standard web container at your service!</div>
```

than native

```
<View>Hi! I'm a basic container in React Native</View>
```

Some smart people figured this out. One of my favorite solutions is the grand [React Native Web](https://github.com/necolas/react-native-web) library made by [Nicolas Gallagher](http://nicolasgallagher.com/). Not only it takes care of the primitives by letting you use the React Native components on the web (not all of them!). It also exposes some of React Native’s APIs like Geolocation, Platform, Animated, AsyncStorage and more! Check out some great examples in the [RNW guides](https://github.com/necolas/react-native-web/tree/master/docs/guides).

### A boilerplate to begin with

So we figured out how to deal with the primitives. We still need to glue the web and native production environments together and make the magic happen. For my project I used [create-react-app](https://github.com/facebook/create-react-app) for the web part and [RN](https://facebook.github.io/react-native/docs/getting-started)’s init script (no Expo here). First I created a project with `create-react-app rnw_web`. Then another one with `react-native init raw_native`. Then I “frankensteined” their respective `package.json` files into one and run yarn on it, in a new project folder. The final package file looks like so:

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

package.json for React Native Web boilerplate (no navigation in this version)

You need to copy all the source folders from the web and native folders to your new unified project folder.

![](https://cdn-images-1.medium.com/max/800/1*jBJPol8evebkL96FXEAFew.png)

Folders that need to be copied to a new project

Next in our newly created src folder we put two files App.js and App.native.js. Thanks to [webpack](https://webpack.js.org/) we can use file name extensions to tell the bundler which files to use where. It is vital to use separate App files, since we’re going to use different approaches to app navigation.

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

App.js for Web. Here with react-router for navigation.

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

App.js for React Native with react-navigation.

That’s how I built a simple boilerplate and constructed a frame for the app. You can try out my clean boilerplate by cloning my github repo.

* [**inspmoore/rnw_boilerplate**: A simple boilerplate for code sharing between React Native and ReactDOM using React Native Web lib.](https://github.com/inspmoore/rnw_boilerplate "https://github.com/inspmoore/rnw_boilerplate")

Next we’re going to a complicate it just a little bit, by adding routing/navigation system.

### Navigation problems and solutions

Unless your app consists of only one screen you need some sort of navigation. Right now (Sep 2018) there is only one ready universal web/native formula — [React Router](https://reacttraining.com/react-router/). It’s a goto solution for web but not exactly for RN.

React Router Native lacks screen transitions, back-button support (android), modals, navbars, others. Other navigators provide this functionality, like [React Navigation](https://reactnavigation.org/).

That’s the one I used in my project but you could use others. So it’s React Router for web and React Navigation for native. This yet creates a new problem. Navigating, as well as passing parameters, in both of those navigators dramatically differs.

To keep the React Native Web spirit of using the more native-like experience everywhere, I approached this problem by building web routes and wrapping them in a HOC. That exposed a React Navigation like API.

This allows to navigate between the screens on the web, without the need to create separate components for both worlds.  
First step is to create a route map object for web routes:

import WebRoutesGenerator from "./NativeWebRouteWrapper"; //custom function that generates React Router routes and wraps them in a HOC

```
import WebRoutesGenerator from "./NativeWebRouteWrapper"; //custom function that generates React Router routes and wraps them in a HOC

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

//in the render method
<View>
  {WebRoutesGenerator({ routeMap })}
</View>
```

The syntax is a copy of React Navigation navigator creation functions with an addition of React Router specific options. Then, with my helper function, I create `react-router` routes. Wrap them in a HOC. That clones the screen component and adds `navigation` property to it’s props. This mimics React Navigation and exposes methods like `navigate()`, `goBack()`, `getParam()`.

#### Modals

React Navigation with it’s `createStackNavigator` gives an option to make the screen slide from the bottom as a modal. To achieve this on the web I have used [React Router Modal](https://github.com/davidmfoley/react-router-modal) library by [Dave Foley](https://github.com/davidmfoley). To use a screen as a modal, first you have to add a modal option to the route map:

```
const routeMap = {
  Modal: {
    screen: ModalScreen,
    path: '*/modal',
    modal: true //the router will use ModalRoute component to render this route
  }
}
```

You also need to add a `<ModalContainer />` component from the `react-router-modal` library to your app’s layout. This is where it’ll be rendered.

#### Navigating between the screens

Thanks to our custom HOC (called temporarily NativeWebRouteWrapper — that’s a terrible name btw) we can use almost the same set of functions as in React Navigation to move between the screens on the web:

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

#### Getting back to a previous screen in the stack

In React Navigation you can go back n-number of screens in your navigation stack. There’s no such thing in React Router, since there are no stacks. To solve this problem you need to import the custom pop function and pass few parameters:

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

`screen`-screen name (used on the web by React Router)  
`n`-number of screens to go back in the stack (used by React Navigation)  
`navigation`-navigation object

### End results

If you want play with this idea, I’ve created two boilerplates.

First one is just a clean universal production environment for web and native. You can find it [here](https://github.com/inspmoore/rnw_boilerplate).

Second one is the first one enhanced with my navigation solutions. Check it out [here](https://github.com/inspmoore/rnw_boilerplate_nav).

There’s also a [demo app based on that idea called papu](https://github.com/inspmoore/papu). It’s full of bugs and blind alleys but you can build it yourself and launch in your browser and mobile to get a taste of how it all works.

### Next step

We trully need some universal navigation library to make projects like this easier to build. Making React Navigation to function also in the web environment would be awesome (actually you can do it today, but it’s a very bumpy ride — [check it out here](https://pickering.org/using-react-native-react-native-web-and-react-navigation-in-a-single-project-cfd4bcca16d0))

**Thanks for your time! Please recommend and share if you like it.** [**Hit me on twitter**](https://twitter.com/pirx__) **should you have any questions or comment below 😃**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
