> * 原文地址：[Using Proxy to Track Javascript Class](https://medium.com/front-end-weekly/using-proxy-to-track-javascript-class-50a33a6ccb)
> * 原文作者：[Amir Harel](https://medium.com/@amir.harel)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-proxy-to-track-javascript-class.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-proxy-to-track-javascript-class.md)
> * 译者：
> * 校对者：

# Using Proxy to Track Javascript Class

![](https://cdn-images-1.medium.com/max/800/0*kcmAY6tU-LtxRRov)

Photo by [Fabian Grohs](https://unsplash.com/@grohsfabian?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral)

One of the cool and probably less known features of ES6 is the [Proxy](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy) object. While it has been around for quite some time, I want to take this post and explain a little bit about this feature, and use a real example how it could be used.

### What is Proxy

In plain boring english, as defined in the MDN web site:

> The **Proxy** object is used to define custom behavior for fundamental operations (e.g. property lookup, assignment, enumeration, function invocation, etc).

While this is pretty much sum it up, when I read it it was not so clear what it does and what can it help with.

To begin with, the Proxy concept is from the meta-programming world. In simple words, meta programming is the code which allow us to play with the application (or core) code that we write. For example the infamous `eval` function which allows us to evaluate string code into executable code, is in the meta programming realm.

The `Proxy` API allows us to create some some kind of a layer between an object and its consuming entities, that gives us the power to control the behavior of that object, like deciding how how the `get`and `set` is being done, or even decide what should we do if someone is trying to access a property in a object which is not defined.

### Proxy API

```
var p = new Proxy(target, handler);
```

The `Proxy` object gets a `target` object and a `handler` object to trap different behaviors in the `target` object. Here is a partial list of the traps you can set:

*   `has` — to trap the `in` operator. For example, this will allow you to hide a certain properties of an object.
*   `get` — to trap getting property value. For example, this will allow you to return some default value if this property does not exist.
*   `set` — to trap setting property value. For example, this will allow you to validate the value that is being set to a property and throw an exception if the value is not valid.
*   `apply` — to trap a function call. For example, this will allow you to wrap all the functions in a `try` and `catch` block.

This is just a small traps and you can check the full list in the MDN website.

Lets see a simple example of using proxy for validation:

```
const Car = {
  maker: 'BMW',
  year: '2018,
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

As you can see, we can validate the value that is being set into the proxy object.

### Debugging with Proxy

To show the power of proxy in action I created a simple tracking lib which tracks the following for a given object/class

*   Execution time for functions
*   Who called each function or property
*   Count the number of calls for each function or property.

It is being done by calling a function `proxyTrack` on any object or class, or even a function.

This could be really useful if you want to track who is changing a value in an object, or how long and how many times a function is being called, and who calls it. I know that there are probably better tools out there to do that, but I created this tool just for the purpose of playing a bit with this API.

#### Using proxyTrack

First, lets see how you can use it:

```
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

If we will run this code we should see in the console:

```
MyClass.num is being set by start for the 1 time
MyClass.num is being get by isPrime for the 1 time
MyClass.isPrime was called by start for the 1 time and took 0 mils.
MyClass.num is being get by start for the 2 time
```

The `proxyTrack` gets 2 parameters: the first is the object/class to track, and the second one is an options object, which will be set to default options in case it is not passed. Let's take a look at this `options` object:

```
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

As you can see, you can control what you want to track by setting the appropriate flag. In case you want to control that the output will go somewhere else then to the `console.log` you can pass a function to the `stdout`.

You can also control which tracking message will be output if you pass the `filter` callback. you will get an object with the info about the tracking data, and you will have to return `true` to keep the message or `false` to ignore it.

#### Using proxyTrack with React

Since react components are actually classes, you can track a class to examine it in real time. For example:

```
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

As you can see, you can filter out messages that might not be relevant to you, or might clutter the console.

### proxyTrack Implementation

Let’s take a look at the implementation of the `proxyTrack` .

First, the function itself:

```
export function proxyTrack(entity, options = defaultOptions) {
    if (typeof entity === 'function') return trackClass(entity, options);
    return trackObject(entity, options);
}
```

Nothing special here, we just call the appropriate function.

Lets the the `trackObject` first:

```
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

As you can see, in case we need to track properties for the object, we create a proxy object with `get` and `set` traps. Here is the code for the `set` trap:

```
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

The more interesting (at least to me) is the `trackClass` function:

```
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

In this case, we want to create a proxy to the function prototype and to create a trap for the constructor, since we want to be able to trap properties on the class which are not coming from the prototype.

Don’t forget that even if you defined a property on the prototype level, once you set a value to it, JavaScript will create a local copy of that property so it won’t change the value to all the other instances of this class. This is why is it not enough to only proxy the prototype.

You can take a look at the full code [here](https://gist.github.com/mrharel/592df0228cebc017ca413f2f763acc5f).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
