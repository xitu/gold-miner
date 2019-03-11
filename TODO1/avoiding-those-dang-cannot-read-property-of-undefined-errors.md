> * 原文地址：[Avoiding those dang cannot read property of undefined errors](https://css-tricks.com/%E2%80%8B%E2%80%8Bavoiding-those-dang-cannot-read-property-of-undefined-errors/)
> * 原文作者：[Adam Giese](https://css-tricks.com/author/thirdgoose/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/avoiding-those-dang-cannot-read-property-of-undefined-errors.md](https://github.com/xitu/gold-miner/blob/master/TODO1/avoiding-those-dang-cannot-read-property-of-undefined-errors.md)
> * 译者：[Xcco](https://github.com/Xcco)
> * 校对者：[hanxiansen](https://github.com/hanxiansen), [Mirosalva](https://github.com/Mirosalva)

# 避免那些可恶的 "cannot read property of undefined" 错误

`Uncaught TypeError: Cannot read property 'foo' of undefined.` 是一个我们在 JavaScript 开发中都遇到过的可怕错误。或许是某个 API 返回了意料外的空值，又或许是其它什么原因，这个错误是如此的普遍而广泛以至于我们无法判断。

我最近遇到了一个问题，某一环境变量出于某种原因没有被加载，导致各种各样的报错夹杂着这个错误摆在我面前。不论什么原因，放着这个错误不处理都会是灾难性的。所以我们该怎么从源头阻止这个问题发生呢？

让我们一起来找出解决方案。

### 工具库

如果你已经在项目里用到一些工具库，很有可能库里已经有了预防这个问题发生的函数。lodash 里的 `_.get`（[文档](https://lodash.com/docs/4.17.11#get)) 或者 Ramda 里的 `R.path`([文档](https://ramdajs.com/docs/#path)）都能确保你安全使用对象。  
  
如果你已经使用了工具库，那么这看起来已经是最简单的方法了。如果你没有使用工具库，继续读下去吧！

### 使用 && 短路

JavaScript 里有一个关于逻辑运算符的有趣事实就是它不总是返回布尔值。[根据说明](https://www.ecma-international.org/ecma-262/9.0/index.html#sec-binary-logical-operators)，『`&&` 或者 `||` 运算符的返回值并不一定是布尔值。而是两个操作表达式的其中之一。』  
 
举个 `&&` 运算符的例子，如果第一个表达式的布尔值是 false，那么该值就会被返回。否则，第二个表达式的值就会被使用。这说明表达式 `0 && 1` 会返回 `0`（一个 false 值），而表达式 `2 && 3` 会返回 `3`。如果多个 `&&` 表达式连在一起，它们将会返回第一个 false 植或最后一个值。举个例子，`1 && 2 && 3 && null && 4` 会返回 `null`，而 `1 && 2 && 3` 会返回 `3`。

那么如何安全的获取嵌套对象内的属性呢？JavaScript 里的逻辑运算符会『短路』。在这个 `&&` 的例子中，这表示表达式会在到达第一个假值时停下来。

```
const foo = false && destroyAllHumans();
console.log(foo); // false，人类安全了
```

在这个例子中，`destroyAllHumans` 不会被调用，因为 `&&` 停止了所有在 false 之后的运算

这可以被用于安全地获取嵌套对象的属性。

```
const meals = {
  breakfast: null, // 我跳过了一天中最重要的一餐！ :(
  lunch: {
    protein: 'Chicken',
    greens: 'Spinach',
  },
  dinner: {
    protein: 'Soy',
    greens: 'Kale',
  },
};

const breakfastProtein = meals.breakfast && meals.breakfast.protein; // null
const lunchProtein = meals.lunch && meals.lunch.protein; // 'Chicken'
```

除了简单，这个方法的一个主要优势就是在处理较少嵌套时十分简洁。然而，当访问深层的对象时，它会变得十分冗长。

```
const favorites = {
  video: {
    movies: ['Casablanca', 'Citizen Kane', 'Gone With The Wind'],
    shows: ['The Simpsons', 'Arrested Development'],
    vlogs: null,
  },
  audio: {
    podcasts: ['Shop Talk Show', 'CodePen Radio'],
    audiobooks: null,
  },
  reading: null, // 开玩笑的 — 我热爱阅读
};

const favoriteMovie = favorites.video && favorites.video.movies && favorites.video.movies[0];
// Casablanca
const favoriteVlog = favorites.video && favorites.video.vlogs && favorites.video.vlogs[0];
// null
```

对象嵌套的越深，它就变得越笨重。

### 『或单元』

Oliver Steele 提出这个方法并且在他发布的博客里探究了更多的细节，[『单元第一章：或单元』](https://blog.osteele.com/2007/12/cheap-monads/)我会试着在这里给出一个简要的解释。

```
const favoriteBook = ((favorites.reading||{}).books||[])[0]; // undefined
const favoriteAudiobook = ((favorites.audio||{}).audiobooks||[])[0]; // undefined
const favoritePodcast = ((favorites.audio||{}).podcasts||[])[0]; // 'Shop Talk Show'
```

与上面的短路例子类似，这个方法通过检查值是否为假来生效。如果值为假，它会尝试取得空对象的属性。在上面的例子中，favorites.reading 的值是 null，所以从一个空对象上获得books属性。这会返回一个 undefined 结果，所以0会被用于获取空数组中的成员。

这个方法相较于 `&&` 方法的优势是它避免了属性名的重复。在深层嵌套的对象中，这会成为显著的优势。而主要的缺点在于可读性 — 这不是一个普通的模式，所以这或许需要阅读者花一点时间理解它是怎么运作的。

### try/catch

JavaScript 里的 `try...catch` 是另一个安全获取属性的方法。

```
try {
  console.log(favorites.reading.magazines[0]);
} catch (error) {
  console.log("No magazines have been favorited.");
}
```

不幸的是，在 JavaScript 里，`try...catch` 声明不是表达式，它们不会像某些语言里那样计算值。这导致不能用一个简洁的 try 声明来作为设置变量的方法。

有一种选择就是在 `try...catch` 前定义一个 let 变量。

```
let favoriteMagazine;
try { 
  favoriteMagazine = favorites.reading.magazines[0]; 
} catch (error) { 
  favoriteMagazine = null; /* 任意默认值都可以被使用 */
};
```

虽然这很冗长，但这对设置单一变量起作用（就是说，如果变量还没有吓跑你的话）然而，把它们写在一块就会出问题。

```
let favoriteMagazine, favoriteMovie, favoriteShow;
try {
  favoriteMovie = favorites.video.movies[0];
  favoriteShow = favorites.video.shows[0];
  favoriteMagazine = favorites.reading.magazines[0];
} catch (error) {
  favoriteMagazine = null;
  favoriteMovie = null;
  favoriteShow = null;
};

console.log(favoriteMovie); // null
console.log(favoriteShow); // null
console.log(favoriteMagazine); // null
```

如果任意一个获取属性的尝试失败了，这会导致它们全部返回默认值。

一个可选的方法是用一个可复用的工具函数封装 `try...catch`。

```
const tryFn = (fn, fallback = null) => {
  try {
    return fn();
  } catch (error) {
    return fallback;
  }
} 

const favoriteBook = tryFn(() => favorites.reading.book[0]); // null
const favoriteMovie = tryFn(() => favorites.video.movies[0]); // "Casablanca"
```

通过一个函数包裹获取对象属性的行为，你可以延后『不安全』的代码，并且把它传入 `try...catch`。

这个方法的主要优势在于它十分自然地获取了属性。只要属性被封装在一个函数中，属性就可以被安全访问，同时可以为不存在的路径返回指定的默认值。

### 与默认对象合并

通过将对象与相近结构的『默认』对象合并，我们能确保获取属性的路径是安全的。

```
const defaults = {
  position: "static",
  background: "transparent",
  border: "none",
};

const settings = {
  border: "1px solid blue",
};

const merged = { ...defaults, ...settings };

console.log(merged); 
/*
  {
    position: "static",
    background: "transparent",
    border: "1px solid blue"
  }
*/
```

然而，需要注意并非单个属性，而是整个嵌套对象都会被覆写。

```
const defaults = {
  font: {
    family: "Helvetica",
    size: "12px",
    style: "normal",
  },        
  color: "black",
};

const settings = {
  font: {
    size: "16px",
  }
};

const merged = { 
  ...defaults, 
  ...settings,
};

console.log(merged.font.size); // "16px"
console.log(merged.font.style); // undefined
```

不！为了解决这点，我们需要类似地复制每一个嵌套对象。

```
const merged = { 
  ...defaults, 
  ...settings,
  font: {
    ...defaults.font,
    ...settings.font,
  },
};

console.log(merged.font.size); // "16px"
console.log(merged.font.style); // "normal"
```

好多了！

这种模式在这类插件或组件中很常见，它们接受一个包含默认值得大型可配置对象。

这种方式的一个额外好处就是通过编写一个默认对象，我们引入了文档来介绍这个对象。不幸的是，按照数据的大小和结构，复制每一个嵌套对象进行合并有可能造成污染。

### 未来：可选链式调用

目前 TC39 提案中有一个功能叫『可选链式调用』。这个新的运算符看起来像这样：

```
console.log(favorites?.video?.shows[0]); // 'The Simpsons'
console.log(favorites?.audio?.audiobooks[0]); // undefined
```

`?.` 运算符通过短路方式运作：如果 `?.` 运算符的左侧计算值为 `null` 或者 `undefined`，则整个表达式会返回 `undefined` 并且右侧不会被计算。

为了有一个自定义的默认值，我们可以使用 `||` 运算符以应对未定义的情况。

```
console.log(favorites?.audio?.audiobooks[0] || "The Hobbit");
```

### 我们该使用哪一种方法？

答案或许你已经猜到了，正是那句老话『看情况而定』。如果可选链式调用已经被加到语言中并且获得了必要的浏览器支持，这或许是最好的选择。然而，如果你不来自未来，那么你有更多需要考虑的。你在使用工具库吗？你的对象嵌套有多深？你是否需要指定默认值？我们需要根据不同的场景采用不同的方法。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
