>* 原文链接 : [Unit tests with Mockito - Tutorial](http://www.vogella.com/tutorials/Mockito/article.html)
* 原文作者 : [vogella](http://www.vogella.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:



> This tutorial explains testing with the Mockito framework for writing software tests.

## 1\. Prerequisites

The following tutorial requires an understanding of unit testing with the JUnit framework.

In case your are not familiar with JUnit, please check the following JUnit tutorial: [http://www.vogella.com/tutorials/JUnit/article.html](http://www.vogella.com/tutorials/JUnit/article.html).

## 2\. Testing with mock objects

### 2.1\. Target and challenge of unit testing

A unit test should test a class in isolation. Side effects from other classes or the system should be eliminated if possible. To eliminate these side effects you have to replace dependencies to other classes. This can be done via using replacements for the real dependencies.

### 2.2\. Classifications of different test classes

A _dummy object_ is passed around but never used, i.e., its methods are never called. Such an object can for example be used to fill the parameter list of a method.

_Fake_ objects have working implementations, but are usually simplified. For example, they use an in memory database and not a real database.

A _stub_ class is an partial implementation for an interface or class with the purpose of using an instance of this stub class during testing. Stubs usually do responding at all to anything outside what’s programmed in for the test. Stubs may also record information about calls

A _mock object_ is a dummy implementation for an interface or a class in which you define the output of certain method calls.

Test doubles can be passed to other objects which are tested. Your tests can validate that the class reacts correctly during tests. For example, you can validate if certain methods on the mock object were called. This helps to ensure that you only test the class while running tests and that your tests are not affected by any side effects.

Mock objects are typically configured. Mock objects typically require less code to configure and should therefore be preferred.

### 2.3\. Mock object generation

You can create mock objects manually (via code) or use a mock framework to simulate these classes. Mock frameworks allow you to create mock objects at runtime and define their behavior.

The classical example for a mock object is a data provider. In production an implementation to connect to the real data source is used. But for testing a mock object simulates the data source and ensures that the test conditions are always the same.

These mock objects can be provided to the class which is tested. Therefore, the class to be tested should avoid any hard dependency on external data.

Mocking or mock frameworks allows testing the expected interaction with the mock object. You can, for example, validate that only certain methods have been called on the mock object.

### 2.4\. Using Mockito for mocking objects

_Mockito_ is a popular mock framework which can be used in conjunction with JUnit. Mockito allows you to create and configure mock objects. Using Mockito simplifies the development of tests for classes with external dependencies significantly.

If you use Mockito in tests you typically:

*   Mock away external dependencies and insert the mocks into the code under test

*   Execute the code under test

*   Validate that the code executed correctly

![mockitousagevisualization](http://ww2.sinaimg.cn/large/72f96cbagw1f5b2j8m2vsj20hh056jrv)

## 3\. Adding Mockito as dependencies to a project

### 3.1\. Using Grade

If you use Gradle, add the following dependency to the Gradle build file.


    repositories { jcenter() }
    dependencies { testCompile "org.mockito:mockito-core:2.0.57-beta" }


### 3.2\. Using Maven

Maven users can declare a dependency. Search for g:"org.mockito", a:"mockito-core" via the [http://search.maven.org](http://search.maven.org) website to find the correct pom entry.

### 3.3\. Using the Eclipse IDE

The Eclipse IDE supports Gradle as well as Maven. Mockito does not provide a "all" download in its latest version. Therefore you are advised to use either the Gradle or Maven tooling in Eclipes.

### 3.4\. OSGi or Eclipse plug-in development

In Eclipse RCP applications dependencies are usually obtained from p2 update sites. The Orbit repositories are a good source for third party libraries, which can be used in Eclipse based applications or plug-ins.

The Orbit repositories can be found here [http://download.eclipse.org/tools/orbit/downloads](http://download.eclipse.org/tools/orbit/downloads)

![orbit p2 mockito](http://ww2.sinaimg.cn/large/72f96cbagw1f5b2jlbr97j20ny0hg77c)

## 4\. Using the Mockito API

### 4.1\. Static imports

If you add a static import for `org.mockito.Mockito.*;`, you can access Mockitos methods like `mock()` directly. Static imports allows you to call static members, i.e., methods and fields of a class directly without specifying the class.

### 4.2\. Creating and configuring mock objects with Mockito

Mockito supports the creation of mock objects. For this you can use the static `mock()` method.

Mockito also supports the creation of mock objects based on the `@Mock` annotation.

If you use this annotation, you must initialize the mock objects. The `MockitoRule` allows this. It invokes the static method `MockitoAnnotations.initMocks(this)` to populate the annotated fields. Alternatively you can use `@RunWith(MockitoJUnitRunner.class)`.

The usage of the `@Mock` annotation and the `MockitoRule` rule is demonstrated by the following example.


    import static org.mockito.Mockito.*;

    public class MockitoTest  {

            @Mock
            MyDatabase databaseMock; (1)

            @Rule public MockitoRule mockitoRule = MockitoJUnit.rule(); (2)

            @Test
            public void testQuery()  {
                    ClassToTest t  = new ClassToTest(databaseMock); (3)
                    boolean check = t.query("* from t"); (4)
                    assertTrue(check); (5)
                    verify(databaseMock).query("* from t"); (6)
            }
    }




1. Tells Mockito to most the databaseMock instance

2. Tells Mockito to create the mocks based on the @Mock annotation

3. Instantiates the class under test using the created mock

4. Executes some code of the class under test

5. Asserts that the method call returned true

6. Verify that the query method was called on the `MyDatabase` mock

### 4.3\. Configuring mocks

To configure which values are returned at a method call the Mockito framework defines a fluent API.

The `when(…​.).thenReturn(…​.)` method chain is be used to specify a condition and a return value for this condition. If you specify more than one value, they are returned in the order of specification until the last one is used. Afterwards the last specified value is returned. Mocks can also return different values depending on arguments passed into a method. You also use methods like `anyString` or `anyInt` to define that independent of the input value a certain return value should be returned.


    import static org.mockito.Mockito.*;
    import static org.junit.Assert.*;

    @Test
    public void test1()  {
            //  create mock
            MyClass test = Mockito.mock(MyClass.class);

            // define return value for method getUniqueId()
            when(test.getUniqueId()).thenReturn(43);

            // use mock in test....
            assertEquals(test.getUniqueId(), 43);
    }

    // Demonstrates the return of multiple values
    @Test
    public void testMoreThanOneReturnValue()  {
            Iterator i= mock(Iterator.class);
            when(i.next()).thenReturn("Mockito").thenReturn("rocks");
            String result=i.next()+" "+i.next();
            //assert
            assertEquals("Mockito rocks", result);
    }

    // this test demonstrates how to return values based on the input
    @Test
    public void testReturnValueDependentOnMethodParameter()  {
            Comparable c= mock(Comparable.class);
            when(c.compareTo("Mockito")).thenReturn(1);
            when(c.compareTo("Eclipse")).thenReturn(2);
            //assert
            assertEquals(1,c.compareTo("Mockito"));
    }

    // this test demonstrates how to return values independent of the input value

    @Test
    public void testReturnValueInDependentOnMethodParameter()  {
            Comparable c= mock(Comparable.class);
            when(c.compareTo(anyInt())).thenReturn(-1);
            //assert
            assertEquals(-1 ,c.compareTo(9));
    }

    // return a value based on the type of the provide parameter

    @Test
    public void testReturnValueInDependentOnMethodParameter()  {
            Comparable c= mock(Comparable.class);
            when(c.compareTo(isA(Todo.class))).thenReturn(0);
            //assert
            Todo todo = new Todo(5);
            assertEquals(todo ,c.compareTo(new Todo(1)));
    }


The `doReturn(…​).when(…​).methodCall` call chain works similar but is useful for void methods. The `doThrow` variant can be used for methods which return `void` to throw an exception. This usage is demonstrated by the following code snippet.


    import static org.mockito.Mockito.*;
    import static org.junit.Assert.*;

    // this test demonstrates how use doThrow

    @Test(expected=IOException.class)
    public void testForIOException() {
            // create an configure mock
            OutputStream mockStream = mock(OutputStream.class);
            doThrow(new IOException()).when(mockStream).close();

            // use mock
            OutputStreamWriter streamWriter= new OutputStreamWriter(mockStream);
            streamWriter.close();
    }


### 4.4\. Verify the calls on the mock objects

Mockito keeps track of all the method calls and their parameters to the mock object. You can use the `verify()` method on the mock object to verify that the specified conditions are met For example, you can verify that a method has been called with certain parameters. This kind of testing is sometimes called _behavior testing_. Behavior testing does not check the result of a method call, but it checks that a method is called with the right parameters.



    import static org.mockito.Mockito.*;

    @Test
    public void testVerify()  {
            // create and configure mock
            MyClass test = Mockito.mock(MyClass.class);
            when(test.getUniqueId()).thenReturn(43);

            // call method testing on the mock with parameter 12
            test.testing(12);
            test.getUniqueId();
            test.getUniqueId();

            // now check if method testing was called with the parameter 12
            verify(test).testing(Matchers.eq(12));

            // was the method called twice?
            verify(test, times(2)).getUniqueId();

            // other alternatives for verifiying the number of method calls for a method
            verify(mock, never()).someMethod("never called");
            verify(mock, atLeastOnce()).someMethod("called at least once");
            verify(mock, atLeast(2)).someMethod("called at least twice");
            verify(mock, times(5)).someMethod("called five times");
            verify(mock, atMost(3)).someMethod("called at most 3 times");
    }

### 4.5\. Wrapping Java objects with Spy

@Spy or the `spy()` method can be used to wrap a real object. Every call, unless specified otherwise, is delegated to the object.


    import static org.mockito.Mockito.*;

    // Lets mock a LinkedList
    List list = new LinkedList();
    List spy = spy(list);

    //You have to use doReturn() for stubbing
    doReturn("foo").when(spy).get(0);

    // this would not work
    // real method is called so spy.get(0)
    // throws IndexOutOfBoundsException (list is still empty)
    when(spy.get(0)).thenReturn("foo");

The `verifyNoMoreInteractions()` allows you to check that no other method was called.

### 4.6\. Using @InjectMocks for dependency injection via Mockito

You also have the `@InjectMocks` annotation which tries to do constructor, method or field dependency injection based on the type. For example, assume that you have the following class.

    public class ArticleManager {
        private User user;
        private ArticleDatabase database;

        ArticleManager(User user) {
         this.user = user;
        }

        void setDatabase(ArticleDatabase database) { }
    }


This class can be constructed via Mockito and its dependencies can be fulfullied with mock objects as demonstrated by the following code snippet.


    @RunWith(MockitoJUnitRunner.class)
    public class ArticleManagerTest  {

           @Mock ArticleCalculator calculator;
           @Mock ArticleDatabase database;
           @Most User user;

           @Spy private UserProvider userProvider = new ConsumerUserProvider();

           @InjectMocks private ArticleManager manager; (1)

           @Test public void shouldDoSomething() {
                   // assume that ArticleManager has a method called initialize which calls a method
                   // addListener with an instance of ArticleListener
                   manager.initialize();

               // validate that addListener was called
                   verify(database).addListener(any(ArticleListener.class));
           }
    }


1. creates an instance of ArticleManager and injects the mocks into it

For more information see [http://docs.mockito.googlecode.com/hg/1.9.5/org/mockito/InjectMocks.html](http://docs.mockito.googlecode.com/hg/1.9.5/org/mockito/InjectMocks.html).

### 4.7\. Capturing the arguments

The `ArgumentCaptor` class allows to access the arguments of method calls during the verification. This allows to capture these arguments of method calls and to use them for tests.


    import static org.hamcrest.Matchers.hasItem;
    import static org.junit.Assert.assertThat;
    import static org.mockito.Mockito.mock;
    import static org.mockito.Mockito.verify;

    import java.util.Arrays;
    import java.util.List;

    import org.junit.Rule;
    import org.junit.Test;
    import org.mockito.ArgumentCaptor;
    import org.mockito.Captor;
    import org.mockito.junit.MockitoJUnit;
    import org.mockito.junit.MockitoRule;

    public class MockitoTests {

            @Rule public MockitoRule rule = MockitoJUnit.rule();

            @Captor
        private ArgumentCaptor<List<String>> captor;

            @Test
        public final void shouldContainCertainListItem() {
                    List<String> asList = Arrays.asList("someElement_test", "someElement");
            final List<String> mockedList = mock(List.class);
            mockedList.addAll(asList);

            verify(mockedList).addAll(captor.capture());
            final List<String> capturedArgument = captor.<List<String>>getValue();
            assertThat(capturedArgument, hasItem("someElement"));
        }
    }


### 4.8\. Limitations

Mockito has certain limitations. It can not test the following constructs:

*   final classes

*   anonymous classes

*   primitive types


## 5\. Using Mockito on Android

Mockito can also be directly used in Android unit tests by adding the dependency to it to the Gradle build file. To use it in instrumented Android tests (since the release 1.9.5). Which requires that dexmaker and dexmaker-mockito are also added as dependency in the Gradle build file.


    dependencies {
        testCompile 'junit:junit:4.12'
        // required if you want to use Mockito for unit tests
        testCompile 'org.mockito:mockito-core:1.+'
        // required if you want to use Mockito for Android instrumentation tests
        androidTestCompile 'org.mockito:mockito-core:1.+'
        androidTestCompile "com.google.dexmaker:dexmaker:1.2"
        androidTestCompile "com.google.dexmaker:dexmaker-mockito:1.2"
    }


## 6\. Exercise: Write an instrumented unit test using Mockito

### 6.1\. Create Application under tests on Android

Create an Android application with the package name `com.vogella.android.testing.mockito.contextmock`. Add a static method which allows to create an intent with certain parameters as in the following example.

    public static Intent createQuery(Context context, String query, String value) {
            // Reuse MainActivity for simplification
        Intent i = new Intent(context, MainActivity.class);
        i.putExtra("QUERY", query);
        i.putExtra("VALUE", value);
        return i;
    }


### 6.2\. Add the Mockito dependency to the app/build.gradle file

    dependencies {
        // the following is required to use Mockito and JUnit for your
        // instrumentation unit tests on the JVM
            androidTestCompile 'junit:junit:4.12'
        androidTestCompile 'org.mockito:mockito-core:2.0.57-beta'
        androidTestCompile 'com.android.support.test:runner:0.3'
        androidTestCompile "com.google.dexmaker:dexmaker:1.2"
        androidTestCompile "com.google.dexmaker:dexmaker-mockito:1.2"

        // the following is required to use Mockito and JUnit for your unit
        // tests on the JVM
        testCompile 'junit:junit:4.12'
        testCompile 'org.mockito:mockito-core:1.+'

    }


### 6.3\. Create test

Create a new unit test using Mockito to check that the intent is triggered with the correct extra data.

For this you mock the `Context` object with Mockito as in the following example.

    package com.vogella.android.testing.mockitocontextmock;

    import android.content.Context;
    import android.content.Intent;
    import android.os.Bundle;

    import org.junit.Test;
    import org.junit.runner.RunWith;
    import org.mockito.Mockito;

    import static org.junit.Assert.assertEquals;
    import static org.junit.Assert.assertNotNull;

    public class TextIntentCreation {

        @Test
        public void testIntentShouldBeCreated() {
            Context context = Mockito.mock(Context.class);
            Intent intent = MainActivity.createQuery(context, "query", "value");
            assertNotNull(intent);
            Bundle extras = intent.getExtras();
            assertNotNull(extras);
            assertEquals("query", extras.getString("QUERY"));
            assertEquals("value", extras.getString("VALUE"));
        }
    }


## 7\. Exercise: Creating mock objects using Mockito

### 7.1\. Target

Create an API, which can be mocked and use Mockito to do the job.

### 7.2\. Create a sample Twitter API

Implement a `TwitterClient`, which works with `ITweet` instances. But imagine these `ITweet` instances are pretty cumbersome to get, e.g., by using a complex service, which would have to be started.


    public interface ITweet {

            String getMessage();
    }


    public class TwitterClient {

            public void sendTweet(ITweet tweet) {
                    String message = tweet.getMessage();

                    // send the message to Twitter
            }
    }


### 7.3\. Mocking ITweet instances

In order to avoid starting up a complex service to get `ITweet` instances, they can also be mocked by Mockito.


    @Test
    public void testSendingTweet() {
            TwitterClient twitterClient = new TwitterClient();

            ITweet iTweet = mock(ITweet.class);

            when(iTweet.getMessage()).thenReturn("Using mockito is great");

            twitterClient.sendTweet(iTweet);
    }


Now the `TwitterClient` can make use of a mocked `ITweet` instance and will get "Using Mockito is great" as message when calling `getMessage()` on the mocked `ITweet`.


### 7.4\. Verify method invocation

Ensure that getMessage() is at least called once.



    @Test
    public void testSendingTweet() {
            TwitterClient twitterClient = new TwitterClient();

            ITweet iTweet = mock(ITweet.class);

            when(iTweet.getMessage()).thenReturn("Using mockito is great");

            twitterClient.sendTweet(iTweet);

            verify(iTweet, atLeastOnce()).getMessage();
    }


### 7.5\. Validate

Run the test and validate that it is successful.

## 8\. Mocking static methods

<div class="sectionbody">

<div class="sect2">

### 8.1\. Powermock for mocking static methods

Mockito cannot mock static methods. For this you can use `Powermock`.


    import java.net.InetAddress;
    import java.net.UnknownHostException;

    public final class NetworkReader {
        public static String getLocalHostname() {
            String hostname = "";
            try {
                InetAddress addr = InetAddress.getLocalHost();
                // Get hostname
                hostname = addr.getHostName();
            } catch ( UnknownHostException e ) {
            }
            return hostname;
        }
    }


To write a test which mocks away the NetworkReader as dependency you can use the following snippet.


    import org.junit.runner.RunWith;
    import org.powermock.core.classloader.annotations.PrepareForTest;

    @RunWith( PowerMockRunner.class )
    @PrepareForTest( NetworkReader.class )
    public class MyTest {

    // Find the tests here

     @Test
    public void testSomething() {
        mockStatic( NetworkUtil.class );
        when( NetworkReader.getLocalHostname() ).andReturn( "localhost" );

        // now test the class which uses NetworkReader
    }
    ===

    == Using a wrapper instead of Powermock

    Sometimes you can also use a wrapper around a static method, which can be mocked with Powermock.

    [source,java]

class FooWraper { void someMethod() { Foo.someStaticMethod() } }


[[resources_mockito]]
== Mockito resources

http://site.mockito.org - Mockito home page

https://github.com/mockito/mockito- Mockito project hosting page

https://github.com/mockito/mockito/blob/master/doc/release-notes/official.md - Mockito release notes

http://martinfowler.com/articles/mocksArentStubs.html Martin Fowler about Mocks, Stubs etc.

http://chiuki.github.io/advanced-android-espresso/ Chiu-Ki Chan Advanced Android Espresso presentation</pre>

