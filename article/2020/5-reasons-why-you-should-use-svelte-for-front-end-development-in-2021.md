> * 原文地址：[5 reasons why you should use Svelte for Front End Development in 2021](https://medium.com/javascript-in-plain-english/5-reasons-why-you-should-use-svelte-for-front-end-development-in-2021-c9e84db4f55c)
> * 原文作者：[Eric Bandara](https://medium.com/@ericbandara95)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/5-reasons-why-you-should-use-svelte-for-front-end-development-in-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2020/5-reasons-why-you-should-use-svelte-for-front-end-development-in-2021.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[Liusq-Cindy](https://github.com/Liusq-Cindy)、[regon-cao](https://github.com/regon-cao)

# 使用 Svelte 开发前端应用的五个理由

![A Photo By [Randy Fath](https://unsplash.com/@randyfath) on [Unsplash](https://unsplash.com/)](https://cdn-images-1.medium.com/max/2000/0*Ri1Sl9cP2_ry2vYJ)

Svelte 是由 Rich Harris 于 2016 年开发的一个前端 JavaScript 框架。目前，许多软件公司都在使用它作为主要前端框架，因为 Svelte 提供了很多便利，降低程序员开发前端应用的复杂度。

因此，本文将介绍 Svelte 是用于前端应用开发最好的 JavaScript 框架或编译器的五个理由。

## 什么是 Svelte

**它是一种新的 JavaScript 框架，更确切地说是一个编译器，它可以将应用组件转换成高效的 JavaScript 代码。**

## 两步即可开发应用

第 1 步，运行以下命令创建一个简单的项目。

```bash
npx degit sveltejs/template my-startup
```

第 2 步，进入项目中，安装依赖包并运行项目。

```bash
cd my-startup
npm install
npm run dev
```

Svelte 应用程序将在 [http://localhost:5000/](http://localhost:5000/) 启动。

## 为何应使用 Svelte

### 1. 性能

Svelte 是一个经过优化的框架，它的性能得分比 Angular 或 React 高得多，其主要原因是它提供了在编译期间生成高质量代码的灵活性。换句话说，它基本上是一个编译器。这将使得运行时开销最小化，从而进一步加快加载和接口导航性能。

### 2. bundle 大小

与其他框架相比，Svelte 的 bundle 可以说是很小的。bundle 类似于要运送给客户的包裹。所以，通过互联网发送给客户的包裹最好是把它变得小一些。即使是很慢的网络连接速度，Svelte 也能运行良好，因为它的 bundle 大小明显低于 Vue，也比 Angular 小 4 倍。

### 3. 代码量

代码量才是 Svelte 真正吸引大多数开发人员的地方。Svelte 代码量很少，能看到它只有 Vue 的一半，也只有 React 和 Angular 的一半。显然它为开发者提供了一个更好的开发体验。看看 `Hello world` 这个例子。

```html
<script>
 let wish = ‘Make me a better developer’;
</script>
<h1>Good day, {wish}!</h1>
```

如果是使用 Angular、Vue 或 React，就会有更多的代码。

### 4. 人气

显然，Svelte 并不是大多数读者心目中最受欢迎的。但是，如果仔细看下面的调查，你会发现 Svelte 在开发者的兴趣和满意度方面排名第二。

![Source: [https://2019.stateofjs.com/front-end-frameworks/](https://2019.stateofjs.com/front-end-frameworks/)](https://cdn-images-1.medium.com/max/4270/1*Xfe9crp6fWvzlh4AAftQsQ.png)

除此之外，Svelte 在 Github 上还有 40k 个 star。与 Angular、React 和 Vue 相比，它是如此的少。但是，在 2019 年，Svelte 拥有 18k star，到 2020 年它翻了一番。所以它正在获得人们更多的关注，我想随着时间的推移，它的 star 会变得越来越多。

### 5. 开发者体验

最后一部分是开发者体验。Svelte 完全是 HTML，它更加直观。

```html
<style>
 p {
  color: red;
  font-family: ‘Arial’, cursive;
  font-size: 2.3em;
}
</style>
<p>Styled paragraph!</p>
```



在 React 中，必须扩展组件类，然后获得渲染并返回，在项目文件中得到一个构造函数以及其它要处理的内容。Vue 更好一点，但仍然存在所有这些必须直观的东西。Svelte 完全是直观的，如果已经了解 HTML，那么它的代码行就更少了，显然很容易使用。

## 结论

以上就是本文主要介绍使用 Svelte 开发前端应用的五个理由。未来它会变得越来越流行，将被更多地开发团队采用。Svelte 是一个很棒的编译器框架，非常有用。

可以使用下面的链接来练习并更好地了解 Svelte。

[Svelte 示例](https://svelte.dev/examples#hello-world)

感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
