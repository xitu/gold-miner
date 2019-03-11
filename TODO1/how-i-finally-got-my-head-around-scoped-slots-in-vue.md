> * 原文地址：[How I finally got my head around Scoped Slots in Vue](https://medium.com/@ross_65916/how-i-finally-got-my-head-around-scoped-slots-in-vue-c37238d4d4cc)
> * 原文作者：[Ross Coundon](https://medium.com/@ross_65916)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/How-I-finally-got-my-head-around-Scoped-Slots-in-Vue.md](https://github.com/xitu/gold-miner/blob/master/TODO1/How-I-finally-got-my-head-around-Scoped-Slots-in-Vue.md)
> * 译者：
> * 校对者：

# How I finally got my head around Scoped Slots in Vue

<div align="center"><img src="https://cdn-images-1.medium.com/max/800/1*zyNSb0UXhP8TfxYbj-GNWg.png" height="400" width="400"></div>

Vue is a front-end framework for building web applications designed in such a way that developers can become productive very quickly. There’s a tonne of great information out there on all aspects of the framework, and the community is growing every day. If you’re here reading this, chances are you know this already.

While it’s fast and straightforward to get up-and-running, there are elements of the framework that are more sophisticated and more powerful that take a bit more brainpower (at least for me) to understand. One of these areas is Slots and, the related but functionally somewhat different, Scoped Slots. It took a while for me to understand how Slots worked so when I did, I thought it’d be worthwhile to share how I think about Slots in case it’s helpful for anyone else.

## Slots and Named Slots

A regular Slot is a way for a parent component to send in some information to a child component outside of the standard Props mechanism. I find it helps me to relate this approach to regular HTML elements.

For example, take the <a> HTML tag.

```
<a href=”/sometarget">This is a link</a>
```

If this were Vue and <a> was your component then you’d be sending the text “This is a link” into the ‘a’ component, and it would render it as a hyperlink with “This is a link” as the text for that link.

Let’s define a child component to show how this works:

```
<template>  
  <div>  
    <slot></slot>  
  </div>  
</template>
```

Then from the parent, we do this:

```
<template>  
  <div>  
    <child-component>This is from outside</child-component>  
  </div>  
</template>
```

What we see rendered to the screen is, as you might expect, “This is from outside” but rendered by the child component.

We can also add default information in the child component, just in case nothing is passed in like this:

```
<template>  
  <div>  
    <slot>Some default message</slot>  
  </div>  
</template>
```

If we then create our child component like this:

```
<child-component>  
</child-component>
```

We see “Some default message” displayed on the screen.

A named slot is very similar to a regular slot except that you can have multiple places within your target component to where you send the text.

Let’s update the child component to include some named slots

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

Here we have three slots in our child component. Two have names — top and bottom.

Let’s update the parent component to make use of this.

```
<child-component _v-slot:top_>  
Hello there!  
</child-component>
```

Note — we’re using the new Vue 2.6 notation here to specify the slot we want to target: \`v-slot:theName\`

What do you expect to see rendered to the screen here? If you said “Hello Top!” you’d be partially right.

As we haven’t provided any value for the unnamed slot, we also get the default value. So what we actually see is:

Some default message  
Hello There!

Behind the scenes the unnamed slot is known as ‘default’, so you can also use:

```
<child-component _v-slot:default_>  
Hello There!  
</child-component>
```

and we’d only see:

Hello There!

Since we’re now providing the value for the default/unnamed slot and neither of the named slots ‘top’ or ‘bottom’ have default values.

What you send in doesn’t have to be just text, it can be other components too or HTML. You’re sending in content for display.

## Scoped Slots

![](https://cdn-images-1.medium.com/max/800/1*DNFusxSTHQwwoeWD9iNUrQ.jpeg)

I think slots and named slots are relatively straightforward to wrap your head around once you’ve played with them for a little bit. Scoped Slots on the other hand, while sharing the same name are a somewhat different beast.

I tend to think of Scoped Slots a bit like a projector (or a beamer for my European friends). Here’s why.

A Scoped Slot in a child component can provide data for presentation in the parent component using a slot. It’s like someone is standing inside your child component with a projector, shining some image on the wall of your parent component.

Here’s an example. In the child component we set up a slot like this:

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

Notice that the named slot ‘top’ has a prop now named ‘myUser’ and we’re binding that to a reactive data value contained in ‘user’.

In our parent component we set up the child component like so:

```
<div>  
   <child-component _v-slot:top_="slotProps">{{ slotProps }}</child-component>  
</div>
```

What we see on screen then is:

{ “myUser”: “Ross” }

To use the analogy of the projector, our child component is beaming the value of its user string, via the myUser object, into the parent. The wall it’s projected on to in the parent is called ‘slotProps’.

Not a perfect analogy, I know, but when I first was working out what was going on, it helped me to think about it in this way.

The Vue documentation is excellent and I’ve seen a fair few other descriptions of how Scoped Slots work online, but many seemed to take the approach of naming all or some of the properties in the parent the same as in the child which, for me, made it difficult to follow what was going on.

Using ES6 destructuring in the parent, we can also pull the user specifically out of slotProps (that can be called whatever you like) by writing:

```
<child-component _v-slot:top_="{myUser}">{{ myUser }}</child-component>
```

Or even give it a new name in the parent:

```
<child-component _v-slot:top_="{myUser: aFancyName}">{{ aFancyName }}</child-component>
```

All just ES6 destructuring, nothing really to do with Vue.

If you’re beginning your journey with Vue and slots, hopefully, that’s given you a leg up and demystified a few of the trickier parts.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
