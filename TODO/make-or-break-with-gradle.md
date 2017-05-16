> * 原文地址：[Make or break… with Gradle](https://medium.com/contentsquare-engineering-blog/make-or-break-with-gradle-dac2e858868d)
> * 原文作者：[Tancho Markovik](https://medium.com/@smarkovik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Make or break… with Gradle #

Have you ever heard of the phrase, ***Legacy Code***?
Have you ever considered you may be producing Legacy code in real time?

The feeling is horrible, right?

But is it true, is your code “Legacy” ?
I asked myself this question, and decided to do some research on the subject. I tried to figure out how one applies the adjective “Legacy” to code?
While searching, I found this definition:

> “ There is a common, false perception that legacy code is old. Although some software developers look at legacy code as a poorly written program, legacy code actually describes a code base that is no longer engineered but continually patched. Over time, an unlimited number of modifications may be made to a code base based on customer demand, causing what was originally well-written code to evolve into a complex monster. A software developer will recognize legacy code when a feature cannot be added without breaking other logic or features. At this point, the developers may begin lobbying for a new system.”

Sounds familiar?
So how do we fix this?

I’ve worked on Android a lot recently, so I will relate the discussion to this platform. I recently joined ContentSquare, and I was lucky enough have the ability to directly affect both Mobile platforms.

“*I will learn from my mistakes and never allow anyone to do them again!*”

I started looking into the tools of the trade, and also what I want to do, and eventually implement the same safety net on both platforms.

So I started writing requirements for my safety net:

- apply code style checks
- add code analyzers
- add specific pattern detectors
- require continuous code documentation
- perform continuous discovery of new issues
- stop the bleed

### Git and friends ###

Were equipped with all the usual tools. We use GitHub, and we have a Jenkins server which runs our builds. Our usual process uses the feature branch approach. 
This means our branch process by default looks like this:

![](https://cdn-images-1.medium.com/max/1000/1*iHPPa72N11sBI_JSDEGxEA.png)

Git feature branching model. Image courtesy of github.com

What we also decided, is to disable direct commits to master, meaning we only can push code to master through a branch merge with a pull request. 
Doing this on GitHub is super easy. Just go to your repo settings, and select protect this branch.

![](https://cdn-images-1.medium.com/max/800/1*mMx46zrf2rs-mWVM_gvrnQ.png)

Setting up branch protection on GitHub

What we just did is disallow anyone to commit and push directly to master.
From now on we have to go through a pull request which will be reviewed by at least one person.

This helps on two fronts:

1. With the pull request, we notify everyone of the change, allowing them to know the development of the code by review.
2. Using the peer reviews we get to reduce the amount of bugs as people notice when someone is taking a shortcut.

For the time being, our build loop is very simple.

```
./gradlew check // run unit tests 
./gradlew assemble // assemble all build flavors
```

OK, now off to finding the tools we’re going to use.

As a requirement, we decided to only use tools which integrate through gradle. This would allow us to have completely seamless integration.

### [Lint](https://developer.android.com/studio/write/lint.html) ###

As lint is a common tool I will not go into details about it, instead I will just show you how to enable it.

Lint is a part of the android plugin, but by default it’s not configured on new projects.
To enable it, add the following block to the ***android*** section of the ***build.gradle*** file.

```
lintOptions {
//lintrules of conduct
   warningsAsErrors true
   abortOnError true
   htmlReport true
   //locations**for**the rules and output
   lintConfig file("${rootDir}/config/lint/lint-config.xml")
   htmlOutput file("${buildDir}/reports/lint/lint.html")
}
```

In the above segment, the things to note are :

1. warningsAsErrors = true — Consider all warnings as errors
2. abortOnError = true — break the build on any Lint error
3. lintConfig — A file which provides input for lint, with definitions per rule

Ok, so now that we have lint done, we need to actually run it somehow.

Gradle’s android plugin has a quite a few pre-defined tasks, which you can get a complete listing of by using the option *tasks*. 
As the listing is huge, here’s an excerpt of it showing the verification tasks:

```
$ ./**gradlew****tasks**
------------------------------------------------------------
All tasks runnable from root project
------------------------------------------------------------

Android tasks
-------------
androidDependencies - Displays the Android dependencies of the project.
signingReport - Displays the signing info for each variant.
sourceSets - Prints out all the source sets defined in this project.
... etc ...
Verification tasks
------------------

check - Runs all checks.
connectedAndroidTest - Installs and runs instrumentation tests for all flavors on connected devices.
connectedCheck - Runs all device checks on currently connected devices.
connectedDebugAndroidTest - Installs and runs the tests for debug on connected devices.
createDebugCoverageReport - Creates test coverage reports for the debug variant.
deviceAndroidTest - Installs and runs instrumentation tests using all Device Providers.
deviceCheck - Runs all device checks using Device Providers and Test Servers.

lint - Runs lint on all variants.
lintDebug - Runs lint on the Debug build.
lintRelease - Runs lint on the Release build.
test - Run unit tests for all variants.
testDebugUnitTest - Run unit tests for the debug build. 
testReleaseUnitTest - Run unit tests for the release build.

... etc ...
```

I like *check* which is described simply as “runs all checks”.

By default check calls the appropriate check tasks on all available modules. This means, by running :

```
./gradlewcheck
```

You will run the check task on all submodules. And this task runs :

- all unit tests for debug/release flavor
- all UI tests for debug/release flavor
- Lint

For this moment this is all we need, and due to it’s nature, we will link all future checks to this task.

### Code Analysis ###

So, next I was reading up on [PMD](https://github.com/smarkovik/make-or-break/blob/master/config/codequality-pmd.gradle), [Findbugs](https://github.com/smarkovik/make-or-break/blob/master/config/codequality-findbugs.gradle) and discovered Facebook’s [Infer](https://github.com/smarkovik/make-or-break/blob/master/config/codequality-infer.gradle).

**PMD** is a source code analyzer. It finds common programming flaws like unused variables, empty catch blocks, unnecessary object creation, and so forth. PMD works on source code and therefore finds problems like: violation of naming conventions, lack of curly braces, misplaced null check, long parameter list, unnecessary constructor, missing break in switch, etc. PMD also tells you about the Cyclomatic complexity of your code which I find very helpful.

To add PMD as an analyzer, we have to append to the build.gradle file. We can add the following definitions

```
apply plugin: 'pmd'

def configDir = "${project.rootDir}/config"
def reportsDir = "${project.buildDir}/reports"
check.dependsOn 'pmd'
task pmd(type: Pmd, dependsOn: "assembleDebug") {
   ignoreFailures = false
   ruleSetFiles = files("$configDir/pmd/pmd-ruleset.xml")
   ruleSets = []
   source 'src/main/java'
   include '**/*.java'
   exclude '**/gen/**'
   reports {
      xml.enabled = true
      html.enabled = true
      xml {
         destination "$reportsDir/pmd/pmd.xml"
      }
      html {
         destination "$reportsDir/pmd/pmd.html"
      }
   }
}
```

In this script, the interesting things to note are :

1. check.dependsOn ‘pmd’ — this line links the PMD task with check. Which means, when we call gradle check, it will call pmd as a dependency task. This way, the team can get used to just calling gradle check and know all relevant checks are done through this task.
2. ruleSetFiles — defines the set of rules and specifics which are to be used in this installation.
3. reports block — defines all the requirements in terms of what to scan, what to ignore, and where to report.

**FindBugs** is an analyzer which detects possible bugs in Java programs. Potential errors are classified in four ranks: (i) scariest, (ii) scary, (iii) troubling and (iv) of concern. This is a hint to the developer about their possible impact or severity. FindBugs operates on Java bytecode, rather than source code.

```
apply plugin: 'findbugs'
def configDir = "${project.rootDir}/config"
def reportsDir = "${project.buildDir}/reports"
check.dependsOn 'findbugs'
task findbugs(type: FindBugs, dependsOn: "assembleDebug") {
   ignoreFailures = false
   effort = "max"
   reportLevel = "high"
   excludeFilter = new File("$configDir/findbugs/findbugs-filter.xml")
   classes = files("${buildDir}/intermediates/classes")
   source'src/main/java'
   include '**/*.java'
   exclude '**/gen/**'
   reports { 
      xml.enabled = true
      html.enabled = false
      xml {
         destination "$reportsDir/findbugs/findbugs.xml"
      }
      html {
         destination "$reportsDir/findbugs/findbugs.html"
      }
   }
   classpath = files()
}
```

Things to note in this configuration are:

1. check.dependsOn ‘findbugs’ — same as before, we link it to check
2. ignoreFailures = false — defines whether any discoveries are used as warnings or errors.
3. reportLevel = “max” — It specifies the confidence/priority threshold for reporting issues. If set to “low”, confidence is not used to filter bugs. If set to “medium” (the default), low confidence issues are suppressed. If set to “high”, only high confidence bugs are reported
4. effort — Set the analysis effort level. Enable analyses which increase precision and find more bugs, but which may require more memory and take more time to complete.
5. reports = the location where the reports will be saved.

**Infer** is a static analysis tool for Java, Objective-C and C. What was nice about infer is the fact it double checks all `@Nullable` vs `@NonNull` annotated variables and has some Android specific checks which were of interest. Infer is a standalone tool, which means that by default it doesn’t integrate with Gradle, however, good guy Uber developed a [Gradle plugin for Infer](https://github.com/uber-common/infer-plugin/) .
To add this analyzer to our build process, we again add to Gradle.

```
apply plugin: 'com.uber.infer.android'
check.dependsOn 'inferDebug'
check.dependsOn 'eradicateDebug'
inferPlugin {
   infer {
      include = project.files("src/main")
      exclude = project.files("build/")
   }
   eradicate {
   include = project.files("src/main")
   exclude = project.files("build/")
   }
}
```

Adding this plugin is quite straightforward, we only define the sources which are to be included and excluded from the check.

Now that we have some analyzers, call ./***gradlew check*** and see what happens. 
Within the huge log, you will see something similar to the following

```
:mylibrary:inferCheckForCommand
:mylibrary:inferPrepareDebug
:mylibrary:eradicateDebug
Starting analysis...

legend:
  "F" analyzing a file
  "." analyzing a procedure

Found 12 source files in /Users/tancho/Development/repos/tests/make-or-break/mylibrary/build/infer-out

  No issues found
:mylibrary:findbugs UP-TO-DATE
:mylibrary:inferDebug
Starting analysis...

legend:
  "F" analyzing a file
  "." analyzing a procedure

Found 12 source files in /Users/tancho/Development/repos/tests/make-or-break/mylibrary/build/infer-out

  No issues found

:mylibrary:deleteInferConfig
:mylibrary:lint
Ran lint on variant release: 0 issues found
Ran lint on variant debug: 0 issues found
:mylibrary:pmd
```

However defining the code style was a pain!

Google to the rescue! Google actually provides it’s [code style](http://checkstyle.sourceforge.net/reports/google-java-style-20170228.html) publicly. And as it was already pretty close to the IntelliJ Idea defaults,
I just modified the “code formatting template” in studio and within 10–15 mins,[ I was all set](https://github.com/smarkovik/make-or-break/tree/master/config/codestyle).

***ProTip*** *: if you want to constantly auto format your code, IntelliJ has you covered. You can easily record a macro, which will, rearrange code, re-order imports, remove unused imports, as well as do any other style related operations. When done put a “save all” at the end. Next, store the macro and assign it to ctrl+s. These settings, can be shared to the team, and it automagically works for everyone.*

### Generating documentation ###

Quite straight forward for java, we need to generate a Javadoc.

**Step1**: Require a JavaDoc comment on all public methods, through Checkstyle, already done in the default rules.

**Step2**: implement the Gradle JavaDoc plugin

```
task javadoc(type: Javadoc) {
    source = android.sourceSets.main.java.srcDirs
    title = "Library SDK"
    classpath = files(project.android.getBootClasspath())
    destinationDir = file("${buildDir}/reports/javadoc/analytics-sdk/")
    options {
        links "http://docs.oracle.com/javase/7/docs/api/"
        linksOffline "http://d.android.com/reference","${android.sdkDirectory}/docs/reference"
    }
    exclude '**/BuildConfig.java'
    exclude '**/R.java'
}
afterEvaluate {
    // fixes issue where javadoc can't find android symbols ref: http://stackoverflow.com/a/34572606
    androidJavadocs.classpath += files(android.libraryVariants.collect { variant ->
        variant.javaCompile.classpath.files
    })
}

```

Now, if you call *./gradlew javadoc* in your output folder, `build/reports/javadoc` you will find the complete javadoc for your project

### Code coverage reports ###

For this task we’ll use Jacoco, a java standard.

```
apply plugin: 'jacoco'
jacoco {
    toolVersion = "0.7.5.201505241946"
}
task coverage(type: JacocoReport, dependsOn: "testDebugUnitTest") {
    group = "Reporting"
    description = "Generate Jacoco coverage reports after running tests."
    reports {
        xml.enabled = true
        html.enabled = true
        html.destination "${buildDir}/reports/codecoverage"
    }
    def ignoredFilter = [
            '**/R.class',
            '**/R$*.class',
            '**/BuildConfig.*',
            '**/Manifest*.*',
            'android/**/*.*',
            'com.android/**/*.*',
            'com.google/**/*.*'
    ]
    def debugTree = fileTree(dir:"${project.buildDir}/intermediates/classes/debug", excludes: ignoredFilter)
    sourceDirectories = files(android.sourceSets.main.java.srcDirs)
    classDirectories = files([debugTree])
    additionalSourceDirs = files([
            "${buildDir}/generated/source/buildConfig/debug",
            "${buildDir}/generated/source/r/debug"
    ])
    executionData = fileTree(dir: project.projectDir, includes: ['**/*.exec', '**/*.ec'])
}
```

So, similarly by calling ./*gradlew* coverage in `build/reports/coverage` you would get a very nice coverage report page.

An important thing, in order to reduce code smell, was to break if developers forget code, used for debug purposes or comment out code in hopes of future use.

```
e.printStacktrace();

System.out.println();

//this code will be used sometime
//if(contition){
// someImportantMethod()
//}
```

There is a quick fix for this, just add these rules to your checkstyle rules set.

```
<module name="Regexp">
    <property name="format" value="System\.err\.print" />
    <property name="illegalPattern" value="true" />
    <property name="message" value="Bad Move, You should not use System.err.println" />
</module>
<module name="Regexp">
    <property name="format" value="\.printStacktrace" />
    <property name="illegalPattern" value="true" />
    <property name="message" value="Bad Move, You should not use System.err.println" />
</module>
<!--Check for commented out code-->
<module name="Regexp">
    <property name="format" value="^\s*//.*;\s*$" />
    <property name="illegalPattern" value="true" />
    <property name="message" value="Bad Move, Commented out code detected, it smells." />
</module>
```

At the end, our build loop has two extra lines:

```
./gradlew check // run unit tests
./gradlew javadoc // generate javadoc
./gradlew coverage // generate coverage reports
./gradlew assemble // assemble all build flavors
```

So now that we have our checks in place, at last we need to set Github to disallow branch merges unless our Jenkins build passes. 
This is quite easy with the Github plugin. You can just add a post build step, and run it once to have it available on Github

![](https://cdn-images-1.medium.com/max/800/1*3udc8DO-_c9DaWQcnjcq0w.png)

Adding a Jenkins build step

and add the corresponding status as a requirement on Github

![](https://cdn-images-1.medium.com/max/800/1*DBfAZ5j0l47TLBhXmmUbOA.png)

Setting up a status requirement in GitHub

And now, once a build finishes, if you have a PR that does not conform to the rules put in place, Jenkins fails the build and by this Github blocks the merge! \o/

![](https://cdn-images-1.medium.com/max/800/1*uPCb2nWdnm9IdnszVeiV8Q.png)

Github blocks merges if Jenkins fails to build a plan

### Summary ###

You now have a mechanism which runs :

- Code style checks ✓
- Static code analysis (Android specific and Java related) ✓
- Bad practice pattern detectors ✓
- Continuous documentation through JavaDoc ✓
- Continuous discovery through the Jenkins loop ✓
- Stopping the bleed through the master branch protection ✓

Nice, now all you’re left to do is focus on the architecture of the code and continue improving your system.

A sample code project implementing most of the above can be found on my github repo, [https://github.com/smarkovik/make-or-break](https://github.com/smarkovik/make-or-break).

Oh, and if you’re in Paris and interested, look us up.. [http://www.welcometothejungle.co/companies/contentsquare](http://www.welcometothejungle.co/companies/contentsquare).

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
