> * 原文地址：[Using Immer with React: a simple Solutions for Immutable States](https://blog.bitsrc.io/using-immer-with-react-a-simple-solutions-for-immutable-states-a6ebb8b0bfa)
> * 原文作者：[Madushika Perera](https://medium.com/@LMPerera)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/using-immer-with-react-a-simple-solutions-for-immutable-states.md](https://github.com/xitu/gold-miner/blob/master/article/2021/using-immer-with-react-a-simple-solutions-for-immutable-states.md)
> * 译者：
> * 校对者：

# Using Immer with React: a simple Solutions for Immutable States

## Using Immer with React: a Simple Solutions for Immutable States

#### Why Immer works well for React State Immutability?

![](https://cdn-images-1.medium.com/max/5760/1*7V7cegDUA84z--4d6GflYg.jpeg)

In React, using an Immutable state enables quick and cheap comparison of the state tree before and after a change. As a result, each component decides whether to re-rendered or not before performing any costly DOM operations.

And I hope you already know that;

> # JavaScript is mutable, and we have to implement Immutability ourselves.

Popular state management libraries like Redux also follow the same philosophy. When we use reduces, it expects us not to mutate state to avoid any side effects in the application. However, manually implementing Immutability might not be the best option for large-scale projects where it could become error-prone.

---

> # Luckily there are specialized JavaScript libraries like [Immer](https://immerjs.github.io/immer/docs/introduction), which enforces Immutability of the state tree by design.

## What is Immer and How It Works

Immer is a small library created to help developers with immutable state based on a **copy-on-write** mechanism, a technique used to implement a copy operation on modifiable resources.

In Immer, there are 3 main states.

1. Current State: Actual state data
2. Draft State: All the changes will be applied to this state.
3. Next State: This state is produced based on the mutations to the draft state.

![Immer states](https://cdn-images-1.medium.com/max/2000/1*-LI_oJ_e_DpY2mahvV1Hug.png)

Immer performs quite well from performance perspectives compared to Shallow copy using **object.assign()** or Spread operator in JavaScript. If you are interested to know more about performance comparisons, refer the article [Immer vs Shallow copy vs Immutable Perf Test](https://www.measurethat.net/Benchmarks/Show/6108/0/immer-vs-shallow-copy-vs-immutable-perf-test) to understand the benchmarks.

![Performance comparison of Immer and shallow copy](https://cdn-images-1.medium.com/max/2000/1*5m8fOSOiL4W6nb7mwc2AxA.png)

Immer also reduces the amount of code that you need to write to achieve the above benchmark results, and that is one reason why Immer stands out from the rest.

---

Since you have a basic understanding of Immer, let’s see why Immer is recognized as one of the best solutions for immutability.

## Why Immer works well for React State Immutability?

You might get the feeling that Immer is complicating your code if you are working with simple states. But, Immer becomes very useful when it comes to handling more complex data.

To better understand that, let’s consider the famous React reducer example:

```
export default (state = {}, action) => {
    switch (action.type) {
        case GET_ITEMS:
            return {
                ...state,
                ...action.items.reduce((obj, item) => {
                    obj[item.id] = item
                    return obj
                }, {})
            }
        default:
            return state
    }
}
```

The code above shows a typical reducer of a React-Redux that uses ES6 spread operator to dive into the state tree object’s nested levels to update the values. We can easily reduce the complexity in the above code using Immer.

Let’s take an example how we can use Immer to reduce the complexity in practice.

```
import produce from "immer"

export default produce((draft, action) => {
    switch (action.type) {
        case GET_ITEMS:
            action.items.forEach(item => {
                draft[item.id] = item
            })
    }
}, {})
```

> # In this example, Immer simplifies the code used to spread the state. You can also see that it **mutates the object** by using a **ForEach** loop instead of an ES6 **reduce** function.

Let’s see another example where we could use Immer with React.

```
import produce from "immer";

this.state={
    id: 14,
    email: "stewie@familyguy.com",
    profile: {
      name: "Stewie Griffin",
      bio: "You know, the... the novel you've been working on",
      age:1
    }
}

changeBioAge = () => {
    this.setState(prevState => ({
        profile: {
            ...prevState.profile,
            age: prevState.profile.age + 1
        }
    }))
}
```

This code can be refactored by mutating the state like below

```
changeBioAge = () => {
    this.setState(
        produce(draft => {
            draft.profile.age += 1
        })
    )
}
```

---

As you can see, Immer has reduced the number of code lines and your code’s complexity drastically.

Tip: **Share your React components** between projects using [**Bit**](https://bit.dev/) ([Github](https://github.com/teambit/bit)).

Bit components are independent modules that can be consumed, maintained, and developed independently. Use them to maximize code resue, keep a consistent design across apps, and collaborate more effectively.

---

![Exploring React components shared using [Bit](https://bit.dev)](https://cdn-images-1.medium.com/max/2000/1*T6i0a9d9RykUYZXNh2N-DQ.gif)

## Can We Use it with Hooks?

Another significant feature of Immer is its ability to work with React Hooks. Immer uses an additional library called **use-immer** to achieve this functionality. Let's consider an example to get a better understanding.

```
const [state, setState] = useState({
    id: 14,
    email: "stewie@familyguy.com",
    profile: {
      name: "Stewie Griffin",
      bio: "You know, the... the novel you've been working on",
      age:1
    }
  });

function changeBio(newBio) {
    setState(current => ({
      ...current,
      profile: {
        ...current.profile,
        bio: newBio
      }
    }));
  }
```

We can further simplify the Hooks example by replacing **useState** with **useImmer** Hook. And we can also update the React component by mutating the component state.

```
import { useImmer } from 'use-immer';

const [state, setState] = useImmer({
    id: 14,
    email: "stewie@familyguy.com",
    profile: {
      name: "Stewie Griffin",
      bio: "You know, the... the novel you've been working on",
      age:1
    }
 });

function changeBio(newBio) {
   setState(draft => {
      draft.profile.bio = newBio;
    });
  }
```

Also, we can use Immer to convert arrays and sets to immutable objects as well. **Maps**, **Sets** created through Immer will throw errors when it is mutated, allowing the developers to be aware of the mistake of mutation.

> # Most importantly, Immer is not limited for React. You can easily use Immer with plain JavaScript as well.

---

Apart from Immutating, Immer helps maintain well written, readable codebase by reducing your codebase’s complexity.

## Final Thoughts

Based on my experience with Immer, I believe it is a great option to use with React. It will simplify your code and help to manage immutability by design.

You can find more information on Immer by referring to their [documentation](https://immerjs.github.io/immer/docs/introduction).

---

Thank you for Reading !!!

## Learn More
[**Build Scalable React Apps by Sharing UIs and Hooks**
**How to build scalable React apps with independent and shareable UI components and hooks.**blog.bitsrc.io](https://blog.bitsrc.io/build-scalable-react-apps-by-sharing-uis-and-hooks-fa2491e48357)
[**New JSX Enhancements in React 17**
**What’s New for JSX in React 17 and Why You Should Care**blog.bitsrc.io](https://blog.bitsrc.io/new-jsx-enhancements-in-react-17-e5f64acbea89)
[**Incremental vs Virtual DOM**
**Will Incremental DOM Replace Virtual DOM in the Near Future**blog.bitsrc.io](https://blog.bitsrc.io/incremental-vs-virtual-dom-eb7157e43dca)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
