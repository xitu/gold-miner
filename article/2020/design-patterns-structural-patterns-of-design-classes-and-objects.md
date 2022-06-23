> * 原文地址：[Design Patterns: Structural Patterns of Design Classes and Objects](https://levelup.gitconnected.com/design-patterns-structural-patterns-of-design-classes-and-objects-79d58a6519b)
> * 原文作者：[Trung Anh Dang](https://medium.com/@dangtrunganh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/design-patterns-structural-patterns-of-design-classes-and-objects.md](https://github.com/xitu/gold-miner/blob/master/article/2020/design-patterns-structural-patterns-of-design-classes-and-objects.md)
> * 译者：[lhd951220](https://github.com/lhd951220)、[jaredliw](https://github.com/jaredliw)
> * 校对者：[PingHGao](https://github.com/PingHGao)、[jackwener](https://github.com/jackwener)、[finalwhy](https://github.com/finalwhy)

# 设计类和对象的结构型模式

![设计类和对象的结构型模式](https://cdn-images-1.medium.com/max/2730/1*ZQBbxCUNxO7McfVcgL7B3w.png)

> 适配器模式、装饰器模式、代理模式、信息专家、组合模式、桥接模式、享元模式、受保护变化和门面模式

结构性设计模式主要关注如何通过组合类与对象形成更大的结构。它们能让你在不重写或者不自定义代码的情况下创建系统，因为这些模式提高了系统的复用性和健壮性。

> 每一个模式都描述了一种在我们周围环境中反复出现的问题与解决此类问题的方案的核心。通过这样的方式，你可以反复地使用这些方案，而不需要重复相同的（寻找解决之道的）工作。—— **克里斯托弗·亚历山大**

本文将讨论以下几种设计模式和原则。

* 适配器模式
* 桥接模式
* 组合模式
* 装饰器模式
* 享元模式
* 门面模式
* 代理模式
* 信息专家
* 受保护变化

## 适配器（**A**dapter）、桥接（**B**ridge）、组合（**C**omposite）和装饰器（**D**ecorator）模式

### 适配器模式

**目的**

适配器模式是结构型设计模式，它能让具有**不兼容**接口的对象协同运作。

**解决方案**

它实现了一个客户端已知的接口，为客户端提供访问某一未知类的实例的访问途径。

* **`AdapterClient`**：客户端代码。
* **`Adapter`**：将调用转发到 `Adaptee` 类。
* **`Adaptee`**：需要被适配的旧代码。
* **`Target`**：支持的新接口。

![适配器模式](https://cdn-images-1.medium.com/max/2730/1*9hpD88w1qqsHPqHzDcNRlg.png)

**实际案例**

原电压是 220 V，需要适配到 100 V 才能运作。

![实际案例](https://cdn-images-1.medium.com/max/2730/1*gw2KaBMjy4x5k4FM1JRsRQ.png)

下面的代码会解决这个问题。它定义了一个 `HighVoltagePlug` （被适配者），一个 `Plug` 接口和一个 `AdapterPlug`（适配器）。

**`Target`**：Plug.java

```java
public interface Plug {
    public int recharge();
}
```

**`Adaptee`**：HighVoltagePlug.java

```java
public class HighVoltagePlug {
    public int recharge() {
        // 电压是 220 V
        return 220; 
    }
}
```

**`Adapter`**：AdapterPlug.java

```java
public class AdapterPlug implements Plug {
    @Override
    public int recharge() {
        HighVoltagePlug bigPlug = new HighVoltagePlug();
        int v = bigPlug.recharge();
        v = v - 120;
        return v;
    }
}
```

**`AdapterClient`**：AdapterClient.java

```java
public class AdapterClient {
    public static void main(String[] args) {
        HighVoltagePlug oldPlug = new HighVoltagePlug();
        System.out.println(plug.recharge() + " too much voltage");

        Plug newPlug = new AdapterPlug();
        System.out.println("Adapter into " + plug.recharge() + " voltage");
    }
}
```

**用例**

* 当你想要使用一个已经存在的类，但是它实现的接口与你的需求不匹配时。
* 当你想要创建一个可复用的类，且这个类需要与不相关或接口不兼容的类协同运作时。
* 必须在多个源之间进行接口转换的情况。

### 桥接模式

**目的**

它将复杂的组件分为两个既相互独立又相互关联的层次结构，分别是功能的**抽象**和内部的**实现**。

**解决方案**

下面的图展示了一个可行的桥接实现。

* **`Abstraction`**：这是抽象组件。
* **`Implementor`**：这是抽象的实现。
* **`RefinedAbstraction`**：这是精确化后组件。
* **`ConcreateImplementors`**：这些是具体的实现。

![桥接模式](https://cdn-images-1.medium.com/max/2730/1*fViusZWf4tVGdQ4BxBHilQ.png)

**实际案例**

不同的人（比如：男人、女人、男孩和女孩）会穿不同的衣服。

![桥接模式的实际案例](https://cdn-images-1.medium.com/max/2730/1*t-Omjr5bWSlEtwCtEBfzQA.png)

**`AbstractionImpl`**：Person.java

```java
public abstract class Person {
    protected String name;
    protected Clothing clothes;

    public Person(String name) {
        super();
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Clothing getClothes() {
        return clothes;
    }

    public void setClothes(Clothing clothes) {
        this.clothes = clothes;
    }
}
```

**`Implementor`**：Clothing.java

```java
public abstract class Clothing {
    protected String name;

    public Clothing(String name) {
        super();
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
```

**`ConcreteImplementor`**：Jacket.java

```java
public class Jacket extends Clothing {
    public Jacket(String name) {
        super(name);
    }
}
```

**`RefinedAbstraction`**：Woman.java

```java
public class Woman extends Person {
    public Woman(String name) {
        super(name);
    }

    @Override
    public void dress() {
        System.out.println(name + " wear " + clothes.getName());
    }
}
```

**`Client`**：BridgeClient.java

```java
public class BridgeClient {
    public static void main(String[] args) {
        Person woman = new Woman("Woman");

        Clothing jacket = new Jacket("Jacket");

        // 一个穿夹克的妇女
        woman.setClothes(jacket);
        woman.dress();
    }
}
```

**用例**

- 避免永久绑定抽象类和实现类。
- 抽象及其实现都应该可以通过子类进行扩展。
- 改变抽象中的实现不应该对客户端产生影响；也就是说，客户端的代码不必重新编译。

### 组合模式

**目的**

组合模式能让你创建复杂程度不同的树形结构，同时让结构中的每个元素在统一的接口下运作。

**解决方案**

组合模式通过树形结构将对象进行组合，以此来表现整个或部分的等级结构。

![组合模式](https://cdn-images-1.medium.com/max/2730/1*_qUxlkDYSv9MVdNEeVPuDw.png)

* **`Component`** 是对整个树形结构中各个组分的抽象。它定义了任何组分必须实现的接口。
* **`Leaf`** 是没有 `children` 属性的对象。他们实现了由 `Component` 接口描述的服务。
* **`Composite`** 存储子组件，并且实现了 `Component` 接口定义的方法。它通过委派子组件来实现 `Component` 接口中定义的方法。除此之外，它也提供了添加、删除和获取组件的方法。
* **`Client`** 使用组件接口来控制层级中的对象。

**实际案例**

组织中会有总经理；在总经理之下，还有经理；在经理之下，还有开发人员。现在，你可以设置一个树形结构，然后要求每个节点执行通用的操作，比如：`printStructure()`。

**`Component`**：IEmployee.java

```java
interface IEmployee {
    void printStructure();
    int getEmployeeCount();
}
```

**`Composite`**：CompositeEmployee.java

```java
class CompositeEmployee implements IEmployee {
    private int employeeCount = 0;
    private String name;
    private String dept;

    // 子对象的容器
    private List<IEmployee> controls;

    public CompositeEmployee(String name, String dept) {
        this.name = name;
        this.dept = dept;
        controls = new ArrayList<IEmployee>();
    }

    public void addEmployee(IEmployee e) {
        controls.add(e);
    }

    public void removeEmployee(IEmployee e) {
        controls.remove(e);
    }

    @Override
    public void printStructure() {
        System.out.println("\t" + this.name + " works in  " + this.dept);

        for (IEmployee e: controls) {
            e.printStructure();
        }
    }

    @Override
    public int getEmployeeCount() {
        employeeCount = controls.size();
        for (IEmployee e: controls) {
            employeeCount += e.getEmployeeCount();
        }
        return employeeCount;
    }
}
```

**`Leaf`**：Employee.java

```java
class Employee implements IEmployee {
    private String name;
    private String dept;
    private int employeeCount = 0;

    public Employee(String name, String dept) {
        this.name = name;
        his.dept = dept;
    }

    @Override
    public void printStructure() {
        System.out.println("\t\t" + this.name + " works in  " + this.dept);
    }

    @Override
    public int getEmployeeCount() {
        return employeeCount;
    }
}
```

**用例**

- 你想要表示对象的整个或部分层次结构。客户端（在访问时）可以忽略对象组合与独立对象之间的差异。
- 你可以将这个模式应用在具有任意复杂度等级的结构上。

### 装饰器模式

**目的**

装饰器模式能让你在**不改变对象外观和已有功能**的情况下添加和删除对象的功能。

**解决方案**

![装饰器模式](https://cdn-images-1.medium.com/max/2730/1*dMtzsvYbWYueZi2_1qQa-g.png)

它通过使用原始类的子类实例来将操作委托给原始对象，从而以对客户端透明的方式来改变一个对象的功能。

* **`Component`** 是对象的接口，可以动态添加功能。
* **`ConcreteComponent`** 定义了一个可以添加其他职责的对象。
* **`Decorator`** 保存了一个 `Component` 对象的引用，并且定义了一个符合 `Component` 接口的接口。
* **`ConcreteDecorator`** 通过添加状态或行为来扩展组件的功能。

**实际案例**

你已经拥有一个自己的房子。现在，你决定在这基础上修建额外的一个楼层。你也许希望更改新楼层的结构设计，而又不想对现有的结构造成影响。

**用例**

- 动态并且透明地为单个对象添加职责，而不影响其他对象。
- 当你想为之后可能会更改的对象添加职责时。
- 在无法通过静态子类进行扩展的情况。

## 享元（**F**lyweight）、门面（**F**arcade）和代理（**P**roxy）模式

### 享元模式

**目的**

享元模式通过共享对象来减少系统中低级且详细的对象。

**解决方案**

下面的图展示了从池（`pool`）中返回享元对象（`ConcreteFlyweight`）并对其进行操作（`doOperation()`）的流程；该方法需要一个外部状态参数（`extrinsicState`）。

* **`Client`**：客户端代码。
* **`FlyweightFactory`**：如果享元对象不存在则会创建；如果存在，则直接从池中返回。
* **`Flyweight`**：抽象享元对象。
* **`ConcreateFlyweight`**：享元对象，与同级对象共享状态。

![享元模式](https://cdn-images-1.medium.com/max/2730/1*71BoJ6z40DNVCHCKcPfcUw.png)

**实际案例**

这种用法的一个典型用例是文字处理器。在这个场景中，每一个字符都是一个享元对象，都共享了渲染所需的数据。因此，在文档中，只有有字符的位置会消耗额外的内存。

**用例**

当满足以下所有条件时，你应该使用享元模式。

* 应用程序中了使用大量的对象。
* 高储存成本（因对象数量过多）。
* 应用程序不依赖于对象标识。

### 门面模式

**目的**

门面模式为子系统中的一组接口提供了统一的接口。

**解决方案**

它定义了一个更高级的接口，使子系统更易于使用（因为接口只有一个）。

![门面模式](https://cdn-images-1.medium.com/max/2730/1*yXOdKZ9BnVZzjmLAgnXzHg.png)

**实际案例**

门面为子系统定义了一个统一的、高级的接口，使其更易于使用。举例来说，在订购商品时，消费者拨打服务热线并与客服通话。这时客服扮演了“门面”的角色，它提供了订单执行部门，结账部门和运输部门的接口。

**用例**

* 当你想为一个复杂的子系统提供一个简单的接口时。
* 当客户端与抽象类的实现之间存在很多依赖时。
* 当你想要为你的子系统分层时。

### 代理模式

代理模式有多种实现方式，其中属**远程代理**和**虚拟代理**最为常见。

**目的**

代理模式提供了一个替代对象或者占位对象，以此来控制对原始对象的访问。

**解决方案**

![代理模式](https://cdn-images-1.medium.com/max/2730/1*Nak08MGZrTUImZyG28zWUg.png)

**实际案例**

一个现实世界中的案例可以是一张支票或者一张银行卡；它们代理了我们的银行账户。它们可以用来代替现金，并在你需要时提供一种获取现金的方法。这正是代理模式的作用 —— **“控制和管理其保护对象的访问”**。

**用例**

当你需要比普通指针更通用或更复杂的对象引用时。

## GRASP 设计原则

GRASP 罗列并描述了 9 种分配职责的基本原则，本文仅对其中有关的两种进行讨论。

### 信息专家（Information Expert）

让我们看看看专家原则（或着信息专家原则）。这个原则很简单，但也非常重要。

**目的**

为对象分配职责的基本原则是什么？

**解决方案**

将职责分配给具有履行职责所需信息的类。

**实际案例**

以大富翁游戏为例。假设一个对象要引用一个给定名字的棋格。谁应该负责获取这个棋格的信息？

> 最有可能的选项是游戏棋盘，因为它是由一个个棋格组成的。

在这个场景中，棋盘是信息专家，它具有履行此职责所需要的全部信息。

**用例**

将设计模式中的对象视为你管理的工作人员。如果你要分配一个任务，你会把它分配给谁？

* 你会将任务分配给对这个任务拥有最多信息的人。
* 有时，任务的信息会散布在多个对象上；你可以通过对象之间的交流来完成任务，但通常完成任务的职责只在一个对象上。

### 保护变化（Protected Variations）

**目的**

如何设计对象、系统以及子系统才能避免其中的可变性和不稳定性对元素产生不良影响？

**解决方案**

识别可变和不稳定的点，分配职责并围绕这些点创建一个稳定的接口。

“不要跟陌生人交流”原则指出一个对象的方法应该仅给那些直接相关的对象发送信息。

> 相关阅读：[迪米特法则](https://github.com/xitu/gold-miner/blob/master/article/2020/the-law-of-demeter.md)

**实际案例**

数据封装、接口、多态性、间接引用和标准都基于受保护变化原则。

**用例**

受保护变化是一个根本原则；它推动着编程和设计中的大多数机制和模式，为数据、行为、硬件、软件及操作系统中的变化提供灵活性和保护。

## 总结

结构型设计模式以各种方式影响着应用。举例来说，适配器模式能让两个毫不相干的系统进行交流；门面模式能为用户提供一个简化的接口，同时不用移除系统中所有可用的选项。

设计结构并不难，你说是吧？

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
