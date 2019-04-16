> * 原文地址：[Metaprogramming in ES6: Part 3 - Proxies](https://www.keithcirkel.co.uk/metaprogramming-in-es6-part-3-proxies/)
> * 原文作者：[Keith Cirkel](https://twitter.com/keithamus)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-part-3-proxies.md](https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-part-3-proxies.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：[caoyi0905](https://github.com/caoyi0905) [PCAaron](https://github.com/PCAaron)

# ES6 中的元编程： 第三部分 —— 代理（Proxies）

这是我的 ES6 元编程系列的第三部分，也是最后一部分，还记得这个系列的文章我一年之前就开始动笔了，并且承诺不会花一年才写完，但现实就是我还真花费了如此多的时间去完成。在最后这篇文章中，我们要看看可能是 ES6 中最酷的反射特性：代理（Proxy）。由于反射和本文的部分内容有关，如果你还没读过[上一篇讲述 ES6 Reflect API 的文章](/metaprogramming-in-es6-part-2-reflect/)，以及[更早的、讲述 ES6 Symbols 的文章](/metaprogramming-in-es6-symbols/)，先倒回去阅读一下，这样才能更好地理解本文。和其他部分一样，我先引用一下在第一部分提到过的观点：

* Symbols 是 **实现了的反射（Reflection within implementation）**—— 你将 Symbols 应用到你已有的类和对象上去改变它们的行为。
* Reflect 是 **通过自省（introspection）实现反射（Reflection through introspection）** —— 通常用来探索非常底层的代码信息。
* Proxy 是 **通过调解（intercession）实现反射（Reflection through intercession）** —— 包裹对象并通过自陷（trap）来拦截对象行为。

因此，`Proxy` 是一个全新的全局构造函数（类似 `Date` 或者 `Number`），你可以传递给其一个对象，以及一些钩子（hook），它能为你返回一个 **新的** 对象，新的对象使用这些充满魔力的钩子包裹了老对象。现在，你拥有了代理，希望你喜欢它，我也高兴你回到这个系列中来。

关于代理，有很多需要阐述的。但对新手来说，先让我们看看怎么创建一个代理。

## 创建代理

Proxy 构造函数接受两个参数，其一是你想要代理的初始对象，其二是一系列处理钩子（handler hooks）。我们先忽略第二个钩子参数，看看怎么为现有对象创建代理。线索即在代理这个名字中：它们维持了一个你创建对象的引用，但是如果你有了一个原始对象的引用，任何你和原始对象的交互，都会影响到代理，类似地，任何你对代理做的改变，反过来也都会影响到原始对象。换句话说，Proxy 返回了一个包裹了传入对象的新对象，但是任何你对二者的操作，都会影响到它们彼此。为了证实这一点，请看代码：

```js
var myObject = {};
var proxiedMyObject = new Proxy(myObject, {/*以及一系列处理钩子*/});

assert(myObject !== proxiedMyObject);

myObject.foo = true;
assert(proxiedMyObject.foo === true);

proxiedMyObject.bar = true;
assert(myObject.bar === true);
```

目前为止，我们什么目的也没达到，相较于直接使用被代理对象，代理并不能提供任何额外收益。只有用上了处理钩子，我们才能在代理上做一些有趣的事儿。

## 代理的处理钩子

处理钩子是一系列的函数，每一个钩子都有一个具体名字以供代理识别，每一个钩子也控制了你如何和代理交互（因此，也控制了你和被包裹对象的交互）。处理钩子勾住了 JavaScript 的 “内置方法”，如果你对此感觉熟悉，是因为我们在 [上一篇介绍 Reflect API 的文章](https://juejin.im/post/5a0e66386fb9a04523417418) 中提到了内置方法。

是时候铺开来说代理了。我把代理放到系列的最后一部分的重要原因是：由于代理和反射就像一对苦命鸳鸯交织在一起，因此我们需要先知道反射是如何工作的。如你所见，每一个代理钩子都对应到一个反射方法，反之亦然，每一个反射方法都有一个代理钩子。完整的反射方法及对应的代理处理钩子如下：

* `apply` （以一个 `this` 参数和一系列 `arguments`（参数序列）调用函数）
* `construct`（以一系列 `arguments` 及一个可选的、指明了原型的构造函数调用一个类函数或者构造函数）
* `defineProperty` （在对象上定义一个属性，并声明该属性中诸如对象可迭代性这样的元信息）
* `getOwnPropertyDescriptor` （获得一个属性的 “属性描述子”：描述子包含了诸如对象可迭代性这样的元信息）
* `deleteProperty` （从对象上删除某个属性）
* `getPrototypeOf` （获得某实例的原型）
* `setPrototypeOf` （设置某实例的原型）
* `isExtensible` （判断一个对象是否是 “可扩展的”，亦即判断是否可以为其添加属性）
* `preventExtensions` （阻止对象被扩展）
* `get` （得到对象的某个属性）
* `set` （设置对象的某个属性）
* `has` （在不断言（assert）属性值的情况下，判断对象是否含有某个属性）
* `ownKeys` （获得某个对象自身所有的 key，排除掉其原型上的 key）

在[反射那一部分中](https://juejin.im/post/5a0e66386fb9a04523417418)（再啰嗦一遍，如果你没看过，赶快去看），我们已经浏览过上述所有方法了（并附带有例子）。代理用相同的参数集实现了每一个方法。实际上， 代理的默认行为实际上已经实现了对每个处理程序钩子的反射调用（其内部机制对于不同的 JavaScript 引擎可能会有所区别，但对于没有说明的钩子，我们只需要认为它和对应的反射方法行为一致即可）。这也意味着，任何你没有指定的钩子，都具有和默认状况一致的行为，就像它从未被代理过一样：

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

现在，我可以深入到每个代理钩子的工作细节中去了，但是基本上都是复制粘贴反射中的例子（只需要修改很少的部分）。如果只是介绍每个钩子的功能，对代理来说就不太公平，因为代理是去实现一些炫酷用例的。所以，本文剩余内容都将为你展示通过代理完成的炫酷的东西，甚至是一些你没了代理就无法完成的事。

同时，为了让内容更具交互性，我为每个例子都创建一个小的库来展示对应的功能。我会给出每个例子对应的代码仓库链接。

## 用代理来......

### 构建一个可无限链接（chainable）的 API

以前面的例子为基础 —— 我们仍使用 `[[Get]]` 自陷：只需要再施加一点魔法，我们就能构建一个拥有无数方法的 API，当你最终调用其中某个方法时，将返回所有你被你链接的值。[fluent API（流畅 API）](https://en.wikipedia.org/wiki/Fluent_interface) 为 web 请求构建了各个 URL，[Chai](https://github.com/chaijs/chai) 这类的测试框架将各个英文单词链接组成高可读的测试断言，通过这些，我们知道可无限链接的 API 是多么有用。

为了实现这个 API，我们就需要钩子勾住 `[[Get]]`，将取到的属性保存到数组中。代理 ( Proxy ) 将包装一个函数，返回所有检索到的支持的Array，并清空数组，以便可以重用它。我们也会勾住 `[[HasProperty]]`，因为我们想告诉 API 的使用者，任何属性都是存在的。

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

你也可以用相同的模式实现一个树遍历的 fluent API，这类似于你在 jQuery 或者 React 中看到的选择器：

```js
function treeTraverser(tree) {
  var parts = [];
  var proxy = new Proxy(function (parts) {
    let node = tree; // 从树的根节点开始
    for (part of parts) {
      if (!node.props || !node.props.children || node.props.children.length === 0) {
        throw new Error(`Node ${node.tagName} has no more children`);
      }
      // 如果该部分是一个子节点，就深入到该子节点进行下一次遍历
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

我已经发布了一个更加可复用的版本到 [github.com/keithamus/proxy-fluent-api](https://github.com/keithamus/proxy-fluent-api) 上，npm 上也有其同名的包。

### 实现一个 “方法缺失” 钩子

许多其他的编程语言都允许你使用一个内置的反射方法去重写一个类的行为，例如，在 PHP 中有 `__call`，在 Ruby 中有 `method_missing`，在 Python 中则有 `__getattr__`。JavaScript 缺乏这个机制，但现在我们有了代理去实现它。

在开始介绍代理的实现之前，我们先看下 Ruby 是怎么做的，来从中获得一些灵感：

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
#=》 you called this_method_does_not_exist but it doesn't exist!
```

对于任何存在方法，在此例中是 `bar`，该方法能够按预期被执行。对于不存在方法，比如 `foo` 或者 `this_method_does_not_exist`，在调用时会被 `method_missing` 替代。另外，`method_missing` 接受方法名作为第一个参数，这对于判断用户意图非常有用。

我们可以通过混入 ES6 Symbol 实现类似的功能：使用一个函数包裹类，该函数将返回使用了 `get`（`[[Get]]`）自陷的代理，或者说是拦截了 `get` 行为的代理：

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
// you called bar. Good job!
foo.this_method_does_not_exist();
// you called this_method_does_not_exist but it doesn't exist!
```

当你有若干方法功能非常类似，并且可以从函数名推测功能间的差异性，上面的做法就非常有用。将函数的功能区分从参数转移到函数名，将带来更好的可读性。作为此的一个例子 —— 你可以快速轻易地创建一个单位转换 API，如货币或者是进制的转化：

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

当然，你也可以手动创建总计 1296 组合情况的方法，或者单独通过一个循环来创建这些方法，但是这两者都需要用更多的代码来完成。

一个更加具体的例子是 Ruby on Rails 中的 ActiveRecord，其源于 “动态查找（dynamic finders）”。ActiveRecord 基本上实现了 “method_missing” 来允许你根据列查询一个表。使用函数名作为查询关键字，避免了使用传递一个复杂对象来创建查询语句：

```js
Users.find_by_first_name('Keith'); # [ Keith Cirkel, Keith Urban, Keith David ]
Users.find_by_first_name_and_last_name('Keith', 'David');  # [ Keith David ]
```

在 JavaScript 中，我们也能实现类似功能：

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

和其他例子一样，我已经写了一个关于此的库放到了 [github.com/keithamus/proxy-method-missing](https://github.com/keithamus/proxy-method-missing)，npm 上也可以到同名的包。

### 从 `getOwnPropertyNames`、`Object.keys`、`in` 等所有迭代方法中隐藏所有的属性

我们可以使用代理让一个对象的所有的属性都隐藏起来，除非是要获得属性的值。下面罗列了所有 JavaScript 中你可以判断某属性是否存在于一个对象的方法：

* `Reflect.has`、`Object.hasOwnProperty`、`Object.prototype.hasOwnProperty` 以及 `in` 运算符全部使用了 `[[HasProperty]]`。代理可以通过 `has` 拦截它。
* `Object.keys`/`Object.getOwnPropertyNames` 都使用了 `[[OwnPropertyKeys]]`。代理可以通过 `ownKeys` 进行拦截。
* `Object.entries` （一个即将到来的 ES2017 特性），也使用了 `[[OwnPropertyKeys]]`，代理仍然可以通过 `ownKeys` 进行拦截。
* `Object.getOwnPropertyDescriptor` 使用了 `[[GetOwnProperty]]`。特别特别让人兴奋的是，代理可以通过 `getOwnPropertyDescriptor` 进行拦截。

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

老实说，我也没有发现这个模式有特别大的用处。但是，我还是创建了一个关于此的一个库，并放在了[github.com/keithamus/proxy-hide-properties](https://github.com/keithamus/proxy-hide-properties)，它能让你单独地设置某个属性不可见了，而不是一锅端地让所有属性不可见。

### 实现一个观察者模式，也称作 Object.observe

对新规范所添加的内容一直敏锐追踪的人们可能已经注意到了， `Object.observe` 开始被考虑纳入 ES2016 了。`Object.observe` 的拥护者已经开始计划 [起草包含有有 Object.observe 的提案](https://esdiscuss.org/topic/an-update-on-object-observe)，他们对此有一个非常好的理由：草案初衷就是要帮助框架作者解决数据绑定（Data Binding）的问题。现在，随着 React 和 Polymer 1.0 的发布，数据绑定框架有所降温，不可变数据（immutable data）开始变得流行。 

庆幸的是，代理让诸如 Object.observe 这样的规范变得多余，现在我们可以通过代理实现一个更加底层的 Object.observe。为了更加接近 Object.observe 所具有的特性，我们需要钩住 `[[Set]]`、`[[PreventExtensions]]`、`[[Delete]]` 以及 `[[DefineOwnProperty]]` 这些内置方法 —— 代理分别可以使用 `set`、`preventExtensions`、`deleteProperty` 及 `defineProperty` 进行拦截：

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

正如你所看到的，我们用一小段代码实现了一个相对完整的 Object.observe。该实现和规范之间的差异在于，Object.observe 是能够改变对象的，而代理则返回了一个新对象，并且 unobserver 函数也不是全局的。

和其他例子一样，我也写了关于此的一个库并放在了 [github.com/keithamus/proxy-object-observe](https://github.com/keithamus/proxy-object-observe) 以及 npm 上。

## 奖励关卡：可撤销代理

代理还有最后一个大招：一些代理可以被撤销。为了创建一个可撤销的代理，你需要使用 `Proxy.revocable(target, handler)` （而不是 `new Proxy(target, handler)`），并且，最终返回一个结构为 `{proxy, revoke()}` 的对象来替代直接返回一个代理对象。例子如下：

```js
function youOnlyGetOneSafetyNet(object) {
  var revocable = Proxy.revocable(object, {
    get(target, property) {
      if (Reflect.has(target, property)) {
        return Reflect.get(target, property);
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

遗憾的是，你可以看到例子中最后一行的右侧，如果代理已经被撤销，任何在代理对象上的操作都会抛出 TypeError —— 即便这些操作句柄还没有被代理。我觉得这可能是可撤销代理的一种能力。如果所有的操作都能与对应的 Reflect 返回一致（这会使得代理冗余，并让对象表现得好像从未设置过代理一样），将使该特性更加有用。这个特性被放在了本文压轴部分，也是因为我也不真正确定可撤回代理的具体用例。

## 总结

我希望这篇文章让你认识到代理是一个强大到不可思议的工具，它弥补了 JavaScript 内部曾经的缺失。在方方面面，Symbol、Reflect、以及代理都为 JavaScript 开启了新的篇章 —— 就如同 const 和 let，类和箭头函数那样。const 和 let 不再让代码显得混乱肮脏，类和箭头函数让代码更简洁，Symbol、Reflect、和 Proxy 则开始给予开发者在 JavaScript 中进行底层的元编程。

这些新的元编程工具不会在短时间内放慢发展的速度：EcamScript 的新版本正逐渐完善，并添加了更多有趣的行为，例如 [`Reflect.isCallable` 和 `Reflect.isConstructor` 的提案](https://github.com/caitp/TC39-Proposals/blob/master/tc39-reflect-isconstructor-iscallable.md)，亦或 [stage 0 关于 `Reflect.type` 的提案](https://github.com/alex-weej/es-reflect-type-proposal)，亦或 [`function.sent` 这个元属性的提案](https://github.com/allenwb/ESideas/blob/master/Generator%20metaproperty.md)
，亦或[这个包含了更多函数元属性的提案](https://github.com/allenwb/ESideas/blob/master/ES7MetaProps.md)。这些新的 API 也激发了一些关于新特性的有趣讨论，例如 [这个关于添加 `Reflect.parse` 的提案](https://esdiscuss.org/topic/reflect-parse-from-re-typeof-null)，就引起了关于创建一个 AST（Abstract Syntax Tree：抽象语法树）标准的讨论。

你是怎么看待新的 Proxy API 的？已经计划用在你的项目里面了？可以在 Twitter 上给我留言让我知道你的想法，我是 [@keithamus](https://twitter.com/keithamus)。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
