>* 原文链接 : [Better JavaScript with ES6, Pt. II: A Deep Dive into Classes](https://scotch.io/tutorials/better-javascript-with-es6-pt-ii-a-deep-dive-into-classes)
* 原文作者 : [Peleke](https://github.com/Peleke)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

## Out with the Old, In with the `new`

Let's be clear about one thing from the start:

> Under the hood, ES6 classes are not something that is radically new: They mainly provide more convenient syntax to create old-school constructor functions. ~ Axel Rauschmayer

Functionally, `class` is little more than syntactic sugar over the prototype-based behavior delegation capabilities we've had all along. This article will take a close look at the basic use of ES2015's `class` keyword, from the perspective of its relation to prototypes. We'll cover:

*   Defining and instantiating classes;
*   Creating subclasses with `extends`;
*   `super` calls from subclasses; and
*   Examples of important symbol methods.

Along the way, we'll pay special attention to how `class` maps to prototype-based code under the hood.

Let's take it from the top.

## A Step Back: What Classes _Aren't_

JavaScript's "classes" aren't anything like classes in Java, Python, or . . . Really, any other object-oriented language you're likely to have used. Which, by the way, I'll refer to as _class_-oriented languages, as that's more accurate.

In traditional class-oriented languages, you create _classes_, which are templates for _objects_. When you want a new object, you _instantiate_ the class, which tells the language engine to _copy_ the methods and properties of the class into a new entity, called an _instance_. The _instance_ is your object, and, after instantiation, has absolutely no active relation with the parent class.

JavaScript does _not_ have such copy mechanics. "Instantiating" a `class` in JavaScript _does_ create a new object, but _not_ one that is independent of its parent class.

Rather, it creates an object that is linked to a _prototype_. Changes to that prototype propagate to the new object, _even after_ instantiation.

Prototypes are an immensely powerful design pattern in their own right. There are a number of techniques for using them to emulate something like traditional class mechanics, and it's these techniques that `class` provides compact syntax for.

To summarize:

1.  JavaScript _does not_ have classes, the way that Java and other languages have classes; and
2.  JavaScript's `class` is (mostly) just syntactical sugar for prototypes, which are _very_ different from traditional classes.

With that out of the way, let's get our feet wet with `class`.

## Base Classes: Declarations & Expressions

You create classes with the `class` keyword, followed by an identifier, and finally, a code block, called the _class body_. These are called **class declarations**. Class declarations that don't use the `extends` keyword are called _base classes_:

    "use strict";

    // Food is a base class
    class Food {

        constructor (name, protein, carbs, fat) {
            this.name = name;
            this.protein = protein;
            this.carbs = carbs;
            this.fat = fat;
        }

        toString () {
            return `${this.name} | ${this.protein}g P :: ${this.carbs}g C :: ${this.fat}g F`
        }

        print () {
          console.log( this.toString() );
        }
    }

    const chicken_breast = new Food('Chicken Breast', 26, 0, 3.5);

    chicken_breast.print(); // 'Chicken Breast | 26g P :: 0g C :: 3.5g F'
    console.log(chicken_breast.protein); // 26 (LINE A)

A few things to note.

*   Classes can _only_ contain method definitions, **not** data properties;
*   When defining methods, you use [shorthand method definitions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Method_definitions);
*   Unlike when creating objects, you do _not_ separate method definitions in class bodies with commas; and
*   You _can_ refer to properties on instances of the class directly (Line A).

A distinctive feature of classes is the function called **constructor**. This is where you initialize your object's properties.

You don't _have_ to define a constructor function. If you choose not to, the engine will insert an empty one for you:

    "use strict";

    class NoConstructor { 
        /* JavaScript inserts something like this:
         constructor () { }
        */
    }

    const nemo = new NoConstructor(); // Works, but pretty boring

Assigning a class to a variable is called a **class expression**, and is an alternative to the above syntax:

    "use strict";

    // This is an anonymous class expression -- you can't refer to the it by name within the class body.
    const Food = class {
        // Class definition is the same as before. . . 
    }

    // This is a named class expression -- you /can/ refer to this class by name within the class body . . . 
    const Food = class FoodClass {
        // Class definition is the same as before . . . 

        //  Adding new method, to demonstrate we can refer to FoodClass by name
        //   within the class . . . 
        printMacronutrients () {
          console.log(`${FoodClass.name} | ${FoodClass.protein} g P :: ${FoodClass.carbs} g C :: ${FoodClass.fat} g F`)
        }
    }

    const chicken_breast = new Food('Chicken Breast', 26, 0, 3.5);
    chicken_breast.printMacronutrients(); // 'Chicken Breast | 26g P :: 0g C :: 3.5g F'

    // . . . But /not/ outside of it
    try {
        console.log(FoodClass.protein); // ReferenceError 
    } catch (err) { 
        // pass
    }

This behavior is analogous to that of [anonymous and named function expressions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/function).

## Creating Subclasses with `extends` & Calling with `super`

Classes created with `extends` are called **subclasses**, or **derived classes**. Using them is straightforward. Building on our Food example:

    "use strict";

    // FatFreeFood is a derived class
    class FatFreeFood extends Food {

        constructor (name, protein, carbs) {
            super(name, protein, carbs, 0);
        }

        print () {
            super.print(); 
            console.log(`Would you look at that -- ${this.name} has no fat!`);
        }

    }

    const fat_free_yogurt = new FatFreeFood('Greek Yogurt', 16, 12);
    fat_free_yogurt.print(); // 'Greek Yogurt | 26g P :: 16g C :: 0g F  /  Would you look at that -- Greek Yogurt has no fat!'

Everything we discussed above regarding base classe holds true for derived classes, but with a few additional points.

*   Subclasses are declared with the `class` keyword, followed by an identifier, and then the `extends` keyword, followed by an _arbitrary expression_. This will generally just be an identifier, [but could, in theory, be a function](https://gist.github.com/sebmarkbage/fac0830dbb13ccbff596).
*   If your derived class needs to refer to the class it extends, it can do so with the `super` keyword.
*   A derived class can't contain an empty constructor. Even if all the constructor does is call `super()`, you'll still have to do so explicitly. It can, however, contain _no_ constructor.
*   You _must_ call `super` in the constructor of a derived class before you use `this`.

In JavaScript, there are precisely two use cases for the `super` keyword.

1.  **Within subclass constructor calls**. If initializing your derived class requires you to use the parent class's constructor, you can call `super(parentConstructorParams[ )` within the subclass constructor, passing along any necessary parameters.
2.  **To refer to methods in the superclass**. Within normal method definitions, derived classes can refer to methods on the parent class with dot notation: `super.methodName`.

Our `FatFreeFood` demonstrates both use cases:

1.  In the constructor, we simply call `super`, passing along `0` as our quantity of fat.
2.  In our `print` method, we first call `super.print`, and add additional logic after.

Believe it or not, that wraps up the basic syntactical overview of `class`; this is all you need to start experimenting.

## Prototypes: A Deep Dive

It's time we turn our attention to how `class` maps to JavaScript's underlying prototype mechanisms. We'll look at:

*   Creating objects with constructor calls;
*   The nature of prototype linkages;
*   Property & method delegation; and
*   Emulating classes with prototypes

### Creating Objects with Constructor Calls

Constructors are nothing new. Calling _any_ function with the `new` keyword causes it to return an object -- this is called making a _constructor call_, and such functions are generally called _constructors_:

    "use strict";

    function Food (name, protein, carbs, fat) {
        this.name    = name;
        this.protein = protein;
        this.carbs    = carbs;
        this.fat          = fat;
    }

    // Calling Food with 'new' is a "constructor call", and results in its returning an object 
    const chicken_breast = new Food('Chicken Breast', 26, 0, 3.5);
    console.log(chicken_breast.protein) // 26

    // Failing to call Food with 'new' results in its returning 'undefined'
    const fish = Food('Halibut', 26, 0, 2);
    console.log(fish); // 'undefined'

When you call a function with `new`, four things happen under the hood:

1.  A new object gets created (let's call it **O**);
2.  **O** gets linked to another object, called its _prototype_;
3.  The function's `this` value is set to refer to **O**;
4.  The function implicitly returns **O**.

It's between steps three and four that the engine executes your function's specific logic.

Knowing this, we can rewrite our `Food` function to work _without_ the `new` keyword:

    "use strict";

    // Eliminating the need for 'new' -- just for demonstration
    function Food (name, protein, carbs, fat) {
           // Step One: Create a new Object
        const obj = { }; 

        // Step Two: Link prototypes -- we'll cover this in greater detail shortly
        Object.setPrototypeOf(obj, Food.prototype);

        // Step Three: Set 'this' to point to our new Object
        //    Since we can't reset `this` inside of a running execution context, 
        //      we simulate Step Three by using 'obj' instead of 'this'
        obj.name    = name;
        obj.protein = protein;
        obj.carbs    = carbs;
        obj.fat         = fat;

        // Step Four: Return the newly created object
        return obj;
    }

    const fish = Food('Halibut', 26, 0, 2);
    console.log(fish.protein); // 26

Three of these four steps are straightforward. Creating an object, assigning properties, and writing a `return` statement are unlikely to give most developers any conceptual trouble: It's the prototype weirdness that trips people up.

### Grokking the Prototype Chain

Under normal circumstances, all objects in JavaScript -- including Functions -- are linked to another object, called its _prototype_.

If you request a property on an object that the object doesn't have, JavaScript checks the object's prototype for that property. In other words, if you ask for a property on an object that the object doesn't have, it says: "I don't know. Ask my prototype."

This process -- referring lookups for nonexistent properties to another object -- is called _delegation_.

    "use strict";

    // joe has no toString property . . . 
    const joe    = { name : 'Joe' },
           sara  = { name : 'Sara' };

    Object.hasOwnProperty(joe, toString); // false
    Object.hasOwnProperty(sara, toString); // false

    // . . . But we can call it anyway!
    joe.toString(); // '[object Object]', instead of ReferenceError!
    sara.toString(); // '[object Object]', instead of ReferenceError!

The output from our `toString` calls is utterly useless, but note that this snippet doesn't raise a single `ReferenceError`! That's because, while neither `joe` or `sara` has a `toString` property, _their prototype does_.

When we look for `sara.toString()`, `sara` says, "I don't have a `toString` property. Ask my prototype." JavaScript, obligingly, does as told, and asks `Object.prototype` if _it_ has a `toString` property. Since it does, it hands `Object.prototype`'s `toString` back to our program, which executes it.

It doesn't matter that `sara` didn't have the property herself -- _we just delegated the lookup to the prototype_.

In other words, we can access non-existent properties on an object _as long as that object's prototype **does** have those properties_. We can take advantage of this by assigning properties and methods to an object's prototype, so that we can use them as if they existed on the object itself.

Even better, if several objects share the same prototype -- as is the case with `joe` and `sara` above -- they can _all_ access that prototype's properties, immediately after we assign them, _without_ our having to copy those properties or methods to each individual object.

This is what people generally refer to as _prototypical/prototypal inheritance_ -- if my object doesn't have it, but my object's prototype does, my object _inherits_ the property.

In reality, there's no "inheritance" going on, here. In class-oriented languages, inheritance implies behavior is _copied_ from a parent to a child. In JavaScript, no such copying takes place -- which is, in fact, one of the major benefits of prototypes over classes.

Here's a quick recap before we see precisely where these prototypes come from:

*   `joe` and `sara` do _not_ "inherit" a `toString` property;
*   `joe` and `sara`, as a matter of fact, do _not_ "inherit" from `Object.prototype` _at all_;
*   `joe` and `sara` _are_ **linked** to `Object.prototype`;
*   Both `joe` and `sara` are linked to the _same_ `Object.prototype`.
*   To find the prototype of an object -- let's call it **O** -- you use: `Object.getPrototypeOf(O)`.

And, just to hammer it home: Objects do not "inherit from" their prototypes. They _delegate_ to them.

Period.

Let's dig deeper.

## Setting an Object's Prototype

We learned above that (almost) every object (**O**) has a _prototype_ (**P**), and that, when you look for a property on **O** that **O** doesn't have, the JavaScript engine will look for that property on **P** instead.

From here, the questions are:

1.  How do _functions_ play into all of this?
2.  Where do these prototypes come from, anyway?

### A Function Named Object

Before the JavaScript engine executes a program, it builds an environment to run it in, in which it creates a function, called [Object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object), and an associated object, called [Object.prototype](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/prototype).

In other words, `Object` and `Object.prototype` _always_ exist, in _any_ executing JavaScript program.

The _function_, `Object`, is like any other function. In particular, it's a _constructor_ -- calling it returns a new object:

    "use strict";

    typeof new Object(); // "object"
    typeof Object();         // A peculiarity of the Object function is that it does /not/ need to be called with new.

The _object_, `Object.prototype`, is . . . Well, an object. And, like many objects, it has properties.

![Properties on Object.prototype](https://i.imgsafe.org/ebbd5e3.png)

Here's what you need to know about `Object` and `Object.prototype`:

1.  The _function_, `Object`, has a property, called `.prototype`, which points to an object (`Object.prototype`);
2.  The _object_, `Object.prototype`, has a property, called `.constructor`, which points to a function (`Object`).

As it turns out, this general scheme is true for _all_ functions in JavaScript. When you create a function -- `someFunction` -- it will have a property, `.prototype`, that points to an object, called `someFunction.prototype`.

Conversely, that object -- `someFunction.prototype` -- will have a property, called `.constructor`, which points _back_ to the function `someFunction`.

    "use strict";

    function foo () {  console.log('Foo!');  }

    console.log(foo.prototype); // Points to an object called 'foo'
    console.log(foo.prototype.constructor); // Points to the function, 'foo'

    foo.prototype.constructor(); // Prints 'Foo!' -- just proving that 'foo.prototype.constructor' does, in fact, point to our original function 

The major points to keep in mind are these:

1.  All functions have a property, called `.prototype`, which points to an object associated with that function.
2.  All function prototypes have a property, called `.constructor`, which points back to the function.
3.  A function prototype's `.constructor` does not necessarily point to the function that created the function prototype . . . Confusingly enough. We'll touch on this in greater detail soon.

These are the rules for setting a _function's_ prototype. With that out of the way, we can cover three rules for setting an object's prototype:

1.  The "default" rule;
2.  Setting the prototype implicitly, with `new`;
3.  Setting the prototype explicitly, with `Object.create`.

### The Default Rule

Consider this snippet:

    "use strict";

    const foo = { status : 'foobar' };

Refreshingly simple. All we've done is create an object, called `foo`, and give it a property, called `status`.

Behind the scenes, however, JavaScript does a little extra work. When we create an object literal, JavaScript sets the object's prototype reference to `Object.prototype`, and sets its `.constructor` reference to `Object`:

    "use strict";

    const foo = { status : 'foobar' };

    Object.getPrototypeOf(foo) === Object.prototype; // true
    foo.constructor === Object; // true

### Setting the Prototype Implicitly with `new`

Let's take another look at our modified `Food` example.

    "use strict";

    function Food (name, protein, carbs, fat) {
        this.name    = name;
        this.protein = protein;
        this.carbs    = carbs;
        this.fat          = fat;
    }

By now, we know that the _function_ `Food` will be associated with an _object_, called `Food.prototype`.

When we create an object using the `new` keyword, JavaScript:

1.  Sets the object's prototype reference to the `.prototype` property of the function you called with `new`; and
2.  Sets the object's `.constructor` reference to the function you called `new` with.

    const tootsie_roll = new Food('Tootsie Roll', 0, 26, 0);

    Object.getPrototypeOf(tootsie_roll) === Food.prototype; // true
    tootsie_roll.constructor === Food; // true

This is what lets us do slick stuff like this:

    "use strict";

    Food.prototype.cook = function cook () {
        console.log(`${this.name} is cooking!`);
    };

    const dinner = new Food('Lamb Chops', 52, 8, 32);
    dinner.cook(); // 'Lamb Chops are cooking!'

### Setting the Prototype Explicitly with `Object.create`

Finally, we can set an object's prototype reference _manually_, using a utility called `Object.create`.

    "use strict";

    const foo = {
        speak () {
        console.log('Foo!');
        }
    };

    const bar = Object.create(foo);

    bar.speak(); // 'Foo!'
    Object.getPrototypeOf(bar) === foo; // true

Remember the four things that JavaScript does under the hood when you call a function with `new`? `Object.create` does all but the third step:

1.  Create a new object;
2.  Set its prototype reference; and
3.  Return the new object.

[You can see this yourself if you take a look at the polyfill](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/create).

### Emulating `class` Behavior

Using prototypes directly, emulating class-oriented behavior required a bit of manual acrobatics.

    "use strict";

    function Food (name, protein, carbs, fat) {
        this.name    = name;
        this.protein = protein;
        this.carbs    = carbs;
        this.fat          = fat;
    }

    Food.prototype.toString = function () {
        return `${this.name} | ${this.protein}g P :: ${this.carbs}g C :: ${this.fat}g F`;
    };

    function FatFreeFood (name, protein, carbs) {
        Food.call(this, name, protein, carbs, 0);
    }

    // Setting up "subclass" relationships
    // =====================
    // LINE A :: Using Object.create to manually set FatFreeFood's "parent".
    FatFreeFood.prototype = Object.create(Food.prototype);

    // LINE B :: Manually (re)setting constructor reference (!)
    Object.defineProperty(FatFreeFood.constructor, "constructor", {
        enumerable : false,
        writeable      : true,
        value             : FatFreeFood
    });

At Line A, we have to set `FatFreeFood.prototype` equal to a new object, whose prototype reference is to `Food.prototype`. If we fail to do this, our "child classes" won't have access to "superclass" methods.

Unfortunately, this results in the rather bizarre behavior that `FatFreeFood.constructor` is [Function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function) . . . Not `FatFreeFood`. So, to keep everything sane, we have to manually set `FatFreeFood.constructor` by hand at Line B.

Sparing developers from the noise and unwieldliness of emulating class behavior with prototypes is one of the motives for the `class` keyword. It _does_ provide a solution to the most common gotchas of prototype syntax.

Now that we've seen so much of JavaScript's prototype mechanics, it should be easier to appreciate just _how_ much easier it can make things!

## A Closer Look at Methods

Now that we've seen the essentials of JavaScript's prototype system, we'll wrap up by taking a closer look at three kinds of methods classes support, and a special case of the last sort:

*   Constructors;
*   Static methods;
*   Prototype methods; and
*   "Symbol methods", a special case of _prototype methods_

I didn't come up with these groups -- credit goes to Dr Rauschmayer for identifying them in [Exploring ES6](http://exploringjs.com/es6/ch_classes.html).

### Class Constructors

A class's `constructor` function is where you'll focus your initialization logic. The `constructor` is special in a few ways:

1.  It's the only method of a class from which you can make a superconstructor call;
2.  It handles all the dirty work of setting up the prototype chain properly; and
3.  It acts as the definition of the class.

Point 2 is one of the principle benefits to using `class` in JavaScript. To quote heading 15.2.3.1 of Exploring ES6:

> **The prototype of a subclass is the superclass.**

As we've seen, setting this up manually is tedious and error-prone. That the language takes care of it all behind the scenes if we use `class` is a major boon.

Point 3 is interesting. In JavaScript, a class is just a function -- it's equivalent to the `constructor` method in the class.

    "use strict";

    class Food {
        // Class definition is the same as before . . . 
    }

    typeof Food; // 'function'

Unlike normal-functions-as-constructors, you can't call a class's constructor without the `new` keyword:

`const burrito = Food('Heaven', 100, 100, 25); // TypeError`

. . . Which raises another question: What happens when we call a function-as-constructor _without_ new?

The short answer: It returns `undefined`, as does any function without an explicit return. You just have to trust your users will constructor-call your function. This is why the community has adopted the convention of only capitalizing constructor names: It's a reminder to call with `new`.

    "use strict";

    function Food (name, protein, carbs, fat) {
        this.name    = name;
        this.protein = protein;
        this.carbs    = carbs;
        this.fat          = fat;
    }

    const fish = Food('Halibut', 26, 0, 2); // D'oh . . .
    console.log(fish); // 'undefined'

The long answer: It returns `undefined`, _unless_ you manually detect that it wasn't called with `new`, and then do something about it yourself.

ES2015 introdues a property that makes this check trivial: `[new.target]`([https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new.target](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new.target)).

`new.target` is a property defined on all functions called with `new`, including class constructors. When you call a function with the `new` keyword, the value of `new.target` within the function body is the function itself. If the function wasn't called with `new`, its value is `undefined`.

    "use strict";

    // Enforcing constructor call
    function Food (name, protein, carbs, fat) {
        // Manually call 'new' if user forgets
        if (!new.target)
            return new Food(name, protein, carbs, fat); 

        this.name    = name;
        this.protein = protein;
        this.carbs    = carbs;
        this.fat          = fat;
    }

    const fish = Food('Halibut', 26, 0, 2); // Oops -- but, no problem!
    fish; // 'Food {name: "Halibut", protein: 20, carbs: 5, fat: 0}'

This wasn't any worse in ES5:

    "use strict";

    function Food (name, protein, carbs, fat) {

        if (!(this instanceof Food))
            return new Food(name, protein, carbs, fat); 

        this.name    = name;
        this.protein = protein;
        this.carbs    = carbs;
        this.fat          = fat;
    }

The [MDN documentation](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new.target) has more details on `new.target`, and the [spec is the definitive reference](https://tc39.github.io/ecma262/#sec-built-in-function-objects) for the truly curious. The descriptions of [[Construct]] are particularly illuminating.

### Static Methods

_Static methods_ are methods on the constructor function itself, which are _not_ available on instances of the class. You define them by using the `static` keyword.

    "use strict";

    class Food {
         // Class definition is the same as before . . . 

         // Adding a static method
         static describe () {
           console.log('"Food" is a data type for storing macronutrient information.');
          }
    }

    Food.describe(); // '"Food" is a data type for storing macronutrient information.'

Static methods are analogous to attaching properties directly to old-school functions-as-constructors:

    "use strict";

    function Food (name, protein, carbs, fat) {
        Food.count += 1;

        this.name    = name;
        this.protein = protein;
        this.carbs    = carbs;
        this.fat          = fat;
    }

    Food.count = 0;
    Food.describe = function count () {
           console.log(`You've created ${Food.count} food(s).`);
    };

    const dummy = new Food();
    Food.describe(); // "You've created 1 food."

### Prototype Methods

Any method that isn't a constructor or a static method is _prototype method_. The name comes from the fact that we used to achieve this functionality by attaching functions to the `.prototype` of functions-as-constructors:

    "use strict";

    // Using ES6:
    class Food {

        constructor (name, protein, carbs, fat) {
            this.name = name;
            this.protein = protein;
            this.carbs = carbs;
            this.fat = fat;
        }

        toString () {  
        return `${this.name} | ${this.protein}g P :: ${this.carbs}g C :: ${this.fat}g F`; 
        }

        print () {  
        console.log( this.toString() );  
        }
    }

    // In ES5:
    function Food  (name, protein, carbs, fat) {
        this.name = name;
        this.protein = protein;
        this.carbs = carbs;
        this.fat = fat;
    }

    // The name "prototype methods" presumably comes from the fact that we 
    //    used to attach such methods to the '.prototype' old-school functions-as-constructors.
    Food.prototype.toString = function toString () {
        return `${this.name} | ${this.protein}g P :: ${this.carbs}g C :: ${this.fat}g F`; 
    };

    Food.prototype.print = function print () {
        console.log( this.toString() ); 
    };

To be clear, it's perfectly fine to use generators in method definitions, as well:

    "use strict";

    class Range {

      constructor(from, to) {
        this.from = from;
        this.to   = to;
      }

      * generate () {
        let counter = this.from,
            to      = this.to;

        while (counter < to) {
          if (counter == to)
            return counter++;
          else
            yield counter++;
        }
      }
    }

    const range = new Range(0, 3);
    const gen = range.generate();
    for (let val of range.generate()) {
      console.log(`Generator value is: ${ val }. `);
      //  Prints:
      //    Generator value is: 0.
      //    Generator value is: 1.
      //    Generator value is: 2.
    }

### Symbol Methods

Finally, there are the _symbol methods_. These are functions whose names are `Symbol` values, and which the JavaScript engine recognizes and uses when you use certain built-in constructs with your custom objects.

The [MDN docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol) provide a succinct overview of what Symbols are in general:

> A symbol is a unique and immutable data type and may be used as an identifier for object properties.

Creating a new symbol provides you with a value that is guaranteed to be unique within your program. This is what makes it useful for naming object properties: You're guaranteed never to accidentally shadow anything. Symbol-valued keys also aren't innumerable, so they're largely invisible to the outside world ([but not completely](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/ownKeys)).

    "use strict";

    const secureObject = {
        // This key is guaranteed to be unique.
        [new Symbol("name")] : 'Dr. Secure A. F.'
    };

    console.log( Object.getKeys(superSecureObject) ); // [] -- The symbol property is pretty hard to get at . . .  
    console.log( Reflect.ownKeys(secureObject) ); // [Symbol("name")] -- . . . But, not /truly/ hidden.

More interestingly for us, they give us a way to tell the JavaScript engine to use certain functions for special purposes.

The so-called [Well-known Symbols](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol) are special object keys that identify functions the JavaScript engine invokes when you use certain built-in constructs with custom objects.

This is a bit exotic for JavaScript, so let's see an example:

    "use strict";

    // Extending Array lets us use 'length' in an intuitive way,
    //   and also gives us access to built-in array methods, like 
    //   map, filter, reduce, push, pop, etc.
    class FoodSet extends Array {

        // ...foods collects arbitrary number of arguments into an array
        //   https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_operator
        constructor(...foods) {
            super();
            this.foods = [];
            foods.forEach((food) => this.foods.push(food))
        }

         // Custom iterator behavior. This isn't very *useful* iterator behavior, mind you, but it's a fine example.
         // The asterisk *must* precede the name of the key.
         * [Symbol.iterator] () {
            let position = 0;
            while (position < this.foods.length) {
              if (position === this.foods.length) {
                  return "Done!"
              } else {
                  yield `${this.foods[ position++ ]} is the food item at position ${position}`;
              }
             }
         }

          // Return an object of type Array, rather than type FoodSet, when users
          //   use built-in array methods. This makes our FoodSet interoperable
          //   with code expecting an array.
          static get [Symbol.species] () {
              return Array;
          }
    }

    const foodset = new FoodSet(new Food('Fish', 26, 0, 16), new Food('Hamburger', 26, 48, 24));

    // When you use for . . . of with a FoodSet, JavaScript will iterate using the function you 
    //    assoiated with the key [Symbol.iterator].
    for (let food of foodset) {
      // Prints all of our foods
      console.log( food );
    }

    // JavaScript creates and returns a new object when you `filter` on an array, 
    //    which it creates using the default constructor of the object you execute `filter` on.
    //
    //    Since most code would expect filter to return an Array, we can tell JavaScript
    //       to use the Array constructor when implicitly creating a new instance by 
    //       overriding [Symbol.species].
    const healthy_foods = foodset.filter((food) => food.name !== 'Hamburger');

    console.log( healthy_foods instanceof FoodSet ); // 
    console.log( healthy_foods instanceof Array );

When you use a `for...of` loop on an object, JavaScript will try to execute the object's _iterator_ function, which is the function associated with the key, `Symbol.iterator`. If you provide your own definition, JavaScript will use that. If you don't, it'll use the default implementation, if there is one; or do nothing, if there isn't.

`Symbol.species` is a bit more exotic. In a custom class, the default `Symbol.species` function is the constructor for your class. When you subclass built-in collections, like `Array` or `Set`, however, you'll often want to be able to use your subclass wherever you could use an instance of the parent class.

Returning instances of the parent class from methods on the class _instead_ of instances of the derived class gets us closer to ensuring full interoperability of a subclass with more general code. This is `Symbol.species` allows.

Don't sweat it if this bit doesn't make much sense. Using symbols this way -- or at all -- is still a niche case, and the point of these examples is to demonstrate:

1.  That you _can_ use certain built-in JavaScript constructs with custom classes; and
2.  _How_ you achieve that, in two common cases.

## Conclusion

ES2015's `class` keyword does _not_ bring us "true classes", a là Java or SmallTalk. Rather, it simply provides a more convenient syntax for creating objects related via prototype linkage. Under the hood, there's nothing new here.

I covered enough of JavaScript's prototype mechanism for our discussion, but there's quite a bit more to say. Read Kyle Simpson's [this & Object Prototypes](https://github.com/getify/You-Dont-Know-JS/tree/master/this%20%26%20object%20prototypes) for fuller coverage on that front. [Appendix A](https://github.com/getify/You-Dont-Know-JS/blob/master/this%20&%20object%20prototypes/apA.md) is particularly relevant.

For the nitty-gritty on ES2015 classes, Dr Rauschmayer's [Exploring ES6: Classes](http://exploringjs.com/es6/ch_classes.html) should be your go-to resource. It was the inspiration for much of what I've written here.

Finally, if you've got questions, drop a line in the comments, or [hit me on Twitter](https://twitter.com/PelekeS). I'll do my best to get back to everyone directly.

What do you think about `class`? Love it, hate it, no strong feelings? It seems like everyone's got an opinion -- let us know yours below!

