> * 原文地址：[An introduction to Raspberry Pi 4 GPIO and controlling it with Node.js](https://itnext.io/an-introduction-to-raspberry-pi-4-gpio-and-controlling-it-with-node-js-10f2ce41af12)
> * 原文作者：[Uday Hiwarale](https://medium.com/@thatisuday)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/an-introduction-to-raspberry-pi-4-gpio-and-controlling-it-with-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/an-introduction-to-raspberry-pi-4-gpio-and-controlling-it-with-node-js.md)
> * 译者：Weirdochr
> * 校对者：

# 树莓派4代（Raspberry Pi 4） GPIO 简介及使用 Node.js 控制树莓派

> 树莓派 + NODE.JS  
> 通过本文，我们将熟悉树莓派 GPIO 及其技术规范。并且，我们将通过了一个简单例子，说明其如何使用 LED 和开关实现输入和输出。

![(文章来源：[**pexels.com**](https://www.pexels.com/photo/have-a-break-led-signage-2249342/))](https://cdn-images-1.medium.com/max/12000/1*t-dr_5CrKf45RE0Uuww2sg.jpeg)

你可能曾见过 “**IoT**” 这个术语，它是 **Internet of Things(物联网)** 的缩写。 意思是，人们可以通过互联网控制一台设备，即“物” （**thing**）。 你家中可以通过智能手机控制的那些智能灯泡便是解释物联网（IoT）的一个很好示例。

由于物联网可通过互联网控制，所以它应当始终与互联网相连。我们主要有两种方式将设备连接至互联网：以太电缆和无线网络。

物联网设备可被用于各种目的。例如，你可以使用物联网来控制你家的室内温度、照明或者在回家前打开某些设备，所有操作只需要通过你的智能手机便能实现。

那么，物联网设备的技术规范有哪些？简言之，它应该包含连接到互联网的工具，有一些输入和输出接口来读写设备的模拟或数字信号，并且使用最少的硬件来读取和执行程序指令。

一个物联网设备配有一个硬件组件，为外部设备读取数字数据和取电提供接口。 该接口就是 **GPIO** 或称作 **General Purpose Input Output(通用输入输出接口)** 。该硬件组件基本上是一系列可以连接到外部设备的识别码。

这一系列 GPIO 识别码可以由一个程序控制。例如，基于某些条件，我们可以提供一个支持5伏电压的 GPIO 识别码，任何连接到该识别码的器件都将开启。该程序可以监听互联网发送的消息并控制此识别码。物联网由此实现。

从头开始构建这样一个物联网设备可能很困难，因为需要处理的组件有很多。幸运的是，我们有售价低廉的预制设备可购买。这些设备配有 GPIO 硬件和连接互联网的工具。

#### Arduino 微控制器

目前，如果我们想要实现简单的自动化，那么 [**Arduino**](https://en.wikipedia.org/wiki/Arduino) 是最好的选择。它是一个 **微控制器（micro-controller）** ，可以用 C 和 C++ 这样的编程语言来编写 Arduino 程序。

![(来源：[**Wikipedia**](https://en.wikipedia.org/wiki/File:Arduino_Uno_-_R3.jpg))](https://cdn-images-1.medium.com/max/2000/1*-Tmb_Q7yYmmtFGaUk6iv4A.jpeg)

然而，该控制器不配有内置 WiFi 或以太插孔， 并且必须连接外部外围设备 (**称为** 屏蔽) 才能将 Arduino 连接到互联网。

Arduino 旨在充当外部设备的控制器，而不是成熟的物联网设备。因此，该控制器价格非常便宜。一些最新款可以低至18美元。

#### 树莓派微型电脑

相较于 Arduino， [**树莓派**](https://en.wikipedia.org/wiki/Raspberry_Pi) 是一个 **beast**。 其发明之初旨在促进学校和发展中国家的基础计算机科学教学，却被书呆子和业余爱好者捡起来创造新垃圾。目前，它是世界上最受欢迎的 **单板计算机** 之一。

树莓派 (**最新版 4B**) 配有以太网连接器、WiFi、蓝牙、HDMI output、USB 连接器、 40 针 GPIO 和其他基本功能。它由 **ARM** CPU, a **Broadcom** GPU 和 1/2/4 GB 的 **RAM** 供电。你可以从 [**此处**](https://en.wikipedia.org/wiki/Raspberry_Pi#Specifications) 的维基百科表格中查看这些规范。

![(来源：[**Wikipedia**](https://en.wikipedia.org/wiki/File:Raspberry_Pi_4_Model_B_-_Side.jpg))](https://cdn-images-1.medium.com/max/2000/1*WE-9WUau6aQlMSHVLjq9KQ.jpeg)

尽管硬件笨重，最新版的价格在 **$40** 到 **$80** 之间。别忘了，这是一台拥有本机操作系统的成熟计算机。这意味着我们不需要连接外部计算机来对其进行编程。

然而，不像我们日常使用的电脑，树莓派提供了一个 GPIO 硬件组件来控制外部设备。这使得树莓派成为一种几乎可以做任何事情的设备。

让我们了解一下新版树莓派 GPIO 的技术规格。

---

## 树莓派 - GPIO 引脚分配

树莓派 （**4B 版**） 总共有 **40 个 GPIO 引脚** ，分布在 `20 x 2` 的阵列当中。如下图所示，每个引脚都有特定的用途。

![(来源：[**raspberrypi.org**](https://www.raspberrypi.org/documentation/usage/gpio/))](https://cdn-images-1.medium.com/max/4128/0*VsaGvGskvJa20hZa.png)

在讨论每个引脚的功能之前，让我们先了解一些协议。每个引脚都有一个附着在上的特定编号，我们就是通过这些编号从软件中控制这些引脚。

在圆圈中，你可以看到的数字是 GPIO 硬件上的物理引脚编号。例如， **1号引脚** 提供 3.3 伏的恒定功率。该编号系统成为 **针脚板** 或 **物理针脚** 编号系统。

由于树莓派 4B 使用 [**BCM2711**](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2711/README.md) 处理器芯片，我们还有另一个由 [**Broadcom**](https://en.wikipedia.org/wiki/Broadcom_Inc.) 创建的针脚编号系统。此针脚编号系统被称为 **BCM** or **Broadcom 模式**。 上图中，每个针脚附带的标签都显示了 BCM 针脚编号。例如，物理 **7 号针脚** 是 **BCM 7 号针脚** 并被标记为 **GPIO 4**。

我们可以选择遵循 **板** 或 **BCM** 编号系统。然而，根据我们用来访问的 GPIO 编程库，使用该两种编号系统可能会遇到困难。大多数库都偏好 BCM 编号系统， 因为它引用于 Broadcom CPU 芯片。

> 从现在开始，如果我使用 **x 号引脚**，就意味着这是针脚板上的 **物理针脚编号**。BCM 针脚编号会同 BCM 共同提及。

#### 💡 电源针脚和组针脚

**1 号** 和 **17 号** 针脚提供 **3.3 伏** 恒定功率， 而 **2 号** 和 **4 号** 针脚提供 **5 伏** 恒定功率。 These pins provide **constant power** 当你打开树莓派时，这些针脚便提供 **恒定功率** ，并且无论如何这些针脚都是 **不可编程的** 。

**6 号**、 **9 号**、 **14 号**、 **20 号**、 **25 号**、 **30 号**、 **34 号** 和 **39 号** 针脚支持接地连接。它们应该与电路的 **阴极** 连接。电路中所有的接地连接都可以用同一个接地针脚，因为它们都连接到同一根地线。

> 如果你想知道为什么有这么多接地针脚，那么你可以跟着 [**这条线**](https://www.raspberrypi.org/forums/viewtopic.php?t=132851).

#### 🔌 GPIO 针脚

除了 **电源** 和 **接地** 针脚外，其他针脚均为通用输入和输出针脚。当 GPIO 针脚用于 **输出模式** 时，它在开启时提供 3.3V 恒定功率。

在 **输入模式** 下，GPIO 针脚也可用于监听外部电源。技术上，当 **3.3V** 功率供给 GPIO 针脚时（**处于输入模式**），该针脚将被读取为 **逻辑高电平** 或 **1**。当针脚接地或提供 **0V** 功率时，它被读作 **逻辑低电平** 或 **0**。

The output mode is fairly straightforward. In the output mode, we turn on a pin and it sends the 3.3V through the pin. However, in the input of a pin, we need to listen for voltage changes on the pin and when the pin is at the logical high or low, we can do other things like turn on an output GPIO pin.输出模式相当简单。在输出模式下，我们接通一个针脚，设备通过该针脚传送 3.3V 功率。然而，在针脚的输入端，我们需要监听针脚上的电压变化，当引脚处于逻辑高电平或低电平时，我们可以执行其他操作，如打开 GPIO 输出针脚。

#### 🧙‍♀️ SPI、 I²C 和 UART 协议

SPI ([**Serial Peripheral Interface (串行外设接口)**](https://en.wikipedia.org/wiki/Serial_Peripheral_Interface)) 是一种同步串行通信接口， 设备使用它来实现相互间的通信。此接口需要 3 条或更多数据线将主设备连接到从设备（**一条或多条**）。

I²C ([**Inter-Integrated Circuit (内置集成电路)**](http://C)) 类似于 SPI，但它支持多个主设备。此外，与 SPI 不同，它只需要两条数据线来容纳无限数量的从机。不过这会让 I²C 比 SPI 慢。

UART ([Universal asynchronous receiver-transmitter (通用异步收发信机)](https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter)) 也是一个串行通信接口，但数据是 [**异步**](https://en.wikipedia.org/wiki/Asynchronous_serial_communication) 发送的。

树莓派提供了一个低级接口用于通过 GPIO 针脚启用这些接口，就像我们前文讨论过的输入输出模式一样。然而，并非所有的 GPIO 针脚都可以通过这种通信进行配置。

在下图中，你可以看到哪些 GPIO 针脚可以通过 SPI、I²C 和 UART 协议进行配置。你可以访问 **[pinout.xyz](https://pinout.xyz/).** 此网站应用程序提供了一个交互界面供用户查看每个 GPIO 针脚的功能。

![(来源：[**pinout.xyz**](https://pinout.xyz/))](https://cdn-images-1.medium.com/max/2000/1*mpKa3QDHL6G5CmjmMWX3UQ.png)

除了在简单的输入或输出模式下，GPIO 针脚可以在 **6 模式** 下工作，但只能工作一次。当你 (**在上述网站**) 点击 GPIO 针脚时，你可以在屏幕右侧看到它的工作模式。右表中的 ALT0 至 ALT5 提到了这些。

> 你可以通过 [**本视频**](https://www.youtube.com/watch?v=IyGwvGzrqp8) 了解这些通信协议的规范。在本教程中，我们不会涉及这些通信协议，但是，我将在接下来的文章中讨论相关主题。

#### ⚡ 现行规范

我们已经讨论过电源和 GPIO 针脚的电压规格。因为树莓派官方文件中未曾提及，所以现行规范不太明晰。

然而，我们在处理电流时，都需要遵循安全预防措施。可从任何针脚获取的最大电流应小于或等于 **16mA**。因此，我们必须调整负载以满足这一要求。

如果我们已经将多个设备连接到树莓派 GPIO 和其他端口，如 USB，那么我们必须确保从电路获取的最大电流小于 **50mA**。

为了限制电流，我们可以在电路中增加电阻，使得最大电流不会超过这些限制。当一个设备需要比树莓派更多电流时，我们应该使用继电器开关来代替。

**输入** 模式使用的也是相同的规范。当 GPIO 针脚被用作 **漏** （**而非** 源 **电流**）时，我们不应该供应超过 **16mA** 的电流。此外，当多个 GPIO 针脚用作输入时，总共不应施加超过 **50mA** 的电流。

---

## 前提条件

我相信你已经走过一遍树莓派的设置流程。这意味着你已经安装了一个像 [**Raspbian**](https://www.raspberrypi.org/downloads/raspbian/) 这样或你个人偏好的操作系统，并且可以通过 SSH 或 HDMI访问它。

我们需要做的第一件事就是创建项目目录。我已经在 `/home/pi/Programs/io-examples` 这个路径下创建了项目目录，我们所有的程序都将作为教程示例保存在该路径下。

由于我们想通过 Node.js 来控制 GPIO 针脚，首先我们必须安装 Node。你可以选择你最喜欢的方法，但我个人会使用 **[NVM](https://github.com/nvm-sh/nvm)** (**节点版本管理器**)。你可以遵循 [**该建议步骤**](https://github.com/nvm-sh/nvm#install--update-script) 安装。

一旦安装了 NVM，我们可以继续安装特定版本的节点。我将使用节点 v12，因为它是最新的稳定版本。要安装节点 v12，请输入以下命令行：

```
$ nvm install 12
$ nvm use 12
```

一旦树莓派安装了了 Node.js，我们就可以继续进行项目创建了。因为我们想要控制 GPIO 引脚，所以我们需要一个库来为我们提供一个简单的应用编程接口。

树莓派一个控制 GPIO 的大库是 [**开关**](https://www.npmjs.com/package/onoff)。 首先，从项目目录中创建 .json 包，然后安装 `onoff` 包。

```
$ cd /home/pi/Programs/io-examples
$ npm init -y
$ npm i -S onoff
```

现在一切准备就绪，我们可以开始电路设计并编写第一个程序来测试 GPIO 的能力。

---

## LED 输出示例

在本例中，我们将以编程方式打开红色 LED。让我们先看看下面的电路图：

![(简单 LED 输出)](https://cdn-images-1.medium.com/max/3126/1*aarORNzRCTnQlSL-F6pe5Q.png)

从上图可以看出，我们已经将 **6 号引脚** （**接地引脚**） 连接到了线路板的负轨 （**地线**) 上，并将 **BCM 4** 连接到 **1k 欧姆** 电阻的一端。电阻器的另一端连接到红色 LED 的输入端，LED 的输出端接地。

除了电阻，这个电路没什么特别的。需要该电阻是因为红色 LED 在 **2.4V** 电压下工作，而提供 **3.3V** 电压的 GPIO 会损坏 LED。此外，LED 采用的 **20mA** 超过了树莓派的安全限值，因此，电阻也可防止其电流过大。

> 我们可以选择 330 欧姆到 1k 欧姆的电阻。这会影响电流，但不会损坏发光二极管。

从上述电路来看，电路中唯一的变量是 BCM 4 引脚输出。如果引脚打开（**3.3V**），电路将关闭，发光二极管将发光。如果引脚关闭（**0V**），电路打开，发光二极管不会发光。

让我们编写一个程序，实现以编程方式打开 BCM 4引脚。

```JavaScript
const { Gpio } = require( 'onoff' );

// set BCM 4 pin as 'output'
const ledOut = new Gpio( '4', 'out' );

// current LED state
let isLedOn = false;

// run a infinite interval
setInterval( () => {
  ledOut.writeSync( isLedOn ? 0 : 1 ); // provide 1 or 0 
  isLedOn = !isLedOn; // toggle state
}, 3000 ); // 3s
```

在上述程序中， 我们导入 `onoff` 包并提取 `Gpio` 构造函数。 `Gpio` 类用某种配置来配置一个 GPIO。上上述例子当中，我们将 **BCM 4** 设置为 **输出模式**。

> 您可以参考该 `onoff` 模块的 [**应用编程接口文档**](https://github.com/fivdi/onoff#api) 来理解各种配置选项和应用编程接口方法。

`Gpio` 类的一个实例提供了与该引脚交互的高级应用编程接口。`writeSync` 方法将 **1** 或 **0** 写入引脚，以实现开启或禁用引脚。当引脚设为 **1** 时，引脚 **开启** 并输入 **3.3V** 电源。当它设为 **0** 时，引脚 **关闭** 且不提供任何电源 (**0V**)。

使用 `setInterval` 时，我们就是在运行一个无限循环，在 `ledOut` 引脚中写入 0 或 1 来调用 `ledOut.writeSync(val)` 方法。让我们使用 Node.js 来运行这个程序。

```
$ node rpi-led-out.js
```

由于这个一个无限循环的程序，一经启动，该程序就不会终止，除非我们使用 `ctrl + c` 来进行强制中断。在该程序的生命周期内，它将每隔 **3 秒** 切换一次 **BCM 4** 引脚。

树莓派 GPIO 有意思的一点是，一旦 GPIO 引脚设为 **1** 或 **0**，它将一直保持不变， 除非我们覆盖该值或关闭树莓派的电源。当你启动程序时，LED 熄灭，但当你终止程序时，LED 可能会保持亮起。

## Switch 输入示例

众所周知，当 GPIO 用作输入时，我们需要提供接近 **3.3V** 的电压。我们可以连接一个开关 (**按钮**) 直接从 **3.3V** 引脚提供电压，如下图所示：

![(简单按钮输入)](https://cdn-images-1.medium.com/max/3126/1*8TUu5IGDaYm0movHCM9hww.png)

在输入开关之前，我们已经使用了一个 **1K 欧姆** 的电阻以在电路中提供电阻。这将防止从 **3.3V** 电源汲取过多电流，并防止开关熔断。

我们还连接了一个 **10K 欧姆** 电阻，该电阻也从按钮的输出端汲取电流并接地。这些类型的电阻器 (**因为它们在电路中的位置**) 被称为 **下拉** 电阻器，因为它们将电流 (**或大气电荷聚集**) 排放至地面。

> 我们也可以增加一个 **上拉寄存器** ，从 **3.3V** 引脚汲取电流，并供给输入 GPIO 引脚。在这种配置下，输入引脚始终读取 **高** 或 **1**。按下按钮时，开关在电阻和地面之间产生短路，将所有电流排放到地面，并且没有电流通过开关到达输入引脚，读数为 **0**。 [**此处有一段很棒的视频**](https://www.youtube.com/watch?v=5vnW4U5Vj0k) 演示了上拉和下拉电阻。

开关的输出连接到 **BCM 17** 引脚。当按下按钮（**开关**）时，电流将通过开关流入 BCM 17 引脚。然而，由于 10K 欧姆 电阻给电流提供了更大的障碍，大多数电流流过由 **红色虚线** 表示的回路。

为按下按钮时，由红色虚线表示的回路闭合，没有电流流过。然而，由 **灰色虚线** 表示的环路是闭合的，BCM 17 引脚接地 （**0V**）。

> 增加一个 10k 欧姆电阻的主要原因是将 BCM 17 引脚接地，这样它就不会将任何大气干扰读取为高输入。不将输入引脚接地， 我们可以将输入引脚保持在 **浮动状态**。在这种状态下，由于大气干扰，输入引脚可以读取为 0 或 1。

既然电路已经准备好了，让我们编写一个程序来读取输入值。

```JavaScript
const { Gpio } = require( 'onoff' );

// set BCM 17 pin as 'input'
const switchIn = new Gpio( '17', 'in', 'both' );

// listen for pin voltage change
switchIn.watch( ( err, value ) => {
  if( err ) {
    console.log( 'Error', err );
  }

  // log pin value (0 or 1)
  console.log( 'Pin value', value );
} );
```

在以上程序中，我们已经将 **BCM 17** 引脚设置为输入模式。`Gpio` 构造函数的第三个参数配置我们想要得到引脚输入电压变化的通知的时间。该参数标记为 **`edge`** 参数，因为我们读取的是电压上升和下降周期的边缘值。

`edge` 参数可以有以下值：

当使用 `上升` 值时，如果 GPIO 引脚的输入电压 **从 0V 上升**（**至 3.3V**）时，我们将收到通知。位于此位置时，引脚将读取 **逻辑高** 或 **1** ，因为他获得了正电压。

当使用 `下降` 值时，如果输入电压（**从 3.3V**） **降至 0V**，我们将收到通知。位于此位置时，引脚将读取 **逻辑低** 或 **0** ，因为它正在失去电压。

当使用 `两种` 值时，我们将收到上述两个事件的通知。当电压从 0V（**输入高电平或 1**）上升或从 3.3V（**输入低电平或 0**）下降时，我们可以立即收听到这些事件。

> 此处不讨论 `none` 值，请阅读 [**文档**](https://github.com/fivdi/onoff#gpiogpio-direction--edge--options) 了解更多信息。

输入模式下 GPIO 引脚上的 `监听` 方法监视上述事件。这是一个异步方法，因此我们需要传递一个回调函数，该函数接收输入高 (1) 或输入低 (0) 值。

由于我们使用的是 `两种` 值，所以 `监听` 方法将在输入电压上升时以及输入电压下降时执行回调。按下按钮，你应该在控制台中获得以下值：

```
Pin value 1 (按下按钮)
Pin value 0 (释放按钮)
Pin value 1 (按下按钮)
Pin value 1 (重复值)
Pin value 0 (按下按钮)
```

如果仔细检查以上输出就能发现，我们有时会在按下或释放按钮时得到重复的值。由于开关机制的两个连接器之间的物理连接并不总那么顺畅，所以，不小心按下开关时，它可以多次连接和断开。

为了避免这种情况，我们可以在开关电路中增加电容，在实际电流流入 GPIO 引脚之前充电，并在按钮释放时平稳放电。该操作非常简单，你可以试一试。

## 组合 I/O 示例

现在我们已经充分理解了 GPIO 引脚的工作原理以及配置方法，让我们结合最后两个例子进行讲解。更重要的是，按下按钮时，打开 LED 而释放按钮时将其关闭。 让我们先看看电路图：

![(简单 I/O 示例)](https://cdn-images-1.medium.com/max/3126/1*c0iV6t3t2yPUVyT0mhU3OA.png)

从以上例子可以看出，我们没有从上面得两个例子中改变任何东西。另外，LED 和开关电路都是独立的。这意味着我们之前得程序在这条线路上应该可以正常工作。

```JavaScript
const { Gpio } = require( 'onoff' );

// set BCM 4 pin as 'output'
const ledOut = new Gpio( '4', 'out' );

// set BCM 17 pin as 'input'
const switchIn = new Gpio( '17', 'in', 'both' );

// listen for pin voltage change
switchIn.watch( ( err, value ) => {
  if( err ) {
    console.log( 'Error', err );
  }

  // write the input value (0 or 1) 'ledOut' pin
  ledOut.writeSync( value );
} );
```

在上述程序中，我们将 GPIO 引脚分别配置为输入和输出模式。由于输入引脚上的 `监听` 方法提供的值是 **0** 或 **1**，因此，我们可以使用相同的值写入输出引脚。

因为我们在`两种` 模式下监视 `切换` 输入引脚, the `watch` will get triggered 当按下按钮发送 `值` **1** 时，以及当释放按钮发送 `值` **0** 时，`监视` 方法将被触发。

我们可以直接使用该值写入 `输入` 引脚。因此，按下按钮时，`值` 为 `1` 而 `ledOut.writeSync(1)` 将打开 LED。按下按钮时，储备发生。

---

![(演示)](https://cdn-images-1.medium.com/max/2000/1*a35VFbnt_AUM0ch8ftCxMA.gif)

以上是我们刚才创建得完整输入/输出电路的演示。为了你本人和树莓派的安全，建议你买一个好的外壳和 40 针 GPIO 扩展带状电缆。

希望你今天能学到一点东西。在接下来的教程中，我们将构建一些复杂的电路并学习连接一些有意思的设备，如字符 LCD 显示屏和数字输入板。

---

![([**GitHub**](https://github.com/thatisuday) / [**Twitter**](https://twitter.com/thatisuday))](https://cdn-images-1.medium.com/max/7898/1*waznApGKL0XENm0UbkCo_A.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
