> * 原文地址：[I Built an App That Uses All 7 New Features in JavaScript ES2020](https://levelup.gitconnected.com/i-built-an-app-that-uses-all-7-new-features-in-javascript-es2020-647205024984)
> * 原文作者：[Tyler Hawkins](https://medium.com/@thawkin3)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/i-built-an-app-that-uses-all-7-new-features-in-javascript-es2020.md](https://github.com/xitu/gold-miner/blob/master/TODO1/i-built-an-app-that-uses-all-7-new-features-in-javascript-es2020.md)
> * 译者：
> * 校对者：

# I Built an App That Uses All 7 New Features in JavaScript ES2020

![Unit Price Calculator App](https://cdn-images-1.medium.com/max/2506/0*10AyqKCN-035dR-L.png)

The world of web development moves fast, especially in the JavaScript ecosystem. New features, frameworks, and libraries are constantly emerging, and the minute you stop learning is the minute your skill set starts to become obsolete.

One important part of keeping your JavaScript skills sharp is staying current on the latest features in JavaScript. So, I thought it would be fun to build an app that incorporates all seven of the new features in JavaScript ES2020.

---

I recently did a bit of bulk shopping at Costco to stock up on some food essentials. Like most stores, their price tags display the unit price for each item, so you can assess and compare the quality of each deal. Do you go with the small bag or the large bag? (Who am I kidding? It’s Costco. Go large!)

But what if the unit price wasn’t displayed?

In this article, I’ll build a unit price calculator app using vanilla JavaScript for the front end and [Node.js](https://nodejs.org/en/) with [Express.js](https://expressjs.com/) for the back end. I’ll deploy the app on [Heroku](http://heroku.com/), which is an easy place to [quickly deploy a node.js app](https://devcenter.heroku.com/articles/getting-started-with-nodejs).

## What’s New in JavaScript ES2020?

The JavaScript programming language conforms to a specification known as ECMAScript. Starting with the release of ES2015 (or ES6), a new version of JavaScript has been released each year. As of right now, the latest version is ES2020 (ES11). ES2020 is packed with seven exciting new features that JavaScript developers have been waiting for quite some time to see. The new features are:

1. Promise.allSettled()
2. Optional Chaining
3. Nullish Coalescing
4. globalThis
5. Dynamic Imports
6. String.prototype.matchAll()
7. BigInt

You should note that not all browsers support these features — yet. If you want to start using these features now, make sure you provide appropriate polyfills or use a transpiler like Babel to ensure your code is compatible with older browsers.

## Getting Started

If you want to follow along with your own copy of the code, first create a Heroku account and install the Heroku CLI on your machine. See this [Heroku guide](https://devcenter.heroku.com/articles/getting-started-with-nodejs#set-up) for installation instructions.

Once you’ve done that, you can create and deploy the project easily using the CLI. All of the source code needed to run this example app [is available on GitHub](https://github.com/thawkin3/unit-price-calculator).

Below are step-by-step instructions on how to clone the repo and deploy to Heroku:

```bash
git clone https://github.com/thawkin3/unit-price-calculator.git
cd unit-price-calculator
heroku create
git push heroku master
heroku open
```

## System Overview

My unit price calculator app is fairly simple: it lets you compare various price and weight options for fictional products and then calculates the unit price. When the page loads, it fetches product data from the server by hitting two API endpoints. You can then choose your product, your preferred unit of measurement, and a price/weight combination. The unit price calculation is done once you hit the submit button.

![Unit Price Calculator App](https://cdn-images-1.medium.com/max/2506/0*10AyqKCN-035dR-L.png)

Now that you’ve seen the app, let’s take a look at how I used all seven of those ES2020 features. For each feature, I’ll discuss exactly what it is, how it’s useful, and how I used it.

## 1. Promise.allSettled()

When a user first visits the calculator app, three API requests are kicked off to fetch product data from the server. We wait for all three requests to finish by using `Promise.allSettled()`:

```JavaScript
const fetchProductsPromise = fetch('/api/products')
  .then(response => response.json())

const fetchPricesPromise = fetch('/api/prices')
  .then(response => response.json())

const fetchDescriptionsPromise = fetch('/api/descriptions')
  .then(response => response.json())

Promise.allSettled([fetchProductsPromise, fetchPricesPromise, fetchDescriptionsPromise])
  .then(data => {
    // handle the response
  })
  .catch(err => {
    // handle any errors
  })
```

`Promise.allSettled()` is a new feature that improves upon the existing `Promise.all()` functionality. Both of these methods allow you to provide an array of promises as an argument, and both methods return a promise.

The difference is that `Promise.all()` will short-circuit and reject itself early if any of the promises are rejected. On the other hand, `Promise.allSettled()` waits for **all** of the promises to be settled, regardless of whether they are resolved or rejected, and then resolves itself.

So if you want the results from all your promises, even if some of the promises are rejected, then start using `Promise.allSettled()`.

Let’s look at another example with `Promise.all()`:

```JavaScript
const fetchProductsPromise = fetch('/api/products')
  .then(response => response.json())

const fetchPricesPromise = fetch('/api/prices')
  .then(response => response.json())

const fetchDescriptionsPromise = fetch('/api/descriptions')
  .then(response => response.json())

Promise.allSettled([fetchProductsPromise, fetchPricesPromise, fetchDescriptionsPromise])
  .then(data => {
    // handle the response
  })
  .catch(err => {
    // handle any errors
  })
```

And now let’s look at another example with `Promise.allSettled()` to note the difference in behavior when a promise gets rejected:

```JavaScript
// promises 1-3 all will be resolved
const promise1 = new Promise((resolve, reject) => setTimeout(() => resolve('promise 1 resolved!'), 100))
const promise2 = new Promise((resolve, reject) => setTimeout(() => resolve('promise 2 resolved!'), 200))
const promise3 = new Promise((resolve, reject) => setTimeout(() => resolve('promise 3 resolved!'), 300))

// promise 4 and 6 will be resolved, but promise 5 will be rejected
const promise4 = new Promise((resolve, reject) => setTimeout(() => resolve('promise 4 resolved!'), 1100))
const promise5 = new Promise((resolve, reject) => setTimeout(() => reject('promise 5 rejected!'), 1200))
const promise6 = new Promise((resolve, reject) => setTimeout(() => resolve('promise 6 resolved!'), 1300))

// Promise.allSettled() with no rejections
Promise.allSettled([promise1, promise2, promise3])
  .then(data => console.log('all settled! here are the results:', data))
  .catch(err => console.log('oh no, error! reason:', err))
// all settled! here are the results: [
//   { status: "fulfilled", value: "promise 1 resolved!" },
//   { status: "fulfilled", value: "promise 2 resolved!" },
//   { status: "fulfilled", value: "promise 3 resolved!" },
// ]

// Promise.allSettled() with a rejection
Promise.allSettled([promise4, promise5, promise6])
  .then(data => console.log('all settled! here are the results:', data))
  .catch(err => console.log('oh no, error! reason:', err))
// all settled! here are the results: [
//   { status: "fulfilled", value: "promise 4 resolved!" },
//   { status: "rejected", reason: "promise 5 rejected!" },
//   { status: "fulfilled", value: "promise 6 resolved!" },
// ]
```

## 2. Optional Chaining

Once the product data is fetched, we handle the response. The data coming back from the server contains an array of objects with deeply-nested properties. In order to safely access those properties, we use the new optional chaining operator:

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

Optional chaining is the feature I’m most excited about in ES2020. The optional chaining operator — `?.` — allows you to safely access deeply-nested properties of an object without checking for the existence of each property.

For example, prior to ES2020, you might write code that looks like this in order to access the `street` property of some `user` object:

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

In order to safely access the `street` property, you first must make sure that the `user` object exists and that the `address` property exists, and then you can try to access the `street` property.

With optional chaining, the code to access the nested property is much shorter:

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

If at any point in your chain a value does not exist, `undefined` will be returned. Otherwise, the return value will be the value of the property you wanted to access, as expected.

## 3. Nullish Coalescing

When the app loads, we also fetch the user’s preference for their unit of measurement: kilograms or pounds. The preference is stored in local storage, so the preference won’t yet exist for first-time visitors. To handle either using the value from local storage or defaulting to using kilograms, we use the nullish coalescing operator:

```JavaScript
appState.doesPreferKilograms = JSON.parse(doesPreferKilograms ?? 'true')
```

The nullish coalescing operator — `??` — is a handy operator for when you specifically want to use a variable's value as long as it is not `undefined` or `null`. You should use this operator rather than a simple OR — `||`— operator if the specified variable is a boolean and you want to use its value even when it's `false`.

For example, say you have a toggle for some feature setting. If the user has specifically set a value for that feature setting, then you want to respect his or her choice. If they haven’t specified a setting, then you want to default to enabling that feature for their account.

Prior to ES2020, you might write something like this:

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

With the nullish coalescing operator, your code is much shorter and easier to understand:

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

As mentioned above, in order to get and set the user’s preference for unit of measurement, we use local storage. For browsers, the local storage object is a property of the `window` object. While you can just call `localStorage` directly, you can also call it with `window.localStorage`. In ES2020, we can also access it through the `globalThis` object (also note the use of optional chaining again to do some feature detection to make sure the browser supports local storage):

```JavaScript
const doesPreferKilograms = globalThis.localStorage?.getItem?.('prefersKg')
```

The `globalThis` feature is pretty simple, but it solves many inconsistencies that can sometimes bite you. Simply put, `globalThis` contains a reference to the global object. In the browser, the global object is the `window` object. In a node environment, the global object is literally called `global`. Using `globalThis` ensures that you always have a valid reference to the global object no matter what environment your code is running in. That way, you can write portable JavaScript modules that will run correctly in the main thread of the browser, in a web worker, or in the node environment.

## 5. Dynamic Imports

Once the user has chosen a product, a unit of measurement, and a weight and price combination, he or she can click the submit button to find the unit price. When the button is clicked, a JavaScript module for calculating the unit price is lazy loaded. You can check the network request in the browser’s dev tools to see that the second file isn’t loaded until you click the button:

```JavaScript
import('./calculate.js')
  .then(module => {
    // use a method exported by the module
  })
  .catch(err => {
    // handle any errors loading the module or any subsequent errors
  })
```

Prior to ES2020, using an `import` statement in your JavaScript meant that the imported file was automatically included inside the parent file when the parent file was requested.

Bundlers like [webpack](https://webpack.js.org/) have popularized the concept of “code splitting,” which is a feature that allows you to split your JavaScript bundles into multiple files that can be loaded on demand. React has also implemented this feature with its `React.lazy()` method.

Code splitting is incredibly useful for single page applications (SPAs). You can split your code into separate bundles for each page, so only the code needed for the current view is downloaded. This significantly speeds up the initial page load time so that end users don’t have to download the entire app upfront.

Code splitting is also helpful for large portions of rarely-used code. For example, say you have an “Export PDF” button on a page in your app. The PDF download code is large, and including it when the page loads reduces overall load time. However, not every user visiting this page needs or wants to export a PDF. To increase performance, you can make your PDF download code be lazy loaded so that the additional JavaScript bundle is only downloaded when the user clicks the “Export PDF” button.

In ES2020, dynamic imports are baked right into the JavaScript specification!

Let’s look at an example setup for the “Export PDF” functionality without dynamic imports:

```JavaScript
import { exportPdf } from './pdf-download.js'

const exportPdfButton = document.querySelector('.exportPdfButton')
exportPdfButton.addEventListener('click', exportPdf)

// this code is short, but the 'pdf-download.js' module is loaded on page load rather than when the button is clicked
```

And now let’s look at how you could use a dynamic import to lazy load the large PDF download module:

```JavaScript
const exportPdfButton = document.querySelector('.exportPdfButton')

exportPdfButton.addEventListener('click', () => {
  import('./pdf-download.js')
    .then(module => {
      // call some exported method in the module
      module.exportPdf()
    })
    .catch(err => {
      // handle the error if the module fails to load
    })
})

// the 'pdf-download.js' module is only imported once the user click the "Export PDF" button
```

## 6. String.prototype.matchAll()

When calling the `calculateUnitPrice` method, we pass the product name and the price/weight combination. The price/weight combination is a string that looks like "$200 for 10 kg". We need to parse that string to get the price, weight, and unit of measurement. (There's certainly a better way to architect this app to avoid parsing a string like this, but I'm setting it up this way for the sake of demonstrating this next feature.) To extract the necessary data, we can use `String.prototype.matchAll()`:

```JavaScript
const matchResults = [...weightAndPrice.matchAll(/\d+|lb|kg/g)]
```

There’s a lot going on in that one line of code. We look for matches in our string based on a regular expression that is searching for digits and the strings “lb” or “kg”. It returns an iterator, which we can then spread into an array. This array ends up with three elements in it, one element for each match (200, 10, and “kg”).

This feature is probably the most difficult to understand, particularly if you’re not well-versed in regular expressions. The short and simple explanation of `String.prototype.matchAll()` is that it's an improvement on the functionality found in `String.prototype.match()` and `RegExp.prototype.exec()`. This new method allows you to match a string against a regular expression and returns an iterator of all the matching results, including capture groups.

Did you get all that? Let’s look at another example to help solidify the concept:

```JavaScript
const regexp = /t(e)(st(\d?))/
const regexpWithGlobalFlag = /t(e)(st(\d?))/g
const str = 'test1test2'

// Using `RegExp.prototype.exec()`
const matchFromExec = regexp.exec(str)
console.log(matchFromExec)
// ["test1", "e", "st1", "1", index: 0, input: "test1test2", groups: undefined]

// Using `String.prototype.match()` on a regular expression WITHOUT a global flag returns the capture groups
const matchFromMatch = str.match(regexp)
console.log(matchFromMatch)
// ["test1", "e", "st1", "1", index: 0, input: "test1test2", groups: undefined]

// Using `String.prototype.match()` on a regular expression WITH a global flag does NOT return the capture groups :(
const matchesFromMatchWithGlobalFlag = str.match(regexpWithGlobalFlag)
for (const match of matchesFromMatchWithGlobalFlag) {
  console.log(match)
}
// test1
// test2

// Using `String.prototype.matchAll()` correctly returns even the capture groups when the global flag is used :)
const matchesFromMatchAll = str.matchAll(regexpWithGlobalFlag)
for (const match of matchesFromMatchAll) {
  console.log(match)
}
// ["test1", "e", "st1", "1", index: 0, input: "test1test2", groups: undefined]
// ["test2", "e", "st2", "2", index: 5, input: "test1test2", groups: undefined]

```

## 7. BigInt

Finally, we’ll make the unit price calculation by simply dividing the price by the weight. You can do this with normal numbers, but when working with large numbers, ES2020 introduces the `BigInt` which allows you to do calculations on large integers without losing precision. In the case of our app, using `BigInt` is overkill, but who knows, maybe our API endpoint will change to include some crazy bulk deals!

```JavaScript
const price = BigInt(matchResults[0][0])
const priceInPennies = BigInt(matchResults[0][0] * 100)
const weight = BigInt(matchResults[1][0])
const unit = matchResults[2][0]

const unitPriceInPennies = Number(priceInPennies / weight)
const unitPriceInDollars = unitPriceInPennies / 100
const unitPriceFormatted = unitPriceInDollars.toFixed(2)
```

If you’ve ever worked with data that contains extremely large numbers, then you know what a pain it can be to ensure the integrity of your numeric data while performing JavaScript math operations. Prior to ES2020, the largest whole number you could safely store was represented by `Number.MAX_SAFE_INTEGER`, which is 2^53 - 1.

If you tried to store a number larger than that value in a variable, sometimes the number wouldn’t be stored correctly:

```JavaScript
const biggestNumber = Number.MAX_SAFE_INTEGER // 9007199254740991

const incorrectLargerNumber = biggestNumber + 10
// should be: 9007199254741001
// actually stored as: 9007199254741000
```

The new `BigInt` data type helps solve this problem and allows you to work with much larger integers. To make an integer a `BigInt`, you simply append the letter `n` to the end of the integer or call the function `BigInt()` on your integer:

```JavaScript
const biggestNumber = BigInt(Number.MAX_SAFE_INTEGER) // 9007199254740991n

const correctLargerNumber = biggestNumber + 10n
// should be: 9007199254741001n
// actually stored as: 9007199254741001n
```

## Conclusion

That’s it! Now that you know all about the new ES2020 features, what are you waiting for? Get out there and start writing new JavaScript today!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
