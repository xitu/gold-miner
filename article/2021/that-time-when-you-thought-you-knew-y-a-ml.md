> * 原文地址：[That time when you thought you knew Y(A)ML ❗ 😵](https://dev.to/alxizr/that-time-when-you-thought-you-knew-y-a-ml-5302)
> * 原文作者：[alxizr](https://dev.to/alxizr)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/that-time-when-you-thought-you-knew-y-a-ml.md](https://github.com/xitu/gold-miner/blob/master/article/2021/that-time-when-you-thought-you-knew-y-a-ml.md)
> * 译者：[finalwhy](https://github.com/finalwhy)
> * 校对者：[CristoMonte](https://github.com/CristoMonte)、[PingHGao](https://github.com/PingHGao)

# 你真的了解 Y(A)ML 吗？❗ 😵

感谢你能来阅读这篇关于 YAML 文件的文章。这是一篇关于 YAML 文件的轻量级教程。在本文中，我们将会介绍什么是 YAML，如何编写一个 YAML 文件以及我可以在哪些场景中使用 YAML 文件，但不会对某些细节介绍的太过深入。

Y(A)ML 是一种数据序列化语言，它是 JSON（javascript 对象表示法）的严格超集。它是一种面向数据的结构化语言，可以被用作各种应用程序的输入格式。我们由此可以推断出这门语言最终是以**键值对**形式表现的。YML 的设计目标，就是以最直接的方式提高可读性。

我们通常会通过与 GUI 界面的交互来使用某些工具软件，但不会意识到在这背后仅仅只有一个 YAML 文件来存储我们对于特定任务的个性化配置。今天，我们在学习这门语言的同时也会介绍几个实例。

在 YAML 中我们有两种主要的类型：**Scalar（标量）** 和 **Collection（集合）**。我们学过标量仅由描述其大小的值组成，这个概念在 YAML 中也有近似的应用。这意味着我们只能用一个唯一的键来保存一个值，如果在文件中重复使用同一个键，后一处赋值将会覆盖前一处设置的值。例如，如果我们在文件中声明了一个名为 「NAME」 的变量，并给它赋值为 「Joey」，之后。「NAME」 这个键值在整个文件中应该是唯一的，并且我们可以在文件中全局地使用它。

```yaml
# 键 : 值
NAME: Joey
```

如果我们不小心重复声明了这个变量并赋给它一个新值，例如 「Chandler」，那么（这个变量的）最后一个实例将会覆盖它的初始值。

```yaml
NAME: Joey

# ...
# 其他
# yaml
# 配置

NAME: Chandler
# 在该文件被解析的时候，只有这行对 「NAME」 的定义会真实生效。
```

一个集合（**Collection**）同样也是由**键值对**表示的，但是集合中的一个 key 可以容纳多个 value。例如下面这个姓名列表。

```yaml
# list
NAMES: ["Joey", "Chandler", "Ross", "Phoebe", "Rachel", "Monica"]
```

下面这种方法同样可以表示 NAMES 数组（译者注：又称序列或列表）：

```yaml
# list or sequence
NAMES:
  - "Joey"
  - "Chandler"
  - "Ross"
  - "Phoebe"
  - "Rachel"
  - "Monica"
```

YAML 中的集合不仅可以用数组的形式描述，也可以用映射（map）来描述。下面我们以描述一个人的邮寄地址为例，假设地址由街道名称、街道号码、城市、州、邮政编码组成。接下来让我们看看如何将这个地址转换为 YAML。为了方便，这里将选择美国某处必胜客的地址。

```yaml
# yaml 对象
address:
  street_name: North Mathilda Avenue
  street_number: 464
  city: Sunnyvale
  state: CA
  zipcode: 94085
```

如上，我们声明了一个键名为 「address」，它的值中包含了多对**键值对**。当你在编写 YAML 文件时，需要格外注意缩进。当我们想要将多个键值对组合到一个逻辑父容器时，必须使用 2 个空格进行缩进，新行必须与上一行垂直对齐，否则 YAML 文件会在执行前报错。

这种特殊的描述形式被称为一个『映射』。这个映射名为 「address」，它维护了一组通常以 **key:value** 形式表示的数据。你还可以注意到，这些值不仅可以是 'String' 类型，还可以是 'Number' 类型，包括整数和浮点数，也可以是布尔值。顺便一提，对于字符串类型的值，引号是可选的。我们还可以定义日期类型的变量，但需要注意，日期的格式必须符合 ISO 8601 规范，既：「yyyy-mm-dd hh:mm:ss:ssss」。

```yaml
# dates ISO 8601
some_date: 2018-30-09
some_datetime: 2020-10-01 09:10:30
```

因为 YAML 文件是由**键值对**组成并且是 JSON 的超集，所以我们同样可以使用 json 格式描述映射对象。

```yaml
# YAML 中的 JSON 风格映射对象
person: { name: "Johnny", age: 35, single: true }
```

就个人而言，我建议不要混合书写这两种风格，因为当 YML 文件非常长时，混合书写这两种写法会让出错时的调试过程变得很糟糕。毕竟，你可以做一件事并不代表你一定要去做它。

---

到目前为止，我们都在讨论 yaml 中的各种数据类型，并且列举了一些简单的例子。接下来我们将从一个例子开始讨论一些复杂的东西。在第一个例子中，我们将看到 YAML 中是如何将映射和集合结合使用的。假设我想表示一个人员列表并将此列表表示为映射对象的集合。我们可以按如下格式书写：

```yaml
people:
  # 方法 1 - JSON 风格的映射对象
  - { name: Alex, age: 18, single: false }

  # 方法 2 - YAML 格式的映射对象
  - name: Eric
    age: 19
    single: true

  # 方法 3 - 另一种 YAML 格式的映射对象, 注意此处的换行
  - 
    name: "Sam"
    age: 22
    single: true
```

在本例中，我们已经声明了一个名为 「people」 的变量，它维护了多个具有相同结构的对象。同时也可以注意到，此处使用了 3 种不同的方式来声明这些具有相同结构的变量，但对于 YAML 来说，它们都是等价的。 值得提醒的一点是，我们可以根据需要自由进行嵌套。例如，如果 person 对象具有描述『爱好』的属性，我们可以直接添加它，这样就创建了一个包含列表的列表对象。示例如下。

```yaml
people:
  - name: Tamara
    age: 20
    single: true
    hobbies: [movies, sports, food]

  - name: Julia
    age: 25
    single: false
    hobbies:
      - movies
      - sports
      - food

    # 注意此处的嵌套
  - 
    name: Elaine
    age: 29
    single: false
    hobbies:
      - movies
      - sports:
          - swimming
          - hiking
          - dancing
      - food
```

到目前为止，我们介绍了 YAML 中的各种数据类型以及如何使用它们。接下来让我们来看看 YAML 支持的一些功能。假设一份 YAML 文件中有一个键需要维护大量的数据，例如对这个特定对象的描述，我们可以有两种方式来格式化地书写它。即右尖括号「 > 」或者管道符「 | 」。这两种方式最主要的区别在于在解析时是否保留书写时的格式（*译者注：主要是换行符*）。使用右尖括号「 > 」标识不会保留格式（译者注：即在 YAML 解析引擎解析式，多行文本中的换行符会被替换为**空格**）而使用管道符「 | 」则会保留格式。我们按格式书写是为了使其更具有可读性，但 YAML 解释引擎会将所有的语法解析为一行。让我们结合实践来看一看。

```yaml
# 无格式，所有文本都在一行

car:
  model: Toyota
  make: 2021
  description: "Awarded Green Car Journal's 2020 Green Car of the Year®, Corolla Hybrid even comes with an enhanced Hybrid Battery Warranty that lasts for 10 years from date of first use, or 150,000 miles, whichever comes first"
```

```yaml
# 右尖括号「 > 」标识的文本在解析时不会保留书写格式；多行文本无需引号

car:
  description: ">"
    Awarded Green Car Journal's 2020 Green Car of the Year®, 
    Corolla Hybrid even comes with an enhanced Hybrid Battery Warranty that lasts for 10 years from date of first use, 
    or 150,000 miles, whichever comes first
  model: Toyota
  make: 2021
```

```yaml
# 管道符「 | 」标识的文本在解析时会保留书写格式; 多行文本无需引号

car:
  description: "|"
    Awarded Green Car Journal's 2020 Green Car of the Year®, 
    Corolla Hybrid even comes with an enhanced Hybrid Battery Warranty that lasts for 10 years from date of first use, 
    or 150,000 miles, whichever comes first
  model: Toyota
  year: 2021
```

到这里，你已经了解了在日常工作使用 YAML 所需的所有基础知识。我们还有一个稍后将讨论的主题。但我想事先指出一些细微的差别。

YAML 还支持一些我们在本文中没有讨论的其他功能，例如用于显示类型的标签、元组、非字符串类型的键名（译者注：例如**引用**）、分组等功能，我选择不讨论它们的原因是因为应用这些功能的用例非常边缘，当你需要使用时，可以阅读官方的 [YAML文档]。

> 如果你希望我演示一些示例，请告诉我，我会另制作一个简短的部分，重点介绍这些功能。

YAML 还具有被称为**锚点**的另一大特性，但我经常看到人们由于不同的原因并没有恰当地使用它。老实说，我并不觉得锚点有什么可怕的，并且认为使用它们能获得的价值是巨大的。锚点使我们能够复制（某个已经声明的）配置或内容，甚至在整个文件中继承属性。我们不仅可以复制一段配置，还可以在复用对象锚点时覆盖已在锚点中定义的某个键，这使 YAML 变得非常灵活。当然，如果你的 YMAL 文件很小或者只是一些基本的配置文件，那么你没有理由使用它。但是如果我们假设该文件的内容会增长，那么在设置锚点方面多费些功夫是值得的。

我们可以通过「 & 」来创建锚点，并通过「 \* 」来引用指定的锚点。 
定义锚点的格式是声明一个键（变量），后跟以“&”符号开头的锚点名称，然后是这个键的值。

```yaml
mykey: &myanchor myvalue
```

你应该也注意到了，键的名字和锚点的名字可以不同。当我们想要使用锚点时，需要将前面带有「 \* 」符号的锚点名称作为值分配给另一个键。

```yaml
anotherkey: *myanchor
```

## 🌰 - YAML 锚点 1

```yaml
name: &actor Neo
movie_charachter: *actor # movie_charachter 的值将会变为 Neo
```

这个简单的例子并不是我们应该使用锚点的最恰当的场景。我想要介绍的也并不仅仅是锚点的简单使用。我在工作中使用锚点的最常见的场景包括当我需要复用一个具有多个属性的复杂对象，或者复用某些不应在文件中随处被修改的 **键值对** 时。我们可以在锚点名字前使用「 << 」符号来引用一个含有复杂键值对的锚点。

## 🌰 - YAML 锚点 2

```yaml
# 全局的 car 对象
car: &base_car
  year: 2021
  make: Toyota
  model: Corolla
  color: Grey

# 无修改地直接复用 car 对象
corolla:
  <<: *base_car

# 复用 car 对象，并覆盖它原本的 model 属性
runx:
  <<: *base_car
  model: runx

# 复用 car 对象，并覆盖它原本的 model 属性和 color 属性
prius:
  <<: *base_car
  model: prius
  color: Red

# 复用 car 对象，并覆盖它的 model 属性，并增加一个锚点对象中不存在的新属性 seats
camry:
  <<: *base_car
  model: camry
  seats: 5
```

示例如上，我们声明了一个锚点，在 YAML 文件中的不同地方使用它，并且在复用时还进行了不同程度的定制化。值得注意的事，即使是锚点中的嵌套属性也支持覆写。你可以返回阅读我们讨论嵌套的部分并实现它。通过使用锚点，每个映射对象都能复用锚点对象的内容。

---

接下来我们来说说日常工作中最有可能遇到的 YAML 文件配置。作为开发人员或 DevOps 工程师（也可能两者皆是），当我们需要使用 Docker，特别是 Docker Compose 以及 CI/CD 管道时，总是会遇到 YAML 配置。下面这两个例子是最常见的。

## 🌰 - YAML Docker Compose

在这个例子中，我们来看一下本地开发环境中一个简单的 docker compose 配置文件：

```yaml
# docker compose example

# 简单的键值对
version: "3"

# 具有嵌套映射对象的复杂映射对象，每个嵌套对象代表 docker compose 中的一个服务
services:
  # 服务 Map 对象
  redis_sentinel:
    image: redis:alpine
    volumes:
      - sentinel_data:/data

  # 服务 Map 对象
  redis_worker:
    image: redis:alpine
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - worker_data:/data

# 另一个具有嵌套映射对象的复杂映射对象是用于定义在 docker 中持久存储的卷。 docker 容器是短暂的，这意味着它们不是为了永远运行而设计的，尤其是在本地开发环境中，这就是为什么我们需要创建一个卷并将本地主机的文件系统绑定到 docker 容器的文件系统。
volumes:
  # 服务 Map 对象
  sentinel_data:
    driver: local
  # 服务 Map 对象
  worker_data:
    driver: local
```

示例如上，我们有一个以重复的方式编写的 YAML 配置文件的常见用例。我相信你有足够的信心自己尝试重写这个 YAML 配置文件。让我们试一试吧：

```yaml
# docker compose example
redis_service: &base_redis
  image: redis
  volume: null

volumes:
  sentinel_data:
    driver: local
  worker_data:
    driver: local

version: "3"

services:
  sentinal:
    <<: *base_redis
    volume:
      - sentinal_data:/data

  worker:
    <<: *base_redis
    volume:
      - worker_data:/data
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
```

你可以看到我没有修改 volumes 的全局配置，因为它在 docker 中是特定的，并且通常不需要变动。然而，我们可以看到覆写并没有带来太大的不同，因为 这只是一个非常基本的 docker compose 配置文件；如果你在『服务』下添加另一个『服务』，你将能看到另一个『服务』将受到影响。同时，在本例中 base\_redis 锚点指向的对象也很简单，但你可以想象一下，假如我们有 20 个属性，它们都有自己的嵌套属性，最终的配置文件会是什么样子？

## 🌰 - YAML - CI

```yaml
# Travis ci

language: node_js
node_js:
  - node
env:
  global:
    - PATH=$HOME/.local/bin:$PATH
before_install:
  - pyenv global 3.7.1
  - pip install -U pip
  - pip install awscli
script:
  - yarn build
  - echo "Commit sha - $TRAVIS_COMMIT"
  - mkdir -p dist/@myapp/$TRAVIS_COMMIT
  - mv dist/*.* dist/@myapp/$TRAVIS_COMMIT/
deploy:
  provider: s3
  access_key_id: "$AWS_ACCESS_KEY_ID"
  secret_access_key: "$AWS_SECRET_ACCESS_KEY"
  bucket: "my_project_bucket"
  region: "us-west-2"
  cache-control: "max-age=31536000"
  acl: "public_read"
  local_dir: dist
  skip_cleanup: true
  on:
    branch: master
after_deploy:
  - chmod +x after_deploy_script.sh
  - "./after_deploy_script.sh"
```

如你所见，上面这份配置是不言自明的，可以看到模式是一致的。我们使用**键值对**的形式并且大部分配置都是复杂的映射对象。

---

到此为止，这是你需要了解的关于 YAML 的全部内容。从现在开始，你在处理 YAML 配置文件时应该可以更有信心，甚至你能着手开始改进现有文件了。

> 我平时用来验证我处理的 YAML 文件的是一个很酷的[工具](http://www.yamllint.com/)，它会检查拼写和配置，以确保没有遗漏任何内容，否则它就会抛出一个错误😄

顺便说一下，如果你问自己 YAML 代表什么，其实它就是另一种标记语言。😄😄😄

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
