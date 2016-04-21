>* 原文链接 : [Private members in ES6 classes](https://gist.github.com/greim/44e54c2f23eab955bb73b31426e96d6c)
* 原文作者 : [Greg Reimer](https://github.com/greim)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


_“Let’s create an ES6 class!”_ you say. _“Let’s give it a private variable `x`.”_

    class Foo {
      constructor(x) {
        this.x = x;
      }
      getX() {
        return this.x;
      }
    }

_“Please.”_ I respond, rolling my eyes. _“That `x` variable isn’t REALLY private. It’s right there for the whole world to read and write!”_

_“We’ll just prepended it with an underscore,”_ you retort. _“People will never use it because it’s ugly and that underscore will scare them off!”_

    class Foo {
      constructor(x) {
        this._x = x;
      }
      getX() {
        return this._x;
      }
    }

_“It is ugly,”_ I concede, furrowing my brow and looking down as I swirl the coffee in the bottom of my glass while taking on an air of troubled superiority, _“but it still isn’t private, and they WILL use it.”_

_“Well then we can just fly it in under the radar,”_ you counter. _“We’ll make it not be enumerable. Nobody will suspect it’s there!”_

    class Foo {
      constructor(x) {
        Object.defineProperty(this, 'x', {
          value: x,
          enumerable: false,
        });
      }
      getX() {
        return this.x;
      }
    }

[Setting my glass down] _“That is, until they read the source code,”_ I reply, deadpan.

_“We’ll keep it truly private, then,”_ you chortle nervously, looking at others in the room for support, all of whom refuse to make eye contact. _“We’ll just keep everything hidden inside the constructor’s closure. Problem solved!”_

    class Foo {
      constructor(x) {
        this.getX = () => x;
      }
    }

_“But now,”_ I argue, raising my palm to my forehead, _“every instance of that class has a duplicate copy of that function. Not only is it less efficient, but it breaks expectations. People expect it to exist on the prototype, and when it doesn’t, they’ll be confused and blame you!”_

_“Okay then,”_ you say, grasping at straws, _“we’ll store it outside the class in a map, keyed by instances, where nobody can reach it, maybe?”_

    const __ = new Map();

    class Foo {
      constructor(x) {
        __.set(this, { x });
      }
      getX() {
        var { x } = __.get(this);
        return x;
      }
    }

_“But now you have a memory leak,”_ I refute triumphantly, smelling victory. _“That map keeps STRONG references to every class instance you put in it, thus retaining it in memory by creating a referential backpath to a GC root, well after the app has finished using it!”_

_“Hmmm…”_ you wonder, stroking your chin and narrowing your eyes. _“Then we’ll just make it a [WeakMap](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakMap).”_

    const __ = new WeakMap();

    class Foo {
      constructor(x) {
        __.set(this, { x });
      }
      getX() {
        var { x } = __.get(this);
        return x;
      }
    }

Me: _Has no rebuttal. Sweats profusely_.

  
