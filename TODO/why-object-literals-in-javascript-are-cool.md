>* 原文链接 : [Why object literals in JavaScript are cool](https://rainsoft.io/why-object-literals-in-javascript-are-cool/)
* 原文作者 : [Dmitri Pavlutin](https://rainsoft.io/author/dmitri-pavlutin/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [章辰(zhangchen91)](https://github.com/zhangchen91)
* 校对者: [rccoder](https://github.com/rccoder), [Graning](https://github.com/Graning)


在 [ECMAScript 2015](https://rainsoft.io/why-object-literals-in-javascript-are-cool/www.ecma-international.org/ecma-262/6.0/) 之前，Javascript 中的对象字面量(又叫做对象初始化器)是相当简单的，它可以定义2种属性：

*   成对的静态属性名和值 `{ name1: value1 }`
*   通过 [getters](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Functions/get) `{ get name(){..} }` 和 [setters](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Functions/set) `{ set name(val){..} }` 定义的动态计算属性值

说来遗憾，一个简单的例子就可以表示对象字面量的所有可能性：

    var myObject = {  
      myString: 'value 1',
      get myNumber() {
        return this.myNumber;
      },
      set myNumber(value) {
        this.myNumber = Number(value);
      }
    };
    myObject.myString; // => 'value 1'  
    myObject.myNumber = '15';  
    myObject.myNumber; // => 15  

JavaScript 是一种[基于原型继承](https://en.wikipedia.org/wiki/Prototype-based_programming)的语言，所以啥都是个对象。 所以当处理对象的创建、原型的设置与访问时，它必须提供简单的构造方法。

定义一个对象然后设置它的原型是普遍流程。我常常觉得原型的设置应该能直接在字面量里用一条语句实现。

很不幸，字面量的限制不允许这样简单直接的实现方案。你不得不使用 `Object.create()` 配合字面量来设置原型:

    var myProto = {  
      propertyExists: function(name) {
        return name in this;    
      }
    };
    var myNumbers = Object.create(myProto);  
    myNumbers['array'] = [1, 6, 7];  
    myNumbers.propertyExists('array');      // => true  
    myNumbers.propertyExists('collection'); // => false  

我认为这个方案很不方便。 JavaScript 是基于原型的，为什么设置对象的原型要这么痛苦？

幸运的是 JavaScript 在进化，它许多相当令人不舒服的特性正在一步步的被解决。

这篇文章演示了 ES2015 是如何解决以上描述的难题，并增加了哪些特性来提升对象字面量的能力：

*   在对象构造函数中设置原型
*   速写式方法声明
*   进行 `super` 调用
*   可计算的属性名

还有我们可以展望一下将来，看看 ([草案2](https://github.com/sebmarkbage/ecmascript-rest-spread#status-of-this-proposal)) 里的新提议： 可收集可展开的属性。

![Infographic](http://ac-Myg6wSTV.clouddn.com/825d7c6a95690b5818eb.jpg)

### 1\. 在对象构造函数中设置原型

正如你已知的，访问已创建对象的原型有一种方式是引用  `__proto__` 这个 getter 属性：

    var myObject = {  
      name: 'Hello World!'
    };
    myObject.__proto__;                         // => {}  
    myObject.__proto__.isPrototypeOf(myObject); // => true  

`myObject.__proto__` 返回 `myObject` 的原型对象。

好消息是 [ES2015 允许使用](http://www.ecma-international.org/ecma-262/6.0/#sec-__proto__-property-names-in-object-initializers) `__proto__` 在对象字面量 `{ __proto__: protoObject }` 中作为属性名来设置原型。

让我们用 `__proto__` 属性为对象初始化，看它是如何改进介绍中描述的不直观方案：

    var myProto = {  
      propertyExists: function(name) {
        return name in this;    
      }
    };
    var myNumbers = {  
      __proto__: myProto,
      array: [1, 6, 7]
    };
    myNumbers.propertyExists('array');      // => true  
    myNumbers.propertyExists('collection'); // => false  

`myNumbers` 是使用了特殊的属性名 `__proto__` 创建的对象，它的原型是 `myProto` 。
这个对象用了一个简单的声明来创建，没有使用类似 `Object.create()` 的附加函数。

如你所见，使用 `__proto__` 非常简洁. 我通常推荐简洁直观的解决方案。

一些题外话，我认为有点奇怪的是简单可扩展的解决方案依赖大量的设计和工作。如果一个方案很简洁，你也许认为它是容易设计的。然而事实完全相反:

*   让事情变得简单直接很复杂
*   让事情变得复杂难以理解很容易

如果一些事情看起来很复杂或者很难使用，可能它是没有被充分考虑过。
关于返璞归真，你怎么看？（随意留言评论）

#### 2.1 特殊的情况下 `__proto__` 的使用手册

即使 `__proto__` 看起来很简洁， 这有一些特定的场景你需要注意到。

![Infographic](http://ac-Myg6wSTV.clouddn.com/e46fa45d4cce81bc3be9.jpg)

对象字面量中 `__proto__` 只允许使用 **一次** 。重复使用 JavaScript 会抛出异常：

    var object = {  
      __proto__: {
        toString: function() {
          return '[object Numbers]'
        }
      },
      numbers: [1, 5, 89],
      __proto__: {
        toString: function() {
          return '[object ArrayOfNumbers]'
        }
      }
    };

例子中的对象字面量声明了两个 `__proto__` 属性，这是不允许的。这种情况会抛出 `SyntaxError: Duplicate __proto__ fields are not allowed in object literals` 的语法错误。

JavaScript 有只能使用对象或 `null` 作为 `__proto__` 属性值的约束。任何尝试使用原始类型们 (字符串，数字，布尔值) 乃至 `undefined` 会被忽略掉，不能改变对象的原型。
让我们看看这个限制的例子：

    var objUndefined = {  
      __proto__: undefined
    };
    Object.getPrototypeOf(objUndefined); // => {}  
    var objNumber = {  
      __proto__: 15
    };
    Object.getPrototypeOf(objNumber);    // => {}  

这个对象字面量使用了 `undefined` 和数字 `15` 来设置 `__proto__` 的值。因为只有对象或 `null` 允许被当做原型， `objUndefined` 和 `objNumber` 仍然拥有他们默认的原型： JavaScript 空对象 `{}`。 `__proto__` 的值被忽略了。

当然，尝试用原始类型去设置对象的原型会挺奇怪。这里的约束符合预期。

### 2\. 速写式方法声明

我们可以在对象字面量中使用一个更短的语法来声明方法，一个能省略掉 `function` 关键字和 `:` 符号的方式。它被称之为速写式方法声明。

让我们使用这个新的短模式来定义一些方法吧：

    var collection = {  
      items: [],
      add(item) {
        this.items.push(item);
      },
      get(index) {
        return this.items[index];
      }
    };
    collection.add(15);  
    collection.add(3);  
    collection.get(0); // => 15  

`add()` 和 `get()` 是 `collection` 里用这个短模式定义的方法。

这个方法声明的方式还一个好处是它们都是非匿名函数，这在调试的时候会很方便。 上个例子执行 `collection.add.name` 返回函数名 `'add'`。
译者注：好像非速写式声明的函数名字也是一样，调用堆栈的表现也都一样，这里不太明白。

### 3\. 进行 `super` 调用

一个有趣的改进是可以使用 `super` 关键字来访问原型链中父类的属性。瞧瞧下面的这个例子：

    var calc = {  
      sumArray (items) {
        return items.reduce(function(a, b) {
          return a + b;
        });
      }
    };
    var numbers = {  
      __proto__: calc,
      numbers: [4, 6, 7],
      sumElements() {
        return super.sumArray(this.numbers);
      }
    };
    numbers.sumElements(); // => 17  

`calc` 是 `numbers` 对象的原型。在 `numbers` 的 `sumElements` 方法中可以通过 `super` 关键字调用原型的 `super.sumArray()` 方法。

最终， `super` 是调用对象原型链里父类属性的快捷方式。

上面的例子其实可以直接用 `calc.sumArray()` 调用它的原型。然而因为 `super` 基于原型链调用，是一个更推荐的方式。并且它的存在明确得表示了父类属性即将被调用。

#### 3.1 `super` 的使用限制

`super` 在对象字面量中 **只能在速写式方法声明里** 使用。

如果尝试在普通的方法声明 `{ name: function() {} }` 中使用， JavaScript 会抛出异常：

    var calc = {  
      sumArray (items) {
        return items.reduce(function(a, b) {
          return a + b;
        });
      }
    };
    var numbers = {  
      __proto__: calc,
      numbers: [4, 6, 7],
      sumElements: function() {
        return super.sumArray(this.numbers);
      }
    };
    // Throws SyntaxError: 'super' keyword unexpected here
    numbers.sumElements();  

这个 `sumElements` 方法是通过属性： `sumElements: function() {...}` 定义的。 因为 `super` 只能在速写式方法声明中使用，这种情况下调用会抛出 `SyntaxError: 'super' keyword unexpected here` 的语法错误。

这个约束不太影响对象字面量的声明方式，多数情况下因为语法更简洁，使用速写式方法声明会更好。

### 4\. 可计算的属性名

在 ES2015 之前, 在对象字面量初始化中，对象的属性名大部分是静态的字符串。为了创建一个经过运算的属性名，你不得不使用访问器函数创建属性。

    function prefix(prefStr, name) {  
       return prefStr + '_' + name;
    }
    var object = {};  
    object[prefix('number', 'pi')] = 3.14;  
    object[prefix('bool', 'false')] = false;  
    object; // => { number_pi: 3.14, bool_false: false }  

很明显，这种方式定义属性有点不那么友好。

可计算的属性名优雅的解决了这个问题。
当你要通过某个表达式计算属性名，在方括号 `{[expression]: value}` 里替换对应的代码。对应的表达式会把计算结果作为属性名。

我非常喜欢这个语法：简短又简洁。

让我们改进上面的例子：

    function prefix(prefStr, name) {  
       return prefStr + '_' + name;
    }
    var object = {  
      [prefix('number', 'pi')]: 3.14,
      [prefix('bool', 'false')]: false
    };
    object; // => { number_pi: 3.14, bool_false: false }  

`[prefix('number', 'pi')]` 通过计算 `prefix('number', 'pi')` 表达式设置了 `'number_pi'` 这个属性名.  
相应的 `[prefix('bool', 'false')]` 表达式设置了另一个属性名 `'bool_false'` 。

#### 4.1 `Symbol` 作为属性名

[Symbols](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Symbol) 运算也可以作为可计算的属性名。只需要保证把它们括在括号里： `{ [Symbol('name')]: 'Prop value' }` 。

举个栗子，让我们用 `Symbol.iterator` 这个特殊的属性，去遍历对象的自有属性名。如下所示：

    var object = {  
       number1: 14,
       number2: 15,
       string1: 'hello',
       string2: 'world',
       [Symbol.iterator]: function *() {
         var own = Object.getOwnPropertyNames(this),
           prop;
         while(prop = own.pop()) {
           yield prop;
         }
       }
    }
    [...object]; // => ['number1', 'number2', 'string1', 'string2']

`[Symbol.iterator]: function *() { }` 定义了一个属性来遍历对象的自有属性。 展开操作符 `[...object]` 使用了迭代器来返回自有属性的数组。

### 5\. 对未来的一个展望: 可收集可展开的属性

对象字面量的[可收集可展开的属性](https://github.com/sebmarkbage/ecmascript-rest-spread) 目前是草案第二阶段 (stage 2) 中的一个提议，它将被选入下一个 Javascript 版本。

它们等价于[展开和收集操作符](https://rainsoft.io/how-three-dots-changed-javascript/#4improvedarraymanipulation) ，已经可以在 ECMAScript 2015 中被数组所使用。

[可收集的属性](https://github.com/sebmarkbage/ecmascript-rest-spread/blob/master/Rest.md) 允许收集一个对象在解构赋值后剩下的属性们。
下面这个例子收集了 `object` 解构后留下的属性：

    var object = {  
      propA: 1,
      propB: 2,
      propC: 3
    };
    let {propA, ...restObject} = object;  
    propA;      // => 1  
    restObject; // => { propB: 2, propC: 3 }  

[可展开的属性](https://github.com/sebmarkbage/ecmascript-rest-spread/blob/master/Spread.md) 允许从一个源对象拷贝它的自有属性到另一个对象字面量中。这个例子中对象字面量的其它属性合集是从 `source` 对象中展开的：

    var source = {  
      propB: 2,
      propC: 3
    };
    var object = {  
      propA: 1,
      ...source
    }
    object; // => { propA: 1, propB: 2, propC: 3 }  

### 6\. 总结

JavaScript 正在大步前进。

即使一个相当小的对象字面量改进都会在 ECMAScript 2015 里考虑。以及很多草案里的新特性提议。

你可以在对象初始化时直接通过 `__proto__` 属性名设置其原型。比用 `Object.create()` 简单很多。

现在方法声明有个更简洁的模式，所以你不必输入 `function` 关键字。而且在速写式声明里，你可以使用 `super` 关键字，它允许你十分容易得通过对象的原型链访问父类属性。

如果属性名需要在运行时计算，现在你可以用可计算的属性名 `[expression]` 来初始化对象。

对象字面量现在确实很酷！
_你觉得呢？随意留言评论。_
