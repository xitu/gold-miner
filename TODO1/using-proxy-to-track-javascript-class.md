> * 原文地址：[Using Proxy to Track Javascript Class](https://medium.com/front-end-weekly/using-proxy-to-track-javascript-class-50a33a6ccb)
> * 原文作者：[Amir Harel](https://medium.com/@amir.harel)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-proxy-to-track-javascript-class.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-proxy-to-track-javascript-class.md)
> * 译者：[SHERlocked93](https://github.com/SHERlocked93)
> * 校对者：[salomezhang](https://github.com/salomezhang)、[cyuamber](https://github.com/cyuamber)

# 使用 Proxy 来监测 Javascript 中的类

![](https://cdn-images-1.medium.com/max/800/0*kcmAY6tU-LtxRRov)

Photo by [Fabian Grohs](https://unsplash.com/@grohsfabian?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral)

Proxy 对象（[Proxy](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy)）是 ES6 的一个非常酷却鲜为人知的特性。虽然这个特性存在已久，但是我还是想在本文中对其稍作解释，并用一个例子说明一下它的用法。

### 什么是 Proxy

正如 MDN 上简单而枯燥的定义：

> **Proxy** 对象用于定义基本操作的自定义行为（如属性查找，赋值，枚举，函数调用等）。

虽然这是一个不错的总结，但是我却并没有从中搞清楚 Proxy 能做什么，以及它能帮我们实现什么。

首先，Proxy 的概念来源于元编程。简单的说，元编程是允许我们运行我们编写的应用程序（或核心）代码的代码。例如，臭名昭著的 `eval` 函数允许我们将字符串代码当做可执行代码来执行，它是就属于元编程领域。

`Proxy` API 允许我们在对象和其消费实体中创建中间层，这种特性为我们提供了控制该对象的能力，比如可以决定怎样去进行它的 `get` 和 `set`，甚至可以自定义当访问这个对象上不存在的属性的时候我们可以做些什么。

### Proxy 的 API

```js
var p = new Proxy(target, handler);
```

`Proxy` 构造函数获取一个 `target` 对象，和一个用来拦截 `target` 对象不同行为的 `handler` 对象。你可以设置下面这些拦截项：

*   `has`  —  拦截 `in` 操作。比如，你可以用它来隐藏对象上某些属性。
*   `get`  —  用来拦截**读取**操作。比如当试图读取不存在的属性时，你可以用它来返回默认值。
*   `set`  —  用来拦截**赋值**操作。比如给属性赋值的时候你可以增加验证的逻辑，如果验证不通过可以抛出错误。
*   `apply`  —  用来拦截**函数调用**操作。比如，你可以把所有的函数调用都包裹在 `try/catch` 语句块中。

这只是一部分拦截项，你可以在 MDN 上找到[完整的列表](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Proxy)。

下面是将 Proxy 用在验证上的一个简单的例子：

```js
const Car = {
  maker: 'BMW',
  year: 2018,
};

const proxyCar = new Proxy(Car, {
  set(obj, prop, value) {
    if (prop === 'maker' && value.length < 1) {
      throw new Error('Invalid maker');
    }

    if (prop === 'year' && typeof value !== 'number') {
      throw new Error('Invalid year');
    }
    obj[prop] = value;
    return true;
  }

});

proxyCar.maker = ''; // throw exception
proxyCar.year = '1999'; // throw exception
```

可以看到，我们可以用 Proxy 来验证赋给被代理对象的值。

### 使用 Proxy 来调试

为了在实践中展示 Proxy 的能力，我创建了一个简单的监测库，用来监测给定的对象或类，监测项如下：

*   函数执行时间
*   函数的调用者或属性的访问者
*   统计每个函数或属性的被访问次数。

这是通过在访问任意对象、类、甚至是函数时，调用一个名为 `proxyTrack` 的函数来完成的。

如果你希望监测是谁给一个对象的属性赋的值，或者一个函数执行了多久、执行了多少次、谁执行的，这个库将非常有用。我知道可能还有其他更好的工具来实现上面的功能，但是在这里我创建这个库就是为了用一用这个 API。

#### 使用 proxyTrack

首先，我们看看怎么用：

```js
function MyClass() {}

MyClass.prototype = {
    isPrime: function() {
        const num = this.num;
        for(var i = 2; i < num; i++)
            if(num % i === 0) return false;
        return num !== 1 && num !== 0;
    },

    num: null,
};

MyClass.prototype.constructor = MyClass;

const trackedClass = proxyTrack(MyClass);

function start() {
    const my = new trackedClass();
    my.num = 573723653;
    if (!my.isPrime()) {
        return `${my.num} is not prime`;
    }
}

function main() {
    start();
}

main();
```

如果我们运行这段代码，控制台将会输出：

```bash
MyClass.num is being set by start for the 1 time
MyClass.num is being get by isPrime for the 1 time
MyClass.isPrime was called by start for the 1 time and took 0 mils.
MyClass.num is being get by start for the 2 time
```

`proxyTrack` 接受 2 个参数：第一个是要监测的对象/类，第二个是一个配置项对象，如果没传递的话将被置为默认值。我们看看这个配置项默认值长啥样：

```js
const defaultOptions = {
    trackFunctions: true,
    trackProps: true,
    trackTime: true,
    trackCaller: true,
    trackCount: true,
    stdout: null,
    filter: null,
};
```

可以看到，你可以通过配置你关心的监测项来监测你的目标。比如你希望将结果输出出来，那么你可以将 `console.log` 赋给 `stdout`。

还可以通过赋给 `filter` 的回调函数来自定义地控制输出哪些信息。你将会得到一个包括有监测信息的对象，并且如果你希望保留这个信息就返回 `true`，反之返回 `false`。

#### 在 React 中使用 proxyTrack

因为 React 的组件实际上也是类，所以你可以通过 `proxyTrack` 来实时监控它。比如：

```js
class MyComponent extends Component{...}

export default connect(mapStateToProps)(proxyTrack(MyComponent, {
    trackFunctions: true,
    trackProps: true,
    trackTime: true,
    trackCaller: true,
    trackCount: true,
    filter: (data) => {
        if( data.type === 'get' && data.prop === 'componentDidUpdate') return false;
        return true;
    }
}));
```

可以看到，你可以将你不关心的信息过滤掉，否则输出将会变得杂乱无章。

### 实现 proxyTrack

我们来看看 `proxyTrack` 的实现。

首先是这个函数本身：

```js
export function proxyTrack(entity, options = defaultOptions) {
    if (typeof entity === 'function') return trackClass(entity, options);
    return trackObject(entity, options);
}
```

没什么特别的嘛，这里只是调用相关函数。

再看看 `trackObject`：

```js
function trackObject(obj, options = {}) {
    const { trackFunctions, trackProps } = options;

    let resultObj = obj;
    if (trackFunctions) {
        proxyFunctions(resultObj, options);
    }
    if (trackProps) {
        resultObj = new Proxy(resultObj, {
            get: trackPropertyGet(options),
            set: trackPropertySet(options),
        });
    }
    return resultObj;
}
function proxyFunctions(trackedEntity, options) {
    if (typeof trackedEntity === 'function') return;
    Object.getOwnPropertyNames(trackedEntity).forEach((name) => {
        if (typeof trackedEntity[name] === 'function') {
            trackedEntity[name] = new Proxy(trackedEntity[name], {
                apply: trackFunctionCall(options),
            });
        }
    });
}
```

可以看到，假如我们希望监测对象的属性，我们创建了一个带有 `get/set` 拦截器的被监测对象。下面是 `set` 拦截器的实现：

```js
function trackPropertySet(options = {}) {
    return function set(target, prop, value, receiver) {
        const { trackCaller, trackCount, stdout, filter } = options;
        const error = trackCaller && new Error();
        const caller = getCaller(error);
        const contextName = target.constructor.name === 'Object' ? '' : `${target.constructor.name}.`;
        const name = `${contextName}${prop}`;
        const hashKey = `set_${name}`;
        if (trackCount) {
            if (!callerMap[hashKey]) {
                callerMap[hashKey] = 1;
            } else {
                callerMap[hashKey]++;
            }
        }
        let output = `${name} is being set`;
        if (trackCaller) {
            output += ` by ${caller.name}`;
        }
        if (trackCount) {
            output += ` for the ${callerMap[hashKey]} time`;
        }
        let canReport = true;
        if (filter) {
            canReport = filter({
                type: 'get',
                prop,
                name,
                caller,
                count: callerMap[hashKey],
                value,
            });
        }
        if (canReport) {
            if (stdout) {
                stdout(output);
            } else {
                console.log(output);
            }
        }
        return Reflect.set(target, prop, value, receiver);
    };
}
```

更有趣的是 `trackClass` 函数（至少对我来说是这样）：

```js
function trackClass(cls, options = {}) {
    cls.prototype = trackObject(cls.prototype, options);
    cls.prototype.constructor = cls;

    return new Proxy(cls, {
        construct(target, args) {
            const obj = new target(...args);
            return new Proxy(obj, {
                get: trackPropertyGet(options),
                set: trackPropertySet(options),
            });
        },
        apply: trackFunctionCall(options),
    });
}
```

在这个案例中，因为我们希望拦截这个类上不属于原型上的属性，所以我们给这个类的原型创建了个代理，并且创建了个构造函数拦截器。

别忘了，即使你在原型上定义了一个属性，但如果你再给这个对象赋值一个同名属性，JavaScript 将会创建一个这个属性的本地副本，所以赋值的改动并不会改变这个类其他实例的行为。这就是为何只对原型做代理并不能满足要求的原因。

[戳这里](https://gist.github.com/mrharel/592df0228cebc017ca413f2f763acc5f)查看完整代码。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
