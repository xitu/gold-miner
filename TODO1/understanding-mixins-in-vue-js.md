> * 原文地址：[Understanding Mixins in Vue JS](https://blog.bitsrc.io/understanding-mixins-in-vue-js-bdcf9e02a7c1)
> * 原文作者：[Nwose Lotanna](https://medium.com/@viclotana)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-mixins-in-vue-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-mixins-in-vue-js.md)
> * 译者：
> * 校对者：

# Understanding Mixins in Vue JS

A useful introduction to Mixins in Vue, why they are important and how to use them in your workflow.

![Photo by [Augustine Fou](https://unsplash.com/@augustinefou?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*gtfwEvDVwDgHMv7L)

## What are Mixins?

Mixins in Vue JS are basically a chunk of defined logic, stored in a particular prescribed way by Vue, which can be re-used over and over to add functionality to your Vue instances and components. So Vue mixins can be shared between multiple Vue components without the need to repeat code blocks. Anyone who has used the CSS pre-processor called SASS has a good idea of mixins.

## Before you start

This post is suited for intermediate frontend developers that use Vue JS, and so being conversant with beginner concepts and installation processes is assumed. Here are a few prerequisites you should already have before you start to use Vue CLI 3 through this article.

You will need:

* Node.js 10.x and above installed. You can verify if you do by running node -v in your terminal/command prompt.

* The Node Package Manager 6.7 or above (NPM) also installed.

* A code editor: Visual Studio Code is highly recommended. ([here’s why](https://blog.bitsrc.io/a-convincing-case-for-visual-studio-code-c5bcc18e1693?source=your_stories_page---------------------------))

* Vue latest version installed globally on your machine.

* Vue CLI 3.0 installed on your machine. To do this, uninstall the old CLI version first:

```
npm uninstall -g vue-cli
```

then install the new one:

```
npm install -g @vue/cli
```

OR

* Download a Vue starter project here:

[**viclotana/vue-canvas**: An optimized and ready-to-use vue application with the default babel and Eslint config](https://github.com/viclotana/vue-canvas)

* Unzip the downloaded project

* Navigate into the unzipped file and run the command to keep all the dependencies up-to-date:

```
npm install
```

## Why are Mixins important

1. With Vue mixins, you can easily adhere to the DRY principle in programming which simply ensures that you do not repeat yourself.

2. With Vue mixins, you also get a great option of flexibility, a mixin object contains options for Vue components so there is a mixing of both mixin and component options.

3. Vue mixins are also safe, they do not affect changes outside their defined scope if they are well written.

4. They are a great platform for code reusability.

> Mixins are a flexible way to distribute reusable functionalities for Vue components — Official Docs

## The problem mixins help to solve

One way to fully understand the importance of mixins in Vue is to see the re-use problem in action. If you have two components that contains a method that does exactly the same thing or performs the exact functionality in the two components like the simple example below:

Navigate into the project folder and to the src folder and create a components directory where you can then create two components: Test.vue and Modal.vue. Copy the code below to the appropriate components respectively.

```Vue
// Component 1
// src/components/Test.vue
<template>
  <div>
    <button v-on:click="clicked('you just clicked on button  1')">
      Button 1
    </button>
  </div>
</template>;
export default {
  name: "Test",
  methods: {
    clicked(value) {
      alert(value);
    }
  }
};
```

The component above displays a button that shows an alert modal when clicked. The second component below does exactly the same thing:

```Vue
// Component 2
// src/components/Modal.vue
<template>
  <div>
    <button v-on:click="clicked('you just clicked on button  2')">
      Button 2
    </button>
  </div>
</template>;

export default {
  name: "Modal",
  methods: {
    clicked(value) {
      alert(value);
    }
  }
};
```

Your App.vue file should have the both components imported and declared exactly like it is below:

```Vue
<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.png">
    <Test />
    <modal />
  </div>
</template>;
<script>
import Test from "./components/Test.vue";
import Modal from "./components/Modal.vue";
export default {
  name: "app",
  components: {
    Test,
    Modal
  }
};
</script>
```

So you can clearly see that we are repeating the click method code block in the both components and this is not very ideal as it is not an efficient way to handle memory resources and it also goes against the DRY principle.

## Introducing Vue Mixins

The team at Vue has now introduced the mixins as a good solution to this problem, with mixins you can encapsulate a piece of code or functionality and then import it for use as often as you want in various components.

## Mixin syntax

Vue Mixin from definition to usage looks like this:

```Vue
// define a mixin object
var myMixin = {
  created: function() {
    this.hello();
  },
  methods: {
    hello: function() {
      console.log("hello from mixin!");
    }
  }
};
// define a component that uses this mixin
var Component = Vue.extend({
  mixins: [myMixin]
});
var component = new Component(); // => "hello from mixin!"
```

## Demo

You are going to use Vue mixins to rebuild the two components we initially used at the beginning of this post to illustrate the problem. To use mixins in a Vue application, you have to pass through four stages:

* Create the mixin file.
* Import the mixin file into the needed component.
* Remove the repeated logic from said components.
* Register the mixin.

### Creating the mixin file

A mixin file is an exportable javascript file in which the block of code or functionality to be imported and re-used in your various desired Vue components is defined. For developers like myself who like to keep things very modular, create a Mixins folder inside the src folder and then create a clickMixin.js file inside it. Copy the code below into the newly created file.

```JavaScript
// src/mixins/clickMixin.js
export default {
  methods: {
    clicked(value) {
      alert(value);
    }
  }
};
```

This is the the mixin file, inside is a simple click method that pops up an alert modal. It can be any logic at all, it can have data options, computed properties and anything a Vue component can have. The possibilities are really only limited to your imagination and use case as a developer.

### Importing the mixin file into components

Now that a mixin has been created, the next step is to inject it inside the components where it is needed: where the functionality should come to play. In our demonstration above, that would be inside the two components we already created in the beginning of this post. Import the clickMixin inside the two components with the command below:

```
import clickMixin from ‘../Mixins/clickMixin’
```

### Removing repeated logic

After importing the mixin, you have to remove the logic you had initially as it is now being taken care of by the mixin. In our case, this means that you will delete the method creation logic in the both components.

```
// remove this code block and the comma before it.

methods: {

 clicked(value){

  alert(value);

  }

}
```

### Register the mixin

This is where you tell the Vue application that what you imported is a mixin and so it should treat the logic inside it as one and do the dirty work of ensuring the application fixes the functionality and the method calls at the appropriate places in the component. Mixins in Vue by default are registered as arrays like it is below:

```Vue
<script>
import clickMixin from '../Mixins/clickMixin'
export default {
 name: 'Test',
 mixins: [clickMixin]
}
</script>
```

If you followed through from the start, your application components should be like it is below:

**Test.vue**

```Vue
<template>
  <div>
    <button v-on:click="clicked('you just clicked on button 1')">
      Button 1
    </button>
  </div>
</template>;
<script>
import clickMixin from "../Mixins/clickMixin";
export default {
  name: "Test",
  mixins: [clickMixin]
};
</script>
```

**Modal.vue**

```Vue
<template>
  <div>
    <button v-on:click="clicked('you just clicked on button 2')">
      Button 2
    </button>
  </div>
</template>;
<script>
import clickMixin from "../Mixins/clickMixin";
export default {
  name: "Modal",
  mixins: [clickMixin]
};
</script>
```

**App.vue**

```Vue
<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.png" />
    <Test msg="Welcome to Your Vue.js App" />
    <modal />
  </div>
</template>;
<script>
import Test from "./components/Test.vue";
import Modal from "./components/Modal.vue";
export default {
  name: "app",
  components: {
    Test,
    Modal
  }
};
</script>
<style>
#app {
font-family: 'Avenir', Helvetica, Arial, sans-serif;
-webkit-font-smoothing: antialiased;
-moz-osx-font-smoothing: grayscale;
text-align: center;
color: #2c3e50;
margin-top: 60px;
}
button {
background-color: #10776e; /* Green */
border: none;
margin: 5px;
color: white;
padding: 15px 32px;
text-align: center;
text-decoration: none;
display: inline-block;
font-size: 16px;
}
</style>
```

## Types of Mixins

There are two types of mixins in Vue:

1. **Local Mixins:** This is the type we have treated throughout this post. It is scoped to the component it is imported into and registered in. The powers of the local mixin is bound by the component it is imported in.

2. **Global Mixins:** This is a different type of mixin that is defined in the Main.js file of any Vue project. It affects all Vue components in an application so the Vue team advises that it be used with caution. A definition of a global mixin looks like this:

```JavaScript
Vue.mixin({
  mounted() {
    console.log("hello world!");
  }
});
```

## Important things to note

In the hierarchy of things in a Vue application, inside a component mixins are applied first by default. The component is applied second, so that it can override the mixin in any case. So it is important to always remember that when there is a kind of conflict of authority, the Vue component will always have the final say and overriding powers.

## Conclusion

You have been introduced to the concept of mixins in Vue, the types and how they are used with a sample demonstration. It is important you also remember to stick to local mixins and only use global mixins in rare cases when you really need it. Happy coding!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
