> * 原文地址：[Java bridge methods explained](http://stas-blogspot.blogspot.jp/2010/03/java-bridge-methods-explained.html)
> * 原文作者：[STAS](http://stas-blogspot.blogspot.jp)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/java-bridge-methods-explained.md](https://github.com/xitu/gold-miner/blob/master/TODO1/java-bridge-methods-explained.md)
> * 译者：[kezhenxu94](https://github.com/kezhenxu94/)
> * 校对者：[Starrier](https://github.com/Starriers/)

# Java 桥接方法详解

Java 中的桥接方法是一种合成方法，在实现某些 Java 语言特性的时候是很有必要的。最为人熟知的例子就是协变返回值类型和泛型擦除后导致基类方法的参数与实际调用的方法参数类型不一致。

看一下以下的例子：

```java
public class SampleOne {
    public static class A<T> {
        public T getT() {
            return null;
        }
    }

    public static class  B extends A<String> {
        public String getT() {
            return null;
        }
    }
}
```

事实上这就是一个协变返回类型的例子，[泛型擦除](http://en.wikipedia.org/wiki/Type_erasure)后将会变成类似于下面这样的代码段：

```java
public class SampleOne {
    public static class A {
        public Object getT() {
            return null;
        }
    }

    public static class  B extends A {
        public String getT() {
            return null;
        }
    }
}
```

在将编译后的字节码反编译后，类 `B` 会是这样子的：

```java
public class SampleOne$B extends SampleOne$A {
public SampleOne$B();
...
public java.lang.String getT();
Code:
0:   aconst_null
1:   areturn
public java.lang.Object getT();
Code:
0:   aload_0
1:   invokevirtual   #2; // 调用 getT:()Ljava/lang/String;
4:   areturn
}
```

从上面可以看到，有一个新[合成的](http://java.sun.com/docs/books/jvms/second_edition/html/ClassFile.doc.html#80128)方法 `java.lang.Object getT()`, 这在源代码中是没有出现过的。这个方法就起了一个桥接的作用，它所做的就是把对自身的调用委托给方法 `jva.lang.String getT()`。编译器不得不这么做，因为在 JVM 方法中，返回类型也是方法签名的一部分，而桥接方法的创建就正好是实现协变返回值类型的方式。

现在再看一看下面和泛型相关的例子：

```java
public class SampleTwo {
    public static class A<T> {
        public T getT(T args) {
            return args;
        }
    }

    public static class B extends A<String> {
        public String getT(String args) {
            return args;
        }
    }
}
```

编译后类 `B` 会变成下面这样子：

```
public class SampleThree$B extends SampleThree$A{
public SampleThree$B();
...
public java.lang.String getT(java.lang.String);
Code:
0:   aload_1
1:   areturn

public java.lang.Object getT(java.lang.Object);
Code:
0:   aload_0
1:   aload_1
2:   checkcast       #2; //class java/lang/String
5:   invokevirtual   #3; //Method getT:(Ljava/lang/String;)Ljava/lang/String;
8:   areturn
}
```

这里的桥接方法覆盖了（override）基类 `A` 的方法，不仅使用字符串参数将对自身的调用委派给基类 `A` 的方法，同时也执行了一个到 `java.lang.String` 的类型转换检测（#2）。这就意味着如果你运行下面这样的代码，忽略编译器的“未检”（unchecked）警告，结果会是从桥接方法那里抛出异常 `ClassCastException`。

```java
A a = new B();
a.getT(new Object()));
```

以上例子就是桥接方法最为人熟知的两种使用场景，但至少还有一种使用案例，就是桥接方法被用于“改变”基类可见性。考虑以下示例代码，猜测一下编译器是否需要创建一个桥接方法：

```java
package samplefour;

public class SampleFour {
    static class A {
        public void foo() {
        }
    }
    public static class C extends A {

    }
    public static class D extends A {
        public void foo() {
        }
    }
}
```

如果你反编译 `C` 类，你将会看到有 `foo` 方法，它覆盖了基类的方法并把对自身的调用委托给它（基类的方法）：

```
public class SampleFour$C extends SampleFour$A{
...
public void foo();
Code:
0:   aload_0
1:   invokespecial   #2; //Method SampleFour$A.foo:()V
4:   return

}
```

编译器需要这样的方法，因为 `A` 类不是公开的，在 `A` 类所在包之外是不可见的，但是 `C` 类是公开的，它所继承来的所有方法在所在包之外也都应该是可见的。需要注意的是，`D` 类不会有桥接方法生成，因为它覆盖了 `foo` 方法，因此没有必要“提升”其可见性。
这种桥接方法似乎是由于[这个 bug](http://bugs.sun.com/view_bug.do?bug_id=6342411)（在 Java 6 被修复）才引入的。这意味着在 Java 6 之前是不会生成这样桥接方法的，那么 `C#foo` 就不能够在它所在包之外使用反射调用，以致于下面这样的代码在 Java 版本小于 1.6 时会报 `IllegalAccessException` 异常。

```java
package samplefive;
...
SampleFour.C.class.getMethod("foo").invoke(new SampleFour.C());
...
```

不使用反射机制，正常调用的话是起作用的。

可能还有其他使用桥接方法的案例，但没有相关的资料。此外，关于桥接方法也没有明确的定义，尽管你可以很容易的猜测出来，像以上的示例是相当明显的，但如果有一些规范把桥接方法说明清楚的话就更好了。尽管自 Java 5 开始 [`Method#isBridge()` 方法](http://java.sun.com/j2se/1.5.0/docs/api/java/lang/reflect/Method.html#isBridge%28%29) 就是公开的反射 API 了，桥接的标志也是[字节码文件格式](http://java.sun.com/docs/books/jvms/second_edition/ClassFileFormat-Java5.pdf)中的一部分，但 Java 虚拟机和 Java 语言规范都始终没有任何关于桥接方法的确切文档，也没有提供关于编译器何时/如何使用桥接方法的任何规则。我所能找到的全部引用都是来自[这里的“讨论区”](http://java.sun.com/docs/books/jls/third_edition/html/expressions.html#15.12.4.5)。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
