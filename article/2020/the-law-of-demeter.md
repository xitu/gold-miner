> * 原文地址：[The Law of Demeter](https://levelup.gitconnected.com/the-law-of-demeter-4bd40aa21cbe)
> * 原文作者：[Trung Anh Dang](https://medium.com/@dangtrunganh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/the-law-of-demeter.md](https://github.com/xitu/gold-miner/blob/master/article/2020/the-law-of-demeter.md)
> * 译者：
> * 校对者：

# The Law of Demeter

#### It often is forgotten or ignored 😔

![the law of Demeter](https://cdn-images-1.medium.com/max/2800/1*Q2hIGRJoa-s-CNx9KpZPeQ.jpeg)

The law of Demeter, known as LoD or the principle of least knowledge. This so-called law has three core ideas as follows.

* Each unit should have only limited knowledge about other units: only units “closely” related to the current unit.
* Each unit should only talk to its friends; don’t talk to strangers.
* Only talk to your immediate friends.

Keep in mind that a unit in this context is a specifically coded abstraction such as possibly a function, a module, or a class. And talking here means interfacing with, such as calling the code of another module or having that other module call your code.

It is very useful to learn and apply to your program but it is sad 😔 that it often is forgotten or ignored. This law is more of a guideline than a principle to help reduce coupling between components.

We’ve all seen long chain of functions like these.

```
obj.getX()
      .getY()
        .getZ()
          .doSomething();
```

We ask then ask before we tell anything. The call to doSomething() propagates outwards till it gets to Z. These long chains of queries violate something called the Law of Demeter. Wouldn’t it look better like as follows?

```
obj.doSomething();
```

In other words, we can understand this law: an object should only invoke methods of these kinds of objects as follows: itself, its parameters, any objects it creates, its direct component objects, objects of the same type.

Next, let’s take some simple examples of defining `Customer` and `CustomerWallet` class.

```
public class Customer {
    
    ...

}

public class CustomerWallet {

    private float amount = 0;

    ...

}
```

Invoke itself and its parameters.

```
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

It's okay to call methods on any objects we create or any directly held component objects.

```
public class Customer {
    
    private CustomerWallet wallet;
    public Customer() {
        this.wallet = new CustomerWallet();
    }

}
```

Looking further. We take a simplified version of an interaction between the Shopkeeper and the Customer may go wrong as follows.

```
public class ShopKeeper {
    public void processPurchase(Product product, Customer customer){
        static price = product.price();
        customer.wallet.takeMoney(price);
        ...
      }

}
```

It violates the laws of Demeter. We try to consider a real-life case of this interaction. The shopkeeper takes the wallet from the customer’s pocket and then proceeds to open the wallet and take the desired amount without in any way interacting with the customer directly.

It’s immediately obvious that this would never be a socially appropriate interaction in real life. In this case the shopkeeper is making assumptions outside of their remit. The customer may wish to pay using a different mechanism, or may not even have a wallet.

The shopkeeper here should not have knowledge of the customer’s wallet and so should not be talking to it. So, we should re-write our program as follows.

```
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

The `ShopKeeper` is now talking to the `Customer` directly. And the customer also will talk to their `CustomerWallet` instance, retrieving the desired amount and then handing it to the shopkeeper.

Easy, right?

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
