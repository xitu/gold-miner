> * 原文地址：[ES2020 Optional Chaining and Dynamic Imports Are Game-Changers. Here’s Why.](https://blog.bitsrc.io/es2020-optional-chaining-and-dynamic-imports-are-game-changers-heres-why-cbbf7efae3ee)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/es2020-optional-chaining-and-dynamic-imports-are-game-changers-heres-why.md](https://github.com/xitu/gold-miner/blob/master/article/2020/es2020-optional-chaining-and-dynamic-imports-are-game-changers-heres-why.md)
> * 译者：[JohnieXu](https://github.com/JohnieXu)、[jaredliw](https://github.com/jaredliw)
> * 校对者：[ghost](https://github.com/ghost)、[wuyanan](https://github.com/wuyanan)、[Yang Mao](https://github.com/leo-mao)

# 为什么说 ES2020 的可选链和模块动态导入特性改变了已有的生态规则？

![图由 [veeterzy](https://unsplash.com/@veeterzy?utm_source=medium&utm_medium=referral) 发布于 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11520/0*kgic-88vVUjDQbYC)

自从 2015 年发布 ES6 语法规范以来，JavaScript 又进行了几次升级。之后，大量的语法特性提案也被纳入到 ES2020 语法规范中。其中有不少值得一提的新特性，我在此文将重点介绍可选链（Optional Chaining）和模块动态导入（Dynamic Imports）这两个特性。如果能在以前的项目中使用上这两大特性，代码量将会大大缩减。

下面我们一起来看一看这两大特性。

## 可选链

借助可选链特性我们可以通过 ?. 操作符在访问对象嵌套的属性而不需要校验这些属性是否存在。`?.` 操作符与传统的 `.` 操作符十分相似，但是在操作符前面的值为 `undefined` 或 `null` 时该语法不会导致程序报错，并且其获取到的属性值为 `undefined`。

使用可选链特性可以使代码变得更简洁的同时确保在访问对象中不确定是否存在的属性时不会报错。

#### 语法

参考官方文档，可选链的语法包含以下几种，分别为：访问对象属性、访问数组元素及函数调用。

```js
obj.val?.prop
obj.val?.[expr]
obj.arr?.[index]
obj.func?.(args)
```

#### 用法示例

如上文所述，可选链的语法分为访问对象属性、访问数组元素和函数调用这 3 类。下面一起看下他们的用法示例。

**通过属性访问对象值**

```js
let book = {
  name: "Harry Potter 1",
  price: {
    value: 50,
    currency: "EUR"
  },
  ISBN: "978-7-7058-9615-2"
};

console.log(book.price.value);
// 50

console.log(book.weight);
// undefined

console.log(book.weight.value);
// 报错

// 使用可选链
console.log(book?.weight?.value);
// undefined
```

**通过表达式访问对象值**

```js
let book = {
  name: "Harry Potter 1",
  price: {
    value: 50,
    currency: "EUR"
  },
  ISBN: "978-7-7058-9615-2"
};

let userInputProperty = document.getElementById('inputProperty').value;
let userInputNestedProperty = document.getElementById('inputPropertyNested').value;

console.log(book[userInputProperty][userInputNestedProperty]);
// 如果用户在 input 上输入的属性在对象上不存在，JavaScript 将会报错

// 使用可选链
console.log(book?.[userInputProperty]?.[userInputNestedProperty]);
// 如果用户在 input 上输入的属性在对象上不存在，将返回 undefined
// 否则返回属性对应的值
```

**数组元素访问**

```js
let books = [{
    name: "Harry Potter 1",
    price: {
      value: 50,
      currency: "EUR"
    },
    ISBN: "978-7-7058-9615-2"
  },
  {
    name: "Harry Potter 2",
    price: {
      value: 60,
      currency: "EUR"
    },
    ISBN: "978-3-2560-1878-4"
  }
];

console.log(books[1].price.value);
// 50

console.log(books[2].price.value);
// 报错

console.log(books?.[2]?.price?.value);
// undefined
```

**函数访问**

```js
let bookModule = {
  getBooks: function() {
    console.log("Books returned");
    return true;
  }
};


bookModule.getBooks();
// "Books returned"

bookModule.getBook();
// 报错

bookModule?.getBook?.();
// undefined
```

#### 注意事项

可选链只在赋值表达式的右侧生效。

```js
let book = {
  name: "Harry Potter 1",
  price: {
    value: 50,
    currency: "EUR"
  },
  ISBN: "978-7-7058-9615-2"
};

book?.weight?.value = 650;
// 语法错误

book.weight.value = 650;
// 报错：TypeError

book.weight = {
  value: 650
};
// 正常
```

#### 使用可选链前后对比

在引入可选链特性之前，通常需要对每一层级的属性值是否存在做校验以避免报错。这会导致随着嵌套层级的增加，需要校验的属性值也随之增加。这就意味着要避免出现获取 `undefined` 或 `null` 的属性值导致程序崩溃，你需要对每一层级的属性值获取都进行校验。

下面看一下示例。

```JavaScript
let book = {
  name: "Harry Potter 1",
  price: {
    value: 50,
    currency: "EUR"
  },
  ISBN: "978-7-7058-9615-2",
  weight: {
    version1: {
      value: 550,
      unit: 'g'
    },
    version2: {
      value: 690,
      unit: 'g'
    }
  }
}

if (book && book.weight && book.weight.version2 && book.weight.version2.value) {
  // 操作 book.weight.version2.value
  console.log(book.weight.version2.value);
}

if (book && book.weight && book.weight.version3 && book.weight.version3.value) {
  // 由于 book.weight 上没有属性 version3，所以以下代码块将不会执行，同时还会报错
  console.log(book.weight.version3.value);
}

// 直接访问 book.weight.version3 属性，不做校验
console.log(book.weight.version3.value);
// 报错
```

下面是使用可选链的示例，用更少的代码实现了同样的功能。

```JavaScript
let book = {
  name: "Harry Potter 1",
  price: {
    value: 50,
    currency: "EUR"
  },
  ISBN: "978-7-7058-9615-2",
  weight: {
    version1: {
      value: 550,
      unit: 'g'
    },
    version2: {
      value: 690,
      unit: 'g'
    }
  }
}

// 操作 book.weight.version2.value
console.log(book?.weight?.version2?.value);
// 690

console.log(book?.weight?.version3?.value);
// undefined
```

即使 `book.weight` 上不存在 `version3` 这个属性，并且我们也没有显式的校验 `book.weight.version3` 是否是 `null` 或 `undefined`，但是上述代码还是正常执行没有报错，这是主要是因为可选链在访问属性之前会校验是否是 `undefined` 或 `null`。

#### 浏览器兼容性

![源自：[CanIUse](https://caniuse.com/mdn-javascript_operators_optional_chaining)](https://cdn-images-1.medium.com/max/2462/1*Mk1AKifhJ1TbIjmcnjndBg.png)

## 动态导入

动态导入使得应用可以以原生的方式（译者注：之前的动态导入都是由打包工具，如 webpack 在本地编译打包的方式实现的）把 .js 文件作为模块动态地进行导入。在 ES2020 之前，模块无论是否被使用到了都会被导入进来。这一特性，将极大的提升网页应用的性能。

#### 为何需要动态导入

之前的模块导入是基于静态声明的，而 `import` 语句只能放置在文件的顶部。并且，`import` 要求传入的模块描述符必须是字符串字面量，不能包含变量。这些限制使得现在的动态导入访问远比静态声明的模块导入方案灵活。

但是静态模块导入也有其优点，比如它支持模块静态分析、打包构建工具、Tree-Shaking 优化等。

不过静态模块导入语法不支持以下特性：

* 模块按需导入；
* 在模块描述符中使用变量，具体值在运行时才确定；
* 使用 `script` 标签导入模块。

使用动态导入特性就能解决上述几个问题。

接下来看一下使用模块动态导入特性后对项目有何改变。

#### 使用模块动态导入前后对比

假设我们的应用有一个导出为 XML 或 CSV 格式文档的功能，团队对实现这两种格式导出功能分别开发了一个模块。按之前的导入方式，模块代码量会很大并且导致页面加载缓慢。

**静态模块导入**

```JavaScript
import { exportAsCSV } from './export-as-csv.js';
import { exportAsXML } from './export-as-xml.js';

const dataBlock = getData();

const exportCSVButton = document.querySelector('.exportCSVBtn');
const exportXMLButton = document.querySelector('.exportXMLBtn');
exportCSVButton.addEventListener('click', () => { exportAsCSV(dataBlock) });
exportXMLButton.addEventListener('click', () => { exportAsXML(dataBlock) });
```

可以看到，`exportAsCSV` 和 `exportAsXML` 模块不管有没有被实际用到都会先导入到应用中。实际上，并非所有用户都会用到这些功能，这会给浏览器增加不必要的负担。

这种额外的负担可以通过模块的推迟加载来避免，目前已经可以借助 webpack 等模块打包器的**代码分割**功能的来实现。

但是在 ES2020 标准规范中，已经原生支持这一特性，就不需要使用模块打包器的代码分割功能了。

**动态模块导入**

```JavaScript
const dataBlock = getData();

const exportCSVButton = document.querySelector('.exportCSVBtn');
const exportXMLButton = document.querySelector('.exportXMLBtn');

exportCSVButton.addEventListener('click', () => {
    import('./export-as-csv.js')
        .then(module => {
            module.exportAsCSV(dataBlock);
        })
        .catch(err => {
            // 处理模块加载失败的错误
        })
});

exportXMLButton.addEventListener('click', () => {
    import('./export-as-xml.js')
        .then(module => {
            module.exportAsXML(dataBlock);
        })
        .catch(err => {
            // 处理模块加载失败的错误
        })
});
```

上面代码中，使用动态导入语法实现了两个模块的动态导入。只有在对应模块对使用到时，其模块代码才会被加载，这样就减少了页面加载资源的大小并缩短了页面加载时间。

#### 浏览器兼容性

![源自：[CanIUse](https://caniuse.com/mdn-javascript_statements_import_dynamic_import)](https://cdn-images-1.medium.com/max/2450/1*0qzbT_iYuZnNDlQz0sx0dQ.png)

以上两个备受期待的特性能极大地帮助你在不牺牲整体性能的情况下编写更简洁、干净的代码。如果有任何建议和看法，欢迎到评论区留言。

#### 参考文章

- [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Optional_chaining)
- [ES2020 Proposal](https://github.com/tc39)
- [V8 Docs](https://v8.dev/features/dynamic-import)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
