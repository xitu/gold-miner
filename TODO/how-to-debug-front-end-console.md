> * 原文地址：[How to debug Front-end: Console](https://blog.pragmatists.com/how-to-debug-front-end-console-3456e4ee5504)
> * 原文作者：[Michał Witkowski](https://blog.pragmatists.com/@WitkowskiMichau?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-debug-front-end-console.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-debug-front-end-console.md)
> * 译者：
> * 校对者：

# How to debug Front-end: Console

![](https://cdn-images-1.medium.com/max/800/1*7YqeM-SzGWEHzbROo_MyAQ.jpeg)

Software developers produce code and introduce bugs, not intentionally, but they do. The older the bug is, the harder it is to find and fix. In this series of articles, I’ll try to show what you can do by using Google Chrome Devtools, Chrome plugins and WebStorm.

This tutorial will be about Chrome Console, the most commonly used debugging tool. Enjoy!

### Console

To open Chrome DevTools:

*   Select More Tools > Developer Tools from Chrome’s Main Menu.
*   Right-click a page element and select Inspect.
*   Press Command+Option+I (Mac) or Control+Shift+I (Windows, Linux).

Look at the Console tab and what is there.

![](https://cdn-images-1.medium.com/max/800/0*ZggoM0sI_jj1QafW.)

First row:

![](https://cdn-images-1.medium.com/max/600/1*-EAbAlPJaC22sk1R4z6GPA.png)

- clear console

`top` — by default, the Console context is top, unless you inspect some element, or Chrome plugin context.
You can change the context of execution (the top frame of the page).

**Filter:**
Filters console output. You can filter by severity level, regular expression, or by hiding network messages.

**Settings:**
`Hide network` — Hide network errors such as 404.
`Preserve log` — Console will keep logs between refreshes or navigation.
`Selected context only` — We can change the context of logs in [top].
`User messages only` — Hide browser-generated [violation] warnings.
`Log XMLHttpRequests` — I can’t say more than this checkbox says.
`Show timestamps` — timestamps are visible in the console below.
`Autocomplete from history` — Chrome _does_ remember what you typed ;)

### Chosen Console API

The console will run every JS code you’ll type in, in your application context. So if something is available in a global scope, you can easily see it via the console. You can also simply type and see the result of an expression e.g.: “null === 0”.

#### console.log — reference

By definition, console.log prints an output to the console. That part you probably know; what might be new for you is that console.log keeps a reference to the object you are displaying. Look at the code below.

```
var fruits = [{one: 1}, {two: 2}, {three: 3}];
console.log('fruits before modification: ', fruits);
console.log('fruits before modification - stringed: ', JSON.stringify(fruits));
fruits.splice(1);
console.log('fruits after modification: ', fruits);
console.log('fruits after modification - stringed : ', JSON.stringify(fruits))
```

![](https://cdn-images-1.medium.com/max/800/0*L5q3tcszjc1IYXRT.)

When debugging objects or arrays, you need to be careful. We see that `_fruits_` before modification contains 3 objects, but they are no longer there. To see results in this particular moment, use `JSON.stringify` to keep the information visible. Of course, that might not be convenient with bigger objects. Don’t worry; later on, we’ll find a better solution.

#### console.log — sorting object properties

Does JavaScript guarantee object property order?

> 4.3.3 Object — ECMAScript Third Edition (1999)

> An object is a member of the type Object. It is an unordered collection of properties, each of which contains a primitive value, object, or function. A function stored in a property of an object is called a method.

Later… in ES5 it has slightly changed — but you can’t be sure if your object properties will be in order or not. Browsers have implemented this in various ways. If we look at the Chrome result, we’ll see something disturbing.

```
var letters = {
  z: 1,
  t: 2,
  k: 6
};
console.log('fruits', letters);
console.log('fruits - stringify', JSON.stringify(letters));
```

![](https://cdn-images-1.medium.com/max/800/0*aISOsYX8-BnOtWy4.)

Surprise! Chrome sorted properties in alphabetical order, to help us. I can’t decide if I like it or not, but it’s good to know it might happen.

#### console.assert(expression, message)

`Console.assert` throws up an error if the evaluated expression is `false`. Crucially, assert does not stop code from further evaluation. It might help to debug long and tricky code,or find bugs which reveal themselves after several iterations.

```
function callAssert(a,b) {
  console.assert(a === b, 'message: a !== b ***** a: ' + a +' b:' +b);
}
callAssert(5,6);
callAssert(1,1);
```

![](https://cdn-images-1.medium.com/max/800/0*Pdq0UFBR4kCZA6iE.)

#### console.count(label)

Put simply, it’s a `console.log` that counts how many times it has been called with the same expression. THE SAME.

```
for(var i =0; i <=3; i++){
	console.count(i + ' Can I go with you?');
	console.count('No, no this time');
}
```

![](https://cdn-images-1.medium.com/max/800/0*2yH13TAvSFpKrTWn.)

As you can see in the example, only the exact same string had a number.

#### console.table()

Great debugging function, but sometimes I’m just too lazy to use it, even though it would probably speed up my work… so please don’t make this mistake. Be efficient.

```
var fruits = [
  { name: 'apple', like: true },
  { name: 'pear', like: true },
  { name: 'plum', like: false },
];
console.table(fruits);
```

![](https://cdn-images-1.medium.com/max/800/0*qe69gSjpDllYrGvY.)

Great… firstly, you got everything nicely placed in the table; secondly, you have `console.log` added as well. Good work Chrome, but that’s not all.

```
var fruits = [
  { name: 'apple', like: true },
  { name: 'pear', like: true },
  { name: 'plum', like: false },
];
console.table(fruits, ['name'])
```

![](https://cdn-images-1.medium.com/max/800/0*Fv8KsLDQIPY8yfJN.)

We can decide if we want to see all of it, or some columns from the whole object.
The table is sortable– just click on the header of the column you want to sort.

#### console.group() / console.groupEnd();

We’ll start with code this time. Let’s see how grouping works for console.

```
console.log('iteration');
for(var firstLevel = 0; firstLevel<2; firstLevel++){
  console.group('First level: ', firstLevel);
  for(var secondLevel = 0; secondLevel<2; secondLevel++){
	console.group('Second level: ', secondLevel);
	for(var thirdLevel = 0; thirdLevel<2; thirdLevel++){
  	console.log('This is third level number: ', thirdLevel);
	}
	console.groupEnd();
  }
  console.groupEnd();
}
```

![](https://cdn-images-1.medium.com/max/800/0*X3vtX9amAT_Or_DO.)

Great if you are working with data, and going deep…

#### console.trace();

Trace prints stack trace into Console. Good to know, especially if you are building libraries or frameworks.

```
function func1() {
  func2();
}
function func2() {
  func3();
}
function func3() {
  console.trace();
}
func1();
```

![](https://cdn-images-1.medium.com/max/800/0*4JoZfbntg4bGr03y.)

#### console.log vs console.dir

```
console.log([1,2]);
console.dir([1,2]);
```

![](https://cdn-images-1.medium.com/max/800/0*SI2ge80spD1WY9yI.)

Here, the implementation depends on the browser. Initially, dir was supposed to keep the reference to an object, whereas log was not.(Log was displaying a copy of an object). Now as we saw before, log also keeps the reference. Let’s stay with that, as they display objects differently. Not a big deal, and useful with debugging HTML objects.

#### $_, $0 — $4

`$_` returns the value of the most recently evaluated expression.
`$0 — $4` — work as a historical reference to the last 5 inspected HTML elements.

![](https://cdn-images-1.medium.com/max/800/0*J1jrQOkNHzaDA_hu.)

#### getEventListeners(object)

Returns event listeners registered on specific DOM elements.There is also a more convenient way to set listeners, but I’ll cover that in the next tutorial.

![](https://cdn-images-1.medium.com/max/800/0*JrWFBmu3UKYy-nFj.)

### monitorEvents(DOMElement, [events]) / unmonitorEvents(DOMElement)

If any of these set events are triggered, we’ll get information in the console. Until you unmonitor the event.

![](https://cdn-images-1.medium.com/max/800/0*PJTUIgivpcMGnrRP.)

### Selecting elements in Console

![](https://cdn-images-1.medium.com/max/800/0*Dr5KRB77jQrjjdA4.)

To open this screen, press ESC in Element tab.

If there is nothing other assigned to `$`

`$()` — `**document.querySelector()**`**.** Returns the first element, matching a CSS selector (e.g. `$(‘span’)` will return the first span).
`$$()` — `**document.querySelectorAll()**`. Returns an array of elements that match the CSS selector inside.

#### Copy printed data

Sometimes, you are working on data. You might want to create a draft, or simply see if there is any difference between two objects. Highlighting everything and then copying might be hard. Happily, there is another way.

Click with your right mouse button on the object and press copy, or store it as a global element. Then you can operate on the stored element in the console.

Anything in the console can also be copied by using `copy(‘object-name’)`.

#### Style console output

Imagine again that you’re working on a library, or a big module that your whole team/company will work with. It would be nice to highlight some logs in dev mode. You can do it; try the code below.

`console.log(‘%c Truly hackers code! ‘, ‘background: #222; color: #bada55’);`

![](https://cdn-images-1.medium.com/max/800/0*RYIJp1JEZhZ7Nqm8.)

`%d` or `%i` — Integer
`%f` — floating point value
`%o` — Expandable DOM element
`%O` — Expandable JS object
`%c` — Formats outputs with CSS

That is all for today, but not all in this topic. Below, you’ll find links for further reading.

*   [Command Line API Reference](https://developers.google.com/web/tools/chrome-devtools/console/command-line-reference) by Google
*   [Console API](https://developer.mozilla.org/en-US/docs/Web/API/Console) by MDN
*   [Console API](http://2ality.com/2013/10/console-api.html) by 2ality
*   [CSS Selectors](https://developer.mozilla.org/pl/docs/Web/CSS/CSS_Selectors)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
