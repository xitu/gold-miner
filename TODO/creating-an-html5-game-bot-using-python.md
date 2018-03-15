> * 原文地址：[Creating An HTML5 Game Bot Using Python](https://vesche.github.io/articles/01-stabbybot.html)
> * 原文作者：[vesche](https://vesche.github.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/creating-an-html5-game-bot-using-python.md](https://github.com/xitu/gold-miner/blob/master/TODO/creating-an-html5-game-bot-using-python.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[faintz](https://github.com/faintz), [vuuihc](https://github.com/vuuihc)

# 用 Python 做一个 H5 游戏机器人

**摘要：**我给游戏 [stabby.io](http://stabby.io/) 写了一个机器人（bot），源码请参考：[GitHub repo](https://github.com/vesche/stabbybot)。

几周前，我在一个无聊的夜晚发现了一款游戏：[stabby.io](http://stabby.io/)。于是乎我的 IO 游戏瘾又犯了（曾经治好过）。在进入游戏后，你会被送进一个小地图中，场景里有许多和你角色长得一样的玩家，你可以杀死你身边的任何一个人。你周围的角色大多数都是电脑玩家，你需要设法弄清哪个才是人类玩家。我沉迷游戏无法自拔，愉快地玩了几个小时。

![01-scrot](https://vesche.github.io/articles/media/01-scrot.png)

正当我放纵一夜时，Eric S. Raymond 先生提醒我 [boredom and drudgery are evil](http://www.catb.org/~esr/faqs/hacker-howto.html#believe3)（无聊和单调都是罪恶）……我还记得 [LiveOverflow](http://www.liveoverflow.com/) 的一位老师在视频里冲我叫喊 [STOP WASTING YOUR TIME AND LEARN MORE HACKING!](https://www.youtube.com/watch?v=AMMOErxtahk)（多码代码少睡觉）。因此，我打算把我的无聊与单调转变成为一个有趣的编程项目，开始做一个为我玩 stabby 的 Python 机器人！

在开始前，先介绍一下 stabby 超酷的开发者：soulfoam，他在自己的 [Twitch 频道](https://www.twitch.tv/soulfoamtv)直播编程与游戏开发。我得到了他的授权，允许我创建这个机器人并与大家分享。

我最开始的想法是用 [autopy](http://www.autopy.org/) 捕获屏幕，并根据图像分析发送鼠标的移动（作者在此悼念了曾经做过的 Runescape 机器人）。但很快我就放弃这种方式，因为这个游戏有着更直接的交互方式 - [WebSockets](https://en.wikipedia.org/wiki/WebSocket)。由于 stabby 是一款多人实时 HTML5 游戏，因此它使用了 WebSockets 在客户端与服务器之间建立了长连接，双方都能随时发送数据。

![01-websockets](https://vesche.github.io/articles/media/01-websockets.png)

所以我们只需要关注客户端与服务器间的 WebSocket 通讯就行了。如果可以理解从服务器**接收**的消息以及之后**发送**给服务器的消息，那我们就能直接通过 WebSocket 通讯来玩游戏。现在开始玩 stabby 游戏，并打开 [Wireshark](https://www.wireshark.org/) 查看流量。

![01-wireshark](https://vesche.github.io/articles/media/01-wireshark.png)

**注意：**我对上面 stabby 的服务器 IP 进行了打码处理，避免它被攻击。为了避免脚本小子滥用这个机器人，我不会在 stabbybot 中提供这个 IP，你需要自行获取。

接着说这美味的 WebSocket 数据包。在这儿看到了第一个表明我们正处于正确道路的标志！我在开始游戏时，将角色名设定为 `chain`，紧接着在发往服务器的第二个 WebSocket 包的数据部分看到了 `03chain`。游戏里的其他人就这样知道了我的名字！

通过对抓包进一步的分析，我确定了在建立连接时客户端要发送给服务端的东西。下面是我们需要在 Python 中重新复现的内容：

*   连接至 stabby 的 WebSocket 服务器
*   发送当前游戏版本（000.0.4.3）
*   WebSocket Ping/Pong
*   发送我们的角色名
*   监听服务器发来的消息

我将使用 [websocket-client](https://pypi.python.org/pypi/websocket-client) 库来让 Python 连接 WebSocket 服务器。下面编写前文概述内容的代码：

```python
# main.py

import websocket

# 创建一个 websocket 对象
ws = websocket.WebSocket()

# 连接到 stabby.io 服务器
ws.connect('ws://%s:443' % server_ip, origin='http://stabby.io')

# 向服务器发送当前游戏版本
ws.send('000.0.4.3')

# force a websocket ping/pong
ws.pong('')

# 发送用户名
ws.send('03%s' % 'stabbybot')

try:
    while True:
        # 监听服务器发送的消息
        print(ws.recv())
except KeyboardInterrupt:
    pass

ws.close()
```

幸运的是，上面的程序没有让我们失望，收到了服务器消息！

```
030,day
15xx,60|stabbybot,0|
162,2,0
05+36551,186.7,131.0,walking,left|+58036,23.1,122.8,walking,right|_20986,55.2,71.7,idle,left|_47394,70.9,84.9,walking,right|_58354,10.4,16.2,walking,right|_81344,61.0,27.8,walking,left|+77108,107.5,8.9,walking,left|_96763,118.8,71.7,walking,left|_23992,104.4,24.1,walking,right|+30650,118.4,8.0,idle,left|+11693,186.7,35.5,walking,left|+34643,186.7,118.3,walking,left|+65406,83.9,33.3,idle,right|+24414,186.7,136.3,walking,left|+00863,75.2,35.3,walking,left|_57248,39.0,51.3,walking,right|_98132,165.2,10.0,walking,right|_45741,179.2,5.2,walking,right|+57840,186.7,45.3,walking,left|+70676,186.7,135.7,walking,left|+39478,90.8,63.3,walking,left|_51961,166.7,138.7,idle,right|+85034,148.4,7.7,idle,right|_72926,62.4,23.7,walking,left|_25474,9.6,58.0,idle,left|0,4.0,1.0,idle,left|_52426,61.0,128.4,walking,left|_00194,67.5,96.1,walking,left|+12906,170.7,33.7,walking,right|_67508,87.2,93.3,walking,left|+51085,140.3,34.2,idle,right|_67544,170.1,100.7,idle,right|_77761,158.5,127.6,idle,left|_25113,38.4,111.2,walking,left|
08100,20.5,227.68056,227.68056,0.0,0.0
18t,xx,250m or less
...
```

以上是由服务器传给客户端的消息。我们可以在登录后得到关于游戏中时间的信息：`030,day`。接着会有一些数据不断地产生： `05+36551,186.7,131.0,walking,left|+58036,23.1,122.8,walking,right|...`，这些表达全局状况的数据看上去应该是：玩家 id、坐标、状态、脸对着的方向。现在可以试着调试并对游戏的通信进行逆向工程，以理解客户端、服务器之间发送的是什么了。

例如，当在游戏中杀人时会发生什么？

![01-kill](https://vesche.github.io/articles/media/01-kill.png)

这次我使用了 Wireshark，特别设置了过滤器，仅抓取流向`（ip.dst）`服务器的 WebSocket 流量。在杀死某人后，`10` 与玩家 id 被传给服务器。可能你还不太明白，我解释一下：发送给服务器的一切东西都由两位数字开头，我将其称为`事件代码`。总共有差不多 20 个不同的事件代码，我还没完全弄清它们分别是做什么的。不过，我可以找到一些比较重要的事件：

```
EVENTS = {
    '03': '登录',
    '05': '全局状况',
    '07': '移动',
    '09': '游戏中的时间',
    '10': '杀',
    '13': '被杀',
    '14': '杀人信息',
    '15': '状态',
    '18': '目标'
}
```

## 创造一个非常简单的机器人

有了这些信息，我们就能构建机器人啦！

```
.
├── main.py  - 机器人的入口文件。在此文件中会连接 stabby 的服务器，
│              并定义主循环（main loop）。
├── comm.py  - 处理所有消息的收发。
├── state.py - 跟踪游戏的当前状态。
├── brain.py - 决定机器人要做什么事。
└── log.py   - 提供机器人可能需要的日志功能。
```

`main.py` 中的主循环会做以下几件事：

*   接收服务器消息。
*   将服务器消息传给 `comm.py` 进行处理。
*   处理过的数据会储存在当前游戏状态（`state.py`）中。
*   将当前游戏状态传给 `brain.py`。
*   执行基于游戏状态做出的决策。

下面让我们看看如何实现一个非常基本的**会自己移动到上个玩家被杀的位置**的机器人吧。当某人在游戏中被杀害时，其余的每个人都会受到一个类似 `14+12906,120.2,64.8,seth` 的广播消息。这个消息中，`14` 是事件代码，后面是用逗号分隔的玩家 id、x 坐标与 y 坐标，最后是杀手的名称。如果我们要走到这个位置区，要发送事件代码 `07`，后面跟着用逗号分隔的 x 与 y 坐标。

首先，我们创建一个跟踪杀人信息的游戏状态类：

```python
# state.py

class GameState():
    """跟踪 stabbybot 的当前游戏状态。"""

    def __init__(self):
        self.game_state = {
            'kill_info': {'uid': None, 'x': None, 'y': None, 'killer': None},
        }

    def kill_info(self, data):
        uid, x, y, killer = data.split(',')
        self.game_state['kill_info'] = {'uid': uid, 'x': x, 'y': y, 'killer': killer}
```

接下来，我们创建通信代码用以处理**接收**到的杀人信息（然后将其传给游戏状态类），以及将移动命令**发送**出去：

```python
# comm.py

def incoming(gs, raw_data):
    """处理收到的游戏数据"""

    event_code = raw_data[:2]
    data = raw_data[2:]

    if event_code == '14':
        gs.kill_info(data)

class Outgoing(object):
    """处理要发出的游戏数据。"""

    def move(self, x, y):
        x = x.split('.')[0]
        y = y.split('.')[0]
        self.ws.send('%s%s,%s' % ('07', x, y))
```

下面为决策部分。程序将通过当前的游戏状态来进行决策，如果有人被杀了，它会将我们的角色移动到那个位置去：

```python
# brain.py

class GenOne(object):
    """第一代 stabbybot。它现在还很蠢（笑"""

    def __init__(self, outgoing):
        self.outgoing = outgoing
        self.kill_info = {'uid': None, 'x': None, 'y': None, 'killer': None}

    def testA(self, game_state):
        """走到上个玩家被杀的地点去。"""
        if self.kill_info != game_state['kill_info']:
            self.kill_info = game_state['kill_info']

            if self.kill_info['killer']:
                print('New kill by %s! On the way to (%s, %s)!'
                    % (self.kill_info['killer'], self.kill_info['x'], self.kill_info['y']))
                self.outgoing.move(self.kill_info['x'], self.kill_info['y'])
```

最后更新 main 文件，它将连接服务器，并执行上面概括的主循环：

```python
# main.py

import websocket

import state
import comm
import brain

ws = websocket.WebSocket()
ws.connect('ws://%s:443' % server_ip, origin='http://stabby.io')
ws.send('000.0.4.3')
ws.pong('')
ws.send('03%s' % 'stabbybot')

# 将类实例化
gs = state.GameState()
outgoing = comm.Outgoing(ws)
bot = brain.GenOne(outgoing)

while True:
    # 接收服务器消息
    raw_data = ws.recv()

    # 处理收到的数据
    comm.incoming(gs, raw_data)

    # 进行决策
    bot.testA(gs.game_state)

ws.close()
```

机器人运行时，将会如期运行。当有人死亡的时候，机器人会向那个死亡地点攻击。虽然不够刺激，但这是个不错的开头！现在，我们可以发送与接收游戏数据，并在游戏中完成一些特定的任务。

## 创造一个体面的机器人

接下来为前面创造的简单版机器人进行拓展，添加更多的功能。`comm.py` 和 `state.py` 文件现在充满了各种各样的功能，详情请查看 [stabbybot 的 GitHub repo](https://github.com/vesche/stabbybot)。

现在我们将做一个可以与普通人类玩家竞争的机器人。在 stabby 中最简单的获胜方式就是保持耐心，不断走动，直到看见某人被杀，然后去杀掉那个杀人凶手。

因此，我们需要机器人做下面的事：

*   随机走动。
*   检查是否有人被杀（`game_state['kill_info']`）。
*   如果有人被杀了，就检查当前全局状况的数据（`game_state['perception']`）。
*   确认是否某人是否离杀人地点够近，以确定杀人凶手。
*   为了分数和荣耀去杀了那个凶手！

打开 `brain.py` 编写一个 `GenTwo` 类（意为第二代）。第一步实现最简单的部分，让机器人随机走动。

```python
class GenTwo(object):
    """第二代 stabbybot。看着这个小家伙到处走动吧！"""

    def __init__(self, outgoing):
        self.outgoing = outgoing
        self.walk_lock = False
        self.walk_count = 0
        self.max_step_count = 600

    def main(self, game_state):
        self.random_walk(game_state)

    def is_locked(self):
        # 检查是否加锁
        if (self.walk_lock): # 一个锁
            return True
        return False

    def random_walk(self, game_state):
        # 检查是否加锁
        if not self.is_locked():
            # 得到随机的 x、y 坐标
            rand_x = random.randint(40, 400)
            rand_y = random.randint(40, 400)
            # 开始向随机的 x、y 坐标移动
            self.outgoing.move(str(rand_x), str(rand_y))
            # 上锁
            self.walk_lock = True

        # 检查移动是否完成
        if self.max_step_count < self.walk_count:
            # 解锁
            self.walk_lock = False
            self.walk_count = 0

        # 增加走路计数器
        self.walk_count += 1
```

上面做的是一件很重要的事情：创建了一个锁机制。由于机器人要进行许多的操作，我不希望看到机器人变得困惑，在随机走动的途中去杀人。当我们的角色开始随机行走时，会等待 600 个“步骤”（即收到的事件），然后才会再次开始随机行走。600 是通过计算得出的，从地图一角走到另一角的最大步数。

接下来为我们的小狗准备肉。检查最近的杀人事件，然后与当前的全局状况数据进行比较。

```python
import collections

class GenTwo(object):

    def __init__(self, outgoing):
        self.outgoing = outgoing

        # 跟踪最近发生的杀人事件
        self.kill_info = {'uid': None, 'x': None, 'y': None, 'killer': None}

    def main(self, game_state):
        # 优先执行
        self.go_for_kill(game_state)
        self.random_walk(game_state)

    def go_for_kill(self, game_state):
        # 检查是否有新的杀人事件发生
        if self.kill_info != game_state['kill_info']:
            self.kill_info = game_state['kill_info']

            # 杀人事件发生的 x、y 坐标
            kill_x = float(game_state['kill_info']['x'])
            kill_y = float(game_state['kill_info']['y'])

            # 用周围角色的 id、x 坐标、y 坐标创建一个 OrderedDict
            player_coords = collections.OrderedDict()
            for i in game_state['perception']:
                player_x = float(i['x'])
                player_y = float(i['y'])
                player_uid = i['uid']
                player_coords[player_uid] = (player_x, player_y)
```

现在在 `go_for_kill` 中，有一个 `kill_x` 、 `kill_y` 坐标，表明了最近一次杀人时间的发生地点。另外还有一个由玩家 ID、玩家 x、y 坐标组成的有序字典。当游戏中有人被杀时，有序字典将会如下所示：`OrderedDict([('+56523', (315.8, 197.5)), ('+93735', (497.4, 130.7)), ...])`。下面找出离杀人地点最近的玩家就行了。如果有玩家离杀人坐标足够近，机器人将把他们找出来！

所以现在任务很清晰了，我们需要在一组坐标中找到最接近的坐标。这个方法被称为[最邻近查找](https://en.wikipedia.org/wiki/Nearest_neighbor_search)，我们可以用 [k-d trees](https://en.wikipedia.org/wiki/K-d_tree) 实现。我使用了 [SciPy](https://www.scipy.org/) 这个超帅的 Python 库，用它的 [scipy.spatial.KDTree.query](https://docs.scipy.org/doc/scipy/reference/generated/scipy.spatial.KDTree.query.html#scipy.spatial.KDTree.query) 方法实现了这个功能。

```python
from scipy import spatial

    # ...

    def go_for_kill(self, game_state):
        if self.kill_info != game_state['kill_info']:
            self.kill_info = game_state['kill_info']
            self.kill_lock = True

            kill_x = float(game_state['kill_info']['x'])
            kill_y = float(game_state['kill_info']['y'])

            player_coords = collections.OrderedDict()
            for i in game_state['perception']:
                player_x = float(i['x'])
                player_y = float(i['y'])
                player_uid = i['uid']
                player_coords[player_uid] = (player_x, player_y)

            # 找到距击杀坐标最近的玩家
            tree = spatial.KDTree(list(player_coords.values()))
            distance, index = tree.query([(kill_x, kill_y)])

            # 当距离某玩家足够近时进行击杀
            if distance < 10:
                kill_uid = list(player_coords.keys())[int(index)]
                self.outgoing.kill(kill_uid)
```

如果你想看完整的策略，[这儿是 stabbybot 中 brain.py 的完整代码](https://github.com/vesche/stabbybot/blob/master/stabbybot/brain.py).

现在让我们运行机器人，看看它表现如何：

```bash
$ python stabbybot/main.py -s <server_ip> -u stabbybot

[+] MOVE: (228, 56)
[+] STAT: [('sam5', '2146'), ('jjkiller', '397'), ('QWERTY', '393'), ('N-chan', '240'), ('stabbybot', '0')]
[+] KILL: jjkiller (62.798412, 16.391998)
[+] STAT: [('sam5', '2146'), ('jjkiller', '407'), ('QWERTY', '393'), ('N-chan', '240'), ('stabbybot', '0')]
[+] KILL: N-chan (322.9627, 235.68994)
[+] STAT: [('sam5', '2146'), ('jjkiller', '407'), ('QWERTY', '393'), ('N-chan', '250'), ('stabbybot', '0')]
[+] KILL: jjkiller (79.39742, 11.73037)
[+] STAT: [('sam5', '2146'), ('jjkiller', '417'), ('QWERTY', '393'), ('N-chan', '250'), ('stabbybot', '0')]
[+] KILL: QWERTY (241.24649, 253.66882)
[+] STAT: [('sam5', '2146'), ('QWERTY', '505'), ('jjkiller', '417'), ('stabbybot', '0')]
[+] KILL: sam5 (91.02979, 41.00656)
[+] STAT: [('sam5', '2156'), ('QWERTY', '505'), ('jjkiller', '417'), ('stabbybot', '0')]
[+] MOVE: (287, 236)
[+] KILL: jjkiller (100.214806, 36.986927)
[+] STAT: [('jjkiller', '1006'), ('QWERTY', '505'), ('stabbybot', '0')]

... snip (10 minutes later)

[+] ASSA: _95181
[+] STAT: [('Mr.Stabb', '778'), ('QWERTY', '687'), ('stabbybot', '565'), ('fire', '408'), ('ff', '0'), ('Guest72571', '0'), ('shako', '0')]
[+] KILL: stabbybot (159.09984, 218.41016)
[+] ASSA: 0
[+] STAT: [('Mr.Stabb', '778'), ('stabbybot', '717'), ('QWERTY', '687'), ('ff', '0'), ('Guest72571', '0'), ('shako', '0')]
[+] STAT: [('Mr.Stabb', '778'), ('stabbybot', '717'), ('QWERTY', '687'), ('fire', '306'), ('ff', '0'), ('Guest72571', '0'), ('shako', '0')]
[+] STAT: [('Mr.Stabb', '778'), ('stabbybot', '717'), ('QWERTY', '687'), ('fire', '306'), ('z', '37'), ('ff', '0'), ('Guest72571', '0'), ('shako', '0')]
[+] MOVE: (245, 287)
[+] KILL: fire (194.04352, 68.50006)
[+] STAT: [('Mr.Stabb', '778'), ('stabbybot', '717'), ('QWERTY', '687'), ('fire', '316'), ('z', '37'), ('ff', '0'), ('Guest72571', '0'), ('shako', '0')]
[+] TOD: night
[+] KILL: Guest72571 (212.10252, 150.89288)
[+] STAT: [('Mr.Stabb', '778'), ('stabbybot', '717'), ('QWERTY', '687'), ('fire', '316'), ('z', '37'), ('Guest72571', '10'), ('ff', '0'), ('shako', '0')]
[-] You have been killed.
close status: 12596
```

结果还不错。机器人大约存活了 10 分钟，已经很了不起了。它得了 717 分，在被杀掉的时候排行第二！

以上就是本文的全部内容！如果你想找个有趣的编程项目，可以去做做 HTML5 游戏的机器人，你将获得无穷的乐趣，并能很好地练习网络分析、逆向工程、编程、算法、AI 等各种能力。希望能看到你的创作！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

