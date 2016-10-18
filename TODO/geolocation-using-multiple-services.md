>* 原文链接 : [Geolocation using multiple services](https://blog.garage-coding.com/2016/07/06/geolocation-using-multiple-services.html)
* 原文作者 : [wsdookadr](https://github.com/wsdookadr)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [emmiter](https://github.com/emmiter/)
* 校对者: [a-voyager](https://github.com/a-voyager), [jamweak](https://github.com/jamweak)

# 基于多种服务的地理位置查询系统

## 简介

我的[这篇](https://blog.garage-coding.com/2015/12/24/out-on-the-streets.html)文章讨论了 [PostGIS](http://postgis.net/) 以及查询地理数据的几种方法。这篇文章将集中讨论构建一个免费的地理服务系统，并聚合呈现结果。

## 概述

总的来说，我们将会向不同的网络服务(或APIs)发起请求，对响应结果做[反向地理编码](https://blog.garage-coding.com/2016/07/06/geolocation-using-multiple-services.html)后再聚合展示。![](http://ac-Myg6wSTV.clouddn.com/2442a3bd132f453eb9eb.png)

## 比较 [Geonames](http://www.geonames.org/) 和 [OpenStreetMap](https://www.openstreetmap.org/#map=5/51.500/-0.100)

下表罗列了二者之间的部分差别:

![](http://ww1.sinaimg.cn/large/a490147fgw1f5raumu7jtj20gw09ujt1.jpg)

二者用途不同。Geonomes 用于城市/行政区/国家数据，可被用于[地理编码](http://www.geonames.org/export/geonames-search.html)。OpenStreetMap 拥有更加详尽的数据(使用者基本上都可以从 OpenStreetMap 中提取出Geonames数据)，这些数据可被用作地理编码，路线规划以及[这些](http://wiki.openstreetmap.org/wiki/Applications_of_OpenStreetMap)和[基于 OpenStreetMap 的服务](http://wiki.openstreetmap.org/wiki/List_of_OSM-based_services)。

## 发送给地理位置服务的异步请求

我们使用 [gevent](http://www.gevent.org/) 库来向地理位置服务发起异步请求。

    import gevent
    import gevent.greenlet
    from gevent import monkey; gevent.monkey.patch_all()
    
    geoip_service_urls=[
            ['geoplugin'    , 'http://www.geoplugin.net/json.gp?ip={ip}' ],
            ['ip-api'       , 'http://ip-api.com/json/{ip}'              ],
            ['nekudo'       , 'https://geoip.nekudo.com/api/{ip}'        ],
            ['geoiplookup'  , 'http://api.geoiplookup.net/?query={ip}'   ],
            ]
    
    # fetch url in asynchronous mode (makes use of gevent)
    def fetch_url_async(url, tag, timeout=2.0):
        data = None
        try:
            opener = urllib2.build_opener(urllib2.HTTPSHandler())
            opener.addheaders = [('User-agent', 'Mozilla/')]
            urllib2.install_opener(opener)
            data = urllib2.urlopen(url,timeout=timeout).read()
        except Exception, e:
            pass
    
        return [tag, data]
    
    # expects req_data to be in this format: [ ['tag', url], ['tag', url], .. ]
    def fetch_multiple_urls_async(req_data):
    
        # start the threads (greenlets)
        threads_ = []
        for u in req_data:
            (tag, url) = u
            new_thread = gevent.spawn(fetch_url_async, url, tag)
            threads_.append(new_thread)
    
        # wait for threads to finish
        gevent.joinall(threads_)
    
        # retrieve threads return values
        results = []
        for t in threads_:
            results.append(t.get(block=True, timeout=5.0))
    
        return results
    
    def process_service_answers(location_data):
        # 1) extract lat/long data from responses
        # 2) reverse geocoding using geonames
        # 3) aggregate location data
        #    (for example, one way of doing this would
        #     be to choose the location that most services
        #     agree on)
        pass
    
    def geolocate_ip(ip):
        urls = []
        for grp in geoip_service_urls:
            tag, url = grp
            urls.append([tag, url.format(ip=ip)])
        results = fetch_multiple_urls_async(urls)
        answer = process_service_answers(results)
        return answer

## 引发歧义的城市名

### 同一国家中具有相同名字的城市

同个国家里，有非常多的分属于不同州或行政区的同名城市。也有很多同名不同国的城市。例如，根据 Geonames 的数据显示，美国一共有24个名叫 Clinton 的城市(这24个城市共分布在23个州，其中有两个是在密歇根州)

    WITH duplicate_data AS (
        SELECT
        city_name,
        array_agg(ROW(country_code, region_code)) AS dupes
        FROM city_region_data
        WHERE country_code = 'US'
        GROUP BY city_name, country_code
        ORDER BY COUNT(ROW(country_code, region_code)) DESC
    )
    SELECT
    city_name,
    ARRAY_LENGTH(dupes, 1) AS duplicity,
    ( CASE WHEN ARRAY_LENGTH(dupes,1) > 9 
      THEN CONCAT(SUBSTRING(ARRAY_TO_STRING(dupes,','), 1, 50), '...')
      ELSE ARRAY_TO_STRING(dupes,',') END
    ) AS sample
    FROM duplicate_data
    LIMIT 5;

![](http://ww2.sinaimg.cn/large/a490147fgw1f5rawd6ei2j20in06n0uy.jpg)

### 同一国家，同一行政区的同名城市

从全世界范围来看，即便是在同个国家的同个行政区，都会出现多个名字完全相同的城市。就拿位于美国印第安纳州(Indiana)的乔治城(Georgetown)来说，Geonames  表明该州共有3个同名城镇。维基百科则显示了更多:

* [乔治城，弗洛伊德县，印第安纳州](https://en.wikipedia.org/wiki/Georgetown,_Floyd_County,_Indiana)

* [乔治城小镇，弗洛伊德县，印第安纳州](https://en.wikipedia.org/wiki/Georgetown_Township,_Floyd_County,_Indiana)

* [乔治城，卡斯县，印第安纳州](https://en.wikipedia.org/wiki/Georgetown,_Cass_County,_Indiana)

* [乔治城，兰道夫县，印第安纳州](https://en.wikipedia.org/wiki/Georgetown,_Randolph_County,_Indiana)
```
WITH duplicate_data AS (
    SELECT
    city_name,
    array_agg(ROW(country_code, region_code)) AS dupes
    FROM city_region_data
    WHERE country_code = 'US'
    GROUP BY city_name, region_code, country_code
    ORDER BY COUNT(ROW(country_code, region_code)) DESC
)
SELECT
city_name,
ARRAY_LENGTH(dupes, 1) AS duplicity,
( CASE WHEN ARRAY_LENGTH(dupes,1) > 9 
  THEN CONCAT(SUBSTRING(ARRAY_TO_STRING(dupes,','), 1, 50), '...')
  ELSE ARRAY_TO_STRING(dupes,',') END
) AS sample
FROM duplicate_data
LIMIT 4;
```
![](http://ww2.sinaimg.cn/large/a490147fgw1f5raxacpo0j20d505rmy4.jpg)

## 反向地理编码


(city_name, country_code),(city_name, country_code, region_name) 这两个元组都不能唯一地确定一个位置。我们可以使用邮政编码 ([zip codes](https://en.wikipedia.org/wiki/ZIP_code) 或者叫做 [postal codes](https://en.wikipedia.org/wiki/Postal_code))，除非地理位置服务不提供他们。但是大部分的地理位置服务却提供经纬度，可以使用这两者来消除歧义。

### PostgreSQL 数据库中的图形数据类型

我深入研究了 PostgreSQL 数据库的文档，发现它也拥有几何[数据类型](https://www.postgresql.org/docs/9.4/static/datatype-geometric.html)和用于2D 几何(平面几何)的[函数](https://www.postgresql.org/docs/9.4/static/functions-geometry.html)。你可以使用这些现成的数据类型和函数来模拟点，框，路径，多边形和圆并且可以将他们存储，之后还可以查询。PostgreSQL  还有一些存在于普通发布目录的[额外扩展](https://www.postgresql.org/docs/9.1/static/contrib.html)。这些扩展需要大部分 Postgres 安装后才可以使用。当下的情况，我们对[ cube 类型](https://www.postgresql.org/docs/9.4/static/cube.html) 和 [earthdistance](https://www.postgresql.org/docs/9.4/static/earthdistance.html) 扩展感兴趣，earthdistance 扩展使用 [3-cubes](https://en.wikipedia.org/wiki/Hypercube) 来存储向量和表示地球上的点。我们要用到的东西如下所示:

* `earth_distance` 函数是可用的，允许你计算球面上两点之间的最短距离 [great-circle-distance](https://en.wikipedia.org/wiki/Great-circle_distance)
* `earth_box` 函数用于检查对于给定的参考点，和给定的距离，该点是否位于该距离以内
* 一个 [gist](https://www.postgresql.org/docs/9.1/static/sql-createindex.html) [位于表达式上的索引(expression index)](https://www.postgresql.org/docs/9.4/static/indexes-expressional.html)，表达式 `ll_to_earth(lat,long)`  执行快速的空间查询以及寻找附近点。

### 为城市 & 行政区数据设计一个视图

Geonames 数据被导入到3个表中:

* `geo_geoname` (数据来自 [cities1000.zip](http://download.geonames.org/export/dump/cities1000.zip))
* `geo_admin1` (数据来自 [admin1CodesASCII.txt](http://download.geonames.org/export/dump/admin1CodesASCII.txt) )
* geo_countryinfo (数据来自 [countryInfo.txt](http://download.geonames.org/export/dump/countryInfo.txt) )

然后我们来创建一个可以将所有东西拉取到一起的视图<sup>[3](https://blog.garage-coding.com/2016/07/06/geolocation-using-multiple-services.html#fn.3)</sup>。现在我们有了人口数据，城市/行政区/国家数据以及经度/维度数据，都在同个地方了。

    CREATE OR REPLACE VIEW city_region_data AS ( 
        SELECT
            b.country AS country_code,
            b.asciiname AS city_name,
            a.name AS region_name,
            b.region_code,
            b.population,
            b.latitude AS city_lat,
            b.longitude AS city_long,
            c.name    AS country_name
        FROM geo_admin1 a
        JOIN (
            SELECT *, (country || '.' || admin1) AS country_region, admin1 AS region_code
            FROM geo_geoname
            WHERE fclass = 'P'
        ) b ON a.code = b.country_region
        JOIN geo_countryinfo c ON b.country = c.iso_alpha2
    );

### 设计一个城市周边查询函数

在大多数嵌套 `SELECT` 语句中，我们都确保城市是在以参考点为圆心，以大约23km为半径的区域内，再对结果应用国家过滤器和城市模式过滤器(这两个过滤器均为可选)，最后仅得到接近50个结果。下一步，我们用人口数据对结果重新排序，因为有时候会在较大城市附近有一些区和邻域 <sup>[4](https://blog.garage-coding.com/2016/07/06/geolocation-using-multiple-services.html#fn.4)</sup>，而 Geonames 不会用特定的方式标记他们，我们只是想选出较大的城市而不是一个区域(比如说地理位置服务返回了经纬度信息，该信息可被解析为一个较大城市的地区。于我而言，我比较愿意去把它解析成经纬度相对应的大城市)。我们也创建了一个 gist 索引(`@>` 该符号将会使用 gist 索引 )，用于寻找以参照点为圆心，特定半径范围内的点。这个查询函数接受一个点(以纬度和经度表示)作为输入，返回该输入点相关联的城市，地区和国家。

    CREATE INDEX geo_geoname_latlong_idx ON geo_geoname USING gist(ll_to_earth(latitude,longitude));
    CREATE OR REPLACE FUNCTION geo_find_nearest_city_and_region(
        latitude double precision,
        longitude double precision,
        filter_countries_arr varchar[],
        filter_city_pattern  varchar,
    ) RETURNS TABLE(
        country_code varchar,
        city_name varchar,
        region_name varchar,
        region_code varchar,
        population bigint,
        _lat double precision,
        _long double precision,
        country_name varchar,
        distance numeric
        ) AS $
    BEGIN
        RETURN QUERY
        SELECT *
        FROM (
            SELECT
            *
            FROM (
                SELECT 
                *,
                ROUND(earth_distance(
                       ll_to_earth(c.city_lat, c.city_long),
                       ll_to_earth(latitude, longitude)
                      )::numeric, 3) AS distance_
                FROM city_region_data c
                WHERE earth_box(ll_to_earth(latitude, longitude), 23000) @> ll_to_earth(c.city_lat, c.city_long) AND
                      (filter_countries_arr IS NULL OR c.country_code=ANY(filter_countries_arr)) AND
                      (filter_city_pattern  IS NULL OR c.city_name LIKE filter_city_pattern)
                ORDER BY distance_ ASC
                LIMIT 50
            ) d
            ORDER BY population DESC
        ) e
        LIMIT 1;
    END;
    $
    LANGUAGE plpgsql;

## 总结

我们从系统设计着手，让这个系统可以查询多个Geoip 服务，可以收集这些服务返回的数据对其[聚合](https://en.wikipedia.org/wiki/Aggregate_data)后得到一个更加可靠的结果。我们首先考虑了唯一确定位置的几种方式。随后选取了一种可以在确认位置时消除歧义的方法。第二部分中，我们着眼于构建，存储以及查询PostgreSQL中地理数据的不同方法。然后我们建立了一个视图和函数，用来找出参考点附近的允许我们用来进行反向编码的城市。

## 附注:

<sup>[1](https://blog.garage-coding.com/2016/07/06/geolocation-using-multiple-services.html#fnr.1)</sup> 通过使用多种服务(并且假定这些服务内部使用了不同的数据源)聚合后的结果，将会比我们只使用其中某一种服务得到的答案更为可靠。

此处还有一点优势就，我们使用了免费服务，不需要什么设置，也无需关心更新；因为这些服务都是由各自的拥有者在维护。

然而，比起查询一个本地的 geoip(基于 IP 查询的地理位置)数据结构，查询这些网络地理位置服务则会比较缓慢。好在像城市/国家/行政区这种定位数据库已经有了，例如 [MaxMind GeoIP2](https://www.maxmind.com/en/geoip2-databases), [IP2Location](http://www.ip2location.com/databases/db3-ip-country-region-city) 以及 [DB-IP](https://db-ip.com/db/#downloads) 。

<sup>[2](https://blog.garage-coding.com/2016/07/06/geolocation-using-multiple-services.html#fnr.2)</sup> 介绍一篇[好文章](http://tapoueh.org/blog/2013/08/05-earthdistance),讲述了使用 `earthdistance` 模块来计算附近或更远处酒吧的距离。

<sup>[3](https://blog.garage-coding.com/2016/07/06/geolocation-using-multiple-services.html#fnr.3)</sup> Genomes 也有 geonamelds，我们可以使用这些 genomes-specific ids 来精确匹配其位置。

<sup>[4](https://blog.garage-coding.com/2016/07/06/geolocation-using-multiple-services.html#fnr.4)</sup> Geonames 没有关于 城市/邻域的多边形数据，或者城市地区类型的元数据(参考概述中 Geonames 和 OpenStreetMap 差异对照表中 criteria 一列的数据)，所以你无法查询包含那个点的所有的城市多边形(不是指区域/邻域)。
