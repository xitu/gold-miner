> * 原文地址：[C++ Coroutines: Understanding operator co_await](https://lewissbaker.github.io/2017/11/17/understanding-operator-co-await)
> * 原文作者：[lewissbaker](https://lewissbaker.github.io)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-operator-co-await.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-operator-co-await.md)
> * 译者：[7Ethan](https://github.com/7Ethan)
> * 校对者：

# C++ 协程：理解运算符 `co_await`

在之前关于[协程理论的博客](https://lewissbaker.github.io/2017/09/25/coroutine-theory)中，我描述了函数和协程序之间的一些高层次的差异，但没有详细介绍 c++ 协程技术规范（[N4680](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2017/n4680.pdf)）中描述的语法和语义。

协程技术规范中，c++ 新增的关键新功能是能够挂起协程，并能够在之后恢复。技术规范为此提供的机制是通过新的 `co_await` 运算符去实现。

理解 `co_await` 运算符的工作原理可以帮助揭开协程的行为神秘面纱，以及它们如何被暂停和恢复的。在这篇文章中，我将解释 `co_await` 操作符的机制，并介绍 **Awaitable** 和 **Awaiter** 类型的相关概念。

在讲解 `co_await` 之前，我想简要介绍一下协程的技术规范，以提供一些背景知识。

## 协程技术规范给我们提供了什么？

*   三个新的关键字： `co_await`， `co_yield` 和 `co_return`
*   `std::experimental` 命名空间的几个新类型:
    *   `coroutine_handle<P>`
    *   `coroutine_traits<Ts...>`
    *   `suspend_always`
    *   `suspend_never`
*   库作者制定与协程交互的通用机制。
*   一个使异步代码变得更加简单的语言工具！

 C++ 协程技术规范在语言中提供的工具，可以理解为协程的*低级汇编语言*。 这些工具很难直接以安全的方式使用，主要是供库作者使用，用于构建应用程序开发人员可以安全使用的更高级别的抽象。

未来会将这些新的低级工具交付给即将到来的语言标准（可能是 c++20），以及标准库中伴随的一些高级类型，这些高级类型封装了这些低级构建块，应用程序开发人员将可以通过一种安全的方式轻松访问协程。

## 编译器与库的交互

有趣的是，协程技术规范实际上并没有定义协程的语义。它没有定义如何生成返回给调用者的值，没有定义如何处理传递给 `co_return` 语句的返回值，如何处理传递出协程的异常，它也没有定义应该恢复协程的线程。

相反，它指定了库代码的通用机制，那就是通过实现符合特定接口的类型来定制协程的行为。然后，编译器生成代码，在库提供的类型实例上调用方法。这种方法类似于库作者通过定义 `begin()` / `end()` 方法或 `iterator` 类型来定制基于范围的 for 循环的实现。

协程技术规范没有对协程的机制规定任何特定的语义，这使它成为一个强大的工具。它允许库作者为各种不同目的来定义许多不同种类的协程。

例如，你可以定义一个异步生成单个值的协程，或者一个延迟生成一系列值的协程，或者如果遇到 `nullopt` 值，则通过提前退出来简化控制流以消耗 `optional <T>` 值的协程。

协程技术规范定义了两种接口：**Promise** 接口和 **Awaitable** 接口。

**Promise** 接口指定用于自定义协程本身行为的方法。库作者能够自定义调用协程时发生的事件，如协程返回时（通过正常方式或通过未处理的异常返回），或者自定义协程中任何 `co_await` 或 `co_yield` 表达式的行为。

**Awaitable** 接口指定控制 `co_await` 表达式语义的方法。当一个值为 `co_await` 时，代码被转换为对 awaitable 对象上的方法的一系列调用。它可以指定：是否暂停当前协程，暂停调度协程以便稍后恢复后执行一些逻辑，还有在协程恢复后执行一些逻辑以产生 `co_await` 表达式的结果。

我将在以后的博客中介绍 **Promise** 接口的细节，但现在让我们来看看 **Awaitable** 借口。

## Awaiters 与 Awaitables：解释操作符 `co_await`

`co_await`运算符是一个新的一元运算符，可以应用于一个值。例如：`co_await someValue`。

`co_await` 运算符只能在协程的上下文中使用。这有点语义重复，因为根据定义，任何包含 `co_await` 运算符的函数体都将被编译为协程。

支持 `co_await` 运算符的类型称为 **Awaitable** 类型。

注意，`co_await` 运算符是否可以用作类型取决于 `co_await` 表达式出现的上下文。用于协程的 promise 类型可以通过其 `await_transform` 方法更改协程中的 `co_await` 表达式的含义（稍后将详细介绍）。

 为了更具体地在需要的地方，我喜欢使用术语 **Normally Awaitable** 来描述在协程类型中没有 `await_transform` 成员的协程上下文中支持 `co_await` 运算符的类型。我喜欢使用术语 **Contextually Awaitable** 来描述一种类型，它在某些类型的协程的上下文中仅支持 `co_await` 运算符，因为协程的 promise 类型中存在 `await_transform` 方法。（我乐意接受这些名字的更好建议...）

**Awaiter** 类型是一种实现三个特殊方法的类型，它们被称为 `co_await` 表达式的一部分：`await_ready`，`await_suspend`和`await_resume`。

请注意，我在 C＃ `async` 关键字的机制中“借用”了 “Awaiter” 这个术语，该机制是根据 `GetAwaiter（）` 方法实现的，该方法返回一个对象，其接口与 c++ 的 **Awaiter** 概念惊人的相似。有关 C＃ awaiters 的更多详细信息，请参阅[这篇博文](https://weblogs.asp.net/dixin/understanding-c-sharp-async-await-2-awaitable-awaiter-pattern)。

请注意，类型可以是 **Awaitable** 类型和 **Awaiter** 类型。

当编译器遇到 `co_await <expr>` 表达式时，实际上可以根据所涉及的类型将其转换为许多可能的内容。

### 获取 Awaiter

编译器做的第一件事是生成代码，以获取等待值的 **Awaiter** 对象。在 N4680 章节 5.3.8(3) 中，有很多步骤可以获得 awaiter。

让我们假设等待协程的 promise 对象具有类型 `P`，并且 `promise` 是对当前协程的 promise 对象的 l 值引用。

如果 promise 类型 `P` 有一个名为 `await_transform` 的成员，那么 `<expr>` 首先被传递给 `promise.await_transform（<expr>）` 以获得 **Awaitable** 的值。 否则，如果 promise 类型没有 `await_transform` 成员，那么我们使用直接评估 `<expr>` 的结果作为 **Awaitable** 对象。

然后，如果 **Awaitable** 对象，有一个可用的运算符 `co_await（）` 重载，那么调用它来获取 **Awaiter** 对象。 否则，`awaitable` 的对象被用作 awaiter 对象。

如果我们将这些规则编码到 `get_awaitable（）` 和 `get_awaiter（）` 函数中，它们可能看起来像这样：

```cpp
template<typename P, typename T>
decltype(auto) get_awaitable(P& promise, T&& expr)
{
  if constexpr (has_any_await_transform_member_v<P>)
    return promise.await_transform(static_cast<T&&>(expr));
  else
    return static_cast<T&&>(expr);
}

template<typename Awaitable>
decltype(auto) get_awaiter(Awaitable&& awaitable)
{
  if constexpr (has_member_operator_co_await_v<Awaitable>)
    return static_cast<Awaitable&&>(awaitable).operator co_await();
  else if constexpr (has_non_member_operator_co_await_v<Awaitable&&>)
    return operator co_await(static_cast<Awaitable&&>(awaitable));
  else
    return static_cast<Awaitable&&>(awaitable);
}
```

### 等待 Awaiter

因此，假设我们已经封装了将 `<expr>` 结果转换为 **Awaiter** 对象到上述函数中的逻辑，那么 `co_await <expr>` 的语义可以（大致）这样转换：

```cpp
{
  auto&& value = <expr>;
  auto&& awaitable = get_awaitable(promise, static_cast<decltype(value)>(value));
  auto&& awaiter = get_awaiter(static_cast<decltype(awaitable)>(awaitable));
  if (!awaiter.await_ready())
  {
    using handle_t = std::experimental::coroutine_handle<P>;

    using await_suspend_result_t =
      decltype(awaiter.await_suspend(handle_t::from_promise(p)));

    <suspend-coroutine>

    if constexpr (std::is_void_v<await_suspend_result_t>)
    {
      awaiter.await_suspend(handle_t::from_promise(p));
      <return-to-caller-or-resumer>
    }
    else
    {
      static_assert(
         std::is_same_v<await_suspend_result_t, bool>,
         "await_suspend() must return 'void' or 'bool'.");

      if (awaiter.await_suspend(handle_t::from_promise(p)))
      {
        <return-to-caller-or-resumer>
      }
    }

    <resume-point>
  }

  return awaiter.await_resume();
}
```

当 `await_suspend（）` 的调用返回时，`await_suspend（）` 的返回值为 `void` 的版本无条件地将执行转移回协程的调用者/恢复者，而返回值为 `bool` 的版本允许 awaiter 对象有条件地返回并立即恢复协程，而不返回调用者/恢复者。

`await_suspend（）` 的 `bool` 返回版本在 awaiter 可能启动异步操作（有时可以同步完成）的情况下非常有用。 在它同步完成的情况下，`await_suspend（）` 方法可以返回 `false` 以指示应该立即恢复协程并继续执行。

在 `<suspend-coroutine>` 处，编译器生成一些代码来保存协程的当前状态并准备恢复。这包括存储 `<resume-point>` 的断点位置，以及将当前保存在寄存器中的任何值溢出到协程帧存储器中。

在 `<suspend-coroutine>` 操作完成后，当前的协程被认为是暂停的。你可以观察到暂停的协程的第一个断点是在 `await_suspend（）` 的调用中。协程暂停后，就可以恢复或销毁。

当操作完成，`await_suspend（）` 方法负责在将来的某个时刻调度并将协程恢复（或销毁）。注意，从 `await_suspend()` 中返回 `false` 算作调度协程，以便在当前线程上立即恢复。

`await_ready（）` 方法的目的，是允许你在已知操作同步完成而不需要挂起的情况下避免 `<suspend-coroutine>` 操作的成本。

在 `<return-to-caller-or-resumer>` 断点处执行转移回调用者或恢复者，弹出本地堆栈帧但保持协程帧活跃。

当（或者说如果）暂停的协程最终恢复时，执行将在 `<resume-point>` 断点处重新开始。即紧接在调用 `await_resume（） `方法之前获取操作的结果。

`await_resume（）` 方法调用的返回值成为 `co_await` 表达式的结果。`await_resume（）` 方法也可以抛出异常，在这种情况下异常从 `co_await` 表达式中抛出。

注意，如果异常从 `await_suspend（）` 抛出，则协程会自动恢复，并且异常会从 `co_await` 表达式抛出而不调用 `await_resume（）`。

## 协程句柄

你可能已经注意到 `coroutine_handle <P>` 类型的使用，该类型被传递给 `co_await` 表达式的 `await_suspend（）` 调用。

该类型表示协程帧的非拥有句柄，可用于恢复协程的执行或销毁协程帧。它还可以用于访问协程的 promise 对象。

`coroutine_handle` 类型具有以下接口：

```cpp
namespace std::experimental
{
  template<typename Promise>
  struct coroutine_handle;

  template<>
  struct coroutine_handle<void>
  {
    bool done() const;

    void resume();
    void destroy();

    void* address() const;
    static coroutine_handle from_address(void* address);
  };

  template<typename Promise>
  struct coroutine_handle : coroutine_handle<void>
  {
    Promise& promise() const;
    static coroutine_handle from_promise(Promise& promise);

    static coroutine_handle from_address(void* address);
  };
}
```

在实现 **Awaitable** 类型时，你将在 `coroutine_handle` 上使用的主要方法是 `.resume()`，当操作完成并希望恢复等待的协程的执行时，应该调用这个方法。在 `coroutine_handle` 上调用 `.resume()` 将在 `<resume-point>` 重新唤醒一个挂起的协程。当协程接下来遇到一个 `<return-to-caller-or-resumer>` 时，对 `.resume（）` 的调用将返回。

`.destroy（）` 方法销毁协程帧，调用任何范围内变量的析构函数并释放协程帧使用的内存。通常，你不需要（实际上应该是避免）调用 `.destroy（）`，除非你是一个实现协程 promise 类型的库编写者。通常，协程帧将由从对协程的调用返回的某种 RAII（译者注：资源获取即初始化）类型拥有。 所以在没有与 RAII 对象合作的情况下调用 `.destroy（）` 可能会导致双重销毁的错误。

`.promise（）` 方法返回对协程的 promise 对象的引用。但是，就像 `.destroy（）` 那样，它通常只在你创建协程 promise 类型时才有用。 你应该将协程的 promise 对象视为协程的内部实现细节。 对于大多数**常规的 Awaitable** 类型，你应该使用 `coroutine_handle <void>` 作为 `await_suspend（）` 方法的参数类型，而不是 `coroutine_handle <Promise>`。

`coroutine_handle <P> :: from_promise（P＆promise）` 函数允许从对协程的 promise 对象的引用重构协程句柄。注意，你必须确保类型 `P` 与用于协程帧的具体 promise 类型完全匹配; 当具体的 promise 类型是 `Derived` 时，试图构造 `coroutine_handle <Base>` 会出现未定义的行为的错误。

`.address（）`/`from_address（）` 函数允许将协程句柄转换为 `void*` 指针。这主要是为了允许作为 “context(上下文)”参数传递到现有的 C 风格的 API 中，因此你可能会发现在某些情况下实现 **Awaitable** 类型很有用。但是，在大多数情况下，我发现有必要将附加信息传递给这个 'context' 参数中的回调，因此我通常最终将 `coroutine_handle` 存储在结构中并将指针传递给 'context' 参数中的结构而不是使用 `.address（）` 返回值。

## 无同步的异步代码

`co_await` 运算符的一个强大的设计功能是在协程挂起之后但在执行返回给调用者/恢复者之前执行代码的能力。

这允许 Awaiter 对象在协程已经被挂起之后发起异步操作，将被挂起的协程的(句柄) `coroutine_handle` 传递给运算符，当操作完成时(可能在另一个线程上)它可以安全地恢复操作，而不需要任何额外的同步。

例如，当协程已经挂起时，在 `await_suspend（）` 内启动异步读操作意味着我们可以在操作完成时恢复协程，而不需要任何线程同步来协调启动操作的线程和完成操作的线程。

```
Time     Thread 1                           Thread 2
  |      --------                           --------
  |      ....                               Call OS - Wait for I/O event
  |      Call await_ready()                    |
  |      <supend-point>                        |
  |      Call await_suspend(handle)            |
  |        Store handle in operation           |
  V        Start AsyncFileRead ---+            V
                                  +----->   <AsyncFileRead Completion Event>
                                            Load coroutine_handle from operation
                                            Call handle.resume()
                                              <resume-point>
                                              Call to await_resume()
                                              execution continues....
           Call to AsyncFileRead returns
         Call to await_suspend() returns
         <return-to-caller/resumer>
```

在利用这种方法时要*特别注意*的一件事情是，如果你开始将协程句柄发布到其他线程的操作，那么另一个线程可以在 `await_suspend（）` 返回之前恢复另一个线程上的协程，继续与 `await_suspend（）` 方法的其余部分同时执行。

 协程恢复时首先要做的是调用 `await_resume（）` 来获取结果，然后经常会立即销毁 **Awaiter** 对象（即 `await_suspend（）` 调用的 `this` 指针）。在 `await_suspend（）` 返回之前，协程可能会运行完成，销毁协程和 promise 对象。

所以在 `await_suspend（）` 方法中，如果可以在另一个线程上同时恢复协程，你需要确保避免访问 `this` 指针或协程的 `.promise（）` 对象，因为两者都已经可能已被销毁。一般来说，在启动操作并计划恢复协程之后，唯一可以安全访问的是 `await_suspend()` 中的局部变量。

### 与 Stackful 协程的比较

我想稍微多做一些说明，比较一下协程技术规范中的 stackless 协程在协程挂起后与一些现有的常见的协程工具(如 Win32 纤程或 boost::context )一起执行逻辑的能力。

对于许多 stackful 协程框架，一个协程的暂停操作与另一个协程的恢复操作相结合，形成一个 “context-switch(上下文切换)” 操作。使用这种 “context-switch” 操作，通常在挂起当前协程之后，而在将执行转移到另一个协程之前，没有机会执行逻辑。

这意味着，如果我们想在 stackful 协程之上实现类似的异步文件读取操作，那么我们必须在挂起协程*之前*启动操作。因此，可以在协程暂停*之前*在另一个线程上完成操作，并且有资格恢复。在另一个线程上完成的操作和协程挂起之间的这种潜在竞争需要某种线程同步来仲裁，并决定胜利者。

通过使用 trampoline context 可以解决这个问题，该上下文可以在初始化上下文被挂起后代表启动上下文启动操作。然而，这将需要额外的基础设施和额外的上下文切换以使其工作，并且这引入的开销可能大于它试图避免同步的成本。

## 避免内存分配

异步操作通常需要存储一些每个操作的状态，以跟踪操作的进度。这种状态通常需要在操作期间持续，并且只有在操作完成后才会释放。

例如，调用异步 Win32 I/O 函数需要你分配并传递指向 `OVERLAPPED` 结构的指针。调用者负责确保此指针保持有效，直到操作完成。

使用传统的基于回调的 API，通常需要在堆上分配此状态以确保其具有适当的生命周期。如果你执行了许多操作，则可能需要为每个操作分配并释放此状态。如果性能成为了问题，那么可以使用自定义分配器从内存池中分配这些状态对象。

但是，当我们使用协程时，我们可以通过利用协程帧中的局部变量在协程挂起时保持活动的现场，那么可以避免为操作状态在堆上分配内存。

通过将每个操作状态放置在 **Awaiter** 对象中，我们可以从协程帧有效地 “borrow（借用）” 存储器，用于在 `co_await` 表达式的持续时间内存储每个操作状态。一旦操作完成，协程就会恢复并且销毁 **Awaiter** 对象，从而释放协程帧中的内存以供其他局部变量使用。

最终，协程帧仍然可以在堆上分配。但是，一旦分配了，协程帧就可以使用这个堆分配来执行许多异步操作。

你想想，协程帧就像一种高性能的 arena 内存分配器。编译器在编译时计算出所有局部变量所需的 arena 总大小，然后能够根据需要将内存分配给局部变量，而开销为零！试着用自定义分配器打败它;)

## 示例：实现简单的线程同步原语

既然我们已经介绍了 `co_await` 运算符的许多机制，我想通过实现一个基本可等待同步原语来展示如何将这些知识付诸实践：异步手动重置事件。

这个事件的基本要求是，它需要通过多个并发执行协程来成为 **Awaitable** 状态，当等待时，需要挂起等待的协程，直到某个线程调用 `.set()` 方法，此时任何等待的协程都将恢复。如果某个线程已经调用了 `.set()`，那么协程应该继续，而不是挂起。

理想情况下，我们还希望将其设置为 `noexcept`，不需要堆分配并且不需要锁实现。

**2017/11/23 更新：增加 `async_manual_reset_event` 示例**

示例用法如下所示:

```cpp
T value;
async_manual_reset_event event;

// A single call to produce a value
void producer()
{
  value = some_long_running_computation();

  // Publish the value by setting the event.
  event.set();
}

// Supports multiple concurrent consumers
task<> consumer()
{
  // Wait until the event is signalled by call to event.set()
  // in the producer() function.
  co_await event;

  // Now it's safe to consume 'value'
  // This is guaranteed to 'happen after' assignment to 'value'
  std::cout << value << std::endl;
}
```

让我们首先考虑一下这个事件可能存在的状态：`not set` 和 `set`。

当它处于 'not set' 状态时，有一个（可能为空）等待协程列表正在等待它变为 'set' 状态。

当它处于 ‘set’ 状态时，不会有任何等待的协程，因为 `co_wait` 状态下的事件可以在不暂停的情况下继续。

这个状态实际上可以用一个 `std :: atomic <void *>` 来表示。

*   为 ‘set’ 状态保留一个特殊的指针值。在这种情况下，我们将使用事件的 `this` 指针，因为我们知道不能与任何列表项相同的地址。
*   否则，事件处于 ‘not set’ 状态，并且该值是指向等待协程结构的单链表的头部的指针。

我们可以通过将节点存储在放置在协程帧内的 ‘awaiter’ 对象中，从而避免为堆上的链表分配节点的额外调用。

让我们从一个类接口开始，如下所示:

```cpp
class async_manual_reset_event
{
public:

  async_manual_reset_event(bool initiallySet = false) noexcept;

  // No copying/moving
  async_manual_reset_event(const async_manual_reset_event&) = delete;
  async_manual_reset_event(async_manual_reset_event&&) = delete;
  async_manual_reset_event& operator=(const async_manual_reset_event&) = delete;
  async_manual_reset_event& operator=(async_manual_reset_event&&) = delete;

  bool is_set() const noexcept;

  struct awaiter;
  awaiter operator co_await() const noexcept;

  void set() noexcept;
  void reset() noexcept;

private:

  friend struct awaiter;

  // - 'this' => set state
  // - otherwise => not set, head of linked list of awaiter*.
  mutable std::atomic<void*> m_state;

};
```

我们有一个相当直接和简单的借口。在这一点上，要注意的主要事情是它有一个 `operator co_await（）` 方法，它返回一个尚未定义的 `awaiter` 类型。

现在让我们来定义 `awaiter` 类型

### 定义 Awaiter 类型

首先，它需要知道它将等待哪个 `async_manual_reset_event` 的对象，因此它需要对事件的引用和构造函数来初始化它。

它还需要充当 `awaiter` 值链表中的节点，因此它需要持有指向列表中下一个 `awaiter` 对象的指针。

I它还需要存储正在执行 `co_await` 表达式的等待协程的`coroutine_handle`，以便在事件变为 'set' 状态时事件可以恢复协程。我们不关心协程的 promise 类型是什么，所以我们只使用 `coroutine_handle <>`（这是 `coroutine_handle <void>` 的简写）。

最后，它需要实现 **Awaiter** 接口，因此需要三种特殊方法：`await_ready`，`await_suspend` 和 `await_resume`。 我们不需要从 `co_await` 表达式返回一个值，因此 `await_resume` 可以返回 `void`。

当我们将这些都放在一起，`awaiter` 的基本类接口如下所示：

```cpp
struct async_manual_reset_event::awaiter
{
  awaiter(const async_manual_reset_event& event) noexcept
  : m_event(event)
  {}

  bool await_ready() const noexcept;
  bool await_suspend(std::experimental::coroutine_handle<> awaitingCoroutine) noexcept;
  void await_resume() noexcept {}

private:

  const async_manual_reset_event& m_event;
  std::experimental::coroutine_handle<> m_awaitingCoroutine;
  awaiter* m_next;
};
```

现在，当我们执行 `co_await` 一个事件时，如果事件已经设置，我们不希望等待协程暂停。 因此，如果事件已经设置，我们可以定义 `await_ready（）` 来返回 `true`。

```cpp
bool async_manual_reset_event::awaiter::await_ready() const noexcept
{
  return m_event.is_set();
}
```

接下来，让我们看一下 `await_suspend（）` 方法。这通常是 awaitable 类型会发生莫名其妙的事情的地方。

首先，它需要将等待协程的句柄存入 `m_awaitingCoroutine` 成员，以便事件稍后可以在其上调用 `.resume（）`。

然后，当我们完成了这一步，我们需要尝试将 awaiter 自动加入到 waiters 的链表中。如果我们成功加入它，然后我们返回 `true` ，以表明我们不想立即恢复协程，否则，如果我们发现事件已并发地更改为 `set` 状态，那么我们返回 `false` ，以表明协程应立即恢复。

```cpp
bool async_manual_reset_event::awaiter::await_suspend(
  std::experimental::coroutine_handle<> awaitingCoroutine) noexcept
{
  // Special m_state value that indicates the event is in the 'set' state.
  const void* const setState = &m_event;

  // Remember the handle of the awaiting coroutine.
  m_awaitingCoroutine = awaitingCoroutine;

  // Try to atomically push this awaiter onto the front of the list.
  void* oldValue = m_event.m_state.load(std::memory_order_acquire);
  do
  {
    // Resume immediately if already in 'set' state.
    if (oldValue == setState) return false; 

    // Update linked list to point at current head.
    m_next = static_cast<awaiter*>(oldValue);

    // Finally, try to swap the old list head, inserting this awaiter
    // as the new list head.
  } while (!m_event.m_state.compare_exchange_weak(
             oldValue,
             this,
             std::memory_order_release,
             std::memory_order_acquire));

  // Successfully enqueued. Remain suspended.
  return true;
}
```

注意，在加载旧状态时，我们使用 'acquire' 查看内存顺序，如果我们读取特殊的 'set' 值时，那么我们就可以看到在调用 'set()' 之前发生的写操作。

如果 compare-exchange 执行成功，我们需要 ‘release’ 的状态，以便后续的 ‘set()’ 调用将看到我们对 m_awaitingconoutine 的写入，以及之前对协程状态的写入。

### 补全事件类的其余部分

现在我们已经定义了 `awaiter` 类型，让我们回过头来看看 `async_manual_reset_event` 方法的实现。

首先是构造函数。它需要初始化为 'not set' 状态和空的 waiters 链表（即 `nullptr`）或初始化为 'set' 状态（即 `this`）。

```cpp
async_manual_reset_event::async_manual_reset_event(
  bool initiallySet) noexcept
: m_state(initiallySet ? this : nullptr)
{}
```

接下来，`is_set（）` 方法非常简单 - 如果它具有特殊值 `this`，则为 'set'：

```cpp
bool async_manual_reset_event::is_set() const noexcept
{
  return m_state.load(std::memory_order_acquire) == this;
}
```

然后是 `reset（）` 方法，如果它处于 'set' 状态，我们希望它转换为 'not set' 状态，否则保持原样。

```cpp
void async_manual_reset_event::reset() noexcept
{
  void* oldValue = this;
  m_state.compare_exchange_strong(oldValue, nullptr, std::memory_order_acquire);
}
```

使用 `set（）` 方法，我们希望通过使用特殊的 'set' 值（`this`）将当前状态来转换到 'set' 状态，然后检查原本的值是什么。 如果有任何等待的协程，那么我们希望在返回之前依次顺序恢复它们。

```cpp
void async_manual_reset_event::set() noexcept
{
  // Needs to be 'release' so that subsequent 'co_await' has
  // visibility of our prior writes.
  // Needs to be 'acquire' so that we have visibility of prior
  // writes by awaiting coroutines.
  void* oldValue = m_state.exchange(this, std::memory_order_acq_rel);
  if (oldValue != this)
  {
    // Wasn't already in 'set' state.
    // Treat old value as head of a linked-list of waiters
    // which we have now acquired and need to resume.
    auto* waiters = static_cast<awaiter*>(oldValue);
    while (waiters != nullptr)
    {
      // Read m_next before resuming the coroutine as resuming
      // the coroutine will likely destroy the awaiter object.
      auto* next = waiters->m_next;
      waiters->m_awaitingCoroutine.resume();
      waiters = next;
    }
  }
}
```

最后，我们需要实现 `operator co_await（）` 方法。这只需要构造一个 `awaiter` 对象。

```cpp
async_manual_reset_event::awaiter
async_manual_reset_event::operator co_await() const noexcept
{
  return awaiter{ *this };
}
```

我们终于完成它了，一个等待的异步手动重置事件，具有无锁，无内存分配，`noexcept` 实现。

I如果你想尝试一下代码，或者看看它编译到 MSVC 和 Clang 下面的代码，可以看看 [godbolt 上的源代码](https://godbolt.org/g/Ad47tH)。

你还可以在 [cppcoro](https://github.com/lewissbaker/cppcoro) 库中找到此类的实现，以及许多其他有用的 awaitable 类型，例如 `async_mutex` 和 `async_auto_reset_event`。

## 结语

这篇博客研究了如何根据 **Awaitable** 和 **Awaiter** 概念实现和定义运算符 `co_await`。

它还介绍了如何实现一个等待的异步线程同步原语，该原语利用了在协程帧上分配 awaiter 对象的事实，以避免额外的堆分配。

我希望这篇文章已经帮助你对 `co_await` 这个新的运算符有更好的理解。

在下一篇博客中，我将探讨 **Promise** 概念以及协程类型作者如何定制其协程的行为。

## 致谢

我要特别感谢 Gor Nishanov 在过去几年中耐心而热情地回答了我关于协程的许多问题。

此外，还有 Eric Niebler 对本文的早期草稿进行审核并提供反馈。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
