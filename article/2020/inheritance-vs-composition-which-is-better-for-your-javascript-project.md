> - 原文地址：[Inheritance vs Composition: Which is Better for Your JavaScript Project?](https://blog.bitsrc.io/inheritance-vs-composition-which-is-better-for-your-javascript-project-16f4a077de9)
> - 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/inheritance-vs-composition-which-is-better-for-your-javascript-project.md](https://github.com/xitu/gold-miner/blob/master/article/2020/inheritance-vs-composition-which-is-better-for-your-javascript-project.md)
> - 译者：[regon-cao](https://github.com/regon-cao)
> - 校对者：[zenblo](https://github.com/zenblo) [ZavierTang](https://github.com/ZavierTang)

# 继承 vs 组合：哪一个更适合你的 JavaScript 项目？

![Image by [Christo Anestev](https://pixabay.com/users/anestiev-2736923/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2737108) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2737108)](https://cdn-images-1.medium.com/max/3840/1*mp9gh6RXvw3TMbBun2_fAg.jpeg)

扩展行为是我们作为开发人员在很多不同的语言和编程范例中做了很长时间的事情。但是，一场争议就在我们眼前进行，只有极少数人真正地注意到了这一点：

> 你应该通过继承来实现，还是通过组合来扩展和添加新的行为？

这是两种非常古老的技术，乍一看可以获得相同的结果，然而，在一些经验丰富的开发人员看来是有差异的，我在这里给他们作出一些解释。

---

上述介绍完之后，让我们从一些基本的定义开始本文内容，这样我们就可以从同一个地方开始。

## 定义

正如我所说的，这两个概念并不是全新的，但在我学习编程的时候，我认为如果需要扩展行为，就可以通过子类来实现，因此，继承是我给类扩展和添加行为时的唯一工具。让我们从继承开始说起吧。

#### 继承

本质上，在面向对象的上下文环境中，继承可以创建子类，子类从父类借用除了私有属性和方法外所有公共的和受保护的属性和方法。这么做可以维持和父类的一个关系，在父类代码更新时无需手动地去复制扩展父类代码。

```TypeScript
type TypePos = {
    x: number,
    y: number
}

class FourLeggedAnimal {
    protected number_of_legs:number;
    protected is_alive:boolean;
    protected color:string;
    protected position:TypePos;

    constructor(){
        this.number_of_legs = 4;
        this.is_alive = true;
        this.color = "white"

        this.position = {
            x: 0,
            y: 0
        }
    }

   speak():string|null {
    return null;
   }
}


class Dog extends FourLeggedAnimal {

    speak():string|null {
        return "Woof!";
    }
}


class Cat extends FourLeggedAnimal {
    speak():string|null {
        return "Miau!";
    }
}
```

上面的 TypeScript 代码片段是一个基础的继承示例。`Dog` 和 `Cat` 类扩展（或者说是继承）自 `FourLeggedAnimal`，这意味着它们拥有 `FourLeggedAnimal` 所有的属性和方法，我们不需要重新去定义它们，除非我们想覆盖原来的实现，就像上面的例子一样。继承允许我们将公共行为、状态（方法和属性）抽象到一个单独的地方，我们可以从那里（父类）提取。

一些编程语言允许多重继承，比如 JAVA，它可以让你从多个来源完成我们刚才所做的事情。

继承的另一大好处是用父类的类型声明的变量也可以兼容来自子类的对象，主要体现在 Java，TypeScript 等强类型语言。比如：

```TypeScript
let animals:FourLeggedAnimal[] = [
    new Cat(),
    new Dog()
]

animals.forEach( a => console.log(a.speak()))]
/* Outputs:
Miau!
Woof!
*/
```

紧接着之前定义的类，这个例子声明了一组 `FourLeggedAnimals` 类型的元素，包含了一个 `Cat` 和 一个 `Dog`。这是可行的，因为两个对象有相同的父类。同样，我们可以在第 6 行安全地调用 `speak` 方法。因为这个方法已经在父类中定义了，我们知道所有的对象都有它（我们不能明确的知道方法的具体实现除非我们见过代码，但我们能确定这一行不会因为缺失方法而抛出错误）。

#### 组合

如你所见，虽然两种方式可以产出相似的结果，但组合和继承完全是两码事。和我们之前见过的子类不同，组合允许我们在对象之间建立**一个关系**。

它帮助你将状态和行为封装在**组件**中，然后在别的类中使用该组件，这种行为正式的名称叫做**组合**。

回到之前的动物例子中，我们重新思考我们的内部结构后可以得到下面的：

![](https://cdn-images-1.medium.com/max/2000/1*Im_UTAJhD-0lnSYrViUmXA.png)

现在有三个不同的组件，我们在其中的两个(`Barker`和 `Meower` 组件)封装了行为，在 `AnimalProperties` 上封装了状态。我们不再拥有提供给 `Dog` 和 `Cat` 继承的普通类。

基于组件的方法的关键点在于，你现在可以轻松地维护和修改其中任何一个类的代码，而不会影响主类或它们的代码。这种关系被称为**松耦合**。

现在，我们通过添加一个接口来进一步地简化我们的代码。

![](https://cdn-images-1.medium.com/max/2000/1*NyOXVnzwja0qwkDyfkL1dQ.png)

确认我们只有一个包含主要逻辑的动物类。说明一下，接口只是让我们泛化对象的形状，它没有实现任何东西（接口不实现代码，只定义 API）。通过它我们可以创建一个通用类来描述对象的形状，这反过来又让我们定义一个变量来将它们包含在其中(参见 `Animal` 类中的 `actor` 属性)。

此时我们怎么创建一个 `Dog` 或者 `Cat` 呢? 让我来给你展示一下：

```TypeScript
interface IAction {
    speak(): string
}


class Barker implements IAction {

    public speak(): string {
        return "Woof!"
    }
}

class Meower implements IAction {
    public speak(): string {
        return "Meow!!"
    }
}

class AnimalProperties {
    private number_of_legs:number;
    private is_alive:boolean;
    private color:string;
    private position:TypePos;

    /**
     * ... getters and setters here
     */

}

class Animal {
    private actor: IAction;
    private props: AnimalProperties;

    constructor(actor: IAction, properties: AnimalProperties) {
        this.actor = actor;
        this.props = properties
    }

    public speak(): string {
        return this.actor.speak()
    }
}

const aDog = new Animal(new Barker(), new AnimalProperties())
const aCat = new Animal(new Meower(), new AnimalProperties())

let listOfAnimals: Animal[] = [aDog, aCat]

listOfAnimals.forEach(a => console.log(a.speak()))
```

先说重要的：最终的结果是一致的。我们能够创建一个动物的泛型列表，对它进行循环，可以确定的是在调用它时所有对象都拥有同一个方法。同样，我们不知道它将如何实现，因为具体实现是由组件(在本例中)决定的。

这里的主要区别是，我们没有两个不同的类来描述我们的动物，我们只有一个，请注意，它具有很强的可塑性，只要有正确的组件集，就可以变成任何动物。

如果你还没有注意到，尽管继承或组合都可以实现同样的效果，但继承发生在编译(或解释)阶段，而组合发生在执行阶段。这有多重要呢？实际上它真的**非常**重要，你看，只要有一组正确的方法，你就可以把一只 `Cat` 变成一只 `Dog`，甚至在执行阶段变成一种全新的动物，而继承是做不到这一点的。

```TypeScript
class Animal {
    private actor: IAction;
    private props: AnimalProperties;

    constructor(actor: IAction, properties: AnimalProperties) {
        this.actor = actor;
        this.props = properties
    }

    public setActor(a:IAction):void {
        this.actor = a;
    }

    public speak(): string {
        return this.actor.speak()
    }
}
```

使用新的 `setActor` 方法，你可以在任何给定的时间点为 moewer 更改调用器，尽管这种行为可能看起来有点奇怪，但在某些情况下，这种动态性非常适合你的逻辑。

## 哪一个更好呢?

现在我们了解了它们是什么以及如何使用它们，事实是：它们都很棒！

很抱歉让你失望了，但是我真的认为它们每个都有完美的使用场景。

#### 继承的使用场景

继承是有意义的，因为我们倾向于将面向对象（OOP）概念与真实对象联系起来，然后通过概括它们的性质来归纳它们的行为。

换句话说，我们不会认为拥有四条腿和一套能让他们吠叫或喵喵的器官的就是一只猫或一只狗。我们认为他们是**动物**，而这些特征被解释为继承。

正因为如此，使用继承的理想场景是两个或更多类之间 80% 的代码是相同的，同时特定的代码又**非常**的不同。不仅如此，还要确保不存在需要彼此交换特定代码的情况。此时继承肯定是最合适的工具，有了它，你的内部架构将更简单，你需要考虑的代码会更少。

#### 组合的使用场景

正如我们目前所看到的，组合是一个非常灵活的工具。你肯定需要稍微改变一下思维方式，特别是如果你像我一样，以前学习过关于继承的知识，认为继承是 OOP 环境中实现代码重用的唯一解决方案。

然而，现在你已经看到了光明（顺便说一句不用谢），你知道那不是真的。不仅如此，你也知道泛型代码也可以抽象成不同的组件，进而可以根据你的需要变的很复杂（只要保持公共接口是相同的），我们可以在运行时交换他们,这在我看来真的是非常的灵活。

我看到的另一个好处是，当使用继承时，如果你需要创建一个新的特定类(比如现在添加一个 `Lion` 类)，你必须理解 `FourLeggedAnimal` 类的代码，以确保你知道从它获得了什么。这样你就能实现一个不同版本的 `speak` 方法。然而，如果你使用组合，你所需要做的就是创建一个新类来实现 `speak` 方法的逻辑，而不需要知道其他的东西，仅此而已。

当然，在这个例子中，阅读一个非常简单的类所带来的额外认知负担可能看起来无关紧要，但是，考虑一个真实的场景，在这个场景中，你将不得不遍历数百行代码来确保你理解一个基类。那肯定不太好。

---

在我的书中，组合 10 次中有 8 次胜出，然而，继承和它提供的简单实现是有道理的，所以我倾向于对继承持保留意见，以便开发使用。

你呢？你的代码中有明显的赢家吗？你更喜欢其中哪一种呢？请在下方留言，分享你认为哪个是最好的，以及为什么。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
