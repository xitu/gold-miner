> * 原文地址：[Design Patterns: Structural Patterns of Design Classes and Objects](https://levelup.gitconnected.com/design-patterns-structural-patterns-of-design-classes-and-objects-79d58a6519b)
> * 原文作者：[Trung Anh Dang](https://medium.com/@dangtrunganh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/design-patterns-structural-patterns-of-design-classes-and-objects.md](https://github.com/xitu/gold-miner/blob/master/article/2020/design-patterns-structural-patterns-of-design-classes-and-objects.md)
> * 译者：
> * 校对者：

# Design Patterns: Structural Patterns of Design Classes and Objects

![Structural patterns of design classes and objects](https://cdn-images-1.medium.com/max/2730/1*ZQBbxCUNxO7McfVcgL7B3w.png)

> Adapter, Decorator, Proxy, Information Expert, Composite, Bridge, Low Coupling, Flyweight, Protected Variations and Facade

Structural design patterns are concerned with how classes and objects can be composed, to form larger structures. They enable you to create systems without rewriting or customizing the code because these patterns provide the system with enhanced reusability and robust functionality.

> Each pattern describes a problem which occurs over and over again in our environment, and then describes the core of the solution to that problem, in such a way that you can use this solution a million times over, without ever doing it the same way twice. —**Christopher Alexander**

There are following 10 types of structural design patterns.

* Adapter Pattern
* Bridge Pattern
* Composite Pattern
* Decorator Pattern
* Low Coupling
* Flyweight Pattern
* Facade Pattern
* Proxy Pattern
* Information Expert
* Protected Variations

## ABCD (Adapter, Bridge, Composite, Decorator)

#### Adapter Pattern

**Intent**

The Adapter Pattern is a structural design pattern that allows objects with **incompatible** interfaces to work together.

**Solution**

It implements an interface known to its clients and provides access to an instance of a class not known to its clients.

* **AdapterClient**: the code client.
* **Adapter**: the Adapter class that forwards the calls to the adaptee.
* **Adaptee**: the old code needs to be adapted.
* **Target**: the new interface to support.

![adapter pattern](https://cdn-images-1.medium.com/max/2730/1*9hpD88w1qqsHPqHzDcNRlg.png)

**Real-world example**

The original power is 220 voltages, and it needs to be adapted to 100 voltages to work.

![a real-world example](https://cdn-images-1.medium.com/max/2730/1*gw2KaBMjy4x5k4FM1JRsRQ.png)

The following code solves this problem. It defines a `HighVoltagePlug` (adapter), a `Plug` interface (target), a `AdapterPlug` (adapter).

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
        //Power is 220 Voltage
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

**Use-cases**

When you want to use an existing class, and its interface does not match the interface you need.

When you want to create a reusable class that cooperates with unrelated
or unforeseen classes that are classes that don’t necessarily have
compatible interfaces.

Where interface translation among multiple sources must occur.

#### Bridge Pattern

**Intent**

It divides a complex component into two separate but related inheritance hierarchies: the functional **abstraction** and theinternal **implementation**.

**Solution**

The following diagram shows a possible bridge implementation.

* **Abstraction**: this is the abstraction component.
* **Implementor**: this is the abstract implementation.
* **RefinedAbstraction**: this is the refined component.
* **ConcreateImplementors**: those are the concrete implementations.

![bridge pattern](https://cdn-images-1.medium.com/max/2730/1*fViusZWf4tVGdQ4BxBHilQ.png)

**Real-world example**

Different people can wear different clothes such as man, woman, boy, and girl.

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

        // a woman wear jacket
        woman.setCloth(jacket); 
        woman.dress();
    }
}
```

**Use-cases**

Avoiding a permanent binding between an abstraction and its implementation.

Both the abstractions and their implementations should be extensible using subclasses.

Changes in the implementation of an abstraction should have no impact on clients; that is, you should not have to recompile their code.

#### Composite Pattern

**Intent**

The Composite pattern enables you to create hierarchical tree structures of varying complexity while allowing every element in the structure to operate with a uniform interface.

**Solution**

The Composite pattern combines objects into tree structures to represent either the whole hierarchyor a part of the hierarchy.

![composite pattern](https://cdn-images-1.medium.com/max/2730/1*_qUxlkDYSv9MVdNEeVPuDw.png)

* The **Component** is the abstraction for leaves and composites. It defines the interface that must be implemented by the objects in the composition.
* **Leaves** are objects that have no children. They implement services described by the Component interface.
* The **Composite** store child components in addition to implementing methods defined by the component interface. Composites implement methods defined in the Component interface by delegating to child components. In addition, composites provide additional methods for adding, removing, as well as getting components.
* The **Client** manipulates objects in the hierarchy using the component interface.

**Real-world example**

In an organization, It has general managers and under general managers, there can be managers and under managers there can be developers. Now you can set a tree structure and ask each node to perform common operation like `printStructures()`.

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

    //The container for child objects
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

**Use-cases**

You want to represent the whole hierarchy or a part of the hierarchy of objects; where clients to be able to ignore the difference between compositions of objects and individual objects.

You can apply this pattern with a structure that can have any level of complexity.

#### Decorator Pattern

**Intent**

The Decorator pattern enables you to add or remove object functionality without changing the external appearance or function of the object.

**Solution**

![decorator pattern](https://cdn-images-1.medium.com/max/2730/1*dMtzsvYbWYueZi2_1qQa-g.png)

It changes the functionality of an object in a way that is transparent to its clients by using an instance of a subclass of the original class that delegates operations to the original object.

* The **Component** is an Interface for objects that can have responsibilities added to them dynamically.
* The **ConcreteComponent** defines an object to which additional responsibilities can be added.
* The **Decorator** maintains a reference to a Component object and defines an interface that conforms to Component’s interface.
* The **ConcreteDecorators** extend the functionality of the component by adding state or adding behavior.

**Real-world example**

You already own a house. Now you have decided to build an additional floor on top of it. You may want to change the design of the architecture for the newly added floor without affecting the existing architecture such as don’t change the architecture of the ground floor (or existing floors).

**Use-cases**

When adding responsibilities to individual objects dynamically and transparently that is without affecting other objects.

When you want to add responsibilities to the object that you might want to change in the future.

Where extension by static subclassing is impractical.

## F2P (Flyweight, Facade, Proxy)

#### Flyweight Pattern

**Intent**

The Flyweight pattern reduces the number of low-level, detailed objects within a system by sharing objects.

**Solution**

The following diagram shows that the flyweight object is returned from the pool and to function, it needs the external state passed as an argument.

* **Client**: the client code.
* **FlyweightFactory**: this creates flyweights if they don’t exist and returns them from the pool if they exist.
* **Flyweight**: the abstract flyweight.
* **ConcreateFlyweight**: the flyweight designed to be have a shared state with its peers.

![flyweight pattern](https://cdn-images-1.medium.com/max/2730/1*71BoJ6z40DNVCHCKcPfcUw.png)

**Real-world example**

A classic example of this usage is in a word processor. Here, each character is a flyweight object which shares the data needed for the rendering. As a result, only the position of the character inside the document takes up additional memory.

**Use-cases**

You should use the Flyweight pattern when all of the following are true.

* The application uses a large number of objects.
* Storage costs are high because of the quantity of objects.
* The application doesn’t depend on object identity.

#### Facade Pattern

**Intent**

The Façade pattern provides a unified interface to a group of interfaces in a subsystem.

**Solution**

It defines a higher-level interfacethat makes the subsystem easier to use because you have only one interface.

![facade pattern](https://cdn-images-1.medium.com/max/2730/1*yXOdKZ9BnVZzjmLAgnXzHg.png)

**Real-world example**

The Facade defines a unified, higher-level interface to a subsystem that makes it easier to use. Consumers encounter a Facade when ordering from a catalog. The consumer calls one number and speaks with a customer service representative. The customer service representative acts as a Facade, providing an interface to the order fulfillment department, the billing department, and the shipping department.

**Use-cases**

When you want to provide a simple interface to a complex subsystem.

In case that there are many dependencies between clients and the implementation classes of an abstraction

When you want to layer your subsystems.

#### Proxy Pattern

There are several types of implementations of the Proxy pattern, with the Remote proxy and Virtual proxy being the most common.

**Intent**

The Proxy pattern provides a surrogate or placeholder object to control access to the original object.

**Solution**

![proxy pattern](https://cdn-images-1.medium.com/max/2730/1*Nak08MGZrTUImZyG28zWUg.png)

**Real-world example**

A real-world example can be a cheque or credit card is a proxy for what is in our bank account. It can be used in place of cash and provides a means of accessing that cash when required. And that’s exactly what the Proxy pattern does — “Controls and manage access to the object they are protecting“.

**Use-cases**

You need a more versatile or sophisticated referenceto an object than a simple pointer.

## GRASP patterns

GRASP names and describes basic principles to assign responsibilities.

#### Information Expert

We look at the Expert Pattern (or Information Expert Pattern). This one is pretty simple and yet very important.

**Intent**

What is a basic principle for assigning responsibilities to objects?

**Solution**

Assign a responsibility to the class that has the information needed to fulfill it.

**Real-world example**

Consider the Monopoly game. Suppose an object wants to reference a Square, given its name. Who is responsible for knowing the Square, given its name?

> The most likely candidate is the Board because it is composed of Squares.

Since the Board is composed of Squares, it is the object that is best suited to produce a particular square given the square’s name — the Board is the Information Expert, it has all of the information needed to fulfill this responsibility.

**Use-cases**

Think of the objects in your design model as workers that you manage. If you have a task to assign, who do you give it to?

* You give it to the person that has the best knowledge to do the task.
* Occasionally the knowledge to do the task is spread over several objects
Interact via several messages to do the work, but there is usually one object responsible for the completion of the task.

#### Protected Variations

**Intent**

How to design objects, subsystems, and systems so that the variations or instability in these elements does not have an undesirable impact on other elements?

**Solution**

Identify points of predicted variation or instability, assign responsibilities to create a stable interface around them.

The “Don’t talk to strangers” principle, which states that an object’s methods should only send messages (i.e. use methods) of objects that it is directly familiar with.

Related reading: [The Law of Demeter](https://github.com/xitu/gold-miner/blob/master/article/2020/the-law-of-demeter.md)

**Real-world example**

Data encapsulation, interfaces, polymorphism, indirection, and standards are motivated by Protected Variations.

**Use-cases**

Protected Variations is a root principle motivating most of the mechanisms and patterns in programming and design to provide flexibility and protection from variations in data, behavior, hardware, software components, operating systems, and more.

## Conclusion

Structural patterns affect applications in a variety of ways, for example, the Adapter pattern enables two incompatible systems to communicate, whereas the Facade pattern enables you to present a simplified interface to a user without removing all the options available in the system.

Easy, right?

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
