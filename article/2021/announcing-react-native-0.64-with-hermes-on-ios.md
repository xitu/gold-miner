> * 原文地址：[Announcing React Native 0.64 with Hermes on iOS](https://reactnative.dev/blog/2021/03/11/version-0.64)
> * 原文作者：[Mike Grabowski](https://twitter.com/grabbou)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/announcing-react-native-0.64-with-hermes-on-ios.md](https://github.com/xitu/gold-miner/blob/master/article/2021/announcing-react-native-0.64-with-hermes-on-ios.md)
> * 译者：[大宁的洛竹](https://github.com/youngjuning)
> * 校对者：[lsvih](https://github.com/lsvih)、[PassionPenguin](https://github.com/PassionPenguin)

# React Native 0.64 发布，已在 iOS 支持 Hermes

今天，我们发布了 React Native 0.64，该版本在 iOS 上提供了对 Hermes 的支持。

## iOS 可选支持 Hermes

[Hermes](https://hermesengine.dev/) 是为了运行 React Native 而优化的开源 JavaScript 引擎。它通过降低内存使用率、减小打包体积以及减少应用从启动到可使用所花费的时间来优化性能。

在此版本中，我们很高兴地宣布，你现在也可以使用 Hermes 在 iOS 上进行构建应用。要在 iOS 上启用 Hermes，请在你的 `Podfile` 中将 `hermes_enabled` 设置为 `true` 并在命令行执行行 `pod install`。

```ruby
use_react_native!(
   :path => config[:reactNativePath],
   # 修改 false 为 true 然后安装 pods 以在 iOS 上开启 hermes
   :hermes_enabled => true
)
```

请记住，iOS 上对 Hermes 的支持仍处于早期阶段。在进行进一步的基准测试时，我们将其作为可选配置加入。我们鼓励你在自己的应用程序上尝试它，并让我们知道你使用它遇到的情况！

## 默认启用内联引用

内联引用（Inline Requires）是 Metro 的配置选项，它通过将 JavaScript 模块的执行延迟到使用之前（而不是在启动时）来缩短启动时间。

此功能已经存在并已推荐使用多年，作为一个可选配置选项，已在 [我们文档的性能章节](https://reactnative.dev/docs/performance) 中列出。现在，我们默认为新应用程序启用此选项，以帮助人们无需额外配置即可构建快速的 React Native 应用。

内联引用是一个 Babel 转换器，它接受模块导入并将其转换为内联。在下面的例子中，Inline Requires 将模块导入的位置从文件的顶部转换为调用该模块的位置。

**使用前：**

```jsx
import { MyFunction } from 'my-module';

const MyComponent = props => {
  const result = myFunction();

  return <Text>{result}</Text>;
};
```

**使用后：**

```jsx
const MyComponent = props => {
  const result = require('my-module').MyFunction();

  return <Text>{result}</Text>;
};
```

有关内联引用的更多信息，请参见 [性能文档](https://reactnative.dev/docs/ram-bundles-inline-requires#inline-requires)。

## 使用 Chrome 浏览 Hermes 堆栈

在过去的一年中，Facebook 赞助了 [Major League Hacking fellowship](https://fellowship.mlh.io/)，以支持他们对 React Native 的贡献。[Jessie Nguyen](https://twitter.com/jessie_anh_ng) 和 [Saphal Patro](https://twitter.com/saphalinsaan) 添加了使用 Chrome Devtools 上的 “Performance” 标签来查看你的应用程序使用 Hermes 时的执行情况的功能。

更多信息请参见 [新的文档页面](https://reactnative.dev/docs/profile-hermes#record-a-hermes-sampling-profile)。

## Hermes 支持 Proxy

我们为 Hermes 添加了 Proxy 支持，从而实现了与热门社区项目（如 react-native-firebase 和 mobx）的兼容性。如果你一直在使用这些软件包，则现在可以为你的项目迁移到 Hermes。

我们计划在即将发布的版本中使 Hermes 成为 Android 的默认 JavaScript 引擎，因此我们正在努力解决人们在使用 Hermes 时仍然遇到的问题。如果还有其他问题使你的应用无法采用 Hermes，请在 [Hermes GitHub](https://github.com/facebook/hermes) 仓库提一个 issue。

## React 17

React 17 不包含面向开发人员的新功能或重大更改。对于 React Native 应用程序，主要更改是 [新的 JSX 转换器](https://reactjs.org/blog/2020/09/22/introducing-the-new-jsx-transform.html)，该特性使文件不再需要导入 React 才能使用 JSX。

关于 React 17 的更多信息请参见 [React blog](https://reactjs.org/blog/2020/10/20/react-v17.html)。

## 主要依赖版本更改

- 不再支持 Android API 16-20。一直以来 Facebook 都选择放弃对使用率足够低的 Android 版本的支持。Facebook 是 React Native 的主要测试平台，由于 Facebook 不再支持这些 API 版本，因此 React Native 也将放弃支持它们。
- 需要升级 Xcode 到 12 并升级 CocoaPods 到 1.10
- 最低 Node 版本支持从 10 提升到 12
- Flipper 升级到 0.75.1

## 感谢

感谢数以百计的贡献者，这些贡献者使 0.64 的发布成为可能！[0.64 changelog](https://reactjs.org/blog/2020/10/20/react-v17.html) 包含此版本中包含的所有更改。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
