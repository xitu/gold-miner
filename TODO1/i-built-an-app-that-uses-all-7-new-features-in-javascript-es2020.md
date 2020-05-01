> - 原文地址：[I Built an App That Uses All 7 New Features in JavaScript ES2020](https://levelup.gitconnected.com/i-built-an-app-that-uses-all-7-new-features-in-javascript-es2020-647205024984)
> - 原文作者：[Tyler Hawkins](https://medium.com/@thawkin3)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/i-built-an-app-that-uses-all-7-new-features-in-javascript-es2020.md](https://github.com/xitu/gold-miner/blob/master/TODO1/i-built-an-app-that-uses-all-7-new-features-in-javascript-es2020.md)
> - 译者：[yvonneit](https://github.com/yvonneit)
> - 校对者：[Raoul1996](https://github.com/Raoul1996), [niayyy-S](https://github.com/niayyy-S)

# 使用 JavaScript ES2020 中所有的 7 个新特性构建 App

![Unit Price Calculator App](https://cdn-images-1.medium.com/max/2506/0*10AyqKCN-035dR-L.png)

web 开发领域发展迅速，尤其是 JavaScript 生态系统。新的特性、框架和库层出不穷，停止学习的那一刻，即是你技术栈开始过时之时。

保持 JavaScript 技能前沿性的一个重点就是掌握 JavaScript 的最新特性。因此，我认为如果能够结合 JavaScript ES2020 中的所有七个新特性来构建 app 肯定会很有趣。

---

我最近去 Costco 采购了很多东西，以储备一些食品必需品。像大多数商店一样，Costco 中的价格标签用以标示每件商品的单价，这样顾客就可以比较每笔交易值不值得。如果是你，你会带着小购物袋还是大购物袋去买东西呢？（我在跟谁开玩笑呢？这是 Costco 啊，肯定带大的！）

但如果不显示商品的单价呢？

在本文中，我将构建一个单价计算器 app。其中，前端使用 vanilla JS，后端使用 [Node.js](https://nodejs.org/en/) 和 [Express.js](https://expressjs.com/)。然后在 [Heroku](http://heroku.com/) 上部署该 app，利用 Heroku 可以很容易[快速部署 node.js 应用程序](https://devcenter.heroku.com/articles/getting-started-with-nodejs)。

## JavaScript ES2020 中有什么新特性？

ECMAScript 是 JavaScript 的一种语言规范。从 ES2015（ES6）开始，每年都会发布一个新版本的 JavaScript。截至目前，最新版本为 ES2020（ES11）。ES2020 包含了七个令 JS 开发人员既兴奋又期待已久的七个新特性，这些新特性包括：

1. Promise.allSettled()
2. 可选链（Optional Chaining）
3. 空值合并（Nullish Coalescing
4. globalThis
5. 动态导入（Dynamic Imports
6. String.prototype.matchAll()
7. BigInt

需要注意的是并不是所有的浏览器都支持这些特性，如果想现在就开始使用这些特性，那么就要确保使用了合适的 polyfill 或者像 Babel 这样的编译器以确保代码与低版本浏览器兼容。

## 入门指南

如果你想使用自己的代码副本，请首先创建一个 Heroku 帐户并在计算机上安装 Heroku CLI。有关安装说明可以参阅 [Heroku guide](https://devcenter.heroku.com/articles/getting-started-with-nodejs#set-up) 指南。

完成以上操作后，就可以使用 CLI 轻松创建和部署项目了。运行此示例应用程序所需的所有源代码都[可以在 GitHub 上找到](https://github.com/thawkin3/unit-price-calculator)。

以下是有关如何克隆仓库并部署到 Heroku 的分步说明：

```bash
git clone https://github.com/thawkin3/unit-price-calculator.git
cd unit-price-calculator
heroku create
git push heroku master
heroku open
```

## 系统概述

单价计算器 app 非常简单：用户可以比较虚拟产品的各种价格和重量选项，然后计算单价。当页面加载时，通过请求两个 API 接口从服务器获取产品数据。然后，用户就可以选择产品、首选的计量单位和价格/重量的组合了，最后点击提交按钮完成单价计算。

![单价计算器 App](https://cdn-images-1.medium.com/max/2506/0*10AyqKCN-035dR-L.png)

现在你已经看到了这个 App，让我们了解一下我是如何使用 ES2020 中所有七个新特性的。下面我们将详细讨论每个特性是什么、它的用途以及使用方式。

## 1. Promise.allSettled()

当用户第一次访问单价计算器 app 时，会发送三个 API 请求来向服务器获取产品数据，这时可以使用`Promise.allSettled()`等待所有三个请求完成：

```JavaScript
const fetchProductsPromise = fetch('/api/products')
  .then(response => response.json())

const fetchPricesPromise = fetch('/api/prices')
  .then(response => response.json())

const fetchDescriptionsPromise = fetch('/api/descriptions')
  .then(response => response.json())

Promise.allSettled([fetchProductsPromise, fetchPricesPromise, fetchDescriptionsPromise])
  .then(data => {
    // 处理响应
  })
  .catch(err => {
    // 处理报错
  })
```

`Promise.allSettled()` 作为新特性之一拓展了现有的 `Promise.all()` 功能，以上两种方法都允许提供一个 promises 实例数组作为参数，并且都返回一个新的 promise 实例。

区别是， 如果 promises 实例数组中有一个被 rejected，那么`Promise.all()` 就会中断请求过程，而 `Promise.allSettled()` 会等待**所有** promises 请求完成， 无论它们是被 resolved 或者 rejected。

所以如果你想获得所有 promises 的解析结果，即使其中一些 promises 被 rejected，那么就可以使用 `Promise.allSettled()` 这个新特性。

让我们看一下使用 `Promise.all()` 的另外一个例子：

```JavaScript
// promises 1-3 都 resolved
const promise1 = new Promise((resolve, reject) => setTimeout(() => resolve('promise 1 resolved!'), 100))
const promise2 = new Promise((resolve, reject) => setTimeout(() => resolve('promise 2 resolved!'), 200))
const promise3 = new Promise((resolve, reject) => setTimeout(() => resolve('promise 3 resolved!'), 300))

// promise 4 和 6 将会 resolved，但是 promise 5 将被 rejected
const promise4 = new Promise((resolve, reject) => setTimeout(() => resolve('promise 4 resolved!'), 1100))
const promise5 = new Promise((resolve, reject) => setTimeout(() => reject('promise 5 rejected!'), 1200))
const promise6 = new Promise((resolve, reject) => setTimeout(() => resolve('promise 6 resolved!'), 1300))

// 没有 rejected 时 Promise.all() 的表现
Promise.all([promise1, promise2, promise3])
  .then(data => console.log('all resolved! here are the resolve values:', data))
  .catch(err => console.log('got rejected! reason:', err))
// 所有的请求都 resolved！这是 resolve 到的值：["promise 1 resolved!", "promise 2 resolved!", "promise 3 resolved!"]

// 有一个 rejected 时 Promise.all() 的表现
Promise.all([promise4, promise5, promise6])
  .then(data => console.log('all resolved! here are the resolve values:', data))
  .catch(err => console.log('got rejected! reason:', err))
// 输出：got rejected! reason: promise 5 rejected!
```

以下是使用 `Promise.allSettled()` 的实例，注意当 promise 被 rejected 之后二者的区别：

```JavaScript
// promises 1-3 都 resolved
const promise1 = new Promise((resolve, reject) => setTimeout(() => resolve('promise 1 resolved!'), 100))
const promise2 = new Promise((resolve, reject) => setTimeout(() => resolve('promise 2 resolved!'), 200))
const promise3 = new Promise((resolve, reject) => setTimeout(() => resolve('promise 3 resolved!'), 300))

// promise 4 和 6 将会resolved, 但是 promise 5 将被 rejected
const promise4 = new Promise((resolve, reject) => setTimeout(() => resolve('promise 4 resolved!'), 1100))
const promise5 = new Promise((resolve, reject) => setTimeout(() => reject('promise 5 rejected!'), 1200))
const promise6 = new Promise((resolve, reject) => setTimeout(() => resolve('promise 6 resolved!'), 1300))

// 没有 rejected 时的 Promise.allSettled() 的表现
Promise.allSettled([promise1, promise2, promise3])
  .then(data => console.log('all settled! here are the results:', data))
  .catch(err => console.log('oh no, error! reason:', err))
// 所有请求都完成了！这里是结果： [
//   { status: "fulfilled", value: "promise 1 resolved!" },
//   { status: "fulfilled", value: "promise 2 resolved!" },
//   { status: "fulfilled", value: "promise 3 resolved!" },
// ]

// 当有一个为 rejected 时 Promise.allSettled() 的表现
Promise.allSettled([promise4, promise5, promise6])
  .then(data => console.log('all settled! here are the results:', data))
  .catch(err => console.log('oh no, error! reason:', err))
// 所有请求都完成了！这里是结果： [
//   { status: "fulfilled", value: "promise 4 resolved!" },
//   { status: "rejected", reason: "promise 5 rejected!" },
//   { status: "fulfilled", value: "promise 6 resolved!" },
// ]
```

## 2. 可选链（Optional Chaining）

一旦数据请求完成，我们开始处理响应。从服务器返回的数据包含一个具有深层嵌套属性的对象数组，为了安全访问这些属性，我们可以使用新发布的可选链操作符：

```JavaScript
if (data?.[0]?.status === 'fulfilled' && data?.[1]?.status === 'fulfilled') {
  const products = data[0].value?.products
  const prices = data[1].value?.prices
  const descriptions = data[2].value?.descriptions
  populateProductDropdown(products, descriptions)
  saveDataToAppState(products, prices, descriptions)
  return
}
```

可选链是在 ES2020 中最让我激动的特性，可选链操作符 `?.` 支持安全地访问对象的深层嵌套属性，而无需检查每个属性是否存在。

例如，在 ES2020 之前，为了访问 `user` 对象的 `street` 属性，可能需要写下面这样的代码：

```JavaScript
const user = {
  firstName: 'John',
  lastName: 'Doe',
  address: {
    street: '123 Anywhere Lane',
    city: 'Some Town',
    state: 'NY',
    zip: 12345,
  },
}

const street = user && user.address && user.address.street
// '123 Anywhere Lane'

const badProp = user && user.fakeProp && user.fakePropChild
// undefined
```

为了安全地访问 `street` 属性，必须首先确保 `user` 对象和 `address` 属性的存在，然后才能尝试去访问 `street` 属性。

借助可选链，访问嵌套属性的代码简洁了许多：

```JavaScript
const user = {
  firstName: 'John',
  lastName: 'Doe',
  address: {
    street: '123 Anywhere Lane',
    city: 'Some Town',
    state: 'NY',
    zip: 12345,
  },
}

const street = user?.address?.street
// '123 Anywhere Lane'

const badProp = user?.fakeProp?.fakePropChild
// undefined
```

如果在可选链上的值都不存在，则会返回 `undefined`。否则，返回访问的属性值。

## 3. 空值合并（Nullish Coalescing）

当 app 加载时，还需要获取用户对测量单位的偏好设置：千克或磅。但是首选项保存在本地存储中，对于首次访问 app 的用户来说首选项还不存在。可以利用空值合并运算符来解决是使用本地存储中的值还是使用默认值千克的问题：

```JavaScript
appState.doesPreferKilograms = JSON.parse(doesPreferKilograms ?? 'true')
```

当你想要获取一个非 `undefined` 或者 `null` 的变量值时，空值合并运算符 `??` 十分方便。如果指定的变量是一个布尔值，你想要使用它的值，即使它的值为 `false` ，就需要使用 `??` 操作符来替代 `||`。

例如，假设要开发某些功能设置的切换，如果用户专门为该功能设置了一个值，则需要首先考虑他们的选择，而如果用户没有指定相关值，你希望通过设置默认值来为用户帐户启用该功能。

在 ES2020 发布之前，你可能需要这样写：

```JavaScript
const useCoolFeature1 = true
const useCoolFeature2 = false
const useCoolFeature3 = undefined
const useCoolFeature4 = null

const getUserFeaturePreference = (featurePreference) => {
  if (featurePreference || featurePreference === false) {
    return featurePreference
  }
  return true
}

getUserFeaturePreference(useCoolFeature1) // true
getUserFeaturePreference(useCoolFeature2) // false
getUserFeaturePreference(useCoolFeature3) // true
getUserFeaturePreference(useCoolFeature4) // true
```

通过使用空值合并操作符，代码会变得更加简洁且易懂：

```JavaScript
const useCoolFeature1 = true
const useCoolFeature2 = false
const useCoolFeature3 = undefined
const useCoolFeature4 = null

const getUserFeaturePreference = (featurePreference) => {
  return featurePreference ?? true
}

getUserFeaturePreference(useCoolFeature1) // true
getUserFeaturePreference(useCoolFeature2) // false
getUserFeaturePreference(useCoolFeature3) // true
getUserFeaturePreference(useCoolFeature4) // true
```

## 4. globalThis

如上所述，使用本地存储来获取和设置用户对测量单位的偏好。对于浏览器来说，本地存储对象是 `window` 对象的一个属性，可以直接调用 `localStorage` 访问一个 Storage 对象，也可以调用 `window.localStorage`。在 ES2020 中，还可以通过 `globalThis` 对象来访问本地存储（注意：还需要使用可选链进行一些功能检测，以确保浏览器支持本地存储功能）：

```JavaScript
const doesPreferKilograms = globalThis.localStorage?.getItem?.('prefersKg')
```

`globalThis` 特性非常简单，但它解决了一些你可能会踩坑的问题。简单来说，`globalThis` 包含对全局对象的引用，在浏览器中，全局对象就是 `window`，而在 Node 环境中，全局对象即字面上的 `global`。使用 `globalThis` 可以确保无论代码运行在什么环境中，始终对全局对象具有有效的引用。这样你就可以编写可移植的 JavaScript 模块，无论是在浏览器的主线程、 Web Worker 或 Node 环境，这些 JS 模块都可以正确运行。

## 5. 动态导入（Dynamic Imports）

当用户选择了产品、计量单位、重量和价格组合之后，就可以单击提交按钮来查询单价信息。当按钮被点击之后，懒加载用于计算单价的 JavaScript 模块。在浏览器开发工具中检查网络请求，可以发现在点击按钮之前不会加载第二个文件：

```JavaScript
import('./calculate.js')
  .then(module => {
    // 使用模块导出的方法
  })
  .catch(err => {
    // 处理加载模块的错误或其他后续错误
  })
```

ES2020 发布之前，在 JavaScript 中使用 `import` 语句意味着请求父文件时导入的文件将自动包含在父文件中。

像 [webpack](https://webpack.js.org/) 这样的模块打包器使得“代码分离”的概念流行起来，即能够将 JavaScript 包拆分为多个可以按需加载的文件的功能，React 中通过 `React.lazy()` 方法实现了此功能。

代码拆分对于单页应用程序（SPA）非常有用，可以在每个页面把代码分离到不同的包中，因此只需要下载当前视图所需的代码，显著加速了首屏加载时间，这样终端用户就不必提前下载整个应用程序。

代码拆分对于大部分特定环境下才需使用的代码很有帮助。比如应用程序页面上有一个“导出 PDF”的按钮，PDF 文件下载功能的代码比较大，当所需页面加载时再包含这部分代码可以减少总体加载时间。但是并非每个访问此页面的用户都需要或希望导出 PDF 文件，为了提高性能，可以懒加载 PDF 下载代码，以便只有当用户单击“导出 PDF”按钮时，才下载附加的 JavaScript 包。

在 ES2020 中，JavaScript 规范直接加入了动态导入！

让我们看一个没有动态导入的“导出 PDF”功能的示例：

```JavaScript
import { exportPdf } from './pdf-download.js'

const exportPdfButton = document.querySelector('.exportPdfButton')
exportPdfButton.addEventListener('click', exportPdf)

// 这段代码很短，但“pdf-download.js”模块是在页面加载时加载的，而不是在单击按钮时加载
```

现在让我们看看如何使用动态导入懒加载大体量的 PDF 下载模块：

```JavaScript
const exportPdfButton = document.querySelector('.exportPdfButton')

exportPdfButton.addEventListener('click', () => {
  import('./pdf-download.js')
    .then(module => {
      // 在模块中调用一些导出的方法
      module.exportPdf()
    })
    .catch(err => {
      // 模块无法加载时处理错误
    })
})

// “pdf-download.js”模块仅在用户单击“导出 PDF”按钮时导入
```

## 6. String.prototype.matchAll()

调用 `calculateUnitPrice` 方法时传入产品名称和价格/重量组合参数，价格/重量组合是一个类似“\$200 for 10 kg”的字符串，我们需要解析字符串得到价格、重量和度量单位。（当然有更好的方法来设计这个应用程序，以避免像上面这样解析字符串，这是为了演示下一个特性而设置的。）我们可以使用 `String.prototype.matchAll()` 来提取必要的数据：

```JavaScript
const matchResults = [...weightAndPrice.matchAll(/\d+|lb|kg/g)]
```

这一行代码包含了很多内容：基于正则表达式来查找字符串中的数字和字符串匹配项“lb”或“kg”。它返回一个可以拓展到数组中的迭代器，这个数组最终包括三个分别相匹配的元素（200、10 和“kg”）。

这个特性可能是所有新特性中最难理解的一个，尤其是如果你对正则表达式不是很熟悉的话。 `String.prototype.matchAll()` 可以简短解释为是对 `String.prototype.match()` 和 `RegExp.prototype.exec()` 功能的改进。这个新方法允许你将字符串与正则表达式进行匹配，并返回所有匹配结果的迭代器，包括捕获组。

明白以上的基本概念了吗？让我们看看另一个有助于巩固这一概念的例子：

```JavaScript
const regexp = /t(e)(st(\d?))/
const regexpWithGlobalFlag = /t(e)(st(\d?))/g
const str = 'test1test2'

// 使用 `RegExp.prototype.exec()`
const matchFromExec = regexp.exec(str)
console.log(matchFromExec)
// ["test1", "e", "st1", "1", index: 0, input: "test1test2", groups: undefined]

// 对**不带**全局标志的正则表达式使用 `String.prototype.match()` 将返回捕获组
const matchFromMatch = str.match(regexp)
console.log(matchFromMatch)
// ["test1", "e", "st1", "1", index: 0, input: "test1test2", groups: undefined]

// 对具有全局标志的正则表达式使用 `String.prototype.matchAll()` 不会返回捕获组 :(
const matchesFromMatchWithGlobalFlag = str.match(regexpWithGlobalFlag)
for (const match of matchesFromMatchWithGlobalFlag) {
  console.log(match)
}
// test1
// test2

// 正确使用 `String.prototype.matchAll()` 可以返回使用全局标志时的捕获组  :)
const matchesFromMatchAll = str.matchAll(regexpWithGlobalFlag)
for (const match of matchesFromMatchAll) {
  console.log(match)
}
// ["test1", "e", "st1", "1", index: 0, input: "test1test2", groups: undefined]
// ["test2", "e", "st2", "2", index: 5, input: "test1test2", groups: undefined]

```

## 7. BigInt

最后，当使用普通数字时，可以简单地用重量除以价格来计算单价。但是当需要使用大数时，ES2020 引入了 `BigInt` 以在不损失精度的情况下对大整数进行计算。在我们的应用程序中，使用 `BigInt` 比较过犹不及，但是谁知道会不会出现 API 接口改变的情况，包括一些疯狂的批量交易呢！

```JavaScript
const price = BigInt(matchResults[0][0])
const priceInPennies = BigInt(matchResults[0][0] * 100)
const weight = BigInt(matchResults[1][0])
const unit = matchResults[2][0]

const unitPriceInPennies = Number(priceInPennies / weight)
const unitPriceInDollars = unitPriceInPennies / 100
const unitPriceFormatted = unitPriceInDollars.toFixed(2)
```

如果你曾经处理过包含大数的数据，那么就知道在执行 JavaScript 数学操作时确保数字数据的完整性是多么痛苦。在 ES2020 发布前可以安全存储的最大整数是`Number.MAX_SAFE_INTEGER`，即 2^53-1。

如果试图在变量中存储大于该值的数字，则有时该数字将无法正确存储：

```JavaScript
const biggestNumber = Number.MAX_SAFE_INTEGER // 9007199254740991

const incorrectLargerNumber = biggestNumber + 10
// 应该是： 9007199254741001
// 实际存储为： 9007199254741000
```

新的 `BigInt` 数据类型有助于解决此问题，还能够处理更大的整数。只需对整数调用 `BigInt()` 函数或者将字母 `n` 附加到整数的末尾，就可以将整数设为 `BigInt`数据类型：

```JavaScript
const biggestNumber = BigInt(Number.MAX_SAFE_INTEGER) // 9007199254740991n

const correctLargerNumber = biggestNumber + 10n
// 应该是： 9007199254741001n
// 实际存储为： 9007199254741001n
```

## 总结

如上所述！既然你已经了解了 ES2020 的所有新特性，那还等什么呢？马上开始写新的 JavaScript 项目吧！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
