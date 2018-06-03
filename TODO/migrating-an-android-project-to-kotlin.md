
> * 原文地址：[Migrating an Android project to Kotlin](https://medium.com/google-developers/migrating-an-android-project-to-kotlin-f93ecaa329b7)
> * 原文作者：[Ben Weiss](https://medium.com/@keyboardsurfer)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/migrating-an-android-project-to-kotlin.md](https://github.com/xitu/gold-miner/blob/master/TODO/migrating-an-android-project-to-kotlin.md)
> * 译者：[wilsonandusa](https://github.com/wilsonandusa)
> * 校对者：[phxnirvana](https://github.com/phxnirvana), [Zhiw](https://github.com/Zhiw)

# 将 Android 项目迁移到 Kotlin 语言

不久前我们开源了 [Topeka](https://github.com/googlesamples/android-topeka)，一个 Android 小测试程序。
这个程序是用 [integration tests](https://github.com/googlesamples/android-topeka/tree/master/app/src/androidTest/java/com/google/samples/apps/topeka) 和 [unit tests](https://github.com/googlesamples/android-topeka/tree/master/app/src/test/java/com/google/samples/apps/topeka) 进行测试的, 而且本身全部是用 Java 写的。至少以前是这样的...

### 圣彼得堡岸边的那个岛屿叫什么? _ _ _ _ _ _

2017年谷歌在开发者大会上官方宣布 [支持 Kotlin 编程语言](https://blog.jetbrains.com/kotlin/2017/05/kotlin-on-android-now-official/)。从那时起，我便开始移植 Java 代码，**同时在过程中学习 Kotlin。**

> 从技术角度上来讲，这次的移植并不是必须的，程序本身是十分稳定的，而（这次移植）主要是为了满足我的好奇心。Topeka 成为了我学习一门新语言的媒介。

**如果你好奇的话可以直接来看 [GitHub 上的源代码](https://github.com/googlesamples/android-topeka/tree/kotlin)。
目前 Kotlin 代码在一个独立的分支上，但我们计划在未来某个时刻将其合并到主代码中。**

这篇文章涵盖了我在迁移代码过程中发现的一些关键点，以及 Android 开发新语言时有用的小窍门。

---

![](https://cdn-images-1.medium.com/max/1600/1*oML2dls3WxjhTnR4a_TTRg.png)

看上去依旧一样

### 🔑 关键的几点

- Kotlin 是一门有趣而强大的语言
- 多测试才能心安
- 平台受限的情况很少

---

### 移植到 Kotlin 的第一步

[![](https://ws4.sinaimg.cn/large/006tNc79ly1fhzfqen28gj313o0cswga.jpg)](https://twitter.com/anddev_badvice/status/864998931817615360)

虽然不可能像 Bad Android Advice 所说的那么简单，但至少是个不错的出发点。

第一步和第二步对于学好 Kotlin 来说确实很有用。

然而第三步就要看我个人的造化了。

#### 对于 Topeka 来说实际步骤如下：

1. 学好 [ Kotlin 的基础语法](https://kotlinlang.org/docs/reference/basic-syntax.html)
2. 通过使用 [Koan](https://github.com/Kotlin/kotlin-koans) 来逐步熟悉这门语言
3. 使用 “⌥⇧⌘K” 保证（转化后的文件）仍然能一个个通过测试
4. 修改 Kotlin 文件使其更加符合语言习惯
5. 重复第四步直到你和审核你代码的人都满意
6. 完工并上交

### 互通性

**一步步去做是很明智的做法。**
Kotlin 编译为 Java 字节码后两种语言可以互相通用。而且同一个项目中两种语言可以共存，所以并不需要把全部代码都移植成为另一种语言。
但如果你本来就想这么做，那么重复的改写就是有意义的，这样你在迁移代码时可以尽量地维持项目的稳定性，并在此过程中有所收获。

### 多做测试才能更加安心

搭配使用单元和集成测试的好处很多。在绝大多数情况下，这些测试是用来确保当前修改没有损坏现有的功能。

我选择在一开始使用一个不是很复杂的数据类。在整个项目中我一直在用这些类，它们的复杂性相比来说很低。这样来看在学习新语言的过程中这些类就成为了最理想的出发点。

在通过使用 Android Studio 自带的 Kotlin 代码转换器移植一部分代码后，我开始执行并通过测试，直到最终将测试本身也移植为 Kotlin 代码。

如果没有测试的话，我在每次改写后都需要对可能受影响的功能手动进行测试。自动化的测试在我移植代码的过程中显得更加快捷方便。

所以，如果你还没有对你的应用进行正确测试的话，以上就是你需要这么做的又一个原因。 👆

### 生成的代码并不是每一次都看起来很棒！！

在完成最开始**几乎**自动化的移植代码之后，我开始学习 [Kotlin 代码风格指南](https://kotlinlang.org/docs/reference/coding-conventions.html)。 这使我发现还有一条很长的路要走。

总体来讲，代码生成器用起来很不错。尽管有很多语言特征和风格在转换过程中没有被使用，但翻译语言本来就是件很棘手的事，这么做可能更好一些，尤其是当这门语言所包含很多的特征或者可以通过不同方式进行表达的时候。

如果想要了解更多有关 Kotlin 转换器的内容， [Benjamin Baxter](https://medium.com/@benbaxter) 写过一些他自己的经历：

[![](https://ws1.sinaimg.cn/large/006tNc79ly1fhzfrxrvuqj313o0a2400.jpg)](https://medium.com/google-developers/lessons-learned-while-converting-to-kotlin-with-android-studio-f0a3cb41669)

### ‼️ ⁉

我发现自动转换会生成很多的 `?` 和 `!!` 。
这些符号是用来定义可为空的数值和保证其不为空值的。他们反而会导致 `空指针异常`。
我不禁想到一条很恰当的名言

> “过多使用感叹号，” 他一边摇头一边说道， ”是心理不正常的表现。” — [Terry Pratchett](https://wiki.lspace.org/mediawiki/Multiple_exclamation_marks)

在大部分情况下它不会成为空值，所以我们不需要使用空值的检查。同时也没必要通过构造器来直接初始所有的数值，可以使用 `lateinit` 或者委托来代替初始的流程。

然而这些方法也不是万能的：

[![](https://ws3.sinaimg.cn/large/006tNc79ly1fhzfsm2ll1j310c0dedhp.jpg)](https://twitter.com/dimsuz/status/883052997688930304)

有时候变量会成为空值。

看来我得重新把 view 定义为可为空值。

在其他情况下你还是得检查是否 `null` 存在。如果存在 `supportActionBar` 的话， `*supportActionBar*?.setDisplayShowTitleEnabled(false)` 才会执行问号以后的代码。
这意味着更少的基于 null 检查的 if 条件声明。 🔥

直接在非空数值上使用 stdlib 函数非常方便：

```
toolbarBack?.let {
    it.scaleX = 0f
    it.scaleY = 0f
}
```

大规模地使用它...

---

### 变得越来越符合语言习惯

因为我们可以通过审核者的反馈不断地改写生成的代码来使其变得更加符合语言的习惯。这使代码更加简洁并且提升了可读性。以上特点可以证明 Kotlin 是门很强大的语言，

来看看我曾经遇到过的几个例子吧。

#### 少读点儿并不一定是件坏事
我们拿 adapter 里面的 `getView` 来举例：

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

Java 中的 getView

```
override fun getView(position: Int, convertView: View?, parent: ViewGroup) =
    (convertView ?: createView(parent)).also { bindView(it) }
```

Kotlin 的 getView

这两段代码在做同一件事：

先检查 `convertView` 是否为 `null` ，然后在 `createView(...)` 里面创建一个新的 `view` ，或者返回 `convertView`。同时在最后调用 `bindView(...)`.

两端代码都很清晰，不过能从八行代码减到只有两行确实**让我很惊讶。**

#### 数据类很神奇 🦄

为了进一步展现 Kotlin 的精简所在，使用数据类可以轻松避免冗长的代码：

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

下面我们来看怎么用 Kotlin 写这段代码:

```
data class Player( val firstName: String?, val lastInitial: String?, val avatar: Avatar?)
```

是的，在保证功能的情况下少了整整五十五行代码。这就是[数据类的神奇之处](https://kotlinlang.org/docs/reference/data-classes.html)。

#### 扩展功能性

下面可能就是传统 Android 开发者觉得奇怪的地方了。Kotlin 允许在一个给定范围内创建你自己的 DSL。

**来看看它是如何运作的**

有时我们会在 Topeka 里通过
`Parcel` 传递 boolean。Android 框架的 API 无法直接支持这项功能。在一开始实现这项功能的时候必须调用一个功能类函数例如`ParcelableHelper.writeBoolean(parcel, value)`。
如果使用 Kotlin，[扩展函数](https://kotlinlang.org/docs/reference/extensions.html)可以解决之前的难题：

```
import android.os.Parcel

/**
 * 将一个 boolean 值写入[Parcel]。
 * @param toWrite 是即将写入的值。
 */
fun Parcel.writeBoolean(toWrite: Boolean) = writeByte(if (toWrite) 1 else 0)

/**
 * 从[Parcel]中得到 boolean 值。
 */
fun Parcel.readBoolean() = 1 == this.readByte()
```
当写好以上代码之后，我们可以把
 `parcel.writeBoolean(value)` 和 `parcel.readBoolean()` 当成框架的一部分直接调用。要不是因为 Android Studio 使用不同的高亮方式区分扩展函数，很难看出它们之间的区别。


**扩展函数可以提升代码的可读性。** 来看看另一个例子：在 view 的层次结构中替换 Fragment。

如果使用 Java 的话代码如下：

```
getSupportFragmentManager().beginTransaction()
        .replace(R.id.quiz_fragment_container, myFragment)
        .commit();
```

这几行代码其实写的还不错。但每次当 Fragment 被替换的时候你都要把这几行代码再写一遍，或者在其他的 Utils 类中创建一个函数。

如果使用 Kotlin，当我们在 `FragmentActivity` 中需要替换 Fragment 的时候，只需要使用如下代码调用 `replaceFragment(R.id.container, MyFragment())` 即可:

```
fun FragmentActivity.replaceFragment(@IdRes id: Int, fragment: Fragment) {
    supportFragmentManager.beginTransaction().replace(id, fragment).commit()
}
```

替换 Fragment 只需一行代码
#### 少一些形式，多一点儿功能

**高阶函数**太令我震撼了。是的，我知道这不是什么新的概念，但对于部分传统 Android 开发者来说可能是。我之前有听说过这类函数，也见有人写过，但我从未在我自己的代码中使用过它们。

在 Topeka 里我有好几次都是依靠 `OnLayoutChangeListener` 来实现注入行为。如果没有 Kotlin ，这样做会生成一个包含重复代码的匿名类。

迁移代码之后，只需要调用以下代码：
`view.onLayoutChange { myAction() }`

这其中的代码被封装到如下扩展函数中了：

```
/**
 * 当布局改变时执行对应代码
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

使用高阶函数减少样板代码

另一个例子能证明以上的功能同样可以被应用于数据库的操作中：

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

少一些形式，多一些功能

这样写完后，API 使用者只需要调用 `db.transact { operation() }` 就可以完成以上所有操作。

[通过 Twitter 进行更新](https://twitter.com/pacoworks/status/885147451757350912): 通过使用 `SQLiteDatabase.()` 而不是 `()` 可以在 `operation()` 中传递函数并实现直接使用数据库。🔥

不用我多说你应该已经懂了。

> 使用高阶和扩展函数能够提升项目的可读性，同时能去除冗长的代码，提升性能并省略细节。

---

### 有待探索

目前为止我一直在讲代码规范以及一些开发的惯例，都没有提到有关 Android 开发的实践经验。

这主要是因为我对这门语言还不是很熟，或者说我还没有花太大精力去收集并发表这方面的内容。也许是因为我还没有碰到这类情况，但似乎还有相当多的平台特定的语言风格。如果你知道这种情况，请在评论区补充。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
