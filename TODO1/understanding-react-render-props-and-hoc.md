> * 原文地址：[Understanding React Render Props and HOC](https://blog.bitsrc.io/understanding-react-render-props-and-hoc-b37a9576e196)
> * 原文作者：[Aditya Agarwal](https://blog.bitsrc.io/@adityaa803?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-react-render-props-and-hoc.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-react-render-props-and-hoc.md)
> * 译者：[wuzhengyan2015](https://github.com/wuzhengyan2015)
> * 校对者：[Ivocin](https://github.com/Ivocin), [Moonliujk](https://github.com/Moonliujk)

# 理解 React Render Props 和 HOC

## React 中 Render Props 和高阶组件的详细介绍

![](https://cdn-images-1.medium.com/max/1000/1*ORm5S_4kr4hcNSnyoXZSKQ.png)

reactjs.org

如果你最近有在做 [React 开发](https://blog.bitsrc.io/how-to-write-better-code-in-react-best-practices-b8ca87d462b0)，你肯定有遇到像 HOCs 和 Render Props 这样的术语。在本文中，我们将深入探讨这两种模式，以便了解我们为什么需要它们，以及如何正确地使用它们来构建更好的 React 应用。

### 为什么我们需要这些模式？

React 提供了一种简单的代码复用方式，即**组件**。组件封装了很多东西，包括内容、样式和业务逻辑。理想情况下，在单个组件中，我们可以将 html、css 和 js 结合起来，所有的这些是为了一个目的，[单一职责](https://blog.bitsrc.io/solid-principles-every-developer-should-know-b3bfa96bb688)。

提示：使用 [**Bit** (Github)](https://github.com/teambit/bit)，你可以组织和分享**可复用的组件**，这些组件可以从不同的项目和应用中被发现，分享和开发。这比重写组件或者维护一个大型库要快得多。试试看 :)

- [**Bit — 分享和构建组件代码**：Bit 帮助你从不同的项目和应用中分享，发现和使用组件代码，以此来构建新特性和...](https://bitsrc.io "https://bitsrc.io")

#### 例子

假设我们正在开发一个电子商务应用程序。它与其他电子商务应用程序一样，向用户显示所有可购买产品，并且用户可以将任何产品添加到购物车。我们将从 API 获取产品数据，并将产品目录显示为卡片列表。

在这种情况下，React 组件可以像这样实现：

![](https://cdn-images-1.medium.com/max/800/1*Y_sQCauEZZUycXS4HDs6-Q.png)

[代码链接](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=import%2520React%252C%2520%257B%2520Component%2520%257D%2520from%2520%2522react%2522%253B%250A%250Aclass%2520ProductList%2520extends%2520Component%2520%257B%250A%2520%2520state%2520%253D%2520%257B%250A%2520%2520%2520%2520products%253A%2520%255B%255D%250A%2520%2520%257D%253B%250A%250A%2520%2520componentDidMount%28%29%2520%257B%250A%2520%2520%2520%2520getProducts%28%29.then%28products%2520%253D%253E%2520%257B%250A%2520%2520%2520%2520%2520%2520this.setState%28%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520products%250A%2520%2520%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%257D%250A%250A%2520%2520render%28%29%2520%257B%250A%2520%2520%2520%2520return%2520%28%250A%2520%2520%2520%2520%2520%2520%253Cul%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%257Bthis.state.products.map%28product%2520%253D%253E%2520%28%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Cli%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Cspan%253E%257Bproduct.name%257D%253C%252Fspan%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Ca%2520href%253D%2522%2523%2522%253EAdd%2520to%2520Cart%253C%252Fa%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Fli%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%29%29%257D%250A%2520%2520%2520%2520%2520%2520%253C%252Ful%253E%250A%2520%2520%2520%2520%29%253B%250A%2520%2520%257D%250A%257D%250A%250Aexport%2520%257B%2520ProductList%2520%257D%253B&es=2x&wm=false&ts=false)

对于我们的管理员，有一个管理门户，他们可以在其中添加或删除产品。在此门户中，我们从同一 API 获取产品数据，并以表格形式显示产品目录。

这个 React 组件可以像这样实现：

![](https://cdn-images-1.medium.com/max/800/1*rbLMZdroffO_nUWVA1rpGQ.png)

[代码链接](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=import%2520React%252C%2520%257B%2520Component%2520%257D%2520from%2520%2522react%2522%253B%250A%250Aclass%2520ProductTable%2520extends%2520Component%2520%257B%250A%2520%2520state%2520%253D%2520%257B%250A%2520%2520%2520%2520products%253A%2520%255B%255D%250A%2520%2520%257D%253B%250A%250A%2520%2520componentDidMount%28%29%2520%257B%250A%2520%2520%2520%2520getProducts%28%29.then%28products%2520%253D%253E%2520%257B%250A%2520%2520%2520%2520%2520%2520this.setState%28%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520products%250A%2520%2520%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%257D%250A%250A%2520%2520handleDelete%2520%253D%2520currentProduct%2520%253D%253E%2520%257B%250A%2520%2520%2520%2520const%2520remainingProducts%2520%253D%2520this.state.products.filter%28%250A%2520%2520%2520%2520%2520%2520product%2520%253D%253E%2520product.id%2520!%253D%253D%2520currentProduct.id%250A%2520%2520%2520%2520%29%253B%250A%2520%2520%2520%2520deleteProducts%28currentProduct.id%29.then%28%28%29%2520%253D%253E%2520%257B%250A%2520%2520%2520%2520%2520%2520this.setState%28%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520products%253A%2520remainingProducts%250A%2520%2520%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%257D%253B%250A%250A%2520%2520render%28%29%2520%257B%250A%2520%2520%2520%2520return%2520%28%250A%2520%2520%2520%2520%2520%2520%253Ctable%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%253Cthead%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Ctr%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Cth%253EProduct%2520Name%253C%252Fth%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Cth%253EActions%253C%252Fth%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Ftr%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Fthead%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%253Ctbody%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%257Bthis.state.products.map%28product%2520%253D%253E%2520%28%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Ctr%2520key%253D%257Bproduct.id%257D%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Ctd%253E%257Bproduct.name%257D%253C%252Ftd%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Ctd%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Cbutton%2520onClick%253D%257B%28%29%2520%253D%253E%2520this.handleDelete%28product%29%257D%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520Delete%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Fbutton%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Ftd%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Ftr%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%29%29%257D%250A%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Ftbody%253E%250A%2520%2520%2520%2520%2520%2520%253C%252Ftable%253E%250A%2520%2520%2520%2520%29%253B%250A%2520%2520%257D%250A%257D%250A%250Aexport%2520%257B%2520ProductTable%2520%257D%253B&es=2x&wm=false&ts=false)

有一件事很明显，这两个组件都实现了产品的数据获取逻辑。

继续深入，以下这些情况也可能出现：

*   我们必须使用产品数据并以不同的方式显示它。
*   从不同的 API 中获取产品数据（在用户的购物车页面中很有用），但数据的显示和我们在 `ProductList` 中的做法类似。
*   我们必须从 localStorage 访问它，而不是从 API 获取数据。
*   在产品目录表格中，需要使用具有不同操作的按钮而不是删除按钮。

如果我们为这些每一点都写个不同的组件，那么我们将要复制大量的代码。

获取数据和显示数据是两个独立的关注点。正如前面所说的，如果一个组件有一个责任会更好。

让我们重构第一个组件。它将接受产品数据为属性，并像之前一样把产品目录渲染成卡片列表。由于我们不需要[组件状态和生命周期方法](https://blog.bitsrc.io/understanding-react-v16-4-new-component-lifecycle-methods-fa7b224efd7d)，我们把它转换成函数式组件。

它现在看起来是这样的：

![](https://cdn-images-1.medium.com/max/800/1*H5Bao06wMbFJX1ILLd6QJA.png)

ProductList.js ([代码链接](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=import%2520React%2520from%2520%2522react%2522%253B%250A%250Aconst%2520ProductList%2520%253D%2520%28%257B%2520products%2520%257D%29%2520%253D%253E%2520%257B%250A%2520%2520return%2520%28%250A%2520%2520%2520%2520%253Cul%253E%250A%2520%2520%2520%2520%2520%2520%257Bproducts.map%28product%2520%253D%253E%2520%28%250A%2520%2520%2520%2520%2520%2520%2520%2520%253Cli%2520key%253D%257Bproduct.id%257D%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Cspan%253E%257Bproduct.name%257D%253C%252Fspan%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520%253Ca%2520href%253D%2522%2523%2522%253EAdd%2520to%2520Cart%253C%252Fa%253E%250A%2520%2520%2520%2520%2520%2520%2520%2520%253C%252Fli%253E%250A%2520%2520%2520%2520%2520%2520%29%29%257D%250A%2520%2520%2520%2520%253C%252Ful%253E%250A%2520%2520%29%253B%250A%257D%253B%250A%250Aexport%2520%257B%2520ProductList%2520%257D%253B&es=2x&wm=false&ts=false))

就像 `ProductList` 和 `ProductTable` 会是一个函数组件，它接收产品数据为属性，并把数据渲染到表的行中去。

现在让我们创建一个名为 `ProductsData` 的组件。它从 API 获取产品数据。数据的获取和状态的更新将和原先的 `ProductList` 组件一样。但是我们应该在这个组件的 render 方法中放入什么呢？

![](https://cdn-images-1.medium.com/max/800/1*YUTzVts0O0Nx8JdoBt0sRw.png)

ProductData.js ([代码链接](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=import%2520React%252C%2520%257B%2520Component%2520%257D%2520from%2520%2522react%2522%253B%250A%250Aclass%2520ProductData%2520extends%2520Component%2520%257B%250A%2520%2520state%2520%253D%2520%257B%250A%2520%2520%2520%2520products%253A%2520%255B%255D%250A%2520%2520%257D%253B%250A%250A%2520%2520componentDidMount%28%29%2520%257B%250A%2520%2520%2520%2520getProducts%28%29.then%28products%2520%253D%253E%2520%257B%250A%2520%2520%2520%2520%2520%2520this.setState%28%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520products%250A%2520%2520%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%257D%250A%250A%2520%2520render%28%29%2520%257B%250A%2520%2520%2520%2520return%2520%27what%2520should%2520we%2520return%2520here%253F%27%253B%250A%2520%2520%257D%250A%257D%250A%250Aexport%2520%257B%2520ProductData%2520%257D%253B%250A&es=2x&wm=false&ts=false))

如果我们只是简单的放入 ProductList 组件，那么我们就不能复用这个组件于 ProductTable。不管怎样，如果这个组件可以询问要渲染什么，那个问题就会得到解决。在一个地方，我们将告诉它要渲染 `ProductList` 组件，而在管理门户中，我们告诉它要渲染 `ProductTable` 组件。

这就是 Render Props 和 HOCs 发挥作用的地方。它们只是一类方法，即对于一个组件，会询问应该渲染什么内容。这进一步推动了代码的复用。

现在我们知道了为什么需要它们，让我们来看看如何使用它们。

### Render Props

在概念层面理解 Render Props 非常简单。让我们忘掉 React 一会，然后看看原生 JavaScript 下的事情。

我们有一个计算两个数字之和的函数。起初我们只想要把结果记录到控制台。所以，我们这样设计函数：

![](https://cdn-images-1.medium.com/max/800/1*3fUyzeYTNnRlxS9-A5Ic_Q.png)

但是，我们很快发现 sum 函数非常有用，我们需要在其他地方使用到它。因此，我们希望 sum 函数只提供结果，而不是将其记录到控制台，并让调用者决定如何使用结果。

它可以这么做：

![](https://cdn-images-1.medium.com/max/800/1*KO9pes8Nw2CAtOoum9iOoA.png)

[代码链接](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=javascript&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=const%2520sum%2520%253D%2520%28a%252C%2520b%252C%2520fn%29%2520%253D%253E%2520%257B%250A%2520%2520const%2520result%2520%253D%2520a%2520%252B%2520b%253B%250A%2520%2520fn%28result%29%253B%250A%257D%250A%250A%250A%252F%252FUsage%250A%250Asum%281%252C%25202%252C%2520%28result%29%2520%253D%253E%2520%257B%250A%2520%2520console.log%28result%29%253B%250A%257D%29%250A%250Aconst%2520alertFn%2520%253D%2520%28result%29%2520%253D%253E%2520%257B%250A%2520%2520alert%28result%29%253B%250A%257D%250A%250Asum%283%252C%25206%252C%2520alertFn%29&es=2x&wm=false&ts=false)

我们传给 `sum` 函数一个 `fn` 回调函数作为参数。然后 `sum` 函数计算结果并把结果作为参数调用 `fn`。通过这种方式，回调函数可以获得结果，并且可以自由地对结果进行任何操作。

这就是 Render Props 的本质。我们将通过使用这个模式来更清晰地认识它，所以让我们立刻把它用到我们现在面临的问题中去吧。

在这不是计算两个数字之和的函数，而是获取产品数据的组件 `ProductsData`。现在可以通过属性传递给 `ProductsData` 组件一个函数。然后 `ProductsData` 组件将获取产品数据，并将这些数据提供给以属性方式传递进来的函数。传递进来的函数现在可以对产品数据做任何它想做的事情。

在 React 中，它可以像这样实现：

![](https://cdn-images-1.medium.com/max/800/1*bVc30RctgB9yecfgqJLJcg.png)

[代码链接](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=import%2520React%252C%2520%257B%2520Component%2520%257D%2520from%2520%2522react%2522%253B%250A%250Aclass%2520ProductData%2520extends%2520Component%2520%257B%250A%2520%2520state%2520%253D%2520%257B%250A%2520%2520%2520%2520products%253A%2520%255B%255D%250A%2520%2520%257D%253B%250A%250A%2520%2520componentDidMount%28%29%2520%257B%250A%2520%2520%2520%2520getProducts%28%29.then%28products%2520%253D%253E%2520%257B%250A%2520%2520%2520%2520%2520%2520this.setState%28%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520products%250A%2520%2520%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%257D%250A%250A%2520%2520render%28%29%2520%257B%250A%2520%2520%2520%2520return%2520this.props.render%28%257B%250A%2520%2520%2520%2520%2520%2520products%253A%2520this.state.products%250A%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%257D%250A%257D%250A%250Aexport%2520%257B%2520ProductData%2520%257D%253B%250A&es=2x&wm=false&ts=false)

就像 `fn` 参数，我们有一个 **render** 属性，它将作为一个函数被传递。然后 `ProductData` 组件把产品数据作为参数调用这个函数。

因此我们可以以这种方式使用 `ProductData` 组件。

![](https://cdn-images-1.medium.com/max/800/1*_nSoSbkcZpgkxGrYtrea8g.png)

[代码链接](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=%253CProductData%250A%2520%2520render%253D%257B%28%257B%2520products%2520%257D%29%2520%253D%253E%2520%253CProductList%2520products%253D%257Bproducts%257D%2520%252F%253E%257D%250A%252F%253E%250A%250A%250A%253CProductData%250A%2520%2520render%253D%257B%28%257B%2520products%2520%257D%29%2520%253D%253E%2520%253CProductTable%2520products%253D%257Bproducts%257D%2520%252F%253E%257D%250A%252F%253E%250A%250A%250A%253CProductData%2520render%253D%257B%28%257B%2520products%2520%257D%29%2520%253D%253E%2520%28%250A%2520%2520%253Ch1%253E%250A%2520%2520%2520%2520%2520%2520Number%2520of%2520Products%253A%250A%2520%2520%2520%2520%2520%2520%253Cstrong%253E%257Bproducts.length%257D%253C%252Fstrong%253E%250A%2520%2520%253C%252Fh1%253E%250A%2520%2520%250A%29%257D%2520%252F%253E%250A&es=2x&wm=false&ts=false)

正如我们所看到的 **Render Props** 是一种相当通用的模式。大部分事情都可以非常直接地完成。但这也是我们搬起石头砸自己的脚的原因：

![](https://i.loli.net/2018/12/17/5c17638f6b5ad.png)

![](https://i.loli.net/2018/12/17/5c17639dc0217.png)

![](https://i.loli.net/2018/12/17/5c1763acaf846.png)

避免嵌套的一种简单方法是把组件拆解成更小的组件，并将这些组件保存在单独的文件中。另一种方法是编写更多的组件并组合它们，而不是在 Render Props 中使用长函数。

接下来，我们将看下另一种流行的模式，它被称为 HOC。

### 高阶组件（HOC）

在这个模式中，我们定义了一个函数，该函数接受一个组件作为参数，然后返回相同的组件，但是添加了一些功能。

如果这听起来很熟悉，那是因为它类似于 Mobx 中广泛使用的装饰器模式。像 Python 这样的许多语言都内置了装饰器，JavaScript也很快就会支持装饰器。HOCs 很像装饰器。

比起用文字解释，用通过代码来理解 HOCs 会容易很多。所以让我们先来看代码。

![](https://cdn-images-1.medium.com/max/800/1*c9Y18PctkxW_GpUuYggojw.png)

[代码链接](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=import%2520React%252C%2520%257B%2520Component%2520%257D%2520from%2520%2522react%2522%253B%250A%250Aconst%2520withProductData%2520%253D%2520WrappedComponent%2520%253D%253E%250A%2520%2520class%2520ProductData%2520extends%2520Component%2520%257B%250A%2520%2520%2520%2520state%2520%253D%2520%257B%250A%2520%2520%2520%2520%2520%2520products%253A%2520%255B%255D%250A%2520%2520%2520%2520%257D%253B%250A%250A%2520%2520%2520%2520componentDidMount%28%29%2520%257B%250A%2520%2520%2520%2520%2520%2520getProducts%28%29.then%28products%2520%253D%253E%2520%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520this.setState%28%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520%2520%2520products%250A%2520%2520%2520%2520%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%2520%2520%2520%2520%257D%29%253B%250A%2520%2520%2520%2520%257D%250A%250A%2520%2520%2520%2520render%28%29%2520%257B%250A%2520%2520%2520%2520%2520%2520return%2520%253CWrappedComponent%2520products%253D%257Bthis.state.products%257D%2520%252F%253E%253B%250A%2520%2520%2520%2520%257D%250A%2520%2520%257D%253B%250A%250Aexport%2520%257B%2520withProductData%2520%257D%253B%250A&es=2x&wm=false&ts=false)

正如我们所看到的，数据获取和状态更新逻辑就和我们在 Render Props 所做的一样。唯一的变化就是组件类是位于函数内部。该函数接受一个组件为参数，然后在内部的 render 方法中渲染这个组件，但是会添加额外的属性。对于名称如此复杂的模式，实现起来相当简单，对吧？

![](https://cdn-images-1.medium.com/max/800/1*k-Px1N8t5dnq0snEtdHE_g.png)

[代码链接](https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=jsx&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=48px&ph=32px&ln=false&fm=Hack&fs=14px&lh=133%25&si=false&code=%252F%252F%2520Wrap%2520ProductList%252C%2520ProductTable%2520to%2520get%2520the%2520higher%2520order%2520components%250Aconst%2520ProductListWithData%2520%253D%2520withProductData%28ProductList%29%253B%250Aconst%2520ProductTableWithData%2520%253D%2520withProductData%28ProductTable%29%253B%250A%250A%250A%252F%252F%2520Use%2520the%2520higher%2520order%2520components%2520just%2520like%2520normal%2520components.%250A%250A%253Cdiv%253E%250A%2520%2520%253CProductListWithData%2520%252F%253E%250A%2520%2520%253CProductTableWithData%2520%252F%253E%250A%253C%252Fdiv%253E&es=2x&wm=false&ts=false)

现在我们已经了解了为什么我们需要 Render Props，HOCs 以及我们如何实现它们。

还有一个问题：如何在 Render Props 和 HOCs 中进行选择？关于这个话题的文章已经有很多了，所以我现在不讨论这个话题。也许在我的下一篇文章中 :)

[什么时候不要使用 Render Props](https://blog.kentcdodds.com/when-to-not-use-render-props-5397bbeff746) — Kent C. Dodds

[HOCs vs Render Props](https://www.richardkotze.com/coding/hoc-vs-render-props-react) — Richard Kotze

### 结论

在本文中，我们了解了为什么需要这些模式，每个模式的本质和如何利用这些模式来构建高度可复用的组件。以上就是全部内容，希望你喜欢，请随意**评论和提问**。我很乐意交流 👏

> 2018 年 10 月更新：React hooks 已经在 alpha 版本中中发布。它们将消除编写类组件、HOCs 和 Render Props 的痛苦。我很快就会写一篇来解释，关注我的 [Twitter](https://twitter.com/dev__adi) 和 [Medium](https://medium.com/@adityaa803) 或者订阅 [我的时事通讯](https://buttondown.email/itaditya) 来获取最新消息。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
