> * 原文地址：[Decoding Django Sessions in PostgreSQL](https://arctype.com/blog/decoding-django-sessions-in-postgresql/)
> * 原文作者：[Daniel Lifflander](https://arctype.com/blog/author/daniel/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Decoding-Django-Sessions-in-PostgreSQL.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Decoding-Django-Sessions-in-PostgreSQL.md)
> * 译者：[Miigon](https://github.com/Miigon)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[kamly](https://github.com/kamly)

# 在 PostgreSQL 中解码 Django 会话数据

> 解决将用户的会话数据与其实际的用户对象联系起来的问题时，Postgres 变得十分好用。
## Django 中的会话

会话（session）是任何基于 HTTP 的 web 框架的重要组成部分。它使得 web 服务器可以记录重复请求的 HTTP 客户端而不需要对每一次请求重新进行认证。记录会话的方式有多种。其中的一些方法不需要你服务器持久化会话数据（如 JSON Web Tokens），而另外一些则需要。

Django，一个基于 Python 的热门 web 框架，自带了一个会存储会话数据的默认会话后端。存储和缓存的方案也有多种：你可以选择直接将会话存储在 SQL 数据库中，并且每次访问都查询一下、可以将他们存储在例如 Redis 或 Memcached 这样的缓存中、或者两者结合，在数据库之前设置缓存引擎。如果你使用这些最终将会话存储在 SQL 中的方案，则 `django_session` 表将存储你的用户会话数据。

本文中的截图来自 Arctype。

## 会话结构

细读你应用程序的数据，你可能会遇到需要将你的用户的会话数据联系到实际的用户表项（`auth_user` 表）。我最近遇到过这一情景，当我查看会话表的结构时， `user_id` 没有被作为一列数据存储在其中使我感到非常吃惊。这背后是有重要的设计选择的，但是对于像我这样的 SQL'er 来说就不太方便了。

![没有 auth_user id](https://dzone.com/storage/temp/14542364-1616177751108.png)

`session_key` 是提供给客户端的 key。一般而言，发起请求的客户端会以 cookie 的形式将 `session_key` 附带其中。当 web 服务器收到请求时，若存在 `session_key`，将发起查询来检验 key 是否已知。若是，服务器将检索与其关联的 `session_data` 并获取有关用户及会话的原数据。

这就是你可以在一个 Django 请求中访问 `request.user` 的原因。`user_id` 从解码到的 `session_data` 中获取，内建的 User 对象将根据存储的 `user_id` 被填充，在这之后在项目的视角中 User 对象就持续可用了。

谷歌了一下告诉我默认的会话数据是以 JSON 的形式存储的。我此前已经知悉了 Postgre 出色的 JSON 能力（[如果你还不知道，看一看这篇文章](https://www.arctype.com/blog/json-in-postgresql/)），因此我认为我们可以在 Postgre 的范畴内实现这一功能。这对于像我一样在 Postgres 上花了大量时间的人来说是个大好消息。

## 构建请求

### 初瞥一眼

![](https://dzone.com/storage/temp/14542365-1616177763796.png)

你可能在第一张图片中观察到，session_data 看起来不像是 JSON。以 JSON 存储的原数据被隐藏在了 [base64 编码](https://en.wikipedia.org/wiki/Base64) 之后。幸运的是，我们可以在 Postgres 中很方便地解码 base64。

### 从 Base64 解码

![](https://dzone.com/storage/temp/14542366-1616177783620.png)

已经没办法比这更可读了。我们需要将二进制数据转换成文本。

### 编码为文本

Postgres 提供的 "encode" 函数可以用来“将二进制数据编码为文本形式的表示”。

![图源：Arctype 截图](https://dzone.com/storage/temp/14542367-1616177799061.png)

现在，我们终于可以看到可以看懂的数据了。这是一个文本格式的完整的记录：

```
11fcbb0d460fd406e83b60ae082991818a1321a4:{"_auth_user_hash":"39308b9542b9305fc038d28a51088905e14246a1","_auth_user_backend":"x.alternate_auth.Backend","_auth_user_id":"52135"}
```

### 提取 JSON

我们这里得到的是一个带有某种哈希加上一个冒号作为前缀的 JSON blob。我们只对 JSON blob 感兴趣。一个快捷的提取方法是找到第一个冒号的位置，并提取其后的所有字符。

为了实现这一功能，我们可以同时使用 `RIGHT` 函数以及 `POSITION` 函数，前者返回一个 `string` 末尾的 n 个字符，后者返回字符串内某个字符的位置。`POSITION` 只会返回你的搜索目标第一次出现的位置。

`RIGHT` 函数可接收一个负索引。负的索引指从字符串右侧提取字符直到**不包括**负索引指向的那个字符。

继续构建我们的请求，我们使用 CTE 将其分成两部分。CTE 在你已经构造并选择了一列数据并且需要多次使用它时有帮助。如果我们仅用一个 `SELECT`，我们将要多次输入 `encode(decode(session_data, 'base64'), 'escape')`。这很快会变得混乱，并且如果你决定想要更改你解析编码数据的方式时，你将需要同时修改 2 处函数调用。

这是我们能够提取 JSON 部分的新请求。

![](https://dzone.com/storage/temp/14542369-1616177940789.png)

完整结果示例：

```
{"_auth_user_hash":"396db3c0f4ba3d35b350a","_auth_user_backend":"x.alternate_auth.Backend","_auth_user_id":"52646"}
```

### JSON 校验

现在列数据可以作为 JSON 解析了。然而，在 Postgres 中如果你尝试解析一个非法 JSON 文本，Postgres 会抛出一个错误并终止你的查询。在我自己的数据库中，有一些会话数据不能被作为 JSON 解析。下面是一个确保文本看起来像可解析 JSON 的便捷方法。

```sql
where
    substring(decoded, position(':' in decoded) + 1, 1) = '{'

    and right(decoded, 1) = '}'`
```

任何不以花括号开头及结尾的字符串都将被过滤掉。

这不能完全保证它可以被解析，但是对于我有几百万会话的数据库而言，它能够解决问题。你可以写一个自定义的 Postgres 函数来验证 JSON 有效性，但那样查询速度会变慢。

### JSON 转换

使用一个 `WHERE`语句来排除无效的会话元数据后，是时候将我们的字符串转换成 Postgres 的 JSON 类型并从中提取 `_auth_user_id` key 了。取决于你的 Django 配置，这个 key 可能不同。一旦一个对象被转换为 JSON 类型，你就可以使用 `object->key` 语法来请求一个 JSON 值。

![图源：Arctype 截图](https://dzone.com/storage/temp/14544372-1616178066113.png)

### 字符串清理

胜利就在眼前！当从 JSON 转换到 `text` 的时候，Postgres 会在其两端添加双引号。最终我们想要 user_id 的类型为 `int`，但 Postgres 不会将一个带有双引号的字符串转换为 `int`。就算是 JavaScript 也不允许这么干！

带有 `BOTH` 的 `TRIM` 函数会将指定的字符从字符串的两端去除，留下可以轻松转换为整数类型的干净的字符串。

## 最终的请求

这是加上去除多余的双引号并转换为 `int` 的请求：

![](https://dzone.com/storage/temp/14544375-1616178102560.png)

现在，如样例结果所示，我们成功将 `session_key` 和 Django 的 `auth_user` id 连接起来了。

这是可复制格式的完整查询语句：

```sql
with step1 as (
  select
    session_key,
    encode(decode(session_data, 'base64'), 'escape') :: text as decoded
  from
    django_session
)
select
  session_key,
  trim(
    both '"'
    from
      (
        right(
          decoded,
          0 - position(':' in decoded)
        ) :: json -> '_auth_user_id'
      ) :: text
  ) :: int as user_id
from
  step1
where
  substring(decoded, position(':' in decoded) + 1, 1) = '{'
  and right(decoded, 1) = '}'
```

## 使用实例化视图来加快查询

如果你的数据库有大量的用户，你会发现这个查询十分缓慢。创建实例化视图 (materialized view) 使得你可以从一个一致的视图中重复地请求数据，而不用重新执行 SQL 语句。

当你创建实例化视图时（以及当你刷新它时），视图对应的源代码将会被执行以生成结果用于填充视图。确保你在需要最新的数据的时候刷新一下视图！

```sql
create materialized view mv_django_session_user as
with step1 as (
…
// To refresh:
refresh materialized view mv_django_session_user;
```

## 总结

Postgres 中的编码以及字符串操作比常见的用于 web 应用的语言（如 Python、Ruby 或 PHP）来说更加繁琐些，但是用纯 Postgres 构建出一个可以快速提取你要的数据并让你可以和其他表直接连表查询的视图，不得不说是十分愉悦的。

下一次你需要从 web 框架或其他第三方提取数据时，不妨从 Postgres 寻找答案！


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
