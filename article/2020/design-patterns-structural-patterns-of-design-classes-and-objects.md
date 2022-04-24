> * 原文地址：[Design Patterns: Structural Patterns of Design Classes and Objects](https://levelup.gitconnected.com/design-patterns-structural-patterns-of-design-classes-and-objects-79d58a6519b)
> * 原文作者：[Trung Anh Dang](https://medium.com/@dangtrunganh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/design-patterns-structural-patterns-of-design-classes-and-objects.md](https://github.com/xitu/gold-miner/blob/master/article/2020/design-patterns-structural-patterns-of-design-classes-and-objects.md)
> * 译者：[lhd951220](https://github.com/lhd951220)、[jaredliw](https://github.com/jaredliw)
> * 校对者：[PingHGao](https://github.com/PingHGao)、[jackwener](https://github.com/jackwener)

# 设计模式: 设计类和对象的结构性模式

![Structural patterns of design classes and objects](https://cdn-images-1.medium.com/max/2730/1*ZQBbxCUNxO7McfVcgL7B3w.png)

> 适配器，装饰器，代理，信息专家，组合，桥接，低耦合，享元，受保护变化和门面

结构性设计模式主要关注如何组合类与对象，以形成更大的结构。它们允许你在不重写或者自定义代码的情况下创建系统，因为这些模式给系统提供了良好的复用性和健壮性。

> 每一个模式都描述了在我们环境中反复发生的问题，然后描述了这些问题的解决方案的核心。通过这样的方式，你可以反复的使用这些解决方案，而不需要重复两次相同的工作。— **克里斯托佛·亚历山大**

有以下 10 种类型的结构型设计模式。

* 适配器模式
* 桥接模式
* 组合模式
* 装饰器模式
* 低耦合模式
* 享元模式
* 门面模式
* 代理模式
* 信息专家
* 受保护变化

## ABCD (适配器，桥接，组合，装饰器)

#### 适配器模式

**目的**

适配器模式是结构性设计模式，它允许具有**不兼容**接口的对象一起工作。

**解决方案**

它实现了一个客户端已知的接口，为客户端提供访问某一未知类的实例的访问途径。

* **AdapterClient**：客户端代码。
* **Adapter**：将调用转发到 adaptee 的适配器类。
* **Adaptee**：需要被适配的旧代码。
* **Target**：支持的新接口。

![adapter pattern](https://cdn-images-1.medium.com/max/2730/1*9hpD88w1qqsHPqHzDcNRlg.png)

**实际案例**

原始的电压是 220 V，然后需要适配到 100 V 来进行工作。

![a real-world example](https://cdn-images-1.medium.com/max/2730/1*gw2KaBMjy4x5k4FM1JRsRQ.png)

接下来的代码会解决这个问题。它定义了一个 `HighVoltagePlug` （被适配者），一个 `Plug` 接口（新接口），一个 `AdapterPlug`（适配器）。

**Target**: Plug.java

```java
public interface Plug {
    public int recharge();
}
```

**Adaptee**: HighVoltagePlug.java

```java
public class HighVoltagePlug{
    public int recharge() {
        // 电力是 220 V
        return 220; 
    }
}
```

**Adapter**: AdapterPlug.java

```java
public class AdapterPlug implements Plug {
    @Override
    public int recharge() {
        HighVoltagePlug bigplug = new HighVoltagePlug();
        int v = bigplug.recharge();
        v = v - 120;
        return v;
    }
}
```

**AdapterClient**: AdapterClient.java

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

当你想要使用一个已经存在的类，但是它实现的接口与你的需求并不匹配。

当你想要创建一个可复用的类并且这个类要与不相关的类进行合作，或者是一个无法确定的、不需要有兼容性接口的类。

必须在多个源之间进行接口转换的情况。

#### 桥接模式

**目的**

它将复杂的组件分为两个既相互独立又互相关联的继承层次结构，分别是功能的**抽象**和内置的**实现**。

**解决方案**

下面的图展示了一个可能的桥接实现。

* **Abstraction**：这是抽象组件。
* **Implementor**：这是抽象的实现。
* **RefinedAbstraction**：这是优化的组件。
* **ConcreateImplementors**：这些是具体的实现。

![bridge pattern](https://cdn-images-1.medium.com/max/2730/1*fViusZWf4tVGdQ4BxBHilQ.png)

**实际案例**

不同的人群，比如：男人、女人、男孩、女孩，会穿不同的衣服。

![a real-world example](https://cdn-images-1.medium.com/max/2730/1*t-Omjr5bWSlEtwCtEBfzQA.png)

**AbstractionImpl**: Person.java

```java
public abstract class Person {

    protected String name;
    protected Clothing cloth;

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

    public Clothing getCloth() {
        return cloth;
    }

    public void setCloth(Clothing cloth) {
        this.cloth = cloth;
    }
}
```

**Implementor**: Clothing.java

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

**ConcreateImplementor**: Jacket.java

```java
public class Jacket extends Clothing {

    public Jacket(String name) {
        super(name);
    }
}
```

**RefinedAbstraction**: Woman.java

```java
public class Woman extends Person {
    
    public Woman(String name) {
        super(name);
    }

    @Override
    public void dress() {
        System.out.println(name + " wear " + cloth.getName());
    }
}
```

**Client**: BridgeClient.java

```java
public class BridgeClient {
    public static void main(String[] args) {

        Person woman = new Woman("Woman");

        Clothing jacket = new Jacket("Jacket");

        // 一个穿夹克的妇女
        woman.setCloth(jacket); 
        woman.dress();
    }
}
```

**用例**

避免将抽象和它的实现永久绑定。

抽象和它们的实现应该使用子类来扩展。

改变抽象中的实现不应该对客户端产生影响；也就是说，你不能要求客户端重新编译。

#### 组合模式

**目的**

组合模式使得你可以创建复杂程度不同的层次树结构，同时允许结构中的每个元素使用统一的接口进行操作。

**解决方案**

组合模式通过树结构将对象进行组合，以此来表现整个或部分等级结构。

![composite pattern](https://cdn-images-1.medium.com/max/2730/1*_qUxlkDYSv9MVdNEeVPuDw.png)

* **Component** 是叶子节点和组合节点的抽象。它定义相关接口，组合节点里面的对象必须实现这些接口。
* **Leaves** 是没有 children 属性的对象。他们实现了由 Component 接口描述的服务。
* **Composite** 存储子组件，并且实现了 Component 接口定义的方法。复合组件通过委派给子组件来实现 Component 接口中定义的方法。除此之外，复合组件提供额外的添加、删除、获取节点的方法。
* **Client** 使用组件接口来控制层级中的对象。

**实际案例**

在一个组织中，它有总经理；在总经理之下，还有管理者；在管理者之下，还有开发人员。现在，你可以设置一个树结构，然后要求每个节点执行通用的操作，比如：`printStructures()`。

**Component**: IEmployee.java

```java
interface IEmployee {
    
    void printStructures();
    int getEmployeeCount();

}
```

**Composite**: CompositeEmployee.java

```java
class CompositeEmployee implements IEmployee {

    private int employeeCount=0;
    private String name;
    private String dept;

    // 子对象的容器
    private List<IEmployee> controls;

    public CompositeEmployee(String name, String dept){

        this.name = name;
        this.dept = dept;
        controls = new ArrayList<IEmployee>();

    }

    public void addEmployee(IEmployee e){

        controls.add(e);

    }

    public void removeEmployee(IEmployee e){

        controls.remove(e);

    }

    @Override
    public void printStructures(){

        System.out.println("\t" + this.name + " works in  " + this.dept);

        for(IEmployee e: controls){
            e.printStructures();
        }

    }

    @Override
    public int getEmployeeCount(){
        employeeCount=controls.size();
        for(IEmployee e: controls){
            employeeCount+=e.getEmployeeCount();
        }
        return employeeCount;
    }

}
```

**Leaf**: Employee.java

```java
class Employee implements IEmployee{

    private String name;
    private String dept;
    private int employeeCount=0;

    public Employee(String name, String dept){

        this.name = name;
        his.dept = dept;

    }

    @Override
    public void printStructures(){
        System.out.println("\t\t"+this.name + " works in  " + this.dept);
    }

    @Override
    public int getEmployeeCount(){
        return employeeCount;

    }

}
```

**用例**

你想要表示对象的整个或部分层次结构，使得客户端可以忽略不同组合对象以及某个组合对象中各个组件之间的区别。

你可以将这个模式应用在具有任意复杂度等级的结构上。

#### 装饰器模式

**目的**

装饰器模式允许你为对象添加和删除功能，而不需要改变对象的外观和已有功能。

**解决方案**

![decorator pattern](https://cdn-images-1.medium.com/max/2730/1*dMtzsvYbWYueZi2_1qQa-g.png)

它通过使用原始类的子类实例来将操作委托给原始对象，从而改变一个对象的功能且对客户端不产生任何影响。

* **Component** 是对象的接口，可以动态添加功能。
* **ConcreteComponent** 定义了一个可以添加其他功能的对象。
* **Decorator** 保存了一个 Component 对象的引用，并且定义了一个接口，以此来适应 Component 的接口。
* **ConcreteDecorators** 通过添加状态或者添加行为来扩展组件的功能。

**实际案例**

你已经拥有一个自己的房子。现在，你决定在这基础上修建额外的一个楼层。你也许希望更改新楼层的结构设计，而又不想对现有的结构造成影响，比如不想更改底层的结构或已存在楼层的结构。

**用例**

动态并且透明的为单个对象添加功能，而不影响其他对象。

你想要为对象添加功能，并且也许该功能在未来需要变更。

无法通过静态子类进行扩展的情况。

## F2P (享元，门面，代理)

#### 享元模式

**目的**

享元模式通过共享对象来减少系统中低级、详细的对象。

**解决方案**

下面的图展示了从池中返回的享元对象，，它需要将外部状态作为参数传递。

* **Client**：客户端代码。
* **FlyweightFactory**：如果轻量级对象不存在则会创建，如果存在，则直接从池中返回。
* **Flyweight**：抽象轻量级对象。
* **ConcreateFlyweight**：轻量级对象设计为与同级对象共享状态。

![flyweight pattern](https://cdn-images-1.medium.com/max/2730/1*71BoJ6z40DNVCHCKcPfcUw.png)

**实际案例**

这种用法的一个典型用例是文字处理器。在文字处理器中，每一个字符都是一个共享了需要被渲染的数据的轻量级对象。结果是，在文档中，只有有字符的位置会消耗额外的内存。

**用例**

当以下条件都满足的时候，你就应该使用享元模式。

* 应用程序中大量使用的对象。
* 因为大量的对象消耗了大量的内存。
* 应用程序不依赖于对象标识。

#### 门面模式

**目的**

门面模式为子系统中的一组接口提供了统一的接口。

**解决方案**

它定义了一个更高级别的接口，以此使得子系统易于使用，因为你只拥有一个接口。

![facade pattern](https://cdn-images-1.medium.com/max/2730/1*yXOdKZ9BnVZzjmLAgnXzHg.png)

**实际案例**

门面为子系统定义了一个统一的、高级别的接口，使其更易于使用。消费者通过目录进行订购时会遇到一个门面。消费者会拨打一个电话与客户服务代表进行通话。客户服务代表就是扮演了一个门面的角色，它提供了订单执行部门，计费部门，运输部门的接口。

**用例**

当你想为一个复杂的子系统提供一个简单的接口。

如果客户端与抽象类的实现存在很多依赖。

当你想要为你的子系统分层。

#### 代理模式

代理模式拥有多个不同类型的实现，远程代理和虚拟代理是最常见的。

**目的**

代理模式提供了一个替代对象或者占位符对象，以此来控制原始对象的访问。

**解决方案**

![proxy pattern](https://cdn-images-1.medium.com/max/2730/1*Nak08MGZrTUImZyG28zWUg.png)

**实际案例**

一个现实世界的案例可以是一张支票或者一张银行卡，它们代理我们在银行的账户。它可以代替现金，当我们需要现金的时候，可以提供一种访问方式。 这正是代理模式的作用 — “控制和管理其保护对象的访问”。

**用例**

与简单指针相比，你需要一个对对象更通用、更高级的引用。

## GRASP 模式

GRASP 命名并描述了分配职责的基本原则。

#### 信息专家

我们来看专家模式（或者信息专家模式）。这一模式非常简单，但是至今都很重要。

**目的**

为对象分配职责的基本原则是什么？

**解决方案**

将职责分配给一个拥有履行一个职责所必需信息的类。

**实际案例**

以大富翁游戏为例。假设一个对象要引用一个给定名字的棋格。谁能知道通过名称得知这个棋格的信息？

> 最有可能的选项是游戏的棋盘，因为它是由一个个棋格组成的。

因为棋盘是由棋格组成的，它是生成特定的棋格并给予它名字最合适的对象——棋盘是信息专家，它具有履行此职责所需要的全部信息。

**用例**

将设计模型中的对象视为您管理的工作人员。如果您要分配任务，您将任务分配给谁？

* 你将任务分配给对这个任务拥有最多信息的人。
* 有时，任务的信息会散布在多个对象上，并且通过数条信息进行交互以完成工作，但是通常只有一个对象负责完成任务。

#### 受保护变化

**目的**

如何设计对象、子系统以及系统，才能让里面的可变和不稳定元素不会对其他元素产生不良影响？

**解决方案**

预测可变和不稳定的确定点，分配职责以围绕它们创建一个稳定的接口。

“不要跟陌生人交流” 原则，指出一个对象的方法应该仅给那些直接相关的对象发送信息。

相关的阅读：[迪米特法则](https://github.com/xitu/gold-miner/blob/master/article/2020/the-law-of-demeter.md)

**实际案例**

数据封装，接口，多态性，间接性和标准都是受保护变化的动机。

**用例**

受保护的变化是一个根本原则，它激励着编程和设计中的大多数机制和模式，为数据，行为，硬件，软件，操作系统等中的变化提供灵活性和保护。

## 总结

结构性模式以各种方式影响着应用，比如，适配器模式允许两个不相干的系统进行交流，门面模式允许你提供一个简单的接口给用户而不用移除系统中所有可用的选项。

很简单，对吧？

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
