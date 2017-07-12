
> * 原文地址：[ES8 was Released and here are its Main New Features 🔥](https://hackernoon.com/es8-was-released-and-here-are-its-main-new-features-ee9c394adf66)
> * 原文作者：[Dor Moshe](https://hackernoon.com/@dormoshe)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/es8-was-released-and-here-are-its-main-new-features.md](https://github.com/xitu/gold-miner/blob/master/TODO/es8-was-released-and-here-are-its-main-new-features.md)
> * 译者：
> * 校对者：

# ES8 was Released and here are its Main New Features 🔥

## The new features of the EcmaScript specification 8th edition

![](https://cdn-images-1.medium.com/max/2000/1*g3nPXrupuJ3koTjRNr6daw.png)

EcmaScript 8 or EcmaScript 2017 was officially released in the end of June by TC39. It seems that we are talking a lot about EcmaScript in the last year. It’s not for nothing. Currently the standard is to publish a new ES specification version once a year. ES6 was published in 2015 and ES7 was published in 2016, but did someone remembered when ES5 was released? It was happened in 2009, before the magical rise of JavaScript.

So we follow after the changes in the developing of JavaScript as stable language and now we need to enter ES8 to our lexicon.

![](https://ws2.sinaimg.cn/large/006tKfTcgy1fhh0w51hshj30ji07iaaq.jpg)

If you are a strong people, take a deep breath and read the [web](https://www.ecma-international.org/ecma-262/8.0/index.html) or [PDF](https://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf) edition of the specification. For the others, in this article we will cover the main new features of ES8 by code examples.

---

### String padding

This section adds two functions to the String object: padStart & padEnd.
As their names, the purpose of those functions is to pad the start or the end of the string, **so that the resulting string reaches the given length**. You can pad it with specific character or string or just pad with spaces by default. Here are the functions declaration:

    str.padStart(targetLength [, padString])

    str.padEnd(targetLength [, padString])

As you can see, the first parameter of those functions is the `targetLength`, that is the total length of the resulted string. The second parameter is the optional `padString` that is the string to pad the source string. The default value is space.

    'es8'.padStart(2);          // 'es8'
    'es8'.padStart(5);          // '  es8'
    'es8'.padStart(6, 'woof');  // 'wooes8'
    'es8'.padStart(14, 'wow');  // 'wowwowwowwoes8'
    'es8'.padStart(7, '0');     // '0000es8'

    'es8'.padEnd(2);          // 'es8'
    'es8'.padEnd(5);          // 'es8  '
    'es8'.padEnd(6, 'woof');  // 'es8woo'
    'es8'.padEnd(14, 'wow');  // 'es8wowwowwowwo'
    'es8'.padEnd(7, '6');     // 'es86666'

![](https://cdn-images-1.medium.com/max/800/1*gR7YnK8_2yw2l2YZQiJkSA.png)

Browser support (MDN)

---

### Object.values and Object.entries

The `*Object.values*` method returns an array of a given object’s own enumerable property values, in the same order as that provided by a `*for in*` loop. The declaration of the function is trivial:

    Object.values(obj)

The `*obj*`parameter is the source object for the operation. It can be an object or an array (that is an object with indexes like [10, 20, 30] -> { 0: 10, 1: 20, 2: 30 }).

    const obj = { x: 'xxx', y: 1 };
    Object.values(obj); // ['xxx', 1]

    const obj = ['e', 's', '8']; // same as { 0: 'e', 1: 's', 2: '8' };
    Object.values(obj); // ['e', 's', '8']

    // when we use numeric keys, the values returned in a numerical
    // order according to the keys
    const obj = { 10: 'xxx', 1: 'yyy', 3: 'zzz' };
    Object.values(obj); // ['yyy', 'zzz', 'xxx']

    Object.values('es8'); // ['e', 's', '8']

![](https://cdn-images-1.medium.com/max/800/1*Q-K5Cjjb9qnIviRmbn_Ccg.png)

Browser support (MDN) for *Object.values*
The `*Object.entries*` method returns an array of a given object's own enumerable property `[key, value]` pairs, in the same order as `Object.values`. The declaration of the function is trivial:

    const obj = { x: 'xxx', y: 1 };
    Object.entries(obj); // [['x', 'xxx'], ['y', 1]]

    const obj = ['e', 's', '8'];
    Object.entries(obj); // [['0', 'e'], ['1', 's'], ['2', '8']]

    const obj = { 10: 'xxx', 1: 'yyy', 3: 'zzz' };
    Object.entries(obj); // [['1', 'yyy'], ['3', 'zzz'], ['10': 'xxx']]

    Object.entries('es8'); // [['0', 'e'], ['1', 's'], ['2', '8']]

![](https://cdn-images-1.medium.com/max/800/1*QROuy9LbQuGS4Z_vUDztDA.png)

Browser support (MDN) for *Object.entries*

---

### Object.getOwnPropertyDescriptors

The `getOwnPropertyDescriptors` method returns the own property descriptor of the specified object. An own property descriptor is one that is defined directly on the object and is not inherited from the object’s prototype. The declaration of the function is:

    Object.getOwnPropertyDescriptor(obj, prop)

The `*obj*` is the source object and prop is the object’s property name whose description is to be retrieved. The possible keys for the result are *configurable, enumerable, writable, get, set and value*.

    const obj = { get es8() { return 888; } };
    Object.getOwnPropertyDescriptor(obj, 'es8');
    // {
    //   configurable: true,
    //   enumerable: true,
    //   get: function es8(){}, //the getter function
    //   set: undefined
    // }

The descriptor data is very important for [advanced features like decorators](https://hackernoon.com/all-you-need-to-know-about-decorators-a-case-study-4a7e776b22a6).

![](https://cdn-images-1.medium.com/max/800/1*V-gofNjJgaeowtqUWmu5rQ.png)

Browser support (MDN)

---

### Trailing commas in function parameter lists and calls

Trailing commas in function parameter is the ability of the compiler not to raise an error (`SyntaxError`) when we add unnecessary comma in the end of the list:

    function es8(var1, var2, var3**,**) {
      // ...
    }

As the function declaration, this can be applied on function’s calls:

    es8(10, 20, 30**,**);

This feature inspired from the trailing of commas in object literals and Array literals `[10, 20, 30,]` and `{ x: 1, }`.

---

### Async functions

The `async function` declaration defines an asynchronous function, which returns an `[AsyncFunction](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/AsyncFunction)` object. Internally, async functions work much like generators, but they are not translated to generator functions.

    function fetchTextByPromise() {
      return new Promise(resolve => {
        setTimeout(() => {
          resolve("es8");
        }, 2000);
      });
    }

    **async **function sayHello() {
      const externalFetchedText = **await **fetchTextByPromise();
      console.log(`Hello, ${externalFetchedText}`); // Hello, es8
    }

    sayHello();

The call of `sayHello` will log `Hello, es8` after 2 seconds.

    console.log(1);
    sayHello();
    console.log(2);

And now the prints are:

    1 // immediately
    2 // immediately
    Hello, es8 // after 2 seconds

This is because the function call doesn’t block the flow.

Pay attention that an `async function` always returns a promise and an `await` keywordmay only be used in functions marked with the `async` keyword.

![](https://cdn-images-1.medium.com/max/800/1*o9uz3ul-hxd4zDL6ADVCow.png)

Browser support (MDN)

---

### Shared memory and atomics

When memory is shared, multiple threads can read and write the same data in memory. Atomic operations make sure that predictable values are written and read, that operations are finished before the next operation starts and that operations are not interrupted. This section introduces a new constructor `SharedArrayBuffer` and a namespace object `Atomics` with static methods.

The `Atomic` object is an object of static methods like `Math`, so we can’t use it as a constructor. Examples for static method in this object are:

- add / sub— add / subtract a value for the value at a specific position
- and / or / xor — bitwise and / bitwise or / bitwise xor
- load — get the value at a specific position

![](https://cdn-images-1.medium.com/max/800/1*YQ8a02yltTM1Vfphdik5_g.png)

Browser support (MDN)

---

### And one for the next year in ES9 — Lifting template literal restriction

With the tagged template literal (ES6) we can do stuff like declaring a template parsing function and returning a value according to our logic:

    const esth = 8;
    helper`ES ${esth} is `;

    function helper(strs, ...keys) {
      const str1 = strs[0]; // ES
      const str2 = strs[1]; // is

      let additionalPart = '';
      if (keys[0] == 8) { // 8
        additionalPart = 'awesome';
      }
      else {
        additionalPart = 'good';
      }

      return `${str1} ${keys[0]} ${str2} ${additionalPart}.`;
    }

The returned value will be → ES 8 is awesome.
And for `esth` of 7 the returned value will be → ES 7 is good.

But there is a restriction for templates that contain for example \u or \x sub strings. ES9 will deal with this escaping problem. Read more about it in the [MDN website](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals) or in the [TC39 document](https://tc39.github.io/proposal-template-literal-revision/).

![](https://cdn-images-1.medium.com/max/800/1*uO1Rt_UtQWPaBCSnF9vA_g.png)

Browser support (MDN)

---

### Conclusion

JavaScript is in production, but it is always getting renewed. The process of adopting new features to the specification is very arranged and poised. In the last stage, these features confirmed by the TC39 committee and implemented by the core developers. Most of them are already parts of the Typescript language, browsers or other polyfills, so you can go and try them right now.

![](https://cdn-images-1.medium.com/max/800/1*cA1Y2VmIvRnUJUvjUPNZ2A.png)

***You can follow me on ***[***Medium***](https://medium.com/@dormoshe)*** or ***[***Twitter***](https://twitter.com/DorMoshe)*** to read more about Angular and JavaScript.***


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
