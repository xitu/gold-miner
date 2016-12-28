> * 原文地址：[SOLID Principles : The Definitive Guide](https://android.jlelse.eu/solid-principles-the-definitive-guide-75e30a284dea#.8b78yjtyk)
* 原文作者：[Arthur Antunes](https://android.jlelse.eu/@aantunesdias)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[]()
* 校对者：[]()

# SOLID Principles : The Definitive Guide

![](https://cdn-images-1.medium.com/max/2000/1*LcsyJRuNmvg31Va1M2OZgA.png)

**SOLID** is an acronym that represents five principles very important when we develop with the OOP paradigm, in addition it is an essential knowledge that every developer must know.
Understanding and applying these principles will **allow you to write better quality code** and therefore be a better developer.

The SOLID principles were defined in the early 2000s by [Robert C. Martin (Uncle Bob)](https://en.wikipedia.org/wiki/Robert_Cecil_Martin). Uncle Bob elaborated some of these and identified others already existing and said that these principles should be used to get a good management of dependencies in our code.

However, in the beginning these principles were not yet known as SOLID until [Michael Feathers](https://michaelfeathers.silvrback.com/) observed that the initials of these principles fit perfectly under the acronym SOLID and that it was also a very representative name for its definition.

These principles are a set of practical recommendations that when applied to our code helps us to obtain the following benefits:

- Ease to maintain.
- Ease to extend.
- Robust code.

But before we see what each SOLID principle means, we need to remember **two relevant concepts in the development of any software.**
The **coupling** and the **cohesion:**

#### Coupling:

We can define it as **the degree to which a class, method or any other software entity, is directly linked to another.** This degree of coupling can also be seen as a degree of dependence.

- **example:** when we want to use a class that is tightly bound (has a high coupling) to one or more classes, we will end up using or modifying parts of these classes for which we are dependent.

#### Cohesion:

Cohesion is the measure in which **two or more parts of a system work together to obtain better results than each part individually.**

- **example:** Han Solo and Chewbacca aboard the Millennium Falcon.

**To obtain a good software we must always try to have a low coupling and a high cohesion,** and SOLID principles help us with this task. If we follow these guidelines our code will be more robust, maintainable, reusable and extensible and we will avoid the tendency of our code to break in many places every time something is changed.

Let’s break down the letters of SOLID and see the details each of these.

![](https://cdn-images-1.medium.com/max/800/1*ykdDqm06KRI1XDtv34b2BQ.png)

### Single Responsibility Principle (SRP):

> *A class should have only one reason to change.*

This principle means that a class must have **only one responsibility and do only the task for which it has been designed.**

Otherwise, if our class assumes more than one responsibility we will have a high coupling causing our code to be fragile with any changes.

**Benefits:**

- Coupling reduced.
- Code easier to understand and maintain.

#### **Violation of SRP:**

- We have a **Customer** class that **has more than one responsibility:**

```
public class Customer {
 
    private String name;
 
    // getter and setter methods...
 
    // This is a Responsibility
    public void storeCustomer(String customerName) {
        // store customer into a database...
    }
 
    // This is another Responsibility
    public void generateCustomerReport(String customerName) {
        // generate a report...
    }
}
```

**storeCustomer(String name)** has the responsibility of store a Customer into the database so it is a responsibility of persistence and should be out of Customer class.

**generateCustomerReport(String name)** has the responsibility of generating a report about Customer so also should be out of Customer class

When a class has multiple responsibilities it is more difficult to understand, extend and modify.

#### **Better solution:**

We create **different classes for each responsibility.**

- **Customer** class:

```
public class Customer {
 
    private String name;
 
    // getter and setter methods...
}
```

- **CustomerDB** class for the persistence responsibility:

```
public class CustomerDB {
 
    public void storeCustomer(String customerName) {
        // store customer into a database...
    }
}
```

- **CustomerReportGenerator** class for the report generation responsibility:

```
public class CustomerReportGenerator {
 
    public void generateReport(String customerName) {
        // generate a report...
    }
}
```

With this solution, we have some classes but **each class with a single responsibility** so we get a low coupling and a high cohesion.

### Open Closed Principle (OCP):

> *Software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification*

According to this principle, a software entity must be easily extensible with new features without having to modify its existing code in use.

**open for extension:** new behaviour can be added to satisfy the new requirements.

**close for modification:** to extending the new behaviour are not required modify the existing code.

If we apply this principle we will get extensible systems that will be less prone to errors whenever the requirements are changed. We can use the [abstraction](https://en.wikipedia.org/wiki/Abstraction_%28software_engineering%29) and [polymorphism](https://en.wikipedia.org/wiki/Polymorphism_%28computer_science%29) to help us apply this principle.

**Benefits:**

- Code maintainable and reusable.
- Code more robust.

#### **Violation of OCP:**

- We have a **Rectangle** class:

```

public class Rectangle {
 
    private int width;
    private int height;
 
    // getter and setter methods...
}
```

- Also, we have a **Square** class:

```
public class Square {
 
    private int side;
 
    // getter and setter methods...
}
```

- And we have a **ShapePrinter** class that draws several types of shapes:

```

public class ShapePrinter {
 
    public void drawShape(Object shape) {
 
        if (shape instanceof Rectangle) {
            // Draw Rectangle...
        } else if (shape instanceof Square) {
            // Draw Square...
        }
    }
}
```

We can see that every time we want to draw a distinct shape we will have to **modify the drawShape method** of the ShapePrinter **to accept a new shape.**

As new types of shapes come to draw, the ShapePrinter class will be more confusing and fragile to changes.

Therefore the **ShapePrinter** class **is not closed for modification.**

#### **A solution:**

- We added a **Shape** abstract class:

```

public abstract class Shape {
    abstract void draw();
}
```

- Refactor **Rectangle** class to extends from **Shape:**

```
public class Rectangle extends Shape {
 
    private int width;
    private int height;
 
    // getter and setter methods...
 
    @Override
    public void draw() {
        // Draw the Rectangle...
    }
}
```

Refactor **Square** class to extends from **Shape:**

```
public class Square extends Shape {
 
    private int side;
 
    // getter and setter methods...
 
    @Override
    public void draw() {
        // Draw the Square
    }
}
```

- Refactor of **ShapePrinter:**

```
public class ShapePrinter {
 
    public void drawShape(Shape shape) {
        shape.draw();
    }
}
```

Now the **ShapePrinter** class **remains intact** when we add a new shape type.
**The existing code is not modified.**

So if we want to add more types of shapes we just have to create a class for that shape.

#### **Another solution:**

Now with this solution **ShapePrinter** class also remains intact when we add a new shape type because the **drawShape method receives Shape abstractions.**

- We change **Shape** to an interface:

```
public interface Shape {
    void draw();
}
```

- Refactor **Rectangle** class to implements **Shape:**

```
public class Rectangle implements Shape {
 
    private int width;
    private int height;
 
    // getter and setter methods...
 
    @Override
    public void draw() {
        // Draw the Rectangle...
    }
}
```

- Refactor **Square** class to implements **Shape:**

```
public class Square implements Shape {
 
    private int side;
 
    // getter and setter methods...
 
    @Override
    public void draw() {
        // Draw the Square
    }
}
```

- **ShapePrinter:**

```
public class ShapePrinter {
 
    public void drawShape(Shape shape) {
        shape.draw();
    }
}
```

### Liskov Substitution Principle (LSP):

> *Objects in a program should be replaceable with instances of their subtypes without altering the correctness of that program.*

This principle was defined by [Barbara Liskov](https://en.wikipedia.org/wiki/Barbara_Liskov) and says that objects must be replaceable by instances of their subtypes without altering the correct functioning of our system.

Applying this principle we can validate that our abstractions are correct.

**Benefits:**

- Code more reusable.
- Class hierarchies easy to understand.

The classic example that usually to explains this principle is the Rectangle example.

#### **Violation of LSP:**

- We have a **Rectangle** class:

```
public class Rectangle {
 
    private int width;
    private int height;
 
    public void setWidth(int width) {
        this.width = width;
    }
 
    public void setHeight(int height) {
        this.height = height;
    }
 
    public int getArea() {
        return width * height;
    }
}
```

- And a **Square** class:

Since a square is a rectangle (mathematically speaking), we decided that **Square** be a subclass of **Rectangle**.

We make overriding of **setHeight()** and **setWidth()** to set both dimensions (width and height) to the same value for that instances of **Square** remain valid.

```
public class Square extends Rectangle {
 
    @Override 
    public void setWidth(int width) {
        super.setWidth(width);
        super.setHeight(width);
    }
 
    @Override
    public void setHeight(int height) {
        super.setWidth(height);
        super.setHeight(height);
    }
}
```

So now we could pass a **Square** instance where a **Rectangle** instance is expected.

But if we do this, we can **break the assumptions made about the behaviour of Rectangle:**

The next assumption **is true** for **Rectangle:**

```
public class LiskovSubstitutionTest {
 
    public static void main(String args[]) {
        Rectangle rectangle = new Rectangle();
        rectangle.setWidth(2);
        rectangle.setHeight(5);
 
        if (rectangle.getArea() == 10) {
            System.out.println(rectangle.getArea());
        }
    }
}
```

But the same assumption **does not hold** for **Square:**

```
public class LiskovSubstitutionTest {
 
    public static void main(String args[]) {
        Rectangle rectangle = new Square(); // Square
        rectangle.setWidth(2);
        rectangle.setHeight(5);
 
        if (rectangle.getArea() == 10) {
            System.out.println(rectangle.getArea());
        }
    }
}
```

**Square** is not a correct substitution for **Rectangle** since does not comply with the behaviour of a **Rectangle**.

The **Square** / **Rectangle** hierarchy in isolation did not show any problems however, **this violates the Liskov Substitution Principle!**

#### **A solution:**

- Using a **Shape** interface to obtain the area:

```
public interface Shape {
    int area();
}
```

- Refactoring of **Rectangle** to implements **Shape:**

```
public class Rectangle implements Shape {
 
    private int width;
    private int height;
 
    public void setWidth(int width) {
        this.width = width;
    }
 
    public void setHeight(int height) {
        this.height = height;
    }
 
    @Override
    public int area() {
        return width * height;
    }
}
```

Refactoring of **Square** to implements **Shape:**

```
public class Square implements Shape {
 
    private int size;
 
    public void setSize(int size) {
        this.size = size;
    }
 
    @Override
    public int area() {
        return size * size;
    }
}
```

#### **Another solution that is often applied (with** [**immutability**](https://en.wikipedia.org/wiki/Immutable_object)**):**

- Refactoring of **Rectangle:**

```
public class Rectangle {
 
    private final int width;
    private final int height;
 
    public Rectangle(int width, int height) {
        this.width = width;
        this.height = height;
    }
 
    public int getArea() {
        return width * height;
    }
}
```

- Refactoring of **Square** to extends **Rectangle:**

```
public class Square extends Rectangle {
 
    public Square(int side) {
        super(side, side);
    }
}
```

Many times we model our classes depending on the properties of the real world object that we want to represent. But it is more important that we **pay attention to behaviours** to avoid this kind of mistakes.

### Interface Segregation Principle (ISP):

> *many client-specific interfaces are better than one general-purpose interface*

This principle defines that **a class should never implement an interface that does not go to use**. Failure to comply with this principle means that in our implementations we will have dependencies on methods that we do not need but that we are obliged to define.

Therefore, **implement specific interfaces is better to implement a general purpose interface.** An interface is defined by the client that will use it, so it should not have methods that this client will not implement.

**Benefits:**

- Decoupled system.
- Code easy to refactor.

#### **Violation of ISP:**

- We have a **Car** interface:

```
public interface Car {
    void startEngine();
    void accelerate();
}
```

- And a **Mustang** class that implements the **Car:**

```
public class Mustang implements Car {
 
    @Override
    public void startEngine() {
        // start engine...
    }
 
    @Override
    public void accelerate() {
        // accelerate...
    }
}
```

Now we have a new requirement to incorporate a new car model:
A **DeloRean,** but it’s not a common DeLorean. Our **DeloRean** is very special and has the feature to travel in time.

As usual we do not have time to make a good implementation and in addition, the **DeloRean** has to back to the past urgently.
So we decided:

- Add two new methods for our **DeloRean** in the **Car** interface:

```
public interface Car {
    void startEngine();
    void accelerate();
    void backToThePast();
    void backToTheFuture();
}
```

- Now our **DeloRean** class implements the **Car:**

```
public class DeloRean implements Car {
 
    @Override
    public void startEngine() {
        // start engine...
    }
 
    @Override
    public void accelerate() {
        // accelerate...
    }
 
    @Override
    public void backToThePast() {
        // back to the past...
    }
 
    @Override
    public void backToTheFuture() {
        // back to the future...
    }
}
```

- But now the **Mustang** class is forced to implement the new methods to comply with the **Car** interface:

```
public class Mustang implements Car {
 
    @Override
    public void startEngine() {
        // start engine...
    }
 
    @Override
    public void accelerate() {
        // accelerate...
    }
 
    @Override
    public void backToThePast() {
        // because a Mustang can not back to the past!
        throw new UnsupportedOperationException();
    }
 
    @Override
    public void backToTheFuture() {
        // because a Mustang can not back to the future!
        throw new UnsupportedOperationException();
    }
}
```

In this case, Mustang **violates the Interface Segregation Principle** because should implement methods that do not use.

#### **A solution with interfaces segregation:**

- Refactor **Car** interface:

```
public interface Car {
    void startEngine();
    void accelerate();
}
```

- Add a **TimeMachine** interface:

```
public interface TimeMachine {
    void backToThePast();
    void backToTheFuture();
}
```

- Refactor **Mustang (only implements Car interface):**

```
public class Mustang implements Car {
 
    @Override
    public void startEngine() {
        // start engine...
    }
 
    @Override
    public void accelerate() {
        // accelerate...
    }
}
```

- Refactor **DeloRean (implements Car and TimeMachine):**

```
public class DeloRean implements Car, TimeMachine {
 
    @Override
    public void startEngine() {
        // start engine...
    }
 
    @Override
    public void accelerate() {
        // accelerate...
    }
 
    @Override
    public void backToThePast() {
        // back to de past...
    }
 
    @Override
    public void backToTheFuture() {
        // back to de future...
    }
}
```

### Dependency Inversion Principle (DIP):

> *High-level modules should not depend on low-level modules. Both should depend on abstractions.*

> *Abstractions should not depend on details. Details should depend on abstractions.*

The Dependency Inversion Principle means that a particular class should not depend directly on another class, but on an abstraction (interface) of this class.

When we apply this principle we will reduce dependency on specific implementations and thus make our code more reusable.

**Benefits:**

- Reduce the coupling.
- Code more reusable.

#### **Violation of DIP:**

- We have a **DeliveryDriver** class that represents a driver that works for a delivery company:

```
public class DeliveryDriver {
 
    public void deliverProduct(Product product){
        // deliver product...
    }
}
```

- **DeliveryCompany** that handles shipments:

```
public class DeliveryCompany {
 
    public void sendProduct(Product product) {
        DeliveryDriver deliveryDriver = new DeliveryDriver();
        deliveryDriver.deliverProduct(product);
    }
}
```

Note that **DeliveryCompany** creates and uses DeliveryDriver concretions. Therefore **DeliveryCompany** which is a high-level class is dependent on a lower level class and this is a **violation of Dependency Inversion Principle.**

#### **A solution:**

- We create the **DeliveryService** interface to have an abstraction:

```
public interface DeliveryService {
    void deliverProduct(Product product);
}
```

- Refactor **DeliveryDriver** class to implements **DeliveryService:**

```
public class DeliveryDriver implements DeliveryService {
 
    @Override
    public void deliverProduct(Product product) {
        // deliver product...
    }
}
```

- Refactor **DeliveryCompany** that now depends on an abstraction and not off a concretion:

```
public class DeliveryCompany {
 
    private DeliveryService deliveryService;
 
    public DeliveryCompany(DeliveryService deliveryService) {
        this.deliveryService = deliveryService;
    }
 
    public void sendProduct(Product product) {
        this.deliveryService.deliverProduct(product);
    }
}
```

Now the dependencies are created elsewhere and are injected through the class constructor.

It is important not to confuse this principle with the [Dependence Injection](https://en.wikipedia.org/wiki/Dependency_injection) that is a pattern that helps us to apply this principle to ensure that collaboration between classes does not involve dependencies between them.

There are several libraries that facilitate the dependency injection, like [Guice](https://github.com/google/guice) or [Dagger2](https://github.com/google/dagger) that is one of the most popular.

### Conclusion

Following SOLID principles is essential if we are to build quality software that is easy to extend, robust and reusable. Also is important not forgetting to be pragmatic and use common sense because sometimes over-engineering can make simple things more complex.