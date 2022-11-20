> * 原文地址：[Implementing Bitcask, a Log-Structured Hash Table](https://healeycodes.com/implementing-bitcask-a-log-structured-hash-table)
> * 原文作者：[Andrew Healey](https://healeycodes.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/implementing-bitcask-a-log-structured-hash-table.md](https://github.com/xitu/gold-miner/blob/master/article/2022/implementing-bitcask-a-log-structured-hash-table.md)
> * 译者：
> * 校对者：

# Implementing Bitcask, a Log-Structured Hash Table

[Bitcask](https://en.wikipedia.org/wiki/Bitcask) is an application for storing and retrieving key/value data using log-structured hash tables. It stores keys and metadata in memory with the values on disk. Retrieving a value is fast because it requires a single disk seek.

The key benefits are:

* Low latency per item read or written
* Consistent performance
* Handles datasets larger than RAM
* Small design specification

The main drawback is:

* All your keys must fit in RAM

Over the weekend, I implemented part of Bitcask's [design specification](https://riak.com/assets/bitcask-intro.pdf) in a project called [bitcask-lite](https://github.com/healeycodes/bitcask-lite) — a key/value database and server using the Go standard library.

I needed to serve some largeish values for a side project and instead of building an MVP with something like SQLite, I [yak shaved](https://seths.blog/2005/03/dont_shave_that/) a database.

In bitcask-lite, keys and metadata live in a concurrent map based on [orcaman/concurrent-map](https://github.com/orcaman/concurrent-map) — a map of map shards. Go doesn't allow concurrent reading and writing of maps — so each map shard needs to be locked independently to avoid limiting bitcask-lite's concurrency to a single request.

```
type ConcurrentMap[V any] []*MapShard[V]

type MapShard[V any] struct {
  items map[string]V
  mu    *sync.Mutex
}
```

The database is a directory with one or many log files. Items get written to the active log file with the schema: `expire, keySize, valueSize, key, value,` (I'm a big fan of human-readable data).

An item with a key of `a` and a value of `b` that expires on 10 Aug 2022 looks like this:

```
1759300313415,1,1,a,b,
```

Log files are append-only and don't need to be locked for **getting** values but when **setting** values there's a lock on the active log file to ensure that the database is correct relative to the order of incoming requests. Unfortunately, this means that write-heavy workloads will perform worse than read-heavy ones.

I really like Go's API for reading/writing to files. For me, it's sensible, consistent, and obvious. It can be verbose (especially error handling) but I'm in the that's-a-feature camp. Sometimes it's better to be clear.

The following snippet details the hot path for handling `/get` requests. I've added some extra comments and trimmed error handling.

```
// StreamGet gets a value from a log store
func (logStore *LogStore) StreamGet(key string, w io.Writer) (bool, error) {

  // Lock the map shard
  access := logStore.keys.AccessShard(key)
  defer access.Unlock()
  item, found := logStore.keys.Get(key)

  if !found {
    // Key not found
    return false, nil
  } else if int(time.Now().UnixMilli()) >= item.expire {
    // Key found but it's expired..
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

The trickiest part of this project was parsing the log files; largely due to off-by-one errors. The algorithm I used is fairly naive. It makes too many system calls but I wanted to ship rather than optimize early. My gut says that reading into a buffer and parsing is faster but the real performance win would be parsing log files in parallel so if startup time bothers me I'll fix that first!

```
// Parsing a bitcask-lite log file

// Loop:
// - expire    = ReadBytes(COMMA)
//   - EOF error? return
// - keySize   = ReadBytes(COMMA)
// - valueSize = ReadBytes(COMMA)
// - key       = Read(keySize + 1)
// - value     = Discard(valueSize+ 1)
```

## HTTP API

I started this project with the API sketched out on a single sticky note.

```
/get?key=a
/delete?key=c
/set?key=b&expire=1759300313415
  - HTTP body is read as the value
  - expire is optional (default is infinite)
```

After finishing it, I saw there were more lines of test code than other code — which says a lot about software complexity in general. I can describe this API in a single breath but it took me a good few hours to cover every edge case with tests and fixtures.

The server code lives in `func main()` and uses plain old [net/http](https://pkg.go.dev/net/http). Since main functions can't be tested from within Go, I went with a test pattern I've used in side projects before which is a end-to-end test script written in Python that spawns a server process, hits it, and asserts things.

```
# dev command to start server
proc = subprocess.Popen(
    ["go", "run", "."], stdout=subprocess.PIPE, stderr=subprocess.STDOUT
)

# test getting a missing key
g = requests.get(f"{addr}/get?key=z")
print(g.status_code, g.text)
assert g.status_code == 404

# ^ failing asserts exit with a non-zero exit code
# which fails any continuous integration (CI) process
# or other test runner
```

## The Missing Parts

Bitcask's [design specification](https://riak.com/assets/bitcask-intro.pdf) also describes how the database can be cleaned up over time. Currently, bitcask-lite grows and grows. Expired keys live on disk forever.

Bitcask can merge several files into a more compact form and produce hintfiles for faster start up times — deleting expired keys in the process. This merge process has a slight performance hit but it can be performed during low traffic periods.

> In order to cope with a high volume of writes without performance degradation during the day, you might want to limit merging to in non-peak periods. Setting the merge window to hours of the day when traffic is low will help.

I also skipped adding CRCs (cyclic redundancy checks), and instead of setting tombstone values for my delete operation I just pretend that an key has been set to zero bytes with an expire of 1970.

```
// Set takes key, expire, value
err := logStore.Set(key, 0, []byte(""))
if err != nil {
  log.Printf("couldn't delete %s: %s", key, err)
  w.WriteHeader(500)
  return
}
```

I'm happy with the shortcuts I took. And so far, my toy database has been humming along just fine.

Sure, using SQLite with a single table would have gotten me up and going much quicker. But I mostly took this database detour for fun. I do wonder about the performance comparison between [bitcask-lite](https://github.com/healeycodes/bitcask-lite) and SQLite+server. I was about to set up some benchmarks when I couldn't figure out if you can stream individual SQLite values to a client. If you know, [let me know](mailto:healeycodes@gmail.com)!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
