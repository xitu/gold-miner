> * 原文链接 : [World-Class Testing Development Pipeline for Android - Part 2.](http://blog.karumi.com/world-class-testing-development-pipeline-for-android-part-2/)
* 原文作者 : [Karumi](hello@karumi.com)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [markzhai](https://github.com/markzhai)
* 校对者: [JustWe](https://github.com/lfkdsk), [Hugo Xie](https://github.com/xcc3641)

# 世界级的 Android 测试流程（二）

在我们的上一篇博客文章，[“世界级的Android测试开发流程（一）”，我们开始讨论一个Android的测试开发流程](http://blog.karumi.com/world-class-testing-development-pipeline-for-android/)。我们讨论了一个软件工程师从开始写测试到找到测试开发的一些问题的演化过程。我们获得了以下结论，概括如下：

* 自动化测试是成功的软件开发的关键。
* 为了写特定类型的测试，可测试的代码是必须的。
* 一些开发者对测什么与怎么测一无所知，就开始写测试。
* 我们的测试的质量与可读性并不总是能达到预期。
* 一个测试开发流程对定义测什么与怎么测来说是必须的。

相应地，任何应用的测试关键部分是：

* 独立于框架或者库去测试业务逻辑。
* 测试服务器端的API集成。
* 在黑盒场景测试下，从用户角度写的的接收准则。

在这篇文章中，我们将会看到几个测试方法，它们覆盖了上述部分并保证了一个稳若盘石的测试开发流程。

### **独立于框架或者库去测试业务逻辑：**

至关重要的是检查[业务逻辑](http://c2.com/cgi/wiki?BusinessLogicDefinition)是否确实实现了预定的产品需求。我们需要隔离想要测试的代码，模拟不同的初始场景，以设置运行时的一些组件的行为。接着，我们将会通过选择想要练习的部分来测试代码。一旦完成，我们需要检查软件状态在训练该测试主题后是否正确。

这个测试方法的关键是 [依赖倒置原则](http://martinfowler.com/articles/dipInTheWild.html)。通过写依赖于抽象的代码，我们将可以把我们的软件分离为不同的层次。为了获得一个依赖的实例，我们需要从某个地方去请求它。或者，我们可以在实例被创建的时候获得它。我们软件的一部分要求我们创建代码来获取协作者的实例。在这些点，我们将会引入测试替身(Test Double)来模拟初始场景或编写不同行为来设计我们的测试。通过使用 [测试替身](http://martinfowler.com/articles/mocksArentStubs.html)，我们将能模拟生产环境代码的行为与状态。同时，它能帮助我们选择测试的范围（从根本上代表了要测试的代码的数量）。如果没有依赖倒置，所有类就需要各自去获得它们的依赖。从而导致类实现和依赖的实现相互耦合，进而无法引入测试替身来切断生产环境代码的执行流。

通常在构造中传递类依赖是最有效的应用依赖倒置的机制。该机制足够用来引入测试替身。在构造中传递类依赖会帮助我们创建实例来替代对应测试替身的依赖。**尽管并不是强制的，记住[服务定位器(Service Locator)或者依赖注入](http://martinfowler.com/articles/injection.html)框架的用法对帮助减少样板代码以应用依赖倒置仍然很重要。**

**我们将会用一个具体的例子 (**关于 [我几个月前开始做的Android GameBoy模拟器](https://github.com/pedrovgs/AndroidGameBoyEmulator) 的测试**) 来展示如何测试我们的业务需求。**

以下测试有关于GameBoy内存管理单元和GameBoy BIOS执行。我们将会检查产品需求（硬件模拟）是否被正确实现。

    public class MMUTest {  
      private static final int MMU_SIZE = 65536;
      private static final int ANY_ADDRESS = 11;
      private static final byte ANY_BYTE_VALUE = 0x11;

      @Test public void shouldInitializeMMUFullOfZeros() {
        MMU mmu = givenAMMU();

        assertMMUIsFullOfZeros(mmu);
      }

      @Test public void shouldFillMMUWithZerosOnReset() {
        MMU mmu = givenAMMU();

        mmu.writeByte(ANY_ADDRESS, ANY_BYTE_VALUE);
        mmu.reset();

        assertMMUIsFullOfZeros(mmu);   
      }

      @Test public void shouldWriteBigBytesValuesAndRecoverThemAsOneWord() {
        MMU mmu = givenAMMU();

        mmu.writeByte(ANY_ADDRESS, (byte) 0xFA);
        mmu.writeByte(ANY_ADDRESS +1, (byte) 0xFB);

        assertEquals(0xFBFA, mmu.readWord(ANY_ADDRESS));
      }
    }

前三个测试是检查GameBoy MMU（内存管理单元）是否正确实现。成功的关键在于检查测试执行的最后MMU状态是否正确。所有的测试检查MMU是否被正确初始化。如果reset后，MMU被清理了，或者写了2个字节后和期望的词相等，则最后的读取是正确的。为了测试模拟器软件的这部分，我们缩小了测试范围，仅有一个类作为测试对象。

    public class GameBoyBIOSExecutionTest {

      @Test
      public void shouldIndicateTheBIOSHasBeenLoadedUnlockingTheRomMapping() {
        GameBoy gameBoy = givenAGameBoy();

        tickUntilBIOSLoaded(gameBoy);

        assertEquals(1, mmu.readByte(UNLOCK_ROM_ADDRESS) & 0xFF);
      }

      @Test
      public void shouldPutTheNintendoLogoIntoMemoryDuringTheBIOSThirdStage() {
        GameBoy gameBoy = givenAGameBoy();

        tickUntilThirdStageFinished(gameBoy);

        assertNintendoLogoIsInVRAM();
      }

      private GameBoy givenAGameBoy() {
        z80 = new GBZ80();
        mmu = new MMU();
        gpu = new GPU(mmu);
        GameLoader gameLoader = new GameLoader(new FakeGameReader());
        GameBoy gameBoy = new Gameboy(z80, mmu, gpu, gameLoader);
        return gameboy;
      }

    }

在这两个测试中，我们检查了跨越不同阶段的BIOS是否执行正确。在BIOS执行的最后，内存中具体位置的一个字节必须被初始化为具体的一个值。接着，在第三阶段的最后，任天堂的logo必须被读取到VRAM。我们决定扩大测试的范围，因为整个BIOS执行是任何模拟器开发的关键部分之一。关于该测试的主题是CPU，CPU指令集的部分（只包括BIOS执行相关的指令），以及MMU。为了检查执行的状态是否正确，我们必须在MMU状态上进行assert。**一个能显著提升测试质量的关键就是检查执行最后的软件状态，而避免去验证和其他组件的交互。这是因为即便和你的组件交互正确，状态仍然可能错误。** 知道这些测试的部分是独立的也很重要，像是CPU指令。

这些测试的另一个主要亮点是使用了测试替身，以模拟Android SDK使用相关的那些代码。在执行BIOS之前，GameBoy游戏必须被读取到GameBoy MMU里。然后，在测试期间，Android SDK将会变得不可用，作为一种变通方法，我们将不得不替换为从测试环境读取GameBoy rom。_* 我们使用了依赖倒置原则不仅仅是为了隐藏实现细节或者定义边界，—_* 也是为了替代实际生产环境的AndroidGameReader为FakeGameReader，一个测试替身，**从而不依赖于框架和库去测试代码。这样，我们创建了一个隔离的测试环境，并调整了测试范围。**

### **范围：**

调整测试范围是极其重要的。在写测试前，我们必须记住测试范围会帮助我们认识代码里的缺陷（取决于测试范围的大小）。简化的范围将会给我们更丰富的错误反馈，而大范围的测试则无法提供bug位置的准确信息。**测试的粒度必须跟考虑中的测试范围一样小。**

### **基础：**

写这些测试的基础很明确。我们需要写出在依赖倒置原则下可测试的代码，并结合mocking库使用测试框架。mocking库将会帮助我们创建模拟场景下的测试替身，或替换我们部分的生产代码。请注意这些框架和库的使用不是必须的，但我们推荐使用。

### **结果：**

这个方法的结果很有趣。**在遵循依赖倒置原则后，我们可以独立于框架或库去测试我们的业务逻辑**。我们可以创建一个具有可重复性的 **隔离环境** 来实现和设计测试。另外，我们可以简单地 **选择需要测试的生产环境代码的量** 并把它们替换为 **测试替身来模拟行为和不同场景**。

既然我们已经可以测试产品需求是否被正确实现，我们便需要继续致力于测试开发流程。下个我们要测试的是与被测试替身替换的外部组件的集成是否正确。这是我们将会在下一篇博客文章中回顾的东西，敬请期待！;)

参考：

* 世界级的Android测试开发流程（一）by Pedro Vicente Gómez Sánchez. [http://www.slideshare.net/PedroVicenteGmezSnch/worldclass-testing-development-pipeline-for-android](http://www.slideshare.net/PedroVicenteGmezSnch/worldclass-testing-development-pipeline-for-android)
* Android GameBoy 模拟器 GitHub Repository by Pedro Vicente Gómez Sánchez. [https://github.com/pedrovgs/AndroidGameBoyEmulator](https://github.com/pedrovgs/AndroidGameBoyEmulator)
* 控制反转容器和依赖注入模式 by Martin Fowler. [http://martinfowler.com/articles/injection.html](http://martinfowler.com/articles/injection.html)
* 在野外的DIP by Martin Fowler.[http://martinfowler.com/articles/dipInTheWild.html](http://martinfowler.com/articles/dipInTheWild.html)
* 测试替身 by Martin Fowler. [http://www.martinfowler.com/bliki/TestDouble.html](http://www.martinfowler.com/bliki/TestDouble.html)
