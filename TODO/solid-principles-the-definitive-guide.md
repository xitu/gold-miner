> * 原文地址：[SOLID Principles : The Definitive Guide](https://android.jlelse.eu/solid-principles-the-definitive-guide-75e30a284dea#.8b78yjtyk)
* 原文作者：[Arthur Antunes](https://android.jlelse.eu/@aantunesdias)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[XHShirley](https://github.com/XHShirley) * 校对者：[Patrick Wang](https://github.com/imink), [skyar2009](https://github.com/skyar2009)

# SOLID 原则：权威指南

![](https://cdn-images-1.medium.com/max/2000/1*LcsyJRuNmvg31Va1M2OZgA.png)


**SOLID** 是五个面向对象编程的重要原则的缩写。另外，它也是每个开发者必备的基本知识。了解并应用这些原则能**让你写出更优质的代码**，变成更优秀的开发者。

SOLID 原则是由 [Robert C. Martin （Bob 大叔）](https://en.wikipedia.org/wiki/Robert_Cecil_Martin) 在 21 世纪初定义的。Bob 大叔阐述了几个并且确认了其它已经存在的原则。他说我们应该使用这些原则，让代码获得好的依赖管理。

但是，SOLID 原则在最初并没有被大家熟知直到 [Michael Feathers](https://michaelfeathers.silvrback.com/) 观察到这些原则的首字母正好能拼成缩写 SOLID，这个非常具有代表性的名字。

当应用在我们的代码里面的时候，这组实用的建议可以帮助我们获得以下的好处：

- 可持续性
- 扩展性
- 鲁棒的代码

但在我们了解每个 SOLID 原则之前， 我们需要回忆**软件开发中两个相关的概念**。**耦合**和**内聚**：


#### 耦合：

我们可以把它定义为**一个类、方法或者任何一个实体直接与另一个实体连接的度**。这个耦合的度也可以被看作依赖的度。

- **例子：**当我们想要使用的一个类，与一个或者多个类紧密地绑定在一起（高耦合），我们将最终使用或修改这些类我们所依赖的部分。


#### 内聚：

内聚是一个系统里两个或多个部分一起执行工作的度量，来获得比每个部分单独工作获得更好的结果。

- **例子：** 星球大战中 Han Solo 和 Chewbacca 一起在千年隼号里。

**想要有一个高质量的软件，我们必须尝试低耦合高内聚，**而 SOLID 原则正好帮助我们完成这个任务。如果我们遵循这些指引，我们的代码会更健壮，更易于维护，有更高的复用性和可扩展性。同时，可以避免每次变更都要修改多处代码的问题。

让我们把 SOLID 的字母拆开看看每一个对应原则的细节吧。

![](https://cdn-images-1.medium.com/max/800/1*ykdDqm06KRI1XDtv34b2BQ.png)

### 单一职责原则（SRP）：

> **一个类应该只有一个引起改变的原因。**

这个原则意味着**一个类只能有一个职责并且只完成为它设计的功能任务。**

否则，如果我们的类承担的职责多于一个，那么我们的代码就具有高度的耦合性，并会导致它对于任何改变都很脆弱。


**好处：**

- 降低耦合性。
- 代码易于理解和维护。

#### **违反 SRP 原则**

- 我们的 **Customer** 类**有多个的职责：**

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


**storeCustomer(String name)** 职责是把顾客存入数据库。这个职责是持续的，应该把它放在顾客类的外面。

**generateCustomerReport(String name)** 职责是生成一个关于顾客的报告，所以它也应该放在顾客类的外面。

当一个类有多个职责，它就更加难以被理解，扩展和修改。

#### **更好的解决办法：**


我们 **为每一个职责创建不同的类。**

- **Customer** 类：

```
public class Customer {
 
    private String name;
 
    // getter and setter methods...
}
```

- **CustomerDB** 类用于持续的职责：

```
public class CustomerDB {
 
    public void storeCustomer(String customerName) {
        // store customer into a database...
    }
}
```

- **CustomerReportGenerator** 类用于报告制作的职责：

```
public class CustomerReportGenerator {
 
    public void generateReport(String customerName) {
        // generate a report...
    }
}
```


这样，我们就有几个类，但是**每个类都有单一的职责**，我们就使它变成了低耦合高内聚。

### 开闭原则（OCP）：

> **软件实体（类，模块，方法等）应该对扩展开放，对修改封闭。**


根据这一原则，一个软件实体能很容易地扩展新功能而不必修改现有的代码。

**open for extension:** 添加新的功能从而满足新的需求。

**close for modification:** 扩展新的功能行为而不需要修改现有的代码。

如果我们应用这个原则，我们会有一个可扩展的系统且在更改需求的时候更不易出错。我们可以用[抽象](https://en.wikipedia.org/wiki/Abstraction_%28software_engineering%29)和[多态](https://en.wikipedia.org/wiki/Polymorphism_%28computer_science%29)来帮助我们应用这个原则。


**好处：**


- 代码的可维护性和复用性。
- 代码会更健壮。


#### **违反 OCP 原则**

-  我们有一个 **Rectangle** 类：

```

public class Rectangle {
 
    private int width;
    private int height;
 
    // getter and setter methods...
}
```

- 同时，我们有一个 **Square** 类

```
public class Square {
 
    private int side;
 
    // getter and setter methods...
}
```

- 我们还有一个 **ShapePrinter** 类可以画不同的形状：

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


可以看到，当我们每次想要画一个新的形状我们就要**修改 ShapePrinter 类里的 drawShape 方法来接受这个新的形状。**

当要画新的形状种类的时候，ShapePrinter 类就会变得更让人难以理解并且不易于改变。

所以 **ShapePrinter** 类不对修改封闭。


#### **一个解决办法：**

- 我们添加一个 **Shape** 抽象类：

```

public abstract class Shape {
    abstract void draw();
}
```

- 重构 **Rectangle** 类以继承自 **Shape:**

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

重构 **Square** 类以继承自 **Shape:**

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

- **ShapePrinter** 的重构：

```
public class ShapePrinter {
 
    public void drawShape(Shape shape) {
        shape.draw();
    }
}
```


现在，**ShapePrinter** 类在我们添加了新的形状类型的同时也保持了完整性。


#### **另一个解决方法：**

用这个方法，**ShapePrinter** 也能在添加新形状的同时保持完整性，因为 **drawShape 方法接受 Shape 抽象。**

- 我们把 **Shape** 变成一个接口：

```
public interface Shape {
    void draw();
}
```

- 重构 **Rectangle** 类以实现 **Shape:**

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

- 重构 **Square** 类以实现 **Shape:**

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

### 里氏替换原则（LSP）：

> **程序里的对象都应该可以被它的子类实例替换而不用更改程序.**


这个原则由 [Barbara Liskov](https://en.wikipedia.org/wiki/Barbara_Liskov) 定义。他说程序里的对象都应该可以被它的子类实例替换而不用更改系统的正常工作.


**好处:**

- 更高的代码复用性。
- 类的层次结构易于理解。


经常用于解释这个原则的经典例子就是长方形的例子。


#### **违反 LSP 原则:**

- 我们有一个 **Rectangle** 类:

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

- 还有一个 **Square** 类：


因为一个正方形是一个长方形（从数学上讲），我们决定把 **Square** 作为 **Rectangle** 的子类。


我们在重写的 **setHeight()** 和 **setWidth()** 方法中设置（与它的父类）同样的尺寸（宽和高），让 **Square** 的实例依然有效。

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


所以现在我们可以传一个 **Square** 实例到一个需要 **Rectangle** 实例的地方。

但是如果我们这样做，我们会**破坏 Rectangle 的行为假设：**

下面对于 **Rectangle** 的假设是**对的：**

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


但是同样的假设却不适用于 **Square:**

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


**Square** 不是 **Rectangle** 正确的替代品，因为它不遵循 **Rectangle** 的行为规则。

**Square** / **Rectangle** 层次分离虽然不能反应出任何问题，但是这**违反了里氏替换原则**！


#### **一个解决方法：**

- 用 **Shape** 接口来获取面积：

```
public interface Shape {
    int area();
}
```

- 重构 **Rectangle** 以实现 **Shape:**

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

重构 **Square** 以实现 **Shape:**

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


#### **另一个解决方法经常与[非可变性](https://en.wikipedia.org/wiki/Immutable_object)一起应用**

- **Rectangle** 重构：

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

- 重构 **Square** 以继承 **Rectangle:**

```
public class Square extends Rectangle {
 
    public Square(int side) {
        super(side, side);
    }
}
```


很多时候，我们对类的建模依赖于我们想展示的现实世界客体的属性，但更重要的是我们应该关注它们各自的行为来避免这种错误。

### 接口隔离原则（ISP）：

> **多个专用的接口比一个通用接口好。**

这个原则定义了**一个类决不要实现不会用到的接口**。不遵循这个原则意味着在我们在实现里会依赖很多我们并不需要的方法，但又不得不去定义。

所以，实现多个特定的接口比实现一个通用接口要好。一个接口被需要用到的类所定义，所以这个接口不应该有这个类不需要实现的其它方法。


**好处：**

- 系统解耦。
- 代码易于重构。

#### **违反 ISP 原则**

- 我们有一个 **Car** 的接口：

```
public interface Car {
    void startEngine();
    void accelerate();
}
```

- 同时也有一个实现 **Car** 接口的 **Mustang** 类：

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


现在我们有个新的需求，要添加一个新的车型：

一辆 **DeloRean,** 但这并不是一个普通的 DeLorean，我们的 **DeloRean** 非常特别，它有穿梭时光的功能。

像以往一样，我们没有时间来做一个好的实现，而且 **DeloRean** 必须马上回到过去。

- 为我们的 **DeloRean** 在 **Car** 接口里增加两个新的方法：

```
public interface Car {
    void startEngine();
    void accelerate();
    void backToThePast();
    void backToTheFuture();
}
```

- 现在我们的 **DeloRean** 实现 **Car** 的方法：

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

- 但是现在 **Mustang** 被迫去实现在 **Car** 接口里的新方法：

```
public class Mustang implements Car {
 
    @Override
    public void startEngine() {
        // 启动引擎
    }
 
    @Override
    public void accelerate() {
        // 加速
    }
 
    @Override
    public void backToThePast() {
        // 因为 Mustang 不能回到过去！
        throw new UnsupportedOperationException();
    }
 
    @Override
    public void backToTheFuture() {
        // 因为 Mustang 不能穿越去未来！
        throw new UnsupportedOperationException();
    }
}
```

在这种情况下，Mustang **违反了接口隔离的原则**，因为它实现了它不会用到的方法。


#### **使用接口隔离的解决方法：**

- 重构 **Car** 接口：

```
public interface Car {
    void startEngine();
    void accelerate();
}
```

- 增添一个 **TimeMachine** 接口：

```
public interface TimeMachine {
    void backToThePast();
    void backToTheFuture();
}
```

- 重构 **Mustang（只实现 Car 的接口）**

```
public class Mustang implements Car {
 
    @Override
    public void startEngine() {
        // 启动引擎
    }
 
    @Override
    public void accelerate() {
        // 加速
    }
}
```

- 重构 **DeloRean（同时实现 Car 和 TimeMachine）**

```
public class DeloRean implements Car, TimeMachine {
 
    @Override
    public void startEngine() {
        // 启动引擎
    }
 
    @Override
    public void accelerate() {
        // 加速
    }
 
    @Override
    public void backToThePast() {
        // 回到过去
    }
 
    @Override
    public void backToTheFuture() {
        // 到未来去
    }
}
```


### 依赖倒转原则 (DIP):


> **高层次的模块不应该依赖于低层次的模块，它们都应该依赖于抽象。**
> 
> **抽象不应该依赖于细节。细节应该依赖于抽象。**


依赖倒转原则的意思是一个特定的类不应该直接依赖于另外一个类，但是可以依赖于这个类的抽象（接口）。

当我们应用这个原则的时候我们能减少对特定实现的依赖性，让我们的代码复用性更高。


**好处:**

- 减少耦合。
- 代码更高的复用性。


#### **违反 DIP 原则:**

- 我们有一个类叫 **DeliveryDriver** 代表着一个司机为快递公司工作。

```
public class DeliveryDriver {
 
    public void deliverProduct(Product product){
        // 运送产品
    }
}
```

- **DeliveryCompany** 类处理货物装运：

```
public class DeliveryCompany {
 
    public void sendProduct(Product product) {
        DeliveryDriver deliveryDriver = new DeliveryDriver();
        deliveryDriver.deliverProduct(product);
    }
}
```


我们注意到 **DeliveryCompany** 创建并使用 DeliveryDriver 实例。所以 **DeliveryCompany** 是一个依赖于低层次类的高层次的类，这就**违背了依赖倒转原则**。（译者注：上述代码中 DeliveryCompany 需要运送货物，必须需要一个 DeliveryDriver 参与。但如果以后对司机有更多的要求，那我们既要修改 DeliveryDriver 也要修改上述代码。这样造成的依赖，耦合度高）

#### **A solution:**

#### **解决方法:**

- 我们创建 **DeliveryService** 接口，这样我们就有了一个抽象。

```
public interface DeliveryService {
    void deliverProduct(Product product);
}
```

- 重构 **DeliveryDriver** 类以实现 **DeliveryService** 的抽象方法：

```
public class DeliveryDriver implements DeliveryService {
 
    @Override
    public void deliverProduct(Product product) {
        // 运送产品
    }
}
```

- 重构 **DeliveryCompany**，使它依赖于一个抽象而不是一个具体的东西。

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


现在，依赖在别的地方创建，并且从类构造器中被注入。


千万不要把这个原则与[依赖注入](https://en.wikipedia.org/wiki/Dependency_injection)混淆。依赖注入是一种设计模式，帮助我们应用这个原则来确保各个类之间的合作不涉及相互依赖。


这里有好几个库使依赖注入更容易实现，像 [Guice](https://github.com/google/guice) 或者非常流行的 [Dagger2](https://github.com/google/dagger)。

### 结论


遵循 SOLID 原则来构建高质量, 易于扩展, 足够健壮并且可复用的软件是非常必要的。同时, 我们也不要忘了从实际和常识出发, 因为有的时候过份设计会使简单的问题复杂化。
