> * 原文地址：[An introduction to Raspberry Pi 4 GPIO and controlling it with Node.js](https://itnext.io/an-introduction-to-raspberry-pi-4-gpio-and-controlling-it-with-node-js-10f2ce41af12)
> * 原文作者：[Uday Hiwarale](https://medium.com/@thatisuday)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/an-introduction-to-raspberry-pi-4-gpio-and-controlling-it-with-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/an-introduction-to-raspberry-pi-4-gpio-and-controlling-it-with-node-js.md)
> * 译者：[Weirdochr](https://github.com/Weirdochr), [lsvih](https://github.com/lsvih)
> * 校对者：[xionglong58](https://github.com/xionglong58)

# 树莓派 4 GPIO 简介及使用 Node.js 控制树莓派

> 树莓派 + NODE.JS  
> 通过本文，我们将熟悉树莓派 GPIO 及其技术规范。并且，我们将通过了一个简单例子，说明如何使用树莓派的 I/O 控制 LED 和开关。

![(文章来源：[**pexels.com**](https://www.pexels.com/photo/have-a-break-led-signage-2249342/))](https://cdn-images-1.medium.com/max/12000/1*t-dr_5CrKf45RE0Uuww2sg.jpeg)

你可能见过 “**IoT**” 这个术语，它是 **Internet of Things（物联网）** 的缩写。意思是，人们可以通过互联网控制一台设备（即“物” **thing**）。比如，用手机控制你房间内的智能电灯泡就是一种物联网的应用。

由于物联网设备可通过互联网控制，所以 IoT 设备需要始终与互联网相连。我们主要有两种方式将设备连接至互联网：以太网网线和 WiFi。

物联网设备可被用于各种目的。例如，你可以使用物联网来控制你家的室内温度、照明或者在回家前打开某些设备，所有这些操作都只需要通过你的手机便能实现。

那么，物联网设备的技术规范有哪些？简言之，它应该包含连接到互联网的工具，有一些输入和输出接口来读写设备的模拟或数字信号，并且使用最少的硬件来读取和执行程序指令。

一个物联网设备配有一个硬件组件，为外部设备读取数字数据和取电提供接口。该接口就是 **GPIO** 或称作 **General Purpose Input Output（通用输入输出接口）** 。这种硬件组件基本上都是由一系列可以连接到外部设备的引脚（或管脚，pin）构成。

这些 GPIO 引脚可以被程序控制。比如，在满足一些条件的情况下，我们可以给一个 GPIO 引脚施以 5V 的电压，任何连接到该引脚的设备都会被开启。程序也能够监听来自互联网的信号，并根据该信号对 GPIO 引脚进行控制。这就是物联网。

从头开始构建这样一个物联网设备可能很困难，因为需要处理的组件有很多。幸运的是，我们可以购买售价低廉的现成的设备。这些设备配有 GPIO 硬件和连接互联网的工具。

#### Arduino 微控制器

目前，如果我们想要实现简单的自动化，那么 [**Arduino**](https://en.wikipedia.org/wiki/Arduino) 是最好的选择。它是一个 **微控制器（micro-controller）** ，可以用 C 和 C++ 这样的编程语言来编写 Arduino 程序。

![(来源：[**Wikipedia**](https://en.wikipedia.org/wiki/File:Arduino_Uno_-_R3.jpg))](https://cdn-images-1.medium.com/max/2000/1*-Tmb_Q7yYmmtFGaUk6iv4A.jpeg)

然而，该控制器不配有内置 WiFi 或以太网插孔，并且必须连接外部外围设备（即**屏蔽**）才能将 Arduino 连接到互联网。

Arduino 旨在充当外部设备的控制器，而不是成熟的物联网设备。因此，该控制器价格非常便宜，某些最新款的售价可以低至 18 美元。

#### 树莓派微型电脑

相较于 Arduino，[**树莓派**](https://en.wikipedia.org/wiki/Raspberry_Pi) 更像是一只**野兽**。其发明之初的目的就是为了促进基础计算机科学教学在学校和发展中国家的进步。但它现在却被书呆子和业余爱好者们捡起来创造各种各样的小玩意儿。目前，它是世界上最受欢迎的**单板计算机**之一。

树莓派（**最新版 4B**）配有以太网连接器、WiFi、蓝牙、HDMI 输出、USB 连接器、 40 个 GPIO 引脚和其他基本功能。它由 **ARM** CPU、 **博通** GPU 和 1/2/4 GB 的 **RAM** 驱动。你可以在[**此维基百科**](https://en.wikipedia.org/wiki/Raspberry_Pi#Specifications)的表格中查看这些规范。

![(来源：[**Wikipedia**](https://en.wikipedia.org/wiki/File:Raspberry_Pi_4_Model_B_-_Side.jpg))](https://cdn-images-1.medium.com/max/2000/1*WE-9WUau6aQlMSHVLjq9KQ.jpeg)

尽管树莓派的硬件很丰富，但它最新版的售价也仅在 \$40 到 \$80 间。别忘了，这可是一台拥有原生操作系统的成熟计算机。这意味着我们不需要连接外部计算机就能对其进行编程。

与我们日常使用的电脑不同，树莓派提供了一个 GPIO 硬件组件来控制外部设备。这使得树莓派成为了一种几乎可以做任何事情的设备。

让我们了解一下新版树莓派 GPIO 的技术规格。

---

## 树莓派 - GPIO 引脚分配

树莓派（**4B 版**）总共 **40 个 GPIO 引脚**，分布在 `20 x 2` 的阵列当中。如下图所示，每个引脚都有特定的用途。

![(来源：[**raspberrypi.org**](https://www.raspberrypi.org/documentation/usage/gpio/))](https://cdn-images-1.medium.com/max/4128/0*VsaGvGskvJa20hZa.png)

在讨论每个引脚的功能之前，让我们先了解一些协议。每个引脚都有特定的编号，我们就是通过这些编号从软件中控制这些引脚。

在圆圈中，你可以看到的数字是 GPIO 硬件上的物理引脚编号。例如：**1 号引脚** 提供 3.3V 的恒定电压。该编号系统称为 **Board pin** 或**物理引脚**编号系统。

由于树莓派 4B 使用 [**BCM2711**](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2711/README.md) 处理器芯片，因此，我们还有另一个由[**博通**](https://en.wikipedia.org/wiki/Broadcom_Inc.)创建的引脚编号系统。此系统被称为 **BCM** 或 **博通模式**。上图中，每个引脚附带的标签都显示了 BCM 引脚编号。例如：物理 **7 号引脚**是 **BCM 7 号引脚**并被标记为 **GPIO 4**。

我们既可以选择遵循 **Board pin** 编码，也可以用 **BCM** 编码系统。然而，由于我们用 GPIO 编程库的原因，同时使用该两种编码系统可能会遇到问题。大多数库都偏好于 BCM 编号系统，因为它引用于博通 CPU 芯片。

> 从现在开始，如果文中出现 **x 号引脚**，就意味着这是引脚板上的**物理引脚编号**。如果提到了 BCM，则意味着我们在使用 BCM 引脚编号。

#### 💡 电源引脚和引脚分组

**1 号**和 **17 号**引脚提供 **3.3V** 电源，而 **2 号**和 **4 号**引脚提供 **5V** 电源。当你打开树莓派时，这些引脚便会提供**恒定功率**，并且无论在何种条件下，这几个引脚都是**不可编程的**。

**6 号**、 **9 号**、 **14 号**、 **20 号**、 **25 号**、 **30 号**、 **34 号**和 **39 号**引脚支持接地。它们应该与电路的**阴极**相连。电路中所有的接地连接都可以用同一个接地引脚，因为它们都连接到同一根地线。

> 如果你想知道为什么有这么多接地引脚，可以查看[**这个帖子**](https://www.raspberrypi.org/forums/viewtopic.php?t=132851)。

#### 🔌 GPIO 引脚

除了**电源**和**接地**引脚外，其他引脚均为通用输入和输出引脚。当 GPIO 引脚用于**输出模式**时，它在开启时提供 3.3V 恒定功率。

在**输入模式**下，GPIO 引脚也可用于监听外部电源。从技术上看，当用 **3.3V** 电压供给处于输入模式的 GPIO 引脚时，该引脚将被读取为**逻辑高电平**或 **1**。当引脚接地或提供 **0V** 功率时，它会被读作**逻辑低电平**或 **0**。

而**输出模式**更加简单。在输出模式下，我们接通一个引脚，设备会通过该引脚提供 3.3V 的电压。而在引脚的输入端，我们需要监听引脚上的电压变化，当引脚处于逻辑高电平或低电平时，我们可以执行其他操作，如打开一个输出 GPIO 引脚。

#### 🧙‍♀️ SPI、 I²C 和 UART 协议

SPI（[**Serial Peripheral Interface (串行外设接口)**](https://en.wikipedia.org/wiki/Serial_Peripheral_Interface)）是一种同步串行通信接口，设备可以使用它来实现相互间的通信。此接口需要 3 条或更多数据线将主设备连接到（**一个或多个**）从设备。

I²C（[**Inter-Integrated Circuit (内置集成电路)**](http://C)）类似于 SPI，但它支持多个主设备。此外，与 SPI 不同，它只需要两条数据线来容纳多个从机。不过这会让 I²C 比 SPI 慢。

UART（[Universal asynchronous receiver-transmitter (通用异步收发传输器)](https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter)）也是一个串行通信接口，但数据是[**异步**](https://en.wikipedia.org/wiki/Asynchronous_serial_communication)发送的。

树莓派提供了一个底层接口用于通过 GPIO 引脚就像我们前文讨论过的输入输出模式一样启用这些接口。然而，并非所有的 GPIO 引脚都可以实现这些通信方式。

在下图中，你可以看到哪些 GPIO 针脚是可以通过 SPI、I²C 和 UART 协议进行配置的。你可以访问 **[pinout.xyz](https://pinout.xyz/)**，这个网页提供了一个交互界面供用户查看每个 GPIO 引脚的功能。

![(来源：[**pinout.xyz**](https://pinout.xyz/))](https://cdn-images-1.medium.com/max/2000/1*mpKa3QDHL6G5CmjmMWX3UQ.png)

除了简单的输入或输出模式，GPIO 引脚有 **6 种模式**，但每次只能在一种模式下工作。当你在上面那个网页中点击 GPIO 引脚时，你可以在屏幕右侧看到它的工作模式。右表中的 ALT0 至 ALT5 描述了这些模式。

> 你还可以通过[**这个视频**](https://www.youtube.com/watch?v=IyGwvGzrqp8)来了解这些通信协议的规范。在本教程中，我们不会涉及这些通信协议，但是，我将在接下来的文章中讨论相关主题。

#### ⚡ 现行规范

我们已经讨论过电源和 GPIO 引脚的电压规格。因为树莓派官方文件中未曾提及具体规范，所以现行规范还不太明确。

不过可以确定的是，我们在处理电流时，必须要遵循安全措施：从任何引脚获取的最大电流应小于或等于 **16mA**。因此，我们必须调整负载以满足这一要求。

如果我们已经将多个设备连接到树莓派 GPIO 和其他端口（如 USB），那么我们必须确保从电路获取的最大电流小于 **50mA**。

为了限制电流，我们可以在电路中增加电阻，使得最大电流不会超过这些限制。当一个设备需要的电流比树莓派的最大限制还要大时，应当使用继电器开关。

**输入**模式使用的也是相同的规范。当 GPIO 引脚被用作**漏极**（**而非** 源 **电流**）时，我们不应该供应超过 **16mA** 的电流。此外，当多个 GPIO 引脚用作输入时，总共不应施加超过 **50mA** 的电流。

---

## 前提条件

我相信你已经走过一遍树莓派的设置流程。这意味着你已经安装了一个 [**Raspbian**](https://www.raspberrypi.org/downloads/raspbian/) 之类的或是你个人偏好的操作系统，并且可以通过 SSH 或 HDMI 访问它。

我们需要做的第一件事就是创建项目目录。我已经在 `/home/pi/Programs/io-examples` 这个路径下创建了项目目录，我们所有的程序都将作为教程示例保存在该路径下。

由于我们想通过 Node.js 来控制 GPIO 引脚，首先我们必须安装 Node。你可以选择你最喜欢的方法，但我个人会使用 **[NVM](https://github.com/nvm-sh/nvm)**（Node 版本管理器）来安装。你可以遵循[**该建议步骤**](https://github.com/nvm-sh/nvm#install--update-script)安装 NVM。

一旦装好了 NVM，我们就可以安装特定版本的 Node。我将使用 Node v12，因为它是最新的稳定版本。要安装 Node v12，请输入以下命令行：

```bash
nvm install 12
nvm use 12
```

一旦树莓派安装了 Node.js，我们就可以继续创建项目了。因为我们想要控制 GPIO 引脚，所以我们需要一个库来为我们提供一个简单的应用编程接口。

[**onoff**](https://www.npmjs.com/package/onoff) 是一个知名的用树莓派控制 GPIO 的库。首先，在项目目录中创建 package.json，然后安装 `onoff` 包。

```bash
cd /home/pi/Programs/io-examples
npm init -y
npm i -S onoff
```

现在一切准备就绪，我们可以开始电路设计并编写第一个程序来测试 GPIO 的能力。

---

## LED 输出示例

在本例中，我们将以编程方式打开红色 LED。让我们先看看下面的电路图：

![(简单 LED 输出)](https://cdn-images-1.medium.com/max/3126/1*aarORNzRCTnQlSL-F6pe5Q.png)

从上图可以看出，我们已经将 **6 号引脚**（**接地引脚**）连接到了线路板的负极（**地线**）上，并将 **BCM 4** 连接到了 **1k ohm** 电阻的一端。电阻器的另一端连接到红色 LED 的输入端上，LED 的输出端接地。

除了有个电阻，这个电路没什么特别的。需要这个额外的电阻是因为红色 LED 在 **2.4V** 电压下工作，而提供 **3.3V** 电压的 GPIO 会损坏 LED。此外，LED 采用的 **20mA** 超过了树莓派的安全阈值，因此，也需要这个电阻来防止电流过大。

> 我们可以选择 330 ohms 到 1k ohms 的电阻。这个数值范围的电阻会影响电流大小，但都不会损坏 LED。

从上述电路来看，电路中唯一的变量是 BCM 4 引脚输出。如果引脚打开（**3.3V**），电路将闭合，LED 将发光。如果引脚关闭（**0V**），电路断开，LED 不会发光。

让我们编写一个程序，实现以编程方式打开 BCM 4 引脚。

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

在上述程序中， 我们导入 `onoff` 包并引入 `Gpio` 构造函数。用设定好的配置创建 `Gpio` 类来配置一个 GPIO。上面的例子中，我们将 **BCM 4** 设置成了**输出模式**。

> 你可以参考该 `onoff` 模块的 [**API 文档**](https://github.com/fivdi/onoff#api)来了解各种配置选项和 API。

`Gpio` 类创建的实例提供了与该引脚交互的高阶 API。`writeSync` 方法会将 **1** 或 **0** 写入引脚，以实现开启或关闭引脚。当引脚设为 **1** 时，引脚**开启**并输入 **3.3V** 电源。当它设为 **0** 时，引脚会**关闭**且不再提供任何电源电压（**0V**）。

使用 `setInterval` 时，我们就是在运行一个无限循环，不断地调用 `ledOut.writeSync(val)` 方法在 `ledOut` 引脚中写入 0 或 1。让我们使用 Node.js 来运行这个程序：

```bash
node rpi-led-out.js
```

由于这是一个无限循环的程序，一旦启动，它就不会终止，除非我们使用 `ctrl + c` 强制终止程序。在该程序的生命周期内，它将每隔 **3 秒**切换一次 **BCM 4** 引脚的状态。

树莓派 GPIO 有意思的一点是，一旦 GPIO 引脚被设为 **1** 或 **0**，它将一直保持不变， 除非我们覆盖该值或关闭树莓派的电源。比如，当你启动程序时，LED 处于熄灭状态，但当你终止程序时，LED 可能会保持亮起状态。

## 开关输入示例

众所周知，当把 GPIO 用作输入时，我们需要提供接近 **3.3V** 的电压。我们可以连接一个开关（**按钮**）直接从 **3.3V** 引脚提供电压，如下图所示：

![(简单按钮输入)](https://cdn-images-1.medium.com/max/3126/1*8TUu5IGDaYm0movHCM9hww.png)

在输入开关之前，我们已经在电路中使用了一个 **1K ohm** 的电阻。它能防止 **3.3V** 电源产生过大的电流，避免开关熔断。

我们还连接了一个 **10K ohm** 电阻，该电阻也从按钮的输出端汲取电流并接地。这类电阻被称为**下拉**电阻（**因为它们在电路中的位置**），它们会将电流（**或大气中电荷聚集产生的电流**）导向地面。

> 我们也可以增加一个**上拉电阻**，从 **3.3V** 引脚导出电流，供给给 GPIO 的输入引脚。在这种配置下，输入引脚会始终读取 **高** 或 **1**。按下按钮时，开关在电阻和地面之间产生短路，将所有电流导向地面，并且没有电流通过开关到达输入引脚，读数为 **0**。[**此处有一段很棒的视频**](https://www.youtube.com/watch?v=5vnW4U5Vj0k)演示了上拉和下拉电阻。

开关的输出连接到 **BCM 17** 引脚。当按下按钮（**开关**）时，电流将通过开关流入 BCM 17 引脚。然而，由于 10K ohm 电阻给电流提供了更大的障碍，大多数电流会流向由**红色虚线**表示的回路。

未按下按钮时，由红色虚线表示的回路闭合，没有电流流过。然而，由**灰色虚线**表示的环路是闭合的，BCM 17 引脚接地（**0V**）。

> 增加一个 10k ohm 电阻是为了让 BCM 17 引脚接地，这样它就不会将任何大气干扰读取为高输入。如果不将输入引脚接地，输入引脚会保持在**浮动状态**。在这种状态下，由于大气干扰，输入引脚可能读取为 0 或 1。

既然电路已经准备好了，让我们编写一个程序来读取输入值：

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

在上面的程序中，我们将 **BCM 17** 引脚设置为输入模式。`Gpio` 构造函数的第三个参数配置了我们何时需要引脚输入电压变化的通知。该参数名为 **`edge`**，因为我们读取的是电压上升和下降周期的边缘电压值。

`edge` 参数可以有以下值：

当使用 `rising` 值时，如果 GPIO 引脚的输入电压**从 0V 上升**（**至 3.3V**），我们将收到通知。位于此位置时，引脚将读取**逻辑高位**或 **1**，因为该引脚获得了更高的电压。

当使用 `falling` 值时，如果输入电压（**从 3.3V**） **降至 0V**，我们将收到通知。位于此位置时，引脚将读取**逻辑低位**或 **0**，因为它正在失去电压。

当使用 `both` 值时，我们将收到上述两个事件的通知。当电压从 0V 上升（**至输入高电平或 1**）或从 3.3V 下降（**至输入低电平或 0**）时，我们都会收到到这些事件的通知。

> 此处不讨论 `none` 值，请阅读[**文档**](https://github.com/fivdi/onoff#gpiogpio-direction--edge--options)了解更多信息。

输入模式下 GPIO 引脚上的 `watch` 方法监视上述事件。这是一个异步方法，因此我们需要传递一个回调函数，该函数接收输入高（1）或输入低（0）值。

由于我们使用的是 `both` 值，所以 `watch` 方法将在输入电压上升时以及输入电压下降时都执行回调。按下按钮，你应该会在控制台中看到下面的值：

```
Pin value 1 (按下按钮)
Pin value 0 (释放按钮)
Pin value 1 (按下按钮)
Pin value 1 (重复值)
Pin value 0 (按下按钮)
```

如果仔细检查以上输出就能发现，我们有时会在按下或释放按钮时得到重复的值。由于开关机制的两个连接器之间的物理连接并不总那么顺畅，所以，不小心按下开关时，它可以多次连接和断开。

为了避免这种情况，我们可以在开关电路中增加电容，在实际电流流入 GPIO 引脚之前充电，并在按钮释放时平稳放电。这种方法非常简单，你可以试一试。

## 组合 I/O 示例

现在我们已经充分理解了 GPIO 引脚的工作原理以及配置方法，让我们结合最后两个例子进行讲解。更重要的是，按下按钮时，打开 LED 而释放按钮时关闭 LED。让我们先看看电路图：

![(简单 I/O 示例)](https://cdn-images-1.medium.com/max/3126/1*c0iV6t3t2yPUVyT0mhU3OA.png)

从以上例子可以看出，我们没有从上面的两个例子中改变任何东西。另外，LED 和开关电路都是独立的。这意味着我们之前的程序在这条线路上应该可以正常工作。

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

在上述程序中，我们将 GPIO 引脚分别配置为输入和输出模式。由于输入引脚上的 `watch` 方法提供的值是 **0** 或 **1**，因此，我们直接把这些值写入输出引脚。

因为我们在 `both` 模式下用 `watch` 方法监视输入引脚，当按下按钮发送 **1** 或者释放按钮发送 **0** 时，`watch` 方法的回调将被触发。

我们可以直接使用该值写入 `ledOut` 引脚。因此，按下按钮时，`value` 为 `1` 并执行 `ledOut.writeSync(1)`，会打开 LED。松开按钮时则反之。

---

![(演示)](https://cdn-images-1.medium.com/max/2000/1*a35VFbnt_AUM0ch8ftCxMA.gif)

以上是我们刚才创建的完整输入/输出电路的演示。为了你本人和树莓派的安全，建议买一个好的外壳和 40 针 GPIO 扩展带状电缆。

希望你今天能学到一点东西。在接下来的教程中，我们将构建一些复杂的电路并学习连接一些有意思的设备，如字符 LCD 显示屏和数字输入板。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
