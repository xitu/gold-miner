>* 原文链接 : [Private members in ES6 classes](https://gist.github.com/greim/44e54c2f23eab955bb73b31426e96d6c)
* 原文作者 : [Greg Reimer](https://github.com/greim)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [XRene](https://github.com/CommanderXL)
* 校对者:[narcotics726](https://github.com/narcotics726), [jingkecn](https://github.com/jingkecn)

# ECMAScript 6 里面的私有变量

“...让我们创建一个ES6的类吧，”你说。“再给它一个私有变量”

    class Foo {
      constructor(x) {
        this.x = x;
      }
      getX() {
        return this.x;
      }
    }

“拜托.”我白了一眼说。“变量x根本就不是私有的。全世界都还是可以对它进行读写操作！”

“我们可以给这个变量前面加个下划线,”你反驳道。“其他开发人员就再也不会使用这个变量了，因为它的声明方式很丑陋，下划线就能把大家都吓跑了”

    class Foo {
      constructor(x) {
        this._x = x;
      }
      getX() {
        return this._x;
      }
    }

“这种写法确实很丑陋,”我承认道,晃着杯底的咖啡蹙眉凝思并自以为然,“但是它仍然不是私有的，其他人一定还会去访问它。”

“那我们还可以这样干,”你反驳道,“我们可以设置它的属性为不可枚举。这样就没人能觉察到它了！”

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
“直到其他开发人员读了你的源码前，确实是这样的。”我摘下眼镜，默然的回答道。

“那我们还可以这样做!”你尴尬的笑道,但明显有些紧张地将目光投向屋里的其他人想寻求支持，但没人愿意跟你有任何眼神交流，“我们可以把所有私有变量塞到构造函数的闭包当中。大功告成！”

    class Foo {
      constructor(x) {
        this.getX = () => x;
      }
    }

“但是这么一来，”我以手扶额，无奈的争辩道,“每一个类的实例都会包含这个函数的副本。这样不仅效率低，同时也与预期不符:这个变量本应在存在于原型上。其他人也会应该感到困惑，到时候可就归咎于你了！”

“那好吧，”你就像抓住一根救命稻草一样说，“我们可以在定义类的函数外面，将私有变量用map存储起来，使用实例来作为键，这样可能就没人能获取到这个变量了吧?”

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

“但是现在这样会导致内存泄漏，”我洋洋自得的反驳道，好像已经嗅到了胜利的味道,“map始终维持着对于你所设定的实例的强引用，就算程序已经不再使用这个实例，但是它仍然被GC标记而存在于内存当中。”

“嗯...”你摸着自己的下巴，眨巴着眼睛说，“那我们就使用[WeakMap](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakMap)吧。”

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

我：满头大汗，无言以对。

  
