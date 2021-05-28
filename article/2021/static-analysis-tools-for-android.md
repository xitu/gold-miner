> * 原文地址：[Static analysis tools for Android](https://proandroiddev.com/static-analysis-tools-for-android-9531334954f6)
> * 原文作者：[Cristopher Oyarzun](https://medium.com/@coyarzun)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/static-analysis-tools-for-android.md](https://github.com/xitu/gold-miner/blob/master/article/2021/static-analysis-tools-for-android.md)
> * 译者：[Kimhooo](https://github.com/Kimhooo)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)，[PingHGao](https://github.com/PingHGao)

# Android 静态分析工具

![图源 [Zach Vessels](https://unsplash.com/@zvessels55?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)，出自 [Unsplash](https://unsplash.com/s/photos/static?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/8966/1*rnX0nlbNDAkelzWjpkFHhA.jpeg)

让我们来了解一下最流行的静态代码分析工具，借助这些工具您可以在代码库中实现和执行自定义规则。使用 Lint 工具有很多好处，包括：以编程方式执行规范，自动化代码质量和代码维护。

在 Android Studio 中，您可能对这些消息很熟悉：

![](https://cdn-images-1.medium.com/max/2704/1*ToPnjqZ_4pONDNRAbb86PA.png)

您可以使用以下工具编写自己的规则：

* [Android Lint API](https://developer.android.com/studio/write/lint)
* [ktlint](https://github.com/pinterest/ktlint)
* [detekt](https://github.com/detekt/detekt)

我们将一步一步地描述在演示项目上编写一些规则的过程，您可以在[这里](https://github.com/coyarzun89/custom-lint-rules)找到这些规则。

## 使用 Android Lint API 的自定义规则

首先，我们将使用 Android Lint API 编写规则。这样做的优点包括：

* 您可以为 Java、Kotlin、Gradle、XML 和其他一些文件类型编写规则。
* 无需添加插件就可以在 Android Studio 上看到警告或者错误提示。
* 更容易地集成到项目中。

缺点之一是在他们的 [GitHub 仓库](https://github.com/googlesamples/android-custom-lint-rules)中有下面这个脚注：

> lint API 不是一个最终版本的 API；如果您依赖于它，请做好为下一个工具版本调整代码的准备。

那么，下面是创建第一条规则的步骤：

1. 在项目中创建自定义规则所在的新模块。我们将此模块命名为为 `android-lint-rules`。
2. 将该模块上的 **build.gradle** 文件修改为如下内容：

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

在这里，我们以 `compileOnly` 的形式导入依赖项，它将允许我们编写自定义规则 `com.android.tools.lint:lint-api`。您同时需要注意我用的是 `lint-api:27.2.0` 版本（一个 **beta** 版本）。

这里我们还指定了 `Lint-Registry-v2`，用于指向包含规则列表的类。

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
        // 该方法返回要分析的属性名称集。
        // 每当 lint 工具在 XML 资源文件中看到这些属性之一时
        // 就会调用下面的 `visitAttribute` 方法。
        // 在本例中，我们希望分析每个 XML 资源文件中的每个属性。
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
                message = "硬编码颜色的十六进制值应该在 '<color>' 资源中声明"
            )
        }
    }
}
```

根据我们要实现的规则，我们将扩展不同的 `Detector` 类。一个 `Detector` 类能够发现特定的问题。每个问题类型都被唯一地标识为 `Issue`。在本例中，我们将使用 `ResourceXmlDetector`，因为我们要检查每个 XML 资源中的硬编码颜色的十六进制值。

在类声明之后，我们创建定义 `Issue` 所需的所有信息。在这里，我们可以指定类别和严重性，以及在触发规则时将在集成开发环境（IDE）中显示的解释。

然后我们需要指定要扫描的属性。我们可以返回一个特定的属性列表，如 `mutableListOf("textColor"，"background")` 或返回 `XmlScannerConstants.ALL` 来扫描每个布局上的所有属性。这将取决于您的用例。

最后，我们必须添加确定该属性是否为十六进制颜色所需的逻辑，以便生成报告。

4. 创建一个名为 `DefaultIssuereRegistry` 的扩展了 `IssuereRegistry` 的类。然后需要重写 `issues` 变量并列出所有这些变量。

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

5. 为了检查规则是否正确执行了它们的工作，我们将实施一些测试。我们需要在 **build.gradle** 上有这两个依赖项作为 `testImplementation: com.android.tools.lint:lint-tests` 和 `com.android.tools.lint:lint`。这将允许我们在代码中定义一个 XML 文件，并扫描其内容，以查看规则是否正常工作。

1. 如果使用自定义属性，第一个测试检查规则是否仍然有效。因此 TextView 将包含一个名为 `someCustomColor` 的属性，其颜色为 `#fff`。然后，我们可以添加几个问题来扫描模拟文件，在我们的示例中，我们只指定我们唯一编写的规则。最后我们说，预期结果应该是 1 个严重程度为错误的问题。
2. 在第二个测试中，行为非常相似。唯一的变化是我们正在用一个普通属性测试我们的规则，十六进制颜色包括 alpha 透明度。
3. 在上一个测试中，如果我们使用我们的资源指定颜色，我们检查规则是否没有引发任何错误。在这种情况下，我们使用 `@color/primaryColor` 设置文本颜色，预期的结果是干净利落的执行。

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

就这样！如果我们试图在任何布局中设置硬编码颜色，就会立马提示错误 🎉

![](https://cdn-images-1.medium.com/max/3200/1*VeAC6BcQlTP0dm7WKOhajw.png)

如果您需要更多的想法来添加一些自定义规则，那么这个仓库是一份很好的学习资料：[https://github.com/vanniktech/lint-rules](https://github.com/vanniktech/lint-rules)

## 使用 ktlint 自定义规则

ktlint 将自己定义为一个反繁琐的具有内置格式化的 Kotlin Lint 工具。最酷的事情之一是，你可以编写你的规则以及一种方法来自动更正问题，所以用户可以很容易地解决问题。缺点之一是它是专门为 Kotlin 语言编写的，因此不能像我们之前所做的那样为 XML 资源文件编写规则。另外，如果你想在 Android Studio 上可视化产生的问题，你需要安装一个插件。我用的是这个插件： [https://plugins.jetbrains.com/plugin/15057-ktlint-unofficial-](https://plugins.jetbrains.com/plugin/15057-ktlint-unofficial-)

所以，在这种情况下，我们要执行一个关于 Clean 架构的规则。您可能听说过，我们不应该从域或表示层的数据层公开模型。有些人在数据层的每个模型上添加前缀，以便于识别。在本例中，我们要检查以 **data.dto** 结尾的包的每个模型的名称中都应该有一个前缀 **data**。

以下是使用 ktlint 编写规则的步骤：

1. 创建自定义规则所在的新模块。我们将此模块称为 `ktlint-rules`。
2. 修改该模块上的 **build.gradle** 文件：

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

3. 编写一个规则，强制在以 **data.dto** 结尾的包名内的所有模型中使用前缀（`Data`）。

首先，我们需要扩展 ktlint 为我们提供的 `Rule` 类，并为您的规则指定一个 id。

然后我们重写 `visit` 函数。这里我们将设置一些条件来检测包是否以 **data.dto** 结尾，并验证该文件中的类是否具有前缀 **data**。如果类没有这个前缀，那么我们将使用 emit lambda 来触发报告，我们还将提供一种解决问题的方法。

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

4. 创建一个名为 `CustomRuleshiyongSetProvider` 的类，该类扩展 `RuleSetProvider`，然后需要重写 `get()` 函数并在其中列出所有规则。

```Kotlin
class CustomRuleSetProvider : RuleSetProvider {
    private val ruleSetId: String = "custom-ktlint-rules"

    override fun get() = RuleSet(ruleSetId, PrefixDataOnDtoModelsRule())
}

```

5. 在 **resources/META-INF/services** 文件夹中创建一个文件。此文件必须包含在步骤 4 中创建的类的路径。

![](https://cdn-images-1.medium.com/max/6592/1*Des3IkNn0cqX_uSBHNSTgg.png)

6. 现在在我们的项目中，我们将添加这个模块，以便可以应用规则。我们还创建了一个任务来执行 ktlint 并生成一个报告：

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

7. 我同样强烈建议您安装这个插件，这样您就可以在同一个 Android Studio 工程中得到任何有关错误的通知。

![](https://cdn-images-1.medium.com/max/4436/1*bzBNZqnlPF4WR7k-zH6eiA.png)

要在 Android Studio 中查看您的自定义规则，您需要从模块中生成一个 jar，并将该路径添加到外部 rulset JARs 中，如下所示：

![](https://cdn-images-1.medium.com/max/4436/1*GSevjiWQufDEf3cmZMvtLg.png)

## 使用 detekt 自定义规则

detekt 是 **Kotlin** 编程语言的静态代码分析工具。它对 Kotlin 编译器提供的抽象语法树进行操作。它们的重点是查找代码异味，尽管您也可以将其用作格式化工具。

如果你想在 Android Studio 上可视化这些问题，你需要安装一个插件。我在用这个：[https://plugins.jetbrains.com/plugin/10761-detekt](https://plugins.jetbrains.com/plugin/10761-detekt)

我们将要实现的规则将强制为仓库实现使用特定的前缀。这只是为了说明我们可以在项目中创建自定义标准。在这种情况下，如果我们有一个 `ProductRepository` 接口，我们希望实现使用前缀 `Default` 而不是后缀 `Impl`。

使用 detekt 编写规则的步骤如下：

1. 创建自定义规则所在的新模块。我们将此模块称为 `detekt-rules`。
2. 修改该模块上的 **build.gradle** 文件：

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

3. 编写规则以强制在所有仓库实现中使用前缀（`Default`）。

首先，我们需要扩展 detekt 为我们提供的 `Rule` 类。我们还需要重写 `issue` 类成员，并指定名称、问题类型、描述以及解决问题所需的时间。

然后重写 `visitClassOrObject` 函数。这里我们检查每个类的每个实现。如果其中一些以关键字 **Repository** 结尾，那么我们将验证类名是否以前缀开头。在这种情况下，我们将把问题称为**代码的坏味道**。

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

接下来的步骤与 ktlint 中的步骤非常相似。

4. 创建一个名为 `CustomRuleSetProvider` 扩展了 `RuleSetProvider` 的类。然后需要重写 `ruleSetId()` 和 `instance(config: config)` 函数，并在其中列出所有规则。

```Kotlin
class CustomRuleSetProvider : RuleSetProvider {

    override val ruleSetId: String = "custom-detekt-rules"

    override fun instance(config: Config) =
        RuleSet(ruleSetId, listOf(PrefixDefaultOnRepositoryRule(config)))
}
```

5. 在 **resources/META-INF/services** 文件夹中创建一个文件。此文件必须包含在步骤 4 中创建的类的路径。

![](https://cdn-images-1.medium.com/max/6592/1*Des3IkNn0cqX_uSBHNSTgg.png)

6. 现在在我们的项目中，我们将添加这个模块，以便可以应用规则。要在项目中使用 detekt，还需要一个 yaml 样式的配置文件。您可以从同一个 detekt 仓库获取默认配置，[点击此处](https://github.com/detekt/detekt/blob/main/detekt-core/src/main/resources/default-detekt-config.yml)。

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

7. 我同样强烈建议您安装这个插件，这样您就可以在同一个 Android Studio 工程中得到任何有关错误的通知。

![](https://cdn-images-1.medium.com/max/4436/1*bzBNZqnlPF4WR7k-zH6eiA.png)

要在 Android Studio 中查看您的自定义规则，您需要从模块中生成一个 jar，并将该路径添加到外部 rulset JARs 中，如下所示：

![](https://cdn-images-1.medium.com/max/4436/1*ixNVSRgIr996lB8YtIob1w.png)

就这样！现在您可以看到您的自定义规则已经应用啦 🎉

![](https://cdn-images-1.medium.com/max/4288/1*jSPXuDQnZRVwFBNqRqG_eA.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
