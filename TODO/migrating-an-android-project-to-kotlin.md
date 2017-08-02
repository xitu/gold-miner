
> * 原文地址：[Migrating an Android project to Kotlin](https://medium.com/google-developers/migrating-an-android-project-to-kotlin-f93ecaa329b7)
> * 原文作者：[Ben Weiss](https://medium.com/@keyboardsurfer)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/migrating-an-android-project-to-kotlin.md](https://github.com/xitu/gold-miner/blob/master/TODO/migrating-an-android-project-to-kotlin.md)
> * 译者：
> * 校对者：

# Migrating an Android project to Kotlin

A while ago we open sourced [Topeka](https://github.com/googlesamples/android-topeka), an Android quiz app.
It is tested, using [integration tests](https://github.com/googlesamples/android-topeka/tree/master/app/src/androidTest/java/com/google/samples/apps/topeka) and [unit tests](https://github.com/googlesamples/android-topeka/tree/master/app/src/test/java/com/google/samples/apps/topeka).
And it is purely written in Java. Well… it was

### What’s the name of the island off the coast of St Petersburg? _ _ _ _ _ _

At Google I/O 2017 we announced official [support for the Kotlin programming language](https://blog.jetbrains.com/kotlin/2017/05/kotlin-on-android-now-official/). That’s when I started migrating the code base away from Java, **learning Kotlin on the way.**

> Not that this migration was necessary from a technological standpoint. The app is solid as it stands, but mainly to satisfy my curiosity; Topeka serving as my vehicle to learn a new language.

If you’re curious you can jump straight into the [source code on GitHub](https://github.com/googlesamples/android-topeka/tree/kotlin).
*For now the code is on a separate branch, but we’re planning to merge the Kotlin code into master at some point in the future.*

This post gathers some of the key parts I have found during the migration. It also shows some of the things I found useful while learning a new programming language for Android development.

---

![](https://cdn-images-1.medium.com/max/1600/1*oML2dls3WxjhTnR4a_TTRg.png)

It still looks the same

### 🔑 Key take aways

- Kotlin is a fun, powerful language
- Testing gives peace of mind
- Platform specific idioms are scarce

---

### Initial migration to Kotlin

[![](https://ws4.sinaimg.cn/large/006tNc79ly1fhzfqen28gj313o0cswga.jpg)](https://twitter.com/anddev_badvice/status/864998931817615360)

It’s not as easy as Bad Android Advice put it, but it’s a good starting point.

Steps 1 and 2 are kind of valid for getting started with Kotlin.

I’ll figure out how that 3rd step will play out, though.

#### For Topeka the route was more like this:

1. Read up on the [basic syntax of Kotlin](https://kotlinlang.org/docs/reference/basic-syntax.html)
2. Go through the [Koans](https://github.com/Kotlin/kotlin-koans) to gain basic familiarity with the language
3. Convert files, one by one, via “⌥⇧⌘K”, make sure tests still pass
4. Go over the Kotlin files and make them more idiomatic
5. Repeat step 4 until you and your code reviewers are happy
6. Ship it

### Interoperability

**Going step by step is a sensible approach.
**Kotlin compiles down to Java byte code and the two languages are interoperable. Also it’s possible to have both languages within the same project. So it’s not necessary to migrate all code to another language.

But if that’s your goal, it makes sense to do so iteratively. This way it’s more feasible to maintain a stable application throughout the migration process and learn as you go along.

### Tests ease your mind

Having a suite of unit and integration tests has many benefits.
In most cases they are there to provide confidence that changes have not broken existing behaviour.

Starting off with the less complex data classes was the clear choice for me.
They are being used throughout the project, yet their complexity is comparatively low. This makes them an ideal starting point to set off the journey into a new language.

After migrating some of these using the Kotlin code converter, which is built into Android Studio, executing tests and making them pass, I worked my way up until eventually ending up migrating the tests themselves to Kotlin.

Without tests, I would have been required to go through the touched features after each change, and manually verify them.
By having this automated it was a lot quicker and easier to move through the codebase, migrating code as I went along.

So, if you don’t have your app tested properly yet, there’s one more reason to do so right here. 👆

### Generated code is not always nice to look at ‼️

After an initial round of *mostly* automated migration, I went on to read up on the [Kotlin style guide](https://kotlinlang.org/docs/reference/coding-conventions.html). This page made it clear to me that there’s still a long way ahead.

The converter does a good job, overall. There are a lot of language idioms and features which are not being taken into account during the automated process, though. Which is probably for the better, since translating is tricky. Especially if one language contains more features or achieves similar things in a different way.

For further reading on the Kotlin converter, [Benjamin Baxter](https://medium.com/@benbaxter) has written about his experience:

[![](https://ws1.sinaimg.cn/large/006tNc79ly1fhzfrxrvuqj313o0a2400.jpg)](https://medium.com/google-developers/lessons-learned-while-converting-to-kotlin-with-android-studio-f0a3cb41669)

### ‼️ ⁉

After the automatic conversion I ended up with a lot of `?` and `!!`.
These are used to make a value nullable and assert that something is not null. Which in turn can lead to a `NullPointerException`.
And I couldn’t help but think of a very fitting quote:

> *‘Multiple exclamation marks,’ he went on, shaking his head, ‘are a sure sign of a diseased mind. — *[*Terry Pratchett*](https://wiki.lspace.org/mediawiki/Multiple_exclamation_marks)

In many cases a value doesn’t have to be nullable, so null checks can be removed. It’s not even necessary to initialise all values directly within a constructor. Instead `lateinit` or delegate initialisation can be used.

This doesn’t work for everything though:

[![](https://ws3.sinaimg.cn/large/006tNc79ly1fhzfsm2ll1j310c0dedhp.jpg)](https://twitter.com/dimsuz/status/883052997688930304)

Sometimes vars have to be nullable nonetheless

So I had to go back and make my view members nullable.

In these and other cases you will still have to check, whether something is `null`. Using `*supportActionBar*?.setDisplayShowTitleEnabled(false)` only executes the part after the question mark if there is a `supportActionBar`.
This means a lot less `if` statement based null checks. 🔥

Also executing code with some of the stdlib functions directly on the non-null variable can be handy:

```
toolbarBack?.let {
    it.scaleX = 0f
    it.scaleY = 0f
}
```

let it scale, let it scaaaale…

---

### Incrementally becoming more idiomatic

Going through the generated code and making it more idiomatic, as well as getting reviewer feedback made it obvious that Kotlin is a powerful language. It made things readable and concise.

Let’s take a look at some examples that I came across.

#### Reading less is not always a bad thing

Let’s take an adapter’s `getView` as example:

```
@Override
public View getView(int position, View convertView, ViewGroup parent) {
        if (null == convertView) {
           convertView = createView(parent);
        }
        bindView(convertView);
        return convertView;
}
```

getView in Java

```
override fun getView(position: Int, convertView: View?, parent: ViewGroup) =
    (convertView ?: createView(parent)).also { bindView(it) }
```

getView in Kotlin

These two code snippets do the *same thing*:

Check, whether `convertView` is `null` and either create a new view within `createView(...)` or return `convertView`. Both also call `bindView(...)`.

Both snippets, are equally legible. And boiling things down from 8 lines to mere 2 lines? **Render me impressed.**

#### Data classes are magical 🦄

To make it even more obvious how concise Kotlin can be, data classes easily manage to get rid of some verbosity:

```
public class Player {

    private final String mFirstName;
    private final String mLastInitial;
    private final Avatar mAvatar;

    public Player(String firstName, String lastInitial, Avatar avatar) {
        mFirstName = firstName;
        mLastInitial = lastInitial;
        mAvatar = avatar;
    }

    public String getFirstName() {
        return mFirstName;
    }

    public String getLastInitial() {
        return mLastInitial;
    }

    public Avatar getAvatar() {
        return mAvatar;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }

        Player player = (Player) o;

        if (mAvatar != player.mAvatar) {
            return false;
        }
        if (!mFirstName.equals(player.mFirstName)) {
            return false;
        }
        if (!mLastInitial.equals(player.mLastInitial)) {
            return false;
        }

        return true;
    }

    @Override
    public int hashCode() {
        int result = mFirstName.hashCode();
        result = 31 * result + mLastInitial.hashCode();
        result = 31 * result + mAvatar.hashCode();
        return result;
    }
}
```

Now, let’s look at that in Kotlin:

```
data class Player( val firstName: String?, val lastInitial: String?, val avatar: Avatar?)
```

Yes, that’s 55 lines of code less, expressing the same thing. That’s the [magic of data classes](https://kotlinlang.org/docs/reference/data-classes.html).

#### Extending functionality

This is where things get slightly weird from a traditional Android developer’s point of view. Kotlin allows creating your own DSL within a given scope.

**Let’s see how that works**

At times within Topeka it makes sense to pass around booleans in a `Parcel`. This is not directly supported by the Android Framework APIs.
In the initial implementation it was necessary to explicitly call a utility class’ method like such `ParcelableHelper.writeBoolean(parcel, value)`.
With Kotlin, [extension functions](https://kotlinlang.org/docs/reference/extensions.html) solve that once and for all:

```
import android.os.Parcel

/**
 * Writes a single boolean to a [Parcel].
 * @param toWrite Value to write.
 */
fun Parcel.writeBoolean(toWrite: Boolean) = writeByte(if (toWrite) 1 else 0)

/**
 * Retrieves a single boolean from a [Parcel].
 */
fun Parcel.readBoolean() = 1 == this.readByte()
```

Having this written in one place, makes it possible to call `parcel.writeBoolean(value)` and `parcel.readBoolean()` directly, as if it were part of the framework. If Android Studio would not highlight extension functions differently, they were almost not noticeable.

**Extending functionality makes things easier to read.** Let’s take a look at another example: replacing a Fragment in a view hierarchy

In the Java world this would look something like this:

```
getSupportFragmentManager().beginTransaction()
        .replace(R.id.quiz_fragment_container, myFragment)
        .commit();
```

That’s actually not too bad. But you’ll have to write this code, *every single time* a fragment will be replaced. Or create a method somewhere, for example in yet another Utils class.

With Kotlin, an extension function makes it possible to simply call `replaceFragment(R.id.container, MyFragment())` to replace a fragment within any `FragmentActivity` within the project, by adding this code:

```
fun FragmentActivity.replaceFragment(@IdRes id: Int, fragment: Fragment) {
    supportFragmentManager.beginTransaction().replace(id, fragment).commit()
}
```

Replacing Fragments in a single line
#### Less ceremony, more functionality

**Higher order functions** blew my mind.
Yes, I know that this is not a new concept in general. But for the old fashioned Android developer, it actually is. I had heard of them before and have seen them written, but making use of them within my own code is a different story.

Within several places in Topeka, I am relying on an `OnLayoutChangeListener` to inject behaviour. In a pre-Kotlin world this would usually result in an anonymous class, with some duplicated code.

After the migration, all that’s required to call is:
`view.onLayoutChange { myAction() }`

The ceremony around that has been encapsulated in this extension function:

```
/**
 * Performs a given action when a layout change happens.
 */
inline fun View.onLayoutChange(crosssinline action: () -> Unit) {
    addOnLayoutChangeListener(object : View.OnLayoutChangeListener {
        override fun onLayoutChange(v: View, left: Int, top: Int,
                                    right: Int, bottom: Int,
                                    oldLeft: Int, oldTop: Int,
                                    oldRight: Int, oldBottom: Int) {
            removeOnLayoutChangeListener(this)
            action()
        }
    })
}
```

Higher order function to reduce boilerplate

Giving another example, this behaviour can also be applied to things like database transactions:

```
inline fun SQLiteDatabase.transact(operation: SQLiteDatabase.() -> Unit) {
    try {
        beginTransaction()
        operation()
        setTransactionSuccessful()
    } finally {
        endTransaction()
    }
}
```

Less ceremony for database transactions

Now, instead of performing the whole dance to begin and end a transaction, all the user of this API has to call is `db.transact { operation() }`.

[Update via Twitter](https://twitter.com/pacoworks/status/885147451757350912): Using`SQLiteDatabase.()` instead of just `()` to pass in a function allows working on the database directly within the `operation()`. 🔥

I could go on, but you get the gist.

> Higher order functions and extensions are handy to make a project easier to read and more fun to work with by removing unnecessary verbosity, adding functionality and hiding implementation details.

---

### Things to discover

Throughout the conversion I have not come across many best practices for Android development just yet. So far I have mostly been sticking to the style guide and code conventions.

That may be because I am still new to the language or because there hasn’t been that much investment in gathering and publicising these yet. Maybe there is a collection which I am yet to come across, but it seems that there is quite some space for platform specific idioms.
If you’re aware of collections like this, please add them to the comments.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
