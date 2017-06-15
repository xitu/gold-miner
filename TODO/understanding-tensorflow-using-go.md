> * 原文地址：[Understanding Tensorflow using Go](https://pgaleone.eu/tensorflow/go/2017/05/29/understanding-tensorflow-using-go/)
> * 原文作者：[Paolo Galeone](https://pgaleone.eu/about/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[whatbeg](https://github.com/whatbeg),[yifili09](https://github.com/yifili09)

# 用 Go 语言理解 Tensorflow

Tensorflow 并不是一个严格意义上的机器学习库，它是一个使用图来表示计算的通用计算库。它的核心功能由 C++ 实现，通过封装，能在各种不同的语言下运行。它的 Golang 版和 Python 版不同，Golang 版 Tensorflow 不仅能让你通过 Go 语言使用 Tensorflow，还能让你理解 Tensorflow 的底层实现。

## 封装

根据官方说明，Tensorflow 开发者发布了以下内容：

- C++ 源码：底层和高层的具体功能由 C ++ 源码实现，它是真正 Tensorflow 的核心。

- Python 封装与Python 库：由 C++ 实现自动生成的封装版本，通过这种方式我们可以直接用 Python 来调用 C++ 函数：这也是 numpy 的核心实现方式。

  Python 库通过将 Python 封装版的各种调用结合起来，组成了各种广为人知的高层 API。

- Java 封装

- Go 封装

作为一名 Gopher 而非一名 java 爱好者，我对 Go 封装给予了极大的关注，希望了解其适用于何种任务。

> 译注，这里说的”封装“也有说法叫做”语言界面“

## Go 封装

![Tensorflow &amp; Go](https://pgaleone.eu/images/tensorflow_go/tensorgologo.png)

图为 Gopher（由 Takuya Ueda [@tenntenn](https://twitter.com/tenntenn) 创建，遵循 CC 3.0 协议）与 Tensorflow 的 Logo 结合在一起。

---

首先要注意的是，代码维护者自己也承认了，Go API 缺少 `Variable` 支持，因此这个 API 仅用于**使用**训练好的模型，而**不能用于**进行模型训练。

在文档 [Installing Tensorflow for Go](https://www.tensorflow.org/versions/master/install/install_go) 中已经明确提到：

> TensorFlow 为 Go 编程提供了一些 API。这些 API 特别适合加载在 Python 中创建的模型，让其在 Go 应用 中运行。

如果我们对训练机器学习模型没兴趣，那这个限制是 OK 的。

但是，如果你打算自己训练模型，请看下面给的建议：

> 作为一名 Gopher，请让 Go 保持简洁！使用 Python 去定义、训练模型，在这之后你随时都可以用 Go 来加载训练好的模型！（意思就是他们懒得开发呗）

简而言之，golang 版 tensorflow 可以**导入与定义**常数图（constant graph）。这个常数图指的是在图中没有训练过程，也没有需要训练的变量。

让我们用 Golang 深入研究 Tensorflow 吧！首先创建我们的第一个应用。

我建议读者在阅读下面的内容前，先准备好 Go 环境，以及编译、安装好 Tensorflow Go 版（编译、安装过程参考 [README](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/go/README.md)）。

## 理解 Tensorflow 的结构

先复习一下什么是 Tensorflow 吧！（这是我个人的理解，和[官网](https://www.tensorflow.org/)的有所不同）

> TensorFlow™ 是一个采用数据流图(data flow graphs),用于数值计算的开源软件库。节点（Nodes）在图中**表示**数学操作，图中的线（edges）则**表示**在节点间相互联系的多维数据数组，即张量（tensor）。

我们可以把 Tensorflow 看做一种类似于 SQL 的描述性语言，首先你得确定你需要什么数据，它会通过底层引擎（数据库）分析你的查询语句，检查你的句法错误和语法错误，将查询语句转换为私有语言表达式，进行优化之后运算得出计算结果。这样，它能保证将正确的结果传达给你。

因此，我们无论使用什么 API 实质上都是在描述一个图。我们将它放在 `Session` 中作为求值的起点，这样做确定了这个图将会在这个 Session 中运行。

了解这一点，我们可以试着定义一个计算操作的图，并将其放在一个 `Session` 中进行求值。

 [API 文档](https://godoc.org/github.com/tensorflow/tensorflow/tensorflow/go)中明确告知了 `tensorflow`（简称 `tf`）包与 `op` 包中的可用方法列表。

在这个列表中我们可以看到，这两个包中包含了一切我们需要用来定义与评价图的方法。

`tf` 包中包含了各种构建基础结构的函数，例如 `Graph`（图）。`op` 包是最重要的包，它包含了由 C++ 实现自动生成的绑定等功能。

现在，假设我们要计算 AAA 与 xxx 的矩阵乘法：

![](https://ws2.sinaimg.cn/large/006tNc79gy1fg9itnbsc7j31au06274m.jpg)

我假定你们都熟悉 tensorflow 图的定义，都了解 placeholder 并知道它们的工作原理。

下面的代码是一位 Tensorflow Python 用户第一次尝试时会写的代码。让我们给这个文件取名为 `attempt1.go`。

```
package main

import (
	"fmt"
	tf "github.com/tensorflow/tensorflow/tensorflow/go"
	"github.com/tensorflow/tensorflow/tensorflow/go/op"
)

func main() {
	// 第一步：创建图

	// 首先我们需要在 Runtime 定义两个 placeholder 进行占位
	// 第一个 placeholder A 将会被一个 [2, 2] 的 interger 类型张量代替
	// 第二个 placeholder x 将会被一个 [2, 1] 的 interger 类型张量代替

	// 接下来我们要计算 Y = Ax

	// 创建图的第一个节点：让这个空节点作为图的根
	root := op.NewScope()

	// 定义两个 placeholder
	A := op.Placeholder(root, tf.Int64, op.PlaceholderShape(tf.MakeShape(2, 2)))
	x := op.Placeholder(root, tf.Int64, op.PlaceholderShape(tf.MakeShape(2, 1)))

	// 定义接受 A 与 x 输入的 op 节点
	product := op.MatMul(root, A, x)

	// 每次我们传递一个域给一个操作的时候，
	// 我们都要将操作放在在这个域下。
	// 如你所见，现在我们已经有了一个空作用域（由 newScope）创建。这个空作用域
	// 是我们图的根，我们可以用“/”表示它。

	// 现在让 tensorflow 按照我们的定义建立图吧。
	// 依据我们定义的 scope 与 op 结合起来的抽象图，程序会创建相应的常数图。

	graph, err := root.Finalize()
	if err != nil {
		// 如果我们错误地定义了图，我们必须手动修正相关定义，
		// 任何尝试自动处理错误的方法都是无用的。

		// 就像 SQL 查询一样，如果查询不是有效的语法，我们只能重写它。
		panic(err.Error())
	}

	// 如果到这一步，说明我们的图语法上是正确的。
	// 现在我们可以将它放在一个 Session 中并执行它了！

	var sess *tf.Session
	sess, err = tf.NewSession(graph, &tf.SessionOptions{})
	if err != nil {
		panic(err.Error())
	}

	// 为了使用 placeholder，我们需要创建传入网络的值的张量
	var matrix, column *tf.Tensor

	// A = [ [1, 2], [-1, -2] ]
	if matrix, err = tf.NewTensor([2][2]int64{ {1, 2}, {-1, -2} }); err != nil {
		panic(err.Error())
	}
	// x = [ [10], [100] ]
	if column, err = tf.NewTensor([2][1]int64{ {10}, {100} }); err != nil {
		panic(err.Error())
	}

	var results []*tf.Tensor
	if results, err = sess.Run(map[tf.Output]*tf.Tensor{
		A: matrix,
		x: column,
	}, []tf.Output{product}, nil); err != nil {
		panic(err.Error())
	}
	for _, result := range results {
		fmt.Println(result.Value().([][]int64))
	}
}
```

上面的代码写好了注释，我建议读者阅读上面的每一条注释。

现在，这位 Tensorflow Python 用户自我感觉良好，认为他的代码能够成功编译与运行。让我们试一试吧：

`go run attempt1.go`

然后他会看到：

`panic: failed to add operation "Placeholder": Duplicate node name in graph: 'Placeholder'`

等等，为什么会这样呢？

问题很明显。上面代码里出现了 2 个重名的“Placeholder”操作。

## 第 1 课：node IDs

**每次在我们调用方法定义一个操作的时候，不管他是否在之前被调用过，Python API 都会生成不同的节点**。

所以，下面的代码没有任何问题，会返回 3。

```
import tensorflow as tf
a = tf.placeholder(tf.int32, shape=())
b = tf.placeholder(tf.int32, shape=())
add = tf.add(a,b)
sess = tf.InteractiveSession()
print(sess.run(add, feed_dict={a: 1,b: 2}))
```

我们可以验证一下这个问题，看看程序是否创建了两个不同的 placeholder 节点： `print(a.name, b.name)` 

它打印出 `Placeholder:0 Placeholder_1:0`。

这样就清楚了，`a` placeholder 是 `Placeholder:0` 而 `b ` placeholder 是 `Placeholder_1:0`。

但是在 Go 中，上面的程序会报错，因为 `A` 与 `x` 都叫做 `Placeholder`。我们可以由此得出结论：

**每次我们调用定义操作的函数时，Go API 并不会自动生成新的名称**。因此，它的操作名是固定的，我们没法修改。

#### 提问时间：

- 关于 Tensorflow 的架构我们学到了什么？

  **图中的每个节点都必须有唯一的名称。所有节点都是通过名称进行辨认。**

- 节点名称与定义操作符的名称是否相同？

  **是的，也可说节点名称是操作符名称的最后一段。**

接下来让我们修复节点名称重复的问题，来弄明白上面的第二个提问。

## 第 2 课：作用域

正如我们所见，Python API 在定义操作时会自动创建新的名称。如果研究底层会发现，Python API 调用了 C++ `Scope` 类中的 `WithOpName` 方法。

下面是该方法的文档及特性，参考 [scope.h](https://github.com/tensorflow/tensorflow/blob/a5b1fb8e56ceda0ee2794ee05f5a7642157875c5/tensorflow/cc/framework/scope.h)：

```
/// 返回新的作用域。所有在返回的作用域中的 op 都会被命名为
/// <name>/<op_name>[_<suffix].
Scope WithOpName(const string& op_name) const;
```

注意这个方法，返回一个作用域 `Scope` 来对节点进行命名，因此节点名称事实上就是作用域 `Scope`。

`Scope` 就是从根 `/`（空图）追溯至 `op_name` 的**完整路径**。

`WithOpName` 方法在我们尝试添加一个有着相同的 `/` 到 `op_name` 路径的节点时，为了避免在相同作用域下有重复的节点，会为其加上一个后缀 `_<suffix>`（`<suffix>` 是一个计数器）。

了解了以上内容，我们可以通过在 `type Scope` 中寻找 `WithOpName` 来解决重复节点名称的问题。然而，Go tf API  中没有这个方法。

如果查阅 [type Scope 的文档](https://godoc.org/github.com/tensorflow/tensorflow/tensorflow/go/op#Scope)，我们可以看到唯一能返回新 `Scope` 的方法只有 `SubScope(namespace string)`。

下面引用文档中的内容：

> SubScope 将会返回一个新的 Scope，这个 Scope 能确保所有的被加入图中的操作都被放置在 ‘namespace’ 的命名空间下。如果这个命名空间和作用域中已经存在的命名空间冲突，将会给它加上后缀。

这种加后缀的冲突处理和 C++ 中的 `WithOpName` 方法**不同**，`WithOpName` 是在**操作名后面**加`suffix`，它们都在同样的作用域内（例如 `Placeholder` 变成 `Placeholder_1`），而 Go 的 `SubScope` 是在**作用域名称后面**加 `suffix`。

这将导致这两种方法会生成完全不同的图（节点在不同的作用域中了），但是它们的计算结果却是一样的。

让我们试着改一改 placeholder 定义，让它们定义两个不同的节点，然后打印 `Scope` 名称。

让我们创建 `attempt2.go` ，将下面几行

```
A := op.Placeholder(root, tf.Int64, op.PlaceholderShape(tf.MakeShape(2, 2)))
x := op.Placeholder(root, tf.Int64, op.PlaceholderShape(tf.MakeShape(2, 1)))
```

改成

```
// 在根定义域下定义两个自定义域，命名为 input。这样
// 我们就能在根定义域下拥有 input/ 和 input_1/ 两个定义域了。
A := op.Placeholder(root.SubScope("input"), tf.Int64, op.PlaceholderShape(tf.MakeShape(2, 2)))
x := op.Placeholder(root.SubScope("input"), tf.Int64, op.PlaceholderShape(tf.MakeShape(2, 1)))
fmt.Println(A.Op.Name(), x.Op.Name())
```

编译、运行： `go run attempt2.go`，输出结果：

```
input/Placeholder input_1/Placeholder
```

#### 提问时间：

- 关于 Tensorflow 的架构我们学到了什么？

  **节点完全由其定义所在的作用域标识。这个”作用域“是我们从图的根节点追溯到指定节点的一条路径。有两种方法来定义执行同一种操作的节点：1、将其定义放在不同的作用域中（Go 风格）2、改变操作名称（我们在 C++ 中可以这么做，Python 版会自动这么做）**

现在，我们已经解决了节点命名重复的问题，但是现在我们的控制台中出现了另一个问题：

    panic: failed to add operation "MatMul": Value for attr 'T' of int64 is not in the list of allowed values: half, float, double, int32, complex64, complex128
为什么 `MatMul` 节点的定义出错了？我们要做的仅仅是计算两个 `tf.int64` 矩阵的乘积而已！似乎 `MatMul` 偏偏不能接受 `int64` 的类型。

> Value for attr ‘T’ of int64 is not in the list of allowed values: half, float, double, int32, complex64, complex128

上面这个列表是什么？为什么我们能计算 2 个 `int32` 矩阵的乘积却不能计算 `int64` 的乘积？

下面我们将解决这个问题。

##  第 3 课：Tensorflow 类型系统

让我们深入研究 [源代码](https://github.com/tensorflow/tensorflow/blob/r1.2/tensorflow/core/ops/math_ops.cc#L1048) 来看 C++ 是如何定义 `MatMul` 操作的：

```
REGISTER_OP("MatMul")
    .Input("a: T")
    .Input("b: T")
    .Output("product: T")
    .Attr("transpose_a: bool = false")
    .Attr("transpose_b: bool = false")
    .Attr("T: {half, float, double, int32, complex64, complex128}")
    .SetShapeFn(shape_inference::MatMulShape)
    .Doc(R"doc(
Multiply the matrix "a" by the matrix "b".
The inputs must be two-dimensional matrices and the inner dimension of
"a" (after being transposed if transpose_a is true) must match the
outer dimension of "b" (after being transposed if transposed_b is
true).
*Note*: The default kernel implementation for MatMul on GPUs uses
cublas.
transpose_a: If true, "a" is transposed before multiplication.
transpose_b: If true, "b" is transposed before multiplication.
```

这几行代码为 `MatMul` 操作定义了一个接口，由 `REGISTER_OP` 宏对此操作做出了如下描述：

- 名称: `MatMul`
- 参数: `a`, `b`
- 属性（可选参数）: `transpose_a`, `transpose_b`
- 模版 `T` 支持的类型: `half, float, double, int32, complex64, complex128`
- 输出类型: 自动识别
- 文档

这个宏没有包含任何 C++ 代码，但是它告诉了我们**当在定义一个操作的时候，即使它使用模版定义，我们也需要指定特定类型 `T` 支持的类型（或属性）列表。**

实际上，属性 `.Attr("T: {half, float, double, int32, complex64, complex128}")` 将 `T` 的类型限制在了这个类型列表中。
[tensorflow 教程](https://www.tensorflow.org/extend/adding_an_op)中提到，当时模版 `T` 时，我们需要对所有支持的重载运算在内核进行注册。这个内核会使用 CUDA 方式引用 C/C++ 函数，进行并发执行。

`MatMul` 的作者可能是出于以下 2 个原因仅支持上述类型而将 `int64` 排除在外的：

1. 疏忽：这个是有可能的，毕竟 Tensorflow 的作者也是人类呀！
2. 为了支持不能使用 `int64` 的设备，可能这个特性的内核实现不能在各种支持的硬件上运行。

回到我们的问题中，已经很清楚如何解决问题了。我们需要将 `MatMul` 支持类型的参数传给它。

让我们创建 `attempt3.go` ，将所有 `int64` 的地方都改成 `int32`。

有一点需要注意：**Go 封装版 tf 有自己的一套类型，基本与 Go 本身的类型 1:1 相映射。当我们要将值传入图中时，我们必须遵循这种映射关系（例如定义 `tf.Int32` 类型的 placeholder 时要传入 `int32`）。从图中取值同理。**

`*tf.Tensor` 类型将会返回一个张量 evaluation，它包含一个 `Value()` 方法，此方法将返回一个必须转换为正确类型的 `interface{}`（这是从图的结构了解到的）。

运行 `go run attempt3.go`，得到结果：

```
input/Placeholder input_1/Placeholder
[[210] [-210]]
```
成功了！

下面是 `attempt3` 的完整代码，你可以编译并运行它。（这是一个 Gist，如果你发现有啥可以改进的话欢迎来https://gist.github.com/galeone/09657143df49a90536f4ac4893c64696贡献代码）

```
package main                                        

import (                                            
	"fmt"                                       
	tf "github.com/tensorflow/tensorflow/tensorflow/go"                                              
	"github.com/tensorflow/tensorflow/tensorflow/go/op"                                              
)                                                   

func main() {                                       
	// 第一步：创建图

	// 首先我们需要在 Runtime 定义两个 placeholder 进行占位
	// 第一个 placeholder A 将会被一个 [2, 2] 的 interger 类型张量代替
	// 第二个 placeholder x 将会被一个 [2, 1] 的 interger 类型张量代替

	// 接下来我们要计算 Y = Ax

	// 创建图的第一个节点：让这个空节点作为图的根
	root := op.NewScope()                       

	// 定义两个 placeholder
	// 在根定义域下定义两个自定义域，命名为 input。这样
	// 我们就能在根定义域下拥有 input/ 和 input_1/ 两个定义域了。
	A := op.Placeholder(root.SubScope("input"), tf.Int32, op.PlaceholderShape(tf.MakeShape(2, 2)))   
	x := op.Placeholder(root.SubScope("input"), tf.Int32, op.PlaceholderShape(tf.MakeShape(2, 1)))   
	fmt.Println(A.Op.Name(), x.Op.Name())       

	// 定义接受 A 与 x 输入的 op 节点
	product := op.MatMul(root, A, x)            

	// 每次我们传递一个域给一个操作的时候，
	// 我们都要将操作放在在这个域下。
	// 如你所见，现在我们已经有了一个空作用域（由 newScope）创建。这个空作用域
	// 是我们图的根，我们可以用“/”表示它。

	// 现在让 tensorflow 按照我们的定义建立图吧。
	// 依据我们定义的 scope 与 op 结合起来的抽象图，程序会创建相应的常数图。
	graph, err := root.Finalize()               
	if err != nil {                             
		// 如果我们错误地定义了图，我们必须手动修正相关定义，
		// 任何尝试自动处理错误的方法都是无用的。

		// 就像 SQL 查询一样，如果查询不是有效的语法，我们只能重写它。
		panic(err.Error())                  
	}                                           

	// 如果到这一步，说明我们的图语法上是正确的。
	// 现在我们可以将它放在一个 Session 中并执行它了！

	var sess *tf.Session                        
        sess, err = tf.NewSession(graph, &tf.SessionOptions{})                                           
	if err != nil {                             
		panic(err.Error())                  
	}                                           

	// 为了使用 placeholder，我们需要创建传入网络的值的张量             
	var matrix, column *tf.Tensor               

	// A = [ [1, 2], [-1, -2] ]                 
	if matrix, err = tf.NewTensor([2][2]int32{{1, 2}, {-1, -2}}); err != nil {                       
		panic(err.Error())                  
	}                                           
	// x = [ [10], [100] ]                      
	if column, err = tf.NewTensor([2][1]int32{{10}, {100}}); err != nil {                            
		panic(err.Error())                  
	}                                           

	var results []*tf.Tensor                    
	if results, err = sess.Run(map[tf.Output]*tf.Tensor{                                             
		A: matrix,                          
		x: column,                          
	}, []tf.Output{product}, nil); err != nil {
		panic(err.Error())                  
	}                                           
	for _, result := range results {            
		fmt.Println(result.Value().([][]int32))                                            
	}
}
```

#### 提问时间：

关于 Tensorflow 的架构我们学到了什么？

**每个操作都有自己的一组关联内核。Tensorflow 是一种强类型的描述性语言，它不仅遵循 C++ 类型规则，同时要求在 op 注册时需定义好类型才能实现其功能。**

# 总结

使用 Go 来定义与处理一个图让我们能够更好地理解 Tensorflow 的底层结构。通过不断地试错，我们最终解决了这个简单的问题，一步一步地掌握了图、节点以及类型系统的知识。

如果你觉得这篇文章有用，请点个赞或者分享给别人吧~

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
