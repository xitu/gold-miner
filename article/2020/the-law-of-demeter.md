> * 原文地址：[The Law of Demeter](https://levelup.gitconnected.com/the-law-of-demeter-4bd40aa21cbe)
> * 原文作者：[Trung Anh Dang](https://medium.com/@dangtrunganh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/the-law-of-demeter.md](https://github.com/xitu/gold-miner/blob/master/article/2020/the-law-of-demeter.md)
> * 译者：[samyu2000](https://github.com/samyu2000)
> * 校对者：[jackwener](https://github.com/jackwener), [kaikanwu](https://github.com/kaikanwu)

# 迪米特法则

![the law of Demeter](https://cdn-images-1.medium.com/max/2800/1*Q2hIGRJoa-s-CNx9KpZPeQ.jpeg)

迪米特法则, 又称为 LoD 或最少知识原则。

* 每一个部件只需要有限地了解其他部件，而且只能是跟自身密切相关的部件；
* 每一个部件只能跟它的朋友交谈，不跟陌生人说话；
* 只跟直接的朋友交谈。

记住，这里的部件是指程序中的抽象元素，例如一个函数、一个模块或一个类。这里的交谈是指程序间的相互作用，例如调用其他模块的代码或其他模块调用自身代码。

学习并遵循这些法则来写程序，大有好处，但遗憾的是，程序员总是会忘记或忽略它们。这些法则更大程度上是关于降低代码的耦合性的指南，而不是原则。

我们都见过这样冗长的链式函数调用。

```java
obj.getX()
      .getY()
        .getZ()
          .doSomething();
```

像上述代码那样，我们讲诉任何事情前都要不断发问，对 doSomething() 函数的调用一直向外传播，直到执行了 getZ() 函数为止。这种链式调用方式与迪米特法则是背道而驰的。采用如下的方式，不是更好吗？

```java
obj.doSomething();
```

换句话说，我们应该这样理解：一个对象只能调用这些对象的方法：自身、自身的参数、自身创建的对象、与自身直接关联的组件对象、同类的对象。

下面，我们举个例子，定义两个类： Customer 和 CustomerWallet。

```java
public class Customer {
    
    ...

}

public class CustomerWallet {

    private float amount = 0;

    ...

}
```

调用自身及其参数。

```java
public class CustomerWallet {

    ...

    public void addMoney(float deposit) {
        this.amount += deposit;
    }

    public void takeMoney(float debit) {
       this.amount -= debit;
    }
}
```

现在，我们可以在任何对象或直接相关的组件对象中调用这些函数。

```java
public class Customer {
    
    private CustomerWallet wallet;
    public Customer() {
        this.wallet = new CustomerWallet();
    }

}
```

更进一步，我们再举个关于 Shopkeeper 对象和 Customer 对象交互的简单例子，这是一个不符合迪米特法则的例子。

```java
public class ShopKeeper {
    public void processPurchase(Product product, Customer customer){
        static price = product.price();
        customer.wallet.takeMoney(price);
        ...
      }

}
```

这段代码违背了迪米特法则。我们考虑这种交互在现实中的情况：营业员从顾客的口袋里拿出了钱包，接着打开钱包，在没有跟顾客进行任何互动的情况下直接拿走了钱。

显而易见，在现实生活中，营业员的这种做法是不符合常识的。店主是在超越自己的职权进行操作。顾客也有可能希望以其他的方式支付，甚至可能不用钱包。

在这里，营业员不应接触顾客的钱包，所以在代码中 ShopKeeper 对象也不该跟 CustomerWallet 直接交互。所以我们应当把代码改为：  

```java
public class ShopKeeper {
    public void processPurchase(Product product, Customer customer){
        static float price = product.price();
        customer.requestPayment(price);
        ...
    }

}

public class Customer {
    
    ...
    public requestPayment(float price) {
        ...
    }

}
```

在上述代码中， ShopKeeper 对象直接跟 Customer 对象交互，Customer 对象也只跟 CustomerWallet 对象交互，对应于现实生活中顾客拿出相应数额的钱款并交付给营业员的动作。

很简单吧？

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
