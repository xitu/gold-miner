> * 原文地址：[Vue Plugins You Don’t Know You May Need](https://medium.com/swlh/vue-plugins-you-dont-know-you-may-need-573902dfdbae)
> * 原文作者：[John Au-Yeung](https://medium.com/@hohanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/vue-plugins-you-dont-know-you-may-need.md](https://github.com/xitu/gold-miner/blob/master/article/2020/vue-plugins-you-dont-know-you-may-need.md)
> * 译者：[Gesj-yean](https://github.com/Gesj-yean)
> * 校对者：[lhd951220](https://github.com/lhd951220)

# 一个你不知道但可能会需要的 Vue 插件

![图片来自 [Creative Nerds](https://unsplash.com/@creativenerds?utm_source=medium&utm_medium=referral) 在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8000/0*rwLCSJM5TWHmJPtB)

Vue.js 是一个容易上手的 web 应用框架，我们能够用它去开发交互式前端应用程序。

这篇文章将会介绍一些你不知道，但是你也许想要添加到应用中的与 Vue 相关的软件包。

## Vue-Dummy

我们在开发应用程序时，可以用 `vue-dummy` 软件包来添加虚拟文本，这样我们就不用担心自己生成文本了，我们还可以用它来添加占位符图像。

可以通过以下命令安装:

```bash
npm install --save vue-dummy
```

它也可以作为一个独立的脚本，我们可以添加：

```html
<script src="https://unpkg.com/vue-dummy"></script>
```

到 HTML 代码中。

然后我们可以这样使用：

在 `main.js` 文件添加：

```js
import Vue from "vue";
import App from "./App.vue";
import VueDummy from "vue-dummy";

Vue.use(VueDummy);

Vue.config.productionTip = false;

new Vue({
  render: h => h(App)
}).$mount("#app");
```

`App.vue` :

```html
<template>
  <div id="app">
    <p v-dummy="150"></p>
    <img v-dummy="'200x150'">
  </div>
</template>

<script>
export default {
  name: "App"
};
</script>
```

在上面的代码中，我们添加了一个 p 元素并使用 `v-dummy` 指令。我们将值设置为150，这样页面上就会出现 150 个模拟数据单词。

然后，我们添加一个宽度 200px，高度 150px 的图片。

我们也可以在虚拟文本中添加一定范围内任意数量的单词。要使用这个功能，我们可以这样写:

```html
<template>
  <div id="app">
    <p v-dummy="'100,130'"></p>
  </div>
</template>

<script>
export default {
  name: "App"
};
</script>
```

这样我们就得到了 100 到 130 范围内的数量的单词。它也可以写成一个指令参数。例如，我们可以这样写:

```html
<template>
  <div id="app">
    <p v-dummy:100,130></p>
  </div>
</template>

<script>
export default {
  name: "App"
};
</script>
```

和前面的例子一样。

同样，可以将虚拟图像参数设置为指令参数或修饰符。

设虚拟图像的尺寸为自变量，我们可以这样写:

```html
<img v-dummy:300x200>
```

将虚拟图像的尺寸设置为一个指令修饰符，我们可以写成:

```html
<img v-dummy.400x300>
```

我们还可以设置 `img` 标签的宽度和高度属性来设置它的尺寸:

```html
<img v-dummy width="250" height="150">
```

我们还可以创建随机尺寸的图像:

```html
<img v-dummy="'100,400x200,400'">
```

上面的代码将创建宽度在 100 到 400px 之间、高度在 200 到 400px 之间的图像。

我们也可以把数字作为一个指令参数，如下:

```html
<img v-dummy:100,400x200,400>
```

`dummy` 组件也可以像下面这样生成占位符文本或图像：

```html
<dummy text="100"></dummy>
<dummy img="420x300"></dummy>
```

第一行创建了一个 100 个字长的文本块，第二行创建一个 420px 宽、300px 高的占位符图像。

我们也可以像下面这样创建一个模拟内容的表格：

```html
<table v-dummy></table>
```

## Vue.ImagesLoaded

Vue.ImagesLoaded 指令用于检测图像是否已加载。

当图片加载完成或加载失败时，它调用一个回调。我们通过以下命令安装它:

```bash
npm install vue-images-loaded --save
```

然后这样使用:

```html
<template>
  <div id="app">
    {{loaded}}
    <div v-images-loaded:on.progress="imageProgress">
      <img
        src="https://images.unsplash.com/photo-1562953208-602ead7f3d47?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=375&q=80"
      >
    </div>
  </div>
</template>

<script>
import imagesLoaded from "vue-images-loaded";

export default {
  name: "App",
  directives: {
    imagesLoaded
  },
  data() {
    return { loaded: "" };
  },
  methods: {
    imageProgress(instance, image) {
      this.loaded = image.isLoaded ? "loaded" : "broken";
    }
  }
};
</script>
```

在上面的代码中，我们在 `App` 组件中引入了 `vue-image-loaded` 软件包，并注册了 `imagesLoaded` 指令。

接着添加 v-images-loaded:on.progress="imageProgress" 指令，以及 `imageProgress` 方法作为值。

然后我们可以从 `image` 参数的 `isLoaded` 属性中知道图片是否已加载。

`instance` 参数中具有 `elements` 属性，它包含加载中图片的父元素的数组。`images` 属性有一个加载中的图片数组。

`v-images.on` 指令的其他修饰符包括了 `always`，`done`，`fail`，`progress`，用于监测所有的图片的加载事件、监测图片成功加载，监测图片载失败或在图像加载中状态。


## 小结

`v-dummy` 软件包允许我们在开发过程中创建占位符文本和图像，这样我们就不必亲自创建了。

我们可以使用 Vue.ImageLoaded 软件包来监测图像加载的过程。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
