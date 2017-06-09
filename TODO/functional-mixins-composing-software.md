> * 原文地址：[Functional Mixins](https://medium.com/javascript-scene/functional-mixins-composing-software-ffb66d5e731c)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

---

# Functional Mixins

## Composing Software

![](https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

> Note: This is part of the “Composing Software” series on learning functional programming and compositional software techniques in JavaScript ES6+ from the ground up. Stay tuned. There’s a lot more of this to come!
> [< Previous](https://medium.com/javascript-scene/functors-categories-61e031bac53f) | [<< Start over at Part 1](https://medium.com/javascript-scene/composing-software-an-introduction-27b72500d6ea)

**Functional mixins** are composable factory functions which connect together in a pipeline; each function adding some properties or behaviors like workers on an assembly line. Functional mixins don’t depend on or require a base factory or constructor: Simply pass any arbitrary object into a mixin, and an enhanced version of that object will be returned.

Functional mixin features:

- Data privacy/encapsulation
- Inheriting private state
- Inheriting from multiple sources
- No diamond problem (property collision ambiguity) — last in wins
- No base-class requirement

### Motivation

All modern software development is really composition: We break a large, complex problem down into smaller, simpler problems, and then compose solutions to form an application.

The atomic units of composition are one of two things:

- Functions
- Data structures

Application structure is defined by the composition of those atomic units. Often, composite objects are produced using class inheritance, where a class inherits the bulk of its functionality from a parent class, and extends or overrides pieces. The problem with that approach is that it leads to **is-a** thinking, e.g., “an admin is an employee”, causing lots of design problems:

- **The tight coupling problem:** Because child classes are dependent on the implementation of the parent class, class inheritance is the tightest coupling available in object oriented design.
- **The fragile base class problem:** Due to tight coupling, changes to the base class can potentially break a large number of descendant classes — potentially in code managed by third parties. The author could break code they’re not aware of.
- **The inflexible hierarchy problem:** With single ancestor taxonomies, given enough time and evolution, all class taxonomies are eventually wrong for new use-cases.
- **The duplication by necessity problem:** Due to inflexible hierarchies, new use cases are often implemented by duplication, rather than extension, leading to similar classes which are unexpectedly divergent. Once duplication sets in, it’s not obvious which class new classes should descend from, or why.
- **The gorilla/banana problem:** “…the problem with object-oriented languages is they’ve got all this implicit environment that they carry around with them. You wanted a banana but what you got was a gorilla holding the banana and the entire jungle.” ~ Joe Armstrong, [“Coders at Work”](http://www.amazon.com/gp/product/1430219483?ie=UTF8&amp;camp=213733&amp;creative=393185&amp;creativeASIN=1430219483&amp;linkCode=shr&amp;tag=eejs-20&amp;linkId=3MNWRRZU3C4Q4BDN)

If an admin is an employee, how do you handle a situation where you hire an outside consultant to perform administrative duties temporarily? If you knew every requirement in advance, perhaps class inheritance could work, but I’ve never seen that happen. Given enough usage, applications and requirements inevitably grow and evolve over time as new problems and more efficient processes are discovered.

Mixins offer a more flexible approach.

### What are Mixins?

> *“Favor object composition over class inheritance” the Gang of Four, *[*“Design Patterns: Elements of Reusable Object Oriented Software”*](https://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612/ref=as_li_ss_tl?ie=UTF8&amp;qid=1494993475&amp;sr=8-1&amp;keywords=design+patterns&amp;linkCode=ll1&amp;tag=eejs-20&amp;linkId=6c553f16325f3939e5abadd4ee04e8b4)

**Mixins** are a form of *object composition,* where component features get mixed into a composite object so that properties of each mixin become properties of the composite object.

The term “mixins” in OOP comes from mixin ice cream shops. Instead of having a whole lot of ice-cream flavors in different pre-mixed buckets, you have vanilla ice cream, and a bunch of separate ingredients that could be mixed in to create custom flavors for each customer.

Object mixins are similar: You start with an empty object and mix in features to extend it. Because JavaScript supports dynamic object extension and objects without classes, using object mixins is trivially easy in JavaScript — so much so that it is the most common form of inheritance in JavaScript by a huge margin. Let’s look at an example:

    const chocolate = {
      hasChocolate: () => true
    };

    const caramelSwirl = {
      hasCaramelSwirl: () => true
    };

    const pecans = {
      hasPecans: () => true
    };

    const iceCream = Object.assign({}, chocolate, caramelSwirl, pecans);

    /*
    // or, if your environment supports object spread...
    const iceCream = {...chocolate, ...caramelSwirl, ...pecans};
    */

    console.log(`
      hasChocolate: ${ iceCream.hasChocolate() }
      hasCaramelSwirl: ${ iceCream.hasCaramelSwirl() }
      hasPecans: ${ iceCream.hasPecans() }
    `);

Which logs:

      hasChocolate: true
      hasCaramelSwirl: true
      hasPecans: true

### What is Functional Inheritance?

Functional inheritance is the process of inheriting features by applying an augmenting function to an object instance. The function supplies a closure scope which you can use to keep some data private. The augmenting function uses dynamic object extension to extend the object instance with new properties and methods.

Let’s look at an example from Douglas Crockford, who coined the term:

    // Base object factory
    function base(spec) {
        var that = {}; // Create an empty object
        that.name = spec.name; // Add it a "name" property
        return that; // Return the object
    }

    // Construct a child object, inheriting from "base"
    function child(spec) {
        // Create the object through the "base" constructor
        var that = base(spec);
        that.sayHello = function() { // Augment that object
            return 'Hello, I\'m ' + that.name;
        };
        return that; // Return it
    }

    // Usage
    var result = child({ name: 'a functional object' });
    console.log(result.sayHello()); // "Hello, I'm a functional object"

Because `child()` is tightly coupled to `base()`, when you add `grandchild()`, `greatGrandchild()`, etc..., you'll opt into most of the common problems from class inheritance.

### What is a Functional Mixin?

Functional mixins are composable functions which mix new properties or behaviors with properties from a given object. Functional mixins don’t depend on or require a base factory or constructor: Simply pass any arbitrary object into a mixin, and it will be extended.

Let’s look at an example:

    const flying = o => {
      let isFlying = false;

      return Object.assign({}, o, {
        fly () {
          isFlying = true;
          return this;
        },

        isFlying: () => isFlying,

        land () {
          isFlying = false;
          return this;
        }
      });
    };

    const bird = flying({});
    console.log( bird.isFlying() ); // false
    console.log( bird.fly().isFlying() ); // true

Notice that when we call `flying()`, we need to pass an object in to be extended. Functional mixins are designed for function composition. Let's create something to compose with:

    const quacking = quack => o => Object.assign({}, o, {
      quack: () => quack
    });

    const quacker = quacking('Quack!')({});
    console.log( quacker.quack() ); // 'Quack!'

### Composing Functional Mixins

Functional mixins can be composed with simple function composition:

    const createDuck = quack => quacking(quack)(flying({}));

    const duck = createDuck('Quack!');

    console.log(duck.fly().quack());

That looks a little awkward to read, though. It can also be a bit tricky to debug or re-arrange the order of composition.

Of course, this is standard function composition, and we already know some better ways to do that using `compose()` or `pipe()`. If we use `pipe()` to reverse the function order, the composition will read like `Object.assign({}, ...)` or `{...object, ...spread}` -- preserving the same order of precedence. In case of property collisions, the last object in wins.

    const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);
    // OR...
    // import pipe from `lodash/fp/flow`;

    const createDuck = quack => pipe(
      flying,
      quacking(quack)
    )({});

    const duck = createDuck('Quack!');

    console.log(duck.fly().quack());

### When to Use Functional Mixins

You should always use the simplest possible abstraction to solve the problem you’re working on. Start with a pure function. If you need an object with persistent state, try a factory function. If you need to build more complex objects, try functional mixins.

Here are some good use-cases for functional mixins:

- Application state management, e.g., a Redux store.
- Certain cross-cutting concerns and services, e.g., a centralized logger.
- UI components with lifecycle hooks.
- Composable functional data types, e.g., the JavaScript `Array` type implements `Semigroup`, `Functor`, `Foldable`

Some algebraic structures can be derived in terms of other algebraic structures, meaning that certain derivations can be composed into a new data type without customization.

### Caveats

Most problems can be elegantly solved using pure functions. The same is not true of functional mixins. Like class inheritance, functional mixins can cause problems of their own. In fact, it’s possible to faithfully reproduce all of the features and problems of class inheritance using functional mixins.

You can avoid that, though, using the following advice:

- Use the simplest practical implementation. Start on the left and move to the right only as needed: pure functions > factories > functional mixins > classes
- Avoid the creation of **is-a** relationships between objects, mixins, or data types
- Avoid implicit dependencies between mixins — wherever possible, functional mixins should be self-contained, and have no knowledge of other mixins
- “Functional mixins” doesn’t mean “functional programming”

### Classes

Class inheritance is very rarely (perhaps *never*) the best approach in JavaScript, but that choice is sometimes made by a library or framework that you don’t control. In that case, using `class` is sometimes practical, provided the library:

1. Does not require you to extend your own classes (i.e., does not require you to build multi-level class hierarchies), and
2. Does not require you to directly use the `new` keyword -- in other words, the framework handles instantiation for you

Both Angular 2+ and React meet those requirements, so you can safely use classes with them, as long as you don’t extend your own classes. React allows you to avoid using classes if you wish, but your components may fail to take advantage of optimizations built into React’s base classes, and your components won’t look like the components in documentation examples. In any case, you should always prefer the function form for React components when it makes sense.

#### Class Performance

In some browsers, classes may provide JavaScript engine optimizations that are not available otherwise. In almost all cases, those optimizations will not have a significant impact on your app’s performance. In fact, it’s possible to go many years without ever needing to worry about `class` performance differences. Object creation and property access is always very fast (millions of ops/sec), regardless of how you build your objects.

That said, authors of general purpose utility libraries similar to RxJS, Lodash, etc… should investigate possible performance benefits of using `class` to create object instances. Unless you have measured a significant bottleneck that you can provably and substantially reduce using `class`, you should optimize for clean, flexible code instead of worrying about performance.

### Implicit Dependencies

You may be tempted to create functional mixins designed to work together. Imagine you want to build a configuration manager for your app that logs warnings when you try to access configuration properties that don’t exist.

It’s possible to build it like this:

    // in its own module...
    const withLogging = logger => o => Object.assign({}, o, {
      log (text) {
        logger(text)
      }
    });



    // in a different module with no explicit mention of
    // withLogging -- we just assume it's there...
    const withConfig = config => (o = {
      log: (text = '') => console.log(text)
    }) => Object.assign({}, o, {
      get (key) {
        return config[key] == undefined ?

          // vvv implicit dependency here... oops! vvv
          this.log(`Missing config key: ${ key }`) :
          // ^^^ implicit dependency here... oops! ^^^

          config[key]
        ;
      }
    });

    // in yet another module that imports withLogging and
    // withConfig...
    const createConfig = ({ initialConfig, logger }) =>
      pipe(
        withLogging(logger),
        withConfig(initialConfig)
      )({})
    ;

    // elsewhere...
    const initialConfig = {
      host: 'localhost'
    };

    const logger = console.log.bind(console);

    const config = createConfig({initialConfig, logger});

    console.log(config.get('host')); // 'localhost'
    config.get('notThere'); // 'Missing config key: notThere'

However, it’s also possible to build it like this:

    // import withLogging() explicitly in withConfig module
    import withLogging from './with-logging';

    const addConfig = config => o => Object.assign({}, o, {
      get (key) {
        return config[key] == undefined ?
          this.log(`Missing config key: ${ key }`) :
          config[key]
        ;
      }
    });

    const withConfig = ({ initialConfig, logger }) => o =>
      pipe(

        // vvv compose explicit dependency in here vvv
        withLogging(logger),
        // ^^^ compose explicit dependency in here ^^^

        addConfig(initialConfig)
      )(o)
    ;

    // The factory only needs to know about withConfig now...
    const createConfig = ({ initialConfig, logger }) =>
      withConfig({ initialConfig, logger })({})
    ;



    // elsewhere, in a different module...
    const initialConfig = {
      host: 'localhost'
    };

    const logger = console.log.bind(console);

    const config = createConfig({initialConfig, logger});

    console.log(config.get('host')); // 'localhost'
    config.get('notThere'); // 'Missing config key: notThere'

The correct choice depends on a lot of factors. It is valid to require a lifted data type for a functional mixin to act on, but if that’s the case, the API contract should be made explicitly clear in the function signature and API documentation.

That’s the reason that the implicit version has a default value for `o` in the signature. Since JavaScript lacks type annotation capabilities, we can fake it by providing default values:

    const withConfig = config => (o = {
      log: (text = '') => console.log(text)
    }) => Object.assign({}, o, {
      // ...

If you’re using TypeScript or Flow, it’s probably better to declare an explicit interface for your object requirements.

### Functional Mixins & Functional Programming

“Functional” in the context of functional mixins does not always have the same purity connotations as “functional programming”. Functional mixins are commonly used in OOP style, complete with side-effects. Many functional mixins will alter the object argument you pass to them. Caveat emptor.

By the same token, some developers prefer a functional programming style, and will not maintain an identity reference to the object you pass in. You should code your mixins and the code that uses them assuming a random mix of both styles.

That means that if you need to return the object instance, always return `this` instead of a reference to the instance object in the closure -- in functional code, chances are those are not references to the same objects. Additionally, always assume that the object instance will be copied by assignment using `Object.assign()` or `{...object, ...spread}` syntax. That means that if you set non-enumerable properties, they will probably not work on the final object:

    const a = Object.defineProperty({}, 'a', {
      enumerable: false,
      value: 'a'
    });

    const b = {
      b: 'b'
    };

    console.log({...a, ...b}); // { b: 'b' }

By the same token, if you’re using functional mixins that you didn’t create in your functional code, don’t assume the code is pure. Assume that the base object may be mutated, and assume that there may be side-effects & no referential transparency guarantees, i.e., it is frequently unsafe to memoize factories composed of functional mixins.

### Conclusion

Functional mixins are composable factory functions which add properties and behaviors to objects like stations in an assembly line. They are a great way to compose behaviors from multiple source features (**has-a, uses-a, can-do**), as opposed to inheriting all the features of a given class (**is-a**).

Be aware, “functional mixins” doesn’t imply “functional programming” — it simply means, “mixins using functions”. Functional mixins can be written using a functional programming style, avoiding side-effects and preserving referential transparency, but that is not guaranteed. There may be side-effects and nondeterminism in third-party mixins.

- Unlike simple object mixins, functional mixins support true data privacy (encapsulation), including the ability to inherit private data.
- Unlike single-ancestor class inheritance, functional mixins also support the ability to inherit from many ancestors, similar to class decorators, traits, or multiple inheritance.
- Unlike multiple inheritance in C++, the diamond problem is rarely problematic in JavaScript, because there is a simple rule when collisions arise: The last mixin added wins.
- Unlike class decorators, traits, or multiple inheritance, no base class is required.

Start with the simplest implementation and move to more complex implementations only as required:

Pure functions > factory functions > functional mixins > classes

**To be continued…**

### Next Steps

Want to learn more about software composition with JavaScript?

[Learn JavaScript with Eric Elliott](http://ericelliottjs.com/product/lifetime-access-pass/). If you’re not a member, you’re missing out!

[![](https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg)](https://ericelliottjs.com/product/lifetime-access-pass/)

---

***Eric Elliott**** is the author of *[*“Programming JavaScript Applications”*](http://pjabook.com)* (O’Reilly), and *[*“Learn JavaScript with Eric Elliott”*](http://ericelliottjs.com/product/lifetime-access-pass/)*. He has contributed to software experiences for ****Adobe Systems****, ****Zumba Fitness****, ****The Wall Street Journal****, ****ESPN****, ****BBC****, and top recording artists including ****Usher****, ****Frank Ocean****, ****Metallica****, and many more.*

*He spends most of his time in the San Francisco Bay Area with the most beautiful woman in the world.*

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
