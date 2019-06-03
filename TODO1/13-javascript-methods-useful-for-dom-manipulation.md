> * 原文地址：[13 JavaScript Methods Useful For DOM Manipulation](https://devinduct.com/blogpost/20/13-javascript-methods-useful-for-dom-manipulation)
> * 原文作者：[Milos Protic](https://devinduct.com/blogpost/20/13-javascript-methods-useful-for-dom-manipulation)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/13-javascript-methods-useful-for-dom-manipulation.md](https://github.com/xitu/gold-miner/blob/master/TODO1/13-javascript-methods-useful-for-dom-manipulation.md)
> * 译者：
> * 校对者：

# 13 JavaScript Methods Useful For DOM Manipulation

## Intro

DOM or the Document Object Model is the root of all objects on the web page. It represents the structure of a document and connects the page to the programming languages. It is structured as a logical tree. Each branch ends in a node and each node contains child nodes, objects. The DOM API is quite large and in this article, we will cover only the ones I find most useful.

## document.querySelector / document.querySelectorAll

The method `document.querySelector` returns the first element within the document that matches the given selector(s).

The method `document.querySelectorAll` returns a list of nodes representing a list of the document's elements matched by the given selector(s).

```js
// returns the first list
const list = document.querySelector('ul');
// returns all div elements with class intro or warning
const elements = document.querySelectorAll('div.info, div.warning');
```

## document.createElement

This method creates a new `HTMLElement` by the given tag name. The return value is the newly created element.

## Node.appendChild

The `Node.appendChild()` method adds a node to the end of the list of children of a given parent node. Note that if the given child is a reference of an existing node in the document, it will be moved to the new position.

Let's see these two in action:

```js
let list = document.createElement('ul'); // creates a new list
['Paris', 'London', 'New York'].forEach(city => {
    let listItem = document.createElement('li');
    listItem.innerText = city;
    list.appendChild(listItem);
});
document.body.appendChild(list);
```

## Node.insertBefore

This method inserts a given node before the child reference node within a specified parent node (and returns the inserted node). Quick pseudo code would be something like this:

1. Paris
2. London
3. New York

↓

Node.insertBefore(San Francisco, Paris)

↓

1. San Francisco
2. Paris
3. London
4. New York

```js
let list = document.querySelector('ul');
let firstCity = list.querySelector('ul > li'); // here we could use list.firstChild, but the purpose of this article is to show DOM API methods
let newCity = document.createElement('li');
newCity.textContent = 'San Francisco';
list.insertBefore(newCity, firstCity);
```

## Node.removeChild

The `Node.removeChild` method removes a child node from the DOM and returns the removed node. Note that the returned node is no longer part of the DOM but still exists in memory. If not handled properly it can cause memory leaks.

```js
let list = document.querySelector('ul');
let firstItem = list.querySelector('li');
let removedItem = list.removeChild(firstItem);
```

## Node.replaceChild

This method replaces a child node within the parent node (and returns the replaced, old child). Note that this method, if not handled properly, can cause memory leaks just like `Node.removeChild`.

```js
let list = document.querySelector('ul');
let oldItem = list.querySelector('li');
let newItem = document.createElement('li');
newItem.innerHTML = 'Las Vegas';
let replacedItem = list.replaceChild(newItem, oldItem);
```

## Node.cloneNode

This method creates a duplicate of the given node on which this method was invoked. Useful when you need to create a new element that needs to be the same as an existing element on the page. It accepts an optional `boolean` parameter, a flag that indicates whether the child nodes should be cloned or not.

```js
let list = document.querySelector('ul');
let clone = list.cloneNode();
```

## Element.getAttribute / Element.setAttribute

The `Element.getAttribute` method returns the value of a given attribute on the element and vice versa, the `Element.setAttribute` sets the value of an attribute on the given element.

```js
let list = document.querySelector('ul');
list.setAttribute('id', 'my-list');
let id = list.getAttribute('id');
console.log(id); // outputs my-list
```

## Element.hasAttribute / Element.removeAttribute

The `Element.hasAttribute` method checks whether the given element has the specified attribute or not. The return value is `boolean`. By invoking the method `Element.removeAttribute` we can remove the attribute with the given name from the element.

```js
let list = document.querySelector('ul');
if (list.hasAttribute('id')) {
    console.log('list has an id');
    list.removeAttribute('id');
};
```

## Element.insertAdjacentHTML

This method parses the specified text as HTML and inserts the resulting nodes into the DOM tree at a given position. It will not corrupt the existing nodes within the element it inserts the new HTML. The position can be one of the following strings:

1. `beforebegin`
2. `afterbegin`
3. `beforeend`
4. `afterend`

```html
<!-- beforebegin -->
<div>
  <!-- afterbegin -->
  <p>Hello World</p>
  <!-- beforeend -->
</div>
<!-- afterend -->
```

Example:

```js
var list = document.querySelector('ul');
list.insertAdjacentHTML('afterbegin', '<li id="first-item">First</li>');
```

Note that when using this method we need to properly sanitize the given HTML.

## Conclusion And Further Reading

I hope you find this list useful and that will help you understand the DOM. Handling the DOM tree properly is extremely important, and not doing it correctly might bring you some serious consequences. Make sure that you always do a memory cleanup and sanitize the HTML/XML strings properly.

For further reading check out the official [w3c page](https://www.w3.org/TR/?tag=dom).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
