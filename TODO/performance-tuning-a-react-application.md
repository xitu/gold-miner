> * 原文地址：[Performance-tuning a React application](https://codeburst.io/performance-tuning-a-react-application-f480f46dc1a2)
> * 原文作者：[Joshua Comeau](https://codeburst.io/@joshuawcomeau?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/performance-tuning-a-react-application.md](https://github.com/xitu/gold-miner/blob/master/TODO/performance-tuning-a-react-application.md)
> * 译者：[ZhangFe](https://github.com/ZhangFe)
> * 校对者：[atuooo](https://github.com/atuooo), [jonjia](https://github.com/jonjia)

# React 应用性能调优

## 案例研究

最近几周，我一直在为 [**Tello**](https://tello.tv) 工作，这是一个跟踪和管理电视节目的 web app：

![](https://cdn-images-1.medium.com/max/800/1*UfHV4_HWAK4I_yGl0wSq0Q.png)


作为一个 web app 来说，它的代码量是非常小的，大概只有 10,000 行。这是一个基于 Webpack 的 React/Redux 应用，有一个比较轻量的后端 Node 服务(基于 Express 和 MongoDB)。我们 90% 的代码都在前端。在 [**Github**](https://github.com/joshwcomeau/Tello) 上你可以看到我们的源码。

前端性能可以从很多角度来考量。但是从历史角度来看，我更注重于页面加载后的一些点：比如确保滚动的连贯性，以及动画的流畅性。

相比之下，我对于页面加载时间的关注比较少，至少在一些小型项目上是这样的。毕竟它并不需要传输太多的代码；它肯定是很快就能被访问并使用的，对吧？

然而，当我做了一些基准测试后，我惊奇地发现我这个 10k 行代码的小应用在 3G 网络下竟如此的**慢~~**，大约 5s 后才能显示一些有意义的内容，并且需要 **15s** 才能解决所有的网络请求。

我意识到我得在这个问题上投入一些时间和精力。如果人们需要盯着一个空白的屏幕看 5s 的话，那我的动画做的再漂亮也没用了。

总而言之，我在这周末尝试了 6 种技术，并且现在只需要 2300ms 左右就可以在页面上展示一些有意义的内容了 —— 减少了大约 50% 的时间！

这篇博客是我尝试的具体技术的研究案例以及他们的工作情况，更广泛地来说，这里记录了我在解决问题时所学到的知识，以及我在提出解决方案时的一些思路。

### 方法论

所有的分析都使用了相同的设置：

*   “Fast 3G” 的网速。
*   桌面端分辨率。
*   禁止 HTTP 缓存。
*   已登录，并且这个账户关注了 16 个电视节目。

### 基准值

我们需要一个可以用来比较结果的基准值！

我们测试的页面是主登录页的摘要视图，这是数据量最大的页面，因此它也有最大的优化空间

这个摘要部分就像下面这样包含了一组卡片：

![](https://cdn-images-1.medium.com/max/800/1*cag88WlFXxx_I452R5PEUA.png)

每个节目都有自己的卡片，并且每一集都有自己的一个小方块，蓝色的方块意味着这一集已经被观看了。

这是我们在 3G 网络下做基准测试的 profile 视图，看起来性能就不怎么样。

![](https://cdn-images-1.medium.com/max/800/1*116YOrGo-_hRvGUjMCieSA.png)

首次有效渲染：~5000ms
首张图片加载：~6500ms
所有请求结束：>15,000ms

天哪，直到 5s 左右页面才展示了一些有意义的内容。第一张图片在 6.5s 左右的时候加载完成，所有的网络请求足足花了 15s 才结束。

这个时间线视图提供了一系列的内容。让我们仔细研究一下这之间究竟发生了什么：

1. 首先，最初的 HTML 被加载。因为我们的应用不是服务端渲染的，这部分非常的快。
2. 之后，开始下载整个 JS bundle。这部分花费了很久的时间。🚩
3. JS下载完后，React 开始遍历组件树，计算初始化时挂载的状态，并且将它推送到 DOM 上。这部分有一个 header，一个 footer，和一大片的黑色区域。🚩
4. 挂载 DOM 后，这个应用发现它还需要一些数据，因此它向 _/me_ 发起了一个 GET 请求来获取用户数据，以及他们关心的节目列表和看过的剧集。
5. 一旦我们拿到了关键的节目列表，就可以开始请求下面的内容：
	- 每个节目的图片
	- 每个节目的剧集列表

这些数据都来自 TV Maze 的 [**API**](https://www.tvmaze.com/api)。

> * 你可能会想为什么我不在我的数据库里存储这些剧集信息呢，这样我就不需要调用 TV Maze 的接口了。其实原因主要是 TV Maze 的数据更加真实；它有所有新的剧集的信息。当然，我也可以在第四步的时候在服务端上拉取这些数据，可是这会增加这一步的响应时间，如此一来用户就只能盯着一大片空白的黑色区域了。另外，我喜欢比较轻量的服务端。
> 
> 还有一个可行方法就是设置一个定时任务，每天都去同步 TV Maze 的数据，并且只在我没有最新数据的时候才会去拉取。不过我还是喜欢实时的数据，因此这个方案一直都没有实施。

### 一次明显的提升

目前来看，最大的瓶颈就是初始的 JS bundle 体积太大了，下载它耗费了太多的时间。

bundle 的体积有 526kb，而且目前它还没有被压缩，我们需要使用 Gzip 来解救它。

通过 Node/Express 的服务端很容易实现 Gzip；我们只需要安装 [**compression**](https://www.npmjs.com/package/compression) 模块并将它作为一个 Express 中间件使用就可以了。

```
const path = require('path');

const express = require('express');
const compression = require('compression');


const app = express();

// 只需要将 compression 作为一个 Express 中间件!
app.use(compression());

app.use(express.static(path.join(rootDir, 'build')));
```

通过使用这个非常简单的解决方案，让我们看看我们的时间线有什么变化：

![](https://cdn-images-1.medium.com/max/800/1*N1pczEBknaQ_P6u-1S_FQw.png)

首次有效渲染：5000ms -> **3100ms**
首张图片加载：6500ms -> **4600ms
**所有数据加载完成：6500ms -> **4750ms
**所有图片加载完成：~15,000ms -> ~13,000ms

代码体积从 526kb 压缩到只有 156kb，并且它对页面加载速度造成了巨大的变化。

### 使用 LocalStorage 缓存

带着前一步的明显进步，我又回过头来看了下时间线。首次渲染时在 2400ms 时触发的，但这次并没有什么意义。3100 ms 时才真正有内容展示，但是直到 5000ms 左右才获取到所有的剧集数据。

我开始考虑使用服务端渲染，但是这也解决不了问题。服务端仍需要调用数据库，然后调用 TV Maze 的 API。更糟糕的是，在这段时间里用户只能傻盯着白花花的屏幕。

如果使用 local-storage 呢？我们可以把所有的状态变更都存储到浏览器上，并在用户数据返回的时候对这个本地状态进行补充。首屏的数据可能是旧的，但是没关系！真实的数据很快就能加载回来，并且这会使得首次加载的体验非常快。

因为这个 app 使用了 Redux，所以持久化数据是非常简单的。首先，我们需要一个方案来保证 Redux 状态变化时更新 localStorage：

```
import { LOCAL_STORAGE_REDUX_DATA_KEY } from '../constants';
import { debounce } from '../utils'; // generic debounce util

// 当我们的页面首次加载时，一堆 redux actions 会迅速被 dispatch
// 每个节目都要获取它们的剧集，所以最小的 action 数量是 2n (n 是节目的数量)
// 我们不需要太过于频繁的更新 localStorage，可以对他做 debounce
// 如果传入 null，我们会抹去数据，通常用来在登录登出时消除持久状态
const updateLocalStorage = debounce(
  value =>
    value !== null
      ? localStorage.setItem(LOCAL_STORAGE_REDUX_DATA_KEY, value)
      : localStorage.removeItem(LOCAL_STORAGE_REDUX_DATA_KEY),
  2500
);


// store 更新时，将相关部分存储到 localStorage 中
export const handleStoreUpdates = function handleStoreUpdates(store) {
  // 忽略 modals 和 flash 消息，他们不需要被存储
  const { modals, flash, ...relevantState} = store.getState();

  updateLocalStorage(JSON.stringify(relevantState));
}

// 在退出登录时用来清除数据的一个函数
export const clearReduxData = () => {
  // 立即清除存储在 localStorage 中的数据
  window.localStorage.removeItem(LOCAL_STORAGE_REDUX_DATA_KEY);


  // 因为删除是同步的，而持久化数据是异步的，因此这里会导致一个微妙的 bug：
  // 存储的数据会被删除，但是稍后又会被填充上
  // 为了解决这个问题，我们会传入一个 null，来终止当前队列所有的更新
 
  updateLocalStorage(null);
  
  // 我们需要触发异步和同步的操作。
  // 同步操作保证数据可以立刻被删除，所以如果用户点击退出后立刻关闭页面，数据也能被删除
};
```

下一步，我们需要让 Redux store 订阅这个函数，以及用前一次会话的数据对它进行初始化。

```
import { LOCAL_STORAGE_REDUX_DATA_KEY } from './constants';
import { handleStoreUpdates } from './helpers/local-storage.helpers';
import configureStore from './store';


const localState = JSON.parse(
  localStorage.getItem(LOCAL_STORAGE_REDUX_DATA_KEY) || '{}'
);

const store = configureStore(history, localState);

store.subscribe(() => {
  handleStoreUpdates(store);
});
```

虽然还有几个遗留的小问题，但是得益于 Redux 架构，我们只做了一些很小的改动就完成了大部分的功能。

让我们再来看看新的时间线：

![](https://cdn-images-1.medium.com/max/800/1*wJ6uOFLCWUmhMpKtB7XuYw.png)

棒极了！虽然通过这些很小的截屏很难说明什么，但是我们在 2600ms 时的那次渲染已经可以展示一些内容了；它包括一个完整的节目列表以及从之前的会话里保存的剧集信息。

首次有效渲染：3100ms -> **2600ms
**获取剧集数据：4750ms -> **2600ms (!)**

虽然这并没有影响到实际的加载时间（我们仍然需要调用哪些 API，并且在这上面耗时），但是用户可以直接拿到数据，所以**感知**速度的提升非常明显。

在内容已经出现的情况下，页面仍在继续变化，这是一种非常流行的技术，可以让页面更快地展现，并且当新的内容可用时，页面发生更新。可是我更喜欢立即呈现最终的 UI。

这个方案在一些 non-perf 的情况下有一些额外的优势。举个例子，用户可以更改节目的顺序，但可能由于会话的结束导致数据丢失了。现在，当他们返回页面时，之前的偏好还是被保存了下来！

> 但是，这也有一个缺点：我不清楚你是否在等待新的数据加载。我计划在角落里添加一个加载框以显示是否还有其他请求正在加载。

> 另外，你可能会想“这对于老用户来说可能不错，但是对于新用户并没有什么用处！”。你说的没错，但实际上，这也确实不适用于新用户。新用户并没有关注的节目，只有一个引导他们添加节目的提示，因此他们的页面加载的非常快。所以，对于所有的用户来说，不管是新用户还是老用户，我们都已经有效避免了那种一直盯着黑屏的体验。

### 图片和懒加载

即使有了这个最新的改进，图片的加载仍然花费了很多的时间。这个时间线里没有展示出来，但是在 3G 网络下，所有的图片加载一共耗费了超过 12 秒。

原因很简单：TV Maze 返回了一张巨大的电影海报风格的照片，然而我只需要一个狭长的条状图，用于帮助用户一眼就能分辨出节目。

![](https://cdn-images-1.medium.com/max/800/1*wIhn8j9QkPIBvxAA6ulTxQ.jpeg)

**左边**：被下载的图片 ················ **右边**：真正用到的图片

为了解决这个问题，我一开始的想法是使用一个类似于 ImageMagick 的 CLI 工具，我在制作 [**ColourMatch**](http://colourmatch.ca/) 时使用过它。

当用户添加一个新的节目时，服务端将请求一个图片的副本，使用 ImageMagick 将图片的中间裁剪出来并发送给 S3，然后客户端会使用 S3 的 url 而非 TV Maze 的图片链接。

不过，我决定使用 [**Imgix**](https://www.imgix.com/) 来完成这个功能。Imgix 是一个基于 S3(或者其他云存储提供商) 的图片服务，它允许你动态创建裁剪过或者调整了大小的图片。你只需要使用下面这样的链接，它就会创建并提供合适的图片。

```
https://tello.imgix.net/some_file?w=395&h=96&crop=faces
```

> 它还有一个优势就是能够找到图片中有趣的区域并做裁剪。你会注意到，在上面的左/右照片对比中，它将 4 个骑车的孩子裁剪了出来，而非仅仅裁剪出图片的中心

为了配合 Imgix 的工作，你的图片需要能够通过 S3 或者类似的服务被获取到。这里是一段我的后端代码片段，当添加一个新的节目时会上传一张图片：

```
const ROOT_URL = 'https://tello.imgix.net';

const uploadImage = ({ key, url }) => (
  new Promise((resolve, reject) => {
    // 有些情况下节目没有一个链接，这时候跳过这种情况
    if (!url) {
      resolve();
      return;
    }

    request({ url, encoding: null }, (err, res, body) => {
      if (err) {
        reject(err);
      }

      s3.putObject({
        Key: key,
        Bucket: BUCKET_NAME,
        Body: body,
      }, (...args) => {
        resolve(`${ROOT_URL}/${key}`);
      });
    });
  })
);
```


通过对每个新的节目调用这个 Promise，我们获取了可以被动态裁剪的图片。

在客户端，我们使用 _srcset_ 和 _sizes_ 这两个图片属性来确保图片是基于窗口大小和像素比来提供的：

```
const dpr = window.devicePixelRatio;

const defaultImage = 'https://tello.imgix.net/placeholder.jpg';

const buildImageUrl = ({ image, width, height }) => (`
  ${image || defaultImage}?fit=crop&crop=entropy&h=${height}&w=${width}&dpr=${dpr} ${width * dpr}w
`);


// Later, in a render method:
<img
  srcSet={`
    ${buildImageUrl({
      image,
      width: 495,
      height: 128,
    })},
    ${buildImageUrl({
      image,
      width: 334,
      height: 96,
    })}
  `}
  sizes={`
    ${BREAKPOINTS.smMin} 334px,
    495px
  `}
/>
```

这确保了移动设备能获取更大版本的图像（因为这些卡片占据了整个视口的宽度），而桌面客户端得到的是一个较小的版本。

#### 懒加载

现在，每张图片都变小了，但是我们还是一次性加载了整个页面的图片！在我的大型桌面窗口上，每次只能看到 6 个节目，但是我们在页面加载的时候一次性获取了全部的 16 张图片。

值得庆幸的是，有一个很棒的库 [**react-lazyload**](https://github.com/jasonslyvia/react-lazyload) 提供了非常便利的懒加载功能。代码示例如下：

```
import LazyLoad from 'react-lazyload';

// In some render method somewhere:
<LazyLoad once height={UNITS_IN_PX[6]} offset={50}>
  <img
    srcSet={`...omitted`}
    sizes={`...omitted`}
  />
</LazyLoad>
```

来吧，让我们再来看看时间线。

![](https://cdn-images-1.medium.com/max/800/1*YLyKF1rKx1MMaLA-1jnZrg.png)

我们的首次有效渲染时间没什么变化，但是图片加载的时间有了明显的降低：

首张图片：4600ms -> **3900ms**
所有可见范围内的图片：~9000ms -> **4100ms**

> 眼尖的读者可能已经注意到了，这个时间线上只下载了 6 集的数据而不是全部的 16集。因为我最初的尝试（也是我记忆中唯一一个尝试）就是懒加载节目卡片，而并不仅仅是懒加载图片。

> 不过，相比我这周末解决的问题，它也引发了更多的问题，因此我对它进行了一些简化。但是这并不会影响图片加载时间的优化。

### 代码分割

我敢肯定，代码分割是一个非常明智的决定。

因为现在有一个显而易见的问题，我们的代码 bundle 只有一个。让我们使用代码分割来减少一个请求所需要的代码量！

我使用的路由方案是 React Router 4，[**它的文档上**](https://reacttraining.com/react-router/web/guides/code-splitting)有一个很简单的创建 `<Bundle />` 组件的例子。我设置了几个不同的配置，但是最终代码并没有比较有效的分割。

最后，我将移动端和桌面端的视图做了分离。移动版有自己的视图，它使用了一个滑动库，一些自定义的静态资源和几个额外的组件。令人吃惊的是，这个分离出来的 bundle 非常的小 —— 压缩前大概只有 30kb —— 但是它还是带来了一些显著的影响：

![](https://cdn-images-1.medium.com/max/800/1*0eWlF3VGsWLqHulZtLzkDQ.png)

首次有效渲染：2600ms -> **2300ms**
首张图片加载：3900ms -> **3700ms**

> 通过这次尝试让我学到了一件事：代码分割的效果很大程度上取决于你的应用类型。在我这个 case 里，最大的依赖就是 React 和它生态系统里的一些库，然而这些代码是整站都需要的并且不需要被分离出来
>
> 在页面加载时，我们可以在路由层面对组件进行分割以获得一些边际效益，但是这样的话，每当路由变化时都会造成额外的延迟；处处都要处理这种小问题并不有趣。

* * *

### 一些其他方法的尝试和思考
#### 服务端渲染

我的想法是在服务端渲染一个 "shell" —— 一个有正确布局的占位图，只是没有数据。

但是我预见到一个问题，因为客户端已经通过 localStorage 获取前一次会话的数据了，并且它使用这个数据进行了初始化。但是此时服务端是不知情的，所以我需要处理客户端与服务器之间的标记不匹配。

我认为虽然我可以通过 SSR 将我的首次有效渲染时间减少半秒，但是在那时整个网站都是不能交互的；当一个网站看起来已经准备好了但其实不是的时候，让人觉得非常奇怪。

另外，SSR 也会增加复杂性，并且降低开发速度。性能很重要，但是足够好就够了。

有一个我很感兴趣但是没时间研究的问题是 —— 编译时 SSR。它可能这只适用于一些静态页面，比如登出页，但是我觉得它是非常有效的。作为我构建过程的一部分，我会创建并持久化存储 `index.html`，并通过 Node 服务器将它作为一个纯 HTML 文件提供给用户。客户端仍然会下载并运行 React，因此页面仍然是可交互的，但是服务端不需要花时间去构建了，因为我已经在代码部署时直接将这些页面构建好了。

#### CDN 的依赖

还有一个我认为有很大潜力的想法就是将 React 和 ReactDOM 托管到 CDN 上。

Webpack 使得这很容易实现；你可以通过定义 _externals_ 关键字避免将它们打包到你的 bundle 中。

```
// webpack.config.prod.js
{
  externals: {
    react: 'React',
    'react-dom': 'ReactDOM',
  },
}
```

这种方法有两个优势：

* 从 CDN 获取一个流行的库，它有很大可能已经被用户缓存了
* 依赖关系可以被并行化，可以同时下载你的代码，而不是下载一个大文件

我很惊讶的发现，至少在 CDN 未缓存的最坏情况下，将 React 移到 CDN 上并没有什么益处：

![](https://cdn-images-1.medium.com/max/800/1*JaujId8Or-HOxLuJGcKWSw.png)

首次有效渲染时间：**2300ms** -> 2650ms

你可能会发现 React 和 React DOM 是和我的主要软件包并行下载的，并且它确实拖慢了整体的时间。

> 我并不是想说使用 CDN 是一个坏主意。在这方面我并不是很专业并且很可能是我做错了，而不是这个想法的问题！至少在我的 case 里它并没有生效。
	
> 译者注：
> 这里将 React 放在 CDN 上的方案，在本地无缓存的情况下很明显没什么优势，因为你的总代码体积不会减少，你的带宽没有变化，JS是并行下载但是串行执行，所以总的下载时间和执行时间并不会有什么优势；反而由于 http 建立链接的损耗可能会减慢速度，这也是我们说要尽可能减少 http 请求的原因；而且由于是本地测试，CDN 的优势可能并没有体现。
> 但是我觉得这种方案还是可取的，主要有两点：1. 因为有 CDN，可以保证大部分人的下载速度，而放在你的服务器上其实由于传输的问题很多人下载会非常慢；2. 由于将 React 相关的库抽离，后续每次更改代码和发布后这部分代码都是走的缓存，可以减少后续用户的加载时间
* * *

###结论

通过这篇文章，我希望传达出两个观点：

1. 小型程序的开箱即用性非常高，但是一个周末就可以带来一个巨大的提升。这要感谢 Chrome 开发者工具，它可以帮你快速确认项目的瓶颈，并且让你惊讶的发现项目里有如此多的性能洼地。也可以将一些复杂的任务交给像 Imgix 这样的低成本或者免费的服务商。
2. 每个应用都是不同的，这篇文章详细介绍了 Tello 的一些技巧，但是这些技巧的关注点比较特别。即使这些技巧不适用于你的应用，但我希望我已经把理念表达清楚了：性能取决于 web 开发者的创造性。


举个例子，在一些传统的观念看来，服务端渲染是一个必经之路。但是我在的应用里，基于 local-storage 或者 service-workers 来做前端渲染则是一个更好的选择！也许你可以在编译时做一些工作，减少 SSR 的耗时，又或者学习 Netflix，[完全不将 React 传递给前端](https://jakearchibald.com/2017/netflix-and-react/)！
	
	当你做性能优化时，你会发现这非常需要创造力和开阔的思路，而这也是它最有趣的的地方。

> 非常感谢您的阅读！我希望这篇文章能给您带来帮助:)。如果您有什么想法可以联系我的
[Twitter](http://twitter.com/joshwcomeau) 。

> **可以在** [**Github**](https://github.com/joshwcomeau/Tello) **上查看 Tello 的源码****🌟**


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


