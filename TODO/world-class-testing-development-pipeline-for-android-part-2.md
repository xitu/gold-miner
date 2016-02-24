* 原文链接 : [World-Class Testing Development Pipeline for Android - Part 2.](http://blog.karumi.com/world-class-testing-development-pipeline-for-android-part-2/)
* 原文作者 : [Karumi](hello@karumi.com)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [认领地址](https://github.com/xitu/gold-miner/issues/112)
* 校对者: 
* 状态 : 认领中

In our previous blog post, [“World-Class Testing Development Pipeline for Android - Part 1”, we started talking about a Testing Development Pipeline for Android](http://blog.karumi.com/world-class-testing-development-pipeline-for-android/). We discussed the evolution of a Software Engineer once it starts writing tests until it finds some problems related to the testing development. We reached the following conclusions, as summarized below:

*   - Test automation is key to successful software development.
*   - Testable code is required to write specific types of tests.
*   - Some developers start writing tests without knowing what to test and how to test it.
*   - The quality and reliability of our tests are not always as good as they should be.
*   - A testing development pipeline is necessary to define what to test and how to test it.

Accordingly, the key parts to test in any application are:

*   - Test the business logic independently of the framework or library.
*   - Test the Server Side API integration.
*   - Test the acceptance criteria written from the user’s point of view in a black box scenario.

In this blog post, we will review several testing approaches that cover the aforementioned parts to ensure a rock solid Testing Development Pipeline.

### **Testing the business logic independently of the framework or library:**

It is essential to check if the [business logic](http://c2.com/cgi/wiki?BusinessLogicDefinition) is indeed implementing the predefined product requirements. We need to isolate the code we want to test and simulate different initial scenarios to configure the behaviour of some components at runtime. Next, we will test the code by choosing the parts we want to exercise. Once completed, we need to check if the state of the software is correct after exercising the subject under test.

The key to this testing approach is the [Dependency Inversion Principle](http://martinfowler.com/articles/dipInTheWild.html). By writing code that depends on abstractions, we will be able to separate our software in different layers. In order to obtain an instance of a dependency, we just need to request it from someone. Alternatively, we can obtain it once the instance is created. There are parts of our software where we need to create code to obtain instances of collaborators. At these points we will introduce test doubles to simulate initial scenarios or program different behaviours to design our tests. By using [test doubles](http://martinfowler.com/articles/mocksArentStubs.html), we will be able to simulate both the behaviour and the state of the production code replaced with a test double. Simultaneously, it will help us to choose the scope of the test, which essentially represents the amount of code to test. Without Dependency Inversion, all our classes would obtain their dependencies independently. As a result, the class implementation would be coupled to the dependency implementation and therefore we can’t introduce test doubles to cut the production code execution flow.

Usually passing the class dependencies in construction is the most effective mechanism to apply Dependency Inversion. This mechanism is good enough to introduce test doubles. Passing the dependencies of a class in construction will help us create an instance to replace the dependencies with the corresponding test doubles. **It is important to remember that the usage of a [Service Locator or a Dependency Injection](http://martinfowler.com/articles/injection.html) framework will help reduce all the boilerplate needed to apply Dependency Inversion, though these are not mandatory.**

**We will use a specific example (**tests related to an [Android GameBoy Emulator I started working on few months ago](https://github.com/pedrovgs/AndroidGameBoyEmulator)**) to show how to test our business requirements.**

The following tests are related to the GameBoy memory management unit and the GameBoy BIOS execution. We are going to check if our product requirements (the hardware emulation) are correctly implemented.

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

The first three tests are checking whether the implementation of the GameBoy MMU is correct. The key to success is to always check at the end of the test execution if the state of the MMU is correct. All tests check if the MMU is properly initialized. The final read is correct if after a reset the MMU is cleaned and if after writing two bytes it is read as a word. To test this part of the emulator software we have chosen a reduced scope with just one class as the subject under test.

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

In these two tests we are checking if the BIOS is executing correctly across different stages. At the end of the BIOS execution, one byte in a concrete memory position must be initialized with a concrete value. Next, at the end of the third stage, the Nintendo logo must be loaded into the VRAM. We decided to use a bigger scope for these tests because the full BIOS execution is one of the key parts of any emulator development. The subjects under test for this test case are the CPU, part of the CPU instruction set (just the instructions involved in the BIOS execution) and the MMU. To check if the state of the execution is correct we have to perform asserts over the MMU state. **One of the keys to dramatically improve the test quality is by checking the software state at the end of the execution while avoiding to verify the interactions with other components. This is because even if the interaction between your components is correct, the state can be incorrect.** It’s important to know that some parts of these tests are also tested individually, like the CPU instructions.

Another major highlight of these tests is the use of a test double to simulate part of the code related to the Android SDK usage. Prior to executing the BIOS, the GameBoy game has to be loaded into the GameBoy MMU. However, during testing time, the Android SDK will not be available and as a workaround we will have to replace it to load the GameBoy rom from the test environment._* We have used the Dependency Inversion Principle not just to hide implementation details or define boundaries,_* but also to replace the AndroidGameReader production code, with a FakeGameReader, a test double, **meant to test the code without framework or libraries dependencies. By doing this, we are creating an isolated test environment and adjusting the test scope.**

### **Scope:**

Adjusting the scope of the tests is extremely important. Before starting to write a test we should always remember that the scope of the test will help us identify failures in our code (depending on the testing scope size). Test of reduced scope will give us richer error feedback while tests of a bigger scope will not provide accurate information about the location of the bug. **The grain of the test should be as small as the scope of the test under consideration.**

### **Infrastructure:**

The infrastructure to write these tests is quite straightforward. We need to write testable code under the Dependency Inversion Principle and use a testing framework combined with a mocking library. The mocking library will be used to create the test doubles needed to simulate scenarios or replace parts of our production code. Please note that the usage of this frameworks or libraries is not mandatory, but recommended.

### **Results:**

The result of this approach is quite interesting. **When following the Dependency Inversion Principle we will be able to test our business logic independently from the framework or library in the production code**. We can create an **isolated environment** with repeatable easy to write and design tests. Additionally, we can easily **choose the amount of production code to test** and replace this code with **test doubles to simulate the behaviour and different scenarios**.

Once we are able to test if our product requirements are properly implemented, we need to continue working on our Testing Development Pipeline. Next thing we want to test is whether our integration with external components being replaced with test doubles in the previous stage is correct or not. This is something we will review in the next blog post, stay tuned folks! ;)

References:

*   - World-Class Testing Development Pipeline for Android - Part 1 by Pedro Vicente Gómez Sánchez. [http://www.slideshare.net/PedroVicenteGmezSnch/worldclass-testing-development-pipeline-for-android](http://www.slideshare.net/PedroVicenteGmezSnch/worldclass-testing-development-pipeline-for-android)
*   - Android GameBoy Emulator GitHub Repository by Pedro Vicente Gómez Sánchez. [https://github.com/pedrovgs/AndroidGameBoyEmulator](https://github.com/pedrovgs/AndroidGameBoyEmulator)
*   - Inversion of Control Containers and the Dependency Injection pattern by Martin Fowler. [http://martinfowler.com/articles/injection.html](http://martinfowler.com/articles/injection.html)
*   - DIP in the Wild by Martin Fowler.[http://martinfowler.com/articles/dipInTheWild.html](http://martinfowler.com/articles/dipInTheWild.html)
*   - Test Double by Martin Fowler. [http://www.martinfowler.com/bliki/TestDouble.html](http://www.martinfowler.com/bliki/TestDouble.html)
