> * 原文地址：[Introducing JUnit 5 Part 1: The JUnit 5 Jupiter API](https://www.ibm.com/developerworks/library/j-introducing-junit5-part1-jupiter-api/)
> * 原文作者：[J Steven Perry](https://developer.ibm.com/author/steve.perry/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/j-introducing-junit5-part1-jupiter-api.md](https://github.com/xitu/gold-miner/blob/master/TODO1/j-introducing-junit5-part1-jupiter-api.md)
> * 译者：
> * 校对者：

# Introducing JUnit 5 Part 1: The JUnit 5 Jupiter API

## Learn your way around annotations, assertions, and assumptions in the new JUnit Jupiter API

This tutorial introduces you to JUnit 5. We'll start by installing JUnit 5 and getting it setup on your computer. I'll give you a brief tour of JUnit 5's architecture and components, then show you how to use new annotations, assertions, and assumptions in the JUnit Jupiter API.

In [Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/j-introducing-junit5-part2-vintage-jupiter-extension-model.md), we'll take a deeper tour of JUnit 5, including the new JUnit Jupiter Extension model, parameter injection, dynamic tests, and more.

For this tutorial, I used [JUnit 5, Version 5.0.2](http://junit.org/junit5/docs/current/user-guide/#release-notes-5.0.2).

### Prerequisites

For the purpose of this tutorial, I assume that you are comfortable using the following software:

*   Eclipse IDE
*   Maven
*   Gradle (optional)
*   Git

In order to follow along with the examples, you should have JDK 8, Eclipse, Maven, Gradle (optional), and Git installed on your computer. If you are missing any of these tools, you can use the links below to download and install them now:

*   [JDK 8 for Windows, Mac, and Linux.](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
*   [Eclipse IDE for Windows, Mac, and Linux.](http://www.eclipse.org/downloads/eclipse-packages/)
*   [Apache Maven for Windows, Mac, and Linux.](https://maven.apache.org/download.cgi)
*   [Gradle for Windows, Mac, and Linux.](https://gradle.org/install)
*   [Git for Windows, Mac, and Linux.](https://git-scm.com/downloads)

[Clone the sample application from GitHub](https://github.com/makotogo/HelloJUnit5)

##### JUnit with Gradle

In this tutorial, I'll show you how to run JUnit Jupiter tests using Gradle. The demonstration is optional, but I encourage you to learn Gradle. It's a neat build system, and increasingly popular. It's coming soon to a project next to you—I guarantee it!

### Terminology

It's tempting to use the terms _JUnit 5_ and _JUnit Jupiter_ synonymously. In most cases, this is a benign interchange. It's important, however, to understand that the two terms are not the same. _JUnit Jupiter_ is the API for writing tests using JUnit version 5. _JUnit 5_ is the project name (and version) that includes the separation of concerns reflected in all three major modules: JUnit Jupiter, JUnit Platform, and JUnit Vintage.

When I write about JUnit Jupiter, I'm referring to the API for writing unit tests. When I write about JUnit 5, I'm referring to the project as a whole.

## Overview of JUnit 5

Prior versions of JUnit were monolithic. Aside from the inclusion of the Hamcrest JAR in version 4.4, JUnit was basically one big JAR file. Its APIs were used by both test writers—developers like you and me—and tool vendors, who used many of the internal JUnit APIs.

Such prolific use of internal APIs caused JUnit's maintainers some headaches, and left them with few options for moving the technology forward. From the [_JUnit 5 User's Guide_](http://junit.org/junit5/docs/current/user-guide/#api-evolution):

> “ With JUnit 4 a lot of stuff that was originally added as an internal construct only got used by external extension writers and tool builders. That made changing JUnit 4 especially difficult and sometimes impossible. ”

The JUnit Lambda (now called JUnit 5) team decided to redesign JUnit into two clear and separate areas of concern:

*   An API for writing tests.
*   An API for discovering and running those tests.

These areas of concern are now baked into the architecture of JUnit 5, and they're clearly separated from each other. The new architecture is illustrated in Figure 1 (image credit to [Nicolai Parlog](https://blog.codefx.org/design/architecture/junit-5-architecture/)):

##### Figure 1. Architecture of JUnit 5

![An illustration of the JUnit 5 architecture.](https://www.ibm.com/developerworks/library/j-introducing-junit5-part1-jupiter-api/Figure-1.png)

If you look closely at Figure 1, it starts to sink in just how supremely cool JUnit 5's architecture is. Go ahead, _really_ stare at it. What the boxes in the top-right corner show is that the JUnit Jupiter API is _just another API_ as far as JUnit 5 is concerned! Because JUnit Jupiter's components follow the new architecture, they work with JUnit 5, but you could just as easily define a different testing framework. As long as a framework implements the `TestEngine` interface, you can plug it into any tool supporting the `junit-platform-engine` and `junit-platform-launcher` APIs!

I still think JUnit Jupiter is pretty special (after all, I'm about to spend an entire tutorial talking about it), but what the JUnit 5 team have done is truly groundbreaking. I just wanted to point that out. Please feel free to stare at Figure 1 until we are in wholehearted agreement.

### Writing tests with JUnit Jupiter

For our purpose as test writers, any JUnit-compliant testing framework (including JUnit Jupiter) consists of two components:

*   The API against which we write tests.
*   The JUnit `TestEngine` implementation that understands that particular API.

For this tutorial, the former is the JUnit Jupiter API, while the latter is the JUnit Jupiter Test Engine. I'll introduce them both.

#### The JUnit Jupiter API

As a developer, you'll use the JUnit Jupiter API to create unit tests that exercise your application code. Using the API's basic features—annotations, assertions, and so forth—is the main focus of this part of the tutorial.

The JUnit Jupiter API is designed so that you can extend its functionality by plugging into various lifecycle callbacks. You'll learn in Part 2 how to use these callbacks to do cool things like run parameterized tests, pass arguments to test methods, and lots more.

#### The JUnit Jupiter Test Engine

You'll use the JUnit Jupiter Test Engine to discover and execute your JUnit Jupiter unit tests. The test engine implements the `TestEngine` interface, which is part of the JUnit Platform. You can think of the `TestEngine` as the bridge between your unit tests and the tools you use to launch them (like your IDE).

### Running tests with JUnit Platform

In JUnit terminology the process of running unit tests is divided into two parts:

1.  _Discovery_ of tests and the creation of a _test plan_.
2.  _Launching_ the test plan in order to (1) execute tests and (2) report results to the user.

#### API for discovering tests

The API for discovering tests and creating the test plan is part of the JUnit Platform, and is implemented by a `TestEngine`. The testing framework encapsulates the discovery of tests into its implementation of a `TestEngine`. The JUnit Platform is responsible for initiating the test discovery process, using IDEs and build tools like Gradle and Maven.

The goal of test discovery is the creation of the test plan, which consists of a _test specification_. The test specification includes the following components:

*   _Selectors_ such as:
    *   Packages to scan for test classes
    *   Specific class names
    *   Specific methods
    *   Classpath root folders
*   _Filters_ such as:
    *   Class name patterns (e.g., ".*Test")
    *   Tags (discussed in Part 2)
    *   Specific test engines (e.g., "junit-jupiter")

The test plan is a hierarchical view of all the test classes, test methods within those classes, test engines, and so on, that were discovered according to the test specification. Once the test plan is prepared, it's ready to be executed.

#### API for executing tests

The API for executing tests is part of the JUnit Platform, and is implemented by one or more `TestEngine`s. Testing frameworks encapsulate the execution of tests into their implementation of `TestEngine`, but the JUnit Platform is responsible for initiating the test execution process. Test execution is initiated through IDEs and build tools like Gradle and Maven.

A JUnit Platform component called the `Launcher` is responsible for executing the test plan created during test discovery. Some process—let's say your IDE—initiates test execution through the JUnit Platform (specifically, the `junit-platform-launcher` API). At that time, the JUnit Platform hands the `Launcher` the test plan, along with a `TestExecutionListener`. The `TestExecutionListener` will report test execution results for display in your IDE.

The goal of the test execution process is to report to the user exactly what happened when the tests ran. This includes reporting test successes and failures, and messages accompanying the failures to help the user understand what happened.

### Backward compatibility: JUnit Vintage

Many organizations have a significant investment in JUnit 3 and 4, and thus cannot afford to convert wholesale to JUnit 5. Knowing this, the JUnit 5 team have provided the `junit-vintage-engine` and `junit-jupiter-migration-support` components to assist with migration.

As far as JUnit Platform is concerned, JUnit Vintage is just another test framework, complete with its own `TestEngine` and API (specifically, the JUnit 4 API).

Figure 2 shows the dependencies among the various JUnit 5 packages.

##### Figure 2. JUnit 5 package diagram

![An illustration of the JUnit 5 package diagram.](https://www.ibm.com/developerworks/library/j-introducing-junit5-part1-jupiter-api/Figure-2.png)

### What about opentest4j?

Test frameworks that support JUnit vary in how they process exceptions thrown during test execution. There is no standard for testing on the JVM, which is an ongoing issue for the JUnit team. Beyond the `java.lang.AssertionError`, test frameworks are forced to either define their own exception hierarchy or couple themselves to exceptions supported natively by JUnit (or in some cases they may do both).

**Support opentest4j**: To participate in the Open Test Alliance for the JVM, or simply provide feedback to help move the effort forward, visit the [opentest4j](https://github.com/ota4j-team/opentest4j) Github repo and click on the _CONTRIBUTING.md_ link.

To work around consistency issues, the JUnit team has proposed an open source project currently known as Open Test Alliance for the JVM. The alliance is just a proposal at this stage, and the exception hierarchy it has defined is preliminary. However, JUnit 5 uses the `opentest4j` exceptions. (You can see this in Figure 2; notice the dependency lines from the `junit-jupiter-api` and `junit-platform-engine` packages to the `opentest4j` package.)

Now that you have a basic grasp of how the various JUnit 5 components fit together, it's time to write some tests using the JUnit Jupiter API!

## Writing tests using JUnit Jupiter

### Annotations

Since JUnit 4, annotations have been a core feature of the testing framework, and that continues with JUnit 5. I don't have space to cover all of JUnit 5's annotations, but this section will get you started with the ones you're likely to use most.

First, I'll compare the annotations from JUnit 4 with those from JUnit 5. The JUnit 5 team changed the names of some annotations to make them more intuitive, while keeping the functionality the same. If you've been using JUnit 4, the table below will help you orient to the changes.

##### Table 1. Annotations in JUnit 4 vs JUnit 5

| JUnit 5 | JUnit 4 | Description |
| ------- | ------- | ----------- |
| @Test | @Test | The annotated method is a test method. No change from JUnit 4. |
| @BeforeAll | @BeforeClass | The annotated (static) method will be executed once before any @Test method in the current class. |
| @BeforeEach | @Before | The annotated method will be executed before each @Test method in the current class. |
| @AfterEach | @After | The annotated method will be executed after each @Test method in the current class. |
| @AfterAll | @AfterClass | The annotated (static) method will be executed once after all @Test methods in the current class. |
| @Disabled | @Ignore | The annotated method will not be executed (it will be skipped), but reported as such. |

#### Using annotations

Next we'll look at a few examples using these annotations. While some have been renamed in JUnit 5, their functionality should be familiar if you've been using JUnit 4. The code in Listing 1 is from `JUnit5AppTest.java`, which you'll find in the [HelloJUnit5](https://github.com/makotogo/HelloJUnit5) sample application.

##### Listing 1. Basic annotations

```
@RunWith(JUnitPlatform.class)
@DisplayName("Testing using JUnit 5")
public class JUnit5AppTest {
  
  private static final Logger log = LoggerFactory.getLogger(JUnit5AppTest.class);
  
  private App classUnderTest;
  
  @BeforeAll
  public static void init() {
    // Do something before ANY test is run in this class
  }
  
  @AfterAll
  public static void done() {
    // Do something after ALL tests in this class are run
  }
  
  @BeforeEach
  public void setUp() throws Exception {
    classUnderTest = new App();
  }
  
  @AfterEach
  public void tearDown() throws Exception {
    classUnderTest = null;
  }
  
  @Test
  @DisplayName("Dummy test")
  void aTest() {
    log.info("As written, this test will always pass!");
    assertEquals(4, (2 + 2));
  }
  
  @Test
  @Disabled
  @DisplayName("A disabled test")
  void testNotRun() {
    log.info("This test will not run (it is disabled, silly).");
  }
.
.
}
```
Consider the annotations in the highlighted lines above:

*   Line 1: Along with its parameter `JUnitPlatform.class` (a JUnit 4-based `Runner` that understands JUnit Platform) `@RunWith` lets you run JUnit Jupiter unit tests inside of Eclipse. Eclipse does not yet natively support JUnit 5. In the future, Eclipse will provide native JUnit 5 support, and we'll no longer need this annotation.
*   Line 2: `@DisplayName` tells JUnit to display the `String` "Testing using JUnit 5" rather than the test class name when reporting test results.
*   Line 9: `@BeforeAll` tells JUnit to run the `init()` method **once**_before_ all `@Test` method(s) in this class are run.
*   Line 14: `@AfterAll` tells JUnit to run the `done()` method **once**_after_ all `@Test` method(s) in this class are run.
*   Line 19: `@BeforeEach` tells JUnit to run the `setUp()` method _before_**each**`@Test` method in this class.
*   Line 24: `@AfterEach` tells JUnit to run the `tearDown()` method _after_**each**`@Test` method in this class.
*   Line 29: `@Test` tells JUnit that the `aTest()` method is a JUnit Jupiter test method.
*   Line 37: `@Disabled` tells JUnit not to run this `@Test` method because it is disabled.

### Assertions

An _assertion_ is one of a number of static methods on the `org.junit.jupiter.api.Assertions` class. Assertions are used to test a condition that must evaluate to `true` in order for the test to continue executing.

If an assertion fails, the test is halted at the line of code where the assertion is located, and the assertion failure is reported. If the assertion succeeds, the test continues to the next line of code.

All of the JUnit Jupiter assertion methods listed in Table 2 take an optional `message` parameter (as the last parameter) that displays if the assertion fails, rather than the standard default message.

##### Table 2. Assertions in JUnit Jupiter

| Assertion method | Description |
| ---------------- | ----------- |
| `assertEquals(expected, actual)` | The assertion fails if _expected_ does not equal _actual_. |
| `assertFalse(booleanExpression)` | The assertion fails if _booleanExpression_ is not `false`. |
| `assertNull(actual)` | The assertion fails if _actual_ is not `null`. |
| `assertNotNull(actual)` | The assertion fails if _actual_ is `null`. |
| `assertTrue(booleanExpression)` | The assertion fails if _booleanExpression_ is not `true`. |

Listing 2 is an example of these annotations in use, from the HelloJUnit5 sample application.

##### Listing 2. JUnit Jupiter assertions in the sample application

```
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
.
.
  @Test
  @DisplayName("Dummy test")
  void dummyTest() {
    int expected = 4;
    int actual = 2 + 2;
    assertEquals(expected, actual, "INCONCEIVABLE!");
    //
    Object nullValue = null;
    assertFalse(nullValue != null);
    assertNull(nullValue);
    assertNotNull("A String", "INCONCEIVABLE!");
    assertTrue(nullValue == null);
    .
    .
  }
```

Consider the assertions from the highlighted lines above:

*   Line 13: `assertEquals`: If the first parameter value (4) does not equal the second (2+2), then the assertion fails. The user-supplied message (the third parameter to the method) is used when reporting the assertion failure.
*   Line 16: `assertFalse`: The expression `nullValue != null` must be `false` or the assertion fails.
*   Line 17: `assertNull`: The `nullValue` parameter must be `null` or the assertion fails.
*   Line 18: `assertNotNull`: The `String` literal "A String" must not be `null` or the assertion fails, and the message "INCONCEIVABLE!" is reported (instead of the default "Assertion failed" message).
*   Line 19: `assertTrue`: If the expression `nullValue == null` does not evaluate to `true` the assertion fails.

In addition to supporting these standard assertions, the JUnit Jupiter AP provides severaI new ones. We'll look at two of them below.

#### Method @assertAll()

The `@assertAll()` method in Listing 3 presents the same assertions seen in Listing 2, but wrapped in a new assertion method:

##### Listing 3. assertAll()

```
import static org.junit.jupiter.api.Assertions.assertAll;
.
.
@Test
@DisplayName("Dummy test")
void dummyTest() {
  int expected = 4;
  int actual = 2 + 2;
  Object nullValue = null;
  .
  .
  assertAll(
      "Assert All of these",
      () -> assertEquals(expected, actual, "INCONCEIVABLE!"),
      () -> assertFalse(nullValue != null),
      () -> assertNull(nullValue),
      () -> assertNotNull("A String", "INCONCEIVABLE!"),
      () -> assertTrue(nullValue == null));
}
```

The cool thing about `assertAll()` is that _all_ of the assertions contained within it are performed, even if one or more of them fail. Contrast this to the code in Listing 2, where if _any_ assertion fails, the test fails at that point, meaning no other assertions will be performed.

#### Method @assertThrows()

Under certain conditions, the class under test is expected to throw an exception. JUnit 4 provided this capability through the `expected =` method parameter, or through a `@Rule`. In contrast, JUnit Jupiter provides this capability through the `Assertions` class, making it more consistent with other assertions.

An expected exception is considered to be just another condition that can be asserted, and thus `Assertions` contains methods to handle this. Listing 4 introduces the new `assertThrows()` assertion method.

##### Listing 4. assertThrows()

```
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertEquals;
.
.
@Test()
@DisplayName("Empty argument")
public void testAdd_ZeroOperands_EmptyArgument() {
  long[] numbersToSum = {};
  assertThrows(IllegalArgumentException.class, () -> classUnderTest.add(numbersToSum));
}
```

Note Line 9: If the call to `classUnderTest.add()` does not throw an `IllegalArgumentException`, then the assertion fails.

### Assumptions

Assumptions are similar to assertions, except that assumptions must hold true or the test will be _aborted_. In contrast, when an assertion fails, the test is considered to have _failed_. Assumptions are useful when a test method should only be executed under certain conditions—the _assumption_.

An _assumption_ is a static method of the `org.junit.jupiter.api.Assumptions` class. To appreciate the value of assumptions, all you need is a simple example.

Suppose you want to run a particular unit test only on Friday (I assume you have your reasons):

```
@Test
@DisplayName("This test is only run on Fridays")
public void testAdd_OnlyOnFriday() {
  LocalDateTime ldt = LocalDateTime.now();
  assumeTrue(ldt.getDayOfWeek().getValue() == 5);
  // Remainder of test (only executed if assumption holds)...
}
```

In this case, if the condition doesn't hold (Line 5), the body of the lambda will not be executed.

##### Using assertions vs assumptions

The difference can be subtle, so use this rule of thumb: Use assertions to _check the results of a test method_. Use assumptions to _determine whether to run the test method at all_. An aborted test is not reported as a failure, meaning that failure won't break the build.

Note Line 5: If the condition doesn't hold, then the test is skipped. In this case, the day of the week when the test runs is not Friday (5). This doesn't affect the "green" of the project, and won't cause the build to fail; all of the code in test method after `assumeTrue()` is simply skipped.

In cases where only a _portion_ of the test method should execute if an assumption holds, you could write the above condition with the `assumingThat()` method, which uses lambda syntax:

```
@Test
@DisplayName("This test is only run on Fridays (with lambda)")
public void testAdd_OnlyOnFriday_WithLambda() {
  LocalDateTime ldt = LocalDateTime.now();
  assumingThat(ldt.getDayOfWeek().getValue() == 5,
      () -> {
        // Execute this if assumption holds...
      });
  // Execute this regardless
}
```

Note that everything after the lambda will execute, regardless of whether the assumption in `assumingThat()` holds.

### Nesting unit tests for clarity

Before we move on to the next section, I want to show you one last feature of writing unit tests in JUnit 5.

The JUnit Jupiter API lets you create nested classes in order to keep your test code cleaner, which will help make your test results easier to read. Creating nested test classes within a main class allows you to create additional namespaces, which provides two primary benefits:

*   Each unit test may have its own pre- and post-test lifecycle. This allows you to create the class under test using special conditions to test corner cases.
*   Unit test method names just got simpler. In JUnit 4, all test methods exist as peers, where duplicate method names are not allowed (so you wind up with method names like `testMethodButOnlyUnderThisOrThatCondition_2()`). Starting with JUnit Jupiter, only methods in the nested class must have unique names. Listing 6 demonstrates.

##### Listing 5. Passing an empty or null array reference

```
@RunWith(JUnitPlatform.class)
@DisplayName("Testing JUnit 5")
public class JUnit5AppTest {
.
.                
  @Nested
  @DisplayName("When zero operands")
  class JUnit5AppZeroOperandsTest {
  
  // @Test methods go here...
  
  }
.
.
}
```

Note Line 6, where the `JUnit5AppZeroOperandsTest` class can have test methods. The results of any tests will be displayed as nested within the parent class, `JUnit5AppTest`.

## Running tests using JUnit Platform

Writing unit tests is great, but it's not of much use if you can't run them. In this section I'll show you how to run JUnit tests in Eclipse, using first Maven and then Gradle from the command line.

The video below shows you how to clone the sample application code from GitHub and run tests in Eclipse. In the video, I also show you how to run the unit tests from the command line and from within Eclipse using Maven and Gradle. Eclipse has great support for both Maven and Gradle.

[Watch the video: Running unit tests in Eclipse, Maven, and Gradle](https://www.youtube.com/watch?v=M7pTm34eqYc)

[Transcript](http://www.ibm.com/developerworks/library/j-introducing-junit5-part1-jupiter-api/running-unit-tests-in-eclipse-maven-and-gradle-transcript.txt)

I'll provide brief instructions below, but the video offers more detail. Watch the video to learn how to:

*   Clone the HelloJUnit5 sample application from GitHub.
*   Import the application into Eclipse.
*   Run a single JUnit test from the HelloJUnit5 application from within Eclipse.
*   Use Maven to run the HelloJUnit5 unit tests from the command line.
*   Use Gradle to run the HelloJUnit5 unit tests from the command line.

### Clone the HelloJUnit5 sample application

In order to follow along with the rest of the tutorial, you'll need to clone the sample application from GitHub. To do this, open a terminal window (Mac) or a command prompt (Windows), navigate to a directory where you want the code to reside, and enter the following command:

git clone https://github.com/makotogo/HelloJUnit5

Now that you have the code on your machine, you can run JUnit tests inside of your Eclipse IDE. I'll show you how to do that next.

### Running unit tests in your Eclipse IDE

If you followed along with the video, you should already have the code imported into Eclipse. Now, open the **Project Explorer** view in Eclipse, and expand the HelloJUnit5 project until you see the `JUnit5AppTest` class under the `src/test/java` path.

Open `JUnit5AppTest.java` and verify the following annotation just before the `class` definition (Line 3 below):

```
.
.
@RunWith(JUnitPlatform.class)
public class JUnit5AppTest {
.
.
}
```

Now right-click `JUnit5AppTest` and choose **Run As > JUnit Test**. The JUnit view will come up when the unit tests run. You are now ready to complete the exercises for this tutorial.

### Running unit tests with Maven

Open a terminal window (Mac) or command prompt (Windows), navigate to the directory where you cloned the HelloJUnit5 application, and enter the following command:

```
mvn test
```

This will kick off the Maven build and run the unit tests. Your output should look like the following:

```
$ mvn clean test
[INFO] Scanning for projects...
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building HelloJUnit5 1.0.2
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ HelloJUnit5 ---
[INFO] Deleting /Users/sperry/home/development/projects/learn/HelloJUnit5/target
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ HelloJUnit5 ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory /Users/sperry/home/development/projects/learn/HelloJUnit5/src/main/resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.6.1:compile (default-compile) @ HelloJUnit5 ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 2 source files to /Users/sperry/home/development/projects/learn/HelloJUnit5/target/classes
[INFO] 
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ HelloJUnit5 ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory /Users/sperry/home/development/projects/learn/HelloJUnit5/src/test/resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.6.1:testCompile (default-testCompile) @ HelloJUnit5 ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 2 source files to /Users/sperry/home/development/projects/learn/HelloJUnit5/target/test-classes
[INFO] 
[INFO] --- maven-surefire-plugin:2.19:test (default-test) @ HelloJUnit5 ---
 
-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Nov 28, 2017 6:04:49 PM org.junit.vintage.engine.discovery.DefensiveAllDefaultPossibilitiesBuilder$DefensiveAnnotatedBuilder buildRunner
WARNING: Ignoring test class using JUnitPlatform runner: com.makotojava.learn.hellojunit5.solution.JUnit5AppTest
Running com.makotojava.learn.hellojunit5.solution.JUnit5AppTest
Nov 28, 2017 6:04:49 PM org.junit.vintage.engine.discovery.DefensiveAllDefaultPossibilitiesBuilder$DefensiveAnnotatedBuilder buildRunner
WARNING: Ignoring test class using JUnitPlatform runner: com.makotojava.learn.hellojunit5.solution.JUnit5AppTest
Tests run: 1, Failures: 0, Errors: 0, Skipped: 1, Time elapsed: 0.038 sec - in com.makotojava.learn.hellojunit5.solution.JUnit5AppTest
 
Results :
 
Tests run: 1, Failures: 0, Errors: 0, Skipped: 1
 
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 3.741 s
[INFO] Finished at: 2017-11-28T18:04:50-06:00
[INFO] Final Memory: 21M/255M
[INFO] ------------------------------------------------------------------------
```

### Running unit tests with Gradle

Open a terminal window (Mac) or command prompt (Windows), navigate to the directory where you cloned the HelloJUnit5 application, and enter this command:

```
gradle clean test
```

The output should look like this:

```
$ gradle clean test
Starting a Gradle Daemon (subsequent builds will be faster)
:clean
:compileJava
:processResources NO-SOURCE
:classes
:compileTestJava
:processTestResources NO-SOURCE
:testClasses
:junitPlatformTest
ERROR StatusLogger No log4j2 configuration file found. Using default configuration: logging only errors to the console.
 
Test run finished after 10097 ms
[         7 containers found      ]
[         5 containers skipped    ]
[         2 containers started    ]
[         0 containers aborted    ]
[         2 containers successful ]
[         0 containers failed     ]
[        10 tests found           ]
[        10 tests skipped         ]
[         0 tests started         ]
[         0 tests aborted         ]
[         0 tests successful      ]
[         0 tests failed          ]
 
:test SKIPPED
 
BUILD SUCCESSFUL
 
Total time: 21.014 secs
```

## Test exercises

Up till now, you have been reading about JUnit Jupiter, looking at code examples, and watching (and hopefully following along with) the video. That's great and all, but there is nothing like getting your hands in the code! In this last section of Part 1, you'll do the following:

*   Write JUnit Jupiter API unit tests.
*   Run your unit tests.
*   Implement the `App` class so your unit tests pass.

In true, test-driven development (TDD) fashion, you will write the unit tests first, run them, and watch them all fail. Then you'll write the implementation until the unit tests pass, at which point you'll be done.

Note that the `JUnit5AppTest` class comes out-of-the-box with only two test methods. Both will be "in the green" when you first run the class. To complete the exercises, you need to add the remaining code, including annotations to tell JUnit which test methods to run. Remember: if a class or method is not properly instrumented, JUnit will simply skip it.

If you get stuck, check out the `com.makotojava.learn.hellojunit5.solution` package for the solution.

### 1. Write JUnit Jupiter unit tests

Start with `JUnit5AppTest.java`. Open this file and follow the directions in the Javadoc comments.

**Hint**: Use the Javadoc view in Eclipse to read the test instructions. To open the Javadoc view go to **Window > Show View > Javadoc**. You should see the Javadoc view. Depending on how you have your workspace setup, the window could appear in any number of places. In my workspace it looks like the screenshot in Figure 3, appearing just below the editor window, on the right-hand side of the IDE:

##### Figure 3. The Javadoc view

![A screenshot of the Javadoc view.](https://www.ibm.com/developerworks/library/j-introducing-junit5-part1-jupiter-api/Figure-3.png)

The Javadoc comments with raw HTML markup are shown in the editor window, but in the Javadoc window they are formatted and much easier to read.

### 2. Run unit tests in Eclipse

If you're like me, you'll use your IDE to do the following:

*   Write unit tests.
*   Write the implementation tested by the unit tests.
*   Run the initial tests (using the IDE's native JUnit support).

JUnit 5 provides a class called `JUnitPlatform`, which allows you to run JUnit 5 tests within Eclipse.

**JUnit 5 in Eclipse**: Eclipse currently understands JUnit 4, but does not yet provide native support for JUnit 5. Fortunately, that's not a big deal for most unit tests! Unless you need to use some of the more complex features of JUnit 4, the `JUnitPlatform` class will be sufficient to write unit tests to fully exercise your application code.

To run a test within Eclipse, make sure you have the sample application on your computer. The easiest way to do this is to clone the HelloJUnit5 application from GitHub, then import it into Eclipse. (Since the video for this tutorial shows you how to do that, I'll skip the details here and just provide the high-level steps.)

Make sure you've cloned the GitHub repository, then import the code into Eclipse as a new Maven project.

Once the project is imported into Eclipse, open the **Project Explorer** view and expand the `src/main/test` node until you see `JUnit5AppTest`. To run it as a JUnit test, right-click on it, and choose **Run As > JUnit Test**.

### 3. Implement the App class until unit tests pass

The functionality provided by `App`'s single `add()` method is easily understood, and very simple by design. I didn't want the business logic of a complicated application to get in the way of learning JUnit Jupiter.

Once your unit tests pass, you are done! Remember that if you get stuck, you can take a look in the `com.makotojava.learn.hellojunit5.solution` package for the solution.

## Conclusion to Part 1

In this first half of the JUnit 5 tutorial, I've introduced you to JUnit 5's architecture and components, especially the JUnit Jupiter API. We've toured the annotations, assertions, and assumptions you'll use most frequently in JUnit 5, and you've worked through a quick exercise demonstrating how to run tests in Eclipse, Maven, and Gradle.

In [Part 2](http://www.ibm.com/developerworks/library/j-introducing-junit5-part2-vintage-jupiter-extension-model/index.html), you'll get to know some of the advanced features of JUnit 5:

*   The JUnit Jupiter Extension model
*   Method parameter injection
*   Parameterized tests

So where you do you go from here?

[Introducing JUnit 5 Part 2: JUnit 5 Vintage and the JUnit Jupiter Extension Model](https://github.com/xitu/gold-miner/blob/master/TODO1/j-introducing-junit5-part2-vintage-jupiter-extension-model.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
