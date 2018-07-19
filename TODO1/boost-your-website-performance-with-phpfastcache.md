> * 原文地址：[Boost Your Website Performance With PhpFastCache](https://code.tutsplus.com/tutorials/boost-your-website-performance-with-phpfastcache--cms-31031)
> * 原文作者：[Sajal Soni](https://tutsplus.com/authors/sajal-soni?_ga=2.222559131.1693151914.1529137386-2093006918.1525313549)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/boost-your-website-performance-with-phpfastcache.md](https://github.com/xitu/gold-miner/blob/master/TODO1/boost-your-website-performance-with-phpfastcache.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：

# 使用 PhpFastCache 提升网站性能

本文将与你一同探索 PhpFastCache 库，来为你的 PHP 应用实现缓存功能。通过缓存功能，能够提升网站的整体性能与页面加载速度。

## 什么是 PhpFastCache？

PhpFastCache 是一个能让你轻松在 PHP 应用中实现缓存功能的库。它的功能强大，且简单易用，提供了一些 API 以无痛实现缓存策略。

PhpFastCache 不是一个纯粹的传统文件系统式缓存。它支持各种各样的文件适配器（Files Adapter），可以让你选择 Memcache、Redis、MongoDB、CouchDB 等高性能的后端服务。

让我们先总览一遍最流行的适配器：

*   文件系统
*   Memcache、Redis 和 APC
*   CouchDB 和 MongoDB
*   Zend Disk Cache 和 Zend Memory Cache

如果你用的文件适配器不在上面的列表中，也可以简单地开发一个自定义驱动，插入到系统中，同样也能高效地运行。

除了基本功能外，PhpFastCache 还提供了事件机制，可以让你对预定义好的时间进行相应。例如，当某个事物从缓存中被删除时，你可以接收到这个事件，并去刷新或删除相关的数据。

在下面的章节中，我们将通过一些示例来了解如何安装及配置 PhpFastCache。

## 安装与配置

在本节中，我们将了解如何安装及配置 PhpFastCache。下面是几种将它集成进项目的方法。

如果你嫌麻烦，仅准备下载这个库的 **.zip** 或者 **.tar.gz** 文件，可以去[官方网站](https://www.phpfastcache.com/) 直接下载。

或者你也可以用 Composer 包的方式来安装它。这种方式更好，因为在之后的维护和升级时会更方便。如果你还没有安装 Composer，需要先去安装它。

当你安装好 Composer 之后，可以用以下命令下载 PhpFastCache：

```bash
$composer require phpfastcache/phpfastcache
```

命令完成后，你会得到一个 vendor 目录，在此目录中包括了全部 PhpFastCache 所需的文件。另外，如果你缺失了 PhpFastCache 依赖的库或插件，Composer 会提醒你先去安装依赖。

你需要找到 `composer.json` 文件，它类似于下面这样：

```json
{
    "require": {
        "phpfastcache/phpfastcache": "^6.1"
    }
}
```

无论你通过什么方式来安装的 PhpFastCache，都要在应用中 include **autoload.php** 文件。

如果你用的是基于 Composer 的工作流，**autoload.php** 文件会在 **vendor** 目录中。

```php
// Include composer autoloader
require '{YOUR_APP_PATH}/vendor/autoload.php';
```

另外，如果你是直接下载的 **.zip** 和 **.tar.gz**，**autoload.php** 的路径会在 **src/autoload.php**。

```php
// Include autoloader
require '{YOUR_APP_PATH}/src/autoload.php';
```

只要完成上面的操作，就能开始进行缓存，享受 PhpFastCache 带来的好处了。在下一章节中，我们将以一个简单的示例来介绍如何在你的应用中使用 PhpFastCache。

## 示例

前面我提到过，PhpFastCache 支持多种文件适配器进行缓存。在本节中，我会以文件系统和 Redis 这两种文件适配器为例进行介绍。

### 使用文件适配器进行缓存

创建 **file_cache_example.php** 文件并写入下面的代码。在此我假设你使用的是 Composer workflow，因此 **vendor** 目录会与 **file_cache_example.php** 文件同级。如果你是手动安装的 PhpFastCache，需要根据实际情况修改文件结构。

```php
<?php
/**
 * file_cache_example.php
 *
 * Demonstrates usage of phpFastCache with "file system" adapter
 */
 
// Include composer autoloader
require __DIR__ . '/vendor/autoload.php';
 
use phpFastCache\CacheManager;
 
// Init default configuration for "files" adapter
CacheManager::setDefaultConfig([
  "path" => __DIR__ . "/cache"
]);
 
// Get instance of files cache
$objFilesCache = CacheManager::getInstance('files');
 
$key = "welcome_message";
 
// Try to fetch cached item with "welcome_message" key
$CachedString = $objFilesCache->getItem($key);
 
if (is_null($CachedString->get()))
{
    // The cached entry doesn't exist
    $numberOfSeconds = 60;
    $CachedString->set("This website uses PhpFastCache!")->expiresAfter($numberOfSeconds);
    $objFilesCache->save($CachedString);
 
    echo "Not in cache yet, we set it in cache and try to get it from cache!</br>";
    echo "The value of welcome_message:" . $CachedString->get();
}
else
{
    // The cached entry exists
    echo "Already in cache!</br>";
    echo "The value of welcome_message:" . $CachedString->get();
}
```

现在，我们一块一块地来理解代码。首先看到的是将 **autoload.php** 文件引入，然后导入要用到的 namespace：

```php
// Include composer autoloader
require __DIR__ . '/vendor/autoload.php';
 
use phpFastCache\CacheManager;
```

当你使用文件缓存的时候，最好提供一个目录路径来存放缓存系统生成的文件。下面的代码就是做的这件事：

```php
// Init default configuration for "files" adapter
CacheManager::setDefaultConfig([
  "path" => __DIR__ . "/cache"
]);
```

当然，你需要确保 **cache** 目录存在且 web server 有写入权限。

接下来，我们将缓存对象实例化，用 **welcome_message** 加载对应的缓存对象。

```php
// Get instance of files cache
$objFilesCache = CacheManager::getInstance('files');
 
$key = "welcome_message";
 
// Try to fetch cached item with "welcome_message" key
$CachedString = $objFilesCache->getItem($key);
```

如果缓存中不存在此对象，就将它以 60s 过期时间加入缓存，并从缓存中读取与展示它。如果它存在于缓存中，则直接获取：

```php
if (is_null($CachedString->get()))
{
    // The cached entry doesn't exist
    $numberOfSeconds = 60;
    $CachedString->set("This website uses PhpFastCache!")->expiresAfter($numberOfSeconds);
    $objFilesCache->save($CachedString);
 
    echo "Not in cache yet, we set it in cache and try to get it from cache!</br>";
    echo "The value of welcome_message:" . $CachedString->get();
}
else
{
    // The cached entry exists
    echo "Already in cache!</br>";
    echo "The value of welcome_message:" . $CachedString->get();
}
```

非常容易上手对吧！你可以试着自己去运行一下这个程序来查看结果。

当你第一次运行这个程序时，应该会看到以下输出：

```
Not in cache yet, we set it in cache and try to get it from cache!
The value of welcome_message: This website uses PhpFastCache!
```

之后再运行的时候，输出会是这样：

```
Already in cache!
The value of welcome_message: This website uses PhpFastCache!
```

现在就能随手实现文件系统缓存了。在下一章节中，我们将模仿这个例子来使用 Redis Adapter 实现缓存。

### 使用 Redis Adapter 进行缓存

假定你在阅读本节前已经安装好了 Redis 服务，并让它运行在 6379 默认端口上。

下面进行配置。创建 **redis_cache_example.php** 文件并写入以下代码：

```php
<?php
/**
 * redis_cache_example.php
 *
 * Demonstrates usage of phpFastCache with "redis" adapter
 *
 * Make sure php-redis extension is installed along with Redis server.
 */
 
// Include composer autoloader
require __DIR__ . '/vendor/autoload.php';
 
use phpFastCache\CacheManager;
 
// Init default configuration for "redis" adapter
CacheManager::setDefaultConfig([
  "host" => '127.0.0.1',
  "port" => 6379
]);
 
// Get instance of files cache
$objRedisCache = CacheManager::getInstance('redis');
 
$key = "welcome_message";
 
// Try to fetch cached item with "welcome_message" key
$CachedString = $objRedisCache->getItem($key);
 
if (is_null($CachedString->get()))
{
    // The cached entry doesn't exist
    $numberOfSeconds = 60;
    $CachedString->set("This website uses PhpFastCache!")->expiresAfter($numberOfSeconds);
    $objRedisCache->save($CachedString);
 
    echo "Not in cache yet, we set it in cache and try to get it from cache!</br>";
    echo "The value of welcome_message:" . $CachedString->get();
}
else
{
    // The cached entry exists
    echo "Already in cache!</br>";
    echo "The value of welcome_message:" . $CachedString->get();
}
```

如你所见，除了初始化 Redis 适配器的配置一段之外，这个文件与之前基本一样。

```php
// Init default configuration for "redis" adapter
CacheManager::setDefaultConfig([
  "host" => '127.0.0.1',
  "port" => 6379
]);
```

当然如果你要在非本机运行 Redis 服务，需要根据需求修改 host 与 port 的设置。

运行 **redis_cache_example.php** 文件来查看它的工作原理。你也可以在 Redis CLI 中查看输出。

```
127.0.0.1:6379> KEYS *
1) "welcome_message"
```

以上就是使用 Redis 适配器的全部内容。你可以去多试试其它不同的适配器和配置！

## 总结

本文简单介绍了 PhpFastCache 这个 PHP 中非常热门的库。在文章前半部分，我们讨论了它的基本知识以及安装和配置。在文章后半部分，我们通过几个例子来详细演示了前面提到的概念。

希望你喜欢这篇文章，并将 PhpFastCache 集成到你即将开发的项目中。随时欢迎提问和讨论！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
