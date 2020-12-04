> * 原文地址：[Inheritance vs Composition: Which is Better for Your JavaScript Project?](https://blog.bitsrc.io/inheritance-vs-composition-which-is-better-for-your-javascript-project-16f4a077de9)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/inheritance-vs-composition-which-is-better-for-your-javascript-project.md](https://github.com/xitu/gold-miner/blob/master/article/2020/inheritance-vs-composition-which-is-better-for-your-javascript-project.md)
> * 译者：
> * 校对者：

# Inheritance vs Composition: Which is Better for Your JavaScript Project?

![Image by [Christo Anestev](https://pixabay.com/users/anestiev-2736923/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2737108) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2737108)](https://cdn-images-1.medium.com/max/3840/1*mp9gh6RXvw3TMbBun2_fAg.jpeg)

Extending behavior is something we, as developers, have been doing for a long time, in a lot of different languages and programming paradigms. However, a secret war has been waging right in front of our eyes, and only a very select group has actually noticed it:

> Should you do it through inheritance or is it better to extend and add new behavior through composition?

These are two very old techniques that, at first glance, give us the same result, however, there are differences to the trained eye, and I’m here to shed some light on them.

---

With that intro out of the way, let us begin our journey with some basic definitions so we’re all starting at the same place.

## Definitions

As I said, both of these concepts aren’t precisely new, but in my case, I learned programming back in the day thinking that if you needed to extend behavior you did it by sub-classing, and because of that, inheritance was my only tool when it came to extending and adding behavior to a class. Let’s start there.

#### Inheritance

Essentially, in an object oriented context, Inheritance is a technique we can use to create derived classes that borrow everything from their parents, meaning every public and protected property and method, leaving out private ones. This allows you to maintain a relation with the parent class that updates the moment its code changes, making it a better alternative than just copying its code and extending it manually.

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

The above TypeScript code shows the basics of inheritance. Both the `Dog` and `Cat` classes extend or inherit from `FourLeggedAnimal`, which means they take on all their properties and methods, we don’t have to re-define them unless, like in my example, we want to overwrite what they do. What inheritance allows us is to abstract common behavior a state (in other words, methods and properties) into a single place where we can pull from (the parent class).

Some programming languages allow for multiple inheritances, such as JAVA, which in turn, let you to do what we just did but from multiple sources.

Another big benefit from the inheritance, mainly on strongly typed languages such as JAVA, TypeScript and others, is that variables declared with the type of your parent class can hold objects from its child classes as well. In other words:

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

Following with the same class definitions from before, this example declares a list of element of type `FourLeggedAnimals` while in reality, it contains a `Cat` and a `Dog`. This is possible because both objects have the same parent class. the same goes for the fact that we’re able to call the `speak` method safely on line 6. Thanks to the fact that this method is already defined in the parent class, we know all of our objects will have it (we can’t know specifically the implementation that will be used unless we’ve seen the code, but we can be sure this line will not error out due to a missing method error).

#### What about composition?

Although as you’ll see, both tools can yield a very similar result, composition is a whole different beast from inheritance. Instead of sub-typing like we did before, composition allows us to model a **has one** relationship between objects.

This in turn, helps you to encapsulate state and behavior inside a **component** and then use that component from other classes, formally known as **composite.**

If we go back to our animals example, we can re-think our internal architecture and have something like this:

![](https://cdn-images-1.medium.com/max/2000/1*Im_UTAJhD-0lnSYrViUmXA.png)

Essentially we now have three different components where we’ve encapsulated behavior in two of them (the `Barker` and the `Meower` components) and state on the `AnimalProperties` we’ve encapsulated our state. We no longer have a common class for `Dog` and `Cat` to inherit from.

The point of a component-based approach is that you can now easily maintain and modify the code for any of them without affecting the main classes or their code. These type of relationship is called **loosely coupled**.

Now, we can take this to the next level and by adding a simple interface, we can simplify our code even further.

![](https://cdn-images-1.medium.com/max/2000/1*NyOXVnzwja0qwkDyfkL1dQ.png)

Check that out, we’re back to having only one animal class that contains our main logic. And just to clarify, the interface only lets us generalize our object shape, it’s not implementing anything (interfaces don’t really implement code, only define their API). With it we can create a common “type” if you will that describes the shape of our object, which in turn lets us define a variable to carry any of them inside (see the `actor` property inside the `Animal` class).

How do we create either a `Dog` or a `Cat` then? Let me show you:

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

First things first: notice that the end result is the same. We’re able to create a generic list of animals, iterate over it and call the same method with 100% certainty that all objects will have it. Again, we don’t know how it will be implemented, because that’s where the components (in this case) come into play.

The main difference here is that instead of having two different classes to describe our animals, we only have one, which mind you, it so malleable that can be turned into any animal given the right set of components.

And if you haven’t noticed yet, although the same effect can be achieved by either inheritance or composition, the first one happens during compilation (or interpretation) time, however the second one happens during execution time. How is this important? It is actually **very** important, you see, given the right set of methods, you can turn a `Cat` into a `Dog` or even into a brand new animal during execution, something you couldn’t do with inheritance.

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

With the new `setActor` method, you can change the barker for a moewer at any given point and while that behavior might seem a bit odd, there could be use cases where this level of dynamism is perfect for your logic.

## Which one is better then?

Now that we understand what they are and how can they be used, the truth is: they’re both great!

Sorry to disappoint but I truly think there are perfect use cases for each of them.

#### The case for Inheritance

Inheritance makes sense because we tend to relate OOP concepts to real-world objects and then we try to generalize their behavior by generalizing their nature.

In other words, we don’t think of a cat and a doc as having 4 legs and a set of organs that allow them to either bark or meow. We think of them as **animals,** which translates to inheritance.

And because of that, the ideal use case for going with inheritance is having 80% of your code being common between two or more classes and at the same time, having the specific code being **very** different. Not only that, but having the certainty that there is no case where you’d need to swap the specific code with each other. Then inheritance is definitely the way to go, with it you’ll have a simpler internal architecture and less code to think about.

#### The case for composition

As we’ve seen so far, composition is a **very flexible** tool. You definitely have to change your mindset a bit, especially if you, like me, have been taught all about inheritance in the past and how that is the only solution to code-reuse inside an OOP context.

However, now that you’ve seen the light (you’re welcome by the way), you know that’s not true. Not only that, you also know that the generic code can also be abstracted into different components, which in turn can be as complex as they need (as long as they keep their public interface the same) and that we can swap them during runtime, which is something that to me, is amazingly flexible.

The other great benefit I see is that while with inheritance, if you need to create a new specific class (like adding a `Lion` class now), you’d have to understand the code of the `FourLeggedAnimal` class to make sure you now what you’re getting from it. And this would be just so that you can implement a different version of the `speak` method. However, if you went with composition, all you’d have to do is create a new class implementing the new logic for the `speak` method, unaware of anything else, and that’s it.

Of course, withing the context of this example, the extra cognitive load of reading a very simple class might seem irrelevant, however, consider a real-world scenario where you’d have to go through hundreds of lines of code just to make sure you understand a base class. That’s definitely not ideal.

---

In my book, composition wins 8 out of 10 times, however, there is a case for inheritance and the simple implementation it provides, so I tend to leave a door open, just in case.

What about you? Is there a clear winner in your case? Do you prefer one over the other? Leave a comment down below and share which one you think is the best one and why!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
