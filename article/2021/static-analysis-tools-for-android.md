> * 原文地址：[Static analysis tools for Android](https://proandroiddev.com/static-analysis-tools-for-android-9531334954f6)
> * 原文作者：[Cristopher Oyarzun](https://medium.com/@coyarzun)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/static-analysis-tools-for-android.md](https://github.com/xitu/gold-miner/blob/master/article/2021/static-analysis-tools-for-android.md)
> * 译者：[Kimhooo](https://github.com/Kimhooo)
> * 校对者：

# Android 静态分析工具

![Photo by [Zach Vessels](https://unsplash.com/@zvessels55?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/static?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/8966/1*rnX0nlbNDAkelzWjpkFHhA.jpeg)

让我们看看最流行的静态代码分析工具可以做什么，您可以使用这些工具在代码库中实现和实施自定义规则。使用 Lint 工具有很多好处，包括：以编程方式实施标准，自动化代码质量和代码维护。

在 Android Studio 中，您可能对这些消息很熟悉。

![](https://cdn-images-1.medium.com/max/2704/1*ToPnjqZ_4pONDNRAbb86PA.png)

您可以使用以下工具编写自己的规则：

* [Android Lint API](https://developer.android.com/studio/write/lint)
* [ktlint](https://github.com/pinterest/ktlint)
* [detekt](https://github.com/detekt/detekt)

我们将一步一步地描述在演示项目上编写一些规则的过程，您可以在[这里](https://github.com/coyarzun89/custom-lint-rules)找到这些规则。

## 使用 Android Lint API 的自定义规则

首先，我们将使用 Android Lint API 编写规则。这样做的优点包括：

* 您可以为 Java、Kotlin、Gradle、XML 和其他一些文件类型编写规则。
* 无需添加插件就可以在 Android Studio 上看到警告或者错误。
* 更简单地集成到项目中。

缺点之一是在他们的存储库中有这个脚注 [https://github.com/googlesamples/android-custom-lint-rules](https://github.com/googlesamples/android-custom-lint-rules)

> lint API 不是一个最终版本的API；如果您依赖于它，请做好准备为下一个工具版本调整代码。

那么，下面是创建第一条规则的步骤：

1. 在项目中创建自定义规则所在的新模块。我们将此模块称为 **android-lint-rules**。
2. 将该模块上的 **build.gradle** 文件修改为如下内容。

```Gradle
apply plugin: 'kotlin'
apply plugin: 'com.android.lint'


dependencies {
    compileOnly "com.android.tools.lint:lint-api:$lintVersion"

    testImplementation "com.android.tools.lint:lint:$lintVersion"
    testImplementation "com.android.tools.lint:lint-tests:$lintVersion"
}

jar {
    manifest {
        attributes("Lint-Registry-v2": "dev.cristopher.lint.DefaultIssueRegistry")
    }
}
```

在这里，我们以 **compileOnly** 的形式导入依赖项，它将允许我们编写自定义规则 **com.android.tools.lint:lint-api**。您同时需要注意我用的是 **lint-api:27.2.0** 的版本, 这是一个 **beta** 版本。

这里我们还指定 **Lint-Registry-v2**，它将指向包含规则列表的类。

3. 首先编写第一条规则，避免在我们的布局文件中使用硬编码的颜色。

```Kotlin
@Suppress("UnstableApiUsage")
class HardcodedColorXmlDetector : ResourceXmlDetector() {

    companion object {
        val REGEX_HEX_COLOR = "#[a-fA-F\\d]{3,8}".toRegex()

        val ISSUE = Issue.create(
            id = "HardcodedColorXml",
            briefDescription = "禁止在 XML 布局文件中使用硬编码颜色",
            explanation = "硬编码颜色应声明为 '<color>' 资源",
            category = Category.CORRECTNESS,
            severity = Severity.ERROR,
            implementation = Implementation(
                HardcodedColorXmlDetector::class.java,
                Scope.RESOURCE_FILE_SCOPE
            )
        )
    }

    override fun getApplicableAttributes(): Collection<String>? {
        // Return the set of attribute names we want to analyze. The `visitAttribute` method
        // below will be called each time lint sees one of these attributes in a
        // XML resource file. In this case, we want to analyze every attribute
        // in every XML resource file.
        return XmlScannerConstants.ALL
    }

    override fun visitAttribute(context: XmlContext, attribute: Attr) {
        // 获取 XML 属性的值。
        val attributeValue = attribute.nodeValue
        if (attributeValue.matches(REGEX_HEX_COLOR)) {
            context.report(
                issue = ISSUE,
                scope = attribute,
                location = context.getValueLocation(attribute),
                message = "硬编码颜色的十六进制值应该 '<color>' 资源中声明"
            )
        }
    }
}
```

根据我们要实现的规则，我们将从不同的 **Detector** 类进行扩展。探测器能够发现特定的问题。每个问题类型都被唯一地标识为 **Issue**。在本例中，我们将使用 **ResourceXmlDetector**，因为我们要检查每个 XML 资源中的硬编码十六进制颜色。

在类声明之后，我们创建定义 **Issue** 所需的所有信息。在这里，我们可以指定类别和严重性，以及在触发规则时将在IDE中显示的解释。

然后我们需要指定要扫描的属性。我们可以返回一个特定的属性列表，如 **mutableListOf（“textColor”，“background”）** 或返回 **XmlScannerConstants.ALL** 来扫描每个布局上的所有属性。这将取决于您的用例。

最后，我们必须添加确定该属性是否为十六进制颜色所需的逻辑，以便生成报告。

4. 创建一个名为 **DefaultIssuereRegistry** 的类，该类扩展了 **IssuereRegistry**。然后需要重写 **issues** 变量并列出所有这些变量。

如果要创建更多规则，需要在此处添加所有规则。

```Kotlin
class DefaultIssueRegistry : IssueRegistry() {
    override val issues = listOf(
        HardcodedHexColorXmlDetector.ISSUE
    )

    override val api: Int
        get() = CURRENT_API
}

```

5. 为了检查规则是否正确执行了它们的工作，我们将实施一些测试。我们需要在 **build.gradle** 上有这两个依赖项作为 **testImplementation**:**com.android.tools.lint:lint-tests** 和 **com.android.tools.lint:lint**。这将允许我们在代码中定义一个 XML 文件，并扫描其内容，以查看规则是否正常工作。

1. 如果使用自定义属性，第一个测试检查规则是否仍然有效。因此 TextView 将包含一个名为 **someCustomColor** 的属性，其颜色为 **#fff**。然后，我们可以添加几个问题来扫描模拟文件，在我们的示例中，我们只指定我们唯一编写的规则。最后我们说，预期结果应该是 1 个错误严重性问题。
2. 在第二个测试中，行为非常相似。唯一的变化是我们正在用一个普通属性测试我们的规则，十六进制颜色包括 alpha 透明度。
3. 在上一个测试中，如果我们使用我们的资源指定颜色，我们检查规则是否没有引发任何错误。在这种情况下，我们使用 **@color/primaryColor** 设置文本颜色，预期的结果是完整的执行。

```Kotlin
class HardcodedColorXmlDetectorTest {

    @Test
    fun `Given a hardcoded color on a custom text view property, When we analyze our custom rule, Then display an error`() {
        lint()
            .files(
                xml(
                    "res/layout/layout.xml",
                    """
                    <TextView xmlns:app="http://schemas.android.com/apk/res-auto"
                    app:someCustomColor="#fff"/>
                    """
                ).indented()
            )
            .issues(HardcodedColorXmlDetector.ISSUE)
            .allowMissingSdk()
            .run()
            .expectCount(1, Severity.ERROR)
    }

    @Test
    fun `Given a hardcoded color on a text view, When we analyze our custom rule, Then display an error`() {
        lint()
            .files(
                xml(
                    "res/layout/layout.xml",
                    """
                        <TextView xmlns:android="http://schemas.android.com/apk/res/android"
                            android:textColor="#80000000"/>
                        """
                ).indented()
            )
            .issues(HardcodedColorXmlDetector.ISSUE)
            .allowMissingSdk()
            .run()
            .expectCount(1, Severity.ERROR)
    }

    @Test
    fun `Given a color from our resources on a text view, When we analyze our custom rule, Then expect no errors`() {
        lint()
            .files(
                xml(
                    "res/layout/layout.xml",
                    """
                        <TextView xmlns:android="http://schemas.android.com/apk/res/android"
                            android:textColor="@color/primaryColor"/>
                        """
                ).indented()
            )
            .issues(HardcodedColorXmlDetector.ISSUE)
            .allowMissingSdk()
            .run()
            .expectClean()
    }
}

```

6. 现在在 **app module** 中，我们要应用所有这些规则，我们要将这一行添加到 **build.gradle** 文件中：

```
dependencies {
       lintChecks project(':android-lint-rules')
    ....
}
```

就这样！如果我们试图在任何布局中设置硬编码颜色，将提示错误🎉

![](https://cdn-images-1.medium.com/max/3200/1*VeAC6BcQlTP0dm7WKOhajw.png)

This repository can be a good source if you need more ideas to add some custom rules [https://github.com/vanniktech/lint-rules](https://github.com/vanniktech/lint-rules)

## Custom rules with ktlint

ktlint define itself as an anti-bikeshedding Kotlin linter with built-in formatter. One of the coolest things is that you can write your rules along with a way to autocorrect the issue, so the user can easily fix the problem. One of the disadvantages is that it’s specifically for Kotlin, so you can’t write rules for XML files, as we previously did. Also if you want to visualize the issues on Android Studio, you need to install a plugin. I’m using this one [https://plugins.jetbrains.com/plugin/15057-ktlint-unofficial-](https://plugins.jetbrains.com/plugin/15057-ktlint-unofficial-)

So, in this case we’re going to enforce a rule about Clean Architecture. Probably, you have heard that we shouldn’t expose our models from the data layer in our domain or presentation layers. Some people add a prefix on each model from the data layer to make them easy to identify. In this case we want to check that every model which is part of a package ended on **data.dto** should have a prefix **Data** in their name.

These are the steps to write a rule using ktlint:

1. Create a new module where your custom rules will live in. We’ll call this module **ktlint-rules**
2. Modify the **build.gradle** file on that module:

```Gradle
plugins {
    id 'kotlin'
}

dependencies {
    compileOnly "com.github.shyiko.ktlint:ktlint-core:$ktlintVersion"

    testImplementation "junit:junit:$junitVersion"
    testImplementation "org.assertj:assertj-core:$assertjVersion"
    testImplementation "com.github.shyiko.ktlint:ktlint-core:$ktlintVersion"
    testImplementation "com.github.shyiko.ktlint:ktlint-test:$ktlintVersion"
}
```

3. Write a rule to enforce the use of a prefix (**Data**) in all the models inside a package name ending on **data.dto.**

First we need to extend the **Rule** class that ktlint provide for us and specify an id for your rule.

Then we override the **visit** function. Here we’re going to set some conditions to detect that the package ends with **data.dto** and verify if the classes inside that file has the prefix **Data**. If the classes doesn’t have that prefix, then we’re going to use the emit lambda to trigger the report and we’ll also offer a way to fix the problem.

```Kotlin
class PrefixDataOnDtoModelsRule : Rule("prefix-data-on-dto-model") {

    companion object {
        const val DATA_PREFIX = "Data"
        const val IMPORT_DTO = "data.dto"
    }

    override fun visit(
        node: ASTNode,
        autoCorrect: Boolean,
        emit: (offset: Int, errorMessage: String, canBeAutoCorrected: Boolean) -> Unit
    ) {
        if (node.elementType == ElementType.PACKAGE_DIRECTIVE) {
            val qualifiedName = (node.psi as KtPackageDirective).qualifiedName
            if (qualifiedName.isEmpty()) {
                return
            }

            if (qualifiedName.endsWith(IMPORT_DTO)) {
                node.treeParent.children().forEach {
                    checkClassesWithoutDataPrefix(it, autoCorrect, emit)
                }
            }
        }
    }

    private fun checkClassesWithoutDataPrefix(
        node: ASTNode,
        autoCorrect: Boolean,
        emit: (offset: Int, errorMessage: String, canBeAutoCorrected: Boolean) -> Unit
    ) {
        if (node.elementType == ElementType.CLASS) {
            val klass = node.psi as KtClass
            if (klass.name?.startsWith(DATA_PREFIX, ignoreCase = true) != true) {
                emit(
                    node.startOffset,
                    "'${klass.name}' class is not using " +
                        "the prefix Data. Classes inside any 'data.dto' package should " +
                        "use that prefix",
                    true
                )
                if (autoCorrect) {
                    klass.setName("$DATA_PREFIX${klass.name}")
                }
            }
        }
    }
}

```

4. Create a class called **CustomRuleSetProvider** that extends **RuleSetProvider.** Then you need to override the **get()** function and list all your rules there.

```Kotlin
class CustomRuleSetProvider : RuleSetProvider {
    private val ruleSetId: String = "custom-ktlint-rules"

    override fun get() = RuleSet(ruleSetId, PrefixDataOnDtoModelsRule())
}

```

5. Create a file in the folder **resources/META-INF/services**. This file must contain the path to the class created on the step 4.

![](https://cdn-images-1.medium.com/max/6592/1*Des3IkNn0cqX_uSBHNSTgg.png)

6. Now in our project we’re going to add this module, so the rules can be applied. Also we created a task to execute ktlint and generate a report:

```
configurations {
    ktlint
}

dependencies {
    ktlint "com.github.shyiko:ktlint:$ktlintVersion"
    ktlint project(":ktlint-rules")
    ...
}

task ktlint(type: JavaExec, group: "verification", description: "Runs ktlint.") {
    def outputDir = "${project.buildDir}/reports/ktlint/"

    main = "com.github.shyiko.ktlint.Main"
    classpath = configurations.ktlint
    args = [
            "--reporter=plain",
            "--reporter=checkstyle,output=${outputDir}ktlint-checkstyle-report.xml",
            "src/**/*.kt"
    ]

    inputs.files(
            fileTree(dir: "src", include: "**/*.kt"),
            fileTree(dir: ".", include: "**/.editorconfig")
    )
    outputs.dir(outputDir)
}
```

7. I also highly recommend to install this plugin so you can be notified in the same Android Studio about any errors found.

![](https://cdn-images-1.medium.com/max/4436/1*bzBNZqnlPF4WR7k-zH6eiA.png)

To see your custom rules in Android Studio you need to generate a jar from your module and add that path in the external rulset JARs like this:

![](https://cdn-images-1.medium.com/max/4436/1*GSevjiWQufDEf3cmZMvtLg.png)

## Custom rules with detekt

detekt is a static code analysis tool for the **Kotlin** programming language. It operates on the abstract syntax tree provided by the Kotlin compiler. Their focus is find code smells, although you can also use it as a formatting tool.

If you want to visualize the issues on Android Studio, you need to install a plugin. I’m using this one [https://plugins.jetbrains.com/plugin/10761-detekt](https://plugins.jetbrains.com/plugin/10761-detekt)

The rule that we’re going to implement will enforce the use of a specific prefix for the Repository implementations. It’s just to show that we can create a custom standard in our project. In this case if we have a **ProductRepository** interface, we want that the implementation use the prefix **Default** instead of the suffix **Impl.**

The steps to write a rule using detekt are:

1. Create a new module where your custom rules will live in. We’ll call this module **detekt-rules**
2. Modify the **build.gradle** file on that module:

```Gradle
plugins {
    id 'kotlin'
}

dependencies {
    compileOnly "io.gitlab.arturbosch.detekt:detekt-api:$detektVersion"

    testImplementation "junit:junit:$junitVersion"
    testImplementation "org.assertj:assertj-core:$assertjVersion"
    testImplementation "io.gitlab.arturbosch.detekt:detekt-api:$detektVersion"
    testImplementation "io.gitlab.arturbosch.detekt:detekt-test:$detektVersion"
}

```

3. Write a rule to enforce the use of a prefix (**Default**) in all the repository implementations.

First we need to extend the **Rule** class that detekt provide for us. Also we need to override the issue class member and specify name, type of issue, description and how much time it requires to solve the problem.

Then we override the **visitClassOrObject** function. Here we check for each implementation of each class. If some of these ends in the keyword **Repository**, then we’re going to verify if the class name doesn’t start with our prefix. Inside that condition we will report the problem as a **CodeSmell.**

```Kotlin
class PrefixDefaultOnRepositoryRule(config: Config = Config.empty) : Rule(config) {

    companion object {
        const val PREFIX_REPOSITORY = "Default"
        const val REPOSITORY_KEYWORD = "Repository"
    }
    override val issue: Issue = Issue(
        javaClass.simpleName,
        Severity.Style,
        "Use the prefix Default on every 'XXXRepository' implementations.",
        Debt.FIVE_MINS
    )

    override fun visitClassOrObject(classOrObject: KtClassOrObject) {
        for (superEntry in classOrObject.superTypeListEntries) {
            if (superEntry.text.endsWith(REPOSITORY_KEYWORD) &&
                classOrObject.name?.contains(REPOSITORY_KEYWORD) == true &&
                classOrObject.name?.startsWith(PREFIX_REPOSITORY) == false
            ) {
                report(
                    classOrObject,
                    "The repository implementation '${classOrObject.name}' needs to start with the prefix 'Default'."
                )
            }
        }
    }

    private fun report(classOrObject: KtClassOrObject, message: String) {
        report(CodeSmell(issue, Entity.atName(classOrObject), message))
    }
}

```

The next steps are pretty similar to the ones on ktlint.

4. Create a class called **CustomRuleSetProvider** that extends **RuleSetProvider.** Then you need to override the **ruleSetId()** and the **instance(config: Config)** functions and list all your rules there.

```Kotlin
class CustomRuleSetProvider : RuleSetProvider {

    override val ruleSetId: String = "custom-detekt-rules"

    override fun instance(config: Config) =
        RuleSet(ruleSetId, listOf(PrefixDefaultOnRepositoryRule(config)))
}
```

5. Create a file in the folder **resources/META-INF/services**. This file must contain the path to the class created on the step 4.

![](https://cdn-images-1.medium.com/max/6592/1*Des3IkNn0cqX_uSBHNSTgg.png)

6. Now in our project we’re going to add this module, so the rules can be applied. To use detekt in your project you also need to a yaml style configuration file. You can get the default configuration from the same detekt repository [here](https://github.com/detekt/detekt/blob/main/detekt-core/src/main/resources/default-detekt-config.yml).

```
detekt {
    input = files("$rootDir/app/src")
    config = files("$rootDir/app/config/detekt.yml")
}

dependencies {
    detektPlugins "io.gitlab.arturbosch.detekt:detekt-cli:$detektVersion"
    
    detektPlugins project(path: ':detekt-rules')
    ...
}
```

7. I also highly recommend to install this plugin so you can be notified in the same Android Studio about any errors found.

![](https://cdn-images-1.medium.com/max/4436/1*bzBNZqnlPF4WR7k-zH6eiA.png)

To see your custom rules in Android Studio you need to generate a jar from your module and add that path in the external rulset JARs like this:

![](https://cdn-images-1.medium.com/max/4436/1*ixNVSRgIr996lB8YtIob1w.png)

And that’s it! Now you can see your custom rule applied 🎉

![](https://cdn-images-1.medium.com/max/4288/1*jSPXuDQnZRVwFBNqRqG_eA.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
