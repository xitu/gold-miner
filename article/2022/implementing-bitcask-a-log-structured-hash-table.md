> * 原文地址：[Implementing Bitcask, a Log-Structured Hash Table](https://healeycodes.com/implementing-bitcask-a-log-structured-hash-table)
> * 原文作者：[Andrew Healey](https://healeycodes.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/implementing-bitcask-a-log-structured-hash-table.md](https://github.com/xitu/gold-miner/blob/master/article/2022/implementing-bitcask-a-log-structured-hash-table.md)
> * 译者：[wangxuanni](https://github.com/wangxuanni)
> * 校对者：[Quincy_Ye](https://github.com/Quincy-Ye)，[CompetitiveLin](https://github.com/CompetitiveLin)

# 实现 Bitcask ，一种日志结构的哈希表

[Bitcask](https://en.wikipedia.org/wiki/Bitcask) 是一种使用日志结构哈希表，用于存储和检索数据的应用。它将键和元数据存储在内存里，将值存储在磁盘里。检索值的速度很快，因为它只需要一次磁盘寻址。

主要的好处是：

* 每一个数据低延时的读取或写入
* 一致的性能
* 能处理大于 RAM 的数据集
* 设计规格小

主要的缺点是：

* 所有的键都必须放进 RAM

周末，我在一个名为 [bitcask-lite](https://github.com/healeycodes/bitcask-lite) 的项目（一个使用 Go 标准库的键/值数据库和服务器）中实现了 Bitcask 的部分[设计规范](https://riak.com/assets/bitcask-intro.pdf)。

我需要为一个其他项目提供一些值较大的数据，而不是使用 SQLite 之类的东西构建最小可行产品，我[在前人的基础上修补了](https://seths.blog/2005/03/dont_shave_that/)一个数据库。

在 bitcask-lite 中，键和元数据存在于基于 [orcaman/concurrent-map](https://github.com/orcaman/concurrent-map) 的并发映射中 —— 映射分片的映射。Go 不允许并发地读取和写入映射 —— 因此每个映射分片都需要独立锁定，以避免将 bitcask-lite 的并发限制为单个请求。

```
type ConcurrentMap[V any] []*MapShard[V]

type MapShard[V any] struct {
  items map[string]V
  mu    *sync.Mutex
}
```

这个数据库是包含一个或者多个日志文件的目录。数据使用 schema 写入活跃日志文件：`expire, keySize, valueSize, key, value,`（我是人类可读数据的忠实拥护者）。

键为`a`，值为`b`，于 2022 年 8 月 10 日到期的数据如下所示：[]()

```
1759300313415,1,1,a,b,
```

日志文件是 append-only （只许追加），所以不需要为**获取**值而上锁，但是当**设置**值时，会为活跃日志文件上一个锁，以确保数据库相对于传入请求的顺序是正确的。不幸地是，这意味着大量写的负载将比大量读的负载表现更差。

我真的很喜欢 Go 用于读取/写入文件的 API。对我来说，这是明智的、一致的和显而易见的。它可以是很冗长的（尤其是错误处理），但我认为那是个特点。有时候表达清晰会更好。

以下代码段详细说明了处理`/get`请求的热路径。我添加了一些额外的注释并减少了错误处理。

```
// StreamGet 从一个日志存储里获取一个值
func (logStore *LogStore) StreamGet(key string, w io.Writer) (bool, error) {

  // 锁住这个 map 分片
  access := logStore.keys.AccessShard(key)
  defer access.Unlock()
  item, found := logStore.keys.Get(key)

  if !found {
    // Key 没找到
    return false, nil
  } else if int(time.Now().UnixMilli()) >= item.expire {
    // Key 找到了但是过期了
    // so we can clean it up (aka lazy garbage collection!)
    logStore.keys.Delete(key)
    return false, nil
  }

  f, err := os.Open(item.file)
  // ..
  defer f.Close()

  // Set the offset for the upcoming read
  _, err = f.Seek(int64(item.valuePos), 0)
  // ..

  // Pipe it to the HTTP response
  _, err = io.CopyN(w, f, int64(item.valueSize))
  // .. 
  return true, nil
}
```

这个项目最棘手的部分是解析日志文件；主要是由于差一错误。我使用的算法相当幼稚。它进行了太多的系统调用，但我想尽早发布而不是优化。我的直觉是读入缓冲区因此解析速度更快，但真正的性能胜利是并行解析日志文件，所以如果启动时间困扰了我，我会优先解决这个问题！

```
// 解析一个 bitcask-lite 的日志文件

// Loop:
// - expire    = ReadBytes(COMMA)
//   - EOF error? return
// - keySize   = ReadBytes(COMMA)
// - valueSize = ReadBytes(COMMA)
// - key       = Read(keySize + 1)
// - value     = Discard(valueSize+ 1)
```

## HTTP API

我在一张便利贴上草拟了一下 API 就开始了这个项目。

```
/get?key=a
/delete?key=c
/set?key=b&expire=1759300313415
  - HTTP body is read as the value
  - expire is optional (default is infinite)
```

完成之后，我看到测试代码的行数超过了其他的代码。这大体上说明了软件的复杂度。我可以一口气描述这个 API，但我花了好几个小时来用测试和修复来覆盖每个边界值用例。

服务器代码位于`func main()`并使用普通的旧 [net/http](https://pkg.go.dev/net/http) 。由于无法从 Go 中测试主要功能，我使用了一个我之前在其实项目中使用过的测试模式，它是一个用 Python 编写的端到端的测试脚本，它生成一个服务器进程，点击它，然后可以进行断言测试。

```
# 用 dev 命令去启动服务器
proc = subprocess.Popen(
    ["go", "run", "."], stdout=subprocess.PIPE, stderr=subprocess.STDOUT
)

# 测试获取一个缺失的键
g = requests.get(f"{addr}/get?key=z")
print(g.status_code, g.text)
assert g.status_code == 404

# ^ 失败断言以非零退出代码退出
# 导致任何持续集成 (CI) 流程失败
# 或其他测试运行器
```

## 缺失的部分

Bitcask 的[设计规范](https://riak.com/assets/bitcask-intro.pdf)还描述了如何随着时间的推移清理数据库。现在，bitcask-lite 越来越大。过期的数据们永远存在于磁盘上。

Bitcask 可以将多个文件合并成更紧凑的形式，并生成提示文件以加快启动时间 —— 在此过程中删除过期的密钥。此合并过程对性能有轻微影响，但可以在低流量期间执行。

> 为了在白天处理大量写入而不降低性能，您可能希望将合并限制在非高峰期。将合并窗口设置为一天中流量较低的时间会有所帮助。

我还跳过了添加 CRC（循环冗余校验），我不是设置逻辑删除值，我只是假装一个密钥已设置为零字节，过期时间为 1970 年。

```
// Set 处理 key, expire, value
err := logStore.Set(key, 0, []byte(""))
if err != nil {
  log.Printf("couldn't delete %s: %s", key, err)
  w.WriteHeader(500)
  return
}
```

我对我走的捷径很满意。到目前为止，我的“玩具”数据库一直运转良好。

当然，将 SQLite 与单个表一起使用会更快。但我主要是为了好玩写这个数据库。我确实想好奇 [bitcask-lite](https://github.com/healeycodes/bitcask-lite) 和 SQLite + server 之间的性能变化。当我无法弄清楚是否可以将单个 SQLite 值流式传输到客户端时，我准备设置一些基准。如果你知道，请[告诉我](mailto:healeycodes@gmail.com)！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
