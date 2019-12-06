> * 原文地址：[Dart Features for Better Code: Types and working with parameters](https://medium.com/coding-with-flutter/dart-features-for-better-code-types-and-working-with-parameters-896b802ef73a)
> * 原文作者：[Andrea Bizzotto](https://medium.com/@biz84)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/dart-features-for-better-code-types-and-working-with-parameters.md](https://github.com/xitu/gold-miner/blob/master/TODO1/dart-features-for-better-code-types-and-working-with-parameters.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[ArcherGrey](https://github.com/ArcherGrey)

# 类型及其在参数中的应用：利用 Dart 特性优化代码

![](https://cdn-images-1.medium.com/max/3200/1*BMqeS3pHvbHt52MzbZbS3Q.jpeg)

本篇教程将会介绍 Dart 语言的一些基础特性，以及如何将其应用于代码中。

正确的使用这些特性，能够让你的代码更加整洁、轻量，并且健壮。

## 1. 类型推断

Dart 编译器能够在变量初始化的时候自动推断它的类型，所以我们也就不必声明变量的类型。

在代码应用中，也就是我们可以将这样的代码：

```dart
String name = 'Andrea';
int age = 35;
double height = 1.84;
```

转化为：

```dart
var name = 'Andrea';
var age = 35;
var height = 1.84;
```

这段代码之所以能生效，是因为 Dart 可以从表达式右边的值**推断**出变量的类型。

我们可以像这样声明变量：

```dart
var x;
x = 15;
x = 'hello';
```

在这个例子中，`x` 声明在前，初始化在后。

此时它的类型是动态的，即 `dynamic`，这意味着，它可以被多个表达式赋值为不同的类型。

**小结**

* 当使用 `var` 的时候，只要变量的声明和初始化是同时完成的，那么 Dart 将能正确的推断出变量类型。

## 2. final 和 const

当我们使用 var 来声明变量的时候，这个变量可以被多次赋值：

```dart
var name = 'Andrea';
name = 'Bob';
```

也就是说：

> **使用 `var` 意味着**可以多次赋值

但是如果我们使用了 `final`，就不能给变量多次赋值了：

```dart
final name = 'Andrea';
name = 'Bob'; // 'name' 是一个 final 类型的变量，不可以被再次赋值
```

#### final 的应用

在 widget 类中，很常见使用 `final` 声明的属性。例如：

```dart
class PlaceholderContent extends StatelessWidget {
  const PlaceholderContent({
    this.title,
    this.message,
  });
  final String title;
  final String message;
  
  // TODO：实现构建方法
}
```

在这段代码中，`title` 和 `message` 在这个 widget 内是不可以被修改的，因为：

> **使用 `final` 意味着**只能一次赋值

所以，使用 `var` 和 `final` 的区别就是是否允许多次或只能一次赋值。现在我们再来看看 `const`：

#### const

> **`const` 能够定义**编译时**常量**

`const` 用来定义硬编码值，例如颜色、字体大小和图标等。

同时我们也可以在定义 widget 类的时候使用 **const** 构建函数。

这是完全可行的，因为所有 widget 内部的变量和方法都是编译时常量。例如：

```dart
class PlaceholderContent extends StatelessWidget {
  const PlaceholderContent({
    this.title,
    this.message,
  });
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 32.0, color: Colors.black54),
          ),
          Text(
            message,
            style: TextStyle(fontSize: 16.0, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
```

如果这个 widget 的构建函数是 `const` 类型，它就可以被这样构建：

```dart
const PlaceholderContent(
  title: 'Nothing here',
  message: 'Add a new item to get started',
)
```

结果就是，这个 widget 可以被 Flutter 优化为，**当它的父级变化时，widget 本身不会重复构建**。

小结：

* `final` 意味着变量只能被**赋值一次**
* `const` 用来定义**编译时常量**
* **const** 定义的 widget [不会在父级变化时重复构建](https://stackoverflow.com/questions/53492705/does-using-const-in-the-widget-tree-improve-performance)。
* 尽可能选择 `const` 而不是 `final`

## 3. 命名参数和位置参数

在 Dart 中，我们将变量使用大括号（`{}`）包起来，由此可以定义命名参数：

```dart
class PlaceholderContent extends StatelessWidget {
  // 使用命名参数的构建函数
  const PlaceholderContent({
    this.title,
    this.message,
  });
  final String title;
  final String message;
  
  // TODO：实现构建方法
}
```

这段代码意味着，我们可以像这样创建 widget：

```dart
PlaceholderContent(
  title: 'Nothing here',
  message: 'Add a new item to get started',
)
```

还有一种替代方案是，我们可以在构建函数中将大括号省略，声明位置参数：

```dart
// 使用位置参数的构建函数
const PlaceholderContent(
  this.title,
  this.message,
);
```

结果就是，参数可以通过它们**所在的位置**来定义：

```dart
PlaceholderContent(
  'Nothing here', // title 参数位于 0 号位
  'Add a new item to get started', // message 参数位于 1 号位
)
```

这完全行得通，但是当我们有多个参数的时候，这样很容易引起混乱。

此时命名参数就展露优势了，它们让代码更易写也更易读。

顺便说一句，你还可以将位置参数和命名参数结合起来：

```dart
// 位置参数优先，然后是命名参数
void _showAlert(BuildContext context, {String title, String content}) {
  // TODO：展示提示信息
}
```

Flutter widget 中随处可见使用一个位置参数，然后使用多个命名参数的方式。`Text` widget 就是一个很好的例子。

我写代码的指导思想就是，代码一定要保持整洁、自洽。我会依照此合理选择命名参数和位置参数。

## 4. @required 和默认值

默认情况下，命名参数可以被省略。

> **省略命名参数就等于给它赋值为 `null`。**

有时候这会导致无法预期的后果。

在上面的例子中，我们可以在定义 `PlaceholderContent()` 时并不传入 `title` 和 `message` 参数。

这将会导致错误，因为这样的话我们会将 `null` 值传入 `Text` widget，但这是不允许的。

#### @required 是一种补救方法

我们可以为任何变量添加 required 注释：

```dart
const PlaceholderContent({
  @required this.title,
  @required this.message,
});
```

这样当我们忘记传入参数的时候，编译器将会报出警告。

此时如果我们需要，我们仍旧可以明确写出传递 `null` 值：

```dart
PlaceholderContent(
  title: null,
  message: null,
)
```

此时编译器就不会报警告了。

如果想要避免传入 `null` 值，我们可以增加一些断言（assert）：

```dart
const PlaceholderContent({
  @required this.title,
  @required this.message,
}) : assert(title != null && message != null);
```

这些修改让我们的代码安全系数更高，因为：

* `@required` 会增加**编译时**检查
* `assert` 会增加**运行时**检查

如果我们为代码加入断言，那么运行时的错误就更容易改正，因为此时的报错会明确指出导致错误的代码位置。

#### 非空类型

`@required` 和 `assert` 让我们的代码安全系数更高了，但是它们看上去有些笨重。

如果我们可以指定对象在编译时不可为空就更好了。

通过使用非空类型我们可以做到这一点，而它在一开始就内建在 Swift 和 Kotlin 中了。

而且非空类型现在也正计划应用于 Dart 语言。

让我们祈祷它可以快点到来吧。🤞

#### 默认值

有时候，指定**合理的**默认值也很有用。

在 Dart 中这很容易就能做到：

```dart
const PlaceholderContent({
  this.title = 'Nothing here',
  this.message = 'Add a new item to get started',
}) : assert(title != null && message != null);
```

使用这种语法，如果 `title` 和 `message` 参数被忽略了，那么默认值就会被使用。

顺便提一下，默认值也可以应用于位置参数：

```dart
int sum([int a = 0, int b = 0]) {
  return a + b;
}
print(sum(10)); // 打印出 10
```

## 总结

代码是让机器执行的，但是也是要程序员阅读的。

时间宝贵。乖乖的写好代码 😉

* 这样才能让你的应用更健壮，性能也更好。
* 同时也能帮助你和你的团队有更好的发展。

编程愉快！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
