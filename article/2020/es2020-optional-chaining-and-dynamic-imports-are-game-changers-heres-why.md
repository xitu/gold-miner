> * 原文地址：[ES2020 Optional Chaining and Dynamic Imports Are Game-Changers. Here’s Why.](https://blog.bitsrc.io/es2020-optional-chaining-and-dynamic-imports-are-game-changers-heres-why-cbbf7efae3ee)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/es2020-optional-chaining-and-dynamic-imports-are-game-changers-heres-why.md](https://github.com/xitu/gold-miner/blob/master/article/2020/es2020-optional-chaining-and-dynamic-imports-are-game-changers-heres-why.md)
> * 译者：
> * 校对者：

# ES2020 Optional Chaining and Dynamic Imports Are Game-Changers. Here’s Why.

![Photo by [veeterzy](https://unsplash.com/@veeterzy?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11520/0*kgic-88vVUjDQbYC)

After the release of ES6 in 2015, JavaScript got a few handy upgrades. At the present, a lot of new features were being proposed to be included in the ES2020 version. There are several notable features in the new release and I would love to highlight two of them in this article — Optional Chaining and Dynamic Imports. These two features would have saved me several lines of code and performance if I had used them earlier in my work.

Let’s have a look at these awesome two features.

## Optional Chaining

Optional Chaining is simply a feature that allows you to safely access deeply nested properties of an object without having to check for the existence of each of them. Optional Chaining uses the `?.` operator to access the properties of objects. The usage of the `?.` operator is very similar to the typical `.` operator, but when a reference is `undefined` or `null`, rather than throwing an error, it would return `undefined`.

This results in a simpler and cleaner code that guarantees no error will be thrown when exploring objects with uncertain properties.

#### Syntax

As per the documentation, there are several syntaxes for optional chaining. These include usages for accessing objects, arrays, and functions.

```js
obj.val?.prop
obj.val?.[expr]
obj.arr?.[index]
obj.func?.(args)
```

#### Usage Examples for the Above

As I have mentioned above, there are 4 possible syntaxes for optional chaining which can be categorized under object access, array access, and function access. Let’s have a look at examples for all of them.

**Object Value Access via Property**

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
//50

console.log(book.weight);
//undefined

console.log(book.weight.value);
//error

//With Optional Chaining
console.log(book?.weight?.value);
//undefined
```

**Object Value Access via Expression**

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
//if user input not present as a property, then error is thrown


//Using Optional Chaining
console.log(book?.[userInputProperty]?.[userInputNestedProperty]);
//if user input not present as property, then return undefined
//else value is returned
```

**Array Element Access**

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
//50

console.log(books[2].price.value);
//error

console.log(books?.[2]?.price?.value);
//undefined
```

**Function Access**

```js
let bookModule = {
  getBooks: function() {
    console.log("Books returned");
    return true;
  }
};


bookModule.getBooks();
//"Books returned"

bookModule.getBook();
//error

bookModule?.getBook?.();
//undefined
```

#### Note of Caution

Optional chaining is only valid on the right side of an assignment.

```
let book = {
  name: "Harry Potter 1",
  price: {
    value: 50,
    currency: "EUR"
  },
  ISBN: "978-7-7058-9615-2"
};

book?.weight?.value = 650;
//Syntax error

book.weight.value = 650;
//Type error

book.weight = {
  value: 650
};
//No error
```

#### Optional Chaining — Before and After

Before the introduction of optional chaining, you have to check whether the property exists at each level to avoid facing an error. As the level of nesting increases, the number of properties you have manually check increases as well. This means that we have to check every level to make sure that it won’t crash when it runs into a `undefined` or `null` object.

Let’s look at an example.

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
  //Do something with book.weight.version2.value
  console.log(book.weight.version2.value);
}

if (book && book.weight && book.weight.version3 && book.weight.version3.value) {
  //Since there is no version 3, this block would not run and throw any errors
  console.log(book.weight.version3.value);
}

//Accessing without checking
console.log(book.weight.version3.value);
//error
```

With optional chaining, the exact outcome can be obtained in fewer lines of code

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

//Do something with book.weight.version2.value
console.log(book?.weight?.version2?.value);
//690


console.log(book?.weight?.version3?.value);
//undefined
```

Although version 3 does not exist in the book object and we do not explicitly check for `null` or `undefined` values, the above code does not throw an error trying to access an `undefined` property. Optional chaining confirms the value is not `undefined` or `null` before accessing the property nested within.

#### Browser Compatibility

![Source: [CanIUse](https://caniuse.com/mdn-javascript_operators_optional_chaining)](https://cdn-images-1.medium.com/max/2462/1*Mk1AKifhJ1TbIjmcnjndBg.png)

## Dynamic Imports

Dynamic Imports allow you to import JS files dynamically as modules in your application natively. Prior to ES2020, your module should be imported whether the module is used or not. This is a feature that would immensely help improve the performance of your website.

#### Why Do We Need Dynamic Imports

Importing modules earlier were based on static declaration. The static import syntax can only be used in the top level of a file. Furthermore, it requires the module specifier to be passed as a string literal with no variables. This makes the previous less flexible than dynamic imports.

But static imports do have their own advantages. They enable use-cases such as static analysis, bundling tools, and tree-shaking.

Yet the static import syntax does not allow

* modules to be imported on-demand or conditionally
* use variables in the module specifier to decide the value of it in run time
* importing a module from a regular script

The introduction of dynamic imports solved the above-mentioned issues.

Let’s have a look at how dynamic imports can affect our code.

#### Dynamic Imports — Before and After

Let’s assume that our application needs to export documents in either XML or CSV format. Our team of developers has come up with two modules that can achieve this. On the downside, these modules are heavy and would result in a slower page load.

**Before**

```JavaScript
import { exportAsCSV } from './export-as-csv.js';
import { exportAsXML } from './export-as-xml.js';

const dataBlock = getData();

const exportCSVButton = document.querySelector('.exportCSVBtn');
const exportXMLButton = document.querySelector('.exportXMLBtn');
exportCSVButton.addEventListener('click', () => { exportAsCSV(dataBlock) });
exportXMLButton.addEventListener('click', () => { exportAsXML(dataBlock) });
```

As you can see above, the modules are imported regardless of whether they are needed or not. In reality, not all of the users would require to use these functions and this would create an unnecessary load on the browser.

This overhead can be reduced by using lazy loaded modules. This can be achieved with something called **code-splitting** which is already available with the overhead of webpack or other module bundlers.

But with ES2020 we have a native way of doing it, without the need for module bundlers.

**After**

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
            // handle the error if the module fails to load
        })
});

exportXMLButton.addEventListener('click', () => {
    import('./export-as-xml.js')
        .then(module => {
            module.exportAsXML(dataBlock);
        })
        .catch(err => {
            // handle the error if the module fails to load
        })
});
```

The above code, imports the modules dynamically as per the need, with the help of dynamic imports. You can now lazy load your modules only when they are needed. Thereby reducing overhead and decreasing page load times.

#### Browser Compatibility

![Source: [CanIUse](https://caniuse.com/mdn-javascript_statements_import_dynamic_import)](https://cdn-images-1.medium.com/max/2450/1*0qzbT_iYuZnNDlQz0sx0dQ.png)

The above two highly anticipated features immensely help you write easier and cleaner code without sacrificing overall performance. Let me know your thoughts in the comments.

#### Resources

- [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Optional_chaining)
- [ES2020 Proposal](https://github.com/tc39)
- [V8 Docs](https://v8.dev/features/dynamic-import)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
