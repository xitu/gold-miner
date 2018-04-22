> * 原文地址：[Build a bikesharing app with Redis and Python](https://opensource.com/article/18/2/building-bikesharing-application-open-source-tools)
> * 原文作者：[Tague Griffith](https://opensource.com/users/tague)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/building-bikesharing-application-open-source-tools.md](https://github.com/xitu/gold-miner/blob/master/TODO1/building-bikesharing-application-open-source-tools.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[Raoul1996](https://github.com/Raoul1996)、[rydensun](https://github.com/rydensun)

# 用 Redis 和 Python 构建一个共享单车的 app

## 了解如何使用 Redis 和 Python 构建位置感知应用程序。

![google bikes on campus](https://opensource.com/sites/default/files/styles/image-full-size/public/lead-images/google-bikes-yearbook.png?itok=BnmInwea "google bikes on campus")

图片来源： [Travis Wise](https://www.flickr.com/photos/photographingtravis/15720889480). CC BY-SA 2.0

虽然我经常出差，但我不太喜欢开车，所以当我有空的时候，我更喜欢在城市里散步或骑自行车。我出差去过的许多城市都有自行车租赁系统，可以让你租几个小时的自行车。这些系统中的大多数都有一个应用程序来帮助用户定位和租赁他们的自行车，但对于像我这样的用户来说，有一个单独的地方来获取城市中所有可供租赁的自行车的信息会更有帮助。

为了解决这个问题并开源向 Web 应用程序添加位置感知特性的能力，我结合了公开可用的共享单车数据、[Python](https://www.python.org/) 编程语言和开源 [Redis](https://redis.io/) 内存数据结构服务器来索引并查询地理空间数据。

由此产生的共享单车应用程序集成了来自许多不同共享系统的数据，包括在纽约市的 [Citi Bike](https://www.citibikenyc.com/) 共享单车。它利用了 Citi Bike 系统提供的通用共享单车数据流，并使用其数据演示了可以使用 Redis 建立的一些功能来索引地理空间数据。Citi Bike 数据是根据 [Citi Bike 数据许可协议](https://www.citibikenyc.com/data-sharing-policy)提供的。

## 通用共享单车数据流规范

通用共享单车数据流规范（GBFS）是由[北美共享单车协会](http://nabsa.net/ )开发的[开源数据规范](https://github.com/NABSA/gbfs)，目的是让地图和交通类应用程序更轻易地将共享单车系统添加到它们的平台中。目前世界上有 60 多个不同的共享系统在使用该规范。

数据流由包含有关系统状态信息的几个简单 [JSON](https：//www.json.org/) 数据文件组成。数据流从引用子数据流数据的 URL 的顶级 JSON 文件开始：

```
{
    "data": {
        "en": {
            "feeds": [
                {
                    "name": "system_information",
                    "url": "https://gbfs.citibikenyc.com/gbfs/en/system_information.json"
                },
                {
                    "name": "station_information",
                    "url": "https://gbfs.citibikenyc.com/gbfs/en/station_information.json"
                },
                . . .
            ]
        }
    },
    "last_updated": 1506370010,
    "ttl": 10
}
```

第一步是将 system_information 和 station_information 中，数据流有关共享单车站点的信息的数据加载到 Redis 里。

 `system_information` 数据流系统 ID，这是一个可用于 Redis 密钥创建命名空间的短代码。GBFS 规范没有指定系统 ID 的格式，但保证它是全局唯一的。对于系统 ID，许多共享单车数据流都是使用简短的名称，如 coast_bike_share、boise_greenbike 或者 topeka_metro_bikes。另一些使用熟悉的地理缩写，如 NYC 或 BA，其中一个使用通用唯一标识符（UUID）。共享单车应用程序使用标识符作为前缀来构造给定系统的唯一密钥。

`Station_Information` 数据流提供了组成系统的关于共享站点的静态信息。站点由带有多个字段的 JSON 对象表示。在站点对象中有几个必填字段，它们提供真实站点的 ID、名称和位置。还有几个可选字段提供的有用信息，如最近的十字路口或所接受的付款方式。这是共享单车应用程序这部分的主要信息来源。

## 创建数据库

 我写了一个示例应用程序 —— [load_station_data.py](https://gist.github.com/tague/5a82d96bcb09ce2a79943ad4c87f6e15)，它模拟了从外部源加载数据的后端过程中可能发生的情况。

## 查找共享单车站点

从 [Github 的 GBFS 仓库](https://github.com/NABSA/gbfs)的 [systems.csv](https://github.com/NABSA/gbfs/blob/master/systems.csv) 文件加载共享单车数据。

仓库的 [systems.csv](https://github.com/NABSA/gbfs/blob/master/systems.csv) 文件为注册的共享单车系统提供了一个带有可用的 GBFS 数据流发现 URL。发现 URL 是处理共享单车信息的起点。

 `load_station_data` 应用程序获取系统文件中发现的每个 URL，并使用它查询两个数据流 URL：系统信息和站点信息。系统信息数据流提供了一条关键信息：系统的唯一 ID。（**注意：systems.csv 文件也提供了系统 ID，但是该文件中的一些标识符与提要中的标识符不匹配，因此我总是从反馈中获取标识符。**）系统的详细信息，比如共享单车 URL、电话号码和电子邮件。可以添加到应用程序的未来版本中。 因此使用键 `${system_id}:system_info` 将数据存储在 Redis 散列中。

## 加载站点数据

站点信息提供系统中每个站点的数据，包括系统的位置。`load_station_data` 应用程序迭代站点反馈中的每个站点，使用形如 `${system_id}:station:${station_id}` 的键将每个站点的数据存到 Redis 散列中。使用 `GEOADD` 命令将每个站点的位置添加到共享单车的地理空间索引中。

## 更新数据

在随后的运行中，我不希望代码从 Redis 中删除所有数据流数据再将其重新加载到一个空的 Redis 数据库中，因此我仔细考虑了如何处理数据的本地更新。

代码首先载入已经被系统加载到内存中的所有共享单车站点信息的数据集。当为站点加载信息时，从站点的内存集中删除站点(按键)。一旦加载了所有站点数据，我们就会得到一个包含了该系统必须删除的所有站点的数据集合。

应用程序迭代这组站点并创建一个事务来删除站点信息，从地理空间索引中删除站点键，并从系统的站点列表中删除站点。

## 代码注释

在[示例代码](https://gist.github.com/tague/5a82d96bcb09ce2a79943ad4c87f6e15)中有一些有趣的事情需要注意。首先，使用 `GEOADD` 命令将词条添加到地理空间索引中，但是用 `ZREM` 命令删除。由于地理空间类型底层实现使用排序集，因此使用 `ZREM` 删除词条。请注意，为了简洁，示例代码演示了如何使用单个 Redis 节点；如果在集群环境中运行，需要对事务模块进行重构。

如果您使用的是 Redis 4.0 （或者更高版本），则在代码中有一些 `DELETE` 和 `HMSET` 命令的替代方法。Redis 4.0 提供[`UNLINK`](https://redis.io/commands/unlink) 命令作为 `DELETE` 命令的异步替代。`UNLINK` 将从密钥空间中删除密钥，但它在单独的线程中回收内存。[`HMSET`](https://redis.io/commands/hmset) 命令在 [Redis 4.0 中被弃用，`HSET` 命令现在是可变的](https://raw.githubusercontent.com/antirez/redis/4.0/00-RELEASENOTES)（也就是说，它接受数目不定的参数）。

## 通知客户端

在流程结束时，将根据我们的数据向客户端发送通知。使用 Redis pub/sub 机制，通知通过 `geobike：Station_Changed` 通道发送，并带有系统的 ID。

## 数据模型

在用 Redis 构造数据时，要考虑的最重要的事情是如何查询信息，共享单车应用程序需要支持的两个主要查询是：

*   找到附近站点
*   显示站点相关信息

Redis 提供两种用于存储数据的主要数据类型：散列和排序集。[散列类型](https://redis.io/topics/data-types#Hashes) 很好地映射到表示站点的 JSON 对象；由于 Redis 散列不强制执行模式，因此可以使用它们存储可变站点信息。

当然，在地理上寻找站点需要一个地理空间索引来搜索相对于某些坐标的地点。Redis 提供[一些命令](https://redis.io/commands#geo)来使用[排序集](https://redis.io/topics/data-types-intro#redis-sorted-sets)数据结构构建地理控件索引。

我们使用 `${System_id}：Station：${Station_id}` 格式的散列构造密钥，其中包含站点和密钥的信息，使用的 `${System_id}：Station：Location` 格式来查询站点的地理空间索引。

## 获取用户位置

构建应用程序的下一步是确定用户的当前位置。大多数应用程序通过操作系统提供的内置服务来实现这一点。该操作系统可以为应用程序提供基于内置于设备中的 GPS 硬件或近似于设备的可用 WiFi 网络的位置。

## 查询位置

在找到用户的位置后，下一步是定位附近的共享单车站点。Redis 的地理空间功能可以在用户当前坐标的给定距离内返回站点的信息。下面是一个使用 Redis 命令行接口的示例。

![Apple 美国纽约店地址](https://opensource.com/sites/default/files/styles/panopoly_image_original/public/u128651/rediscli_map.png?itok=icqk5543 "Apple 纽约店店址地图")

想象我在纽约市第五大道上的苹果店，我想去西区 37 街的 Mood，和我的好友 [Swatch](https://twitter.com/swatchthedog) 聊天。我可以乘出租车或地铁，但我宁愿骑自行车。附近有共享站点么？我可以在那里租有一辆车去么？

Apple 专卖店位于 40.76384, -73.97297。根据地图，两个自行车站点 —— Grand Army Plaza 和 Central Park South 和 East 58th St. & Madison —— 位于 500 英尺的范围内（在以上地图是蓝色的）。

我可以使用 Redis `GEORADIUS` 命令查询纽约系统索引，查找半径为 500 英尺的站点：

```
127.0.0.1:6379> GEORADIUS NYC:stations:location -73.97297 40.76384 500 ft
1) "NYC:station:3457"
2) "NYC:station:281"
```

Redis 使用地理空间索引中的元素作为特定站点的元数据的键，返回在该半径内找到的两个自行车共享位置。下一步是查找这两个站点的名称：

```
127.0.0.1:6379> hget NYC:station:281 name
"Grand Army Plaza & Central Park S"
 
127.0.0.1:6379> hget NYC:station:3457 name
"E 58 St & Madison Ave"
```

这些键对应以上地图确定的站台。如果愿意，我可以在 `GEORADIUS` 命令中添加更多的标志，以获取元素的列表、它们的坐标以及它们与当前站点的距离：

```
127.0.0.1:6379> GEORADIUS NYC:stations:location -73.97297 40.76384 500 ft WITHDIST WITHCOORD ASC 
1) 1) "NYC:station:281"
   2) "289.1995"
   3) 1) "-73.97371262311935425"
      2) "40.76439830559216659"
2) 1) "NYC:station:3457"
   2) "383.1782"
   3) 1) "-73.97209256887435913"
      2) "40.76302702144496237"
```

查找与这些键相关联的名称会生成一个有序的站点列表，我可以从中进行选择。Redis 不提供方向或路由功能，因此我使用设备操作系统的路由功能来绘制从当前位置到所选自行车站点的路线。

`GEORADIUS` 函数可以轻易在您喜欢的开发框架的 API 中实现，以便将位置功能添加到 app 中。 

## 其他查询命令

除了 `GEORADIUS` 命令以外，Redis 还提供了三个用于从索引中查找数据的命令 `GEOPOS`、`GEODIST` 和 `GEORADIUSBYMEMBER`。

 `GEOPOS` 命令可以从地理散列中提供给定元素的坐标。例如，如果我知道在 West 38th and 8th 有共享单车站点，而且它的 ID 是 523，那么该站点的元素名称是 NYC:station:523。使用 Redis，我可以找到站点的经度和维度：

```
127.0.0.1:6379> geopos NYC:stations:location NYC:station:523
1) 1) "-73.99138301610946655"
   2) "40.75466497634030105"
```

`GEODIST` 命令提供两个元素之间的距离索引。如果我想要找出 Grand Army Plaza 和 Central Park South 和在 East 58th St. & Madison 站点之间的距离, 我会发出以下命令：

```
127.0.0.1:6379> GEODIST NYC:stations:location NYC:station:281 NYC:station:3457 ft
"671.4900"
```

最后，`GEORADIUSBYMEMBER` 命令类似于 `GEORADIUS` 命令，但该命令没有接受一组坐标，而是取索引的另一个成员的名称，并返回以该成员为中心所给定半径内的所有成员。要找到 Grand Army Plaza 和 Central Park 南 1000 英尺范围内的所有车站，请输入以下内容：

```
127.0.0.1:6379> GEORADIUSBYMEMBER NYC:stations:location NYC:station:281 1000 ft WITHDIST
1) 1) "NYC:station:281"
   2) "0.0000"
2) 1) "NYC:station:3132"
   2) "793.4223"
3) 1) "NYC:station:2006"
   2) "911.9752"
4) 1) "NYC:station:3136"
   2) "940.3399"
5) 1) "NYC:station:3457"
   2) "671.4900"
```

虽然这个示例侧重于使用 Python 和 Redis 来解析数据并构建自行车共享系统位置的索引，但它可以很容易地推广到定位餐馆、公共交通或任何其他类型的地方，以帮助用户查找。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
