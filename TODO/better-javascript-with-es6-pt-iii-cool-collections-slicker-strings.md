>* 原文链接 : [Better JavaScript with ES6, Pt. III: Cool Collections & Slicker Strings](https://scotch.io/tutorials/better-javascript-with-es6-pt-iii-cool-collections-slicker-strings)
* 原文作者 : [Peleke](https://github.com/Peleke)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


## Introduction

ES2015 brings some heavy-hitting changes to the language, such as [promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) and [generators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Iterators_and_Generators). But not _everything_ about the new standard is a landmark addition -- quite a few features are convenience methods that are quick to learn and fun to use.

In this article, we'll take a look at a smattering of such goodies:

*   New collections: `map`, `weakmap`, `set`, and `weakset`
*   Most of the [new `String` methods](https://developer.mozilla.org/en-US/docs/Web/JavaScript/New_in_JavaScript/ECMAScript_6_support_in_Mozilla#Additions_to_the_String_object); and
*   Template literals.

Let's start with the last of them; bottoms up.

_Note: This is part 3 of the Better JavaScript series. You can see parts 1 and 2 here:_

*   [Better JavaScript with ES6, Part 1: Popular Features](https://scotch.io/tutorials/better-node-with-es6-pt-i)
*   [Better JavaScript with ES6, Part 2: A Deep Dive into Classes](https://scotch.io/tutorials/better-javascript-with-es6-pt-ii-a-deep-dive-into-classes)

## Template Literals

**Template literals** scratch three itches, allowing you to:

1.  Evaluate JavaScript expressions _inside_ of strings, called _string interpolation_.
2.  Write multi-line strings, without having to concatenate strings or insert newline characters (`\n`).
3.  Use "raw" strings -- strings in which backslash escapes are ignored, and interpreted literally.

    "use strict";

    /* There are three major use cases for tempate literals: 
      * String interpolation, multi-line strings, and raw strings.
      * ================================= */

    // ==================================
    // 1\. STRING INTERPOLATION :: Evaluate an expression -- /any/ expression -- inside of a string.
    console.log(`1 + 1 = ${1 + 1}`);

    // ==================================
    // 2\. MULTI-LINE STRINGS :: Write this:
    let childe_roland = 
    `I saw them and I knew them all. And yet
    Dauntless the slug-horn to my lips I set,
    And blew “Childe Roland to the Dark Tower came.”`

    // . . . Instead of this:
    child_roland = 
    'I saw them and I knew them all. And yet\n' +
    'Dauntless the slug-horn to my lips I set,\n' +
    'And blew “Childe Roland to the Dark Tower came.”';

    // ==================================
    // 3\. RAW STRINGS :: Prefixing with String.raw cause JavaScript to ignore backslash escapes.
    // It'll still evaluate expressions wrapped in ${}, though.
    const unescaped = String.raw`This ${string()} doesn't contain a newline!\n`

    function string () { return "string"; }

    console.log(unescaped); // 'This string doesn't contain a newline!\n' -- Note that \n is printed literally

    // You can use template strings to create HTML templates similarly to the way
    //   React uses JSX (Angular 2 uses them this way).
    const template = 
    `
    <div class="${getClass()}">
      <h1>Example</h1>
        <p>I'm a pure JS & HTML template!</p>
    </div>
    `

    function getClass () {
        // Check application state, calculate a class based on that state
        return "some-stateful-class";
    }

    console.log(template); // A bit bulky to copy the output here, so try it yourself!

    // Another common use case is printing variable names:
    const user = { name : 'Joe' };

    console.log("User's name is " + user.name + "."); // A little cumbersome . . . 
    console.log(`User's name is ${user.name}.`); // . . . A bit nicer.

1.  To use string interpolation, wrap your string with backticks instead of quotes, and wrap the expression whose result you want embedded in `${}`.
2.  For multi-line strings, simply wrap your string in backticks, and break lines wherever you wish. JavaScript will insert a newline at the break.
3.  To use raw strings, prefixe the template literal, still wrapped in backticks, with `String.raw`.

Template literals may be little more than sugar . . . But they're the sweetest.

## New String Methods

ES2015 adds some additional methods to `String`, as well. These fall into two classes:

1.  General-use convenience methods; and
2.  Methods for better unicode support.

We'll only cover the first class in this article, as the unicode-specific methods have fairly niche use cases. [The MDN docs have a a full list of the new String methods](https://developer.mozilla.org/en-US/docs/Web/JavaScript/New_in_JavaScript/ECMAScript_6_support_in_Mozilla#Additions_to_the_String_object), if you're curious.

## startsWith & endsWith

For starters, we now have [String.prototype.startsWith](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/startsWith). It's available on any string, and takes two arguments:

1.  A _search string_; and
2.  An integer position, _n_. This is optional.

`String.prototype.startsWith` will check if the string you call it on starts with the _search string_, starting at the _nth_ character of the string. If you don't pass a position, it starts from the beginning.

It returns `true` if your string starts with the search string, and `false` otherwise.

    "use strict";

    const contrived_example = "This is one impressively contrived example!";

    // does this string start with "This is one"?
    console.log(contrived_example.startsWith("This is one")); // true

    // does this start with "is" at character 4?
    console.log(contrived_example.startsWith("is", 4)); // false

    // does this start with "is" at character 5?
    console.log(contrived_example.startsWith("is", 5)); // true

## endsWith

[String.prototype.endsWith](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/endsWith) is similar: It takes a search string and a position, as well.

With `String.prototype.endsWith`, however, the position tells the function which character in the original string to treat as "last".

In other words, it'll chop off every character in your string after the _nth_, and check if _that_ ends with the search string you passed.

    "use strict";

    const contrived_example = "This is one impressively contrived example!";

    console.log(contrived_example.endsWith("contrived example!")); // true

    console.log(contrived_example.slice(0, 11)); // "This is one"
    console.log(contrived_example.endsWith("one", 11)); // true

    // In general, passing a position is like doing this:
    function substringEndsWith (string, search_string, position) {
        // Chop off the end of the string
        const substring = string.slice(0, position);

        // Check if the shortened string ends with the search string
        return substring.endsWith(search_string);
    }

## includes

ES2015 also adds [String.prototype.includes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/includes). You call it on a string, and pass it a search term. It returns `true` if the string contains the search term, and `false` otherwise.

    "use strict";

    const contrived_example = "This is one impressively contrived example!";

    // does this string include the word impressively?
    contrived_example.includes("impressively"); // true

Back in the days of cavemen, we had to do this:

    "use strict";
    contrived_example.indexOf("impressively") !== -1 // true

Not much worse. But, `String.prototype.includes` _is_ an improvement, in that it shields use from the leaky abstraction of equation truth to an arbitrary integer return value.

## repeat

We've also got [String.prototype.repeat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/repeat). You can call this one on any string, and, like `includes`, it more or less does what its name implies.

It takes a single argument: An integer _count_. An example is clearer than an explanation, so here you go:

    const na = "na";

    console.log(na.repeat(5) + ", Batman!"); // 'nanananana, Batman!'

## raw

Finally, we have [String.raw](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/raw), which we met briefly above.

If you prefix a template literal with `String.raw`, it won't evaluate escape sequences within the string:

    /* Since the backslash alone means "escape", we need to double it to print
      *   one. Similarly, \n in a normal string is interpreted as "newline". 
      *   */
    console.log('This string \\ has fewer \\ backslashes \\ and \n breaks the line.');

    // Not so, with String.raw!
    String.raw`This string \\ has too many \\ backslashes \\ and \n doesn't break the line.`

## Unicode Methods

While we won't cover the rest of the new string methods, I'd be remiss if I didn't point you to a few must-reads on the topic.

*   Dr Rauschmayer's introduction to [Unicode in JavaScript](http://speakingjs.com/es5/ch24.html);
*   His discussion of [ES2015's Unicode Support in Exploring ES6](http://exploringjs.com/es6/ch_unicode.html#sec_escape-sequences); and
*   [The Absolute Minimum Every Software Developer Needs to Know About Unicode](http://www.joelonsoftware.com/articles/Unicode.html).

I just had to slip that last one in there somehow. Oldie but goodie.

Here are the docs for the missing string methods, just so you know what they are.

*   [String.fromCodePoint](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/fromCodePoint) & [String.prototype.codePointAt](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/codePointAt);
*   [String.prototype.normalize](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/normalize); and
*   [Unicode point escapes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Lexical_grammar#Unicode_code_point_escapes).

## Collections

ES2015 brings us four new collection types:

1.  [Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) and [WeakMap](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakMap)
2.  [Set](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set), and [WeakSet](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakSet).

Proper Map and Set types are fantastically convenient, and weak variants, while somewhat exotic to the JavaScript landscape, are exciting additions to the language.

## Map

A _map_ is simply a key-value pair. The easiest way to think of this is by analogy with objects, whose property names are analogous to _keys_ associated with a _value_.

    "use strict";

    // We can think of foo as a key, and bar as a value.
    const obj = { foo : 'bar' };

    // The foo 'key' of obj has value 'bar'
    obj.foo === 'bar'; // true

The new Map type is conceptually similar, but lets you use arbitrary datatypes for keys -- not just strings and symbols -- and eliminates some of the _many_ [pitfalls associated with trying to use an object as a map](http://www.2ality.com/2012/01/objects-as-maps.html).

The following snippet demonstrates the Map API.

    "use strict";

    // Constructor  
    let scotch_inventory = new Map();

    // BASIC API METHODS
    // Map.prototype.set (K, V) :: Create a key, K, and set its value to V.
    scotch_inventory.set('Lagavulin 18', 2);
    scotch_inventory.set('The Dalmore', 1);

    // You can also create a map from an array of 2-element arrays.
    scotch_inventory = new Map([['Lagavulin 18', 2], ['The Dalmore', 1]]);

    // All maps have a size property. This tells you how many key-value pairs are stored within.
    //   BE SURE TO USE 'size', NOT 'length', when you work with Map and Set.
    console.log(scotch_inventory.size); // 2

    // Map.prototype.get(K) :: Return the value associated with the key, K. If the key doesn't exist, return undefined.
    console.log(scotch_inventory.get('The Dalmore')); // 1
    console.log(scotch_inventory.get('Glenfiddich 18')); // undefined

    // Map.prototype.has(K) :: Return true if map contains the key, K. Otherwise, return false.
    console.log(scotch_inventory.has('The Dalmore')); // true
    console.log(scotch_inventory.has('Glenfiddich 18')); // false

    // Map.prototype.delete(K) :: Remove the key, K, from the map. Return true if succesful, or false if K doesn't exist.
    console.log(scotch_inventory.delete('The Dalmore')); // true -- breaks my heart

    // Map.prototype.clear() :: Remove all key-value pairs from the map.
    scotch_inventory.clear();
    console.log( scotch_inventory ); // Map {} -- long night

    // ITERATOR METHODS
    // Maps provide a number of ways to loop through their keys and values. 
    //  Let's reset our inventory, and then explore.
    scotch_inventory.set('Lagavulin 18', 1);
    scotch_inventory.set('Glenfiddich 18', 1);

    /* Map.prototype.forEach(callback[, thisArg]) :: Execute a function, callback, on every key-value pair in the map. 
      *   You can set the value of 'this' inside the callback by passing a thisArg, but that's optional and seldom necessary.
      *   Finally, note that the callback gets passed the VALUE and KEY, in that order. */
    scotch_inventory.forEach(function (quantity, scotch) {
        console.log(`Excuse me while I sip this ${scotch}.`);
    });

    // Map.prototype.keys() :: Returns an iterator over the keys in the map.
    const scotch_names = scotch_inventory.keys();
    for (let name of scotch_names) {
        console.log(`We've got ${name} in the cellar.`);
    }

    // Map.prototype.values() :: Returns an iterator over the values of the map.
    const quantities = scotch_inventory.values();
    for (let quantity of quantities) {
        console.log(`I just drank ${quantity} of . . . Uh . . . I forget`);
    }

    // Map.prototype.entries() :: Returns an iterator over [key, value] pairs, provided as an array with two entries. 
    //   You'll often see [key, value] pairs referred to as "entries" when people talk about maps. 
    const entries = scotch_inventory.entries();
    for (let entry of entries) {
        console.log(`I remember! I drank ${entry[1]} bottle of ${entry[0]}!`);
    }

Maps are sweet. But objects are still useful for this kind of key-value record keeping. If all of the following hold, you might still want an object:

1.  You know your key-value pairs when you write your code;
2.  You know you're probably not going to add or remove key-value pairs;
3.  All of your keys are Strings or Symbols.

On the other hand, if _any_ of the following are true, you probably want a map.

1.  You need to iterate over the entries of the map -- this is surprisingly tricky to do with objects.
2.  You don't necessarily know the number or names of your keys when you write your code.
3.  You need complicated keys, like Objects or other Maps (!).

Iterating over an object you use as a map is possible, but tricky -- there are some nonobvious gotchas lurking in the shadows. Maps are much simpler to work with, and have the added advantage of consistency. Whereas object properties are iterated in random order, **maps iterate over their entries in the order of insertion**.

Similarly, adding arbitrary, dynamically named key-value pairs to an object is _possible_. But, tricky: If you ever need to iterate such a pseudo-map, you'll need to remember to update the number of entries manually, for instance.

Finally, if you need keys that aren't Strings or Symbols, you don't have a choice but to use a Map.

These are just guidelines, but they're good rules of thumb.

## WeakMap

You may have heard of this nifty feature called a [garbage collector](https://en.wikipedia.org/wiki/Garbage_collection_(computer_science)), which periodically finds objects your program no longer needs and gets rid of them.

[To quote Dr Rauschmayer](http://www.2ality.com/2015/01/es6-maps-sets.html):

> A WeakMap is a map that doesn't prevent its keys from being garbage-collected. That means that you can associate data with objects without having to worry about memory leaks.

In other words, if your program loses all external references to the _keys_ of a WeakMap, it can garbage-collect their _values_.

For a good, albeit drastically simplified, use case, consider a SPA that displays items on a user's wishlists, with item descriptions and an image, which we consume as JSON returned by an API call.

It would make sense to cache those results to cut down the number of times we have to hit the server. We could use a Map for this:

    "use strict";

    const cache = new Map();

    function put (element, result) {
        cache.set(element, result);
    }

    function retrieve (element) {
        return cache.get(element);
    }

. . . Which works, but potentially leaks memory.

Since this is a SPA, our users may want to navigate away from the wishlist view. That would make our "wishlist item" objects pretty useless, and eligible for garbage collection.

Unfortunately, if you use a normal Map, you'll have to clear it yourself when those objects become unreachable.

Using a WeakMap instead solves the problem for us:

    "use strict";

    const cache = new WeakMap(); // No more memory leak!

    // The rest is the same . . . 

This way, when the application loses all references to the unneeded elements, the garbage collector can recycle them automagically. Nifty.

The API for WeakMap is similar to that of Map, with a few key differences:

1.  You can only use Object keys in a WeakMap. That means no Strings, and no Symbols.
2.  WeakMaps only have `set`, `get`, `has`, and `delete` methods -- that means **you can't iterate over weak maps**.
3.  WeakMaps don't have a `size` property.

The reason you can't iterate a WeakMap, or check its length, is because the garbage collector could run in the middle of your iteration: One moment, it'd be full. The next, empty.

That sort of unpredictable behavior is precisely what the TC39 sought to avoid in forbidding iteration and size-checks on WeakMaps.

For other use cases, check out the section on [Use Cases for WeakMap](http://exploringjs.com/es6/ch_maps-sets.html#_use-cases-for-weakmaps), from Exploring ES6.

## Set

A **Set** is a collection that contains only unique values. In other words, each element of a set can appear only once.

This is a useful data type if you need to keep track of objects that are inherently unique, such as the current users in a chat room.

Set and Map have almost identical APIs. The main difference is that Set doesn't have a `set` method, since it doesn't store key-value pairs. Everything is just about the same.

    "use strict";

    // Constructor  
    let scotch_collection = new Set();

    // BASIC API METHODS
    // Set.prototype.add (O) :: Add an object, O, to the set.
    scotch_collection.add('Lagavulin 18');
    scotch_collection.add('The Dalmore');

    // You can also create a set from an array.
    scotch_collection = new Set(['Lagavulin 18', 'The Dalmore']);

    // All sets have a length property. This tells you how many objects are stored.
    //   BE SURE TO USE 'size', NOT 'length', when you work with Map and Set.
    console.log(scotch_collection.size); // 2

    // Set.prototype.has(O) :: Return true if set contains the object, O. Otherwise, return false.
    console.log(scotch_collection.has('The Dalmore')); // true
    console.log(scotch_collection.has('Glenfiddich 18')); // false

    // Set.prototype.delete(O) :: Remove the object, O, from the set. Return true if successful; false if O isn't in the set.
    scotch_collection.delete('The Dalmore'); // true -- breaks my heart

    // Set.prototype.clear() :: Remove all objects from the set.
    scotch_collection.clear();
    console.log( scotch_collection ); // Set {} -- long night.

    /* ITERATOR METHODS
     * Sets provide a number of ways to loop through their keys and values. 
     *  Let's reset our collection, and then explore. */
    scotch_collection.add('Lagavulin 18');
    scotch_collection.add('Glenfiddich 18');

    /* Set.prototype.forEach(callback[, thisArg]) :: Execute a function, callback,
     *  on every key-value pair in the set. You can set the value of 'this' inside 
     *  the callback by passing a thisArg, but that's optional and seldom necessary. */
    scotch_collection.forEach(function (scotch) {
        console.log(`Excuse me while I sip this ${scotch}.`);
    });

    // Set.prototype.values() :: Returns an iterator over the values of the set.
    let scotch_names = scotch_collection.values();
    for (let name of scotch_names) {
        console.log(`I just drank ${name} . . . I think.`);
    }

    // Set.prototype.keys() :: For sets, this is IDENTICAL to the values function.
    scotch_names = scotch_collection.keys();
    for (let name of scotch_names) {
        console.log(`I just drank ${name} . . . I think.`);
    }

    /* Set.prototype.entries() :: Returns an iterator over [value, value] pairs, 
     *   provided as an array with two entries. This is a bit redundant, but it's
     *   done this way to maintain interoperability with the Map API. */
    const entries = scotch_collection.entries();
    for (let entry of entries) {
        console.log(`I got some ${entry[0]} in my cup and more ${entry[1]} in my flask!`);
    }

## WeakSet

WeakSet is to Set as WeakMap is to Map. Like WeakMap:

1.  References to objects in a WeakSet are weakly-held.
2.  WeakSets do not have a `size` property.
3.  You can't iterate over a WeakSet.

Use cases for weak sets don't abound, but there are a few. [Domenic Denicola](https://mail.mozilla.org/pipermail/es-discuss/2015-June/043027.html) has called them "perfect for branding" -- that is, marking an object as satisfying some or other quality.

Here's the example he gave:

    /* The following example comes from an archived email thread on use cases for WeakSet.
      *    The text of the email, along with the rest of the thread, is available here:
      *      https://mail.mozilla.org/pipermail/es-discuss/2015-June/043027.html
      */

    const foos = new WeakSet();

    class Foo {
      constructor() {
        foos.add(this);
      }

      method() {
        if (!foos.has(this)) {
          throw new TypeError("Foo.prototype.method called on an incompatible object!");
        }
      }
    }

This is a lightweight technique way for preventing people from using `method` on any object that was _not_ created by the `Foo` constructor.

Using a WeakSet has the advantage that it allows objects in `foos` to be garbage-collected when they become unreachable.

## Conclusion

In this article, we've taken a look at some of the sweeter sugar that ES2015 brings, from new convenience methods on `String` and template literals to proper Map and Set implementations.

The `String` methods and template literals are easy to get started with. And, while you may not need to sling around weak sets anytime soon, I think Set and Map will grow on you pretty swiftly.

If you've got any questions, drop a line in the comments below, or hit me on Twitter ([@PelekeS](http://twitter.com/PelekeS)-- I'll get back to everyone individually.

