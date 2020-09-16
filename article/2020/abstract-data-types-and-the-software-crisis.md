> * 原文地址：[Abstract Data Types and the Software Crisis](https://medium.com/javascript-scene/abstract-data-types-and-the-software-crisis-671ea7fc72e7)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/abstract-data-types-and-the-software-crisis.md](https://github.com/xitu/gold-miner/blob/master/article/2020/abstract-data-types-and-the-software-crisis.md)
> * 译者：
> * 校对者：

# Abstract Data Types and the Software Crisis

#### How Abstractions Help Us Manage Software Complexity

![Image: [MattysFlicks — Smoke Art — Cubes to Smoke](https://www.flickr.com/photos/68397968@N07/11432696204) ([CC BY 2.0](https://creativecommons.org/licenses/by/2.0/))](https://cdn-images-1.medium.com/max/4096/1*DSu4IJYOeNzJbQIip9oTVg.jpeg)

> **Note:** This is part of the “Composing Software” serie**s [(now a book!)](https://leanpub.com/composingsoftware)** on learning functional programming and compositional software techniques in JavaScriptES6+ from the ground up. Stay tuned. There’s a lot more of this to come!**
**[Buy the Book](https://leanpub.com/composingsoftware) | [Index](https://medium.com/javascript-scene/composing-software-the-book-f31c77fc3ddc) | [\< Previous](https://medium.com/javascript-scene/abstraction-composition-cb2849d5bdd6) | [Next >](https://medium.com/javascript-scene/functors-categories-61e031bac53f)

## Abstract Data Types

> **Not to be confused with:**
>
> **Algebraic Data Types** (sometimes abbreviated ADT or AlgDT). Algebraic Data Types refer to complex types in programming languages (e.g., Rust, Haskell, F#) that display some properties of specific algebraic structures. e.g., sum types and product types.
>
> **Algebraic Structures.** Algebraic structures are studied and applied from abstract algebra, which, like ADTs, are also commonly specified in terms of algebraic descriptions of axioms, but applicable far outside the world of computers and code. An algebraic structure can exist that is impossible to model in software completely. For contrast, Abstract Data Types serve as a specification and guide to formally verify working software.

An Abstract Data Type (ADT) is an abstract concept defined by axioms that represent some data and operations on that data. ADTs are **not** defined in terms of concrete instances and **do not specify** the concrete data types, structures, or algorithms used in implementations. Instead, ADTs define data types only in terms of their operations, and the axioms to which those operations must adhere.

## Common ADT Examples

* List
* Stack
* Queue
* Set
* Map
* Stream

ADTs can represent any set of operations on any kind of data. In other words, the exhaustive list of all possible ADTs is infinite for the same reason that the exhaustive list of all possible English sentences is infinite. ADTs are the abstract concept of a set of operations over unspecified data, not a specific set of concrete data types. A common misconception is that the specific examples of ADTs taught in many university courses and data structure textbooks are what ADTs are. Many such texts label the data structures “ADTs” and then skip the ADT and describe the data structures in concrete terms instead, without ever exposing the student to an actual abstract representation of the data type. **Oops!**

ADTs can express many useful algebraic structures, including semigroups, monoids, functors, monads, etc. The [Fantasyland Specification](https://github.com/fantasyland/fantasy-land) is a useful catalog of algebraic structures described by ADTs to encourage interoperable implementations in JavaScript. Library builders can verify their implementations using the supplied axioms.

## Why ADTs?

Abstract Data Types are useful because they provide a way for us to formally define reusable modules in a way that is mathematically sound, precise, and unambiguous. This allows us to share a common language to refer to an extensive vocabulary of useful software building blocks: Ideas that are useful to learn and carry with us as we move between domains, frameworks, and even programming languages.

## History of ADTs

In the 1960s and early 1970s, many programmers and computer science researchers were interested in the software crisis. As Edsger Dijkstra put it in his Turing award lecture:

> “The major cause of the software crisis is that the machines have become several orders of magnitude more powerful! To put it quite bluntly: as long as there were no machines, programming was no problem at all; when we had a few weak computers, programming became a mild problem, and now we have gigantic computers, programming has become an equally gigantic problem.”

The problem he refers to is that software is very complicated. A printed version of the Apollo lunar module and guidance system for NASA is about the height of a filing cabinet. That’s a lot of code. Imagine trying to read and understand every line of that.

Modern software is orders of magnitude more complicated. Facebook was roughly [62 million lines of code](https://www.informationisbeautiful.net/visualizations/million-lines-of-code/) in 2015. If you printed 50 lines per page, you’d fill 1.24 million pages. If you stacked those pages, you’d get about 1,800 pages per foot, or 688 feet. That’s taller than San Francisco’s [Millenium Tower](https://en.wikipedia.org/wiki/Millennium_Tower_(San_Francisco)), the tallest residential building in San Francisco at the time of this writing.

Managing software complexity is one of the primary challenges faced by virtually every software developer. In the 1960s and 1970s, they didn’t have the languages, patterns, or tools that we take for granted today. Things like linters, intellisense, and even static analysis tools were not invented yet.

Many software engineers noted that the hardware they built things on top of mostly worked. But software, more often than not, was complex, tangled, and brittle. Software was commonly:

* Over budget
* Late
* Buggy
* Missing requirements
* Difficult to maintain

If only you could think about software in modular pieces, you wouldn’t need to understand the whole system to understand how to make part of the system work. That principle of software design is known as locality. To get locality, you need **modules** that you can understand in isolation from the rest of the system. You should be able to describe a module unambiguously without over-specifying its implementation. That’s the problem that ADTs solve.

Stretching from the 1960s almost to the present day, advancing the state of software modularity was a core concern. It was with those problems in mind that people including Barbara Liskov (the same Liskov referenced in the Liskov Substitution Principle from the SOLID OO design principles), Alan Kay, Bertrand Meyer and other legends of computer science worked on describing and specifying various tools to enable modular software, including ADTs, object-oriented programming, and design by contract, respectively.

ADTs emerged from the work of Liskov and her students on [the CLU programming language](https://en.wikipedia.org/wiki/CLU_(programming_language)) between 1974 and 1975. They contributed significantly to the state of the art of software module specification — the language we use to describe the interfaces that allow software modules to interact. Formally provable interface compliance brings us significantly closer to software modularity and interoperability.

Liskov was awarded the Turing award for her work on data abstraction, fault tolerance, and distributed computing in 2008. ADTs played a significant role in that accomplishment, and today, virtually every university computer science course includes ADTs in the curriculum.

The software crisis was never entirely solved, and many of the problems described above should be familiar to any professional developer, but learning how to use tools like objects, modules, and ADTs certainly helps.

## Specifications for ADTs

Several criteria can be used to judge the fitness of an ADT specification. I call these criteria **FAMED**, but I only invented the mnemonic. The original criteria were published by Liskov and Zilles in their famous 1975 paper, [“Specification Techniques for Data Abstractions.”](http://csg.csail.mit.edu/CSGArchives/memos/Memo-117.pdf)

* **Formal.** Specifications must be formal. The meaning of each element in the specification must be defined in enough detail that the target audience should have a reasonably good chance of constructing a compliant implementation from the specification. It must be possible to implement an algebraic proof in code for each axiom in the specification.
* **Applicable.** ADTs should be widely applicable. An ADT should be generally reusable for many different concrete use-cases. An ADT which describes a particular implementation in a particular language in a particular part of the code is probably over-specifying things. Instead, ADTs are best suited to describe the behavior of common data structures, library components, modules, programming language features, etc. For example, an ADT describing stack operations, or an ADT describing the behavior of a promise.
* **Minimal.** ADT specifications should be minimal. The specification should include the interesting and widely applicable parts of the behavior and nothing more. Each behavior should be described precisely and unambiguously, but in as little specific or concrete detail as possible. Most ADT specifications should be provable using a handful of axioms.
* **Extensible.** ADTs should be extensible. A small change in a requirement should lead to only a small change in the specification.
* **Declarative.** Declarative specifications describe **what,** not **how.** ADTs should be described in terms of what things are, and relationship mappings between inputs and outputs, not the steps to create data structures or the specific steps each operation must carry out.

A good ADT should include:

* **Human readable description.** ADTs can be rather terse if they are not accompanied by some human readable description. The natural language description, combined with the algebraic definitions, can act as checks on each other to clear up any mistakes in the specification or ambiguity in the reader’s understanding of it.
* **Definitions.** Clearly define any terms used in the specification to avoid any ambiguity.
* **Abstract signatures.** Describe the expected inputs and outputs without linking them to concrete types or data structures.
* **Axioms.** Algebraic definitions of the axiom invariants used to prove that an implementation has satisfied the requirements of the specification.

## Stack ADT Example

A stack is a Last In, First Out (LIFO) pile of items which allows users to interact with the stack by pushing a new item to the top of the stack, or popping the most recently pushed item from the top of the stack.

Stacks are commonly used in parsing, sorting, and data collation algorithms.

## Definitions

* `a`: Any type
* `b`: Any type
* `item`: Any type
* `stack()`: an empty stack
* `stack(a)`: a stack of `a`
* `[item, stack]`: a pair of `item` and `stack`

## Abstract Signatures

#### Construction

The `stack` operation takes any number of items and returns a stack of those items. Typically, the abstract signature for a constructor is defined in terms of itself. Please don’t confuse this with a recursive function.

* stack(...items) => stack(...items)

#### Stack Operations (operations which return a stack)

* push(item, stack()) => stack(item)
* `pop(stack) => [item, stack]`

## Axioms

The stack axioms deal primarily with stack and item identity, the sequence of the stack items, and the behavior of pop when the stack is empty.

#### Identity

Pushing and popping have no side-effects. If you push to a stack and immediately pop from the same stack, the stack should be in the state it was before you pushed.

```
pop(push(a, stack())) = [a, stack()]
```

* Given: push `a` to the stack and immediately pop from the stack
* Should: return a pair of `a` and `stack()`.

#### Sequence

Popping from the stack should respect the sequence: Last In, First Out (LIFO).

```
pop(push(b, push(a, stack())) = [b, stack(a)]
```

* Given: push `a` to the stack, then push `b` to the stack, then pop from the stack
* Should: return a pair of `b` and `stack(a)`.

#### Empty

Popping from an empty stack results in an undefined item value. In concrete terms, this could be defined with a Maybe(item), Nothing, or Either. In JavaScript, it’s customary to use `undefined`. Popping from an empty stack should not change the stack.

```
pop(stack()) = [undefined, stack()]
```

* Given: pop from an empty stack
* Should: return a pair of undefined and `stack()`.

## Concrete Implementations

An abstract data type could have many concrete implementations, in different languages, libraries, frameworks, etc. Here is one implementation of the above stack ADT, using an encapsulated object, and pure functions over that object:

```
const stack = (...items) => ({
  push: item => stack(...items, item),
  pop: () => {
    // create a item list
    const newItems = [...items];

    // remove the last item from the list and
    // assign it to a variable
    const [item] = newItems.splice(-1);

    // return the pair
    return [item, stack(...newItems)];
  },
  // So we can compare stacks in our assert function
  toString: () => `stack(${ items.join(',') })`
});

const push = (item, stack) => stack.push(item);
const pop = stack => stack.pop();
```

And another that implements the stack operations in terms of pure functions over JavaScript’s existing `Array` type:

```
const stack = (...elements) => [...elements];

const push = (a, stack) => stack.concat([a]);

const pop = stack => {
  const newStack = stack.slice(0);
  const item = newStack.pop();
  return [item, newStack];
};
```

Both versions satisfy the following axiom proofs:

```
// A simple assert function which will display the results
// of the axiom tests, or throw a descriptive error if an
// implementation fails to satisfy an axiom.
const assert = ({given, should, actual, expected}) => {
  const stringify = value => Array.isArray(value) ?
    `[${ value.map(stringify).join(',') }]` :
    `${ value }`;

  const actualString = stringify(actual);
  const expectedString = stringify(expected);

  if (actualString === expectedString) {
    console.log(`OK:
      given: ${ given }
      should: ${ should }
      actual: ${ actualString }
      expected: ${ expectedString }
    `);
  } else {
    throw new Error(`NOT OK:
      given ${ given }
      should ${ should }
      actual: ${ actualString }
      expected: ${ expectedString }
    `);
  }
};

// Concrete values to pass to the functions:
const a = 'a';
const b = 'b';

// Proofs
assert({
  given: 'push `a` to the stack and immediately pop from the stack',
  should: 'return a pair of `a` and `stack()`',
  actual: pop(push(a, stack())),
  expected: [a, stack()]
})

assert({
  given: 'push `a` to the stack, then push `b` to the stack, then pop from the stack',
  should: 'return a pair of `b` and `stack(a)`.',
  actual: pop(push(b, push(a, stack()))),
  expected: [b, stack(a)]
});

assert({
  given: 'pop from an empty stack',
  should: 'return a pair of undefined, stack()',
  actual: pop(stack()),
  expected: [undefined, stack()]
});
```

## Conclusion

* **An Abstract Data Type (ADT)** is an abstract concept defined by axioms which represent some data and operations on that data.
* **Abstract Data Types are focused on what, not how** (they’re framed declaratively, and do not specify algorithms or data structures).
* **Common examples** include lists, stacks, sets, etc.
* **ADTs provide a way for us to formally define reusable modules** in a way that is mathematically sound, precise, and unambiguous.
* **ADTs emerged from the work of Liskov** and students on the CLU programming language in the 1970s.
* **ADTs should be FAMED.** Formal, widely Applicable, Minimal, Extensible, and Declarative.
* **ADTs should include** a human readable description, definitions, abstract signatures, and formally verifiable axioms.

> **Bonus tip:** If you’re not sure whether or not you should encapsulate a function, ask yourself if you would include it in an ADT for your component. Remember, ADTs should be minimal, so if it’s non-essential, lacks cohesion with the other operations, or its specification is likely to change, encapsulate it.

## Glossary

* **Axioms** are mathematically sound statements which must hold true.
* **Mathematically sound** means that each term is well defined mathematically so that it’s possible to write unambiguous and provable statements of fact based on them.

## Next Steps

[EricElliottJS.com](https://ericelliottjs.com/) features many hours of video lessons and interactive exercises on topics like this. If you like this content, please consider joining.

---

****Eric Elliott** is a tech product and platform advisor, author of [“Composing Software”](https://slack-redir.net/link?url=https%3A%2F%2Fleanpub.com%2Fcomposingsoftware), cofounder of [EricElliottJS.com](https://slack-redir.net/link?url=http%3A%2F%2FEricElliottJS.com) and [DevAnywhere.io](https://slack-redir.net/link?url=http%3A%2F%2FDevAnywhere.io), and dev team mentor. He has contributed to software experiences for **Adobe Systems, Zumba Fitness,** **The Wall Street Journal,** **ESPN,** **BBC,** and top recording artists including **Usher, Frank Ocean, Metallica,** and many more.**

**He enjoys a remote lifestyle with the most beautiful woman in the world.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
