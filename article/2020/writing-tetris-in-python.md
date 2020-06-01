> * 原文地址：[Writing Tetris in Python](https://levelup.gitconnected.com/writing-tetris-in-python-2a16bddb5318)
> * 原文作者：[Dr Pommes](https://medium.com/@pommes)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/writing-tetris-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2020/writing-tetris-in-python.md)
> * 译者：[z0gSh1u](https://github.com/z0gSh1u)
> * 校对者：[Park-ma](https://github.com/Park-ma)、[Zhengjian-L](https://github.com/Zhengjian-L)

# 用 Python 写一个俄罗斯方块游戏

使用 Python 的 PyGame 库写一个俄罗斯方块游戏的逐步指南

在这篇教程中，我们会用 Python 的 PyGame 库写一个简单的俄罗斯方块游戏。里面的算法很简单，但对新手可能有一点挑战性。我们不会太关注 PyGame 的内部原理，而更关注游戏的逻辑。如果你懒得阅读整篇文章，你可以简单地复制粘贴文末的代码。

![俄罗斯方块游戏](https://cdn-images-1.medium.com/max/2000/1*zJwBMHhqoVES9LbIg68qxQ.gif)

#### 准备工作

1. Python 3。这可以从 [官方网站](https://www.python.org/downloads/) 下载。
2. PyGame。根据你正在使用的操作系统，打开命令提示符或者终端，输入 `pip install pygame` 或 `pip3 install pygame`。
3. Python 的基本知识。如果有需要，可以看看我的其他博文。

你在安装 Python 或者 PyGame 的时候可能会遇到一些问题，但这超出了本文的范围。请参考 StackOverflow :)

我个人在 Mac 上遇到了没办法在屏幕上显示任何东西的问题，安装某些特定版本的 PyGame 可以解决这个问题：`pip install pygame==2.0.0.dev4` 。

#### Figure 类

让我们从 Figure 类开始。我们的目标是储存图形的各种类型和它们的旋转结果。我们当然可以通过矩阵旋转来实现，但是这会让问题变得太复杂了。

![图形表示的主要思想](https://cdn-images-1.medium.com/max/2000/1*UjtAS8CTRpUJMnzw2PjF0Q.png)

所以，我们简单地用这样的列表表示图形：

```python
class Figure:
    figures = [
        [[1, 5, 9, 13], [4, 5, 6, 7]],
        [[1, 2, 5, 9], [0, 4, 5, 6], [1, 5, 9, 8], [4, 5, 6, 10]],
        [[1, 2, 6, 10], [5, 6, 7, 9], [2, 6, 10, 11], [3, 5, 6, 7]],  
        [[1, 4, 5, 6], [1, 4, 5, 9], [4, 5, 6, 9], [1, 5, 6, 9]],
        [[1, 2, 5, 6]],
    ]
```

其中，列表第一维度存储图形的类型，第二维度存储它们的旋转结果。每个元素中的数字代表了在 4 × 4 矩阵中填充为实心的位置。例如，[1,5,9,13] 表示一条竖线。为了更好地理解，请参考上面的图片。

作为练习，试着添加一些这里没有的图形，比如 Z 字形。

`__init__` 函数如下所示：

```python
class Figure:
    ...    
    def __init__(self, x, y):
        self.x = x
        self.y = y
        self.type = random.randint(0, len(self.figures) - 1)
        self.color = random.randint(1, len(colors) - 1)
        self.rotation = 0
```

在这里，我们随机选择一个形状和颜色。

并且，我们需要能够快速地旋转图形并获得当前的旋转结果，为此我们给出这两个简单的方法：

```python
class Figure:
    ...
    def image(self):
        return self.figures[self.type][self.rotation]

    def rotate(self):
        self.rotation = (self.rotation + 1) % len(self.figures[self.type])
```

#### Tetris 类

我们先用一些变量初始化游戏：

```python
class Tetris:
    level = 2
    score = 0
    state = "start"
    field = []
    height = 0
    width = 0
    x = 100
    y = 60
    zoom = 20
    figure = None
```

其中，`state` 表示我们是否仍在进行游戏；`field` 表示游戏的场地，为 0 处表示为空，有颜色值则表示此处有图形（除了仍在下落的）。

我们通过下面这个简单的方法来初始化游戏：

```python
class Tetris:
    ...    
    def __init__(self, height, width):
        self.height = height
        self.width = width
        for i in range(height):
            new_line = []
            for j in range(width):
                new_line.append(0)
            self.field.append(new_line)
```

这会创建一个大小为 `height x width` 的场地。

创建一个新的图形，并把它定位到坐标 (3, 0) 是很简单的：

```python
class Tetris:
    ...
    def new_figure(self):
        self.figure = Figure(3, 0)
```

更有意思的函数是检查目前正在下落的图形是否与已经固定的相交。这种情形可能在图形向左、向右、向下或者旋转时发生。

```python
class Tetris:
    ...
    def intersects(self):
        intersection = False
        for i in range(4):
            for j in range(4):
                if i * 4 + j in self.figure.image():
                    if i + self.figure.y > self.height - 1 or \
                            j + self.figure.x > self.width - 1 or \
                            j + self.figure.x < 0 or \
                            self.field[i + self.figure.y][j + self.figure.x] > 0:
                        intersection = True
        return intersection
```

这很简单：我们遍历并检查当前图形的 4 × 4 矩阵的每个格子，不管它是否超出了游戏的边界或者或者与场地已填充的块重合。我们还检查 `self.field[..][..] > 0`，因为场地的那一块可能有颜色。如果那里是 0，就说明那一块是空的，那就没问题。

有了这个函数，我们就可以检查是否可以移动或旋转图形了。如果它向下移动并且满足相交，那就说明我们已经到底了，所以我们需要 “冻结” 场地上的这个图形：

```python
class Tetris:
    ...
    def freeze(self):
        for i in range(4):
            for j in range(4):
                if i * 4 + j in self.figure.image():
                    self.field[i + self.figure.y][j + self.figure.x] = self.figure.color
        self.break_lines()
        self.new_figure()
        if self.intersects():
            game.state = "gameover"
```

冻结以后，我们需要检查有没有已填满的、需要删除的水平线。然后创建一个新的图形，如果它刚创建就满足相交，那就 Game Over 了 :) 。

检查填满的水平线相当简单直接，但注意，删除水平线需要由下而上地进行：

```python
class Tetris:
    ...
    def break_lines(self):
        lines = 0
        for i in range(1, self.height):
            zeros = 0
            for j in range(self.width):
                if self.field[i][j] == 0:
                    zeros += 1
            if zeros == 0:
                lines += 1
                for i1 in range(i, 1, -1):
                    for j in range(self.width):
                        self.field[i1][j] = self.field[i1 - 1][j]
        self.score += lines ** 2
```

现在，我们还差移动的方法：

```python
class Tetris:
    ...
    def go_space(self):
        while not self.intersects():
            self.figure.y += 1
        self.figure.y -= 1
        self.freeze()

    def go_down(self):
        self.figure.y += 1
        if self.intersects():
            self.figure.y -= 1
            self.freeze()

    def go_side(self, dx):
        old_x = self.figure.x
        self.figure.x += dx
        if self.intersects():
            self.figure.x = old_x

    def rotate(self):
        old_rotation = self.figure.rotation
        self.figure.rotate()
        if self.intersects():
            self.figure.rotation = old_rotation
```

如你所见，`go_space` 方法重复了 `go_down` 的，但它会一直向下运动直到接触到场景底部或者某个固定的图形。

并且在每个方法中，我们记忆了之前的位置，改变坐标，然后检查是否满足相交。如果有相交，我们就回退到前一个状态。

#### PyGame 和完整的代码

我们快搞定了！

还剩下一些游戏循环和 PyGame 方面的逻辑。所以，现在一起看看完整的代码吧：

```python
import pygame
import random

colors = [
    (0, 0, 0),
    (120, 37, 179),
    (100, 179, 179),
    (80, 34, 22),
    (80, 134, 22),
    (180, 34, 22),
    (180, 34, 122),
]


class Figure:
    x = 0
    y = 0

    figures = [
        [[1, 5, 9, 13], [4, 5, 6, 7]],
        [[1, 2, 5, 9], [0, 4, 5, 6], [1, 5, 9, 8], [4, 5, 6, 10]],
        [[1, 2, 6, 10], [5, 6, 7, 9], [2, 6, 10, 11], [3, 5, 6, 7]],
        [[1, 4, 5, 6], [1, 4, 5, 9], [4, 5, 6, 9], [1, 5, 6, 9]],
        [[1, 2, 5, 6]],
    ]

    def __init__(self, x, y):
        self.x = x
        self.y = y
        self.type = random.randint(0, len(self.figures) - 1)
        self.color = random.randint(1, len(colors) - 1)
        self.rotation = 0

    def image(self):
        return self.figures[self.type][self.rotation]

    def rotate(self):
        self.rotation = (self.rotation + 1) % len(self.figures[self.type])


class Tetris:
    level = 2
    score = 0
    state = "start"
    field = []
    height = 0
    width = 0
    x = 100
    y = 60
    zoom = 20
    figure = None

    def __init__(self, height, width):
        self.height = height
        self.width = width
        for i in range(height):
            new_line = []
            for j in range(width):
                new_line.append(0)
            self.field.append(new_line)

    def new_figure(self):
        self.figure = Figure(3, 0)

    def intersects(self):
        intersection = False
        for i in range(4):
            for j in range(4):
                if i * 4 + j in self.figure.image():
                    if i + self.figure.y > self.height - 1 or \
                            j + self.figure.x > self.width - 1 or \
                            j + self.figure.x < 0 or \
                            self.field[i + self.figure.y][j + self.figure.x] > 0:
                        intersection = True
        return intersection

    def break_lines(self):
        lines = 0
        for i in range(1, self.height):
            zeros = 0
            for j in range(self.width):
                if self.field[i][j] == 0:
                    zeros += 1
            if zeros == 0:
                lines += 1
                for i1 in range(i, 1, -1):
                    for j in range(self.width):
                        self.field[i1][j] = self.field[i1 - 1][j]
        self.score += lines ** 2

    def go_space(self):
        while not self.intersects():
            self.figure.y += 1
        self.figure.y -= 1
        self.freeze()

    def go_down(self):
        self.figure.y += 1
        if self.intersects():
            self.figure.y -= 1
            self.freeze()

    def freeze(self):
        for i in range(4):
            for j in range(4):
                if i * 4 + j in self.figure.image():
                    self.field[i + self.figure.y][j + self.figure.x] = self.figure.color
        self.break_lines()
        self.new_figure()
        if self.intersects():
            game.state = "gameover"

    def go_side(self, dx):
        old_x = self.figure.x
        self.figure.x += dx
        if self.intersects():
            self.figure.x = old_x

    def rotate(self):
        old_rotation = self.figure.rotation
        self.figure.rotate()
        if self.intersects():
            self.figure.rotation = old_rotation


# 初始化游戏引擎
pygame.init()

# 定义一些颜色
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
GRAY = (128, 128, 128)

size = (400, 500)
screen = pygame.display.set_mode(size)

pygame.display.set_caption("Tetris")

# 循环，直到用户点击关闭按钮
done = False
clock = pygame.time.Clock()
fps = 25
game = Tetris(20, 10)
counter = 0

pressing_down = False

while not done:
    if game.figure is None:
        game.new_figure()
    counter += 1
    if counter > 100000:
        counter = 0

    if counter % (fps // game.level // 2) == 0 or pressing_down:
        if game.state == "start":
            game.go_down()

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            done = True
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_UP:
                game.rotate()
            if event.key == pygame.K_DOWN:
                pressing_down = True
            if event.key == pygame.K_LEFT:
                game.go_side(-1)
            if event.key == pygame.K_RIGHT:
                game.go_side(1)
            if event.key == pygame.K_SPACE:
                game.go_space()
        if event.type == pygame.KEYUP:
            if event.key == pygame.K_DOWN:
                pressing_down = False

    screen.fill(WHITE)

    for i in range(game.height):
        for j in range(game.width):
            pygame.draw.rect(screen, GRAY, [game.x + game.zoom * j, game.y + game.zoom * i, game.zoom, game.zoom], 1)
            if game.field[i][j] > 0:
                pygame.draw.rect(screen, colors[game.field[i][j]],
                                 [game.x + game.zoom * j + 1, game.y + game.zoom * i + 1, game.zoom - 2, game.zoom - 1])

    if game.figure is not None:
        for i in range(4):
            for j in range(4):
                p = i * 4 + j
                if p in game.figure.image():
                    pygame.draw.rect(screen, colors[game.figure.color],
                                     [game.x + game.zoom * (j + game.figure.x) + 1,
                                      game.y + game.zoom * (i + game.figure.y) + 1,
                                      game.zoom - 2, game.zoom - 2])

    font = pygame.font.SysFont('Calibri', 25, True, False)
    font1 = pygame.font.SysFont('Calibri', 65, True, False)
    text = font.render("Score: " + str(game.score), True, BLACK)
    text_game_over = font1.render("Game Over :( ", True, (255, 0, 0))

    screen.blit(text, [0, 0])
    if game.state == "gameover":
        screen.blit(text_game_over, [10, 200])

    pygame.display.flip()
    clock.tick(fps)

pygame.quit()
```

试试复制然后粘贴到一个 `py` 文件里。运行，然后享受游戏吧！ :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
