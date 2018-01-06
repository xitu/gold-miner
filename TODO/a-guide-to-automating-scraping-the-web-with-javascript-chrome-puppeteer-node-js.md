> * 原文地址：[A Guide to Automating & Scraping the Web with JavaScript (Chrome + Puppeteer + Node JS)](https://codeburst.io/a-guide-to-automating-scraping-the-web-with-javascript-chrome-puppeteer-node-js-b18efb9e9921)
> * 原文作者：[Brandon Morelli](https://codeburst.io/@bmorelli25?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-guide-to-automating-scraping-the-web-with-javascript-chrome-puppeteer-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-guide-to-automating-scraping-the-web-with-javascript-chrome-puppeteer-node-js.md)
> * 译者：[pot-code](https://github.com/pot-code)
> * 校对者：[bambooom](https://github.com/bambooom)

# JavaScript 自动化爬虫入门指北（Chrome + Puppeteer + Node JS）

## 和 Headless Chrome 一起装逼一起飞

![](https://cdn-images-1.medium.com/max/800/1*kk8ovQKB-45FsZ8TZM-vjg.png)

> [**Udemy Black Friday Sale**](https://codeburst.io/udemys-black-friday-sale-starts-today-all-web-development-courses-just-10-44966e590bd4) — Thousands of Web Development & Software Development courses are on sale for only $10 for a limited time! [**Full details and course recommendations can be found here**](https://codeburst.io/udemys-black-friday-sale-starts-today-all-web-development-courses-just-10-44966e590bd4).

#### 内容简介

本文将会教你如何用 JavaScript 自动化 web 爬虫，技术上用到了 Google 团队开发的 Puppeteer。 [__Puppeteer__](https://github.com/GoogleChrome/puppeteer) 运行在 Node 环境，可以用来操作 headless Chrome。何谓 [__Headless Chrome__](https://developers.google.com/web/updates/2017/04/headless-chrome)？通俗来讲就是在不打开 Chrome 浏览器的情况下使用提供的 API 模拟用户的浏览行为。

**如果你还是不理解，你可以想象成使用 JavaScript 全自动化操作 Chrome 浏览器。**

#### 前言

先确保你已经安装了 Node 8 及以上的版本，没有的话，可以先到 [**官网**](https://nodejs.org/en/) 里下载安装。注意，一定要选“Current”处显示的版本号大于 8 的。

如果你是第一次接触 Node，最好先看一下入门教程：[**Learn Node JS — The 3 Best Online Node JS Courses**](https://codeburst.io/learn-node-js-the-3-best-online-node-js-courses-87e5841f4c47).

安装好 Node 之后，创建一个项目文件夹，然后安装 Puppeteer。安装 Puppeteer 的过程中会附带下载匹配版本的 Chromium（译者注：国内网络环境可能会出现安装失败的问题，可以设置环境变量 `PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = 1` 跳过下载，副作用是每次使用 `launch` 方法时，需要手动指定浏览器的执行路径）：

```shell
npm install --save puppeteer
```

#### 例 1 —— 网页截图

Puppeteer 安装好之后，我们就可以开始写一个简单的例子。这个例子直接照搬自官方文档，它可以对给定的网站进行截图。

首先创建一个 js 文件，名字随便起，这里我们用 `test.js` 作为示例，输入以下代码：

```javascript
const puppeteer = require('puppeteer');

async function getPic() {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://google.com');
  await page.screenshot({path: 'google.png'});

  await browser.close();
}

getPic();
```

下面我们来逐行分析上面的代码。

* **第 1 行：** 引入依赖。
* **第 3–10 行：** 核心代码，自动化过程在这里完成。
* **第 12 行：** 执行 `getPic()` 方法。

细心的读者会发现，`getPic()` 前面有个 `async` 前缀，它表示 `getPic()` 方法是个异步方法。`async` 和 `await` 成对出现，属于 ES 2017 新特性。介于它是个异步方法，所以调用之后返回的是 `Promise` 对象。当 `async` 方法返回值时，对应的 `Promise` 对象会将这个值传递给 `resolve`（如果抛出异常，那么会将错误信息传递给 `Reject`)。

在 `async` 方法中，可以使用 `await` 表达式暂停方法的执行，直到表达式里的 `Promise` 对象完全解析之后再继续向下执行。看不懂没关系，后面我再详细讲解，到时候你就明白了。

接下来，我们将会深入分析 `getPic()` 方法：

* **第 4 行：**

```javascript
const browser = await puppeteer.launch();
```

这段代码用于启动 puppeteer，实质上打开了一个 Chrome 的实例，然后将这个实例对象赋给变量 `browser`。因为使用了 `await` 关键字，代码运行到这里会阻塞（暂停），直到 `Promise` 解析完毕（无论执行结果是否成功）

* **第 5 行：**

```javascript
const page = await browser.newPage();
```

接下来，在上文获取到的浏览器实例中新建一个页面，等到其返回之后将新建的页面对象赋给变量 `page`。

* **第 6 行：**

```javascript
await page.goto('https://google.com');
```

使用上文获取到的 `page` 对象，用它来加载我们给的 URL 地址，随后代码暂停执行，等待页面加载完毕。

* **第 7 行：**

```javascript
await page.screenshot({path: 'google.png'});
```

等到页面加载完成之后，就可以对页面进行截图了。`screenshot()` 方法接受一个对象参数，可以用来配置截图保存的路径。注意，不要忘了加上 `await` 关键字。

* **第 9 行：**

```javascript
await browser.close();
```

最后，关闭浏览器。

#### 运行示例

在命令行输入以下命令执行示例代码：

```shell
node test.js
```

以下是示例里的截图结果：

![](https://cdn-images-1.medium.com/max/800/1*OHQ4myaGuBWxqkJ_G1hxoA.png)

是不是很厉害？这只是热身，下面教你怎么在非 headless 环境下运行代码。

非 headless？百闻不如一见，自己先动手试一下吧，把第 4 行的代码：

```javascript
const browser = await puppeteer.launch();
```

换成这句：

```javascript
const browser = await puppeteer.launch({headless: false});
```

然后再次运行：

```shell
node test.js
```

是不是更炫酷了？当配置了 `{headless: false}` 之后，就可以直观的看到代码是怎么操控 Chrome 浏览器的。

这里还有一个小问题，之前我们的截图有点没截完整的感觉，那是因为 `page` 对象默认的截屏尺寸有点小的缘故，我们可以通过下面的代码重新设置 `page` 的视口大小，然后再截取：

```javascript
await page.setViewport({width: 1000, height: 500})
```

这下就好多了：

![](https://cdn-images-1.medium.com/max/800/1*5nobu4vdUesXZg1cgWlySg.png)

最终代码如下：

```javascript
const puppeteer = require('puppeteer');

async function getPic() {
  const browser = await puppeteer.launch({headless: false});
  const page = await browser.newPage();
  await page.goto('https://google.com');
  await page.setViewport({width: 1000, height: 500})
  await page.screenshot({path: 'google.png'});

  await browser.close();
}

getPic();
```

#### 例 2 —— 爬取数据

通过上面的例子，你应该掌握了 Puppeteer 的基本用法，下面再来看一个稍微复杂点的例子。

开始前，不妨先看看 [官方文档](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#)。你会发现 Puppeteer 能干很多事，像是模拟鼠标的点击、填充表单数据、输入文字、读取页面数据等。

在接下来的教程里，我们将爬一个叫 [_Books To Scrape_](http://books.toscrape.com/) 的网站，这个网站是专门用来给开发者做爬虫练习用的。

还是在之前创建的文件夹里，新建一个 js 文件，这里用 `scrape.js` 作为示例，然后输入以下代码：

```javascript
const puppeteer = require('puppeteer');

let scrape = async () => {
  // Actual Scraping goes Here...
  
  // Return a value
};

scrape().then((value) => {
    console.log(value); // Success!
});
```

有了上一个例子的经验，这段代码要看懂应该不难。如果你还是看不懂的话......那也没啥问题就是了。

首先，还是引入 `puppeteer` 依赖，然后定义一个 `scrape()` 方法，用来写爬虫代码。这个方法返回一个值，到时候我们会处理这个返回值（示例代码是直接打印出这个值）

先在 scrape 方法中添加下面这一行测试一下：

```javascript
let scrape = async () => {
  return 'test';
};
```

在命令行输入 `node scrape.js`，不出问题的话，控制台会打印一个 `test` 字符串。测试通过后，我们来继续完善 `scrape` 方法。

**步骤 1：前期准备**

和例 1 一样，先获取浏览器实例，再新建一个页面，然后加载 URL：

```javascript
let scrape = async () => {
  const browser = await puppeteer.launch({headless: false});
  const page = await browser.newPage();
  await page.goto('http://books.toscrape.com/');
  await page.waitFor(1000);
  // Scrape
  browser.close();
  return result;
};
```

再来分析一下上面的代码：

首先，我们创建了一个浏览器实例，将 `headless` 设置为 `false`，这样就能直接看到浏览器的操作过程：

```javascript
const browser = await puppeteer.launch({headless: false});
```

然后创建一个新标签页：

```javascript
const page = await browser.newPage();
```

访问 `books.toscrape.com`：

```javascript
await page.goto('http://books.toscrape.com/');
```

下面这一步可选，让代码暂停执行 1 秒，保证页面能完全加载完毕：

```javascript
await page.waitFor(1000);
```

任务完成之后关闭浏览器，返回执行结果。

```javascript
browser.close();
return result;
```

步骤 1 结束。

**步骤 2： 开爬**

打开 Books to Scrape 网站之后，想必你也发现了，这里面有海量的书籍，只是数据都是假的而已。先从简单的开始，我们先抓取页面里第一本书的数据，返回它的标题和价格信息（红色边框选中的那本）。

![](https://cdn-images-1.medium.com/max/1000/1*SJi9SPF1a7gGcZ_mEnScgg.png)

查一下文档，注意到这个方法能模拟页面点击：

**page.click(selector[, options])**

* `selector` <string> 选择器，定位需要进行点击的元素，如果有多个元素匹配，以第一个为准。

这里可以使用开发者工具查看元素的选择器，在图片上右击选中 inspect：

![](https://cdn-images-1.medium.com/max/800/1*PSffzKaJrObAdfA1QRLCpg.png)

上面的操作会打开开发者工具栏，之前选中的元素也会被高亮显示，这个时候点击前面的三个小点，选择 copy - copy selector：

![](https://cdn-images-1.medium.com/max/1000/1*fUXgbZ7LTGSvkqadYUPbAw.png)

有了元素的选择器之后，再加上之前查到的元素点击方法，得到如下代码：

```javascript
await page.click('#default > div > div > div > div > section > div:nth-child(2) > ol > li:nth-child(1) > article > div.image_container > a > img');
```

然后就会观察到浏览器点击了第一本书的图片，页面也会跳转到详情页。

在详情页里，我们只关心书的标题和价格信息 —— 见图中红框标注。

![](https://cdn-images-1.medium.com/max/800/1*ccol1C8a4b1wGXUdV8qfTA.png)

为了获取这些数据，需要用到 `page.evaluate()` 方法。这个方法可以用来执行浏览器内置 DOM API ，例如 `querySelector()`。

首先创建 `page.evaluate()` 方法，将其返回值保存在 `result` 变量中：

```javascript
const result = await page.evaluate(() => {
// return something
});
```

同样，要在方法里选择我们要用到的元素，再次打开开发者工具，选择需要 inspect 的元素：

![](https://cdn-images-1.medium.com/max/1000/1*jzC0PnWrZsI_SF8t5PgGTA.png)

标题是个简单的 `h1` 元素，使用下面的代码获取：

```javascript
let title = document.querySelector('h1');
```

其实我们需要的只是元素里的文字部分，可以在后面加上 `.innerText`，代码如下：

```javascript
let title = document.querySelector('h1').innerText;
```

获取价格信息同理：

![](https://cdn-images-1.medium.com/max/1000/1*dKX7qukRfMVfPP2kydD03w.png)

刚好价格元素上有个 `price_color` class，可以用这个 class 作为选择器获取到价格对应的元素：

```javascript
let price = document.querySelector('.price_color').innerText;
```

这样，标题和价格都有了，把它们放到一个对象里返回：

```javascript
return {
  title,
  price
}
```

回顾刚才的操作，我们获取到了标题和价格信息，将它们保存在一个对象里返回，返回结果赋给 `result` 变量。所以，现在你的代码应该是这样：

```javascript
const result = await page.evaluate(() => {
  let title = document.querySelector('h1').innerText;
  let price = document.querySelector('.price_color').innerText;
return {
  title,
  price
}
});
```

然后只需要将 `result` 返回即可，返回结果会打印到控制台：

```javascript
return result;
```

最后，综合起来代码如下：

```javascript
const puppeteer = require('puppeteer');

let scrape = async () => {
    const browser = await puppeteer.launch({headless: false});
    const page = await browser.newPage();

    await page.goto('http://books.toscrape.com/');
    await page.click('#default > div > div > div > div > section > div:nth-child(2) > ol > li:nth-child(1) > article > div.image_container > a > img');
    await page.waitFor(1000);

    const result = await page.evaluate(() => {
        let title = document.querySelector('h1').innerText;
        let price = document.querySelector('.price_color').innerText;

        return {
            title,
            price
        }

    });

    browser.close();
    return result;
};

scrape().then((value) => {
    console.log(value); // Success!
});
```

在控制台运行代码：

```javascript
node scrape.js
// { title: 'A Light in the Attic', price: '£51.77' }
```

操作正确的话，在控制台会看到正确的输出结果，到此为止，你已经完成了 web 爬虫。

#### 例 3 —— 后期完善

稍加思考一下你会发现，标题和价格信息是直接展示在首页的，所以，完全没必要进入详情页去抓取这些数据。既然这样，不妨再进一步思考，能否抓取所有书的标题和价格信息？

所以，抓取的方式其实有很多，需要你自己去发现。另外，上面提到的直接在主页抓取数据也不一定可行，因为有些标题可能会显示不全。

**拔高题**

目标 —— 抓取主页所有书籍的标题和价格信息，并且用数组的形式保存返回。正确的输出应该是这样：

![](https://cdn-images-1.medium.com/max/800/1*w4YN9E40rzpdmQfwqM2Pcg.png)

开干吧，伙计，其实实现起来和上面的例子相差无几，如果你觉得实在太难，可以参考下面的提示。

* * *

**提示：**

其实最大的区别在于你需要遍历整个结果集，代码的大致结构如下：

```javascript
const result = await page.evaluate(() => {
  let data = []; // 创建一个空数组
  let elements = document.querySelectorAll('xxx'); // 选择所有相关元素
  // 遍历所有的元素
    // 提取标题信息
    // 提取价格信息
    data.push({title, price}); // 将数据插入到数组中
  return data; // 返回数据集
});
```

* * *

如果提示了还是做不出来的话，好吧，以下是参考答案。在以后的教程中，我会在下面这段代码的基础上再做一些拓展，同时也会涉及一些更高级的爬虫技术。你可以在 [**这里**](https://docs.google.com/forms/d/e/1FAIpQLSeQYYmBCBfJF9MXFmRJ7hnwyXvMwyCtHC5wxVDh5Cq--VT6Fg/viewform) 提交你的邮箱地址进行订阅，有新的内容更新时我们会通知你。

**参考答案：**

```javascript
const puppeteer = require('puppeteer');

let scrape = async () => {
    const browser = await puppeteer.launch({headless: false});
    const page = await browser.newPage();

    await page.goto('http://books.toscrape.com/');

    const result = await page.evaluate(() => {
        let data = []; // 创建一个数组保存结果
        let elements = document.querySelectorAll('.product_pod'); // 选择所有书籍

        for (var element of elements){ // 遍历书籍列表
            let title = element.childNodes[5].innerText; // 提取标题信息
            let price = element.childNodes[7].children[0].innerText; // 提取价格信息

            data.push({title, price}); // 组合数据放入数组
        }

        return data; // 返回数据集
    });

    browser.close();
    return result; // 返回数据
};

scrape().then((value) => {
    console.log(value); // 打印结果
});
```

### 结语：

谢谢观看！如果你有学习 NodeJS 的意向，可以移步 [**Learn Node JS — The 3 Best Online Node JS Courses**](https://codeburst.io/learn-node-js-the-3-best-online-node-js-courses-87e5841f4c47)。

每周我都会发布 4 篇有关 web 开发的技术文章，[**欢迎订阅**](https://docs.google.com/forms/d/e/1FAIpQLSeQYYmBCBfJF9MXFmRJ7hnwyXvMwyCtHC5wxVDh5Cq--VT6Fg/viewform)！或者你也可以在 Twitter 上 [**关注我**](https://twitter.com/BrandonMorelli)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
