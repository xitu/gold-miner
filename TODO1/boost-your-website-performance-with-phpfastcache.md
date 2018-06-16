> * 原文地址：[Boost Your Website Performance With PhpFastCache](https://code.tutsplus.com/tutorials/boost-your-website-performance-with-phpfastcache--cms-31031)
> * 原文作者：[Sajal Soni](https://tutsplus.com/authors/sajal-soni?_ga=2.222559131.1693151914.1529137386-2093006918.1525313549)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/boost-your-website-performance-with-phpfastcache.md](https://github.com/xitu/gold-miner/blob/master/TODO1/boost-your-website-performance-with-phpfastcache.md)
> * 译者：
> * 校对者：

# Boost Your Website Performance With PhpFastCache

In this article, we're going to explore the PhpFastCache library, which allows you to implement caching in your PHP applications. Thus, it helps to improve overall website performance and page load times.

## What Is PhpFastCache?  

PhpFastCache is a library that makes it a breeze to implement caching in your PHP applications. It's an easy-to-use and yet powerful library that provides several APIs to help you implement a caching strategy of your choice without much hassle.

Don't make the mistake of assuming that it's merely a traditional file system caching scheme. In fact, PhpFastCache supports a plethora of adapters that let you choose from high-performance back-ends like Memcache, Redis, MongoDB, CouchDB, and others.

Let's have a quick look at a couple of the most popular adapters:

*   file system
*   Memcache, Redis, and APC
*   CouchDB and MongoDB
*   Zend Disk Cache and Zend Memory Cache

If you don't find your choice of adapter in the above list, you could easily develop a custom driver that plugs into the system and works effortlessly.

In addition to the basic functionality, the PhpFastCache library also provides an event mechanism that allows you to respond to certain predefined events. For example, when something is deleted from the cache, you could catch this event and refresh or delete related data as well.

In the upcoming sections, we'll go through the installation and configuration of PhpFastCache, along with the demonstration of a few examples.

## Installation and Configuration

In this section, we'll go through the installation and configuration of the PhpFastCache library. There are different ways you could approach this in your project.

If you just want to download the **.zip** or **.tar.gz** version of the library without much hassle, you could go ahead and grab it from the [official site](https://www.phpfastcache.com/).

On the other hand, you could install it as a Composer package as well. That should be the preferred way as it makes maintenance and upgrading easier in the future. If you haven't installed Composer yet, you'll have to do that first.

Once you've installed Composer, let's go ahead and grab the PhpFastCache library using the following command.

```
$composer require phpfastcache/phpfastcache
```

Upon the successful completion of that command, you should have the vendor directory in place, which contains everything you need to run the PhpFastCache library. On the other hand, if you're missing any libraries or extensions required by the PhpFastCache library, Composer will ask you to install them first.

You should also find the `composer.json` file that looks like this:

```
{
    "require": {
        "phpfastcache/phpfastcache": "^6.1"
    }
}
```

No matter the way you've chosen to install the PhpFastCache library, the only thing that's necessary is to include the **autoload.php** file in your application to kick things off.

If you're using the Composer-based workflow, **autoload.php** is located under the **vendor** directory.

```
// Include composer autoloader
require '{YOUR_APP_PATH}/vendor/autoload.php';
```

On the other hand, if you've downloaded the **.zip** or **.tar.gz** package, **autoload.php** should be available at **src/autoload.php**.

```
// Include autoloader
require '{YOUR_APP_PATH}/src/autoload.php';
```

And with that, you're all set to start caching and gaining the benefits of the amazing PhpFastCache library. In the next section, we'll go through a couple of practical examples that demonstrate how to use PhpFastCache in your application.

## Demonstration

I've already mentioned that the PhpFastCache library supports various adapters when it comes to caching. In this section, I'll demonstrate using the file system and Redis adapters.

### Caching Using the Files Adapter

Go ahead and create the **file_cache_example.php** file with the following contents. I assume that you're using the Composer workflow and thus the **vendor** directory is at the same level as that of **file_cache_example.php**. If you've installed PhpFastCache manually, you can change the file structure accordingly.

```
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

Let's go through this to understand what each piece of code stands for. The first obvious thing is to include the **autoload.php** file and import the namespace that we intend to use.

```
// Include composer autoloader
require __DIR__ . '/vendor/autoload.php';
 
use phpFastCache\CacheManager;
```

When you're using the files cache, you're supposed to provide the directory path that holds files generated by the caching system. And that's what exactly we've configured in the following snippet.

```
// Init default configuration for "files" adapter
CacheManager::setDefaultConfig([
  "path" => __DIR__ . "/cache"
]);
```

Of course, we need to make sure the **cache** directory exists and it's writable by the web server.

Next, we instantiate the cache object and try to load the cached item with the **welcome_message** key.

```
// Get instance of files cache
$objFilesCache = CacheManager::getInstance('files');
 
$key = "welcome_message";
 
// Try to fetch cached item with "welcome_message" key
$CachedString = $objFilesCache->getItem($key);
```

If the item doesn't exist in the cache, we'll add it to the cache for 60 seconds and display it from the cache. On the other hand, if it exists in the cache, we'll just fetch it!

```
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

That was a fairly easy setup, wasn't it? In fact, you can go ahead and run the file to check the results!

When you run it for the first time, you should see the following output:

```
Not in cache yet, we set it in cache and try to get it from cache!
The value of welcome_message: This website uses PhpFastCache!
```

In the next run, the output looks something like this:

```
Already in cache!
The value of welcome_message: This website uses PhpFastCache!
```

So that was file system caching at your disposal. In the next section, we'll mimic the same example using the Redis cache adapter.

### Caching Using the Redis Adapter

Before we move ahead, I assume that you've already installed the Redis server and it's running on port 6379, which is the default port for Redis.

With that set up, let's go ahead and create the **redis_cache_example.php** file with the following contents.

```
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

As you can see, the file is pretty much the same, except the section that initializes the configuration specific to the Redis adapter.

```
// Init default configuration for "redis" adapter
CacheManager::setDefaultConfig([
  "host" => '127.0.0.1',
  "port" => 6379
]);
```

Of course, you should change the host and port settings to match your requirements if you're running a Redis server other than localhost.

Go ahead and run the **redis_cache_example.php** file to see how it works. You could also confirm it by checking the output in the Redis CLI.

```
127.0.0.1:6379> KEYS *
1) "welcome_message"
```

So that's all you need to use the Redis adapter. I would encourage you to try different adapters and their options!

## Conclusion

Today, we went through one of the most popular caching libraries for PHP—PhpFastCache. In the first half of the article, we discussed the basics along with installation and configuration. Later in the article, we went through a couple of examples to demonstrate the concepts that we discussed.

I hope you've enjoyed the article and that you will be motivated to integrate the PhpFastCache library in your upcoming projects. Feel free to post any questions and comments below!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
