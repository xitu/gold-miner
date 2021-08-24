> * 原文地址：[Advanced Python: How To Implement Caching In Python Application](https://medium.com/fintechexplained/advanced-python-how-to-implement-caching-in-python-application-9d0a4136b845)
> * 原文作者：[Farhad Malik](https://medium.com/@farhadmalik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/advanced-python-how-to-implement-caching-in-python-application.md](https://github.com/xitu/gold-miner/blob/master/article/2021/advanced-python-how-to-implement-caching-in-python-application.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：

# 进阶 Python：在 Python 应用中实现缓存

缓存对每一个 Python 程序员来说都是一个重要的概念。

总的来说，缓存的概念是利用编程技术将数据存储在临时位置，而不是每次从源头检索数据。

此外，缓存能提升应用程序的性能，因为从临时位置访问数据总比从源头（数据库，服务器等）获取来得快。

这篇文章主要探讨缓存在 Python 中是如何运作的。

![](https://miro.medium.com/max/671/1*4f9xjNXx1FVXzIoQZ4CdpQ.png)

这对 Python 开发者来说是一个进阶的课题。如果你正在使用 Python 或打算使用它，那么你非常适合阅读这篇文章。

如果你想从入门到进阶地了解 Python 程序语言，那么我强烈推荐你阅读[这篇文章](https://medium.com/fintechexplained/everything-about-python-from-beginner-to-advance-level-227d52ef32d2)。

## 文章主旨

在这篇文章中，我会解释什么是缓存，我们为什么需要缓存和如何在 Python 中实现它。

> 我们需要缓存来提高程序的性能。

我将概述以下三个关键点：

1. 什么是缓存以及为什么我们需要实现缓存？
2. 缓存的规则是什么？
3. 如何实现缓存？

我将首先解释什么是缓存，为什么我们需要在我们的应用程序中引入缓存，以及如何实现缓存。

## 1. 什么是缓存以及为什么我们需要实现缓存？

要想了解缓存是什么以及我们为什么需要缓存，试考虑以下场景：

- 我们正在用 Python 构建一个应用程序，它将向终端用户展示产品列表。
- 每天将有 100 多个用户多次访问此应用程序。
- 该应用程序将托管在应用程序服务器上，并可在互联网上访问。
- 产品的资料将存储在数据库服务器中。
- 因此应用程序服务器将查询数据库以获取相关记录。

下图展示了我们的目标应用程序是如何配置的：

![](https://miro.medium.com/max/700/1*XcWM5A0G6yKWqr_yWUfgnw.png)

上图说明了应用程序服务器如何从数据库服务器获取数据。

### 问题

从数据库中获取数据是一个 I/O 密集型的操作。因此，它本质上是缓慢的。如果服务端需要频繁地发送请求且服务器响应跟不上请求的速度，那么我们可以将响应缓存在应用程序的内存中。

与其每次都查询数据库，我们可以将结果缓存，如下所示：

![数据存储在临时缓存中](https://miro.medium.com/max/700/1*3mv7SdqieweoDQYEhkNAhA.png)

获取数据的请求必须通过网线，响应也必须通过网线返回。

这本质上是缓慢的。因此，我们引入了缓存。

> 我们可以缓存结果以减少计算时间并节省计算机资源。

缓存是一个临时存储位置。它以惰性载入的方式工作。

一开始，缓存是空的。当应用程序服务器从数据库服务器获取数据时，数据集将填充缓存。从那以后，后续的请求便能直接从缓存中获取数据。

我们还需要及时废止缓存，以确保我们向终端用户显示最新信息。

本文的下一部分：缓存规则。

## 2. 缓存规则

在我看来，缓存有三个规则。

在启用缓存之前，我们需要执行一个关键步骤 —— 分析应用程序。

因此，在应用程序中引入缓存之前的第一步是分析应用程序。

只有这样我们才能了解每个函数需要执行多长时间以及它被调用了多少次。

我在[**这篇文章**](https://medium.com/fintechexplained/advanced-python-learn-how-to-profile-python-code-1068055460f9)中解释了分析的艺术，我强烈将它推荐给大家。

分析完成后，我们需要确定需要缓存的内容。

我们需要一种能将输入链接到函数的输出的机制，并将它们存储在内存中。这就是缓存的第一条规则。

### 2.1. 第一条规则：

第一条规则是确保目标函数确实需要很长时间才能返回输出，且它会频繁被执行但输出的更动不大。

我们不想为不需要很长时间才能完成的函数，或几乎不会在应用程序中调用的函数，或那些返回结果在源中频繁更改的函数引入缓存。

请牢记这条重要的规则。

> 适合缓存的候选 = 经常调用的函数，输出不经常变化并且需要很长时间执行。

举例来说，如果一个函数被执行了 100 次，且该函数需要很长时间才能返回结果，并且它为给定的输入返回相同的结果，那么我们可以缓存它。

然而，如果函数返回的值在源中每秒更新一次，并且我们每分钟将收到一个执行该函数的请求，那么我们得清楚地明白是否需要缓存结果。这非常重要，因为可能导致应用发送过时的数据给用户。我们得了解是否需要缓存，或者是否需要不同的通信通道、数据结构或序列化机制来更快地检索数据，例如通过 socket 使用二进制序列化器与通过 HTTP 的 XML 序列化发送数据。

此外，知道何时废止缓存并重新加载新数据到缓存是非常重要的。

### 2.2. 第二条规则：

第二条规则是确保从缓存中获取数据的速度比执行目标函数的速度更快。

如果实践缓存后对检索结果所需的时间有正面的影响，我们才应该引入缓存。

> 缓存应该比从当前数据源获取数据更快。

因此，选择合适的数据结构（例如字典或 LRU 缓存）作为缓存的实例至关重要。

### 2.3. 第三条规则：

第三个重要规则是关于内存占用，这很常被忽略。你执行的是 I/O 操作（例如查询数据库、网络服务），还是执行 CPU 密集型操作（例如处理数字和执行内存内计算）？

当我们缓存结果时，应用程序的内存占用会增加，因此选择合适的数据结构并且只缓存需要缓存的数据是至关重要的。

有时侯，我们得查询多个表来创建一个类的对象。然而，我们只需要在我们的应用程序中缓存基本属性。

> 缓存对内存占用有影响。

例如，假设我们构建了一个报告面板，用于查询数据库并检索订单列表。为了让你有个大致的画面，我们假设面板上仅显示订单名称。

因此，我们可以只缓存每个订单的名称，而不是缓存整个订单对象。通常，架构师建议创建一个具有 `__slots__` 属性的“瘦身版”数据传输对象（DTO）以减少内存占用。命名元组或 `dataclass` 类也有同样的效果。（`dataclass` 类是 Python 3.7 中新增的功能。）

本文的最后一部分：概述实现缓存的细节。

## 3. 如何实现缓存？

有多种方法可以实现缓存。

我们可以在 Python 进程中创建本地数据结构来构建缓存，或将缓存作为服务器充当代理并为请求提供服务。

Python 中有相应的内置工具，例如 `functools` 库中的 `cached_property` 装饰器。我将通过它来介绍缓存的实现。（仅适用于 Python 3.8 及更高版本。）

下面的代码段说明了 `cached_property` 如何运作：

```python
from functools import cached_property


class FinTech:

    @cached_property
    def run(self):
        return list(range(1, 100))
```

因此，现在 `FinTech().run` 已被缓存，并且 `list(range(1,100))` 将只生成一次。但是，在实际场景中，我们几乎不需要缓存属性。

让我们看看其他方法。

### 3.1. 字典方法

对于简单的用例，我们可以创建/使用映射数据结构（例如字典），将数据保存在内存中并使其使其可在全局范围内访问。

实现方式有多种，最简单的方法是创建一个单例模块，例如：`config.py`。

在 `config.py` 中，我们可以创建一个字典类型的字段，该字段在开始时被填充一次。

以后我们便可以使用字典的字段来获取结果。

举例来说，看看下方的代码。

`config.py` 带有 `cache` 属性：

```python
cache = {}
```

试想一下，我们的应用程序将通过 `get_prices(symbol, start_date, end_date)` 函数查询雅虎财经的网络服务以获取公司的历史价格。

历史价格不会改变，因此我们不需要每次需要历史价格时都查询网络服务。我们可以在内存中缓存价格。

在内部实践中，函数 `get_prices(symbol, start_date, end_date)` 可以在尝试返回结果之前检查数据是否在缓存中。

让我通过代码解释该策略。

下面的 `get_prices` 函数接受一个名为 `companies` 的参数。

1. 首先，该函数创建一个开始和结束日期的变量，其中开始日期设为昨天，结束日期设为 12 天前。
2. 然后它创建一个名为 `target_key` 的元组类型变量。它的值唯一，由模块、函数、开始和结束日期组成。
3. 该函数首先在 `config.cache` 中查找键。如果它找到了，则检查 `cache` 是否包含目标公司名称。
4. 如果缓存中包含公司名称，它会从缓存中返回价格。
5. 如果 `target_key` 不在缓存中，那么它通过雅虎财经检索所有公司，并将价格保存在缓存中以备将来调用。最后，函数返回价格。

因此，基本概念是检查缓存中的目标键，如果不存在，则从源头获取它并在返回之前将其保存在缓存中。

这就是缓存的构建方式：

```python
import datetime

import yfinance as yf

import config


def get_prices(companies):
    end_date = datetime.datetime.now() - datetime.timedelta(days=1)
    start_date = end_date - datetime.timedelta(days=11)
    target_key = (__name__, '_get_prices_',
                  start_date.strftime("%Y-%m-%d"),
                  end_date.strftime("%Y-%m-%d"))

    if target_key in config.cache:
        cached_prices = config.cache[target_key]
        # cached_prices 是一个字典，其中键为公司符号，值为价格。
        prices = {}
        for company in companies:
            # 对于每个公司，只获取未缓存的价格。
            if company in cached_prices:
                # 我们已经缓存了价格。
                # 在局部变量中设置价格。
                prices[company] = cached_prices[company]
            else:
                # 去雅虎财经得到价格。
                yahoo_prices = yf.download(company, start=start_date, end=end_date)
                prices[company] = yahoo_prices['Close']
                cached_prices[company] = prices[company]
        return prices
    else:
        company_symbols = ' '.join(map(lambda x: x, companies))
        yahoo_prices = yf.download(company_symbols, start=start_date, end=end_date)
        # 现在将其存储在缓存中以备将来使用。
        prices_per_company = yahoo_prices['Close'].to_dict()
        config.cache[target_key] = prices_per_company
        return prices_per_company
```

上方的所选键包含开始日期和结束日期。你也可以在键中包含公司名称，存储 `（公司名称，开始日期，结束日期，函数名称）` 作为键。

数据结构的键必须是唯一的。它可以是一个元组。

历史价格不会改变，因此不构建及时使缓存失效的逻辑也是安全的。

这个缓存是一个嵌套字典，因为其值是一个字典。它加快了查找的速度，操作的时间复杂度为 `O(1)`。

[这里有一篇很棒的文章](https://medium.com/fintechexplained/time-complexities-of-python-data-structures-ddb7503790ef)，它以一种易于理解的方式解释了 Python 数据结构的时间复杂性。

有时键会变得太长，最好使用 MD5、SHA 等对其进行散列。但是，使用散列可能会发生冲突，使得两个字符串产生相同的散列。

我们也可以利用记忆化（memoisation）技术。

Memoisation is usually used in recursive function calls where the intermediate results are stored in memory and are returned when they are required.

This is where I will introduce the LRU.

### 3.2. LRU 算法

我们可以使用 Python 的内置 LRU 功能。

LRU stands for the least recently used algorithm. LRU can cache the return values of a function that are dependent on the arguments that have been passed to the function.LRU 代表最近最少使用的算法。 LRU 可以缓存依赖于传递给函数的参数的函数的返回值。

LRU is particularly useful in recursive CPU bound operations.LRU 在递归 CPU 绑定操作中特别有用。

它本质上是一个装饰器：`[@lru_cache](http://twitter.com/lru_cache)(maxsize, typed)`，我们可以用它来装饰我们的函数。

- `maxsize` 告诉装饰器缓存的最大大小（预设值为 128）。如果我们不想设置大小，那么只需将其设置为 `None`。
- `typed` is used to indicate whether we want to cache the output as the same values that can be compared values of different types.`typed` 用于指示我们是否要将输出缓存为可以比较不同类型值的相同值。

This works when we expect the same output for the same inputs.当我们期望相同的输入有相同的输出时，这是有效的。

Holding all of the data in your application's memory can be troubling.保存所有数据的应用程序的内存可以困扰。

This can become a problem in a distributed application with multiple processes where it is not appropriate to cache all of the results in memory in all of the processes.

A good use case is when the application runs on a cluster of machines. We can host caching as a service.

### 3.3. Caching As A Service

The third option is about hosting cached data as an external service. This service can be responsible for storing all of the requests and responses.
All of the applications can retrieve data via the caching service. It acts as a proxy.

Let's consider that we are building an application as big as Wikipedia and it is expected to service 1000s of requests concurrently and in parallel.

We need a caching mechanism and want to distribute the caching across servers.

We can use memcache and cache the data.

Memcached is highly popular in Linux and Windows because:

- It can be used for implementing memoisation caches that have states.
- It can even be distributed across servers.
- It is extremely simple to use, it's fast and it is being used across industry in multiple large organisations.
- It supports auto-expiring the cached data

There is a python library called `pymemcache `which we need to install.

Memcache requires the data to be either stored as strings or binary. Hence, we would have to serialise the cached objects and deserialise them when we want to retrieve them.

The code snippet shows how we can launch and use the memcache:

```python
client = Client(host, serialiser, deserialiser)
client.set(‘blog’: {‘name’:’caching’, ‘publication’:’fintechexplained’}}
blog = client.get(‘blog’)
```

### 3.4. Gotcha: Invalidating Cache

Lastly, I wanted to quickly provide an overview of the scenarios when the output of a function for the same inputs is changing on timely basis and we want to cache the results for a shorter period of time.

Consider the case whereby two applications are running on two different application servers.

The first application gets the data from the database server and the second application updates the data in the database server. The data is fetched frequently and we want to cache the data in the first application server:

![](https://miro.medium.com/max/700/1*2gi4DqkHWejxgU7sSRoDGQ.png)

There are a few ways to solve it.

- The application in the second application server can notify the first application server whenever new records are stored so that it can refresh its cache. It can post a message to a queue that the first application can subscribe to.
- The first application server can also make a light-weight call to the database server to find the last time when the data was updated and it can then use the time to determine whether it needs to refresh the cache or get the data from the cache.
- We can also add a timeout that will clear the cache so that the next request can reload it. It is easy to implement but it is not as reliable as the last options I have explained above. This feature can be achieved via signaling library whereby we can subscribe a handler to the signal.alarm(timeout) and after a timeout period is called, we can clear the cache in the handler. We can also run a background thread to invalidate the cache, it's, however, important to ensure appropriate synchronisation objects are used.

## 总结

缓存是每个 Python 程序员和数据科学家都需要理解的重要概念。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
