> * 原文地址：[How I finally got my head around Scoped Slots in Vue](https://medium.com/@ross_65916/how-i-finally-got-my-head-around-scoped-slots-in-vue-c37238d4d4cc)
> * 原文作者：[Ross Coundon](https://medium.com/@ross_65916)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/How-I-finally-got-my-head-around-Scoped-Slots-in-Vue.md](https://github.com/xitu/gold-miner/blob/master/TODO1/How-I-finally-got-my-head-around-Scoped-Slots-in-Vue.md)
> * 译者：[shixi-li](https://github.com/shixi-li)
> * 校对者：[brilliantGuo](https://github.com/brilliantGuo), [xionglong58](https://github.com/xionglong58)

# 我最终是怎么玩转了 Vue 的作用域插槽

<div align="center"><img src="https://cdn-images-1.medium.com/max/800/1*zyNSb0UXhP8TfxYbj-GNWg.png" height="400" width="400"></div>

Vue 是一个用于构建 Web 应用程序的前端框架，其设计方式使得开发人员可以非常快速地提高工作效率。该框架的各个方面都有很多资料，它的社区也每天都在不断成长。如果你读到了这篇文章，那么这些事儿你很可能已经知道咯。

虽然我们可以快速直接地启动并运行它，但是框架里面那些更复杂和更强大的地方还是需要好好动动脑子才能理解（至少对我是这样）。其中一个是插槽，还有另一个与之相关但功能上不太相同的就是作用域插槽。我学习的时候花了好一阵才理解插槽工作的机制，所以我觉得将我对插槽的理解分享出来是有价值的，因为这没准会帮助到大家。

## 插槽和具名插槽

父组件以另外一种方式（不是通过常规的 Props 属性传递机制）向子组件传递信息。我发现把这种方法同常规的 HTML 元素联系起来很有帮助。

比如说 HTML 标签。

```
<a href=”/sometarget">This is a link</a>
```

比如在 Vue 环境中并且 <a> 是你的组件，那么你需要发送“This is a link”信息到‘a’组件里面，然后它将被渲染成为一个超链接，而“This is a link”就是这个链接的文本。

让我们定义一个子组件来展示它的机制是怎样的：

```
<template>  
  <div>  
    <slot></slot>  
  </div>  
</template>
```

然后在父组件我们这么做：

```
<template>  
  <div>  
    <child-component>This is from outside</child-component>  
  </div>  
</template>
```

这时候屏幕上呈现的就应该和你预期的一样就是“This is from outside”，但这是由子组件所渲染出来的。

我们还可以给子组件添加默认的信息，以免到时候这里出现什么都没有传入的情况，就像这样子：

```
<template>  
  <div>  
    <slot>Some default message</slot>  
  </div>  
</template>
```

然后如果我们像这样子创建我们的子组件：

```
<child-component>  
</child-component>
```

我们可以看到屏幕上会呈现“Some default message”。

具名插槽和常规插槽非常类似，唯一的差别就是你可以在你的目标组件多个位置传入你的文本。

我们把子组件升级一下，让它有多个具名插槽

```
<template>  
  <div>  
    <slot>Some default message</slot>  
    <br/>  
    <slot _name_="top"></slot>  
    <br/>  
    <slot _name_="bottom"></slot>  
  </div>  
</template>
```

这样,在我们的子组件中就有了三个插槽。其中 top 和 bottom 插槽是具名插槽。

让我们更新父组件以使用它。

```
<child-component _v-slot:top_>  
Hello there!  
</child-component>
```

注意 —— 我们在这里使用新的 Vue 2.6 语法来指定我们想要定位的插槽：\`v-slot:theName\`。

你现在认为会在屏幕上看到什么呢？如果你说是“Hello Top!”，那么你就只说对了一部分。

因为我没有为没有具名的插槽赋予任何值，我们因此也还会得到默认值。所以我们真正会看到的是：

Some default message  
Hello There!

其实真正意义上没有具名的插槽是被当作‘default’，所以你还可以这么做：

```
<child-component _v-slot:default_>  
Hello There!  
</child-component>
```

现在我们就只会看到：

Hello There!

因为我们已经提供了值给默认（也就是未具名）插槽，因此具名插槽‘top’和‘bottom’也都没有默认值。

你发送的并不一定只是文本，还可以是其他组件或者 HTML。你可以发送任意你想展示的内容。

## 作用域插槽

![](https://cdn-images-1.medium.com/max/800/1*DNFusxSTHQwwoeWD9iNUrQ.jpeg)

我认为插槽和具名插槽相对简单，一旦你稍微玩玩就可以掌握。可另一方面，作用域插槽虽然名字相似但又有些不同之处。

我倾向于认为作用域插槽有点像一个放映机（或者是一个我欧洲朋友的投影仪）。以下是原因。

子组件中的作用域插槽可以为父组件中的插槽的显示提供数据。这就像一个人带着放映机站在你的子组件里面，然后在父组件的墙上让一些图像发光。

这有一个例子。在子组件中我们像这样设置了一个插槽：

```
<template>  
  <div>  
    <slot _name_="top" _:myUser_="user"></slot>  
    <br/>  
    <slot _name_="bottom"></slot>  
    <br/>  
  </div>  
</template>

<script>

data() {  
  _return_ {  
    user: "Ross"  
  }  
}

</script>
```

注意到我们的具名插槽‘top’现在有了一个名为‘myUser’的属性，然后我们绑定了一个动态的值在‘user’中。

在我们的父组件中就像这样子设置子组件：

```
<div>  
   <child-component _v-slot:top_="slotProps">{{ slotProps }}</child-component>  
</div>
```

我们在屏幕上看到的就是这样子：

{ “myUser”: “Ross” }

还是使用放映机的类比，我们的子组件通过 myUser 对象将其用户字符串的值传递给父组件。它在父组件上投射到的墙就被称为‘slotProps’。

我知道这不是一个完美的类比，但当我第一次尝试理解这个机制的时候，它帮助我以这种方式思考。

Vue 的文档非常好，而且我也已经看到了一些其他关于作用域插槽工作机制的说明。但很多人采取的方法似乎是将父组件中的所有或部分属性命名为与子组件相同，我认为这会使得数据很难被追踪。

在父组件中使用 ES6 解构，我们这样子写还可以将特定 user 对象从插槽属性（你可以随便怎么称呼它）解脱出来：

```
<child-component _v-slot:top_="{myUser}">{{ myUser }}</child-component>
```

或者甚至就只是在父组件中给它一个新的名字：

```
<child-component _v-slot:top_="{myUser: aFancyName}">{{ aFancyName }}</child-component>
```

所有都是通过 ES6 解构，与 Vue 本身并没有什么关系。

如果你正开始使用 Vue 和插槽，希望这可以让你起步并解决一些棘手的问题。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

