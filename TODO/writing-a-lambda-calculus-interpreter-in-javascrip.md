>* 原文链接 : [A 𝝺-CALCULUS INTERPRETER](http://tadeuzagallo.com/blog/writing-a-lambda-calculus-interpreter-in-javascript/)
* 原文作者 : [tadeuzagallo](http://tadeuzagallo.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


Recently [I tweeted about falling in love with Lambda Calculus](https://twitter.com/tadeuzagallo/status/742836038264098817), and how simple and powerful it is.

Of course I had heard of λ-calculus before, but it wasn’t until I read the book [Types and Programming Languages](https://www.cis.upenn.edu/~bcpierce/tapl) that I could really see the beauty in it.

There are many compiler/parser/interpreter tutorials out there, but most won’t guide you through the complete implementation of a language, since implementing full language semantics is usually lot of work, but in this case, λ-calculus is so simple that we can cover it all!

First of all, what is λ-calculus? Here’s the [Wikipedia](https://en.wikipedia.org/wiki/Lambda_calculus) description:

> Lambda calculus (also written as λ-calculus) is a formal system in mathematical logic for expressing computation based on function abstraction and application using variable binding and substitution. It is a universal model of computation that can be used to simulate any single-taped Turing machine and was first introduced by mathematician Alonzo Church in the 1930s as part of an investigation into the foundations of mathematics.

And here’s what a very simple λ-calculus program looks like:

      (λx. λy. x) (λy. y) (λx. x)    

You only have two constructions in λ-calculus: Function abstractions (i.e. a function declaration) and applications (i.e. function calls), and yet, you can do any computation with it!

## 1\. Grammar

Before writing a parser, the first thing we need to know is what is the grammar for the language we’ll be parsing, here’s the [BNF](https://en.wikipedia.org/wiki/Backus–Naur_Form):

    Term ::= Application
            | LAMBDA LCID DOT Term

    Application ::= Application Atom
                   | Atom

    Atom ::= LPAREN Term RPAREN
            | LCID

The grammar tells us how to look for tokens during parsing. But wait, what are tokens?

## 2\. Tokens

As you might already know, the parser doesn’t operate on source code. Before parsing we run the source code through the `Lexer`, which will break the source code into tokens (which are the ones in all caps in the grammar). Here are the tokens we can extract from the grammar above:

    LPAREN: '('
    RPAREN: ')'
    LAMBDA: 'λ' // we'll also allow using '\' for convenience
    DOT: '.'
    LCID: /[a-z][a-zA-Z]*/ // LCID stands for LowerCase IDentifier
                         // i.e. any string starting with a lowercase letter

We’ll have a `Token` class, that can hold a `type` (one of the above) and an optional value (e.g. for the string in `LCID`).

      class Token {
      constructor(type, value) {
        this.type = type;
        this.value = value;
      }
    };

## 3\. Lexer

Now we can use the tokens defined above to write a `Lexer`, providing a nice _API_ for the parser to consume the program.

The token creation part of the Lexer is not very exciting: it’s one big switch statement that checks the next char in the source code:

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

And here are the helper methods, to consume the tokens:

*   `next(Token)`: returns whether the next token matches `Token`;
*   `skip(Token)`: same as `next`, but skips the token if it matches;
*   `match(Token)`: assert that `next` is true, and `skip`;
*   `token(Token)`: assert that `next` is true, and return the token.

Okay, now, to the `Parser`!

## 4\. Parser

The parser is basically a copy of the grammar. We create one method for each production rule, based on its name (in the left-hand side of the `::=`) and follow the right-hand side: If it’s an all caps word, it means it’s a _terminal_ (i.e. a token), and we consume it from the lexer. If it’s a capitalised word, it’s another production, so we call the method for it. When we find an `|` (reads `or`) we have to decide which side to use, we’ll do that based which of the sides match the tokens we have.

There’s only one tricky bit about this grammar: hand written parsers are usually [recursive descent](https://en.wikipedia.org/wiki/Recursive_descent_parser) (ours will be), and they can’t handle left recursion. You might have noticed that the right-hand side of the `Application` production, contains `Application` itself in the first position, so if we just follow the procedure described in the previous paragraph, where we call all the productions we find, we’ll have an infinite recursion.

Luckily left recursions can be removed with one simple trick:

    Application ::= Atom Application'

    Application' ::= Atom Application'
                    | ε  # empty

### 4.1\. AST

As we parse, we need to store the parsed information somehow, and for that we’ll create an [Abstract Syntax Tree (AST)](https://en.wikipedia.org/wiki/Abstract_syntax_tree). The tree for the λ-calculus is really simple, as we can only have 3 kinds of nodes: Abstraction, Application and Identifier.

The _Abstraction_ holds its parameter and its body, the _Application_ holds the left- and right-hand side of the application and the _Identifier_ is a leaf node, that only holds the string representation of the identifier itself.

Here’s a simple program with its AST:

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

Now the we have our AST nodes, we can use them to construct the actual tree. Here are the parsing methods based on the production rules in the grammar.

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

## 5\. Evaluation

Now that we have our AST, we can use it to evaluate the program, but in order to know what should our interpreter look like, we first need to look at λ-calculus’ evaluation rules.

### 5.1\. Evaluation rules

First we need to define what are our terms (which can be inferred from the grammar) and what are our values.

Our terms are:

    t1 t2   # Application

    λx. t1  # Abstraction

    x       # Identifier

Yes, these are exactly the same as the nodes from our AST! But which of these are values?

Values are terms that are in its final form, i.e. they can’t be evaluated any further. In this case, the only terms that are also values are abstractions (you can’t evaluated a function unless it’s called).

The actual evaluation rules are as following:



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

### 5.2\. Interpreter

The interpreter is the piece that follows the evaluation rules to reduce a program to a value. All we have to now is translate the rules above into JavaScript:

First we’ll define a simple helper to tell us when a node is a value:

<figure>

    const isValue = node => node instanceof AST.Abstraction;

</figure>

That’s it: if it’s an abstraction, it’s value, otherwise, it’s not.

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

## 6\. Printing

Ok, now we are almost done: we can already reduce a program to a value, all we need to do now is to find a way to present this value.

An easy way of doing that is by adding a `toString` method to every AST node:

    /* Abstraction */ toString() {
      return `(λ${this.param.toString()}. ${this.body.toString()})`;
    }

    /* Application */ toString() {
      return `${this.lhs.toString()} ${this.rhs.toString()}`;
    }

    /* Identifier */ toString() {
      return this.name;
    }

Now we can just call `toString` in the root node of the result, and it’ll print all of its children recursively in order to generate its string representation.

## 7\. Putting it all together

We’ll need a runner script that will wire all this parts together, the code should be something like:

    // assuming you have some source
    const source = '(λx. λy. x) (λx. x) (λy. y)';

    // wire all the pieces together
    const lexer = new Lexer(source);
    const parser = new Parser(lexer);
    const ast = parser.parse();
    const result = Interpreter.eval(ast);

    // stringify the resulting node and print it
    console.log(result.toString());

## Source code

The full implementation can be found on Github: [github.com/tadeuzagallo/lc-js](https://github.com/tadeuzagallo/lc-js)

#### That’s all!

Thanks for reading, and as usual, any feedback is more than welcome! 😊

