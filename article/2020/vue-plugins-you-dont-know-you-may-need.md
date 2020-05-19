> * 原文地址：[Vue Plugins You Don’t Know You May Need](https://medium.com/swlh/vue-plugins-you-dont-know-you-may-need-573902dfdbae)
> * 原文作者：[John Au-Yeung](https://medium.com/@hohanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/vue-plugins-you-dont-know-you-may-need.md](https://github.com/xitu/gold-miner/blob/master/article/2020/vue-plugins-you-dont-know-you-may-need.md)
> * 译者：
> * 校对者：

# Vue Plugins You Don’t Know You May Need

![Photo by [Creative Nerds](https://unsplash.com/@creativenerds?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8000/0*rwLCSJM5TWHmJPtB)

Vue.js is an easy to use web app framework that we can use to develop interactive front end apps.

In this article, we’ll look at some Vue packages you don’t know you want to add to your app.

## Vue-Dummy

The `vue-dummy` package lets us add dummy text to our app when while we’re developing it so we won’t have to worry about generating the text ourselves. We can also add placeholder images with it.

We can install it by running:

```bash
npm install --save vue-dummy
```

It’s also available as a standalone script that we can add by adding:

```html
<script src="https://unpkg.com/vue-dummy"></script>
```

to our HTML code.

Then we can use it as follows:

`main.js` :

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

In the code above, we added a p element and bind it to the `v-dummy` directive. We set the value to 150 so that we get 150 fake words on the page.

Next, we added an image that’s 200px wide by 150px high.

We can also have a random number of words between a range for the dummy text. To use this feature, we can write:

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

Then we get a random block of text between 100 to 130 words. It can also be written as a directive argument. For instance, we can write:

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

to do the same thing we did in the previous example.

Likewise, dummy images dimensions can be set as directive arguments or modifiers.

To set dummy image dimensions as an argument, we can write:

```html
<img v-dummy:300x200>
```

To set dummy image dimensions as a directive modifer, we can write:

```html
<img v-dummy.400x300>
```

We can also set the width and height attributes of the `img` tag to set its dimensions:

```html
<img v-dummy width="250" height="150">
```

We can also create randomly sized images:

```html
<img v-dummy="'100,400x200,400'">
```

The code above will create images that’s between 100 to 400px wide and 200 to 400px high.

We can also put the numbers as a directive argument as follows:

```html
<img v-dummy:100,400x200,400>
```

The `dummy` component is also available to generate the placeholder text or image as follows:

```html
<dummy text="100"></dummy>
<dummy img="420x300"></dummy>
```

The first line creates a text block that’s 100 words long, and the 2nd creates a placeholder image that’s 420px wide by 300px high.

We can also create a table with fake content as follows:

```html
<table v-dummy></table>
```

## Vue.ImagesLoaded

The Vue.ImagesLoaded directive detects whether an image has been loaded.

It calls a callback when the image is loaded or fails to load. We can install it by running:

```bash
npm install vue-images-loaded --save
```

Then we can use it as follows:

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

In the code above, we registered the `imagesLoaded` directive from the `vue-image-loaded` package in our `App` component.

Then we added the v-images-loaded:on.progress=”imageProgress” directive with the `imageProgress` method as the value.

Then we can get whether the image is loaded from the `image` parameter’s `isLoaded` property.

The `instance` parameter has the `elements` property with an array for the parent of the image element that’s being loaded. The `images` property has an array of image elements for the images that are being loaded.

Other modifiers for the `v-images.on` directive include `always`, `done`, `fail`, `progress` to watch for all image loading events, watching only when the image is successfully loaded, watch only when it fails to load or watch the image when it’s loading respectively.

## Conclusion

The `v-dummy` package lets us create placeholder text and images during development so we don’t have to do that ourselves.

To watch the progress of image loading, we can use the Vue.ImageLoaded package to do that.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
