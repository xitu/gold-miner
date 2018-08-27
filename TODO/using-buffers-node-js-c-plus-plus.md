> * 原文地址：[Using Buffers to share data between Node.js and C++](https://community.risingstack.com/using-buffers-node-js-c-plus-plus/)
* 原文作者：[Scott Frees](https://scottfrees.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Jiang Haichao](https://github.com/AceLeeWinnie)
* 校对者：[熊贤仁](https://github.com/FrankXiong), [Lei Guo](https://github.com/futureshine)

# 在 Node.js 和 C++ 之间使用 Buffer 共享数据

使用 Node.js 开发的一个好处是简直能够在 JavaScript 和 原生 C++ 代码之间无缝切换 - 这要得益于 V8 的扩展 API。从 JavaScript 进入 C++ 的能力有时由处理速度驱动，但更多的情况是我们已经有 C++ 代码，而我们想要直接用 JavaScript 调用。

我们可以用（至少）两轴对不同用例的扩展进行分类 - （1）C++ 代码的运行时间，（2）C++ 和 JavaScript 之间数据流量。

![CPU vs. 数据象限](https://scottfrees.com/quadrant.png)

大多数文档讨论的 Node.js 的 C++ 扩展关注于左右象限的不同。如果你在左象限（短处理时间），你的扩展有可能是同步的 - 意思是当调用时 C++ 代码在 Node.js 的事件循环中直接运行。

["#nodejs 允许我们在#javascript 和原生 C++ 代码之间无缝切换" via @RisingStack](https://twitter.com/share?text=%22%23nodejs%20allows%20us%20to%20move%20fairly%20seamlessly%20between%20%23javascript%20and%20native%20C%2B%2B%20code%22%20via%20%40RisingStack;url=https://community.risingstack.com/using-buffers-node-js-c-plus-plus/)

在这个场景中，扩展函数阻塞并等待返回值，意味着其他操作不能同时进行。在右侧象限中，几乎可以确定要用异步模式来设计附加组件。在一个异步扩展函数中，JavaScript 调用函数立即返回。调用代码向扩展函数传入一个回调，扩展函数工作于一个独立工作线程中。由于扩展函数没有阻塞，则避免了 Node.js 事件循环的死锁。

顶部和底部象限的不同时常容易被忽视，但是他们也同样重要。

# V8 vs. C++ 内存和数据

如果你不了解如何写一个原生附件，那么你首先要掌握的是属于 V8 的数据（**可以** 通过 C++ 附件获取的）和普通 C++ 内存分配的区别。 

当我们提到 “属于 V8 的”，指的是持有 JavaScript 数据的存储单元。

这些存储单元是可通过 V8 的 C++ API 访问的，但它们不是普通的 C++ 变量，因为他们只能够通过受限的方式访问。当你的扩展 **可以** 限制为只使用 V8 数据，它就更有可能同样会在普通 C++ 代码中创建自身的变量。这些变量可以是栈或堆变量，且完全独立于 V8。

在 JavaScript 中，基本类型（数字，字符串，布尔值等）是 **不可变的**，一个 C++ 扩展不能够改变与基本类型相连的存储单元。这些基本类型的 JavaScript 变量可以被重新分配到 C++ 创建的 **新存储单元** 中 - 但是这意味着改变数据将会导致 **新** 内存的分配。

在上层象限（少量数据传递），这没什么大不了。如果你正在设计一个无需频繁数据交换的附加组件，那么所有新内存分配的开销可能没有那么大。当扩展更靠近下层象限时，分配/拷贝的开销会开始令人震惊。

一方面，这会增大最高的内存使用量，另一方面，也会 **损耗性能**。

在 JavaScript(V8 存储单元) 和 C++（返回）之间复制所有数据花费的时间通常会牺牲首先运行 C++ 赚来的性能红利！对于在左下象限（低处理，高数据利用场景）的扩展应用，数据拷贝的延迟会把你的扩展引用往右侧象限引导 - 迫使你考虑异步设计。

# V8 内存与异步附件

在异步扩展中，我们在一个工作线程中执行大块的 C++ 处理代码。如果你对异步回调并不熟悉，看看这些教程（[这里](http://blog.scottfrees.com/building-an-asynchronous-c-addon-for-node-js-using-nan) 和 [这里](http://blog.scottfrees.com/c-processing-from-node-js-part-4-asynchronous-addons)）。

异步扩展的中心思想是 **你不能在事件循环线程外访问 V8 （JavaScript）内存**。这导致了新的问题。大量数据必须在工作线程启动前 **从事件循环中** 复制到 V8 内存之外，即扩展的原生地址空间中去。同样地，工作线程产生或修改的任何数据都必须通过执行事件循环（回调）中的代码拷贝回 V8 引擎。如果你致力于创建高吞吐量的 Node.js 应用，你应该避免花费过多的时间在事件循环的数据拷贝上。

![为 C++ 工作线程创建输入输出拷贝](https://raw.githubusercontent.com/freezer333/node-v8-workers/master/imgs/copying.gif)

理想情况下，我们更倾向于这么做：

![从 C++ 工作线程中直接访问 V8 数据](https://raw.githubusercontent.com/freezer333/node-v8-workers/master/imgs/inplace.gif)

# Node.js Buffer 来救命

这里有两个相关的问题。

1. 当使用同步扩展时，除非我们不改变/产生数据，那么可能会需要花费大量时间在 V8 存储单元和老的简单 C++ 变量之间移动数据 - 十分费时。
2. 当使用异步扩展时，理想情况下我们应该尽可能减少事件轮询的时间。这就是问题所在 - 由于 V8 的多线程限制，我们 **必须** 在事件轮询线程中进行数据拷贝。

Node.js 里有一个经常会被忽视的特性可以帮助我们进行扩展开发 - `Buffer`。[Nodes.js 官方文档](https://nodejs.org/api/buffer.html) 在此。

> Buffer 类的实例与整型数组类似，但对应的是 V8 堆外大小固定，原始内存分配空间。

这不就是我们一直想要的吗 - Buffer 里的数据 **并不存储在 V8 存储单元内**，不受限于 V8 的多线程规则。这意味着可以通过异步扩展启动的 C++ 工作线程与 Buffer 进行交互。

## Buffer 是如何工作的

Buffer 存储原始的二进制数据，可以通过 Node.js 的读文件和其他 I/O 设备 API 访问。

借助 Node.js 文档里的一些例子，可以初始化指定大小的 buffer，指定预设值的 buffer，由字节数组创建的 buffer 和 由字符串创建的 buffer。


    // 10 个字节的 buffer：const buf1 = Buffer.alloc(10);

    // 10 字节并初始化为 1 的 buffer：const buf2 = Buffer.alloc(10, 1);

    //包含 [0x1, 0x2, 0x3] 的 buffer：const buf3 = Buffer.from([1, 2, 3]);

    // 包含 ASCII 字节 [0x74, 0x65, 0x73, 0x74] 的 buffer：const buf4 = Buffer.from('test');

    // 从文件中读取 buffer：const buf5 = fs.readFileSync("some file");

Buffer 能够传回传统 JavaScript 数据（字符串）或者写回文件，数据库，或者其他 I/O 设备中。

## C++ 中如何访问 Buffer

构建 Node.js 的扩展时，最好是通过使用 NAN（Node.js 原生抽象）API 启动，而不是直接用 V8 API 启动 - 后者可能是一个移动目标。网上有许多用 NAN 扩展启动的教程 - 包括 NAN 代码库自己的 [例子](https://github.com/nodejs/nan#example)。我也写过很多 [教程](http://blog.scottfrees.com/building-an-asynchronous-c-addon-for-node-js-using-nan)，在我的 [电子书](https://scottfrees.com/ebooks/nodecpp/) 里藏得比较深。

首先，来看看扩展程序如何访问 JavaScript 发送给它的 Buffer。我们会启动一个简单的 JS 程序并引入稍后创建的扩展。

```javascript
    'use strict';  

    // 先引入稍后创建的扩展 
    const addon = require('./build/Release/buffer_example');

    // 在 V8 之外分配内存，预设值为 ASCII 码的 "ABC"
    const buffer = Buffer.from("ABC");

    // 同步，每个字符旋转 +13
    addon.rotate(buffer, buffer.length, 13);

    console.log(buffer.toString('ascii'));
```

"ABC" 进行 ASCII 旋转 13 后，期望输出是 "NOP"。来看看扩展！它由三个文件（方便起见，都在同一目录下）组成。

```
// binding.gyp
{
  "targets": [
    {
        "target_name": "buffer_example",
        "sources": [ "buffer_example.cpp" ],
        "include_dirs" : ["<!(node -e \"require('nan')\")"]
    }
  ]
}

```

```json
//package.json
{
  "name": "buffer_example",
  "version": "0.0.1",
  "private": true,
  "gypfile": true,
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
      "nan": "*"
  }
}
```

```
// buffer_example.cpp
#include <nan.h>
using namespace Nan;  
using namespace v8;

NAN_METHOD(rotate) {  
    char* buffer = (char*) node::Buffer::Data(info[0]->ToObject());
    unsigned int size = info[1]->Uint32Value();
    unsigned int rot = info[2]->Uint32Value();

    for(unsigned int i = 0; i < size; i++ ) {
        buffer[i] += rot;
    }   
}

NAN_MODULE_INIT(Init) {  
   Nan::Set(target, New<String>("rotate").ToLocalChecked(),
        GetFunction(New<FunctionTemplate>(rotate)).ToLocalChecked());
}

NODE_MODULE(buffer_example, Init)
```


最有趣的文件就是 `buffer_example.cpp`。注意我们用了 `node:Buffer` 的 `Data` 方法来把传入扩展的第一个参数转换为字符数组。现在我们能用任何觉得合适的方式来操作数组了。在本例中，我们仅仅执行了文本的 ASCII 码旋转。要注意这没有返回值，Buffer 的关联内存已经被修改了。

通过 `npm install` 构建扩展。`package.json` 会告知 npm 下载 NAN 并使用 `binding.gyp` 文件构建扩展。运行 index.js 会返回期望的 "NOP" 输出。

我们还可以在扩展里创建 **新** buffer。修改 rotate 函数增加输入，并返回减小相应数值后生成的字符串 buffer。

```
NAN_METHOD(rotate) {  
    char* buffer = (char*) node::Buffer::Data(info[0]->ToObject());
    unsigned int size = info[1]->Uint32Value();
    unsigned int rot = info[2]->Uint32Value();

    char * retval = new char[size];
    for(unsigned int i = 0; i < size; i++ ) {
        retval[i] = buffer[i] - rot;
        buffer[i] += rot;
    }   

   info.GetReturnValue().Set(Nan::NewBuffer(retval, size).ToLocalChecked());
}
```    

```javascript
var result = addon.rotate(buffer, buffer.length, 13);

console.log(buffer.toString('ascii'));  
console.log(result.toString('ascii'));
```


现在结果 buffer 是 '456'。注意 NAN 的 `NewBuffer` 方法的使用，它包装了 Node buffer 里 `retval` 数据的动态分配。这么做会 **转让这块内存的使用权** 给 Node.js，所以当 buffer 越过 JavaScript 作用域时 `retval` 的关联内存将会（通过调用 `free`）重新声明。稍后会有更多关于这一点的解释 - 毕竟我们不希望总是重新声明。

你可以在 [这里](https://github.com/nodejs/nan/blob/master/doc/buffers.md) 找到 NAN 如何处理 buffer 的更多信息。

# 🌰 ：PNG 和 BMP 图片处理

上面的例子非常基础，没什么兴奋点。来看个更具有实操性的例子 - C++ 图片处理。如果你想要拿到上例和本例的全部源码，请到我的 GitHub 仓库 [https://github.com/freezer333/nodecpp-demo](https://github.com/freezer333/nodecpp-demo)，代码在 'buffers' 目录下。

图片处理用 C++ 扩展处理再合适不过，因为它耗时，CPU 密集，许多处理方法并行，而这些正是 C++ 所擅长的。本例中我们会简单地将图片由 png 格式转换为 bmp 格式。

> png 转换 bmp **不是** 特别耗时，使用扩展可能有点大材小用了，但能很好的实现示范目的。如果你在找纯 JavaScript 进行图片处理（包括不止 png 转 bmp）的实现方式，可以看看 JIMP，[https://www.npmjs.com/package/jimp](https://www.npmjs.com/package/jimp)[https://www.npmjs.com/package/jimp](https://www.npmjs.com/package/jimp)。

有许多开源 C++ 库可以帮我们做这件事。我要使用的是 LodePNG，因为它没有依赖，使用方便。LodePNG 在 [http://lodev.org/lodepng/](http://lodev.org/lodepng/)，它的源码在 [https://github.com/lvandeve/lodepng](https://github.com/lvandeve/lodepng)。多谢开发者 Lode Vandevenne 提供了这么好用的库!

## 设置扩展

我们要创建以下目录结构，包括从 [https://github.com/lvandeve/lodepng](https://github.com/lvandeve/lodepng) 下载的源码，也就是 `lodepng.h` 和 `lodepng.cpp`。

```
    /png2bmp
     |
     |--- binding.gyp
     |--- package.json
     |--- png2bmp.cpp  # the add-on
     |--- index.js     # program to test the add-on
     |--- sample.png   # input (will be converted to bmp)
     |--- lodepng.h    # from lodepng distribution
     |--- lodepng.cpp  # From loadpng distribution
```

`lodepng.cpp` 包含所有进行图片处理必要的代码，我不会就其工作细节进行讨论。另外，lodepng 包囊括了允许你指定在 pnp 和 bmp 之间进行转换的简单代码。我对它进行了一些小改动并放入扩展源文件 `png2bmp.cpp` 中，马上我们就会看到。

在深入扩展之前来看看 JavaScript 程序：

```javascript
    'use strict';  
    const fs = require('fs');  
    const path = require('path');  
    const png2bmp = require('./build/Release/png2bmp');

    const png_file = process.argv[2];  
    const bmp_file = path.basename(png_file, '.png') + ".bmp";  
    const png_buffer = fs.readFileSync(png_file);

    const bmp_buffer = png2bmp.getBMP(png_buffer, png_buffer.length);  
    fs.writeFileSync(bmp_file, bmp_buffer);
```

这个程序把 png 图片的文件名作为命令行参数传入。调用了 `getBMP` 扩展函数，该函数接受包含 png 文件的 buffer 和它的长度。此扩展是 **同步** 的，在稍后我们也会看到异步版本。

这是 `package.json` 文件，设置了 `npm start` 命令来调用 `index.js` 程序并传入 `sample.png` 命令行参数。这是一张普通的图片。

```json
    {
      "name": "png2bmp",
      "version": "0.0.1",
      "private": true,
      "gypfile": true,
      "scripts": {
        "start": "node index.js sample.png"
      },
      "dependencies": {
          "nan": "*"
      }
    }
```

![](https://scottfrees.com/sample.png)

这是 `binding.gyp` 文件 - 在标准文件的基础上设置了一些编译器标识用于编译 lodepng。还包括了 NAN 必要的引用。

    {
      "targets": [
        {
          "target_name": "png2bmp",
          "sources": [ "png2bmp.cpp", "lodepng.cpp" ],
          "cflags": ["-Wall", "-Wextra", "-pedantic", "-ansi", "-O3"],
          "include_dirs" : ["<!(node -e \"require('nan')\")"]
        }
      ]
    }


`png2bmp.cpp` 主要包括了 V8/NAN 代码。不过，它也有一个图片处理通用函数 - `do_convert`，从 lodepng 的 png 转 bmp 例子里采纳过来的。

`encodeBMP` 函数接受 `vector<unsigned char>` 参数用于输入数据（png 格式）和 `vector<unsigned char>` 参数来存放输出数据（bmp 格式，直接参照 lodepng 的例子。

这是这两个函数的全部代码。细节对于理解扩展的 `Buffer` 对象不重要，包含进来是为了程序完整性。扩展程序入口会调用 `do_convert`。

```
    ~~~~~~~~<del>{#binding-hello .cpp}
    /*
    ALL LodePNG code in this file is adapted from lodepng's  
    examples, found at the following URL:  
    https://github.com/lvandeve/lodepng/blob/  
    master/examples/example_bmp2png.cpp'  
    */void encodeBMP(std::vector<unsigned char>& bmp,  
      const unsigned char* image, int w, int h)
    {
      //3bytes per pixel used for both input and output.
      int inputChannels = 3;
      int outputChannels = 3;

      //bytes 0-13bmp.push_back('B'); bmp.push_back('M'); //0: bfType
    bmp.push_back(0); bmp.push_back(0); bmp.push_back(0); bmp.push_back(0); bmp.push_back(0); bmp.push_back(0); //6: bfReserved1
    bmp.push_back(0); bmp.push_back(0); //8: bfReserved2
    bmp.push_back(54 % 256); bmp.push_back(54 / 256); bmp.push_back(0); bmp.push_back(0);

      //bytes 14-53bmp.push_back(40); bmp.push_back(0); bmp.push_back(0); bmp.push_back(0);  //14: biSize
    bmp.push_back(w % 256); bmp.push_back(w / 256); bmp.push_back(0); bmp.push_back(0); //18: biWidth
    bmp.push_back(h % 256); bmp.push_back(h / 256); bmp.push_back(0); bmp.push_back(0); //22: biHeight
    bmp.push_back(1); bmp.push_back(0); //26: biPlanes
    bmp.push_back(outputChannels * 8); bmp.push_back(0); //28: biBitCount
    bmp.push_back(0); bmp.push_back(0); bmp.push_back(0); bmp.push_back(0);  //30: biCompression
    bmp.push_back(0); bmp.push_back(0); bmp.push_back(0); bmp.push_back(0);  //34: biSizeImage
    bmp.push_back(0); bmp.push_back(0); bmp.push_back(0); bmp.push_back(0);  //38: biXPelsPerMeter
    bmp.push_back(0); bmp.push_back(0); bmp.push_back(0); bmp.push_back(0);  //42: biYPelsPerMeter
    bmp.push_back(0); bmp.push_back(0); bmp.push_back(0); bmp.push_back(0);  //46: biClrUsed
    bmp.push_back(0); bmp.push_back(0); bmp.push_back(0); bmp.push_back(0);  //50: biClrImportant

      int imagerowbytes = outputChannels * w;
      //must be multiple of 4
      imagerowbytes = imagerowbytes % 4 == 0 ? imagerowbytes :
                imagerowbytes + (4 - imagerowbytes % 4);

      for(int y = h - 1; y >= 0; y--)
      {
        int c = 0;
        for(int x = 0; x < imagerowbytes; x++)
        {
          if(x < w * outputChannels)
          {
            int inc = c;
            //Convert RGB(A) into BGR(A)
    if(c == 0) inc = 2;elseif(c == 2) inc = 0;bmp.push_back(image[inputChannels
                * (w * y + x / outputChannels) + inc]);
          }
          elsebmp.push_back(0);
          c++;if(c >= outputChannels) c = 0;
        }
      }

      // Fill in the size
      bmp[2] = bmp.size() % 256;bmp[3] = (bmp.size() / 256) % 256;bmp[4] = (bmp.size() / 65536) % 256;bmp[5] = bmp.size() / 16777216;
    }

    bool do_convert(  
      std::vector<unsigned char> & input_data,
      std::vector<unsigned char> & bmp)
    {
      std::vector<unsigned char> image; //the raw pixels
      unsigned width, height;
      unsigned error = lodepng::decode(image, width,
        height, input_data, LCT_RGB, 8);if(error) {
        std::cout << "error " << error << ": "
                  << lodepng_error_text(error)
                  << std::endl;
        return false;
      }
      encodeBMP(bmp, &image[0], width, height);
      return true;
    }
    </del>~~~~~~~~
```

Sorry... 代码太长了，但对于理解运行机制很重要！把这些代码在 JavaScript 里运行一把看看。

## 同步 Buffer 处理

当我们在 JavaScript 里，png 图片数据会被真实读取，所以会作为 Node.js 的 `Buffer` 传入。我们用 NAN 访问 buffer 自身。这里是同步版本的完整代码：

```
    NAN_METHOD(GetBMP) {  
        unsigned char*buffer = (unsigned char*) node::Buffer::Data(info[0]->ToObject());  
        unsigned int size = info[1]->Uint32Value();

        std::vector<unsigned char> png_data(buffer, buffer + size);
        std::vector<unsigned char> bmp;

        if ( do_convert(png_data, bmp)) {
            info.GetReturnValue().Set(
                NewBuffer((char *)bmp.data(), bmp.size()/*, buffer_delete_callback, bmp*/).ToLocalChecked());
        }
    }  

    NAN_MODULE_INIT(Init) {  
       Nan::Set(target, New<String>("getBMP").ToLocalChecked(),
            GetFunction(New<FunctionTemplate>(GetBMP)).ToLocalChecked());
    }

    NODE_MODULE(png2bmp, Init)
```

在 `GetBMP` 函数里，我们用熟悉的 `Data` 方法打开 buffer，所以我们能够像普通字符数组一样处理它。接着，基于输入构建一个 `vector`，才能够传入上面列出的 `do_convert` 函数。一旦 `bmp` 向量被 `do_convert` 函数填满，我们会把它包装进 `Buffer` 里并返回 JavaScript。

这里有个问题：返回的 buffer 里的数据在 JavaScript 使用之前可能会被删除。为啥？因为当 `GetBMP` 函数返回时，`bmp` 向量要传出作用域。C++ 向量语义当向量传出作用域时，向量析构函数会删除向量里所有的数据 - 在本例中，bmp 数据也会被删掉！这是个大问题，因为回传到 JavaScript 的 `Buffer` 里的数据会被删掉。这最后会使程序崩溃。

幸运的是，`NewBuffer` 的第三和第四个可选参数可控制这种情况。

第三个参数是当 `Buffer` 被 V8 垃圾回收结束时调用的回调函数。记住，`Buffer` 是 JavaScript 对象，数据存储在 V8 之外，但是对象本身受到 V8 的控制。

从这个角度来看，就能解释为什么回调有用。当 V8 销毁 buffer 时，我们需要一些方法来释放创建的数据 - 这些数据可以通过第一个参数传入回调函数中。回调的信号由 NAN 定义 - `Nan::FreeCallback()`。第四个参数则提示重新分配内存地址，接着我们就可以随便使用。

因为我们的问题是向量包含 bitmap 数据会传出作用域，我们可以 **动态** 分配向量，并传入回调，当 `Buffer` 被垃圾回收时能够被正确删除。

以下是新的 `delete_callback`，与新的 `NewBuffer` 调用方法。 把真实的指针传入向量作为一个信号，这样它就能够被正确删除。

```
    void buffer_delete_callback(char* data, void* the_vector){  
      deletereinterpret_cast<vector<unsigned char> *> (the_vector);
    }

    NAN_METHOD(GetBMP) {

      unsigned char*buffer =  (unsigned char*) node::Buffer::Data(info[0]->ToObject());
      unsigned int size = info[1]->Uint32Value();

      std::vector<unsigned char> png_data(buffer, buffer + size);
      std::vector<unsigned char> * bmp = new vector<unsigned char>();

      if ( do_convert(png_data, *bmp)) {
          info.GetReturnValue().Set(
              NewBuffer(
                (char *)bmp->data(),
                bmp->size(),
                buffer_delete_callback,
                bmp)
                .ToLocalChecked());
      }
    }
```

`npm install` 和 `npm start` 运行程序，目录下会生成 `sample.bmp` 文件，和 `sample.png` 非常相似 - 仅仅文件大小变大了（因为 bmp 压缩远没有 png 高效）。

## 异步 Buffer 处理

接着开发一个 png 转 bitmap 转换器的异步版本。使用 `Nan::AsyncWorker` 在一个 C++ 线程中执行真正的转换方法。通过使用 `Buffer` 对象，我们能够避免复制 png 数据，这样我们只需要拿到工作线程可访问的底层数据的指针。同样的，工作线程产生的数据（`bmp` 向量），也能够在不复制数据情况下用于创建新的 `Buffer`。

```
    class PngToBmpWorker : public AsyncWorker {
        public:
        PngToBmpWorker(Callback * callback,
            v8::Local<v8::Object> &pngBuffer, int size)
            : AsyncWorker(callback) {
            unsigned char*buffer =
              (unsigned char*) node::Buffer::Data(pngBuffer);

            std::vector<unsigned char> tmp(
              buffer,
              buffer +  (unsigned int) size);

            png_data = tmp;
        }
        voidExecute(){
           bmp = new vector<unsigned char>();
           do_convert(png_data, *bmp);
        }
        voidHandleOKCallback(){
            Local<Object> bmpData =
                   NewBuffer((char *)bmp->data(),
                   bmp->size(), buffer_delete_callback,
                   bmp).ToLocalChecked();
            Local<Value> argv[] = { bmpData };
            callback->Call(1, argv);
        }

        private:
            vector<unsigned char> png_data;
            std::vector<unsigned char> * bmp;
    };

    NAN_METHOD(GetBMPAsync) {  
        int size = To<int>(info[1]).FromJust();
        v8::Local<v8::Object> pngBuffer =
          info[0]->ToObject();

        Callback *callback =
          new Callback(info[2].As<Function>());

        AsyncQueueWorker(
          new PngToBmpWorker(callback, pngBuffer , size));
    }
```

我们新的 `GetBMPAsync` 扩展函数首先解压缩从 JavaScript 传入的 buffer，接着初始化并用 NAN API 把新的 `PngToBmpWorker` 工作线程入队。这个工作线程对象的 `Execute` 方法在转换结束时被工作线程内的 `libuv` 调用。当 `Execute` 函数返回，`libuv` 调用 Node.js 事件轮询线程的 `HandleOKCallback` 方法，创建一个 buffer 并调用 JavaScript 传入的回调函数。

现在我们能够在 JavaScript 中使用这个扩展函数了：

```
    png2bmp.getBMPAsync(png_buffer,  
      png_buffer.length,
      function(bmp_buffer) {
        fs.writeFileSync(bmp_file, bmp_buffer);
    });
```

# 总结

本文有两个核心卖点：

1.
不能忽视 V8 存储单元和 C++ 变量之间的数据拷贝消耗。如果你不注意，本来你认为把工作丢进 C++ 里执行可以提高的性能，就又被轻易消耗了。

2.
Buffer 提供了一个在 JavaScript 和 C++ 共享数据的方法，这样避免了数据拷贝。

我希望通过旋转 ASCII 文本的简单例子，和同步与异步进行图片转换实战使用 Buffer 很简单。希望本文对你提升扩展应用的性能有所帮助！

再次提醒，本文内的所有代码均能在 [https://github.com/freezer333/nodecpp-demo](https://github.com/freezer333/nodecpp-demo) 中找到，位于 "buffers" 目录下。

如果你正在寻找关于如何设计 Node.js 的 C++ 扩展的小贴士，可以访问我的 [C++ 和 Node.js 一体化电子书](https://scottfrees.com/ebooks/nodecpp/)。
