> * 原文地址：[Writing Better Adapters](https://medium.com/@dpreussler/writing-better-adapters-1b09758407d2)
* 原文作者：[Danny Preussler](https://medium.com/@dpreussler)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

Implementing adapters is one of the most frequent tasks for an Android developer. It’s the base for every list. Looking at apps, lists are the base of most apps.

The schema we follow to implement list views is often the same: a View with an adapter that holds the data. Doing this all the time can make us blind to what we are writing, even to ugly code. Even worse, we end up repeating that ugly code.

It’s time to take a close look into adapters.

### RecyclerView Basics

The basic operations for RecyclerViews (but also applicable for ListView) are:

*   Creating the view and the ViewHolder that holds the view information.
*   Binding the ViewHolder to the data that the adapter holds, probably a list of model classes.

Implementing this is pretty straightforward and not much can be done wrong here.

### RecyclerView With Different Types

It gets trickier when you need to have different kind of items in your views. It might be different kind of cards in case you use CardViews or could be ads stitched in between your elements. You might even have a list of completely different kind of objects (this article uses [Kotlin[1]](https://kotlinlang.org/) but it can be easily applied to Java as no language specific feature are used)

    interface Animal
    class Mouse: Animal
    class Duck: Animal
    class Dog: Animal
    class Car

You have various animals and then suddenly something like a car that is totally unrelated.

In those use cases you have probably different view types you need to show. Means you need to create different ViewHolders and probably inflate different layouts in each. The API defines type identifier as integers, that’s where the ugliness starts!

But let’s look at some code. When you have more than one item type you announce this by overriding:

    override fun getItemViewType(position: Int) : Int

as the default implementation always returns zero. The implementer needs to translate the types into Integer values.

Next step: create the ViewHolders. So you have to implement:

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder

In this method the API tells the Integer type you passed earlier as parameter. The implementation is pretty trivial: a switch statement, or something similar, can be used to create ViewHolders for every given type.

The difference comes when binding the newly created (or recycled) ViewHolder:

    override fun onBindViewHolder(holder: ViewHolder, position: Int): Any

Notice that here there is no type parameter. You could use getItemViewType if needed but normally it’s not needed. You could have some bind() method in a base class of all our different ViewHolders that you can call.

### The Uglyness

So what is the problem now? Looks straightforward to implement, isn’t it?

Let’s look once again into getItemViewType().

The system needs the type for every position. So you have to translate an item in your backing model list to a view type.

You might want to write something like:

    if (things.get(position) is Duck) {
        return TYPE_DUCK
    } else if (things.get(position) is Mouse) {
        return TYPE_MOUSE
    }

Can we agree on how ugly this is?  It might get even worse if your ViewHolders don’t share a common base class. If they are totally different types, in your lists you have the same ugly code when binding the ViewHolder:

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        val thing = things.get(position)
        if (thing is Animal) {
            (holder as AnimalViewHolder).bind(thing as Animal)
        } else if (thing is Car) {
            (holder as CarViewHolder).bind(thing as Car)
        }
    ...
    }

This is a mess. instance-of checks and dozens of casting. Both are code smells and should be even considered [anti-patterns[2]](http://www.yegor256.com/2015/04/02/class-casting-is-anti-pattern.html).

Many years ago I had a couple of quotes attached to my monitor. One of them was from [Effective C++ by Scott Meyers[3]](https://books.google.de/books/about/Effective_C++.html?id=eQq9AQAAQBAJ&source=kp_cover&redir_esc=y) (one of the best IT books ever written) and goes like this:

> Anytime you find yourself writing code of the form “if the object is of type T1, then do something, but if it’s of type T2, then do something else,” slap yourself.

If you look at those adapter implementation, there is a lot of slapping to be done.

*   We have type checks and we have lots of ugly casts!
*   This is simply not object orientated code! OO just celebrated its 50th birthday so we should try to use more of its strengths.
*   In addition, the way we implemented those adapters is a violation of the “[Open-Closed[4]](https://en.wikipedia.org/wiki/Open/closed_principle)” rule from the [SOLID[5]](https://en.wikipedia.org/wiki/SOLID_%28object-oriented_design%29) principles. It says: “open for extension but closed for modifications”. But when we would add another type to our classes, another Model, let’s say Rabbit and therefore RabbitViewHolder, we have to change lots of methods in the adapter. A clear violation of the principle. A new kind of object should not lead to modifications in existing methods.

So let’s try to solve this.

### Let’s Fix It

One alternative would be to put something in the middle to do the translation for us. It could be as simple as putting your Class types in some Map and retrieve the type with one call. It would be something like:

    override fun getItemViewType(position: Int) : Int 
       = types.get(things.javaClass)

It’s much better now isn’t it?  The sad answer is: not really! In the end this just hides instance-of.

How would you implement the onBindViewholder() we’ve seen above? It would be something like: if object is of type T1 then do.. else… so still slapping to be done here.

The goal should be to be able to add new view types without even touching the adapter.

Therefore: don’t create your own type mapping in the adapter between the models and the views in the first place. Google suggests using layout ids. With this trick you don’t need the artificial type mappings by simply using the layout id you’re inflating. And of course you probably save another enum as [#perfmatters[6]](https://twitter.com/hashtag/perfmatters).

But still you need to map those to each other? How?

In the end end you need to map models to views. Could this knowledge move to the model?

It would be tempting to put the type into your model, something like.

    fun getType() : Int = R.layout.item_duck

This way the adapter implementation for type could be totally generic:

    override fun getItemViewType(pos: Int) = things[pos].getType()

Open-Closed principle is applied, no changes needed when adding new models.

But now you totally mixed our layers and indeed broke the complete architecture. Entities know about presentation, arrows pointing into the wrong direction. [This must be unacceptable for us[7]](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html).  And again: adding a method into an object to asks for it’s type is not object orientated. You again would just hide the instance-of check.

### The ViewModel

One way to approach this, is to have separat ViewModels instead of using our Model directly. In the end our problem was that our models are disjoint, they don’t share a common base: a car is not an animal. And this is correct. Only for the presentation layer you need to show them in on list. So when you introduce models for this layer you don’t have this problem, they can have a common base.

    abstract class ViewModel {
        abstract fun type(): Int
    }
    class DuckViewModel(val duck: Duck): ViewModel() {
        override fun type() = R.layout.duck
    }
    class CarViewModel(val car: Car): ViewModel() {
        override fun type() = R.layout.car
    }

So you simply wrapped the models. You don’t need to modify them at all and keep view specific code in those new ViewModels. This way you can also add all formatting logic into there and use Android’s new [Data Binding Library[8]](https://developer.android.com/topic/libraries/data-binding/index.html).

The idea of using list of ViewModels in the adapter instead of the Models helps especially when you need artificial items like dividers, section headers or simply advertisement items.

This is one approach to solve the problem. But not the only one.

### The Visitor

Let’s go back to our initial idea of only using the Model. If you would have lots of model classes, maybe you don’t want to create lots of ViewModel one each.  Thinking of the type() method that you added in the first place into the model, you missed some decoupling. You need to avoid having the presentation code in there directly. You need to indirect it, move the actual type knowledge to somewhere else. How about adding an interface into this type() method:

    interface Visitable {
        fun type(typeFactory: TypeFactory) : Int
        }

Now you might ask what have you won here as the factory would still need to branch between types like the adapter did in the first place, right?

No it does not! This approach will be based on the [Visitor pattern[9]](https://en.wikipedia.org/wiki/Visitor_pattern), one of the classic [Gang-of-Four pattern[10]](https://en.wikipedia.org/wiki/Design_Patterns). All the model will do, is forwarding this type call:

    interface Animal : Visitable
        interface Car : Visitable

    class Mouse: Animal {
        override funtype(typeFactory: TypeFactory) 
            = typeFactory.type(this)
            }

The factory has variations you need:

    interface TypeFactory {
        fun type(duck: Duck): Int
        fun type(mouse: Mouse): Int
        fun type(dog: Dog): Int
        fun type(car: Car): Int
        }

This way it’s totally type safe, no instance-of, no casts needed at all.

And the responsibility of the factory is clear: it knows about the view types:

    class TypeFactoryForList : TypeFactory {
        override fun type(duck: Duck) = R.layout.duckoverride fun type(mouse: Mouse) = R.layout.mouse    override fun type(dog: Dog) = R.layout.dogoverride fun type(car: Car) = R.layout.car

I could even also create ViewHolders to keep the knowledge about the ids in one place. So when adding a new view, this is the place to add. This should be pretty SOLID. You might need another method for new types but not modify any existing method: Open for Extension, Closed for Modification.

Now you might ask: why not use the factory directly from adapter instead using the indirection of the model? Only with this path you get the type safety without need of casts and type checks. Take a moment to realize this here, there is not a single cast needed! This indirection is the magic behind Visitor Pattern.

Following this approach leaves the adapter with a very generic implementation that hardly ever needs to be changed.

### Conclusion

*   Try to keep your presentation code clean.
*   Instance-of checks should be a red flag!
*   Look out for down casting as it’s a code smell.
*   Try to replace those two with correct OO usage. Think about interfaces and inheritance.
*   Try to use generics to prevent castings.
*   Use ViewModels.
*   Check out for usages for the Visitor pattern.

I would be happy to learn other ideas to make our Adapters cleaner.