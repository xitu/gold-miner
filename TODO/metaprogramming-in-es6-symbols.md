> * 原文地址：[Metaprogramming in ES6: Symbols and why they're awesome](https://www.keithcirkel.co.uk/metaprogramming-in-es6-symbols/)
> * 原文作者：[Keith Cirkel](https://twitter.com/keithamus)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-symbols.md](https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-symbols.md)
> * 译者：
> * 校对者：

# Metaprogramming in ES6: Symbols and why they're awesome

You’ve heard of ES6 right? It’s the new version of JavaScript that is awesome in so many ways. I frequently wax lyrical about all of the amazing new features I keep discovering with ES6, much to the chagrin of my colleagues (consuming someone’s lunch break talking about ES6 Modules seems to be not to everyone’s liking).

A set of great new features for ES6 comes in the form of a slew of new metaprogramming tools, which provide low level hooks into code mechanics. Not much has been written on them, so I thought I’d do a teensy weensy 3 part post on them (sidebar; because I’m so lazy and this post has been sat in my drafts folder - 90% done - for three months, a [bit more has been written about them since I said that](https://hacks.mozilla.org/2015/06/es6-in-depth-symbols/)):

Part 1: Symbols (this post) [Part 2: Reflect](/metaprogramming-in-es6-part-2-reflect/) [Part 3: Proxies](/metaprogramming-in-es6-part-3-proxies/)

## Metaprogramming

First, let’s take a quick detour and discover the wonderful world of Metaprogramming. Metaprogramming is (loosely) all about the underlying mechanics of the language, rather than “high level” data modelling or business logic. If programming can be described as “making programs”, metaprogramming could be described as “making programs making programs” - or something. You probably use metaprogramming every day perhaps without even noticing it.

Metaprogramming has a few “subgenres” - one is _Code Generation_, aka `eval` & friends - which JavaScript has had since its inception (JS had `eval` in ES1, even before it got `try`/`<span class="k">catch</span>` or `switch` statements). Pretty much every other language you’d reasonably use today has _code generation_ features.

Another facet of metaprogramming is Reflection - finding out about and adjusting the structure and semantics of your application. JavaScript has quite a few tools for Reflection. Functions have `Function#name` and `Function#length`, as well as `Function#bind`, `Function#call`, and `Function#apply`. All of the available methods on Object are Reflection, e.g. `Object.getOwnProperties` (As an aside, Reflection tools that don’t alter code, but instead gather information about it are often called Introspection). We also have Reflection/Introspection operators, like `typeof`, `instanceof`, and `delete`.

Reflection is a really cool part of metaprogramming, because it allows you to alter the internals of how an application works. Take for example Ruby, in Ruby you can specify operators as methods which lets you override how those operators work when used against the class (sometimes called “operator overloading”):

```
class BoringClass
end
class CoolClass
  def ==(other_object)
   other_object.is_a? CoolClass
  end
end
BoringClass.new == BoringClass.new #=> false
CoolClass.new == CoolClass.new #=> true!
```

Compared to other languages like Ruby or Python, JavaScript’s metaprogramming features are not yet as advanced - especially when it comes to nifty tools like Operator Overloading, but ES6 is starting to level the playing field.

### Metaprogramming within ES6

The new APIs in ES6 come in three flavours: `Symbol`, `Reflect`, and `Proxy`. Upon first glance this might be a little confusing - three separate APIs all for metaprogramming? But it actually makes a lot of sense when you see how each one is split:

* Symbols are all about _Reflection within implementation_ - you sprinkle them on your existing classes and objects to change the behaviour.
* Reflect is all about _Reflection through introspection_ - used to discover very low level information about your code.
* Proxy is all about _Reflection through intercession_ - wrapping objects and intercepting their behaviours through traps.

So how does each one work? How are they useful? This post will cover Symbols, while the next two posts will cover Reflect and Proxy respectively.

## Symbols - Reflection within Implementation

Symbols are a new primitive. Just like the `Number`, `String`, and `Boolean` primitives, Symbols have a `Symbol` function which can be used to create them. Unlike the other primitives, Symbols do not have a literal syntax (e.g how Strings have `''`) - the only way to make them is with the Symbol constructor-not-constructor-thingy:

```
Symbol(); // symbol
console.log(Symbol()); // prints "Symbol()" to the console
assert(typeof Symbol() === 'symbol')
new Symbol(); // TypeError: Symbol is not a constructor
```

### Symbols have debuggability built in

Symbols can be given a description, which is really just used for debugging to make life a little easier when logging them to a console:

```
console.log(Symbol('foo')); // prints "Symbol(foo)" to the console.
assert(Symbol('foo').toString() === 'Symbol(foo)');
```

### Symbols can be used as Object keys

This is where Symbols get really interesting. They are heavily intertwined with Objects. Symbols can be assigned as keys to Objects (kind of like String keys), meaning you can assign an unlimited number of unique Symbols to an object and be guaranteed that these will never conflict with String keys, or other unique Symbols:

```
var myObj = {};
var fooSym = Symbol('foo');
var otherSym = Symbol('bar');
myObj['foo'] = 'bar';
myObj[fooSym] = 'baz';
myObj[otherSym] = 'bing';
assert(myObj.foo === 'bar');
assert(myObj[fooSym] === 'baz');
assert(myObj[otherSym] === 'bing');
```

In addition to that, Symbols do not show up on an Object using `for in`, `for of` or `Object.getOwnPropertyNames` - the only way to get the Symbols within an Object is `Object.getOwnPropertySymbols`:

```
var fooSym = Symbol('foo');
var myObj = {};
myObj['foo'] = 'bar';
myObj[fooSym] = 'baz';
Object.keys(myObj); // -> [ 'foo' ]
Object.getOwnPropertyNames(myObj); // -> [ 'foo' ]
Object.getOwnPropertySymbols(myObj); // -> [ Symbol(foo) ]
assert(Object.getOwnPropertySymbols(myObj)[0] === fooSym);
```

This means Symbols give a whole new sense of purpose to Objects - they provide a kind of hidden under layer to Objects - not iterable over, not fetched using the already existing Reflection tools and guaranteed not to conflict with other properties in the object!

### Symbols are completely unique…

By default, each new Symbol has a completely unique value. If you create a symbol (`var mysym = Symbol()`) it creates a completely new value inside the JavaScript engine. If you don’t have the _reference_ for the Symbol, you just can’t use it. This also means two symbols will never equal the same value, even if they have the same description.

```
assert.notEqual(Symbol(), Symbol());
assert.notEqual(Symbol('foo'), Symbol('foo'));
assert.notEqual(Symbol('foo'), Symbol('bar'));

var foo1 = Symbol('foo');
var foo2 = Symbol('foo');
var object = {
    [foo1]: 1,
    [foo2]: 2,
};
assert(object[foo1] === 1);
assert(object[foo2] === 2);
```

### …except when they’re not.

Well, there’s a small caveat to that - as there is also another way to make Symbols that can be easily fetched and re-used: `Symbol.for()`. This method creates a Symbol in a “global Symbol registry”. Small aside: this registry is also cross-realm, meaning a Symbol from an iframe or service worker will be the same as one generated from your existing frame:

```
assert.notEqual(Symbol('foo'), Symbol('foo'));
assert.equal(Symbol.for('foo'), Symbol.for('foo'));

// Not unique:
var myObj = {};
var fooSym = Symbol.for('foo');
var otherSym = Symbol.for('foo');
myObj[fooSym] = 'baz';
myObj[otherSym] = 'bing';
assert(fooSym === otherSym);
assert(myObj[fooSym] === 'bing');
assert(myObj[otherSym] === 'bing');

// Cross-Realm
iframe = document.createElement('iframe');
iframe.src = String(window.location);
document.body.appendChild(iframe);
assert.notEqual(iframe.contentWindow.Symbol, Symbol);
assert(iframe.contentWindow.Symbol.for('foo') === Symbol.for('foo')); // true!
```

Having global Symbols does make things more complicated, but for good reason, which we’ll get to. Right now some of you are probably saying “Argh!? How will I know which Symbols are unique Symbols and which Symbols aren’t?”, to that I say “it’s okay, I got you, nothing bad is going to happen, we have `Symbol.keyFor()`”:

```
var localFooSymbol = Symbol('foo');
var globalFooSymbol = Symbol.for('foo');

assert(Symbol.keyFor(localFooSymbol) === undefined);
assert(Symbol.keyFor(globalFooSymbol) === 'foo');
assert(Symbol.for(Symbol.keyFor(globalFooSymbol)) === Symbol.for('foo'));
```

### What Symbols are, what Symbols aren’t.

So we’ve got a good overview for what Symbols are, and how they work - but it’s just as important to know what Symbols _are_ good for, and what they’re _not_ good for, as they could easily be assumed to be something they’re not:

* **Symbols will never conflict with Object string keys**. This makes them great for extending objects you’ve been given (e.g. as a function param) without affecting the Object in a noticeable way.
* **Symbols cannot be read using existing reflection tools**. You need the new `Object.getOwnPopertySymbols()` to access an Object’s symbols, this makes Symbols great for storing bits of information you don’t want people getting at through normal operation. Using `Object.getOwnPropertySymbols()` is a pretty special use-case.
* **Symbols are not private**. The other edge to that sword - all of the Symbols of an object can be gotten by using `Object.getOwnSymbols()` - not very useful for a truly private value. Don’t try to store information you want to be really private in an Object using a symbol - it can be gotten!
* **Enumerable Symbols can be copied to other objects** using new methods like Object.assign. If you try calling `Object.assign(newObject, objectWithSymbols)` all of the (enumerable) Symbols in the second param (`objectWithSymbols`) _will be copied_ to the first (`newObject`). If you don’t want this to happen, make them non-enumerable with `Object.defineProperty`.
* **Symbols are not coercible into primitives**. If you try to coerce a Symbol to a primitive (`+Symbol()`, `''+Symbol()`, `Symbol() + 'foo'`) it will throw an Error. This prevents you accidentally stringifying them when setting them as property names.
* **Symbols are not always unique**. As mentioned above, `Symbol.for()` returns you a non-unique Symbol. Don’t always assume the Symbol you have is unique, unless you made it yourself.
* **Symbols are nothing like Ruby Symbols**. They share some similarities - such as having a central Symbol registry, but that’s about it. They should not be used the same as Ruby symbols.

## Okay, but what are Symbols really good for?

In reality, Symbols are just a slightly different way to attach properties to an Object - you could easily provide the well-known symbols as standard methods, just like `Object.prototype.hasOwnProperty` which appears in everything that inherits from Object (which is basically everything). In fact, other languages such as Python do just that - Python’s equivalent of `Symbol.iterator` is `__iter__`, `Symbol.hasInstance` is `__instancecheck__`, and I guess `Symbol.toPrimitive` draws similarities with `__cmp__`. Python’s way is, arguably, a worse approach though, as JavaScript Symbols don’t need any weird syntax, and in no way can a user accidentally conflict with one of these special methods.

Symbols, in my opinion, can be used 2 fold:

### 1. As a unique value where you’d probably normally use a String or Integer:

Let’s assume you have a logging library, which includes multiple log levels such as `logger.levels.DEBUG`, `logger.levels.INFO`, `logger.levels.WARN` and so on. In ES5 code you’d like make these Strings (so `logger.levels.DEBUG === 'debug'`), or numbers (`logger.levels.DEBUG === 10`). Both of these aren’t ideal as those values aren’t unique values, but Symbols are! So `logger.levels` simply becomes:

```
log.levels = {
    DEBUG: Symbol('debug'),
    INFO: Symbol('info'),
    WARN: Symbol('warn'),
};
log(log.levels.DEBUG, 'debug message');
log(log.levels.INFO, 'info message');
```

### 2. A place to put metadata values in an Object

You could also use them to store custom metadata properties that are secondary to the actual Object. Think of this as an extra layer of non-enumerability (after all, non-enumerable keys still come up in `Object.getOwnProperties`). Lets take our trusty Collection class and add a size reference, which is hidden behind the scenes as a Symbol (just remember that **Symbols are not private** - and you can - and should - only use them in for stuff you don’t mind being altered by the rest of the app):

```
var size = Symbol('size');
class Collection {
    constructor() {
        this[size] = 0;
    }

    add(item) {
        this[this[size]] = item;
        this[size]++;
    }

    static sizeOf(instance) {
        return instance[size];
    }

}

var x = new Collection();
assert(Collection.sizeOf(x) === 0);
x.add('foo');
assert(Collection.sizeOf(x) === 1);
assert.deepEqual(Object.keys(x), ['0']);
assert.deepEqual(Object.getOwnPropertyNames(x), ['0']);
assert.deepEqual(Object.getOwnPropertySymbols(x), [size]);
```

### 3. Giving developers ability to add hooks to their objects, through your API

Ok, this sounds a little weird but bear with me. Let’s pretend that we have a `console.log` style utility function - this function can take _any_ Object, and log it to the console. It has its own routines for how it displays the given Object in the console - but you, as a developer who consumes this API, can override those by providing a method, under a hook: an `inspect` Symbol:

```
// Retreive the magic inspect Symbol from the API's Symbol constants
var inspect = console.Symbols.INSPECT;

var myVeryOwnObject = {};
console.log(myVeryOwnObject); // logs out `{}`

myVeryOwnObject[inspect] = function () { return 'DUUUDE'; };
console.log(myVeryOwnObject); // logs out `DUUUDE`
```

An implementation of this theoretical inspect hook could look a little something like this:

```
console.log = function (…items) {
    var output = '';
    for(const item of items) {
        if (typeof item[console.Symbols.INSPECT] === 'function') {
            output += item[console.Symbols.INSPECT](item);
        } else {
            output += console.inspect[typeof item](item);
        }
        output += '  ';
    }
    process.stdout.write(output + '\n');
}
```

To clarify, this does not mean you should write code that modifies objects given to it. That would most definitely be a no-no (for this, have a look at [WeakMaps](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/WeakMap) which can provide ancillary objects for you to gather your own metadata on Objects).

[Node.js already has similar behaviour with its implementation of `console.log`](https://nodejs.org/api/util.html#util_custom_inspect_function_on_objects). Sort of. It uses String (`'inspect'`) not a Symbol, meaning you can set `x.inspect = function(){}` - but this is clunky because it could clash with your classes methods, and occur by accident. Using Symbols _is a very purposeful way for this kind of behaviour to happen_.

This way of using Symbols is so profound, that it is actually part of the language, and with that we segue into the realm of well known Symbols…

## Well Known Symbols

A key part of what makes Symbols useful, is a set of Symbol constants, known as “well known symbols”. These are effectively a bunch of static properties on the `Symbol` class which are implemented within other native objects, such as Arrays, Strings, and within the internals of the JavaScript engine. This is where the real “Reflection within Implementation” part happens, as these well known Symbols alter the behaviour of (what used to be) JavaScript internals. Below I’ve detailed what each one does and why they’re just so darn awesome!

## Symbol.hasInstance: instanceof

`Symbol.hasInstance` is a Symbol which drives the behaviour of `instanceof`. When an ES6 compliant engine sees the `instanceof` operator in an expression it calls upon `Symbol.hasInstance`. For example, `lho instanceof rho` would call `rho[Symbol.hasInstance](lho)` (where `rho` is the right hand operand and `lho` is the left hand operand). It’s then up to the method to determine if it inherits from that particular instance, you could implement this like so:

```
class MyClass {
    static [Symbol.hasInstance](lho) {
        return Array.isArray(lho);
    }
}
assert([] instanceof MyClass);
```

### Symbol.iterator

If you’ve heard anything about Symbols, you’ve probably heard about `Symbol.iterator`. With ES6 comes a new pattern - the `for of` loop, which calls `Symbol.iterator` on right hand operand to get values to iterate over. In other words these two are equivalent:

```
var myArray = [1,2,3];

// with `for of`
for(var value of myArray) {
    console.log(value);
}

// without `for of`
var _myArray = myArray[Symbol.iterator]();
while(var _iteration = _myArray.next()) {
    if (_iteration.done) {
        break;
    }
    var value = _iteration.value;
    console.log(value);
}
```

`Symbol.iterator` will allow you to override the `of` operator - meaning if you make a library that uses it, developers will love you:

```
class Collection {
  *[Symbol.iterator]() {
    var i = 0;
    while(this[i] !== undefined) {
      yield this[i];
      ++i;
    }
  }

}
var myCollection = new Collection();
myCollection[0] = 1;
myCollection[1] = 2;
for(var value of myCollection) {
    console.log(value); // 1, then 2
}
```

### Symbol.isConcatSpreadable

`Symbol.isConcatSpreadable` is a pretty specific Symbol - driving the behaviour of `Array#concat`. You see, `Array#concat` can take multiple arguments, which - if arrays - will themselves be flattened (or spread) as part of the concat operation. Consider the following code:

```
x = [1, 2].concat([3, 4], [5, 6], 7, 8);
assert.deepEqual(x, [1, 2, 3, 4, 5, 6, 7, 8]);
```

As of ES6 the way `Array#concat` will determine if any of its arguments are spreadable will be with `Symbol.isConcatSpreadable`. This is more used to say that the class you have made that extends Array won’t be particularly good for `Array#concat`, rather than the other way around:

```
class ArrayIsh extends Array {
    get [Symbol.isConcatSpreadable]() {
        return true;
    }
}
class Collection extends Array {
    get [Symbol.isConcatSpreadable]() {
        return false;
    }
}
arrayIshInstance = new ArrayIsh();
arrayIshInstance[0] = 3;
arrayIshInstance[1] = 4;
collectionInstance = new Collection();
collectionInstance[0] = 5;
collectionInstance[1] = 6;
spreadableTest = [1,2].concat(arrayInstance).concat(collectionInstance);
assert.deepEqual(spreadableTest, [1, 2, 3, 4, <Collection>]);
```

### Symbol.unscopables

This Symbol has a bit of interesting history. Essentially, while developing ES6, the TC found some old code in a popular JS libraries that did this kind of thing:

```
var keys = [];
with(Array.prototype) {
    keys.push('foo');
}
```

This works well in old ES5 code and below, but ES6 now has `Array#keys` - meaning when you do `with(Array.prototype)`, `keys` is now the method `Array#keys` - not the variable you set. So there were three solutions:

1. Try to get all websites using this code to change it/update the libraries (impossible).
2. Remove `Array#keys` and hope another bug like this doesn’t crop up (not really solving the problem)
3. Write a hack around all of this which prevents some properties being scoped into `with` statements.

Well, the TC went with option 3, and so `Symbol.unscopables` was born, which defines a set of “unscopable” values in an Object which should not be set when used inside the `with` statement. You’ll probably never need to use this - nor will you encounter it in day to day JavaScripting, but it demonstrates some of the utility of Symbols, and also is here for completeness:

```
Object.keys(Array.prototype[Symbol.unscopables]); // -> ['copyWithin', 'entries', 'fill', 'find', 'findIndex', 'keys']

// Without unscopables:
class MyClass {
    foo() { return 1; }
}
var foo = function () { return 2; };
with (MyClass.prototype) {
    foo(); // 1!!
}

// Using unscopables:
class MyClass {
    foo() { return 1; }
    get [Symbol.unscopables]() {
        return { foo: true };
    }
}
var foo = function () { return 2; };
with (MyClass.prototype) {
    foo(); // 2!!
}
```

### Symbol.match

This is another Symbol specific to a function. `String#match` function will now use this to determine if the given value can be used to match against it. So, you can provide your own matching implementation to use, rather than using Regular Expressions:

```
class MyMatcher {
    constructor(value) {
        this.value = value;
    }
    [Symbol.match](string) {
        var index = string.indexOf(this.value);
        if (index === -1) {
            return null;
        }
        return [this.value];
    }
}
var fooMatcher = 'foobar'.match(new MyMatcher('foo'));
var barMatcher = 'foobar'.match(new MyMatcher('bar'));
assert.deepEqual(fooMatcher, ['foo']);
assert.deepEqual(barMatcher, ['bar']);
```

### Symbol.replace

Just like `Symbol.match`, `Symbol.replace` has been added to allow custom classes, where you’d normally use Regular Expressions, for `String#replace`:

```
class MyReplacer {
    constructor(value) {
        this.value = value;
    }
    [Symbol.replace](string, replacer) {
        var index = string.indexOf(this.value);
        if (index === -1) {
            return string;
        }
        if (typeof replacer === 'function') {
            replacer = replacer.call(undefined, this.value, string);
        }
        return `${string.slice(0, index)}${replacer}${string.slice(index + this.value.length)}`;
    }
}
var fooReplaced = 'foobar'.replace(new MyReplacer('foo'), 'baz');
var barMatcher = 'foobar'.replace(new MyReplacer('bar'), function () { return 'baz' });
assert.equal(fooReplaced, 'bazbar');
assert.equal(barReplaced, 'foobaz');
```

### Symbol.search

Yup, just like `Symbol.match` and `Symbol.replace`, `Symbol.search` exists to prop up `String#search` - allowing for custom classes instead of Regular Expressions:

```
class MySearch {
    constructor(value) {
        this.value = value;
    }
    [Symbol.search](string) {
        return string.indexOf(this.value);
    }
}
var fooSearch = 'foobar'.search(new MySearch('foo'));
var barSearch = 'foobar'.search(new MySearch('bar'));
var bazSearch = 'foobar'.search(new MySearch('baz'));
assert.equal(fooSearch, 0);
assert.equal(barSearch, 3);
assert.equal(bazSearch, -1);
```

### Symbol.split

Ok, last of the String symbols - `Symbol.split` is for `String#split`. Use like so:

```
class MySplitter {
    constructor(value) {
        this.value = value;
    }
    [Symbol.split](string) {
        var index = string.indexOf(this.value);
        if (index === -1) {
            return string;
        }
        return [string.substr(0, index), string.substr(index + this.value.length)];
    }
}
var fooSplitter = 'foobar'.split(new MySplitter('foo'));
var barSplitter = 'foobar'.split(new MySplitter('bar'));
assert.deepEqual(fooSplitter, ['', 'bar']);
assert.deepEqual(barSplitter, ['foo', '']);
```

### Symbol.species

Symbol.species is a pretty clever Symbol, it points to the constructor value of a class, which allows classes to create new versions of themselves within methods. Take for example `Array#map`, which creates a new Array resulting from each return value of the callback - in ES5 `Array#map`’s code might look something like this:

```
Array.prototype.map = function (callback) {
    var returnValue = new Array(this.length);
    this.forEach(function (item, index, array) {
        returnValue[index] = callback(item, index, array);
    });
    return returnValue;
}
```

In ES6 `Array#map`, along with all of the other non-mutating Array methods have been upgraded to create Objects using the `Symbol.species` property, and so the ES6 `Array#map` code now looks more like this:

```
Array.prototype.map = function (callback) {
    var Species = this.constructor[Symbol.species];
    var returnValue = new Species(this.length);
    this.forEach(function (item, index, array) {
        returnValue[index] = callback(item, index, array);
    });
    return returnValue;
}
```

Now, if you were to make a `class Foo extends Array` - every time you called `Foo#map` while before it would return an Array (no fun) and you’d have to write your own Map implementation just to create `Foo`s instead of `Array`s, now `Foo#map` return a `Foo`, thanks to `Symbol.species`:

```
class Foo extends Array {
    static get [Symbol.species]() {
        return this;
    }
}

class Bar extends Array {
    static get [Symbol.species]() {
        return Array;
    }
}

assert(new Foo().map(function(){}) instanceof Foo);
assert(new Bar().map(function(){}) instanceof Bar);
assert(new Bar().map(function(){}) instanceof Array);
```

You may be asking “why not just use `this.constructor` instead of `this.constructor[Symbol.species]`?”. Well, `Symbol.species` provides a _customisable_ entry-point for what type to create - you might not always want to subclass and have methods create your subclass - take for example the following:

```
class TimeoutPromise extends Promise {
    static get [Symbol.species]() {
        return Promise;
    }
}
```

This timeout promise could be created to perform an operation that times out - but of course you don’t want one Promise that times out to subsequently effect the whole Promise chain, and so `Symbol.species` can be used to tell `TimeoutPromise` to return `Promise` from it’s prototype methods. Pretty handy.

### Symbol.toPrimitive

This Symbol is the closest thing we have to overloading the Abstract Equality Operator (`==` for short). Basically, `Symbol.toPrimitive` is used when the JavaScript engine needs to convert your Object into a primitive value - for example if you do `+object` then JS will call `object[Symbol.toPrimitive]('number');`, if you do `''+object'` then JS will call `object[Symbol.toPrimitive]('string')`, and if you do something like `if(object)` then it will call `object[Symbol.toPrimitive]('default')`. Before this, we had `valueOf` and `toString` to juggle with - both of which were kind of gnarly and you could never get the behaviour you wanted from them. `Symbol.toPrimitive` gets implemented like so:

```
class AnswerToLifeAndUniverseAndEverything {
    [Symbol.toPrimitive](hint) {
        if (hint === 'string') {
            return 'Like, 42, man';
        } else if (hint === 'number') {
            return 42;
        } else {
            // when pushed, most classes (except Date)
            // default to returning a number primitive
            return 42;
        }
    }
}

var answer = new AnswerToLifeAndUniverseAndEverything();
+answer === 42;
Number(answer) === 42;
''+answer === 'Like, 42, man';
String(answer) === 'Like, 42, man';
```

### Symbol.toStringTag

Ok, this is the last of the well known Symbols. Come on, you’ve got this far, you can do this! `Symbol.toStringTag` is actually a pretty cool one - if you’ve ever tried to implement your own replacement for the `typeof` operator, you’ve probably come across  `Object#toString()` - and how it returns this weird `'[object Object]'` or `'[object Array]'` String. Before ES6, this behaviour was defined in the crevices of the spec, however today, in fancy ES6 land we have a Symbol for it! Any Object passed to `Object#toString()` will be checked to see if it has a property of `[Symbol.toStringTag]` which should be a String, and if it is there then it will be used in the generated String - for example:

```
class Collection {

  get [Symbol.toStringTag]() {
    return 'Collection';
  }

}
var x = new Collection();
Object.prototype.toString.call(x) === '[object Collection]'
```

As an aside for this - if you use [Chai](http://chaijs.com) for testing, it now uses Symbols under the hood for type detection, so you can write `expect(x).to.be.a('Collection')` in your tests (provided `x` has the Symbol.toStringTag property like above, oh and that you’re running the code in a browser with `Symbol.toStringTag`).

## The missing well-known Symbol: Symbol.isAbstractEqual

You’ve probably figured it out by now - but I really like the idea of Symbols for Reflection. To me, there is one piece missing that would make them something I’d be really excited about: `Symbol.isAbstractEqual`. Having a `Symbol.isAbstractEqual` well known Symbol could bring the abstract equality operator (`==`) back into popular usage. Being able to use it in your own way, for your own classes just like you can in Ruby, Python, and co. When you see code like `lho == rho` it could be converted into `rho[Symbol.isAbstractEqual](lho)`, allowing classes to override what `==` means to them. This could be done in a backwards compatible way - by defining defaults for all current primitive prototypes (e.g. `Number.prototype`) and would tidy up a chunk of the spec, while giving developers a reason to bring `==` back from the bench.

## Conclusion

What do you think about Symbols? Still confused? Just want to rant to someone? I’m [@keithamus over on the Twitterverse](https://twitter.com/keithamus) - so feel free to hit me up there, who knows, one day I might be taking up your whole lunchtimes telling you about sweet new ES6 features I like way too much.

Now you’re done reading all about Symbols, you should totally read [Part 2 - Reflect](/metaprogramming-in-es6-part-2-reflect/).

Also lastly I’d like to thank the excellent developers [@focusaurus](https://twitter.com/focusaurus), [@mttshw](https://twitter.com/mttshw), [@colby_russell](https://twitter.com/colby_russell), [@mdmazzola](https://twitter.com/mdmazzola), and [@WebReflection](https://twitter.com/WebReflection) for proof reading this, and making much needed improvements.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
