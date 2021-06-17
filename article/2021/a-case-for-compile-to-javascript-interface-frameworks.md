> * 原文地址：[A Case for Compile to JavaScript Interface Frameworks](https://javascript.plainenglish.io/a-case-for-compile-to-javascript-interface-frameworks-a684b361884f)
> * 原文作者：[AsyncBanana](https://medium.com/@asyncbanana)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/a-case-for-compile-to-javascript-interface-frameworks.md](https://github.com/xitu/gold-miner/blob/master/article/2021/a-case-for-compile-to-javascript-interface-frameworks.md)
> * 译者：[没事儿](https://github.com/Tong-H)
> * 校对者：[KimYangOfCat](https://github.com/KimYangOfCat) [PassionPenguin](https://github.com/PassionPenguin)

# 一个编译成 JavaScript 接口框架的案例

![图源 [Ferenc Almasi](https://unsplash.com/@flowforfrank?utm_source=medium&utm_medium=referral) 上传至 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10296/0*LUP7NJrirKlw-voh)

如今的 web 框架，类似 React 和 Vue 在创建现代 web 应用方面非常受欢迎，这是有原因的。这些框架帮助把代码片段变成可复用的组件，通过使用声明式性的标记使组件易于根据数据更新。

但几乎所有的这类框架运行时都需要重量型的程序库，这代表着性能上的消耗。而且这类界面语言不够强势，且因为原生 js 的限制而更繁琐。

不管怎样，针对这个问题的解决方案可以让你使用更简洁的代码获得更好的性能

这些框架把那些为声明式用户接口设计而优化的语言编译为原生 JavaScript。因为这是被编译后的，不需要大型的运行时的库，所以他们更小。

编译为 JavaScript 用户接口框架的类型有两种。一种是为了实际的逻辑而使用 JavaScript，类似 [Svelte](https://svelte.dev/) 和 [Solid](https://github.com/solidjs/solid)；另一种使用完全不同的语言，比如 [Elm](https://elm-lang.org/) 和 [Mint](https://www.mint-lang.com/)，它们通常不只是为了做声明性标记。这篇文章我们主要着重于前一种框架。现在让我们去了解一下为什么要用这些框架。

Solid 可以被看成是运行时的框架，但由于它常常用于优化代码的编译，在这篇文章中，我将它看为一种对 JS 框架的编译。

## 被编译后的 JavaScript 运行更快

很多被编译后的框架，尤其是那些比较新的，会比运行时的框架更小更快。

这是因为他们可以在代码运行前做很多优化，将代码转变为普通 DOM 操作的 JavaScript，避免使用大型的程序包。

比如，相比于着重利用编译的两个框架 Svelte 和 Solid ，React 和 vue 的设计更常用于运行时。

* React 使用被编译后的 JSX，但这只是基于调用`createElement` 的基础语法糖。

根据 BundlePhobia 计算，React 和 vue 的包大小分别是 39.4kb GZip 和 22.9kb GZip。

![React 包大小](https://cdn-images-1.medium.com/max/2724/1*yWAVUnOXKsrwrRzTSb6kzw.png)

![Vue 包大小](https://cdn-images-1.medium.com/max/2684/1*eTVWVuDuNORYhxf1g5bF_w.png)

相比之下，Svelte 除了原生 DOM 操作以外使用的东西很少，所以几乎没有基本的包大小，且对于只有一些小型函数帮助 DOM 更新。

因为编译器占据了大部分的包大小，但它并不包含在最后生成的 web 应用中，你不能从 Bundlephobia 量化其大小，但是启动时间基准可以合理的评估大小。

另外，Solid 和 Svelte 在运行时都明显更快。 根据 [Krausest Framework Benchmarks](https://krausest.github.io/js-framework-benchmark/2021/table_chrome_90.0.4430.72.html), Solid 和 Svelte 在启动时间，DOM 操作速度以及内存使用方面更快。

![框架速度基准对比](https://cdn-images-1.medium.com/max/2000/1*cyKBaU7O35rKAPZJ4jsO2A.png)

![框架启动速度对比](https://cdn-images-1.medium.com/max/2000/1*m5e36L44ph12wCOhCq576Q.png)

![框架内存基准对比](https://cdn-images-1.medium.com/max/2000/1*EuwkvRIURVuvKk7XqphdYQ.png)

就像你看到的，在大型 Dom 操作上，启动（受脚本大小和编译时间影响）时间和内存使用方面，Solid 和 Svelte 比 React 和 Vue 表现更佳。

当然，你必须记住，大部分时候这并不是很重要。但是如果你追求更好的性能，那么利用 UI 代码的编译去优化框架性能可能会是一个好方向。

比如，如果你在为使用慢速 2G 或 3G 网络的用户做开发，那么使用 Svelte 去减少大小将会很有帮助。

而且，记住，虽然被优化后编译的框架可能会比没有优化过的框架更快，vanilla JavaScript 几乎一直更快，但 vanilla JavaScript 更繁琐枯燥，这引出我们的第二个重点。

## 优化编译后的框架是为了更少的代码量

JavaScript 的最初设计并不是为了创造类似 React 这类声明型的标记，正是因为这样，React 的很多特色强迫你使用函数和方法而不是使用一般的变量，比如`useState()` ，这不糟糕但是也谈不上好。

另外，大部分功能在运行时就需要被装载，所以只有很少的功能。Svelte 对反应性变量有内置支持，你可以使用一般的语法`let variable = value`去声明。

另外，仅仅用`$:` 你就可以做一个反应性的声明。这可能会让人有点困惑，有一些例子可以帮助你理解。

```JavaScript
import {useState} from 'react'
export default function App() {
  let [clicks,setClicks] = useState(0)
  return (
    <div className="App">
      <h1>Clicks: {clicks}</h1>
      <button onClick={()=>{
        setClicks(clicks+1)
      }}>Click Me!</button>
    </div>
  );
}
```

```Svelte
<script>
	let clicks = 0
</script>

<h1>Clicks: {clicks}</h1>
<button on:click={()=>
	clicks++
}>Click Me!</button>
```

正如你看到的，语法风格完全不同。Svelte 更有原生的感觉，且比 React 少 1/3 的代码。

不管怎样，主要取决于你想要怎样的语法，但是编译者为语法增加了更多的灵活性。你可能会想花费在编译和设置编译器上的时间胜于它带来的语法优势，这就引出了最后一点。

## 你可能已经在编译 JavaScript 了

你可能只使用原生 JavaScript，但是你仍然还是要编译它，即使只是为了将 ES6 转化为旧版本浏览器所支持的代码，或者是为了压缩代码。[创建 React App](https://create-react-app.dev/) 在后台使用 Webpack 去执行不同的代码。实际上，被 Reat 团队推荐的 React JSX，需要编译成函数调用去创建真实的元素。

不幸的是， React 并不能充分利用并优化它，尽管他们最近在新的 JSX 转换方面取得了一些改进。 [Vue Cli](https://cli.vuejs.org/) 也在后台使用 Webpack。这表示虽然你不需要使用编译器，但不管怎样你很可能会用，而且这非常容易设置。

## 总结

使用一个编译成 JavaScript 框架不永远是答案。有些不编译成 JavaScript 的框架比那些用编译器的框架更快一些，且使用编译器并不代表它就是一个更好的框架。

而且，被编译的范围很广。比如 Alpine.js 这类框架被设计成完全不需要任何构建的步骤就可以运行。

其他的，类似 React，只选择性的编译少部分代码。Solid 使用 JSX，有点类似 React，但是它在编译时优化更进一步。

编译的最后一个水平是任何代码都可以被编译，比如 Svelte。你想编译多少这是你的选择，每种方案都有各自的优缺点。

我希望从这篇文章中你能够有收获，感谢阅读。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
