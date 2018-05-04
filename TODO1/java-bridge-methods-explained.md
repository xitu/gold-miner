> * 原文地址：[Java bridge methods explained](http://stas-blogspot.blogspot.jp/2010/03/java-bridge-methods-explained.html)
> * 原文作者：[STAS](http://stas-blogspot.blogspot.jp)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/java-bridge-methods-explained.md](https://github.com/xitu/gold-miner/blob/master/TODO1/java-bridge-methods-explained.md)
> * 译者：
> * 校对者：

# Java bridge methods explained

Bridge methods in Java are synthetic methods, which are necessary to implement some of Java language features. The best known samples are covariant return type and a case in generics when erasure of base method's arguments differs from the actual method being invoked.

Have a look at following example:

```
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

Which in reality is just an example of covariant return type and after [erasure](http://en.wikipedia.org/wiki/Type_erasure) will look like following snippet:

```
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

And after the compilation decompiled result class "B" will be following:

```
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
1:   invokevirtual   #2; // Call to Method getT:()Ljava/lang/String;
4:   areturn
}
```

Above you can see there is new [synthetic](http://java.sun.com/docs/books/jvms/second_edition/html/ClassFile.doc.html#80128) method "java.lang.Object getT()" which is not present in source code. That method acts as bridge method and all is does is delegating invocation to "java.lang.String getT()". Compiler has to do that, because in JVM method return type is part of method's signature, and creation of bridge method here is just the way to implement covariant return type.

Now have a look at following example which is generics-specific:

```
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

after compilation class "B" will be transformed into following:

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

here, the bridge method, which overrides method from base class "A", not just calling one with string argument (#3), but also performs type cast to "java.lang.String" (#2). It means, that if you will execute following code, ignoring compiler's "unchecked" warning, the result will be ClassCastException thrown from the bridge method:

```
A a = new B();
a.getT(new Object()));
```

These two examples are the best known cases where bridge methods are used, but there is, at least, one more, where bridge method is used to "change" visibility of base class's methods. Have a look at following sample and try to guess where compiler may need the bridge method to be created:

```
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

If you will decompile class C, you will see method "foo" there, which overrides method from base class and delegates to it:

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

compiler needs that method, because class A is not public and can't be accessed outside it's package, but class C is public and all inherited method have to become visible outside the package as well. Note, that class D will not have bridge method, because it overrides "foo" and there is no need to "increase" visibility.
It looks like, that type of bridge method, was introduced after [bug](http://bugs.sun.com/view_bug.do?bug_id=6342411) which was fixed in Java 6\. It means that before Java 6 that type of bridge method is not generated and method "C#foo" can't be called from package other than it's own via reflection, so following snippet causes IllegalAccessException, in cases when compiled on Java version < 1.6:

```
package samplefive;
...
SampleFour.C.class.getMethod("foo").invoke(new SampleFour.C());
...
```

Normal invocation, without using reflection, will work fine.

Probably there are some other cases where bridge methods are used, but there is no source of information about it. Also, there is no definition of bridge method, although you can guess it easily, it's pretty obvious from examples above, but still would be nice to have something in spec which states it clearly. In spite of the fact that method [Method#isBridge()](http://java.sun.com/j2se/1.5.0/docs/api/java/lang/reflect/Method.html#isBridge%28%29) is part of public reflection API since Java1.5 and bridge flag is part of [class file format](http://java.sun.com/docs/books/jvms/second_edition/ClassFileFormat-Java5.pdf), JVM and JLS specifications do not have any information what exactly is that and do not provide any rules when and how it should be used by compiler. All I could find is just reference in "Discussion" area [here](http://java.sun.com/docs/books/jls/third_edition/html/expressions.html#15.12.4.5).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
