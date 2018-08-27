> * 原文链接 : [How to improve quality and syntax of your Android code](http://vincentbrison.com/2014/07/19/how-to-improve-quality-and-syntax-of-your-android-code/)
* 原文作者 : [Vincent Brison](http://vincentbrison.com/author/admin/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [尹述迪](http://yinshudi.com/)
* 校对者: [laobie](https://github.com/laobie)

# 如何提高安卓代码的质量和语法

在这篇文章中，我会介绍几种不同的方式，让你通过自动化工具提高你的Android代码质量，包括 [Checkstyle](http://checkstyle.sourceforge.net/)， [Findbugs](http://findbugs.sourceforge.net/)， [PMD](http://pmd.sourceforge.net/)， 当然，还有我们最熟悉的[Android Lint](http://tools.android.com/tips/lint)。 为了让你的代码保持缜密的语法，同时避免一些糟糕的实现和错误，使用自动化的方式测试你的代码十分有用，尤其是当你和队友一起工作时。我会细心地解释如何直接通过你的Gradle构建脚本使用这些工具，和怎么方便地配置它们。

## Fork这个例子
我强烈建议你fork[此项目](https://github.com/vincentbrison/vb-android-app-quality.git)，因为我将介绍的所有例子均来自于它。同时，你也能自己测试这些质量控制工具。

## 关于Gradle任务
理解任务在Gradle中的概念是理解这篇文章的基础(广义上，也是学会撰写Gradle脚本的基础)。我强烈建议你先阅读一下Gradle文档中关于任务的部分([这个](http://www.gradle.org/docs/current/userguide/tutorial_using_tasks.html)和[这个](http://www.gradle.org/docs/current/userguide/more_about_tasks.html))。
文档中包含许多例子，非常容易理解。好了，那现在我就假设你已经fork了我的仓库，将项目导入了你的Android Studio，同时也已经熟悉了Gradle的任务。如果没有也不必担心，我会尽我所能解释得通俗易懂。

## Demo项目的层次结构
你能将`gradle`脚本分离在很多文件中，目前我分了3个`gradle`文件：
* [一个在根目录](https://github.com/vincentbrison/vb-android-app-quality/blob/master/build.gradle)，这个文件是关于项目的一些配置(比如使用的maven仓库和使用的Gradle版本)；
* [一个在子文件夹`app`中](https://github.com/vincentbrison/vb-android-app-quality/blob/master/app/build.gradle)，这是一个典型的构建Android应用的Gradle文件。
* [一个在子文件夹`config`中](https://github.com/vincentbrison/vb-android-app-quality/blob/master/config/quality.gradle)，这个才是我们所关注的，我用它来为我的项目集成并配置所有的质量控制工具。

# Checkstyle

[![](http://checkstyle.sourceforge.net/images/logo.png)](http://checkstyle.sourceforge.net/)

## 简介
> Checkstyle是一个帮助程序员坚持规范化编写Java代码的开发工具.它自动检查Java代码,将程序员从这项乏味(但重要)的工作中解放出来.

正如Checkstyle的开发者所说，这个工具帮助你在一个项目中，精确并灵活地定义和保持编码规范。当你运行Checkstyle时，它会分析你的Java代码，根据你的配置找出所有错误并提示你。

## 通过Gradle配置
以下代码展示了在你项目中使用`Checkstyle`的基本配置(作为一个`Gradle`任务)：

```Gradle
task checkstyle(type: Checkstyle) {
    configFile file("${project.rootDir}/config/quality/checkstyle/checkstyle.xml") // Where my checkstyle config is...
    configProperties.checkstyleSuppressionsPath = file("${project.rootDir}/config/quality/checkstyle/suppressions.xml").absolutePath // Where is my suppressions file for checkstyle is...
    source 'src'
    include '**/*.java'
    exclude '**/gen/**'
    classpath = files()
}
```
配置完后，这个任务就会根据`checkstyle.xml`和`suppressions.xml`两个文件来分析你的代码。只需要在`Gradle`面板中启动这个任务，Android Studio就会自动执行此任务。

[![checkstyle](http://vincentbrison.com/wp-content/uploads/2014/07/checkstyle.jpg)](http://vincentbrison.com/wp-content/uploads/2014/07/checkstyle.jpg)

运行`Checkstyle`后，你会得到一份报告，上面纪录了在你项目中找到的所有问题。而且它非常易于理解。

如果你想更个性化地配置`Checkstyle`，请参考这篇[文档](http://www.gradle.org/docs/current/dsl/org.gradle.api.plugins.quality.Checkstyle.html)。

## Checkstyle使用技巧

`Checkstyle`会探测到大量问题，尤其当你使用了很多规则--比如你想要一个精确的语法。虽然我通过`Gradle`脚本来使用`Checkstyle`(比如在我push代码之前)，但我建议你同时使用`Checkstyle`的IntellJ/Android Studio插件(你能直接通过工具栏File/Settings/Plugins安装它们。译者注:mac版是Android Studio/Preferences/Plugins)。这种方式也是根据你之前为Gradle指定的那两个配置文件在你的项目中应用`Checkstyle`。这样的好处是能直接在Android Studio中查看结果。更实用的是，结果可以直接链接到错误所在代码(`Gradle`的那种方式仍然很重要，因为你能通过`Jenkins`这样的自动化构建系统来使用它)。

# FindBugs

[![](http://findbugs.sourceforge.net/umdFindbugs.png)](http://findbugs.sourceforge.net/)

## 简介

`Findbugs` 需要简介吗？它的名字已经说明了一切。
>Findbugs 通过静态分析来检查Java字节码中的错误模式。

`Findbugs` 基本上只需要项目的字节码文件来做分析，因此它十分易用。它会检测出诸如错误使用布尔运算符这样常见的错误。同时，它还能检测出一些由于误解语言特性所导致的错误，比如Java中方法参数的重新赋值(实际上是无效的，因为Java中方法的参数是值传递)。

## 通过Gradle配置

以下代码展示了在你项目中使用`Findbugs`的基本配置(作为一个`Gradle`任务)：

```Gradle
task findbugs(type: FindBugs) {
    ignoreFailures = false
    effort = "max"
    reportLevel = "high"
    excludeFilter = new File("${project.rootDir}/config/quality/findbugs/findbugs-filter.xml")
    classes = files("${project.rootDir}/app/build/classes")

    source 'src'
    include '**/*.java'
    exclude '**/gen/**'

    reports {
    xml.enabled = false
    html.enabled = true
    xml {
    destination "$project.buildDir/reports/findbugs/findbugs.xml"
    }
    html {
    destination "$project.buildDir/reports/findbugs/findbugs.html"
    }
    }

    classpath = files()
}
```
这和`Checkstyle`的任务很像。`Findbugs`支持`HTML`和`XML`格式的报告，我选择了`HTML`，因为其可读性更强。除此以外，你只需要标记一下报告的路径来快速读取它。如果Findbugs中的错误被检测到，任务会失败(仍然产生报告)。执行`Findbugs`的方式和`Checkstyle`完全一样(只是名字变成了"Findbugs")。

## Findbugs使用技巧

由于Android项目与Java项目有轻微不同，我强烈建议大家使用`findbugs-filter`。例子[点这里](https://github.com/vincentbrison/vb-android-app-quality/blob/demo/config/quality/findbugs/findbugs-filter.xml)(示例项目的其中之一)。它一般会忽略掉R文件和清单文件。另外，由于`Findbugs`是分析你的字节码，你至少需要编译一次项目来测试它。


# PMD

[![](http://pmd.sourceforge.net/pmd_logo.png)](http://pmd.sourceforge.net/)

## 简介

这个工具十分有趣：`PMD`并没有一个真正的名字。在官方网站上你会发现一些有趣的命名建议：

*   Pretty Much Done
*   Project Meets Deadline

实际上，`PMD`是一个非常强大的工具。它的工作方式有点像`Findbugs`，但它直接检查源码而非字节码(另外，PMD支持大量语言)。目标也和`Findbugs`高度相似--通过静态分析找出能导致bug的模式。那么为什么我们还要同时使用`Findbugs`和`PMD`呢？好吧，尽管`Findbugs`和`PMD`的目标一致，但它们的检查方法并不同。因此`PMD`有时可以找到`Findbugs`找不到的bug，反过来也一样。

## 通过Gradle配置

以下代码展示了在你项目中使用`PMD`的基本配置(作为一个`Gradle`任务)：

```Gradle
task pmd(type: Pmd) {
    ruleSetFiles = files("${project.rootDir}/config/quality/pmd/pmd-ruleset.xml")
    ignoreFailures = false
    ruleSets = []

    source 'src'
    include '**/*.java'
    exclude '**/gen/**'

    reports {
        xml.enabled = false
        html.enabled = true
        xml {
            destination "$project.buildDir/reports/pmd/pmd.xml"
        }
        html {
            destination "$project.buildDir/reports/pmd/pmd.html"
        }
    }
}
```

`PMD`的结果同样与`Findbugs`有许多相同之处。`PMD`的报告同样支持`HTML`和`XML`,因此我再次选择了`HTML`的格式。我强烈建议使用你自己的自定义规则集文件，就像我在例子中做的这样([参照这个文件](https://github.com/vincentbrison/vb-android-app-quality/blob/master/config/quality/pmd/pmd-ruleset.xml))。当然，你还需要看一下[自定义规则集的文档](http://pmd.sourceforge.net/pmd-5.1.1/howtomakearuleset.html)。我这么建议是因为`PMD`相比`Findbugs`而言更具争议。比如，如果你没有折叠if条件语句或写了一个空的if条件语句，它一般就会警告你。我认为应该由你或你的同事为你们的项目来定义这些规则是否正确。像我自己就喜欢不折叠if条件语句，因为这样更具可读性。执行`PMD`的方式和`Checkstyle`完全一样(只是名字变成了"PMD")。

## PMD使用技巧

由于我推荐你不要使用默认的规则集，你需要加上这行代码(上面已经加上了)
```
ruleSets = []
```

不加的话，由于默认值是基本的规则集，那些默认的规则集会始终伴随你自定义的规则集一起执行。这样即使你在自定义的规则集中指明不使用基础规则集中的规则，它们仍然会被考虑在内。

# Android Lint

## 简介
>Android lint 工具是一个静态代码分析工具。它通过你Android项目的源码检测出潜在的错误，并为项目在正确性，安全性，性能，可用性，
易用性和国际化等方面提供最佳的改进方案。

正如其官网所说，`Android Lint`是一款专注于Android的静态分析工具。它非常强大，能给出大量建议来提高你代码的质量。

## 通过Gradle配置

```Gradle
android {
    lintOptions {
    abortOnError true

    lintConfig file("${project.rootDir}/config/quality/lint/lint.xml")

    // if true, generate an HTML report (with issue explanations, sourcecode, etc)
    htmlReport true
    // optional path to report (default will be lint-results.html in the builddir)
    htmlOutput file("$project.buildDir/reports/lint/lint.html")
}
```

我推荐你使用一个单独的文件来定义哪些规则应该使用。[这个网站](http://tools.android.com/tips/lint-checks)定义了所有来自最新ADT版本的规则。除了"ignore"中"severity"级别的规则外，我的demo中的`Lint`文件包含了所有规则：

* IconDensities：这个规则确保你为每一种分辨率都设置了对应的图片资源(除ldpi外)。
* IconDipSize：这个规则确保你正确地定义了资源的每种尺寸。(换句话说，检查你是否为不同分辨率定义了完全相同的图片，而没有重新设置图片大小)。

所以你能直接复用这份`lint`文件并激活所有你想要的规则。执行`Android Lint`任务的方式和`Checkstyle`完全一样(只是名字变成了"lint")。

## Android Lint使用技巧

`Android Lint`没有什么特殊的使用技巧，你只需要记住，`Android Lint`总是会测试除"ignore"中"severity"级别的规则外的所有规则。所以如果随着ADT的新版本出现了新的规则，它们会被检查，而不会被忽略。

# 通过一个任务管理以上所有工具

现在你已经掌握了为你项目使用4个质量控制工具的关键。但如果你能同时使用4个工具就更好了。你能在你的Gradle任务之间添加依赖，比如当你执行一个任务时，另外一个会在第一个任务完成后执行。一般在Gradle中，你通过"check"任务为你的质量工具添加依赖：

```Gradle
check.dependsOn 'checkstyle', 'findbugs', 'pmd', 'lint'
```
现在，当你执行"check"任务，`Checkstyle`， `Findbugs`， `PMD`， 和`Android Lint` 都会被执行。这是一个非常好的方式来在你commit/push/请求合并之前检查代码质量。

你能在[这个Gradle文件](https://github.com/vincentbrison/vb-android-app-quality/blob/master/config/quality.gradle)中获得所有这些任务的示例。你能在demo源码的`config/quality`文件夹中找到所有关于质量控制的配置和gradle文件。

# 总结

正如这篇文章介绍的，Android的质量控制工具配合`Gradle`使用非常简单。质量控制工具不仅仅能检查你电脑中的本地项目，还能检查一些自动化构建平台上的代码，比如Jenkins/Hudson等。这使你能将质量控制的工作依附于自动构建系统，实现自动化。执行所有测试的命令与执行Jenkins和Hudson相同，最简单的命令是：

```Gradle
gradle check
```

请自由评论这篇文章，或者咨询任何与Android代码质量相关的问题！[😉](http://s.w.org/images/core/emoji/72x72/1f609.png)

快去实践吧！
