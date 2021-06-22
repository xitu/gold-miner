> * 原文地址：[JavaScript Typed Arrays](https://blog.bitsrc.io/javascript-typed-arrays-ccfa5ae8838d)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/javascript-typed-arrays.md](https://github.com/xitu/gold-miner/blob/master/article/2021/javascript-typed-arrays.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[KimYang](https://github.com/KimYangOfCat)、[Kimhooo](https://github.com/Kimhooo)

# JavaScript 类型化数组

![图源 [Pierre Bamin](https://unsplash.com/@bamin?utm_source=juejin&utm_medium=referral)，出自 [Unsplash](https://unsplash.com?utm_source=juejin&utm_medium=referral)](https://cdn-images-1.medium.com/max/10992/0*u7yLuqz5vOYfScJQ)

在 JavaScript 这门语言中，我们所有人都必须对数组足够熟悉，知晓数组本质上是动态的，并且可以容纳任何 JavaScript 对象。不过，如果你曾经使用过类似于 C 语言这样的其他语言，你应该知道其数组本质上不是动态的。而且你只能在该数组中存储特定的数据类型，毕竟从性能角度来看，这可以确保数组效率更高。但数组的动态化与存储信息类型的多样化其实并没有使 JavaScript 数组效率低下。在 JavaScript 引擎优化的帮助下，JavaScript 中数组的执行速度其实非常快。

随着 Web 应用程序功能越来越强大，我们开始需要让 Web 应用程序处理和操纵原始二进制数据。JavaScript 数组无法处理这些原始二进制数据，也因此我们引入了 JavaScript 的类型化数组。

## 类型化数组

类型化数组是与数组非常相似的对象，但是它提供了一种将原始二进制数据写入内存缓冲区的机制。所有主要浏览器均很好地支持此功能，并且 ES6 已将其集成到 JavaScript 核心框架中，也可以访问诸如 `map()`、`filter()` 等 Array 方法。我强烈建议你浏览本文结尾处提到的资源，以更深入了解类型化数组。

### 组成

类型化数组由两个主要部分组成，`Buffer` 和 `View`。

#### 缓冲区

`Buffer` 是 `ArrayBuffer` 类型的对象，表示一个数据块。此原始二进制数据块无法被单独访问或修改。你可能好奇，无法访问或修改的数据对象的能有什么用途。实际上视图是缓冲区的读写接口。

#### 视图

`View` 是一个对象，允许你访问和修改存储在 `ArrayBuffer` 中的原始二进制内容。一般来说有两种视图。

#### `TypedArray` 对象的实例

这些类型的对象与普通数组非常相似，但是仅存储单一类型的数值数据。诸如 `Int8`、`Uint8`、`Int16`、`Float32` 就是类型化数组的数据类型。类型中的数字表示为数据类型分配的位数。例如，`Int8` 表示 8 位的整数。

> 你可以阅读 [参考文档](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Typed_arrays#%E7%B1%BB%E5%9E%8B%E6%95%B0%E7%BB%84%E8%A7%86%E5%9B%BE) 来详细了解类型化数组的数据类型。

#### `DataView` 对象的实例

`DataView` 是一个低级接口，提供了一个 `getter` / `setter` API 来读取和写入任意数据到缓冲区。这很大程度上方便了我们的开发，尤其是需要在单个类型化数组中处理多种数据类型时。

使用 `DataView` 的另一个好处是，它可以让你控制数据的字节序 —— 类型化数组使用平台的字节序。当然如果你的程序运行在本地，这将不是问题，因为你的设备将使用与输入数组相同的字节序。在大多数情况下，你的类型化数组将为低端字节序，因为英特尔采取的是小端字节序。由于英特尔在计算机处理器中非常普遍，因此大多数时候不会出现问题。但是，如果将小端字节序编码的数据传输到使用大端字节序编码的设备，则会导致读取时候的错误，最终可能导致数据的丢失。由于 `DataView` 使你可以控制字节序的方向，因此你可以在必要时使用它。

## 是什么使它们与普通数组不同

如前所述，普通的 JavaScript 数组已通过 JavaScript 引擎进行了优化，你没必要为了提升性能而使用类型化数组，因为这不会给你带来太多升级。但是有些特性使类型化数组不同于普通数组，这才可能是你选择它们的原因。

* 让你能够处理原始二进制数据
* 由于它们处理的数据类型是有限的，因此与普通数组相比，你的引擎更易优化类型化数组，因为普通数组的优化其实是一个非常复杂的过程。
* 不能保证普通数组永远都能得到优化，因为你的引擎可能因各种原因决定不进行优化。

## 在 Web 开发中的用途

### XMLHttpRequest API

你可以根据你的响应类型以 `ArrayBuffer` 形式接收数据响应。

```js
const xhr = new XMLHttpRequest();
xhr.open('GET', exampleUrl);
xhr.responseType = 'arraybuffer';

xhr.onload = function () {
    const arrayBuffer = xhr.response;
    // 处理数据
};

xhr.send();
```

### Fetch API

类似于 XMLHttpRequest API，Fetch API 还允许你在 `ArrayBuffer` 中接收响应。你只需在 fetch API 响应中使用 `arrayBuffer()` 方法，你就能够收到一个使用 `ArrayBuffer` 解析的 `Promise`。

```js
fetch(url)
.then(response => response.arrayBuffer())
.then(arrayBuffer => {
   // 处理数据
});
```

### HTML Canvas

HTML5 Canvas 元素使你可以渲染动态的 2D 形状和位图图像。该元素仅充当图形的容器，而图形则是在 JavaScript 的帮助下绘制。

canvas 的 2D Context 使你可以将位图数据作为 `Uint8ClampedArray` 的实例进行检索。让我们看一下 Axel 博士提供的示例代码：

```js
const canvas = document.getElementById('my_canvas');
const context = canvas.getContext('2d');
const imageData = context.getImageData(0, 0, canvas.width, canvas.height);
const uint8ClampedArray = imageData.data;
```

### WebGL

WebGL 允许你渲染高性能的交互式 3D 和 2D 图形。它在很大程度上依赖于类型化数组，因为它会处理原始像素数据以在画布上输出必要的图形。

你可以在 [这篇文章](https://blog.bitsrc.io/understanding-webgl-51ab81ccb48c) 中阅读有关 WebGL 基础的更多信息。

### Web Socket

Web Socket 允许你以 Blob 或数组缓冲区的形式发送和接收原始二进制数据。

```js
const socket = new WebSocket("ws://localhost:8080");
socket.binaryType = "arraybuffer";

// 监听 message
socket.addEventListener("message", function (event) {
    const view = new DataView(event.data);
    // 处理接收数据
});

// 发送二进制数据
socket.addEventListener('open', function (event) {
    const typedArray = new Uint16Array(7);
    socket.send(typedArray.buffer);
});
```

尽管初学者可能不需要详细了解类型化数组，但是当你进入中高级 JavaScript 开发的时候，它们是必不可少的。这主要是因为你可能要开发需要使用类型化数组的更复杂的应用程序。

要深入了解类型化数组，请浏览下面附带的资源链接。

感谢你的阅读，祝你编程愉快！！

## 资源

* [JavaScript 类型化数组 - MDN 文档](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Typed_arrays)
* [Exploring JS by Dr. Axel](https://exploringjs.com/es6/ch_typed-arrays.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
