> * 原文地址：[Metaprogramming in ES6: Part 3 - Proxies](https://www.keithcirkel.co.uk/metaprogramming-in-es6-part-3-proxies/)
> * 原文作者：[Keith Cirkel](https://twitter.com/keithamus)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-part-3-proxies.md](https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-part-3-proxies.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：

# ES6 中的元编程： 第三部分 - 代理（Proxies）

这是我的 ES6 元编程系列的第三部分，也是最后一部分，还记得这个系列的文章我一年之前就开始动笔了，并且承诺不会花一年才写完，但现实就是我还真花费了如此多的时间去完成。在最后这篇文章中，我们要看看可能是 ES6 中最酷的反射特性：代理。已经读过了[上一篇讲述 ES6 Reflect API 的文章](/metaprogramming-in-es6-part-2-reflect/)，以及[更早的、讲述 ES6 Symbols 的文章](/metaprogramming-in-es6-symbols/)，由于反射和本文的部分内容有关，如果你还没读过它们，先倒回去阅读一下才能继续阅读本文。正如其他部分一样，我先引用一下在第一部分提到过的观点：

* Symbols 是 **实现了的反射（Reflection within implementation）**—— 你将 Symbols 应用到你已有的类和对象上去改变它们的行为。
* Reflect 是 **通过自省（introspection）实现反射（Reflection through introspection）** —— 通常用来探索非常底层的代码信息。
* Proxy 是 **通过调解（intercession）实现反射（Reflection through intercession）** —— 包裹对象并通过自陷（trap）来拦截对象行为。

因此，`Proxy` 是一个全新的全局构造函数（类似 `Date` 或者 `Number`），你可以传递给其一个对象，以及一些钩子（hook），它能为你返回一个 **新的** 对象，该对象由这些充满魔力的钩子包裹了老对象得到。现在你拥有了代理，希望你喜欢它，我也高兴你回到这个系列中来。

关于代理，有很多需要阐述的。但对新手来书，先让我们看看这个构造函数。

## 创建代理

Proxy 构造函数接受两个参数，其一是你想要代理的初始对象，其二是一系列处理钩子（handler hooks）。我们先忽略第二个钩子参数，看看怎么为现有对象创建代理。线索即在代理这个名字中：它们维持了一个你创建对象的引用，但是如果你有了一个原始对象对象的引用，任何你和原始对象的交互，都会影响到代理，类似地，任何你对代理做的改变，反过来也都会影响到原始对象。换句话说，Proxy 返回了一个包裹了传入对象的新对象，但是任何你对二者的操作，都会影响到它们彼此。为了证实这一点，看到代码：

```js
var myObject = {};
var proxiedMyObject = new Proxy(myObject, {/*以及一系列处理钩子*/});

assert(myObject !== proxiedMyObject);

myObject.foo = true;
assert(proxiedMyObject.foo === true);

proxiedMyObject.bar = true;
assert(myObject.bar === true);
```

目前为止，我们什么目的也没打到，相较于直接使用被代理对象，代理并不能提供任何额外收益。只有用上了处理钩子，我们才能在代理上做一些有趣的事儿。

## 代理的处理钩子

处理钩子是一系列的函数，每一个钩子都有一个具体名字以供代理识别，每一个钩子也控制了你如何和代理交互（因此，也控制了你和被包裹对象的交互）。处理钩子勾住了 JavaScript 的 “内置方法”，如果你听到这里感觉有点熟悉的话，是因为我们在 [上一篇介绍 Reflect API 的文章](/metaprogramming-in-es6-part-2-reflect/#internal-methods) 中提到了内置方法。

是时候铺开来说代理的。我把代理放到系列的最后一部分的重要原因是：由于代理和反射就像明星和粉丝一样，是相互交织的，因此我们需要先知道反射是如何工作的。如你所见，每一个代理钩子都对应到一个反射方法，也可以反过来说，每一个反射方法都有一个代理钩子。完整的反射方法/代理处理钩子如下：

* `apply` （以一个 `this` 参数和一系列 `arguments`（参数序列） 调用函数）
* `construct`（以一系列 `arguments` 及一个可选的、指明了原型的构造函数调用一个类函数或者构造函数）
* `defineProperty` （在对象上定义一个属性，并声明该属性诸如对象可迭代性这样的元信息）
* `getOwnPropertyDescriptor` （获得一个属性的 “属性描述子”：描述子包含了诸如对象可迭代性这样的元信息）
* `deleteProperty` （从对象上删除某个属性）
* `getPrototypeOf` （获得某实例的原型）
* `setPrototypeOf` （设置某实例的原型）
* `isExtensible` （判断一个对象是否是 “可扩展的”，亦即是否可以为其添加属性）
* `preventExtensions` （防止对象被扩展）
* `get` （得到对象的某个属性）
* `set` （设置对象的某个属性）
* `has` （在不断言属性值的情况下，判断对象是否含有某个属性）
* `ownKeys` （获得某个对象自身所有的 key，排除掉其原型上的 key）

在[反射那一部分中](/metaprogramming-in-es6-part-2-reflect/)（再啰嗦一遍，如果你没看过，赶快去看），我们已经浏览过所有这些方法了（并附带有例子）。代理用相同的参数集实现了每一个方法。实际上，代理的默认行为已经实现了在每个处理钩子中完成反射函数的调用（其内部机制对于不同的 JavaScript 引擎可能会有所区别，但对于没有说明的钩子，我们只需要认为它和对应的反射方法行为一致即可）。这也意味着，任何你没有指定的钩子，都具有和默认状况一致的行为，就像它从未被代理过一样：

```js
// 我们新创建了代理，并定义了与默认创建时一样的行为
proxy = new Proxy({}, {
  apply: Reflect.apply,
  construct: Reflect.construct,
  defineProperty: Reflect.defineProperty,
  getOwnPropertyDescriptor: Reflect.getOwnPropertyDescriptor,
  deleteProperty: Reflect.deleteProperty,
  getPrototypeOf: Reflect.getPrototypeOf,
  setPrototypeOf: Reflect.setPrototypeOf,
  isExtensible: Reflect.isExtensible,
  preventExtensions: Reflect.preventExtensions,
  get: Reflect.get,
  set: Reflect.set,
  has: Reflect.has,
  ownKeys: Reflect.ownKeys,
});
```

现在，我可以深入到每个代理钩子的工作细节中去了，但我不会直接复制/粘贴反射中的例子来偷懒。如果只是介绍每个钩子的功能，对代理来说就不太公平，因为代理是去实现一些炫酷用例的。所以，本文剩余内容都将为你展示通过代理完成的炫酷的东西，甚至是一些你没了代理就无法完成的事。

同时，为了让内容更具交互性，我为每个例子都创建一个小的库来展示对应的功能。我会给出每个例子对应的代码仓库链接。

## 用代理来......

### 构建一个可无限链式调用的 API

Building on the previous example - using the same `[[Get]]` trap: with a little bit more magic we can make an API which has an infinite number of methods, and when you finally call one of those it’ll return everything you chained. This could be useful, for example, in making a [fluent API](https://en.wikipedia.org/wiki/Fluent_interface) that constructs URLs for web requests, or maybe some kind of Test Assertion framework that chains together English words to make readable assertions, kind of like [Chai](https://github.com/chaijs/chai).

For this we need to hook into `[[Get]]`, and push the retrieved prop into an array. The Proxy will wrap a function which returns the Array of all retrieved props and empty the array, so it can be re-used. We’ll also hook into `[[HasProperty]]` because, like before, we want to demonstrate to our users that any property exists.

```js
function urlBuilder(domain) {
  var parts = [];
  var proxy = new Proxy(function () {
    var returnValue = domain + '/' + parts.join('/');
    parts = [];
    return returnValue;
  }, {
    has: function () {
      return true;
    },
    get: function (object, prop) {
      parts.push(prop);
      return proxy;
    },
  });
  return proxy;
}
var google = urlBuilder('http://google.com');
assert(google.search.products.bacon.and.eggs() === 'http://google.com/search/products/bacon/and/eggs')
```

You could also use this same pattern to make a tree traversal fluent API, something like you might see as part of jQuery or perhaps a React selector tool:

```js
function treeTraverser(tree) {
  var parts = [];
  var proxy = new Proxy(function (parts) {
    let node = tree; // start the node at the root
    for (part of parts) {
      if (!node.props || !node.props.children || node.props.children.length === 0) {
        throw new Error(`Node ${node.tagName} has no more children`);
      }
      // If the part is a child tag, drill down into that child for the next traversal step
      let index = node.props.children.findIndex((child) => child.tagName == part);
      if(index === -1) {
        throw new Error(`Cannot find child: ${part} in ${node.tagName}`);
      }
      node = node.props.children[index];
    }
    return node.props;
  }, {
    has: function () {
      return true;
    },
    get: function () {
      parts.push(prop);
      return proxy;
    }
  });
  return proxy;
}
var myDomIsh = treeTraverserExample({
  tagName: 'body',
  props: {
    children: [
      {
        tagName: 'div',
        props: {
          className: 'main',
          children: [
            {
              tagName: 'span',
              props: {
                className: 'extra',
                children: [
                  { tagName: 'i', props: { textContent: 'Hello' } },
                  { tagName: 'b', props: { textContent: 'World' } },
                ]
              }
            }
          ]
        }
      }
    ]
  }
});
assert(myDomIsh.div.span.i().textContent === 'Hello');
assert(myDomIsh.div.span.b().textContent === 'World');
```

I’ve made a slightly more reusable version of this over at [github.com/keithamus/proxy-fluent-api](https://github.com/keithamus/proxy-fluent-api), available on npm with the same name.

### 实现一个 “方法缺失” 钩子

Various other programming languages give you the ability to override the behaviour of a class using a well-known reflection methods, for example in PHP it is `__call`, in Ruby it is `method_missing`, in Python you can emulate this behaviour with `__getattr__`. JavaScript has no such mechanism - but now we have Proxies which allow us to do cool things like this.

To get an idea of what we’re after, let’s look at a Ruby example for some inspiration:

```rb
class Foo
  def bar()
    print "you called bar. Good job!"
  end
  def method_missing(method)
    print "you called `#{method}` but it doesn't exist!"
  end
end

foo = Foo.new
foo.bar()
#=> you called bar. Good job!
foo.this_method_does_not_exist()
#=> you called this_method_does_not_exist but it doesn't exist
```

So for any method that exists, in this case `bar`, that method is executed like you’d expect. For methods which don’t exist, like `foo` or `this_method_does_not_exist`, then the `method_missing` method is executed in place of it. In addition, it gets the called method name as the first argument, which is super useful for determining what the user wanted.

We could do something similar with a mixture of ES6 Symbols, and a function that can wrap the class and return a Proxy with the `get` (`[[Get]]`) trap:

```js
function Foo() {
  return new Proxy(this, {
    get: function (object, property) {
      if (Reflect.has(object, property)) {
        return Reflect.get(object, property);
      } else {
        return function methodMissing() {
          console.log('you called ' + property + ' but it doesn\'t exist!');
        }
      }
    }
  });
}

Foo.prototype.bar = function () {
  console.log('you called bar. Good job!');
}

foo = new Foo();
foo.bar();
//=> you called bar. Good job!
foo.this_method_does_not_exist()
//=> you called this_method_does_not_exist but it doesn't exist
```

This really comes into use where you have a set of methods whose functionality is largely the same, where the differences can be inferred from the method name. Effectively moving what would be function parameters into the function name for a more readable syntax. As an example of this - you could quickly and easily make an API for switching between two pairs of values like currencies, or perhaps bases:

```js
const baseConvertor = new Proxy({}, {
  get: function baseConvert(object, methodName) {
    var methodParts = methodName.match(/base(\d+)toBase(\d+)/);
    var fromBase = methodParts && methodParts[1];
    var toBase = methodParts && methodParts[2];
    if (!methodParts || fromBase > 36 || toBase > 36 || fromBase < 2 || toBase < 2) {
      throw new Error('TypeError: baseConvertor' + methodName + ' is not a function');
    }
    return function (fromString) {
      return parseInt(fromString, fromBase).toString(toBase);
    }
  }
});

baseConvertor.base16toBase2('deadbeef') === '11011110101011011011111011101111';
baseConvertor.base2toBase16('11011110101011011011111011101111') === 'deadbeef';
```

Of course, you could manually type out all 1,296 permutations of the available methods, or make a loop to create all of those methods individually, but both require much more code.

A more concrete example of this exists in Ruby on Rails ActiveRecord, which comes with “dynamic finders”. It essentially implements `method_missing` to allow you to query a table by its columns. Rather than passing in a complex object, your parameters become values matched to the method name, for example:

```js
Users.find_by_first_name('Keith'); # [ Keith Cirkel, Keith Urban, Keith David ]
Users.find_by_first_name_and_last_name('Keith', 'David');  # [ Keith David ]
```

We could implement something similar in JavaScript using our above pattern:

```js
function RecordFinder(options) {
  this.attributes = options.attributes;
  this.table = options.table;
  return new Proxy({}, function findProxy(methodName) {
    var match = methodName.match(new RegExp('findBy((?:And)' + this.attributes.join('|') + ')'));
    if (!match){
      throw new Error('TypeError: ' + methodName + ' is not a function');
    }
  });
});
```

Like the rest of these examples, I’ve made a little lib out of this - over at [github.com/keithamus/proxy-method-missing](https://github.com/keithamus/proxy-method-missing). It’s on npm too.

### 从 `getOwnPropertyNames`、`Object.keys`、`in` 等所有迭代方法中隐藏所有的属性

We can use Proxies to make every property in an object completely hidden, except for when getting the value. Here’s all of the ways you can find out if a property exists on an Object in JavaScript:

* `Reflect.has`,`Object.hasOwnProperty`,`Object.prototype.hasOwnProperty`, and the `in` operator all use `[[HasProperty]]`. Proxy can trap this with `has`.
* `Object.keys`/`Object.getOwnPropertyNames`, which uses `[[OwnPropertyKeys]]`. Proxy can trap this with `ownKeys`.
* `Object.entries` (an upcoming ES2017 feature), also uses `[[OwnPropertyKeys]]` - again - trapped by `ownKeys`.
* `Object.getOwnPropertyDescriptor` which uses `[[GetOwnProperty]]`. Proxy can trap this with, surprise surprise, `getOwnPropertyDescriptor`.

```js
var example = new Proxy({ foo: 1, bar: 2 }, {
  has: function () { return false; },
  ownKeys: function () { return []; },
  getOwnPropertyDescriptor: function () { return false; },
});
assert(example.foo === 1);
assert(example.bar === 2);
assert('foo' in example === false);
assert('bar' in example === false);
assert(example.hasOwnProperty('foo') === false);
assert(example.hasOwnProperty('bar') === false);
assert.deepEqual(Object.keys(example), [ ]);
assert.deepEqual(Object.getOwnPropertyNames(example), [ ]);
```

I’m not going to lie, I cannot think of any super useful uses of this pattern. Nevertheless, I have made a library to go with this, available at [github.com/keithamus/proxy-hide-properties](https://github.com/keithamus/proxy-hide-properties) which also lets you specify individual properties to hide, rather than blanket hiding all properties.

### 实现一个观察者模式，也称作 Object.observe

Those of you who keenly follow the additions of new specs may have noticed `Object.observe` being considered for inclusion in ES2016\. Recently, however, the champions of `Object.observe` have planned to [withdraw their proposal to include Object.observe](https://esdiscuss.org/topic/an-update-on-object-observe), and with good reason: it was originally created to answer a problem framework authors had around Data Binding. Now, with React and Polymer 1.0, the trend of data binding frameworks is declining, and instead immutable data structures are becoming more prevalent.

Thankfully, Proxy actually makes specs like Object.observe redundant, as now we have a low level API through Proxy, we can actually implement something like Object.observe. To get close feature parity with Object.observe, we need to hook on the `[[Set]]`, `[[PreventExtensions]]`, `[[Delete]]`, and `[[DefineOwnProperty]]` internal methods - that’s the `set`, `preventExtensions`, `deleteProperty` and `defineProperty` Proxy traps respectively:

```js
function observe(object, observerCallback) {
  var observing = true;
  const proxyObject = new Proxy(object, {
    set: function (object, property, value) {
      var hadProperty = Reflect.has(object, property);
      var oldValue = hadProperty && Reflect.get(object, property);
      var returnValue = Reflect.set(object, property, value);
      if (observing && hadProperty) {
        observerCallback({ object: proxyObject, type: 'update', name: property, oldValue: oldValue });
      } else if(observing) {
        observerCallback({ object: proxyObject, type: 'add', name: property });
      }
      return returnValue;
    },
    deleteProperty: function (object, property) {
      var hadProperty = Reflect.has(object, property);
      var oldValue = hadProperty && Reflect.get(object, property);
      var returnValue = Reflect.deleteProperty(object, property);
      if (observing && hadProperty) {
        observerCallback({ object: proxyObject, type: 'delete', name: property, oldValue: oldValue });
      }
      return returnValue;
    },
    defineProperty: function (object, property, descriptor) {
      var hadProperty = Reflect.has(object, property);
      var oldValue = hadProperty && Reflect.getOwnPropertyDescriptor(object, property);
      var returnValue = Reflect.defineProperty(object, property, descriptor);
      if (observing && hadProperty) {
        observerCallback({ object: proxyObject, type: 'reconfigure', name: property, oldValue: oldValue });
      } else if(observing) {
        observerCallback({ object: proxyObject, type: 'add', name: property });
      }
      return returnValue;
    },
    preventExtensions: function (object) {
      var returnValue = Reflect.preventExtensions(object);
      if (observing) {
        observerCallback({ object: proxyObject, type: 'preventExtensions' })
      }
      return returnValue;
    },
  });
  return { object: proxyObject, unobserve: function () { observing = false } };
}

var changes = [];
var observer = observe({ id: 1 }, (change) => changes.push(change));
var object = observer.object;
var unobserve = observer.unobserve;
object.a = 'b';
object.id++;
Object.defineProperty(object, 'a', { enumerable: false });
delete object.a;
Object.preventExtensions(object);
unobserve();
object.id++;
assert.equal(changes.length, 5);
assert.equal(changes[0].object, object);
assert.equal(changes[0].type, 'add');
assert.equal(changes[0].name, 'a');
assert.equal(changes[1].object, object);
assert.equal(changes[1].type, 'update');
assert.equal(changes[1].name, 'id');
assert.equal(changes[1].oldValue, 1);
assert.equal(changes[2].object, object);
assert.equal(changes[2].type, 'reconfigure');
assert.equal(changes[2].oldValue.enumerable, true);
assert.equal(changes[3].object, object);
assert.equal(changes[3].type, 'delete');
assert.equal(changes[3].name, 'a');
assert.equal(changes[4].object, object);
assert.equal(changes[4].type, 'preventExtensions');
```

As you can see, we have a relatively complete Object.observe implementation in a small chunk of code. The main differences between the proposed spec and this implementation is that Object.observe could mutate an object, where as Proxy has to return a new one - that and the unobserve function is not a global.

## 加分环节：可撤回代理

Proxies have one last trick up their sleeve: some Proxies can be revoked. To create a revocable Proxy, you need to use `Proxy.revocable(target, handler)` (instead of `new Proxy(target, handler)`), and instead of returning the Proxy directly, it’ll return an Object that looks like `{ proxy, revoke(){} }`. An example:

```js
function youOnlyGetOneSafetyNet(object) {
  var revocable = Proxy.revocable(object, {
    get(property) {
      if (Reflect.has(this, property)) {
        return Reflect.get(this, property);
      } else {
        revocable.revoke();
        return 'You only get one safety net';
      }
    }
  });
  return revocable.proxy;
}

var myObject = youOnlyGetOneSafetyNet({ foo: true });

assert(myObject.foo === true);
assert(myObject.foo === true);
assert(myObject.foo === true);

assert(myObject.bar === 'You only get one safety net');
myObject.bar // TypeError
myObject.bar // TypeError
Reflect.has(myObject, 'bar') // TypeError
```

Sadly, as you can see right at the end in the example, a revoked Proxy will throw a TypeError when any of the handlers are triggered - even if those handlers haven’t been set. I feel like this neuters the ability of a Revocable Proxy. If all handlers returned to their Reflect equivalents (effectively making the Proxy redundant, and the object behave as if the Proxy was never in place) this would make for a much more useful feature. Sadly, that isn’t the case. As such this feature has been left in the proverbial footnotes of this post, as I’m not really sure of a concrete use case for a revocable Proxy.

Like the other examples, this one has been codified up, and is available at [github.com/keithamus/proxy-object-observe](https://github.com/keithamus/proxy-object-observe) - and also on npm.

## 总结

I hope this post has shown you that Proxy is an incredibly powerful tool for messing with (what used to be) JavaScript internals. In many ways, Symbol, Reflect, and Proxy are opening up a new chapter of JavaScript - in as much as const and let, or classes and arrow functions. While const & let make code less confusing, and classes & arrow functions make code more terse, Symbol, Reflect, and Proxy are beginning to give developers really low level metaprogramming hooks within JavaScript.

These new metaprogramming tools are also not slowing down any time soon: new proposals for future EcmaScript versions are shaping up and adding additional interesting behaviours, such as [this proposal for `Reflect.isCallable` & `Reflect.isConstructor`](https://github.com/caitp/TC39-Proposals/blob/master/tc39-reflect-isconstructor-iscallable.md), [or this stage 0 proposal for `Reflect.type`](https://github.com/alex-weej/es-reflect-type-proposal), or [this proposal for `function.sent` meta property](https://github.com/allenwb/ESideas/blob/master/Generator%20metaproperty.md), [or this one for a bunch more function metaproperties](https://github.com/allenwb/ESideas/blob/master/ES7MetaProps.md). Also, these new APIs have inspired some interesting discussions about some great new features, such as [this proposal about adding `Reflect.parse`](https://esdiscuss.org/topic/reflect-parse-from-re-typeof-null), subsequently leading to discussion around making a AST (Abstract Syntax Tree) standard.

What do you think about the new Proxy API? Plan on using it in your project? Let me know, in the comments below or on Twitter, where I’m [@keithamus](https://twitter.com/keithamus).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
