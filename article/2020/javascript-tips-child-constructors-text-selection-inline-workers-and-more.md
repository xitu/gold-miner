> * 原文地址：[JavaScript Tips — Child Constructors, Text Selection, Inline Workers, and More](https://medium.com/front-end-weekly/javascript-tips-child-constructors-text-selection-inline-workers-and-more-606bc050ee24)
> * 原文作者：[John Au-Yeung](https://medium.com/@hohanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/javascript-tips-child-constructors-text-selection-inline-workers-and-more.md](https://github.com/xitu/gold-miner/blob/master/article/2020/javascript-tips-child-constructors-text-selection-inline-workers-and-more.md)
> * 译者：
> * 校对者：

# JavaScript Tips — Child Constructors, Text Selection, Inline Workers, and More

![Photo by [Todd Quackenbush](https://unsplash.com/@toddquackenbush?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11232/0*KOJy41sl9vEDg2M8)

Like any kind of apps, there are difficult issues to solve when we write JavaScript apps.

In this article, we’ll look at some solutions to common JavaScript problems.

## Prevent Text Selection After Double Click

We can stop text selection after a double click by calling `preventDefault()` to stop the default action.

For example, we can write:

```js
document.addEventListener('mousedown', (event) => {
  if (event.detail > 1) {
    event.preventDefault();
    // ...
  }
}, false);
```

## Why is it Necessary to Set the Prototype Constructor?

We’ve to set the prototype constructor so that we can check with `instanceof` that the prototype’s constructor is a given constructor.

For instance, if we have:

```js
function Person(name) {
  this.name = name;
}  


function Student(name) {  
  Person.call(this, name);
}

Student.prototype = Object.create(Person.prototype);
```

Then the `Student` ‘s prototype is set to `Person` .

But we actually want to set it to `Student` , even though it inherits from `Person` .

Therefore, we need to write:

```js
Student.prototype.constructor = Student;
```

Now if we create an instance of `Student` , and check if it with `instanceof` :

```js
student instanceof Student
```

Then that would return `true` .

If we use the class syntax, then we don’t have to do that anymore.

We just write:

```js
class Student extends Person {
}
```

and everything else is handled for us.

## Creating Web Workers without a Separate Javascript File

We can create a web worker without creating a separate JavaScript file using the `javascript/worker` as the value of the `type` attribute.

For instance, we can write:

```html
<script id="worker" type="javascript/worker">
  self.onmessage = (e) => {
    self.postMessage('msg');
  };
</script>
<script>
  const blob = new Blob([
    document.querySelector('#worker').textContent
  ];

  const worker = new Worker(window.URL.createObjectURL(blob));
  worker.onmessage = (e) => {
    console.log(e.data);
  }
  worker.postMessage("hello");
</script>
```

We get the worker as a blob by using get the script element and use the `textContent` property on it.

Then we create the worker with the `Worker` constructor with the blob.

Then we write our usual worker code in the worker and the script invoking the worker.

## How to Trim a File Extension from a String

We can trim the file extension from a string, we can use `replace` method.

For instance, we can write:

```js
fileName.replace(/\.[^/.]+$/, "");
```

We get the last part of the string that’s after the dot with the regex pattern.

And we replace it with the empty string.

In Node apps, we can use the `path` module.

To get the name, we can write:

```js
const path = require('path');
const filename = 'foo.txt';
path.parse(filename).name;
```

`path.parse` takes the file path. Then we get the `name` property from it.

## Why does parseInt Return NaN with Array.prototype.map?

`parseInt` returns `NaN` with array instance’s `map` method because `parseInt` takes arguments but the `map` callback takes 3 arguments.

`parseInt` takes the number as the first argument and the radix as the 2nd argument.

The `map` callback takes the array entry as the first argument, index as the 2nd argument, and the array itself as the 3rd argument.

Therefore, if we use `parseInt` directly as the callback, then the index will be passed in as the radix, which doesn’t make sense.

This is why we may get `NaN` .

We get that if the radix isn’t a valid radix.

Therefore, instead of writing:

```js
['1','2','3'].map(parseInt)
```

We write:

```js
['1','2','3'].map(Number)
```

or:

```js
['1','2','3'].map(num => parseInt(num, 10))
```

## Omitting the Second Expression When Using the Ternary Operator

If we have the following ternary expressions:

```js
x === 1 ? doSomething() : doSomethingElse();
```

but we don’t want to call `doSomethingElse` when `x === 1` is `false` , then we can use the `&&` operator instead.

For instance, we can write:

```js
x === 1 && dosomething();
```

Then if `x === 1` is `true` , then `doSomething` is called.

## Clear Cache in Yarn

We can clear the cache in yarn by using the `yarn cache clean` command.

## innerText Works in IE, but not in Other Browsers

`innerText` is an IE-only property for populate texting content of a node.

To do the same thing other browsers, we set the `textContent` property.

For instance, we write:

```js
const el = document.getElementById('foo');
el.textContent = 'foo';
```

![Photo by [Ron Hansen](https://unsplash.com/@ron_hansen?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11232/0*WUVX7cH9AbWz9RhL)

## Conclusion

We can stop selection after double-clicking by calling `preventDefault` to stop the default action from running.

Also, we shouldn’t use `parseInt` as a callback for `map` .

We’ve to set the constructor to the current constructor if we create a child constructor.

This way, we can check for the instance properly.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
