> * 原文地址：[A minimal guide to ECMAScript Decorators: A short introduction to “decorators” proposal in JavaScript with basic examples and little bit about ECMAScript](https://itnext.io/a-minimal-guide-to-ecmascript-decorators-55b70338215e)
> * 原文作者：[Uday Hiwarale](https://itnext.io/@thatisuday?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-minimal-guide-to-ecmascript-decorators.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-minimal-guide-to-ecmascript-decorators.md)
> * 译者：[jonjia](https://github.com/jonjia)
> * 校对者：[coconilu](https://github.com/coconilu) [ssshooter](https://github.com/ssshooter)

# ECMAScript 修饰器微指南

## JavaScript「修饰器」提案简介，包含一些基本示例和 ECMAScript 的一些示例

![](https://cdn-images-1.medium.com/max/2000/1*CMwgpS7hFNgPqnz62gaBqA.png)

为什么标题是 **ECMAScript 修饰器**，而不是 **JavaScript 修饰器**？因为，[**ECMAScript**](https://en.wikipedia.org/wiki/ECMAScript) 是编写像 **JavaScript** 这种脚本语言的标准，它不强制 JavaScript 支持所有规范内容，JavaScript 引擎（不同浏览器使用不同引擎）不一定支持 ECMAScript 引入的功能，或者支持行为不一致。

可以将 ECMAScript 理解为我们说的**语言**，比如**英语**。那 JavaScript 就是一种方言，类似**英国英语**。方言本身就是一种语言，但它是基于语言衍生出来的。所以，ECMAScript 是烹饪/编写 JavaScript 的烹饪书，是否遵循其中所有成分/规则完全取决于厨师/开发者。

理论上来说，JavaScript 使用者应该遵循语言规范中所有规则（**开发者或许会疯掉吧**），但实际上新版 JavaScript 引擎很晚才会实现这些规则，开发者要确保一切正常后（才会切换）。**TC39** 也就是 ECMA 国际技术委员会第 39 号 负责维护 ECMAScript 语言规范。该团队的成员大多来自于 ECMA 国际、浏览器厂商和对 Web 感兴趣的公司。

由于 ECMAScript 是开放标准，任何人都可以提出新的想法或功能并对其进行处理。因此，新功能的提议将经历 4 个主要阶段，TC39 将参与此过程，直到该功能准备好发布。

```
+-------+-----------+----------------------------------------+  
| stage | name      | mission                                |  
+-------+-----------+----------------------------------------+  
| 0     | strawman  | Present a new feature (proposal)       |  
|       |           | to TC39 committee. Generally presented |  
|       |           | by TC39 member or TC39 contributor.    |  
+-------+-----------+----------------------------------------+  
| 1     | proposal  | Define use cases for the proposal,     |  
|       |           | dependencies, challenges, demos,       |  
|       |           | polyfills etc. A champion              |  
|       |           | (TC39 member) will be                  |  
|       |           | responsible for this proposal.         |  
+-------+-----------+----------------------------------------+  
| 2     | draft     | This is the initial version of         |  
|       |           | the feature that will be               |  
|       |           | eventually added. Hence description    |  
|       |           | and syntax of feature should           |  
|       |           | be presented. A transpiler such as     |  
|       |           | Babel should support and               |  
|       |           | demonstrate implementation.            |  
+-------+-----------+----------------------------------------+  
| 3     | candidate | Proposal is almost ready and some      |  
|       |           | changes can be made in response to     |  
|       |           | critical issues raised by adopters     |  
|       |           |  and TC39 committee.                   |  
+-------+-----------+----------------------------------------+  
| 4     | finished  | The proposal is ready to be            |  
|       |           | included in the standard.              |  
+-------+-----------+----------------------------------------+
```

现在（2018 年 6 月），**修饰器**提案正处于**第二阶段**，我们可以使用 `babel-plugin-transform-decorators-legacy` 这个 Babel 插件来转换它。在第二阶段，由于功能的语法会发生变化，因此不建议在生产环境中使用它。无论如何，修饰器都很优美，也有助于更快地完成任务。

从现在开始，我们要开始研究实验性的 JavaScript 了，因此你的 node.js 版本可能不支持这个新特性。所以我们需要使用 Babel 或 TypeScript 转换器。可以使用我准备的 [**js-plugin-starter**](https://github.com/thatisuday/js-plugin-starter) 插件来设置项目，其中包括了这篇文章中用到的插件。

* * *

要理解修饰器，首先需要了解 JavaScript 对象属性的**属性描述符**。 **属性描述符**是对象属性的一组规则，例如属性是**可写**还是**可枚举**。当我们创建一个简单的对象并向其添加一些属性时，每个属性都有默认的属性描述符。

```
var myObj = {  
    myPropOne: 1,  
    myPropTwo: 2  
};
```

`myObj`是一个简单的 JavaScript 对象，在控制台中如下所示：

![](https://cdn-images-1.medium.com/max/800/1*Y8y_yHAuU4e5qQ98328h9A.png)

现在，如果我们像下面那样将新值写入 `myPropOne` 属性，操作可以成功，我们可以获得更改后的值。

```
myObj.myPropOne = 10;  
console.log( myObj.myPropOne ); //==> 10
```

为了获取属性的属性描述符，我们需要使用 `Object.getOwnPropertyDescriptor(obj, propName)` 方法。这里 **Own** 的意思是只有 `propName` 属性是 `obj` 对象自有属性而不是在原型链上查找的属性时，才会返回 `propName` 的属性描述符。

```
let descriptor = Object.getOwnPropertyDescriptor(  
    myObj,  
    'myPropOne'  
);

console.log( descriptor );
```

![](https://cdn-images-1.medium.com/max/800/1*_hI_shyJTWzbDzxAZRG2cw.png)

`Object.getOwnPropertyDescriptor` 方法返回一个对象，该对象包含描述属性权限和当前状态的键。 `value` 表示属性的当前值，`writable` 表示用户是否可以为属性赋值，`enumerable` 表示该属性是否会出现在 `for in` 循环或 `for of` 循环或 `Object.keys` 等遍历方法中。`configurable` 表示用户是否有权更改**属性描述符**并更改 `writable` 和 `enumerable`。属性描述符还有 `get` 和 `set` 键，它们是获取值或设置值的中间件函数，但这两个是可选的。

要在对象上创建新属性或使用自定义描述符修改现有属性，我们使用 `Object.defineProperty` 方法。让我们修改 `myPropOne` 这个现有属性，`writable` 设置为 `false`，这会**禁止**向 `myObj.myPropOne` 写入值。


```
'use strict';

var myObj = {  
    myPropOne: 1,  
    myPropTwo: 2  
};

// 修改属性描述符  
Object.defineProperty( myObj, 'myPropOne', {  
    writable: false  
} );

// 打印属性描述符  
let descriptor = Object.getOwnPropertyDescriptor(  
    myObj, 'myPropOne'  
);  
console.log( descriptor );

// 设置新值  
myObj.myPropOne = 2;
```

![](https://cdn-images-1.medium.com/max/800/1*OA4CAoOYemieJ9lB5wmqCg.png)

从上面的报错中可以看出，`myPropOne` 属性是不可写入的。因此如果用户尝试给它赋予新值，就会抛出错误。

> 如果使用 `Object.defineProperty` 来修改现有属性的描述符，那**原始描述符**会被新的修改**覆盖**。`Object.defineProperty` 方法会返回修改后的 `myObj` 对象。

让我们看看如果将 `enumerable` 描述符键设置为 `false` 会发生什么。

```
var myObj = {  
    myPropOne: 1,  
    myPropTwo: 2  
};

// 修改描述符  
Object.defineProperty( myObj, 'myPropOne', {  
    enumerable: false  
} );

// 打印描述符  
let descriptor = Object.getOwnPropertyDescriptor(  
    myObj, 'myPropOne'  
);  
console.log( descriptor );

// 打印遍历对象  
console.log(  
    Object.keys( myObj )  
);
```

![](https://cdn-images-1.medium.com/max/800/1*Aa-unAIvyxiw3kGjIz4Ewg.png)

从上面的结果可以看出，我们在 `Object.keys` 枚举中看不到对象的 `myPropOne` 属性。

使用 `Object.defineProperty` 在对象上定义新属性并传递空 `{}` 描述符时，默认描述符如下所示：

![](https://cdn-images-1.medium.com/max/800/1*e3FZCJKiLjbMVJnFbHcKIg.png)

现在，让我们使用自定义描述符定义一个新属性，其中 `configurable` 键设置为 `false`。我们将 `writable` 保持为`false`、`enumerable` 为 `true`，并将 `value` 设置为 `3`。

```
var myObj = {  
    myPropOne: 1,  
    myPropTwo: 2  
};

// 设置新属性描述符  
Object.defineProperty( myObj, 'myPropThree', {  
    value: 3,  
    writable: false,  
    configurable: false,  
    enumerable: true  
} );

// 打印属性描述符
let descriptor = Object.getOwnPropertyDescriptor(  
    myObj, 'myPropThree'  
);  
console.log( descriptor );

// 修改属性描述符 
Object.defineProperty( myObj, 'myPropThree', {  
    writable: true  
} );
```

![](https://cdn-images-1.medium.com/max/800/1*QulK_GxuflHPaJ6X4UwqAA.png)

通过将 `configurable` 设置为 `false`，我们失去了更改  `myPropThree` 属性描述符的能力。如果不希望用户操作对象的行为，这将非常有用。

**get**（**getter**）和 **set**（**setter**）也可以在属性描述符中设置。但是当你定义一个 getter 时，也会带来一些牺牲。你根本不能在描述符上有**初始值**或 `value`，因为 getter 将返回该属性的值。你也不能在描述符上使用 `writable`，因为你的写操作是通过 setter 完成的，可以防止写入。看看 MDN 文档关于 [**getter**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/get) 和 [**setter**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/set)，或阅读[**这篇文章**](https://codeburst.io/javascript-object-property-attributes-ac012be317e2)，这里不需要太多解释。

> 可以使用带有两个参数的 `Object.defineProperties` 方法一次创建/更新多个属性描述符。第一个参数是**目标对象**，在其中添加/修改属性，第二个参数是一个对象，其中 `key` 为**属性名**，`value` 是它的**属性描述符**。此函数返回**目标对象。**

你是否尝试过使用 `Object.create` 方法来创建对象？这是创建没有原型或自定义原型对象最简单方法。它也是使用自定义属性描述符从头开始创建对象的更简单方法之一。

`Object.create` 方法具有以下语法：

```
var obj = Object.create( prototype, { property: descriptor, ... } )
```

这里 `prototype` 是一个对象，它将成为 `obj` 的原型。如果 `prototype` 是 `null`，那么 `obj` 将没有任何原型。使用 `var obj = {}` 语法定义空或非空对象时，默认情况下，`obj.__proto__` 指向 `Object.prototype`，因此 `obj` 具有 `Object`类的原型。

这类似于用 `Object.prototype` 作为第一个参数（**正在创建对象的原型**）使用 `Object.create` 方法 。

```
'use strict';

var o = Object.create( Object.prototype, {  
    a: { value: 1, writable: false },  
    b: { value: 2, writable: true }  
} );

console.log( o.__proto__ );  
console.log(   
    'o.hasOwnProperty( "a" ) =>  ',   
    o.hasOwnProperty( "a" )   
);
```

![](https://cdn-images-1.medium.com/max/800/1*Fc2_huyI1qxhEif4E9wHRw.png)

但当我们把 **prototype** 参数设置为 `null` 时，会出现下面的错误：

```
'use strict';

var o = Object.create( null, {  
    a: { value: 1, writable: false },  
    b: { value: 2, writable: true }  
} );

console.log( o.__proto__ );  
console.log(   
    'o.hasOwnProperty( "a" ) =>  ',   
    o.hasOwnProperty( "a" )   
);
```

![](https://cdn-images-1.medium.com/max/800/1*JOvcTkY5uzgrjlOBhz0QtQ.png)

* * *

#### ✱ 类方法修饰器

现在我们已经了解了如何定义/配置对象的新属性/现有属性，让我们把注意力转移到修饰器以及为什么讨论属性描述符上。

修饰器是一个 JavaScript 函数（**建议是纯函数**），它用于修改类属性/方法或类本身。当你在**类属性**、**方法**或**类本身**顶部添加 `@decoratorFunction` 语法后，`decoratorFunction` 方法会以一些参数**被调用**，然后**就可以使用这些参数来修改类或类属性了**。

让我们创建一个简单的 `readonly `修饰器函数。但在此之前，先创建一个包含 `getFullName` 方法简单的 `User` 类，这个方法通过组合 `firstName` 和 `lastName` 返回用户的全名。

```
class User {  
    constructor( firstname, lastName ) {  
        this.firstname = firstname;  
        this.lastName = lastName;  
    }

    getFullName() {  
        return this.firstname + ' ' + this.lastName;  
    }  
}

// 创建实例  
let user = new User( 'John', 'Doe' );  
console.log( user.getFullName() );
```

运行上面的代码，控制台中会打印出 `John Doe`。但这样有一个问题：任何人都可以修改 `getFullName` 方法。

```
User.prototype.getFullName = function() {  
    return 'HACKED!';  
}
```

经过上面的修改，就会得到以下输出：

```
HACKED!
```

为了限制修改我们任何方法的权限，需要修改 `getFullName` 方法的属性描述符，这个属性属于 `User.prototype` 对象。

```
Object.defineProperty( User.prototype, 'getFullName', {  
    writable: false  
} );
```

现在，如果还有用户尝试覆盖 `getFullName` 方法，他/她就会得到下面的错误。

![](https://cdn-images-1.medium.com/max/800/1*UVOaz8O1FoSa7KVpIBFMxA.png)

但如果 `User` 类有很多方法，上面这种手动修改就不太好了。这就是修饰器的用武之地了。通过在 `getFullName` 方法上添加 `@readonly` 也可以实现同样功能，如下：

```
function readonly( target, property, descriptor ) {  
    descriptor.writable = false;  
    return descriptor;  
}

class User {  
    constructor( firstname, lastName ) {  
        this.firstname = firstname;  
        this.lastName = lastName;  
    }

    @readonly  
    getFullName() {  
        return this.firstname + ' ' + this.lastName;  
    }  
}

User.prototype.getFullName = function() {  
    return 'HACKED!';  
}
```

看一下 `readonly` 函数。它接收三个参数。`property` 是属性/方法的名字，`target` 是这些属性/方法属于的对象（**就和 `User.prototype` 一样**），`descriptor` 是这个属性的描述符。在修饰器函数中，我们必须返回 `descriptor` 对象。这个修改后的 `descriptor` 会替换该属性原来的属性描述符。

修饰器写法还有另一种版本，类似 `@decoratorWrapperFunction( ...customArgs )` 这样。但这样写，`decoratorWrapperFunction` 函数应该返回一个 `decoratorFunction` 修饰器函数，它的使用和上面的例子相同。

```
function log( logMessage ) {
    // 返回修饰器函数
    return function ( target, property, descriptor ) {
        // 保存属性原始值，它是一个方法（函数）
        let originalMethod = descriptor.value;
        // 修改方法实现
        descriptor.value = function( ...args ) {
            console.log( '[LOG]', logMessage );
            // 这里，调用原始方法
            // `this` 指向调用实例
            return originalMethod.call( this, ...args );
        };
        return descriptor;
    }
}
class User {
    constructor( firstname, lastName ) {
        this.firstname = firstname;
        this.lastName = lastName;
    }
    @log('calling getFullName method on User class')
    getFullName() {
        return this.firstname + ' ' + this.lastName;
    }
}
var user = new User( 'John', 'Doe' );
console.log( user.getFullName() );
```

![](https://cdn-images-1.medium.com/max/800/1*sUHsV_OSQUSehgfblsYvRg.png)

修饰器不区分静态和非静态方法。下面的代码同样可以工作，唯一不同是你如何访问这些方法。这个结论也适用于我们下面要讨论的**类实例字段修饰器**。

```
@log('calling getVersion static method of User class')  
static getVersion() {  
    return 'v1.0.0';  
}

console.log( User.getVersion() );
```

* * *

#### ✱ **类实例字段修饰器**

目前为止，我们已经看到通过 `@decorator` 或 `@decorator(..args)` 语法来修改类方法的属性描述符，但如何修改 **公有/私有属性（类实例字段）**呢？

与 `typescript` 或 `java` 不同，JavaScript 类**没有**类实例字段或者说没有类属性。这是因为任何在 `class` 里面、`constructor` 外面定义的都属于类的**原型**。但也有一个新的[**提案**](https://github.com/tc39/proposal-class-fields)，它提议使用 `public` 和 `private` 访问修饰符来启用类实例字段，目前处于[第 3 阶段](https://github.com/tc39/proposals)，也可以通过 [**babel transformer plugin**](https://babeljs.io/docs/plugins/transform-class-properties/) 这个插件来使用它。

定义一个简单的 `User` 类，但这一次，不需要在构造函数中设置 `firstName` 和 `lastName` 的默认值。

```
class User {
    firstName = 'default_first_name';
    lastName = 'default_last_name';
    constructor( firstName, lastName ) {
        if( firstName ) this.firstName = firstName;
        if( lastName ) this.lastName = lastName;
    }
    getFullName() {
        return this.firstName + ' ' + this.lastName;
    }
}
var defaultUser = new User();
console.log( '[defaultUser] ==> ', defaultUser );
console.log( '[defaultUser.getFullName] ==> ', defaultUser.getFullName() );
var user = new User( 'John', 'Doe' );
console.log( '[user] ==> ', user );
console.log( '[user.getFullName] ==> ', user.getFullName() );
```

![](https://cdn-images-1.medium.com/max/800/1*44yA-f6PZURlQ-FOf4Vrww.png)

现在，如果查看 `User` 类的原型，你不会看到 `firstName` 和 `lastName` 这两个属性。

![](https://cdn-images-1.medium.com/max/800/1*pUvV2kP_Evs0JWbhYK-KFg.png)

**类实例字段**非常有用，还是面向对象编程（**OOP**）的重要组成部分。我们提出相应的提案很好，但故事远未结束。

与**类方法处于类的原型上**不同，**类实例字段处于对象/实例上**。由于类实例字段既不是类的一部分也不是它原型的一部分，因此操作它的描述符有点困难。Babel 为类实例字段的属性描述符提供了 `initializer` 方法来替代 `value`。为什么要用 `initializer` 方法来替代 `value` 呢？这个问题有些争议，因为修饰器提案还处于**第二阶段**，还没有发布最终草案来说明这个问题，但你可以通过查看 [**Stack Overflow 上这个答案**](https://stackoverflow.com/questions/31433630/does-the-es7-decorator-spec-require-descriptors-to-have-an-initializer-method) 来了解背景故事。

也就是说，让我们修改之前示例并创建简单的 `@upperCase` 修饰器函数，它会改变类实例字段默认值的大小写。

```
function upperCase( target, name, descriptor ) {
    let initValue = descriptor.initializer();
    descriptor.initializer = function(){
        return initValue.toUpperCase();
    }
    return descriptor;
}
class User {
    
    @upperCase
    firstName = 'default_first_name';
    
    lastName = 'default_last_name';
    constructor( firstName, lastName ) {
        if( firstName ) this.firstName = firstName;
        if( lastName ) this.lastName = lastName;
    }
    getFullName() {
        return this.firstName + ' ' + this.lastName;
    }
}
console.log( new User() );
```

![](https://cdn-images-1.medium.com/max/800/1*5_SX5itRYtBIojyjY7-wHQ.png)

我们也可以使用**带参数的修饰器函数**，让它更有定制性。

```
function toCase( CASE = 'lower' ) {
    return function ( target, name, descriptor ) {
        let initValue = descriptor.initializer();
    
        descriptor.initializer = function(){
            return ( CASE == 'lower' ) ? 
            initValue.toLowerCase() : initValue.toUpperCase();
        }
    
        return descriptor;
    }
}
class User {
    @toCase( 'upper' )
    firstName = 'default_first_name';
    lastName = 'default_last_name';
    constructor( firstName, lastName ) {
        if( firstName ) this.firstName = firstName;
        if( lastName ) this.lastName = lastName;
    }
    getFullName() {
        return this.firstName + ' ' + this.lastName;
    }
}
console.log( new User() );
```

`descriptor.initializer` 方法由 **Babel** 内部实现对象属性描述符的 `value` 的创建。它会返回分配给类实例字段的初始值。在修饰器函数内部，我们需要返回另一个 `initializer` 方法，它会返回最终值。

> 类实例字段提案具有高度实验性，在到达**第 4 阶段**前，它的语法很有可能会改变。因此，将类实例字段与修饰器一起使用还不是一个好习惯。

* * *

#### ✱ 类修饰器

现在我们已经熟悉了修饰器能做什么。它可以改变属性、类方法行为和类实例字段，使我们能灵活地通过简单的语法来实现这些。

**类修饰器**和我们之前看到的修饰器有些不同。之前，我们使用**属性修饰器**来修改属性或方法的实现，但类修饰器函数中，我们需要返回一个构造函数。

我们先来理解下什么是构造函数。在下面，一个 JavaScript 类只不过是一个函数，这个函数添加了**原型方法**、定义了一些初始值。

```
function User( firstName, lastName ) {
    this.firstName = firstName;
    this.lastName = lastName;
}
User.prototype.getFullName = function() {
    return this.firstName + ' ' + this.lastName;
}
let user = new User( 'John', 'Doe' );
console.log( user );
console.log( user.__proto__ );
console.log( user.getFullName() );
```

![](https://cdn-images-1.medium.com/max/800/1*8upRjd8kwXbOntVmrjvOqg.png)

> [这篇文章](https://blog.bitsrc.io/what-is-this-in-javascript-3b03480514a7) 对理解 JavaScript 中的 `this` 很有帮助。

因此，当我们调用 `new User` 时，就会使用传递的参数调用 `User` 这个函数，返回结果是一个对象。所以，`User` 就是一个构造函数。顺便说一句，JavaScript 中每个函数都是一个构造函数，因为如果你查看 `function.prototype`，你会发现 `constructor` 属性。只要我们使用 `new` 关键字调用函数，都会得到一个对象。

>如果从构造函数返回一个有效的 JavaScript 对象，那么就会使用这个对象，而不用 `this` 赋值创建新对象了。这将打破原型链，因为修改后的对象将不具有构造函数的任何原型方法。

考虑到这一点，让我们看看类修饰器可以做什么。类修饰器必须位于类的顶部，就像之前我们在方法名或字段名上看到的修饰器一样。这个修饰器也是一个函数，但它应该返回构造函数或类。

假设我有一个简单的 `User` 类如下：

```
class User {  
    constructor( firstName, lastName ) {  
        this.firstName = firstName;  
        this.lastName = lastName;  
    }  
}
```

这里的 `User` 类不包含任何方法。正如上面所说，类修饰器应该返回一个构造函数。

```
function withLoginStatus( UserRef ) {
    return function( firstName, lastName ) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.loggedIn = false;
    }
}
@withLoginStatus
class User {
    constructor( firstName, lastName ) {
        this.firstName = firstName;
        this.lastName = lastName;
    }
}
let user = new User( 'John', 'Doe' );
console.log( user );
```

![](https://cdn-images-1.medium.com/max/800/1*rM3KBl5wFGoMNkq3DDFrgg.png)

类修饰器函数会接收目标类 `UserRef`，在上面的示例中是 `User`（**修饰器的作用目标**）并且必须返回构造函数。这打开了使用修饰器无限可能性的大门。因此，类修饰器比方法/属性修饰器更受欢迎。

但是上面的例子太基础了，当我们的 `User` 类有大量的属性和原型方法时，我们不想创建一个新的构造函数。好消息是，我们在修饰器函数中可以引用类，即 `UserRef`。可以从构造函数返回新类，该类将扩展 `User` 类（`UserRef` 指向的类）。因为，类也是构造函数，所以下面的代码也是合法的。

```
function withLoginStatus( UserRef ) {
    return class extends UserRef {
        constructor( ...args ) {
            super( ...args );
            this.isLoggedIn = false;
        }
        setLoggedIn() {
            this.isLoggedIn = true;
        }
    }
}
@withLoginStatus
class User {
    constructor( firstName, lastName ) {
        this.firstName = firstName;
        this.lastName = lastName;
    }
}
let user = new User( 'John', 'Doe' );
console.log( 'Before ===> ', user );
// 设置为已登录
user.setLoggedIn();
console.log( 'After ===> ', user );
```

![](https://cdn-images-1.medium.com/max/800/1*uWCbna4Q89ZWCz5Xmv5Hdg.png)

* * *

你可以将多个修饰器放在一起，执行顺序和它们外观顺序一致。

* * *

修饰器是更快地达到目的的奇特方式。在它们正式加入 ECMAScript 规范之前，我们先期待一下吧。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
