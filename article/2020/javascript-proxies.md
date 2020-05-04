> * 原文地址：[JavaScript Proxies](https://medium.com/javascript-in-plain-english/javascript-proxies-b41abcdd2bda)
> * 原文作者：[Dornhoth](https://medium.com/@dornhoth)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/javascript-proxies.md](https://github.com/xitu/gold-miner/blob/master/article/2020/javascript-proxies.md)
> * 译者：
> * 校对者：

# JavaScript Proxies

![Photo by [Tim Mossholder](https://unsplash.com/@timmossholder?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/private?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/13200/1*MrmHIH3lN9LjMFcWS8GSVQ.jpeg)

Proxies are an ES6 feature enabling to monitor how a given object is accessed. For example, let’s say we have an object `alice` that contains some information about Alice, like her birthdate, her age, her height, her weight and her BMI.

```js
const alice = {
  birthdate: '2000-04-06',
  age: 20,
  height: 170,
  weight: 65,
  bmi: 22.5,
};
```

Properties can be simply read and set by doing:

```js
console.log(alice.height);
console.log(alice.age);
alice.weight = 64;
```

This object might be used by other parts of the code and a few problems can occur. We might want to let external consumers of the object change the weight of Alice, but not her birthdate. If she is a grown up, changing her height also doesn’t make much sense. We should recalculate the BMI if her weight changes. And her age should probably be calculated when being requested.

An idea would be to create methods like `getAge` or `setWeight`. That would partially work, but wouldn’t prevent anyone from simply doing `alice.weight = 64;`. JavaScript doesn’t natively have private fields.

A native JavaScript solution is to use a proxy. A proxy is simply a wrapper around your original object (called the **target**).

```js
const handler = {};
const proxy = new Proxy(alice, handler);
```

You create it by calling the `Proxy` constructor, to which you pass the **target**, in our case ****`alice`, and a **handler** as an argument. The **handler** is an object in which we can define how each property should be accessed. In this example, our **handler** is empty, so the proxy just forwards every access request to the object.

```js
console.log(proxy.age); // 20
console.log(proxy.height); // 170
```

Let’s now use the **handler** to define what is returned when the `age` property is read.

```js
const handler = {
  get (target, key) {
    if (key === 'age') {
      return calculateAge(new Date(target.birthdate));
    }
    return target[key];
  }
};
const proxy = new Proxy(alice, handler);
```

Here is the `calculateAge` function if you are testing along:

```js
const calculateAge = (birthdate) => {
  const today = new Date();
  let age = today.getFullYear() - birthdate.getFullYear();
  const m = today.getMonth() - birthdate.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < birthdate.getDate())) {
    age--;
  }
  return age;
}
```

Our **handler** now contains a `get `**trap**. When trying to read any property of the proxy, this `get` function is going to be called with the `target` ( `alice` ) and the `key`. When trying to read the `age` , instead of simply returning `alice.age`, we return a calculated value from the `birhdate`. For any other property, we just return `target[key]` .

You can test:

```js
alice.age = 22;
console.log(proxy.age); // 20
console.log(proxy.height); // 170
```

We can also define a `set` trap, defining if and how properties should be set. For example we want to prevent the birthdate property to be set and we want to recalculate the BMI if the weight is changed:

```js
const handler = {
  get (target, key) {
    ...
  },
  set (target, key, value) {
    if (key === 'birthdate') {
      throw new Error('Birthdate is readonly');
    } else if (key === 'weight') {
      const { height } = target;
      target.bmi = Math.round(
        value / (height / 100 * height / 100) * 100
      ) / 100;
    }
    return true;
  }
};
```

If you try to set a new birthdate you are now going to receive an error:

![](https://cdn-images-1.medium.com/max/2000/1*F8c3i-QoEFYTEsXGLSAbiA.png)

Every property is otherwise set to the value (this is what the `return true;` means). When the weight is being set we now recalculate the BMI. You can test that:

```js
console.log(proxy.bmi); // 22.5
proxy.weight = 63;
console.log(proxy.bmi); // 21.8
```

We could do something similar for other readonly properties like `age` and `height` . We could also add `_` in front of their names and write our `set` trap a way that an error is thrown for any property with a name starting with `_`.

By the way, all this is only worth if you don’t give access to the `alice` object but only to the `proxy`. The `alice` object should therefore not be exported.

There are more traps than just `set` and `get` . You can for example define the behavior when:

* a property is being deleted ( `delete alice.height;` ) with the `deleteProperty` trap.
* it is being checked if a property exists on the object ( `console.log('age' in proxy);` ) with the `has` trap.
* a new property is defined on the proxy (`proxy.name = 'Alice';` ) with the `defineProperty` trap.

There is a long list of possible traps, I just listed the most commons here. You can find the whole list [here](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy).

---

Proxies let you control how fields are accessed, if and how fields can be read, modified, added or deleted, and generally let you monitor everything that can be done to your object. They are really helpful to implement a kind of encapsulation in JavaScript. As a matter of example, they can be used for validation (write the validation in the `set` trap of the proxy), to change a value before setting it (transform a `string` into a `Date` for example) or trace and log changes to an object.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
