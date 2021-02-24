> * 原文地址：[A Complete Guide of Node.js Buffer](https://medium.com/javascript-in-plain-english/a-complete-guide-of-node-js-buffer-3a38d2d949b1)
> * 原文作者：[Harsh Patel](https://medium.com/@harsh-patel)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/a-complete-guide-of-node-js-buffer.md](https://github.com/xitu/gold-miner/blob/master/article/2021/a-complete-guide-of-node-js-buffer.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[flashhu](https://github.com/flashhu)、[regon-cao](https://github.com/regon-cao)

# Node.js 缓冲区的完整指南

二进制流是大量的二进制数据的集合。由于通常情况下二进制流的大小挺大的，因此二进制流一般不会一起运送，而会在运输前切分成小块然后逐一发送。

当数据处理单元暂时不再接收其他数据流时，剩余的数据将会被保留在缓存中，直到数据处理单元准备好接收更多数据为止。

Node.js 服务器一般需要在文件系统中进行读写，而文件在存储层面而言其实都是二进制流。除此之外，Node.js 还能与 TCP 流一起使用，让 TCP 流在不可靠的互联网络上提供可靠的端到端字节流保障通信。

发送给接收者的数据流会被缓冲，直到接收者准备接收更多要处理的数据为止。这就是 Node.js 处理临时数据部分的工作内容 —— 在 V8 引擎外部管理和存储二进制数据。

让我们一起深入缓冲区（`Buffer`）的各种使用方法，了解更多有关它们的信息以及一起学习如何在 Node.js 程序中使用它们吧。

![](https://cdn-images-1.medium.com/max/2000/0*RbpNfHqVXY39GYeC.png)

## Node.js Buffer 的方法

Node.js 缓冲模块的最大优势，其实就是它是内置于 Node.js 中的，因此我们可以在任何我们想要使用它的地方使用它。

让我们一起浏览一些重要的 Node.js 缓冲模块的方法吧。

#### `Buffer.alloc()`

此方法将创建一个新的缓冲区，但是分配的大小不是固定的。当我们调用此方法时，可以自行分配大小（以字节为单位）。

```js
const buf = Buffer.alloc(6)  // 这会创建一个 6 字节的缓冲区

console.log(buf) // <Buffer 00 00 00 00 00 00>
```

#### `Buffer.byteLength()`

如果我们想要获取缓冲区的长度，我们只需调用 `Buffer.byteLength()` 就行了。

```js
var buf = Buffer.alloc(10)
var buffLen = Buffer.byteLength(buf) // 检查缓冲区长度

console.log(buffLen) // 10
```

#### `Buffer.compare()`

通过使用 `Buffer.compare()` 我们可以比较两个缓冲区，此方法的返回值是 `-1`，`0`，`1` 中的一个。

译者注：`buf.compare(otherBuffer);` 这一句调用会返回一个数字 `-1`，`0`，`1`，分别对应 `buf` 在 `otherBuffer` 之前，之后或相同。

```js
var buf1 = Buffer.from('Harsh')
var buf2 = Buffer.from('Harsg')
var a = Buffer.compare(buf1, buf2)
console.log(a) // 这会打印 0

var buf1 = Buffer.from('a')
var buf2 = Buffer.from('b')
var a = Buffer.compare(buf1, buf2)
console.log(a) // 这会打印 -1


var buf1 = Buffer.from('b')
var buf2 = Buffer.from('a')
var a = Buffer.compare(buf1, buf2)
console.log(a) // 这会打印 1
```

#### `Buffer.concat()`

顾名思义，我们可以使用此函数连接两个缓冲区。当然，就像字符串一样，我们也可以连接两个以上的缓冲区。

```js
var buffer1 = Buffer.from('x')
var buffer2 = Buffer.from('y')
var buffer3 = Buffer.from('z')
var arr = [buffer1, buffer2, buffer3]

console.log(arr)
/* buffer, !concat [ <Buffer 78>, <Buffer 79>, <Buffer 7a> ] */

// 通过 Buffer.concat 方法连接两个缓冲区
var buf = Buffer.concat(arr)

console.log(buf)
// <Buffer 78 79 7a> concat successful
```

#### `Buffer.entries()`

`Buffer.entries()` 会用这一缓冲区的内容创建并返回一个 [index, byte] 形式的迭代器。

```js
var buf = Buffer.from('xyz')

for (a of buf.entries()) {
    console.log(a)
    /* 这个会在控制台输出一个有缓冲区位置与内容的字节的数组 [ 0, 120 ][ 1, 121 ][ 2, 122 ] */
}
```

#### `Buffer.fill()`

我们可以使用 `Buffer.fill()` 这个函数将数据插入或填充到缓冲区中。更多信息请参见下文。

```js
const b = Buffer.alloc(10).fill('a')

console.log(b.toString())
// aaaaaaaaaa
```

#### `Buffer.includes()`

像字符串一样，它将确认缓冲区是否具有该值。我们可以使用 `Buffer.includes()` 方法来实现这一点，给定方法根据搜索返回一个布尔值，即 `true` 或 `false`。

```js
const buf = Buffer.from('this is a buffer')
console.log(buf.includes('this'))
// true

console.log(buf.includes(Buffer.from('a buffer example')))
// false
```

#### `Buffer.isEncoding()`

我们可能知道二进制文件必须进行编码，那么如果我们要检查数据类型是否支持字符编码该怎么办呢？我们可以使用 `Buffer.isEncoding()` 方法进行确认。如果支持，它将返回 `true`。

```js
console.log(Buffer.isEncoding('hex'))
// true

console.log(Buffer.isEncoding('utf-8'))
// true

console.log(Buffer.isEncoding('utf/8'))
// false

console.log(Buffer.isEncoding('hey'))
// false
```

#### `Buffer.slice()`

`buf.slice()` 将用于使用缓冲区的选定元素创建一个新缓冲区 —— 对缓冲区进行切割时，将创建一个新缓冲区，其中包含要在新缓冲区切片中找到的项目的列表。

```js
var a = Buffer.from('uvwxyz');
var b = a.slice(2, 5);

console.log(b.toString());
// wxy
```

#### `Buffer.swapX()`

`Buffer.swapX()` 用于交换缓冲区的字节顺序。使用 `Buffer.swapX()` （此处 `X` 可以为 16, 32, 64）来交换 16 位，32 位和 64 位缓冲区对象的字节顺序。

```js
const buf1 = Buffer.from([0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8])
console.log(buf1)
// <Buffer 01 02 03 04 05 06 07 08>

// 交换 16 位字节顺序
buf1.swap16()
console.log(buf1)
// <Buffer 02 01 04 03 06 05 08 07>

// 交换 32 位字节顺序
buf1.swap32()
console.log(buf1)
// <Buffer 03 04 01 02 07 08 05 06>

// 交换 64 位字节顺序
buf1.swap64()
console.log(buf1)
// <Buffer 06 05 08 07 02 01 04 03>
```

#### `Buffer.json()`

它可以帮助我们从缓冲区创建 JSON 对象，而该方法将返回 JSON 缓冲区对象，

```js
const buf = Buffer.from([0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8]);

console.log(buf.toJSON());
// {"type":"Buffer", data:[1, 2, 3, 4, 5, 6, 7, 8]}
```

## 结论

如果我们需要进一步了解并使用 Node.js 的缓冲区，我们需要对缓冲区以及 Node.js 缓冲区的工作原理有更扎实的基础知识。我们还应该了解为什么我们需要使用 Node.js 缓冲区和各种 Node.js 缓冲区方法的使用。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
