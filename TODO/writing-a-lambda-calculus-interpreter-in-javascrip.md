>* 原文链接 : [A 𝝺-CALCULUS INTERPRETER](http://tadeuzagallo.com/blog/writing-a-lambda-calculus-interpreter-in-javascript/)
* 原文作者 : [tadeuzagallo](http://tadeuzagallo.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [zhangzhaoqi](https://github.com/joddiy)
* 校对者: [jamweak](https://github.com/jamweak), [Zheaoli](https://github.com/Zheaoli)

# 用 Javascript 编写λ演算解释器

最近，[我在推特上对λ演算非常着迷](https://twitter.com/tadeuzagallo/status/742836038264098817)，它是如此简单和强大。

当然我之前听说过λ演算，但是直到我读了这本书 [Types and Programming Languages](https://www.cis.upenn.edu/~bcpierce/tapl) 我才真正了解了它的美丽之处。

有许多其他的编译器、剖析器、解释器的教程，但是它们大多不会指导你遍览语言的全部实现，因为编程语言的实现需要进行大量的工作，然而λ演算是如此简单以至于我们可以完全讲解。

首先，什么是λ演算？这里是一个 [Wikipedia](https://en.wikipedia.org/wiki/Lambda_calculus) 的描述：

> λ演算（英语：lambda calculus，λ-calculus）是一套在数学逻辑上针对表达式计算的形式系统，主要使用变量绑定和替换来研究函数定义、函数应用。它是一种计算的统一模型，可以被用来模拟任何单步图灵机。数学家 Alonzo Church 在20世纪30年代首次提出了这个概念作为基础数学的一个研究。

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
    LAMBDA: 'λ' // 为了方便我们也可以使用 '\'
    DOT: '.'
    LCID: /[a-z][a-zA-Z]*/ // LCID 代表了小写字母的标识符
                         // 例如：任何以小写字母开头的字符串

我们会有一个 `Token` 类，包含一个 `type` 属性（上面中的一个），和一个可选的 `value` 属性（例如，`LCID` 中的字符串）：.

      class Token {
      constructor(type, value) {
        this.type = type;
        this.value = value;
      }
    };

## 3\. Lexer（词法分析器）

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

好了，让我们继续聊聊 `Parser` ！

## 4\. Parser

Parser 基本上是语法的拷贝。我们基于产生式规则的名字（ `::=` 左边的部分）给每个产生式规则创建了一个方法， `::=` 右边则遵循以下规则：如果字母都是大写的，那么就是一个_终结符_（例如：一个 Token ），并且我们可以使用 Lexer 处理它；如果右边是一个（首字母）大写的单词，那么则是另一个产生式，因此我们可以给它调用方法。当我们看到一个 `|` （读作 `or`）时，我们需要决定去使用哪边，具体取决于哪边匹配 Token 。

语法中只有一个棘手的部分，手写的 Parser 通常是[递归下降](https://en.wikipedia.org/wiki/Recursive_descent_parser)（我们遇到过很多这样的情况），并且它们无法处理左递归。你可能注意到 `Application` 产生式的右边，在第一个位置包含了 `Application` 本身，所以我们只是遵循上一段提到的产生规则的话，当我们调用看到的所有产生式时将会导致无限递归。

幸运的是左递归可以用以下技巧去掉：

    Application ::= Atom Application'

    Application' ::= Atom Application'
                    | ε  # empty

### 4.1\. AST

在 Parser 之后，我们需要以某种方式存储信息，因此我们将创造一个 [抽象语法树(AST)](https://en.wikipedia.org/wiki/Abstract_syntax_tree)。λ演算的语法树非常简单，只需要三种节点：Abstraction 、 Application 和 Identifier 。

_Abstraction_ 包含 param 和 body 属性， _Application_ 包含左右两个部分， _Identifier_ 是一个左节点，仅仅包含它本身的字符串形式。

这里是 AST 的一个简单的程序：

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

### 4.2\. Parser 实现

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

## 5\. 求值

现在我们可以使用 AST 来求值了，但是为了知道解释器的具体细节，我们首先许需要关注一下λ演算的求值规则。

### 5.1\. 求值规则

首先我们需要定义什么是 Term （这可以从语法中猜测出来）以及什么是值。

Term 就是:

    t1 t2   # Application

    λx. t1  # Abstraction

    x       # Identifier

是的，这些跟 AST 中的节点很像，但是这些中的哪些是值？

值就是有着最终形态的 Term ，例如：它们不能再被求值了。这种情况下，唯一的 Term 同时也是值的是 Abstraction （除非它被调用，否则不会求值）。

实际的求值规则如下：



    1)       t1 -> t1'
         _________________

          t1 t2 -> t1' t2

    2)       t2 -> t2'
         ________________

          v1 t2 -> v1 t2'

    3)    (λx. t12) v2 -> [x -> v2]t12



这里是每条规则的介绍：

1.  如果 `t1` 是一个求 `t1'` 值的 Term ，`t1 t2` 就是求 `t1' t2` 的值，例如：Application 的左边会先求值。
2.  如果 `t2` 是一个求 `t2'` 值的 Term ，`v1 t2` 就是求 `v1 t2'` 的值，注意这里左边是 `v1` 而不是 `t1` 意味着它是一个值，不能再被求值了，例如：只有左边求值完之后才能给右边求值。
3.  Application `(λx. t12) v2` 的结果，和把 `t12` 中所有出现 `x` 的地方替换为 `v2` 的结果是等效的。注意在 Application 求值前两边都变成了值。

### 5.2\. 解释器

解释器是遵循求值规则把程序分解成值的部分。现在我们需要做的是把上面的规则翻译成 JavaScript ：

首先，我们将定义简单的助手方法来告诉我们什么时候节点是一个值：

<figure>

    const isValue = node => node instanceof AST.Abstraction;

</figure>

规则就是：如果是一个 Abstraction ，它就是一个值，否则就不是。

这里是解释器的一个片段 ：

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

这有一些复杂，但是如果你凝神细看的话，你能看到编码后的求值规则：

*   首先，我们检查它是否是 Application ，如果是，就可以求值。
    *   如果 Abstraction 两边都是值，我们可以简单地把所有出现 `x` 的地方替换为将要被使用的值；(3)
    *   另外，如果左边是值， 我们给 Application 的右边求值；(2)
    *   如果以上都没用到，那么我们给 Application 的左边求值；(1)
*   现在，如果下一个节点是 Identifier ，我们可以简单地用值来替代。
*   最后，如果没有规则适用 AST ，意味着它已经是一个值了，仅仅返回就行。

另一件值得注意的是 Context ， Context 包含了名称和值之间的绑定关系（ AST 节点），例如，当你调用一个方法时，你传入了方法所期望的变量，并且用方法的主体进行了求值。

克隆 Context 来确保一旦我们完成了右边的求值，限定的变量就会超出范围，因为我们仍然持有原始的 Context 。

如果我们不克隆 Context 的话，Application 的右边绑定就会泄漏，并且可以被左边获取，这本来是不应该的。考虑下面场景：


    (λx. y) ((λy. y) (λx. x))



这很明显是一个非法的程序：在 Abstraction 最左边使用的 Identifier `y` 没有限制。但是让我们来看看如果我们不克隆 Context 的话求得的值是什么样的：

左边已经是值了，所以我们给右边求值。它是一个 Application ，所以会绑定 `(λx .x)` 到 `y` ，并且给 `(λy. y)` 求值，其实就是 `y` 本身，所以也等价于 `(λx. x)` 。

这样就完成了右边，把它变成了值，并且 `y` 现在超出了范围，因为我们退出了 `(λy. y)` ，但是我们在求值的时候没有克隆 Context，并且绑定泄漏了，同时 `y` 将有值 `(λx. x)` ，这最终导致了错误的程序结果。

## 6\. 输出

现在我们基本做完了：我们已经可以把程序拆解为值，现在我们需要做的是用一种方式来表现值。

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

现在我们可以在结果的根节点上调用 `toString` 方法，这将以字符串形式递归输出所有孩子节点。

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

非常感谢阅读，并且期待反馈:D

