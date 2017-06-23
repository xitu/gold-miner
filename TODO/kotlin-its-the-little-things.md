> * 原文地址：[Kotlin: It’s the little things](https://m.signalvnoise.com/kotlin-its-the-little-things-8c0f501bc6ea)
> * 原文作者：[Dan Kim](https://m.signalvnoise.com/@lateplate)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[CACppuccino](https://github.com/CACppuccino)
> * 校对者：[wilsonandusa](https://github.com/wilsonandusa) [Zhiw](https://github.com/Zhiw)

---

# Kotlin: 小菜一碟
Kotlin 有不少很棒的特性，而其中一些如[扩展函数](https://kotlinlang.org/docs/reference/extensions.html#extension-functions)、 [高阶函数](https://kotlinlang.org/docs/reference/lambdas.html)、和[Null 安全性](https://kotlinlang.org/docs/reference/null-safety.html)更是引人注意。 毫无疑问，这些基本而强大的特性正是这门语言的根基所在。

![](https://cdn-images-1.medium.com/max/800/1*O9IHQ8ivLkRCDLBtGZvaNg.png)

我喜爱这些特性，不过同时，这里也有一些你所不太知道的，却一样令我钟情的“小东西”。

有一些东西小而微，可能你每天都在成百次地使用它，却感受不到任何“高级”的地方。它是这门语言的基础知识，但相比 Java，却为你节省了很多精力与时间。

让我们看一下这个简洁的例子：

```
// Java
1 | View view = getLayoutInflater().inflate(layoutResource, group);
2 | view.setVisibility(View.GONE)
3 | System.out.println(“View " + view + " has visibility " + view.getVisibility() + ".");

// Kotlin
1 | val view = layoutInflater.inflate(layoutResource, group)
2 | view.visibility = View.GONE
3 | println(“View $view has visibility ${view.visibility}.")
```

一眼望去，Kotlin 的版本似乎看起来没什么不同，但它们的差别却很微妙，从中我们可以解读出一些长远来看令你的工作变得更棒的东西。

浏览完了上面那个例子之后，让我们看看**在 Kotlin 中相对于 Java 永远无需做的五件事**

**(注意：为了看的清楚，Java 总会首先展示，Kotlin 其次。代码的其余部分已被截掉，不同之处以粗体标出)**

#### 1.声明变量类型

```
View view
vs.
val view
```

Kotlin 根据赋值内容推断变量类型（这里是 `View`），而不是明确声明一个变量类型。你只需写 `val` 或 `var`, 赋值给它，就可以继续工作了，无需考虑更多。

#### 2. 将字符串连接成不可读的乱码

```
“View " + view + " has visibility " + view.getVisibility() + "."
vs.
“View $view has visibility ${view.visibility}."
```

Kotlin 提供了[字符串插值](https://kotlinlang.org/docs/reference/idioms.html#string-interpolation)。它简单至极，使得对字符串的处理变得更加简单和可读，对日志记录特别有用。

#### 3. 调用 getter/setter

```
getLayoutInflater().inflate();
view.setVisibility(View.GONE);
view.getVisibility();
vs.
layoutInflater.inflate()
view.visibility = View.GONE
view.visibility
```

Kotlin 提供了访问器来处理 Java 的 getter 和 setter，使得它们可以像属性一样被使用。因此获得的简洁性（更少的括号和 `get` / `set` 前缀）显著提高了代码的可读性。

**(有时候 Kotlin 编译器不能够解析类中的 getter/setter，因而这个特性无法使用，不过这种情况比较罕见)**

#### 4. 调用令人痛苦的超长模板语句

```
System.out.println();
vs.
println()
```

Kotlin 给你提供了许多简洁而方便的方法来帮你避免那些 Java 中长的令你痛苦的调用语句。`println`是最基本的（尽管不得不承认它不是那么实用）例子，但是 [Kotlin 的基本库](https://kotlinlang.org/api/latest/jvm/stdlib/) 有不少有用的工具减少了 Java 中固有的冗长语句，这点毋庸置疑。

#### 5. 写分号

```
;
;
vs.

```

还需要我说更多吗？

**荣幸地提示：虽然没有在文中展示，但再也**[**不用写 'new' 关键字**](https://kotlinlang.org/docs/reference/classes.html#creating-instances-of-classes)**了！**

---
瞧，我知道这些不是那种可以让人震惊的特性，但在几个月的工作和上万行代码之后，会让你的工作变得大不一样。这确实是那种你需要经历并赞美的事情之一。

将所有这些小的东西放在一起，包括小标题中 Kotlin 的特性，你会感觉比之前好多了。🍩

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
