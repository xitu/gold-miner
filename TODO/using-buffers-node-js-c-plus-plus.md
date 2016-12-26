> * 原文地址：[Using Buffers to share data between Node.js and C++](https://community.risingstack.com/using-buffers-node-js-c-plus-plus/)
* 原文作者：[Scott Frees](https://scottfrees.com/)
* 译文出自：[]()
* 译者：[]()
* 校对者：[]()

# Using Buffers to share data between Node.js and C++

One of the best things about developing with Node.js is the ability to move fairly seamlessly between JavaScript and native C++ code - thanks to the V8's add-on API. The ability to move into C++ is sometimes driven by processing speed, but more often because we already have C++ code and we just want to be able to use it from JavaScript.

We can categorize the different use cases for add-ons along (at least) two axes - (1) amount of processing time we'll spend in the C++ code, and (2) the amount of data flowing between C++ and JavaScript.

![CPU vs. Data quadrant](https://scottfrees.com/quadrant.png)

Most articles discussing C++ add-ons for Node.js are focusing on the differences between the left and right quadrants. If you are in the left quadrants (short processing time), your add-on can possibly be synchronous - meaning the C++ code that executes is running directly in the Node.js event loop when called.

["#nodejs allows us to move fairly seamlessly between #javascript and native C++ code" via @RisingStack](https://twitter.com/share?text=%22%23nodejs%20allows%20us%20to%20move%20fairly%20seamlessly%20between%20%23javascript%20and%20native%20C%2B%2B%20code%22%20via%20%40RisingStack;url=https://community.risingstack.com/using-buffers-node-js-c-plus-plus/)

[Click To Tweet](https://twitter.com/share?text=%22%23nodejs%20allows%20us%20to%20move%20fairly%20seamlessly%20between%20%23javascript%20and%20native%20C%2B%2B%20code%22%20via%20%40RisingStack;url=https://community.risingstack.com/using-buffers-node-js-c-plus-plus/)

In this case, the add-on function is blocks and waits for the return value, meaning no other operations can be done in the meantime. In the right quadrants, you would almost certainly design the add-on using the asynchronous pattern. In an asynchronous add-on function, the calling JavaScript code returns immediately. The calling code passes a callback function to the add-on, and the add-on does its work in a separate worker thread. This avoids locking up the Node.js event loop, as the add-on function does not block.

The difference between the top and bottom quadrants is often overlooked, however they can be just as important.

# V8 vs. C++ memory and data

If you are new to writing native add-ons, one of the first things you must master is the differences between V8-owned data (which you **can** access from C++ add-ons) and normal C++ memory allocations.

When we say "V8-owned", we are referring to the storage cells that hold JavaScript data.

These storage cells are accessible through V8's C++ API, but they aren't ordinary C++ variables since they can only be accessed in limited ways. While your add-on *could* restrict itself to ONLY using V8 data, it will more likely create it's own variables too - in plain old C++. These could be stack or heap variables, and of course are completely independent of V8.

In JavaScript, primitives (numbers, strings, booleans, etc.) are *immutable*, and a C++ add-on can not alter storage cells associated with primitive JavaScript variables. The primitive JavaScript variables can be reassigned to *new storage cells* created by C++ - but this means that changing data will always result in *new* memory allocation.

In the upper quadrant (low data transfer), this really isn't a big deal. If you are designing an add-on that doesn't have a lot of data exchange, then the overhead of all the new memory allocation probably doesn't mean much. As your add-ons move closer to the lower quadrant, the cost of allocation / copying will start to hurt you.

For one, it costs you in terms of peak memory usage, and **it also costs you in performance**!

The time cost of copying all this data between JavaScript (V8 storage cells) to C++ (and back) usually kills the performance benefits you might be getting from running C++ in the first place!For add-ons in the lower left quadrant (low processing, high data usage), the latency associated with data copying can push your add-on towards the right - forcing you to consider an asynchronous design.

# V8 memory and asynchronous add-ons

In asynchronous add-ons we execute the bulk of our C++ processing code in a worker thread. If you are unfamiliar with asynchronous callbacks, you might want to check out a few tutorials (like [here](http://blog.scottfrees.com/building-an-asynchronous-c-addon-for-node-js-using-nan) and [here](http://blog.scottfrees.com/c-processing-from-node-js-part-4-asynchronous-addons)).

A central tenant of asynchronous add-ons is that *you can't access V8 (JavaScript) memory outside the event-loop's thread*. This leads us to our next problem. If we have lots of data, that data must be copied out of V8 memory and into your add-on's native address space *from the event loop's thread*, before the worker thread starts. Likewise, any data produced or modified by the worker thread must be copied back into V8 by code executing in the event loop (in the callback). If you are interested in creating high throughput Node.js applications, you should avoid spending lots of time in the event loop copying data!

![Creating copies for input and output for a C++ worker thread](https://raw.githubusercontent.com/freezer333/node-v8-workers/master/imgs/copying.gif)

Ideally, we'd prefer a way to do this:

![Accessing V8 data directly from C++ worker thread](https://raw.githubusercontent.com/freezer333/node-v8-workers/master/imgs/inplace.gif)

# Node.js Buffers to the rescue

So, we have two somewhat related problems.

1. When working with synchronous add-ons, unless we aren't changing/producing data, it's likely we'll need to spend a lot of time moving our data between V8 storage cells and plain old C++ variables - which costs us.
2. When working with asynchronous add-ons, we ideally should spend as little time in the event loop as possible. This is why we still have a problem - since we *must* do our data copying in the event loop's thread due to V8's multi-threaded restrictions.

This is where an often overlooked feature of Node.js helps us with add-on development - the `Buffer`. Quoting the [Node.js official documentation](https://nodejs.org/api/buffer.html),

> Instances of the Buffer class are similar to arrays of integers but correspond to fixed-sized, raw memory allocations outside the V8 heap.

This is exactly what we are looking for - because the data inside a Buffer is *not stored in a V8 storage cell*, it is not subjected to the multi-threading rules of V8. This means that we can interact with it **in place** from a C++ worker thread started by an asynchronous add-on.

## How Buffers work

Buffers store raw binary data, and they can be found in the Node.js API for reading files and other I/O devices.

Borrowing from some examples in the Node.js documentation, we can create initialized buffers of a specified size, buffers pre-set with a specified value, buffers from arrays of bytes, and buffers from strings.

    // buffer with size 10 bytesconst buf1 = Buffer.alloc(10);

    // buffer filled with 1's (10 bytes)const buf2 = Buffer.alloc(10, 1);

    //buffer containing [0x1, 0x2, 0x3]const buf3 = Buffer.from([1, 2, 3]);

    // buffer containing ASCII bytes [0x74, 0x65, 0x73, 0x74].const buf4 = Buffer.from('test');

    // buffer containing bytes from a fileconst buf5 = fs.readFileSync("some file");


Buffers can be turned back into traditional JavaScript data (strings) or written back out to files, databases, or other I/O devices.

## How to access Buffers in C++

When building an add-on for Node.js, the best place to start is by making use of the NAN (Native Abstractions for Node.js) API rather than directly using the V8 API - which can be a moving target. There are many tutorials on the web for getting started with NAN add-ons - including [examples](https://github.com/nodejs/nan#example) in NAN's code base itself. I've written a bit about it [here](http://blog.scottfrees.com/building-an-asynchronous-c-addon-for-node-js-using-nan), and it's also covered in a lot of depth in my [ebook](https://scottfrees.com/ebooks/nodecpp/).

First, let’s see how an add-on can access a Buffer sent to it from JavaScript. We'll start with a simple JS program that requires an add-on that we'll create in a moment:

    'use strict';  
    // Requiring the add-on that we'll build in a moment...const addon = require('./build/Release/buffer_example');

    // Allocates memory holding ASCII "ABC" outside of V8.const buffer = Buffer.from("ABC");

    // synchronous, rotates each character by +13
    addon.rotate(buffer, buffer.length, 13);

    console.log(buffer.toString('ascii'));


The expected output is "NOP", the ASCII rotation by 13 of "ABC". Let's take a look the add-on! It consists of three files (in the same directory, for simplicity):

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

```
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
// buffer_example.cpp#include<nan.h>usingnamespace Nan;  
usingnamespace v8;

NAN_METHOD(rotate) {  
    char* buffer = (char*) node::Buffer::Data(info[0]->ToObject());
    unsignedint size = info[1]->Uint32Value();
    unsignedint rot = info[2]->Uint32Value();

    for(unsignedint i = 0; i < size; i++ ) {
        buffer[i] += rot;
    }   
}

NAN_MODULE_INIT(Init) {  
   Nan::Set(target, New<String>("rotate").ToLocalChecked(),
        GetFunction(New<FunctionTemplate>(rotate)).ToLocalChecked());
}

NODE_MODULE(buffer_example, Init)
```


The most interesting file is `buffer_example.cpp`. Notice that we've used `node::Buffer`'s `Data` method to convert the first parameter sent to the add-on to a character array. This is now free for us to use in any way we see fit. In this case, we just perform an ASCII rotation of the text. Notice that there is no return value, the memory associated with the Buffer has been modified **in place**.

We can build the add-on by just typing `npm install`. The `package.json` tells npm to download NAN and build the add-on using the `binding.gyp` file. Running it will give us the "NOP" output we expect.

We can also create *new* buffers while inside the add-on. Let's modify the rotate function to increment the input, but return another buffer containing the string resulting from a decrement operation:

```
NAN_METHOD(rotate) {  
    char* buffer = (char*) node::Buffer::Data(info[0]->ToObject());
    unsignedint size = info[1]->Uint32Value();
    unsignedint rot = info[2]->Uint32Value();

    char * retval = newchar[size];
    for(unsignedint i = 0; i < size; i++ ) {
        retval[i] = buffer[i] - rot;
        buffer[i] += rot;
    }   

   info.GetReturnValue().Set(Nan::NewBuffer(retval, size).ToLocalChecked());
}
```    

```
var result = addon.rotate(buffer, buffer.length, 13);

console.log(buffer.toString('ascii'));  
console.log(result.toString('ascii'));
```


Now the resulting buffer will contain '456'. Note the use of NAN's `NewBuffer` function, which wraps the dynamically allocated `retval` array in a Node buffer. Doing so *transfers ownership* of this memory to Node.js, so the memory associated with `retval` will be reclaimed (by calling `free`) when the buffer goes out of scope in JavaScript. More on this issue later - as we don't always want to have it happen this way!

You can find additional information about how NAN handles buffers [here](https://github.com/nodejs/nan/blob/master/doc/buffers.md).

# Example: PNG and BMP Image Processing

The example above is pretty basic and not particularly exciting. Let's turn to a more practical example - image processing with C++. If you want to get the full source code for both the example above and the image processing code below, you can head over to my `nodecpp-demo` repository at [https://github.com/freezer333/nodecpp-demo](https://github.com/freezer333/nodecpp-demo), the code is in the "buffers" directory.

Image processing is a good candidate for C++ add-ons, as it can often be time-consuming, CPU intensive, and some processing techniques have parallelism that C++ can exploit well. In the example we'll look at now, we'll simply convert png formatted data into bmp formatted data .

> Converting a png to bmp is *not* particularly time consuming and it's probably overkill for an add-on, but it's good for demonstration purposes. If you are looking for a pure JavaScript implementation of image processing (including much more than png to bmp conversion), take a look at JIMP at [https://www.npmjs.com/package/jimp](https://www.npmjs.com/package/jimp)[https://www.npmjs.com/package/jimp](https://www.npmjs.com/package/jimp).

There are a good number of open source C++ libraries that can help us with this task. I'm going to use LodePNG as it is dependency free and quite simple to use. LodePNG can be found at [http://lodev.org/lodepng/](http://lodev.org/lodepng/), and it's source code is at [https://github.com/lvandeve/lodepng](https://github.com/lvandeve/lodepng). Many thanks to the developer, Lode Vandevenne for providing such an easy to use library!

## Setting up the add-on

For this add-on, we'll create the following directory structure, which includes source code downloaded from [https://github.com/lvandeve/lodepng](https://github.com/lvandeve/lodepng), namely `lodepng.h` and `lodepng.cpp`.

    /png2bmp
     |
     |--- binding.gyp
     |--- package.json
     |--- png2bmp.cpp  # the add-on
     |--- index.js     # program to test the add-on
     |--- sample.png   # input (will be converted to bmp)
     |--- lodepng.h    # from lodepng distribution
     |--- lodepng.cpp  # From loadpng distribution


`lodepng.cpp` contains all the necessary code for doing image processing, and I will not discuss it's working in detail. In addition, the lodepng distribution contains sample code that allows you to specifically convert between png and bmp. I've adapted it slightly and will put it in the add-ons source code file `png2bmp.cpp` which we will take a look at shortly.

Let's look at what the actual JavaScript program looks like before diving into the add-on code itself:

    'use strict';  
    const fs = require('fs');  
    const path = require('path');  
    const png2bmp = require('./build/Release/png2bmp');

    const png_file = process.argv[2];  
    const bmp_file = path.basename(png_file, '.png') + ".bmp";  
    const png_buffer = fs.readFileSync(png_file);

    const bmp_buffer = png2bmp.getBMP(png_buffer, png_buffer.length);  
    fs.writeFileSync(bmp_file, bmp_buffer);


The program uses a filename for a png image as a command line option. It calls an add-on function `getBMP` which accepts a buffer containing the png file and its length. This add-on is *synchronous*, but we'll take a look at the asynchronous version later on too.

Here's the `package.json`, which is setting up `npm start` to invoke the `index.js` program with a command line argument of `sample.png`. It's a pretty generic image:

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


![](https://scottfrees.com/sample.png)

Here is the `binding.gyp` file - which is fairly standard, other than a few compiler flags needed to compile lodepng. It also includes the requisite references to NAN.

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


`png2bmp.cpp` will mostly contain V8/NAN code. However, it does have one image processing utility function - `do_convert`, adopted from lodepng's png to bmp example code.

The function accepts a `vector<unsigned char>` containing input data (png format) and a `vector<unsigned char>` to put its output (bmp format) data into. That function, in turn, calls `encodeBMP`, which is straight from the lodepng examples.

Here is the full code listing of these two functions. The details are not important to the understanding of the add-ons `Buffer` objects but are included here for completeness. Our add-on entry point(s) will call `do_convert`.

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


Sorry... that listing was long, but it's important to see what's actually going on! Let's get to work bridging all this code to JavaScript.

## Synchronous Buffer Processing

The png image data is actually read when we are in JavaScript, so it's passed in as a Node.js `Buffer`. We'll use NAN to access the buffer itself. Here's the complete code for the synchronous version:

    NAN_METHOD(GetBMP) {  
    unsignedchar*buffer = (unsignedchar*) node::Buffer::Data(info[0]->ToObject());  
        unsignedint size = info[1]->Uint32Value();

        std::vector<unsignedchar> png_data(buffer, buffer + size);
        std::vector<unsignedchar> bmp;

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


In `GetBMP`, we use the familiar `Data` method to unwrap the buffer so we can work with it like a normal character array. Next, we build a `vector` around the input so we can pass it to our `do_convert` function listed above. Once the `bmp` vector is filled in by `do_convert`, we wrap it up in a `Buffer` and return to JavaScript.

So *here is the problem* with this code: The data contained in the buffer we return is likely deleted before our JavaScript gets to use it. Why? Because the `bmp` vector is going to go out of scope as our `GetBMP` function returns. C++ vector semantics hold that when the vector goes out of scope, the vector's destructor deletes all data within the vector - in our case, our bmp data will be deleted as well! This is a huge problem since the `Buffer` we send back to JavaScript will have it's data deleted out from under it. You might get away with this (race conditions are fun right?), but it will eventually cause your program to crash.

Luckily, `NewBuffer` has an optional third and fourth parameter to give us some more control.

The third parameter is a callback which ends up being called when the `Buffer` gets garbage collected by V8. Remember that `Buffer`s are JavaScript objects, whose data is stored outside of V8, but the object itself is under V8's control.

From this perspective, it should make sense that a callback would be handy. When V8 destroys the buffer, we need some way of freeing up the data we have created - which is passed into the callback as its first parameter. The signature of the callback is defined by NAN - `Nan::FreeCallback()`. The fourth parameter is a hint to aid in deallocation, and we can use it however we want.

Since our problem is that the vector containing bitmap data goes out of scope, we can *dynamically* allocate the vector itself instead, and pass it into the free callback where it can be properly deleted when the `Buffer` has been garbage collected.

Below is the new `delete_callback`, along with the new call to `NewBuffer`. I'm sending the actual pointer to the vector as the hint, so it can be deleted directly.

    voidbuffer_delete_callback(char* data, void* the_vector){  
      deletereinterpret_cast<vector<unsignedchar> *> (the_vector);
    }

    NAN_METHOD(GetBMP) {

      unsignedchar*buffer =  (unsignedchar*) node::Buffer::Data(info[0]->ToObject());
      unsignedint size = info[1]->Uint32Value();

      std::vector<unsignedchar> png_data(buffer, buffer + size);
      std::vector<unsignedchar> * bmp = newvector<unsignedchar>();

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


Run this program by doing an `npm install` and then an `npm start` and you'll see a `sample.bmp` generated in your directory that looks eerily similar to `sample.png` - just a whole lot bigger (because bmp compression is far less efficient than png).

## Asynchronous Buffer Processing

Let's develop an asynchronous version of the png to bitmap converter. We'll perform the actual conversion in a C++ worker thread, using `Nan::AsyncWorker`. By using `Buffer` objects, we can avoid copying the png data, so we will only need to hold a pointer to the underlying data such that our worker thread can access it. Likewise, the data produced by the worker thread (the `bmp` vector) can be used to create a new `Buffer` without copying data.

    class PngToBmpWorker : public AsyncWorker {
        public:
        PngToBmpWorker(Callback * callback,
            v8::Local<v8::Object> &pngBuffer, int size)
            : AsyncWorker(callback) {
            unsignedchar*buffer =
              (unsignedchar*) node::Buffer::Data(pngBuffer);

            std::vector<unsignedchar> tmp(
              buffer,
              buffer +  (unsignedint) size);

            png_data = tmp;
        }
        voidExecute(){
           bmp = newvector<unsignedchar>();
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
            vector<unsignedchar> png_data;
            std::vector<unsignedchar> * bmp;
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


Our new `GetBMPAsync` add-on function first unwraps the input buffer sent from JavaScript and then initializes and queues a new `PngToBmpWorker` worker , using NAN's API. The worker object's `Execute` method is called by `libuv` inside a worker thread where the conversion is done. When the `Execute` function returns, `libuv` calls the `HandleOKCallback` in the Node.js event loop thread, which creates the buffer and invokes the callback sent from JavaScript.

Now we can utilize this add-on function in JavaScript like this:

    png2bmp.getBMPAsync(png_buffer,  
      png_buffer.length,
      function(bmp_buffer) {
        fs.writeFileSync(bmp_file, bmp_buffer);
    });


# Summary

There were two core takeaways in this post:

1.
You can't ignore the costs of copying data between V8 storage cells and C++ variables. If you aren't careful, you can easily kill the performance boost you might have thought you were getting by dropping into C++ to perform your work!

2.
Buffers offer a way to work with the same data in both JavaScript and C++, thus avoiding the need to create copies.

Using buffers in your add-ons can be pretty painless. I hope I've been able to show you this through a simple demo application that rotates ASCII text, along with more practical synchronous and asynchronous image conversion examples Hopefully, this post helps you boost the performance of your own add-ons!

A reminder, all the code from this post can be found at [https://github.com/freezer333/nodecpp-demo](https://github.com/freezer333/nodecpp-demo), the code is in the "buffers" directory.

If you are looking for more tips on how to design Node.js C++ add-ons, please check out my [ebook on C++ and Node.js Integration](https://scottfrees.com/ebooks/nodecpp/).
