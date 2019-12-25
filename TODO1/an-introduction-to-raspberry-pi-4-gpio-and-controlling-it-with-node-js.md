> * 原文地址：[An introduction to Raspberry Pi 4 GPIO and controlling it with Node.js](https://itnext.io/an-introduction-to-raspberry-pi-4-gpio-and-controlling-it-with-node-js-10f2ce41af12)
> * 原文作者：[Uday Hiwarale](https://medium.com/@thatisuday)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/an-introduction-to-raspberry-pi-4-gpio-and-controlling-it-with-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/an-introduction-to-raspberry-pi-4-gpio-and-controlling-it-with-node-js.md)
> * 译者：
> * 校对者：

# An introduction to Raspberry Pi 4 GPIO and controlling it with Node.js

> RASPBERRY PI + NODE.JS  
> In this article, we will get familiar with the GPIO of Raspberry Pi and its technical specifications. We will also go through a simple example of Input and Output with a Led and a Switch.

![(Source: [**pexels.com**](https://www.pexels.com/photo/have-a-break-led-signage-2249342/))](https://cdn-images-1.medium.com/max/12000/1*t-dr_5CrKf45RE0Uuww2sg.jpeg)

You might have come across the term “**IoT**”, it is an acronym for the **Internet of Things**. This basically means that a device (**thing**) that can be controlled from the internet. An example of an IoT would be smart bulbs in your house which can be controlled from your smartphone.

Since an IoT can be controlled from the internet, it should always be connected with the internet. There are primarily two ways we can connect a device to the internet, either through an Ethernet cable or through WiFi.

IoT devices can be used for various purposes. For example, you can use an IoT to control the temperature of your house, control lighting or turn on devices before you get home, right from your smartphone.

So what are the technical specifications of an IoT device? Well, in a nutshell, it should have the means to connect to the internet, have some input and output sockets to read/write analog or digital signals to and from a device, and bare minimal hardware to read and execute instructions from a program.

An IoT device has a hardware component that provides an interface for external devices to read digital data or to get electricity. This is called **GPIO** or **General Purpose Input Output**. This hardware component is basically a series of pins that can be connected to external devices.

These GPIO pins can be controlled by a program. For example, based on some conditions, we can turn on a GPIO pin which provides 5V electricity and any device which is connected to this pin will turn on. This program can listen to a message sent from the internet and control this pin. Hence the IoT.

Building such an IoT device from scratch can be tough since it has a lot of components to work with. Luckily, there are pre-built devices that you can purchase and they are extremely cheap. These devices come with GPIO hardware and means to connect to the internet.

#### Arduino Microcontroller

At the moment, if we are looking for simple automation, [**Arduino**](https://en.wikipedia.org/wiki/Arduino) is the best device to go for. It is a **micro-controller** that can be programmed using programming languages like C and C++.

![(Source: [**Wikipedia**](https://en.wikipedia.org/wiki/File:Arduino_Uno_-_R3.jpg))](https://cdn-images-1.medium.com/max/2000/1*-Tmb_Q7yYmmtFGaUk6iv4A.jpeg)

However, it does not come with the built-in WiFi or Ethernet jack and an external peripheral device (**called as a** shield) has to be connected to connect the Arduino to the internet.

Arduino is meant to be used as a controller for external devices and not a fully-fledged IoT device. Hence, they are extremely cheap. Some of the latest models can go as low as $18.

#### Raspberry Pi Micro-computer

Compared to Arduino, [**Raspberry Pi**](https://en.wikipedia.org/wiki/Raspberry_Pi) is a **beast**. It was created to promote the teaching of basic computer science in schools and in developing countries, but it was picked up by nerds and hobbyists to create new shit. At the moment, it is one of the most popular **single-board computers** in the world.

Raspberry Pi (**latest Model 4B**) comes with an Ethernet connector, WiFi, Bluetooth, HDMI output, USB connectors, a 40-pin GPIO, and other essential features. It is powered by an **ARM** CPU, a **Broadcom** GPU and 1/2/4 GB of **RAM**. You can see these specifications from [**this**](https://en.wikipedia.org/wiki/Raspberry_Pi#Specifications) Wikipedia table.

![(Source: [**Wikipedia**](https://en.wikipedia.org/wiki/File:Raspberry_Pi_4_Model_B_-_Side.jpg))](https://cdn-images-1.medium.com/max/2000/1*WE-9WUau6aQlMSHVLjq9KQ.jpeg)

Despite this heavy hardware, the latest model costs between **$40** to **$80**. Don’t forget, this is a fully-fledged computer with a native operating system. This means we do not need to connect with an external computer to program it.

However, unlike our day to day computers, Raspberry Pi provides a GPIO hardware component to control external devices. This makes the Raspberry Pi a device that can do just about anything.

Let’s understand the technical specifications of this GPIO.

---

## Raspberry Pi - GPIO pinout

Raspberry Pi (**model 4B**) has **40 GPIO pins** in total, stacked in `20 x 2` array. As shown in the below diagram, each pin has a specific purpose.

![(Source: [**raspberrypi.org**](https://www.raspberrypi.org/documentation/usage/gpio/))](https://cdn-images-1.medium.com/max/4128/0*VsaGvGskvJa20hZa.png)

Before we discuss the functionality of each pin, let’s understand some conventions first. Each pin has a specific number attached to it and that’s how we can control these pins from the software.

The numbers you can see in the circle is physical pin numbers on the GPIO hardware. For example, **pin no. 1** provides a constant 3.3V power. This number system is called **Board Pin** or **Physical Pin** numbering system.

We also have another pin numbering system created by [**Broadcom**](https://en.wikipedia.org/wiki/Broadcom_Inc.) since Raspberry Pi 4B uses the [**BCM2711**](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2711/README.md) processor chip. This pin numbering system is called **BCM** or **Broadcom Mode**. The label attached with each pin in the above diagram shows BCM pin numbers. For example, physical **pin no. 7** is **BCM pin no. 7** and labeled as **GPIO 4**.

We can choose to follow either the **Board** or **BCM** numbering system. However, depending on the programming library we use to access the GPIO, we could be stuck with one of them. However, most libraries out there prefer the BCM numbering system since it is referred by the Broadcom CPU chip.

> From here on, if I use **Pin no. x**, it means the **physical pin number** on the board. The BCM pin number will be mentioned with BCM.

#### 💡 Power and Group Pins

Pin no. **1** and **17** provide **3.3V** power while pin no. **2** and **4** provide **5V** power. These pins provide **constant power** when you turn on the Raspberry Pi and these are **not programmable** by any means whatsoever.

Pin no. **6**, **9**, **14**, **20**, **25**, **30**, **34** and **39** provide the ground connection. This is where the **cathode** of a circuit should be attached. We can use a single ground pin for all ground connections in the circuit since they are connected to the same ground rail.

> If you are wondering why so many ground pins, then you can follow [**this thread**](https://www.raspberrypi.org/forums/viewtopic.php?t=132851).

#### 🔌 GPIO Pins

Except for **Power** and **Ground** Pins, rests are general-purpose input and output pins. When a GPIO pin is used in **output mode**, it provides 3.3V constant power when it is turned on.

In the **input mode**, a GPIO pin can also be used to listen for external power. Technically, when a **3.3V** is supplied to a GPIO pin (**when it is in the input mode**), the pin will read as **logical high** or **1**. When the pin is grounded or supplied with **0V**, it will read as **logical low** or **0**.

The output mode is fairly straightforward. In the output mode, we turn on a pin and it sends the 3.3V through the pin. However, in the input of a pin, we need to listen for voltage changes on the pin and when the pin is at the logical high or low, we can do other things like turn on an output GPIO pin.

#### 🧙‍♀️ SPI, I²C, and UART Protocols

SPI ([**Serial Peripheral Interface**](https://en.wikipedia.org/wiki/Serial_Peripheral_Interface)) is a synchronous serial communication interface used by devices to talk to each other. This interface needs 3 or more data lines to connect a master device to a slave device (**out of one or many**).

I²C ([**Inter-Integrated Circuit**](http://C)) is also similar to SPI but it supports multiple master devices. Also, unlike SPI, it only requires two data lines for unlimited numbers of slaves. However, this makes I²C slower than SPI.

UART ([Universal asynchronous receiver-transmitter](https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter)) is also a serial communication interface but data is sent [**asynchronously**](https://en.wikipedia.org/wiki/Asynchronous_serial_communication).

Raspberry Pi provides a low-level interface to enable these interfaces through GPIO pins just like input and output mode we discussed earlier. However, not all GPIO pins can be configured from these kinds of communications.

In the below diagram, you can see which GPIO pins can be configured from SPI, I²C and UART protocols. You should visit **[pinout.xyz](https://pinout.xyz/).** This web application provides an interactive interface to see what each GPIO pin does.

![(Source: [**pinout.xyz**](https://pinout.xyz/))](https://cdn-images-1.medium.com/max/2000/1*mpKa3QDHL6G5CmjmMWX3UQ.png)

Besides in a simple input or output mode, a GPIO pin can work in **6 modes** but only one at a time. When you click on a GPIO pin (**in the above website**), you would be able to see its modes on the right side. These are mentioned with ALT0 to ALT5 in the right table.

> You can learn about the specifications of these communication protocols from [**this video**](https://www.youtube.com/watch?v=IyGwvGzrqp8). We won’t be working with these communication protocols in this tutorial, however, I will be covering these topics in the upcoming articles.

#### ⚡ Current Specifications

We have talked about the voltage specifications of the power and GPIO pins. The current specifications are little foggy because they are not mentioned in the Raspberry Pi official documentation.

However, we follow a safety precaution while handling the current. The maximum current that can be drawn from any pin should be less than or equal to **16mA**. Hence, we must adjust our load to meet this requirement.

If we have connected multiple devices to the Raspberry Pi GPIO and other ports like USB, then we must ensure that the maximum current drawn from the circuit is less than **50mA**.

To limit the current, we can add resistors to the circuit so that the maximum current drawn does not cross these limits. When a device needs more power than Raspberry Pi can provide, we should be using relay switches instead.

When it comes to the **input**, these same specifications are used. When a GPIO pin is used as a **drain** (**instead of a** source **of the current**), we should not supply more than **16mA**. Also when multiple GPIO pins are used as input, no more than **50mA** current should be applied in total.

---

## Prerequisites

I believe that you have gone through the setup of the Raspberry Pi. This means you have installed an operating system like [**Raspbian**](https://www.raspberrypi.org/downloads/raspbian/) or your personal favorite and you can access it through SSH or HDMI.

The first thing we need to do is create a project directory. I have created the project directory at `/home/pi/Programs/io-examples` where all our programs will live for these tutorial examples.

Since we want to control the GPIO pins using Node.js, we need to install Node first. You can choose your favorite method but I personally use **[NVM](https://github.com/nvm-sh/nvm)** (**node version manager**). You can follow [**these recommended steps**](https://github.com/nvm-sh/nvm#install--update-script) to install it.

Once you have NVM installed, we can proceed further to install a specific version of Node. I will be using Node v12 since it is the latest stable version. To install Node v12, use the below commands.

```
$ nvm install 12
$ nvm use 12
```

Once Node.js is installed on the Raspberry Pi, we can move ahead with the project creation. Since we want to control the GPIO pins, we need a library that can provide an easy API to do that for us.

One great library to control GPIO on Raspberry Pi is [**onoff**](https://www.npmjs.com/package/onoff). From the project directory, first, create the package.json and then install `onoff` package.

```
$ cd /home/pi/Programs/io-examples
$ npm init -y
$ npm i -S onoff
```

Now that we have everything we need, we can process with the circuit design and write our first program to test the power of GPIO.

---

## Output example with LED

In this example, we will turn on a Red LED programmatically. Let’s take a look at the below circuit diagram.

![(Simple LED Output)](https://cdn-images-1.medium.com/max/3126/1*aarORNzRCTnQlSL-F6pe5Q.png)

From the above circuit diagram, we have connected **Pin no. 6** (**ground pin**) to the negative (**ground**) rail of the breadboard and **BCM 4** to the one end of a **1k ohm** resistor. The other end of the resistor is connected to the input of a Red LED and the output of the LED drains to the ground.

There is nothing interesting about this circuit except the resistor. The resistor is needed because Red LED operates at **2.4V** and a GPIO pin provides **3.3V** which can damage the LED. Also, the LED draws **20mA** which is above the safe limit of Raspberry Pi, hence resistor will also prevent the excess current.

> We can choose between 330 ohms to 1k ohm resistance. This will impact the current flow but won’t damage the LED.

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
