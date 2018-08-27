> * 原文地址：[Make or break… with Gradle](https://medium.com/contentsquare-engineering-blog/make-or-break-with-gradle-dac2e858868d)
> * 原文作者：[Tancho Markovik](https://medium.com/@smarkovik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[jacksonke](https://github.com/jacksonke)
> * 校对者：[phxnirvana](https://github.com/phxnirvana) [stormrabbit](https://github.com/stormrabbit)

# 使用 Gradle 做构建检查 #

你是否听过这个词, 垃圾代码（**Legacy Code**）? 
你是否考虑过在实际工作中，你也会制造垃圾代码？

那感觉挺可怕的，对吧？

但这是真的吗？你的代码会是垃圾代码吗？
我会问自己这个问题，最后决定对这个课题做一些研究。我尝试去弄清楚开发者是如何定义垃圾代码的。
在我搜索的时候，我发现这么个定义：

> “有一种常见的误区，认为垃圾代码就是旧代码。虽然一些软件开发人员将垃圾代码视为一个写得不好的程序，但实际上，垃圾代码其实是开发者不再精心设计，而疲于不断修补的代码。客户的需求一直在变化，代码也要跟着变动，久而久之，无休止的变动会让最初编写好的代码演变成一个复杂的怪物。当不破坏原有的逻辑或者功能就无法添加新特性时，开发者就会将这种代码视作垃圾代码。这个时候，开发人员可能会开始尝试新的系统。”

听起来是否很熟悉？
那么，我们要如何解决这种问题呢？

最近我多数工作都是基于 Android 平台的，所以我接下去的讨论都会基于这个平台。我加入 ContentSquare 一段时间了，我很幸运能够直接影响两个移动平台。

“**我会从所犯的错误中汲取教训，同时不让其他人再一次犯同样的错误！**”

我开始研究相关工具，最终我想做的是在两个平台上实施相同的安全策略。

所以，我开始为我的安全策略定了些要求：

- 检测代码风格
- 增加代码分析器
- 添加特定的模式匹配，来查找代码
- 能持续性地产生文档
- 开发过程中，能够持续的发现问题
- 预防代码漏洞

### Git 及其它相关小工具 ###

（我们）配备了所有常用的工具。我们使用 GitHub，我们有一个运行我们的构建的 Jenkins 服务器。通常，我们使用特征分支方法。
这意味着，默认情况下，我们的分支如下所示：

![](https://cdn-images-1.medium.com/max/1000/1*iHPPa72N11sBI_JSDEGxEA.png)

Git 特征分支模型。图片由 github.com 提供

我们还决定，禁用直接提交代码到 master 分支，这意味着提交代码到 master 分支，只能通过发起 pull request 来合并分支。
在 GitHub 上，这样是超级容易实现的。只需要在你的代码库设置中，勾选保护这个分支。

![](https://cdn-images-1.medium.com/max/800/1*mMx46zrf2rs-mWVM_gvrnQ.png)

在 GitHub 上设置分支保护

以上介绍的是如何禁止开发者直接将代码提交到 master 分支。
从现在开始，只有通过提交 pull request 才能进行修改。这意味着，至少有一个人会审核你的代码。

这有两个好处：

1. 通过 pull 请求，我们会给关注的人发送代码变动的通知，他们能够通过审核代码来知悉代码的变动情况。
2. 采用彼此间的审核，我们可以减少错误的数量。当有人试图取巧而犯错的时候，其他人会注意到的。

目前，我们的构建循环非常简单。

```
./gradlew check // run unit tests 
./gradlew assemble // assemble all build flavors
```

现在开始介绍我们需要用到的工具。

作为要求，我们决定只使用通过 gradle 整合的工具。这将使我们能够完全无缝集成。

### [Lint](https://developer.android.com/studio/write/lint.html) ###

由于 lint 是一个常见的工具，这里不会详细介绍它，只会向您展示如何启用它。

Lint 是 Android 插件的一部分，但默认情况下，它没有在新项目中配置。
要启用它，可以将下面的代码段添加到 **build.gradle** 文件中的 **android** 代码段内。

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

上面的代码段中，需要注意的是：

1. warningsAsErrors = true — 将所有的警告当成错误处理
2. abortOnError = true — 发生 Lint 错误时，终止编译
3. lintConfig — 定义 Lint 规则的配置文件

现在我们已经配置过 lint，是时候动手运行看看。

Gradle 的 Android 插件有不少预定义的 tasks，你可以使用 **tasks** 选项罗列出所有的 tasks。
输出的日志数量巨大，下面是其中验证任务的片段：

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

我喜欢用 **check**，它是这样描述的 “运行所有检查 （runs all checks）”。

默认情况下， check 会调用所有可用的模块工程对应的 check 任务，这意味着，运行：

```
./gradlewcheck
```

会执行所有子模块工程的 check 任务，包括：

- debug/release 所有的单元测试
- debug/release 所有的 UI 测试
- Lint

这些特性正是我们现在所需要的，后面介绍的特性都会与这个 check 任务关联。

### 代码分析 ###

所以, 接下来，我阅读了 [PMD](https://github.com/smarkovik/make-or-break/blob/master/config/codequality-pmd.gradle), [Findbugs](https://github.com/smarkovik/make-or-break/blob/master/config/codequality-findbugs.gradle) 同时发现了 Facebook 的 [Infer](https://github.com/smarkovik/make-or-break/blob/master/config/codequality-infer.gradle).

**PMD** 是一个代码分析工具. 它能发现常见的编程缺陷，如未使用的变量，空的 catch 块，不必要的对象创建等等。 PMD 工作在源代码层，因此会发现以下问题：违反命名规则，缺少花括号，错误的 null 检查，长参数列表，不必要的构造函数，switch 中缺少 break 等。PMD还会告诉您代码的循环复杂性，这我觉得非常有帮助。

为了添加 PMD 作为分析器，我们需要在 build.gradle 文件中追加一些内容。我们可以添加下面的代码段

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

在这个脚本中，值得注意的有趣的点是：

1. check.dependsOn ‘pmd’ — 这行将 PMD 和 check 任务关联起来了。 这意味着，当我们调用 gradle check 的同时, pmd 作为依赖任务也会被一同调用。 这样, 团队可以习惯于调用 gradle check，所有相关的检查也同时进行。
2. ruleSetFiles — 定义将在此构建中使用的一组规则和细节。
3. reports block — 指定要扫描的内容，要忽略的内容以及要报告的位置。

**FindBugs** 是一个检查 Java 代码中潜在 bugs 的工具. 潜在错误分为四个等级: (i) 最严重的 (scariest)， (ii) 严重的 （scary）， (iii) 麻烦的 (troubling) 和 (iv) 关心的 (concerned)。它会给开发者关于代码中可能存在的问题的严重性给予提示。 FindBugs 工作于字节码层面, 而非源码层面。

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

这个配置中需要关注的点是：

1. check.dependsOn ‘findbugs’ — 跟之前一样，我们将它和 check 任务关联。
2. ignoreFailures = false — 定义发现的问题是要归类为警告还是错误。
3. reportLevel = “max” — 指定报错的阈值. 如果设置为 “low”， 则不需要过滤所发现的问题。 如果设置为 “medium” (默认值)， 低优先级的问题就会直接被滤掉。 如果设置为 “high”， 只有严重的问题才会被提出。
4. effort —-- 设置分析的等级. 启用分析，增加精度并发现更多错误，但可能需要更多内存并花费更多时间来完成。
5. reports = 报告生成的位置

**Infer** 是针对 Java， Objective-C 和 C 的静态分析工具。 infer 的优点在于它的双重检测所有的`@Nullable` vs `@NonNull` 注解的变量， 同时对于 Android，它有一些针对性的检测。 Infer 是个独立的工具， 这意味着默认情况下，它不需要集成到 Gradle 中， 但是 Uber 的小伙伴开发了 [Gradle plugin for Infer](https://github.com/uber-common/infer-plugin/) .
为了在构建过程中加入这个分析器，我们还是将它加入 Gradle 中。


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

添加这个插件是相对直接的，只需要定义哪些源文件需要检测，哪些不需要检测。

既然我们已经有了一些分析器，调用 ./**gradlew check** 然后查看会发生什么。
在大量的日志中，你会看到类似于下面的内容

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

但是定义代码风格是件痛苦的事情！

Google 又救场了! Google 实际上有对外公开了它的[代码风格](http://checkstyle.sourceforge.net/reports/google-java-style-20170228.html)。 因为实际上和 IntelliJ Idea 默认风格很类似，我仅仅修改了 Android studio 的“代码格式模板”，只需花费 10–15 分钟，[ 我就设置完了](https://github.com/smarkovik/make-or-break/tree/master/config/codestyle).

**专业提示** **: 如果您想不断自动格式化您的代码，IntelliJ 已经为你提供了。 您可以轻松地录制宏，它能够重新排列代码，重新给 imports 排序，移除未使用的 imports，以及执行其他与代码风格相关操作。当结束的时候，在末尾加上 “save all” 。 接下去, 用 ctrl + s 保存宏定义。 这些设置可以分享到团队内, 它会自动为每个人工作。**

### 生成文档 ###

对于 java 来说很直接，我们需要生成 Javadoc。

**步骤 1**: 需要给所有公共方法添加 JavaDoc 注释，这些注释得遵守一定的规则，并通过 Checkstyle 检测。

**步骤 2**: 采用 Gradle JavaDoc 插件

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

现在, 如果在输出目录执行 *./gradlew javadoc* ，在 `build/reports/javadoc` 目录中，你能够找到工程的完整 javadoc 文档

### 代码覆盖率报告 ###

这里我们会使用 Jacoco, 一个标准 java 插件。

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

这样, 类似地，执行 ./**gradlew** coverage 你可以在 `build/reports/coverage` 找到代码覆盖率报告。

值得注意的是，为了减少代码错误（code smell），当开发者忘了删除所添加的调试代码、或者是注释掉将来才会使用的代码的时候，应该终止编译。

```
e.printStacktrace();

System.out.println();

//this code will be used sometime
//if(contition){
// someImportantMethod()
//}
```

这里有个简单的解决方式, 只需要将下面的规则添加到 checkstyle 规则集中。

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

最后，我们的构建过程还有额外的两行：

```
./gradlew check // run unit tests
./gradlew javadoc // generate javadoc
./gradlew coverage // generate coverage reports
./gradlew assemble // assemble all build flavors
```

到这里，我们在必要的地方都已经加了检测校验。在最后我们还需要设置 Github，除非通过了 Jenkins 编译，否则不许分支合并。
使用 Github 插件，这会是相当容易的。你可以添加一个编译步骤，运行一次，让它可以在 Github 上使用。

![](https://cdn-images-1.medium.com/max/800/1*3udc8DO-_c9DaWQcnjcq0w.png)

添加 Jenkins 编译步骤

在 Github 上修改相应的状态要求

![](https://cdn-images-1.medium.com/max/800/1*DBfAZ5j0l47TLBhXmmUbOA.png)

在 Github 上设置状态要求

一旦编译完成，如果你的 PR 不符合我们设置的规则， Jenkins 编译算是失败的，这时，Github 会阻止分支合并。

![](https://cdn-images-1.medium.com/max/800/1*uPCb2nWdnm9IdnszVeiV8Q.png)

当 Jenkins 编译失败时，Github 阻止分支合并

### 总结 ###

你现在拥有包含如下规则的机制：

- 代码风格检测 ✓
- 静态代码分析 (Android specific and Java related) ✓
- 使用模式匹配，检测不良代码 ✓
- 使用 JavaDoc 生成可持续，可维护的文档 ✓
- 使用 Jenkins 来不断发现问题 ✓
- 保护 master 分支 ✓

棒极了，剩下要做的就是集中精力优化代码的体系结构以及持续优化整个系统。

我的 [github 项目](https://github.com/smarkovik/make-or-break)提供了一个样例，包含了上面提到的多数特性。

如果你也在巴黎，如果你有兴致，你可以来我们这里看看。[http://www.welcometothejungle.co/companies/contentsquare](http://www.welcometothejungle.co/companies/contentsquare).

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
