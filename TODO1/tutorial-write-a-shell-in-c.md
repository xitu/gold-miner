> * 原文地址：[Tutorial - Write a Shell in C](https://brennan.io/2015/01/16/write-a-shell-in-c/)
> * 原文作者：[Stephen Brennan](https://brennan.io)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/tutorial-write-a-shell-in-c.md](https://github.com/xitu/gold-miner/blob/master/TODO1/tutorial-write-a-shell-in-c.md)
> * 译者：[nettee](https://github.com/nettee)
> * 校对者：[kasheemlew](https://github.com/kasheemlew)，[JackEggie](https://github.com/JackEggie)

# 教程 - 用 C 写一个 Shell

你很容易认为自己“不是一个**真正的**程序员”。有一些程序所有人都用，它们的开发者很容易被捧上神坛。虽然开发大型软件项目并不容易，但很多时候这种软件的基本思想都很简单。自己实现这样的软件是一种证明自己可以是真正的程序员的有趣方式。所以，这篇文章介绍了我是如何用 C 语言写一个自己的简易 Unix shell 的。我希望其他人也能感受到这种有趣的方式。

这篇文章中介绍的 shell（叫做 `lsh`），可以在 [GitHub](https://github.com/brenns10/lsh) 上获取它的源代码。

**学校里的学生请注意！** 许多课程都有要求你编写一个 shell 的作业，而且有些教师都知道这样的教程和代码。如果你是此类课程上的学生，请不要在未经允许的情况下复制（或复制加修改）这里的代码。我[建议](https://brennan.io/2016/03/29/dishonesty/)反对重度依赖本教程的行为。

### Shell 的基本生命周期

让我们自顶向下地观察一个 shell。一个 shell 在它的生命周期中主要做三件事。

*   **初始化**：在这一步中，shell 一般会加载并执行它的配置文件。这些配置会改变 shell 的行为。
*   **解释执行**：接着，shell 会从标准输入（可能是交互式输入，也可能是一个文件）读取命令，并执行这些命令。
*   **终止**：当命令全部执行完毕，shell 会执行关闭命令，释放所有内存，然后终止。

这三个步骤过于宽泛，其实可以适用于任何程序，但我们可以将其用于我们的 shell 的基础。我们的 shell 会很简单，不需要任何配置文件，也没有任何关闭命令。那么，我们只需要调用循环函数，然后终止。不过对于架构而言，我们需要记住，程序的生命周期并不仅仅是循环。

```C
int main(int argc, char **argv)
{
  // 如果有配置文件，则加载。

  // 运行命令循环
  lsh_loop();

  // 做一些关闭和清理工作。

  return EXIT_SUCCESS;
}
```

这里你可以看到，我只是写了一个函数：`lsh_loop()`。这个函数会循环，并解释执行一条条命令。我们接下来会看到这个循环如何实现。

### Shell 的基本循环

我们已经知道了 shell 程序如何启动。现在考虑程序的基本逻辑：shell 在它的循环中会做什么？处理命令的一个简单的方式是采用这三步：

*   **读取**：从标准输入读取一个命令。
*   **分析**：将命令字符串分割为程序名和参数。
*   **执行**：运行分析后的命令。

下面，我将这些思路转化为 `lsh_loop()` 的代码：

```C
void lsh_loop(void)
{
  char *line;
  char **args;
  int status;

  do {
    printf("> ");
    line = lsh_read_line();
    args = lsh_split_line(line);
    status = lsh_execute(args);

    free(line);
    free(args);
  } while (status);
}
```

让我们看一遍这段代码。一开始的几行只是一些声明。Do-while 循环在检查状态变量时会更方便，因为它会在检查变量的值之前先执行一次。在循环内部，我们打印了一个提示符，调用函数来分别读取一行输入、将一行分割为参数，以及执行这些参数。最后，我们释放之前为 line 和 args 申请的内存空间。注意到我们使用 `lsh_execute()` 返回的状态变量决定何时退出循环。

### 读取一行输入

从标准输入读取一行听起来很简单，但用 C 语言做起来可能有一定难度。坏消息是，你没法预先知道用户会在 shell 中键入多长的文本。因此你不能简单地分配一块空间，希望能装得下用户的输入，而应该先暂时分配一定长度的空间，当确实装不下用户的输入时，再重新分配更多的空间。这是 C 语言中的一个常见策略，我们也会用这个方法来实现 `lsh_read_line()`。

```C
#define LSH_RL_BUFSIZE 1024
char *lsh_read_line(void)
{
  int bufsize = LSH_RL_BUFSIZE;
  int position = 0;
  char *buffer = malloc(sizeof(char) * bufsize);
  int c;

  if (!buffer) {
    fprintf(stderr, "lsh: allocation error\n");
    exit(EXIT_FAILURE);
  }

  while (1) {
    // 读一个字符
    c = getchar();

    // 如果我们到达了 EOF, 就将其替换为 '\0' 并返回。
    if (c == EOF || c == '\n') {
      buffer[position] = '\0';
      return buffer;
    } else {
      buffer[position] = c;
    }
    position++;

    // 如果我们超出了 buffer 的大小，则重新分配。
    if (position >= bufsize) {
      bufsize += LSH_RL_BUFSIZE;
      buffer = realloc(buffer, bufsize);
      if (!buffer) {
        fprintf(stderr, "lsh: allocation error\n");
        exit(EXIT_FAILURE);
      }
    }
  }
}
```

第一部分是很多的声明。也许你没有发现，我倾向于使用古老的 C 语言风格，将变量的声明放在其他代码前面。这个函数的重点在（显然是无限的）`while (1)` 循环中。在这个循环中，我们读取了一个字符（并将它保存为 `int` 类型，而不是 `char` 类型，这很重要！EOF 是一个整型值而不是字符型值。如果你想将它的值作为判断条件，需要使用 `int` 类型。这是 C 语言初学者常犯的错误。）。如果这个字符是换行符或者 EOF，我们将当前字符串用空字符结尾，并返回它。否则，我们将这个字符添加到当前的字符串中。

下一步，我们检查下一个字符是否会超出当前的缓冲区大小。如果会超出，我们就先重新分配缓冲区（并检查内存分配是否成功）。就是这样。

如果你对新版的 C 标准库很熟悉，会注意到 `stdio.h` 中有一个 `getline()` 函数，和我们刚才实现的功能几乎一样。实话说，我在写完上面这段代码之后才知道这个函数的存在。这个函数一直是 C 标准库的 GNU 扩展，直到 2008 年才加入规约中，大多数现代的 Unix 系统应该都已经有了这个函数。我会保持我已写的代码，我也鼓励你们先用这种方式学习，然后再使用 `getline`。否则，你会失去一次学习的机会！不管怎样，有了 `getline` 之后，这个函数就不重要了：

```C
char *lsh_read_line(void)
{
  char *line = NULL;
  ssize_t bufsize = 0; // 利用 getline 帮助我们分配缓冲区
  getline(&line, &bufsize, stdin);
  return line;
}
```

### 分析一行输入

好，那我们回到最初的那个循环。我们目前实现了 `lsh_read_line()`，得到了一行输入。现在，我们需要将这一行解析为参数的列表。我在这里将会做一个巨大的简化，假设我们的命令行参数中不允许使用引号和反斜杠转义，而是简单地使用空白字符作为参数间的分隔。这样的话，命令 `echo "this message"` 就不是使用单个参数 `this message` 调用 echo，而是有两个参数： `"this` 和 `message"`。

有了这些简化，我们需要做的只是使用空白符作为分隔符标记字符串。这意味着我们可以使用传统的库函数 `strtok` 来为我们干些苦力活。

```C
#define LSH_TOK_BUFSIZE 64
#define LSH_TOK_DELIM " \t\r\n\a"
char **lsh_split_line(char *line)
{
  int bufsize = LSH_TOK_BUFSIZE, position = 0;
  char **tokens = malloc(bufsize * sizeof(char*));
  char *token;

  if (!tokens) {
    fprintf(stderr, "lsh: allocation error\n");
    exit(EXIT_FAILURE);
  }

  token = strtok(line, LSH_TOK_DELIM);
  while (token != NULL) {
    tokens[position] = token;
    position++;

    if (position >= bufsize) {
      bufsize += LSH_TOK_BUFSIZE;
      tokens = realloc(tokens, bufsize * sizeof(char*));
      if (!tokens) {
        fprintf(stderr, "lsh: allocation error\n");
        exit(EXIT_FAILURE);
      }
    }

    token = strtok(NULL, LSH_TOK_DELIM);
  }
  tokens[position] = NULL;
  return tokens;
}
```

这段代码看起来和 `lsh_read_line()` 极其相似。这是因为它们就是很相似！我们使用了相同的策略 —— 使用一个缓冲区，并且将其动态地扩展。不过这里我们使用的是以空指针结尾的指针数组，而不是以空字符结尾的字符数组。

在函数的开始处，我们开始调用 `strtok` 来分割 token。这个函数会返回指向第一个 token 的指针。`strtok()` 实际上做的是返回指向你传入的字符串内部的指针，并在每个 token 的结尾处放置字节 `\0`。我们将每个返回的指针放在一个字符指针的数组（缓冲区）中。

最后，我们在必要时重新分配指针数组。这样的处理过程一直重复，直到 `strtok` 不再返回 token 为止。此时，我们将 token 列表的尾部设为空指针。

这样，我们的工作完成了，我们得到了 token 的数组。接下来我们就可以执行命令。那么问题来了，我们怎么去执行命令呢？

### Shell 如何启动进程

现在，我们真正来到了 shell 的核心位置。Shell 的主要功能就是启动进程。所以写一个 shell 意味着你要很清楚进程中发生了什么，以及进程是如何启动的。因此这里我要暂时岔开话题，聊一聊 Unix 中的进程。

在 Unix 中，启动进程只有两种方式。第一种（其实不能算一种方式）是成为 Init 进程。当 Unix 机器启动时，它的内核会被加载。内核加载并初始化完成后，会启动单独一个进程，叫做 Init 进程。这个进程在机器开启的时间中会一直运行，负责管理启动其他的你需要的进程，这样机器才能正常使用。

既然大部分的程序都不是 Init，那么实际上就只有一种方式启动进程：使用 `fork()` 系统调用。当调用该函数时，操作系统会将当前进程复制一份，并让两者同时运行。原有的进程叫做“父进程”，而新的进程叫做“子进程”。`fork()` 会在子进程中返回 0，在父进程中返回子进程的进程 ID 号（PID）。本质上，这意味着新进程启动的唯一方法是复制一个已有的进程。

这看上去好像有点问题。特别是，当你想运行一个新的进程时，你肯定不希望再运行一遍相同的程序 —— 你想运行的是另一个程序。这就是 `exec()` 系统调用所做的事情。它会将当前运行的程序替换为一个全新的程序。这意味着每当你调用 `exec`，操作系统都会停下你的进程，加载新的程序，然后在原处启动新的程序。一个进程从来不会从 `exec()` 调用中返回（除非出现错误）。

有了这两个系统调用，我们就有了大多数程序在 Unix 上运行的基本要素。首先，一个已有的进程将自己分叉（fork）为两个不同的进程。然后，子进程使用 `exec()` 将自己正在执行的程序替换为一个新的程序。父进程可以继续做其他的事情，甚至也可以使用系统调用 `wait()` 继续关注子进程。

啊！我们讲了这么多。但是有了这些作为背景，下面启动程序的代码才是说得通的：

```C
int lsh_launch(char **args)
{
  pid_t pid, wpid;
  int status;

  pid = fork();
  if (pid == 0) {
    // 子进程
    if (execvp(args[0], args) == -1) {
      perror("lsh");
    }
    exit(EXIT_FAILURE);
  } else if (pid < 0) {
    // Fork 出错
    perror("lsh");
  } else {
    // 父进程
    do {
      wpid = waitpid(pid, &status, WUNTRACED);
    } while (!WIFEXITED(status) && !WIFSIGNALED(status));
  }

  return 1;
}
```

这个函数使用了我们之前创建的参数列表。然后，它 fork 当前的进程，并保存返回值。当 `fork()` 返回时，我们实际上有了**两个**并发运行的进程。子进程会进入第一个 if 分支（`pid == 0`）。

在子进程中，我们想要运行用户提供的命令。所以，我们使用 `exec` 系统调用的多个变体之一：`execvp`。`exec` 的不同变体做的事情稍有不同。一些接受变长的字符串参数，一些接受字符串的列表，还有一些允许你设定进程运行的环境。`execvp` 这个变体接受一个程序名和一个字符串参数的数组（也叫做向量（vector），因此是‘v’）（数组的第一个元素应当是程序名）。‘p’ 表示我们不需要提供程序的文件路径，只需要提供文件名，让操作系统搜索程序文件的路径。

如果 exec 命令返回 -1（或者说，如果它返回了），我们就知道有地方出错了。那么，我们使用 `perror` 打印系统的错误消息以及我们的程序名，让用户知道是哪里出了错。然后，我们让 shell 继续运行。

第二个 if 条件（`pid < 0`）检查 `fork()` 是否出错。如果出错，我们打印错误，然后继续执行 —— 除了告知用户，我们不会进行更多的错误处理。我们让用户决定是否需要退出。

第三个 if 条件表明 `fork()` 成功执行。父进程会运行到这里。我们知道子进程会执行命令的进程，所以父进程需要等待命令运行结束。我们使用 `waitpid()` 来等待一个进程改变状态。不幸的是，`waitpid()` 有很多选项（就像 `exec()` 一样）。进程可以以很多种方式改变其状态，并不是所有的状态都表示进程结束。一个进程可能退出（正常退出，或者返回一个错误码），也可能被一个信号终止。所以，我们需要使用 `waitpid()` 提供的宏来等待进程退出或被终止。函数最终返回 1，提示上层函数需要继续提示用户输入了。

### Shell 内置函数

你可能发现了，`lsh_loop()` 函数调用了 `lsh_execute()`。但上面我们写的函数却叫做 `lsh_launch()`。这是有意为之的。虽然 shell 执行的命令大部分是程序，但有一些不是。一些命令是 shell 内置的。

这里的原因其实很简单。如果你想改变当前目录，你需要使用函数 `chdir()`。问题是，当前目录是进程的一个属性。那么，如果你写了一个叫 `cd` 的程序来改变当前目录，它只会改变自己当前的目录，然后终止。它的父进程的当前目录不会改变。所以应当是 shell 进程自己执行 `chdir()`，才能更新自己的当前目录。然后，当它启动子进程时，子进程也会继承这个新的目录。

类似的，如果有一个程序叫做 `exit`，它也没有办法使调用它的 shell 退出。这个命令也必须内置在 shell 中。还有，多数 shell 通过运行配置脚本（如 `~/.bashrc`）来进行配置。这些脚本使用一些改变 shell 行为的命令。这些命令如果由 shell 自己实现的话，同样只会改变 shell 自己的行为。

因此，我们需要向 shell 本身添加一些命令是有道理的。我添加进我的 shell 的命令是 `cd`、`exit` 和 `help`。下面是他们的函数实现：

```C
/*
  内置 shell 命令的函数声明：
 */
int lsh_cd(char **args);
int lsh_help(char **args);
int lsh_exit(char **args);

/*
  内置命令列表，以及它们对应的函数。
 */
char *builtin_str[] = {
  "cd",
  "help",
  "exit"
};

int (*builtin_func[]) (char **) = {
  &lsh_cd,
  &lsh_help,
  &lsh_exit
};

int lsh_num_builtins() {
  return sizeof(builtin_str) / sizeof(char *);
}

/*
  内置命令的函数实现。
*/
int lsh_cd(char **args)
{
  if (args[1] == NULL) {
    fprintf(stderr, "lsh: expected argument to \"cd\"\n");
  } else {
    if (chdir(args[1]) != 0) {
      perror("lsh");
    }
  }
  return 1;
}

int lsh_help(char **args)
{
  int i;
  printf("Stephen Brennan's LSH\n");
  printf("Type program names and arguments, and hit enter.\n");
  printf("The following are built in:\n");

  for (i = 0; i < lsh_num_builtins(); i++) {
    printf("  %s\n", builtin_str[i]);
  }

  printf("Use the man command for information on other programs.\n");
  return 1;
}

int lsh_exit(char **args)
{
  return 0;
}
```

这段代码有三个部分。第一部分包括我的函数的**前置声明**。前置声明是当你声明了（但还未定义）某个符号，就可以在它的定义之前使用。我这么做是因为 `lsh_help()` 使用了内置命令的数组，而这个数组中又包括 `lsh_help()`。打破这个依赖循环的最好方式是使用前置声明。

第二个部分是内置命令名字的数组，然后是它们对应的函数的数组。这样做是为了，在未来可以简单地通过修改这些数组来添加内置命令，而不是修改代码中某处一个庞大的“switch”语句。如果你不理解 `builtin_func` 的声明，这很正常！我也不理解。这是一个函数指针（一个接受字符串数组作为参数，返回整型的函数）的数组。C 语言中任何有关函数指针的声明都会很复杂。我自己仍然需要查一下函数指针是怎么声明的！

最后，我实现了每个函数。`lsh_cd()` 函数首先检查它的第二个参数是否存在，不存在的话打印错误消息。然后，它调用 `chdir()`，检查是否出错，并返回。帮助函数会打印漂亮的消息，以及所有内置函数的名字。退出函数返回 0，这是让命令循环退出的信号。

### 组合内置命令与进程

我们的程序最后缺失的一部分就是实现 `lsh_execute()` 了。这个函数要么启动一个内置命令，要么启动一个进程。如果你一路读到了这里，你会知道我们只剩下一个非常简单的函数需要实现了：

```C
int lsh_execute(char **args)
{
  int i;

  if (args[0] == NULL) {
    // 用户输入了一个空命令
    return 1;
  }

  for (i = 0; i < lsh_num_builtins(); i++) {
    if (strcmp(args[0], builtin_str[i]) == 0) {
      return (*builtin_func[i])(args);
    }
  }

  return lsh_launch(args);
}
```

这个函数所做的不过是检查命令是否和各个内置命令相同，如果相同的话就运行内置命令。如果没有匹配到一个内置命令，我们会调用 `lsh_launch()` 来启动进程。需要注意的是，有可能用户输入了一个空字符串或字符串只有空白符，此时 `args` 只包含空指针。所以，我们需要在一开始检查这种情况。

### 全部组合在一起

以上就是这个 shell 的全部代码了。如果你已经读完，你应该完全理解了 shell 是如何工作的。要试用它（在 Linux 机器上）的话，你需要将这些代码片段复制到一个文件中（`main.c`），然后编译它。确保代码中只包括一个 `lsh_read_line()` 的实现。你需要在文件的顶部包含以下的头文件。我添加了注释，以便你知道每个函数的来源。

*   `#include <sys/wait.h>`
    *   `waitpid()` 及其相关的宏
*   `#include <unistd.h>`
    *   `chdir()`
    *   `fork()`
    *   `exec()`
    *   `pid_t`
*   `#include <stdlib.h>`
    *   `malloc()`
    *   `realloc()`
    *   `free()`
    *   `exit()`
    *   `execvp()`
    *   `EXIT_SUCCESS`, `EXIT_FAILURE`
*   `#include <stdio.h>`
    *   `fprintf()`
    *   `printf()`
    *   `stderr`
    *   `getchar()`
    *   `perror()`
*   `#include <string.h>`
    *   `strcmp()`
    *   `strtok()`

当你准备好了代码和头文件，简单地运行 `gcc -o main main.c` 进行编译，然后 `./main` 来运行即可。

或者，你可以从 [GitHub](https://github.com/brenns10/lsh/tree/407938170e8b40d231781576e05282a41634848c) 上获取代码。这个链接直接跳转到我写这篇文章时的代码当前版本 —— 未来我可能会更新代码，增加一些新的功能。如果代码更新了，我会尽量在本文中更新代码的细节和实现思路。

### 结语

如果你读了这篇文章，想知道我到底是怎么知道如何使用这些系统调用的。答案很简单：通过手册页（man pages）。在 `man 3p` 中有对每个系统调用的详尽文档。如果你知道你要找什么，只是想知道如何使用它，那么手册页是你最好的朋友。如果你不知道 C 标准库和 Unix 为你提供了什么样的接口，我推荐你阅读 [POSIX 规范](http://pubs.opengroup.org/onlinepubs/9699919799/)，特别是第 13 章，“头文件”。你可以找到每个头文件，以及其中需要定义哪些内容。

显然，这个 shell 的功能不够丰富。一些明显的遗漏有：

*   只用了空白符分割参数，没有考虑到引号和反斜杠转义。
*   没有管道和重定向。
*   内置命令太少。
*   没有通配符。

实现这几个功能其实非常有趣，但已经远不是我这样一篇文章可以容纳的了的了。如果我开始实现其中任何一项，我一定会写一篇关于它的后续文章。不过我鼓励读者们都尝试自己实现这些功能。如果你成功了，请在下面的评论区给我留言，我很乐意看到你的代码。

最后，感谢阅读这篇教程（如果有人读了的话）。我写得很开心，也希望你能读得开心。在评论区让我知道你的想法！

**更新：** 在本文的较早版本中，我在 `lsh_split_line()` 中遇到了一些讨厌的 bug，它们恰好相互抵消了。感谢 Reddit 的 /u/munmap（以及其他评论者）找到了这些 bug！ 在[这里](https://github.com/brenns10/lsh/commit/486ec6dcdd1e11c6dc82f482acda49ed18be11b5)看看我究竟做错了什么。

**更新二：** 感谢 GitHub 用户 ghswa 贡献了我忘记的一些 `malloc()` 的空指针检查。他/她还指出 `getline` 的[手册页](http://pubs.opengroup.org/onlinepubs/9699919799/functions/getline.html)规定了第一个参数所占用的内存空间应当可以被释放，所以我的使用 `getline()` 的 `lsh_read_line()` 实现中，`line` 应当初始化为 `NULL`。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
