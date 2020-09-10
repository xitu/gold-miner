> * 原文地址：[Tutorial on Python Logging](https://levelup.gitconnected.com/tutorial-on-python-logging-ac5f21e0a00)
> * 原文作者：[Anuradha Wickramarachchi](https://medium.com/@anuradhawick)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/tutorial-on-python-logging.md](https://github.com/xitu/gold-miner/blob/master/article/2020/tutorial-on-python-logging.md)
> * 译者：
> * 校对者：

# Tutorial on Python Logging

Logging is a very important functionality for a programmer. For both debugging and displaying run-time information, logging is equally useful. In this article, I will present why and how you could use the python’s logging module in your programs.

![Photo by [Chris Ried](https://unsplash.com/@cdr6934?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/codes?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/12032/1*1X0-98EiQNkwBJj2vnTTqQ.jpeg)

## Why Logging and not print()

There is a key difference between a print statement and logging output. Usually, print statements write to **stdout** (standard output) which is expected to be the useful information or the output of the program. However, logs are written into **stderr** (standard error). We can demonstrate this scenario as follows.

```py
import logging

logging.basicConfig(level=logging.INFO) #We'll talk about this soon!

logging.warning('Something bad could happen!')
logging.info('You are running the program')
logging.error('Aw snap! Everything failed.')

print("This is the program output")
```

Now if I run this program, I will see the following in the command line.

```
$ python log_test.py
WARNING:root:Something bad could happen!
INFO:root:You are running the program
ERROR:root:Aw snap! Everything failed.
This is the program output
```

However, for the usual user, the information is too much. Though this is actually displayed all together in the command line the data is written into two separate streams. So a typical user should do the following.

```
$ python log_test.py > program_output.txt
WARNING:root:Something bad could happen!
INFO:root:You are running the program
ERROR:root:Aw snap! Everything failed.

$ cat program_output.txt
This is the program output
```

Here the useful program output is written to a file, by redirection `>`. So we can see what's happening on the terminal and get the output conveniently on a file. Now let’s try to understand the log levels!

## Logging and Log Levels

![Photo by [Edvard Alexander Rølvaag](https://unsplash.com/@edvardr?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/hierarchy?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/8302/1*whdOswlacQ_B_cpFkYssEw.jpeg)

Logging can happen for different reasons. These reasons are separated into levels of severity as following.

* **DEBUG**: Debug information for developers such as computed values, estimated parameters, URLs, API calls, etc.
* **INFO**: Information, nothing serious.
* **WARNING**: Warnings to users about inputs, parameters, etc.
* **ERROR**: Reports an error caused by something that the user did or occurred within the program.
* **CRITICAL**: The highest priority log output. Used for critical concerns (Depends on the use-case).

The most common types of logs are **DEBUG**, **INFO**, and **ERROR**. However, you can easily end up with scenarios where python throws warnings for version mismatches.

## Configuring the Logger and Log Handlers

The loggers can be configured under different parameters. The logger can be configured to follow a particular log level, a file name, file mode, and a format to print the log output.

![Image by [2427999](https://pixabay.com/users/2427999-2427999/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=3714727) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=3714727)](https://cdn-images-1.medium.com/max/2560/1*VCxgsxAXIXkGAnHzMxzoHw.jpeg)

#### Configuring the Logger Parameters

The logger can be configured as follows.

```py
import logging

logging.basicConfig(filename='program.log', filemode='w', level=logging.DEBUG)
logging.warning('You are given a warning!')
```

The above setting asks the logger to output the log into a file named `program.log`. The `filemode=’w’` defines the nature of writing to file. For example, `'w'` open a new file overwriting whatever that was there. By default, this parameter is `'a'` which will open the log file in append mode. Sometimes it is useful to have a log history. The level parameter defines the lowest severity for logging. For example, if you set this to **INFO**, **DEBUG** logs will not be printed. You may have seen programs needs to be run in`verbose=debug` mode to see some parameters. By default the level is **INFO**.

#### Creating a Log Handler

Although the above approach is straightforward for a simple application we need a comprehensive logging process for a production-ready software or a service. This is because it might be quite difficult to find for a particular **ERROR** log amidst millions of **DEBUG** logs. Furthermore, we need to use a single logger throughout the program and modules. This way we’ll correctly append the logs to the same file. For this, we can use handlers with different configurations for this task.

```py
import logging

logger = logging.getLogger("My Logger")
logger.setLevel(logging.DEBUG)

console_handler = logging.StreamHandler()
file_handler = logging.FileHandler('file.log', mode='w')
console_handler.setLevel(logging.INFO)
file_handler.setLevel(logging.DEBUG)

logger.addHandler(console_handler)
logger.addHandler(file_handler)
```

You can see that we first get a logger passing a name. This enables us to reuse the same logger everywhere else in the program. We set the global logging level to be **DEBUG**. This is the lowest log level, hence enables us to use any log level in other handlers.

Next, we create two handlers for **console** and **file** writing. For each handler, we provide a log level. This can help reduce the overhead on console output and transfer them to the file handler. Makes it easy to deal with debugs later.

## Formatting the Log Output

Logging is not merely print our own message. Sometimes we need to print other information such as time, log level, and process ids. For this task, we can use log formatting. Let’s see the following code.

```py
console_format = logging.Formatter('%(name)s - %(levelname)s - %(message)s')
file_format = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

console_handler.setFormatter(console_format)
file_handler.setFormatter(file_format)
```

Before we add handlers to the logger we can format the log outputs as above. There are many more parameters that you can use for this. You can find them all [here](https://docs.python.org/3/library/logging.html#logrecord-attributes).

## A Code for Reuse

The following is a code snippet for logging that I continue to use in many of my applications. Thought it might be useful for you as the reader.

```Python
import logging

logger = logging.getLogger('Program Name-Version')
logger.setLevel(logging.DEBUG)

formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')

consoleHeader = logging.StreamHandler()
consoleHeader.setFormatter(formatter)
consoleHeader.setLevel(logging.INFO)

fileHandler = logging.FileHandler(f"{output}/metabcc-lr.log")
fileHandler.setLevel(logging.DEBUG)
fileHandler.setFormatter(formatter)

logger.addHandler(fileHandler)
logger.addHandler(consoleHeader)
```

![Image by [Bruno /Germany](https://pixabay.com/users/Bru-nO-1161770/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1006172) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1006172)](https://cdn-images-1.medium.com/max/2560/1*irOTu97Vs_YYWyqsivxu2Q.png)

#### Loggin with Multithreading

The logging module is made with thread safety in mind. Hence no special action is required when you’re logging from different threads except very few exceptions (out of the main scope of this article).

I hope this is a simple but useful article for many budding programmers and engineers. The following are a few more python tutorials that you might like having a look at. Happy reading. Cheers! :-)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
