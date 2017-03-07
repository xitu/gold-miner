> * 原文地址：[Functional Programming for Android developers — Part 2](https://medium.com/@anupcowkur/functional-programming-for-android-developers-part-2-5c0834669d1a#.r6495260x)
* 原文作者：[Anup Cowkur](https://medium.com/@anupcowkur)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

---

# Functional Programming for Android developers — Part 2

![](https://cdn-images-1.medium.com/max/1600/1*1-2UBc_3rxKqKn89iMN2nQ.jpeg)

If you haven’t read part 1, please read it here:

[**Functional Programming for Android developers — Part 1**
](https://medium.com/@anupcowkur/functional-programming-for-android-developers-part-1-a58d40d6e742)

In the last post, we learnt about *Purity*, *Side effects* and *Ordering.* In this part, let’s talk about *immutability* and *concurrency*.

### Immutability

Immutability is the idea that a value once created can never be modified.

Let’s say I have an *Car* classlike this:

    public final class Car {
        private String name;
    
        public Car(final String name) {
            this.name = name;
        }
    
        public void setName(final String name) {
            this.name = name;
        }
    
        public String getName() {
            return name;
        }
    }

Since it has a setter, I can modify the name of the car after I’ve constructed it:

    Car car = new Car("BMW");
    car.setName("Audi");

This class is *not* immutable. It can be modified after creation.

Let’s make it immutable. In order to do that, we have to:

- Make the name variable *final.*
- Remove the setter.
- Make the class *final* as well so that another class cannot extend it and modify it’s internals.

```
public final class Car {
    private final String name;

    public Car(final String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
```

Now if someone needs to create a new car, they need to initialise a new object. No one can modify our car once it’s created. This class is now *immutable*.

But what about the *getName()* method? It’s returning our name variable to the outside world right? What if someone were to modify the *name* value after getting a reference to it from this getter?

In Java, [strings are immutable by default](http://stackoverflow.com/questions/1552301/immutability-of-strings-in-java). Even if someone got a reference to our *name* string and were to modify it, they would get a copy of the *name* string and the original string would remain intact.

But what about things that are not immutable? A list perhaps? Let’s modify the *Car* class to have a list of people who drive it.

    public final class Car {
        private final List<String> listOfDrivers;
    
        public Car(final List<String> listOfDrivers) {
            this.listOfDrivers = listOfDrivers;
        }
    
        public List<String> getListOfDrivers() {
            return listOfDrivers;
        }
    }

In this case, someone can use the *getListOfDrivers()* method to get a reference to our internal list and modify it thus rendering our class *mutable*.

To make it immutable, we must pass a deep copy of the list in the getter that is separate from our list so that the new list can be safely modified by the caller. A deep copy means that we copy all the dependent data recursively. For instance, if the list was a list of *Driver* objects instead of just plain strings, we’d have to copy each of the *Driver* objects too. Otherwise, we’d be making a new list with references to the original *Driver* objects which could be mutated. In our class, since the list is composed of immutable strings, we can make a deep copy like this:

    public final class Car {
        private final List<String> listOfDrivers;
    
        public Car(final List<String> listOfDrivers) {
            this.listOfDrivers = listOfDrivers;
        }
    
        public List<String> getListOfDrivers() {
            List<String> newList = new ArrayList<>();
            for (String driver : listOfDrivers) {
                newList.add(driver);
            }
            return newList;
        }
    }

Now this class is truly *immutable*.

### Concurrency

Okay, so *immutability* is cool and all but why bother? As we talked about in part 1, pure functions allow us easy concurrency and if an object is immutable, it’s very easy to use in pure functions since you can’t modify it and cause side effects.

Let’s see an example. Suppose that we add a *getNoOfDrivers* method to our *Car* class and we also make it *mutables* by allowing an external caller to modify the number of drivers variable like this:

    public class Car {
        private int noOfDrivers;
    
        public Car(final int noOfDrivers) {
            this.noOfDrivers = noOfDrivers;
        }
    
        public int getNoOfDrivers() {
            return noOfDrivers;
        }
    
        public void setNoOfDrivers(final int noOfDrivers) {
            this.noOfDrivers = noOfDrivers;
        }
    }

Suppose we share an instance of this *Car* class across 2 threads: *Thread_1* and *Thread_2. Thread_1* wants to do some calculation based on the number of drivers so it calls *getNoOfDrivers().* Meanwhile *Thread_2* comes in and modifies the *noOfDrivers* variable. *Thread_1* does not know about this change and happily carries on with it’s calculations. These calculations would be wrong since the state of the world has been modified without by *Thread_2* without *Thread_1* knowing about them.

The following sequence diagram illustrates the issue:

![](https://cdn-images-1.medium.com/max/2000/1*PXDu-vgwZ6hmh96lc5TYOg.png)

This is a classic race condition known as the Read-Modify-Write problem. The traditional way to solve this is to use [locks and mutexes](https://en.wikipedia.org/wiki/Mutual_exclusion) so that only a single thread can operate on shared data at a time and let go of the lock once the operation is complete (In our case, *Thread_1* would hold a lock on *Car* until it completes it’s calculation).

This type of lock-based resource management is notoriously hard to do safely and leads to concurrency bugs that are extremely difficult to analyse. Many programmers have lost their sanity to [deadlocks and livelocks.](https://en.wikipedia.org/wiki/Deadlock)

How would immutability fix this you say? Let’s make *Car* immutable again:

    public final class Car {
        private final int noOfDrivers;
    
        public Car(final int noOfDrivers) {
            this.noOfDrivers = noOfDrivers;
        }
    
        public int getNoOfDrivers() {
            return noOfDrivers;
        }
    }

Now, *Thread_1* can carry out it’s calculations without worry since it’s guaranteed that *Thread_2* cannot modify the car object. If *Thread_2* wants to modify *Car,* then it’ll create it’s own copy to do so and *Thread_1* will be completely unaffected by it. No locks necessary.

![](https://cdn-images-1.medium.com/max/2000/1*EyBmNH__K0QlOfapgib_rg.png)

Immutability ensures that shared data is thread-safe by default. Things that *should not* be modified *cannot* be modified.

#### What If we need to have global modifiable state?

To write useful applications, we need shared modifiable state in many instances. There might a genuine requirement to update *noOfDrivers* and have it reflect across the system. We’ll deal with situations like that by using state isolation and pushing side effects to the edges of our system when we talk about *functional architectures* in an upcoming chapter.

### Persistent data structures

Immutable objects may be great, but if we use them without restraint, they will overload the garbage collector and cause performance issues. Functional programming also provides us specialised data structures to use immutability while minimising object creation. These specialised data structures are known as *Persistent Data Structures.*

A persistent data structure always preserves the previous version of itself when it is modified. Such data structures are effectively immutable, as their operations do not (visibly) update the structure in-place, but instead always yield a new updated structure.

Let’s say we have the following strings that we want to store in memory: **reborn, rebate, realize, realizes, relief, red, redder.**

We can store them all separately but that would take more memory than we need. If we look closely, we can see that these strings have many characters in common and we could represent them in a single [*trie*](https://en.wikipedia.org/wiki/Trie) data structure like this (not all tries are persistent but tries are one of the tools we can use to implement persistent data structures) :

![](https://cdn-images-1.medium.com/max/1600/1*5_7HbxMEMGRmpPkxlUnIHA.png)

This is the basic idea behind how persistent data structures work. When a new string is to be added, we simply create a new node and link it in the appropriate place. If an object which is using this structure needs to delete a node, we simply stop referencing it from that object but the actual node is not deleted from memory thus preventing side effects. This ensures that other objects that are referencing this structure can continue to use it. When no other object is referencing it, we can GC the whole structure to reclaim memory.

Persistent data structures in Java are not a radical idea. [Clojure](https://clojure.org/) is a functional language that runs on the JVM and has an entire standard library of persistent data structures. You could directly use the Clojure’s standard lib in Android code but it has significant size and method count. A better alternative I’ve found is a library called [PCollections](https://pcollections.org/). It has [427 methods and 48Kb dex size](http://www.methodscount.com/?lib=org.pcollections%3Apcollections%3A2.1.2) which makes it great for our purposes.

As an example, here’s how we’d create and use a persistent linked list using PCollections:

    ConsPStack<String> list = ConsPStack.*empty*();
    System.*out*.println(list);  // []
    
    ConsPStack<String> list2 = list.plus("hello");
    System.*out*.println(list);  // []
    System.*out*.println(list2); // [hello]
    
    ConsPStack<String> list3 = list2.plus("hi");
    System.*out*.println(list);  // []
    System.*out*.println(list2); // [hello]
    System.*out*.println(list3); // [hi, hello]
    
    ConsPStack<String> list4 = list3.minus("hello");
    System.*out*.println(list);  // []
    System.*out*.println(list2); // [hello]
    System.*out*.println(list3); // [hi, hello]
    System.*out*.println(list4); // [hi]

As we can see, none of the lists are modified in-place but a new copy is returned every time a modification is required.

PCollections has a bunch of standard persistent data structures implemented for various use cases and is worth exploring. They also play nice with Java’s standard collection library which is quite handy.

Persistent data structures are a vast subject and this section is only touching the tip of the iceberg. If you are interested in learning more about them, [Chris Okasaki’s Purely Functional Data Structures](https://www.amazon.com/Purely-Functional-Structures-Chris-Okasaki/dp/0521663504) comes highly recommended.

### Summary

*Immutability* and *Purity* are a potent combo allowing us to write safe, concurrent programs. Now that we have learnt enough concepts, we can look at how to devise a functional architecture for Android apps in the next part of this series.

### **Extra credit**

I did a whole talk on immutability and concurrency at Droidcon India. Enjoy!

[![](https://i.ytimg.com/vi_webp/lE9XnvBV-ys/sddefault.webp)](https://www.youtube.com/embed/lE9XnvBV-ys?wmode=opaque&widget_referrer=https%3A%2F%2Fmedium.com%2Fmedia%2F77eb6effeadb0e8ce1fd46d5f9efdc2c%3FpostId%3D5c0834669d1a&enablejsapi=1&origin=https%3A%2F%2Fcdn.embedly.com&widgetid=1)