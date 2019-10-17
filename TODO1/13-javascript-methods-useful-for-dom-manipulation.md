> * 原文地址：[13 JavaScript Methods Useful For DOM Manipulation](https://devinduct.com/blogpost/20/13-javascript-methods-useful-for-dom-manipulation)
> * 原文作者：[Milos Protic](https://devinduct.com/blogpost/20/13-javascript-methods-useful-for-dom-manipulation)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/13-javascript-methods-useful-for-dom-manipulation.md](https://github.com/xitu/gold-miner/blob/master/TODO1/13-javascript-methods-useful-for-dom-manipulation.md)
> * 译者：[fireairforce](https://github.com/fireairforce)
> * 校对者：[ZavierTang](https://github.com/ZavierTang), [smilemuffie](https://github.com/smilemuffie)

# 13 种有用的 JavaScript DOM 操作

## 介绍

DOM（Document Object Model）是网页上所有对象的基础。它描述文档的结构，并且为编程语言提供操作页面的接口。它被构造成逻辑树。每个分支以节点结束，每个节点包含有子节点。DOM API 有很多，在本文里面，我仅介绍一些我认为最有用的 API。

## document.querySelector / document.querySelectorAll

`document.querySelector` 方法返回文档中与给定选择器组匹配的第一个元素。

`document.querySelectorAll` 返回与给定选择器组匹配的文档中的元素列表。

```js
// 返回第一个元素
const list = document.querySelector('ul');
// 返回所有类名为 intro 或 warning 的 div 元素
const elements = document.querySelectorAll('div.info, div.warning');
```

## document.createElement

这个方法会通过给定的标签名称来创建一个 `HTMLElement`。返回值是新创建的元素。

## Node.appendChild

`Node.appendChild()` 这个方法能够将节点添加到给定父节点的子节点列表的末尾。请注意，如果给定要添加的子节点是文档中现有节点的引用，则它将会被移动到子节点列表的末尾。

让我们看看这两种方法的作用：

```js
let list = document.createElement('ul'); // 创建一个新的 ul 元素
['Paris', 'London', 'New York'].forEach(city => {
    let listItem = document.createElement('li');
    listItem.innerText = city;
    list.appendChild(listItem);
});
document.body.appendChild(list);
```

## Node.insertBefore

这个方法在指定父节点内的某个子节点之前插入给定节点（并返回插入的节点）。下面是使用该方法的一个伪代码:

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
let firstCity = list.querySelector('ul > li'); // 这里我们可以使用 list.firstChild，但是这篇文章的目的是介绍 DOM API
let newCity = document.createElement('li');
newCity.textContent = 'San Francisco';
list.insertBefore(newCity, firstCity);
```

## Node.removeChild

该 `Node.removeChild` 方法从 DOM 中删除子节点并且返回已删除的节点。请注意返回的节点已经不再是 DOM 的一部分，但仍然保存在内存中。如果处理不当，可能会导致内存泄漏。

```js
let list = document.querySelector('ul');
let firstItem = list.querySelector('li');
let removedItem = list.removeChild(firstItem);
```

## Node.replaceChild

该方法用于替换父节点中的子节点（并且会返回被替换的子节点）。请注意，如果处理不当，这个方法可能会像 `Node.removeChild` 一样导致内存泄漏。

```js
let list = document.querySelector('ul');
let oldItem = list.querySelector('li');
let newItem = document.createElement('li');
newItem.innerHTML = 'Las Vegas';
let replacedItem = list.replaceChild(newItem, oldItem);
```

## Node.cloneNode

这个方法用于用于创建调用此方法的给定节点的副本。当你需要在页面上创建一个与现有元素相同的新元素时非常有用。它接受一个可选的 `boolean` 类型的参数，该参数用于表示是否对子节点进行深度克隆。

```js
let list = document.querySelector('ul');
let clone = list.cloneNode();
```

## Element.getAttribute / Element.setAttribute

`Element.getAttribute` 该方法返回元素上给定属性的值，与之对应的，`Element.setAttribute` 方法用于设置给定元素上属性的值。

```js
let list = document.querySelector('ul');
list.setAttribute('id', 'my-list');
let id = list.getAttribute('id');
console.log(id); // 输出 my-list
```

## Element.hasAttribute / Element.removeAttribute

`Element.hasAttribute` 方法用于检查给定元素是否具有指定的属性。返回值是 `boolean` 类型。同时，通过调用 `Element.removeAttribute`，我们可以从元素中删除给定名称的属性。

```js
let list = document.querySelector('ul');
if (list.hasAttribute('id')) {
    console.log('list has an id');
    list.removeAttribute('id');
};
```

## Element.insertAdjacentHTML

该方法将制定的文本解析为 HTML，并将 HTML 元素节点插入到 DOM 树中的给定位置。它不会破坏要插入的新 HTML 元素中的现有节点。插入的位置可以是以下字符串之一：

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

例：

```js
var list = document.querySelector('ul');
list.insertAdjacentHTML('afterbegin', '<li id="first-item">First</li>');
```

请注意，使用此方法的时候，我们需要适当的格式化给定的 HTML 元素。

## 结论和了解更多

我希望这篇文章对你有帮助，它会有助于你理解 DOM。正确处理 DOM 树是非常重要的，如果不正确地使用它可能会给你带来一些严重的后果。确保始终进行内存清理并适当格式化 HTML/XML 字符串。

如果需要了解更多，请查看官方 [w3c 页面](https://www.w3.org/TR/?tag=dom)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
