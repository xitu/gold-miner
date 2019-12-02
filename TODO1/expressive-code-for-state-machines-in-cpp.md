> * 原文地址：[Expressive Code for State Machines in C++](https://www.fluentcpp.com/2019/09/24/expressive-code-for-state-machines-in-cpp/)
> * 原文作者：[Jonathan Boccara](https://www.fluentcpp.com/author/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/expressive-code-for-state-machines-in-cpp.md](https://github.com/xitu/gold-miner/blob/master/TODO1/expressive-code-for-state-machines-in-cpp.md)
> * 译者：
> * 校对者：

# Expressive Code for State Machines in C++

> This is a guest post from Valentin Tolmer. Valentin is a Software Engineer at Google, where he tries to improve the quality of the code around him. He was bitten by a template when he was young, and now only meta-programs. You can find some of his work on [Github](https://github.com/nitnelave), in particular the [ProtEnc](https://github.com/nitnelave/ProtEnc) library this article is about.

Have you ever run into this kind of comments?

```c++
// IMPORTANT: Do not call this function before calling SetUp()!
```
Or checks like these:

```c++
if  (my\_field\_.empty())  abort();
```

Those are all symptoms of a (often light-weight) protocol that our code must respect. Or sometimes, you have an explicit protocol that you’re following, such as in the implementation of an SSL handshake or other business logic. Or maybe you have an explicit state machine in your code, with the transitions checked each time against a list of possible transitions.

Let’s have a look at how we can **expressively** handle these cases.

### Example: Building an HTTP Connection

Our example today will be building an HTTP connection. To simplify greatly, let’s say that our connection requires at least one header (but can have more), exactly one body, and that the headers must be specified before the body (e.g. because we write into an append-only data structure for performance reasons).

**Note: this** ****specific**** **problem could be solved with a constructor taking the correct parameters, but I didn’t want to over-complicate the protocol. You’ll see how easily extensible it is.**

Here’s a first implementation:

```c++
class  HttpConnectionBuilder  {
 public:
  void  add_header(std::string  header)  {
    headers_.emplace_back(std::move(header);
  }
  // IMPORTANT : must be called after at least one add_header
  void  add_body(std::string  body)  {
    body_  =  std::move(body);
  }
  // IMPORTANT : must be called after add_body.
  // Consumes the object.
  HttpConnection build()  &&  {
    return  {std::move(headers_),  std::move(body_)};
  }
 private:
  std::vector<std::string>  headers_;
  std::string  body_;
};
```

Now, this example is quite simple, but already it’s relying on the user not doing things wrong: there’s nothing preventing them from adding another header after the body, if they didn’t read the documentation. Put this into a 1000-line file, and you’ll quickly get bad surprises. Worse, there’s no check that the class is used correctly, so the only way to see that it was misused is through the unwanted side effects! If it causes memory corruption, good luck debugging this.

We can do better…

### Using dynamic enums

As is often the case, this protocol can be represented by a finite state machine: start in the state in which we didn’t add any header (START), in which case the only option is to add a header. Then we’re in the state where we have at least one header (HEADER), from which we can either add another header and stay in this state, or add a body and go to the BODY state. Only from there can we call build, getting us to the final state.

![typestates state machine](https://www.fluentcpp.com/wp-content/uploads/2019/09/state_machine.png)

So, let’s encode that into our class!

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

And so on for the other functions. That’s already better: we have an explicit state telling us which transitions are possible, and we check it. Of course, you have thorough tests for your code, right? Then you’ll be able to catch any violation at test time, providing you have enough coverage. You might enable those checks in production as well to make sure that you don’t deviate from the protocol (a controlled crash is better than memory corruption), but you’ll have to pay the price of the added checks.

### Using typestates

How can we catch these earlier, and with 100% certainty? Let the compiler do the work! Here I’ll introduce the concept of typestates:

Roughly speaking, typestates are the idea of encoding the state of an object in its very type. Some languages do this by implementing a separate class for each state (e.g. `HttpBuilderWithoutHeader`, `HttpBuilderWithBody`, …) but that can get fairly verbose in C++: we have to declare the constructors, delete the copy constructors, convert one object into the other… It gets old quickly.

But C++ has another trick up its sleeve: templates! We can encode the state in an enum, and template our builder with this enum. This gives us something like:

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

Here we check statically that the object is in the correct state. Invalid code won’t even compile! And we get a pretty clear error message. Every time we create a new object of the type corresponding to the target state, and destroy the object corresponding to the previous state: you call add_header on an object of type `HttpConnectionBuilder<START>`, but you’ll get an `HttpConnectionBuilder<HEADER>` as return value. That’s the core idea of typestates.

Note that the methods can only be called on r-values (`std::move`, that’s the role of the trailing “`&&`” in the function declaration). Why so? It enforces the destruction of the previous state, so you only get the relevant state. Think about it like a `unique_ptr`: you don’t want to copy the internals and get an invalid state. Just like there should be a single owner for a `unique_ptr`, there should be a single state for a typestate.

With this, you can write:

```c++
auto connection  =  GetConnectionBuilder()
  .add_header("first header")
  .add_header("second header")
  .add_body("body")
  .build();
```

Any deviation from the protocol will be a compilation failure.

There are however a couple of things to keep in mind:

* All your functions must take the object by r-value (i.e. `*this` must be an r-value, the trailing “`&&`”).
* You probably want to disable copy constructors, unless it makes sense to jump in the middle of the protocol (that’s the reason we have r-values, after all).
* You need to declare your constructor private, and friend a factory function to make sure that people don’t create the object in a non-start state.
* You need to friend and implement the move constructor to another state, without which you can transform your object from one state to another.
* You need to make sure you added checks in every function.

All in all, implementing this correctly from scratch is a bit tricky, and you probably don’t want 15 different self-made typestates implementations in the wild. If only there were a framework to easily and safely declare these typestates!

### The ProtEnc library

Here’s where [ProtEnc](https://github.com/nitnelave/ProtEnc) (short for protocol encoder) comes in. With a scary amount of templates, the library allows for an easy declaration of a class implementing the typestate checks. To use it, you need your (unchecked) implementation of the protocol, the very first class we wrote with all the “IMPORTANT” comments (which we’ll remove).

We’re going to add a wrapper to that class, presenting the same interface but with typestate checks. The wrapper will contain the information about the possible initial state, transitions and final transitions in its type. Each wrapper function is simply checking if the transition is allowed, then perfect-forwarding the call to the underlying object. All of this without pointer indirection, runtime component or memory footprint, so it’s essentially free!

So, how do we declare this wrapper? First, we have to define the finite state machine. This consists of 3 parts: initial states, transitions, and final states/transitions. The list of initial states is just a list of our enum, like so:

```c++
using  MyInitialStates  =  InitialStates<START>;
```

For the transition, we need the initial state, the final state, and the function that will get us there:

```c++
using  MyTransitions  =  Transitions<
  Transition<START,  HEADERS,  &HttpConnectionBuilder::add_header>,
  Transition<HEADERS,  HEADERS,  &HttpConnectionBuilder::add_header>,
  Transition<HEADERS,  BODY,  &HttpConnectionBuilder::add_body>>;
```

And for the final transitions, we’ll need the state and the function:

```c++
using  MyFinalTransitions  =  FinalTransitions<
  FinalTransition<BODY,  &HttpConnectionBuilder::build>>;
```

The extra “FinalTransitions” comes from the possibility of having more than one “FinalTransition”.

We can now declare our wrapping type. Some of the unavoidable boilerplate had been hidden in a macro, but it’s mostly just constructors and friend declarations with the base class that does the heavy lifting:

```c++
PROTENC\_DECLARE\_WRAPPER(HttpConnectionBuilderWrapper,  HttpConnectionBuilder,  BuilderState,  MyInitialStates,  MyTransitions,  MyFinalTransitions);
```

That opens a scope (a class) in which we can forward our functions:

```c++
PROTENC\_DECLARE\_TRANSITION(add_header);
PROTENC\_DECLARE\_TRANSITION(add_body);
PROTENC\_DECLARE\_FINAL_TRANSITION(build);
```

And then close the scope.

```c++
PROTENC\_END\_WRAPPER;
```

(That one is just a closing brace, but you don’t want mismatching braces, do you?)

With this simple yet extensible setup, you can use the wrapper just like we used the one from the previous step, and all the operations will be checked 🙂

```c++
auto connection  =  HttpConnectionBuilderWrapper<START>{}
  .add_header("first header")
  .add_header("second header")
  .add_body("body")
  .build();
```

Trying to call the functions in the wrong order will cause compilation errors. Don’t worry, care was taken to make sure that the first error has a readable error message 😉 For instance, removing the `.add_body("body")` line, you would get:

In file included from example/http_connection.cc:6:

```c++
src/protenc.h:  In  instantiation of  ‘struct  prot_enc::internal::return\_of\_final\_transition\_t<prot_enc::internal::NotFound,  HTTPConnectionBuilder>’:
src/protenc.h:273:15:     required by  ...
example/http_connection.cc:174:42:     required from here
src/protenc.h:257:17:  error:  static  assertion failed:  Final  transition not  found
   static_assert(!std::is\_same\_v<T,  NotFound>,  "Final transition not found");
```

Just make sure that your wrapped class is only constructible from the wrapper, and you’ll have guaranteed enforcement throughout your codebase!

If your state machine is encoded in another form (or if it gets too big), it would be trivial to generate code describing it, since all the transitions and initial states are gathered together in an easy-to-read/write format.

The full code of this example can be found in the [repository](https://github.com/nitnelave/ProtEnc). Note that it currently doesn’t work with Clang because of [bug #35655](https://bugs.llvm.org/show_bug.cgi?id=35655).

### You will also like

* [TODO_BEFORE(): A Cleaner Codebase for 2019](https://www.fluentcpp.com/2019/01/01/todo_before-clean-codebase-2019/)
* [How to Disable a Warning in C++](https://www.fluentcpp.com/2019/08/30/how-to-disable-a-warning-in-cpp/)
* [Curried Objects in C++](https://www.fluentcpp.com/2019/05/03/curried-objects-in-cpp/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
