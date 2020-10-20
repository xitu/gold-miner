> * 原文地址：[Design Patterns: Structural Patterns of Design Classes and Objects](https://levelup.gitconnected.com/design-patterns-structural-patterns-of-design-classes-and-objects-79d58a6519b)
> * 原文作者：[Trung Anh Dang](https://medium.com/@dangtrunganh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/design-patterns-structural-patterns-of-design-classes-and-objects.md](https://github.com/xitu/gold-miner/blob/master/article/2020/design-patterns-structural-patterns-of-design-classes-and-objects.md)
> * 译者：[lhd951220](https://github.com/lhd951220)
> * 校对者：

# 设计模式: 设计类和对象的结构性模式

![Structural patterns of design classes and objects](https://cdn-images-1.medium.com/max/2730/1*ZQBbxCUNxO7McfVcgL7B3w.png)

> 适配器，装饰器，代理，信息专家，组合，桥接，低耦合，亨元，受保护变化和门面

结构性设计模式主要关注如何组合类与对象，以形成更大的结构。它们允许你在不重写或者自定义代码的情况下创建系统，因为这些模式给系统提供了增强的复用性和强大的功能。

> 每一个模式都描述了在我们环境中反复发生的问题，然后描述了这些问题的解决方案的核心，通过这样的方式，你可以频繁的使用这些解决方案，而不需要使用相同的方式执行两次。— **克里斯托佛·亚历山大**

有以下 10 种类型的结构型设计模式。

* 适配器模式
* 桥接模式
* 组合模式
* 装饰器模式
* 低耦合模式
* 亨元模式
* 门面模式
* 代理模式
* 信息专家
* 受保护变化

## ABCD (适配器，桥接，组合，装饰器)

#### 适配器模式

**目的**

适配器模式是结构性设计模式，它允许具有**不兼容**接口的对象一起工作。

**解决方案**

它实现了一个客户端已知的接口，然后提供一个客户端未知的类实例的访问。

* **AdapterClient**：客户端代码。
* **Adapter**：将调用转发到 adaptee 的适配器类。
* **Adaptee**：需要被适配的旧代码。
* **Target**：支持的新接口。

![adapter pattern](https://cdn-images-1.medium.com/max/2730/1*9hpD88w1qqsHPqHzDcNRlg.png)

**现实世界案例**

原始的电压是 220V，然后需要适配到 100V 来进行工作。

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
        // 电力是 220V
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

当你想要使用一个已经存在的类，但是它实现的接口并不匹配你需要的接口。

当你想要创建一个可复用的类并且这个类要与不相关的类进行合作，或者是一个无法确定的类，这个类不需要有兼容性的接口。

必须在多个源之间进行接口转换的地方。

#### 桥接模式

**目的**

它将复杂的组件分为两部分但具有相关的继承层次结构，这两部分是功能的**抽象**和内置的**实现**。

**解决方案**

下面的图展示了一个可能的桥接实现。

* **Abstraction**： 这是抽象组件。
* **Implementor**： 这是抽象的实现。
* **RefinedAbstraction**： 这是精致的组件。
* **ConcreateImplementors**： 这些是具体的实现。

![bridge pattern](https://cdn-images-1.medium.com/max/2730/1*fViusZWf4tVGdQ4BxBHilQ.png)

**现实世界案例**

不同的人可以穿不同的衣服，比如：男人、女人、男孩、女孩。

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

        // 一个妇女穿夹克
        woman.setCloth(jacket); 
        woman.dress();
    }
}
```

**用例**

避免将抽象和它的实现永久绑定。

抽象和它们的实现应该使用子类来扩展。

改变抽象中的实现不应该对客户端产生影响；也就是说，你不能重新编译客户端的代码。

#### 组合模式

**目的**

当你允许结构中的每一个元素都有统一的接口进行操作，组合模式可以使你创建具有变化复杂性的阶级式树结构。

**解决方案**

组合模式通过树结构将对象进行组合，以此来表现整个等级结构或部分等级结构。

![composite pattern](https://cdn-images-1.medium.com/max/2730/1*_qUxlkDYSv9MVdNEeVPuDw.png)

* The **Component** is the abstraction for leaves and composites. It defines the interface that must be implemented by the objects in the composition.
* **Leaves** are objects that have no children. They implement services described by the Component interface.
* The **Composite** store child components in addition to implementing methods defined by the component interface. Composites implement methods defined in the Component interface by delegating to child components. In addition, composites provide additional methods for adding, removing, as well as getting components.
* The **Client** manipulates objects in the hierarchy using the component interface.

**现实世界案例**

在一个组织中，它有总经理，在总经理之下，他们可以是管理者，在管理者之下，他们可以是开发商。现在，你可以设置一个树结构，然后你可以要求每个节点执行通用的操作，比如：`printStructures()`。

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

You want to represent the whole hierarchy or a part of the hierarchy of objects; where clients to be able to ignore the difference between compositions of objects and individual objects.

You can apply this pattern with a structure that can have any level of complexity.

#### 装饰器模式

**目的**

装饰器模式允许你为对象添加和删除功能，而不需要改变对象的外观和已有功能。

**解决方案**

![decorator pattern](https://cdn-images-1.medium.com/max/2730/1*dMtzsvYbWYueZi2_1qQa-g.png)

It changes the functionality of an object in a way that is transparent to its clients by using an instance of a subclass of the original class that delegates operations to the original object.

* The **Component** is an Interface for objects that can have responsibilities added to them dynamically.
* The **ConcreteComponent** defines an object to which additional responsibilities can be added.
* The **Decorator** maintains a reference to a Component object and defines an interface that conforms to Component’s interface.
* The **ConcreteDecorators** extend the functionality of the component by adding state or adding behavior.

**现实世界案例**

You already own a house. Now you have decided to build an additional floor on top of it. You may want to change the design of the architecture for the newly added floor without affecting the existing architecture such as don’t change the architecture of the ground floor (or existing floors).

**用例**

When adding responsibilities to individual objects dynamically and transparently that is without affecting other objects.

When you want to add responsibilities to the object that you might want to change in the future.

Where extension by static subclassing is impractical.

## F2P (亨元，门面，代理)

#### 亨元模式

**目的**

The Flyweight pattern reduces the number of low-level, detailed objects within a system by sharing objects.

**解决方案**

The following diagram shows that the flyweight object is returned from the pool and to function, it needs the external state passed as an argument.

* **Client**: the client code.
* **FlyweightFactory**: this creates flyweights if they don’t exist and returns them from the pool if they exist.
* **Flyweight**: the abstract flyweight.
* **ConcreateFlyweight**: the flyweight designed to be have a shared state with its peers.

![flyweight pattern](https://cdn-images-1.medium.com/max/2730/1*71BoJ6z40DNVCHCKcPfcUw.png)

**现实世界案例**

A classic example of this usage is in a word processor. Here, each character is a flyweight object which shares the data needed for the rendering. As a result, only the position of the character inside the document takes up additional memory.

**用例**

You should use the Flyweight pattern when all of the following are true.

* The application uses a large number of objects.
* Storage costs are high because of the quantity of objects.
* The application doesn’t depend on object identity.

#### 门面模式

**目的**

The Façade pattern provides a unified interface to a group of interfaces in a subsystem.

**解决方案**

It defines a higher-level interfacethat makes the subsystem easier to use because you have only one interface.

![facade pattern](https://cdn-images-1.medium.com/max/2730/1*yXOdKZ9BnVZzjmLAgnXzHg.png)

**现实世界案例**

The Facade defines a unified, higher-level interface to a subsystem that makes it easier to use. Consumers encounter a Facade when ordering from a catalog. The consumer calls one number and speaks with a customer service representative. The customer service representative acts as a Facade, providing an interface to the order fulfillment department, the billing department, and the shipping department.

**用例**

When you want to provide a simple interface to a complex subsystem.

In case that there are many dependencies between clients and the implementation classes of an abstraction

When you want to layer your subsystems.

#### 代理模式

There are several types of implementations of the Proxy pattern, with the Remote proxy and Virtual proxy being the most common.

**目的**

The Proxy pattern provides a surrogate or placeholder object to control access to the original object.

**解决方案**

![proxy pattern](https://cdn-images-1.medium.com/max/2730/1*Nak08MGZrTUImZyG28zWUg.png)

**现实世界案例**

A real-world example can be a cheque or credit card is a proxy for what is in our bank account. It can be used in place of cash and provides a means of accessing that cash when required. And that’s exactly what the Proxy pattern does — “Controls and manage access to the object they are protecting“.

**用例**

You need a more versatile or sophisticated referenceto an object than a simple pointer.

## GRASP 模式

GRASP names and describes basic principles to assign responsibilities.

#### 信息专家

We look at the Expert Pattern (or Information Expert Pattern). This one is pretty simple and yet very important.

**目的**

What is a basic principle for assigning responsibilities to objects?

**解决方案**

Assign a responsibility to the class that has the information needed to fulfill it.

**现实世界案例Real-world example**

Consider the Monopoly game. Suppose an object wants to reference a Square, given its name. Who is responsible for knowing the Square, given its name?

> The most likely candidate is the Board because it is composed of Squares.

Since the Board is composed of Squares, it is the object that is best suited to produce a particular square given the square’s name — the Board is the Information Expert, it has all of the information needed to fulfill this responsibility.

**用例**

Think of the objects in your design model as workers that you manage. If you have a task to assign, who do you give it to?

* You give it to the person that has the best knowledge to do the task.
* Occasionally the knowledge to do the task is spread over several objects
Interact via several messages to do the work, but there is usually one object responsible for the completion of the task.

#### 受保护变化

**目的**

How to design objects, subsystems, and systems so that the variations or instability in these elements does not have an undesirable impact on other elements?

**解决方案**

Identify points of predicted variation or instability, assign responsibilities to create a stable interface around them.

The “Don’t talk to strangers” principle, which states that an object’s methods should only send messages (i.e. use methods) of objects that it is directly familiar with.

Related reading: [The Law of Demeter](https://github.com/xitu/gold-miner/blob/master/article/2020/the-law-of-demeter.md)

**现实世界案例**

Data encapsulation, interfaces, polymorphism, indirection, and standards are motivated by Protected Variations.

**用例**

Protected Variations is a root principle motivating most of the mechanisms and patterns in programming and design to provide flexibility and protection from variations in data, behavior, hardware, software components, operating systems, and more.

## 总结

Structural patterns affect applications in a variety of ways, for example, the Adapter pattern enables two incompatible systems to communicate, whereas the Facade pattern enables you to present a simplified interface to a user without removing all the options available in the system.

Easy, right?

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
