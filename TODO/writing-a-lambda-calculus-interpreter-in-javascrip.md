>* 原文链接 : [A 𝝺-CALCULUS INTERPRETER](http://tadeuzagallo.com/blog/writing-a-lambda-calculus-interpreter-in-javascript/)
* 原文作者 : [tadeuzagallo](http://tadeuzagallo.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [zhangzhaoqi](https://github.com/joddiy)
* 校对者:


最近，[我在推特上对λ演算非常着迷](https://twitter.com/tadeuzagallo/status/742836038264098817)，它是如此简单和强大。

当然我之前听说过λ演算，但是直到我读了这本书 [Types and Programming Languages](https://www.cis.upenn.edu/~bcpierce/tapl) 我才真正了解了它的美丽之处。

有许多其他的编译器、剖析器、解释器的教程，但是它们大多不会指导你遍览语言的全部实现，因为语言语义的实现包含了大量的工作，然而λ演算是如此简单以至于我们可以完全讲解。

首先，什么是λ演算？这里是一个 [Wikipedia](https://en.wikipedia.org/wiki/Lambda_calculus) 的描述：

> λ演算（英语：lambda calculus，λ-calculus）是一套在数学逻辑上针对表达式计算的形式系统，主要使用可变绑定和替换来研究函数定义、函数应用。它是一种计算的统一模型，可以被用来模拟任何单步图灵机。数学家 Alonzo Church 在20世纪30年代首次提出了这个概念作为基础数学的一个研究。

一个简单的λ演算程序如下：

      (λx. λy. x) (λy. y) (λx. x)    

在λ演算仅仅有两种构造：函数定义（例如：一个函数声明）和函数应用（例如：函数调用）。有了这两种构造之后你就可以做任何计算了。

## 1\. 语法

在介绍 Parser 之前，我们要做的第一件事情是了解一下所要 Parser 的语言的语法，这里是 [BNF](https://en.wikipedia.org/wiki/Backus–Naur_Form) ：

    Term ::= Application
            | LAMBDA LCID DOT Term

    Application ::= Application Atom
                   | Atom

    Atom ::= LPAREN Term RPAREN
            | LCID

语法告诉了我们如何在 Parser 阶段查找 Token ，但是 Token 又是什么呢？

## 2\. Token

你可能早已了解，Parser 并不在源码上操作。在 Parser 之前，源码会通过 `Lexer` 分词成 Token （就是在语法中全部大写的那些），这里是我们从上面语法中提取出的 Token ：

    LPAREN: '('
    RPAREN: ')'
    LAMBDA: 'λ' // we'll also allow using '\' for convenience
    DOT: '.'
    LCID: /[a-z][a-zA-Z]*/ // LCID stands for LowerCase IDentifier
                         // i.e. any string starting with a lowercase letter

我们会有一个 `Token` 类，包含一个 `type` 属性（上面中的一个），和一个可选的 `type` 属性（例如，`LCID` 中的字符串）：.

      class Token {
      constructor(type, value) {
        this.type = type;
        this.value = value;
      }
    };

## 3\. Lexer

现在我们可以使用上面定义的 Token 来写一个 `Lexer` ，以此为 Parser 处理程序提供一个良好的 _API_ 。

Lexer 中 Token 的构造部分不是很有趣：只是一个很大的 switch 语句来检查源码中下一个字符：

    _nextToken() {
      switch (c) {
        case 'λ':
        case '\\':
          this._token = new Token(Token.LAMBDA);
          break;

        case '.':
          this._token = new Token(Token.DOT);
          break;

        case '(':
          this._token = new Token(Token.LPAREN);
          break;

        /* ... */
      }
    }

这里是处理 Token 的一些助手方法：

*   `next(Token)`：返回是否下一个 Token 匹配 `Token`；
*   `skip(Token)`：和 `next` 相同, 但是如果匹配则跳过；
*   `match(Token)`：断言 `next` 是 true, 并且 `skip`；
*   `token(Token)`：断言 `next` 是 true, 并且将其返回。

好了，现在继续进行 `Parser`！

## 4\. Parser

Parser 是。我们
The parser is basically a copy of the grammar. We create one method for each production rule, based on its name (in the left-hand side of the `::=`) and follow the right-hand side: If it’s an all caps word, it means it’s a _terminal_ (i.e. a token), and we consume it from the lexer. If it’s a capitalised word, it’s another production, so we call the method for it. When we find an `|` (reads `or`) we have to decide which side to use, we’ll do that based which of the sides match the tokens we have.

There’s only one tricky bit about this grammar: hand written parsers are usually [recursive descent](https://en.wikipedia.org/wiki/Recursive_descent_parser) (ours will be), and they can’t handle left recursion. You might have noticed that the right-hand side of the `Application` production, contains `Application` itself in the first position, so if we just follow the procedure described in the previous paragraph, where we call all the productions we find, we’ll have an infinite recursion.

Luckily left recursions can be removed with one simple trick:

    Application ::= Atom Application'

    Application' ::= Atom Application'
                    | ε  # empty

### 4.1\. AST

在 Parser 之后，我们需要以某种方式存储信息，因此我们将创造一个 [抽象语法树(AST)](https://en.wikipedia.org/wiki/Abstract_syntax_tree)。λ演算的语法树非常简单，只需要三种节点：Abstraction 、 Application 和 Identifier 。

_Abstraction_ 包含 param 和 body 属性， _Application_ holds the left- and right-hand side of the application and the _Identifier_ is a leaf node, that only holds the string representation of the identifier itself.

这里是 AST 简单的一个简单的程序：

    (λx. x) (λy. y)

    Application {
      abstraction: Abstraction {
        param: Identifier { name: 'x' },
        body: Identifier { name: 'x' }
      },
      value: Abstraction {
        param: Identifier { name: 'y' },
        body: Identifier { name: 'y' }
      }
    } 

### 4.2\. Parser implementation

现在我们有了 AST 节点，我们可以用它们去构建实际的树。这里是语法中基于产品规则的 Parser 方法。

    term() {
      // Term ::= LAMBDA LCID DOT Term
      //        | Application
      if (this.lexer.skip(Token.LAMBDA)) {
        const id = new AST.Identifier(this.lexer.token(Token.LCID).value);
        this.lexer.match(Token.DOT);
        const term = this.term();
        return new AST.Abstraction(id, term);
      }  else {
        return this.application();
      }
    }

    application() {
      // Application ::= Atom Application'
      let lhs = this.atom();
      while (true) {
        // Application' ::= Atom Application'
        //                | ε
        const rhs = this.atom();
        if (!rhs) {
          return lhs;
        } else {
          lhs = new AST.Application(lhs, rhs);
        }
      }
    }

    atom() {
      // Atom ::= LPAREN Term RPAREN
      //        | LCID
      if (this.lexer.skip(Token.LPAREN)) {
        const term = this.term(Token.RPAREN);
        this.lexer.match(Token.RPAREN);
        return term;
      } else if (this.lexer.next(Token.LCID)) {
        const id = new AST.Identifier(this.lexer.token(Token.LCID).value);
        return id;
      } else {
        return undefined;
      }
    }

## 5\. 评估

现在我们可以使用 AST 来评估程序，但是为了知道解释器长什么样子，我们首先许需要关注一下λ演算的评估规则。

### 5.1\. 评估规则

首先我们需要定义
First we need to define what are our terms (which can be inferred from the grammar) and what are our values.

Our terms are:

    t1 t2   # Application

    λx. t1  # Abstraction

    x       # Identifier

是的，这些跟 AST 中的节点很像，但是这些中的哪些是值？

Values are terms that are in its final form, i.e. they can’t be evaluated any further. In this case, the only terms that are also values are abstractions (you can’t evaluated a function unless it’s called).

实际的评估规则如下：



    1)       t1 -> t1'
         _________________

          t1 t2 -> t1' t2

    2)       t2 -> t2'
         ________________

          v1 t2 -> v1 t2'

    3)    (λx. t12) v2 -> [x -> v2]t12



Here’s how we can read each rule:

1.  If `t1` is a term that evaluates to `t1'`, `t1 t2` will evaluate to `t1' t2`. i.e. the left-hand side of an application is evaluated first.
2.  If `t2` is a term that evaluates to `t2'`, `v1 t2` will evaluate to `v1 t2'`. Notice that here the left-hand side is `v1` instead of `t1`, that means that it’s a value, and can’t be evaluated any further, i.e. only when we’re done with the left-hand side we’ll evaluate the right one.
3.  The result of application `(λx. t12) v2` is the same as effectively replacing all occurrences of `x` in `t12` with `v2`. Notice that both sides have to be values before evaluating an application.

### 5.2\. 解释器

解释器是遵循评估规则把程序分解成值的部分。现在我们需要做的是把上面的规则翻译成 JavaScript ：

首先，我们将定义简单的助手方法来告诉我们什么时候 node 是一个值：

<figure>

    const isValue = node => node instanceof AST.Abstraction;

</figure>

规则就是：如果是一个 Abstraction ，它就是一个值，否则就不是。

这里是解释器的一个片段
And here’s the bit of the interpreter that matters:

    const eval = (ast, context={}) => {
      while (true) {
        if (ast instanceof AST.Application) {
          if (isValue(ast.lhs) && isValue(ast.rhs)) {
            context[ast.lhs.param.name] = ast.rhs;
            ast = eval(ast.lhs.body, context);
          } else if (isValue(ast.lhs)) {
            ast.rhs = eval(ast.rhs, Object.assign({}, context));
          } else {
            ast.lhs = eval(ast.lhs, context);
          }
        } else if (ast instanceof AST.Identifier) {
           ast = context[ast.name];
        } else {
          return ast;
        }
      }
    };

It’s a little bit dense, but if you squeeze your eyes really hard, you can see the encoded evaluation rules:

*   First we check if it’s an application: if it is, we can evaluate it.
    *   If both sides of the abstraction are values, we can simple replace all the ocurrences of `x` with the value being applied; (3)
    *   Otherwise, if the left-hand side is value, we evaluate right-hand side of the application; (2)
    *   If none of the above applies, we just evaluate the left-hand side of the application. (1)
*   Now, if the next node is an identifier, we simply replace it with the value bound to the variable it represents.
*   Lastly, if no rules applies to the AST, that means that it’s already a value, and then we return it.

The other thing worth noting is the context. The context holds the bindings from names to values (AST nodes), e.g. when you call a function, you’re binding the argument you’re passing to the variable that the function expects, and then evaluating the function’s body.

Cloning the context ensures that once we have finished evaluating the right-hand side, and the variables that were bound will go out of scope, since we’re still holding onto the original context.

If we didn’t clone the context a binding introduced in the right-hand side of an application could leak, and be accessible in the left-hand side, which it shouldn’t. Consider the following:



    (λx. y) ((λy. y) (λx. x))



This is clearly an invalid program: the identifier `y`, used in the body of the left-most abstraction, is unbound. But let’s look at what the evaluation would look like if we didn’t clone the context:

The left-hand side is already a value, so we evaluate the right-hand side. It’s an application, so it’ll bind `(λx .x)` to `y`, and evaluate the body of `(λy. y)`, which is `y` itself, so it’ll just evaluate to `(λx. x)`.

At this point we’re finished with the right-hand side, as it’s a value, and `y` has now gone out of scope, since we exited `(λy. y)`, but if we didn’t clone the context when evaluating it, we’d have mutated the original context, and the binding would leak, and `y` would have value `(λx. x)`, which would end up being, erroneously, the result of the program.

## 6\. 输出

现在我们基本做完了：我们已经可以把程序拆解为值，现在我们需要做的事用一种方式来表现值。

一种简单的方式是在每个 AST 节点上都加上 `toString` 方法：

    /* Abstraction */ toString() {
      return `(λ${this.param.toString()}. ${this.body.toString()})`;
    }

    /* Application */ toString() {
      return `${this.lhs.toString()} ${this.rhs.toString()}`;
    }

    /* Identifier */ toString() {
      return this.name;
    }

现在我们可以在结果的根节点上调用 `toString` 方法，这将递归输出所有孩子节点以此来输出字符串形式。

## 7\. 整合

我们需要一个运行脚本把所有部分整合起来，代码应该像下面这样：

    // 假设你有一些代码
    const source = '(λx. λy. x) (λx. x) (λy. y)';

    // 把所有片段放在一起
    const lexer = new Lexer(source);
    const parser = new Parser(lexer);
    const ast = parser.parse();
    const result = Interpreter.eval(ast);

    // 字符串化结果节点并输出
    console.log(result.toString());

## 源码

所有的实现都能在 Github 找到：[github.com/tadeuzagallo/lc-js](https://github.com/tadeuzagallo/lc-js)

#### 结束语

非常感谢阅读，并且期待反馈 😊

