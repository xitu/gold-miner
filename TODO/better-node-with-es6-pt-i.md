>* 原文链接 : [Better Node with ES6, Pt. I](https://scotch.io/tutorials/better-node-with-es6-pt-i)
* 原文作者 : [Peleke](https://github.com/Peleke)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [huanglizhuo](https://github.com/huanglizhuo) 
* 校对者: [yllziv](https://github.com/yllziv) , [godofchina](https://github.com/godofchina)

# 使用 ES6 写更好的 JavaScript part I：广受欢迎的新特性

## 介绍 

在 ES2015 规范敲定并且 Node.js 增添了大量的函数式子集的背景下，我们终于可以拍着胸脯说：未来就在眼前。

. . . 我早就想这样说了

但这是真的。[V8 引擎将很快实现规范](http://v8project.blogspot.com/2016/03/v8-release-50.html)，而且 [Node 已经添加了大量可用于生产环境的 ES2015 特性](https://nodejs.org/en/docs/es6/)。下面要列出的是一些我认为很有必要的特性，而且这些特性是不使用需要像 [Babel](https://babeljs.io/) 或者 [Traceur](https://github.com/google/traceur-compiler) 这样的翻译器就可以直接使用的。

这篇文章将会讲到三个相当流行的 ES2015 特性，并且已经在 Node 中支持了了：

*   用 `let` 和 `const` 声明块级作用域；
*   箭头函数；
*   简写属性和方法。

让我们马上开始。

## `let` 和 `const` 声明块级作用域

**作用域** 是你程序中变量可见的区域。换句话说就是一系列的规则，它们决定了你声明的变量在哪里是可以使用的。

大家应该都听过 ，在 JavaScript 中只有在函数内部才会创造新的作用域。然而你创建的 98% 的作用域事实上都是函数作用域，其实在 JavaScript 中有三种创建新作用域的方法。你可以这样：

1.  **创建一个函数**。你应该已经知道这种方式。
2.  **创建一个 `catch` 块**。 [我绝对没哟开玩笑](https://github.com/getify/You-Dont-Know-JS/blob/master/scope%20&%20closures/apB.md).
3.  **创建一个代码块**。如果你用的是 ES2015，在一段代码块中用 `let` 或者 `const` 声明的变量会限制它们**只在**这个块中可见。这叫做_块级作用域_.

一个_代码块_就是你用花括号包起来的部分。 `{ 像这样 }`。在 `if`/`else` 声明和 `try`/`catch`/`finally` 块中经常出现。如果你想利用块作用域的优势，你可以用花括号包裹任意的代码来创建一个代码块

考虑下面的代码片段。

    // 在 Node 中你需要使用 strict 模式尝试这个
    "use strict";

    var foo = "foo";
    function baz() {
        if (foo) {
            var bar = "bar";
            let foobar = foo + bar;
        }
        // foo 和 bar 这里都可见 
        console.log("This situation is " + foo + bar + ". I'm going home.");

        try {
            console.log("This log statement is " + foobar + "! It threw a ReferenceError at me!");
        } catch (err) {
            console.log("You got a " + err + "; no dice.");
        }

        try {
            console.log("Just to prove to you that " + err + " doesn't exit outside of the above `catch` block.");
        } catch (err) {
            console.log("Told you so.");
        }
    }

    baz();

    try {
        console.log(invisible);
    } catch (err) {
        console.log("invisible hasn't been declared, yet, so we get a " + err);
    }
    let invisible = "You can't see me, yet"; // let 声明的变量在声明前是不可访问的


还有些要强调的

*   注意 `foobar` 在 `if` 块之外是不可见的，因为我们没有用`let` 声明；
*   我们可以在任何地方使用 `foo` ，因为我们用 `var` 定义它为全局作用域可见；
*   我们可以在 `baz` 内部任何地方使用 `bar`， 因为 `var`-声明的变量是在定义的整个作用域内都可见。
*   用 let or const 声明的变量不能在定义前调用。换句话说，它不会像 `var` 变量一样被编译器提升到作用域的开始处。

`const` 与 `let` 类似，但有两点不同。


1.  _必须_ 给声明为 `const` 的变量在声明时赋值。不可以先声明后赋值。
2.  _不能_ 改变`const`变量的值，只有在创建它时可以给它赋值。如果你试图改变它的值，会得到一个 `TyepError`。

### `let` & `const`: Who Cares?

我们已经用 `var` 将就了二十多年了，你可能在想我们_真的_需要新的类型声明关键字吗？（这里作者应该是想表达这个意思）

问的好，简单的回答就是-- 不， 并不 _真正_ 需要。但在可以用`let` 和 `const` 的地方使用它们很有好处的。

*   `let` 和 `const` 声明变量时都不会被提升到作用域开始的地方，这样可以使代码可读性更强，制造尽可能少的迷惑。
*   它会尽可能的约束变量的作用域，有助于减少令人迷惑的命名冲突。
*   这样可以让程序只有在必须重新分配变量的情况下重新分配变量。 `const` 可以加强常量的引用。

另一个例子就是 `let` 在 `for` 循环中的使用：

    "use strict";

    var languages = ['Danish', 'Norwegian', 'Swedish'];

    //会污染全局变量!
    for (var i = 0; i < languages.length; i += 1) {
        console.log(`${languages[i]} is a Scandinavian language.`);
    }

    console.log(i); // 4

    for (let j = 0; j < languages.length; j += 1) {
        console.log(`${languages[j]} is a Scandinavian language.`);
    }

    try {
        console.log(j); // Reference error
    } catch (err) {
        console.log(`You got a ${err}; no dice.`);
    }

在 `for`循环中使用 `var` 声明的计数器并不会 _真正_ 把计数器的值限制在本次循环中。 而 `let` 可以。

`let` 在每次迭代时重新绑定循环变量有很大的优势，这样每个循环中拷贝 自身 , 而不是共享全局范围内的变量。

    "use strict";

    // 简洁明了
    for (let i = 1; i < 6; i += 1) {
        setTimeout(function() {
            console.log("I've waited " + i + " seconds!");
        }, 1000 * i);
    }

    // 功能完全混乱
    for (var j = 0; j < 6; j += 1) {
            setTimeout(function() {
            console.log("I've waited " + j + " seconds for this!");
        }, 1000 * j);
    }

第一层循环会和你想象的一样工作。而下面的会每秒输出 "I've waited 6 seconds!"。

好吧，我选择狗带。

## 动态 `this` 关键字的怪异

JavaScript 的 `this` 关键字因为总是不按套路出牌而臭名昭著。

事实上，它的 [规则相当简单](https://github.com/getify/You-Dont-Know-JS/tree/master/this%20%26%20object%20prototypes)。不管怎么说，`this` 在有些情形下会导致奇怪的用法

    "use strict";

    const polyglot = {
        name : "Michel Thomas",
        languages : ["Spanish", "French", "Italian", "German", "Polish"],
        introduce : function () {
            // this.name is "Michel Thomas"
            const self = this;
            this.languages.forEach(function(language) {
                // this.name is undefined, so we have to use our saved "self" variable 
                console.log("My name is " + self.name + ", and I speak " + language + ".");
            });
        }
    }

    polyglot.introduce();

在 `introduce` 里, `this.name` 是 `undefined`。在回调函数外面，也就是 `forEach` 中， 它指向了 `polyglot` 对象。在这种情形下我们总是希望在函数内部 `this` 和函数外部的 `this` 指向同一个对象。

问题是在 JavaScript 中函数会根据[确定性四原则](https://github.com/getify/You-Dont-Know-JS/blob/master/this%20&%20object%20prototypes/ch2.md)在调用时定义自己的 `this` 变量。这就是著名的 _动态 `this`_ 机制。

这些规则中没有一个是关于查找 this 所描述的“附近作用域”的；也就是说并没有一个确切的方法可以让 JavaScript 引擎能够基于包裹作用域来定义 this的含义。

这就意味着当引擎查找 `this` 的值时，可以找到值，但却和回调函数之外的不是同一个值。有两种传统的方案可以解决这个问题。

1.  在函数外面吧 `this` 保存到一个变量中，通常取名 `self`，并在内部函数中使用；或者
2.  在内部函数中调用 [`bind`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind) 阻止对 `this` 的赋值。 

以上两种办法均可生效，但会产生副作用。

另一方面，如果内部函数 _没有_ 设置它自己的 `this` 值，JavaScript 会像查找其它变量那样查找 `this` 的值：通过遍历父作用域直到找到同名的变量。这样会让我们使用附近作用域代码中的 this 值，这就是著名的 _词法 `this`_ 。

如果有样的特性，我们的代码将会更加的清晰，不是吗?

### 箭头函数中的词法 `this` 
在 ES2015 中，我们有了这一特性。箭头函数 _不会_ 绑定 `this` 值，允许我们利用词法绑定 `this` 关键字。这样我们就可以像这样重构上面的代码了：

    "use strict";

    let polyglot = {
        name : "Michel Thomas",
        languages : ["Spanish", "French", "Italian", "German", "Polish"],
        introduce : function () {
            this.languages.forEach((language) => {
                console.log("My name is " + this.name + ", and I speak " + language + ".");
            });
        }
    }

. . . 这样就会按照我们想的那样工作了。

箭头函数有一些新的语法。

    "use strict";

    let languages = ["Spanish", "French", "Italian", "German", "Polish"];

    // 多行箭头函数必须使用花括号， 
    // 必须明确包含返回值语句
        let languages_lower = languages.map((language) => {
        return language.toLowerCase()
    });

    // 单行箭头函数，花括号是可省的，
    // 函数默认返回最后一个表达式的值
    // 你可以指明返回语句，这是可选的。
    let languages_lower = languages.map((language) => language.toLowerCase());

    // 如果你的箭头函数只有一个参数，可以省略括号
    let languages_lower = languages.map(language => language.toLowerCase());

    // 如果箭头函数有多个参数，必须用圆括号包裹
    let languages_lower = languages.map((language, unused_param) => language.toLowerCase());

    console.log(languages_lower); // ["spanish", "french", "italian", "german", "polish"]

    // 最后，如果你的函数没有参数，你必须在箭头前加上空的括号。
    (() => alert("Hello!"))();

[MDN 关于箭头函数的文档](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) 解释的很好。

## 简写属性和方法

ES2015 提供了在对象上定义属性和方法的一些新方式。

### 简写方法

在 JavaScript 中， _method_ 是对象的一个有函数值的属性：

    "use strict";

    const myObject = {
        const foo = function () {
            console.log('bar');
        },
    }

在ES2015 中，我们可以这样简写：

    "use strict";

    const myObject = {
        foo () {
            console.log('bar');
        },
        * range (from, to) {
            while (from < to) {
                if (from === to)
                    return ++from;
                else
                    yield from ++;
            }
        }
    }

注意你也可以使用生成器去定义方法。只需要在函数名前面加一个星号 (*)。

这些叫做 _方法定义_ 。和传统的函数作为属性很像，但有一些不同：

*   _只能_ 在方法定义处调用 `super` ；
*   _不允许_ 用 `new` 调用方法定义。

我会在随后的几篇文章中讲到 `super` 关键字。如果你等不及了， [Exploring ES6](http://exploringjs.com/es6/ch_classes.html) 中有关于它的干货。

### 简写和推导属性

ES6 还引入了 _简写_ 和 _推导属性_ 。

如果对象的键值和变量名是一致的，那么你可以仅用变量名来初始化你的对象，而不是定义冗余的键值对。

    "use strict";

    const foo = 'foo';
    const bar = 'bar';

    // 旧语法
    const myObject = {
        foo : foo,
        bar : bar
    };

    // 新语法
    const myObject = { foo, bar }

两中语法都以 `foo` 和 `bar` 键值指向 `foo` and `bar` 变量。 后面的方式语义上更加一致；这只是个语法糖。

当用[揭示模块模式](https://addyosmani.com/resources/essentialjsdesignpatterns/book/#revealingmodulepatternjavascript)来定义一些简洁的公共 API 的定义，我常常利用简写属性的优势。

    "use strict";

    function Module () {
        function foo () {
            return 'foo';
        }

        function bar () {
            return 'bar';
        }

        // 这样写:
        const publicAPI = { foo, bar }

        /* 不要这样写:
        const publicAPI =  {
           foo : foo,
           bar : bar
        } */ 

        return publicAPI;
    };

这里我们创建并返回了一个 `publicAPI` 对象，键值 `foo` 指向 `foo` 方法，键值 `bar` 指向 `bar` 方法。

### 推导属性名

这是 _不常见_ 的例子，但 ES6 允许你用表达式做属性名。

    "use strict";

    const myObj = {
      // 设置属性名为 foo 函数的返回值
        [foo ()] () {
          return 'foo';
        }
    };

    function foo () {
        return 'foo';
    }

    console.log(myObj.foo() ); // 'foo'

根据 Dr. Raushmayer 在 [Exploring ES6](http://exploringjs.com/)中讲的，这种特性最主要的用途是设置属性名与 [Symbol](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol) 值一样。

### Getter 和 Setter 方法

最后，我想提一下 `get` 和 `set` 方法，它们在 ES5 中就已经支持了。


    "use strict";

    // 例子采用的是 MDN's 上关于 getter 的内容
    //   https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/get
    const speakingObj = {
        // 记录 “speak” 方法调用过多少次
        words : [],

        speak (word) {
            this.words.push(word);
            console.log('speakingObj says ' + word + '!');
        },

        get called () {
            // 返回最新的单词
            const words = this.words;
            if (!words.length)
                return 'speakingObj hasn\'t spoken, yet.';
            else
                return words[words.length - 1];
        }
    };

    console.log(speakingObj.called); // 'speakingObj hasn't spoken, yet.'

    speakingObj.speak('blargh'); // 'speakingObj says blargh!'

    console.log(speakingObj.called); // 'blargh'

使用 getters 时要记得下面这些:

*   Getters 不接受参数；
*   属性名不可以和 getter 函数重名；
*   可以用 `Object.defineProperty(OBJECT, "property name", { get : function () { . . . } })` 动态创建 getter

作为最后这点的例子，我们可以这样定义上面的 getter 方法：

    "use strict";

    const speakingObj = {
        // 记录 “speak” 方法调用过多少次
        words : [],

        speak (word) {
            this.words.push(word);
            console.log('speakingObj says ' + word + '!');
        }
    };

    // 这只是为了证明观点。我是绝对不会这样写的
    function called () {
        // 返回新的单词
        const words = this.words;
        if (!words.length)
            return 'speakingObj hasn\'t spoken, yet.';
        else
            return words[words.length - 1];
    };

    Object.defineProperty(speakingObj, "called", get : getCalled ) 

除了 getters，还有 setters。像平常一样，它们通过自定义的逻辑给对象设置属性。

    "use strict";

    // 创建一个新的 globetrotter（环球者）！
    const globetrotter = {
        // globetrotter 现在所处国家所说的语言 
        const current_lang = undefined,

        // globetrotter 已近环游过的国家
        let countries = 0,

        // 查看环游过哪些国家了
        get countryCount () {
            return this.countries;
        }, 

        // 不论 globe trotter 飞到哪里，都重新设置他的语言
        set languages (language) {
            // 增加环游过的城市数
            countries += 1;

            // 重置当前语言
            this.current_lang = language; 
        };
    };

    globetrotter.language = 'Japanese';
    globetrotter.countryCount(); // 1

    globetrotter.language = 'Spanish';
    globetrotter.countryCount(); // 2

上面讲的关于 getters 的也同样适用于 setters ，但有一点不同：

*   getter _不接受_ 参数， setters _必须_ 接受 _正好一个_ 参数。

破坏这些规则中的任意一个都会抛出一个错误。

既然 Angular 2 正在引入 TypeCript 并且把 `class` 带到了台前，我希望 `get` and `set` 能够流行起来. . . 但还有点希望它们不要🔥起来。

## 结论

未来的 JavaScript 正在变成现实，是时候把它提供的东西都用起来了。这篇文章里，我们浏览了 ES2015 的三个很流行的特性：

*   `let` 和 `const` 带来的块级作用域；
*   箭头函数带来的 `this` 的词法作用域；
*   简写属性和方法，以及 getter 和 setter 函数的回顾。

关于 `let`，`const`，以及块级作用域的详细信息，请参考 [Kyle Simpson's take on block scoping](https://davidwalsh.name/for-and-against-let)。这里有你快速练习需要的所有指导，参考 MDN 关于 [`let`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let) 和 [`const`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/const)的详细信息。

Dr Rauschmayer 写了一片篇[相当好的关于箭头函数和词法 `this` 的文章](http://www.2ality.com/2012/04/arrow-functions.html)。如果你想了解关于这篇文章更深层次的信息，这绝对是一篇好文。

最后关于我们这里讨论的所有的更详细更深入的内容，请看 Dr Rauschmayer 的书 [Exploring ES6](http://exploringjs.com/)，这是最好的关于 web 最好的一体化指导手册。 

ES2015 的特性中哪个最让你激动? 有什么想让我在后面的文章中写入的新特性? 那就在下面或者在 Twitter 上 ([@PelekeS](http://twitter.com/PelekeS)) 评论吧 -- 我会尽最大的努力单独回复你的。
