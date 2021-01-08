> * 原文地址：[A Complete Guide of Node.js Buffer](https://medium.com/javascript-in-plain-english/a-complete-guide-of-node-js-buffer-3a38d2d949b1)
> * 原文作者：[Harsh Patel](https://medium.com/@harsh-patel)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/a-complete-guide-of-node-js-buffer.md](https://github.com/xitu/gold-miner/blob/master/article/2021/a-complete-guide-of-node-js-buffer.md)
> * 译者：
> * 校对者：

# A Complete Guide of Node.js Buffer

Binary streaming is a collection of large amounts of binary data. Due to their large size, binary streams are not shipped together; break into small pieces before shipping.

When a data processing unit does not accept other data streams, the excess data is kept in a cache until the data processing unit is ready to receive more data.

Node.js servers usually require reading and writing in the file system and, of course, files are stored in binaries. Also, Node.js works with TCP streams, which protect recipients’ communications before sending binary data to small chunks.

The data streams sent to the recipient need to be buffer until the recipient is ready to take more pieces of data to be processed. This is where the temporary Node.js section operates — manages and stores binary data outside the V8 engine.

Let’s jump into the various buffer methods to understand more, and how we can use them in our Node.js program.

![](https://cdn-images-1.medium.com/max/2000/0*RbpNfHqVXY39GYeC.png)

## Node.js buffer methods

A good thing about Node.js buffer module is that it is pre installed, so you can use it anywhere.

Let’s go through some important Node.js buffer methods.

#### Buffer.alloc()

This method will create a new buffer, but the size is not fixed. When you call this method at that time you can assign the size in bytes.

```js
const buf = Buffer.alloc(6)  //This will create 6 bytes buffer

console.log(buf)
//<Buffer 00 00 00 00 00 00>
```

#### Buffer.byteLength()

Now if you want to get the length of a buffer then simply call `Buffer.byteLength()`

```js
var buf = Buffer.alloc(10)

//check the length
var buffLen = Buffer.byteLength(buf)

console.log(buffLen)
//<10>
```

#### Buffer.compare()

With `Buffer.compare()` you can compare two buffers and check that it’s identical or not. Return of this method will be one of this`-1`, `0`, or `1`,

```js
var buf1 = Buffer.from('Harsh')
var buf2 = Buffer.from('Harsg')
var a = Buffer.compare(buf1, buf2)
console.log(a) //it will print 0 

var buf1 = Buffer.from('a')
var buf2 = Buffer.from('b')
var a = Buffer.compare(buf1, buf2)
console.log(a) //it will print -1


var buf1 = Buffer.from('b')
var buf2 = Buffer.from('a')
var a = Buffer.compare(buf1, buf2)
console.log(a) //it will print 1
```

#### Buffer.concat

As the name indicate you can join two buffer with this method. Like string, you can join more than one-two buffers as well.

```js
var buffer1 = Buffer.from('x')
var buffer2 = Buffer.from('y')
var buffer3 = Buffer.from('z')
var arr = [buffer1, buffer2, buffer3]

console.log(arr)
/*buffer, !concat [ <Buffer 78>, <Buffer 79>, <Buffer 7a> ]*/

//concatenate buffer with Buffer.concat method
var buf = Buffer.concat(arr)

console.log(buf)
//<Buffer 78 79 7a> concat successful
```

#### buf.entries()

`buf.entries()`will help you to loop through a buffer,

```js
var buf = Buffer.from('xyz')

for (a of buf.entries()) {
  console.log(a)
  /*This will console arrays of indexes and byte of buffer content \[ 0, 120 \][ 1, 121 ][ 2, 122 ]*/
}
```

#### Buffer.fill()

As the name indicates, it helps you to insert or fill data into a buffer using the `Buffer.fill()` method. For more see below,

```js
const b = Buffer.alloc(10).fill('a')

console.log(b.toString())
//aaaaaaaaaa
```

#### buff.includes()

Like string it will identify that If a buffer has that value or not. you can use the `buff.includes()` method to achieve that, given method return a boolean value, `true` or `false` depending on the search.

```js
const buf = Buffer.from('this is a buffer')
console.log(buf.includes('this'))
// true

console.log(buf.includes(Buffer.from('a buffer example')))
// false
```

#### Buffer.isEncoding()

As you might know that binaries have to be encoded, To check If a data type supports the character encoding or not? You can use `Buffer.isEncoding()` method to confirm. It will return `true` if it supports.

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

#### buf.slice()

`buf.slice()` will be used to create a new buffer from selected elements of a buffer. When you slice a buffer, you create a new buffer with a list of items you want in the new buffer slice.

```js
var a = Buffer.from('uvwxyz');
var b = a.slice(2,5);

console.log(b.toString());
//wxy
```

#### Buffer swap [buf.swapX()]

`buf.swapX()`is used to swap the byte order of a buffer. Buffer has these methods `buf.swapX()`(here X can be 16,32,64) to swap the byte order of a 16-bit, 32-bit, and 64-bit buffer object.

```js
const buf1 = Buffer.from([0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8])
console.log(buf1)
// <Buffer 01 02 03 04 05 06 07 08>

//swap byte order to 16 bit
buf1.swap16()
console.log(buf1)
// <Buffer 02 01 04 03 06 05 08 07>

//swap byte order to 32 bit
buf1.swap32()
console.log(buf1)
// <Buffer 03 04 01 02 07 08 05 06>

//swap byte order to 64 bit
buf1.swap64()
console.log(buf1)
// <Buffer 06 05 08 07 02 01 04 03>
```

#### buf.json()

It helps you to create json from a buffer, it will return json buffer object,

```js
const buf = Buffer.from([0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8]);

console.log(buf.toJSON());
//{"type":"Buffer", data:[1,2,3,4,5,6,7,8]}
```

## Conclusion

Now you need to have a solid, basic understanding of a buffer and how Node.js buffer works. You should also understand why you need to use the Node.js buffer section and the various Node.js buffer methods.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
