> * 原文地址：[A minimal guide to ECMAScript Decorators: A short introduction to “decorators” proposal in JavaScript with basic examples and little bit about ECMAScript](https://itnext.io/a-minimal-guide-to-ecmascript-decorators-55b70338215e)
> * 原文作者：[Uday Hiwarale](https://itnext.io/@thatisuday?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-minimal-guide-to-ecmascript-decorators.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-minimal-guide-to-ecmascript-decorators.md)
> * 译者：
> * 校对者：

# A minimal guide to ECMAScript Decorators

## A short introduction to “decorators” proposal in JavaScript with basic examples and little bit about ECMAScript

![](https://cdn-images-1.medium.com/max/2000/1*CMwgpS7hFNgPqnz62gaBqA.png)

Why **ECMAScript Decorators** instead of **JavaScript Decorators** in the title? Because, [**ECMAScript**](https://en.wikipedia.org/wiki/ECMAScript) is a standard for writing scripting languages like **JavaScript**, it doesn’t enforce JavaScript to support all the specs but a JavaScript engine (_used by different browsers_) may or may not support a feature introduced in ECMAScript or support with little different behaviour.

Consider ECMAScript as **language** that you speak for example, **_English_**. Then JavaScript would be a **dialect** like **_British English_**. A dialect is a language itself but it is based on principals of the language it was derived from. So, ECMAScript is a cookbook for cooking/writing JavaScript and it’s upto the chef/developer to follow all ingredients/rules or not.

Generally, JavaScript adopters follow all the specifications written in language (_or developers will go crazy_) and ship it very late with the new version of JavaScript engine until they make sure that everything is working well. **TC39** or Technical Committee 39 at ECMA International is responsible for maintaining ECMAScript language specifications. Members of this team belongs to ECMA International, browser vendors and companies interested in web in general.

As ECMAScript is open standard, anybody can suggest new ideas or features and work on them. Hence, a proposal for new feature goes through 4 main stages and TC39 gets involved in this process until that feature is ready to be shipped.

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

Right now (_June 2018_), **Decorators** are in **stage 2** and we have Babel plugin to transpile decorators `babel-plugin-transform-decorators-legacy`. In stage 2, as syntax of the feature is subjected to change, it’s not recommended to use it in production as of now. In any case, decorators are beautiful and very useful to achieve things quicker.

From here on, we are working on experimental JavaScript, hence your node.js version might not support this feature. Hence, we need Babel or TypeScript transpiler to get started. Use [**js-plugin-starter**](https://github.com/thatisuday/js-plugin-starter) plugin to setup very basic project and I have added support for what we are going to cover in this article.

* * *

To understand decorators, we need to first understand what is a **property descriptor** of JavaScript object property. A **property descriptor** is a set of rules on an object property, like whether a property is **writable** or **enumerable**. When we create a simple object and add some properties to it, each property has default property descriptor.

```
var myObj = {  
    myPropOne: 1,  
    myPropTwo: 2  
};
```

`myObj` is a simple JavaScript object which looks like below in the console.

![](https://cdn-images-1.medium.com/max/800/1*Y8y_yHAuU4e5qQ98328h9A.png)

Now, if we write new value to `myPropOne` property like below, operation will be successful and we will get the changed value.

```
myObj.myPropOne = 10;  
console.log( myObj.myPropOne ); //==> 10
```

To get property descriptor of property, we need to use `Object.getOwnPropertyDescriptor(obj, propName)` method. **_Own_** here means return property descriptor of `propName` property only if that property belongs to the object `obj` and not on it’s prototype chain.

```
let descriptor = Object.getOwnPropertyDescriptor(  
    myObj,  
    'myPropOne'  
);

console.log( descriptor );
```

![](https://cdn-images-1.medium.com/max/800/1*_hI_shyJTWzbDzxAZRG2cw.png)

`Object.getOwnPropertyDescriptor` method returns an object with keys describing the permissions and current state of the property. `value` is the current value of the property, `writable` is whether user can assign new value to the property, `enumerable` is whether this property will show up in enumerations like `for in` loop or `for of` loop or `Object.keys` etc. `configurable` is whether user has permission to change **property descriptor** and make changes to `writable` and `enumerable`. Property descriptor also has `get` and `set` keys which are middleware functions to return value or update value, but these are optional.

To create new property on an object or update existing property with a custom descriptor, we use `Object.defineProperty`. Let’s modify an existing property `myPropOne` with `writable` set to `false`, which should **disable writes** to `myObj.myPropOne`.

```
'use strict';

var myObj = {  
    myPropOne: 1,  
    myPropTwo: 2  
};

// modify property descriptor  
Object.defineProperty( myObj, 'myPropOne', {  
    writable: false  
} );

// print property descriptor  
let descriptor = Object.getOwnPropertyDescriptor(  
    myObj, 'myPropOne'  
);  
console.log( descriptor );

// set new value  
myObj.myPropOne = 2;
```

![](https://cdn-images-1.medium.com/max/800/1*OA4CAoOYemieJ9lB5wmqCg.png)

As you can see from above error, our property `myPropOne` is not writable, hence if a user is trying to assign new value to it, it will throw error.

> If `Object.defineProperty` is updating existing property descriptor, then **original descriptor** will be **overridden** with new modifications. `Object.defineProperty` returns the original object `myObj` after changes.

Let’s see what will happen if we set `enumerable` descriptor key to `false`.

```
var myObj = {  
    myPropOne: 1,  
    myPropTwo: 2  
};

// modify property descriptor  
Object.defineProperty( myObj, 'myPropOne', {  
    enumerable: false  
} );

// print property descriptor  
let descriptor = Object.getOwnPropertyDescriptor(  
    myObj, 'myPropOne'  
);  
console.log( descriptor );

// print keys  
console.log(  
    Object.keys( myObj )  
);
```

![](https://cdn-images-1.medium.com/max/800/1*Aa-unAIvyxiw3kGjIz4Ewg.png)

As you can see from above result, we can’t see `myPropOne` property of the object in `Object.keys` enumeration.

When you define a new property on object using `Object.defineProperty` and pass empty `{}` descriptor, the default descriptor looks like below.

![](https://cdn-images-1.medium.com/max/800/1*e3FZCJKiLjbMVJnFbHcKIg.png)

Now, let’s define a new property with custom descriptor where `configurable` descriptor key is set to `false`. We will keep `writable` to `false` and `enumerable` to `true` with `value` set to `3`.

```
var myObj = {  
    myPropOne: 1,  
    myPropTwo: 2  
};

// modify property descriptor  
Object.defineProperty( myObj, 'myPropThree', {  
    value: 3,  
    writable: false,  
    configurable: false,  
    enumerable: true  
} );

// print property descriptor  
let descriptor = Object.getOwnPropertyDescriptor(  
    myObj, 'myPropThree'  
);  
console.log( descriptor );

// change property descriptor  
Object.defineProperty( myObj, 'myPropThree', {  
    writable: true  
} );
```

![](https://cdn-images-1.medium.com/max/800/1*QulK_GxuflHPaJ6X4UwqAA.png)

By setting `configurable` descriptor key to `false`, we lost ability to change descriptor of our property `myPropThree`. This is very helpful if you don’t want your users to manipulate recommended behaviour of an object.

**get** (_getter_) and **set** (_setter_) for a property can also be set in property descriptor. But when you define a getter, it comes with some sacrifices. You can not have a **initial value** or `value` key on the descriptor at all because getter will return the value of that property. You can not use `writable` key on descriptor as well, because your writes are done through the setter and you can prevent writes there. Have a look at MDN documentation of [**getter**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/get) and [**setter**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/set), or read [**this article**](https://codeburst.io/javascript-object-property-attributes-ac012be317e2) because they don’t need much explanation here.

> You can create and/or update multiple properties at once using `Object.defineProperties` which takes two arguments. First argument is **target object** on which properties has to be added/modified and second argument is object with `key` as **property name** and `value` as it’s **property descriptor**. This function returns the **target object.**

Have you tried `Object.create` function to create objects? This is the easiest way to create an Object with no or custom prototype. It is also one of the easier way to create Object from scratch with custom property descriptors.

`Object.create` function has following syntax.

```
var obj = Object.create( prototype, { property: descriptor, ... } )
```

Here `prototype` is an object which will be prototype of the `obj`. If `prototype` is `null`, then `obj` won’t have any prototype. When you define an empty or non-empty object with `var obj= {}` syntax, by default, `obj.__proto__` points to `Object.prototype` hence `obj` has prototype of `Object` class.

This is similar to using `Object.create` with `Object.prototype` as first argument (_prototype of object being created_).

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

But when we set **prototype** to `null`, we get below error.

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

#### ✱ Class Method Decorator

Now that we understood how we can define and configure new or existing properties of an object, let’s move our attention to decorators and why we discussed property descriptors at all.

Decorator is a JavaScript function (_recommended pure function_) which is used to modify class properties/methods or class itself. When you add `@decoratorFunction` syntax on the top of **class property**, **method** or **class** itself, `decoratorFunction` **gets called** with few arguments **which we can use to modify class or class properties**.

Let’s create a simple `readonly` decorator function. But before that, let’s create simple `User` class with `getFullName` method which returns full name of the user by combining `firstName` and `lastName`.

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

// create instance  
let user = new User( 'John', 'Doe' );  
console.log( user.getFullName() );
```

Above code prints `John Doe` to the console. But there is huge problem, anybody can modify `getFullName` method.

```
User.prototype.getFullName = function() {  
    return 'HACKED!';  
}
```

With this, now we get below result.

```
HACKED!
```

To avoid public access to override any of our methods, we need to modify property descriptor of `getFullName` method which lives on `User.prototype` object.

```
Object.defineProperty( User.prototype, 'getFullName', {  
    writable: false  
} );
```

Now, if any user is trying to override `getFullName` method, he/she will get below error.

![](https://cdn-images-1.medium.com/max/800/1*UVOaz8O1FoSa7KVpIBFMxA.png)

But if we have many methods on the `User` class, doing this manually won’t be so great. This is where decorator comes in. We can achieve same thing by putting `@readonly` syntax on top of `getFullName` method like below.

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

Have a look at `readonly` method. It accepts three arguments. `property` is name of the property/method which belongs to `target` object (_which is same as_ `_User.prototype_`) and `descriptor` is property descriptor for that property. From within a decorator function, we have to return the `descriptor` at any cost. This `descriptor` will replace existing property descriptor of that property.

There is another version of decorator syntax which goes like `@decoratorWrapperFunction( ...customArgs )`. But with this syntax, `decoratorWrapperFunction` should return a `decoratorFunction` which is same as used in previous example.

```
function log( logMessage ) {
    // return decorator function
    return function ( target, property, descriptor ) {
        // save original value, which is method (function)
        let originalMethod = descriptor.value;
        // replace method implementation
        descriptor.value = function( ...args ) {
            console.log( '[LOG]', logMessage );
            // here, call original method
            // `this` points to the instance
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

Decorators do not differentiate between `static` and `non-static` methods. Below code will work just fine, only thing will change is how you access the method. Same applies to **_Instance Field Decorators_** which we will see next.

```
@log('calling getVersion static method of User class')  
static getVersion() {  
    return 'v1.0.0';  
}

console.log( User.getVersion() );
```

* * *

#### ✱ **Class Instance Field Decorator**

So far, we have seen changing property descriptor of a method with `@decorator` or `@decorator(..args)` syntax, but what about **public/private properties** (_class instance fields_)?

Unlike `typescript` or `java`, JavaScript classes **do not have** class instance fields AKA class properties. This is because anything defined in the `class` and outside the `constructor` should belong to class **prototype**. But there is a new [**proposal**](https://github.com/tc39/proposal-class-fields) to enable class instance fields with `public` and `private` access modifiers, which is now in [**stage 3**](https://github.com/tc39/proposals) and we have [**babel transformer plugin**](https://babeljs.io/docs/plugins/transform-class-properties/) for it.

Let’s define a simple `User` class but this time, we don’t need to set default values for `firstName` and `lastName` from within the constructor.

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

Now, if you check `prototype` of `User` class, you won’t be able to see `firstName` and `lastName` properties.

![](https://cdn-images-1.medium.com/max/800/1*pUvV2kP_Evs0JWbhYK-KFg.png)

**Class instance fields** are very helpful and important part of Object Oriented Programming (**OOP**). It’s good that we have proposal for that but the story is far from over.

Unlike **class methods which lives on class prototype**, **class instance fields live on object/instance**. Since class instance field is neither part of the class nor it’s prototype, it’s little tricky to manipulate it’s descriptor. Babel gives us `initializer` function on property descriptor of class instance field instead of `value` key. Why `initializer` function instead of `value`, this topic is in debate and since `Decorators` are in **stage-2**, no final draft has been published to outline this but you can follow this answer on [**Stack Overflow**](https://stackoverflow.com/questions/31433630/does-the-es7-decorator-spec-require-descriptors-to-have-an-initializer-method) to understand the background story.

That being said, let’s modify our early example and create simple `@upperCase` decorator which will change case of class instance field’s default value.

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

We can also make use of **decorator function with parameters** to make it more customisable.

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

`descriptor.initializer` function is used internally by **Babel** to create `value` of property descriptor of an object property. This function returns the initial value assigned to class instance field. Inside decorator, we need to return another `initializer` function which returns final value.

> Class instance field proposal is highly experimental and there is a strong chance that it’s syntax might change until it goes to **stage-4**. Hence, it’s not a good practice to use class instance fields with decorators yet.

* * *

#### ✱ Class Decorator

Now we are familiar with what decorators can do. They can change properties and behaviour of class methods and class instance fields, giving us flexibility to dynamically achieve those things with simpler syntax.

**Class decorators** are little bit different that decorators we saw earlier. Previously, we used **property descriptor** to modify behaviour of a property or method, but in case of class decorator, we need to return a constructor function.

Let’s understand what a constructor function is. Underneath, a JavaScript class is nothing but a function which is used to add **prototype methods** and define some initial values for the fields.

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

> [Here is a great article](https://blog.bitsrc.io/what-is-this-in-javascript-3b03480514a7) to understand `_this_` in JavaScript.

So when we call `new User`, `User` function is invoked with arguments we passed and in return, we got an object. Hence, `User` is a constructor function. BTW, every function in JavaScript is a constructor function, because if you check `function.prototype`, you will get `constructor` property. As long as we are using `new` keyword with a function, we should expect an object in return.

> If you `return` a valid JavaScript Object from constructor function, then that value will be used instead of creating new object using `this` assignments. That will break the prototype chain though because retuned object won’t have any prototype methods of constructor function.

With that in mind, let’s focus what a class decorator can do. A class decorator has to be on the top of the class, like previously we have seen decorator on method name or field name. This decorator is also a function but it should return a constructor function instead or a class.

Let’s say I have a simple `User` class like below.

```
class User {  
    constructor( firstName, lastName ) {  
        this.firstName = firstName;  
        this.lastName = lastName;  
    }  
}
```

Our `User` class do not have any method at the moment. As discussed, a class decorator must return a constructor function.

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

A class decorator function will receive target class `UserRef`, which is `User` in above example (_on which decorator is applied_) and must return a constructor function. This opens the door of infinite possibilities that you can do with the decorator. Hence class decorators are more popular than method/property decorators.

But above example is too basic and we wouldn’t want to create a new constructor when our `User` class might have tons of properties and prototype methods. Good thing is, we have reference to the class from within the decorator function i.e. `UserRef`. We can return new class from constructor function and that class will extends `User` class (_more accurately_ `_UserRef_` _class_). Since, class is also a constructor function underneath, this is legal.

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
// set logged in
user.setLoggedIn();
console.log( 'After ===> ', user );
```

![](https://cdn-images-1.medium.com/max/800/1*uWCbna4Q89ZWCz5Xmv5Hdg.png)

* * *

You can chain multiple decorators together by placing on top of each other. The order of execution will be the same as order of their appearance.

* * *

Decorators are fancy way to achieve things faster. Wait for some time until they are added to ECMAScript specifications.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
