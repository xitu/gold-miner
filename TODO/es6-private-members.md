>* 原文链接 : [Private members in ES6 classes](https://gist.github.com/greim/44e54c2f23eab955bb73b31426e96d6c)
* 原文作者 : [Greg Reimer](https://github.com/greim)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : XRene
* 校对者:


_“让我们创建一个ES6的类吧，”你说。“并给它赋值一个私有变量”_

    class Foo {
      constructor(x) {
        this.x = x;
      }
      getX() {
        return this.x;
      }
    }

_“拜托.”我眨了眨眼说。“变量x根本就不是私有的。全局环境仍然可以获取并修改它！”_

_“我们可以给这个变量前面加个下划线,”你反驳道。“其他开发人员就再也不会使用这个变量了，因为它的声明方式很丑陋，把大家都吓跑了”_

    class Foo {
      constructor(x) {
        this._x = x;
      }
      getX() {
        return this._x;
      }
    }

_“虽然这种写法确实很丑陋,”我晃动杯子里的咖啡,紧皱自己的眉头,将眼神移向地面承认道,“但是这个_x仍然不是私有变量，全局环境仍然可以获得到它。”_

_“为了不让这个变量暴露在全局环境中,”你继续说到,“我们可以设置它的属性为不可枚举。这样就没人觉得它是暴露在全局环境中了！”_

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
“直到其他开发人员读了你的源码前，确实是这样的。”我摘下眼镜，面无表情的回答道。

_“接下来，我们为了让这个变量完全成为私有的，”你紧张的望向房间里其他的同事去寻求支持，但他们却不想和你有任何眼神交流，“我们可以把所有私有变量放置于构造函数的闭包当中。这样问题就能被解决了！”_

    class Foo {
      constructor(x) {
        this.getX = () => x;
      }
    }

_“但是现在，”我将手掌置于我的额头，争辩道,“每一个类的实例都有着个函数的副本。这样不仅效率低，同时也超出了我们的预期。大家都希望这个变量存在于原型对象上，当事实情况不是这样的时候，大家便会很困惑同时还会责备你！”_

_“那好吧，”你就像抓住一根救命稻草一样说，“我们可以在定义类的函数外面，将私有变量用map存储起来，使用实例来作为键，这样可能就没人能获取到这个变量了。”_

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

_“但是现在这样会导致内存泄漏，”我洋洋自得的反驳道，好像已经嗅到了胜利的味道,“map始终维持着对于你所设定的实例的强引用，就算程序已经不再使用这个实例，但是它仍然被GC标记而存在于内存当中。”_

_“嗯...”你摸着自己的下巴，眨巴着眼睛说，“那我们就使用[WeakMap](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakMap)吧。”_

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

我：无法反驳，满头盗汗。

  
