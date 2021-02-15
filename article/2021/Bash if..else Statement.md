> * 原文地址：[Bash if..else Statement](https://linuxize.com/post/bash-if-else-statement/)
> * 原文作者：[linuxize](https://twitter.com/linuxize)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Bash%20if..else%20Statement.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Bash%20if..else%20Statement.md)
> * 译者：
> * 校对者：

# Bash if..else Statement
![https://linuxize.com/post/bash-if-else-statement/featured_hu91e1d6741dfcdbd79b4fecce3479ee44_25821_480x0_resize_q75_lanczos.jpg?ezimgfmt=ng%3Awebp%2Fngcb65%2Frs%3Adevice%2Frscb65-1](https://linuxize.com/post/bash-if-else-statement/featured_hu91e1d6741dfcdbd79b4fecce3479ee44_25821_480x0_resize_q75_lanczos.jpg?ezimgfmt=ng%3Awebp%2Fngcb65%2Frs%3Adevice%2Frscb65-1)

In this tutorial, we will walk you through the basics of the Bash `if` statement and show you how to use it in your shell scripts.

Decision making is one of the most fundamental concepts of computer programming. Like in any other programming language, `if`, `if..else`, `if..elif..else` and nested `if` statements in Bash can be used to execute code based on a certain condition.

## if Statement

Bash `if` conditionals can have different forms. The most basic `if` statement takes the following form:


```
if TEST-COMMAND
then
  STATEMENTS
fi
```

The `if` statement starts with the `if` keyword followed by the conditional expression and the `then` keyword. The statement ends with the `fi` keyword.

If the `TEST-COMMAND` evaluates to `True`, the `STATEMENTS` gets executed. If `TEST-COMMAND` returns `False`, nothing happens, the `STATEMENTS` gets ignored.

In general, it is a good practice to always indent your code and separate code blocks with blank lines. Most people choose to use either 4-space or 2-space indentation. Indentations and blank lines make your code more readable and organized.

Let’s look at the following example script that checks whether a given number is greater than 10:


```
#!/bin/bash

echo -n "Enter a number: "
read VAR

if [[ $VAR -gt 10 ]]
then
  echo "The variable is greater than 10."
fi
```
Save the code in a file and run it from the command line:

```
bash test.sh
```

The script will prompt you to enter a number. If, for example, you enter 15, the `test` command will evaluate to `true` because 15 is greater than 10, and the `[echo](https://linuxize.com/post/echo-command-in-linux-with-examples/)` command inside the `then` clause will be executed.

```
The variable is greater than 10.

```

## if..else` Statement

The Bash `if..else` statement takes the following form:


```
if TEST-COMMAND
then
  STATEMENTS1
else
  STATEMENTS2
fi
```
If the `TEST-COMMAND` evaluates to `True`, the `STATEMENTS1` will be executed. Otherwise, if `TEST-COMMAND` returns `False`, the `STATEMENTS2` will be executed. You can have only one `else` clause in the statement.

Let’s add an `else` clause to the previous example script:


```
#!/bin/bash

echo -n "Enter a number: "
read VAR

if [[ $VAR -gt 10 ]]
then
  echo "The variable is greater than 10."
else
  echo "The variable is equal or less than 10."
fi
```
If you run the code and enter a number, the script will print a different message based on whether the number is greater or less/equal to 10.

## if..elif..else Statement

The Bash `if..elif..else` statement takes the following form:


```
if TEST-COMMAND1
then
  STATEMENTS1
elif TEST-COMMAND2
then
  STATEMENTS2
else
  STATEMENTS3
fi
```
If the `TEST-COMMAND1` evaluates to `True`, the `STATEMENTS1` will be executed. If the `TEST-COMMAND2` evaluates to `True`, the `STATEMENTS2` will be executed. If none of the test commands evaluate to `True`, the `STATEMENTS2` is executed.

You can have one or more `elif` clauses in the statement. The `else` clause is optional.

The conditions are evaluated sequentially. Once a condition returns `True` the remaining conditions are not performed and program control moves to the end of the `if` statements.

Let’s add an `elif` clause to the previous script:

```
#!/bin/bash

echo -n "Enter a number: "
read VAR

if [[ $VAR -gt 10 ]]
then
  echo "The variable is greater than 10."
elif [[ $VAR -eq 10 ]]
then
  echo "The variable is equal to 10."
else
  echo "The variable is less than 10."
fi

```
## Nested if Statements

Bash allows you to nest `if` statements within `if` statements. You can place multiple `if` statement inside another `if` statement.

The following script will prompt you to enter three numbers and will print the largest number among the three numbers.

```
#!/bin/bash

echo -n "Enter the first number: "
read VAR1
echo -n "Enter the second number: "
read VAR2
echo -n "Enter the third number: "
read VAR3

if [[ $VAR1 -ge $VAR2 ]] && [[ $VAR1 -ge $VAR3 ]]
then
  echo "$VAR1 is the largest number."
elif [[ $VAR2 -ge $VAR1 ]] && [[ $VAR2 -ge $VAR3 ]]
then
  echo "$VAR2 is the largest number."
else
  echo "$VAR3 is the largest number."
fi
```
Here is how the output will look like:

```
Enter the first number: 4
Enter the second number: 7
Enter the third number: 2
7 is the largest number.

```

Generally, it is more efficient to use the `[case` statement](https://linuxize.com/post/bash-case-statement/) instead nested `if` statements.

## **Multiple Conditions**

The logical `OR` and `AND` operators allow you to use multiple conditions in the `if` statements.

Here is another version of the script to print the largest number among the three numbers. In this version, instead of the nested `if` statements, we’re using the logical `AND` (`&&`) operator.


```
#!/bin/bash

echo -n "Enter the first number: "
read VAR1
echo -n "Enter the second number: "
read VAR2
echo -n "Enter the third number: "
read VAR3

if [[ $VAR1 -ge $VAR2 ]] && [[ $VAR1 -ge $VAR3 ]]
then
  echo "$VAR1 is the largest number."
elif [[ $VAR2 -ge $VAR1 ]] && [[ $VAR2 -ge $VAR3 ]]
then
  echo "$VAR2 is the largest number."
else
  echo "$VAR3 is the largest number."
fi
```
## Test Operators

In Bash, the `test` command takes one of the following syntax forms:

`test EXPRESSION
[ EXPRESSION ]
[[ EXPRESSION ]]`

To make the script portable, prefer using the old test `[` command which is available on all POSIX shells. The new upgraded version of the `test` command `[[` (double brackets) is supported on most modern systems using Bash, Zsh, and Ksh as a default shell.

To negate the test expression, use the logical `NOT` (`!`) operator. When [comparing strings](https://linuxize.com/post/how-to-compare-strings-in-bash/) , always use single or double quotes to avoid word splitting and globbing issues.

Below are some of the most commonly used operators:

- `n` `VAR` - True if the length of `VAR` is greater than zero.
- `z` `VAR` - True if the `VAR` is empty.
- `STRING1 = STRING2` - True if `STRING1` and `STRING2` are equal.
- `STRING1 != STRING2` - True if `STRING1` and `STRING2` are not equal.
- `INTEGER1 -eq INTEGER2` - True if `INTEGER1` and `INTEGER2` are equal.
- `INTEGER1 -gt INTEGER2` - True if `INTEGER1` is greater than `INTEGER2`.
- `INTEGER1 -lt INTEGER2` - True if `INTEGER1` is less than `INTEGER2`.
- `INTEGER1 -ge INTEGER2` - True if `INTEGER1` is equal or greater than INTEGER2.
- `INTEGER1 -le INTEGER2` - True if `INTEGER1` is equal or less than `INTEGER2`.
- `h` `FILE` - True if the `FILE` exists and is a symbolic link.
- `r` `FILE` - True if the `FILE` exists and is readable.
- `w` `FILE` - True if the `FILE` exists and is writable.
- `x` `FILE` - True if the `FILE` exists and is executable.
- `d` `FILE` - True if the `FILE` exists and is a directory.
- `e` `FILE` - True if the `FILE` exists and is a file, regardless of type (node, directory, socket, etc.).
- `f` `FILE` - True [if the `FILE` exists](https://linuxize.com/post/bash-check-if-file-exists/) and is a regular file (not a directory or device).

## Conclusion

The `if`, `if..else` and `if..elif..else` statements allow you to control the flow of the Bash script’s execution by evaluating given conditions.

If you have any questions or feedback, feel free to leave a comment.