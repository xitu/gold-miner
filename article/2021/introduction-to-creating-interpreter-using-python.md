> * 原文地址：[I Used Python to Create My Own Programming Language](https://python.plainenglish.io/introduction-to-creating-interpreter-using-python-c2a9a6820aa0)
> * 原文作者：[Umangshrestha](https://medium.com/@umangshrestha09)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/introduction-to-creating-interpreter-using-python.md](https://github.com/xitu/gold-miner/blob/master/article/2021/introduction-to-creating-interpreter-using-python.md)
> * 译者：
> * 校对者：

# I Used Python to Create My Own Programming Language

#### How to Create a Language Interpreter with Python

#### How to create a programming language with Python

Computers only understand machine code. At the end of the day programming languages are just words that make it’s easier for humans to write what they want computers to do. The real magic is done by compilers and interpreters to bridge the gap. Interpreter reads the code line by line and convert it to machine code. In this article, we will design interpreter that can perform arithmetic operation. We are not going to reinvent the wheel. I will be using the popular PLY ( [Python Lex-Yacc](https://github.com/dabeaz/ply)) by David M. Beazley in this tutorial. Download it using:

```
$ pip install ply
```

We will just gloss over the surface to understand the basics of how to create interpreter. For better information kindly refer to the GitHub repo [here](https://github.com/dabeaz/ply).

![basic representation of interpreter](https://cdn-images-1.medium.com/max/2000/1*fnh2Q_e0lHe8zgqpPPEyRQ.png)

---

## Token

`**Token**` is the smallest units of characters that gives meaningful information to interpreter. Token contains the pair containing token name and attribute value.

Let’s start by creating list of token names. It is a compulsory step.

```Python
tokens = (
    # data types
    "NUM",
    "FLOAT",
    # athemetic operations
    "PLUS",
    "MINUS",
    "MUL",
    "DIV",
    # brackets
    "LPAREN",
    "RPAREN",
)
```

---

## Lexer

The process of converting the statement to the token is called `Tokenization` or `**Lexing**`. The program that does `Tokenizer` is `**Lexer**`.

```Python
# regular expression for the tokens
t_PLUS    =  r"\+"
t_MINUS   =  r"\-"
t_MUL     =  r"\*"
t_DIV     =  r"/"
t_LPAREN  =  r"\("
t_RPAREN  =  r"\)"
# spaces and tabs will be ignored
t_ignore  =  r" \t"

# adding rules with actions
def t_FLOAT(t):
    r"\d+\.\d+"
    t.value = float(t.value)
    return t

def t_NUM(t):
    r"\d+"
    t.value = int(t.value)
    return t

# error handling for charectors for whom rules are not defined
def t_error(t):
    # the t.value here contains rest of the input that has not been tokenized
    print(f"keyword not found: {t.value[0]}\nline {t.lineno}")
    t.lexer.skip(1)

# incase \n is seen then make it a new line
def t_newline(t):
    r"\n+"
    t.lexer.lineno += t.value.count("\n")
```

To import the lexer, we will using:

`**import ply.lex as lex**`

The `t_` is a special prefix indicating the rules for defining the token. Each lexing rules are made with the regular expression compact able with `[re](https://umangshrestha09.medium.com/list/regex-423b3a281bcc)` module in python. Regular expressions have the ability to scan the pattern based on rules to search for finite strings of symbols. The grammar defined by regular expressions is known as **regular grammar**. The language defined by regular grammar is known as **regular language**.

Now that rules are defined we will build the lexer.

```
data = 'a = 2 +(10 -8)/1.0'

lexer = lex.lex()
lexer.input(data)

while tok := lexer.token():
    print(tok)
```

To pass the input string we use **`lexer.input(data)`.` lexer.token()`** returns next instance of **`LexToken`** and **`None`** at end. Based on the above rules, the tokens for the code` 2 + ( 10 -8)/1.0` will be

![](https://cdn-images-1.medium.com/max/2000/1*59uivI84Mhe-UjeeGs1xoQ.jpeg)

The blue color is the statement, purple color represents then token name.

---

## Backus-Naur Form (BNF)

Most programming languages can be written by `context-free languages`. It is more complex that regular languages. For `context free language` we use `context free grammar` which is the set of rules to describe all the possible syntax in the language. BNF is the way of defining syntax that describes the grammar of programming language. With that out of the way. Lets see the example:

symbol := alternative1| alternative2 …

Based on the production rule the left hand side of `**:=**` is replaced by value one of the alternative in right hand side which are separated by `**|**`. For the calculator interpreter I am using grammar specification like:

```
expression expression : expression '+' factor
                      | expression '-' factor
                      | expression '/' factor
                      | expression '*' factor
                      | expression '^' factor
                      | -expression
                      | factor

factor     : NUM
           | float
           | ( expression )
```

The input tokens are symbols such as `Num, Float, +, — , *, /. `are `**terminals**`. It consists of collection of terminals and rules such as term and factor **`non-terminals`.** For more information on BNF refer [here](https://isaaccomputerscience.org/concepts/dsa_toc_bnf).

---

## Parser

We will be using `**YACC**` (`Yet another compiler-compiler`) as parser generator. To use it we will use `**import ply.yacc as yacc**`.

```Python

from operator import (add,  sub, mul, truediv, pow) 


# list of operators supported by our interpetor
ops = {
    '+' : add,
    '-' : sub,
    '*' : mul,
    '/' : truediv,   
    '^' : pow,  
}

def p_expression(p):
    """expression : expression PLUS factor
                | expression MINUS factor
                | expression DIV factor
                | expression MUL factor
                | expression POW factor"""
    if (p[2], p[3]) == ("/",  0):
        # if  division is by 0 puttinf 'inf' as value 
        p[0] = float('INF')
    else:  
        p[0] = ops[p[2]](p[1], p[3])

def p_expression_uminus(p):
    "expression : MINUS expression %prec UMINUS"
    p[0] = -p[2]

def p_expression_factor(p):
    'expression : factor'
    p[0] = p[1]

def p_factor_num(p):
    """factor : NUM
            | FLOAT"""
    p[0] = p[1]

def p_factor_expr(p):
    'factor : LPAREN expression RPAREN'
    p[0] = p[2]

# Error rule for syntax errors
def p_error(p):
    print(f"Syntax error in {p.value}")
```

In the doc string we will add appropriate grammar specification. The `p` values are mapped to grammatical symbols as shown below:

```
expression: expression PLUS  expression
p[0]         p[1]       p[2]  p[3]
```

Then we can add the rule based on expression. Yacc allows individual tokens to be assigned precedence level. We can set it using:

```
precedence = (
    ('left', 'PLUS', 'MINUS'),
    ('left', 'MUL', 'DIV'),
)
```

`PLUS` and `MINUS` have the same precedence level and have left associativity. The `MUL` and `DIV` have higher precedence that `PLUS` and `MINUS`.

To parse the code we will use:

```
parser = yacc.yacc()
result = parser.parse(data)
print(result)
```

The full code is here:

```Python
#####################################
# Imports                           #
#####################################
from operator import (add,  sub, mul, truediv, pow) 
import ply.yacc as yacc
import ply.lex as lex
from logging import (basicConfig, INFO, getLogger)

# list of operators supported by our interpetor
ops = {
    '+' : add,
    '-' : sub,
    '*' : mul,
    '/' : truediv,   
    '^' : pow,  
}
#####################################
# List of tokens                    #
#####################################
tokens = (
    # data types
    "NUM",
    "FLOAT",    
    # athemetic operations   
    "PLUS",
    "MINUS",
    "MUL",
    "DIV",
    "POW",
    # brackets
    "LPAREN",
    "RPAREN",
)
#####################################
# Regular expression for the tokens #
#####################################
t_PLUS    =  r"\+"
t_MINUS   =  r"\-"
t_MUL     =  r"\*"
t_DIV     =  r"/"
t_LPAREN  =  r"\("
t_RPAREN  =  r"\)"
t_POW     =  r"\^"
# spaces and tabs will be ignored
t_ignore  =  r" \t"

# adding rules with actions
def t_FLOAT(t):
    r"\d+\.\d+"
    t.value = float(t.value)
    return t

def t_NUM(t):
    r"\d+"
    t.value = int(t.value)
    return t

def t_error(t):
    print(f"keyword not found: {t.value[0]}\nline {t.lineno}")
    t.lexer.skip(1)

def t_newline(t):
    r"\n+"
    t.lexer.lineno += t.value.count("\n")

#####################################
# Setting precedence of symbols     #
#####################################
precedence = (
    ('left', 'PLUS', 'MINUS'),
    ('left', 'MUL', 'DIV'),
    ('right', 'UMINUS'),
)
#####################################
# Writing BNF rule                  #
#####################################
def p_expression(p):
    """expression : expression PLUS factor
                | expression MINUS factor
                | expression DIV factor
                | expression MUL factor
                | expression POW factor"""
    if (p[2], p[3]) == ("/",  0):
        # if  division is by 0 puttinf 'inf' as value 
        p[0] = float('INF')
    else:  
        p[0] = ops[p[2]](p[1], p[3])

def p_expression_uminus(p):
    "expression : MINUS expression %prec UMINUS"
    p[0] = -p[2]

def p_expression_factor(p):
    'expression : factor'
    p[0] = p[1]

def p_factor_num(p):
    """factor : NUM
            | FLOAT"""
    p[0] = p[1]

def p_factor_expr(p):
    'factor : LPAREN expression RPAREN'
    p[0] = p[2]

# Error rule for syntax errors
def p_error(p):
    print(f"Syntax error in {p.value}")

#####################################
# Main                              #
#####################################
if __name__ == "__main__":
    basicConfig(level=INFO, filename="logs.txt")

    lexer = lex.lex()
    parser = yacc.yacc()

    while 1:
        try:
            result = parser.parse(
                input(">>>"), 
                debug=getLogger())
            print(result)
        except AttributeError:
            print("invalid syntax")


```

## Conclusion

Due to sheer volume of the topic, it is not possible to explain properly in such a small article. But I hope you understood the surface level knowledge well. I will write other articles on it soon. Thank you. Have a good day.

**More content at[** plainenglish.io**](http://plainenglish.io)**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
