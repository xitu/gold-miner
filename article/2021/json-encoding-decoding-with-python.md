> * 原文地址：[JSON encoding/decoding with Python](https://levelup.gitconnected.com/json-encoding-decoding-with-python-62a2cae63a6a)
> * 原文作者：[Martin Thoma](https://medium.com/@martinthoma)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/json-encoding-decoding-with-python.md](https://github.com/xitu/gold-miner/blob/master/article/2021/json-encoding-decoding-with-python.md)
> * 译者：
> * 校对者：

# JSON Libraries in Python - Comparing by Speed, Maturity, and Operational Safety

![Photo by [chuttersnap](https://unsplash.com/@chuttersnap?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12032/0*iesq6b2IrRZHExHL)

JSON is a cornerstone for the exchange of data on the Internet. REST APIs use the standardized message format all around the world. Being a subset of JavaScript, it got a huge initial boost in its adoption right from the start. The fact that its syntax is pretty clear and easy to read also helped.

JSON has libraries in every language I know for serialization and deserialization. In Python, there are actually multiple libraries. In this article, I will compare them for you.

## The libraries

**CPython** itself has a `[json](https://docs.python.org/3/library/json.html)` module. It was originally developed by Bob Ippolito as `simplejson` and was merged into Python 2.4 ([source](https://docs.python.org/3/whatsnew/2.6.html#the-json-module-javascript-object-notation)). CPython is licensed under the Python Software Foundation License.

**simplejson** still exists as its own library and you can install it via pip. It is a pure Python library with an optional C extension. Simplejson is licensed under the MIT and the Academic Free License (AFL) license.

[**ujson**](https://pypi.org/project/ujson/) is a binding to the C library [Ultra JSON](https://github.com/ultrajson/ultrajson). Ultra JSON was developed by ESN ([an Electronic Arts Inc. studio](https://techcrunch.com/2012/09/26/electronic-arts-buys-online-gaming-development-studio-esn/)) and is licensed under the [3-clause BSD License](https://tldrlegal.com/license/bsd-3-clause-license-(revised)). Ultra JSON has 3k stars on Github, 305 forks, 50 contributors, the last commit is only 12 days old and the last issue was opened 5 days ago. I’ve heard that it is in “maintenance mode” ([source](https://github.com/ultrajson/ultrajson/issues/428#issuecomment-699456053)), indicating that there is no new development.

**pysimdjson** is a binding to the C++ library [simdjson](https://github.com/simdjson/simdjson). SIMDjson received funding from Canada. simdjson has 12.2k stars on Github, 611 forks, 63 contributors, the last commit was 11 hours ago, and the last issue was opened 2 hours ago.

**python-rapidjson** is a binding to the C++ library [RapidJSON](https://github.com/Tencent/rapidjson). RapidJSON was developed by [Tencent](https://en.wikipedia.org/wiki/Tencent). RapidJSON has 9.8k stars on GitHub, 2.7k forks, 150 contributors, the last commit was about 2 months ago and the last issue was opened 17 days ago.

[**orjson**](https://pypi.org/project/orjson/) is a Python package that relies on Rust to do the heavy lifting.

## Maturity and Operational Safety

All mentioned libraries worked for the benchmark examples without issues. Switching the JSON module is not a super big deal, but still, I want to know that the module is supported.

CPython, simplejson, ujson, and orjson consider themselves production-ready.

python-rapidjson marks itself as alpha, but one maintainer says that is a mistake and will be fixed soon ([source](https://github.com/python-rapidjson/python-rapidjson/issues/140#issuecomment-699475354)).

![Image by Martin Thoma](https://cdn-images-1.medium.com/max/3052/1*U5_u-RSFKJonoiyITzMzAg.png)

## The Questions

One indicator of how easy it might be to resolve problems is to ask questions and see how the behavior is:

* [SimpleJSON](https://github.com/simplejson/simplejson/issues/267): I’ve got a response the next day. The response was clear, easy to follow, friendly. [Bob Ippolito](undefined) answered me — the guy who originally developed it and who also is mentioned in the Python docs for the JSON module!
* [uJSON](https://github.com/ultrajson/ultrajson/issues/428): I’ve got a clear, friendly, easy to follow answer within 30 minutes. @hugovank
* [ORJSON](https://github.com/ijl/orjson/issues/127): No reaction for 10days, then it was closed without any comment.
* [PySIMDJSON](https://github.com/TkTech/pysimdjson/issues/54): No answer after 15days.
* [Python-RapidJSON](https://github.com/python-rapidjson/python-rapidjson/issues/140): I’ve got a clear, friendly, easy to follow answer within 30 minutes. A [simple PR](https://github.com/python-rapidjson/python-rapidjson/pull/143) was merged after ten days.

One answer I’ve got for all of the projects is that they are essentially not in contact with each other.

## The Benchmark

In order to benchmark the different libraries properly, I thought of the following scenarios:

* **APIs**: Web services that exchange information. It might contain Unicode and have a nested structure. A JSON file from a Twitter API sounds good to test this.
* **API JSON Error**: I was curious about how the performance would change if there was an error in the JSON API format. So I removed a brace in the middle.
* **GeoJSON**: I’ve first seen [the GeoJSON format](https://en.wikipedia.org/wiki/GeoJSON) with [Overpass Turbo](https://overpass-turbo.eu/), an Open Streep Map exporter. You will get crazy big JSON files with mostly coordinates, but also pretty nested.
* **Machine Learning**: Just a massive list of floats. Those might be weights of a neural network layer.
* **JSON Line**: Structured logs are heavily used in the industry. If you analyze those logs, you might need to go through Gigabytes of data. They are all simple dictionaries with a datetime object, a message, the logger, log status, and maybe some more.

#### Deserialization Speed

The speed of my hard drive gives a lower boundary for the speed to read. I’ve included it as a baseline in the following 3 charts.

![Image created by Martin Thoma](https://cdn-images-1.medium.com/max/4800/1*T6ZZEdyTdAfk2H7ZUROXQw.png)

![Image created by Martin Thoma](https://cdn-images-1.medium.com/max/4800/1*l9edlCf_jRRmfk2c3E6sTQ.png)

![Image created by Martin Thoma](https://cdn-images-1.medium.com/max/4800/1*mdU1HzX6SvyPmRQxvT267w.png)

![Image created by Martin Thoma](https://cdn-images-1.medium.com/max/4800/1*dF6H5_XkF0B0zYFohYh8Fg.png)

![Image created by Martin Thoma](https://cdn-images-1.medium.com/max/4800/1*UvxjYlDcM507RIVBytu78w.png)

The conclusion from this:

* Rapidjson is slow, but for small JSONs like the twitter.json, you will not notice a difference. One can see this with the structured logs.
* simdjson, orjson, and ujson are all crazy fast.
* Reading a JSON file that contains a structural error is equally fast for most libraries. A notable exception is rapidjson. I guess that it aborts reading the file once it finds the error.

#### Serialization Speed

In this case, I created the JSON-String beforehand and measured the time it takes to write it to disk as a baseline.

![Image by Martin Thoma](https://cdn-images-1.medium.com/max/4800/1*li98MCygc3bb3CNeM6UmiQ.png)

![Image by Martin Thoma](https://cdn-images-1.medium.com/max/4800/1*H-6Jn-siAFZol3zaMK3tZQ.png)

![Image by Martin Thoma](https://cdn-images-1.medium.com/max/4800/1*euOrrhI4Ds2-rXc3I0MlBg.png)

![Image created by Martin Thoma](https://cdn-images-1.medium.com/max/4800/1*vE2gNIkOy7087tGdeX0ZTA.png)

What I conclude from this:

* orjson is just insanely fast. It is super close to maxing out my hard drive. And ujson is pretty close to that.
* rapidjson is pretty quick, but not on the same level as orjson or ujson.
* simdjson is slow.

## A professional workflow with JSON

As a closing note, I want to point out some issues I see sometimes and have written myself:

* Calling variables `foo_json` : JSON is a string format. If it’s not a string, it’s not JSON. If you deserialized a JSON with `bar = json.loads(foo)` , then `bar` is not a JSON. You can serialize `bar` to a JSON which is equivalent to the JSON`foo` , but `bar` is not a JSON. It’s a Python object. Very likely a dictionary. You can then all it `foo_dict` .
* Attribute checks all over the place: If you receive a JSON, it’s super easy to convert it to a Python object (e.g. a dict) and use it. This is fine for proof-of-concept code or very small JSON strings. It will bite you in the ass if you don’t convert it to something like a [dataclass](https://docs.python.org/3/library/dataclasses.html).

[pydantic](https://github.com/samuelcolvin/pydantic) is a super helpful validation library. You can take the JSON-string, parse it to a Python base representation with dictionaries / lists / strings / numbers / booleans with your favorite JSON library and then parse it again with Pydantic. The advantage you get from this is that you know what you’re dealing with later. No longer just `Dict[str, Any]` as a [type annotation](https://medium.com/analytics-vidhya/type-annotations-in-python-3-8-3b401384403d). No longer unhelpful editor autocompletion. No longer checking if attributes exist all over your code.

To include other json packages than the default `json` , I recommend the pattern

```py
import ujson as json
```

For Flask, you can use another [encoder](https://flask.palletsprojects.com/en/1.1.x/api/#flask.json.JSONEncoder)/[decoder](https://flask.palletsprojects.com/en/1.1.x/api/#flask.json.JSONDecoder) like this:

```py
from simplejson import JSONEncoder, JSONDecoder

app.json_encoder = JSONEncoder
app.json_decoder = JSONDecoder
```

## See also

* [Daniel Lemire](undefined): [Parsing JSON Really Quickly: Lessons Learned](https://www.youtube.com/watch?v=wlvKAT7SZIQ) at InfoQ
* [Ng Wai Foong](undefined): [Introduction to orjson](https://levelup.gitconnected.com/introduction-to-orjson-3d06dde79208)
* [Nicolas Seriot](undefined): [Parsing JSON is a Minefield](http://seriot.ch/parsing_json.php)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
