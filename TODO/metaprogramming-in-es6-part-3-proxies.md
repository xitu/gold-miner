> * 原文地址：[Metaprogramming in ES6: Part 3 - Proxies](https://www.keithcirkel.co.uk/metaprogramming-in-es6-part-3-proxies/)
> * 原文作者：[Keith Cirkel](https://twitter.com/keithamus)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-part-3-proxies.md](https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-part-3-proxies.md)
> * 译者：
> * 校对者：

# Metaprogramming in ES6: Part 3 - Proxies

In the third and final installment of my Metaprogramming in ES6 series - remember, those posts I wrote over a year ago and promised I wouldn’t take ages to complete but did? In this last post, we’ll be looking at possibly the coolest ES6 Reflection feature: Proxies. Those of you versed in my back catalogue will have already read [my last post, when we had a look at the ES6 Reflect API](/metaprogramming-in-es6-part-2-reflect/), and [the post before where we took a look at ES6 Symbols](/metaprogramming-in-es6-symbols/) - those of you haven’t should go ahead and get versed, the Reflect will be particularly relevant here and is required reading before we continue. Just like the other posts, I’m going to quote a point I made in Part 1:

> * Symbols are all about Reflection within implementation - you sprinkle them on your existing classes and objects to change the behaviour.
> * Reflect is all about Reflection through introspection - used to discover very low level information about your code.
> * Proxy is all about Reflection through intercession - wrapping objects and intercepting their behaviours through traps.

So, `Proxy` is a new global constructor (like `Date` or `Number`) that you pass an Object, a bunch of hooks, and it spits out a _new_ Object that wraps the old one with all these fancy hooks. Voilà, you have a proxy! Post over, hope you enjoyed it, let’s all go home!

Ok, so there’s definitely some more to it. For starters, let’s have a look at the constructor.

## Creating Proxies

The Proxy constructor takes two arguments, an initial Object that you want to proxy, and a set of handler hooks. Let’s forget about the hooks for the moment and take a look at how we create proxies on objects. The clue is in the name with Proxies: they hold a reference to the Object you create, but if you have a reference to the original Object then you can still interact with it, and the Proxy will also be affected, similarly, any alterations you make with Proxy will be reflected onto the original object. In other words, Proxies return a new object which wraps the passed in object, but anything you do with either effects the other. To demonstrate:

```
var myObject = {};
var proxiedMyObject = new Proxy(myObject, {/*handler hooks*/});

assert(myObject !== proxiedMyObject);

myObject.foo = true;
assert(proxiedMyObject.foo === true);

proxiedMyObject.bar = true;
assert(myObject.bar === true);
```

So far we’ve achieved nothing, our Proxy doesn’t give us any benefits over just using the normal object. To do interesting stuff with it, we’ll need to use the handler hooks.

## Proxy Handler Hooks

The handler hooks are a set of functions, each one has a specific name that Proxy is aware of, and each one controls the behaviour of how you interact with the Proxy (and therefore, its wrapped object). The handler hooks JavaScript’s “internal methods”, and if this is sounding familiar that’s because we already discussed Internal Methods in [the post on the Reflect API](/metaprogramming-in-es6-part-2-reflect/#internal-methods).

Ok, it’s time to spill the beans. There’s a good reason I saved Proxy until last; that’s because we needed to understand how Reflect works, because Proxy and Reflect are intertwined, like star crossed lovers. You see, every handler hook Proxy has Reflect has a method for, or to put it another way, every one of the Reflect methods has a Proxy Handler Hook. The full list of Reflect methods/Proxy handler hooks is:

* `apply` (call a function with a `this` argument and a set of `arguments`)
* `construct` (call a class/constructor function with a set of `arguments` and optional constructor for prototype)
* `defineProperty` (define a property on an Object, including metadata about its enumerability and whatnot)
* `getOwnPropertyDescriptor` (get a properties “property descriptor”: the metadata about an object property such as its enumerability)
* `deleteProperty` (delete a property from an object)
* `getPrototypeOf` (get an instances prototype)
* `setPrototypeOf` (set an instances prototype)
* `isExtensible` (determine if an object is “extensible” (can have properties added to it))
* `preventExtensions` (prevent the object from being extensible)
* `get` (get the value of a property on an object)
* `set` (set the value of a property on an object)
* `has` (check if an object has a particular property without asserting on the value)
* `ownKeys` (retreive all of the own keys of a Object: the keys it has, but not the keys its prototype has)

We went over all of these methods (with code samples) in the [Reflect post](/metaprogramming-in-es6-part-2-reflect/) (one more time: go read it if you haven’t). Proxy implements every one of these, with exactly the same argument set. In fact, Proxy’s default behaviour essentially implements Reflect calls for every handler hook (the internal mechanics of JavaScript engines might be slightly different, but we can just pretend that unspecified hooks will just default to their Reflect counterparts). This also means that any hook you don’t specify will behave just like it normally would, as if it was never proxied:

```
// Here is a Proxy where we're defining the same behaviour as the default:
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

Now, I could go into detail about how each of these Proxy handler hooks works, but it’d basically be me copy/pasting the Reflect examples with a few minor edits. It’d also be a bit unfair for Proxy, because Proxy is all about the cool use cases, not the utility of individual methods. So the rest of this post is going to show you cool things you can do with proxies, including some you could never do without them.

Also, to make things a bit more interactive, I’ve created small libraries for each of the examples, which demonstrate the functionality. I’ll link the repos to each example.

## Using Proxy to…

### …make an infinitely chainable API

Building on the previous example - using the same `[[Get]]` trap: with a little bit more magic we can make an API which has an infinite number of methods, and when you finally call one of those it’ll return everything you chained. This could be useful, for example, in making a [fluent API](https://en.wikipedia.org/wiki/Fluent_interface) that constructs URLs for web requests, or maybe some kind of Test Assertion framework that chains together English words to make readable assertions, kind of like [Chai](https://github.com/chaijs/chai).

For this we need to hook into `[[Get]]`, and push the retrieved prop into an array. The Proxy will wrap a function which returns the Array of all retrieved props and empty the array, so it can be re-used. We’ll also hook into `[[HasProperty]]` because, like before, we want to demonstrate to our users that any property exists.

```
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

```
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

### …implement a “method missing” hook

Various other programming languages give you the ability to override the behaviour of a class using a well-known reflection methods, for example in PHP it is `__call`, in Ruby it is `method_missing`, in Python you can emulate this behaviour with `__getattr__`. JavaScript has no such mechanism - but now we have Proxies which allow us to do cool things like this.

To get an idea of what we’re after, let’s look at a Ruby example for some inspiration:

```
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

```
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

```
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

```
Users.find_by_first_name('Keith'); # [ Keith Cirkel, Keith Urban, Keith David ]
Users.find_by_first_name_and_last_name('Keith', 'David');  # [ Keith David ]
```

We could implement something similar in JavaScript using our above pattern:

```
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

### …hide all properties from all enumeration methods including `getOwnPropertyNames`, `Object.keys`, `in` etc.

We can use Proxies to make every property in an object completely hidden, except for when getting the value. Here’s all of the ways you can find out if a property exists on an Object in JavaScript:

* `Reflect.has`,`Object.hasOwnProperty`,`Object.prototype.hasOwnProperty`, and the `in` operator all use `[[HasProperty]]`. Proxy can trap this with `has`.
* `Object.keys`/`Object.getOwnPropertyNames`, which uses `[[OwnPropertyKeys]]`. Proxy can trap this with `ownKeys`.
* `Object.entries` (an upcoming ES2017 feature), also uses `[[OwnPropertyKeys]]` - again - trapped by `ownKeys`.
* `Object.getOwnPropertyDescriptor` which uses `[[GetOwnProperty]]`. Proxy can trap this with, surprise surprise, `getOwnPropertyDescriptor`.

```
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

### …implement the Observer pattern, aka Object.observe.

Those of you who keenly follow the additions of new specs may have noticed `Object.observe` being considered for inclusion in ES2016\. Recently, however, the champions of `Object.observe` have planned to [withdraw their proposal to include Object.observe](https://esdiscuss.org/topic/an-update-on-object-observe), and with good reason: it was originally created to answer a problem framework authors had around Data Binding. Now, with React and Polymer 1.0, the trend of data binding frameworks is declining, and instead immutable data structures are becoming more prevalent.

Thankfully, Proxy actually makes specs like Object.observe redundant, as now we have a low level API through Proxy, we can actually implement something like Object.observe. To get close feature parity with Object.observe, we need to hook on the `[[Set]]`, `[[PreventExtensions]]`, `[[Delete]]`, and `[[DefineOwnProperty]]` internal methods - that’s the `set`, `preventExtensions`, `deleteProperty` and `defineProperty` Proxy traps respectively:

```
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

## Bonus Round: Revocable Proxies

Proxies have one last trick up their sleeve: some Proxies can be revoked. To create a revocable Proxy, you need to use `Proxy.revocable(target, handler)` (instead of `new Proxy(target, handler)`), and instead of returning the Proxy directly, it’ll return an Object that looks like `{ proxy, revoke(){} }`. An example:

```
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

## Conclusion

I hope this post has shown you that Proxy is an incredibly powerful tool for messing with (what used to be) JavaScript internals. In many ways, Symbol, Reflect, and Proxy are opening up a new chapter of JavaScript - in as much as const and let, or classes and arrow functions. While const & let make code less confusing, and classes & arrow functions make code more terse, Symbol, Reflect, and Proxy are beginning to give developers really low level metaprogramming hooks within JavaScript.

These new metaprogramming tools are also not slowing down any time soon: new proposals for future EcmaScript versions are shaping up and adding additional interesting behaviours, such as [this proposal for `Reflect.isCallable` & `Reflect.isConstructor`](https://github.com/caitp/TC39-Proposals/blob/master/tc39-reflect-isconstructor-iscallable.md), [or this stage 0 proposal for `Reflect.type`](https://github.com/alex-weej/es-reflect-type-proposal), or [this proposal for `function.sent` meta property](https://github.com/allenwb/ESideas/blob/master/Generator%20metaproperty.md), [or this one for a bunch more function metaproperties](https://github.com/allenwb/ESideas/blob/master/ES7MetaProps.md). Also, these new APIs have inspired some interesting discussions about some great new features, such as [this proposal about adding `Reflect.parse`](https://esdiscuss.org/topic/reflect-parse-from-re-typeof-null), subsequently leading to discussion around making a AST (Abstract Syntax Tree) standard.

What do you think about the new Proxy API? Plan on using it in your project? Let me know, in the comments below or on Twitter, where I’m [@keithamus](https://twitter.com/keithamus).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
