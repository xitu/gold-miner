> * 原文地址：[The Best Explanation of JavaScript Reactivity 🎆](https://medium.com/vue-mastery/the-best-explanation-of-javascript-reactivity-fea6112dd80d)
> * 原文作者：[Gregg Pollack](https://medium.com/@greggpollack?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-best-explanation-of-javascript-reactivity.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-best-explanation-of-javascript-reactivity.md)
> * 译者：
> * 校对者：

# The Best Explanation of JavaScript Reactivity 🎆

Many front-end JavaScript frameworks (Ex. Angular, React, and Vue) have their own Reactivity engines. By understanding what reactivity is and how it works, you can improve your development skills and more effectively use JavaScript frameworks. In the video and the article below, we build the same sort of Reactivity you see in the Vue source code.

* YouTube 视频链接：https://youtu.be/7Cjb7Xj8fEI

_If you watch this video instead of reading the article, watch the_ [_next video in the series_](https://www.vuemastery.com/courses/advanced-components/evan-you-on-proxies/) _discussing reactivity and proxies with Evan You, the creator of Vue._

### 💡 The Reactivity System

Vue’s reactivity system can look like magic when you see it working for the first time. Take this simple Vue app:

![](https://cdn-images-1.medium.com/max/800/1*aLjr0oQBzX7PoUF6oL7yfQ.png)

![](https://cdn-images-1.medium.com/max/800/1*neR2Y-0zJseWT8oY1JukXA.png)

Somehow Vue just knows that if `price` changes, it should do three things:

*   Update the `price` value on our webpage.
*   Recalculate the expression that multiplies `price` `*` `quantity`, and update the page.
*   Call the `totalPriceWithTax` function again and update the page.

But wait, I hear you wonder, how does Vue know what to update when the `price` changes, and how does it keep track of everything?

![](https://cdn-images-1.medium.com/max/800/1*t8enMn6h0gjY6HNKoSVC1g.jpeg)

**This is not how JavaScript programming usually works**

If it’s not obvious to you, the big problem we have to address is that programming usually doesn’t work this way. For example, if I run this code:

![](https://cdn-images-1.medium.com/max/800/1*RrDCv_fUYnOl34Eq0afgYw.png)

What do you think it’s going to print? Since we’re not using Vue, it’s going to print `10`.

![](https://cdn-images-1.medium.com/max/800/1*q7nHV9seYErboH1DDiEdUg.png)

In Vue we want `total` to get updated whenever `price` or `quantity` get updated. We want:

![](https://cdn-images-1.medium.com/max/800/1*aFGF-Go7ONnOtWjfyzytig.png)

Unfortunately, JavaScript is procedural, not reactive, so this doesn’t work in real life. In order to make `total` reactive, we have to use JavaScript to make things behave differently.

### ⚠️ Problem

We need to save how we’re calculating the `total`, so we can re-run it when `price` or `quantity` changes.

### ✅ Solution

First off, we need some way to tell our application, “The code I’m about to run, **store this**, I may need you to run it at another time.” Then we’ll want to run the code, and if `price` or `quantity` variables get updated, run the stored code again.

![](https://cdn-images-1.medium.com/max/800/0*Nh-FQoHiDHncmQSi.png)

We might do this by recording the function so we can run it again.

![](https://cdn-images-1.medium.com/max/800/1*vD19ImKAK2WYySJGIvrKtQ.png)

Notice that we store an anonymous function inside the `target` variable, and then call a `record` function. Using the ES6 arrow syntax I could also write this as:

![](https://cdn-images-1.medium.com/max/800/1*z0E_bw1_XBjGdM0ab_pyDg.png)

The definition of the `record` is simply:

![](https://cdn-images-1.medium.com/max/800/1*6tRbHmwr7mzy5CNemhkTcg.png)

We’re storing the `target` (in our case the `{` `total = price * quantity` `}`) so we can run it later, perhaps with a `replay` function that runs all the things we’ve recorded.

![](https://cdn-images-1.medium.com/max/800/1*dyxkUSFl1S3m4dFCgc2jZw.png)

This goes through all the anonymous functions we have stored inside the storage array and executes each of them.

Then in our code, we can just:

![](https://cdn-images-1.medium.com/max/800/1*Fr8Oif-PkvmyFDKDt5Xm6w.png)

Simple enough, right? Here’s the code in it’s entirety if you need to read through and try to grasp it one more time. FYI, I am coding this in a particular way, in case you’re wondering why.

![](https://cdn-images-1.medium.com/max/800/1*TpEBEstjfM4FNMYuh37BLA.png)

![](https://cdn-images-1.medium.com/max/800/0*0a_165xKF15xL889.png)

### ⚠️ Problem

We could go on recording targets as needed, but it’d be nice to have a more robust solution that will scale with our app. Perhaps a class that takes care of maintaining a list of targets that get notified when we need them to get re-run.

### ✅ Solution: A Dependency Class

One way we can begin to solve this problem is by encapsulating this behavior into its own class, a **Dependency Class** which implements the standard programming observer pattern.

So, if we create a JavaScript class to manage our dependencies (which is closer to how Vue handles things), it might look like this:

![](https://cdn-images-1.medium.com/max/800/1*9NnQmGxZfmxhRJBUEs4Z7g.png)

Notice instead of `storage` we’re now storing our anonymous functions in `subscribers`. Instead of our `record` function we now call `depend` and we now use `notify` instead of `replay`. To get this running:

![](https://cdn-images-1.medium.com/max/800/1*Y5XJpipq7-Po1mP_eJoCGw.png)

It still works, and now our code feels more reusable. Only thing that still feels a little weird is the setting and running of the `target`.

### ⚠️ Problem

In the future we’re going to have a Dep class for each variable, and it’ll be nice to encapsulate the behavior of creating anonymous functions that need to be watched for updates. Perhaps a `watcher` function might be in order to take care of this behavior.

So instead of calling:

![](https://cdn-images-1.medium.com/max/800/1*mo9tPOcAy-qC1VZ6Bnz76A.png)

(this is just the code from above)

We can instead just call:

![](https://cdn-images-1.medium.com/max/800/1*2TPYfKaV4UBEReN8PWwzbQ.png)

### ✅ Solution: A Watcher Function

Inside our Watcher function we can do a few simple things:

![](https://cdn-images-1.medium.com/max/800/1*U7bJcE5Ad7lxbQUP-U68uw.png)

As you can see, the `watcher` function takes a `myFunc` argument, sets that as a our global `target` property, calls `dep.depend()` to add our target as a subscriber, calls the `target` function, and resets the `target`.

Now when we run the following:

![](https://cdn-images-1.medium.com/max/800/1*vefCUnWyacq0GxC3TRI0Cw.png)

![](https://cdn-images-1.medium.com/max/800/0*D05AHN0_GUXoMVM8.png)

You might be wondering why we implemented `target` as a global variable, rather than passing it into our functions where needed. There is a good reason for this, which will become obvious by the end of our article.

### ⚠️ Problem

We have a single `Dep class`, but what we really want is each of our variables to have its own Dep. Let me move things into properties before we go any further.

![](https://cdn-images-1.medium.com/max/800/1*YBknbJTkI-za0L9eMAFayQ.png)

Let’s assume for a minute that each of our properties (`price` and `quantity`) have their own internal Dep class.

![](https://cdn-images-1.medium.com/max/800/0*kV4iCRoguwO5C_JQ.png)

Now when we run:

![](https://cdn-images-1.medium.com/max/800/1*-rznzvwxr5clvYdPVq2MfA.png)

Since the `data.price` value is accessed (which it is), I want the `price` property’s Dep class to push our anonymous function (stored in `target`) onto its subscriber array (by calling `dep.depend()`). Since `data.quantity` is accessed I also want the `quantity` property Dep class to push this anonymous function (stored in `target`) into its subscriber array.

![](https://cdn-images-1.medium.com/max/800/0*E-_YXfn3vJe7S_Ry.png)

If I have another anonymous function where just `data.price` is accessed, I want that pushed just to the `price` property Dep class.

![](https://cdn-images-1.medium.com/max/800/0*wefv6my2WWLW2385.png)

When do I want `dep.notify()` to be called on `price`’s subscribers? I want them to be called when `price` is set. By the end of the article I want to be able to go into the console and do:

![](https://cdn-images-1.medium.com/max/800/1*1XiVHkIOvqzIVOxNxYlsDA.png)

We need some way to hook into a data property (like `price` or `quantity`) so when it’s accessed we can save the `target` into our subscriber array, and when it’s changed run the functions stored our subscriber array.

### ✅ Solution: Object.defineProperty()

We need to learn about the [Object.defineProperty()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty) function which is plain ES5 JavaScript. It allows us to define getter and setter functions for a property. Lemme show you the very basic usage, before I show you how we’re going to use it with our Dep class.

![](https://cdn-images-1.medium.com/max/800/1*KLPITQjsRSoGjOBRc6Y8zA.png)

![](https://cdn-images-1.medium.com/max/800/0*i1g7DtASO4z1rOvk.png)

As you can see, it just logs two lines. However, it doesn’t actually `get` or `set` any values, since we over-rode the functionality. Let’s add it back now. `get()` expects to return a value, and `set()` still needs to update a value, so let’s add an `internalValue` variable to store our current `price` value.

![](https://cdn-images-1.medium.com/max/800/1*ek8RxCQ6pkLgbs-DJWteOg.png)

Now that our get and set are working properly, what do you think will print to the console?

![](https://cdn-images-1.medium.com/max/800/0*lwD5BfrrNiiZjhyw.png)

So we have a way to get notified when we get and set values. And with some recursion we can run this for all items in our data array, right?

FYI, `Object.keys(data)` returns an array of the keys of the object.

![](https://cdn-images-1.medium.com/max/800/1*56SYVD46rppSBl6mDzzsMg.png)

Now everything has getters and setters, and we see this on the console.

![](https://cdn-images-1.medium.com/max/800/0*VquzAf2KmijoTfbD.png)

### 🛠 Putting both ideas together

![](https://cdn-images-1.medium.com/max/800/1*2Nvu9DfFpp__k-HTMLSdYg.png)

When a piece of code like this gets run and **gets** the value of `price`, we want `price` to remember this anonymous function (`target`). That way if `price` gets changed, or is **set** to a new value, it’ll trigger this function to get rerun, since it knows this line is dependent upon it. So you can think of it like this.

**Get** => Remember this anonymous function, we’ll run it again when our value changes.

**Set** => Run the saved anonymous function, our value just changed.

Or in the case of our Dep Class

**Price accessed (get)** => call `dep.depend()` to save the current `target`

**Price set** => call `dep.notify()` on price, re-running all the `targets`

Let’s combine these two ideas, and walk through our final code.

![](https://cdn-images-1.medium.com/max/800/1*bM-LGqWYYU3lCaazJ7cAew.png)

And now look at what happens in our console when we play around.

![](https://cdn-images-1.medium.com/max/800/0*mgmRTNK_n0i2AFK2.png)

Exactly what we were hoping for! Both `price` and `quantity` are indeed reactive! Our total code gets re-run whenever the value of `price` or `quantity` gets updated.

This illustration from the Vue docs should start to make sense now.

![](https://cdn-images-1.medium.com/max/800/0*tB3MJCzh_cB6i3mS.png)

Do you see that beautiful purple Data circle with the getters and setters? It should look familiar! Every component instance has a `watcher` instance (in blue) which collects dependencies from the getters (red line). When a setter is called later, it **notifies** the watcher which causes the component to re-render. Here’s the image again with some of my own annotations.

![](https://cdn-images-1.medium.com/max/800/0*P268NBNs64Z-CERj.png)

Yeah, doesn’t this make a whole lot more sense now?

Obviously how Vue does this under the covers is more complex, but you now know the basics.

### ⏪ So what have we learned?

*   How to create a **Dep class** which collects a dependencies (depend) and re-runs all dependencies (notify).
*   How to create a **watcher** to manage the code we’re running, that may need to be added (target) as a dependency.
*   How to use **Object.defineProperty()** to create getters and setters.

### What Next?

If you enjoyed learning with me on this article, the next step in your learning path is to learn about [Reactivity with Proxies](https://www.vuemastery.com/courses/advanced-components/evan-you-on-proxies/). Definitely check out my [my free video](https://www.vuemastery.com/courses/advanced-components/evan-you-on-proxies/) on this topic on VueMastery.com where I also speak with Evan You, the creator of Vue.js.

* * *

_Originally published at_ [_www.vuemastery.com_](https://www.vuemastery.com/courses/advanced-components/build-a-reactivity-system/)_._

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
