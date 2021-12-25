> * 原文地址：[Expressive Code for State Machines in C++](https://www.fluentcpp.com/2019/09/24/expressive-code-for-state-machines-in-cpp/)
> * 原文作者：[Jonathan Boccara](https://www.fluentcpp.com/author/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/expressive-code-for-state-machines-in-cpp.md](https://github.com/xitu/gold-miner/blob/master/TODO1/expressive-code-for-state-machines-in-cpp.md)
> * 译者：[zh1an](https://github.com/zh1an)
> * 校对者：[司徒公子](https://github.com/stuchilde), [PingHGao](https://github.com/PingHGao)

# C++ 中清晰明了的状态机代码

> 这是 Valentin Tolmer 的特邀文章。 Valetin 是谷歌的一名软件工程师，他试图提高他周围的代码质量。他年轻时就受到模板编程的影响并且现在只致力于元编程。你可以在 [GitHub](https://github.com/nitnelave) 找到他的一些工作内容，特别是本文所涉及的 [ProtEnc](https://github.com/nitnelave/ProtEnc) 库。

你曾经遇到过这种注释吗？

```c++
// 重要：在调用 SetUp() 之前请不要调用该函数!
```
或者做这样的检查：

```c++
if  (my_field_.empty())  abort();
```

这些（注释中提出的状态检查要求）都是我们的代码必须遵守的协议的通病。有些时候，你正在遵守的一个明确的协议也会有状态检查的要求，例如在 SSL 握手或者其他业务逻辑实现中。或者可能在你的代码中有一个明确状态转换的状态机，该状态机每次都需要根据可能的转换列表做转换状态检查。

让我们看看我们如何**清晰明了地**处理这种方案。

### 例如：建立一个 HTTP 连接

我们今天的示例是构建一个 HTTP 连接。为了大大简化，我们只说我们的连接请求至少包含一个 header（也许会更多），有且只有一个 body，并且这些 header 必须在 body 之前被指定出来（例如因为性能原因，我们只写入一个追加的数据结构）。

**备注：虽然这个****特定的****问题可以通过给构造函数传递正确的参数来解决，我不想使这个协议过于复杂。你将看到扩展它是多么的容易。**

这是第一次实现：

```c++
class  HttpConnectionBuilder  {
 public:
  void  add_header(std::string  header)  {
    headers_.emplace_back(std::move(header);
  }
  // 重要: 至少调用一次 add_header 之后才能被调用
  void  add_body(std::string  body)  {
    body_  =  std::move(body);
  }
  // 重要: 只能调用 add_body 之后才能被调用
  // 消费对象
  HttpConnection build()  &&  {
    return  {std::move(headers_),  std::move(body_)};
  }
 private:
  std::vector<std::string>  headers_;
  std::string  body_;
};
```

直到现在，这个例子相当的简单，但是它依赖于用户不要做错事情：如果他们没有提前阅读过文档，没有什么可以阻止他们在 body 之后添加另外的 header。如果将其放入到一个 1000 行的文件中，你很快就会发现这有多糟糕。更糟糕的是，没有检查类是否被正确的使用，所以，查看类是否被误用的唯一方法是观察是否有意料之外的效果！如果它导致了内存损坏，那么祝您调试顺利。

其实我们可以做的更好……

### 使用动态枚举

通常情况下，该协议可以用一个有限状态机来表示：该状态机开始于我们没有添加任何的 header 的状态(START 状态)，该状态下只有一个添加 header 的选项。然后进入至少添加一个 header (HEADER 状态)，该状态下既可以添加另外的 header 来保持该状态，也可以添加一个 body 而进入到 BODY 状态。只有在 BODY 这个状态下我们可以调用 build，让我们进入到最终状态。

![typestates state machine](https://www.fluentcpp.com/wp-content/uploads/2019/09/state_machine.png)

所以，让我们将这些想法写到我们的类中！

```c++
enum  BuilderState  {
  START,
  HEADER,
  BODY
};
class  HttpConnectionBuilder  {
  void  add_header(std::string  header)  {
    assert(state_  ==  START  ||  state_  ==  HEADER);
    headers_.emplace_back(std::move(header));
    state_  =  HEADER;
  }
  ...
 private:
  BuilderState state_;
  ...
};
```

其他的函数也是这样。这已经很好了：我们有一个确定的状态告诉我们哪种转换是可能的，并且我们检查了它。当然了，你有针对你的代码的周密的测试用例，对吗？如果你的测试对代码有足够的覆盖率，那么你将能够在测试的时候捕获任何违规的操作。你也可以在生产环境中启用这些检查，以确保不会偏离该协议（受控崩溃总比内存损坏要强），但是你必须对增加的检查付出代价。

### 使用类型状态（typestates）

我们怎么才能更快地、100% 准确地捕获到这些错误呢？那就让编译器来做这些工作！下面我将介绍类型状态（typestates）的概念。

大致说来，类型状态（typestates）是将对象的状态编码为其本身的类型。有些语言通过为每个状态实现一个单独的类来实现(比如 `HttpBuilderWithoutHeader`、`HttpBuilderWithBody` 等等)，但这在 C++ 中将会变得非常的冗长：我们不得不声明构造函数、删除拷贝函数、将一个对象转换成另外一个对象…… 并且它很快就会过期。

但是 C++ 还有其他的妙招：模板！我们可以在 `enum` 中对状态进行编码，并且使用这个 `enum` 将构造器模板化。这就得到了如下的代码：

```c++
template  <BuilderState  state>
class  HttpConnectionBuilder  {
  HttpConnectionBuilder<HEADER> 
  add_header(std::string  header)  &&  {
    static_assert(state  ==  START  ||  state  ==  HEADER, 
      "add_header can only be called from START or HEADER state");
    headers_.emplace_back(std::move(header));
    return  {std::move(*this)};
  }
  ...
};
```

这里我们静态地检查对象是否处于正确的状态，无效代码甚至无法编译！并且我们还可以得到了一个相当清晰的错误信息。每次我们创建与目标状态相对应的新对象时，我们也销毁了与之前状态对应的对象：你在类型为 `HttpConnectionBuilder<START>`的对象上调用 add_header，但是你将得到一个 `HttpConnectionBuilder<HEADER>` 类型的返回值。这就是类型状态（typestates）的核心思想。

注意：这个方法只能在右值引用(r-values)中调用(`std::move`，就是函数声明行末尾的 `&&` 的作用)。为什么要这样呢？它强制性地破坏了前一个状态，因此只能得到一个相关的状态。可以将其看做 `unique_ptr`：你不想复制一个内部的构件并获得无效的状态。就像 `unique_ptr` 只有一个所有者一样，类型状态（typestates）也必须只有一个状态。

有了这个，你就可以这样写：

```c++
auto connection  =  GetConnectionBuilder()
  .add_header("first header")
  .add_header("second header")
  .add_body("body")
  .build();
```

任何对协议的偏离都会导致编译失败。

这有几个无论如何都要遵守的规则：

* 你所有的函数必须使用右值引用的对象(比如 `*this` 必须是一个右值引用，在末尾要要有 `&&`)。
* 你可能需要禁用拷贝函数，除非跳转到协议中间状态的时候是有意义的(毕竟这就是我们有右值引用的原因)。
* 你有必要声明你的构造函数为私有，并添加一个工厂（factory）函数来确保人们不会创建一个无开始状态的对象。
* 你需要将移动构造函数添加为友元并实现到另外一种状态，没有这种状态，你就可以随意地将对象从一个状态转移到另外一种状态。
* 你需要确定你已经在每个函数中添加了检查。

总而言之，从头开始正确的实现这些是有一点儿棘手的，并且在自然增长中，你很有可能不想要15种不同的自制类型状态（typestates）实现。如果有一个框架可以轻松且安全地声明这些类型状态就好了！

### ProtEnc 库

这就是 [ProtEnc](https://github.com/nitnelave/ProtEnc)(protocol encoder 的简称)发挥作用的地方。有了数量惊人的模板，该库允许轻松的声明实现 typestate 检查的类。要使用它，需要你的(未检查的)协议实现，这是我们用所有“重要的”注释实现的第一个类。

我们将给这个类增加一个与其有相同的接口但是增加了类型检查的包装类。该包装类将在它的类型中包含一些诸如可能的初始化状态、转换和最终状态。每个包装类函数只是简单的检查转换是否可行，然后完美的转发调用给下一个对象。所有的这些都不包括指针的间接寻址、运行时组件或者内存分配，所以它完全自由的！

那么，我们怎么声明这个包装类呢？首先，我们不得不定义一个有限状态机。这包括三个部分：初始状态、转换和最终状态或者转换。初始状态的列表只是我们的枚举类型的列表，就像下边这样的：

```c++
using  MyInitialStates  =  InitialStates<START>;
```

对于转换，我们需要初始化状态、最终状态和执行状态转换的函数：

```c++
using  MyTransitions  =  Transitions<
  Transition<START,  HEADERS,  &HttpConnectionBuilder::add_header>,
  Transition<HEADERS,  HEADERS,  &HttpConnectionBuilder::add_header>,
  Transition<HEADERS,  BODY,  &HttpConnectionBuilder::add_body>>;
```

对于最终的转换，我们也需要一个状态和函数：

```c++
using  MyFinalTransitions  =  FinalTransitions<
  FinalTransition<BODY,  &HttpConnectionBuilder::build>>;
```

这个额外的 "FinalTransitions" 是因为我们可能会定义多个 "FinalTransition"。

现在我们可以声明我们的包装类的类型了。一些不可避免的模板被宏定义隐藏起来，但它主要是基类的构造或者元的声明。

```c++
PROTENC\_DECLARE\_WRAPPER(HttpConnectionBuilderWrapper,  HttpConnectionBuilder,  BuilderState,  MyInitialStates,  MyTransitions,  MyFinalTransitions);
```

这是展开的一个作用域（一个类），我们可以在其中转发我们的函数：

```c++
PROTENC\_DECLARE\_TRANSITION(add_header);
PROTENC\_DECLARE\_TRANSITION(add_body);
PROTENC\_DECLARE\_FINAL_TRANSITION(build);
```

然后是关闭作用域。

```c++
PROTENC\_END\_WRAPPER;
```

(那只是一个右括号，但你不想要不匹配的括号，是吗?)

通过这个简单但可扩展的设置，你就可以像使用上一步中的包装器一样使用它啦，并且所有的操作都会被检查。🙂

```c++
auto connection  =  HttpConnectionBuilderWrapper<START>{}
  .add_header("first header")
  .add_header("second header")
  .add_body("body")
  .build();
```

试图在错误的顺序下调用函数将导致编译错误。别担心，精心的设计保证了第一个错误信息是可读的😉。例如，移除 `.add_body("body")` 行，你将得到以下错误：

In file included from example/http_connection.cc:6:

```c++
src/protenc.h:  In  instantiation of  ‘struct  prot_enc::internal::return\_of\_final\_transition\_t<prot_enc::internal::NotFound,  HTTPConnectionBuilder>’:
src/protenc.h:273:15:     required by  ...
example/http_connection.cc:174:42:     required from here
src/protenc.h:257:17:  error:  static  assertion failed:  Final  transition not  found
   static_assert(!std::is\_same\_v<T,  NotFound>,  "Final transition not found");
```

只要确保包装类只能从包装器构造，就可以保证整个代码库的正确运行！

如果您的状态机是以另一种形式编码的(或者如果它变得太大了)，那么生成描述它的代码就很简单了，因为所有的转换和初始状态都是以一种容易读/写的格式聚集在一起的。

完整的代码示例可以在 [GitHub](https://github.com/nitnelave/ProtEnc) 找到。请注意该代码现在不能使用 Clang 因为 [bug #35655](https://bugs.llvm.org/show_bug.cgi?id=35655)。


### 你将也喜欢

* [TODO_BEFORE(): A Cleaner Codebase for 2019](https://www.fluentcpp.com/2019/01/01/todo_before-clean-codebase-2019/)
* [How to Disable a Warning in C++](https://www.fluentcpp.com/2019/08/30/how-to-disable-a-warning-in-cpp/)
* [Curried Objects in C++](https://www.fluentcpp.com/2019/05/03/curried-objects-in-cpp/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
