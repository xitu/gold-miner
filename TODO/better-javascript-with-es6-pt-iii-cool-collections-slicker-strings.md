>* 原文链接 : [Better JavaScript with ES6, Pt. III: Cool Collections & Slicker Strings](https://scotch.io/tutorials/better-javascript-with-es6-pt-iii-cool-collections-slicker-strings)
* 原文作者 : [Peleke](https://github.com/Peleke)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


## 简介

ES2015 发生了一些重大变革，像 [promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) 和 [generators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Iterators_and_Generators). 但并非新标准的一切都高不可攀。 -- 相当一部分新特性可以快速上手。

在这篇文章里，我们来看下新特性带来的好处:

*   新的集合: `map`，`weakmap`，`set`，和 `weakset`
*   大部分的 [new `String` methods](https://developer.mozilla.org/en-US/docs/Web/JavaScript/New_in_JavaScript/ECMAScript_6_support_in_Mozilla#Additions_to_the_String_object) 和
*   模板字符串。

我们开始这个系列的最后一章吧。

_标注: 这是 the Better JavaScript 系列的第三章。 前两章在这儿:_

*   [Better JavaScript with ES6, Part 1: Popular Features](https://scotch.io/tutorials/better-node-with-es6-pt-i)
*   [Better JavaScript with ES6, Part 2: A Deep Dive into Classes](https://scotch.io/tutorials/better-javascript-with-es6-pt-ii-a-deep-dive-into-classes)

## 模板字符串

**模板字符串** 解决了三个痛点，允许你做如下操作:

1.  定义在字符串_内部的_表达式，称为 _字符串插值_。
2.  写多行字符串无须用换行符 (`\n`) 拼接。
3.  使用 "raw" 字符串 -- 在反斜杠内的字符串不会被转义，视为常量。

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

1.  使用字符串插值，用反引号代替引号包裹字符串，并把我们想要的表达式嵌入在${}中。
2.  对于多行字符串，只需要把你要写的字符串包裹在反引号里，在要换行的地方直接换行。 JavaScript 会在换行处插入新行。
3.  使用原生字符串，在模板字符串前加前缀`String.raw`，仍然使用反引号包裹字符串。

模板字符串或许只不过是一种语法糖 . . . 但比语法糖它略胜一筹。

## 新的字符串方法

ES2015 也给 `String` 新增了一些方法。 他们主要归为两类:

1.  通用的便捷方法和
2.  扩充 Unicode 支持的方法。

在本文里我们只讲第一类，同时 unicode 特定方法也有相当好的用例 。如果你感兴趣的话，这是地址 [在 MDN 的文档里，有一个关于字符串新方法的完整列表](https://developer.mozilla.org/en-US/docs/Web/JavaScript/New_in_JavaScript/ECMAScript_6_support_in_Mozilla#Additions_to_the_String_object)。

## startsWith & endsWith

对新手而言，我们有 [String.prototype.startsWith](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/startsWith)。 它对任何字符串都有效，它需要两个参数:

1.  一个是 _search string_; 还有
2.  整形的位置参数 _n_。这是可选的。

`String.prototype.startsWith` 方法会检查以 _nth_ 位起的字符串是否以 _search string_ 开始。如果没有位置参数，则默认从头开始。

如果字符串以要搜索的字符串开头返回 `true`，否则返回 `false`。

    "use strict";

    const contrived_example = "This is one impressively contrived example!";

    // does this string start with "This is one"?
    console.log(contrived_example.startsWith("This is one")); // true

    // does this start with "is" at character 4?
    console.log(contrived_example.startsWith("is", 4)); // false

    // does this start with "is" at character 5?
    console.log(contrived_example.startsWith("is", 5)); // true

## endsWith

[String.prototype.endsWith](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/endsWith) 和startswith相似: 它也需要两个参数：一个是要搜索的字符串，一个是位置。

然而 `String.prototype.endsWith` 位置参数会告诉函数要搜索的字符串在原始字符串中被当做结尾处理。

换句话说，它会切掉 _nth_ 后的所有字符串，并检查是否以要搜索的字符结尾。

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

ES2015 也添加了 [String.prototype.includes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/includes)。 你需要用字符串调用它，并且要传递一个搜索项。 如果字符串包含搜索项会返回 `true`，反之返回 `false`。

    "use strict";

    const contrived_example = "This is one impressively contrived example!";

    // does this string include the word impressively?
    contrived_example.includes("impressively"); // true

ES2015之前，我们只能这样:

    "use strict";
    contrived_example.indexOf("impressively") !== -1 // true

不算太坏。 但是，`String.prototype.includes` _是_ 一个改善，它屏蔽了任意整数返回值为true的漏洞。

## repeat

还有 [String.prototype.repeat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/repeat)。 可以对任意字符串使用，像 `includes` 一样，它会或多或少地完成函数名指示的工作。

它只需要一个参数: 一个整型的 _count_。使用案例说明一切，上代码:

    const na = "na";

    console.log(na.repeat(5) + ", Batman!"); // 'nanananana, Batman!'

## raw

最后，我们有 [String.raw](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/raw)，我们在上面简单介绍过。

一个模板字符串以 `String.raw` 为前缀，它将不会在字符串中转义:

    /* Since the backslash alone means "escape", we need to double it to print
      *   one. Similarly, \n in a normal string is interpreted as "newline". 
      *   */
    console.log('This string \\ has fewer \\ backslashes \\ and \n breaks the line.');

    // Not so, with String.raw!
    String.raw`This string \\ has too many \\ backslashes \\ and \n doesn't break the line.`

## Unicode 方法

虽然我们不涉及剩余的 string 方法，但是如果我不告诉你去这个主题的必读部分就会显得我疏忽。 
*   Dr Rauschmayer 对于 [Unicode in JavaScript](http://speakingjs.com/es5/ch24.html) 的介绍;
*   他关于 [ES2015's Unicode Support in Exploring ES6](http://exploringjs.com/es6/ch_unicode.html#sec_escape-sequences) ; 和
*   [The Absolute Minimum Every Software Developer Needs to Know About Unicode](http://www.joelonsoftware.com/articles/Unicode.html) 的讨论。

无论如何我不得不跳过它的最后一部分。虽然有些老但是还是有优点的。

这里是文档中缺失的字符串方法，这样你会知道缺哪些东西了。

*   [String.fromCodePoint](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/fromCodePoint) & [String.prototype.codePointAt](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/codePointAt);
*   [String.prototype.normalize](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/normalize); 和
*   [Unicode point escapes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Lexical_grammar#Unicode_code_point_escapes).

## 集合

ES2015 新增了一些集合类型:

1.  [Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) 和 [WeakMap](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakMap)
2.  [Set](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set) 和 [WeakSet](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakSet)。

合适的 Map 和 Set 类型十分方便使用，还有弱变量是一个令人兴奋的改动，虽然它对Javascript来说像舶来品一样。

## Map

_map_ 就是简单的键值对。 最简单的理解方式就是和 object 类似，一个键对应一个值。

    "use strict";

    // We can think of foo as a key, and bar as a value.
    const obj = { foo : 'bar' };

    // The foo 'key' of obj has value 'bar'
    obj.foo === 'bar'; // true

新的 Map 类型在概念上是相似的，但是可以使用任意的数据类型作为键 -- 不止 strings 和 symbols -- 还有除了 [pitfalls associated with trying to use an objects a map](http://www.2ality.com/2012/01/objects-as-maps.html) 的一些东西。

下面的片段例举了 Map 的 API.

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

Maps are sweet。但是 Object 在保存键值对的时候仍然有用。 如果符合下面的全部条件，你可能还是想用 Object:

1.  当你写代码的时候，你知道你的键值对。
2.  你知道你可能不会去增加或删除你的键值对。
3.  你使用的键全都是 string 或 symbol。

另一方面，如果符合以下_任意_条件，你可能会想使用一个 map。

1.  你需要遍历整个map -- 然而这对 object 来说是难以置信的.
2.  当你写代码的时候不需要知道键的名字或数量。
3.  你需要复杂的键，像 Object 或 别的 Map (!).

像遍历一个 map 一样遍历一个 object 是可行的，但奇妙的是 -- 还会有一些坑潜伏在暗处。 Map 更容易使用，并且增加了一些可集成的优势。然而 object 是以随机顺序遍历的，**map 是以插入的顺序遍历的**。

添加随意动态键名的键值对给一个 object 是_可行的_。但奇妙的是: 比如说如果你曾经遍历过一个伪 map ，你需要记住手动更新条目数。

最后一条，如果你要设置的键名不是 string 或 symbol，你除了选择 Map 别无选择。

上面的这些只是一些指导性的意见，并不是最好的规则。

## WeakMap

你可能听说过一个特别棒的特性 [垃圾回收器](https://en.wikipedia.org/wiki/Garbage_collection_(computer_science))，它会定期地检查不再使用的对象并清除。

[To quote Dr Rauschmayer](http://www.2ality.com/2015/01/es6-maps-sets.html):

> WeakMap 不会阻止它的键值被垃圾回收。那意味着你可以把数据和对象关联起来不用担心内存泄漏。

换句换说，就是你的程序丢掉了 WeakMap _键_ 的所有外部引用，他能自动垃圾回收他们的值。

尽管大大简化了用例，考虑到 SPA(单页面应用) 就是用来展示用户希望展示的东西，像一些物品描述和一张图片，我们可以理解为 API 返回的 JSON。

理论上来说我们可以通过缓存响应结果来减少请求服务器的次数。我们可以这样用 Map :

    "use strict";

    const cache = new Map();

    function put (element, result) {
        cache.set(element, result);
    }

    function retrieve (element) {
        return cache.get(element);
    }

. . . 这是行得通的，但是有内存泄漏的危险。

因为这是一个 SPA，用户或许想离开这个视图，这样的话我们的 "视图" object 就会失效，会被垃圾回收。

不幸的是，如果你使用的是正常的 Map ,当这些 object 不使用时，你必须自行清除。

使用 WeakMap 替代就可以解决上面的问题:

    "use strict";

    const cache = new WeakMap(); // No more memory leak!

    // The rest is the same . . . 

这样当应用失去不需要的元素的引用时，垃圾回收系统可以自动重用那些元素。

WeakMap 的API 和Map 相似，但有如下几点不同:

1.  在 WeakMap 里你可以使用 object 作为键。 这意味着不能以 String 和 Symbol 做键。
2.  WeakMap 只有 `set`，`get`，`has`，和 `delete` 方法 -- 那意味着 **你不能遍历 weak map**.
3.  WeakMaps 没有 `size` 属性。

不能遍历或检查 WeakMap 的长度的原因是，在遍历过程中可能会遇到垃圾回收系统的运行: 这一瞬间是满的，下一秒就没了。

这种不可预测的行为需要谨慎对待，TC39(ECMA第39届技术委员会) 曾试图避免禁止 WeakMap 的遍历和长度检测。

其他的案例，可以在这里找到 [Use Cases for WeakMap](http://exploringjs.com/es6/ch_maps-sets.html#_use-cases-for-weakmaps)，来自 Exploring ES6.

## Set

**Set** 就是只包含一个值的集合。换句换说，每个 set 的元素只会出现一次。

这是一个有用的数据类型，如果你要追踪唯一并且固定的 object ,比如说聊天室的当前用户。

Set 和 Map 有完全相同的 API。主要的不同是 Set 没有 `set` 方法，因为它不能存储键值对。剩下的几乎相同。

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

WeakSet 相对于 Set 就像 WeakMap 相对于 Map。就像 WeakMap:

1.  在 WeakSet 里 object 的引用是弱类型的。 
2.  WeakSet 没有 property 属性。
3.  不能遍历 WeakSet。

Weak set的用例并不多，但是这儿有一些 [Domenic Denicola](https://mail.mozilla.org/pipermail/es-discuss/2015-June/043027.html) 称呼它们为 "perfect for branding" -- 意思就是标记一个对象以满足其他需求。

这儿是他给的例子:

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

这是一个轻量科学的方法防止大家在一个 _没有_ 被 `Foo` 构造出的 object上使用 `method`。

使用的 WeakSet 的优势是允许 `foo` 里的 object 使用完后被垃圾回收。

## 总结

这篇文章里，我们已经了解了 ES2015 带来的一些好处，从 `string` 的便捷方法和模板变量到适当的Map 和 Set 实现。

`String` 方法 和 模板字符串易于上手。同时你很快也就不用到处用 weak set 了，我认为你很快就会喜欢上 Set 和 Map。

如何你有任何问题，请在下方留言，或在 Twitter([@PelekeS](http://twitter.com/PelekeS) 上跟我联系-- 我会逐一答复。

