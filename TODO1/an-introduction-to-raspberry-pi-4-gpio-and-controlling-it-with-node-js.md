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

From the above circuit, the only variable in the circuit is BCM 4 pin output. If the pin is on (**3.3V**), the circuit will close and LED will glow. If the pin is off (**0V**), the circuit is open and LED won’t glow.

Let’s write a program that can programmatically turn on the BCM 4 pin.

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

In the above program, we are importing `onoff` package and extracting `Gpio` constructor. The `Gpio` class configures a GPIO with a certain configuration. In the above example, we have set **BCM 4** in the **output mode**.

> You can follow [**this API documentation**](https://github.com/fivdi/onoff#api) of the `onoff` module to understand various configurations options and API methods.

An instance of `Gpio` class provides high-level API to interact with that pin. The `writeSync` method writes either **1** or **0** to the pin which enables or disables it. When a pin is set to **1**, it turns **on** and outputs the **3.3V** power. When it is set to **0**, it turns **off** and does not provide any power (**0V**).

Using `setInterval`, we are running an endless loop that writes either 0 or 1 to the `ledOut` pin using `ledOut.writeSync(val)` method call. Let’s run this program using Node.js.

```
$ node rpi-led-out.js
```

Since this is an endless loop, once we start the program, it will not terminate unless we interrupt it forcefull using `ctrl + c`. During the lifetime of this program, it will toggle the **BCM 4** pin every **3 seconds**.

One interesting thing about the Raspberry Pi GPIO, once a GPIO pin is set to **1** or **0**, it will stay like that until we override the value again or turn off the power supply to the Raspberry Pi. When when you start the program, the LED is off but when you stop it, the LED might remain on.

## Input example with Switch

As we know, when a GPIO is used as an input, we need to supply a voltage close to **3.3V**. We can hook up a switch (**push button**) that supplies a voltage directly from **3.3V** pin as shown in the circuit diagram below.

![(Simple Button Input)](https://cdn-images-1.medium.com/max/3126/1*8TUu5IGDaYm0movHCM9hww.png)

We have used a **1K ohm** resistor before the input of the switch to provide some resistance in the circuit. This will prevent too much current drawn from the **3.3V** supply and prevent our switch from getting fried.

We have also attached a **10K ohm** resistor that also draws the current from the output of the button and drains to the ground. These types of resistors (**because of their position in the circuit**) are called **pull-down** resistors since they drain the current (**or atmospheric charge build-up**) to the ground.

> We can alternatively add a **pull-up register** which pulls the current from **3.3V** pin and provides to the input GPIO pin. In this configuration, the input pin always reads **high** or **1**. When the button is pressed, the switch creates a short circuit between the resistor and the ground draining all the current to the ground and no current is passed through the switch to the input pin and it reads **0**. [**Here is a great video**](https://www.youtube.com/watch?v=5vnW4U5Vj0k) demonstrating the pull-up and pull-down resistors.

The output of the switch is connected to the **BCM 17** pin. When the button (**switch**) is pressed, the current will flow through the switch into the BCM 17 pin. However, since the 10K ohm resistor provides a greater obstacle to the current flow, most current flow through the loop represented by the **red dotted line**.

When the button is not pressed, the loop represented by the red dotted line is closed and no current will flow through it. However, the loop represented by the **grey dotted line** is closed, and the BCM 17 pin is grounded (**0V**).

> The main reason to add a 10k ohm resistor is to connect BCM 17 pin to the ground so that it can not read any atmospheric disturbance as input high. By not connecting a input pin to the ground, we keep the input pin in **floating state**. In that state the input pin can read either 0 or 1 due to atmospheric disturbances.

Now that our circuit is ready, let’s write a program to read input value.

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

In the above program, we have set **BCM 17** pin in the input mode. The third argument of the `Gpio` constructor configures when we want to get notified of the pin input voltage change. This is labeled as the **`edge`** argument since we are reading the value at the edge of voltage rise and drop cycle.

The `edge` argument can have the following values.

When the `rising` value is used, we will get notified when the input voltage to a GPIO pin is **rising from 0V** (**to 3.3V**). At this position, the pin will read **logical high** or **1** because it is getting positive voltage.

When the `falling` value is used, we will get notified when the input voltage is **falling to 0V** (**from 3.3V**). At this position, the pin will read **logical low** or **0** because it is losing voltage.

When `both` value is used, we will get notified of the above two events. When the voltage is rising from 0V (**input high or 1**) or falling from 3.3V (**input low or 0**), we can listen to these events at once.

> The `none` value is not discussed here, read the [**documentation**](https://github.com/fivdi/onoff#gpiogpio-direction--edge--options) to know more.

The `watch` method on a GPIO pin in the input mode watches for the above events. This is an asynchronous method, hence we need to pass a callback function which receives the input high (1) or input low (0) value.

Since we are using `both` value, the `watch` method will execute the callback when the input voltage is rising as well as when the input voltage is falling. Based on the button press, you should get the below values in the console.

```
Pin value 1 (when button is pressed)
Pin value 0 (when button is released)
Pin value 1 (when button is pressed)
Pin value 1 (repeat value)
Pin value 0 (when button is pressed)
```

If you inspect the above output carefully, we sometimes get duplicate values when the button is pressed or released. Since the physical connection between two connectors of the switch mechanism is not always smooth, it can connect and disconnect many times when a switch is not pressed carefully.

To avoid this, we can add capacity in the switch circuit which charges before the actually current flows in the GPIO pin and discharges smoothly when the button is released. You should give this a try since this is fairly simple.

## Combined I/O example

Now that we have a good understanding of how GPIO pin works and how we can configure them, let’s combine our last two examples. The bigger picture is to turn on the LED when the button is pressed and turn it off when the button is released. Let’s first look at the circuit diagram.

![(Simple I/O Example)](https://cdn-images-1.medium.com/max/3126/1*c0iV6t3t2yPUVyT0mhU3OA.png)

As you can see from the above example, we haven’t changed a thing from the above two examples. Also, both LED and Switch circuits are independent. Which means our earlier program should work just fine with this circuit.

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

In the above program, we have GPIO pins configured in the input and output mode individually. Since the value provided by the `watch` method on an input pin is **0** or **1**, we can use the same value to write to an output pin.

Since we are watching `switchIn` input pin in `both` mode, the `watch` will get triggered when the button is pressed sending the `value` **1** and also when the button is released sending the `value` **0**.

We can use this value directly to write to the `ledOut` pin. Hence, when the button is pressed, `value` is `1` and `ledOut.writeSync(1)` will turn on the LED. the reserve will happen when the button is pressed.

---

![(Demonstration)](https://cdn-images-1.medium.com/max/2000/1*a35VFbnt_AUM0ch8ftCxMA.gif)

Here is the demonstration of the complete input/output circuit we have just created. For your and safety of your Raspberry Pi, I would recommend you to purchase a good case and 40 pin GPIO extension ribbon cable.

I hope you have learned something today. In upcoming tutorials, we will build some complex circuits and learn to connect some fancy devices like character LCD screens and numeric input pad.

---

![([**GitHub**](https://github.com/thatisuday) / [**Twitter**](https://twitter.com/thatisuday))](https://cdn-images-1.medium.com/max/7898/1*waznApGKL0XENm0UbkCo_A.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
