>* 原文链接 : [Better JavaScript with ES6, Pt. II: A Deep Dive into Classes](https://scotch.io/tutorials/better-javascript-with-es6-pt-ii-a-deep-dive-into-classes)
* 原文作者 : [Peleke](https://github.com/Peleke)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Malcolm](https://github.com/malcolmyu)
* 校对者: [嘤嘤嘤](https://github.com/xingwanying), [Jack-Kingdom](https://github.com/Jack-Kingdom)

# 使用 ES6 编写更好的 JavaScript Part II：深入探究 [类]

## 辞旧迎新

在本文的开始，我们要说明一件事：

> 从本质上说，ES6 的 classes 主要是给创建老式构造函数提供了一种更加方便的语法，并不是什么新魔法 —— Axel Rauschmayer，Exploring ES6 作者

从功能上来讲，`class` 声明就是一个语法糖，它只是比我们之前一直使用的基于原型的行为委托功能更强大一点。本文将从新语法与原型的关系入手，仔细研究 ES2015 的 `class` 关键字。文中将提及以下内容：

* 定义与实例化类；
* 使用 `extends` 创建子类；
* 子类中 `super` 语句的调用；
* 以及重要的标记方法（symbol method）的例子。

在此过程中，我们将特别注意 `class` 声明语法从本质上是如何映射到基于原型代码的。

让我们从头开始说起。

## 退一步说：Classes **不是**什么

JavaScript 的『类』与 Java、Python 或者其他你可能用过的面向对象语言中的类不同。其实后者可能称作面向『类』的语言更为准确一些。

在传统的面向类的语言中，我们创建的**类**是**对象**的模板。需要一个新对象时，我们**实例化**这个类，这一步操作告诉语言引擎将这个类的方法和属性**复制**到一个新实体上，这个实体称作**实例**。**实例**是我们自己的对象，且在实例化之后与父类毫无内在联系。

而 JavaScript **没有**这样的复制机制。在 JavaScript 中『实例化』一个类创建了一个新对象，但这个新对象却**不**独立于它的父类。

正相反，它创建了一个与**原型**相连接的对象。即使是在**实例化之后**，对于原型的修改也会传递到实例化的新对象去。

原型本身就是一个无比强大的设计模式。有许多使用了原型的技术模仿了传统类的机制，`class` 便为这些技术提供了简洁的语法。

总而言之：

1. JavaScript **不存在** Java 和其他面向对象语言中的类概念；
2. JavaScript 的 `class` 很大程度上只是原型继承的语法糖，与传统的类继承有**很大的不同**。

搞清楚这些之后，让我们先看一下 `class`。

## 类基础：声明与表达式

我们使用 `class` 关键字创建类，关键字之后是变量标识符，最后是一个称作**类主体**的代码块。这种写法称作**类的声明**。没有使用 `extends` 关键字的类声明被称作**基类**：

    "use strict";

    // Food 是一个基类
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

需要注意到以下事情：

* 类**只能**包含方法定义，**不能**有数据属性；
* 定义方法时，可以使用[简写方法定义](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Method_definitions)；
* 与创建对象不同，我们不能在类主体中使用逗号分隔方法定义；
* 我们**可以**在实例化对象上直接引用类的属性（如 LINE A）。

类有一个独有的特性，就是 **contructor** 构造方法。在构造方法中我们可以初始化对象的属性。

构造方法的定义并**不是必须**的。如果不写构造方法，引擎会为我们插入一个空的构造方法：

    "use strict";

    class NoConstructor {
        /* JavaScript 会插入这样的代码：
         constructor () { }
        */
    }

    const nemo = new NoConstructor(); // 能工作，但没啥意思

将一个类赋值给一个变量的形式叫**类表达式**，这种写法可以替代上面的语法形式：

    "use strict";

    // 这是一个匿名类表达式，在类主体中我们不能通过名称引用它
    const Food = class {
        // 和上面一样的类定义……
    }

    // 这是一个命名类表达式，在类主体中我们可以通过名称引用它
    const Food = class FoodClass {
        // 和上面一样的类定义……

        //  添加一个新方法，证明我们可以通过内部名称引用 FoodClass……        
        printMacronutrients () {
            console.log(`${FoodClass.name} | ${FoodClass.protein} g P :: ${FoodClass.carbs} g C :: ${FoodClass.fat} g F`)
        }
    }

    const chicken_breast = new Food('Chicken Breast', 26, 0, 3.5);
    chicken_breast.printMacronutrients(); // 'Chicken Breast | 26g P :: 0g C :: 3.5g F'

    // 但是不能在外部引用
    try {
        console.log(FoodClass.protein); // 引用错误
    } catch (err) {
        // pass
    }

这一行为与[匿名函数与命名函数表达式](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/function)很类似。

## 使用 `extends` 创建子类以及使用 super 调用

使用 `extends` 创建的类被称作**子类**，或**派生类**。这一用法简单明了，我们直接在上面的例子中构建：

    "use strict";

    // FatFreeFood 是一个派生类
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

派生类拥有我们上文讨论的一切有关基类的特性，另外还有如下几点新特点：

* 子类使用 `class` 关键字声明，之后紧跟一个标识符，然后使用 `extend` 关键字，最后写一个**任意表达式**。这个表达式通常来讲就是个标识符，但[理论上也可以是函数](https://gist.github.com/sebmarkbage/fac0830dbb13ccbff596)。
* 如果你的派生类需要引用它的父类，可以使用 `super` 关键字。
* 一个派生类不能有一个空的构造函数。即使这个构造函数就是调用了一下 `super()`，你也得把它显式的写出来。但派生类却可以**没有**构造函数。
* 在派生类的构造函数中，**必须**先调用 `super`，才能使用 `this` 关键字（译者注：仅在构造函数中是这样，在其他方法中可以直接使用 `this`）。

在 JavaScript 中仅有两个 `super` 关键字的使用场景：

1. **在子类构造函数中调用**。如果初始化派生类是需要使用父类的构造函数，我们可以在子类的构造函数中调用 `super(parentConstructorParams)`，传递任意需要的参数。
2. **引用父类的方法**。在常规方法定义中，派生类可以使用点运算符来引用父类的方法：`super.methodName`。

我们的 `FatFreeFood` 演示了这两种情况：

1. 在构造函数中，我们简单的调用了 `super`，并将脂肪的量传入为 `0`。
2. 在我们的 `print` 方法中，我们先调用了 `super.print`，之后才添加了其他的逻辑。

不管你信不信，~~我反正是信了~~以上说的已涵盖了有关 `class` 的基础语法，这就是你开始实验需要掌握的全部内容。

## 深入学习原型

现在我们开始关注 `class` 是怎么映射到 JavaScript 内部的原型机制的。我们会关注以下几点：

* 使用构造调用创建对象；
* 原型连接的本质；
* 属性和方法委托；
* 使用原型模拟类。

### 使用构造调用创建对象

构造函数不是什么新鲜玩意儿。使用 `new` 关键字调用**任意**函数会使其返回一个对象 —— 这一步称作创建了一个**构造调用**，这种函数通常被称作**构造器**：

    "use strict";

    function Food (name, protein, carbs, fat) {
        this.name    = name;
        this.protein = protein;
        this.carbs   = carbs;
        this.fat     = fat;
    }

    // 使用 'new' 关键字调用 Food 方法，就是构造调用，该操作会返回一个对象
    const chicken_breast = new Food('Chicken Breast', 26, 0, 3.5);
    console.log(chicken_breast.protein) // 26

    // 不用 'new' 调用 Food 方法，会返回 'undefined'
    const fish = Food('Halibut', 26, 0, 2);
    console.log(fish); // 'undefined'

当我们使用 `new` 关键字调用函数时，JS 内部执行了下面四个步骤：

1. 创建一个新对象（这里称它为 **O**）；
2. 给 **O** 赋予一个连接到其他对象的链接，称为**原型**；
3. 将函数的 `this` 引用指向 **O**；
4. 函数隐式返回 **O**。

在第三步和第四步之间，引擎会执行你函数中的具体逻辑。

知道了这一点，我们就可以重写 `Food` 方法，使之不用 `new` 关键字也能工作：

    "use strict";

    // 演示示例：消除对 'new' 关键字的依赖
    function Food (name, protein, carbs, fat) {
        // 第一步：创建新对象
        const obj = { };

        // 第二步：链接原型——我们在下文会更加具体地探究原型的概念
        Object.setPrototypeOf(obj, Food.prototype);

        // 第三步：设置 'this' 指向我们的新对象
        // 尽然我们不能再运行的执行上下文中重置 `this`
        // 我们在使用 'obj' 取代 'this' 来模拟第三步
        obj.name    = name;
        obj.protein = protein;
        obj.carbs   = carbs;
        obj.fat     = fat;

        // 第四步：返回新创建的对象
        return obj;
    }

    const fish = Food('Halibut', 26, 0, 2);
    console.log(fish.protein); // 26

四步中的三步都是简单明了的。创建一个对象、赋值属性、然后写一个 `return` 声明，这些操作对大多数开发者来说没有理解上的问题——然而这就是难倒众人的黑魔法原型。

### 直观理解原型链

在通常情况下，JavaScript 中的包括函数在内的所有对象都会链接到另一个对象上，这就是**原型**。

如果我们访问一个对象本身没有的属性，JavaScript 就会在对象的原型上检查该属性。换句话说，如果你对一个对象请求它没有的属性，它会对你说：『这个我不知道，问我的原型吧』。

在另一个对象上查找不存在属性的过程称作**委托**。

    "use strict";

    // joe 没有 toString 方法……
    const joe    = { name : 'Joe' },
        sara   = { name : 'Sara' };

    Object.hasOwnProperty(joe, toString); // false
    Object.hasOwnProperty(sara, toString); // false

    // ……但我们还是可以调用它！
    joe.toString(); // '[object Object]'，而不是引用错误！
    sara.toString(); // '[object Object]'，而不是引用错误！

尽管我们的 `toString` 的输出完全没啥用，但请注意：这段代码没有引起任何的 `ReferenceError`！这是因为尽管 `joe` 和 `sara` 没有 `toString` 的属性，**但他们的原型有啊**。

当我们寻找 `sara.toString()` 方法时，`sara` 说：『我没有 `toString` 属性，找我的原型吧』。正如上文所说，JavaScript 会亲切的询问 `Object.prototype` 是否含有 `toString` 属性。由于原型上有这一属性，JS 就会把 `Object.prototype` 上的 `toString` 返回给我们程序并执行。

`sara` 本身没有属性没关系——**我们会把查找操作委托到原型上**。

换言之，我们就可以访问到对象上并不存在的属性，**只要其的原型上有这些属性**。我们可以利用这一点将属性和方法赋值到对象的原型上，然后我们就可以调用这些属性，好像它们真的存在在那个对象上一样。

更给力的是，如果几个对象共享相同的原型——正如上面的 `joe` 和 `sara` 的例子一样——当我们给原型赋值属性之后，它们就**都**可以访问了，**无需**将这些属性单独拷贝到每一个对象上。

这就是为何大家把它称作**原型继承**——如果我的对象没有，但对象的原型有，那我的对象也能**继承**这个属性。

事实上，这里并没有发生什么『继承』。在面向类的语言里，继承指从父类**复制**属性到子类的行为。在 JavaScript 里，没发生这种复制的操作，事实上这就是原型继承与类继承相比的一个主要优势。

在我们探究原型究竟是怎么来的之前，我们先做一个简要回顾：

* `joe` 和 `sara` **没有**『继承』一个 `toString` 的属性；
* `joe` 和 `sara` 实际上根本**没有**从 `Object.prototype` 上『继承』；
* `joe` 和 `sara` 是**链接**到了 `Object.prototype` 上；
* `joe` 和 `sara` 链接到了**同一个** `Object.prototype` 上。
* 如果想找到一个对象的（我们称它作**O**）原型，我们可以使用 `Object.getPrototypeof(O)`。

然后我们再强调一遍：对象没有『继承自』他们的原型。他们只是**委托**到原型上。

以上。

接下来让我们深♂入一下。

## 设置对象的原型

我们已了解到基本上每个对象（下文以 **O** 指代）都有原型（下文以 **P** 指代），然后当我们查找 **O** 上没有的属性，JavaScript 引擎就会在 **P** 上寻找这个属性。

至此我们有两个问题：

1. 以上情况**函数**怎么玩？
2. 这些原型是从哪里来的？

### 名为 Object 的函数

在 JavaScript 引擎执行程序之前，它会创建一个环境让程序在内部执行，在执行环境中会创建一个函数，叫做 [Object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object), 以及一个关联对象，叫做 [Object.prototype](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/prototype)。

换句话说，`Object` 和 `Object.prototype` 在**任意**执行中的 JavaScript 程序中**永远**存在。

这个 `Object` 乍一看好像和其他函数没什么区别，但特别之处在于它是一个**构造器**——在调用它时返回一个新对象：

    "use strict";

    typeof new Object(); // "object"
    typeof Object();     // 这个 Object 函数的特点是不需要使用 new 关键字调用

这个 `Object.prototype` **对象**是个……对象。正如其他对象一样，它有属性。

![Object.prototype 上的属性](https://i.imgsafe.org/ebbd5e3.png)

关于 `Object` 和 `Object.prototype` 你需要知道以下几点：

1. `Object` **函数**有一个叫做 `.prototype` 的属性，指向一个对象（`Object.prototype`）；
2. `Object.prototype` **对象**有一个叫做 `.constructor` 的属性，指向一个函数（`Object`）。

实际上，这个总体方案对于 JavaScript 中的**所有**函数都是适用的。当我们创建一个函数——下文称作 `someFunction`——这个函数就会有一个属性 `.prototype`，指向一个叫做 `someFunction.prototype` 的对象。

与之相反，`someFunction.prototype` 对象会有一个叫做 `.contructor` 的属性，它的引用指回函数 `someFunction`。

    "use strict";

    function foo () {  console.log('Foo!');  }

    console.log(foo.prototype); // 指向一个叫 'foo' 的对象
    console.log(foo.prototype.constructor); // 指向 'foo' 函数

    foo.prototype.constructor(); // 输出 'Foo!' —— 仅为证明确实有 'foo.prototype.constructor' 这么个方法且指向原函数

需要记住以下几个要点：

1. 所有的函数都有一个属性，叫做 `.prototype`，它指向这个函数的关联对象。
2. 所有函数的原型都有一个属性，叫做 `.constructor`，它指向这个函数本身。
3. 一个函数原型的 `.constructor` 并非必须指向创建这个函数原型的函数……有点绕，我们等下会深入探讨一下。

设置**函数**的原型有一些规则，在开始之前，我们先概括设置对象原型的三个规则：

1. 『默认』规则；
2. 使用 `new` 隐式设置原型；
3. 使用 `Object.create` 显式设置原型。

### 默认规则

考虑下这段代码：

    "use strict";

    const foo = { status : 'foobar' };

十分简单，我们做的事儿就是创建一个叫 `foo` 的对象，然后给他一个叫 `status` 的属性。

然后 JavaScript 在幕后多做了点工作。当我们在字面上创建一个对象时，JavaScript 将对象的原型指向 `Object.prototype` 并设置其原型的 `.constructor` 指向 `Object`：

    "use strict";

    const foo = { status : 'foobar' };

    Object.getPrototypeOf(foo) === Object.prototype; // true
    foo.constructor === Object; // true

### 使用 `new` 隐式设置原型

让我们再看下之前调整过的 `Food` 例子。

    "use strict";

    function Food (name, protein, carbs, fat) {
        this.name    = name;
        this.protein = protein;
        this.carbs   = carbs;
        this.fat     = fat;
    }

现在我们知道**函数** `Food` 将会与一个叫做 `Food.prototype` 的**对象**关联。

当我们使用 `new` 关键字创建一个对象，JavaScript 将会：

1. 设置这个对象的原型指向我们使用 `new` 调用的函数的 `.prototype` 属性；
2. 设置这个对象的 `.constructor` 指向我们使用 `new` 调用到的构造函数。

```js
const tootsie_roll = new Food('Tootsie Roll', 0, 26, 0);

Object.getPrototypeOf(tootsie_roll) === Food.prototype; // true
tootsie_roll.constructor === Food; // true
```

这就可以让我们搞出下面这样的黑魔法：

    "use strict";

    Food.prototype.cook = function cook () {
        console.log(`${this.name} is cooking!`);
    };

    const dinner = new Food('Lamb Chops', 52, 8, 32);
    dinner.cook(); // 'Lamb Chops are cooking!'

### 使用 `Object.create` 显式设置原型

最后我们可以使用 `Object.create` 方法手工设置对象的原型引用。

    "use strict";

    const foo = {
        speak () {
            console.log('Foo!');
        }
    };

    const bar = Object.create(foo);

    bar.speak(); // 'Foo!'
    Object.getPrototypeOf(bar) === foo; // true

还记得使用 `new` 调用函数的时候，JavaScript 在幕后干了哪四件事儿吗？`Object.create` 就干了这三件事儿：

1. 创建一个新对象；
2. 设置它的原型引用；
3. 返回这个新对象。

[你可以自己去看下 MDN 上写的那个 polyfill。](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/create)
（译者注：polyfill 就是给老代码实现现有新功能的补丁代码，这里就是指老版本 JS 没有 `Object.create` 函数，MDN 上有手工撸的一个替代方案）

### 模拟 `class` 行为

直接使用原型来模拟面向类的行为需要一些技巧。

    "use strict";

    function Food (name, protein, carbs, fat) {
        this.name    = name;
        this.protein = protein;
        this.carbs   = carbs;
        this.fat     = fat;
    }

    Food.prototype.toString = function () {
        return `${this.name} | ${this.protein}g P :: ${this.carbs}g C :: ${this.fat}g F`;
    };

    function FatFreeFood (name, protein, carbs) {
        Food.call(this, name, protein, carbs, 0);
    }

    // 设置 "subclass" 关系
    // =====================
    // LINE A :: 使用 Object.create 手动设置 FatFreeFood's 『父类』.
    FatFreeFood.prototype = Object.create(Food.prototype);

    // LINE B :: 手工重置 constructor 的引用
    Object.defineProperty(FatFreeFood.constructor, "constructor", {
        enumerable : false,
        writeable  : true,
        value      : FatFreeFood
    });

在 Line A，我们需要设置 `FatFreeFood.prototype` 使之等于一个新对象，这个新对象的原型引用是 `Food.prototype`。如果没这么搞，我们的子类就不能访问『超类』的方法。

不幸的是，这个导致了相当诡异的结果：`FatFreeFood.constructor` 是 [Function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function)，而不是 `FatFreeFood`。为了保证一切正常，我们需要在 Line B 手工设置 `FatFreeFood.constructor`。

让开发者从使用原型对类行为笨拙的模仿中脱离苦海是 `class` 关键字的产生动机之一。它确实也提供了避免原型语法常见陷阱的解决方案。

现在我们已经探究了太多关于 JavaScript 的原型机制，你应该更容易理解 class 关键字让一切变得多么简单了吧！

## 深入探究下方法

现在我们已了解到 JavaScript 原型系统的必要性，我们将深入探究一下类支持的三种方法，以及一种特殊情况，以结束本文的讨论。

* 构造器；
* 静态方法；
* 原型方法；
* 一种**原型方法**的特殊情况：『标记方法』。

并非我提出的这三组方法，这要归功于 Rauschmayer 博士在 [探索 ES6](http://exploringjs.com/es6/ch_classes.html) 一书中的定义。

### 类构造器

一个类的 `constructor` 方法用于关注我们的初始化逻辑，`constructor` 方法有以下几个特殊点：

1. 只有在构造方法里，我们才可以调用父类的构造器；
2. 它在背后处理了所有设置原型链的工作；
3. 它被用作类的定义。

第二点就是在 JavaScript 中使用 `class` 的一个主要好处，我们来引用一下《探索 ES6》书里的 15.2.3.1 的标题：

> **子类的原型就是超类**

正如我们所见，手工设置非常繁琐且容易出错。如果我们使用 `class` 关键字，JavaScript 在内部会负责搞定这些设置，这一点也是使用 `class` 的优势。

第三点有点意思。在 JavaScript 中类仅仅是个函数——它等同于与类中的 `constructor` 方法。

    "use strict";

    class Food {
        // 和之前一样的类定义……
    }

    typeof Food; // 'function'

与一般把函数作为构造器的方式不同，我们不能不用 `new` 关键字而直接调用类构造器：

`const burrito = Food('Heaven', 100, 100, 25); // 类型错误`

这就引发了另一个问题：当我们**不用** `new` 调用函数构造器的时候发生了什么？

简短的回答是：对于任何没有显式返回的函数来说都是返回 `undefined`。我们只需要相信用我们构造函数的用户都会使用构造调用。这就是社区为何约定构造方法的首字母大写：提醒使用者要用 `new` 来调用。

    "use strict";

    function Food (name, protein, carbs, fat) {
        this.name    = name;
        this.protein = protein;
        this.carbs   = carbs;
        this.fat     = fat;
    }

    const fish = Food('Halibut', 26, 0, 2); // D'oh . . .
    console.log(fish); // 'undefined'

长一点的回答是：返回 `undefined`，除非你手工检测是否使用被 `new` 调用，然后进行自己的处理。

ES2015 引入了一个属性使得这种检测变得简单: `[new.target]`([https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new.target](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new.target)).

`new.target` 是一个定义在所有使用 `new` 调用的函数上的属性，包括类构造器。 当我们使用 `new` 关键字调用函数时，函数体内的 `new.target` 的值就是这个函数本身。如果函数没有被 `new` 调用，这个值就是 `undefined`。

    "use strict";

    // 强行构造调用
    function Food (name, protein, carbs, fat) {
        // 如果用户忘了手工调用一下
        if (!new.target)
            return new Food(name, protein, carbs, fat);

        this.name    = name;
        this.protein = protein;
        this.carbs   = carbs;
        this.fat     = fat;
    }

    const fish = Food('Halibut', 26, 0, 2); // 糟了，不过没关系！
    fish; // 'Food {name: "Halibut", protein: 20, carbs: 5, fat: 0}'

在 ES5 里用起来也还行：

    "use strict";

    function Food (name, protein, carbs, fat) {

        if (!(this instanceof Food))
            return new Food(name, protein, carbs, fat);

        this.name    = name;
        this.protein = protein;
        this.carbs   = carbs;
        this.fat     = fat;
    }

[MDN 文档](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new.target)讲述了 `new.target` 的更多细节，而且给有兴趣者[配上了 ES2015 规范作为参考](https://tc39.github.io/ecma262/#sec-built-in-function-objects)。规范里有关 [[Construct]] 的描述很有启发性。

### 静态方法

**静态方法**是构造方法自己的方法，**不能**被类的实例化对象调用。我们使用 `static` 关键字定义静态方法。

    "use strict";

    class Food {
         // 和之前一样……

         // 添加静态方法
         static describe () {
             console.log('"Food" 是一种存储了营养信息的数据类型');
         }
    }

    Food.describe(); // '"Food" 是一种存储了营养信息的数据类型'

静态方法与老式构造函数中直接属性赋值相似：

    "use strict";

    function Food (name, protein, carbs, fat) {
        Food.count += 1;

        this.name    = name;
        this.protein = protein;
        this.carbs   = carbs;
        this.fat     = fat;
    }

    Food.count = 0;
    Food.describe = function count () {
        console.log(`你创建了 ${Food.count} 个 food`);
    };

    const dummy = new Food();
    Food.describe(); // "你创建了 1 个 food"

### 原型方法

任何不是构造方法和静态方法的方法都是**原型方法**。之所以叫原型方法，是因为我们之前通过给构造函数的原型上附加方法的方式来实现这一功能。

    "use strict";

    // 使用 ES6：
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

    // 在 ES5 里：
    function Food  (name, protein, carbs, fat) {
        this.name = name;
        this.protein = protein;
        this.carbs = carbs;
        this.fat = fat;
    }

    // 『原型方法』的命名大概来自我们之前通过给构造函数的原型上附加方法的方式来实现这一功能。
    Food.prototype.toString = function toString () {
        return `${this.name} | ${this.protein}g P :: ${this.carbs}g C :: ${this.fat}g F`;
    };

    Food.prototype.print = function print () {
        console.log( this.toString() );
    };

应该说明，在方法定义时完全可以使用生成器。

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
        console.log(`Generator 的值是 ${ val }. `);
        //  Prints:
        //    Generator 的值是 0.
        //    Generator 的值是 1.
        //    Generator 的值是 2.
    }

### 标志方法

最后我们说说**标志方法**。这是一些名为 `Symbol` 值的方法，当我们在自定义对象中使用内置构造器时，JavaScript 引擎可以识别并使用这些方法。

[MDN 文档](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol)提供了一个 Symbol 是什么的简要概览：

> Symbol 是一个唯一且不变的数据类型，可以作为一个对象的属性标示符。

创建一个新的 symbol，会给我们提供一个被认为是程序里的唯一标识的值。这一点对于命名对象的属性十分有用：我们可以确保不会不小心覆盖任何属性。使用 Symbol 做键值也不是无数的，所以他们很大程度上对外界是不可见的（也不完全是，可以通过 [Reflect.ownKeys](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Reflect/ownKeys) 获得）

    "use strict";

    const secureObject = {
        // 这个键可以看作是唯一的
        [new Symbol("name")] : 'Dr. Secure A. F.'
    };

    console.log( Object.getKeys(superSecureObject) ); // [] -- 标志属性不太好获取    console.log( Reflect.ownKeys(secureObject) ); // [Symbol("name")] -- 但也不是完全隐藏的

对我们来讲更有意思的是，这给我们提供了一种方式来告诉 JavaScript 引擎使用特定方法来达到特定的目的。

所谓的『[众所周知的 Symbol](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol)』是一些特定对象的键，当你在定义对象中使用时他们时，JavaScript 引擎会触发一些特定方法。

这对于 JavaScript 来说有点怪异，我们还是看个例子吧：

    "use strict";

    // 继承 Array 可以让我们直观的使用 'length'
    // 同时可以让我们访问到内置方法，如
    // map、filter、reduce、push、pop 等
    class FoodSet extends Array {

        // foods 把传递的任意参数收集为一个数组
        // 参见：https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_operator
        constructor(...foods) {
            super();
            this.foods = [];
            foods.forEach((food) => this.foods.push(food))
        }

         // 自定义迭代器行为，请注意，这不是多么好用的迭代器，但是个不错的例子
         // 键名前必须写星号
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

         // 当我们的用户使用内置的数组方法，返回一个数组类型对象
         // 而不是 FoodSet 类型的。这使得我们的 FoodSet 可以被一些
         // 期望操作数组的代码操作
         static get [Symbol.species] () {
             return Array;
         }
    }

    const foodset = new FoodSet(new Food('Fish', 26, 0, 16), new Food('Hamburger', 26, 48, 24));

    // 当我们使用 for ... of 操作 FoodSet 时，JavaScript 将会使用
    // 我们之前用 [Symbol.iterator] 做键值的方法
    for (let food of foodset) {
        // 打印全部 food
        console.log( food );
    }

    // 当我们执行数组的 `filter` 方法时，JavaScript 创建并返回一个新对象
    // 我们在什么对象上执行 `filter` 方法，新对象就使用这个对象作为默认构造器来创建
    // 然而大部分代码都希望 filter 返回一个数组，于是我们通过重写 [Symbol.species]
    // 的方式告诉 JavaScript 使用数组的构造器
    const healthy_foods = foodset.filter((food) => food.name !== 'Hamburger');

    console.log( healthy_foods instanceof FoodSet ); //
    console.log( healthy_foods instanceof Array );

当你使用 `for...of` 遍历一个对象时，JavaScript 将会尝试执行对象的**迭代器**方法，这一方法就是该对象 `Symbol.iterator` 属性上关联的方法。如果我们提供了自己的方法定义，JavaScript 就会使用我们自定义的。如果没有自己制定的话，如果有默认的实现就用默认的，没有的话就不执行。

`Symbo.species` 更奇异了。在自定义的类中，默认的 `Symbol.species` 函数就是类的构造函数。当我们的子类有内置的集合（例如 `Array` 和 `Set`）时，我们通常希望在使用父类的实例时也能使用子类。

通过方法返回父类的实例**而不是**派生类的实例，使我们更能确保我们子类在大多数代码里的可用性。而 `Symbol.species` 可以实现这一功能。

如果不怎么需要这个功能就别费力去搞了。Symbol 的这种用法——或者说有关 Symbol 的全部用法——都还比较罕见。这些例子只是为了演示：

1. 我们**可以**在自定义类中使用 JavaScript 内置的特定构造器；
2. 用两个普通的例子展示了怎么实现这一点。


## 结论

ES2015 的 `class` 关键字**没有**带给我们 Java 里或是 SmallTalk 里那种『真正的类』。宁可说它只是提供了一种更加方便的语法来创建通过原型关联的对象，本质上没有什么新东西。

在我们的论述中我基本涵盖了 JavaScript 的原型机制，但还需要说一点：看一下 Kyle Simpson 的 [this 与对象原型](https://github.com/getify/You-Dont-Know-JS/tree/master/this%20%26%20object%20prototypes)一文可以对上面所述的进行一次全面的回顾，它的[附录 A](https://github.com/getify/You-Dont-Know-JS/blob/master/this%20&%20object%20prototypes/apA.md) 也与本文密切相关。

如果想了解 ES2015 类的有关细节，可以去看 Rauschmayer 博士的[探索 ES6：类](http://exploringjs.com/es6/ch_classes.html)。这正是我写本文的灵感来源。

最后如果你有什么问题，可以给我评论或者 [Twitter](https://twitter.com/PelekeS) 上艾特我。我会尽我所能回答每个人的问题。

你对 `class` 的感受是什么呢？喜欢、讨厌，还是毫无感觉？每个人都有自己的观点——在下面说出你的观点吧！
