> * 原文地址：[Speed Up Your Angular Projects by 10x With GPU.js](https://betterprogramming.pub/speed-up-your-angular-projects-by-10x-with-gpu-js-92c4b2bad4e3)
> * 原文作者：[Chameera Dulanga](https://medium.com/@chameeradulanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/speed-up-your-angular-projects-by-10x-with-gpu-js.md](https://github.com/xitu/gold-miner/blob/master/article/2021/speed-up-your-angular-projects-by-10x-with-gpu-js.md)
> * 译者：
> * 校对者：

# Speed Up Your Angular Projects by 10x With GPU.js

![Photo by [Lucas Kepner](https://unsplash.com/@lucaskphoto?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/12878/0*rDxYRR86genkrPIK)

As developers, we always seek opportunities to enhance the performance of the applications we build. But when it comes to computationally heavy tasks, our options are minimal, and those tasks depend on CPU performance.

So, what would happen if we combined the power of GPU with our web applications?

In this article, I will show you the steps to integrate GPU programming into your Angular project using [GPU.js](https://github.com/gpujs/gpu.js). I will also make a performance comparison and discuss when you should use GPU and when you should not.

## Using GPU.js With Angular

If you don't know anything about GPU.js, don't worry. I will give the relevant details as the process goes on. Let's start by creating a new Angular project.

### 1. Initializing a new Angular project

To create a new Angular project, you just need to run the `new` command:

```bash
ng new <project-name>
```

If you haven't configured Angular on your machine before, I suggest you follow their [documentation](https://angular.io/docs).

After that, you can run the `ng serve` command and open `[http://localhost:4200/](http://localhost:4200/)` in your browser to test the project.

![](https://cdn-images-1.medium.com/max/3800/1*Ae4A5eiYOynQNWqNdr9aSg.png)

### 2. Installing GPU.js

As I mentioned initially, GPU.js is a JavaScript accelerated library that can be used for general-purpose computation purposes.

Using GPU.js doesn't make your application obsolete if there is no GPU in the running device. It can fall back into the regular JavaScript engine if there is no GPU in the device. So, there won’t be any disadvantage to using GPU.js.

![Source: [GPU.js](https://gpu.rocks/#/)](https://cdn-images-1.medium.com/max/3710/0*gxIob58_QAXfYe3a.png)

Like any other JavaScript library, GPU.js also available in npm or yarn. You can use either of them to install GPU.js:

```bash
npm install gpu.js — save
```

or 

```bash
yarn add gpu.js
```

Now we can start working on our first GPU.js functions.

### 3. Writing the kernel function with GPU.js

I will be making this application write a function to calculate the multiplication of two numbers and feed them with different sizes of number arrays to see their execution time.

Let's start with the GPU function:

```JavaScript
 gpuMultiplyMatrix() {
    const gpu = new GPU();
    const multiplyMatrix = gpu.createKernel(function (a: number[][], b: number[][], matrixSize: number) {
      let sum = 0;
      for (let i = 0; i < matrixSize; i++) {
        sum += a[this.thread.y][i] * b[i][this.thread.x];
      }
      return sum;
    }).setOutput([this.matrixSize, this.matrixSize])

    const startTime = performance.now();
    const resultMatrix = multiplyMatrix(this.matrices[0], this.matrices[1], this.matrixSize);
    const endTime = performance.now();
    this.gpuTime = (endTime - startTime) + " ms";
    console.log("GPU TIME : "+ this.gpuTime);
    this.gpuProduct = resultMatrix as number[][];
  }
```

At the beginning of the function, I have initiated a new GPU object. Then I have created a kernel function named `multiplyMatirx` using the `gpu.createKernel()` function, which is a built-in function in GPU.js.

Two number arrays and the matrix size are passed into that function as input parameters, and multiplication will happen inside that.

JavaScript performance API functions are used to calculate the time and the `performance.now()` function will log the start and end times of the GPU execution.

### 4. Writing the CPU function

Now we have to write an equivalent function for CPU execution. For that, I have used `for` loops and came up with this small function:

```JavaScript
 cpuMutiplyMatrix() {
    const startTime = performance.now();
    const a = this.matrices[0];
    const b = this.matrices[1];

    let productRow = Array.apply(null, new Array(this.matrixSize)).map(Number.prototype.valueOf, 0);
    let product = new Array(this.matrixSize);
    for (let p = 0; p < this.matrixSize; p++) {
      product[p] = productRow.slice();
    }

    for (let i = 0; i < this.matrixSize; i++) {
      for (let j = 0; j < this.matrixSize; j++) {
        for (let k = 0; k < this.matrixSize; k++) {
          product[i][j] += a[i][k] * b[k][j];
        }
      }
    }
    const endTime = performance.now();
    this.cpuTime = (endTime - startTime) + " ms";
    console.log("CPU TIME : "+ this.cpuTime);
    this.cpuProduct = product;
  }

```

Apart from that, I have also used a function called `generateMatrices()` to generate two arrays with random numbers:

```JavaScript
  generateMatrices() {
    this.matrices = [[], []];
    for (let y = 0; y < this.matrixSize; y++) {
      this.matrices[0].push([])
      this.matrices[1].push([])
      for (let x = 0; x < this.matrixSize; x++) {
        const value1 = parseInt((Math.random() * 10).toString())
        const value2 = parseInt((Math.random() * 10).toString())
        this.matrices[0][y].push(value1)
        this.matrices[1][y].push(value2)
      }
    }
  }
```

### 5. Creating a simple UI

Now I’m going to implement a simple UI where users can enter a size for the array and see the execution times.

![](https://cdn-images-1.medium.com/max/2000/1*2nHeMQvrijEV_4sb99Andw.png)

```HTML
<div class="container-fluid">
  <div class="row">
    <div class="col col-3"></div>
    <div class="col col-6">
      <div class="card" style="margin: 5%">
        <div class="card-body">
          <div class="input-group mb-3">
            <div class="input-group-prepend">
              <span class="input-group-text" id="inputGroup-sizing-default"
                >Array Size</span
              >
            </div>
            <input
              type="text"
              [(ngModel)]="matrixSize"
              class="form-control"
              aria-label="Default"
              aria-describedby="inputGroup-sizing-default"
            />
          </div>
          <div style="margin: 5%">
            <h5>CPU Execution Time : {{ cpuTime }}</h5>
            <h5>GPU Execution Time : {{ gpuTime }}</h5>
          </div>
          <button
            type="button"
            class="btn btn-success btn-lg"
            (click)="execute()"
          >
            Start Calculation
          </button>
        </div>
      </div>
    </div>
    <div class="col col-3"></div>
  </div>
</div>

```

### 6. Running the application and seeing the performance

Now it's all set, and the complete code looks like this:

```TypeScript
import { Component } from '@angular/core';
import { GPU } from 'gpu.js';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
})
export class AppComponent {
  title = 'gpujs-demo';

  gpu: GPU;
  matrices: Array<Array<Array<number>>> = [[], []];
  matrixSize = 1000;

  cpuProduct: number[][];
  gpuProduct: number[][];

  cpuTime = '';
  gpuTime = '';

  constructor() {}

  execute() {
    this.gpu = new GPU();
    this.generateMatrices();
    this.cpuMutiplyMatrix();
    this.gpuMultiplyMatrix();
  }

  generateMatrices() {
    this.matrices = [[], []];
    for (let y = 0; y < this.matrixSize; y++) {
      this.matrices[0].push([]);
      this.matrices[1].push([]);
      for (let x = 0; x < this.matrixSize; x++) {
        const value1 = parseInt((Math.random() * 10).toString());
        const value2 = parseInt((Math.random() * 10).toString());
        this.matrices[0][y].push(value1);
        this.matrices[1][y].push(value2);
      }
    }
  }

  cpuMutiplyMatrix() {
    const startTime = performance.now();
    const a = this.matrices[0];
    const b = this.matrices[1];

    let productRow = Array.apply(null, new Array(this.matrixSize)).map(
      Number.prototype.valueOf,
      0
    );
    let product = new Array(this.matrixSize);
    for (let p = 0; p < this.matrixSize; p++) {
      product[p] = productRow.slice();
    }

    for (let i = 0; i < this.matrixSize; i++) {
      for (let j = 0; j < this.matrixSize; j++) {
        for (let k = 0; k < this.matrixSize; k++) {
          product[i][j] += a[i][k] * b[k][j];
        }
      }
    }
    const endTime = performance.now();
    this.cpuTime = endTime - startTime + ' ms';
    console.log('CPU TIME : ' + this.cpuTime);
    this.cpuProduct = product;
  }

  gpuMultiplyMatrix() {
    const gpu = new GPU();
    const multiplyMatrix = gpu
      .createKernel(function (
        a: number[][],
        b: number[][],
        matrixSize: number
      ) {
        let sum = 0;
        for (let i = 0; i < matrixSize; i++) {
          sum += a[this.thread.y][i] * b[i][this.thread.x];
        }
        return sum;
      })
      .setOutput([this.matrixSize, this.matrixSize]);

    const startTime = performance.now();
    const resultMatrix = multiplyMatrix(
      this.matrices[0],
      this.matrices[1],
      this.matrixSize
    );
    const endTime = performance.now();

    this.gpuTime = endTime - startTime + ' ms';
    console.log('GPU TIME : ' + this.gpuTime);
    this.gpuProduct = resultMatrix as number[][];
  }
}
```

## Let's See the Performance Difference

Now, it's time to check the performance boost we can get from GPU.js and see whether we can use it for everything or if there are any limitations.

For that, I executed the program multiple times with different array sizes, and the results were pretty interesting:

![Execution times](https://cdn-images-1.medium.com/max/2000/1*ur_7EfLMeJAVMvOu9GV_WQ.png)

As you can see, the CPU performs well when the size of the task is much smaller. For all the array sizes below 200, the CPU shows the best execution times, while the GPU takes considerable time to complete the task.

So, the CPU is suitable for tasks that are not too complex or computationally heavy.

But when the array size increases, the GPU starts to perform much better than the CPU. When the array size is 1,000, the GPU performs around ten times better than the CPU.

The GPU performs well when the weight of the task is heavy and more complex.

You should be mindful when using the GPU to select the best task for a GPU and get the most out of it. So, I invite all of you to give it a try with GPU.js in your next Angular application to see the performance boost.

Thank you for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
